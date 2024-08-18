local lib = require("auto-fix-return.lib")

local M = {
  config = {
    enable_autocmds = true,
  },
}

M.setup = function(config)
  M.config = vim.tbl_deep_extend("force", M.config, config)

  if M.config.enable_autocmds then
    lib.enable_autocmds()
  end

  lib.setup_user_commands()
end

return M
