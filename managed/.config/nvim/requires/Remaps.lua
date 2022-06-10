local function map (lhs, rhs) vim.api.nvim_set_keymap('', lhs, rhs, {noremap = false, silent = true}) end
local function nnoremap (lhs, rhs) vim.api.nvim_set_keymap('n', lhs, rhs, {noremap = true, silent = true}) end
local function tnoremap (lhs, rhs) vim.api.nvim_set_keymap('t', lhs, rhs, {noremap = true, silent = true}) end

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

-- buffer navigating
nnoremap('<c-b>', ':b#<enter>')        -- most recent buffer, ctrl-b for 'back'
nnoremap('<c-j>', ':bprev<enter>')     -- previous buffer, ctrl-j for going down in the stack
nnoremap('<c-k>', ':bnext<enter>')     -- next buffer, ctrl-k for going up in the stack
nnoremap('<c-t>', ':tabedit %<enter>') -- duplicate buffer to new tab
nnoremap('<c-f>', ':cd %:p:h<enter>:pwd<enter>')  -- cd to current file and show pwd
nnoremap('<c-g>', ':GT<enter>:pwd<enter>')        -- cd to git dir

nnoremap('gD', ':lua vim.lsp.buf.declaration()<enter>')
nnoremap('gd', ':lua vim.lsp.buf.definition()<enter>')
nnoremap('<leader>d', ':lua vim.lsp.buf.hover()<enter>')
nnoremap('gi', ':lua vim.lsp.buf.implementation()<enter>')
nnoremap('<leader>rn', ':lua vim.lsp.buf.rename()<enter>')
nnoremap('gc', ':lua vim.lsp.buf.code_action()<enter>')
nnoremap('g=', ':lua vim.lsp.buf.formatting()<enter>')
nnoremap('go', ':lua vim.lsp.buf.document_symbol()<enter>')
nnoremap('gw', ':lua vim.lsp.buf.workspace_symbol()<enter>')
nnoremap('gs', ':lua vim.lsp.buf.signature_help()<enter>')

-- nerdtree
nnoremap('<leader>t', ':NERDTreeFind<enter>:set rnu<enter>')       -- at current working directory
nnoremap('<leader>T', ':NERDTreeToggleVCS<enter>:set rnu<enter>')  -- at vcs toplevel

-- git, figutive
nnoremap('<leader>g', ':tab G<enter>')
nnoremap('<leader>b', ':G branch<enter>')

-- fuzzy finding
nnoremap('<leader>ff', ":Telescope find_files<enter>") -- uses default settings
nnoremap('<leader>fg', ":Telescope live_grep<enter>") -- uses default settings
nnoremap('<leader>fhf', ":Telescope find_files find_command=rg,--hidden,--files<enter>") -- uses default settings
-- nnoremap('<leader>fhg', ":Telescope live_grep grep_command=rg,--hidden<enter>") -- uses default settings

-- fold method changes
nnoremap('<leader>zfi', ':set foldmethod=indent<enter>')
nnoremap('<leader>zfm', ':set foldmethod=manual<enter>')

-- for errorfinding and grep
nnoremap('<leader>n', ':cnext<enter>')
nnoremap('<leader>N', ':cprev<enter>')

-- terminal remapping
tnoremap('<esc><esc>', '<C-\\><C-n>') -- esc esc takes you to normal mode.
