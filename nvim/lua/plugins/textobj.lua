return {
  "beloglazov/vim-textobj-quotes",
  dependencies = { "kana/vim-textobj-user" },
  keys = {
    { "iq", nil,  mode = { "x", "o" }, desc = "[I]nside [q]uotes" },
    { "q",  "iq", mode = { "x", "o" }, desc = "Inside [q]uotes",  remap = true },
  },
}
