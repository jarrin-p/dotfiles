--- nvim highlight group wrapper that allows easier inline status text formatting.
--- additionally, has defaults specified to keep the status/tab line uniform.
--- todo: links MUST come after normal assignments.
--- todo: links persist to following :new delcarations for some reason
M = {
    name = 'Not set',
    scope = 0,
    options = { bg = Colors.gui.statusline_background_default },
    pretext = '',
    posttext = '',

    -- create new statusline colorgroup object. attempting to manage statusline color groups
    -- so its behavior can be more easily updated.
    new = function(self, arg_table)
        self.__index = self
        local obj = {}
        setmetatable(obj, self)

        for key, val in pairs(arg_table) do
            if key == 'options' then
                -- if it's the options table, loop through to add to the table instead of
                -- overwriting from the new table. this preserves default settings.
                for opts_key, opts_val in pairs(val) do
                    obj.options[opts_key] = opts_val
                end

            else
                obj[key] = val
            end
        end
        vim.api.nvim_set_hl(obj.scope, obj.name, obj.options)

        return obj
    end,

    --- @param text_to_color string for code readability, to "pseudo" wrap the group of characters to be colored.
    --- @return string #the color group in the status line.
    set = function(self, text_to_color)
        text_to_color = text_to_color or ''
        return '%#' .. self.name .. '#' .. self.pretext .. text_to_color .. self.posttext
    end,
}
return M
