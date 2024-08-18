local lib = require("auto-fix-return.lib")

local M = {}

M.setup = function(config)
  lib.setup_autocmds()
  lib.setup_user_commands()
end

return M
