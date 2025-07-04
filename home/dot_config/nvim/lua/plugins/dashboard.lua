return {
  {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    opts = {
      shortcut_type = "letter",
      shuffle_letter = false,
      hide = {
        statusline = true, -- hide statusline default is true
        tabline = true, -- hide the tabline
        winbar = true, -- hide winbar
      },
      theme = "hyper",
      config = {
        week_header = {
          enable = true,
        },
        disable_move = false,
        shortcut = {
          { desc = "󰊳 Update", group = "@property", action = "Lazy update", key = "u" },
          {
            icon = " ",
            icon_hl = "@variable",
            desc = "Files",
            group = "Label",
            action = "Telescope find_files",
            key = "f",
          },
          {
            desc = " Dots",
            group = "NvimNumber",
            action = function()
              local t = require("telescope.builtin")
              t.find_files({ cwd = vim.fn.expand("$HOME/git/gitlab.com/bitfooxyz/dots") })
            end,
            key = "d",
          },
          {
            desc = " Help",
            group = "NvimNumber",
            action = "Telescope help_tags",
            key = "h",
          },
        },
        mru = { limit = 15, cwd = true },
      },
    },
    dependencies = { { "nvim-tree/nvim-web-devicons" } },
  },
}
