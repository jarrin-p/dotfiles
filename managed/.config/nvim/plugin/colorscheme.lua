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
        comment_fg = GetColorschemeAsHex("Comment", "foreground"),
        gray_lighter = '#515354',
        green = '#a7c080',
        green_bright = '#a9dd9d',
        red = '#fd8489',
        wood_dark = '#f0aa8a',
        wood_light = '#ffebc3',
        statusline_bg = '#374247',
        cursor_fg = GetColorschemeAsHex("Cursor", "foreground"),
        boolean_fg = GetColorschemeAsHex("Boolean", "foreground"),
    },
} -- }}}

vim.api.nvim_set_hl(0, 'TablineSel', { fg = Colors.gui.cursor_fg, bg = Colors.gui.boolean_fg })
