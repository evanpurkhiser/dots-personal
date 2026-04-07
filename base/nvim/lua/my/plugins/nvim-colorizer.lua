---@module "lazy"

---@type LazySpec
local P = {
  "catgoose/nvim-colorizer.lua",
  event = "BufReadPre",
  opts = {
    filetypes = { "*" },
    options = {
      parsers = {
        names = { enable = false },
      },
    },
  },
}

return P
