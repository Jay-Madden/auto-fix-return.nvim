local lib = require("auto-fix-return.lib")

local M = {}

M.setup = function(config)
  lib.setup_aucmds()
end

return M
