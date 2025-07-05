-- Pull in the wezterm API
local wezterm = require("wezterm")
local keys = require("keys")
require("tabbar").setup()

-- Initialize config if config_builde is available us it
local config = {}
if wezterm.config_builder then
  config = wezterm.config_builder()
end
config.tab_and_split_indices_are_zero_based = false
---------------------------------
-- Add values to configuration --
---------------------------------
config.scrollback_lines = 100000
-- Default color schemes to toggle betwenn dark/light --
local color_schemes = { "tokyonight_storm", "tokyonight_day" }
-- Appearance configuration options --
config.color_scheme = color_schemes[1]

-- Insert keybinding for toggle color_scheme
table.insert(keys.key_bindings, {
  mods = "LEADER",
  key = "s",
  action = wezterm.action_callback(function(win, pane)
    -- Get current overrides or default scheme
    local overrides = win:get_config_overrides() or {}
    local current_scheme = overrides.color_scheme or config.color_scheme

    -- Find current scheme index
    local current_index = 1
    for i, scheme in ipairs(color_schemes) do
      if scheme == current_scheme then
        current_index = i
        break
      end
    end

    -- Compute next scheme index
    local next_index = (current_index % #color_schemes) + 1
    local next_scheme = color_schemes[next_index]

    -- Apply next scheme
    win:set_config_overrides({
      color_scheme = next_scheme,
    })

    wezterm.log_info("Switched to color scheme: " .. next_scheme)
  end),
})
-- Configure command pallete colors
config.command_palette_bg_color = "#24283b"
config.command_palette_fg_color = "#c0caf5"
-- Set fonts and fallback fonts
config.font = wezterm.font_with_fallback({
  { family = "FiraCode Nerd Font Mono" },
  { family = "UbuntuMono Nerd Font", scale = 1.2 },
})
config.font_size = 14
-- Do not adjust the window size if changing font size
config.adjust_window_size_when_changing_font_size = false
-- How many rows the command pallete will have
config.command_palette_rows = 15
-- Increase font size of command pallete slightly
config.command_palette_font_size = 16
-- Increase font size for smiley and special character pallete
config.char_select_font_size = config.command_palette_font_size
-- Show the tab bar but do not use the fancy one but the
-- more defaulty one, which inherits also the color_scheme
config.show_tabs_in_tab_bar = true
config.use_fancy_tab_bar = false
-- If there is only one tab/session opened,
-- the tabbar will be hidden
config.hide_tab_bar_if_only_one_tab = false
-- Disable the + signe to enable creating new tabs
config.show_new_tab_button_in_tab_bar = false
-- Switch to the last active tab instead of the left hand tab
config.switch_to_last_active_tab_when_closing_tab = true
config.tab_bar_at_bottom = true
config.tab_max_width = 25
-- Remove titlebar, integrated buttons from wezterm
config.window_decorations = "RESIZE"
-- Keep cursor as a Block without blinking
config.default_cursor_style = "SteadyBlock"
-- Reverts colors from cursor, it enables fancy colors
config.force_reverse_video_cursor = true
-- Controls the amount of padding between the window border and the terminal cells.
config.window_padding = { left = 2, right = 2, top = 2, bottom = 2 }
-- Disbable scrollbar
config.enable_scroll_bar = false
-- Hide mouse cursor as soon as typing started
config.hide_mouse_cursor_when_typing = true
-- Disable audio bell when \a is issued
config.audible_bell = "Disabled"

-- Scroll window/pane to the bottom when input is inserted
config.scroll_to_bottom_on_input = true
-- Sent mouse click directly to the terminal instead of just selecting the
-- terminal, on MacOS `true` is the default, but on other systems not,
-- changed to have a consistent behavior on all systems
config.swallow_mouse_click_on_window_focus = true
-- Disable update check
config.check_for_updates = false
-- Commented until https://github.com/wez/wezterm/issues/5142 is fixed
-- Start wezterm like a tmux session
-- config.unix_domains = {
-- 	{
-- 		name = "unix",
-- 	},
-- }
-- This causes `wezterm` to act as though it was started as
-- `wezterm connect unix` by default, connecting to the unix
-- domain on startup.
-- If you prefer to connect manually, leave out this line.
-- config.default_gui_startup_args = { "connect", "unix" }

-- Set leader keys and key_tables
config.disable_default_key_bindings = keys.disable_default_key_bindings
config.leader = keys.key_leader
config.keys = keys.key_bindings
config.key_tables = keys.key_tables

-- extra configuration
require("hyperlink_rules").setup(config)

-- Return config object
return config
