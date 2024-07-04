return {
  'Wansmer/treesj',
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  config = function()
    require('treesj').setup({
      use_default_keymaps = false,
    })
    vim.keymap.set("n", "m", "<CMD>TSJJoin<CR>", { desc = "Join lines" })
    vim.keymap.set("n", "M", "<CMD>TSJSplit<CR>", { desc = "Split lines" })
  end,
}
