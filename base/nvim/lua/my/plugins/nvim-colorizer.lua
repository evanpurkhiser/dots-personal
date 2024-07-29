---@type LazySpec
local P = {
  "norcalli/nvim-colorizer.lua",
}

function P.config()
  local colorizer = require("colorizer")

  colorizer.setup({ "*" }, {
    RRGGBB = true,
    RGB = false,
    names = false,
    RRGGBBAA = false,
  })
end

return P
