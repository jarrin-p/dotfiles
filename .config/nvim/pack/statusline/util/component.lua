local get_colorscheme_as_hex = require 'utils.color-tool'["get-colorscheme-as-hex"]

--- nvim highlight group wrapper that allows easier inline status text formatting.
--- additionally, has defaults specified to keep the status/tab line uniform.
--- @class component
--- @field hl_name string
--- @field scope integer
--- @field pretext string
--- @field posttext string
local M = {
    hl_name = 'Not set',
    scope = 0,
    value = '',

    -- create new statusline colorgroup object. attempting to manage statusline color groups
    -- so its behavior can be more easily updated.
    new = function(self, arg_table)
        self.__index = self
        local obj = {}
        setmetatable(obj, self)

        for key, val in pairs(arg_table) do
            obj[key] = val
        end

        return obj
    end,

    --- @param text_to_color string for code readability, to "pseudo" wrap the group of characters to be colored.
    --- @return string #the color group in the status line.
    set = function(self, text_to_color)
        text_to_color = text_to_color or ''
        return '%#' .. self.hl_name .. '#' .. text_to_color
    end,

    --- @param component component the component of the color scheme you want to transition to.
    --- @param identifier string what key to access from the result of `GetColorschemeAsHex`.
    --- @param symbol string the symbol to use for transitioning.
    --- @return component transition the transition component.
    get_transition_to = function(self, component, identifier, symbol)
        local from = get_colorscheme_as_hex(component.hl_name, identifier)
        local to = get_colorscheme_as_hex(self.hl_name, identifier)
        local newComponentName = self.hl_name .. 'To' .. component.hl_name
        vim.api.nvim_set_hl(0, newComponentName, { bg = from, fg = to })
        return self:new{ hl_name = newComponentName, value = symbol }
    end,

    --- @return string #the value stored inside this component. typically preceded by `get_transition_to`.
    get_value = function(self)
        return self:set(self.value)
    end,

    --- @param highlight_group_override string the name of the highlight group you wish to override.
    --- @return component #a new component pointing at HighlightGroup that has reversed bg, fg of what this was called on.
    reversed = function(self, highlight_group_override)
        local bg = get_colorscheme_as_hex(self.hl_name, 'background')
        local fg = get_colorscheme_as_hex(self.hl_name, 'foreground')
        local newComponentName = highlight_group_override or self.hl_name .. 'Reversed'
        vim.api.nvim_set_hl(0, newComponentName, { bg = fg, fg = bg })
        return self:new{ hl_name = newComponentName }
    end,
}
return M
