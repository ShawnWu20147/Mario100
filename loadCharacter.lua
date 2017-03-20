allImages = {"pic/mario.png", "pic/banlizai.png", "pic/manmangui.png", "pic/manmangui2.png"}

allW = {32, 32, 32, 32}
allH = {32, 32, 64, 64}

      Tileset = {}
    tileW = {}
    tileH = {}

    leftPic = {}
    rightPic = {}

for i = 1 , 4 do


      
      

    
        Tileset[i - 1] = love.graphics.newImage(allImages[i])
    tileW[i - 1], tileH[i - 1] = allW[i], allH[i]
    tilesetW, tilesetH = Tileset[i - 1]:getWidth(), Tileset[i - 1]:getHeight()
    

    
    --table.insert(leftPic, love.graphics.newQuad(0, 0, tileW, tileH, tilesetW, tilesetH))
    --table.insert(leftPic, love.graphics.newQuad(32, 0, tileW, tileH, tilesetW, tilesetH))
    --table.insert(leftPic, love.graphics.newQuad(64, 0, tileW, tileH, tilesetW, tilesetH))
    --table.insert(leftPic, love.graphics.newQuad(96, 0, tileW, tileH, tilesetW, tilesetH))
    
    leftPic[i - 1] = {}
    leftPic[i - 1][0] = love.graphics.newQuad(0, 0, tileW[i - 1], tileH[i - 1], tilesetW, tilesetH)
    leftPic[i - 1][1] = love.graphics.newQuad(tileW[i - 1], 0, tileW[i - 1], tileH[i - 1], tilesetW, tilesetH)
    leftPic[i - 1][2] = love.graphics.newQuad(tileW[i - 1] * 2, 0, tileW[i - 1], tileH[i - 1], tilesetW, tilesetH)
    leftPic[i - 1][3] = love.graphics.newQuad(tileW[i - 1] * 3, 0, tileW[i - 1], tileH[i - 1], tilesetW, tilesetH)

    
    rightPic[i - 1] = {}
    rightPic[i - 1][0] = love.graphics.newQuad(0, tileH[i - 1], tileW[i - 1], tileH[i - 1], tilesetW, tilesetH)
    rightPic[i - 1][1] = love.graphics.newQuad(tileW[i - 1], tileH[i - 1], tileW[i - 1], tileH[i - 1], tilesetW, tilesetH)
    rightPic[i - 1][2] = love.graphics.newQuad(tileW[i - 1] * 2, tileH[i - 1], tileW[i - 1], tileH[i - 1], tilesetW, tilesetH)
    rightPic[i - 1][3] = love.graphics.newQuad(tileW[i - 1] * 3, tileH[i - 1], tileW[i - 1], tileH[i - 1], tilesetW, tilesetH)
    
    
  end
  
  
  
  mushroomRed = love.graphics.newImage("pic/mushroomred.png")
  mushroomGreen = love.graphics.newImage("pic/mushroomgreen.png")