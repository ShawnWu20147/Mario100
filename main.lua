function love.load()
    Object = require "classic"
    require "mario"
    require "item"
    require "platform"
    require "libraries.sick"
    
    require "myconfiguration"
    
    
    
    highscore.set("marioHighScore.txt", MAX_HIGHSCORE, "author",1)
    

    
    isWritingName = false
    isFinishWriting = false
    
    MyName = ""
    

    love.graphics.setBackgroundColor(126, 126, 126, 123)
    
    local zt = love.graphics.newFont("font/YaHei Consolas Hybrid.ttf",18)
    love.graphics.setFont(zt)
    
    gameOverImage =  love.graphics.newImage("pic/kuba.jpg")
    
    gameStartImage = love.graphics.newImage("pic/qnba.jpg")
    
    
    
    curPoint = 0
    
    optionSelected = 0
    
    curDirection = 1
  -- 0 left, 1 right
  
    curIndex = 0
    
    ticks = 0
    
    time_past = 0
    
    gameStatus = 0
    -- 0 begin
    -- 1 started
    -- 2 paused
    -- 3 over
    
    -- 10 tell how to play
    
    require "loadCharacter"
    
    mario = Mario()
    

    
    listOfPlatforms = {}
    
    listOfItems = {}
    

    gameSpeed = GameInitialSpeed
    

    
    math.randomseed(tostring(os.time()):reverse():sub(1, 6)) 
    
    lastGenerateTime = 0
    lastUpdateSpeedTime = 0
    
    idNumber = 1
    
    animationTimer = 0
    

    


    
    
    


end


function love.textinput(t)
  if isWritingName and string.len(MyName) <= 12 then
    MyName = MyName .. t
  end
end


function initGame()
  
  MyName = ""
  
  isWritingName = false
  isFinishWriting = false
  
  curPoint = 0
  
  curDirection = 1
  -- 0 left, 1 right
  
  curIndex = 0
  
  ticks = 0
  
  mario:reset()
  
  gameSpeed = GameInitialSpeed  -- 初始为100 以后会加的
  
  time_past = 0
  
  listOfItems = {}
  
  listOfPlatforms = {}
  
  l1 = Platform(0, 240 - 60, 700 + mario.height, 0)
  
  table.insert(listOfPlatforms, l1)
  
  mario:setPlatform(l1)
  
  lastGenerateTime = 0
  
  lastUpdateSpeedTime = 0
  
  idNumber = 1
  
  animationTimer = 0
  
end

function drawGame()


   
   mario:draw()
   
   for i = 1, #listOfPlatforms do
     listOfPlatforms[i]:draw()
   end
   
   for i = 1, #listOfItems do
     listOfItems[i]:draw()
   end
   
end




function drawPause()
  love.graphics.print("游戏暂停", 170, 350, 0, 1.5, 1.5)
  love.graphics.print("按ESC回到主界面，别的键回到游戏", 30, 400, 0, 1.5, 1.5)
end

function drawOver()
  love.graphics.draw(gameOverImage, 0, 0, 0, 2, 3.2)
  local s0 = {{255, 0, 255},"你的得分是:".. curPoint}
  local s1
  if curPoint >= 100 then
    s1 = {{255, 0, 255},"你有点叼啊"}
  else
    s1 = {{255, 0, 255},"卢瑟!你彻底输了!"}
  end
  local s2 = {{255, 0, 255},"按6返回主菜单"}
  
  love.graphics.print(s0, 145, 250, 0, 2, 2)

  love.graphics.print(s1, 130, 350, 0, 2, 2)


