--- @author jarrin-p
--- @file `colorscheme.lua`
--
--- @param colorgroup string the name of the color group to get back as a string.
function GetColorschemeAsHex(colorgroup, colorgroup_field)
    local getColorValueFromGroup = vim.api.nvim_get_hl_by_name(colorgroup, true)[colorgroup_field]
    getColorValueFromGroup = string.format("%06x", getColorValueFromGroup)
    return '#' .. getColorValueFromGroup
end

--- colors {{{
--- specifying colors manually. makes tweaking easier
--- these are basically manually defined to line up with current color scheme config
Colors = {
    gui = {
        statusline_background_default = GetColorschemeAsHex('Tabline', 'background'),

        boolean_fg = GetColorschemeAsHex('Boolean', 'foreground'),
        comment_fg = GetColorschemeAsHex('Comment', 'foreground'),
        float_fg = GetColorschemeAsHex('Float', 'foreground'),
        folded_fg = GetColorschemeAsHex('Folded', 'foreground'),
        function_fg = GetColorschemeAsHex('Function', 'foreground'),
        identifier_fg = GetColorschemeAsHex('Identifier', 'foreground'),
        normal_bg = GetColorschemeAsHex('Normal', 'background'),
        normal_fg = GetColorschemeAsHex('Normal', 'foreground'),
        string_fg = GetColorschemeAsHex('String', 'foreground'),
        tablinesel_fg = GetColorschemeAsHex('TabLineSel', 'foreground'),
        tablinesel_bg = GetColorschemeAsHex('TabLineSel', 'background'),
        diffAdd_bg = GetColorschemeAsHex('DiffAdd', 'background'),
        diffChange_bg = GetColorschemeAsHex('DiffChange', 'background'),
        diffDelete_bg = GetColorschemeAsHex('DiffDelete', 'background'),
        diffText_bg = GetColorschemeAsHex('DiffText', 'background'),
        tabline_bg = GetColorschemeAsHex('TabLine', 'background'),
    },
} -- }}}

local fg = GetColorschemeAsHex('Fg', 'foreground')
local darker = GetColorschemeAsHex('FloatBorder', 'background')

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
vim.api.nvim_set_hl(0, 'TablineSel', { fg = Colors.gui.cursor_fg, bg = 'Black' })
