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
    vim.keymap.set("n", "<C-f>", "<cmd>lua require('flash').jump()<cr>", { desc = "Jump to" })
  end
}
