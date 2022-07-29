-- nerdtree will always have relative number set
vim.api.nvim_create_autocmd(
    { 'FileType' },
        { pattern = 'nerdtree', command = 'set number relativenumber' }
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
-- holding until confirmation format works.
-- vim.api.nvim_create_autocmd(
--     { 'BufWritePost' }, { pattern = { '*.java' }, command = 'silent SA' }
-- )

-- terraform format.
vim.api.nvim_create_autocmd(
    { 'FileType' }, {
        pattern = { 'terraform' },
        command = MakeFormatPrgText { 'terraform', 'fmt', '-' },
    }
)
vim.api.nvim_create_autocmd(
    { 'BufWritePost' }, { pattern = { '.*', '*' }, callback = FF }
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

vim.api.nvim_create_autocmd(
    { 'BufWinLeave' }, {
        pattern = { '.*', '*' },
        command = 'if expand("%") != "" | silent! mkview | endif',
    }
)

vim.api.nvim_create_autocmd(
    { 'BufWinEnter' }, {
        pattern = { '.*', '*' },
        command = 'if expand("%") != "" | silent! loadview | endif',
    }
)
