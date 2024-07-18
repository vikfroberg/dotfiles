local mru_buffers = {}

local function mru_upsert_file(filename)
  if vim.fn.filereadable(filename) == 1 then
    local modified_filename = vim.fn.fnamemodify(filename, ":~:.")
    mru_buffers = vim.tbl_filter(function(v)
      return v ~= modified_filename
    end, mru_buffers)
    table.insert(mru_buffers, 1, modified_filename)
  end
end

local mru_delete_file = function(filename)
  local modified_filename = vim.fn.fnamemodify(filename, ":~:.")
  mru_buffers = vim.tbl_filter(function(v)
    return v ~= modified_filename
  end, mru_buffers)
end

local mru_buffer_group = vim.api.nvim_create_augroup("mru_buffer_group", { clear = true })

vim.api.nvim_create_autocmd("BufWritePost", {
  group = mru_buffer_group,
  callback = function()
    mru_upsert_file(vim.fn.expand("%"))
  end,
})

vim.api.nvim_create_autocmd("BufEnter", {
  group = mru_buffer_group,
  callback = function()
    mru_upsert_file(vim.fn.expand("%"))
  end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
  group = mru_buffer_group,
  callback = function()
    mru_upsert_file(vim.fn.expand("%"))
  end,
})

vim.api.nvim_create_autocmd("BufDelete", {
  group = mru_buffer_group,
  callback = function()
    mru_delete_file(vim.fn.expand("%"))
  end,
})

local function mru_files()
  local mru = mru_buffers
  local files = vim.fn.split(vim.fn.system("fd -c never -tf"), "\n")
  local current_filename = vim.fn.fnamemodify(vim.fn.expand("%"), ":~:.")
  local relative_mru_without_current = vim.tbl_filter(function(v)
    return v ~= current_filename
  end, mru)
  local files_without_mru = vim.tbl_filter(function(file)
    return not vim.tbl_contains(mru, file)
  end, files)
  local source = vim.fn.extend(relative_mru_without_current, files_without_mru)
  require "fzf-lua".fzf_exec(source, {
    actions = {
      ["default"] = require "fzf-lua".actions.file_edit,
    },
  })
end

local function live_grep_word()
  local word = vim.fn.expand("<cword>")
  require "fzf-lua".live_grep({ search = word })
end

local function live_grep_visual()
  local tmp = vim.fn.getreg("s")
  vim.cmd("normal! \"sy")
  local selection = vim.fn.getreg("s")
  vim.fn.setreg("s", tmp)
  require("fzf-lua").live_grep({ search = selection })
end

return {
  "ibhagwan/fzf-lua",
  opts = {
    winopts = {
      height = 1,      -- window height
      width = 1,       -- window width
      row = 0,         -- window row position (0=top, 1=bottom)
      col = 0,         -- window col position (0=left, 1=right)
      border = "none", -- window border style
    },
    grep = {
      -- no_header_i = true,
    },
    commands = {
      previewer = false,
    },
    blines = {
      previewer = false,
    },
  },
  keys = {
    { "<leader>o", mode = "n", function() require "fzf-lua".lsp_document_symbols() end,  { desc = "LSP symbols" } },
    { "<leader>O", mode = "n", function() require "fzf-lua".lsp_workspace_symbols() end, { desc = "LSP workspace symbols" } },
    { "<leader>f", mode = "n", function() require "fzf-lua".blines() end,                { desc = "Lines" } },
    { "<leader>F", mode = "n", function() require "fzf-lua".live_grep() end,             { desc = "Live grep" } },
    { "<leader>N", mode = "n", function() live_grep_word() end,                          { desc = "Live grep word" } },
    { "<leader>N", mode = "v", function() live_grep_visual() end,                        { desc = "Live grep visual" } },
    { "<leader>k", mode = "n", function() require "fzf-lua".commands() end,              { desc = "Commands" } },
    { "<leader>p", mode = "n", function() mru_files() end,                               { desc = "MRU Files" } },
  },
}
