local Util = {}

function Util.ls(path, fn)
  local handle = vim.uv.fs_scandir(path)
  while handle do
    local name, t = vim.uv.fs_scandir_next(handle)
    if not name then
      break
    end

    local fname = path .. "/" .. name

    -- HACK: type is not always returned due to a bug in luv,
    -- so fecth it with fs_stat instead when needed.
    -- see https://github.com/folke/lazy.nvim/issues/306
    if fn(fname, name, t or vim.uv.fs_stat(fname).type) == false then
      break
    end
  end
end

function Util.walkmods(root, fn, modname)
  modname = modname and (modname:gsub("%.$", "") .. ".") or ""
  Util.ls(root, function(path, name, type)
    if name == "init.lua" then
      fn(modname:gsub("%.$", ""), path)
    elseif (type == "file" or type == "link") and name:sub(-4) == ".lua" then
      fn(modname .. name:sub(1, -5), path)
    elseif type == "directory" then
      Util.walkmods(path, fn, modname .. name .. ".")
    end
  end)
end
