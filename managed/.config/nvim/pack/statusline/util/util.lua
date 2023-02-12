local M = {
    --- standard linear search function.
    --- @param table_to_search table the table to be searched.
    --- @param item_to_find any item to be found in the table.
    --- @return number index of item. returns `-1` if nothing is found.
    linearSearch = function(table_to_search, item_to_find)
        for i, item in ipairs(table_to_search) do
            if item == item_to_find then
                return i
            end
        end
        return -1
    end,

    --- checks if a boolean option is true, then adds a user defined symbol if it is.
    --- @param option string the vim option to check if it's true or not.
    --- @param symbol_to_use string the value to be returned if the option is true.
    --- @return string #empty if false, otherwise returns `symbol_to_use`.
    getIfSet = function(option, symbol_to_use)
        if (vim.api.nvim_get_option_value(option, {}) == true) then
            return symbol_to_use
        end
        return ''
    end,

    --- @param colorgroup string the name of the color group to get back as a string.
    get_colorscheme_as_hex = function(colorgroup, colorgroup_field)
        local getColorValueFromGroup = vim.api.nvim_get_hl_by_name(colorgroup, true)[colorgroup_field]
        getColorValueFromGroup = string.format("%06x", getColorValueFromGroup)
        return '#' .. getColorValueFromGroup
    end,
}
return M
