local P = {
  "williamboman/mason.nvim",
  build = ":MasonUpdate",
  cmd = {
    "Mason",
    "MasonInstall",
    "MasonUninstall",
    "MasonUninstallAll",
    "MasonUpdate",
    "MasonLog",
  },
}

function P.config()
  require("mason").setup()
end

return P
