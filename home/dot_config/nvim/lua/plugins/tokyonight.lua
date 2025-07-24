return {
  { -- You can easily change to a different colorscheme.
    -- Change the name of the colorscheme plugin below, and then
    -- change the command in the config to whatever the name of that colorscheme is.
    "folke/tokyonight.nvim",
    priority = 1000, -- Make sure to load this before all the other start plugins.
    init = function()
      -- Load the colorscheme here.
      -- Like many other themes, this one has different styles, and you could load
      -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
      vim.cmd.colorscheme("tokyonight-night")

      -- You can configure highlights by doing something like:
      vim.cmd.hi("Comment gui=none")
    end,
    keys = {
      {
        "<leader>ts",
        function()
          local active_coloscheme = vim.g.colors_name
          if active_coloscheme == "tokyonight-day" then
            vim.cmd.colorscheme("tokyonight-night")
          else
            vim.cmd.colorscheme("tokyonight-day")
          end
          print("Colorscheme: " .. vim.g.colors_name)
        end,
      },
    },
  },
}
