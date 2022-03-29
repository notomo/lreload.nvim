local ShowError = require("lreload.vendor.misclib.error_handler").for_show_error()

local _post_hooks = {}

function ShowError.refresh(name)
  vim.validate({ name = { name, "string" } })
  local dir = name:gsub("/", ".") .. "."
  for key in pairs(package.loaded) do
    if vim.startswith(key:gsub("/", "."), dir) or key == name then
      package.loaded[key] = nil
    end
  end

  local post_hook = _post_hooks[name]
  if post_hook then
    post_hook()
  end
end

local to_pattern = function(name)
  local path = name:gsub("%.", "/")
  return ("*/lua/%s.lua,*/lua/%s/*"):format(path, path)
end

local to_group_name = function(name)
  return "lreload_" .. name
end

function ShowError.enable(name, opts)
  vim.validate({ name = { name, "string" }, opts = { opts, "table", true } })
  opts = opts or {}

  vim.validate({ events = { opts.events, "table", true } })
  opts.events = opts.events or { "BufWritePost" }

  vim.validate({ post_hook = { opts.post_hook, "function", true } })

  local group = vim.api.nvim_create_augroup(to_group_name(name), {})
  vim.api.nvim_create_autocmd(opts.events, {
    group = group,
    pattern = { to_pattern(name) },
    callback = function()
      require("lreload").refresh(name)
    end,
  })

  if opts.post_hook then
    _post_hooks[name] = opts.post_hook
  end
end

function ShowError.disable(name)
  vim.validate({ name = { name, "string" } })
  vim.api.nvim_create_augroup(to_group_name(name), {})
  _post_hooks[name] = nil
end

return ShowError:methods()
