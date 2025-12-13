return {
  "stevearc/oil.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  lazy = false,
  -- Move keymap here so it works immediately
  keys = {
    { "<leader>pv", "<CMD>Oil<CR>", desc = "Open Oil" },
  },
  config = function()
    require("oil").setup({
      default_file_explorer = true,
      columns = { "permissions", "size", "mtime" },
      keymaps = {
        ["g?"] = "actions.show_help",
        ["<CR>"] = "actions.select",
        ["-"] = "actions.parent",
        ["<C-p>"] = false,
      },
      float = { padding = 2, border = "rounded" },
    })
  end,
}
