--- @author jarrin-p
--- @file `colorscheme.lua`
local util = require 'pack.statusline.util.util'
local apply_opacity = require'hex_tool'.apply_opacity_transition

local fg = util.get_colorscheme_as_hex('Normal', 'foreground')
local bg = util.get_colorscheme_as_hex('Normal', 'background')
local darker = util.get_colorscheme_as_hex('FloatBorder', 'background')

local green = util.get_colorscheme_as_hex('Function', 'foreground')
local red = util.get_colorscheme_as_hex('Character', 'foreground')
local orange = util.get_colorscheme_as_hex('Float', 'foreground')
-- local dark_green = '#252715'
-- local dark_red = '#251110'
-- local dark_orange = '#25160c'

local opacity = .15
local dark_green = apply_opacity(green, bg, opacity)
local dark_red = apply_opacity(red, bg, opacity)
local dark_orange = apply_opacity(orange, bg, opacity)

local hl = vim.api.nvim_set_hl
hl(0, 'DiffAdd', { bg = dark_green })
hl(0, 'DiffAdded', { link = 'DiffAdd' })

hl(0, 'DiffDelete', { bg = dark_red, fg = dark_red })
hl(0, 'DiffRemoved', { bg = dark_red })

hl(0, 'DiffChange', { bg = dark_orange })
hl(0, 'DiffText', { bg = dark_orange })

hl(0, 'EndOfBuffer', { fg = 'bg' })
hl(0, 'Search', { bg = darker, underline = true, italic = true })
hl(0, 'CurSearch', { bg = darker, underline = true, italic = true, bold = true })
hl(0, 'String', { link = 'AquaItalic' })
hl(0, 'MsgArea', { fg = fg, bg = darker })
hl(0, 'TablineFill', { link = 'Normal' })

hl(0, 'Whitespace', { fg = dark_orange })

hl(0, 'SignColumn', { link = 'Normal' })
hl(0, 'CursorLineNr', { link = 'Normal'})
hl(0, 'CursorLineSign', { link = 'Normal'})
hl(0, 'LineNr', { link = 'Normal'})
hl(0, 'FoldColumn', { link = 'Normal'})
