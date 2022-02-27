local M = {}

function M.setup()
  local status_ok, lsp_installer = pcall(require, "nvim-lsp-installer")
  if not status_ok then
    return
  end

  local handlers = require("configs.lsp.handlers")

  lsp_installer.on_server_ready(function(server)
    local opts = server:get_default_options()
    opts.on_attach = handlers.on_attach
    opts.capabilities = handlers.capabilities

    server:setup(opts)
  end)
end

return M
