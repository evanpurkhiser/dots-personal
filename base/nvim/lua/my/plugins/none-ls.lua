local P = {
  "nvimtools/none-ls.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
}

local augroup_formatting = vim.api.nvim_create_augroup("LspFormatting", {})

function P.config()
  -- XXX: This is a community maintained version of the deprecated null-ls. The
  -- pakcage name is still the same but we'll call it none_ls in here for
  -- consistency.
  local none_ls = require("null-ls")

  local function handleAttach(client, bufnr)
    -- Handle format on save if we have an active LSP with buffer formatting
    if client.supports_method("textDocument/formatting") then
      vim.api.nvim_clear_autocmds({ group = augroup_formatting, buffer = bufnr })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup_formatting,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({ name = "none-ls", bufnr = bufnr, timeout_ms = 10000 })
        end,
      })
    end
  end

  -- Check supported formatters
  -- https://github.com/nvimtools/none-ls.nvim/tree/main/lua/null-ls/builtins/formatting
  local formatting = none_ls.builtins.formatting

  none_ls.setup({
    sources = {
      formatting.black,
      formatting.eslint_d,
      formatting.gofmt,
      formatting.isort,
      formatting.biome,
      formatting.rustfmt.with({ extra_args = { "--edition=2021" } }),
      formatting.shfmt,
      formatting.stylua,
      formatting.jsonnetfmt,
      none_ls.builtins.diagnostics.flake8,
    },

    on_attach = handleAttach,
  })
end

return P
