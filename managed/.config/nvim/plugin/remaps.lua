--- @author jarrin-p
--- @file `remaps.lua`
local util = require 'util'
util.map('<space>', '<leader>') -- Remap leader to spacebar, obviously
util.nnoremap('Y', 'y$') -- Change back to vanilla default
util.nnoremap('U', '<c-r>') -- change U to redo because I'm simple and U confuses me.
util.nnoremap('`', '\'') -- swap mapping of "jump to mark's col,line" with "jump to mark's line"
util.nnoremap('\'', '`') -- swap mapping of "jump to mark's line" with "jump to mark's col,line"

--- increase or decrease respectively the font size via mapping.
util.nnoremap('<leader>+', ':lua SetFontSize(1)<enter>')
util.nnoremap('<leader>-', ':lua SetFontSize(-1)<enter>')

--- insert mode maps 
-- NOTE: this `inoremap` prepends `<c-o>` for a single action.
util.inoremap('<c-h>', 'b')
util.inoremap('<c-l>', 'E<c-o>l')

--- window management 
-- (need to finish rest of mapping os before GoPrev() and GoNext() are actually useful)
-- nnoremap('<c-h>', ':lua GoPrev()<enter>') -- previous window (above, left)
-- nnoremap('<c-l>', ':lua GoNext()<enter>') -- next window (below, right)
-- these apply to vertical splits as well, mimics my skhd behavior instead using ctrl modifier
util.nnoremap('<c-h>', '<c-w>W') -- previous window (above, left)
util.nnoremap('<c-l>', '<c-w>w') -- next window (below, right)

--- buffer navigating 
util.nnoremap('<c-b>', ':b#<enter>') -- most recent buffer, ctrl-b for 'back'
util.nnoremap('<c-j>', ':bprev<enter>') -- previous buffer, ctrl-j for going down in the stack
util.nnoremap('<c-k>', ':bnext<enter>') -- next buffer, ctrl-k for going up in the stack
util.nnoremap('<c-t>', ':tabedit %<enter>') -- duplicate buffer to new tab
util.nnoremap('<c-f>', ':cd %:p:h<enter>:pwd<enter>') -- cd to current file and show pwd
util.nnoremap('<c-g>', ':GT<enter>:pwd<enter>') -- cd to git dir

--- fold method changing 
util.nnoremap('<leader>zfi', ':set foldmethod=indent<enter>')
util.nnoremap('<leader>zfm', ':set foldmethod=manual<enter>')

--- finding navigation 
util.nnoremap('<leader>n', ':cnext<enter>')
util.nnoremap('<leader>N', ':cprev<enter>')

-- terminal remaps 
util.tnoremap('<C-[>', '<C-\\><C-n>')
util.tnoremap('<c-h>', '<C-\\><C-n><c-w>W') -- previous window (above, left)
util.tnoremap('<c-l>', '<C-\\><C-n><c-w>w') -- next window (below, right)

-- vim: fdm=marker foldlevel=0
