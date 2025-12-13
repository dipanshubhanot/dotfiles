return {
  { "tpope/vim-fugitive" },
  {
    "lewis6991/gitsigns.nvim",
    dependencies = { "folke/snacks.nvim" },
    opts = {
      signs = { add = { text = "+" }, change = { text = "~" }, delete = { text = "_" }, topdelete = { text = "‾" }, changedelete = { text = "~" } },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        vim.keymap.set("n", "]h", gs.next_hunk, { buffer = bufnr, desc = "Next hunk" })
        vim.keymap.set("n", "[h", gs.prev_hunk, { buffer = bufnr, desc = "Prev hunk" })
        vim.keymap.set("n", "<leader>hs", gs.stage_hunk, { buffer = bufnr, desc = "Stage hunk" })
        vim.keymap.set("n", "<leader>hr", gs.reset_hunk, { buffer = bufnr, desc = "Reset hunk" })
        vim.keymap.set("n", "<leader>hp", gs.preview_hunk, { buffer = bufnr, desc = "Preview hunk" })
        vim.keymap.set("n", "<leader>hb", gs.toggle_current_line_blame, { buffer = bufnr, desc = "Toggle inline blame" })
        vim.keymap.set("n", "<leader>hd", gs.diffthis, { buffer = bufnr, desc = "Diff this" })

        -- Custom Git Diff Selection using Snacks
        vim.keymap.set("v", "<leader>pd", function()
          local snacks = require("snacks.picker")
          local start_line = vim.fn.line("'<")
          local end_line = vim.fn.line("'>")
          local file = vim.fn.expand("%")
          local lines = vim.api.nvim_buf_get_lines(bufnr, start_line - 1, end_line, false)
          local selection_text = table.concat(lines, "\n") .. "\n"
          local handle = io.popen("git diff --no-index --color=always -- /dev/null -", "w")
          if handle then
            handle:write(selection_text)
            local diff_output = handle:read("*a")
            handle:close()
            if diff_output == "" then diff_output = table.concat(lines, "\n") end
            snacks.pick({
              finder = function() return { { text = ("Diff %s:%d-%d"):format(file, start_line, end_line), preview = { text = diff_output, ft = "diff" } } } end,
              format = "text", previewer = "diff",
              actions = { ["<CR>"] = function() gs.stage_hunk({ range = { start_line, end_line } }) end },
            })
          end
        end, { buffer = bufnr, desc = "Preview selection diff" })
      end,
    },
  },
}
