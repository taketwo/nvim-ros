local Logger = require('nvim-ros.logger')
local Ros = require('nvim-ros.ros')

local ok, Snacks = pcall(require, 'snacks') ---@type boolean, Snacks?
if not ok then Snacks = nil end

---@class NvimRos.Snacks.Pickers
local M = {}

---@param title string
---@param ft string
---@param list_fn fun(): table?
---@param opts snacks.picker.Config?
local function make_picker(title, ft, list_fn, opts)
  if not Snacks then
    Logger:error('snacks.nvim is required for snacks pickers')
    return
  end
  Snacks.picker(vim.tbl_extend('force', {
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

---Open a picker for files from ROS packages.
---@param opts snacks.picker.Config?
function M.file_picker(opts)
  if not Snacks then
    Logger:error('snacks.nvim is required for snacks pickers')
    return
  end
  Snacks.picker(vim.tbl_extend('force', {
    title = 'ROS packages',
    format = 'text',
    layout = { preview = false },
    finder = function()
      local items = {}
      for _, entry in ipairs(Ros.list_packages()) do
        items[#items + 1] = { text = entry[1], dir = entry[2] }
      end
      return items
    end,
    confirm = function(picker, item)
      picker:close()
      if item then
        Snacks.picker.files({
          cwd = item.dir,
          transform = function(i)
            if i.cwd and i.file then
              i.file = vim.fs.joinpath(i.cwd, i.file)
              i.cwd = nil
            end
          end,
        })
      end
    end,
  }, opts or {}))
end

return M
