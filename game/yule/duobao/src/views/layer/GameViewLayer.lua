--
-- Author: garry
-- Date: 2017-2-23
--
local GameViewLayer = class("GameViewLayer",function(scene)
		local gameViewLayer =  display.newLayer()
    return gameViewLayer
end)
local module_pre = "game.yule.duobao.src"

local ExternalFun = require(appdf.EXTERNAL_SRC .. "ExternalFun")
local g_var = ExternalFun.req_var
local ClipText = appdf.EXTERNAL_SRC .. "ClipText"
local PopupInfoHead = appdf.EXTERNAL_SRC .. "PopupInfoHead"

local cmd = module_pre .. ".models.cmd_game"
local Gem = module_pre..".views.layer.Gem"
local DuobaoLayer  = module_pre..".views.layer.DuobaoLayer"
local HelpLayer = module_pre..".views.layer.HelpLayer"
local SetLayer = module_pre..".views.layer.SetLayer"
local ExitLayer = module_pre..".views.layer.ExitLayer"
 
local game_cmd = appdf.HEADER_SRC .. "CMD_GameServer"
local QueryDialog   = require("app.views.layer.other.QueryDialog")
local TAG = {BUTTON_START = 1,BUTTON_TUOGUAN = 2,BUTTON_BACK = 3,BUTTON_XIANSUB =4,
                  BUTTON_XIANADD = 5,BUTTON_SCORESUB =6,BUTTON_SCOREADD =7,BUTTON_HELP = 8,BUTTON_SET = 9}


function GameViewLayer:ctor(scene)

  self._scene = scene
  
  self.againFlag = true
  self.firstRank = false

  self:initGame()

  	--初始化csb界面
  self:initCsbRes()

  

  	 --注册事件
  ExternalFun.registerTouchEvent(self,true)

  
end



function GameViewLayer:gameDataReset()

 
    self.gameData.zuanNumber = 0
    self.gameData.rankNumber = 1
    self.gameData.playScore = self.lastScore
    self.gameData.showWinScore = 0
    self._scene.rankNum = 4
    self.levelFlagTable ={true,true,true}

   self._scene:SendUserReady()

    self.rankNum = self.gameData.rankNumber +3
    self:updateView()
    self:updatePosition()
    self:updateZuantou()

end

function GameViewLayer:initCsbRes()
   local rootLayer, csbNode = ExternalFun.loadRootCSB("game_res/csb/GameScene.csb",self)
   self._rootNode = csbNode

   self:initButtonEvent()
    --self:showUserInfo(self._scene:GetMeUserItem())
end

function GameViewLayer:initGame()

       --搜索路径
    local gameList = self:getParentNode():getParentNode():getApp()._gameList;
    local gameInfo = {};
    for k,v in pairs(gameList) do
        if tonumber(v._KindID) == tonumber(g_var(cmd).KIND_ID) then
            gameInfo = v;
            break;
        end
    end

  if nil ~= gameInfo._Module then
      self._searchPath = device.writablePath.."game/" .. gameInfo._Module .. "/res/";
      print("search path is ========= >"..self._searchPath)
      cc.FileUtils:getInstance():addSearchPath(self._searchPath);
    end

    self.topP = nil
    self.bomP = nil
    self.gameData ={}                                                   --场景数据table
    self.topGemAtable = {}                                          --上面宝石精灵table
    self.bomGemAtable = {}                                         --下面宝石精灵table
    self.tempSpare = {}                                                 --备用填充宝石精灵table
    self.isTuoguan = false                                            --托管标识，true为正在托管
    self.gameState = false                                           ---false  空闲，true  游戏
    self.isGongGao = false                                          --是否正在播放公告
    self.isSpare = false                                                --是否是申请备用宝石
    
    self.lastScore = 0                                                    --游戏结束是记录上次游戏总分
    self.sameGemNum = 0                                           --相同宝石个数
    self.destroyTable = {}                                              --消除宝石列表
    self.oldStorage = 0                                                  --库存
    self.showLevelFlag = false
    self.gemGetFlag = false
    self.levelFlagTable ={true,true,true}
    self.storageScheduler = nil
    self.tGetScore = {}
    self.tGonggao = {}

    self.topP =cc.p(575,560)
    self.bomP=cc.p(575,110)

    cc.SpriteFrameCache:getInstance():addSpriteFrames("game_res/animation/gem.plist")

    if GlobalUserItem.bVoiceAble then
        AudioEngine.playMusic("sound_res/BACK_MUSIC.mp3", true)
    end
  

end


function GameViewLayer:updateView()
      --关卡img
      self.rankImg = self._rootNode:getChildByName("Sprite_rank")
      if self.gameData.rankNumber  >=4 then
          self.rankImg:setTexture(cc.Director:getInstance():getTextureCache():addImage("game_res/rank3.png"))
      else
        self.rankImg:setTexture(cc.Director:getInstance():getTextureCache():addImage("game_res/rank"..self.gameData.rankNumber..".png"))
      end

      --游戏总游戏币数
      self.totalScore = self._rootNode:getChildByName("AtlasLabel_1")
      self.totalScore:setString(""..self.gameData.playScore*self.gameData.exchange)

      --本局游戏分
      self.benjuScore = self._rootNode:getChildByName("AtlasLabel_2")
      self.benjuScore:setString(""..self.gameData.showWinScore*self.gameData.exchange)

      self.kucunGold = self._rootNode:getChildByName("AtlasLabel_4")
      self.kucunGold:setString(""..self.gameData.kuncunNumber*self.gameData.exchange)
      self.oldStorage = self.gameData.kuncunNumber*self.gameData.exchange

      --关数
      self.rankImg = self._rootNode:getChildByName("Sprite_rank")

      --线数
      self.xianNum = self._rootNode:getChildByName("AtlasLabel_3")
      self.xianNum:setString(""..self.gameData.lineNumber)

      --单位分数
      self.xianScore = self._rootNode:getChildByName("AtlasLabel_5")
      self.xianScore:setString(""..self.gameData.lineGold*self.gameData.lineTimes)

      self.sliderLineGold:setPercent(100*self.gameData.lineGold/20)

      self:updateZuan()

