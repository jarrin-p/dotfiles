local vim = vim -- keeps language server from freaking out

Set = vim.o -- shorthand
Set.compatible = false

-- Buffer Settings
Set.hidden = true
Set.tabstop = 4
Set.shiftwidth = 4
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

-- Editing Settings
Set.backspace = 'indent,eol,start'
Set.magic = true
Set.inccommand = 'nosplit'

-- Plugin Settings
vim.g.netrw_liststyle = 3
vim.g.csv_nomap_cr = 1
