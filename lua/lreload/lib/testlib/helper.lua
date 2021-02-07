local M = {}

M.root = require("lreload.lib.path").find_root()

function M.before_each()
  require("lreload").refresh("lreload")
end

function M.after_each()
  pcall(vim.cmd, "autocmd! lreload")
  vim.cmd("tabedit")
  vim.cmd("tabonly!")
  vim.cmd("silent %bwipeout!")
end

return M
