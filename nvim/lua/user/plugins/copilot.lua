return {
  {
    "github/copilot.vim",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      -- Your Hardcoded Node Path
      vim.g.copilot_node_command = "/home/deepanshu.bhanot/.nvm/versions/node/v22.13.0/bin/node"
      vim.g.copilot_no_tab_map = true
      vim.keymap.set("i", "<C-J>", 'copilot#Accept("<CR>")', { expr = true, replace_keycodes = false })
      vim.keymap.set("i", "<C-]>", "<Plug>(copilot-next)", { desc = "Next Copilot suggestion" })
      vim.keymap.set("i", "<C-\\>", "<Plug>(copilot-dismiss)", { desc = "Dismiss Copilot suggestion" })
    end,
  },

  {
    "olimorris/codecompanion.nvim",
    -- 🛑 PINS version to v17.33.0 to FIX the warning you saw
    version = "v17.33.0",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("codecompanion").setup({
        strategies = {
          -- Tell it to use Copilot for everything
          chat = { adapter = "copilot" },
          inline = { adapter = "copilot" },
          agent = { adapter = "copilot" },
        },
      })

      -- KEYMAPPINGS (Cursor Style)

      -- 1. Inline Assistant (Like Cmd+K in Cursor)
      -- Select code (visual mode) or place cursor (normal mode) and press <leader>ai
      -- It will open a prompt. Type "Refactor this" and it will DIFF the changes in-place.
      vim.keymap.set({ "n", "v" }, "<leader>ai", "<cmd>CodeCompanion<cr>", { desc = "AI Inline Assist (Cursor Style)" })

      -- 2. Chat Sidebar (Like Cmd+L in Cursor)
      vim.keymap.set({ "n", "v" }, "<leader>aa", "<cmd>CodeCompanionChat Toggle<cr>", { desc = "AI Chat Toggle" })

      -- 3. Actions Menu (Explain, Fix, LSP context, etc.)
      vim.keymap.set({ "n", "v" }, "<leader>ap", "<cmd>CodeCompanionActions<cr>", { desc = "AI Actions Picker" })
    end,
  },
}
