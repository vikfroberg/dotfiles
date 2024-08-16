return {
  "folke/which-key.nvim",
  -- event = "VeryLazy",
  lazy = false,
  opts = {
    plugins = {
      marks = false,
      registers = false,
      spelling = { enabled = false },
    },
    icons = {
      mappings = false,
    },
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  },
}
