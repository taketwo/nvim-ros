local Config = require('nvim-ros.config')
local Logger = require('nvim-ros.logger')

local M = {}

---Path to the python directory of this plugin.
---@type string?
local python_path = nil

---Call a Python function from nvim_ros module.
---@param fname string Name of the function to call.
---@return table
function M._call(fname)
  if python_path == nil then
    python_path = Config.me .. '/python'
    Logger:debug('Adding ' .. python_path .. ' directory to Python sys.path')
    vim.fn.py3eval('sys.path.insert(0, "' .. python_path .. '")')
  end
  local expr = '__import__("nvim_ros").' .. fname .. '()'
  Logger:debug('Evaluating Python expression: ' .. expr)
  return vim.fn.py3eval(expr)
end

---Get the list of ROS messages.
---@return table
function M.list_messages() return M._call('list_messages') end

return M
