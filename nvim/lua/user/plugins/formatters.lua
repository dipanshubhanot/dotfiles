return {
  {
    "stevearc/conform.nvim",
    dependencies = { "williamboman/mason.nvim" },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local conform = require("conform")

      conform.setup({
        formatters_by_ft = {
          -- stop_after_first: prevents trying other formatters if stylua matches
          lua = { "stylua", stop_after_first = true },
          python = { "isort", "black" },
          bash = { "shfmt" },
          sh = { "shfmt" },
          nix = {"alejandra"},
        },

        -- This options table applies to 'gq' and direct calls
        default_format_opts = {
          lsp_fallback = true,
          timeout_ms = 500,
        },
      })

      -- 1. Set formatexpr so 'gq' uses Conform
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
  },

  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      local is_managed = os.getenv("NVIM_LSP_MANAGED_EXTERNALLY") == "true"
      local tools = { "stylua", "black", "isort", "shfmt", "shellcheck" }

      if not is_managed then
        require("mason-tool-installer").setup({ ensure_installed = tools })
      end
    end,
  },
}
