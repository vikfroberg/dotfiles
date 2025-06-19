local function get_visual_selection()
  local tmp = vim.fn.getreg("s")
  vim.cmd("normal! \"sy")
  local selection = vim.fn.getreg("s")
  vim.fn.setreg("s", tmp)
  return selection
end

local function get_cword()
  return vim.fn.expand("<cword>")
end

return {
  {
    "ibhagwan/fzf-lua",
    cmd = "FzfLua",
    keys = {
      { "<leader>o", mode = "n", function() require "fzf-lua".lsp_document_symbols() end,                         { desc = "lsp symbols" } },
      { "<leader>O", mode = "n", function() require "fzf-lua".lsp_workspace_symbols() end,                        { desc = "LSP workspace symbols" } },
      { "<leader>f", mode = "n", function() require "fzf-lua".blines() end,                                       { desc = "Lines" } },
      { "<leader>F", mode = "n", function() require "fzf-lua".live_grep() end,                                    { desc = "Live grep" } },
      { "<leader>N", mode = "n", function() require "fzf-lua".live_grep({ search = get_cword() }) end,            { desc = "Live grep word" } },
      { "<leader>N", mode = "v", function() require "fzf-lua".live_grep({ search = get_visual_selection() }) end, { desc = "Live grep visual" } },
      { "<leader>K", mode = "n", function() require "fzf-lua".commands() end,                                     { desc = "Commands" } },
    },
    opts = {
      winopts = {
        height = 1,      -- window height
        width = 1,       -- window width
        row = 0,         -- window row position (0=top, 1=bottom)
        col = 0,         -- window col position (0=left, 1=right)
        border = "none", -- window border style
      },
      grep = {
        -- no_header_i = true,
      },
      keymaps = {
        previewer = false,
      },
      lsp = {
        symbols = {
          previewer = false,
        },
        workspaceSymbols = {
          previewer = false,
        },
      },
      commands = {
        previewer = false,
      },
      blines = {
        previewer = false,
      },
    }
  },
  {
    "vikfroberg/mru",
    lazy = false,
    opts = {},
    keys = {
      {
        "<leader>p",
        mode = "n",
        function()
          local source = require("mru").mru_files()
          require "fzf-lua".fzf_exec(source, {
            actions = {
              ["default"] = require "fzf-lua".actions.file_edit,
            },
          })
        end,
        { desc = "MRU Files" }
      },
    }
  }
}
