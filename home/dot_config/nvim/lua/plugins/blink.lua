return {

  {
    "saghen/blink.cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    -- optional: provides snippets for the snippet source
    dependencies = {
      {
        "saghen/blink.compat",
        -- use v2.* for blink.cmp v1.*
        version = "2.*",
        -- lazy.nvim will automatically load the plugin when it's required by blink.cmp
        lazy = true,
        -- make sure to set opts so that lazy.nvim calls blink.compat's setup
        opts = {},
      },
      "rafamadriz/friendly-snippets",
      "onsails/lspkind.nvim",
      "nvim-tree/nvim-web-devicons",
      "moyiz/blink-emoji.nvim",
      "bydlw98/blink-cmp-env",
      "disrupted/blink-cmp-conventional-commits",
      "dmitmel/cmp-digraphs",
      "hrsh7th/cmp-calc",
    },
    -- use a release tag to download pre-built binaries
    version = "1.*",
    config = function()
      local blink = require("blink-cmp")

      local highlight = function(ctx)
        local hl = ctx.kind_hl
        if vim.tbl_contains({ "Path" }, ctx.source_name) then
          local dev_icon, dev_hl = require("nvim-web-devicons").get_icon(ctx.label)
          if dev_icon then
            hl = dev_hl
          end
        end
        return hl
      end

      ---@module 'blink.cmp'
      ---@type blink.cmp.Config
      blink.setup({
        enabled = function()
          -- Disabled to ensure no completion if using typr
          if vim.bo.filetype == "typr" then
            return false
          end
          return true
        end,
        sources = {
          default = { "lsp", "path", "snippets", "buffer", "env", "emoji", "conventional_commits", "digraphs", "calc" },
          providers = {
            -- create provider
            lsp = {
              score_offset = 100,
            },
            path = {
              score_offset = 90,
            },
            snippets = {
              score_offset = 80,
            },
            buffer = {
              score_offset = 70,
            },
            calc = {
              name = "calc",
              module = "blink.compat.source",
              score_offset = 50,
              opts = {},
            },
            emoji = {
              module = "blink-emoji",
              name = "emoji",
              score_offset = 0, -- Tune by preference
              opts = {
                insert = true, -- Insert emoji (default) or complete its name
                trigger = ":",
              },
            },
            conventional_commits = {
              name = "Conventional Commits",
              module = "blink-cmp-conventional-commits",
              enabled = function()
                return vim.bo.filetype == "gitcommit"
              end,
              ---@module 'blink-cmp-conventional-commits'
              ---@type blink-cmp-conventional-commits.Options
              opts = {}, -- none so far
            },
            env = {
              name = "Env",
              module = "blink-cmp-env",
              score_offset = -10,
              --- @type blink-cmp-env.Options
              opts = {
                item_kind = require("blink.cmp.types").CompletionItemKind.Variable,
                show_braces = false,
                show_documentation_window = true,
              },
            },
            digraphs = {
              -- IMPORTANT: use the same name as you would for nvim-cmp
              name = "digraphs",
              module = "blink.compat.source",

              -- all blink.cmp source config options work as normal:
              score_offset = -15,
              -- this table is passed directly to the proxied completion source
              -- as the `option` field in nvim-cmp's source config
              --
              -- this is NOT the same as the opts in a plugin's lazy.nvim spec
              opts = {
                -- this is an option from cmp-digraphs
                cache_digraphs_on_start = true,
                filter = function(item)
                  local allowed_charnr = {
                    0x00C4, -- Ä
                    0x00E4, -- ä
                    0x00D6, -- Ö
                    0x00F6, -- ö
                    0x00DC, -- Ü
                    0x00FC, -- ü
                    0x00DF, -- ß
                    0x20AC, -- €
                  }
                  for _, value in ipairs(allowed_charnr) do
                    if item.charnr == value then
                      return true
                    end
                  end
                  return false
                end,
              },
            },
          },
        },
        signature = {
          enabled = true,
        },
        completion = {
          ghost_text = {
            enabled = true,
          },
          menu = {
            draw = {
              columns = { { "kind_icon" }, { "label", "label_description", gap = 1 }, { "kind" }, { "source_name" } },
              components = {
                kind_icon = {
                  text = function(ctx)
                    local icon = ctx.kind_icon
                    if vim.tbl_contains({ "Path" }, ctx.source_name) then
                      local dev_icon, _ = require("nvim-web-devicons").get_icon(ctx.label)
                      if dev_icon then
                        icon = dev_icon
                      end
                    else
                      icon = require("lspkind").symbolic(ctx.kind, {
                        mode = "symbol",
                      })
                    end

                    return icon .. ctx.icon_gap
                  end,
                  -- Optionally, use the highlight groups from nvim-web-devicons
                  -- You can also add the same function for `kind.highlight` if you want to
                  -- keep the highlight groups in sync with the icons.
                  highlight = highlight,
                },
              },
            },
          },
        },
        cmdline = {
          keymap = { preset = "inherit" },
          completion = {
            menu = {
              auto_show = true,
            },
            ghost_text = {
              enabled = true,
            },
          },
        },
      })
    end,
  },
}
