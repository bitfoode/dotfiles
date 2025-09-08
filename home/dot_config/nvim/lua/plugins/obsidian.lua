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
    -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
    event = {
      "BufEnter " .. vim.fn.expand("~") .. "/git/bitfoode/obsidian/*.md",
      "BufReadPre " .. vim.fn.expand("~") .. "/git/bitfoode/obsidian/*.md",
      "BufNewFile " .. vim.fn.expand("~") .. "/git/bitfoode/obsidian/*.md",
    },
    keys = {
      {
        "<leader>ww",
        function()
          vim.cmd("cd " .. Obsidian.opts.workspaces[1].path)
          vim.cmd("e index.md")
        end,
      },
    },
    ---@module 'obsidian'
    ---@type obsidian.config
    opts = {
      legacy_commands = false,
      workspaces = {
        {
          name = "Home Wiki",
          path = vim.fn.expand("~") .. "/git/git.vonessen.eu/dvonessen/notes",
        },
      },
      notes_subdir = "notes",
      completion = {
        nvim_cmp = false,
        blink = true,
        create_new = true,
        min_chars = 0,
      },
      picker = {
        name = "snacks.pick",
      },
      attachments = {
        img_folder = "./",
      },
      note_id_func = function(title)
        return title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
      end,
      note_frontmatter_func = function(note)
        -- Add the title of the note as an alias.
        if note.title then
          note:add_alias(note.title)
        end

        if not note:get_field("creation_date") then
          note:add_field("creation_date", tostring(os.date("%Y-%m-%d %H:%M")))
        end

        if not note:get_field("summary") then
          vim.ui.input({ prompt = "Short summary for this note: " }, function(input)
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
      vim.o.conceallevel = 2
    end,
  },
}
