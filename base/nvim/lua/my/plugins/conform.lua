---@module "lazy"

---@type LazySpec
local P = {
  "stevearc/conform.nvim",
}

function P.config()
  local conform = require("conform")

  local jsformat = {
    "prettierd",
    "eslint_d",
  }

  conform.setup({
    log_level = vim.log.levels.TRACE,

    format_on_save = {
      -- These options will be passed to conform.format()
      timeout_ms = 5000,
      lsp_fallback = true,
    },

    formatters_by_ft = {
      lua = { "stylua" },
      python = { "black", "isort" },
      go = { "gofmt" },
      sh = { "shfmt" },
      rust = { "rustfmt" },
      toml = { "taplo" },
      javascript = jsformat,
      javascriptreact = jsformat,
      typescript = jsformat,
      typescriptreact = jsformat,
      json = { "prettierd" },
      jsonnet = { "jsonnetfmt" },
    },
  })
end

return P
