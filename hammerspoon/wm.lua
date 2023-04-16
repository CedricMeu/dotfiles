-- notes
-- - [ ] toggle fullscreen
-- - [ ] toggle wm for all
-- - [ ] toggle wm for window
-- - [ ] if window cant be resized to fit, it float_opts
-- - [ ] 2 columns (main left)
-- - [ ] main column swappable.
-- - [ ] each column is a stack.
-- - [ ] new windows open on current stack.
-- - [ ] moving windows between stacks
-- - [ ] resize columns
-- - [ ] move spaces, create if current one not empty and no next one
-- - [ ] move displays

-- Remove animations
hs.window.animationDuration = 0

ColumnLayout = require("column_layout")

--- Module
--- module
local module = {
  started = false,
  defaultLayout = nil,
  spaces = {},
  windowFilter = hs.window.filter.new(),
}

module.windowFilter:setDefaultFilter {}
module.windowFilter:setSortOrder(hs.window.filter.sortByFocusedLast)

function module:window_created(window)
  table.insert(self.windows, window)
end

function module:window_destroyed(window)
  print("destroyed window")
end

function module:window_focused(window)
  print("window focused")
end

function module:start(defaultLayout)
  if self.started then
    warn("Start was called on a started window manager")
    return
  end

  self.defaultLayout = defaultLayout or self.defaultLayout

  self.windowFilter:subscribe(hs.window.filter.windowCreated, function(window, _, _)
    self:window_created(window)
  end)

  self.windowFilter:subscribe(hs.window.filter.windowDestroyed, function(window, _, _)
    self:window_destroyed(window)
  end)

  self.windowFilter:subscribe(hs.window.filter.windowFocused, function(window, _, _)
    self:window_focused(window)
  end)

  self.started = true
end

function module:stop()
  if not self.started then
    warn("Stop was called on a stopped windows manager")
    return
  end

  self.windowFilter:unsubscribeAll()
  self.started = false
end

function module:updateSpaces()
  if self.defaultLayout == nil then
    error("No default layout was specified")
  end

  local osSpaces = hs.spaces.allSpaces()
end

-- TODO: handle spaces

return module
