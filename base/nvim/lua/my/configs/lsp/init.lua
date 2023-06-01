local M = {}

function M.setup()
  local mason = require("mason")
  local masonLspconfig = require("mason-lspconfig")

  mason.setup()

  masonLspconfig.setup({
    ensure_installed = {
      "ansiblels",
      "bashls",
      "cssls",
      "dockerls",
      "gopls",
      "jsonls",
      "lua_ls",
      "sqlls",
      "tsserver",
    },
  })

  -- Order matters. lspconfig should load after mason-lspconfig
  local lspconfig = require("lspconfig")

  local on_attach = function(client, bufnr)
    require("my.mappings").lsp_mapping(bufnr)
  end

  local capabilities = require("cmp_nvim_lsp").default_capabilities()

  masonLspconfig.setup_handlers({
    -- The first entry (without a key) will be the default handler and will be
    -- called for each installed server that doesn't have a dedicated handler.
    function(server_name)
      lspconfig[server_name].setup({
        on_attach = on_attach,
        capabilites = capabilities,
      })
    end,
    -- you can provide a dedicated handler for specific servers. For example, a
    -- handler override for the `rust_analyzer`:
    --
    -- ["rust_analyzer"] = function ()
    --     require("rust-tools").setup {}
    -- end
  })

  -- Add rounded window borders
  local lspconfig_window = require("lspconfig.ui.windows")
  local old_defaults = lspconfig_window.default_opts

  function lspconfig_window.default_opts(opts)
    local win_opts = old_defaults(opts)
    win_opts.border = "rounded"
    return win_opts
  end

  require("my.configs.lsp.handlers").setup()
end

return M
