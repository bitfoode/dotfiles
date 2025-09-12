local M = {}

function M.setup()
  vim.api.nvim_create_augroup("MarkdownListEnter", {})
  vim.api.nvim_create_autocmd("FileType", {
    group = "MarkdownListEnter",
    pattern = "markdown",
    callback = function()
      vim.keymap.set("i", "<CR>", function()
        local line = vim.api.nvim_get_current_line()

        if line:match("^%s*[-*]%s+%S") then
          -- Continue list
          local bullet = line:match("^%s*([-*])")
          return "\n" .. bullet .. " "
        elseif line:match("^%s*[-*]%s*$") then
          -- Exit list: replace current line with empty string and move cursor
          vim.schedule(function()
            local row, _ = unpack(vim.api.nvim_win_get_cursor(0))
            vim.api.nvim_buf_set_lines(0, row - 1, row, false, { "" })
            vim.api.nvim_win_set_cursor(0, { row, 0 })
          end)
          return ""
        else
          return "\n"
        end
      end, { buffer = true, expr = true })
    end,
  })
end

return M
