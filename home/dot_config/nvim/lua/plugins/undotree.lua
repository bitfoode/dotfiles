return {
  {
    "mbbill/undotree",
    opts = {},
    config = function()
      vim.keymap.set("n", "<leader>tu", vim.cmd.UndotreeToggle, { desc = "[Toggle [U]ndotree" })
      vim.g.undotree_WindowLayout = 3
      vim.g.undotree_SetFocusWhenToggle = 1
      vim.g.undotree_TreeNodeShape = "●"
    end,
  },
}
