---@module "lazy"

---@type LazySpec
local P = {
  "echasnovski/mini.surround",
}

function P.config()
  require("mini.surround").setup()
end

return P
