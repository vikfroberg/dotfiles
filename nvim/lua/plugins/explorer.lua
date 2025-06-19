return {
  "stevearc/oil.nvim",
  lazy = false,
  keys = {
    { "-", "<cmd>Oil<cr>", { desc = "Open parent directory" } },
  },
  opts = {
    use_default_keymaps = false,
    delete_to_trash = true,
    skip_confirm_for_simple_edits = true,
    prompt_save_on_select_new_entry = false,
    view_options = {
      is_always_hidden = function(name, _) return name == ".." end,
    },
    keymaps = {
      ["."] = "actions.toggle_hidden",
      ["<CR>"] = "actions.select",
      ["R"] = "actions.refresh",
      ["-"] = "actions.parent",
      ["_"] = "actions.open_cwd",
      ["~"] = { "actions.cd", opts = { scope = "tab" }, desc = ":tcd to the current oil directory" },
      ["?"] = "actions.preview",
    },
  },
  init = function()
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "oil_preview",
      callback = function(params)
        vim.keymap.set("n", "<CR>", "y", { buffer = params.buf, remap = true, nowait = true })
      end,
    })
  end,
}
