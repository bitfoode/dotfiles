-- Configure the wezterm retro tab bar
local wezterm = require("wezterm")
local M = {}

-- Show that leader key is presset in right status (right corner of window)
local function set_right_status(window, pane)
	local LEFT_SIDE = ""
	local RIGHT_SIDE = ""
	local TEXT = {}

	-- Show  icon in right status if leader is pressed
	if window:leader_is_active() then
		table.insert(TEXT, " " .. wezterm.nerdfonts.dev_terminal_badge .. " ")
	end
	if window:active_key_table() then
		table.insert(TEXT, wezterm.nerdfonts.fa_arrows .. ": " .. window:active_key_table())
	end

	for _, pane_info in ipairs(window:active_tab():panes_with_info()) do
		if pane_info.is_zoomed then
			table.insert(TEXT, wezterm.nerdfonts.md_magnify .. ": zoomed")
		end
	end

	if #TEXT > 0 then
		LEFT_SIDE = wezterm.nerdfonts.ple_left_half_circle_thick
		RIGHT_SIDE = wezterm.nerdfonts.ple_right_half_circle_thick
	end

	local STATUS = {}
	for _, text in ipairs(TEXT) do
		table.insert(STATUS, { Foreground = { Color = "#7aa2f7" } })
		table.insert(STATUS, { Background = { Color = "#1f2335" } })
		table.insert(STATUS, { Text = LEFT_SIDE })
		table.insert(STATUS, { Foreground = { Color = "#1f2335" } })
		table.insert(STATUS, { Background = { Color = "#7aa2f7" } })
		table.insert(STATUS, { Text = text })
		table.insert(STATUS, { Foreground = { Color = "#7aa2f7" } })
		table.insert(STATUS, { Background = { Color = "#1f2335" } })
		table.insert(STATUS, { Text = RIGHT_SIDE })
	end
	window:set_right_status(wezterm.format(STATUS))
end

-- Format tab bar and text of each tab
local function format_tab_title(tab, _, _, config, hover, _)
	-- The filled in variant of the  symbol
	local LEFT_SIDE = wezterm.nerdfonts.ple_left_half_circle_thick

	-- The filled in variant of the  symbol
	local RIGHT_SIDE = wezterm.nerdfonts.ple_right_half_circle_thick

	local tab_title = tab.active_pane.title

	if tab.tab_title and #tab.tab_title > 0 then
		tab_title = tab.tab_title
	end

	-- Tab text, limited to 14 characters
	-- Default length of content text is 16 characters.
	-- LEFT_SIDE and RIGHT_SIDE teakes on char, means 2-16 = 14
	-- 14 characters left for displaying text
	tab_title = string.sub((tab.tab_index + 1) .. ": " .. tab_title, 1, config.tab_max_width - 2)

	-- Color settings for active tabs
	if tab.is_active then
		return {
			{ Foreground = { Color = "#7aa2f7" } },
			{ Background = { Color = "#1f2335" } },
			{ Text = LEFT_SIDE },
			{ Foreground = { Color = "#1f2335" } },
			{ Background = { Color = "#7aa2f7" } },
			{ Text = tab_title },
			{ Foreground = { Color = "#7aa2f7" } },
			{ Background = { Color = "#1f2335" } },
			{ Text = RIGHT_SIDE },
		}
	end
	-- Change text color on when mouse hovers over tab
	if hover then
		return {
			{ Foreground = { Color = "#545c7e" } },
			{ Background = { Color = "#292e42" } },
			{ Text = LEFT_SIDE },
			{ Background = { Color = "#545c7e" } },
			{ Foreground = { Color = "#7aa2f7" } },
			{ Attribute = { Intensity = "Bold" } },
			{ Text = tab_title },
			{ Foreground = { Color = "#545c7e" } },
			{ Background = { Color = "#292e42" } },
			{ Text = RIGHT_SIDE },
		}
	end
	-- Color setting for inactive tabs
	return {
		{ Foreground = { Color = "#545c7e" } },
		{ Background = { Color = "#292e42" } },
		{ Text = LEFT_SIDE },
		{ Background = { Color = "#545c7e" } },
		{ Foreground = { Color = "#292e42" } },
		{ Text = tab_title },
		{ Foreground = { Color = "#545c7e" } },
		{ Background = { Color = "#292e42" } },
		{ Text = RIGHT_SIDE },
	}
end

function M.setup()
	wezterm.on("format-tab-title", format_tab_title)
	wezterm.on("update-status", set_right_status)
end

return M
