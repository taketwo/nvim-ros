local Logger = require('nvim-ros.logger')
local ros = require('nvim-ros.ros')

local cmp = require('cmp')

local M = {}

M.rosmsg = {}
M.rosmsg.new = function()
  local self = setmetatable({ cache = {} }, { __index = M.rosmsg })
  return self
end

M.rosmsg.complete = function(self, _, callback)
  if #self.cache == 0 then
    Logger:debug('ROS message cache does not exist, creating it')
    local messages = ros.list_messages()
    local items = {}
    for _, entry in ipairs(messages) do
      table.insert(items, {
        label = entry[1],
        kind = cmp.lsp.CompletionItemKind.Struct,
        documentation = {},
      })
    end
    local builtin_types = {
      'bool',
      'int8',
      'uint8',
      'int16',
      'uint16',
      'int32',
      'uint32',
      'int64',
      'uint64',
      'float32',
      'float64',
      'string',
      'time',
      'duration',
      'Header',
    }
    for _, entry in ipairs(builtin_types) do
      table.insert(items, {
        label = entry,
        kind = cmp.lsp.CompletionItemKind.Struct,
        documentation = {},
      })
    end
    self.cache = items
  end
  callback({ items = self.cache, isIncomplete = false })
end

M.rosmsg.get_debug_name = function() return 'ROS message types' end

M.rosmsg.is_available = function()
  return vim.bo.filetype == 'rosmsg' or vim.bo.filetype == 'rossrv' or vim.bo.filetype == 'rosaction'
end

return M
