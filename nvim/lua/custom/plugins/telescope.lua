return {
  'nvim-telescope/telescope.nvim',
  tag = '0.1.8',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local actions = require "telescope.actions"
    require('telescope').setup({
      defaults = {
        -- border = false,
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

    local builtin = require('telescope.builtin')
    vim.keymap.set('n', '<leader>f', builtin.current_buffer_fuzzy_find, { desc = "Find in current buffer" })
    vim.keymap.set('n', '<leader>F', builtin.live_grep, { desc = "Find in project" })
    vim.keymap.set("n", "<leader>N", builtin.grep_string, { desc = "Find word under cursor in project" })
    vim.keymap.set('n', '<leader>o', builtin.lsp_document_symbols, { desc = "LSP: Document symbols" })
    vim.keymap.set('n', '<leader>O', builtin.lsp_workspace_symbols, { desc = "LSP: Workspace symbols" })
    -- vim.keymap.set('n', '<leader>t', builtin.treesitter, { desc = "Treesitter: Document symbols" })
    vim.keymap.set("n", "grr", builtin.lsp_references, { desc = "LSP: References" })
    vim.keymap.set("n", "gro", builtin.lsp_outgoing_calls, { desc = "LSP: Outgoing calls" })
    vim.keymap.set("n", "gri", builtin.lsp_incoming_calls, { desc = "LSP: Incoming calls" })
    vim.keymap.set("n", "gdd", builtin.lsp_definitions, { desc = "LSP: Definitions" })
    vim.keymap.set("n", "gdt", builtin.lsp_type_definitions, { desc = "LSP: Type definitions" })
    vim.keymap.set("n", "gdi", builtin.lsp_implementations, { desc = "LSP: Implementations" })
  end,
}
