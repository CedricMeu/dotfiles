local wezterm = require('wezterm')
local config = wezterm.config_builder()

require('keytables')(config)

-- Theme
config.color_scheme = 'ayu_light'
config.ui_key_cap_rendering = 'Emacs'

-- Font
config.font = wezterm.font('Monoid Nerd Font Mono')
config.font_size = 11
config.line_height = 1.25

-- Tab bar
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = false
config.tab_bar_at_bottom = true

-- Window padding
config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

-- Inactive pane
config.inactive_pane_hsb = {
  saturation = 0.9,
  brightness = 0.9
}

return config
