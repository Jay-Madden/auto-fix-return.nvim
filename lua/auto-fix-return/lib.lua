local M = {}

M.setup_autocmds = function()
  vim.api.nvim_create_autocmd(
    -- { "InsertLeave", "TextChanged" },
    { "TextChangedI", "TextChanged" },
    { callback = M.wrap_golang_return }
  )
end

M.wrap_golang_return = function()
  if vim.bo.filetype ~= "go" then
    return
  end

  local query_str = [[
    (_
       result: (_) @result 
       (ERROR)? @error 
    ) 
  ]]

  local query = vim.treesitter.query.parse("go", query_str)
  local cursor_row, cursor_col = unpack(vim.api.nvim_win_get_cursor(0))

  local tree = vim.treesitter.get_node():tree()

  local final_start_row, final_start_col, final_end_row, final_end_col = 0, 0, 0, 0

  for id, node, _, _ in query:iter_captures(tree:root(), 0) do
    local start_row, _, end_row, end_col = node:range()

    if cursor_row < start_row + 1 or cursor_row > end_row + 1 then
      goto continue
    end

    local capture_name = query.captures[id]
    if capture_name == "result" then
      final_start_row, final_start_col, final_end_row, final_end_col = node:range()
    end
    if capture_name == "error" then
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

  local returns = vim.split(value, ",")
  local new_line = line
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
