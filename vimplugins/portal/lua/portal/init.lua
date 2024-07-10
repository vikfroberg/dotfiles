local M = {}

M.open = function(args)
  local file, start_line, end_line = string.match(args, "([^:]+):(%d+)-(%d+)")
  start_line = tonumber(start_line)
  end_line = tonumber(end_line)

  if not file or not start_line or not end_line then
    print("Invalid arguments. Usage: :Portal <file>:<start_line>-<end_line>")
    return
  end

  -- Read the lines from the file
  local lines = {}
  for line in io.lines(file) do
    table.insert(lines, line)
  end

  -- Create a new buffer
  local buf = vim.api.nvim_create_buf(false, true)

  -- Set buffer content to the specified lines
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.list_slice(lines, start_line, end_line))

  -- Get the current window dimensions
  local width = vim.api.nvim_get_option("columns")
  local height = vim.api.nvim_get_option("lines")

  -- Define floating window dimensions and position
  local win_width = math.ceil(width * 0.8)
  local win_height = math.ceil(height * 0.8)
  local row = math.ceil((height - win_height) / 2)
  local col = math.ceil((width - win_width) / 2)

  -- Create the floating window
  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = win_width,
    height = win_height,
    row = row,
    col = col,
    border = 'single',
  })

  -- Make the floating window buffer modifiable and set an autocmd to save changes
  vim.api.nvim_buf_set_option(buf, 'modifiable', true)
  vim.api.nvim_create_autocmd('BufWritePost', {
    buffer = buf,
    callback = function()
      local modified_lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

      local beforeLines = vim.list_slice(lines, 0, start_line)
      local afterLines = vim.list_slice(lines, start_line, #modified_lines)
      local newLines = vim.list_concat({ beforeLines, modified_lines, afterLines })
      local f = io.open(file, "w")
      if f then
        for _, line in ipairs(newLines) do
          f:write(line .. "\n")
        end
        f:close()
      end
    end,
  })
end

M.setup = function(_)
  vim.api.nvim_create_user_command("Portal", function(opts)
    M.open(opts.args)
  end, {
    nargs = 1,
    complete = "file",
    desc = "Open a floating window portal into another file",
  })
end

return M
