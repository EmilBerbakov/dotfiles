local wezterm = require("wezterm")
local config = wezterm.config_builder()
config.window_close_confirmation = "NeverPrompt"
config.color_scheme = "Catppuccin Mocha"
local mux = wezterm.mux
wezterm.on("gui-startup", function(cmd)
	local _, _, window = mux.spawn_window(cmd or {})
	window:gui_window():maximize()
end)
config.font = wezterm.font_with_fallback({
	"JetBrains Mono",
})
config.tab_max_width = 100

local os_type = wezterm.target_triple

if os_type == "x86_64-pc-windows-msvc" then
	local _, stdout, _ = wezterm.run_child_process({ "cmd.exe", "ver" })
	local _, _, build, _ = stdout:match("Version ([0-9]+)%.([0-9]+)%.([0-9]+)%.([0-9]+)")
	local is_windows_11 = tonumber(build) >= 22000
	if is_windows_11 then
		config.window_background_opacity = 0.5
		config.win32_system_backdrop = "Acrylic"
		config.webgpu_power_preference = "HighPerformance"
		config.front_end = "OpenGL"
		config.prefer_egl = true
	end
	config.default_prog = { "pwsh.exe", "-NoLogo" }
	config.use_fancy_tab_bar = true
end

config.window_frame = { active_titlebar_bg = "none" }
config.tab_bar_at_bottom = true

return config
