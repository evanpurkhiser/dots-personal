super = {"cmd", "ctrl", "shift", "alt"}

-- Media volume
hs.hotkey.bind(super, "-", function()
    output = hs.audiodevice.defaultOutputDevice()
    output:setVolume(output:volume() - 1)
end)

hs.hotkey.bind(super, "=", function()
    output = hs.audiodevice.defaultOutputDevice()
    output:setVolume(output:volume() + 1)
end)


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
windowHistory = nil

function toggleWindowFocus(windowName)
    return function()
        window = hs.window.filter.new(windowName):getWindows()[1]
        if hs.window.focusedWindow() == window then
            window = windowHistory
        end

        windowHistory = hs.window.focusedWindow()
        hs.mouse.setAbsolutePosition(window:frame().center)
        window:focus()
    end
end

hs.hotkey.bind(super, "s", toggleWindowFocus("Slack"))
hs.hotkey.bind(super, "w", toggleWindowFocus("Terminal"))
hs.hotkey.bind(super, "e", toggleWindowFocus("Google Chrome"))

hs.hotkey.bind(super, "`", function()
    hs.execute("pmset displaysleepnow")
end)
