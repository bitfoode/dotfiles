return {
  "MeanderingProgrammer/render-markdown.nvim",
  ft = { "markdown" },
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  ---@module 'render-markdown'
  ---@type render.md.UserConfig
  opts = {
    render_modes = { "n", "c", "t" },
    heading = {
      position = "inline",
      icons = { "󰬺 ", "󰬻 ", "󰬼 ", "󰬽 ", "󰬾 ", "󰬿 " },
    },
    code = {
      width = "block",
      right_pad = 1,
    },
    completions = {
      lsp = {
        enabled = true,
      },
    },
  },
  keys = {
    {
      "<leader>tm",
      function()
        require("render-markdown").set()
      end,
      desc = "[T]oggle [M]arkdown rendering",
    },
  },
}
