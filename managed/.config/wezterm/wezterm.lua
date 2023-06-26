local wezterm = require 'wezterm'

local config = {}
if wezterm.config_builder then
    config = wezterm.config_builder()
end

config.enable_tab_bar = false
config.color_scheme = 'Gruvbox dark, hard (base16)'

config.font = wezterm.font('JetBrains Mono')
config.font_size = 13

-- window settings
config.enable_scroll_bar = true
config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

return config
