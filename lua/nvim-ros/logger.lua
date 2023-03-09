-- Based on logger implementation from Null-ls
--   https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/lua/null-ls/logger.lua

local Config = require('nvim-ros.config')

local default_notify_opts = {
  title = 'nvim-ros',
}

local logger = {}

function logger:add_entry(msg, level)
  if not self.__notify_fmt then
    self.__notify_fmt = function(m) return string.format(Config.options.notify_format, m) end
  end

  if Config.options.log_level == 'off' then return end

  if self.__handle then
    self.__handle[level](msg)
    return
  end

  local default_opts = {
    plugin = 'nvim-ros',
    level = Config.options.log_level or 'warn',
    use_console = false,
    info_level = 4,
  }

  local has_plenary, plenary_log = pcall(require, 'plenary.log')
  if not has_plenary then return end

  local handle = plenary_log.new(default_opts)
  handle[level](msg)
  self.__handle = handle
end

---Get path to the log file
---@return string
function logger:get_path() return vim.fn.stdpath('cache') .. '/nvim-ros.log' end

---Add a log entry at TRACE level
---@param msg any
function logger:trace(msg) self:add_entry(msg, 'trace') end

---Add a log entry at DEBUG level
---@param msg any
function logger:debug(msg) self:add_entry(msg, 'debug') end

---Add a log entry at INFO level
---@param msg any
function logger:info(msg) self:add_entry(msg, 'info') end

---Add a log entry at WARN level and display a notification
---@param msg any
function logger:warn(msg)
  self:add_entry(msg, 'warn')
  vim.notify(self.__notify_fmt(msg), vim.log.levels.WARN, default_notify_opts)
end

---Add a log entry at ERROR level and display a notification
---@param msg any
function logger:error(msg)
  self:add_entry(msg, 'error')
  vim.notify(self.__notify_fmt(msg), vim.log.levels.ERROR, default_notify_opts)
end

setmetatable({}, logger)

return logger
