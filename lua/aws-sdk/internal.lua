local M = {}

M.cleanup_summary = function(input)
    input = input:gsub('<p>', '')
    input = input:gsub('</p>', '')
    input = input:gsub('\n', '')
    return input
end

M.preview = function(self, entry, status)
    vim.api.nvim_win_set_option(self.state.winid, "wrap", true)
    vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, { M.cleanup_summary(entry.summary) })
end

M.copy_to_clipboard = function (value)
    vim.fn.setreg('+', value)
end

return M
