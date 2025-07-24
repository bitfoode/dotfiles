return {
  { -- LSP Configuration & Plugins
    "neovim/nvim-lspconfig",
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for Neovim
      {
        -- Use KingMichaelPark's version of Mason until #1640 is resolved
        -- https://github.com/mason-org/mason.nvim/pull/1640
        "KingMichaelPark/mason.nvim",
        version = "feat/add-uv-pypi-source",
        opts = {
          pip = { use_uv = true },
        },
      }, -- NOTE: Must be loaded before dependants
      "mason-org/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",

      -- Useful status updates for LSP.
      { "j-hui/fidget.nvim", opts = {} },
      {
        "folke/lazydev.nvim",
        dependencies = { "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings
        ft = "lua", -- only load on lua files
        opts = {
          library = {
            -- See the configuration section for more details
            -- Load luvit types when the `vim.uv` word is found
            { path = "luvit-meta/library", words = { "vim%.uv" } },
          },
        },
      },
      {
        "saghen/blink.cmp",
      },
    },
    config = function()
      -- This function gets run when an LSP attaches to a particular buffer.
      -- That is to say, every time a new file is opened that is associated with
      -- an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
      -- function will be executed to configure the current buffer
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
        callback = function(event)
          -- In this case, we create a function that lets us more easily define mappings specific
          -- for LSP related items. It sets the mode, buffer and description for us each time.
          local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
          end

          -- Jump to the definition of the word under your cursor.
          --  This is where a variable was first declared, or where a function is defined, etc.
          --  To jump back, press <C-t>.
          map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")

          -- Find references for the word under your cursor.
          map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")

          -- Jump to the implementation of the word under your cursor.
          --  Useful when your language has ways of declaring types without an actual implementation.
          map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")

          -- Jump to the type of the word under your cursor.
          --  Useful when you're not sure what type a variable is and you want to see
          --  the definition of its *type*, not where it was *defined*.
          map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")

          -- Fuzzy find all the symbols in your current document.
          --  Symbols are things like variables, functions, types, etc.
          map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")

          -- Fuzzy find all the symbols in your current workspace.
          --  Similar to document symbols, except searches over your entire project.
          map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

          -- Rename the variable under your cursor.
          --  Most Language Servers support renaming across files, etc.
          map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")

          -- Execute a code action, usually your cursor needs to be on top of an error
          -- or a suggestion from your LSP for this to activate.
          map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

          -- Opens a popup that displays documentation about the word under your cursor
          --  See `:help K` for why this keymap.
          map("K", vim.lsp.buf.hover, "Hover Documentation")
          map("<leader>k", vim.lsp.buf.hover, "Hover Documentation")

          -- WARN: This is not Goto Definition, this is Goto Declaration.
          --  For example, in C this would take you to the header.
          map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.server_capabilities.documentHighlightProvider then
            local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd("LspDetach", {
              group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
              end,
            })
          end

          -- The following autocommand is used to enable inlay hints in your
          -- code, if the language server you are using supports them
          --
          -- This may be unwanted, since they displace some of your code
          if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
            map("<leader>th", function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
            end, "[T]oggle Inlay [H]ints")
          end
        end,
      })

      -- Enable the following language servers
      --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
      --
      --  Add any additional override configuration in the following tables. Available keys are:
      --  - cmd (table): Override the default command used to start the server
      --  - filetypes (table): Override the default list of associated filetypes for the server
      --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
      --  - settings (table): Override the default settings passed when initializing the server.
      --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
      local servers = {
        ansiblels = {},
        marksman = {},
        markdownlint = {},
        dockerls = {},
        jsonls = {
          schemas = require("schemastore").json.schemas(),
          validate = { enable = true },
        },
        yamlls = {
          schemaStore = {
            -- You must disable built-in schemaStore support if you want to use
            -- this plugin and its advanced options like `ignore`.
            enable = false,
            -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
            url = "",
          },
          schemas = require("schemastore").yaml.schemas(),
        },
        basedpyright = {
          settings = {
            basedpyright = {
              -- Using Ruff's import organizer
              disableOrganizeImports = true,
              analysis = {
                typeCheckingMode = "recommended",
                autoImportCompletions = true,
                autoSearchPaths = true,
                diagnosticMode = "openFilesOnly",
                useLibraryCodeForTypes = true,
                diagnosticSeverityOverrides = {
                  reportUnknownMemberType = false,
                  reportMissingTypeStubs = false,
                  reportUnusedCallResult = false,
                  reportUnannotatedClassAttribute = false,
                },
              },
            },
          },
        },
        ruff = {
          settings = {
            configurationPreference = "filesystemFirst",
          },
        },
        prettier = {},
        html = {},
        cssls = {},
        emmet_ls = {},
        eslint = {},
        htmx = {},
        jinja_lsp = {
          filetypes = { "html", "jinja", "htmldjango" },
        },
        ts_ls = {},
        bashls = {
          settings = {
            bashIde = {
              -- Glob pattern for finding and parsing shell script files in the workspace.
              -- Used by the background analysis features across files.

              -- Prevent recursive scanning which will cause issues when opening a file
              -- directly in the home directory (e.g. ~/foo.sh).
              --
              -- Default upstream pattern is "**/*@(.sh|.inc|.bash|.command)".
              globPattern = "*@(.sh|.zsh|.inc|.bash|.command)",
            },
          },
          filetypes = { "bash", "sh", "zsh" },
        },
        tombi = {},
        lua_ls = {
          settings = {
            Lua = {
              completion = {
                runtime = {
                  version = "LuaJIT",
                },
                workspace = {
                  library = vim.api.nvim_get_runtime_file("", true),
                },
                callSnippet = "Replace",
              },
            },
          },
        },
        golangci_lint_ls = {},
        gopls = {},
      }

      -- Ensure the servers and tools above are installed
      --  To check the current status of installed tools and/or manually install
      --  other tools, you can run
      --    :Mason
      --
      --  You can press `g?` for help in this menu.
      require("mason").setup()

      -- You can add other tools here that you want Mason to install
      -- for you, so that they are available from within Neovim.
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        "stylua", -- Used to format Lua code
        "ansible-lint",
        "shellcheck",
        "shfmt",
      })

      -- Install hadolint only on non Darwin arm64 platforms
      local uname = vim.uv.os_uname()
      if uname.sysname ~= "Darwin" and uname.machine ~= "arm64" then
        vim.list_extend(ensure_installed, { "hadolint" })
      end
      -- Installs LSPs and tools like linters, formatter, DAPs
      require("mason-tool-installer").setup({ ensure_installed = ensure_installed })
      -- Since nvim >=0.11.0 mason-lspconfig uses the builtin nvim.lsp.enable and nvim.lsp.config
      require("mason-lspconfig").setup({
        ensure_installed = {},
        automatic_enable = vim.tbl_keys(servers or {}),
      })

      -- Installed LSPs are configured and enabled automatically with mason-lspconfig
      -- The loop below is for overriding the default configuration of LSPs with the ones in the servers table
      for server_name, config in pairs(servers) do
        vim.lsp.config(server_name, config)
      end
    end,
  },
}
