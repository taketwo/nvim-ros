local Config = require('nvim-ros.config')
local Logger = require('nvim-ros.logger')

local M = {}

---@param opts? NvimRosConfig
function M.setup(opts)
  Config.setup(opts)
  Logger:debug('Plugin setup completed')
end

return M
