-- Leader
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Colorscheme
require("themes.ansi").setup()
vim.api.nvim_create_autocmd("OptionSet", {
  pattern = "background",
  callback = function()
    require("themes.ansi").setup()
  end,
})


-- Config
require("config")

-- Lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins", {
  defaults = { lazy = false },
  checker = { enabled = false },
  change_detection = { enabled = false },
  dev = {
    path = "~/Developer/vimplugins",
    patterns = { "vikfroberg" },
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
