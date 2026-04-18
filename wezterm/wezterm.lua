local wezterm = require 'wezterm'

local config = wezterm.config_builder()

config.color_scheme = 'OneHalfDark'
config.colors = {
	background = "#1e1e1e",
}
config.hide_tab_bar_if_only_one_tab = true
config.window_decorations = "RESIZE"
config.leader = { key = "a", mods = "CTRL" }
config.keys = {
	{ key = "t", mods = "CTRL", action = wezterm.action.SpawnTab('DefaultDomain') },
}
return config
