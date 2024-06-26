local opt = vim.opt

----- Interesting Options -----
opt.termguicolors = true

-- You have to turn this one on :)
opt.inccommand = "split"

-- Best search settings :)
opt.smartcase = true
opt.ignorecase = true

----- UI Options -----
opt.softtabstop = 2
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.smartindent = true

opt.list = true

opt.hidden = true
opt.lazyredraw = true
opt.encoding = "utf-8"
opt.swapfile = false

opt.linespace = 3
opt.showmode = false
opt.showcmd = true

opt.scrolloff = 7
opt.wrap = false

opt.cursorline = true

----- Personal Preferences -----
opt.number = false

opt.splitbelow = true
opt.splitright = true

opt.clipboard = "unnamedplus"

opt.formatoptions:remove "o"
