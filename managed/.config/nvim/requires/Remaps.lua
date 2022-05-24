require 'Global'

local function map (lhs, rhs) Vim.api.nvim_set_keymap('', lhs, rhs, {noremap = false, silent = true}) end
local function nnoremap (lhs, rhs) Vim.api.nvim_set_keymap('n', lhs, rhs, {noremap = true, silent = true}) end
local function tnoremap (lhs, rhs) Vim.api.nvim_set_keymap('t', lhs, rhs, {noremap = true, silent = true}) end
local function t (str) return Vim.api.nvim_replace_termcodes(str, true, true, true) end

-- simple changes
map('<space>', '<leader>') -- Remap leader to spacebar, obviously
nnoremap('Y', 'y$')        -- Change back to vanilla default
nnoremap('U', '<c-r>')     -- change U to redo because I'm simple and U confuses me.
nnoremap('<leader>V', ':tabe ' .. os.getenv('MYVIMRC') .. '<enter>') -- edit init.lua
nnoremap('`', "'") -- swap mapping of "jump to mark's col,line" with "jump to mark's line"
nnoremap("'", '`') -- swap mapping of "jump to mark's line" with "jump to mark's col,line"

-- window management
-- (need to finish rest of mapping os before GoPrev() and GoNext() are actually useful)
-- nnoremap('<c-h>', ':lua GoPrev()<enter>') -- previous window (above, left)
-- nnoremap('<c-l>', ':lua GoNext()<enter>') -- next window (below, right)
-- these apply to vertical splits as well, mimics my skhd behavior instead using ctrl modifier
nnoremap('<c-h>', '<c-w>W') -- previous window (above, left)
nnoremap('<c-l>', '<c-w>w') -- next window (below, right)
nnoremap('<c-n>', '<c-w>n') -- exchange with next window (or prev if no next)
nnoremap('<c-r>', '<c-w>n') -- exchange with next window (or prev if no next)
nnoremap('<c-enter>', ':vsp<enter>')
--nnoremap('<C-.>', '<C-W>+') -- increase window size -- control . not working
--nnoremap('<C-,>', '<C-W>-') -- reduce window size -- control , not working

-- buffer navigating
nnoremap('<c-b>', ':b#<enter>')        -- most recent buffer, ctrl-b for 'back'
nnoremap('<c-j>', ':bprev<enter>')     -- previous buffer, ctrl-j for going down in the stack
nnoremap('<c-k>', ':bnext<enter>')     -- next buffer, ctrl-k for going up in the stack
nnoremap('<c-t>', ':tabedit %')        -- duplicate window to new tab
nnoremap('<leader>b', ':BufExplorer<enter>')

-- coc
nnoremap('<leader>d', ':call CocAction("definitionHover")<enter>')
nnoremap('gd', ':call CocAction("jumpDefinition")<enter>')
--nnoremap('<leader>r', ':call CocAction("rename")<enter>')     -- not sure why these aren't working
--nnoremap('<leader>R', ':call CocAction("refactor")<enter>')   -- not sure why these aren't working
nnoremap('<leader>c', ':call CocAction("codeAction")<enter>')
nnoremap('<leader>C', ':call CocAction("codeActions")<enter>')
nnoremap('<leader>o', ':call CocAction("showOutline")<enter>:vert res 50<Enter>')
nnoremap('<leader>j', ':call CocAction("jumpReferences")<enter>:copen<enter>')
nnoremap('<leader>DD', ':call CocAction("diagnosticToggle")<enter>')

-- nerdtree
nnoremap('<leader>t', ':NERDTreeFind<enter>:set rnu<enter>')       -- at current working directory
nnoremap('<leader>T', ':NERDTreeToggleVCS<enter>:set rnu<enter>')  -- at vcs toplevel

-- git
nnoremap('<leader>g', ':tab G<enter>')

-- fuzzy finding
nnoremap('<leader>ff', ":Telescope find_files<enter>") -- uses default settings
nnoremap('<leader>fg', ":Telescope live_grep<enter>") -- uses default settings
nnoremap('<leader>fhf', ":Telescope find_files find_command=rg,--hidden,--files<enter>") -- uses default settings
-- nnoremap('<leader>fhg', ":Telescope live_grep grep_command=rg,--hidden<enter>") -- uses default settings

-- nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
-- nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
-- nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
-- nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>

-- fold method changes
nnoremap('<leader>zfi', ':set foldmethod=indent<enter>')
nnoremap('<leader>zfm', ':set foldmethod=manual<enter>')

-- for errorfinding and grep
nnoremap('<leader>n', ':cnext<enter>')
nnoremap('<leader>N', ':cprev<enter>')

-- terminal remapping
tnoremap('<esc><esc>', '<C-\\><C-n>') -- esc esc takes you to normal mode.
