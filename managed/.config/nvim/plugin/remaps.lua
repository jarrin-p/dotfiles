--- @author jarrin-p
--- @file `remaps.lua`
local utils = require 'utils'
utils.map('<space>', '<leader>') -- Remap leader to spacebar, obviously
utils.nnoremap('Y', 'y$') -- Change back to vanilla default
utils.nnoremap('U', '<c-r>') -- change U to redo because I'm simple and U confuses me.
utils.nnoremap('`', '\'') -- swap mapping of "jump to mark's col,line" with "jump to mark's line"
utils.nnoremap('\'', '`') -- swap mapping of "jump to mark's line" with "jump to mark's col,line"

--- increase or decrease respectively the font size via mapping.
utils.nnoremap('<leader>+', ':lua SetFontSize(1)<enter>')
utils.nnoremap('<leader>-', ':lua SetFontSize(-1)<enter>')

--- insert mode maps
-- NOTE: this `inoremap` prepends `<c-o>` for a single action.
utils.inoremap('<c-h>', 'b')
utils.inoremap('<c-l>', 'E<c-o>l')

--- window management
-- (need to finish rest of mapping os before GoPrev() and GoNext() are actually useful)
-- nnoremap('<c-h>', ':lua GoPrev()<enter>') -- previous window (above, left)
-- nnoremap('<c-l>', ':lua GoNext()<enter>') -- next window (below, right)
-- these apply to vertical splits as well, mimics my skhd behavior instead using ctrl modifier
utils.nnoremap('<c-h>', '<c-w>W') -- previous window (above, left)
utils.nnoremap('<c-l>', '<c-w>w') -- next window (below, right)

--- buffer navigating
utils.nnoremap('<c-b>', ':b#<enter>') -- most recent buffer, ctrl-b for 'back'
utils.nnoremap('<c-j>', ':bprev<enter>') -- previous buffer, ctrl-j for going down in the stack
utils.nnoremap('<c-k>', ':bnext<enter>') -- next buffer, ctrl-k for going up in the stack
utils.nnoremap('<c-t>', ':tabedit %<enter>') -- duplicate buffer to new tab
utils.nnoremap('<c-f>', ':lcd %:p:h<enter>:pwd<enter>') -- cd to current file and show pwd
utils.nnoremap('<c-g>', ':GT<enter>:pwd<enter>') -- cd to git dir

--- fold method changing
utils.nnoremap('<leader>zfi', ':set foldmethod=indent<enter>')
utils.nnoremap('<leader>zfm', ':set foldmethod=manual<enter>')

--- finding navigation
utils.nnoremap('<leader>n', ':cnext<enter>')
utils.nnoremap('<leader>p', ':cprev<enter>')

utils.nnoremap('<leader>t', ':NvimTreeToggle<enter>')
utils.nnoremap('<leader>T', ':NvimTreeFindFile<enter>')

-- terminal remaps
utils.tnoremap('<C-[>', '<C-\\><C-n>')
utils.tnoremap('<c-h>', '<C-\\><C-n><c-w>W') -- previous window (above, left)
utils.tnoremap('<c-l>', '<C-\\><C-n><c-w>w') -- next window (below, right)

-- vim: fdm=marker foldlevel=0
