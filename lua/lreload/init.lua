local M = {}

--- Refresh the lua modules.
--- @param name string: module name prefix
function M.refresh(name)
  require("lreload.command").refresh(name)
end

--- Enable hot-reloading for the lua module.
--- @param name string: name prefix
--- @param opts table|nil: |lreload.nvim-opts|
function M.enable(name, opts)
  require("lreload.command").enable(name, opts)
end

--- Disable hot-reloading for the lua module.
--- @param name string: module name prefix
function M.disable(name)
  require("lreload.command").disable(name)
end

return M
