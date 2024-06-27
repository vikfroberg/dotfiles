return {
  "danielfalk/smart-open.nvim",
  branch = "0.2.x",
  dependencies = {
    "kkharji/sqlite.lua",
    "nvim-telescope/telescope-fzy-native.nvim",
  },
  config = function()
    require("telescope").load_extension("smart_open")
    local function smart_open()
      require("telescope").extensions.smart_open.smart_open({
        filename_first = false,
        cwd_only = true,
      })
    end

    vim.keymap.set("n", "<leader>p", smart_open, { noremap = true, silent = true })
  end,
}
