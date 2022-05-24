local M = {}

-- if you want to set up formatting on save, you can use this as a callback
local augroup_formatting = vim.api.nvim_create_augroup("LspFormatting", {})

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

    on_attach = function(client, bufnr)
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
    end,
  })
end

return M
