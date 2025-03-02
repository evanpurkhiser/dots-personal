---@module "lazy"

---@type LazySpec
local P = {
  "echasnovski/mini.splitjoin",
}

function P.config()
  require("mini.splitjoin").setup()
end

return P