end

function GameViewLayer:updateZuantou()

      print("zuantou init ")


      if self.zuanTable then
            for i=1,#self.zuanTable do
              self.zuanTable [i]:removeFromParent()
            end
      end


      self.zuanTable ={}
     
      for i=1,45 - self.gameData.zuanNumber do
        local box = cc.Sprite:create("game_res/baoxiang.png")
            self._rootNode:addChild(box)
            self.zuanTable[i] = box
        if i<=15 then        
          box:setPosition(918-(i-1)*35,58)
        elseif i >15 and i<=30 then
          box:setPosition(429,96+(i-16)*37)          
        else
          box:setPosition(918,96+(i-31)*37)
        end

      end
  
end

function GameViewLayer:updatePosition()

   if self._scene.rankNum == g_var(cmd).GEM_FIRST then
    self.topP =cc.p(575,560)
    self.bomP=cc.p(575,110)

  elseif self._scene.rankNum == g_var(cmd).GEM_SECOND then
    self.topP =cc.p(538,560)
    self.bomP=cc.p(538,110)

  elseif self._scene.rankNum == g_var(cmd).GEM_THIRD then
    self.topP =cc.p(510,560)
    self.bomP=cc.p(510,110)
  end


end


--公告
function GameViewLayer:addGongGao(_cmd_table,_type)

      table.insert(self.tGonggao,{cmd_table =_cmd_table,ggtype = _type})

      local meItem = self._scene:GetMeUserItem()
      if _type == 2 and _cmd_table.nUserID ==meItem.dwUserID then
          self.gameData.playScore = self.gameData.playScore +_cmd_table.lGemScore
          self.gameData.showWinScore = self.gameData.showWinScore + _cmd_table.lGemScore

          self:updateScore()
      end

      if not self.isGongGao then

             self:showGongGao(clone(self.tGonggao[1].cmd_table),_type)

      end

end

