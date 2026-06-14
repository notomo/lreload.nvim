local ntf = require("ntf")
local describe, it, before_each, after_each = ntf.describe, ntf.it, ntf.before_each, ntf.after_each
local helper = require("lreload.test.helper")
local lreload = require("lreload")
local assert = require("assertlib").typed(ntf.assert)

describe("lreload.nvim", function()
  before_each(helper.before_each)
  after_each(helper.after_each)

  it("can refresh a module", function()
    require(helper.module .. ".data1.dummy").loaded = true

    lreload.refresh(helper.module .. ".data1")

    assert.is_nil(require(helper.module .. ".data1.dummy").loaded)
  end)

  it("can refresh a module on write", function()
    require(helper.module .. ".data1.dummy").loaded = true

    lreload.enable(helper.module .. ".data1")

    vim.cmd.edit(helper.file("data1/dummy.lua"))
    vim.cmd.write({ mods = { silent = true } })

    assert.is_nil(require(helper.module .. ".data1.dummy").loaded)
  end)

  it("can refresh on write root module", function()
    require(helper.module).loaded = true

    lreload.enable(helper.module)

    vim.cmd.edit(helper.file("init.lua"))
    vim.cmd.write({ mods = { silent = true } })

    assert.is_nil(require(helper.module).loaded)
  end)

  it("can refresh modules on write", function()
    require(helper.module .. ".data1.dummy").loaded = true
    require(helper.module .. ".data2.dummy").loaded = true

    lreload.enable(helper.module .. ".data1")
    lreload.enable(helper.module .. ".data2")

    vim.cmd.edit(helper.file("data1/dummy.lua"))
    vim.cmd.write({ mods = { silent = true } })
    vim.cmd.edit(helper.file("data2/dummy.lua"))
    vim.cmd.write({ mods = { silent = true } })

    assert.is_nil(require(helper.module .. ".data1.dummy").loaded)
    assert.is_nil(require(helper.module .. ".data2.dummy").loaded)
  end)

  it("can disable hot-reloading", function()
    require(helper.module).loaded = true

    lreload.enable(helper.module)
    lreload.disable(helper.module)

    vim.cmd.edit(helper.file("init.lua"))
    vim.cmd.write({ mods = { silent = true } })

    assert.is_true(require(helper.module).loaded)
  end)

  it("can custom trigger events", function()
    require(helper.module).loaded = true

    lreload.enable(helper.module, { events = { "BufLeave" } })
    vim.cmd.edit(helper.file("init.lua"))
    vim.cmd.tabedit()

    assert.is_nil(require(helper.module).loaded)
  end)

  it("can custom post reload hook", function()
    local pre_hooked = false
    require(helper.module).loaded = true

    lreload.enable(helper.module, {
      pre_hook = function()
        assert.is_true(require(helper.module).loaded)
        pre_hooked = true
      end,
    })
    vim.cmd.edit(helper.file("init.lua"))
    vim.cmd.write({ mods = { silent = true } })

    assert.is_true(pre_hooked)
  end)

  it("can custom post reload hook", function()
    local post_hooked = false
    require(helper.module).loaded = true

    lreload.enable(helper.module, {
      post_hook = function()
        assert.is_nil(require(helper.module).loaded)
        post_hooked = true
      end,
    })
    vim.cmd.edit(helper.file("init.lua"))
    vim.cmd.write({ mods = { silent = true } })

    assert.is_true(post_hooked)
  end)

  it("can receive autocmd callback arguments by pre reload hook", function()
    require(helper.module).loaded = true

    local received
    lreload.enable(helper.module, {
      pre_hook = function(args)
        received = args
      end,
    })
    vim.cmd.edit(helper.file("init.lua"))
    vim.cmd.write({ mods = { silent = true } })

    assert.equal("BufWritePost", received.event)
  end)

  it("can receive autocmd callback arguments by post reload hook", function()
    require(helper.module).loaded = true

    local received
    lreload.enable(helper.module, {
      post_hook = function(args)
        received = args
      end,
    })
    vim.cmd.edit(helper.file("init.lua"))
    vim.cmd.write({ mods = { silent = true } })

    assert.equal("BufWritePost", received.event)
  end)

  it("avoids duplicated autocmd", function()
    local called_count = 0

    lreload.enable(helper.module, {
      post_hook = function()
        called_count = called_count + 1
      end,
    })
    lreload.enable(helper.module, {
      post_hook = function()
        called_count = called_count + 1
      end,
    })
    vim.cmd.edit(helper.file("init.lua"))
    vim.cmd.write({ mods = { silent = true } })

    assert.same(1, called_count)
  end)
end)
