Mario = Object:extend()



function Mario:new()
  self.status = 0
  -- 0 on the platform
  -- 1 in the air
  
  self.effect = 0
  
  self.width, self.height = tileW[self.effect], tileH[self.effect]
  
  self.x = 240 - 16
  self.y = 600
  
  self.YSpeed = 0
  
  

  
  self.dur = 0
  self.health = 0

  

  
end

function Mario:updateEffect(effect)
  self.effect = effect
  self.width, self.height = tileW[self.effect], tileH[self.effect]
end



function Mario:setPlatform(pf)
  self.pf = pf

end

function Mario:reset()
  self.status = 0
  self.x = 240 - 16
  self.y = 700
  
  self:updateEffect(0)
end


function Mario:draw()
  what = self.effect
  if (what == 2 and self.health == 0) then
    what = 3
  end
  if curDirection == 0 then
    love.graphics.draw(Tileset[what], leftPic[what][curIndex], self.x, self.y)
  else
    love.graphics.draw(Tileset[what], rightPic[what][curIndex], self.x, self.y)
  end
end


function Mario:regularUp(dt)
  self.y = self.y - dt * gameSpeed
end


function Mario:adjustPosIfNecessary()
  if self.pf == nil then
    return
  end
  
  self.y = self.pf.y - self.height
end
