local Space = {
  layout = nil,
  osSpace = nil,
}

function Space.new(layout, osSpace)
  local self = {}
  setmetatable(self, Space)
  self.__index = self
  self.layout = layout
  self.osSpace = osSpace

  self.layout:setChangeHandler(function()
    self.layout:apply(
      self.osSpace:frame().x,
      self.osSpace:frame().y,
      self.osSpace:frame().w,
      self.osSpace:frame().h
    )
  end)

  return self
end

function Space:addWindow(window)
  self.layout:addWindow(window)
end

function Space:removeWindow(window)
  self.layout:removeWindow(window)
end

function Space:getLayout()
  return self.layout
end

function Space:getOsSpace()
  return self.osSpace
end

return Space
