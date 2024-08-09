---@class NvimRos.Config: NvimRos.Opts
local M = {}

---@class NvimRos.Opts
local defaults = {
  ---@type string Format string for vim.notify messages
  notify_format = '[nvim-ros] %s',
  ---@type string Logging level (off, error, warn, info, debug, trace)
  log_level = 'warn',
}

---@type NvimRos.Opts
M.options = nil

---Path to the plugin root
---@type string
M.me = nil

---@param opts? NvimRos.Opts
function M.setup(opts)
  M.options = vim.tbl_deep_extend('force', defaults, opts or {})
  M.me = vim.fn.fnamemodify(debug.getinfo(1, 'S').source:sub(2), ':p:h:h:h')
end

return M
