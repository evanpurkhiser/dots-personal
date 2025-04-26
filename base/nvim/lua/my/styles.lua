M = {}

-- Border used for floating windows
M.border = { "▄", "▄", "▄", "█", "▀", "▀", "▀", "█" }

-- Border for floating windows with only a top border
M.top_only_border = {
  { "▆", "FloatEdgeBorder" },
  { "▆", "FloatEdgeBorder" },
  { "▆", "FloatEdgeBorder" },
  "█",
  "",
  "",
  "",
  "█",
}

local function apply_highlights()
  -- Vertical split coloring
  vim.api.nvim_set_hl(0, "WinSeparator", { link = "Whitespace" })

  -- Float borders match the float window
  local float_normal = vim.api.nvim_get_hl(0, { name = "NormalFloat", link = false })
  vim.api.nvim_set_hl(0, "FloatBorder", { fg = float_normal.bg, bg = "none" })
  vim.api.nvim_set_hl(0, "FloatEdgeBorder", { fg = float_normal.bg, bg = "none" })
end

function M.setup()
  vim.api.nvim_create_autocmd("ColorScheme", {
    desc = "Apply highlight modifications when the colorscheme is applied",
    group = vim.api.nvim_create_augroup("MyHighlights", {}),
    callback = apply_highlights,
  })
end

return M
