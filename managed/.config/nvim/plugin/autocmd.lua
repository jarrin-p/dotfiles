--- @author jarrin-p
--- @file `autocmd.lua`
-- run auto format before saving using formatprg if it's been set.
local util = require 'util'
-- vim.api.nvim_create_autocmd({ 'BufWritePre' }, { pattern = { '.*', '*' }, callback = util.file_format })

-- assumes spotlessApply is apart of gradle.build.
-- vim.api.nvim_create_autocmd({ 'BufWritePost' }, { pattern = { '*.java', '*.scala' }, command = 'silent SA' })

-- after writing to a buffer, a `Session.vim` will be created in the root of
-- a git repo if in one or in the current directory of the file.
vim.api.nvim_create_autocmd({ 'BufWritePost' }, { pattern = { '.*', '*' }, callback = util.make_session_on_git_root })

-- before writing to a buffer postspace will be cleaned.
vim.api.nvim_create_autocmd({ 'BufWritePre' }, { pattern = { '.*', '*' }, callback = util.clean_buffer_postspace })

-- create a view on save.
vim.api.nvim_create_autocmd({ 'BufWinLeave' },
    { pattern = { '.*', '*' }, command = 'if expand("%") != "" | silent! mkview | endif' })

-- load view on entering the buffer.
vim.api.nvim_create_autocmd({ 'BufWinEnter' },
    { pattern = { '.*', '*' }, command = 'if expand("%") != "" | silent! loadview | endif' })

vim.api.nvim_create_autocmd({ 'DirChanged', 'VimLeave' }, { callback = util.export_cwd })

vim.api.nvim_create_autocmd({ 'BufWinEnter' },
    { pattern = { '*.flinklog' }, command = 'runtime! after/syntax/flinklog.lua' })

vim.api.nvim_create_autocmd({ 'BufWinEnter' },
    { pattern = { '*.rangerconf' }, command = 'runtime! after/syntax/rangerconf.lua' })

vim.api.nvim_create_autocmd({ 'BufWinEnter' },
    { pattern = { '*.velocity' }, command = 'runtime! after/syntax/velocity.lua' })

vim.cmd([[augroup CursorLine
    au!
    au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
    au WinLeave * setlocal nocursorline
augroup END
]])
