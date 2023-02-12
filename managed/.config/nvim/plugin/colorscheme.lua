--- @author jarrin-p
--- @file `colorscheme.lua`
local util = require 'pack.statusline.util.util'

local fg = util.get_colorscheme_as_hex('Fg', 'foreground')
local darker = util.get_colorscheme_as_hex('FloatBorder', 'background')

vim.api.nvim_set_hl(0, 'DiffAdd', { link = 'GreenItalic' })
vim.api.nvim_set_hl(0, 'DiffChange', { link = 'OrangeItalic' })
vim.api.nvim_set_hl(0, 'DiffDelete', { link = 'RedItalic' })
vim.api.nvim_set_hl(0, 'DiffText', { link = 'YellowItalic' })
vim.api.nvim_set_hl(0, 'EndOfBuffer', { fg = 'bg' })
vim.api.nvim_set_hl(0, 'Search', { underline = true, italic = true })
vim.api.nvim_set_hl(0, 'CurSearch', { underline = true, italic = true, bold = true })
vim.api.nvim_set_hl(0, 'String', { link = 'AquaItalic' })
vim.api.nvim_set_hl(0, 'MsgArea', { fg = fg, bg = darker })
vim.api.nvim_set_hl(0, 'TablineFill', { link = 'Normal' })
