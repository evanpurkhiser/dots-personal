---@module "lazy"

---@type LazySpec
local P = {
  "neovim/nvim-lspconfig",
}

P.dependencies = {
  "hrsh7th/nvim-cmp",
  "williamboman/mason.nvim",
  "williamboman/mason-lspconfig.nvim",

  -- Depends on fzf for some lsp keyboard mappings
  "ibhagwan/fzf-lua",
}

function P.config()
  local masonLspconfig = require("mason-lspconfig")

  masonLspconfig.setup({
    ensure_installed = {
      "ansiblels",
      "bashls",
      "basedpyright",
      "biome",
      "cssls",
      "dockerls",
      "eslint",
      "gopls",
      "jsonls",
      "lua_ls",
      "rust_analyzer",
      "sqlls",
      "ts_ls",
      "yamlls",
    },
  })

  -- Order matters. lspconfig should load after mason-lspconfig
  local lspconfig = require("lspconfig")

  local style = require("my.styles")
  require("lspconfig.ui.windows").default_options.border = style.border

  -- Fix float border highlight group for LspInfo
  vim.api.nvim_set_hl(0, "LspInfoBorder", { link = "FloatBorder" })

  local function on_attach(client, bufnr)
    require("my.mappings").lsp_mapping(bufnr)
  end

  local capabilities = require("cmp_nvim_lsp").default_capabilities()

  masonLspconfig.setup_handlers({
    -- The first entry (without a key) will be the default handler and will be
    -- called for each installed server that doesn't have a dedicated handler.
    function(server_name)
      lspconfig[server_name].setup({
        on_attach = on_attach,
        capabilities = capabilities,
      })
    end,
    -- Server customizations
    ["rust_analyzer"] = function()
      lspconfig["rust_analyzer"].setup({
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
          ["rust-analyzer"] = {
            checkOnSave = true,
            check = { command = "clippy" },
            cargo = { features = "all" },
          },
        },
      })
    end,
    ["basedpyright"] = function()
      lspconfig["basedpyright"].setup({
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
          basedpyright = {
            analysis = { typeCheckingMode = "off" },
          },
        },
      })
    end,
  })

  local signs = {
    { name = "DiagnosticSignError", text = "━" },
    { name = "DiagnosticSignWarn", text = "━" },
    { name = "DiagnosticSignHint", text = "━" },
    { name = "DiagnosticSignInfo", text = "━" },
  }

  for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
  end

  local border = require("my.styles").border

  vim.diagnostic.config({
    virtual_text = false,
    update_in_insert = true,
    underline = true,
    severity_sort = true,
    signs = {
      active = signs,
    },
    float = {
      focusable = false,
      style = "minimal",
      source = true,
      border = border,
      header = "",
      prefix = "",
    },
  })
end

return P
