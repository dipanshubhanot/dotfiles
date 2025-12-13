-- General Options
vim.opt.mouse = "" 
vim.opt.showcmd = true
vim.opt.autoindent = true
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Restore termguicolors on UI events
vim.api.nvim_create_autocmd({ "UIEnter", "ColorScheme" }, {
  callback = function()
    vim.opt.termguicolors = true
  end,
})
