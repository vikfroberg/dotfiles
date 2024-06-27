vim.g.mapleader = ' '
vim.keymap.set("n", "<Space>", "<NOP>")

vim.keymap.set({ "n", "o", "x" }, "B", "^", { desc = "Move to start of line" })
vim.keymap.set({ "n", "o", "x" }, "E", "$", { desc = "Move to end of line" })

vim.keymap.set("n", "s", ":w<CR>", { desc = "Save file" })
vim.keymap.set("n", "S", ":wq<CR>", { desc = "Save and quit" })
vim.keymap.set("n", "q", ":bw<CR>", { desc = "Close buffer" })
vim.keymap.set("n", "Q", ":q<CR>", { desc = "Quit" })

vim.keymap.set("n", "j", "gj", { desc = "Move down" })
vim.keymap.set("n", "k", "gk", { desc = "Move up" })

vim.keymap.set({ "n", "x" }, "J", "5j", { desc = "Move down 5 lines" })
vim.keymap.set({ "n", "x" }, "K", "5k", { desc = "Move up 5 lines" })

vim.keymap.set("n", "gj", "J", { desc = "Join lines" })

vim.keymap.set("n", "gs", ":source %<CR>", { desc = "Source file" })

vim.keymap.set("n", ",", ";")
vim.keymap.set("n", ";", ",")

vim.keymap.set("n", "U", "<C-R>", { desc = "Redo" })

vim.keymap.set("x", "V", "$", { desc = "Select to end of line" })
vim.keymap.set("x", "v", "V", { desc = "Select line" })
vim.keymap.set("x", "y", "ygv<Esc>", { desc = "Yank visual selection" })

vim.keymap.set("n", "V", "v$h", { desc = "Select to end of line" })
vim.keymap.set("n", "Y", "y$", { desc = "Yank to end of line" })

vim.keymap.set("n", "<C-l>", "<C-W><C-L>", { desc = "Move to left window" })
vim.keymap.set("n", "<C-k>", "<C-W><C-K>", { desc = "Move to upper window" })
vim.keymap.set("n", "<C-j>", "<C-W><C-J>", { desc = "Move to lower window" })
vim.keymap.set("n", "<C-h>", "<C-W><C-H>", { desc = "Move to right window" })

vim.keymap.set("n", "<Tab>", ">>", { desc = "Indent right" })
vim.keymap.set("n", "<S-Tab>", "<<", { desc = "Indent left" })
vim.keymap.set("x", "<Tab>", ">gv", { desc = "Indent right" })
vim.keymap.set("x", "<S-Tab>", "<gv", { desc = "Indent left" })

vim.keymap.set("n", "<leader>n", "*", { desc = "Search word under cursor" })

vim.keymap.set("n", "<leader>a", function() vim.lsp.buf.code_action() end, { desc = "Code action" })
