local M = {}
local uv = vim.uv or vim.loop
local core = require "fzf-lua.core"
local path = require "fzf-lua.path"
local utils = require "fzf-lua.utils"
local config = require "fzf-lua.config"

M.mru_files = function(opts)
  local function merge_table(table1, table2)
    for _, value in ipairs(table2) do
      table1[#table1+1] = value
    end
    return table1
  end

  opts = config.normalize_opts(opts, "files")
  local curbuf = vim.api.nvim_buf_get_name(0)
  if #curbuf > 0 then
    curbuf = path.relative_to(curbuf, opts.cwd or uv.cwd())
    opts.file_ignore_patterns = opts.file_ignore_patterns or {}
    table.insert(opts.file_ignore_patterns,
      "^" .. utils.lua_regex_escape(curbuf) .. "$")
  end
  opts.cmd = string.format("fd %s", opts.fd_opts)
  local contents = core.mt_cmd_wrapper(opts)
  opts = core.set_header(opts, opts.headers or { "actions", "cwd" })
  return core.fzf_exec(contents, opts)
end

return M
