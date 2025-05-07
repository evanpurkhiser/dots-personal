---@module "lazy"

---@type LazySpec
local P = {
  "neovim/nvim-lspconfig",
}

P.dependencies = {
  "hrsh7th/nvim-cmp",
  "williamboman/mason.nvim",
  -- Depends on fzf for some lsp keyboard mappings
  "ibhagwan/fzf-lua",
}

function P.config()
  local capabilities = require("cmp_nvim_lsp").default_capabilities()

  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("my.lsp", {}),
    callback = function(args)
      require("my.mappings").lsp_mapping(args.buf)
    end,
  })

  vim.lsp.config("*", {
    capabilities = capabilities,
  })
  vim.lsp.config("rust_analyzer", {
    capabilities = capabilities,
    settings = {
      ["rust-analyzer"] = {
        checkOnSave = true,
        check = { command = "clippy" },
        cargo = { features = "all" },
      },
    },
  })
  vim.lsp.config("basedpyright", {
    capabilities = capabilities,
    settings = {
      basedpyright = {
        analysis = { typeCheckingMode = "off" },
      },
    },
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

  local style = require("my.styles")
  require("lspconfig.ui.windows").default_options.border = style.border

  -- Fix float border highlight group for LspInfo
  vim.api.nvim_set_hl(0, "LspInfoBorder", { link = "FloatBorder" })

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
      border = style.border,
      header = "",
      prefix = "",
    },
  })
end

return P
