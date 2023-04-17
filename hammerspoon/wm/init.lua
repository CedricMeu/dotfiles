-- [x] Stacking windows in space
-- [ ] change window to fullscreen
-- [ ] itterate through stack
-- [x] WM listens to space changes
-- [x] WM listens to window changes
-- [x] Layout: maximise all windows, show active window on top
-- [ ] add window to correct space when it is changed from space (eg. fullscreen to not)
-- WM -> Space -> Layout (if not in fullscreen)

hs.window.animationDuration = 0

local StackLayout = require("wm.stack_layout")

---@class WindowManager
local WindowManager = {
  ---@type table<integer, StackLayout>
  spaces = {},
  ---@type hs.window.filter
  windowFilter = nil,
  ---@type hs.spaces.watcher
  spacesWatcher = nil,
}
WindowManager.__index = WindowManager

---Create a new WindowManager
---@return WindowManager
---@nodiscard
function WindowManager.new()
  local self = setmetatable({}, WindowManager)
  self.spaces = {}
  self.windowFilter = hs.window.filter.new()
  self.spacesWatcher = hs.spaces.watcher.new(function(_) self:updateSpaces() end)
  return self
end

---Updated self.spaces
function WindowManager:updateSpaces()
  local spacesByScreen = hs.spaces.allSpaces() --[[ @as table<string, integer[]> ]]
  local spaces = {}

  for _, spaceIds in pairs(spacesByScreen) do
    for _, spaceId in pairs(spaceIds) do
      if self.spaces[spaceId] ~= nil then
        spaces[spaceId] = self.spaces[spaceId]
      else
        spaces[spaceId] = StackLayout.new(spaceId)
      end
    end
  end

  self.spaces = spaces
end

---Callback for when a window is created
---@param window hs.window
---@private
function WindowManager:windowCreated(window)
  -- hs.spaces.moveWindowToSpace(window, self.spaceId)
  local space = hs.spaces.activeSpaceOnScreen() --[[ @as integer ]]
  self.spaces[space]:addWindow(window)
end

---Callback for when a window is created
---@param window hs.window
---@private
function WindowManager:windowDestroyed(window)
  local space = hs.spaces.activeSpaceOnScreen() --[[ @as integer ]]
  self.spaces[space]:removeWindow(window)
end

---start the window manager
function WindowManager:start()
  self:stop()
  self.windowFilter:subscribe(hs.window.filter.windowCreated, function(window, _, _) self:windowCreated(window) end)
  self.windowFilter:subscribe(hs.window.filter.windowDestroyed, function(window, _, _) self:windowDestroyed(window) end)
  self.spacesWatcher:start()
  self:updateSpaces()
  -- TODO: add existing windows to correct space
end

---stop the window manager
function WindowManager:stop()
  self.windowFilter:unsubscribeAll()
  self.spacesWatcher:stop()
end

---Get current layout
---@return StackLayout
---@nodiscard
function WindowManager:currentLayout()
  local space = hs.spaces.activeSpaceOnScreen() -- [[ @as integer ]]
  return self.spaces[space]
end

return WindowManager
