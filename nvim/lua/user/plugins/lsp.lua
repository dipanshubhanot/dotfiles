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

    local is_managed_externally = os.getenv("NVIM_LSP_MANAGED_EXTERNALLY") == "true"
    local servers = {
      "clangd",
      "lua_ls",
      "marksman",
      "nil_ls",
      "pyright",
      "rust_analyzer",
      "taplo",
    }

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

    function remove_all(t, value)
      for i = #t, 1, -1 do
        if t[i] == value then
          table.remove(t, i)
        end
      end
    end

    require("mason-lspconfig").setup({
      ensure_installed = is_managed_externally and {} or servers,
    })

    local lspconfig = require("lspconfig")

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
    remove_all(servers, "clangd")

    lspconfig.lua_ls.setup({
      on_attach = function(client, body)
        client.server_capabilities.documentFormattingProvider = false
        on_attach(client, body)
      end,
      capabilities = capabilities,
      settings = {
        Lua = {
          diagnostics = { globals = { "vim" } },
          workspace = { checkThirdParty = false },
          telemetry = { enable = false },
        },
      },
    })
    remove_all(servers, "lua_ls")

    for _, server in ipairs(servers) do
      lspconfig[server].setup({ on_attach = on_attach, capabilities = capabilities })
    end
  end,
}
