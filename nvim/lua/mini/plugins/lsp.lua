return {
  "lukas-reineke/lsp-format.nvim",
  {
    "neovim/nvim-lspconfig",
    ft = { "rescript", "lua" },
    init = function()
      local lsp_group = vim.api.nvim_create_augroup("lsp", { clear = true })

      vim.api.nvim_create_autocmd(
        { "BufNewFile", "BufRead" },
        {
          group = lsp_group,
          pattern = "*.res,*.resi",
          callback = function()
            local root_dir = vim.fs.dirname(
              vim.fs.find({ "rescript.json", "bsconfig.json" }, { upward = true })[1]
            )
            local client = vim.lsp.start_client({
              name = "rescript-language-server",
              cmd = { "rescript-language-server", "--stdio" },
              root_dir = root_dir,
              rescript = {
                settings = {
                  askToStartBuild = false,
                },
              },
              settings = {
                rescript = {
                  askToStartBuild = false,
                  settings = {
                    askToStartBuild = false,
                  },
                },
              },
            })
            if client then
              vim.lsp.buf_attach_client(0, client)
            end
          end
        }
      )

      vim.api.nvim_create_autocmd(
        { "BufNewFile", "BufRead" },
        {
          group = lsp_group,
          pattern = "*.html,*.json,*.js",
          callback = function()
            local root_dir = vim.fs.dirname(
              vim.fs.find({ ".git" }, { upward = true })[1]
            )
            local client = vim.lsp.start_client({
              name = "prettier",
              cmd = { "prettier", "--stdin-filepath", "${INPUT}" },
              root_dir = root_dir,
            })
            if client then
              vim.lsp.buf_attach_client(0, client)
            end
          end
        }
      )

      vim.api.nvim_create_autocmd(
        { "BufNewFile", "BufRead" },
        {
          group = lsp_group,
          pattern = "*.lua",
          callback = function()
            local root_dir = vim.fs.dirname(
              vim.fs.find({ ".git" }, { upward = true })[1]
            )
            local client = vim.lsp.start_client({
              name = "lua-language-server",
              cmd = { "lua-language-server" },
              root_dir = root_dir,
              settings = {
                Lua = {
                  workspace = {
                    -- Make the server aware of Neovim runtime files
                    library = vim.api.nvim_get_runtime_file("", true),
                  },
                  diagnostics = {
                    globals = { "vim" }
                  }
                }
              },
            })
            if client then
              vim.lsp.buf_attach_client(0, client)
            end
          end
        }
      )

      vim.api.nvim_create_autocmd("LspAttach", {
        group = lsp_group,
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          require("lsp-format").on_attach(client)
          vim.keymap.set("n", "<leader>e", function() vim.diagnostic.setqflist() end, { buffer = args.buf })
          vim.keymap.set("n", "<leader>j", vim.diagnostic.goto_next, { buffer = args.buf })
          vim.keymap.set("n", "<leader>k", vim.diagnostic.goto_prev, { buffer = args.buf })
          vim.keymap.set("n", "<leader>i", vim.lsp.buf.hover, { buffer = args.buf })
          vim.keymap.set("n", "<leader>d", vim.lsp.buf.definition, { buffer = args.buf })
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = args.buf })
          vim.keymap.set("n", "<leader>t", function() vim.lsp.buf.code_action() end, { desc = "Code action" })
        end,
      })
    end
  },
}
