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
    vim.keymap.set("n", " ", "<cmd>lua require('flash').jump()<cr>", { desc = "Flash jump" })
  end
}
