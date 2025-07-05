local wezterm = require("wezterm")
local act = wezterm.action

local M = {}

local function set_tab_title(window, _, line)
  if line then
    window:active_tab():set_title(line)
  end
end

M.key_leader = { mods = "META", key = "Space", timeout_milliseconds = 3000 }
-- Disable internal keybindings
M.disable_default_key_bindings = true

M.key_bindings = {
  -- Create a new Tab in the current domain/session
  { mods = "LEADER", key = "c", action = act.SpawnTab("CurrentPaneDomain") },
  -- Close current tab and ask for confirmation
  { mods = "LEADER", key = "x", action = act.CloseCurrentPane({ confirm = true }) },
  -- Force close current tab
  { mods = "LEADER", key = "X", action = act.CloseCurrentPane({ confirm = false }) },
  -- Go one tab to right, it is relative to active tab.
  { mods = "LEADER", key = "n", action = act.ActivateTabRelative(1) },
  -- Go one tab to left, it is relative to active tab.
  { mods = "LEADER", key = "b", action = act.ActivateTabRelative(-1) },
  -- Use either \ or | to split current pane horizontaly
  { mods = "LEADER", key = "|", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
  { mods = "LEADER", key = "\\", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
  -- Split current pane vertically
  { mods = "LEADER", key = "-", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
  { mods = "LEADER", key = "u", action = act.ScrollByPage(-1) },
  { mods = "LEADER", key = "d", action = act.ScrollByPage(1) },
  { mods = "LEADER", key = "y", action = act.ActivateCopyMode },
  { mods = "LEADER", key = "q", action = act.QuickSelect },
  -- 'activate_pane' here corresponds to the name="activate_pane" in
  -- the key assignments above.
  { mods = "LEADER", key = "h", action = act.ActivatePaneDirection("Left") },
  { mods = "LEADER", key = "l", action = act.ActivatePaneDirection("Right") },
  { mods = "LEADER", key = "k", action = act.ActivatePaneDirection("Up") },
  { mods = "LEADER", key = "j", action = act.ActivatePaneDirection("Down") },
  -- System new key_bindings
  { mods = "SHIFT|CTRL", key = "c", action = act.CopyTo("Clipboard") },
  { mods = "SHIFT|CTRL", key = "v", action = act.PasteFrom("Clipboard") },
  { mods = "SHIFT|CTRL", key = "0", action = act.ResetFontSize },
  { mods = "SHIFT|CTRL", key = "+", action = act.IncreaseFontSize },
  { mods = "SHIFT|CTRL", key = "-", action = act.DecreaseFontSize },
  { mods = "SHIFT|CTRL", key = "k", action = act.ClearScrollback("ScrollbackOnly") },
  { mods = "SHIFT|CTRL", key = "l", action = act.ShowDebugOverlay },
  { mods = "SHIFT|CTRL", key = "n", action = act.SpawnWindow },
  { mods = "SHIFT|CTRL", key = "p", action = act.ActivateCommandPalette },
  { mods = "SHIFT|CTRL", key = "r", action = act.ReloadConfiguration },
  { mods = "SHIFT|CTRL", key = "y", action = act.ActivateCopyMode },
  { mods = "SHIFT|CTRL", key = "z", action = act.TogglePaneZoomState },
  { mods = "SHIFT|CTRL", key = "q", action = act.QuitApplication },
  { mods = "SHIFT|CTRL", key = "w", action = act.CloseCurrentTab({ confirm = true }) },
  { mods = "SHIFT|CTRL", key = "phys:Space", action = act.QuickSelect },
  { mods = "SHIFT|CTRL", key = "f", action = act.Search("CurrentSelectionOrEmptyString") },
  {
    mods = "SHIFT|CTRL",
    key = "u",
    action = act.CharSelect({ copy_on_select = true, copy_to = "ClipboardAndPrimarySelection" }),
  },

  -- CTRL+Space, followed by 'r' will put us in resize-pane
  -- mode until we cancel that mode.
  { mods = "LEADER", key = "r", action = act.ActivateKeyTable({ name = "resize_pane", one_shot = false }) },
  -- CTRL+Space, followed by 'p' will put us in `panes`
  -- mode until we press some other key or until 1 second (1000ms)
  -- of time elapses
  { mods = "LEADER", key = "p", action = act.ActivateKeyTable({ name = "panes", one_shot = false }) },
  -- CTRL+Space, followed by 't' will put us in `tabs` mode
  -- until we press some other key or until 1 second (1000ms)
  -- of time elapses
  { mods = "LEADER", key = "t", action = act.ActivateKeyTable({ name = "tabs", one_shot = false }) },
}

M.key_tables = {
  panes = {
    { key = "j", action = act.ScrollByPage(1) },
    { key = "d", action = act.ScrollByPage(1) },
    { key = "k", action = act.ScrollByPage(-1) },
    { key = "u", action = act.ScrollByPage(-1) },

    {
      key = "s",
      action = act.Multiple({
        act.PaneSelect({ alphabet = "asdfghjklweruio", mode = "SwapWithActiveKeepFocus" }),
        act.PopKeyTable,
      }),
    },
    {
      key = "g",
      action = act.Multiple({
        act.PaneSelect({ alphabet = "asdfghjklweruio", mode = "Activate" }),
        act.PopKeyTable,
      }),
    },
    -- Cancel the mode by pressing escape
    { key = "Escape", action = "PopKeyTable" },
  },
  -- Defines keys that are specific to tab configuration and arrangement
  tabs = {
    -- Rename active tab with input
    {
      key = "r",
      action = act.Multiple({
        act.PromptInputLine({
          description = "Enter new tab name:",
          action = wezterm.action_callback(set_tab_title),
        }),
        act.PopKeyTable,
      }),
    },
    -- Move active tab to left
    { key = "h", action = act.MoveTabRelative(-1) },
    -- Move active tab to right
    { key = "l", action = act.MoveTabRelative(1) },
    -- Cancel the mode by pressing escape
    { key = "Escape", action = "PopKeyTable" },
  },
  -- Defines the keys that are active in our resize-pane mode.
  -- Since we're likely to want to make multiple adjustments,
  -- we made the activation one_shot=false. We therefore need
  -- to define a key assignment for getting out of this mode.
  -- 'resize_pane' here corresponds to the name="resize_pane" in
  -- the key assignments above.
  resize_pane = {
    { key = "h", action = act.AdjustPaneSize({ "Left", 1 }) },
    { key = "l", action = act.AdjustPaneSize({ "Right", 1 }) },
    { key = "k", action = act.AdjustPaneSize({ "Up", 1 }) },
    { key = "j", action = act.AdjustPaneSize({ "Down", 1 }) },

    -- Cancel the mode by pressing escape
    { key = "Escape", action = "PopKeyTable" },
  },
  copy_mode = {
    { key = "Escape", action = act.CopyMode("Close") },
    { key = "Enter", action = act.CopyMode("MoveToStartOfNextLine") },
    { key = "h", action = act.CopyMode("MoveLeft") },
    { key = "j", action = act.CopyMode("MoveDown") },
    { key = "k", action = act.CopyMode("MoveUp") },
    { key = "l", action = act.CopyMode("MoveRight") },
    { key = "d", action = act.CopyMode({ MoveByPage = 0.5 }) },
    { key = "u", action = act.CopyMode({ MoveByPage = -0.5 }) },
    { key = "w", action = act.CopyMode("MoveForwardWord") },
    { key = "b", action = act.CopyMode("MoveBackwardWord") },
    { key = "e", action = act.CopyMode("MoveForwardWordEnd") },
    { key = "$", action = act.CopyMode("MoveToEndOfLineContent") },
    { key = "0", action = act.CopyMode("MoveToStartOfLine") },
    { key = "g", action = act.CopyMode("MoveToScrollbackTop") },
    { mods = "CTRL", key = "g", action = act.CopyMode("MoveToViewportTop") },
    { key = "G", action = act.CopyMode("MoveToScrollbackBottom") },
    { mods = "CTRL", key = "G", action = act.CopyMode("MoveToViewportBottom") },
    { key = "v", action = act.CopyMode({ SetSelectionMode = "Cell" }) },
    { key = "V", action = act.CopyMode({ SetSelectionMode = "Line" }) },
    { mods = "CTRL", key = "v", action = act.CopyMode({ SetSelectionMode = "Block" }) },
    {
      key = "y",
      action = act.Multiple({ { CopyTo = "ClipboardAndPrimarySelection" }, { CopyMode = "Close" } }),
    },
  },
  search_mode = {
    { key = "Escape", action = act.CopyMode("Close") },
    { mods = "CTRL", key = "Enter", action = act.CopyMode("NextMatch") },
    { mods = "CTRL", key = "n", action = act.CopyMode("NextMatch") },
    { mods = "CTRL", key = "N", action = act.CopyMode("PriorMatch") },
    { mods = "CTRL", key = "c", action = act.CopyMode("ClearPattern") },
    { mods = "CTRL", key = "r", action = act.CopyMode("CycleMatchType") },
  },
}

-- Associate LEADER+0-9 to activate tab
-- Associate LEADER+t+0-9 to switch tab to n possition
for n = 0, 9 do
  -- Tabs are always indexed starting from zero,
  -- regardless of the tab_and_split_indices_are_zero_based setting.
  -- To activate the 10th tab with keystroke 0, use tab index 9.
  -- For all other keystrokes, subtract one from the number to activate the correct tab.
  -- Regardless of tab_and_split_indices_are_zero_based option, all tabs are indexed
  -- beginning from zero, therefore some computation as to be done
  -- For keystorke 0, activate the 10th tab meaning tab index 9, for all other
  -- substract one from number to activate correct tab
  if n == 0 then
    table.insert(M.key_bindings, { mods = "LEADER", key = tostring(n), action = act.ActivateTab(9) })
    table.insert(M.key_tables.tabs, { key = tostring(n), action = act.MoveTab(9) })
  else
    table.insert(M.key_bindings, { mods = "LEADER", key = tostring(n), action = act.ActivateTab(n - 1) })
    table.insert(M.key_tables.tabs, { key = tostring(n), action = act.MoveTab(n - 1) })
  end
end

if string.find(wezterm.target_triple, "apple%-darwin") then
  table.insert(M.key_bindings, { mods = "SUPER", key = "c", action = act.CopyTo("Clipboard") })
  table.insert(M.key_bindings, { mods = "SUPER", key = "v", action = act.PasteFrom("Clipboard") })
  table.insert(M.key_bindings, { mods = "SUPER", key = "n", action = act.SpawnWindow })
  table.insert(M.key_bindings, { mods = "SUPER", key = "q", action = act.QuitApplication })
  table.insert(M.key_bindings, { mods = "SUPER", key = "w", action = act.CloseCurrentTab({ confirm = true }) })
  table.insert(M.key_bindings, { mods = "SUPER", key = "f", action = act.Search("CurrentSelectionOrEmptyString") })
end
return M
