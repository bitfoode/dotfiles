return {
  {
    "folke/snacks.nvim",
    dependencies = {
      { "nvim-tree/nvim-web-devicons" },
    },
    priority = 1000,
    lazy = false,
    ---@module 'snacks'
    ---@type snacks.Config
    opts = {
      terminal = {
        win = {
          height = 20,
        },
      },
      statuscolumn = { enabled = true },
      lazygit = {
        enabled = true,
        win = {
          height = 0.9,
        },
      },
      indent = { enabled = true },
      quickfile = { enabled = true },
      gitbrowse = {
        enabled = true,
        config = function(opts, _)
          -- custom pattern, if the web site is not under ssh.example.com
          -- but unter example.com, this strips the ssh.
          local custom_remote_patterns = {
            { "^git@ssh.(.+):(.+)%.git$", "https://%1/%2" },
          }

          --- extends the custom_remote_patterns with the opts.remote_patterns (lower priority)
          opts.remote_patterns = vim.list_extend(custom_remote_patterns, opts.remote_patterns)
          --- add forgejo pattern
          opts.url_patterns["git%.vonessen%.eu"] = {
            branch = "/src/branch/{branch}",
            file = "/src/branch/{branch}/{file}#L{line_start}-L{line_end}",
            permalink = "/src/commit/{commit}/{file}#L{line_start}-L{line_end}",
            commit = "/commit/{commit}",
          }
          opts.url_patterns["git%.tech%.rz%.db%.de"] = opts.url_patterns["gitlab%.com"]
        end,
        what = "branch",
      },
      git = {
        enabled = true,
      },
      picker = {
        enabled = true,
        matcher = {
          frecency = true,
        },
        previewers = {
          man_pager = "batman",
        },
      },
      image = {
        enabled = true,
        preferred_protocol = "wezterm",
        fallback_protocol = "chafa",
        -- Used by obsidian.nvim to shwo images
        resolve = function(path, src)
          if require("obsidian.api").path_is_note(path) then
            return require("obsidian.api").resolve_image_path(src)
          end
        end,
      },
    },
    keys = {
      -- Start Pickers
      -- find
      {
        "<leader><space>",
        function()
          Snacks.picker.buffers()
        end,
        desc = "Buffers",
      },
      {
        "<leader>fb",
        function()
          Snacks.picker.buffers()
        end,
        desc = "Buffers",
      },
      {
        "<leader>fc",
        function()
          Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
        end,
        desc = "Find Config File",
      },
      {
        "<leader>ff",
        function()
          Snacks.picker.files({ hidden = true })
        end,
        desc = "Find Files",
      },
      {
        "<leader>sf",
        function()
          Snacks.picker.files({ hidden = true })
        end,
        desc = "Find Files",
      },
      {
        "<leader>fg",
        function()
          Snacks.picker.git_files()
        end,
        desc = "Find Git Files",
      },
      {
        "<leader>fn",
        function()
          Snacks.picker.notifications()
        end,
        desc = "Notification History",
      },
      {
        "<leader>fr",
        function()
          Snacks.picker.recent()
        end,
        desc = "Recent",
      },
      -- git
      {
        "<leader>gb",
        function()
          Snacks.picker.git_branches()
        end,
        desc = "Git Branches",
      },
      {
        "<leader>gl",
        function()
          Snacks.picker.git_log()
        end,
        desc = "Git Log",
      },
      {
        "<leader>gL",
        function()
          Snacks.picker.git_log_line()
        end,
        desc = "Git Log Line",
      },
      {
        "<leader>gs",
        function()
          Snacks.picker.git_status()
        end,
        desc = "Git Status",
      },
      {
        "<leader>gS",
        function()
          Snacks.picker.git_stash()
        end,
        desc = "Git Stash",
      },
      {
        "<leader>gd",
        function()
          Snacks.picker.git_diff()
        end,
        desc = "Git Diff (Hunks)",
      },
      {
        "<leader>gf",
        function()
          Snacks.picker.git_log_file()
        end,
        desc = "Git Log File",
      },
      -- Grep
      {
        "<leader>sb",
        function()
          Snacks.picker.lines()
        end,
        desc = "Buffer Lines",
      },
      {
        "<leader>sB",
        function()
          Snacks.picker.grep_buffers()
        end,
        desc = "Grep Open Buffers",
      },
      {
        "<leader>sg",
        function()
          Snacks.picker.grep()
        end,
        desc = "Grep",
      },
      {
        "<leader>sw",
        function()
          Snacks.picker.grep_word()
        end,
        desc = "Visual selection or word",
        mode = { "n", "x" },
      },
      -- search
      {
        '<leader>s"',
        function()
          Snacks.picker.registers()
        end,
        desc = "Registers",
      },
      {
        "<leader>s/",
        function()
          Snacks.picker.search_history()
        end,
        desc = "Search History",
      },
      {
        "<leader>sa",
        function()
          Snacks.picker.autocmds()
        end,
        desc = "Autocmds",
      },
      {
        "<leader>sc",
        function()
          Snacks.picker.command_history()
        end,
        desc = "Command History",
      },
      {
        "<leader>sC",
        function()
          Snacks.picker.commands()
        end,
        desc = "Commands",
      },
      {
        "<leader>sd",
        function()
          Snacks.picker.diagnostics()
        end,
        desc = "Diagnostics",
      },
      {
        "<leader>sD",
        function()
          Snacks.picker.diagnostics_buffer()
        end,
        desc = "Buffer Diagnostics",
      },
      {
        "<leader>sh",
        function()
          Snacks.picker.help()
        end,
        desc = "Help Pages",
      },
      {
        "<leader>sH",
        function()
          Snacks.picker.highlights()
        end,
        desc = "Highlights",
      },
      {
        "<leader>si",
        function()
          Snacks.picker.icons()
        end,
        desc = "Icons",
      },
      {
        "<leader>sj",
        function()
          Snacks.picker.jumps()
        end,
        desc = "Jumps",
      },
      {
        "<leader>sk",
        function()
          Snacks.picker.keymaps()
        end,
        desc = "Keymaps",
      },
      {
        "<leader>sl",
        function()
          Snacks.picker.loclist()
        end,
        desc = "Location List",
      },
      {
        "<leader>sm",
        function()
          Snacks.picker.marks()
        end,
        desc = "Marks",
      },
      {
        "<leader>sM",
        function()
          Snacks.picker.man()
        end,
        desc = "Man Pages",
      },
      {
        "<leader>sp",
        function()
          Snacks.picker.lazy()
        end,
        desc = "Search for Plugin Spec",
      },
      {
        "<leader>sq",
        function()
          Snacks.picker.qflist()
        end,
        desc = "Quickfix List",
      },
      {
        "<leader>sR",
        function()
          Snacks.picker.resume()
        end,
        desc = "Resume",
      },
      {
        "<leader>su",
        function()
          Snacks.picker.undo()
        end,
        desc = "Undo History",
      },
      {
        "<leader>uC",
        function()
          Snacks.picker.colorschemes()
        end,
        desc = "Colorschemes",
      },
      -- LSP
      -- Jump to the definition of the word under your cursor.
      --  This is where a variable was first declared, or where a function is defined, etc.
      {
        "gd",
        function()
          Snacks.picker.lsp_definitions()
        end,
        desc = "Goto Definition",
      },
      -- This is not Goto Definition, this is Goto Declaration.
      -- For example, in C this would take you to the header.
      {
        "gD",
        function()
          Snacks.picker.lsp_declarations()
        end,
        desc = "Goto Declaration",
      },
      -- Find references for the word under your cursor.
      {
        "gr",
        function()
          Snacks.picker.lsp_references()
        end,
        nowait = true,
        desc = "References",
      },
      -- Jump to the implementation of the word under your cursor.
      --  Useful when your language has ways of declaring types without an actual implementation.
      {
        "gI",
        function()
          Snacks.picker.lsp_implementations()
        end,
        desc = "Goto Implementation",
      },
      -- Jump to the type of the word under your cursor.
      --  Useful when you're not sure what type a variable is and you want to see
      --  the definition of its *type*, not where it was *defined*.
      {
        "gy",
        function()
          Snacks.picker.lsp_type_definitions()
        end,
        desc = "Goto T[y]pe Definition",
      },
      -- Fuzzy find all the symbols in your current document.
      --  Symbols are things like variables, functions, types, etc.
      {
        "<leader>ss",
        function()
          Snacks.picker.lsp_symbols()
        end,
        desc = "LSP Document Symbols",
      },
      -- Fuzzy find all the symbols in your current workspace.
      --  Similar to document symbols, except searches over your entire project.
      {
        "<leader>sS",
        function()
          Snacks.picker.lsp_workspace_symbols()
        end,
        desc = "LSP Workspace Symbols",
      },
      -- Pickers end
      {
        "<leader>bd",
        function()
          Snacks.bufdelete()
        end,
        desc = "[D]elete Buffer",
      },
      {
        "<leader>gg",
        function()
          Snacks.lazygit()
        end,
        desc = "Open Lazy[g]it",
      },
      {
        "<leader>gc",
        function()
          Snacks.gitbrowse({ what = "commit" })
        end,
        desc = "Open [C]ommit on Remote",
        mode = { "n", "v" },
      },
      {
        "<leader>gB",
        function()
          Snacks.gitbrowse({ what = "branch" })
        end,
        desc = "Open [B]ranch on Remote",
        mode = { "n", "v" },
      },
      {
        "<leader>gr",
        function()
          Snacks.gitbrowse({ what = "repo" })
        end,
        desc = "Open [R]epository on Remote",
        mode = { "n", "v" },
      },
      {
        "<leader>tt",
        function()
          Snacks.terminal.toggle()
        end,
        desc = "Toggle Terminal",
      },
      {
        "<c-\\>",
        function()
          Snacks.terminal()
        end,
        desc = "which_key_ignore",
      },
      {
        "<leader>tp",
        desc = "Interactive [P]ython repl",
        function()
          local python_repls = {
            "bpython",
            "ipython",
            "python",
          }
          local cmd = ""
          local title = "interactive python repl"
          for _, repl in ipairs(python_repls) do
            if vim.fn.executable(repl) == 1 then
              cmd = repl
              break
            end
          end
          if cmd == "" then
            cmd = [[
	            printf "No python REPL installed.\n"
	            printf "Press any key to exit."
	            read ans
	            exit 0
						]]
            title = "interactive python repl not found!"
          end

          Snacks.terminal.open(cmd, { win = { border = "rounded", title = title, title_pos = "center", height = 0.9 } })
        end,
      },
      {
        "<leader>to",
        desc = "Start OpenCode as floating Terminal",
        function()
          local cmd = "opencode"
          local title = "opencode"
          if vim.fn.executable(cmd) ~= 1 then
            cmd = [[
	            printf "opencode not installed\n"
	            printf "Press any key to exit."
	            read ans
	            exit 0
                  ]]
            title = "opencode cli not found!"
          end
          Snacks.terminal.toggle(
            cmd,
            { win = { border = "rounded", title = title, title_pos = "center", height = 0.9 } }
          )
        end,
      },
    },
  },
}
