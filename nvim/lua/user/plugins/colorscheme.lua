return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha",
        background = { dark = "mocha" },
        transparent_background = true,
        term_colors = true,
        integrations = {
          treesitter = true,
          semantic_tokens = true, -- Enables LSP highlighting
          telescope = { enabled = true },
          mason = true,
          cmp = true,
          gitsigns = true,
        },
        styles = {
          comments = { "italic" },
          functions = { "bold" },
          variables = {},
        },
        custom_highlights = function(colors)
          return {
            -- Transparent Backgrounds
            Normal = { bg = "NONE" },
            NormalNC = { bg = "NONE" },
            NormalFloat = { bg = "NONE" },
            LineNr = { bg = "NONE" },
            SignColumn = { bg = "NONE" },

            -- Syntax Overrides (Dynamic Colors)
            ["@keyword"] = { fg = colors.flamingo, bold = true },
            ["@keyword.function"] = { fg = colors.flamingo, italic = true },
            ["@variable"] = { fg = colors.mauve },
            ["@variable.builtin"] = { fg = colors.peach },
            ["@constant"] = { fg = colors.peach },
            ["@function"] = { fg = colors.blue },
            ["@parameter"] = { fg = colors.sky },
            ["@string"] = { fg = colors.green },
            ["@type"] = { fg = colors.rosewater },

            -- Link LSP Semantic Tokens to our custom groups
            ["@lsp.type.variable"] = { link = "@variable" },
            ["@lsp.type.parameter"] = { link = "@parameter" },
            ["@lsp.type.function"] = { link = "@function" },
            ["@lsp.type.method"] = { link = "@method" },
            ["@lsp.type.class"] = { link = "@type" },
            
            -- Modifiers
            ["@lsp.typemod.variable.readonly"] = { fg = colors.peach }, -- Const variables
          }
        end,
      })
      vim.cmd.colorscheme("catppuccin")
    end,
  },
}
