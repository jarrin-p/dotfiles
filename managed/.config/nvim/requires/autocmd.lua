--- @author jarrin-p
--- @file `autocmd.lua`
-- nerdtree will always have relative number set
vim.api.nvim_create_autocmd(
    { 'FileType' },
        { pattern = 'nerdtree', command = 'set number relativenumber' }
)

-- git commit flood prevention.
vim.api.nvim_create_autocmd(
    { 'FileType' }, { pattern = { 'gitcommit' }, command = '' }
)

-- run auto format before saving using formatprg if it's been set.
vim.api.nvim_create_autocmd(
    { 'BufWritePre' }, { pattern = { '.*', '*' }, callback = FF }
)

-- match settings from other projects for these filetypes
-- TODO add filetype specific loads (e.g. make a `.../nvim/after/plugin/...` directory)
vim.api.nvim_create_autocmd(
    { 'FileType' },
        { pattern = { 'java', 'terraform' }, command = 'set tabstop=2' }
)

-- java format.
-- assumes java is using gradle with SA implemented.
vim.api.nvim_create_autocmd(
    { 'FileType' }, {
        pattern = { 'java' },
        command = MakeFormatPrgText {
            'gradle', 'spotlessApply', '-PspotlessIdeHookUseStdIn',
            '-PspotlessIdeHookUseStdOut', '-PspotlessIdeHook=%',
        },
    }
)

-- terraform format.
vim.api.nvim_create_autocmd(
    { 'FileType' }, {
        pattern = { 'terraform' },
        command = MakeFormatPrgText { 'terraform', 'fmt', '-' },
    }
)

-- python format.
vim.api.nvim_create_autocmd(
    { 'FileType' },
        { pattern = { 'py' },
        command = MakeFormatPrgText { 'black', '-q', '-' } }
)

-- lua format.
vim.api.nvim_create_autocmd(
    { 'FileType' }, {
        pattern = { 'lua' },
        command = MakeFormatPrgText { 'lua-format', '-c', '$HOME/.luaformat' },
    }
)

-- after writing to a buffer, a `Session.vim` will be created in the root of
-- a git repo if in one or in the current directory of the file.
vim.api.nvim_create_autocmd(
    { 'BufWritePost' }, { pattern = { '.*', '*' }, callback = MakeGitSession }
)

-- before writing to a buffer postspace will be cleaned.
vim.api.nvim_create_autocmd(
    { 'BufWritePre' },
        { pattern = { '.*', '*' }, callback = CleanBufferPostSpace }
)

-- create a view on save.
vim.api.nvim_create_autocmd(
    { 'BufWinLeave' }, {
        pattern = { '.*', '*' },
        command = 'if expand("%") != "" | silent! mkview | endif',
    }
)

-- load view on entering the buffer.
vim.api.nvim_create_autocmd(
    { 'BufWinEnter' }, {
        pattern = { '.*', '*' },
        command = 'if expand("%") != "" | silent! loadview | endif',
    }
)
