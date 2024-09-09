local helper = require("vusted.helper")
local plugin_name = helper.get_module_root(...)

helper.root = helper.find_plugin_root(plugin_name)

function helper.before_each() end

function helper.after_each()
  helper.cleanup()
  helper.cleanup_loaded_modules(plugin_name)
end

vim.opt.packpath:prepend(vim.fs.joinpath(helper.root, "spec/.shared/packages"))
require("assertlib").register(require("vusted.assert").register)

return helper
