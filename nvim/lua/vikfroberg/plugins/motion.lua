return {
  "bkad/CamelCaseMotion",
  init = function()
    vim.keymap.set("n", "w", "<Plug>CamelCaseMotion_w", { desc = "CamelCase motion w", silent = true })
    vim.keymap.set("n", "e", "<Plug>CamelCaseMotion_e", { desc = "CamelCase motion e", silent = true })
    vim.keymap.set("n", "b", "<Plug>CamelCaseMotion_b", { desc = "CamelCase motion b", silent = true })
    vim.keymap.set({ "x", "o" }, "iw", "<Plug>CamelCaseMotion_iw", { desc = "CamelCase motion iw", silent = true })
    vim.keymap.set({ "x", "o" }, "iW", "iw", { desc = "CamelCase motion iW", silent = true })
  end,
}
