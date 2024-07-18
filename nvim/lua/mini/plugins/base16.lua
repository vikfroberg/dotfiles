return {
  "RRethy/base16-nvim",
  lazy = false,
  init = function()
    if vim.fn.exists("$BASE16_THEME") == 1 and
        (not vim.g.colors_name or vim.g.colors_name ~= "base16-" .. vim.fn.getenv("BASE16_THEME")) then
      vim.g.base16colorspace = 256
      vim.cmd("colorscheme base16-" .. vim.fn.getenv("BASE16_THEME"))
    end
  end,
}