function GameViewLayer:showGongGao(cmd_table,ggtype)
  
    local  layout1 = self._rootNode:getChildByName("Panel_2")
    ---layout:setSize()
    --local  txt = layout1:getChildByName("Text_1")
    --txt:setVisible(false)

    local layout = ccui.Layout:create()
            layout:setContentSize(cc.size(390, 39))
            layout:setPosition(483,627)
            layout:setClippingEnabled(true)

    self._rootNode:addChild(layout)

    if self.isGongGao then
        return
    end
   
    self.isGongGao = true

    local gem = {"白玉", "碧玉", "黑玉", "玛玉", "金蛋", 
                          "红宝石", "猫眼石", "蓝宝石", "翡翠", "紫猫眼", 
                          "浅蓝钻石", "绿钻石", "黄宝石", "蓝钻石", "钻石","钻头"}
    --cmd_table.wPlayName
    local strT = {}
    local colorT = {}

        if ggtype == 1 then
            strT = {cmd_table.wPlayName,"拍出",cmd_table.nGemCount,"连线",gem[cmd_table.nGemIndex + 1],",共赢得",cmd_table.lGemScore*self.gameData.exchange,"点数!"}
            colorT = {cc.c3b(76,187,117),cc.c3b(213,150,94),cc.c3b(246,74,89),cc.c3b(213,150,94),cc.c3b(246,74,89),cc.c3b(213,150,94),cc.c3b(246,74,89),cc.c3b(213,150,94)}
        else
            strT = {cmd_table.wPlayName,"获得派发的彩金",cmd_table.lGemScore*self.gameData.exchange}
            colorT = {cc.c3b(76,187,117),cc.c3b(213,150,94),cc.c3b(246,74,89)}
        end

    local txt1 = cc.Label:createWithSystemFont("恭喜","res/fonts/FZCUYUAN-M03S.TTF",20)
                        :move(390,20)
                        :setColor(cc.c3b(213,150,94))
                        :setAnchorPoint(cc.p(0,0.5))
                        :addTo(layout)
    local lenth = txt1:getContentSize().width

    for i=1,#strT do
       --print("addGongGao11111,"..cmd_table.nGemIndex)
        --print("addGongGao,i="..i..",#strT = "..#strT..","..ggtype)
          local txt2 = cc.Label:createWithSystemFont((strT[i]..""),"res/fonts/FZCUYUAN-M03S.TTF",20)
                        :move(lenth,0)
                        :setColor(colorT[i])
                        :setAnchorPoint(cc.p(0,0))
                        :addTo(txt1)
            lenth = lenth + txt2:getContentSize().width
    end  
    txt1:runAction(cc.Sequence:create(cc.Repeat:create(cc.Sequence:create(cc.MoveBy:create(5,cc.p(-390 - lenth,0)),cc.CallFunc:create(function ()
    table.remove(self.tGonggao,1)

      txt1:setPosition(390,20)
    end)),3),cc.RemoveSelf:create(),cc.CallFunc:create(function ()
      print("addGongGao============>")
      self.isGongGao = false

      if #self.tGonggao >=1 then
             
            self:showGongGao(clone(self.tGonggao[1].cmd_table),self.tGonggao[1].ggtype)
             
      end

    end)))

    
    
end




function GameViewLayer:updateLevel()

    self.rankImg:setTexture(cc.Director:getInstance():getTextureCache():addImage("game_res/rank"..(self._scene.rankNum-3 <=3 and (self._scene.rankNum-3) or 3)..".png"))
    self:updatePosition()
   
  
end

function GameViewLayer:initButtonEvent()
   
   --确定
    self.btn_ok = self._rootNode:getChildByName("Button_1")
    self.btn_ok:setTag(TAG.BUTTON_START)
    self.btn_ok:addTouchEventListener(handler(self, self.onEvent))
  

    --托管
    self.btn_tuoguan = self._rootNode:getChildByName("Button_tuoguan")
    self.btn_tuoguan:setTag(TAG.BUTTON_TUOGUAN)
    self.btn_tuoguan:addTouchEventListener(handler(self, self.onEvent))

    --退出
    local btn = self._rootNode:getChildByName("Button_back")
    btn:setTag(TAG.BUTTON_BACK)
    btn:addTouchEventListener(handler(self, self.onEvent))

    --线数减
    self.xianSub = self._rootNode:getChildByName("Button_sub1")
    self.xianSub:setTag(TAG.BUTTON_XIANSUB)
    self.xianSub:addTouchEventListener(handler(self, self.onEvent))

    --线数加
    self.xianAdd = self._rootNode:getChildByName("Button_add1")
    self.xianAdd:setTag(TAG.BUTTON_XIANADD)
    self.xianAdd:addTouchEventListener(handler(self, self.onEvent))


    --线分减
    self.scoreSub = self._rootNode:getChildByName("Button_sub2")
    self.scoreSub:setTag(TAG.BUTTON_SCORESUB)
    self.scoreSub:addTouchEventListener(handler(self, self.onEvent))


    --线分加
    self.scoreAdd = self._rootNode:getChildByName("Button_add2")
    self.scoreAdd:setTag(TAG.BUTTON_SCOREADD)
    self.scoreAdd:addTouchEventListener(handler(self, self.onEvent))

    --线分滑动条
    self.sliderLineGold = self._rootNode:getChildByName("Slider_1")
    self.sliderLineGold:onEvent(handler(self,GameViewLayer.SlideEvent))
    self.sliderLineGold:setPercent(0)
    --self.sliderLineGold:setMaxPercent(50)
    --self.sliderLineGold:setMaximumValue(5.0) 
 
    --帮助
    btn = self._rootNode:getChildByName("Button_2")
    btn:setTag(TAG.BUTTON_HELP)
    btn:addTouchEventListener(handler(self, self.onEvent))

    --设置
    btn = self._rootNode:getChildByName("Button_3")
    btn:setTag(TAG.BUTTON_SET)
    btn:addTouchEventListener(handler(self, self.onEvent))


    self.zuanImgTable ={}
    self.zuanTxtTable = {}
    for i=1,5 do
        print("mmmmmmmmmmmmmmmm"..i)
        local img = self._rootNode:getChildByName("img_zuan"..i)
        table.insert(self.zuanImgTable,img)

        local txt = self._rootNode:getChildByName("zuan"..i)
        table.insert(self.zuanTxtTable,txt)
    end
end

function GameViewLayer:SlideEvent(event)
  if event.name == "ON_PERCENTAGE_CHANGED" then
    local percent = event.target:getPercent()
    self.sliderLineGold:setPercent(percent)
    --[[
    if percent <= 15 then
      self.sliderLineGold:setPercent(15)
    elseif percent >= 85 then
      self.sliderLineGold:setPercent(85)
    end
    ]]

    local number = percent*2 -percent*2%10
    number = number <=10 and 10 or number
    if number ~= self.gameData.lineGold*10 then
      self.gameData.lineGold = number/10
            self.xianScore:setString(""..self.gameData.lineGold*self.gameData.lineTimes)
            self:lineGoldChange()
            self:updateZuan()
     -- print("percent===========================>"..number)
    end
  
  end
end


--得分提示
function GameViewLayer:showGetScore(type,num)
      local bgSprite = cc.Sprite:create("game_res/huodeBg.png")
      bgSprite:setPosition(666,355)
      self._rootNode:addChild(bgSprite,100,100)

      local gem = cc.Sprite:createWithSpriteFrameName("anim_gem_"..type.."_0.png")
      gem:setPosition(58,63)
      bgSprite:addChild(gem,10,10)



      local numtxt  = cc.Label:createWithSystemFont("x"..num,"res/fonts/msyh.ttf",37)
                :move(125,63)
                :setColor(cc.c3b(253,203,109))

      bgSprite:addChild(numtxt,10,10)



      local huode = cc.Sprite:create("game_res/huodeTxt.png"):move(195,62)

      bgSprite:addChild(huode,10,10)


      local scoreNum = {
      { 2, 4, 5, 8, 10, 20, 30, 50, 100, 200, 400 },
      { 4, 5, 10, 20, 30, 50, 100, 250, 500, 750, 800 },
      { 5, 10, 20, 40, 80, 160, 500, 1000, 2000, 5000, 6000 },
      { 10, 30, 50, 60, 100, 750, 1000, 10000, 20000, 50000, 60000  },
      { 20, 50, 100, 500, 1000, 2000, 5000, 20000, 50000, 60000, 80000  },

      { 2, 4, 5, 8, 10, 20, 30, 50, 100, 200, 450 },
      { 4, 5, 10, 20, 30, 50, 100, 250, 500, 750, 1000  },
      { 5, 10, 20, 40, 80, 160, 500, 1000, 2000, 5000, 7000 },
      { 10, 30, 50, 60, 100, 750, 1000, 10000, 20000, 50000, 70000  },
      { 20, 50, 100, 500, 1000, 2000, 5000, 20000, 50000, 80000, 100000 },

      { 2, 4, 5, 8, 10, 20, 30, 50, 100, 200, 500 },
      { 4, 5, 10, 20, 30, 50, 100, 250, 500, 750, 1200  },
      { 5, 10, 20, 40, 80, 160, 500, 1000, 2000, 5000, 8000 },
      { 10, 30, 50, 60, 100, 750, 1000, 10000, 20000, 50000, 80000  },
      { 20, 50, 100, 500, 1000, 2000, 5000, 20000, 50000, 100000, 100000  }
      }
      local gemNum = ((num- self._scene.rankNum +1 )> 11 and 11 or  (num- self._scene.rankNum+1))

      print("xxxxxxxxxxxxxxxxxxxxxxxxxx,"..type..","..gemNum)
      local defen = scoreNum[type+1][gemNum]*self.gameData.cellScore*self.gameData.lineNumber*self.gameData.lineGold*self.gameData.lineTimes/10

      local score = cc.Label:createWithCharMap("game_res/kucunNum.png", 27, 40, 48)
      score:setPosition(245,62)
      score:setAnchorPoint(cc.p(0,0.5))
      score:setString(""..defen*self.gameData.exchange)
      bgSprite:addChild(score,10,10)

      bgSprite:runAction(cc.Sequence:create(cc.MoveTo:create(0.3,cc.p(666,535)),cc.DelayTime:create(2),cc.RemoveSelf:create(),cc.CallFunc:create(function ()
          
          if #self.tGetScore>=1 then
              self:showGetScore(self.tGetScore[1][1],self.tGetScore[1][2])
          end

      end)))

      self.gameData.playScore = self.gameData.playScore +defen
      self.gameData.showWinScore = self.gameData.showWinScore + defen

      self:updateScore()
      table.remove(self.tGetScore,1)
      
end


function GameViewLayer:updateScore()
    self.totalScore:setString(""..self.gameData.playScore*self.gameData.exchange) 

    self.benjuScore:setString(""..self.gameData.showWinScore*self.gameData.exchange)
end

--创建宝石
function GameViewLayer:updateGem()
    print("uuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu1")
    

    self.tempSpare = {}

--if self._scene.rankNum ==5 then
   -- self._scene.gemBottomTable = {7,7,7,7,7, 7,7,7,7,7, 7,9,7,7,7, 7,7,9,9,8, 5,6,7,8,9}
   -- end

--[[
    self._scene.gemTopTable = {4,2,1,3}]]



    for i = 1,#self._scene.gemBottomTable do
        local sprite1 = g_var(Gem):create(self._scene.gemBottomTable[i],(i-1)%self._scene.rankNum,math.floor((i-1)/self._scene.rankNum))
         sprite1:setPosition(self.bomP.x + ((i-1)%self._scene.rankNum)*g_var(cmd).GEM_DISTANCE,597)
         sprite1:setVisible(false)
         sprite1:setScale(1.1)
         self._rootNode:addChild(sprite1)
       
          if self.isSpare then
            

                if ((i-1)%self._scene.rankNum) == 0 then
                  self.tempSpare[math.floor((i-1)/self._scene.rankNum)+1] ={}
                end
                  self.tempSpare[math.floor((i-1)/self._scene.rankNum)+1][(i-1)%self._scene.rankNum +1] =  sprite1

          else

             table.insert(self.bomGemAtable,sprite1)
           end

      end


    for i=1,#self._scene.gemTopTable do
       local sprite1 = g_var(Gem):create(self._scene.gemTopTable[i],i,1)
       
       sprite1:setPosition(self.topP.x + (i-1)*g_var(cmd).GEM_DISTANCE,597)
       sprite1:setVisible(false)
       sprite1:setScale(1.1)
       self._rootNode:addChild(sprite1)


      if self.isSpare then

                if 1 == i then
                    self.tempSpare[self._scene.rankNum + 1] = {}
                end
                self.tempSpare[self._scene.rankNum + 1][i] = sprite1
                
      else
            table.insert(self.topGemAtable,sprite1)
      end
    end



    if self.isSpare then


      self:runAction(cc.Sequence:create(cc.DelayTime:create(0.5),cc.CallFunc:create(function ()

           self:dropAfterDestroy(true)
      end)))
    
    else
        
            self.gameData.playScore = self.gameData.playScore  - self.gameData.lineNumber*self.gameData.lineGold*self.gameData.lineTimes*self.gameData.cellScore
            
        
            self.gameData.showWinScore = self.gameData.showWinScore - self.gameData.lineNumber*self.gameData.lineGold*self.gameData.lineTimes*self.gameData.cellScore

            self.gameData.showWinScore = self.gameData.showWinScore <=0 and 0 or self.gameData.showWinScore

            self:updateScore()

            self.tempTable = {}

          for i =1,#self._scene.gemBottomTable  do
            if ((i-1)%self._scene.rankNum) == 0 then
              self.tempTable[math.floor((i-1)/self._scene.rankNum)+1] ={}
            end

              self.tempTable[math.floor((i-1)/self._scene.rankNum)+1][(i-1)%self._scene.rankNum + 1] = self.bomGemAtable[i]

          end
          --[[
         -- print("ooooooooooooooooo="..self._scene.rankNum)
          for i=1,self._scene.rankNum do
            local str = ""
            for j=1,self._scene.rankNum do
              str = str..","..self.tempTable[i][j]._type
            end
              -- print("pppppppppppppp="..str)
          end]]

          self:gemDrop()
    end
end


function GameViewLayer:changeSpareGem(spare)
      local gemSpare = {}

      for i =1,#spare do
            if ((i-1)%self._scene.rankNum) == 0 then
              gemSpare[math.floor((i-1)/self._scene.rankNum)+1] ={}
            end

              gemSpare[math.floor((i-1)/self._scene.rankNum)+1][(i-1)%self._scene.rankNum + 1] = spare[i]

      end

      for i=2,#self.tempSpare do
              for j=1,self._scene.rankNum do
                  print("changeSpareGem ,i="..i..",j="..j)
                  if self.tempSpare[i][j]._isDestroy then
                        local gem = self.tempSpare[i][j]
                        self.tempSpare[i][j] = gemSpare[1][j]
                        gemSpare[1][j] = gem

                        for n=1,self._scene.rankNum do
                            if gemSpare[n+1][j]._isDestroy then
                              break
                            end

                            local gem = gemSpare[n][j]
                            gemSpare[n][j] = gemSpare[n+1][j]
                            gemSpare[n+1][j] = gem
                        end
                  end
         
              end
      end

      local num = #self.tempSpare
      for i =1,self._scene.rankNum + 1 do
          self.tempSpare[num +i] = gemSpare[i]
      end

end



--宝石下落
function GameViewLayer:gemDrop()
    print("fffffffffffffffffffffff"..self._scene.rankNum)
    for i = 1,self._scene.rankNum do
      local randTable = self:getRandomTable(self._scene.rankNum)
      for j = 1,self._scene.rankNum do
       -- print("indexdrop = "..((i-1)*self._scene.rankNum + randTable[j]))

        local gemSprite = self.bomGemAtable[(i-1)*self._scene.rankNum + randTable[j]]
        
        gemSprite:runAction(cc.Sequence:create(cc.DelayTime:create(0.1+((i-1)*self._scene.rankNum+j-1)*0.15),
          cc.CallFunc:create(function ()
            gemSprite:setVisible(true)
            gemSprite:runAction(cc.MoveTo:create(0.2,cc.p(self.bomP.x + (randTable[j]-1)*g_var(cmd).GEM_DISTANCE,self.bomP.y + (i-1)*g_var(cmd).GEM_DISTANCE)))

              AudioEngine.playEffect("sound_res/GEM_LAND.wav")

              if i== self._scene.rankNum and j==self._scene.rankNum then
                local randTable1 = self:getRandomTable(self._scene.rankNum)
                for i = 1,self._scene.rankNum do

                  local topSprite = self.topGemAtable[randTable1[i]]
        
                  topSprite:runAction(cc.Sequence:create(cc.DelayTime:create(0.1+(i-1)*0.15),
                  cc.CallFunc:create(function ()
                    topSprite:setVisible(true)
                    topSprite:runAction(cc.MoveTo:create(0.1,cc.p(self.topP.x + (randTable1[i]-1)*g_var(cmd).GEM_DISTANCE,self.topP.y )))

                    if i==self._scene.rankNum then
                        self:findZuantouToDestory()
                    end
                    
                    end)))

                end
              end
            end)))
      end
    end

    
end


--乱序数组
function GameViewLayer:getRandomTable(num)
  
  local numTable = {}
  

  for i = 1,num do
      numTable[i] = i
  end
  
  for i=1,num do
      local rad= math.floor(math.random(num))

      local temp =numTable[i]
      numTable[i] = numTable[rad]
      numTable[rad] = temp

  end  

  return numTable
end

function GameViewLayer:findZuantouToDestory()

    for i = 1,#self.bomGemAtable do

      if self.bomGemAtable[i]._type ==g_var(cmd).GEMINDEX_ZUANTOU then

          self.bomGemAtable[i]._isDestroy = true
          self.bomGemAtable[i]:showDestroy()
          AudioEngine.playEffect("sound_res/GEM_BOMB.wav")

          --print("jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj"..#self.zuanTable..",zuanNumber"..self.gameData.zuanNumber)

          local allNum = #self.zuanTable
          self.zuanTable[allNum]:setVisible(false)
          self.zuanTable[allNum] = nil
          --table.remove(self.zuanTable,45-self.gameData.zuanNumber)

          self.gameData.zuanNumber = self.gameData.zuanNumber + 1

          
          self:sendGetGem(false) 

          return 
      end

    end

    self:findGemToDestroy()
   
end


function GameViewLayer:findGemToDestroy()

      --重置遍历标识位
      for i =1,self._scene.rankNum do
          for j = 1,self._scene.rankNum do
            self.tempTable[i][j]._flag = false
          end
      end


       for i=1,self._scene.rankNum do
          for j=1,self._scene.rankNum do
              local tempSprite = self.tempTable[i][j]

              if not tempSprite._flag then
                self.sameGemNum = 1
                table.insert(self.destroyTable,self.tempTable[i][j])

                self:findSameGem(self.tempTable,i,j)
                if self.sameGemNum >= self._scene.rankNum then
                  for i=1,#self.destroyTable do
                      self.destroyTable[i]._isDestroy = true
                  end
                  
                  table.insert(self.tGetScore, {self.destroyTable[1]._type,self.sameGemNum})
                end
                --print("ppppppppppppp1 = "..self.sameGemNum)

                self.destroyTable = {}
                self.sameGemNum = 0

              end

          end
       end

       local haveDestroy = false
       for i=1,self._scene.rankNum do
        
          for j=1,self._scene.rankNum do
            if self.tempTable[i][j]._isDestroy then
               self.tempTable[i][j]:showDestroy()

               haveDestroy = true
            end
          end
      end

      if haveDestroy then
          AudioEngine.playEffect("sound_res/GEM_BOMB.wav")

          self:showGetScore(self.tGetScore[1][1],self.tGetScore[1][2])

          self:sendGetGem(false) 

      else
        
        self:runAction(cc.Sequence:create(cc.DelayTime:create(0.5),cc.CallFunc:create(function ()
            for i=1,self._scene.rankNum do
              for j=1,self._scene.rankNum do
                local fangxiang = math.floor(math.random(2))

                local jump = cc.JumpTo:create(0.6,cc.p(self.tempTable[i][j]:getPositionX()+math.random(350)*(fangxiang == 1 and -1 or 1),-50),math.random(100)+200,1)
            

                self.tempTable[i][j]:runAction(cc.Sequence:create(jump,cc.RemoveSelf:create()))

              end
            end

            for i=1,self._scene.rankNum do

               local fangxiang = math.floor(math.random(2))
               local jump = cc.JumpTo:create(0.6,cc.p(self.topGemAtable[i]:getPositionX()+math.random(350)*(fangxiang == 1 and -1 or 1),-50),math.random(100)+200,1)
            
              self.topGemAtable[i]:runAction(cc.Sequence:create(jump,cc.RemoveSelf:create()))
            end

            
            AudioEngine.playEffect("sound_res/GEM_SCATTERED.wav")

            self.bomGemAtable = {}
            self.topGemAtable = {}     
            
            if self.isTuoguan then
              self:runAction(cc.Sequence:create(cc.DelayTime:create(0.5),cc.CallFunc:create(function ()

                    if 0 ~= #self.zuanTable then

                      if not self:isGoldEnough() then
                              self.gameState = false
                              self:changeButtonState(true,false)

                              return 
                      end

                      self.gameState = true
                      self:sendGetGem(true)
                    end

                  end)))
            else
                  self.gameState = false
                  --self.btn_ok:setEnabled(true) 
                  self:changeButtonState(true,false)
            end


            if   0 == #self.zuanTable then
                self.gameState = false

                self:changeButtonState(true,false)
                self:sendGetGem(true)

            end

          end )))
         
      end

end

--按钮状态
function GameViewLayer:changeButtonState(btnflag,tgflag)


        if not self.gameState  then
            self.xianSub:setEnabled(btnflag)
            self.xianAdd:setEnabled(btnflag)
            self.scoreSub:setEnabled(btnflag)
            self.scoreAdd:setEnabled(btnflag)
            self.sliderLineGold:setEnabled(btnflag)
            self.btn_ok:setEnabled(btnflag)
        end

        self.isTuoguan = tgflag

        local path = tgflag and "game_res/bt_tuoguan2.png" or "game_res/bt_tuoguan1.png"
        self.btn_tuoguan:loadTextures(path, path, "")

end




--递归寻找相连的宝石
function GameViewLayer:findSameGem(gemTable,i,j)
  local gem = gemTable[i][j]
  gem._flag = true

    if j-1 >=1 and not gemTable[i][j-1]._flag and gemTable[i][j-1]._type == gem._type then
            self.sameGemNum = self.sameGemNum +1
            table.insert(self.destroyTable,gemTable[i][j-1])

            self:findSameGem(gemTable,i,j-1)
    end 

    if  j+1 <=self._scene.rankNum and not gemTable[i][j+1]._flag and gemTable[i][j+1]._type == gem._type then
            self.sameGemNum = self.sameGemNum +1
            table.insert(self.destroyTable,gemTable[i][j+1])

            self:findSameGem(gemTable,i,j+1)
    end

    if i+1 <=self._scene.rankNum and not gemTable[i+1][j]._flag and gemTable[i+1][j]._type == gem._type then
            self.sameGemNum = self.sameGemNum +1
            table.insert(self.destroyTable,gemTable[i+1][j])

            self:findSameGem(gemTable,i+1,j)
    end

    if i-1 >= 1 and not gemTable[i-1][j]._flag and gemTable[i-1][j]._type == gem._type then
            self.sameGemNum = self.sameGemNum +1
            table.insert(self.destroyTable,gemTable[i-1][j])

            self:findSameGem(gemTable,i-1,j)
    end

end



--宝石消除后掉落
function GameViewLayer:dropAfterDestroy(flag)


  print("uuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu2")
      --游戏池的掉落
      for i=2,self._scene.rankNum do
        for j=1,self._scene.rankNum do

          if not self.tempTable[i][j] then
            print("dropAfterDestroy,i="..i..",j="..j)
          end

          
          if not self.tempTable[i][j]._isDestroy  then
                --AudioEngine.playEffect("sound_res/GEM_LAND.wav")
                for k=1,self._scene.rankNum - 1 do
                    if i-k>=1 and self.tempTable[i -k][j]._isDestroy  then
                         local temp = self.tempTable[i -k][j]
                         self.tempTable[i -k][j] = self.tempTable[i -k +1][j]
                         self.tempTable[i -k +1][j] = temp
                         self.tempTable[i -k][j]:runAction(cc.MoveBy:create(0.2,cc.p(0,-g_var(cmd).GEM_DISTANCE)))
                         --AudioEngine.playEffect("sound_res/GEM_LAND.wav")
                        if 1 == k then--只响一次
                             self:runAction(cc.Sequence:create(cc.DelayTime:create(0.2),cc.CallFunc:create(function ()
                              AudioEngine.playEffect("sound_res/GEM_LAND.wav")
                            end)))
                        end

                    else
                        
                      break
                    end

                end
          end
        end
      end
      
    self:runAction(cc.Sequence:create(cc.DelayTime:create(0.5),cc.CallFunc:create(function ()

      --上面的掉落
      for i=1,self._scene.rankNum do

          if self.tempTable[self._scene.rankNum][i]._isDestroy  then
              for j=1,self._scene.rankNum do
                  local gem = self.tempTable[self._scene.rankNum - j +1 ][i]

                  if 1==j then                    
                      self.tempTable[self._scene.rankNum][i] = self.topGemAtable[i]
                      self.topGemAtable[i] = gem
                  else            
                      self.tempTable[self._scene.rankNum -j + 1][i] = self.tempTable[self._scene.rankNum -j + 2][i]
                      self.tempTable[self._scene.rankNum -j + 2][i] = gem
                  end


                  if self._scene.rankNum -j < 1 or not self.tempTable[self._scene.rankNum -j][i]._isDestroy then

                      self.tempTable[self._scene.rankNum -j + 1][i]:runAction(cc.Sequence:create(cc.DelayTime:create(i*0.1),cc.Show:create(),cc.MoveTo:create(0.18 +(j-1)*0.1 ,cc.p(self.bomP.x + (i-1)*g_var(cmd).GEM_DISTANCE,self.bomP.y+(self._scene.rankNum -j)*g_var(cmd).GEM_DISTANCE)),cc.CallFunc:create(function ()

                                          AudioEngine.playEffect("sound_res/GEM_LAND.wav")
                                        end)))

                      break
                  end

              end
          end

      end

      --重新申请的宝石的掉落
      local numIndex = 1
      local time = 0

      for i=1,self._scene.rankNum  do
            for j=1,self._scene.rankNum do
                  
                  if self.tempTable[i][j]._isDestroy then

                      if numIndex ~= i then
                            time = time + 1
                            numIndex = i
                        end

                      self.tempTable[i][j] = self.tempSpare[i][j]

                      self.tempTable[i][j]:runAction(cc.Sequence:create(cc.DelayTime:create(0.2+(time-1)*0.3 +j*0.1),cc.Show:create(),cc.MoveTo:create(0.18 +(self._scene.rankNum -i)*0.1 ,cc.p(self.bomP.x + (j-1)*g_var(cmd).GEM_DISTANCE,self.bomP.y+(i -1)*g_var(cmd).GEM_DISTANCE)),cc.CallFunc:create(function ()

                                          AudioEngine.playEffect("sound_res/GEM_LAND.wav")
                                        end)))
                  end
            end
      end

      for i =1,self._scene.rankNum do

            if self.topGemAtable[i]._isDestroy then

                  self.topGemAtable[i] = self.tempSpare[self._scene.rankNum + 1][i]

                  self.topGemAtable[i]:setPosition(cc.p(self.topP.x + (i-1)*g_var(cmd).GEM_DISTANCE,597))  
                  self.topGemAtable[i]:runAction(cc.Sequence:create(cc.DelayTime:create(0.4+(time-1)*0.3 + i*0.1),cc.Show:create(),cc.MoveTo:create(0.1,cc.p(self.topP.x + (i-1)*g_var(cmd).GEM_DISTANCE,self.topP.y)),cc.CallFunc:create(function ()

                     -- AudioEngine.playEffect("sound_res/GEM_LAND.wav")

                    end)))
            end

      end


           
            self:runAction(cc.Sequence:create(cc.DelayTime:create(1+time*0.3),cc.CallFunc:create(function ()

                  self:findGemToDestroy()
              end)))
          
     end)))--action end
end

function GameViewLayer:onGameMessageBetFail(cmd_table)
        self.gameData.playScore = cmd_table.lPlayScore
        self.gameData.showWinScore = cmd_table.lPlayShowWinLose
        self:updateScore()
        self.gameState = false
        self:changeButtonState(true,false)

end

function GameViewLayer:onGameMessageUpdateStorage(newStorage)

        --self.kucunGold:setString(""..newStorage)


        local numTemp = self.oldStorage
        self.storageScheduler = cc.Director:getInstance():getScheduler():scheduleScriptFunc(function()  
                  
                numTemp  = numTemp + math.floor((newStorage - self.oldStorage-1)/60 +1)
                if numTemp <  newStorage then
                  self.kucunGold:setString(""..numTemp)
                else
                  self.kucunGold:setString(""..newStorage)
                  self.oldStorage = newStorage
                  if self.storageScheduler then
                    cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.storageScheduler)
                    self.storageScheduler = nil
                  end
                end

        end,1/60,false) 

end

function GameViewLayer:onExit()

      cc.SpriteFrameCache:getInstance():removeSpriteFramesFromFile("game_res/animation/gem.plist")

      if self.storageScheduler  then
          cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.storageScheduler)
          self.storageScheduler = nil
      end

