local Config = require('nvim-ros.config')

local M = {}

---@param opts? NvimRosConfig
function M.setup(opts)
  Config.setup(opts)
end

return M
