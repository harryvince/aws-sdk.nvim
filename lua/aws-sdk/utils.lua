local M = {}

local pickers = require('telescope.pickers')
local previewers = require('telescope.previewers')
local finders = require('telescope.finders')
local conf = require('telescope.config').values

local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')

local curl = require('plenary.curl')

local packages = require('aws-sdk.packages')

local removePtags = function(input)
    input = input:gsub("<p>", "")
    input = input:gsub("</p>", "")
    return input
end

M.packages = function(opts)
    opts = opts or {}
    pickers.new(opts, {
        prompt_title = "Packages",
        finder = finders.new_table {
            results = packages
        },
        sorter = conf.generic_sorter(opts),
        attach_mappings = function(prompt_bufnr, map)
            actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                print(selection[1])
                M.operations(selection[1], opts)
            end)
            return true
        end,
    }):find()
end

M.operations = function(client, opts)
    local response = curl.get(
        'https://docs.aws.amazon.com/AWSJavaScriptSDK/v3/latest/_next/data/preview/client/' ..
        client .. '.json?client=' .. client)
    local operations = vim.fn.json_decode(response.body).pageProps.operations

    opts = opts or {}
    pickers.new(opts, {
        prompt_title = "Operations",
        finder = finders.new_table {
            results = operations,
            entry_maker = function(entry)
                return {
                    value = 'https://docs.aws.amazon.com/AWSJavaScriptSDK/v3/latest/client/' ..
                        client .. '/command/' .. entry.name,
                    display = entry.name,
                    ordinal = entry.name,
                    summary = entry.summary
                }
            end,
        },
        previewer = previewers.new_buffer_previewer({
            title = "Command Summary",
            define_preview = function(self, entry, status)
                vim.api.nvim_win_set_option(self.state.winid, "wrap", true)
                vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, { removePtags(entry.summary) })
            end
        }),
        sorter = conf.generic_sorter(opts),
        attach_mappings = function(prompt_bufnr, map)
            actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                vim.fn.setreg('+', selection.value)
                vim.notify(selection.display .. ' documenatation url added to clipboard')
            end)
            return true
        end,
    }):find()
end

return M
