return {
  {
    "Bekaboo/dropbar.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons", "nvim-telescope/telescope-fzf-native.nvim" },
    config = function()
      local dropbar_api = require("dropbar.api")
      vim.keymap.set("n", "<leader>dp", dropbar_api.pick, { desc = "[P]ic symbols in droppar" })
    end,
    init = function()
      vim.o.mousemoveevent = true -- Used for hover in dropbar on mouseover
    end,
  },
}
