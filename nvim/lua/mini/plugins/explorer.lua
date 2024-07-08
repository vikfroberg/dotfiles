return {
  {
    "stevearc/oil.nvim",
    config = function()
      require("oil").setup {
        use_default_keymaps = false,
        keymaps = {
          ["."] = "actions.toggle_hidden",
          ["<CR>"] = "actions.select",
          ["R"] = "actions.refresh",
          ["-"] = "actions.parent",
          ["_"] = "actions.open_cwd",
          ["~"] = { "actions.cd", opts = { scope = "tab" }, desc = ":tcd to the current oil directory" },
        },
      }
      vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "oil_preview",
        callback = function(params)
          vim.keymap.set("n", "<CR>", "y", { buffer = params.buf, remap = true, nowait = true })
        end,
      })
    end,
  },
}
