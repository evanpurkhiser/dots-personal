local M = {}

-- Hide ugly toolbar
hs.console.toolbar(nil)

-- Disable window movement animations
hs.window.animationDuration = 0

-- key used as my "super" key. This key combination is mapped with karabiner
-- elements from the capslock key.
M.super = { "cmd", "ctrl", "shift", "alt" }

return M
