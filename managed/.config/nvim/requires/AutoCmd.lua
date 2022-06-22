-- nerdtree will always have relative number set
vim.api.nvim_create_autocmd({'FileType'}, { pattern='nerdtree', command = "set number relativenumber" })

-- open nerdtree as soon as vim opens. make it full screen if no other buffer is open
function OpeningBehavior()
    if vim.fn.line('$') == 1
        and vim.fn.getline(1) == ''
        and vim.api.nvim_get_option_value('filetype', {}) == '' then
            vim.api.nvim_command('NERDTreeToggleVCS | only')
            vim.api.nvim_command('FZF')
    else
        vim.api.nvim_command('NERDTreeToggleVCS')
        vim.api.nvim_command('wincmd p')
    end
end
vim.api.nvim_create_autocmd({'VimEnter'}, { callback = OpeningBehavior })

-- match settings from other projects for these filetypes
vim.api.nvim_create_autocmd({'FileType'}, { pattern = {'java', 'terraform'}, command = 'set tabstop=2' })
vim.api.nvim_create_autocmd({'FileType'}, { pattern = {'qf'}, command = 'wincmd L | vert res 80' })

-- custom spotlessApply command (SA) that runs at top of git level.
-- assumes java is using gradle with SA ipmlemented.
vim.api.nvim_create_autocmd({'BufWritePost'}, { pattern = {'*.java'}, command = 'silent SA' })
vim.api.nvim_create_autocmd({'BufWritePost'}, { pattern = {'*.tf'}, command = 'silent TFF' })
