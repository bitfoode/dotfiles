return {
  {
    "akinsho/toggleterm.nvim",
    opts = {
      open_mapping = { [[<leader>tt]], [[<c-\>]] },
      size = function(term)
        if term.direction == "horizontal" then
          return 20
        elseif term.direction == "vertical" then
          return vim.o.columns * 0.4
        end
      end,
    },
    init = function()
      --  See `:help window-resize` for a list of all window commands
      vim.keymap.set("t", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
      vim.keymap.set("t", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
      vim.keymap.set("t", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
      vim.keymap.set("t", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

      --  See `:help windows-resize` for a list of all window commands
      vim.keymap.set("t", "<M-h>", "3<C-w><", { silent = false, desc = "Resize window to the left" })
      vim.keymap.set("t", "<M-l>", "3<C-w>>", { silent = false, desc = "Resize window to the right" })
      vim.keymap.set("t", "<M-k>", "3<C-w>+", { silent = false, desc = "Resize window upwards" })
      vim.keymap.set("t", "<M-j>", "3<C-w>-", { silent = false, desc = "Resize window downwards" })

      -- Switch back to Normal mode
      vim.keymap.set("t", "<Esc><Esc>", [[<C-\><C-n>]], { silent = true, noremap = true })

      -- Require Terminal class from toggleterm
      local Terminal = require("toggleterm.terminal").Terminal

      -- Create a terminal and execute lazygit in it
      local lazygit_term = Terminal:new({
        cmd = "lazygit",
        display_name = "lazygit",
        direction = "float",
        close_on_exit = true,
        hidden = true,
        float_opts = {
          border = "double",
          title_pos = "center",
        },
        on_open = function(term)
          vim.cmd("startinsert!")
          vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
        end,
        -- function to run on closing the terminal
        on_close = function()
          vim.cmd("startinsert!")
        end,
      })
      -- Keymap to open lazygit
      vim.keymap.set("n", "<leader>tg", function()
        lazygit_term:toggle()
      end, { desc = "Toggle lazy[g]it in terminal" })

      -- Create a terminal and execute some python repl in it
      local python_term = function()
        local cmds = {
          "bpython",
          "ipython",
          "python",
        }
        local term_opt = {}
        for _, cmd in ipairs(cmds) do
          if vim.fn.executable(cmd) == 1 then
            term_opt["cmd"] = cmd
            term_opt["display_name"] = cmd
            break
          end
        end
        if not term_opt["cmd"] then
          term_opt["cmd"] = [[
              printf "Neither ipython, bpython or python is installed.\n"
              printf "Press any key to exit."
              read ans
              exit 0
              ]]
          term_opt["display_name"] = "interactive python interpreter not foundjk"
        end
        return Terminal:new({
          cmd = term_opt.cmd,
          display_name = term_opt.display_name,
          direction = "float",
          close_on_exit = true,
          hidden = true,
          float_opts = {
            border = "double",
            title_pos = "center",
          },
        })
      end
      -- Keymap to open python iterpretes
      vim.keymap.set("n", "<leader>tp", function()
        python_term():toggle()
      end, { desc = "[Toggle] [p]ython repl in terminal (bpython, ipython, python)" })
    end,
  },
}
