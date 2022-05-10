local M = {}

function M.setup()
  local signs = {
    { name = "DiagnosticSignError", text = "" },
    { name = "DiagnosticSignWarn", text = "" },
    { name = "DiagnosticSignHint", text = "" },
    { name = "DiagnosticSignInfo", text = "" },
  }

  for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
  end

  local diagnostics_config = {
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
      border = "rounded",
      source = "always",
      header = "",
      prefix = "",
    },
  }

  vim.diagnostic.config(diagnostics_config)

  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
    vim.lsp.handlers.hover,
    { border = "rounded" }
  )

  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
    vim.lsp.handlers.signature_help,
    { border = "rounded" }
  )
end

local function lsp_keymaps(bufnr)
  local map = require("my.utils").map

  map.nmap({
    "gD",
    "<cmd>lua vim.lsp.buf.declaration()<CR>",
    bufnr = bufnr,
  })
  map.nmap({
    "gd",
    "<cmd>lua vim.lsp.buf.definition()<CR>",
    bufnr = bufnr,
  })

  map.nmap({
    "gi",
    "<cmd>lua vim.lsp.buf.implementation()<CR>",
    bufnr = bufnr,
  })
  map.nmap({
    "gr",
    "<cmd>lua vim.lsp.buf.references()<CR>",
    bufnr = bufnr,
  })
  map.nmap({
    "<space>",
    "<cmd>lua vim.lsp.buf.hover()<CR>",
    bufnr = bufnr,
  })
  map.nmap({
    "<C-p>",
    '<cmd>lua vim.diagnostic.goto_prev({ border = "rounded" })<CR>',
    bufnr = bufnr,
  })
  map.nmap({
    "<C-n>",
    '<cmd>lua vim.diagnostic.goto_next({ border = "rounded" })<CR>',
    bufnr = bufnr,
  })

  vim.cmd([[ command! Format execute 'lua vim.lsp.buf.formatting()' ]])
end

M.on_attach = function(client, bufnr)
  if client.name == "tsserver" then
    client.server_capabilities.documentFormattingProvider = false
  end
  if client.name == "jsonls" then
    client.server_capabilities.documentFormattingProvider = false
  end
  if client.name == "html" then
    client.server_capabilities.documentFormattingProvider = false
  end
  lsp_keymaps(bufnr)
end

local capabilities

capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

M.capabilities = capabilities

return M
