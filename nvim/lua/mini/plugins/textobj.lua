return {
  "beloglazov/vim-textobj-quotes",
  dependencies = { "kana/vim-textobj-user" },
  init = function()
    vim.keymap.set({ "x", "o" }, "q", "iq", { desc = "Inside quotes", remap = true })
  end,
}
