local M = {}

M.remove_paragraph_tags = function(input)
    input = input:gsub('<p>', '')
    input = input:gsub('</p>', '')
    return input
end

M.preview = function(self, entry, status)
    vim.api.nvim_win_set_option(self.state.winid, "wrap", true)
    vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, { M.remove_paragraph_tags(entry.summary) })
end

M.copy_to_clipboard = function (value)
    vim.fn.setreg('+', value)
end

return M
