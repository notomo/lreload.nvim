local messagelib = require("lreload.lib.message")

local M = {}

local Command = {}
Command.__index = Command
M.Command = Command

function Command.new(name, ...)
  local args = {...}
  local f = function()
    return Command[name](unpack(args))
  end

  local ok, msg = xpcall(f, debug.traceback)
  if not ok then
    return messagelib.error(msg)
  end
end

function Command.refresh(name)
  vim.validate({name = {name, "string"}})
  local dir = name:gsub("/", ".") .. "."
  for key in pairs(package.loaded) do
    if (vim.startswith(key:gsub("/", "."), dir) or key == name) then
      package.loaded[key] = nil
    end
  end
end

local group_name = "lreload"
vim.cmd("augroup " .. group_name)
vim.cmd("augroup END")

local to_pattern = function(name)
  local path = name:gsub("%.", "/")
  return ("*/lua/%s.lua,*/lua/%s/*"):format(path, path)
end

function Command.enable(name, opts)
  vim.validate({name = {name, "string"}, opts = {opts, "table", true}})
  opts = opts or {}

  vim.validate({events = {opts.events, "table", true}})
  opts.events = opts.events or {"BufWritePost"}

  local pattern = to_pattern(name)
  for _, event in ipairs(opts.events) do
    local cmd = ([[autocmd %s %s %s lua require("lreload").refresh("%s")]]):format(group_name, event, pattern, name)
    vim.cmd(cmd)
  end
end

function Command.disable(name)
  vim.validate({name = {name, "string"}})
  local pattern = to_pattern(name)
  vim.cmd(([[autocmd! %s * %s]]):format(group_name, pattern))
end

return M
