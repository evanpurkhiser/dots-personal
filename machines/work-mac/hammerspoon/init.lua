super = {"cmd", "ctrl", "shift", "alt"}

-- See https://github.com/Hammerspoon/hammerspoon/issues/595
windowFilter = hs.window.filter.new():setCurrentSpace(true)

-- Window navigation
hs.hotkey.bind(super, "up", function()
    windowFilter:focusWindowNorth(nil, true)
    hs.mouse.setAbsolutePosition(hs.window.focusedWindow():frame().center)
end)

hs.hotkey.bind(super, "down", function()
    windowFilter:focusWindowSouth(nil, true)
    hs.mouse.setAbsolutePosition(hs.window.focusedWindow():frame().center)
end)

hs.hotkey.bind(super, "left", function()
    windowFilter:focusWindowWest()
    hs.mouse.setAbsolutePosition(hs.window.focusedWindow():frame().center)
end)

hs.hotkey.bind(super, "right", function()
    windowFilter:focusWindowEast(nil, true)
    hs.mouse.setAbsolutePosition(hs.window.focusedWindow():frame().center)
end)

hs.hotkey.bind(super, "\\", function()
    nextScreen = hs.window.focusedWindow():screen():next()

    wf = hs.window.filter.new()
    wf:setOverrideFilter({ allowScreens = nextScreen:id() })
    wf:setSortOrder(hs.window.filter.sortByFocusedLast)

    window = wf:getWindows()[1]
    window:focus()
    hs.mouse.setAbsolutePosition(window:frame().center)
end)

-- Window focus toggling
function toggleWindowFocus(windowName)
    return function()
        window = hs.window.filter.new(windowName):getWindows()[1]

        hs.mouse.setAbsolutePosition(window:frame().center)
        window:focus()
    end
end

hs.hotkey.bind(super, "s", toggleWindowFocus("Slack"))
hs.hotkey.bind(super, "d", toggleWindowFocus("Terminal"))
hs.hotkey.bind(super, "f", toggleWindowFocus("Google Chrome"))

-- Terminal sizing
hs.hotkey.bind(super, "t", function()
    window = hs.window.filter.new('Terminal'):getWindows()[1]
    size = window:size()

    size.w = size.w == 845 and 1770 or 845
    window:setSize(size)
end)

hs.hotkey.bind(super, "`", function()
    hs.execute("pmset displaysleepnow")
end)
