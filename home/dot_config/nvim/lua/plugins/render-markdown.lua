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
      right_pad = 1,
    },
    completions = {
      lsp = {
        enabled = true,
      },
    },
  },
  init = function()
    -- Put this in your init.lua or a plugin file

    -- Umlaut and sharp S mappings
    local umlaut_map = {
      ae = "ä",
      ue = "ü",
      oe = "ö",
      Ae = "Ä",
      Ue = "Ü",
      Oe = "Ö",
      ss = "ß",
    }

    local function set_colon_umlaut_mappings()
      local opts = { expr = true, noremap = true, buffer = true }

      for lhs, char in pairs(umlaut_map) do
        vim.keymap.set("i", lhs .. ":", function()
          -- Remove colon and the letters typed, insert the umlaut/ß
          return char
        end, opts)
        vim.keymap.set("i", ":" .. lhs, function()
          -- Remove colon and the letters typed, insert the umlaut/ß
          return char
        end, opts)
      end
    end

    -- Apply only to markdown files
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "markdown",
      callback = set_colon_umlaut_mappings,
    })
  end,
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
