local helper = require("lreload.lib.testlib.helper")
local lreload = require("lreload")

describe("lreload.nvim", function()

  before_each(helper.before_each)
  after_each(helper.after_each)

  it("can refresh a module", function()
    require("lreload.lib.testdata.data1.dummy").loaded = true

    lreload.refresh("lreload.lib.testdata.data1")

    assert.is_nil(require("lreload.lib.testdata.data1.dummy").loaded)
  end)

  it("can refresh a module on write", function()
    require("lreload.lib.testdata.data1.dummy").loaded = true

    lreload.enable("lreload.lib.testdata.data1")

    vim.cmd("edit " .. helper.root .. "/lua/lreload/lib/testdata/data1/dummy.lua")
    vim.cmd("silent write")

    assert.is_nil(require("lreload.lib.testdata.data1.dummy").loaded)
  end)

  it("can refresh on write root module", function()
    require("lreload.lib.testdata.data").loaded = true

    lreload.enable("lreload.lib.testdata.data")

    vim.cmd("edit " .. helper.root .. "/lua/lreload/lib/testdata/data.lua")
    vim.cmd("silent write")

    assert.is_nil(require("lreload.lib.testdata.data").loaded)
  end)

  it("can refresh modules on write", function()
    require("lreload.lib.testdata.data1.dummy").loaded = true
    require("lreload.lib.testdata.data2.dummy").loaded = true

    lreload.enable("lreload.lib.testdata.data1")
    lreload.enable("lreload.lib.testdata.data2")

    vim.cmd("edit " .. helper.root .. "/lua/lreload/lib/testdata/data1/dummy.lua")
    vim.cmd("silent write")
    vim.cmd("edit " .. helper.root .. "/lua/lreload/lib/testdata/data2/dummy.lua")
    vim.cmd("silent write")

    assert.is_nil(require("lreload.lib.testdata.data1.dummy").loaded)
    assert.is_nil(require("lreload.lib.testdata.data2.dummy").loaded)
  end)

  it("can disable hot-reloading", function()
    require("lreload.lib.testdata.data").loaded = true

    lreload.enable("lreload.lib.testdata.data")
    lreload.disable("lreload.lib.testdata.data")

    vim.cmd("edit " .. helper.root .. "/lua/lreload/lib/testdata/data.lua")
    vim.cmd("silent write")

    assert.is_true(require("lreload.lib.testdata.data").loaded)
  end)

end)
