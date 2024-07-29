---@module "lazy"

---@type LazySpec
local P = {
  "nvim-treesitter/nvim-treesitter-textobjects",
  requires = "nvim-treesitter/nvim-treesitter",
  after = "nvim-treesitter",
}

function P.config()
  local treesitter = require("nvim-treesitter.configs")

  treesitter.setup({
    textobjects = {
      select = {
        enable = true,
        lookahead = true,
        include_surrounding_whitespace = true,

        keymaps = {
          ["af"] = "@function.outer",
          ["if"] = "@function.inner",
          ["ac"] = "@class.outer",
          ["ic"] = "@class.inner",
          ["aa"] = "@parameter.outer",
          ["ia"] = "@parameter.inner",
        },
        selection_modes = {
          ["@function.inner"] = "V",
        },
      },
    },
  })
end

return P
