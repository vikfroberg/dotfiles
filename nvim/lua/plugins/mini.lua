return {
  "echasnovski/mini.nvim",
  version = false,
  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
  config = function()
    local gen_spec = require('mini.ai').gen_spec
    require('mini.ai').setup({
      custom_textobjects = {
        -- Function definition (needs treesitter queries with these captures)
        F = gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }),
      }
    })

    require("mini.surround").setup({
      mappings = {
        delete = "ds", -- Delete surrounding
        replace = "cs", -- Replace surrounding
      },
    })

    require("mini.comment").setup({
      mappings = {
        comment_line = "\\",
      },
    })
  end,
}
