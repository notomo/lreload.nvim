local M = {}

local _pre_hooks = {}
local _post_hooks = {}

function M.refresh(name, autocmd_callback_args)
  local pre_hook = _pre_hooks[name]
  if pre_hook then
    pre_hook(autocmd_callback_args)
  end

  local dir = name:gsub("/", ".") .. "."
  for key in pairs(package.loaded) do
    if vim.startswith(key:gsub("/", "."), dir) or key == name then
      package.loaded[key] = nil
    end
  end

  local post_hook = _post_hooks[name]
  if post_hook then
    post_hook(autocmd_callback_args)
  end
end

local to_group_name = function(name)
  return "lreload_" .. name
end

function M.enable(name, raw_opts)
  local opts = require("lreload.option").new(raw_opts)
  local path = name:gsub("%.", "/")
  local group_name = to_group_name(name)
  vim.api.nvim_create_autocmd(opts.events, {
    group = vim.api.nvim_create_augroup(group_name, {}),
    pattern = {
      ("*/lua/%s.lua"):format(path),
      ("*/lua/%s/*"):format(path),
    },
    callback = function(args)
      M.refresh(name, args)
    end,
  })
  _pre_hooks[name] = opts.pre_hook
  _post_hooks[name] = opts.post_hook
end

function M.disable(name)
  vim.api.nvim_clear_autocmds({ group = to_group_name(name) })
  _pre_hooks[name] = nil
  _post_hooks[name] = nil
end

return M
