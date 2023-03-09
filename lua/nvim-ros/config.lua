local M = {}

---@class NvimRosConfig
M.defaults = {
  ---@type string Format string for vim.notify messages
  notify_format = '[nvim-ros] %s',
  ---@type string Logging level (off, error, warn, info, debug, trace)
  log_level = 'warn',
}

---@class NvimRosConfig
M.options = {}

---Path to the plugin root
---@type string
M.me = nil

---@param opts? NvimRosConfig
function M.setup(opts)
  M.options = vim.tbl_deep_extend('force', M.defaults, opts or {})
  M.me = vim.fn.fnamemodify(debug.getinfo(1, 'S').source:sub(2), ':p:h:h:h')
end

return M
