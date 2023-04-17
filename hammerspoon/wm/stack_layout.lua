---@class StackLayout
local StackLayout = {
  ---@type table<integer, hs.window.filter>
  windows = {},
  ---@type integer
  activeWindowId = nil,
}
StackLayout.__index = StackLayout

---Create a new StackLayout
---@param spaceId integer
---@return StackLayout|nil # Returns nil if space is full screen or a native tiled space, or the space does not exist
---@nodiscard
function StackLayout.new(spaceId)
  if not hs.spaces.spaceType(spaceId) == "user" then
    return nil
  end

  local self = setmetatable({}, StackLayout)
  self.spaceId = spaceId
  self.windows = {}
  return self
end

---Get sorted list of the ids of the windows managed by the layout
---@return integer[]
---@nodiscard
---@private
function StackLayout:windowIdsSorted()
  local ids = {}

  for id, _ in pairs(self.windows) do
    table.insert(ids, id)
  end

  table.sort(ids)

  return ids
end

---Update layout
---@private
function StackLayout:apply()
  for windowId, _ in pairs(self.windows) do
    local window = hs.window.get(windowId)
    window:maximize()
  end

  -- TODO: Remove self.activeWindowId, and use rotating of an array with windows
  if self.activeWindowId ~= nil then
    local activeWindow = hs.window.get(self.activeWindowId)
    activeWindow:raise()
  end
end

---Get active window in layout
---@return integer
---@nodiscard
function StackLayout:getActiveWindowId()
  return self.activeWindowId
end

---Add window to layout
---@param window hs.window
function StackLayout:addWindow(window)
  local windowId = window:id() --[[ @as integer ]]

  if self.windows[windowId] ~= nil then
    warn("Window already added to layout. Cannot add it twice")
    return
  end

  self.windows[windowId] = hs.window.filter.new(
  ---@param filteredWindow hs.window
    function(filteredWindow)
      return windowId == filteredWindow:id()
    end)

  self.windows[windowId]:subscribe(hs.window.filter.windowFocused,
    ---@param cbWindow hs.window
    ---@param appName string
    ---@param event string
    ---@diagnostic disable-next-line: unused-local
    function(cbWindow, appName, event)
      print("active window changed")
      self.activeWindowId = cbWindow:id() --[[ @as integer ]]
    end, true)

  self:apply()
end

---Remove window from layout
---@param window hs.window
function StackLayout:removeWindow(window)
  local windowId = window:id() --[[ @as integer ]]

  self.windows[windowId]:unsubscribeAll()
  self.windows[windowId] = nil

  if self.activeWindowId == windowId then
    self.activeWindowId = nil
  end

  self:apply()
end

return StackLayout
