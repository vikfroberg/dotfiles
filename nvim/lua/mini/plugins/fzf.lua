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

local mru_buffer_group = vim.api.nvim_create_augroup('mru_buffer_group', { clear = true })

vim.api.nvim_create_autocmd('BufWritePost', {
  group = mru_buffer_group,
  callback = function()
    mru_upsert_file(vim.fn.expand('%'))
  end,
})

vim.api.nvim_create_autocmd('BufEnter', {
  group = mru_buffer_group,
  callback = function()
    mru_upsert_file(vim.fn.expand('%'))
  end,
})

vim.api.nvim_create_autocmd('BufReadPost', {
  group = mru_buffer_group,
  callback = function()
    mru_upsert_file(vim.fn.expand('%'))
  end,
})

vim.api.nvim_create_autocmd('BufDelete', {
  group = mru_buffer_group,
  callback = function()
    mru_delete_file(vim.fn.expand('%'))
  end,
})

local function mru_files()
  local mru = vim.fn.reverse(vim.fn.copy(mru_buffers))
  local files = vim.fn.split(vim.fn.system('fd -c never -tf'), '\n')
  local current_filename = vim.fn.fnamemodify(vim.fn.expand('%'), ":~:.")
  local relative_mru_without_current = vim.tbl_filter(function(v)
    return v ~= current_filename
  end, mru)
  local files_without_mru = vim.tbl_filter(function(file)
    return not vim.tbl_contains(mru, file)
  end, files)
  return vim.fn.extend(relative_mru_without_current, files_without_mru)
end

return {
  "ibhagwan/fzf-lua",
  config = function()
    vim.keymap.set("n", "<c-P>", function () require'fzf-lua'.fzf_exec(mru_files(), {
      actions = {
        ['default'] = require'fzf-lua'.actions.file_edit,
      },
    }) end, { desc = "MRU Files" })
  end
}
