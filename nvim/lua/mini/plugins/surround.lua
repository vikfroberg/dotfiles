return {
  "tpope/vim-surround",
  config = function()
    vim.keymap.set("n", "\"", "cs'\"", { desc = "Switch to double quotes", remap = true })
    vim.keymap.set("n", "'", "cs\"'", { desc = "Switch to single quotes", remap = true })
    vim.keymap.set("n", "`", "cs'`", { desc = "Switch to backticks", remap = true })
    vim.keymap.set({ "x", "o" }, "s", "S", { desc = "Surround", remap = true })
    vim.keymap.set({ "x", "o" }, "\"", "S\"", { desc = "Surround with double quotes", remap = true })
    vim.keymap.set({ "x", "o" }, "'", "S'", { desc = "Surround with single quotes", remap = true })
    vim.keymap.set({ "x", "o" }, "`", "S`", { desc = "Surround with backticks", remap = true })
    vim.keymap.set({ "x", "o" }, "{", "S{", { desc = "Surround with curly braces", remap = true })
    vim.keymap.set({ "x", "o" }, "[", "S[", { desc = "Surround with square brackets", remap = true })
    vim.keymap.set({ "x", "o" }, "(", "S(", { desc = "Surround with parentheses", remap = true })
  end,
}
