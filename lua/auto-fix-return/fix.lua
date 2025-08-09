require("auto-fix-return.log")

local declaration = require("auto-fix-return.parsers.declaration")
local interface = require("auto-fix-return.parsers.interface")

local M = {}

---Validate if a given fix is syntactically valid by testing it in a scratch buffer first
---@param curr_bufnr integer
---@param parse_fix ParseFixValues
---@returns boolean
function M.validate_fix(curr_bufnr, parse_fix)
  -- Build a scratch buffer to test the fix first before we apply it to the user buffer
  local new_bufnr = vim.api.nvim_create_buf(true, true)
  vim.bo[new_bufnr].filetype = "go"
  vim.api.nvim_buf_set_lines(
    new_bufnr,
    0,
    -1,
    false,
    vim.api.nvim_buf_get_lines(curr_bufnr, 0, -1, false)
  )

  vim.api.nvim_buf_set_text(
    new_bufnr,
    parse_fix.grid.start_row,
    parse_fix.grid.start_col,
    parse_fix.grid.end_row,
    parse_fix.grid.end_col,
    { parse_fix.text_value }
  )

  -- Test if there are any ERROR tokens in the parse tree, we should not generate invalid parses
  -- TODO: We should check if the invalid parse is actually related to
  -- the return fix cursor range instead of the entire buffer
  local tree = vim.treesitter.get_parser(new_bufnr):parse(false)[1]
  local error_found = tree:root():has_error()

  vim.api.nvim_buf_delete(new_bufnr, { force = true })

  return not error_found
end

---@class FixedDefinition
---@field new_line string
---@field final_cursor_col number

