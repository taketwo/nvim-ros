local M = {}

---@class NvimRosConfig
M.defaults = {
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
