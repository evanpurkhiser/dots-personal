---@module "lazy"

---@type LazySpec
local P = {
  "ellisonleao/gruvbox.nvim",
}

function P.config()
  vim.cmd("colorscheme gruvbox")

  vim.api.nvim_set_hl(0, "SignColumn", { link = "GruvboxBg0" })
end

return P