end


function GameViewLayer:isGoldEnough()

            if  (self.gameData.playScore  - self.gameData.lineNumber*self.gameData.lineGold*self.gameData.lineTimes*self.gameData.cellScore) < 0  then

              showToast(self,"游戏币不足!",2)
              return false
            end
      return true
end


function GameViewLayer:onEvent(sender ,eventType )
  
   local tag = sender:getTag()

   

   if eventType == ccui.TouchEventType.ended  then
      AudioEngine.playEffect("sound_res/BUTTON_SOUND.wav")
     if tag == TAG.BUTTON_START then

          if not self:isGoldEnough() then
              return 
          end

          self:changeButtonState(false,false)

          self.gameState = true
          self:sendGetGem(true)     

    elseif tag == TAG.BUTTON_TUOGUAN then

        

        if self.isTuoguan then

          self:changeButtonState(true,false)

        else

          if not self:isGoldEnough() then
              return 
          end


          self:changeButtonState(false,true)

          if not self.gameState then

              self.gameState = true
              self:sendGetGem(true) 
          end

          

        end

     elseif tag == TAG.BUTTON_BACK then


          local ExitLayer = g_var(ExitLayer):create(self)
          self:addChild(ExitLayer)

      elseif tag == TAG.BUTTON_XIANSUB then
         if self.gameData.lineNumber - 1 >=1 then
            self.gameData.lineNumber = self.gameData.lineNumber - 1
            self.xianNum:setString(""..self.gameData.lineNumber)
            self:lineNumberChange()
            self:updateZuan()
         end

      elseif tag == TAG.BUTTON_XIANADD then
        if self.gameData.lineNumber + 1 <=self.gameData.maxLineCount then
            self.gameData.lineNumber = self.gameData.lineNumber + 1
            self.xianNum:setString(""..self.gameData.lineNumber)
            self:lineNumberChange()
            self:updateZuan()
         end

        --local duobaoLayer = g_var(DuobaoLayer):create(self._scene)
        --duobaoLayer:initData({1,2,3,4,5},3)
        --self:addChild(duobaoLayer)

        --self._scene:onEventGameMessage(g_var(cmd).SUB_S_GAME_OVER)

      elseif tag == TAG.BUTTON_SCORESUB then
        if self.gameData.lineGold - 1 >=1 then
          self.gameData.lineGold = self.gameData.lineGold -1
          self.xianScore:setString(""..self.gameData.lineGold*self.gameData.lineTimes)
          self:lineGoldChange()
          self:updateZuan()
          self.sliderLineGold:setPercent(self.gameData.lineGold*5)
        end
      elseif tag == TAG.BUTTON_SCOREADD then
        if self.gameData.lineGold + 1 <=20 then
          self.gameData.lineGold = self.gameData.lineGold +1
          self.xianScore:setString(""..self.gameData.lineGold*self.gameData.lineTimes)
          self.sliderLineGold:setPercent(self.gameData.lineGold*5)
          self:lineGoldChange()
          self:updateZuan()
        end

      elseif tag ==  TAG.BUTTON_HELP then

        self:addChild(g_var(HelpLayer):create())

      elseif tag == TAG.BUTTON_SET then
        local mgr = self._scene:getParentNode():getApp():getVersionMgr()
                              local verstr = mgr:getResVersion(g_var(cmd).KIND_ID) or "0"
                              verstr = "游戏版本:" .. appdf.BASE_C_VERSION .. "." .. verstr

        self:addChild(g_var(SetLayer):create(verstr))

     end
   end
