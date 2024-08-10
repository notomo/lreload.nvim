local M = {}

M.default = {
  events = { "BufWritePost" },
  post_hook = function() end,
  pre_hook = function() end,
}

function M.new(raw_opts)
  vim.validate({ raw_opts = { raw_opts, "table", true } })
  raw_opts = raw_opts or {}
  local opts = vim.tbl_deep_extend("force", M.default, raw_opts)
  vim.validate({
    events = { opts.events, "table" },
    post_hook = { opts.post_hook, "function" },
    pre_hook = { opts.pre_hook, "function" },
  })
  return opts
end

return M
