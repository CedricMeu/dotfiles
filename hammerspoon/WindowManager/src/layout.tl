local record Layout<LayoutData>
  data: LayoutData

end

function Layout:addWindow(window: hs.window)
  window = hs.window.get()

end

function Layout:removeWindow(window: hs.window)
end

return Layout