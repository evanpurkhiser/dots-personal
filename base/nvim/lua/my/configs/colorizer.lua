M = {}

function M.setup()
  local colorizer = safe_require("colorizer")
  if not colorizer then
    return
  end

  colorizer.setup({ "*" }, {
    RRGGBB = true,
    RGB = false,
    names = false,
    RRGGBBAA = false,
  })
end

return M
