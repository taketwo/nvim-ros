local pickers = require('nvim-ros.telescope.pickers')

return require('telescope').register_extension({
  exports = {
    msg = pickers.msg_picker,
    srv = pickers.srv_picker,
    action = pickers.action_picker,
    ed = pickers.ed_picker,
  },
})
