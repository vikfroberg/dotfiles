local M = {}

local mru_buffers = {}

function M.mru_upsert_file(filename)
  if vim.fn.filereadable(filename) == 1 then
    local modified_filename = vim.fn.fnamemodify(filename, ":~:.")
    mru_buffers = vim.tbl_filter(function(v)
      return v ~= modified_filename
    end, mru_buffers)
    table.insert(mru_buffers, 1, modified_filename)
  end
end

function M.mru_delete_file(filename)
  local modified_filename = vim.fn.fnamemodify(filename, ":~:.")
  mru_buffers = vim.tbl_filter(function(v)
    return v ~= modified_filename
  end, mru_buffers)
end

function M.mru_files()
  local mru = mru_buffers
  local files = vim.fn.split(vim.fn.system("fd -c never -tf"), "\n")
  local current_filename = vim.fn.fnamemodify(vim.fn.expand("%"), ":~:.")
  local relative_mru_without_current = vim.tbl_filter(function(v)
    return v ~= current_filename
  end, mru)
  local files_without_mru = vim.tbl_filter(function(file)
    return not vim.tbl_contains(mru, file)
  end, files)
  return vim.fn.extend(relative_mru_without_current, files_without_mru)
end

function M.setup(_)
  local mru_buffer_group = vim.api.nvim_create_augroup("mru_buffer_group", { clear = true })

  vim.api.nvim_create_autocmd("BufWritePost", {
    group = mru_buffer_group,
    callback = function()
      M.mru_upsert_file(vim.fn.expand("%"))
    end,
  })

  vim.api.nvim_create_autocmd("BufEnter", {
    group = mru_buffer_group,
    callback = function()
      M.mru_upsert_file(vim.fn.expand("%"))
    end,
  })

  vim.api.nvim_create_autocmd("BufReadPost", {
    group = mru_buffer_group,
    callback = function()
      M.mru_upsert_file(vim.fn.expand("%"))
    end,
  })

  vim.api.nvim_create_autocmd("BufDelete", {
    group = mru_buffer_group,
    callback = function()
      M.mru_delete_file(vim.fn.expand("%"))
    end,
  })
end

return M
