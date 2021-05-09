local Command = require("lreload.command").Command

local M = {}

--- Refresh the lua modules.
--- @param name string: module name prefix
function M.refresh(name)
  Command.new("refresh", name)
end

--- Enable hot-reloading for the lua module.
--- @param name string: name prefix
--- @param opts table: default = {events = {"BufWritePost"}, post_hook = nil}
function M.enable(name, opts)
  Command.new("enable", name, opts)
end

--- Disable hot-reloading for the lua module.
--- @param name string: module name prefix
function M.disable(name)
  Command.new("disable", name)
end

return M
