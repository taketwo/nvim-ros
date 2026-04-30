local Logger = require('nvim-ros.logger')
local Ros = require('nvim-ros.ros')

---@class NvimRos.Blink
local M = {}

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

---@type lsp.CompletionItem[]?
local cache = nil

---Build and store the completion item cache.
local function build_cache()
  if cache ~= nil then return end
  Logger:debug('ROS message cache does not exist, creating it')
  local items = {}
  for _, entry in ipairs(Ros.list_messages() or {}) do
    table.insert(items, {
      label = entry[1],
      kind = vim.lsp.protocol.CompletionItemKind.Struct,
    })
  end
  for _, name in ipairs(builtin_types) do
    table.insert(items, {
      label = name,
      kind = vim.lsp.protocol.CompletionItemKind.Struct,
    })
  end
  cache = items
end

---Register a FileType autocmd to pre-warm the cache when a ROS filetype is first opened.
function M.setup()
  vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'rosmsg', 'rossrv', 'rosaction' },
    once = true,
    callback = function() vim.schedule(build_cache) end,
  })
end

---Create a new instance of the blink.cmp source.
---@return NvimRos.Blink
function M.new() return setmetatable({}, { __index = M }) end

---Enable the source only for ROS definition filetypes.
---@return boolean
function M:enabled()
  local ft = vim.bo.filetype
  return ft == 'rosmsg' or ft == 'rossrv' or ft == 'rosaction'
end

---Return completions for ROS message types and builtin primitive types.
---@param ctx table blink.cmp context
---@param callback fun(response: { items: lsp.CompletionItem[], is_incomplete_forward: boolean, is_incomplete_backward: boolean })
function M:get_completions(ctx, callback)
  -- Only complete at the type position (first word on the line)
  local before_cursor = ctx.line:sub(1, ctx.cursor[2])
  if before_cursor:gsub('^%s+', ''):find('%s') then
    callback({ items = {}, is_incomplete_forward = true, is_incomplete_backward = true })
    return
  end
  build_cache()
  callback({ items = cache, is_incomplete_forward = false, is_incomplete_backward = false })
end

return M
