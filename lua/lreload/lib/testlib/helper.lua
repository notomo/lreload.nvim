local plugin_name = vim.split((...):gsub("%.", "/"), "/", true)[1]
local M = require("vusted.helper")

M.root = M.find_plugin_root(plugin_name)

function M.before_each()
  M.cleanup_loaded_modules(plugin_name)
end

function M.after_each()
  pcall(vim.cmd, "autocmd! lreload")
  vim.cmd("tabedit")
  vim.cmd("tabonly!")
  vim.cmd("silent %bwipeout!")
end

return M
