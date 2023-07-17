local P = {
  "jose-elias-alvarez/null-ls.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
}

local augroup_formatting = vim.api.nvim_create_augroup("LspFormatting", {})

function P.config()
  local null_ls = require("null-ls")

  local function handleAttach(client, bufnr)
    -- Handle format on save if we have an active LSP with buffer formatting
    if client.supports_method("textDocument/formatting") then
      vim.api.nvim_clear_autocmds({ group = augroup_formatting, buffer = bufnr })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup_formatting,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({ name = "null-ls", bufnr = bufnr, timeout_ms = 10000 })
        end,
      })
    end
  end

  -- Check supported formatters
  -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
  local formatting = null_ls.builtins.formatting

  null_ls.setup({
    sources = {
      formatting.black,
      formatting.eslint_d,
      formatting.gofmt,
      formatting.isort,
      formatting.prettierd,
      formatting.rustfmt.with({ extra_args = { "--edition=2021" } }),
      formatting.shfmt,
      formatting.stylua,
      formatting.jsonnetfmt,
    },

    on_attach = handleAttach,
  })
end

return P