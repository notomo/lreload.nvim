local helper = require("ntf.helper")
local plugin_name = helper.get_module_root(...)

helper.root = helper.find_plugin_root(plugin_name)

vim.opt.packpath:prepend(vim.fs.joinpath(helper.root, "spec/.shared/packages"))
require("assertlib").register(require("ntf.assert").register)

helper.runtimepath = vim.o.runtimepath

local data_dir = require("lreload.vendor.misclib.test.data_dir")
local data_root = vim.fs.joinpath(helper.root, "spec")

local counter = 0

function helper.before_each()
  vim.o.runtimepath = helper.runtimepath
  helper.test_data = data_dir.setup(data_root)
  vim.opt.runtimepath:append(helper.test_data:path(""))

  counter = counter + 1
  helper.module = ("lreload_test_%d_%d"):format(vim.fn.getpid(), counter)

  local prefix = "lua/" .. helper.module .. "/"
  helper.test_data:create_file(prefix .. "init.lua", "return {}")
  helper.test_data:create_file(prefix .. "data1/dummy.lua", "return {}")
  helper.test_data:create_file(prefix .. "data2/dummy.lua", "return {}")
end

function helper.after_each()
  helper.test_data:teardown()
end

--- Returns the full path of a fixture file under the current test module.
--- @param relative_path string e.g. "init.lua", "data1/dummy.lua"
--- @return string path
function helper.file(relative_path)
  return helper.test_data:path("lua/" .. helper.module .. "/" .. relative_path)
end

return helper
