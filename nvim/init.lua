local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end
vim.opt.rtp:prepend(lazypath)

require("mini.config")

-- Leader
-- vim.keymap.set('n', '<SPACE>', '<Nop>', { remap = false })
-- vim.g.mapleader = ' '

-- Lazy
require("lazy").setup("mini.plugins", {
  checker = { enabled = false },
  change_detection = { enabled = false },
})