if not (not isFinishWriting and (#highscore.scores <= MAX_HIGHSCORE or highscore.scores[MAX_HIGHSCORE][1] < curPoint)) then
  isWritingName = false
  
  love.graphics.print(s2, 130, 450, 0, 2, 2)
end
  
  
  if not isFinishWriting and (#highscore.scores <= MAX_HIGHSCORE or highscore.scores[MAX_HIGHSCORE][1] < curPoint) then

    isWritingName = true
    local s3 = {{255, 0, 255},"留下你的大名，以回车结束:"}
    love.graphics.print(s3, 130, 550, 0, 1, 1)
    love.graphics.setColor(255, 0, 255)
    love.graphics.print(MyName, 180, 650, 0, 2, 2)
    love.graphics.setColor(255, 255, 255)
  end
  
end

function drawStart()
  love.graphics.draw(gameStartImage, 0, 0, 0, 1.2, 2)
  
  ss ={{255,34,125},"马里奥要下100层"}
  
  love.graphics.print(ss, 100, 220, 0, 2, 2)  --标题
  
  
  for i = 0, GameStartItems do
    love.graphics.print(allText[i], StartItemPosX, StartItemPosY[i + 1], 0, 2, 2)
  end

    
  love.graphics.setColor(0, 133, 255)
    
  love.graphics.rectangle("line", StartItemPosX - 5, StartItemPosY[optionSelected + 1] - 5, RectangleWidth, RectangleHeight)
    

  love.graphics.setColor(255, 255, 255)
  
end

function drawPoint()
  love.graphics.print(curPoint, 0, 0, 0, 2, 2)
end




function love.update(dt)
  if dt < 1/60 then
      love.timer.sleep(1/60 - dt)
  end
  if gameStatus ~= 1 then
    return
  end
  
  
  -- 首先大家都要往上移动
  mario:regularUp(dt)
  for i = 1, #listOfPlatforms do
     listOfPlatforms[i]:regularUp(dt)
  end
  
  for i = 1, #listOfItems do
    listOfItems[i]:regularUp(dt)
  end
  
  
  -- 判断越界死亡
  if (mario.y <= 0 or mario.y >= GameHeight - mario.height) then
    gameStatus = 3
    return
  end
  
  -- 废弃平台
  for i =  #listOfPlatforms, 1, -1 do
    local one = listOfPlatforms[i]
    if one.y <= 0 or one.y >= GameHeight - one.height then
      table.remove(listOfPlatforms, i)
    end
  end
  
  
  -- 废弃道具
  for i =  #listOfItems, 1, -1 do
    local one = listOfItems[i]
    if one.y <= 0 or one.y >= GameHeight - one.height then
      table.remove(listOfItems, i)
    end
  end
  
  
  time_past = time_past + dt

  lastGenerateTime = lastGenerateTime + dt
  -- 产生新的平台
  if lastGenerateTime >= 1 / (gameSpeed / GameInitialSpeed) then
    lastGenerateTime = 0
    
    local whether = math.random()
    
    if (whether >= 0.1) then
    
      local what_type = math.random(0, 100)
      local decide_type = 0
      if what_type <= 60 then
        decide_type = 0
      elseif what_type <= 70 then
        decide_type = 1
      elseif what_type <= 90 then
        decide_type = 2
      else
        decide_type = 3
      end
      
      local l2 = Platform(decide_type, math.random(0, GameWidth - 120), 700 + mario.height, idNumber)
      table.insert(listOfPlatforms, l2)
      idNumber = idNumber + 1
      
      
      
      -- 接下来产生道具
      local whether_item = math.random()
      if (whether >= 0.85 and decide_type == 0) then
        what_type = math.random(0, 100)
        -- 板栗仔  慢慢龟
        if what_type <= 60 then
          local i1 = Item(1, l2.x + l2.width / 2 - ITEM_WIDTH / 2, l2.y - ITEM_HEIGHT, 10)
          table.insert(listOfItems, i1)
        elseif what_type <= 100 then
          local i1 = Item(2, l2.x + l2.width / 2 - ITEM_WIDTH / 2, l2.y - ITEM_HEIGHT, 10)
          table.insert(listOfItems, i1)
        end
      end
   
      
    end
  end
  
  -- 改变移动速度
  if math.floor(time_past) - lastUpdateSpeedTime >= 3 then
    lastUpdateSpeedTime = math.floor(time_past)
    gameSpeed = gameSpeed + 20
    
  end
  

  
  
  if not love.keyboard.isDown("a", "left", "d", "right") then
    curIndex = 0
  end
  
  -- 左右移动监测
  if love.keyboard.isDown("a", "left") then
    if curDirection == 1 then
      curDirection = 0
      animationTimer = 0
      curIndex = 0
    else
      animationTimer = animationTimer + 1
      local threshold = MoveSlowStep
      if love.keyboard.isDown("a") then threshold = MoveFastStep end
      if animationTimer >= threshold then
        curIndex = (curIndex + 1) % 4
        animationTimer = 0
      end
    end
    
    local useWhat = MarioSpeed
    if love.keyboard.isDown("a") then useWhat = MarioCrazySpeed end
    
    if mario.effect == 1 then
      useWhat = useWhat * 1.5
    elseif mario.effect == 2 then
      useWhat = useWhat * 0.5
    end
    
    
    mario.x = mario.x - dt * useWhat
    if (mario.x <= 0) then mario.x = GameWidth - mario.width end
    
  end
  
  if love.keyboard.isDown("d", "right") then
    if curDirection == 0 then
      curDirection = 1
      animationTimer = 0
      curIndex = 0
    else
      animationTimer = animationTimer + 1
      local threshold = MoveSlowStep
      if love.keyboard.isDown("d") then threshold = MoveFastStep end
      if animationTimer >= threshold then
        curIndex = (curIndex + 1) % 4
        animationTimer = 0
      end
    end

    local useWhat = MarioSpeed
    if love.keyboard.isDown("d") then useWhat = MarioCrazySpeed end
  
    if mario.effect == 1 then
      useWhat = useWhat * 1.5
    elseif mario.effect == 2 then
      useWhat = useWhat * 0.5
    end

    mario.x = mario.x + dt * useWhat
    if (mario.x + mario.width >= GameWidth) then mario.x = 0 end
  end

  -- 对于易碎木板 检测是否破碎
  if mario.pf ~= nil and mario.pf.mytype == 2 then
    mario.pf.bindTime = mario.pf.bindTime - dt
    if (mario.pf.bindTime <= 0) then
      mario.status = 1
      local oldPlatform = mario.pf
      mario.pf = nil
      mario.YSpeed = 150 + (gameSpeed - GameInitialSpeed) -- y方向速度为0
      for i = #listOfPlatforms, 1, -1 do
        if listOfPlatforms[i] == oldPlatform then
          table.remove(listOfPlatforms, i)
          break
        end
      end
      
      --return  -- 注意 这里可能影响结果
      
    end
  end
  
  -- 对于普通以及易碎木板 检测是否越界
  if mario.pf ~= nil  then
    if mario.x + mario.width -5 < mario.pf.x or mario.x > mario.pf.x + mario.pf.width - 5 then

      mario.status = 1
      mario.pf = nil
      mario.YSpeed = 150 + (gameSpeed - GameInitialSpeed)-- y方向速度为0
      
      --return -- 注意 这里可能影响结果
      
    end
  end
  
  if mario.status == 1 then
    -- 在空中
    mario.YSpeed = mario.YSpeed + dt * (GameGravity + gameSpeed - GameInitialSpeed)
    mario.y = mario.y + mario.YSpeed * dt
  end
  
  
  -- 更新马里奥状态
  if mario.effect ~= 0 then
    mario.dur = mario.dur - dt
    if mario.dur <= 0 then
      mario:updateEffect(0)
      mario:adjustPosIfNecessary()
    end
  end
  
  
  -- 检测马里奥与道具
  for i = #listOfItems, 1, -1 do
    if checkCollision(mario, listOfItems[i]) then
      mario:updateEffect(listOfItems[i].tp)
      mario.dur = 10
      if mario.effect == 2 then
        -- 慢慢龟的buff
        mario.health = 1
      end
      mario:adjustPosIfNecessary()
      table.remove(listOfItems, i)
    end
  end
      
    
  
  -- 碰撞检测一波!
  if mario.status == 0 then
    return
  end
  
  
  
  mx = mario.x
  my = mario.y
  mw = mario.width
  mh = mario.height
  
  
  
  
  for i = 1, #listOfPlatforms do
    local one = listOfPlatforms[i]
    onex = one.x
    oney = one.y
    onew = one.width
    oneh = one.height

    
    -- 只考虑上面初接触
    -- 从两边的 纠正一下位置即可
    if (mx + mw < onex or mx >= onex + onew) and one.landStatus == 1 and my + mh >= oney then
      one.landStatus = -1
    end
    
    if mx + mw >= onex and mx <= onex + onew and mario.YSpeed > 0 then
      -- 上面碰撞
      
      if my + mh < oney and one.landStatus == 0 then 
        one.landStatus = 1
      elseif my + mh >= oney and one.landStatus == 0 then
        if mx <= onex and mx + mario.width >= onex then
          -- 左边碰撞
          mario.x = onex - mario.width
        elseif mx <= onex + onew and mx + mario.width >= onex + onew then
          -- 右边碰撞
          mario.x = onex + onew
        end
        one.landStatus = -1
      
      
      elseif my + mh >= oney and one.landStatus == 1 then
        
        one.landStatus = 2 -- landed
      
        mario.y = one.y - mh
        
        if one.mytype == 3 then
          if mario.effect == 2 and mario.health == 1 then
            curPoint = one.id
            one.mytype = 0
            mario.health = 0
            
            mario.status = 0
            mario:setPlatform(one)
            
          else
            curPoint = one.id
            gameStatus = 3
            return
          end
        elseif one.mytype == 1 then
          curPoint = one.id
          mario.YSpeed = - 150
          
          one.landStatus = 0
          
          return
        else
          curPoint = one.id
          mario.status = 0
          mario:setPlatform(one)
        end
      end
    else
      -- 不是上面碰撞
      if mx <= onex and mx + mario.width >= onex and my <= oney and my + mario.height >= oney then
        -- 左边碰撞
        mario.x = onex - mario.width
      elseif mx <= onex + onew and mx + mario.width >= onex + onew and my <= oney and my + mario.height >= oney then
        -- 右边碰撞
        mario.x = onex + onew
      end
    end
  end
  

  
  

  
end

function love.draw()
  if gameStatus == 0 then
    -- do nothing but show beginning
    drawStart()
  elseif gameStatus == 1 then
    --
    drawGame()
    drawPoint()
  elseif gameStatus == 2 then
    --
    drawGame()
    drawPoint()
    drawPause()
  elseif gameStatus ==  3 then
    -- do nothing but show endding
    drawOver()
  elseif gameStatus == 10 then
    -- tell how to play
    tellHowToPlay()
  elseif gameStatus == 20 then
    showHighScores()
  end
  
end


function showHighScores()
  love.graphics.print("姓名", 0, 0, 0, 2, 2)
  love.graphics.print("分数", 300, 0, 0, 2, 2) 
  
  for i, score, name in highscore() do
    love.graphics.print(name, 0, i * 40, 0, 2, 2)
    love.graphics.print(score, 310, i * 40, 0, 2, 2)
  end
  
  love.graphics.setColor(255, 0, 0)
  love.graphics.print("按任意键回到主界面", 70, 700, 0, 2, 2)
  love.graphics.setColor(255, 255, 255)
end


function love.mousereleased(x, y, button, istouch)
  if not button == 1 then
    return
  end
  
  if gameStatus == 10 or gameStatus == 20 then
    gameStatus = 0
    return
  end
  
  if gameStatus == 1 then
    return
  end
  
  if x >= StartItemPosX - 5 and x <= StartItemPosX - 5 + RectangleWidth then
    if y >= StartItemPosY[1] - 5 and y <= StartItemPosY[1] - 5 + RectangleHeight then
      optionSelected = 0
      initGame()
      gameStatus = 1
    elseif y >= StartItemPosY[2] - 5 and y <= StartItemPosY[2] - 5 + RectangleHeight then
      optionSelected = 1
      gameStatus = 10
    elseif y >= StartItemPosY[3] - 5 and y <= StartItemPosY[3] - 5 + RectangleHeight then
      optionSelected = 2   
      gameStatus = 20
    elseif y >= StartItemPosY[4] - 5 and y <= StartItemPosY[4] - 5 + RectangleHeight then
      optionSelected = 3
      highscore.scores = {}
      highscore.save()
    elseif y >= StartItemPosY[5] - 5 and y <= StartItemPosY[5] - 5 + RectangleHeight then
      optionSelected = 4
      love.event.quit()
    end
  end
  
  
  
end

function love.keyreleased(key)
  if gameStatus == 2 then
    if key == "escape" then 
      gameStatus = 0
    else
      gameStatus = 1
    end
    return
  end
  
  if gameStatus == 10 or gameStatus == 20 then
    gameStatus = 0
    return
  end
  
  if gameStatus == 0 and  (key == "w" or key == "s" or key == "up" or key == "down") then
    if (key == "up" or key == "w") then
      optionSelected = optionSelected - 1
      if optionSelected == -1 then optionSelected = GameStartItems end
    else
      optionSelected = optionSelected + 1
      if optionSelected == GameStartItems + 1 then optionSelected = 0 end
    end
  end

  if (key == "return" or key == "space") and gameStatus == 0 then
    if optionSelected == 0 then
      --开始游戏
      initGame()
      gameStatus = 1
    elseif optionSelected == 1 then
      --说明
      gameStatus = 10
    elseif optionSelected == 2 then
      --高分榜
      gameStatus = 20
    elseif optionSelected == 3 then
      -- 重置高分榜
      highscore.scores = {}
      highscore.save()
    elseif optionSelected == 4 then
      -- 退出游戏
      love.event.quit()
    end
  end
  
  if key == "6" and gameStatus == 3 and not isWritingName then
    gameStatus = 0
  end
  
  if key == "escape" and gameStatus == 1 then
    gameStatus = 2
  end
  
  if gameStatus == 3 then
    if key == "backspace" then
      MyName = string.sub(MyName, 0, string.len(MyName) - 1)
    elseif key == "return" then
      isWritingName = false
      isFinishWriting = true
      highscore.add(MyName, curPoint)
      highscore.save()
      gameStatus = 0
    end
  end
      
  

  

  
end



function tellHowToPlay()
  love.graphics.print("游戏菜单页面按回车或者空格进行确认", 0, 0)
  love.graphics.print("利用A或者方向键左向左移动，A速度更快", 0, 40)
  love.graphics.print("利用D或者方向键右向右移动，D速度更快", 0, 80)
  
  love.graphics.setColor(255, 0, 0)
  love.graphics.rectangle("fill", 0, 120, 73, 22)
  
  love.graphics.setColor(255, 255, 255)
  love.graphics.print("是普通平台，踩上去没有任何问题", 74, 120)
  
  love.graphics.setColor(0, 255, 0)
  love.graphics.rectangle("fill", 0, 160, 73, 22)
  
  love.graphics.setColor(255, 255, 255)
  love.graphics.print("是弹簧平台，踩上去会获得一个向上的速度", 74, 160)
  
  love.graphics.setColor(0, 0, 255)
  love.graphics.rectangle("fill", 0, 200, 73, 22)
  
  love.graphics.setColor(255, 255, 255)
  love.graphics.print("是消失平台，踩上去会在0.3秒后消失",74, 200)
  
  love.graphics.setColor(255, 255, 255)
  love.graphics.rectangle("fill", 0, 240, 73, 22)
    
    
  love.graphics.print("是死亡平台，踩上去即死", 74, 240)
  
  
  love.graphics.draw(mushroomRed, 0, 280)
  love.graphics.print("吃了之后10秒内变成板栗仔", 38, 280)
  love.graphics.draw(Tileset[1], leftPic[1][0], 260, 280)
  love.graphics.print("左右移动速度提高50%", 292, 280)
  
  love.graphics.draw(mushroomGreen, 0, 320)
  love.graphics.print("吃了之后10秒内变成慢慢龟", 38, 320)
  love.graphics.draw(Tileset[2], leftPic[2][0], 260, 300)
    love.graphics.print("左右移动速度减慢50%", 292, 320)
    
  love.graphics.print("但是可以强行踩踏一次白块,自身变为第二形态", 40, 360)
  love.graphics.draw(Tileset[3], leftPic[3][0], 420, 340)
  
  
  
  love.graphics.print("游戏过程中可以按ESC键暂停", 0, 600, 0, 2, 2)
  
  love.graphics.setColor(255, 0, 0)
  love.graphics.print("按任意键回到主界面", 0, 640, 0, 2, 2)
  love.graphics.setColor(255, 255, 255)
  

  
end