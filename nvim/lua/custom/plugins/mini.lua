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
        delete = "ds",  -- Delete surrounding
        replace = "cs", -- Replace surrounding
      },
    })

    require("mini.comment").setup({
      mappings = {
        comment_line = "\\",
        comment_visual = "\\",
      },
    })

    require("mini.base16").setup({
      palette = {
        base00 = '#000000',
        base01 = '#242422',
        base02 = '#484844',
        base03 = '#6c6c66',
        base04 = '#918f88',
        base05 = '#b5b3aa',
        base06 = '#d9d7cc',
        base07 = '#fdfbee',
        base08 = '#ff6c60',
        base09 = '#e9c062',
        base0A = '#ffffb6',
        base0B = '#a8ff60',
        base0C = '#c6c5fe',
        base0D = '#96cbfe',
        base0E = '#ff73fd',
        base0F = '#b18a3d',
      },
      -- use_cterm = true,
    })
  end,
}
