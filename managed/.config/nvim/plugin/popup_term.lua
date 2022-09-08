-- @see :h api-floatwin
function FloatingTerm()
    local buffer_handle = vim.api.nvim_create_buf(true, true)
    vim.api.nvim_open_win(buffer_handle, true, { relative = 'win', row = 3, col = 3, width = 100, height = 10 })
    vim.cmd('term')
end
