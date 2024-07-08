return {
  "tpope/vim-surround",
  config = function()
    vim.keymap.set("n", "\"", "cs'\"", { desc = "Switch to double quotes", remap = true })
    vim.keymap.set("n", "'", "cs\"'", { desc = "Switch to single quotes", remap = true })
    vim.keymap.set("n", "`", "cs'`", { desc = "Switch to backticks", remap = true })
  end,
}
