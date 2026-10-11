local config = require(".config")

local super = config.super

-- hammerspoon reload
hs.hotkey.bind(super, "0", function()
  hs.reload()
end)

-- Sleep monitor
hs.hotkey.bind(super, "`", nil, function()
  hs.execute("pmset displaysleepnow")
end)

-- Align windows to the center of the screen
hs.hotkey.bind(super, "m", function()
  local screen = hs.screen.mainScreen():frame()
  local window = hs.window.focusedWindow():frame()

  window.x = screen.center.x - (window.w / 2)
  window.y = screen.center.y - (window.h / 2)

  hs.window.focusedWindow():setFrame(window)
end)
