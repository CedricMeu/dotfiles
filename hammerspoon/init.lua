-- hs.loadSpoon("EmmyLua")

local WindowManager = require("wm")
Wm = WindowManager.new()
Wm:start()

local mods = { "alt" }

hs.hotkey.bind(mods, "j", function()
  local layout = Wm:currentLayout()
  local column = layout:getActiveColumn()
  local _ = column:focusNext()
end)

hs.hotkey.bind(mods, "k", function()
  local layout = Wm:currentLayout()
  local column = layout:getActiveColumn()
  local _ = column:focusPrevious()
end)

hs.hotkey.bind(mods, "h", function()
  local layout = Wm:currentLayout()
  local _ = layout:focusLeft()
end)

hs.hotkey.bind(mods, "l", function()
  local layout = Wm:currentLayout()
  local _ = layout:focusRight()
end)

hs.hotkey.bind(mods, "n", function()
  local layout = Wm:currentLayout()

  if layout:rightmostActive() then
    local _ = layout:addColumnRight()
  end

  local _ = layout:moveActiveWindowRight()
  Wm:update()
end)

hs.hotkey.bind(mods, "p", function()
  local layout = Wm:currentLayout()

  if layout:leftmostActive() then
    local _ = layout:addColumnLeft()
  end

  local _ = layout:moveActiveWindowLeft()
  Wm:update()
end)

hs.hotkey.bind(mods, "f", function()
  hs.window.focusedWindow():toggleFullScreen()
end)
