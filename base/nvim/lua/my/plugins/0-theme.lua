---@type LazySpec
local P = {
  "ellisonleao/gruvbox.nvim",
}

function P.config()
  vim.cmd("colorscheme gruvbox")
end

return P
