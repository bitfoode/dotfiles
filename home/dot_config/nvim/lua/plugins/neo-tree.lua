return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    events = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    opts = {
      sort_case_insensitive = true,
      popup_border_style = "rounded",
      use_popups_for_input = true,
      source_selector = {
        winbar = true, -- toggle to show selector on winbar
      },
      default_component_configs = {
        indent = {
          expander_collapsed = "",
          expander_expanded = "",
          expander_highlight = "NeoTreeExpander",
          indent_marker = "│",
          indent_size = 2,
          last_indent_marker = "└",
          with_expanders = true,
          with_markers = true,
        },
        name = {
          trailing_slash = true,
          highlight_opened_files = true,
        },
        git_status = {
          symbols = { modified = "Δ" },
        },
      },
    },
    init = function()
      vim.keymap.set("n", "<leader>te", function()
        require("neo-tree.command").execute({ toggle = true, action = "focus", source = "filesystem", reveal = true })
      end, { desc = "Toggle NeoTree file [E]xplorer" })
    end,
  },
}
