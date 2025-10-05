-- German Umlaut Substitution Plugin for Neovim
-- This plugin provides configurable umlaut substitution on a per-buffer basis
-- using key mappings with timeout-based escape mechanism

---@class UmlautConfig
---@field enabled_filetypes string[] List of filetypes where umlaut substitution is auto-enabled
---@field mappings table<string, string> Custom mappings for umlaut substitution (default: ae->ä, oe->ö, ue->ü, ss->ß)
---@field timeout_ms number Timeout in milliseconds for key sequences (default: 150)

---@class UmlautState
---@field enabled_buffers table<number, boolean> Track which buffers have umlauts enabled

local M = {}

-- Default configuration
---@type UmlautConfig
local default_config = {
  enabled_filetypes = { "markdown", "text", "mail" },
  mappings = {
    ["ae"] = "ä",
    ["oe"] = "ö",
    ["ue"] = "ü",
    ["Ae"] = "Ä",
    ["Oe"] = "Ö",
    ["Ue"] = "Ü",
    ["ss"] = "ß",
  },
  timeout_ms = 150,
}

-- Plugin state
---@type UmlautState
local state = {
  enabled_buffers = {},
}

-- Current configuration
---@type UmlautConfig
local config = vim.deepcopy(default_config)

---Setup key mappings for the current buffer
---@param bufnr number Buffer number
local function setup_buffer_mappings(bufnr)
  for trigger, replacement in pairs(config.mappings) do
    vim.keymap.set("i", trigger, replacement, {
      buffer = bufnr,
      desc = string.format("Substitute %s with %s", trigger, replacement),
    })
  end
end

---Remove key mappings from the current buffer
---@param bufnr number Buffer number
local function remove_buffer_mappings(bufnr)
  for trigger, _ in pairs(config.mappings) do
    pcall(function()
      vim.keymap.del("i", trigger, { buffer = bufnr })
    end)
  end
end

---Enable umlaut substitution for a specific buffer
---@param bufnr number|nil Buffer number (nil for current buffer)
function M.enable(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()

  if not state.enabled_buffers[bufnr] then
    state.enabled_buffers[bufnr] = true
    setup_buffer_mappings(bufnr)
    vim.notify("Umlaut substitution enabled for current buffer", vim.log.levels.INFO)
  end
end

---Disable umlaut substitution for a specific buffer
---@param bufnr number|nil Buffer number (nil for current buffer)
function M.disable(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()

  if state.enabled_buffers[bufnr] then
    state.enabled_buffers[bufnr] = nil
    remove_buffer_mappings(bufnr)
    vim.notify("Umlaut substitution disabled for current buffer", vim.log.levels.INFO)
  end
end

---Disable umlaut substitution in all opened buffers
function M.disable_all()
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if state.enabled_buffers[bufnr] then
      M.disable(bufnr)
    end
  end
  vim.notify("Umlaut substitution disabled for all buffers", vim.log.levels.INFO)
end

---Enable umlaut substitution in all opened buffers
function M.enable_all()
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(bufnr) and vim.api.nvim_buf_is_loaded(bufnr) then
      M.enable(bufnr)
    end
  end
  vim.notify("Umlaut substitution enabled for all buffers", vim.log.levels.INFO)
end

---Toggle umlaut substitution for a specific buffer
---@param bufnr number|nil Buffer number (nil for current buffer)
function M.toggle(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  if state.enabled_buffers[bufnr] then
    M.disable(bufnr)
  else
    M.enable(bufnr)
  end
end

---Check if the current filetype should have umlauts enabled
---@param filetype string
---@return boolean
local function should_enable_for_filetype(filetype)
  for _, ft in ipairs(config.enabled_filetypes) do
    if ft == filetype then
      return true
    end
  end
  return false
end

---Setup autocommands for filetype-based enabling
local function setup_autocommands()
  local group = vim.api.nvim_create_augroup("UmlautSubstitution", { clear = true })

  -- Enable for configured filetypes
  vim.api.nvim_create_autocmd("FileType", {
    group = group,
    callback = function(args)
      if should_enable_for_filetype(vim.bo[args.buf].filetype) then
        M.enable(args.buf)
      end
    end,
  })

  -- Clean up state when buffer is deleted
  vim.api.nvim_create_autocmd("BufDelete", {
    group = group,
    callback = function(args)
      state.enabled_buffers[args.buf] = nil
    end,
  })
end

---Setup the plugin with user configuration
---@param user_config UmlautConfig|nil User configuration options
function M.setup(user_config)
  -- Merge user config with defaults
  config = vim.tbl_deep_extend("force", default_config, user_config or {})

  -- Set the timeout option for key mappings
  vim.opt.timeoutlen = config.timeout_ms

  -- Setup autocommands
  setup_autocommands()

  -- Create user commands
  vim.api.nvim_create_user_command("UmlautEnable", function()
    M.enable()
  end, { desc = "Enable umlaut substitution for current buffer" })

  vim.api.nvim_create_user_command("UmlautDisable", function()
    M.disable()
  end, { desc = "Disable umlaut substitution for current buffer" })

  vim.api.nvim_create_user_command("UmlautToggle", function()
    M.toggle()
  end, { desc = "Toggle umlaut substitution for current buffer" })

  -- Set up a keybinding for toggling
  vim.keymap.set("n", "<leader>u", M.toggle, { desc = "Toggle umlaut substitution" })
end

---Get the current state (for debugging)
---@return UmlautState
function M.get_state()
  return vim.deepcopy(state)
end

return M
