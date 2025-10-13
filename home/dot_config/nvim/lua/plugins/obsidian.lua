return {
  {
    "obsidian-nvim/obsidian.nvim",
    dependencies = {
      {
        "MeanderingProgrammer/render-markdown.nvim",
        ft = { "markdown", "md" },
        dependencies = {
          "nvim-treesitter/nvim-treesitter",
          "nvim-tree/nvim-web-devicons",
        },
      },
    },
    version = "*", -- recommended, use latest release instead of latest commit
    ft = "markdown",
    keys = {
      { "<leader>wn", "<cmd>Obsidian new_from_template<CR>", desc = "Create new note from template" },
      { "<leader>wt", "<cmd>Obsidian new_from_template<CR>", desc = "Create new note from template" },
      { "<leader>wN", "<cmd>Obsidian new<CR>", desc = "Create new note" },
      { "<leader>wT", "<cmd>Obsidian template<CR>", desc = "Insert template into current note" },
      { "<leader>wp", "<cmd>Obsidian paste_img<CR>", desc = "Paste image into note" },
      { "<leader>wsh", "<cmd>Obsidian toc<CR>", desc = "Show table of contents in note" },
      { "<leader>wsw", "<cmd>Obsidian workspace<CR>", desc = "Show all workspaces" },
      { "<leader>wsb", "<cmd>Obsidian backlinks<CR>", desc = "Search Notes backinks" },
      { "<leader>wst", "<cmd>Obsidian tags<CR>", desc = "Search for tags" },
      { "<leader>wss", "<cmd>Obsidian search<CR>", desc = "Search in notes" },
      { "<leader>wss", "<cmd>Obsidian quick_switch<CR>", desc = "Search for notes" },
      { "<leader>wsl", "<cmd>Obsidian links<CR>", desc = "Search links in note" },
      { "<leader>wut", require("custom.umlauts").toggle, desc = "Toggle Umlaut substitution" },
      { "<leader>wue", require("custom.umlauts").enable, desc = "Enable Umlaut substitution" },
      { "<leader>wud", require("custom.umlauts").disable, desc = "Disable Umlaut substitution" },
    },
    ---@module 'obsidian'
    ---@type obsidian.config
    opts = {
      legacy_commands = false,
      ui = {
        enable = false,
      },
      workspaces = {
        {
          name = "Home Wiki",
          path = vim.fn.expand("~") .. "/git/git.vonessen.eu/dvonessen/notes",
        },
      },
      notes_subdir = "notes",
      new_notes_location = "notes_subdir",
      completion = {
        nvim_cmp = false,
        blink = true,
        create_new = true,
        min_chars = 0,
      },
      picker = {
        name = "snacks.pick",
      },
      note_id_func = function(title)
        return title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):gsub("%-%-", "-"):lower()
      end,
      frontmatter = {
        enabled = true,
        func = function(note)
          -- Add the title of the note as an alias.
          local title = note.title
          if title ~= nil and title ~= "" then
            if string.byte(title, 1) > 224 then
              title = title:sub(6)
            end
            note:add_alias(title)
          end

          if not note:get_field("creation_date") then
            note:add_field("creation_date", tostring(os.date("%Y-%m-%d %H:%M")))
          end

          if not note:get_field("summary") then
            vim.ui.input({ prompt = "Short summary for this note:" }, function(input)
              if input == nil then
                input = ""
              end
              if input == "" then
                vim.notify("Empty summary given", vim.log.levels.WARN)
              end
              note:add_field("summary", input)
            end)
          end
          -- add last_modified
          note:add_field("last_modified", tostring(os.date("%Y-%m-%d %H:%M")))

          local out = { id = note.id, aliases = note.aliases, tags = note.tags }

          -- `note.metadata` contains any manually added fields in the frontmatter.
          -- So here we just make sure those fields are kept in the frontmatter.
          if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
            for k, v in pairs(note.metadata) do
              out[k] = v
            end
          end

          return out
        end,
      },
      templates = {
        folder = "resources/templates",
        substitutions = {
          current_full_date = function(_)
            return tostring(os.date("%A %d. %B %Y"))
          end,
          meeting_schedule = function(_)
            local schedule
            vim.ui.input(
              { prompt = "Date/Time when meeting takes/took place:", default = os.date("%Y-%m-%d %H:%M") },
              function(input)
                schedule = input
              end
            )
            return tostring(schedule)
          end,
          week_number = function(_)
            return tostring(os.date("%V"))
          end,
          weekly_title = function(_)
            local obp = require("custom.obsidian-plugins")
            local first_work_day_of_week = os.date("%d", obp.get_date_of_weekday())
            local last_work_day_of_week = os.date("%d", obp.get_date_of_weekday(5))

            --- Format: January 07-11, 2020 Week 08
            return string.format(
              "%s %s-%s, %s Week %s",
              os.date("%B"), -- Long month name e.g. January, February ...
              first_work_day_of_week,
              last_work_day_of_week,
              os.date("%Y"),
              os.date("%V") -- Week number of current week
            )
          end,
          full_week_dates = function(_)
            local obp = require("custom.obsidian-plugins")

            local week_dates = ""
            for i = 1, 7 do
              local date_of_workday_day = obp.get_date_of_weekday(i)
              week_dates = week_dates
                .. string.format(
                  "## 📅 %s %s. %s %s",
                  os.date("%A", date_of_workday_day), -- Long month name e.g. January, February ...
                  os.date("%d", date_of_workday_day),
                  os.date("%B", date_of_workday_day),
                  os.date("%Y", date_of_workday_day) -- Week number of current week
                )
              if i < 7 then
                week_dates = week_dates .. "\n\n"
              end
            end
            return week_dates
          end,
        },
        customizations = {
          private_weekly = {
            notes_subdir = "private/weeklies",
            note_id_func = function(_, _)
              return Obsidian.opts.note_id_func(string.format("Private Weekly %s-W%s", os.date("%Y"), os.date("%V")))
            end,
          },
          private_log = {
            notes_subdir = "private/logs",
            note_id_func = function(title, _)
              return Obsidian.opts.note_id_func(title)
            end,
          },
          work_weekly = {
            notes_subdir = "work/weeklies",
            note_id_func = function(_, _)
              return Obsidian.opts.note_id_func(string.format("Work Weekly %s-W%s", os.date("%Y"), os.date("%V")))
            end,
          },
          work_log = {
            notes_subdir = "work/logs",
            note_id_func = function(title, _)
              return Obsidian.opts.note_id_func(title)
            end,
          },
          work_meeting = {
            notes_subdir = "work/meetings",
            note_id_func = function(title, _)
              return Obsidian.opts.note_id_func(title)
            end,
          },
          person = {
            notes_subdir = "persons",
            note_id_func = function(title, _)
              return Obsidian.opts.note_id_func(title)
            end,
          },
        },
      },
      attachments = {
        img_folder = "resources/images",
      },
      callbacks = {
        post_set_workspace = function(workspace)
          local vault_dir = workspace.path.filename
          local save_time_minutes = 15

          local git_stat = vim.uv.fs_stat(vault_dir .. "/.git")
          if git_stat ~= nil then
            if vim.fn.getcwd():sub(1, #vault_dir) == vault_dir then
              local timer = vim.uv.new_timer()
              timer:start(
                save_time_minutes * 1000 * 60,
                save_time_minutes * 1000 * 60,
                vim.schedule_wrap(require("custom.obsidian-plugins").auto_commit)
              )
              vim.notify(("Auto commiting changes every %s minutes"):format(save_time_minutes), vim.log.levels.INFO)
              vim.api.nvim_create_autocmd({ "VimLeavePre" }, {
                callback = function(_)
                  require("custom.obsidian-plugins").auto_commit()
                end,
              })
            end
          end
        end,
      },
    },
    init = function()
      local obsidian_au_group = vim.api.nvim_create_augroup("Obsidian", { clear = true })
      -- Create an autocommand that triggers when a buffer's filetype is set
      vim.api.nvim_create_autocmd("FileType", {
        group = obsidian_au_group,
        -- Only apply this autocommand to Markdown files
        pattern = "markdown",

        -- Define the function that runs when the autocommand triggers
        callback = function(args)
          -- 'args.buf' gives the numeric buffer handle for the current buffer
          local buf = args.buf

          -- Get the full path of the file associated with this buffer
          -- e.g., "/foo/bar/baz/notes/example.md"
          local filepath = vim.api.nvim_buf_get_name(buf)

          -- Define the base directory we care about
          local target_dir = Obsidian.workspace.path.filename

          -- Normalize the path using Neovim’s built-in function wrapper (vim.fn)
          -- ':p' expands to an absolute, normalized path
          -- This ensures things like "./file.md" or "~/file.md" become full paths
          local normalized = vim.fn.fnamemodify(filepath, ":p")

          -- Check if the normalized path starts with "/foo/bar/baz/"
          -- '^' anchors the match to the beginning of the string
          -- 'vim.pesc()' escapes special regex characters safely in the path
          if normalized:find("^" .. vim.pesc(target_dir) .. "/") then
            -- 'vim.bo' gives access to buffer-local options
            -- Setting these options affects only this buffer
            vim.api.nvim_set_option_value("fixeol", true, { scope = "local", buf = buf }) -- Ensure a newline is added at end of file

            -- Window-local option (conceallevel)
            local win = vim.api.nvim_get_current_win()
            vim.api.nvim_set_option_value("wrap", true, { scope = "local", win = win }) -- Enable line wrapping for long lines
            vim.api.nvim_set_option_value("conceallevel", 2, { scope = "local", win = win })

            -- Buffer-local keymap to toggle wrap
            vim.keymap.set("n", "<leader>tw", function()
              local current_wrap_value = vim.api.nvim_get_option_value("wrap", { scope = "local", win = win })
              vim.api.nvim_set_option_value("wrap", not current_wrap_value, { scope = "local", win = win })
              vim.notify(
                "Wrap is now " .. tostring(vim.api.nvim_get_option_value("wrap", { scope = "local", win = win }))
              )
            end, { buffer = buf, desc = "Toggle wrap for this buffer" })
          end
        end,
      })
      require("custom.umlauts").setup()
    end,
  },
}