end


function GameViewLayer:showRankChange(level)
    local guangquan = cc.Sprite:create("game_res/bg1.png"):move(672,395):addTo(self)
    guangquan:setLocalZOrder(9)

    local bg = cc.Sprite:create("game_res/bg3.png"):move(672,396):addTo(self)
    bg:setLocalZOrder(10)
    local level = cc.Sprite:create("game_res/level"..level..".png"):setScale(3):move(672,663):addTo(self)
    level:setLocalZOrder(11)

    guangquan:runAction(cc.RepeatForever:create(cc.RotateBy:create(3,360)))
    level:runAction(cc.Spawn:create(cc.MoveTo:create(0.2,cc.p(672,395)),cc.ScaleTo:create(0.5,1)))

    bg:runAction(cc.Sequence:create(cc.Spawn:create(cc.MoveTo:create(0.2,cc.p(672,396)),cc.ScaleTo:create(0.2,0.5)),cc.CallFunc:create(function ()
            bg:setTexture("game_res/bg2.png")
            bg:setScale(1)
            local huadong = cc.Sprite:create("game_res/huadong1.png"):move(76,85):addTo(bg)
            huadong:runAction(cc.Sequence:create(cc.MoveTo:create(1,cc.p(488,85)),cc.RemoveSelf:create()))

            local frames = {}
            for i=1,10 do
            
                local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame("blink"..i..".png")
                table.insert(frames, frame)
            end

             local  animation =cc.Animation:createWithSpriteFrames(frames,0.1)

             local sprite = cc.Sprite:createWithSpriteFrameName("blink1.png"):move(672,396):addTo(self)
             sprite:setLocalZOrder(12)


             local action = cc.RepeatForever:create(cc.Animate:create(animation))
              
              sprite:runAction(action)

             self:runAction(cc.Sequence:create(cc.DelayTime:create(1.5),cc.CallFunc:create(function ()
                 guangquan:removeFromParent()
                 bg:removeFromParent()
                 level:removeFromParent()
                 sprite:removeFromParent()
                 if self.showLevelFlag and not self.gemGetFlag then
                    self:updateGem()
                 end
                 self.showLevelFlag = false
                end)))

    end)))

