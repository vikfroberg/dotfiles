-- Available mappings
-- z/Z, m/M

_G.vikfroberg = _G.vikfroberg or {}
function vikfroberg.visual_set_search(cmdtype)
  local tmp = vim.fn.getreg("s")
  vim.cmd.normal({ args = { 'gv"sy' }, bang = true })
  vim.fn.setreg("/", "\\V" .. vim.fn.escape(vim.fn.getreg("s"), cmdtype .. "\\"):gsub("\n", "\\n"))
  vim.fn.setreg("s", tmp)
end

-- Movement
vim.keymap.set({ "n", "o", "x" }, "B", "^", { desc = "Move to start of line" })
vim.keymap.set({ "n", "o", "x" }, "E", "$", { desc = "Move to end of line" })

vim.keymap.set({ "n", "x" }, "j", "gj", { desc = "Move down" })
vim.keymap.set({ "n", "x" }, "k", "gk", { desc = "Move up" })
vim.keymap.set({ "n", "x" }, "J", "5j", { desc = "Move down 5 lines" })
vim.keymap.set({ "n", "x" }, "K", "5k", { desc = "Move up 5 lines" })

vim.keymap.set({ "n", "x" }, "E", "5l", { desc = "Move right 5 lines" })
vim.keymap.set({ "n", "x" }, "W", "5h", { desc = "Move left 5 lines" })

vim.keymap.set("n", ",", ";")
vim.keymap.set("n", ";", ",")

vim.keymap.set("n", "gt", "gg", { desc = "Go to top of file" })
vim.keymap.set("n", "gb", "G", { desc = "Go to bottom of file" })

-- Session
vim.keymap.set("n", "s", ":w<CR>", { desc = "Save file" })
vim.keymap.set("n", "S", ":wq<CR>", { desc = "Save and quit" })
vim.keymap.set("n", "q", ":bw<CR>", { desc = "Close buffer" })
vim.keymap.set("n", "Q", ":q<CR>", { desc = "Quit" })
vim.keymap.set("n", "gs", ":source %<CR>", { desc = "Source file" })
vim.keymap.set("n", "R", ":e %<CR>", { desc = "Reopen current file" })

-- Editing
vim.keymap.set("n", "U", "<C-R>", { desc = "Redo" })

-- Sane operators
vim.keymap.set("x", "V", "$", { desc = "Select to end of line" })
vim.keymap.set("x", "v", "V", { desc = "Select line" })
vim.keymap.set("x", "y", "ygv<Esc>", { desc = "Yank visual selection" })
vim.keymap.set("n", "V", "v$h", { desc = "Select to end of line" })
vim.keymap.set("n", "Y", "y$", { desc = "Yank to end of line" })

-- Windows
vim.keymap.set("n", "<C-l>", "<C-W><C-L>", { desc = "Move to left window" })
vim.keymap.set("n", "<C-k>", "<C-W><C-K>", { desc = "Move to upper window" })
vim.keymap.set("n", "<C-j>", "<C-W><C-J>", { desc = "Move to lower window" })
vim.keymap.set("n", "<C-h>", "<C-W><C-H>", { desc = "Move to right window" })

-- Indentation
vim.keymap.set("n", "<Tab>", ">>", { desc = "Indent right" })
vim.keymap.set("n", "<S-Tab>", "<<", { desc = "Indent left" })
vim.keymap.set("x", "<Tab>", ">gv", { desc = "Indent right" })
vim.keymap.set("x", "<S-Tab>", "<gv", { desc = "Indent left" })

-- Search
vim.keymap.set("n", "<esc>", "<cmd>nohls<cr>", { desc = "Clear search highlight" })
vim.keymap.set("n", "<leader>n", "*", { desc = "Search word under cursor forwards" })
vim.keymap.set("n", "<leader>r", [[:%s/<C-r><C-w>//g<Left><Left>]], { desc = "Replace word under cursor" })
vim.keymap.set("x", "r", "\"hy:%s/<C-r>h//gc<left><left><left>", { desc = "Replace word visual selection" })
vim.keymap.set("x", "n", ':lua vikfroberg.visual_set_search("/")<CR>/<C-R>=@/<CR><CR>')

-- Yank registers
vim.keymap.set({ "n", "x", "o" }, "gy", "\"y", { desc = "Yank to sacred register" })
vim.keymap.set({ "n", "x", "o" }, "gp", "\"p", { desc = "Paste from sacred register below cursor" })
vim.keymap.set({ "n", "x", "o" }, "gP", "\"P", { desc = "Paste from sacred register above cursor" })

-- Help
vim.keymap.set("n", "gh", ":help <C-r><C-w><CR>", { desc = "Help under cursor" })

-- Quickfix
-- vim.keymap.set("n", "<C-j>", function()
--   vim.diagnostic.setqflist()
--   vim.cmd('cfirst')
--   vim.cmd('cclose')
-- end, { desc = 'Set qflist, jump to first item, and close quickfix' })

-- Join lines
vim.keymap.set("n", "gj", "J", { desc = "Join lines" })
