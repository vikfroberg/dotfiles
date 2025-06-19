return {
  {
    "supermaven-inc/supermaven-nvim",
    event = "InsertEnter",
    opts = {
      keymaps = {
        accept_suggestion = "<S-Tab>",
        accept_word = "<Tab>",
      },
    },
  },
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    setup = function()
      local cmp = require("cmp")
      cmd.setup({
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
        }),
        mapping = cmp.mapping.preset.insert({
          ['<C-n>'] = cmp.mapping.select_next_item(),
          ['<C-p>'] = cmp.mapping.select_prev_item(),
          ['<Esc>'] = cmp.mapping.abort(),
          ['<C-y>'] = cmp.mapping.confirm({ select = false }),
        }),
      })
    end,
  },
}
