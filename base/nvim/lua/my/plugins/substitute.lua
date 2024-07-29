---@type LazySpec
local P = {
  "gbprod/substitute.nvim",
}

function P.config()
  local substitute = require("substitute")

  substitute.setup()

  require("my.mappings").substitute_mapping(substitute)
end

return P
