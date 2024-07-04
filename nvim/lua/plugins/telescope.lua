return {
  'nvim-telescope/telescope.nvim',
  tag = '0.1.8',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope-fzy-native.nvim',
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    {
      "danielfalk/smart-open.nvim",
      branch = "0.2.x",
      dependencies = {
        "kkharji/sqlite.lua",
      },
    },
  },
  config = function()
    local actions = require "telescope.actions"

    require('telescope').setup({
      extensions = {
        smart_open = {
          match_algorithm = "fzf",
        },
      },
      defaults = {
        sorting_strategy = "ascending",
        layout_strategy = "horizontal",
        scroll_strategy = "limit",
        layout_config = {
          width = { padding = 0 },
          height = { padding = 0 },
          preview_cutoff = 1,
          prompt_position = "top",
        },
        mappings = {
          i = {
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
            ["<CR>"] = actions.select_default,
            ["<C-s>"] = actions.select_horizontal,
            ["<Esc>"] = actions.close,
          },
        },
      },
    })

    require("telescope").load_extension("smart_open")
    require('telescope').load_extension('fzf')

    local function smart_open()
      require("telescope").extensions.smart_open.smart_open({
        filename_first = false,
        cwd_only = true,
      })
    end

    local builtin = require('telescope.builtin')
    vim.keymap.set('n', '<leader>f', "<NOP>")
    vim.keymap.set('n', 'gf', builtin.current_buffer_fuzzy_find, { desc = "Find in current buffer" })
    vim.keymap.set("n", "<leader>p", "<NOP>")
    vim.keymap.set("n", "gp", smart_open, { noremap = true, silent = true })
    vim.keymap.set('n', '<leader>F', "<NOP>")
    vim.keymap.set('n', 'gF', builtin.live_grep, { desc = "Find in project" })
    vim.keymap.set("n", "<leader>N", "<NOP>")
    vim.keymap.set("n", "gN", builtin.grep_string, { desc = "Find word under cursor in project" })
    vim.keymap.set('n', '<leader>o', "<NOP>")
    vim.keymap.set('n', 'go', builtin.lsp_document_symbols, { desc = "LSP: Document symbols" })
    vim.keymap.set('n', '<leader>O', "<NOP>")
    vim.keymap.set('n', 'gO', builtin.lsp_workspace_symbols, { desc = "LSP: Workspace symbols" })
    -- vim.keymap.set("n", "grr", builtin.lsp_references, { desc = "LSP: References" })
    -- vim.keymap.set("n", "gro", builtin.lsp_outgoing_calls, { desc = "LSP: Outgoing calls" })
    -- vim.keymap.set("n", "gri", builtin.lsp_incoming_calls, { desc = "LSP: Incoming calls" })
    -- vim.keymap.set("n", "gdd", builtin.lsp_definitions, { desc = "LSP: Definitions" })
    -- vim.keymap.set("n", "gdt", builtin.lsp_type_definitions, { desc = "LSP: Type definitions" })
    -- vim.keymap.set("n", "gdi", builtin.lsp_implementations, { desc = "LSP: Implementations" })
  end,
}
