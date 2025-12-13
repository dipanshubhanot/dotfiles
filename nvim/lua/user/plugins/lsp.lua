return {
  "neovim/nvim-lspconfig",
  lazy = false, -- Load immediately
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "j-hui/fidget.nvim",
    "folke/neodev.nvim",
    "saghen/blink.cmp", 
  },
  config = function()
    require("mason").setup()
    require("neodev").setup()
    require("fidget").setup()

    local on_attach = function(_, bufnr)
      local nmap = function(keys, func, desc)
        vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
      end
      nmap("gd", require("telescope.builtin").lsp_definitions, "Goto Definition")
      nmap("gr", require("telescope.builtin").lsp_references, "Goto References")
      nmap("K", vim.lsp.buf.hover, "Hover Documentation")
      nmap("<leader>rn", vim.lsp.buf.rename, "Rename")
    end

    local capabilities = require("blink.cmp").get_lsp_capabilities()

    require("mason-lspconfig").setup({
      ensure_installed = { "clangd", "lua_ls", "pyright", "rust_analyzer" },
      -- handlers = {} -- Explicitly omitted as requested
    })

    local lspconfig = require("lspconfig")

    -- 1. Clangd Manual Setup
    lspconfig.clangd.setup({
      on_attach = on_attach,
      capabilities = capabilities,
      cmd = {
        "clangd",
        "--background-index",
        "--clang-tidy",
        "--limit-results=0",
        "--completion-style=detailed",
        "--header-insertion=never",
      },
      init_options = {
        compilationDatabasePath = vim.fn.getcwd() .. "/build/clang15_debug/",
      },
    })

    -- 2. Lua LS Manual Setup
    lspconfig.lua_ls.setup({
      on_attach = on_attach,
      capabilities = capabilities,
      settings = {
        Lua = {
          diagnostics = { globals = { "vim" } },
          workspace = { checkThirdParty = false },
          telemetry = { enable = false },
        },
      },
    })

    -- 3. Simple Servers
    for _, server in ipairs({ "pyright", "rust_analyzer", "marksman" }) do
      lspconfig[server].setup({ on_attach = on_attach, capabilities = capabilities })
    end
  end,
}
