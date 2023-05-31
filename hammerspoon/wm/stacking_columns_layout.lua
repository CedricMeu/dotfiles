local StackLayout = require("wm.stack_layout")

---@class StackingColumnsLayout
local StackingColumnsLayout = {
  ---@type table<integer, hs.window.filter>
  windows = {},
  ---@type StackLayout[]
  columns = {},
  ---@type integer
  activeColumn = nil,
}
StackingColumnsLayout.__index = StackingColumnsLayout

---Create new stacking columns layout
---@return StackingColumnsLayout
---@nodiscard
function StackingColumnsLayout.new()
  local self = setmetatable({}, StackingColumnsLayout)
  self.windows = {}
  self.columns = { StackLayout.new() }
  self.activeColumn = 1
  return self
end

---TODO: Let init.lua hangle this
---Handler for when focus is changed onto a window in one of the columns
---@param window hs.window
---@pre window is in self.windows
---@private
function StackingColumnsLayout:focusChanged(window)
  local column = hs.fnutils.find(self.columns,
    ---@param column StackLayout
    function(column)
      return column:containsWindow(window)
    end) --[[ @as StackLayout ]]

  self.activeColumn = hs.fnutils.indexOf(self.columns, column) --[[ @as integer ]]
end

---Update layout
---@param frame hs.geometry
function StackingColumnsLayout:update(frame)
  local columnWidth = frame.w / #self.columns
  for i, column in pairs(self.columns) do
    local columnFrame = frame:copy()
    columnFrame.w = columnWidth
    columnFrame.x = (i - 1) * columnWidth
    column:update(columnFrame)
  end
end

---Get layout of active column
---@return StackLayout
---@nodiscard
function StackingColumnsLayout:getActiveColumn()
  return self.columns[self.activeColumn]
end

---Get layout of column, right of the active column
---@return StackLayout
---@nodiscard
function StackingColumnsLayout:getNextColumn()
  local previous = self.activeColumn + 1
  if previous > #self.columns then
    previous = 1
  end

  return self.columns[previous]
end

---Get layout of column, left of the active column
---@return StackLayout
---@nodiscard
function StackingColumnsLayout:getPreviousColumn()
  local previous = self.activeColumn - 1
  if previous < 1 then
    previous = #self.columns
  end

  return self.columns[previous]
end

---Add window to active column
---@param window hs.window
function StackingColumnsLayout:addWindow(window)
  local windowId = window:id() --[[ @as integer ]]
  self:getActiveColumn():addWindow(window)

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

---Remove window from layout (any column)
---@param window hs.window
function StackingColumnsLayout:removeWindow(window)
  local windowId = window:id() --[[ @as integer ]]

  self.windows[windowId]:unsubscribeAll()
  self.windows[windowId] = nil

  for _, column in pairs(self.columns) do
    if column:containsWindow(window) then
      column:removeWindow(window)
    end
  end
end

---Check if window is in layout
---@param window hs.window
---@return boolean
---@nodiscard
function StackingColumnsLayout:containsWindow(window)
  for _, column in pairs(self.columns) do
    if column:containsWindow(window) then
      return true
    end
  end

  return false
end

---Set focus to active column
---@return boolean # wether the layout took focus
---@nodiscard
function StackingColumnsLayout:focus()
  return self:getActiveColumn():focus()
end

---Set focus to next column (wraps)
---@return boolean # wether the layout took focus
---@nodiscard
function StackingColumnsLayout:focusRight()
  local nextColumn = self:getNextColumn()
  self.activeColumn = hs.fnutils.indexOf(self.columns, nextColumn) or self.activeColumn
  return self:focus()
end

---Set focus to previous column (wraps)
---@return boolean # wether the layout took focus
---@nodiscard
function StackingColumnsLayout:focusLeft()
  local previousColumn = self:getPreviousColumn()
  self.activeColumn = hs.fnutils.indexOf(self.columns, previousColumn) or self.activeColumn
  return self:focus()
end

---Move active window in active column to next column (wraps, takes focus)
---@return boolean # wether the layout took focus
---@nodiscard
function StackingColumnsLayout:moveActiveWindowRight()
  local windowId = self:getActiveColumn():getActiveWindowId()
  local window = hs.window.get(windowId)
  self:getActiveColumn():removeWindow(window)
  self:getNextColumn():addWindow(window)
  return self:focusRight()
end

---Move active window in active column to previous column (wraps, takes focus)
---@return boolean # wether the layout took focus
---@nodiscard
function StackingColumnsLayout:moveActiveWindowLeft()
  local windowId = self:getActiveColumn():getActiveWindowId()
  local window = hs.window.get(windowId)
  self:getActiveColumn():removeWindow(window)
  self:getPreviousColumn():addWindow(window)
  return self:focusLeft()
end

---@deprecated
---Add a column to the left of the active column, no focus is transfered
---FIXME: Does not move windows right
function StackingColumnsLayout:addColumnLeft()
  local index = self.activeColumn
  local newColumn = StackLayout.new()
  table.insert(self.columns, index, newColumn)
  self.activeColumn = self.activeColumn + 1
end

---@deprecated
---Add a column to the right of the active column, no focus is transfered
function StackingColumnsLayout:addColumnRight()
  local index = self.activeColumn + 1
  local newColumn = StackLayout.new()
  table.insert(self.columns, index, newColumn)
end

---Check if leftmost column is active
---@return boolean
---@nodiscard
function StackingColumnsLayout:leftmostActive()
  return self.activeColumn == 1
end

---Check if rightmost column is active
---@return boolean
---@nodiscard
function StackingColumnsLayout:rightmostActive()
  return self.activeColumn == #self.columns
end

return StackingColumnsLayout
