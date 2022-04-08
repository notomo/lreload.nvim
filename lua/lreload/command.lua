local ShowError = require("lreload.vendor.misclib.error_handler").for_show_error()

local _post_hooks = {}

function ShowError.refresh(name, autocmd_callback_args)
  vim.validate({
    name = { name, "string" },
    autocmd_callback_args = { autocmd_callback_args, "table", true },
  })
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

function ShowError.enable(name, raw_opts)
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
      require("lreload.command").refresh(name, args)
    end,
    desc = group_name,
  })
  _post_hooks[name] = opts.post_hook
end

function ShowError.disable(name)
  vim.validate({ name = { name, "string" } })
  vim.api.nvim_clear_autocmds({ group = to_group_name(name) })
  _post_hooks[name] = nil
end

return ShowError:methods()
