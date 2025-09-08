return {
  { -- Collection of various small independent plugins/modules
    "nvim-mini/mini.nvim",
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
      require("mini.surround").setup({
        custom_surroundings = {
          -- Bold: **text**
          ["b"] = {
            input = { "%*%*().-()%*%*" },
            output = { left = "**", right = "**" },
          },
          -- Italic: *text*
          ["i"] = {
            input = { "%*().-()%*" },
            output = { left = "*", right = "*" },
          },
          -- Code: `text`
          ["c"] = {
            input = { "`().-()`" },
            output = { left = "`", right = "`" },
          },
          ["s"] = {
            input = { "~~().-()~~" },
            output = { left = "~~", right = "~~" },
          },

          -- "l" for "link"
          ["l"] = {
            input = { "%b[]%b()", "^%b[]%([^)]-%)" }, -- detect [text](url)
            output = function()
              -- Get the visually selected text (works in operator/visual mode)
              local mode = vim.fn.mode()
              local sel = ""
              if mode:match("[vV]") then
                -- Use getreg('"') for visual selection (the unnamed register)
                sel = vim.fn.getreg("v")
              else
                -- Fallback: word under cursor
                sel = vim.fn.expand("<cWORD>")
              end

              if not sel or sel == "" then
                return nil
              end

              -- Check if it's a URL
              local is_url = sel:match("^.+://.+")

              if is_url then
                -- URL case → place URL in ()
                return {
                  left = "[](",
                  right = ")",
                }
              else
                -- Normal text case → put text in [] and cursor in ()
                return {
                  left = "[",
                  right = "]()",
                }
              end
            end,
          },
        },
      })
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
    keys = {
      -- Normal mode: format word under cursor (markdown only)
      { "gsb", "saiWb", desc = "Bold word", ft = "markdown", remap = true, mode = { "n", "v" } },
      { "gsi", "saiWi", desc = "Italic word", ft = "markdown", remap = true, mode = { "n", "v" } },
      { "gss", "saiWs", desc = "Strikethrough word", ft = "markdown", remap = true, mode = { "n", "v" } },
      { "gsc", "saiWc", desc = "Code word", ft = "markdown", remap = true, mode = { "n", "v" } }, -- Changed from C-c to avoid conflict
      { "gsl", "saiWl", desc = "Link word", ft = "markdown", remap = true, mode = { "n", "v" } },

      -- Remove formatting (markdown only)
      { "gsdb", "sdb", desc = "Remove bold", ft = "markdown", remap = true, mode = { "n", "v" } },
      { "gsdi", "sdi", desc = "Remove italic", ft = "markdown", remap = true, mode = { "n", "v" } },
      { "gsds", "sds", desc = "Remove strikethrough", ft = "markdown", remap = true, mode = { "n", "v" } },
      { "gsdc", "sdc", desc = "Remove code", ft = "markdown", remap = true, mode = { "n", "v" } },

      -- Headers and lists (markdown only)
      { "gs1", "I# <Esc>", desc = "H1 header", ft = "markdown", remap = true, mode = { "n", "v" } },
      { "gs2", "I## <Esc>", desc = "H2 header", ft = "markdown", remap = true, mode = { "n", "v" } },
      { "gs3", "I### <Esc>", desc = "H3 header", ft = "markdown", remap = true, mode = { "n", "v" } },
      { "gs4", "I#### <Esc>", desc = "H3 header", ft = "markdown", remap = true, mode = { "n", "v" } },
      { "gs5", "I##### <Esc>", desc = "H3 header", ft = "markdown", remap = true, mode = { "n", "v" } },
      { "gs6", "I###### <Esc>", desc = "H3 header", ft = "markdown", remap = true, mode = { "n", "v" } },
      { "gs-", "I- ", desc = "List item", ft = "markdown", remap = true, mode = { "n", "v" } },
      { "gs*", "I* ", desc = "List item", ft = "markdown", remap = true, mode = { "n", "v" } },
    },
  },
}
