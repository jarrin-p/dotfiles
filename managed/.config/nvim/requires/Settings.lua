local vim = vim -- keeps language server from freaking out

-- repeatable setting values
tab_width = 4

Set = vim.o -- shorthand
Set.compatible = false

-- Terminal Settings
Set.title = true
Set.titlestring = '%t'

-- Buffer Settings
Set.hidden = true
Set.tabstop = 4
Set.shiftwidth = 0 -- 0 means use tabstop value
Set.expandtab = true
Set.smartindent = true
Set.wrap = false
Set.number = true
Set.relativenumber = true
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

-- Editing Settings
Set.backspace = 'indent,eol,start'
Set.magic = true
Set.inccommand = 'nosplit'

-- Plugin Settings
vim.g.netrw_liststyle = 3
vim.g.csv_nomap_cr = 1
vim.g.NERDTreeWinSize = 50
--vim.g.lightline.colorscheme = 'apprentice'
--vim.api.nvim_exec('set statusline=%<%f\ %h%m%r%{FugitiveStatusline()}%=%-14.(%l,%c%V%)\ %P', false)
