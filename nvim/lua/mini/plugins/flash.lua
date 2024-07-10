return {
  "folke/flash.nvim",
  keys = {
    { "<C-f>", "<cmd>lua require('flash').jump()<cr>", desc = "Jump to" },
  },
  opts = {
    modes = {
      char = {
        enabled = false,
      },
    },
  },
}
