local _log_level = vim.log.levels.INFO

--- Set the log level for the AutoFixReturn module
---@param level integer
function set_log_level(level)
  _log_level = level
end

---@param message string
---@param level integer
function log(message, level)
  if level >= _log_level then
    vim.notify(message, level)
  end
end

---@param message string
---@param level integer
function log_once(message, level)
  if level >= _log_level then
    vim.notify_once(message, level)
  end
end
