local M = {}

function M.setup()
  local null_ls = safe_require("null-ls")
  if not null_ls then
    return
  end

  -- Check supported formatters
  -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
  local formatting = null_ls.builtins.formatting

  null_ls.setup({
    sources = {
      formatting.prettierd,
      formatting.eslint_d,
      formatting.black,
      formatting.isort,
      formatting.gofmt,
      formatting.stylua,
      formatting.shfmt,
    },

    on_attach = function(client)
      -- Handle format on save if we have an active LSP with buffer formatting
      if client.resolved_capabilities.document_formatting then
        vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()")
      end
    end,
  })
end

return M
