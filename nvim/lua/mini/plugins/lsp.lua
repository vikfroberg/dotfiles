return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "lukas-reineke/lsp-format.nvim",
    },
    config = function()
      require("lsp-format").setup()

      vim.api.nvim_create_autocmd(
        { "BufNewFile", "BufRead" },
        {
          pattern = "*.res,*.resi",
          callback = function()
            local root_dir = vim.fs.dirname(
              vim.fs.find({ 'rescript.json', 'bsconfig.json' }, { upward = true })[1]
            )
            local client = vim.lsp.start_client({
              name = 'rescript-language-server',
              cmd = { 'rescript-language-server', '--stdio' },
              root_dir = root_dir,
            })
            vim.lsp.buf_attach_client(0, client)
          end
        }
      )

      vim.api.nvim_create_autocmd(
        { "BufNewFile", "BufRead" },
        {
          pattern = "*.lua",
          callback = function()
            local root_dir = vim.fs.dirname(
              vim.fs.find({ 'init.lua' }, { upward = true })[1]
            )
            local client = vim.lsp.start_client({
              name = 'lua-language-server',
              cmd = { 'lua-language-server' },
              root_dir = root_dir,
              settings = {
                diagnostics = {
                  Lua = {
                    globals = { 'vim' }
                  }
                }
              },
            })
            vim.lsp.buf_attach_client(0, client)
          end
        }
      )

      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          require("lsp-format").on_attach(client)
          vim.keymap.set('n', '<leader>h', vim.lsp.buf.hover, { buffer = args.buf })
          vim.keymap.set('n', '<leader>k', vim.diagnostic.goto_prev, { buffer = args.buf })
          vim.keymap.set('n', '<leader>j', vim.diagnostic.goto_next, { buffer = args.buf })
          vim.keymap.set('n', '<leader>d', vim.lsp.buf.definition, { buffer = args.buf })
          vim.keymap.set("n", "<leader>a", function() vim.lsp.buf.code_action() end, { desc = "Code action" })
        end,
      })
    end
  },
  {
    "folke/trouble.nvim",
    opts = {}, -- for default options, refer to the configuration section for custom setup.
    cmd = "Trouble",
    keys = {
      {
        "gx",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
    },
  }
}
