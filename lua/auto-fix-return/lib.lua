local M = {}

local command_id = 0

M.setup_user_commands = function()
  vim.api.nvim_create_user_command("AutoFixReturn", function()
    M.wrap_golang_return()
  end, {})

  vim.api.nvim_create_user_command("AutoFixReturnEnable", function()
    M.enable_autocmds()
  end, {})

  vim.api.nvim_create_user_command("AutoFixReturnDisable", function()
    M.disable_autocomds()
  end, {})
end

M.enable_autocmds = function()
  command_id = vim.api.nvim_create_autocmd(
    { "TextChangedI", "TextChanged" },
    { callback = M.wrap_golang_return }
  )
end

M.disable_autocomds = function()
  vim.api.nvim_del_autocmd(command_id)
end

M.wrap_golang_return = function()
  if vim.bo.filetype ~= "go" then
    return
  end

  -- This query attempts to match all valid and also most common invalid or inprogress syntax trees for a function declaration
  -- short_var_declaration is for the edge case of named returns
  -- EXAMPLE: func foo() err error { }
  local query_str = [[
  [
      (
         ;; The default case for most method/function declarations, they are the only ones that have the named field "result" 
         ;; so we can generally rely on that to be accurate with the (ERROR) tokens preceeding or proceeding it to give us the
         ;; complete range of the intended return declaration
	       (_
		       (ERROR)? @error_start 
		       result: (_) @result 
		       (ERROR)? @error_end
         ) 
         ;; The in progress parse tree for interface method declarations places the error token
         ;; one level up in the tree
         ;; type: (interface_type ; [15, 9] - [17, 1]
         ;;   (method_elem ; [16, 2] - [16, 11]
         ;;     name: (field_identifier) ; [16, 2] - [16, 5]
         ;;     parameters: (parameter_list) ; [16, 5] - [16, 7]
         ;;     result: (type_identifier)) ; [16, 8] - [16, 11]
         ;;   (ERROR)))) ; [16, 11] - [16, 12]
         ;; We need to handle this case specifically so we anchor it to the ancestor node for interface
         (
           (ERROR)? @error_interface_end (#has-parent? @error_interface_end interface_type)
         )
      )  
      ;; This is a weird edgecase in regards to handling multi returns, an in progress multireturn on a top level function is
      ;; parsed intermediately as a short_var_declaration so we have to anchor it to the actual function declaration itself
      ;; to prevent incorrect matches on non method syntaxes E.G a for loop
      (
        (function_declaration)
        (short_var_declaration 
            left: (expression_list
                (identifier) @named_result
                (ERROR (identifier) @error_end)?
            )
        )
      )
  ]
  ]]

  local query = vim.treesitter.query.parse("go", query_str)
  local cursor_row, cursor_col = unpack(vim.api.nvim_win_get_cursor(0))

  -- We make sure to call the entire parse again to make sure we have the most up to date tree
  -- NOTE: without this the bugs are a bit nasty
  local tree = vim.treesitter.get_parser(0):parse(true)[1]

  local final_start_row, final_start_col, final_end_row, final_end_col = 0, 0, 0, 0

  for id, node, _, _ in query:iter_captures(tree:root(), 0) do
    local start_row, _, end_row, end_col = node:range()

    if cursor_row < start_row + 1 or cursor_row > end_row + 1 then
      goto continue
    end

    local capture_name = query.captures[id]

    -- If we find a start error then we know we are possibly doing a named return
    if capture_name == "error_start" then
      final_start_row, final_start_col, final_end_row, final_end_col = node:range()
    elseif capture_name == "result" and final_end_row == 0 then
      final_start_row, final_start_col, final_end_row, final_end_col = node:range()
    elseif capture_name == "named_result" then
      final_end_col = end_col + 1
      final_end_row = end_row
    elseif capture_name == "result" and final_end_row ~= 0 then
      final_end_col = end_col
      final_end_row = end_row
    elseif capture_name == "error_end" or capture_name == "error_interface_end" then
      final_end_col = end_col
      final_end_row = end_row
    end

    ::continue::
  end

  local line = vim.api.nvim_buf_get_text(
    0,
    final_start_row,
    final_start_col,
    final_end_row,
    final_end_col,
    {}
  )[1]

  if line == "" then
    return
  end

  -- Here we rebuild the entire return statement to a syntactically correct version
  -- splitting on commas to decide if there is a parameter list or a single value
  -- Strip the parens off, we will add them back if we need to
  local value = string.gsub(line, "%(", "")
  value = string.gsub(value, "%)", "")

  -- We will need to move the cursor depending on the action that we take,
  -- grab the current cusor position so we can adjust it below
  local final_cursor_col = cursor_col

  -- If there are any commas in the return definition we know we will need parenthesis
  local returns = vim.split(value, ",")

  local function trim_end(s)
    return s:gsub("%s+$", "")
  end
  -- If we do not have any commas we might still be doing a named return
  -- `E.G func foo() err e` <- once the e is typed we know a named return has been
  -- initiated and we should split it again,
  -- however, we need to trim the leading space so we dont surround the return after you have hit space with
  -- JUST a type return
  if #returns == 1 then
    local trimmed = trim_end(value)
    returns = vim.split(trimmed, " ")
  end

  local new_line = line

  -- If returns just equals one we know we have a single return and do
  -- not need parenthesis
  if #returns == 1 then
    final_cursor_col = final_cursor_col - 1
    new_line = value
  else
    final_cursor_col = final_cursor_col + 1
    new_line = "(" .. value .. ")"
  end

  -- If the line hasnt changed or theres nothing to add then we just bail out here
  if line == new_line then
    return
  end

  -- If the cursor is positioned outside of the immediate return declaration match then we do not want to touch it as this can 
  -- cause weird behavior when editing parts of a function that are unrelated to the return declaration and if there is a weird edge that triggers
  if cursor_row < final_start_row + 1 or cursor_row > final_end_row + 1 or cursor_col < final_start_col or cursor_col > final_end_col then
    return
  end

  vim.api.nvim_buf_set_text(
    0,
    final_start_row,
    final_start_col,
    final_end_row,
    final_end_col,
    { new_line }
  )

  vim.api.nvim_win_set_cursor(0, { final_end_row + 1, final_cursor_col })
end

return M
