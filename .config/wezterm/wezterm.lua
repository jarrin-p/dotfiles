local wezterm = require 'wezterm'

local config = {}
if wezterm.config_builder then
    config = wezterm.config_builder()
end

config.enable_tab_bar = false
config.color_scheme = 'Gruvbox dark, hard (base16)'
config.font = wezterm.font('JetBrains Mono')
config.freetype_load_target = "HorizontalLcd"

-- key remaps
config.keys = {
    { key = '=', mods = 'ALT', action = wezterm.action.IncreaseFontSize },
    { key = '-', mods = 'ALT', action = wezterm.action.DecreaseFontSize },
    { key = 't', mods = 'CTRL', action = wezterm.action.DisableDefaultAssignment, },
    { key = 'v', mods = 'ALT', action = wezterm.action.PasteFrom 'Clipboard' },
}

-- window settings
config.enable_scroll_bar = false
config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }

local operating_system
if package.config:sub(1, 1) == '\\' then operating_system = 'win' else operating_system = 'unix' end

if operating_system == 'win' then
    local mine = wezterm.color.load_terminal_sexy_scheme "fill this in with a path :-)"
    config.colors = mine
    config.default_domain = 'WSL:Ubuntu'

    config.animation_fps = 1
    config.font_size = 11.0
    config.line_height = 1.0

elseif operating_system == 'unix' then
    local mine = wezterm.color.load_terminal_sexy_scheme "your path goes here"
    config.colors = mine
    config.animation_fps = 1
    config.font_size = 13
    config.line_height = 1.3

else
    print("unknown configuration")
end

return config
