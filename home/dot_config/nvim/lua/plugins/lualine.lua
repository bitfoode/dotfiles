return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        section_separators = { left = "", right = "" },
        component_separators = { left = "", right = "" },
        disabled_filetypes = { statusline = vim.g.disabled_filetypes, winbar = vim.g.disabled_filetypes },
      },
      sections = {
        lualine_a = {
          {
            "mode",
          },
        },
        lualine_b = {
          {
            "branch",
            icon = "",
          },
          { "diff" },
          {
            "diagnostics",
          },
        },
      },
      theme = "tokyonight",
    },
  },
}
