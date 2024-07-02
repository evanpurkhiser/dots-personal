local config = require(".config")
local utils = require(".utils")

local super = config.super

-- hammerspoon reload
hs.hotkey.bind(super, "0", function()
  hs.reload()
end)

-- Sleep monitor
hs.hotkey.bind(super, "`", nil, function()
  hs.execute("pmset displaysleepnow")
end)

-- Trigger spelling hotkey
hs.hotkey.bind(super, "s", function()
  hs.eventtap.keyStroke({ "cmd", "shift" }, ";")
end)

-- Align windows to 10px grid
hs.hotkey.bind(super, "a", function()
  utils.snapWindow(hs.window.focusedWindow(), 10)
end)

-- Align widnows to the center of the screen
hs.hotkey.bind(super, "m", function()
  screen = hs.screen.mainScreen():frame()
  window = hs.window.focusedWindow():frame()

  window.x = screen.center.x - (window.w / 2)
  window.y = screen.center.y - (window.h / 2)

  hs.window.focusedWindow():setFrame(window)
end)

-- Focus Slack
hs.hotkey.bind(super, "1", utils.cycleWindowFocus(hs.window.filter.new({ "Slack" })))

-- Focus messaging window
hs.hotkey.bind(
  super,
  "2",
  utils.cycleWindowFocus(hs.window.filter.new({
    "Telegram",
    "Messages",
    "WhatsApp",
    "Signal",
  }))
)

-- Focus browsers
hs.hotkey.bind(
  super,
  "3",
  utils.cycleWindowFocus(hs.window.filter.new({
    "Google Chrome",
    "Firefox",
    "Safari",
    "Arc",
  }))
)

-- Focus Terminals
hs.hotkey.bind(
  super,
  "\\",
  utils.cycleWindowFocus(hs.window.filter.new({ "Alacritty", "Terminal" }))
)

-- Copy the name and position of the focused window to
hs.hotkey.bind(super, "-", function()
  local window = hs.window.focusedWindow()

  local content =
    string.format('["%s"] = "%s",', window:application():name(), window:frame().string)

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

local mobileSetup = {
  ["Google Chrome"] = "10,35/1420x855",
  ["Cron"] = "10,35/1420x855",
  ["Spark"] = "10,35/1420x855",
  ["Slack"] = "10,35/1420x855",
  ["Telegram"] = "10,250/550x630",
  ["Messages"] = "10,260/550x630",
  ["Things"] = "880,260/550x630",
}

local workSetuo = {}

-- Depending on the monitor use different setups
local windowSetups = {
  ["02F83E40-3490-8049-C3BD-212425835336"] = mobileSetup,
  ["6227B76D-CD93-41D9-AA93-811943BC79E6"] = homeSetup,
  ["TODO"] = workSetuo,
}

-- Hotkey to re-align windows
hs.hotkey.bind(super, "=", function()
  local monitorId = hs.screen.primaryScreen():getUUID()
  local setup = windowSetups[monitorId]

  if setup == nil then
    hs.notify.show("Window Setup", "No setup configure for the primary monitor", "")
    hs.pasteboard.setContents(monitorId)
    return
  end

  for name, pos in pairs(setup) do
    local appWindows = hs.window.filter.new(name):getWindows()
    if #appWindows > 0 then
      appWindows[1]:raise()
      appWindows[1]:setFrame(pos)
    end
  end
end)
