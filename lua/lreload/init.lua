local Command = require("lreload.command").Command

local M = {}

--- Refresh the lua modules.
--- @param module name prefix
function M.refresh(name)
  Command.new("refresh", name)
end

--- Enable hot-reloading for the lua module.
--- @param module name prefix
--- @param (optional) default: {events = {"BufWritePost"}}
function M.enable(name, opts)
  Command.new("enable", name, opts)
end

--- Disable hot-reloading for the lua module.
--- @param module name prefix
function M.disable(name)
  Command.new("disable", name)
end

return M
