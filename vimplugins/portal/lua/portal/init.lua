local M = {}

M.find_open_buffers = function(file_name)
  local buffers = {}

  -- Iterate through all buffers
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    local buf_name = vim.api.nvim_buf_get_name(bufnr)
    -- Compare filenames (adjust as needed for your specific use case)
    if vim.fn.fnamemodify(buf_name, ':p') == vim.fn.fnamemodify(file_name, ':p') then
      table.insert(buffers, bufnr)
    end
  end

  return buffers
end

M.prettify_file_name = function(file_name)
  -- Get the base name of the file
  local base_name = vim.fn.fnamemodify(file_name, ":t")

  -- Get the shortened path of the directory
  local dir_name = vim.fn.fnamemodify(file_name, ":p:h")
  local shortened_dir = vim.fn.pathshorten(dir_name)

  -- Combine the shortened directory path and base name
  return shortened_dir .. "/" .. base_name
end

M.open = function(file, start_line, end_line, floating)
  -- Read the lines from the file
  local lines = {}
  for line in io.lines(file) do
    table.insert(lines, line)
  end

  -- Create a new buffer
  local buf = vim.api.nvim_create_buf(false, true)
  if vim.api.nvim_buf_get_name(buf) == "" then
    vim.api.nvim_buf_set_name(buf, file .. ":" .. start_line .. "-" .. end_line)
  end
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.list_slice(lines, start_line, end_line))
  vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = buf })
  vim.api.nvim_set_option_value("buftype", "acwrite", { buf = buf })
  vim.api.nvim_set_option_value("modified", false, { buf = buf })

  local set_title = function() end

  if floating then
    local max_width = vim.o.columns - 2
    local max_height = vim.o.lines - vim.o.cmdheight - 2
    local width = math.floor(max_width * 0.8)
    local height = math.floor(max_height * 0.8)

    local win = vim.api.nvim_open_win(buf, true, {
      relative = 'editor',
      title = file .. ":" .. start_line .. "-" .. end_line,
      title_pos = "left",
      row = math.floor(((vim.o.lines - height) / 2) - 2),
      col = math.floor(((vim.o.columns - width) / 2) - 2),
      width = width,
      height = height,
      border = 'single',
    })

    vim.api.nvim_create_autocmd('BufWipeout', {
      buffer = buf,
      callback = vim.schedule_wrap(function()
        if vim.api.nvim_win_is_valid(win) then
          vim.api.nvim_win_close(win, true)
        end
      end),
    })

    vim.api.nvim_create_autocmd('VimResized', {
      buffer = buf,
      callback = function()
        vim.defer_fn(function()
          if vim.api.nvim_win_is_valid(win) then
            vim.api.nvim_win_set_config(win, {
              relative = 'editor',
              row = math.floor(((vim.o.lines - height) / 2) - 2),
              col = math.floor(((vim.o.columns - width) / 2) - 2),
            })
          end
        end, 100)
      end,
    })

    set_title = function(title)
      vim.api.nvim_win_set_config(win, {
        title = title,
      })
    end
  else
    vim.api.nvim_win_set_buf(0, buf)
  end

  vim.api.nvim_create_autocmd('BufWriteCmd', {
    buffer = buf,
    callback = function()
      local before_lines = vim.list_slice(lines, 0, start_line - 1)
      local modified_lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
      local after_lines = vim.list_slice(lines, end_line + 1, #lines)
      lines = {}
      for _, v in ipairs(before_lines) do
        table.insert(lines, v)
      end
      for _, v in ipairs(modified_lines) do
        table.insert(lines, v)
      end
      for _, v in ipairs(after_lines) do
        table.insert(lines, v)
      end
      end_line = #before_lines + #modified_lines

      local f = io.open(file, "w")
      if f then
        for _, line in ipairs(lines) do
          f:write(line .. "\n")
        end
        f:close()
      end

      set_title(file .. ":" .. start_line .. "-" .. end_line)

      vim.api.nvim_set_option_value("modified", false, { buf = buf })
    end,
  })
end

M.setup = function(opts)
  M.opts = type(opts) == "table" and opts or {}
  vim.api.nvim_create_user_command("PortalFile", function(cmd_opts)
    local args = cmd_opts.args
    local floating = args:find("--float")

    local range_left = vim.fn.line("'<")
    local range_right = vim.fn.line("'>")

    local file, start_line, end_line
    if range_left and range_right then
      file = vim.api.nvim_buf_get_name(0)
      file = vim.fn.fnamemodify(file, ":~:.")
      start_line = range_left
      end_line = range_right
    else
      file, start_line, end_line = string.match(args, "([^:]+):(%d+)-(%d+)")
      start_line = tonumber(start_line)
      end_line = tonumber(end_line)

      if not file or not start_line or not end_line then
        print("Invalid arguments. Usage: :Portal <file>:<start_line>-<end_line>")
        return
      end
    end

    M.open(file, start_line, end_line, floating)
  end, {
    nargs = "*",
    complete = "file",
    desc = "Open a portal into another file",
    range = true,
  })
end

return M
