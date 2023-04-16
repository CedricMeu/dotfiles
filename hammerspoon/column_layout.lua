-- utils
local function reversed(t)
  local rev = {}

  for i = #t, 1, -1 do
    table.insert(rev, t[i])
  end

  return rev
end

local function move_item(t, from, to)
  local item = table.remove(t, from)
  table.insert(t, to, item)
end

-- Columns
local Column = {
  display = "stack",
  windows = {},
  activeWindow = nil,
  width = 512,
  onChange = nil,
}

function Column.new(onChange)
  local self = {}
  setmetatable(self, Column)
  self.__index = self
  self.display = "stack"
  self.windows = {}
  self.focusedWindow = nil
  self.onChange = onChange
  return self
end

function Column:width()
  return self.width
end

function Column:setWidth(width)
  self.width = width
end

function Column:setAndFocusActiveWindow(window)
  self.activeWindow = window
  self:focus()
end

function Column:getActiveWindow()
  return self.activeWindow
end

function Column:getActiveWindowIndex()
  for i, column in pairs(self.columns) do
    if column == self.activeWindow then
      return i
    end
  end

  return nil
end

function Column:focus()
  self.onChange()
  self.activeWindow:focus()
end

function Column:addWindow(window)
  table.insert(self.windows, window)
  self.onChange()
end

function Column:focusPreviousWindow()
  local active_index = self:getActiveWindowIndex()

  if active_index > 1 then
    self:setAndFocusActiveWindow(self.windows[active_index - 1])
  end
end

function Column:focusNextWindow()
  local active_index = self:getActiveWindowIndex()

  if active_index < #self.windows then
    self:setAndFocusActiveWindow(self.windows[active_index + 1])
  end
end

function Column:moveWindowPrevious()
  local active_index = self:getActiveWindowIndex()
  local new_active_index = active_index

  if active_index > 1 then
    new_active_index = active_index - 1
    move_item(self.windows, active_index, new_active_index)
  end

  self:focus()
end

function Column:moveWindowNext()
  local active_index = self:getActiveWindowIndex()
  local new_active_index = active_index

  if active_index < #self.windows then
    new_active_index = active_index + 1
    move_item(self.windows, active_index, new_active_index)
  end

  self:focus()
end

function Column:apply(screenX, screenY, screenW, screenH)
  if self.display == "stack" then
    for _, window in pairs(self.windows) do
      local frame = window:frame()

      frame.w = self:width()
      frame.y = screenY
      frame.h = screenH

      window:setFrame(frame)
    end
  end
end

--- Returns:
---  * Updated active window, nil if no windows left
function Column:removeWindow(window)
  for i, v in pairs(self.windows) do
    if v:id() == window:id() then
      table.remove(self.windows, i)
      return
    end
  end

  if self.activeWindow:id() == window:id() then
    if #self.windows > 0 then
      self.activeWindow = self.windows[#self.windows]
    end
  end

  self.onChange()

  return self.activeWindow
end

function Column:containsWindow(window)
  for _, v in pairs(self.windows) do
    if v:id() == window:id() then
      return true
    end
  end
  return false
end

-- Column layout
local ColumnLayout = {
  columns = {},
  activeColumn = nil,
  onChange = nil
}

function ColumnLayout.new()
  local self = ColumnLayout
  setmetatable(self, ColumnLayout)
  self.__index = self
  self.columns = {}
  self.activeColumn = nil
  self.onChange = function()
  end

  return self
end

function ColumnLayout:setChangeHandler(onChange)
  self.onChange = onChange
end

-- function ColumnLayout:updateSpaces()
--   if self.spaces == nil then
--     self.spaces = {}
--   end

--   local spaces_backup = self.spaces

--   local spaces, err = hs.spaces.allSpaces()
--   if err then
--     error(error)
--     return error
--   end

--   for _, space_id in spaces do
--     ---@diagnostic disable-next-line: need-check-nil
--     if spaces_backup[space_id] == nil then
--       self.spaces[space_id] = Space.new()
--     else
--       ---@diagnostic disable-next-line: need-check-nil
--       self.spaces[space_id] = spaces_backup[space_id]
--     end
--   end
-- end

function ColumnLayout:addWindow(window)
  if self.activeColumn == nil then
    local column = Column.new(self.onChange)
    table.insert(self.columns, column)
    self.activeColumn = column
  end

  self.activeColumn:addWindow(window)
end

function ColumnLayout:removeWindow(window)
  local to_remove = {}

  for i, column in pairs(self.columns) do
    local aw = column:removeWindow(window)
    if aw == nil then
      table.insert(to_remove, i)
    end
  end

  for i in pairs(reversed(to_remove)) do
    table.remove(self.columns, i)
  end
end

function ColumnLayout:setAndFocusActiveColumn(column)
  self.activeColumn = column
  self.activeColumn:focus()
end

function ColumnLayout:getActiveColumn()
  return self.activeColumn
end

function ColumnLayout:getActiveColumnIndex()
  for i, column in pairs(self.columns) do
    if column == self.activeColumn then
      return i
    end
  end

  return nil
end

function ColumnLayout:focus()
  self.onChange()
  self.activeColumn:focus()
end

function ColumnLayout:focusPreviousColumn()
  local active_index = self:getActiveColumnIndex()

  if active_index > 1 then
    self:setAndFocusActiveColumn(self.columns[active_index - 1])
  end
end

function ColumnLayout:focusNextColumn()
  local active_index = self:getActiveColumnIndex()

  if active_index < #self.columns then
    self:setAndFocusActiveColumn(self.columns[active_index + 1])
  end
end

function ColumnLayout:moveWindowToPreviousColumn()
  local active_index = self:getActiveColumnIndex()

  if active_index == 1 then
    local column = Column.new(self.onChange)
    table.insert(self.columns, 1, column)
    self.activeColumn = column
  else
    active_index = active_index - 1
  end

  local active_window = self:getActiveColumn():getActiveWindow()
  self:getActiveColumn():removeWindow(active_window)
  self.activeColumn[active_index]:addWindow(active_window)
end

function ColumnLayout:moveWindowToNextColumn()
  local active_index = self:getActiveColumnIndex()

  if active_index == #self.columns then
    local column = Column.new(self.onChange)
    table.insert(self.columns, column)
    self.activeColumn = column
  else
    active_index = active_index + 1
  end

  local active_window = self:getActiveColumn():getActiveWindow()
  self:getActiveColumn():removeWindow(active_window)
  self.activeColumn[active_index]:addWindow(active_window)
end

function ColumnLayout:apply(screenX, screenY, screenW, screenH)
  for _, column in pairs(self.columns) do
    column:apply(screenX, screenY, screenW, screenH)
  end
end

return ColumnLayout
