local Config = require('nvim-ros.config')
local Logger = require('nvim-ros.logger')

---@class NvimRos
local M = {}

---@param opts? NvimRos.Opts
function M.setup(opts)
  Config.setup(opts)
  local has_telescope, telescope = pcall(require, 'telescope')
  if has_telescope then
    Logger:debug('Telescope found, loading extension')
    telescope.load_extension('ros')
  end
  local has_snacks = pcall(require, 'snacks')
  if has_snacks then Logger:debug('Snacks found, snacks pickers will be available') end
  local has_blink = pcall(require, 'blink.cmp')
  if has_blink then Logger:debug('Blink found, blink completion source will be available') end
  Logger:debug('Plugin setup completed')
end

return M
