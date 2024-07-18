return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = "BufEnter",
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
        filetype = "rescript",
      }

      configs.setup({
        auto_install = true,
        ignore_install = { "all" },
        modules = {},
        ensure_installed = { "lua", "rescript", "javascript", "json", "html" },
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
    event = "BufEnter",
  },
  {
    "vikfroberg/treesitter-quote",
    opts = {},
    keys = {
      { "\"", function() require("treesitter-quote").change_quote('"') end, desc = "Change to double quotes" },
      { "'",  function() require("treesitter-quote").change_quote("'") end, desc = "Change to single quotes" },
      { "`",  function() require("treesitter-quote").change_quote("`") end, desc = "Change to backticks" },
    },
  }
}
