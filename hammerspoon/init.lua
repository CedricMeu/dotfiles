-- hs.loadSpoon("EmmyLua")

local WindowManager = require("wm")
Wm = WindowManager.new()
Wm:start()

local nav_mods = { "alt" }
local c_mods = { "ctrl", "alt" }

hs.hotkey.bind(nav_mods, "j", function()
  local layout = Wm:currentLayout()
  local column = layout:getActiveColumn()
  local _ = column:focusNext()
end)

hs.hotkey.bind(nav_mods, "k", function()
  local layout = Wm:currentLayout()
  local column = layout:getActiveColumn()
  local _ = column:focusPrevious()
end)

hs.hotkey.bind(nav_mods, "h", function()
  local layout = Wm:currentLayout()
  local _ = layout:focusLeft()
end)

hs.hotkey.bind(nav_mods, "l", function()
  local layout = Wm:currentLayout()
  local _ = layout:focusRight()
end)

hs.hotkey.bind(nav_mods, "n", function()
  local layout = Wm:currentLayout()
  local _ = layout:moveActiveWindowRight()
  Wm:update()
end)

hs.hotkey.bind(nav_mods, "p", function()
  local layout = Wm:currentLayout()
  local _ = layout:moveActiveWindowLeft()
  Wm:update()
end)

hs.hotkey.bind(nav_mods, "f", function()
  hs.window.focusedWindow():toggleFullScreen()
end)

hs.hotkey.bind(c_mods, "h", function()
  Wm:currentLayout():addColumnLeft()
  Wm:update()
end)

hs.hotkey.bind(c_mods, "l", function()
  Wm:currentLayout():addColumnRight()
  Wm:update()
end)
