-- -@type Wezterm
local wezterm = require("wezterm")

local config = wezterm.config_builder()


config.term = "wezterm"

config.enable_wayland = true

config.initial_cols = 120
config.initial_rows = 28
config.default_cursor_style = "BlinkingBar"

config.color_scheme = "tokyonight_night"

config.font = wezterm.font_with_fallback({
	"Jetbrains Mono Nerd Font",
	"M+1 Nerd Font",
	"M+1Code Nerd Font",
	"devicons",
	"icomoon Regular",
})
config.font_dirs = {
	"/usr/share/fonts/TTF",
}
config.font_size = 9
config.line_height = 0.86
config.cell_width = 1.0
config.colors = {
	indexed = { [16] = "rgba(0,0,0,0.1)" },
	background = "rgba(0,0,0,0.4)",
	-- cursorline =  "40404001"
}
config.enable_tab_bar = false
config.window_close_confirmation = "NeverPrompt"
config.window_padding = {
	left = "2cell",
	-- right = "1cell",
	top = "0cell",
	bottom = "0cell",
}

return config
