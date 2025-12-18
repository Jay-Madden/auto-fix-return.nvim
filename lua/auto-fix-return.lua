require("auto-fix-return.log")

local lib = require("auto-fix-return.lib")

local M = {}

---@class AutoFixReturnConfigInternal
---@field enabled boolean
---@field log_level integer

---@return AutoFixReturnConfigInternal
function M.get_default_config()
  local config = {
    enabled = true,
    log_level = vim.log.levels.INFO,
  }

  return config
end

---If possible pull the installed TreeSitter parser version from 'nvim-treesitter'
---returns nil if not found
---@return string|nil
function M.get_parser_version()
  return lib.get_parser_version()
end

---@class AutoFixReturnConfig
---@field enabled boolean|nil
---@field log_level integer|nil

---@param config AutoFixReturnConfig
function M.setup(config)
  local default_config = M.get_default_config()
  local final_config = vim.tbl_deep_extend("force", default_config, config)

  set_log_level(final_config.log_level)

  if final_config.enabled then
    lib.enable_tree_cbs()
  end

  lib.setup_user_commands()
end

return M