end


function GameViewLayer:lineNumberChange()
    local dataBuffer = CCmd_Data:create(4)
      dataBuffer:pushint(self.gameData.lineNumber)
      self._scene:SendData(g_var(cmd).SUB_C_LINE_COUNT,dataBuffer)
end

function GameViewLayer:lineGoldChange()

  local dataBuffer = CCmd_Data:create(4)
      dataBuffer:pushint(self.gameData.lineGold)
      self._scene:SendData(g_var(cmd).SUB_C_LINE_NUMBER,dataBuffer)


end

--线数，线值改变
function GameViewLayer:updateZuan()
      
      for i =1,5 do
          if i<= self.gameData.lineNumber then
            self.zuanImgTable[i]:setTexture(cc.Director:getInstance():getTextureCache():addImage("game_res/zuanshi1.png"))
            self.zuanTxtTable[i]:setVisible(true)
            self.zuanTxtTable[i]:setString(""..self.gameData.lineGold*self.gameData.lineTimes)
          else
            self.zuanImgTable[i]:setTexture(cc.Director:getInstance():getTextureCache():addImage("game_res/zuanshi2.png"))
            self.zuanTxtTable[i]:setVisible(false)
          end
      end
end


function GameViewLayer:getParentNode()
  return self._scene
end

function GameViewLayer:getDataMgr( )
  return self:getParentNode():getDataMgr()
end

function GameViewLayer:showPopWait( )
  self:getParentNode():showPopWait()
end

function GameViewLayer:sendGetGem(flag)
  
    if flag then
        self.isSpare = false
        self.tempSpare = {}
        if (#self.zuanTable)%15 == 0 and  #self.zuanTable~= 0  and self.levelFlagTable[4 - #self.zuanTable/15] then
            self.showLevelFlag = true
            self.levelFlagTable[4 - #self.zuanTable/15] = false

          self:showRankChange(4 - #self.zuanTable/15)
        end
    else
        self.isSpare = true
    end


    self.gemGetFlag = true


    local dataBuffer = CCmd_Data:create(4)
      dataBuffer:pushint(flag)
      self._scene:SendData(g_var(cmd).SUB_C_GEM,dataBuffer)
    print("send getGem===================>")
end


return GameViewLayer