local wezterm = require("wezterm")
local secrets = require("secrets")

local M = {}

function M.setup(config)
  -- Use the defaults as a base
  config.hyperlink_rules = wezterm.default_hyperlink_rules()

  -- Regex represents typical Jira Ticket Numbers like TEST-1234
  if secrets.jira_url then
    table.insert(config.hyperlink_rules, {
      regex = [[\b([A-Z][A-Z0-9_]+-[1-9][0-9]*)]],
      format = secrets.jira_url .. "$1",
    })
  end
end

return M
