return {
  "beloglazov/vim-textobj-quotes",
  dependencies = { "kana/vim-textobj-user" },
  keys = {
    { "q", "iq", mode = { "x", "o" }, desc = "Inside quotes", remap = true },
  },
}
