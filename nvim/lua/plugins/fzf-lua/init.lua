return {
  "ibhagwan/fzf-lua",
  init = function()
    vim.keymap.set("n", "<leader>p", "<cmd>lua require('plugins.fzf-lua.cmds').mru_files()<CR>", { desc = "MRU files" })
    vim.keymap.set("n", "<leader>f", "<cmd>lua require('fzf-lua').blines()<CR>", { desc = "Buffer lines" })
  end,
  config = function()
    require("fzf-lua").setup({})
    require("plugins.fzf-lua.cmds")
  end,
}
