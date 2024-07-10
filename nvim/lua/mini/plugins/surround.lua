return {
  "tpope/vim-surround",
  dependencies = { "tpope/vim-repeat" },
  keys = {
    { "\"", "cs'\"", mode = "n",          desc = "Switch to double quotes",       remap = true },
    { "'",  "cs\"'", mode = "n",          desc = "Switch to single quotes",       remap = true },
    { "`",  "cs'`",  mode = "n",          desc = "Switch to backticks",           remap = true },
    { "s",  "S",     mode = { "x", "o" }, desc = "Surround",                      remap = true },
    { "\"", "S\"",   mode = { "x", "o" }, desc = "Surround with double quotes",   remap = true },
    { "'",  "S'",    mode = { "x", "o" }, desc = "Surround with single quotes",   remap = true },
    { "`",  "S`",    mode = { "x", "o" }, desc = "Surround with backticks",       remap = true },
    { "{",  "S{",    mode = { "x", "o" }, desc = "Surround with curly braces",    remap = true },
    { "[",  "S[",    mode = { "x", "o" }, desc = "Surround with square brackets", remap = true },
    { "(",  "S(",    mode = { "x", "o" }, desc = "Surround with parentheses",     remap = true },
  },
}
