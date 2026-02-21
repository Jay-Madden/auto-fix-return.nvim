require("auto-fix-return.log")

local fix = require("auto-fix-return.fix")

local M = {}

local command_id = 0
local registered_ts_cbs_bufs = {}

M.TESTED_PARSER_REVS =
  { "5e73f476efafe5c768eda19bbe877f188ded6144", "2346a3ab1bb3857b48b29d779a1ef9799a248cd7" }

local last_changenr = 0

-- Optionally load a module and return nil if it fails, or the module if it succeeds.
---@return any|nil
function prequire(m)
  local ok, mod = pcall(require, m)
  if not ok then
    return nil
  end
  return mod
end

---If possible pull the installed TreeSitter parser version from 'nvim-treesitter'
---nvim-treesitter has recently done a complete rewrite and moved from the 'master' branch to the 'main' branch
---during this transition we try to get the parser versions from both versions of nvim-treesitter
---@return string|nil
function M.get_parser_version()
  local parser_rev = nil

  -- Try to get the parser version from the 'main' branch of nvim-treesitter first
  local parsers = prequire("nvim-treesitter.parsers")
  if parsers ~= nil then
    local configs = type(parsers.get_parser_configs) == "function" and parsers.get_parser_configs() or parsers
    if configs == nil then
      log("AutoFixReturn: failed to load nvim-treesitter.parsers", vim.log.levels.DEBUG)
      return nil
    end
    local go_config = configs["go"]
    if go_config == nil or go_config.install_info == nil then
      log(
        "AutoFixReturn: nvim-treesitter found but Go parser not installed, run :TSInstall go",
        vim.log.levels.WARN
      )
      return nil
    end
    parser_rev = go_config.install_info.revision
  end

  -- If that fails try to get the parser version from the 'master' branch of nvim-treesitter
  local ts_master_config = prequire("nvim-treesitter.configs")
  if ts_master_config ~= nil then
    local info_dir = ts_master_config.get_parser_info_dir()
    if info_dir == nil then
      log(
        "AutoFixReturn: failed to get nvim-treesitter parser info directory",
        vim.log.levels.DEBUG
      )
      return nil
    end

    local rev_file = io.open(info_dir .. "/go.revision")
    if rev_file == nil then
      return nil
    end

    local rev = rev_file:read("*a")
    local value = string.gsub(rev, '"', "")
    parser_rev = string.gsub(value, "\n", "")
  end

  return parser_rev
end

function M.setup_user_commands()
  vim.api.nvim_create_user_command("AutoFixReturn", function(opts)
    if #opts.fargs == 0 then
      fix.wrap_golang_return()
    elseif opts.fargs[1] == "enable" then
      M.enable_tree_cbs()
      log("AutoFixReturn: Enabled on all buffers", vim.log.levels.INFO)
    elseif opts.fargs[1] == "disable" then
      M.disable_ts_cbs()
      log("AutoFixReturn: Disabled on all buffers", vim.log.levels.INFO)
    end
  end, {
    nargs = "?",
    complete = function()
      return { "enable", "disable" }
    end,
  })
end

function M.enable_tree_cbs()
  for bufnr, _ in pairs(registered_ts_cbs_bufs) do
    registered_ts_cbs_bufs[bufnr] = true
  end

  -- Register callbacks on current Go buffers that aren't registered yet
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(bufnr) and registered_ts_cbs_bufs[bufnr] == nil then
      if vim.bo[bufnr].filetype == "go" then
        M.register_buf_cbs(bufnr)
        registered_ts_cbs_bufs[bufnr] = true
      end
    end
  end

  if command_id ~= 0 then
    return
  end

  -- Register the autocmd to handle buffer read events that attach ts callbacks to the buffers parser
  command_id = vim.api.nvim_create_autocmd({ "BufReadPost" }, { callback = M.register_buf_handler })
end

function M.register_buf_handler(event)
  local bufnr = event.buf
  M.register_buf_cbs(bufnr)
  registered_ts_cbs_bufs[bufnr] = true
end

function M.register_buf_cbs(bufnr)
  if vim.bo[bufnr].filetype ~= "go" then
    return
  end

  -- We should warn the users if they are using a parser version we do not know about
  -- but only once on the initial go buffer attach otherwise it is annoying
  local rev = M.get_parser_version()
  if rev ~= nil and not vim.tbl_contains(M.TESTED_PARSER_REVS, rev) then
    log_once(
      "AutoFixReturn: Current Go treesitter parser version '"
        .. rev
        .. "' is not tested with this plugin.\n"
        .. "If you encounter issues please upgrade your Go Treesitter parser to one of the tested versions '"
        .. vim.inspect(M.TESTED_PARSER_REVS)
        .. "'",
      vim.log.levels.WARN
    )
  elseif rev ~= nil then
    log_once("AutoFixReturn: Unable to find current Go treesitter version'", vim.log.levels.DEBUG)
  end

  local tree = vim.treesitter.get_parser(bufnr)

  if tree == nil then
    return
  end

  -- We can not modify the tree in the on_changedtree callback
  -- so we use a flag to prevent re-entrancy and dispatch the
  -- auto fix via schedule
  local processing = false
  tree:register_cbs({
    on_changedtree = function()
      if not registered_ts_cbs_bufs[bufnr] then
        return
      end
      if processing then
        return
      end

      -- If we detect an undo then bail out so we do not
      -- cause a infinite loop of the plugin constantly immediately reapplying its own changes
      local curr_changenr = vim.fn.changenr()
      if curr_changenr < last_changenr then
        last_changenr = curr_changenr
        return
      end

      processing = true
      vim.schedule(function()
        fix.wrap_golang_return()
        last_changenr = curr_changenr
        processing = false
      end)
    end,
  }, false)
end

function M.disable_buf_ts_cbs()
  for bufnr, _ in pairs(registered_ts_cbs_bufs) do
    registered_ts_cbs_bufs[bufnr] = false
  end
end

function M.disable_ts_cbs()
  if command_id == 0 then
    return
  end

  vim.api.nvim_del_autocmd(command_id)
  command_id = 0

  M.disable_buf_ts_cbs()
end

return M
