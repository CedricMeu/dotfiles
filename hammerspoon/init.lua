hs.hotkey.bind({"cmd", "alt"}, "w", function()
  hs.alert.show("Hello world")
  hs.notify.new({title="Hammerspoon", informativeText="Hello World"}):send()
end)