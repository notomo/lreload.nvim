local M = {}

M.default = {
  events = { "BufWritePost" },
  post_hook = function() end,
  pre_hook = function() end,
}

--- @param raw_opts table?
function M.new(raw_opts)
  raw_opts = raw_opts or {}
  return vim.tbl_deep_extend("force", M.default, raw_opts)
end

return M
