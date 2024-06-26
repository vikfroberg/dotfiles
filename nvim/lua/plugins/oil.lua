return {
  {
    "stevearc/oil.nvim",
    config = function()
      require("oil").setup {}
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
