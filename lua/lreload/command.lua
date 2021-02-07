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

function Command.enable(name)
  vim.validate({name = {name, "string"}})
  local pattern = to_pattern(name)
  local on_write = ([[autocmd %s BufWritePost %s lua require("lreload").refresh("%s")]]):format(group_name, pattern, name)
  vim.cmd(on_write)
end

function Command.disable(name)
  vim.validate({name = {name, "string"}})
  local pattern = to_pattern(name)
  vim.cmd(([[autocmd! %s * %s]]):format(group_name, pattern))
end

return M
