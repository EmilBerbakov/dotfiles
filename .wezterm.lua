local wezterm = require("wezterm")
local config = wezterm.config_builder()
config.window_close_confirmation = "NeverPrompt"
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 2000 }

local function theme_switch(appearance)
	if appearance:find("Dark") then
		return "Catppuccin Mocha"
	else
		return "Catppuccin Latte"
	end
end

config.color_scheme = theme_switch(wezterm.gui.get_appearance())
local color_theme = wezterm.color.get_builtin_schemes()[theme_switch(wezterm.gui.get_appearance())]

local mux = wezterm.mux
wezterm.on("gui-startup", function(cmd)
	local _, _, window = mux.spawn_window(cmd or {})
	window:gui_window():maximize()
end)
config.tab_max_width = 100

local os_type = wezterm.target_triple

local use_fancy_titlebar = false
config.use_fancy_tab_bar = use_fancy_titlebar
config.tab_bar_at_bottom = true

--NOTE: This does not work

function Toggle_Fancy_Titlebar(swap)
	if swap == nil then
		swap = true
	end
	use_fancy_titlebar = swap and not use_fancy_titlebar
	if use_fancy_titlebar then
		config.window_frame = { active_titlebar_bg = "none" }
		config.window_decorations = "RESIZE | INTEGRATED_BUTTONS | TITLE"
		config.integrated_title_button_style = "Windows"
		wezterm.on("format-tab-title", function(tab)
			return {
				{ Background = { Color = "transparent" } },
				{ Text = "[" .. tab.tab_index + 1 .. "] " .. tab.active_pane.title },
			}
		end)
	else
		config.colors = {
			tab_bar = {
				background = color_theme.background,
			},
		}
	end
end

Toggle_Fancy_Titlebar(false)
wezterm.on("update-status", function(window)
	window:set_left_status(wezterm.format({
		{ Background = { Color = color_theme.foreground } },
		{ Foreground = { Color = color_theme.background } },
		{ Attribute = { Intensity = "Bold" } },
		{ Text = window:leader_is_active() and " LEADER " or "" },
	}))
end)

config.keys = {
	{
		key = "T",
		mods = "LEADER",
		action = wezterm.action_callback(Toggle_Fancy_Titlebar),
	},
}

if os_type == "x86_64-pc-windows-msvc" then
	--	local _, stdout, _ = wezterm.run_child_process({ "cmd.exe", "ver" })
	--	local _, _, build, _ = stdout:match("Version ([0-9]+)%.([0-9]+)%.([0-9]+)%.([0-9]+)")
	--	local is_windows_11 = tonumber(build) >= 22000
	--	if is_windows_11 and not use_fancy_titlebar then
	--NOTE: Can't combine this with window_decorations: https://github.com/wezterm/wezterm/issues/3598
	--		config.window_background_opacity = 0.5
	--		config.win32_system_backdrop = "Acrylic"

	-- NOTE: I was under the impression that these settings would make it more performant, but that doesn't seem to be the case. If anything, it was much worse
	--		config.webgpu_power_preference = "HighPerformance"
	--		config.front_end = "OpenGL"
	--		config.prefer_egl = true
	-- end
	config.default_prog = { "pwsh.exe", "-NoLogo" }
end

return config
