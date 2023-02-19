local util = require 'util'
util.nnoremap('<leader>m', ':MinimapToggle<enter>')

vim.g.minimap_width = 15
vim.g.minimap_left = 1
vim.g.minimap_git_colors = 1
vim.g.minimap_highlight_search = 1
vim.g.minimap_block_filetypes = { 'nofile', 'fugitive', 'fzf', 'help' }
-- these break on a lot of buffers for some reason.
-- vim.g.minimap_auto_start = 1
-- vim.g.minimap_auto_start_win_enter = 1
