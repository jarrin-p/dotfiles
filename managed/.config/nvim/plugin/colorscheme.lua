--- @author jarrin-p
--- @file `colorscheme.lua`
local util = require 'pack.statusline.util.util'
local apply_opacity = require'hex_tool'.apply_opacity_transition

local fg = util.get_colorscheme_as_hex('Fg', 'foreground')
local bg = util.get_colorscheme_as_hex('Normal', 'background')
local darker = util.get_colorscheme_as_hex('FloatBorder', 'background')

local green = util.get_colorscheme_as_hex('Green', 'foreground')
local red = util.get_colorscheme_as_hex('Red', 'foreground')
local orange = util.get_colorscheme_as_hex('Orange', 'foreground')
-- local dark_green = '#252715'
-- local dark_red = '#251110'
-- local dark_orange = '#25160c'
--
local opacity = .15
local dark_green = apply_opacity(green, bg, opacity)
local dark_red = apply_opacity(red, bg, opacity)
local dark_orange = apply_opacity(orange, bg, opacity)

vim.api.nvim_set_hl(0, 'DiffAdd', { bg = dark_green })
vim.api.nvim_set_hl(0, 'DiffAdded', { link = 'DiffAdd' })

vim.api.nvim_set_hl(0, 'DiffDelete', { bg = dark_red, fg = dark_red })
vim.api.nvim_set_hl(0, 'DiffRemoved', { bg = dark_red })

vim.api.nvim_set_hl(0, 'DiffChange', { bg = dark_orange })
vim.api.nvim_set_hl(0, 'DiffText', { bg = dark_orange })

vim.api.nvim_set_hl(0, 'EndOfBuffer', { fg = 'bg' })
vim.api.nvim_set_hl(0, 'Search', { bg = darker, underline = true, italic = true })
vim.api.nvim_set_hl(0, 'CurSearch', { bg = darker, underline = true, italic = true, bold = true })
vim.api.nvim_set_hl(0, 'String', { link = 'AquaItalic' })
vim.api.nvim_set_hl(0, 'MsgArea', { fg = fg, bg = darker })
vim.api.nvim_set_hl(0, 'TablineFill', { link = 'Normal' })

