local super = { "cmd", "ctrl", "shift", "alt" }

-- Hide ugly toolbar
hs.console.toolbar(nil)

-- Disable window movment animations
hs.window.animationDuration = 0

-- hammerspoon reload
hs.hotkey.bind(super, "0", function()
  hs.reload()
end)

-- Toggle between previously focused windows
hs.hotkey.bind(super, "\\", function()
  local nextScreen = hs.window.focusedWindow():screen():next()

  local wf = hs.window.filter.new()
  wf:setOverrideFilter({ allowScreens = nextScreen:id() })
  wf:setSortOrder(hs.window.filter.sortByFocusedLast)

  local window = wf:getWindows()[1]
  window:focus()
  hs.mouse.setAbsolutePosition(window:frame().center)
end)

local function snapWindow(window, gridSize)
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

-- Copy the name and position of the focused window to
hs.hotkey.bind(super, "-", function()
  local window = hs.window.focusedWindow()

  local content = string.format(
    '["%s"] = "%s",',
    window:application():name(),
    window:frame().string
  )

  hs.pasteboard.setContents(content)
  hs.notify.show("Window Details Copied", "Window name and coordinates copied", "")
end)

local homeSetup = {
  ["Google Chrome"] = "1130,30/1420x1400",
  ["Cron"] = "10,30/1110x760",
  ["Spark"] = "10,30/1110x760",
  ["Slack"] = "10,30/1110x760",
  ["Telegram"] = "10,800/550x630",
  ["Messages"] = "10,800/550x630",
  ["Things"] = "570,800/550x630",
}

-- Hotkey to re-align windows
hs.hotkey.bind(super, "=", function()
  for name, pos in pairs(homeSetup) do
    local appWindows = hs.window.filter.new(name):getWindows()
    if #appWindows > 0 then
      print(appWindows[1]:isVisible())

      appWindows[1]:raise()
      appWindows[1]:setFrame(pos)
    end
  end
end)

local function cycleWindowFocus(filterGroup)
  return function()
    local lastFocused = filterGroup:getWindows(hs.window.filter.sortByFocusedLast)[1]

    -- If none of the windows are currently focused, focused the one most visible
    local focusOrder = hs.window.filter.sortByFocused

    -- If we aren't focusing the top window make sure we focus it first before
    -- cycling through the other windows.
    if lastFocused ~= hs.window.focusedWindow() then
      focusOrder = hs.window.filter.sortByFocusedLast
    end

    local window = filterGroup:getWindows(focusOrder)[1]
    window:focus()
    hs.mouse.setAbsolutePosition(window:frame().center)
  end
end

-- Focus Slack / Cron / Spark
hs.hotkey.bind(
  super,
  "1",
  cycleWindowFocus(hs.window.filter.new({ "Slack", "Cron", "Spark" }))
)

-- Focus telegram window
hs.hotkey.bind(
  super,
  "2",
  cycleWindowFocus(hs.window.filter.new({ "Telegram", "Messages" }))
)
