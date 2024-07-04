return {
  "ggVGc/vim-fuzzysearch",
  init = function()
    vim.keymap.set("n", "<ESC>", "<CMD>nohls<CR>", { desc = "Clear search highlight" })

    vim.keymap.set("n", "/", "<CMD>FuzzySearch<CR>", { desc = "Fuzzy search" })

    vim.keymap.set("n", "gp", "#", { desc = "Search word under cursor backwards" })
    vim.keymap.set("n", "gn", "*", { desc = "Search word under cursor forwards" })
  end,
}
