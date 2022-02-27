local super = { "cmd", "ctrl", "shift", "alt" }

-- Hide ugly toolbar
hs.console.toolbar(nil)

hs.hotkey.bind(super, "\\", function()
  local nextScreen = hs.window.focusedWindow():screen():next()

  local wf = hs.window.filter.new()
  wf:setOverrideFilter({ allowScreens = nextScreen:id() })
  wf:setSortOrder(hs.window.filter.sortByFocusedLast)

  local window = wf:getWindows()[1]
  window:focus()
  hs.mouse.setAbsolutePosition(window:frame().center)
end)

hs.hotkey.bind(super, "o", function()
  local focused = hs.window.focusedWindow()
  focused:moveToScreen(focused:screen():next())

  focused:focus()
  hs.mouse.setAbsolutePosition(focused:frame().center)
end)

local snapWindow = function(window, gridSize)
  local frame = window:frame()

  for _, axis in ipairs({ "x", "x2", "y", "y2" }) do
    frame[axis] = math.floor((frame[axis] / gridSize) + 0.5) * gridSize
  end

  hs.window.focusedWindow():setFrameInScreenBounds(frame)
end

hs.hotkey.bind(super, "a", function()
  snapWindow(hs.window.focusedWindow(), 10)
end)

hs.hotkey.bind(super, "m", function()
  hs.window.focusedWindow():centerOnScreen()
  snapWindow(hs.window.focusedWindow(), 10)
end)

hs.hotkey.bind(super, "`", nil, function()
  hs.execute("pmset displaysleepnow")
end)

-- Navigate to slack
hs.hotkey.bind(super, "s", function()
  local window = hs.window.filter.new("Slack"):getWindows()[1]
  window:focus()
  hs.mouse.setAbsolutePosition(window:frame().center)
end)
