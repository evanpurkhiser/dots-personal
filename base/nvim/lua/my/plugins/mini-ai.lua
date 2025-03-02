---@module "lazy"

---@type LazySpec
local P = {
  "echasnovski/mini.ai",
}

function P.config()
  local miniAI = require("mini.ai")

  miniAI.setup({
    custom_textobjects = {
      -- Include `<>` for argument consideration
      a = miniAI.gen_spec.argument({ brackets = { "%b()", "%b[]", "%b<>", "%b{}" } }),
    },
  })
end

return P
