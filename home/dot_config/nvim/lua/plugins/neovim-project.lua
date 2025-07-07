return {
  {
    "coffebar/neovim-project",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      -- optional picker
      { "nvim-telescope/telescope.nvim" },
      { "Shatur/neovim-session-manager" },
      {
        "folke/noice.nvim",
        dependencies = {
          "MunifTanjim/nui.nvim",
          "rcarriga/nvim-notify", -- Optional: fallback and animations
        },
      },
    },
    lazy = false,
    priority = 100,

    config = function()
      vim.notify = require("notify")
      --- Path to the cache file.
      local cache_file = vim.fn.stdpath("cache") .. "/neovim-projects-cache.json"
      --- Cache validity duration in days.
      local cache_ttl_days = 14
      --- Number of seconds in a day.
      local seconds_in_day = 86400
      -- Implement cache
      --- Checks if the cache file is still valid based on its modification time.
      --- @return boolean valid True if cache is valid, false otherwise.
      local function is_cache_valid()
        local stat = vim.loop.fs_stat(cache_file)
        if not stat then
          return false
        end
        local age = os.time() - stat.mtime.sec
        return age < (cache_ttl_days * seconds_in_day)
      end

      --- Reads the list from the cache file.
      --- @return table|nil cached_list The cached list, or nil if reading failed.
      local function read_cache()
        local file = io.open(cache_file, "r")
        if not file then
          vim.notify("Failed to open cache file for reading.", vim.log.levels.WARN)
          return nil
        end
        local content = file:read("*a")
        file:close()
        local ok, decoded = pcall(vim.fn.json_decode, content)
        if not ok then
          vim.notify("Failed to decode cache content.", vim.log.levels.ERROR)
        end
        return ok and decoded or nil
      end

      --- Writes the list to the cache file.
      --- @param data table The list of items to cache.
      local function write_cache(projects)
        local file = io.open(cache_file, "w")
        if file then
          file:write(vim.fn.json_encode(projects))
          file:close()
          vim.notify("Cache file updated.", vim.log.levels.INFO)
        else
          vim.notify("Failed to open cache file for writing.", vim.log.levels.ERROR)
        end
      end

      --- Recursively find all `.git` directories under one or more root paths,
      --- limiting the traversal to a maximum folder depth.
      ---
      --- @param roots string|string[]  # A single root path or a list of root paths. `~` will be expanded.
      --- @param max_depth integer  # Maximum folder depth to traverse (0 = root only, 1 = root + immediate subfolders, etc.).
      --- @return string[]  # A list of `.git` directory paths found.
      local function find_git_dirs(roots, max_depth)
        local uv = vim.loop -- libuv bindings
        local git_dirs = {}

        if type(roots) == "string" then
          roots = { roots }
        end

        for i, path in ipairs(roots) do
          roots[i] = vim.fn.expand(path)
        end

        local function scan(dir, depth)
          if depth > max_depth then
            return -- stop if depth exceeded
          end

          local handle = uv.fs_scandir(dir)
          if not handle then
            return
          end

          while true do
            local name, typ = uv.fs_scandir_next(handle)
            if not name then
              break
            end

            local full_path = dir .. "/" .. name

            if typ == "directory" then
              if name == ".git" then
                table.insert(git_dirs, dir)
              else
                scan(full_path, depth + 1) -- go deeper
              end
            end
          end
        end

        for _, root in ipairs(roots) do
          scan(root, 0) -- start at depth 0
        end
        return git_dirs
      end

      --- Gets the list of items, using the cache if valid unless forced.
      --- @param force_refresh boolean|nil If true, forces regeneration of the list.
      --- @return table list The retrieved or newly generated list.
      function get_projects(force_refresh)
        if not force_refresh and is_cache_valid() then
          local cache = read_cache()
          if cache then
            return cache
          else
            vim.notify("Cache is valid but reading failed. Regenerating...", vim.log.levels.WARN)
          end
        else
          if force_refresh then
            vim.notify("Force refresh of cached list.", vim.log.levels.INFO)
          else
            vim.notify("Cache expired or missing. Regenerating...", vim.log.levels.INFO)
          end
        end
        local projects = find_git_dirs("~/git", 50)
        write_cache(projects)
        return projects
      end

      -- All git repositories inside ~/git
      local git_folders = get_projects(false)
      local projects = vim.list_extend(vim.deepcopy(git_folders), { "~/.local/share/chezmoi" })

      local project = require("neovim-project")
      project.setup({
        projects = projects,
        picker = {
          type = "telescope", -- or "fzf-lua"
        },
      })

      --- User command to manually refresh the cached list.
      vim.api.nvim_create_user_command("RefreshNeovimProjectsCache", function()
        vim.notify("Projects list updated running... this may take some time.", vim.log.levels.WARN)
        local new_projects = get_projects(true) -- force refresh
        require("neovim-project.config").options.projects = new_projects
        vim.notify("Projects list updated from cache.", vim.log.levels.INFO)
        -- get_projects(true)
        -- vim.notify("Cache manually refreshed! Please restart neovim.", vim.log.levels.INFO)
      end, {})

      vim.keymap.set(
        "n",
        "<leader>sp",
        "<cmd>NeovimProjectDiscover<CR>",
        { silent = true, noremap = true, desc = "Search for projects and restore its session" }
      )
    end,
  },
}
