local M = {}

function M.setup()
  require("my.configs.lsp.installer").setup()

  local lspconfig = safe_require("lspconfig")
  if not lspconfig then
    return
  end

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
