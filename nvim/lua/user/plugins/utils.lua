return {
  { "numToStr/Comment.nvim", opts = {} },
  
  -- Snacks.nvim (for custom git previewer)
  { "folke/snacks.nvim", priority = 1000, lazy = false, opts = { terminal = {} } },

  -- Tiny Code Action
  {
    "rachartier/tiny-code-action.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    event = "LspAttach",
    opts = {
      backend = "difftastic",
      picker = "telescope", -- Uses Telescope for the UI
      backend_opts = {
        delta = { args = { "--line-numbers" } },
        difftastic = { args = { "--color=always", "--display=inline", "--syntax-highlight=on" } },
      },
    },
    config = function(_, opts)
      require("tiny-code-action").setup(opts)
      vim.keymap.set({ "n", "x" }, "<leader>ca", function()
        require("tiny-code-action").code_action()
      end, { noremap = true, silent = true, desc = "Code Action" })
    end,
  },
}
