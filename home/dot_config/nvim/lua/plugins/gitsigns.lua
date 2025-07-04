return {
  {
    -- Adds git related signs to the gutter, as well as utilities for managing changes
    "lewis6991/gitsigns.nvim",
    cfg = {
      numhl = true,
      current_line_blame = true,
      current_line_blame_opts = {
        delay = 500,
        use_focus = false,
      },
      current_line_blame_formatter = "<author>, <author_time:%R> - <summary> | <abbrev_sha>",
      signs = {
        add = { text = "+" },
        change = { text = "Δ" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
    },
  },
}
