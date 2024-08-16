vim.opt_local.expandtab = true
vim.opt_local.softtabstop = 2
vim.opt_local.shiftwidth = 2


-- Function to search for the type definition
local function goto_definition()
  -- Get the word under the cursor
  local word = vim.fn.expand('<cword>')

  -- Search for the word as a type definition
  local search_pattern = '\\ctype ' .. word .. ' {'

  -- Execute the search command
  vim.fn.search(search_pattern)
end

-- Create a command and map it to the function
vim.api.nvim_create_user_command('GraphQLGoToDefinition', goto_definition, {})

-- Map the 'gd' key to call the 'GraphQLGoToDefinition' command
vim.keymap.set('n', 'gd', '<cmd>GraphQLGoToDefinition<CR>', { buffer = true, desc = 'Go to definition' })
