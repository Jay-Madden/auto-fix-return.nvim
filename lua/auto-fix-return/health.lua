local M = {}

function M.check()
  vim.health.start("auto-fix-return: Go TreeSitter Parser")

  local has_parser = pcall(function()
    return vim.treesitter.language.inspect("go")
  end)

  if has_parser then
    vim.health.ok("Go TreeSitter parser found")
  else
    vim.health.error("Go TreeSitter parser not found", {
      "Install the Go parser using nvim-treesitter: :TSInstall go",
      "Or manually add a Go parser to your Neovim runtime path",
    })
    return
  end

  vim.health.start("auto-fix-return: Parser Version")

  local lib = require("auto-fix-return.lib")
  if not lib then
    vim.health.info("Could not load auto-fix-return.lib to check parser version")
    return
  end

  local parser_rev = lib.get_parser_version()
  if parser_rev == nil then
    vim.health.info("Unable to determine Go parser revision (nvim-treesitter may not be installed)")
    return
  end

  if vim.tbl_contains(lib.TESTED_PARSER_REVS, parser_rev) then
    vim.health.ok("Go parser revision " .. parser_rev .. " is compatible")
  else
    vim.health.warn("Go parser revision " .. parser_rev .. " is not in the tested revisions list", {
      "Tested revisions: " .. table.concat(lib.TESTED_PARSER_REVS, ", "),
      "The plugin may still work, but has not been tested with this parser version",
    })
  end
end

return M
