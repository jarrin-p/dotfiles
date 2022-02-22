local vim = vim

local function map (lhs, rhs) vim.api.nvim_set_keymap('', lhs, rhs, {noremap = false, silent = true}) end
local function nnoremap (lhs, rhs) vim.api.nvim_set_keymap('n', lhs, rhs, {noremap = true, silent = true}) end
local function tnoremap (lhs, rhs) vim.api.nvim_set_keymap('t', lhs, rhs, {noremap = true, silent = true}) end
local function t (str) return vim.api.nvim_replace_termcodes(str, true, true, true) end

-- Simple edits
map('<space>', '<leader>') -- Remap leader to spacebar, obviously
nnoremap('Y', 'y$') -- Change back to vanilla default
nnoremap('U', '<C-R>') -- change U to redo because I'm simple and U confuses me.
nnoremap('<leader>V', ':tabe ' .. os.getenv('MYVIMRC') .. '<Enter>') -- edit init.lua

-- Window management
nnoremap('<leader>j', '<C-W>j')
nnoremap('<leader>k', '<C-W>k')
nnoremap('<leader>h', '<C-W>h')
nnoremap('<leader>l', '<C-W>l')
nnoremap('<leader>J', '<C-W>J')
nnoremap('<leader>K', '<C-W>K')
nnoremap('<leader>H', '<C-W>H')
nnoremap('<leader>L', '<C-W>L')
nnoremap('<leader>wr', '<C-W>r')

-- coc
nnoremap('<leader>d', ':call CocAction("definitionHover")<Enter>')
nnoremap('gd', ':call CocAction("jumpDefinition")<Enter>')
nnoremap('<leader>rr', ':call CocAction("rename")')
nnoremap('<leader>RR', ':call CocAction("refactor")')
nnoremap('<leader>c', ':call CocAction("codeAction")')
--nnoremap('<leader>o', '') -- needs to be expression for toggle outline

-- faster finding
nnoremap('<leader>f', ':FZF<Enter>')

-- fold method changes
nnoremap('<leader>zfi', ':set foldmethod=indent<Enter>')
nnoremap('<leader>zfm', ':set foldmethod=manual<Enter>')

-- for errorfinding and vimgrep
nnoremap('<leader>n', ':cnext<Enter>')
nnoremap('<leader>N', ':cprev<Enter>')

-- Buffer navigating
nnoremap('<leader>b', ':b#<Enter>')

-- Terminal Remapping
tnoremap('<esc><esc>', '<C-\\><C-n>')
