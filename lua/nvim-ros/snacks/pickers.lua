local Logger = require('nvim-ros.logger')
local Ros = require('nvim-ros.ros')

---@class NvimRos.Snacks.Pickers
local M = {}

---@param title string
---@param ft string
---@param list_fn fun(): table?
---@param opts snacks.picker.Config?
local function make_picker(title, ft, list_fn, opts)
  local ok, snacks = pcall(require, 'snacks')
  if not ok then
    Logger:error('snacks.nvim is required for snacks pickers')
    return
  end
  snacks.picker(vim.tbl_extend('force', {
    title = title,
    finder = function()
      local items = {}
      for _, entry in ipairs(list_fn() or {}) do
        items[#items + 1] = { text = entry[1], file = entry[2] }
      end
      return items
    end,
    preview = 'file',
    previewers = { file = { ft = ft } },
  }, opts or {}))
end

---Open a picker for ROS message types.
---@param opts snacks.picker.Config?
function M.msg_picker(opts) make_picker('ROS messages', 'rosmsg', Ros.list_messages, opts) end

---Open a picker for ROS service types.
---@param opts snacks.picker.Config?
function M.srv_picker(opts) make_picker('ROS services', 'rossrv', Ros.list_services, opts) end

---Open a picker for ROS action types.
---@param opts snacks.picker.Config?
function M.action_picker(opts) make_picker('ROS actions', 'rosaction', Ros.list_actions, opts) end

return M
