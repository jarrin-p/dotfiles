--- @author jarrin-p
--- @file `autocmd.lua`
-- run auto format before saving using formatprg if it's been set.
vim.api.nvim_create_autocmd({ 'BufWritePre' }, { pattern = { '.*', '*' }, callback = FF })

-- assumes spotlessApply is apart of gradle.build.
vim.api.nvim_create_autocmd({ 'BufWritePost' }, { pattern = { '*.java', '*.scala' }, command = 'silent SA' })

-- after writing to a buffer, a `Session.vim` will be created in the root of
-- a git repo if in one or in the current directory of the file.
vim.api.nvim_create_autocmd({ 'BufWritePost' }, { pattern = { '.*', '*' }, callback = MakeGitSession })

-- before writing to a buffer postspace will be cleaned.
vim.api.nvim_create_autocmd({ 'BufWritePre' }, { pattern = { '.*', '*' }, callback = CleanBufferPostSpace })

-- create a view on save.
vim.api.nvim_create_autocmd({ 'BufWinLeave' },
    { pattern = { '.*', '*' }, command = 'if expand("%") != "" | silent! mkview | endif' })

-- load view on entering the buffer.
vim.api.nvim_create_autocmd({ 'BufWinEnter' },
    { pattern = { '.*', '*' }, command = 'if expand("%") != "" | silent! loadview | endif' })

vim.api.nvim_create_autocmd({ 'DirChanged', 'VimLeave' }, { callback = ExportCwd })
