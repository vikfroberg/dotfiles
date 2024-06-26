return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  dependencies = {
    "rescript-lang/tree-sitter-rescript"
  },
  config = function ()
    local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
    parser_config.rescript = {
      install_info = {
        url = "https://github.com/rescript-lang/tree-sitter-rescript",
        branch = "main",
        files = { "src/parser.c", "src/scanner.c" },
        generate_requires_npm = false,
        requires_generate_from_grammar = true,
        use_makefile = true, -- macOS specific instruction
      },
    }

    local configs = require("nvim-treesitter.configs")
    configs.setup({
      ensure_installed = { "lua", "vimdoc", "javascript", "html", "rescript" },
      sync_install = false,
      highlight = { enable = true },
      indent = { enable = true },
    })
  end
 }
