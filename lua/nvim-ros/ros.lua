local Config = require('nvim-ros.config')
local Logger = require('nvim-ros.logger')

local M = {}

---Path to the python directory of this plugin.
---@type string?
local python_path = nil

---Call a Python function from nvim_ros module.
---@param fname string Name of the function to call.
---@return table?
function M._call(fname)
  if python_path == nil then
    python_path = Config.me .. '/python'
    Logger:debug('Adding ' .. python_path .. ' directory to Python sys.path')
    vim.fn.py3eval('sys.path.insert(0, "' .. python_path .. '")')
  end
  local expr = '__import__("nvim_ros").' .. fname .. '()'
  Logger:debug('Evaluating Python expression `' .. expr .. '`')
  return vim.fn.py3eval(expr)
end

---Get a list of ROS messages.
---@return table? List of { name, path } pairs.
function M.list_messages() return M._call('list_messages') end

---Get a list of ROS services.
---@return table? List of { name, path } pairs.
function M.list_services() return M._call('list_services') end

---Get a list of ROS packages.
---@return table List of { name, path } pairs.
function M.list_packages()
  local packages = {}
  Logger:debug('Calling `rospack list` to get a list of packages')
  local lines = vim.fn.systemlist('rospack list')
  for _, line in ipairs(lines) do
    local name, path = line:match('^(%S+)%s+(%S+)$')
    if name and path then table.insert(packages, { name, path }) end
  end
  Logger:debug('Parsed ' .. #packages .. ' packages')
  return packages
end

return M
