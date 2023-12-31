local M = {}

local pickers = require("telescope.pickers")
local previewers = require("telescope.previewers")
local finders = require("telescope.finders")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local conf = require("telescope.config").values

local curl = require("plenary.curl")

local internal = require("aws-sdk.internal")
local constants = require("aws-sdk.constants")

M.initial_search = function(opts, search_list, callback)
	opts = opts or {}
	opts["aws-sdk"] = {}

	pickers
		.new(opts, {
			prompt_title = "Packages",
			finder = finders.new_table({
				results = search_list,
			}),
			sorter = conf.generic_sorter(opts),
			attach_mappings = function(prompt_bufnr, map)
				actions.select_default:replace(function()
					actions.close(prompt_bufnr)
					local selection = action_state.get_selected_entry()
					opts["aws-sdk"].client = selection[1]
					callback(opts)
				end)
				return true
			end,
		})
		:find()
end

M.operations = function(opts)
	local client = opts["aws-sdk"].client

	local response = curl.get(constants.preview_url .. client .. constants.preview_options .. client)
	local operations = vim.fn.json_decode(response.body).pageProps.operations

	local last_command_picked = ""

	opts = opts or {}
	pickers
		.new(opts, {
			prompt_title = "Operations",
			finder = finders.new_table({
				results = operations,
				entry_maker = function(entry)
					return {
						value = constants.doc_url .. client .. "/command/" .. entry.name,
						display = entry.name,
						ordinal = entry.name,
						summary = entry.summary,
					}
				end,
			}),
			previewer = previewers.new_buffer_previewer({
				title = "Command Summary",
				define_preview = internal.preview,
			}),
			sorter = conf.generic_sorter(opts),
			attach_mappings = function(prompt_bufnr, map)
				actions.select_default:replace(function()
					local selection = action_state.get_selected_entry()
					local command = selection.display

					actions.close(prompt_bufnr)
					internal.copy_to_clipboard(selection.value)
					vim.notify(selection.display .. " documentation url added to clipboard")

					--if command == last_command_picked then
					--actions.close(prompt_bufnr)
					--internal.copy_to_clipboard(selection.value)
					--vim.notify(selection.display .. " documentation url added to clipboard")
					--else
					--last_command_picked = command
					--local example = internal.get_command_example(client, selection.display)
					--local previewer = action_state.get_current_picker(prompt_bufnr).previewer
					--vim.api.nvim_buf_set_lines(previewer.state.bufnr, 0, -1, false, example)
					--end
				end)
				return true
			end,
		})
		:find()
end

return M
