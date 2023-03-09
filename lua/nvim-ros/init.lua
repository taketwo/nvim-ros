local Config = require('nvim-ros.config')
local Logger = require('nvim-ros.logger')

local M = {}

---@param opts? NvimRosConfig
function M.setup(opts)
  Config.setup(opts)
  local has_telescope, telescope = pcall(require, 'telescope')
  if has_telescope then
    Logger:debug('Telescope found, loading extension')
    telescope.load_extension('ros')
  end
  Logger:debug('Plugin setup completed')
end

return M
