return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    { "nvim-telescope/telescope-ui-select.nvim" },
    "nvim-tree/nvim-web-devicons",
  },
  -- Define keys here so they exist BEFORE the plugin loads
  keys = {
    { "<leader>pf", function() require("telescope.builtin").find_files() end, desc = "Find Files" },
    { "<C-p>", function() require("telescope.builtin").git_files() end, desc = "Git Files" },
    { "<leader>?", function() require("telescope.builtin").oldfiles() end, desc = "Recent Files" },
    { "<leader><space>", function() require("telescope.builtin").buffers() end, desc = "Buffers" },
    { "<leader>sg", function() require("telescope.builtin").live_grep() end, desc = "Grep" },
    { "<leader>sw", function() require("telescope.builtin").grep_string() end, desc = "Word" },
    { "<leader>sn", function() require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config") }) end, desc = "Config" },
    {
      "<leader>/",
      function()
        require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({ winblend = 10, previewer = false }))
      end,
      desc = "Buffer Search",
    },
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")

    telescope.setup({
      defaults = {
        path_display = { "truncate " },
        mappings = {
          i = {
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-j>"] = actions.move_selection_next,
          },
        },
        vimgrep_arguments = {
          "rg", "--color=never", "--no-heading", "--with-filename",
          "--line-number", "--column", "--smart-case", "--hidden", "--glob", "!**/.git/*",
        },
      },
      pickers = {
        find_files = {
          find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
        },
      },
      extensions = {
        ["ui-select"] = { require("telescope.themes").get_dropdown({}) },
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = "smart_case",
        },
      },
    })

    pcall(telescope.load_extension, "fzf")
    pcall(telescope.load_extension, "ui-select")
  end,
}
