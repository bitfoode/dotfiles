---@class ObsidianPlugins
local M = {}

---Run a command and throw an error on failure
---Helper function for async consecutive calls
---@param cmd string[] Command arguments, e.g. { "git", "add", "-A" }
---@param msg? string Optional notification message on success
---@param on_success fun()|nil Function which runs if cmd is Successfully
function M.run_async(cmd, msg, on_success)
  vim.system(cmd, {}, function(out)
    if out.code ~= 0 then
      vim.schedule(function()
        vim.notify(
          ("Command failed: %s\n%s (code %d)"):format(table.concat(cmd, " "), out.stderr, out.code),
          vim.log.levels.ERROR
        )
      end)
      return
    end
    vim.schedule(function()
      if msg then
        vim.notify(msg, vim.log.levels.INFO)
      end
      if on_success then
        on_success()
      end
    end)
  end)
end

---Runs all git commands to prepare a git push
---@param msg string git commit message
function M.git_push_all(msg)
  M.run_async({ "git", "add", "-A" }, nil, function()
    M.run_async({ "git", "commit", "-m", msg }, msg, function()
      M.run_async({ "git", "pull", "--rebase" }, nil, function()
        M.run_async({ "git", "push" }, "Pushed changes to remote")
      end)
    end)
  end)
end

function M.auto_commit()
  local git_msg = ""
  vim.system({ "git", "status", "--porcelain" }, {}, function(out)
    if out.stdout and #out.stdout > 0 then
      local files = vim.split(out.stdout, "\n")
      git_msg = "doc(manual): :books: Auto commit at "
        .. os.date("%Y-%m-%d %H:%M:%S")
        .. "\n\n"
        .. "Updated Vault affected Files ("
        .. #files - 1
        .. "):\n\n"
      for _, file in ipairs(files) do
        local f = vim.split(file, " ")
        if f ~= nil and f[#f] ~= nil and f[#f] ~= "" then
          git_msg = git_msg .. "\t" .. f[#f] .. "\n"
        end
      end

      M.git_push_all(git_msg)
    end
  end)
end
return M
