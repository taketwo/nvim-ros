local Logger = require('nvim-ros.logger')
local ros = require('nvim-ros.ros')

local actions = require('telescope.actions')
local actions_state = require('telescope.actions.state')
local builtin = require('telescope.builtin')
local conf = require('telescope.config').values
local finders = require('telescope.finders')
local pickers = require('telescope.pickers')
local previewers = require('telescope.previewers')

local M = {}

function M.msg_picker(opts)
  opts = opts or {}
  local messages = ros.list_messages()
  pickers
    .new(opts, {
      prompt_title = 'ROS messages',
      finder = finders.new_table({
        results = messages,
        entry_maker = function(entry)
          return {
            value = entry,
            display = entry[1],
            ordinal = entry[1],
            path = entry[2],
          }
        end,
      }),
      previewer = previewers.new_buffer_previewer({
        title = 'ROS message preview',
        get_buffer_by_name = function(_, entry) return 'rosmsg/' .. tostring(entry.value[1]) end,
        define_preview = function(self, entry)
          conf.buffer_previewer_maker(entry.value[2], self.state.bufnr, {
            bufname = self.state.bufname,
            callback = function(bufnr, _) require('telescope.previewers.utils').regex_highlighter(bufnr, 'rosmsg') end,
          })
        end,
      }),
      sorter = conf.generic_sorter(opts),
    })
    :find()
end

function M.ed_picker(opts)
  opts = opts or {}
  local packages = ros.list_packages()
  pickers
    .new(opts, {
      prompt_title = 'ROS packages',
      finder = finders.new_table({
        results = packages,
        entry_maker = function(entry)
          return {
            value = entry,
            display = entry[1],
            ordinal = entry[1],
            path = entry[2],
          }
        end,
      }),
      attach_mappings = function(_, _)
        actions.select_default:replace(function()
          local selected_entry = actions_state.get_selected_entry()
          if not selected_entry then
            Logger:warn('No package entry selected')
            return
          end
          builtin.find_files({
            prompt_title = 'Find files in ROS package ' .. selected_entry.display,
            cwd = selected_entry.path,
          })
        end)
        return true
      end,
      sorter = conf.generic_sorter(opts),
    })
    :find()
end

return M
