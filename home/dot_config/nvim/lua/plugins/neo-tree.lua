return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    events = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("neo-tree").setup({
        sort_case_insensitive = true,
        popup_border_style = "rounded",
        use_popups_for_input = true,
        source_selector = {
          winbar = true, -- toggle to show selector on winbar
          truncation_character = "…",
        },
        filesystem = {
          use_libuv_file_watcher = true,
          filtered_items = {
            visible = true,
            hide_dotfiles = false,
            hide_gitignored = false,
          },
          follow_current_file = {
            enabled = true,
          },
        },
        default_component_configs = {
          indent = {
            expander_collapsed = "",
            expander_expanded = "",
            expander_highlight = "NeoTreeExpander",
            indent_marker = "│",
            indent_size = 2,
            last_indent_marker = "└",
            with_expanders = true,
            with_markers = true,
          },
          name = {
            trailing_slash = true,
            highlight_opened_files = true,
          },
          git_status = {
            symbols = { modified = "Δ" },
          },
        },
        commands = {
          -- https://github.com/nvim-neo-tree/neo-tree.nvim/discussions/370#discussioncomment-6679447
          copy_selector = function(state)
            local node = state.tree:get_node()
            local filepath = node:get_id()
            local filename = node.name
            local modify = vim.fn.fnamemodify

            local vals = {
              ["BASENAME"] = modify(filename, ":r"),
              ["EXTENSION"] = modify(filename, ":e"),
              ["FILENAME"] = filename,
              ["PATH (CWD)"] = modify(filepath, ":."),
              ["PATH (HOME)"] = modify(filepath, ":~"),
              ["PATH"] = filepath,
              ["URI"] = vim.uri_from_fname(filepath),
            }

            local options = vim.tbl_filter(function(val)
              return vals[val] ~= ""
            end, vim.tbl_keys(vals))
            if vim.tbl_isempty(options) then
              vim.notify("No values to copy", vim.log.levels.WARN)
              return
            end
            table.sort(options)
            vim.ui.select(options, {
              prompt = "Choose to copy to clipboard:",
              format_item = function(item)
                return ("%s: %s"):format(item, vals[item])
              end,
            }, function(choice)
              local result = vals[choice]
              if result then
                vim.notify(("Copied: `%s`"):format(result))
                vim.fn.setreg("+", result)
              end
            end)
          end,
        },
        window = {
          mappings = {
            Y = "copy_selector",
          },
        },
      })
    end,
    init = function()
      vim.keymap.set("n", "<leader>te", function()
        require("neo-tree.command").execute({
          toggle = true,
          action = "focus",
          source = "filesystem",
          reveal = true,
        })
      end, { desc = "Toggle NeoTree file [E]xplorer" })
    end,
  },
}
