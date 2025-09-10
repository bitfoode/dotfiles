return {
  { -- Autoformat
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    lazy = false,
    keys = {
      {
        "<leader>F",
        function()
          require("conform").format({ async = true, lsp_fallback = true })
        end,
        desc = "Format buffer",
      },
    },
    ---@module "conform"
    ---@type conform.setupOpts
    opts = {
      notify_on_error = true,
      format_on_save = { lsp_format = "fallback" },
      default_format_opts = {
        lsp_format = "fallback",
      },
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "ruff_organize_imports", "ruff_fix", "ruff_format" },
        go = { "golangci-lint" },
        ["markdown"] = { "prettier", "markdownlint-cli2" },
        ["markdown.mdx"] = { "prettier", "markdownlint-cli2" },
      },
    },
  },
}
