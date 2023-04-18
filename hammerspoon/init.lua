-- hs.loadSpoon("EmmyLua")

local WindowManager = require("wm")
Wm = WindowManager.new()
Wm:start()

local mods = { "alt" }

hs.hotkey.bind(mods, "n", function()
  local layout = Wm:currentLayout()
  layout:focusNext()
end)

hs.hotkey.bind(mods, "p", function()
  local layout = Wm:currentLayout()
  layout:focusPrevious()
end)

hs.hotkey.bind(mods, "f", function()
  hs.window.focusedWindow():toggleFullScreen()
end)
