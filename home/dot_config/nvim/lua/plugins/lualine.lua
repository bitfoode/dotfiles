return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = { disabled_filetypes = { statusline = vim.g.disabled_filetypes, winbar = vim.g.disabled_filetypes } },
      theme = "tokyonight",
    },
  },
}
