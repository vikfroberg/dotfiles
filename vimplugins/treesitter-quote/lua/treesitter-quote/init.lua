local M = {}

function M.find_closest_string_content_node()
  local node = vim.treesitter.get_node({ ignore_injections = false })
  local string_content = nil
  local types = { 'string_content', 'string_fragment' }

  if not node then
    error("No node found under the cursor")
  end

  if vim.tbl_contains(types, node:type()) then
    string_content = node
  else
    for child, _ in node:iter_children() do
      if vim.tbl_contains(types, child:type()) then
        string_content = child
      end
    end
  end

  if not string_content then
    error("No string node found under the cursor")
  end

  return string_content
end

function M.change_quote(new_quote_char)
  local string_content = M.find_closest_string_content_node()
  local text = vim.treesitter.get_node_text(string_content, 0)
  local new_text = new_quote_char .. text .. new_quote_char
  local range = { string_content:range() }
  vim.api.nvim_buf_set_text(0, range[1], range[2] - 1, range[3], range[4] + 1, { new_text })
end

function M.cycle_quotes(quotes)
  local string_content = M.find_closest_string_content_node()

  local range = { string_content:range() }
  local full_range = { range[1], range[2] - 1, range[3], range[4] + 1 }
  local text = table.concat(
    vim.api.nvim_buf_get_text(0, full_range[1], full_range[2], full_range[3], full_range[4], {}), "\n")

  local first_char = text:sub(1, 1)
  if not vim.tbl_contains(quotes, first_char) then
    error("The node under cursor does match any of the following chars " .. table.concat(quotes, ", "))
  end

  local next_quote
  for i, quote in ipairs(quotes) do
    if quote == first_char then
      next_quote = quotes[(i % #quotes) + 1]
      break
    end
  end

  local new_text = next_quote .. text:sub(2, -2) .. next_quote
  vim.api.nvim_buf_set_text(0, full_range[1], full_range[2], full_range[3], full_range[4], { new_text })
end

function M.setup(_)
end

return M
