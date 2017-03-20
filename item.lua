Item = Object:extend()

ITEM_WIDTH, ITEM_HEIGHT = 32, 32

function Item:new(tp, x, y, dur)
  -- 板栗仔  慢慢龟
  self.tp = tp
  self.x = x
  self.y = y
  self.dur = dur
  self.width, self.height = ITEM_WIDTH, ITEM_HEIGHT
end


function Item:draw()
  if self.tp == 1 then
    love.graphics.draw(mushroomRed, self.x, self.y)
  elseif self.tp == 2 then
    love.graphics.draw(mushroomGreen, self.x, self.y)
  end
end


function Item:regularUp(dt)
  self.y = self.y - dt * gameSpeed
end



function checkCollision(a, b)
    --With locals it's common usage to use underscores instead of camelCasing
    local a_left = a.x
    local a_right = a.x + a.width
    local a_top = a.y
    local a_bottom = a.y + a.height

    local b_left = b.x
    local b_right = b.x + b.width
    local b_top = b.y
    local b_bottom = b.y + b.height

    --If Red's right side is further to the right than Blue's left side.
    if a_right > b_left and
    --and Red's left side is further to the left than Blue's right side.
    a_left < b_right and
    --and Red's bottom side is further to the bottom than Blue's top side.
    a_bottom > b_top and
    --and Red's top side is further to the top than Blue's bottom side then..
    a_top < b_bottom then
        --There is collision!
        return true
    else
        --If one of these statements is false, return false.
        return false
    end
end