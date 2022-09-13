--- @see :h api-floatwin
require 'math'
function FloatingTerm()
    -- get window dimensions for better formatting.
    local win_width = vim.api.nvim_win_get_width(0)
    local win_height = vim.api.nvim_win_get_height(0)

    -- create new scratch buffer.
    local buffer_handle = vim.api.nvim_create_buf(true, true)
    vim.cmd('setlocal winhl=NormalFloat:NormalPopupTerm,FloatBorder:BorderPopupTerm')

    local padding = 1

    vim.api.nvim_open_win(buffer_handle, true, {
        relative = 'win',
        row = padding,
        col = win_width - padding,
        width = math.floor(win_width / 2),
        height = win_height - 2 * (padding + 1),
        anchor = 'NE',
        border = 'single',
    })
    vim.cmd('term')
    vim.cmd('startinsert')
end

function ShowDiagnostics()
    -- get the diagnostics at the current position.
    local diagnostics = vim.lsp.diagnostic.get_line_diagnostics()

    -- get window dimensions for better formatting.
    local win_width = vim.api.nvim_win_get_width(0)
    local win_height = vim.api.nvim_win_get_height(0)

    -- create new scratch buffer.
    local buffer_handle = vim.api.nvim_create_buf(true, true)
    vim.cmd('set winhl=NormalFloat:NormalPopupTerm,FloatBorder:BorderPopupTerm')

    local padding = 1

    -- create window, do not steal focus.
    vim.api.nvim_open_win(buffer_handle, false, {
        relative = 'win',
        row = padding,
        col = win_width - padding,
        width = math.floor(win_width / 2),
        height = win_height - 2 * (padding + 1),
        anchor = 'NE',
        border = 'single',
    })
end
