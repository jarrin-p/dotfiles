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
    cursorline = '#f0aa8a', -- dark wood
    none = 'none',

    term = { cyan = 81, blue_dark = 8, red = 9 },

    gui = {
        gray_lighter = '#515354',
        green = '#a7c080',
        green_bright = '#a9dd9d',
        red = '#fd8489',
        wood_dark = '#f0aa8a',
        wood_light = '#ffebc3',
        statusline_bg = '#374247',
        boolean_fg = GetColorschemeAsHex('Boolean', 'foreground'),
        comment_fg = GetColorschemeAsHex('Comment', 'foreground'),
        cursor_bg = GetColorschemeAsHex('Cursor', 'background'),
        cursor_fg = GetColorschemeAsHex('Cursor', 'foreground'),
        float_fg = GetColorschemeAsHex('Float', 'foreground'),
        folded_fg = GetColorschemeAsHex('Folded', 'foreground'),
        function_fg = GetColorschemeAsHex('Function', 'foreground'),
        identifier_fg = GetColorschemeAsHex('Identifier', 'foreground'),
        normal_bg = GetColorschemeAsHex('Normal', 'background'),
        normal_fg = GetColorschemeAsHex('Normal', 'foreground'),
        statusline_background_default = GetColorschemeAsHex('Tabline', 'background'),
        string_fg = GetColorschemeAsHex('String', 'foreground'),
        tablinesel_fg = GetColorschemeAsHex('TabLineSel', 'foreground'),
        tablinesel_bg = GetColorschemeAsHex('TabLineSel', 'background'),
    },
} -- }}}

vim.api.nvim_set_hl(0, 'Character', { fg = Colors.gui.float_fg })
vim.api.nvim_set_hl(0, 'Conditional', { fg = Colors.gui.float_fg })
vim.api.nvim_set_hl(0, 'CurSearch', { fg = Colors.gui.cursor_fg, bg = Colors.gui.cursor_bg })
vim.api.nvim_set_hl(0, 'CursorLine', {})
vim.api.nvim_set_hl(0, 'Define', { italic = true, fg = Colors.gui.function_fg })
vim.api.nvim_set_hl(0, 'EndOfBuffer', { fg = 'bg' })
vim.api.nvim_set_hl(0, 'Float', { fg = Colors.gui.string_fg })
vim.api.nvim_set_hl(0, 'Folded', { italic = true, fg = Colors.gui.folded_fg })
vim.api.nvim_set_hl(0, 'Function', { italic = false, fg = Colors.gui.boolean_fg })
vim.api.nvim_set_hl(0, 'Identifier', { italic = false, fg = Colors.gui.function_fg })
vim.api.nvim_set_hl(0, 'Keyword', { bold = true, fg = Colors.gui.float_fg })
vim.api.nvim_set_hl(0, 'Label', { italic = true, fg = Colors.gui.function_fg })
vim.api.nvim_set_hl(0, 'Number', { italic = true, fg = Colors.gui.string_fg })
vim.api.nvim_set_hl(0, 'Operator', { fg = Colors.gui.float_fg })
vim.api.nvim_set_hl(0, 'String', { fg = Colors.gui.string_fg, italic = true })
vim.api.nvim_set_hl(0, 'Structure', { italic = true, fg = Colors.gui.function_fg })
vim.api.nvim_set_hl(0, 'TablineFill', {})
vim.api.nvim_set_hl(0, 'TablineSel', { fg = Colors.gui.cursor_fg, bg = Colors.gui.boolean_fg })
vim.api.nvim_set_hl(0, 'Type', { italic = true, fg = Colors.gui.function_fg })
vim.api.nvim_set_hl(0, 'Typedef', { italic = true, fg = Colors.gui.function_fg })
