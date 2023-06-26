local wezterm = require 'wezterm'

local config = {}
if wezterm.config_builder then
    config = wezterm.config_builder()
end

config.enable_tab_bar = false
config.color_scheme = 'Gruvbox dark, hard (base16)'

-- fonts
config.font = wezterm.font('JetBrains Mono')
config.font_size = 13
config.line_height = 1.3
config.freetype_load_target = "HorizontalLcd"
-- config.animation_fps = 60

-- key remaps
config.keys = {
    { key = '=', mods = 'ALT', action = wezterm.action.IncreaseFontSize },
    { key = '-', mods = 'ALT', action = wezterm.action.DecreaseFontSize },
}

-- window settings
config.enable_scroll_bar = true
config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }

return config
