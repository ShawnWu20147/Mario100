Platform = Object:extend()


function Platform:new(mytype, x, y, id)
  -- type: 0 normal 1 jump 2 elastic 3 death
  
  self.x = x
  self.y = y
  self.mytype = mytype
  self.height = 16
  self.width = 120
  
  self.id = id
  
  self.bindTime = 0.2 --仅仅用于脆的板子,0.6秒的生命
  
  self.landStatus = 0
  
end


function Platform:draw()

  if self.mytype == 0 then
    love.graphics.setColor(255, 0, 0)
  elseif self.mytype == 1 then
    love.graphics.setColor(0, 255, 0)
  elseif self.mytype == 2 then
    love.graphics.setColor(0, 0, 255)
  else
    -- do nothing
  end
  love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
  love.graphics.setColor(255, 255, 255)
end


function Platform:regularUp(dt)
  self.y = self.y - dt * gameSpeed
end
