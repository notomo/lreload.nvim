local M = {}

--- Refresh the lua modules.
--- @param name string: module name prefix
function M.refresh(name)
  require("lreload.command").refresh(name)
end

--- @class LreloadOption
--- @field events string[]? autocmd events. default: { "BufWritePost" }
--- @field post_hook fun(args:table?)? called after refreshed.
---  The function arugment is |nvim_create_autocmd()| callback argument.
---  default: function(_) end
--- @field pre_hook fun(args:table?)? called before refreshed.
---  The function arugment is |nvim_create_autocmd()| callback argument.
---  default: function(_) end

--- Enable hot-reloading for the lua module.
--- @param name string: name prefix
--- @param opts LreloadOption?: |LreloadOption|
function M.enable(name, opts)
  require("lreload.command").enable(name, opts)
end

--- Disable hot-reloading for the lua module.
--- @param name string: module name prefix
function M.disable(name)
  require("lreload.command").disable(name)
end

return M
