M = {}

function M.setup()
  local colorizer = safe_require("colorizer")
  if not colorizer then
    return
  end

  colorizer.setup({ "*" }, {
    RGB = true,
    RRGGBB = true,
    names = false,
    RRGGBBAA = false,
  })
end

return M
