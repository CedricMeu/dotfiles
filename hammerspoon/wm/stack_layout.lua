---@class StackLayout
local StackLayout = {
  ---@type table<integer, hs.window.filter>
  windows = {},
  ---@type integer[]
  order = {},
}
StackLayout.__index = StackLayout

---Create a new StackLayout
---@return StackLayout
---@nodiscard
function StackLayout.new()
  local self = setmetatable({}, StackLayout)
  self.windows = {}
  self.order = {}
  return self
end

---Update layout
---@param frame hs.geometry
function StackLayout:update(frame)
  for windowId, _ in pairs(self.windows) do
    local window = hs.window(windowId) --[[ @as hs.window | nil ]]
    if window ~= nil then
      window:setFrame(frame)
    end
  end

  local activeWindowId = self:getActiveWindowId()
  if activeWindowId ~= nil then
    local topMostWindow = hs.window(activeWindowId) --[[ @as hs.window | nil ]]
    if topMostWindow ~= nil then
      topMostWindow:raise()
    end
  end
end

---TODO: let init.lua handle this
---Handler for when focus is changed onto a window in the stack
---@param window hs.window
---@pre window is in self.windows
---@private
function StackLayout:focusChanged(window)
  local windowId = window:id()

  if not hs.fnutils.contains(self.order, windowId) then
    error("Window to which focus changed is not in this layout")
  end

  while self:getActiveWindowId() ~= windowId do
    local first = table.remove(self.order) --[[ @as hs.window ]]
    table.insert(self.order, 1, first)
  end
end

---Get active window in layout
---@return integer | nil # id of the active window, or nil if there are no windows
---@nodiscard
function StackLayout:getActiveWindowId()
  if #self.order == 0 then
    return nil
  end
  return self.order[#self.order]
end

---Add window to layout
---@param window hs.window
function StackLayout:addWindow(window)
  local windowId = window:id() --[[ @as integer ]]

  if self.windows[windowId] ~= nil then
    warn("Window already added to layout. Cannot add it twice")
    return
  end

  table.insert(self.order, windowId)

  self.windows[windowId] = hs.window.filter.new(
  ---@param filteredWindow hs.window
    function(filteredWindow)
      return windowId == filteredWindow:id()
    end)

  self.windows[windowId]:subscribe(hs.window.filter.windowFocused,
    ---@param cbWindow hs.window
    function(cbWindow, _, _)
      self:focusChanged(cbWindow)
    end, true)
end

---Remove window from layout
---@param window hs.window
function StackLayout:removeWindow(window)
  print(window)
  local windowId = window:id() --[[ @as integer ]]

  self.windows[windowId]:unsubscribeAll()
  self.windows[windowId] = nil

  self.order = hs.fnutils.filter(self.order, function(id)
    return id ~= windowId
  end) --[[ @as integer[] ]]
end

---Check if window in layout
---@param window hs.window
---@return boolean
---@nodiscard
function StackLayout:containsWindow(window)
  return self.windows[window:id()] ~= nil
end

---Focus
---@return boolean # wether a window in the layout took focus
---@nodiscard
function StackLayout:focus()
  local activeWindowId = self:getActiveWindowId()
  if activeWindowId == nil then
    return false
  end

  local window = hs.window.get(activeWindowId)
  window:focus()
  return true
end

---Focus next window (wraps)
--@return boolean # wether a window in the layout took focus
---@nodiscard
function StackLayout:focusNext()
  local next = table.remove(self.order, 1)
  table.insert(self.order, next)

  return self:focus()
end

---Focus previous window (wraps)
---@return boolean # wether a window in the layout took focus
---@nodiscard
function StackLayout:focusPrevious()
  local next = table.remove(self.order)
  table.insert(self.order, 1, next)

  return self:focus()
end

return StackLayout
