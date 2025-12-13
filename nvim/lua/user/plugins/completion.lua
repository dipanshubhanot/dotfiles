return {
  "saghen/blink.cmp",
  dependencies = {
    "rafamadriz/friendly-snippets",
    "mikavilpas/blink-ripgrep.nvim",
  },
  version = "1.*",
  opts = {
    appearance = { nerd_font_variant = "mono" },
    completion = {
      documentation = { auto_show = true, auto_show_delay_ms = 200 },
    },
    signature = { enabled = true },
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
      providers = {
        buffer = { opts = { get_bufnrs = vim.api.nvim_list_bufs } },
        ripgrep = {
          module = "blink-ripgrep",
          name = "RG",
          opts = { prefix_min_len = 3, max_filesize = 100 * 1024 },
        },
      },
    },
    fuzzy = { implementation = "prefer_rust_with_warning" },
  },
}
