---@module "lazy"

---@type LazySpec
local P = {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  cmd = {
    "TSInstall",
    "TSInstallInfo",
    "TSInstallSync",
    "TSUninstall",
    "TSUpdate",
    "TSUpdateSync",
  },
}

local languages = {
  "bash",
  "c",
  "cpp",
  "css",
  "dockerfile",
  "go",
  "html",
  "javascript",
  "jq",
  "json",
  "jsonnet",
  "lua",
  "markdown",
  "php",
  "python",
  "regex",
  "rust",
  "toml",
  "tsx",
  "typescript",
  "vim",
  "vimdoc",
}

function P.config()
  require("nvim-treesitter").install(languages)
end

return P
