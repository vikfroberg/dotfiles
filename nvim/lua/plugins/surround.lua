return {
  "rhysd/vim-operator-surround",
  dependencies = { "kana/vim-operator-user" },
  init = function()
    vim.keymap.set("n", "ys", '<Plug>(operator-surround-append)', { silent = true })
    vim.keymap.set("n", "ds", '<Plug>(operator-surround-delete)', { silent = true })
    vim.keymap.set("n", "cs", '<Plug>(operator-surround-replace)', { silent = true })
  end,
}
