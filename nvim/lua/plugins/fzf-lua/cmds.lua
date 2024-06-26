local M = {}
local fzf_lua = require "fzf-lua"

M.mru_files = function(opts)
  opts = fzf_lua.config.normalize_opts(opts, "mru_files")
  return fzf_lua.core.fzf_exec({"123"}, opts)
end

return M
