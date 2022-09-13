--- @author jarrin-p
--- @file `remaps.lua`
local init = os.getenv('MYVIMRC')

--- simple changes {{{
map('<space>', '<leader>') -- Remap leader to spacebar, obviously
nnoremap('Y', 'y$') -- Change back to vanilla default
nnoremap('U', '<c-r>') -- change U to redo because I'm simple and U confuses me.
nnoremap('<leader>V', ':tabe ' .. init .. '<enter>:lcd %:p:h<enter>') -- edit init.lua
nnoremap('`', '\'') -- swap mapping of "jump to mark's col,line" with "jump to mark's line"
nnoremap('\'', '`') -- swap mapping of "jump to mark's line" with "jump to mark's col,line"
-- end simple changes }}}

--- insert mode maps {{{
-- NOTE: this `inoremap` prepends `<c-o>` for a single action.
inoremap('<c-h>', 'b')
inoremap('<c-l>', 'E<c-o>l')
-- end insert mode maps }}}

--- window management {{{
-- (need to finish rest of mapping os before GoPrev() and GoNext() are actually useful)
-- nnoremap('<c-h>', ':lua GoPrev()<enter>') -- previous window (above, left)
-- nnoremap('<c-l>', ':lua GoNext()<enter>') -- next window (below, right)
-- these apply to vertical splits as well, mimics my skhd behavior instead using ctrl modifier
nnoremap('<c-h>', '<c-w>W') -- previous window (above, left)
nnoremap('<c-l>', '<c-w>w') -- next window (below, right)
-- end window management }}}

--- buffer navigating {{{
nnoremap('<c-b>', ':b#<enter>') -- most recent buffer, ctrl-b for 'back'
nnoremap('<c-j>', ':bprev<enter>') -- previous buffer, ctrl-j for going down in the stack
nnoremap('<c-k>', ':bnext<enter>') -- next buffer, ctrl-k for going up in the stack
nnoremap('<c-t>', ':tabedit %<enter>') -- duplicate buffer to new tab
nnoremap('<c-f>', ':cd %:p:h<enter>:pwd<enter>') -- cd to current file and show pwd
nnoremap('<c-g>', ':GT<enter>:pwd<enter>') -- cd to git dir
-- end buffer navigating }}}

--- fold method changing {{{
nnoremap('<leader>zfi', ':set foldmethod=indent<enter>')
nnoremap('<leader>zfm', ':set foldmethod=manual<enter>')
-- end fold method changing }}}

--- finding navigation {{{
nnoremap('<leader>n', ':cnext<enter>')
nnoremap('<leader>N', ':cprev<enter>')
-- end finding navigation }}}

-- terminal remaps {{{
-- default terminal mapping.
tnoremap('<C-[>', '<C-\\><C-n>')
tnoremap('<c-h>', '<C-\\><C-n><c-w>W') -- previous window (above, left)
tnoremap('<c-l>', '<C-\\><C-n><c-w>w') -- next window (below, right)
-- }}}

-- vim: fdm=marker foldlevel=0
