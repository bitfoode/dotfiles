return {
  { -- You can easily change to a different colorscheme.
    -- Change the name of the colorscheme plugin below, and then
    -- change the command in the config to whatever the name of that colorscheme is.
    --
    -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
    "folke/tokyonight.nvim",
    priority = 1000, -- Make sure to load this before all the other start plugins.
    init = function()
      -- Load the colorscheme here.
      -- Like many other themes, this one has different styles, and you could load
      -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
      vim.cmd.colorscheme("tokyonight-night")
      local schemes = { "tokyonight-night", "tokyonight-day" }
      local i = 1
      local function toggle_colorscheme()
        i = i % #schemes + 1
        vim.cmd.colorscheme(schemes[i])
        print("Colorscheme: " .. schemes[i])
      end
      vim.keymap.set("n", "<leader>ts", toggle_colorscheme, { desc = "[T]oggle color[s]cheme" })

      -- You can configure highlights by doing something like:
      vim.cmd.hi("Comment gui=none")
    end,
  },
}
