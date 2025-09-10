local M = {}

function M.setup()
  -- Keymap for normal mode (Leader + d)
  vim.keymap.set("n", "<leader>idd", function()
    vim.api.nvim_put({ tostring(os.date("%Y-%m-%d")) }, "c", true, true)
  end, {
    desc = "Insert current date (2020-01-31)",
  })
  vim.keymap.set("n", "<leader>idf", function()
    vim.api.nvim_put({ tostring(os.date("%A %d. %B %Y")) }, "c", true, true)
  end, {
    desc = "Insert current date (Monday 9. September 2020)",
  })
  vim.keymap.set("n", "<leader>idi", function()
    vim.api.nvim_put({ "📅 " .. tostring(os.date("%A %d. %B %Y")) }, "c", true, true)
  end, {
    desc = "Insert current date (Monday 9. September 2020)",
  })

  -- Keymap for insert mode (Ctrl + d)
  vim.keymap.set("i", "<C-@>", function()
    vim.api.nvim_put({ tostring(os.date("%Y-%m-%d")) }, "c", true, true)
  end, {
    desc = "Insert current date (YYYY-MM-DD)",
  })

  vim.keymap.set("n", "<leader>ww", function()
    vim.cmd("cd " .. vim.fn.expand("~") .. "/git/git.vonessen.eu/dvonessen/notes")
    vim.cmd("e index.md")
  end, { desc = "Go into Home wiki" })
end

return M