---Build the fixed return definition with proper parenthesis handling
---@param line string The original line text
---@param cursor_col number The current cursor column
---@return FixedDefinition
function M.build_fixed_definition(line, cursor_col)
  -- Strip the parens off, we will add them back if we need to
  local temp, count_left = string.gsub(line, "^%(", "")
  local value, count_right = string.gsub(temp, "%)$", "")

  -- In the case that we ONLY remove the one paren then it is most likely
  -- that the user is performing a backspace of the entire return on either parentheses,
  -- E.G.
  -- func Foo() (int, error)|<bs> {}
  -- ->
  -- func Foo() (int, error| {}
  -- ->
  -- func Foo() (int, error|) {}
  --
  -- in this case when we rebuild the return type and add back the removed paren we would also set the cursor
  -- back to its original position effectively removing the users ability to backspace.
  --
  -- If we detect that case mark it here and simply do not modify the cursor at the end
  local needs_cursor_moved = true
  if count_left ~= count_right then
    needs_cursor_moved = false
  end

  -- If there are any commas in the return definition we know we will need parenthesis
  -- But we need to be careful not to split on commas inside brackets (like generics)
  local returns = {}
  local current_part = ""
  local bracket_stack = {}
  
  for i = 1, #value do
    local c = value:sub(i, i)
    
    if c == "{" or c == "[" or c == "(" then
      table.insert(bracket_stack, c)
    elseif c == "}" or c == "]" or c == ")" then
      table.remove(bracket_stack)
    elseif c == "," and #bracket_stack == 0 then
      -- Only split on commas when not inside brackets
      table.insert(returns, current_part)
      current_part = ""
      goto continue
    end
    
    current_part = current_part .. c
    ::continue::
  end
  
  -- Always add the final part, even if empty (for trailing commas)
  table.insert(returns, current_part)
  
  -- Handle trailing commas - if we have empty parts, it indicates multiple returns
  local non_empty_returns = {}
  for _, ret in ipairs(returns) do
    local trimmed = ret:gsub("^%s*", ""):gsub("%s*$", "")  -- trim whitespace
    if trimmed ~= "" then
      table.insert(non_empty_returns, ret)
    end
  end
  
  -- If we had more returns than non-empty ones, it means we had trailing commas
  if #returns > #non_empty_returns then
    -- Restore comma-split behavior for trailing comma cases
    returns = vim.split(value, ",")
  else
    returns = non_empty_returns
  end

  local function trim_end(s)
    return s:gsub("%s+$", "")
  end

  -- If we do not have any commas we might still be doing a named return
  -- `E.G func foo() err e` <- once the e is typed we know a named return has been
  -- initiated and we should lex it again,
  -- however, we need to trim the leading space so we dont surround the return after you have hit space with
  -- JUST a type return
  --
  -- This section is essentially a small parser for go type decls as a declaration
  -- can have arbitrary amount of spaces which can masquarede as a named return
  if #returns == 1 then
    local trimmed = trim_end(value)

    local temp_returns = {}
    local curr_word = ""
    local bracket_stack = {}

    -- We iterate over the string and split it on spaces to build up a possible named return
    --
    -- NOTE: `chan` syntax is unique in that a single return that is a channel type DOES NOT
    -- require parenthesis, this is for all forms of channel including `chan` `<-chan` and `chan<-`
    -- NOTE: `func()` syntax is also unique in that it can contain arbitrary amounts of spaces that
    -- should not be considered a named return
    -- TODO: This should be rewritten into a more robust parser
    for i = 1, #trimmed do
      local c = trimmed:sub(i, i)

      if c == "{" or c == "[" or c == "(" then
        table.insert(bracket_stack, #bracket_stack + 1, c)
      end
      if c == "}" or c == "]" or c == ")" then
        table.remove(bracket_stack, #bracket_stack)
      end

      -- This technically does not handle a case like `func foo() chan<- int a b c` but as this will never be syntactically valid go code we can ignore it
      if
        c == " "
        and not (
          curr_word:find("^chan") ~= nil
          or curr_word:find("chan$") ~= nil
          or curr_word:find("^func")
        )
      then
        -- Peek ahead to find the next non-space character
        -- so that we can ignore whitespace in return definitions like `interface   {}`
        -- we then do a stack approach to ensure we only add a return definition if we have validated
        -- that we have gotten to the end of all bracket pairs E.G `string[ interface { } ]`
        local next_char = nil
        for j = i + 1, #trimmed do
          local peek = trimmed:sub(j, j)
          if peek ~= " " then
            next_char = peek
            break
          end
        end

        if next_char == "{" or next_char == "[" or next_char == "(" then
          table.insert(bracket_stack, #bracket_stack + 1, next_char)
        end

        -- Only split on spaces when we're not inside brackets (like [T, V] in generics)
        if #bracket_stack == 0 then
          temp_returns[#temp_returns + 1] = curr_word
          curr_word = ""
        end
      end

      curr_word = curr_word .. c
    end

    if curr_word ~= "" then
      temp_returns[#temp_returns + 1] = curr_word
    end

    returns = temp_returns
  end

  local new_line = line
  local final_cursor_col = cursor_col

  -- If returns just equals one we know we have a single return and do
  -- not need parenthesis
  -- Here we also need to possibly set the offset for the CURSOR to be placed after we do the text replacement
  if #returns == 1 then
    if needs_cursor_moved then
      final_cursor_col = final_cursor_col - 1
    end
    new_line = value
  else
    if needs_cursor_moved then
      final_cursor_col = final_cursor_col + 1
    end
    new_line = "(" .. value .. ")"
  end

  return {
    new_line = new_line,
    final_cursor_col = final_cursor_col,
  }
end

---@class ParseFixValues
---@field grid TextGrid
---@field text_value string
---@field final_cursor_column number

---@return ParseFixValues?
function M.parse_return()
  local cursor_row, cursor_col = unpack(vim.api.nvim_win_get_cursor(0))
  local return_def_coords = declaration.parse_declaration(cursor_row)

  if return_def_coords == nil then
    return_def_coords = interface.parse_interface(cursor_row)
  end

  if return_def_coords == nil then
    log("AutoFixReturn: No valid return definition found", vim.log.levels.DEBUG)
    return
  end

  if
    return_def_coords.start_row > return_def_coords.end_row
    or return_def_coords.start_col > return_def_coords.end_col
  then
    log("AutoFixReturn: Invalid return definition coordinates", vim.log.levels.DEBUG)
    return
  end

  local line = vim.api.nvim_buf_get_text(
    0,
    return_def_coords.start_row,
    return_def_coords.start_col,
    return_def_coords.end_row,
    return_def_coords.end_col,
    {}
  )[1]

  if line == "" then
    return
  end

  -- Here we rebuild the entire return statement to a syntactically correct version
  -- splitting on commas to decide if there is a parameter list or a single value
  local fixed_def = M.build_fixed_definition(line, cursor_col)

  -- If the line has not changed or theres nothing to add then we just bail out here
  if line == fixed_def.new_line then
    return
  end

  -- If the cursor is positioned outside of the immediate return declaration match then we do not want to touch it as this can
  -- cause weird behavior when editing parts of a function that are unrelated to the return declaration and if there is a weird edge that triggers
  --
  -- We offset the final column start value to avoid edgecases with regards to using 'daw' or similar on a method_declaration
  -- E.G
  --              daw
  -- func (f Foo) B|ar() int {}
  -- ->
  -- func (f Foo) () int {}
  -- This parse will break without the final_start_col offset
  if cursor_col < return_def_coords.start_col or cursor_col > return_def_coords.end_col then
    return
  end

  return {
    grid = return_def_coords,
    text_value = fixed_def.new_line,
    final_cursor_column = fixed_def.final_cursor_col,
  }
end

function M.wrap_golang_return()
  if vim.bo.filetype ~= "go" then
    return
  end

  local parse_fix = M.parse_return()
  if parse_fix == nil then
    return
  end

  local valid_fix = M.validate_fix(0, parse_fix)
  if not valid_fix then
    log("AutoFixReturn: Invalid return fix, not applying", vim.log.levels.DEBUG)
    return
  end

  vim.api.nvim_buf_set_text(
    0,
    parse_fix.grid.start_row,
    parse_fix.grid.start_col,
    parse_fix.grid.end_row,
    parse_fix.grid.end_col,
    { parse_fix.text_value }
  )

  vim.api.nvim_win_set_cursor(0, { parse_fix.grid.end_row + 1, parse_fix.final_cursor_column })
end

return M
