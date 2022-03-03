local M = {}

function M.setup()
  local lsp_installer = safe_require("nvim-lsp-installer")
  if not lsp_installer then
    return
  end

  local handlers = require("my.configs.lsp.handlers")

  lsp_installer.on_server_ready(function(server)
    local opts = server:get_default_options()
    opts.on_attach = handlers.on_attach
    opts.capabilities = handlers.capabilities

    server:setup(opts)
  end)
end

return M
