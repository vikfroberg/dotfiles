return {
  "folke/flash.nvim",
  opts = {
    modes = {
      char = {
        enabled = false,
      },
    },
  },
  config = function()
    vim.keymap.set("n", "<leader>f", "<cmd>lua require('flash').jump()<cr>", { desc = "Jump to" })
    vim.keymap.set("n", "<leader>n",
      "<cmd>lua require('flash').jump({ pattern = vim.fn.expand('<cword>'), autojump = true })<cr>",
      { desc = "Jump to word under cursor" })
  end
}
