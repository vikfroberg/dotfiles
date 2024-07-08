local formatoptions_group = vim.api.nvim_create_augroup('formatoptions', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
  group = formatoptions_group,
  pattern = '*',
  callback = function()
    vim.opt_local.formatoptions:remove('o')
    vim.opt_local.formatoptions:remove('O')
  end,
})
