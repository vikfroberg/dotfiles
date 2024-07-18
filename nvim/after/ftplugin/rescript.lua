vim.opt_local.expandtab = true
vim.opt_local.softtabstop = 2
vim.opt_local.shiftwidth = 2
vim.api.nvim_set_option_value('commentstring', '// %s', { scope = 'local' })

vim.keymap.set('n', 'csq', function() require('treesitter-quote').cycle_quotes({ "\"", "`" }) end,
  { desc = "Cycle quotes", buffer = true })
