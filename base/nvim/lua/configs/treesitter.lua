local M = {}

function M.setup()
  local status_ok, treesitter = pcall(require, "nvim-treesitter.configs")
  if not status_ok then
    return
  end

  treesitter.setup({
    ensure_installed = {},
    sync_install = false,
    ignore_install = {},
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },
    context_commentstring = {
      enable = true,
      enable_autocmd = false,
    },
    autopairs = {
      enable = true,
    },
    incremental_selection = {
      enable = true,
    },
    indent = {
      enable = true,
    },
    rainbow = {
      enable = true,
      disable = { "html" },
      extended_mode = false,
      max_file_lines = nil,
    },
    autotag = {
      enable = true,
    },
  })
end

return M
