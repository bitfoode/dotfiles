return {
  { -- Collection of various small independent plugins/modules
    "echasnovski/mini.nvim",
    config = function()
      require("mini.pairs").setup({})
      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yin' - [Y]ank [I]nside [N]ext [']quote
      --  - ci'  - [C]hange [I]nside [']quote
      require("mini.ai").setup({ n_lines = 500 })

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      --
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      require("mini.surround").setup()
      require("mini.comment").setup({})
      require("mini.move").setup({
        mappings = {
          -- Move visual selection in Visual mode. Defaults are Alt (Meta) + hjkl.
          left = "<C-M-h>",
          right = "<C-M-l>",
          down = "<C-M-j>",
          up = "<C-M-k>",

          -- Move current line in Normal mode
          line_left = "<C-M-h>",
          line_right = "<C-M-l>",
          line_down = "<C-M-j>",
          line_up = "<C-M-k>",
        },
      })
    end,
  },
}
