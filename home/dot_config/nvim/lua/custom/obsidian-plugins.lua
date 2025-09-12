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

---@param day? integer # Day of week number Monday=1, Tuesday=2 ...
---@return integer # Time object of given day, use os.date("%d", get_date_of_weekday()) to get the date from Monday
function M.get_date_of_weekday(day)
  if day == nil then
    day = 0
  else
    day = day - 1 -- create the correct offset
  end

  local today = os.date("*t")
  -- substract 2 will always calculate the day offset cause monday is second(2) day of the week
  local offset_to_first_day_of_week = today.wday - 2
  -- Turnaround to use the sunday to substract until monday
  if offset_to_first_day_of_week < 0 then
    offset_to_first_day_of_week = 6
  end
  return os.time({ day = (today.day - offset_to_first_day_of_week) + day, month = today.month, year = today.year })
end

return M
