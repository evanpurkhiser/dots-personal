---@module "lazy"

---@type LazySpec
local P = {
  "mason-org/mason.nvim",
  build = ":MasonUpdate",
  cmd = {
    "Mason",
    "MasonInstall",
    "MasonUninstall",
    "MasonUninstallAll",
    "MasonUpdate",
    "MasonLog",
  },
  dependencies = {
    "mason-org/mason-lspconfig.nvim",
  },
}

function P.config()
  require("mason").setup()
  require("mason-lspconfig").setup({
    ensure_installed = {
      "ansiblels",
      "bashls",
      "basedpyright",
      "cssls",
      "dockerls",
      "gopls",
      "jsonls",
      "lua_ls",
      "rust_analyzer",
      "sqlls",
      "ts_ls",
      "yamlls",
    },
  })
end

return P
