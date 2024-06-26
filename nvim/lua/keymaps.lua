local set = vim.keymap.set

vim.g.mapleader = ' '
set("n", "<Space>", "<NOP>")

set({ "n", "o", "x" }, "B", "^", { desc = "Move to start of line" })
set({ "n", "o", "x" }, "E", "$", { desc = "Move to end of line" })

set("n", "s", ":w<CR>", { desc = "Save file" })
set("n", "S", ":wq<CR>", { desc = "Save and quit" })
set("n", "q", ":bw<CR>", { desc = "Close buffer" })
set("n", "Q", ":q<CR>", { desc = "Quit" })

set("n", "j", "gj", { desc = "Move down" })
set("n", "k", "gk", { desc = "Move up" })

set({"n", "x"}, "J", "5j", { desc = "Move down 5 lines" })
set({"n", "x"}, "K", "5k", { desc = "Move up 5 lines" })

set("n", "gj", "J", { desc = "Join lines" })

set("n", "gs", ":source %<CR>", { desc = "Source file" })

set("n", ",", ";")
set("n", ";", ",")

set("n", "U", "<C-R>", { desc = "Redo" })

set("x", "V", "$", { desc = "Select to end of line" })
set("x", "v", "V", { desc = "Select line" })
set("x", "y", "ygv<Esc>", { desc = "Yank visual selection" })

set("n", "V", "v$h", { desc = "Select to end of line" })
set("n", "Y", "y$", { desc = "Yank to end of line" })

set("n", "<C-j>", ":cn<CR>")
set("n", "<C-k>", ":cp<CR>")

set("n", "<Tab>", ">>", { desc = "Indent right" })
set("n", "<S-Tab>", "<<", { desc = "Indent left" })
set("x", "<Tab>", ">gv", { desc = "Indent right" })
set("x", "<S-Tab>", "<gv", { desc = "Indent left" })

set("n", "<leader>n", "*", { desc = "Search word under cursor" })
