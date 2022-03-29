local helper = require("lreload.test.helper")
local lreload = helper.require("lreload")

describe("lreload.nvim", function()
  before_each(helper.before_each)
  after_each(helper.after_each)

  it("can refresh a module", function()
    require("lreload.test.data.data1.dummy").loaded = true

    lreload.refresh("lreload.test.data.data1")

    assert.is_nil(require("lreload.test.data.data1.dummy").loaded)
  end)

  it("can refresh a module on write", function()
    require("lreload.test.data.data1.dummy").loaded = true

    lreload.enable("lreload.test.data.data1")

    vim.cmd("edit " .. helper.root .. "/lua/lreload/test/data/data1/dummy.lua")
    vim.cmd("silent write")

    assert.is_nil(require("lreload.test.data.data1.dummy").loaded)
  end)

  it("can refresh on write root module", function()
    require("lreload.test.data").loaded = true

    lreload.enable("lreload.test.data")

    vim.cmd("edit " .. helper.root .. "/lua/lreload/test/data/init.lua")
    vim.cmd("silent write")

    assert.is_nil(require("lreload.test.data").loaded)
  end)

  it("can refresh modules on write", function()
    require("lreload.test.data.data1.dummy").loaded = true
    require("lreload.test.data.data2.dummy").loaded = true

    lreload.enable("lreload.test.data.data1")
    lreload.enable("lreload.test.data.data2")

    vim.cmd("edit " .. helper.root .. "/lua/lreload/test/data/data1/dummy.lua")
    vim.cmd("silent write")
    vim.cmd("edit " .. helper.root .. "/lua/lreload/test/data/data2/dummy.lua")
    vim.cmd("silent write")

    assert.is_nil(require("lreload.test.data.data1.dummy").loaded)
    assert.is_nil(require("lreload.test.data.data2.dummy").loaded)
  end)

  it("can disable hot-reloading", function()
    require("lreload.test.data").loaded = true

    lreload.enable("lreload.test.data")
    lreload.disable("lreload.test.data")

    vim.cmd("edit " .. helper.root .. "/lua/lreload/test/data/init.lua")
    vim.cmd("silent write")

    assert.is_true(require("lreload.test.data").loaded)
  end)

  it("can custom trigger events", function()
    require("lreload.test.data").loaded = true

    lreload.enable("lreload.test.data", { events = { "BufLeave" } })
    vim.cmd("edit " .. helper.root .. "/lua/lreload/test/data/init.lua")
    vim.cmd("tabedit")

    assert.is_nil(require("lreload.test.data").loaded)
  end)

  it("can custom post reload hook", function()
    local post_hooked = false
    require("lreload.test.data").loaded = true

    lreload.enable("lreload.test.data", {
      post_hook = function()
        post_hooked = true
      end,
    })
    vim.cmd("edit " .. helper.root .. "/lua/lreload/test/data/init.lua")
    vim.cmd("silent write")

    assert.is_true(post_hooked)
  end)

  it("avoids duplicated autocmd", function()
    local called_count = 0

    lreload.enable("lreload.test.data", {
      post_hook = function()
        called_count = called_count + 1
      end,
    })
    lreload.enable("lreload.test.data", {
      post_hook = function()
        called_count = called_count + 1
      end,
    })
    vim.cmd("edit " .. helper.root .. "/lua/lreload/test/data/init.lua")
    vim.cmd("silent write")

    assert.is_same(1, called_count)
  end)
end)
