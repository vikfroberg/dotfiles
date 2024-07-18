vim.opt_local.expandtab = true
vim.opt_local.softtabstop = 2
vim.opt_local.shiftwidth = 2

vim.keymap.set('n', 'csq', function() require('treesitter-quote').cycle_quotes({ "\"", "'" }) end,
  { silent = true, desc = "Cycle quotes", buffer = true })
