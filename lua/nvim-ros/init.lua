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
  local has_cmp, cmp = pcall(require, 'cmp')
  if has_cmp then
    Logger:debug('Cmp found, registering completion sources')
    cmp.register_source('rosmsg', require('nvim-ros.cmp.sources').rosmsg.new())
  end
  Logger:debug('Plugin setup completed')
end

return M
