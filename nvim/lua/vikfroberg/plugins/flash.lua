return {
  "folke/flash.nvim",
  enabled = false,
  event = "VeryLazy",
  opts = {},
  keys = {
    { "f", mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
    { "t", mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
    { "T", mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
  },
}
