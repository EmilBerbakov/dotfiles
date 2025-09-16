local wezterm = require("wezterm")
local config = wezterm.config_builder()
-- Don't think this works the way I think it does
-- config.set_environment_variables = {
-- 	HAS_NERD_FONT = 1,
-- }
config.default_prog = { "pwsh.exe", "-NoLogo" }
local mux = wezterm.mux
wezterm.on("gui-startup", function(cmd)
	local tab, pane, window = mux.spawn_window(cmd or {})
	window:gui_window():maximize()
end) -- end)
config.font = wezterm.font_with_fallback({
	"JetBrains Mono",
})
config.use_fancy_tab_bar = false
--:config.tab_bar_at_bottom = true
config.color_scheme = "Catppuccin Mocha"
config.window_background_opacity = 0.5
config.win32_system_backdrop = "Acrylic"
return config
