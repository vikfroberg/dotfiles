return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufEnter *.lua", "BufEnter *.res", "BufEnter *.resi" },
    dependencies = { "rescript-lang/tree-sitter-rescript" },
    config = function()
      local parser_configs = require("nvim-treesitter.parsers").get_parser_configs()
      local configs = require("nvim-treesitter.configs")

      parser_configs.rescript = {
        install_info = {
          url = "https://github.com/rescript-lang/tree-sitter-rescript",
          branch = "main",
          files = { "src/parser.c", "src/scanner.c" },
          generate_requires_npm = false,
          requires_generate_from_grammar = true,
          use_makefile = true, -- macOS specific instruction
        },
      }

      configs.setup({
        ensure_installed = { "lua", "rescript" },
        sync_install = false,
        highlight = { enable = true },
        indent = { enable = true },
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["aa"] = "@parameter.outer",
              ["ia"] = "@parameter.inner",
            },
          },
        },
      })
    end
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    keys = {
      { "af" },
      { "if" },
      { "aa" },
      { "ia" },
    },
  }
}
