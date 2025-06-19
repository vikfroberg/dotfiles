return {
  "vikfroberg/lsp",
  dependencies = {
    "lukas-reineke/lsp-format.nvim",
    "hrsh7th/cmp-nvim-lsp",
  },
  ft = { "rescript", "lua" },
  init = function()
    local lsp_group = vim.api.nvim_create_augroup("lsp", { clear = true })
    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    -- Rescript
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
            capabilities = capabilities,
            name = "rescript-language-server",
            cmd = { "rescript-language-server", "--stdio" },
            root_dir = root_dir,
          })
          if client then
            vim.lsp.buf_attach_client(0, client)
          end
        end
      }
    )

    -- TypeScript
    vim.api.nvim_create_autocmd(
      { "BufNewFile", "BufRead" },
      {
        group = lsp_group,
        pattern = "*.ts,*.tsx",
        callback = function()
          local root_dir = vim.fs.dirname(
            vim.fs.find({ ".git" }, { upward = true })[1]
          )
          local client = vim.lsp.start_client({
            capabilities = capabilities,
            name = "typescript-language-server",
            cmd = { "typescript-language-server", "--stdio" },
            root_dir = root_dir,
            settings = {
              typescript = {
                inlayHints = {
                  includeInlayParameterNameHints = "all",
                  includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                  includeInlayFunctionParameterTypeHints = true,
                  includeInlayVariableTypeHints = true,
                  includeInlayPropertyDeclarationTypeHints = true,
                  includeInlayFunctionLikeReturnTypeHints = true,
                  includeInlayEnumMemberValueHints = true,
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

    -- Lua
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
            capabilities = capabilities,
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
      end,
    })
  end
}
