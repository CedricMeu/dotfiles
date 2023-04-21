-- [x] Stacking windows in space
-- [ ] change window to fullscreen
-- [x] itterate through stack
-- [x] WM listens to space changes
-- [x] WM listens to window changes
-- [x] Layout: maximise all windows, show active window on top
-- [x] add window to correct space when it is changed from space (eg. fullscreen to not)
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
  self.spacesWatcher = hs.spaces.watcher.new(function()
    self:updateSpaces()
  end)

  -- FIXME:
  -- LuaSkin: hs.spaces.watcher callback: /Users/cedricmeukens/.hammerspoon/wm/stack_layout.lua:24: attempt to index a nil value (local 'window')
  -- stack traceback:
  -- 	/Users/cedricmeukens/.hammerspoon/wm/stack_layout.lua:24: in function 'wm.stack_layout.apply'
  -- 	/Users/cedricmeukens/.hammerspoon/wm/init.lua:56: in function 'wm.updateSpaces'
  -- 	/Users/cedricmeukens/.hammerspoon/wm/init.lua:32: in function </Users/cedricmeukens/.hammerspoon/wm/init.lua:32>  self.spacesWatcher = hs.spaces.watcher.new(function(_) self:updateSpaces() end)
  return self
end

---Updated self.spaces
function WindowManager:updateSpaces()
  local spacesByScreen = hs.spaces.allSpaces() --[[ @as table<string, integer[]> ]]
  ---@type table<integer, StackLayout>
  local spaces = {}

  for _, spaceIds in pairs(spacesByScreen) do
    for _, spaceId in pairs(spaceIds) do
      if hs.spaces.spaceType(spaceId) == "user" then
        if self.spaces[spaceId] ~= nil then
          spaces[spaceId] = self.spaces[spaceId]
        else
          spaces[spaceId] = StackLayout.new()
        end
      end
    end
  end

  self.spaces = spaces

  for _, layout in pairs(self.spaces) do
    layout:apply()
  end
end

---Callback for when a window is created
---@param window hs.window
---@private
function WindowManager:addWindow(window)
  -- hs.spaces.moveWindowToSpace(window, self.spaceId)
  ---@type table, string | nil
  ---@diagnostic disable-next-line: assign-type-mismatch
  local windowSpaces, err = hs.spaces.windowSpaces(window)

  if windowSpaces == nil then
    error(err)
  end

  if #windowSpaces == 0 then
    return
  end

  local space = windowSpaces[1]

  local layout = self.spaces[space]

  if layout ~= nil then
    self.spaces[space]:addWindow(window)
  end
end

---Callback for when a window is created
---@param window hs.window
---@private
function WindowManager:removeWindow(window)
  for _, layout in pairs(self.spaces) do
    if layout:containsWindow(window) then
      layout:removeWindow(window)
    end
  end
end

---start the window manager
function WindowManager:start()
  self:stop()
  self.spacesWatcher:start()
  self:updateSpaces()

  self.windowFilter:subscribe(hs.window.filter.windowCreated, function(window, _, _) self:addWindow(window) end, true)
  self.windowFilter:subscribe(hs.window.filter.windowDestroyed, function(window, _, _) self:removeWindow(window) end)
  self.windowFilter:subscribe(hs.window.filter.windowMoved, function(window, _, _)
    self:removeWindow(window)
    self:addWindow(window)
  end)
  self.windowFilter:subscribe(hs.window.filter.windowMinimized, function(window, _, _) self:removeWindow(window) end)
  self.windowFilter:subscribe(hs.window.filter.windowUnminimized, function(window, _, _) self:addWindow(window) end)
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
