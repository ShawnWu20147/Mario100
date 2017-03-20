MAX_HIGHSCORE = 10    -- 最多显示多少个高分


GameInitialSpeed = 100  -- 开始下降的速度


GameGravity = 550       --游戏的重力
-- speed = speed + GameGravity * dt


MarioSpeed = 280
    
MarioCrazySpeed = 460


-- 以下2个用于绘图取样
MoveFastStep = 2
MoveSlowStep = 4


    
    

    
GameWidth = 480
GameHeight = 800



GameStartItems = 4  -- 首先有多少个选项 从0开始计数

allText = {}
allText[0] = {{255,34,125},"开始"}
allText[1] = {{255,34,125},"说明"}
allText[2] = {{255,34,125},"高分"}
allText[3] = {{255,34,125},"重置"}
allText[4] = {{255,34,125},"结束"}

StartItemPosY = {320, 400, 480, 560, 640}

StartItemPosX = 195

RectangleWidth = 80
RectangleHeight = 55




