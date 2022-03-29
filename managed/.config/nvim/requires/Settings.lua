local vim = vim -- keeps language server from freaking out

Set = vim.o     -- shorthand
Set.compatible = false

-- Terminal Settings
Set.title = true
Set.titlestring = '%t'

-- Buffer Settings
Set.hidden = true
Set.tabstop = 2        -- match the work java linter
Set.shiftwidth = 0     -- 0 means use tabstop value
Set.expandtab = true   -- use spaces instead of tabs
Set.smartindent = true -- let neovim think about indentation
Set.wrap = false
Set.number = true
Set.relativenumber = true   -- show how many lines away instead of exact line number
Set.syntax = 'on'
Set.foldcolumn = '3'
Set.foldmethod = 'indent'
Set.path = Set.path .. '**'
Set.signcolumn = 'yes'
Set.updatetime = 200
Set.foldlevelstart = 99
Set.scrolloff = 12
Set.cursorline = true
Set.showmode = false
Set.grepprg = 'rg --line-number --with-filename'

-- Editing Settings
Set.backspace = 'indent,eol,start'
Set.magic = true
Set.inccommand = 'nosplit'

-- Plugin Settings
vim.g.netrw_liststyle = 3
vim.g.csv_nomap_cr = 1
vim.g.NERDTreeWinSize = 50
--vim.g.lightline.colorscheme = 'apprentice'
