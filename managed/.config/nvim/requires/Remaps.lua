local vim = vim

local function map (lhs, rhs) vim.api.nvim_set_keymap('', lhs, rhs, {noremap = false, silent = true}) end
local function nnoremap (lhs, rhs) vim.api.nvim_set_keymap('n', lhs, rhs, {noremap = true, silent = true}) end
local function tnoremap (lhs, rhs) vim.api.nvim_set_keymap('t', lhs, rhs, {noremap = true, silent = true}) end
local function t (str) return vim.api.nvim_replace_termcodes(str, true, true, true) end

-- simple edits
map('<space>', '<leader>') -- Remap leader to spacebar, obviously
nnoremap('Y', 'y$')        -- Change back to vanilla default
nnoremap('U', '<c-r>')     -- change U to redo because I'm simple and U confuses me.
nnoremap('<leader>V', ':tabe ' .. os.getenv('MYVIMRC') .. '<enter>') -- edit init.lua

-- formatting
nnoremap('<leader>=', ':SA<enter>')

-- window management
-- these apply to vertical splits as well, mimics my skhd behavior instead using ctrl modifier
nnoremap('<c-h>', '<c-w>W') -- previous window (above, left)
nnoremap('<c-l>', '<c-w>w') -- next window (below, right)
nnoremap('<c-n>', '<c-w>n') -- exchange with next window (or prev if no next)
nnoremap('<c-r>', '<c-w>n') -- exchange with next window (or prev if no next)
--nnoremap('<C-.>', '<C-W>+') -- increase window size -- control . not working
--nnoremap('<C-,>', '<C-W>-') -- reduce window size -- control , not working

-- buffer navigating
nnoremap('<c-b>', ':b#<enter>')    -- most recent buffer, ctrl-b for 'back'
nnoremap('<c-j>', ':bprev<enter>') -- previous buffer, ctrl-j for going down in the stack
nnoremap('<c-k>', ':bnext<enter>') -- next buffer, ctrl-k for going up in the stack

-- coc
nnoremap('<leader>d', ':call CocAction("definitionHover")<enter>')
nnoremap('gd', ':call CocAction("jumpDefinition")<enter>')
--nnoremap('<leader>r', ':call CocAction("rename")<enter>')     -- not sure why these aren't working
--nnoremap('<leader>R', ':call CocAction("refactor")<enter>')   -- not sure why these aren't working
nnoremap('<leader>c', ':call CocAction("codeAction")<enter>')
nnoremap('<leader>C', ':call CocAction("codeActions")<enter>')
nnoremap('<leader>o', ':call CocAction("showOutline")<enter>:vert res 50<Enter>')
nnoremap('<leader>r', ':call CocAction("jumpReferences")<enter>:copen<enter>')
nnoremap('<leader>DD', ':call CocAction("diagnosticToggle")<enter>')

-- nerdtree
nnoremap('<leader>t', ':NERDTreeToggle<enter>:set rnu<enter>')     -- at current working directory
nnoremap('<leader>T', ':NERDTreeToggleVCS<enter>:set rnu<enter>')  -- at vcs toplevel

-- fuzzy finding
nnoremap('<leader>f', ':FZF<enter>')

-- fold method changes
nnoremap('<leader>zfi', ':set foldmethod=indent<enter>')
nnoremap('<leader>zfm', ':set foldmethod=manual<enter>')

-- for errorfinding and vimgrep
nnoremap('<leader>n', ':cnext<enter>')
nnoremap('<leader>N', ':cprev<enter>')

-- terminal remapping
tnoremap('<esc><esc>', '<C-\\><C-n>') -- esc esc takes you to normal mode.