---@class ObsidianPlugins
local M = {}

local Job = require("plenary.job")
local async = require("plenary.async")

---Run a command asynchronously and throw an error on failure
---@param cmd string Command e.g. "git"
---@param args string[] Arguments for command { "add", "-A" }
---@param msg? string Optional notification message on success
function M.run(cmd, args, msg)
  Job:new({
    command = cmd,
    args = args,
    on_exit = function(job, code, _)
      if code ~= 0 then
        local result = job:result()
        if result == nil or #result == 0 then
          result = { "" }
        end
        vim.notify(
          ("Command failed: %s %s\n(code %d)\n\nResult: %s"):format(
            cmd,
            table.concat(args, " "),
            job.code,
            table.concat(result, " ")
          ),
          vim.log.levels.ERROR,
          { title = "Auto Commit Error" }
        )
      end
    end,
  }):sync()
  if msg then
    vim.notify(msg, vim.log.levels.INFO, { title = "Auto Commit" })
  end
end

function M.auto_commit()
  async.run(function()
    local git_status_files = Job:new({
      command = "git",
      args = { "status", "--porcelain" },
    }):sync()

    if git_status_files ~= nil and #git_status_files > 0 then
      local git_msg = "doc(autocommit): :books: Commit at "
        .. os.date("%Y-%m-%d %H:%M:%S")
        .. "\n\n"
        .. "Updated Vault affected Files ("
        .. #git_status_files
        .. "):\n\n"
      for _, file in ipairs(git_status_files) do
        local f = vim.split(file, " ")
        if f ~= nil and f[#f] ~= nil and f[#f] ~= "" then
          git_msg = git_msg .. "\t" .. f[#f] .. "\n"
        end
      end
      M.run("git", { "add", "-A" }, "Files added to stage")
      M.run("git", { "commit", "-m", git_msg }, git_msg)
      M.run("git", { "pull", "--rebase" }, "Pulled and rebased from remote")
      M.run("git", { "push" }, "Pushed changes to remote")
    end
  end, function() end)
end

return M
