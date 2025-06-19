local highlight_yank_group = vim.api.nvim_create_augroup('highlight_yank', { clear = true })

vim.api.nvim_create_autocmd('TextYankPost', {
  group = highlight_yank_group,
  callback = function()
    vim.highlight.on_yank { higroup = 'IncSearch', timeout = 500 }
  end,
})
