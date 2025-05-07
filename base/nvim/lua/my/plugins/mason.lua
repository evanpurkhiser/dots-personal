---@module "lazy"

---@type LazySpec
local P = {
  "williamboman/mason.nvim",
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
    "williamboman/mason-lspconfig.nvim",
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
