return {
  "voldikss/vim-floaterm",
  init = function()
    vim.keymap.set("t", "§", "<cmd>FloatermKill<CR>", { desc = "Toggle terminal window" })
  end,
  config = function()
    vim.keymap.set("n", "§", "<cmd>FloatermNew --wintype=floating --width=0.9 --height=0.9<CR>",
      { desc = "Toggle terminal window" })
  end,
}
