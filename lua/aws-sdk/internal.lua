local curl = require("plenary.curl")
local constants = require("aws-sdk.constants")

local M = {}

M.trim = function(s)
	return s:match("^%s*(.*%S)") or ""
end

M.cleanup = function(input)
	input = M.trim(input:gsub("<([^<>]*)>", ""))
	input = vim.split(input, "\n")
	return input
end

M.preview = function(self, entry, status)
	vim.api.nvim_win_set_option(self.state.winid, "wrap", true)
	vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, M.cleanup(entry.summary))
end

M.copy_to_clipboard = function(value)
	vim.fn.setreg("+", value)
end

M.get_command_example = function(client, command)
	local response = curl.get(constants.command_url .. client .. "/command/" .. command)
	local extracted_json = (response.body):gsub('(.-)<script id="__NEXT_DATA__" type="application/json">', "")
	extracted_json = extracted_json:gsub("</script>(.*)", "")
	local json = vim.fn.json_decode(extracted_json)
	local example = json.props.pageProps.command.otherBlocks.example[1].code
	return M.cleanup(example)
end

M.open_new_tab_with_content = function(contents, tab_name)
	-- Create a new tab
	vim.api.nvim_command("tabnew")

	-- Get the current buffer number in the new tab
	local bufnr = vim.api.nvim_get_current_buf()

	-- Set content in the new tab's buffer
	vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, contents)

    -- Mark the buffer as unmodifiable (no changes allowed)
    vim.api.nvim_buf_set_option(bufnr, 'modifiable', false)

    vim.api.nvim_command('tabdo tabname ' .. tab_name)

	-- Return to normal mode in the new tab
	vim.api.nvim_command("normal! gg")
end

return M
