return {
  "tpope/vim-commentary",
  init = function()
    local formatoptions_group = vim.api.nvim_create_augroup('formatoptions', { clear = true })
    vim.api.nvim_create_autocmd('FileType', {
      group = formatoptions_group,
      pattern = '*',
      callback = function()
        vim.opt_local.formatoptions:remove('o')
        vim.opt_local.formatoptions:remove('O')
      end,
    })

    vim.keymap.set("n", "<leader>c", "gcc", { desc = "Comment" })
    vim.keymap.set("n", "\\", "gcc", { desc = "Comment" })
    vim.keymap.set("x", "<leader>c", "gc", { desc = "Comment" })
    vim.keymap.set("x", "\\", "gc", { desc = "Comment" })
  end,
}
