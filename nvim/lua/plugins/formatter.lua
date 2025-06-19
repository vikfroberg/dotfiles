return {
  -- conform.nvim is the main formatting engine - this is your primary tool
  "stevearc/conform.nvim",
  dependencies = {
    -- Mason provides the package management foundation
    "williamboman/mason.nvim",
    -- The integration bridge depends on both Mason and Conform existing
    "zapling/mason-conform.nvim",
  },
  init = function()
    -- Setup order matters: foundation first, then integration, then configuration
    
    -- 1. Establish the foundation - Mason's package management
    require("mason").setup({
      -- You can add Mason-specific configuration here if needed
    })
    
    -- 2. Create the bridge between Mason and Conform
    require("mason-conform").setup({
      -- This automatically configures conform to find Mason-installed tools
      -- You can specify which formatters to auto-install here if desired
    })
    
    -- 3. Configure the main formatting behavior
    require("conform").setup({
      formatters_by_ft = {
        -- Using arrays is more idiomatic and allows for formatter chains
        markdown = { "prettier" },
        html = { "prettier" },
        css = { "prettier" },
        scss = { "prettier" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        python = { "black" },
        rust = { "rustfmt" },
      },
      -- Add automatic formatting on save
      format_on_save = {
        -- Timeout for formatting operations
        timeout_ms = 500,
        -- Fall back to LSP formatting if conform formatter isn't available
        lsp_fallback = true,
      },
    })
  end,
}
