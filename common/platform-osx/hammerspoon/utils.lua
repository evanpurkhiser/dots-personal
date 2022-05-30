local M = {}

-- Returns the currently focused window that is in a set of windows.
-- Nil if none of the windows have focus
function M.getFocusedInGroup(windows)
  for _, win in ipairs(windows) do
    if win:id() == hs.window.focusedWindow():id() then
      return win
    end
  end
  return nil
end

-- Focus a window and set the cursor to the center
function M.focusWindow(window)
  window:focus()
  hs.mouse.absolutePosition(window:frame().center)
end

-- Cycle focus for a window filter group
function M.cycleWindowFocus(filterGroup)
  filterGroup:setCurrentSpace(nil)

  return function()
    local windows = filterGroup:getWindows(hs.window.filter.sortByFocused)
    local lastWindows = filterGroup:getWindows(hs.window.filter.sortByFocusedLast)

    if #lastWindows == 0 then
      return
    end

    -- If one of the windows in the group has focus then
    if M.getFocusedInGroup(windows) then
      M.focusWindow(windows[1])
    else
      M.focusWindow(lastWindows[1])
    end
  end
end

-- Snap a window to a grid
function M.snapWindow(window, gridSize)
  local frame = window:frame()

  for _, axis in ipairs({ "x", "x2", "y", "y2" }) do
    frame[axis] = math.floor((frame[axis] / gridSize) + 0.5) * gridSize
  end

  hs.window.focusedWindow():setFrameInScreenBounds(frame)
end

return M
