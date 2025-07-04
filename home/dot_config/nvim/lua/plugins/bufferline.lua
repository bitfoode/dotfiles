return {
  {
    "akinsho/bufferline.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      vim.o.termguicolors = true
      local bl = require("bufferline")
      bl.setup({
        options = {
          mode = "buffers",
          style_presets = bl.style_preset.no_bold,
          indicator = { style = "underline" },
          diagnostics = "nvim_lsp",
          diagnostics_indicator = function(count, level, _, context)
            if context.buffer:current() then
              return ""
            end

            local icon = level:match("error") and " " or " "
            return " " .. icon .. count
          end,
          offsets = {
            {
              filetype = "neo-tree",
              text = "Neo-Tree",
              highlight = "Directory",
              text_align = "center",
            },
          },
          separator_style = "slant",
          show_close_icon = false,
          show_buffer_close_icons = false,
          move_wraps_at_ends = true,
        },
      })
      -- Keymaps
      -- Cycle through buffers
      -- Show Next buffer
      vim.keymap.set("n", "<C-Tab>", function()
        bl.cycle(1)
      end, { desc = "Show [N]ext buffer", silent = true })
      vim.keymap.set("n", "<leader>bn", function()
        bl.cycle(1)
      end, { desc = "Show [N]ext buffer", silent = true })

      -- Show previous buffer
      vim.keymap.set("n", "<S-C-Tab>", function()
        bl.cycle(-1)
      end, { desc = "Show [P]revious buffer", silent = true })
      vim.keymap.set("n", "<leader>bp", function()
        bl.cycle(-1)
      end, { desc = "Show [P]revious buffer", silent = true })

      -- Choose buffer
      vim.keymap.set("n", "<leader>bc", function()
        bl.pick()
      end, { desc = "[C]hoose buffer", silent = false })

      -- Move a buffer
      vim.keymap.set("n", "<leader>br", function()
        bl.move(1)
      end, { desc = "Move buffer to [R]ight", silent = false })
      vim.keymap.set("n", "<leader>bl", function()
        bl.move(-1)
      end, { desc = "Move buffer to [L]eft", silent = false })
    end,
  },
}
