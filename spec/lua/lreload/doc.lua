local util = require("genvdoc.util")
local plugin_name = vim.env.PLUGIN_NAME
local full_plugin_name = plugin_name .. ".nvim"

local example_path = ("./spec/lua/%s/example.lua"):format(plugin_name)
dofile(example_path)

require("genvdoc").generate(full_plugin_name, {
  chapters = {
    {
      name = function(group)
        return "Lua module: " .. group
      end,
      group = function(node)
        if node.declaration == nil then
          return nil
        end
        return node.declaration.module
      end,
    },
    {
      name = "TYPES",
      body = function(ctx)
        local opts_text
        do
          local descriptions = {
            events = [[(table): autocmd events. default: %s]],
            post_hook = [[(function): called after refreshed.
  The function arugment is the same with autocmd api callback.
  default: function(args) end]],
          }
          local default = require("lreload.option").default
          local keys = vim.tbl_keys(default)
          local lines = util.each_keys_description(keys, descriptions, default)
          opts_text = table.concat(lines, "\n")
        end

        return util.sections(ctx, {
          { name = "options", tag_name = "opts", text = opts_text },
        })
      end,
    },
    {
      name = "EXAMPLES",
      body = function()
        return util.help_code_block_from_file(example_path)
      end,
    },
  },
})

local gen_readme = function()
  local f = io.open(example_path, "r")
  local exmaple = f:read("*a")
  f:close()

  local content = ([[
# %s

Hot-reloading manager for neovim lua plugin development

## Example

```lua
%s```]]):format(full_plugin_name, exmaple)

  local readme = io.open("README.md", "w")
  readme:write(content)
  readme:close()
end
gen_readme()
