local M = {}

function M.open(locations)
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_name(buf, "multi-buffer")
  vim.api.nvim_buf_set_lines(buf, 0, 0, false, locations)
  vim.api.nvim_set_option_value("buftype", "acwrite", { buf = buf })
  vim.api.nvim_set_option_value("modified", false, { buf = buf })
  vim.api.nvim_set_option_value("swapfile", false, { buf = buf })
  vim.api.nvim_win_set_buf(0, buf)
end

function M.open_with_peak(file_lines, peak)
  peak = peak or 4
  local locations = {}
  for _, file_line in ipairs(file_lines) do
    table.insert(locations, file_line)
  end
end

M.setup = function(_)
end

return M
