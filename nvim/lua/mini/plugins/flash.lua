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
    vim.keymap.set("n", "<leader>f", "<cmd>lua require('flash').jump()<cr>", { desc = "Flash jump" })
  end
}
