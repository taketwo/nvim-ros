local Logger = require('nvim-ros.logger')
local ros = require('nvim-ros.ros')

local actions = require('telescope.actions')
local actions_state = require('telescope.actions.state')
local builtin = require('telescope.builtin')
local conf = require('telescope.config').values
local finders = require('telescope.finders')
local pickers = require('telescope.pickers')
local previewers = require('telescope.previewers')

local make_picker = function(opts, entries, name, type)
  opts = opts or {}
  return pickers.new(opts, {
    prompt_title = 'ROS ' .. name,
    finder = finders.new_table({
      results = entries,
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
      title = 'ROS ' .. name .. ' preview',
      get_buffer_by_name = function(_, entry) return type .. '/' .. tostring(entry.value[1]) end,
      define_preview = function(self, entry)
        conf.buffer_previewer_maker(entry.value[2], self.state.bufnr, {
          bufname = self.state.bufname,
          callback = function(bufnr, _) require('telescope.previewers.utils').regex_highlighter(bufnr, type) end,
        })
      end,
    }),
    sorter = conf.generic_sorter(opts),
  })
end

local M = {}

function M.msg_picker(opts) make_picker(opts, ros.list_messages(), 'message', 'rosmsg'):find() end

function M.srv_picker(opts) make_picker(opts, ros.list_services(), 'service', 'rossrv'):find() end

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
