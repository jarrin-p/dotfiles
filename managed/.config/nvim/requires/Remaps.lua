local vim = vim

local function map (lhs, rhs) vim.api.nvim_set_keymap('', lhs, rhs, {noremap = false, silent = true}) end
local function nnoremap (lhs, rhs) vim.api.nvim_set_keymap('n', lhs, rhs, {noremap = true, silent = true}) end
local function tnoremap (lhs, rhs) vim.api.nvim_set_keymap('t', lhs, rhs, {noremap = true, silent = true}) end
local function t (str) return vim.api.nvim_replace_termcodes(str, true, true, true) end

-- simple edits
map('<space>', '<leader>') -- Remap leader to spacebar, obviously
nnoremap('Y', 'y$')        -- Change back to vanilla default
nnoremap('U', '<C-R>')     -- change U to redo because I'm simple and U confuses me.
nnoremap('<leader>V', ':tabe ' .. os.getenv('MYVIMRC') .. '<Enter>') -- edit init.lua

-- window management
-- these apply to vertical splits as well, mimics my skhd behavior instead using ctrl modifier
nnoremap('<C-h>', '<C-W>W') -- previous window (above, left)
nnoremap('<C-l>', '<C-W>w') -- next window (below, right)
nnoremap('<C-r>', '<C-W>r') -- rotate windows
nnoremap('<C-.>', '<C-W>+') -- increase window size
nnoremap('<C-,>', '<C-W>-') -- reduce window size

-- buffer navigating
nnoremap('<c-b>', ':b#<Enter>')    -- most recent buffer, ctrl-b for 'back'
nnoremap('<c-j>', ':bprev<Enter>') -- previous buffer, ctrl-j for going down in the stack
nnoremap('<c-k>', ':bnext<Enter>') -- next buffer, ctrl-k for going up in the stack

-- coc
nnoremap('<leader>d', ':call CocAction("definitionHover")<Enter>')
nnoremap('gd', ':call CocAction("jumpDefinition")<Enter>')
nnoremap('<leader>r', ':call CocAction("rename")<Enter>')
nnoremap('<leader>R', ':call CocAction("refactor")<Enter>')
nnoremap('<leader>c', ':call CocAction("codeAction")<Enter>')
nnoremap('<leader>o', ':call CocAction("showOutline")<Enter>')

-- nerdtree
nnoremap('<leader>t', ':NERDTreeToggleVCS<Enter>')

-- fuzzy finding
nnoremap('<leader>f', ':FZF<Enter>')

-- fold method changes
nnoremap('<leader>zfi', ':set foldmethod=indent<Enter>')
nnoremap('<leader>zfm', ':set foldmethod=manual<Enter>')

-- for errorfinding and vimgrep
nnoremap('<leader>n', ':cnext<Enter>')
nnoremap('<leader>N', ':cprev<Enter>')

-- terminal remapping
tnoremap('<esc><esc>', '<C-\\><C-n>') -- esc esc takes you to normal mode.
