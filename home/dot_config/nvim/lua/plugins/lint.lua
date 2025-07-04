return {
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lint = require("lint")
      -- This allows other plugins to add linters to require('lint').linters_by_ft
      lint.linters_by_ft = lint.linters_by_ft or {}

      -- Set linters for filetype
      lint.linters_by_ft["markdown"] = { "markdownlint" }
      lint.linters_by_ft["dockerfile"] = { "hadolint" }

      -- Set nil on default linters, this is neccessary, this is neccessary because,
      -- they are not overwritten by the lint.linters_by_ft for the default linters
      -- see https://github.com/mfussenegger/nvim-lint/blob/master/lua/lint.lua#L35
      lint.linters_by_ft["clojure"] = nil
      lint.linters_by_ft["inko"] = nil
      lint.linters_by_ft["janet"] = nil
      lint.linters_by_ft["json"] = nil
      lint.linters_by_ft["rst"] = nil
      lint.linters_by_ft["ruby"] = nil
      lint.linters_by_ft["terraform"] = nil
      lint.linters_by_ft["text"] = nil

      -- Create autocommand which carries out the actual linting
      -- on the specified events.
      local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
        group = lint_augroup,
        callback = function()
          lint.try_lint()
        end,
      })
    end,
  },
}
