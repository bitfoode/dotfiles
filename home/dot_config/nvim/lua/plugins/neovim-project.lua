return {
  {
    "coffebar/neovim-project",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      -- optional picker
      { "nvim-telescope/telescope.nvim" },
      { "Shatur/neovim-session-manager" },
    },
    lazy = false,
    priority = 100,

    config = function()
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

      -- All git repositories inside ~/git
      local git_folders = find_git_dirs("~/git", 50) -- limit to depth 3
      local projects = vim.list_extend(vim.deepcopy(git_folders), { "~/.local/share/chezmoi" })

      local project = require("neovim-project")
      project.setup({
        projects = projects,
        picker = {
          type = "telescope", -- or "fzf-lua"
        },
      })

      vim.keymap.set(
        "n",
        "<leader>sp",
        "<cmd>NeovimProjectDiscover<CR>",
        { silent = true, noremap = true, desc = "Search for projects and restore its session" }
      )
    end,
  },
}
