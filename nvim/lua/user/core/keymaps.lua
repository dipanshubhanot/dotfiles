-- Set leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local keymap = vim.keymap

-- General
keymap.set("n", "Q", "<nop>")
keymap.set("n", "<leader>f", vim.lsp.buf.format, { desc = "Format buffer" })

-- Move selected lines
keymap.set("n", "J", "mzJ`z")
keymap.set("n", "<C-d>", "<C-d>zz")
keymap.set("n", "<C-u>", "<C-u>zz")
keymap.set("n", "n", "nzzzv")
keymap.set("n", "N", "Nzzzv")

-- Word wrap remaps
keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Indenting in visual mode (keeps selection)
keymap.set("v", "<", "<gv")
keymap.set("v", ">", ">gv")

-- Paste without overwriting register
keymap.set("x", "<leader>p", [["_dP]])
keymap.set({ "n", "v" }, "<leader>d", [["_d]])
