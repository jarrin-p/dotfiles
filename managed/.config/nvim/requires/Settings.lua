local vim = vim -- keeps language server from freaking out

Set = vim.o     -- shorthand
Set.compatible = false

-- Terminal Settings
Set.title = true
Set.titlestring = '%t'

-- Buffer Settings
Set.hidden = true
Set.tabstop = 4        -- autocmd for java to be 2
Set.shiftwidth = 0     -- 0 means use tabstop value
Set.expandtab = true   -- use spaces instead of tabs
Set.smartindent = false -- trying out only autoindent
Set.wrap = false
Set.number = true
Set.relativenumber = true   -- show how many lines away instead of exact line number
Set.syntax = 'on'
Set.foldcolumn = '3'
Set.foldmethod = 'manual'
Set.path = Set.path .. '**'
Set.signcolumn = 'yes'
Set.updatetime = 100
Set.foldlevelstart = 99
Set.scrolloff = 12
Set.cursorline = true
Set.showmode = false  -- changed to false because of lightline plugin
Set.splitright = true -- splits new window to the right
Set.splitbelow = true -- splits new window down
--Set.sessionoptions = 'localoptions,folds,options,tabpages,winsizes,sesdir'

-- sets the grep program as ripgrep
Set.grepprg = 'rg --line-number --with-filename'

-- Editing Settings
Set.backspace = 'indent,eol,start'
Set.magic = true
Set.inccommand = 'nosplit'

-- Plugin Settings
vim.g.netrw_liststyle = 3
vim.g.csv_nomap_cr = 1
vim.g.NERDTreeWinSize = 50
