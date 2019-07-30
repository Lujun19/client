
--
-- Author: Tang
-- Date: 2016-08-09 14:46:36
--
local GameViewLayer = class("GameViewLayer", function(scene)
	    local gameViewLayer = display.newLayer()
	    return gameViewLayer
    end)

--Tag
GameViewLayer.VIEW_TAG = 
{
    tag_bg        = 200,
    tag_autoshoot = 210,
    tag_autolock = 211,
    tag_gameScore= 212,
    tag_gameMultiple = 213,
    tag_grounpTips = 214,
    tag_GoldCycle = 3000,
    tag_GoldCycleTxt = 4000,
    tag_Menu = 5000,
    tag_MenuT = 5001,
    tag_GoldsText = 1000,
    tag_speed = 215,
    tag_upScore = 216,
    tag_downScore = 217,
}
local CHANGE_MULTIPLE_INTERVAL =  0.8
local  TAG = GameViewLayer.VIEW_TAG

local ExternalFun = require(appdf.EXTERNAL_SRC.."ExternalFun")
local HeadSprite = appdf.req(appdf.EXTERNAL_SRC .. "HeadSprite")
local g_var = ExternalFun.req_var
local ClipText = appdf.EXTERNAL_SRC .. "ClipText"
local module_pre = "game.yule.jcby.src"	
local game_cmd = appdf.HEADER_SRC .. "CMD_GameServer"
local PRELOAD = require(module_pre..".views.layer.PreLoading") 
local CannonSprite = require(module_pre..".views.layer.Cannon1")
local cmd = module_pre .. ".models.CMD_LKPYGame"
local scheduler = cc.Director:getInstance():getScheduler()
local Game_CMD = appdf.req(module_pre .. ".models.CMD_LKPYGame")
local HelpLayer = appdf.req(module_pre .. ".views.layer.HelpLayer")
local ControlLayer = module_pre..".views.layer.ControlLayer"
 
local random = math.random

local rewardPos = 
{
    cc.p(382,610),
	--cc.p(667,610),
	cc.p(897,610),
	cc.p(382,200),
	--cc.p(667,200),
	cc.p(897,200),
	--cc.p(204,399),
	--cc.p(1130,399)
}

function GameViewLayer:ctor( scene )

    self._tag = 0
	self._scene = scene
    self.m_bIsGameCheatUser = false

	self:addSerchPaths()
    PRELOAD.setEnded(false)
    self._gameFrame = scene._gameFrame

    self.m_pUserItem = self._gameFrame:GetMeUserItem()
   --预加载资源
    PRELOAD.loadTextures()

    --气泡特效
    self.particle1 = cc.ParticleSystemQuad:create("particle/particle_bubbleup.plist")
    self.particle1:setPosition(300, 0)
    self.particle1:setScale(1.2)

    self.particle1:setPositionType(cc.POSITION_TYPE_GROUPED)
    self._scene.fishBg:addChild(self.particle1, 3)

    self.particle2 = cc.ParticleSystemQuad:create("particle/particle_bubbleup.plist")
    self.particle2:setPosition(1034, 0)
    self.particle2:setScale(1.2)
    self.particle2:setPositionType(cc.POSITION_TYPE_GROUPED)
    self._scene.fishBg:addChild(self.particle2, 3)

    --注册事件
    ExternalFun.registerTouchEvent(self,true)
    self.m_TAG = TAG
    self.m_bCanChangeMultple = true
    self.m_touchTime = 0
    --dyj1(FC++)
    self.Themoney = 0
    --dyj2
    self.Music = true
    
    --for k, vs pairs(a) do
    --     CCTestLog(a[v])
   -- end
    
    
    GlobalUserItem.bLKFishSound = GlobalUserItem.bSoundAble 
    --self.Sound = GlobalUserItem.bSoundAble 
    
end


function GameViewLayer:onExit()

    self:unscheduleWaveSea()

    PRELOAD.unloadTextures()
    PRELOAD.removeAllActions()

    PRELOAD.resetData()

    self:StopLoading(true)

    --播放大厅背景音乐
    --ExternalFun.playPlazzBackgroudAudio()

    --重置搜索路径
    local oldPaths = cc.FileUtils:getInstance():getSearchPaths();
    local newPaths = {};
    local a = nil 
    for k,v in pairs(oldPaths) do
        a = nil 
        a = string.match(tostring(v), "/jcby/")
        if tostring(v) ~= tostring(self._searchPath) and nil == a then
            table.insert(newPaths, v);
        end
    end
    cc.FileUtils:getInstance():setSearchPaths(newPaths);
    
    --清理锁表
    GlobalUserItem.dwLockKindID = 0
end

function GameViewLayer:StopLoading( bRemove )
    PRELOAD.StopAnim(bRemove)
end

function GameViewLayer:getDataMgr( )
    return self:getParentNode():getDataMgr()
end

function GameViewLayer:getParentNode( )
    return self._scene;
end

function GameViewLayer:addSerchPaths( )
   --搜索路径
    --local gameList = self._scene._scene:getApp()._gameList;
    --local gameInfo = {};
    --for k,v in pairs(gameList) do
      --    if tonumber(v._KindID) == tonumber(Game_CMD.KIND_ID) then
       --     gameInfo = v;
      --      break;
      --  end
   -- end

    --if nil ~= gameInfo._KindName then
   --     self._searchPath = device.writablePath.."game/" .. gameInfo._Module .. "/res/";
   --     cc.FileUtils:getInstance():addSearchPath(self._searchPath);
   -- end

    --搜索路径
    if device.platform == "windows" then
        cc.FileUtils:getInstance():addSearchPath("game/yule/jcby/res/")
    end
    if device.platform == "ios" then
        cc.FileUtils:getInstance():addSearchPath("game/yule/jcby/res/")
    end
    if device.platform == "android" then
        cc.FileUtils:getInstance():addSearchPath("game/yule/jcby/res/")
    end
end

function GameViewLayer:changeMultipleSchedule( dt )

    local function  update(dt)
       self:multipleUpdate()
    end

    if nil == self.multipleSchedule then
        self.multipleSchedule = scheduler:scheduleScriptFunc(update, dt, false)
    end
    
end

function GameViewLayer:unMultipleSchedule()
    self.m_bCanChangeMultple = true
    if nil ~= self.multipleSchedule then
        scheduler:unscheduleScriptEntry(self.multipleSchedule)
        self.multipleSchedule = nil
    end
end

function GameViewLayer:multipleUpdate()
    self:unMultipleSchedule()  
end

function GameViewLayer:initView(  )

    local bg =  ccui.ImageView:create("background/game_bg_2.jpg")
	bg:setAnchorPoint(cc.p(.5,.5))
    bg:setTag(TAG.tag_bg)
    bg:setName("bg")
	bg:setPosition(cc.p(yl.WIDTH/2,yl.HEIGHT/2))
	self._scene.fishBg:addChild(bg, -1)

    if self._scene.m_nChairID < 3 then
        bg:setRotation(180)
        self.particle1:setRotation(180)
        self.particle1:setPosition(cc.p(300, yl.HEIGHT))
        self.particle2:setRotation(180)
        self.particle2:setPosition(cc.p(1034, yl.HEIGHT))
    end

    local function callBack( sender, eventType)
        self:ButtonEvent(sender,eventType)
    end

    --自动射击
    self.byself = ccui.Button:create("game_res/auto_btn2.png", "game_res/auto_btn1.png")
    self.byself:setPosition(cc.p(1270,400))
    self.byself:setTag(TAG.tag_autoshoot)
    self.byself:addTouchEventListener(callBack)
    self:addChild(self.byself,20)

    --自动锁定
    self.lock = ccui.Button:create("game_res/lock_btn2.png", "game_res/lock_btn1.png")
    self.lock:setPosition(cc.p(1270,265))
    self.lock:setTag(TAG.tag_autolock)
    self.lock:addTouchEventListener(callBack)
    self:addChild(self.lock,20)

--     --加速
--    self.speed = ccui.Button:create("game_res/speed_fast.png", "game_res/speed_fast.png")
--    self.speed:setPosition(cc.p(60,335))
--    self.speed:setTag(TAG.tag_speed)
--    self.speed:addTouchEventListener(callBack)
--    self:addChild(self.speed,20)
 --添加子菜单
    self.upScoreBtn = ccui.Button:create("game_res/upscore.png","game_res/upscore.png")
    self.upScoreBtn:setTag(TAG.tag_downScore)
    self.upScoreBtn:addTouchEventListener(callBack)
    self.upScoreBtn:setPosition(60,400)
    self:addChild(self.upScoreBtn,20)

    self.downScoreBtn = ccui.Button:create("game_res/downscore.png","game_res/downscore.png")
    self.downScoreBtn:setTag(TAG.tag_upScore)
    self.downScoreBtn:addTouchEventListener(callBack)
    self.downScoreBtn:setPosition(60,265) 
    self:addChild(self.downScoreBtn,20)
   
    --菜单
    self.menu = ccui.Button:create("game_res/menu1.png", "game_res/menu2.png")
    self.menu:setTag(TAG.tag_Menu)
    self.menu:setPosition(cc.p(1270,700))
    self.menu:addTouchEventListener(callBack)
    self:addChild(self.menu,20)

    --退出
    self.exit = ccui.Button:create("game_res/exit1.png", "game_res/exit2.png", "")
    self.exit:setPosition(cc.p(60,700))
    self.exit:setTag(TAG.tag_MenuT)
    self.exit:addTouchEventListener(function (sender,eventType)
            if eventType == ccui.TouchEventType.ended then
               self._scene:onQueryExitGame()
               --self._scene:KillGameClock()
               --self._scene:showPopWait()
               --self._scene._gameFrame:onCloseSocket()
               --self._scene._scene:onKeyBack()
            end
        end)
    self:addChild(self.exit,20)

    	
	--控制层
	self.m_controlLayer = g_var(ControlLayer):create(self)
	self:addChild(self.m_controlLayer, 2001)
	self.m_controlLayer:setVisible(false)

    --水波效果
    local render = cc.RenderTexture:create(1334,750)
    render:beginWithClear(0,0,0,0)
    local water = cc.Sprite:createWithSpriteFrameName("water_0.png")
    if water then
        water:setScale(2.5)
        water:setOpacity(200)
        water:setBlendFunc(gl.SRC_ALPHA,gl.ONE)
        water:visit()
        render:endToLua()
        water:addChild(render)
        render:setPosition(667,375) 
        water:setPosition(667,375)
        self._scene.m_fishLayer:addChild(water, 1000)
        local ani1 = cc.Animate:create(cc.AnimationCache:getInstance():getAnimation("WaterAnim"))
        local ani2 = ani1:reverse()
        local action = cc.RepeatForever:create(cc.Sequence:create(ani1,ani2))
        water:runAction(action)
    end

    local callFunc = cc.CallFunc:create(function ()
        self:upScore()
    end)

    local action = cc.Sequence:create(cc.DelayTime:create(1),callFunc)
    self:runAction(action)
end


function GameViewLayer:initUserInfo()
    --用户分数 
    local score = cc.Label:createWithCharMap("game_res/scoreNum.png",16,22,string.byte("0"))
    --print(string.format("------------------用户分数 %d------------", self._scene.m_pUserItem.lScore))
    score:setString(string.format("%.2f", self._scene.m_pUserItem.lScore))
    score:setAnchorPoint(0.5,0.5)
    score:setScale(0.9)
    score:setTag(TAG.tag_gameScore)
    score:setPosition(163, 22)
    --self:addChild(score,22)
end

--更新用户显示
function GameViewLayer:OnUpdateUserStatus(viewId)
	
end


-- 触摸事件
function GameViewLayer:onTouchBegan(touch, event)

    return true
end

function GameViewLayer:onTouchMoved(touch, event)

end

function GameViewLayer:onTouchEnded(touch, event)

end

function GameViewLayer:updateUserScore( score )
    local _score  = self:getChildByTag(TAG.tag_gameScore)
    if nil ~=  _score then
        _score:setString(string.format("%.2f",score))
    end
end

function GameViewLayer:updateMultiple( multiple )
    local _Multiple = self:getChildByTag(TAG.tag_gameMultiple)
    if nil ~=  _Multiple then
        _Multiple:setString(tostring(multiple))
    end

end

function GameViewLayer:updteBackGround(param, delayTime)
    
    local bg = self._scene.fishBg:getChildByName("bg")    --Tag(TAG.tag_bg)

    if bg  then
        local call = cc.CallFunc:create(function()
            bg:removeFromParent(true)
        end)


        local bgfile = string.format("background/game_bg_%d.jpg", param)
        local _bg = cc.Sprite:create(bgfile)
        if not _bg or _bg == nil then
            return
        end
        _bg:setPosition(yl.WIDTH / 2 + yl.WIDTH, yl.HEIGHT / 2)
        self._scene.fishBg:addChild(_bg, -1)
        if self._scene.m_nChairID < 3 then
            _bg:setRotation(180)
        end
        local newCall = cc.CallFunc:create(function()
            _bg:setTag(TAG.tag_bg)
            _bg:setName("bg")
        end)
        _bg:runAction(cc.Sequence:create(cc.MoveTo:create(delayTime, cc.p(yl.WIDTH / 2, yl.HEIGHT / 2)), call, newCall))
    end

    --鱼阵浪潮
    local groupTips = cc.Sprite:create()
    groupTips:initWithSpriteFrameName("wave_1.png")
    local animation = cc.AnimationCache:getInstance():getAnimation("waveAnim")
    if nil ~= animation then
        local action = cc.RepeatForever:create(cc.Animate:create(animation))
        groupTips:runAction(action)
    end
    groupTips:setPosition(cc.p(yl.WIDTH + 180,yl.HEIGHT/2))
    groupTips:setLocalZOrder(1)
    groupTips:setName("wave")
    self._scene.m_fishLayer:addChild(groupTips,30)

    local callFunc1 = cc.CallFunc:create(function()
            self:unscheduleWaveSea()
        end)

    local callFunc2 = cc.CallFunc:create(function()
            groupTips:removeFromParent(true)
        end)

    
    local moveTo1 = cc.MoveTo:create(delayTime, cc.p(180, yl.HEIGHT / 2))
    local delayTime1 = (180 + 200) / (1334 / delayTime)
    local moveTo2 = cc.MoveTo:create(delayTime1, cc.p(-200, yl.HEIGHT / 2))
    groupTips:runAction(cc.Sequence:create(moveTo1, callFunc1, moveTo2, callFunc2))

    self:scheduleWaveSea()
end

function GameViewLayer:scheduleWaveSea()

    local function update()
        if nil ~= self._scene and nil ~= self._scene.m_fishLayer then
            local groupTips = self._scene.m_fishLayer:getChildByName("wave")
            if nil ~= groupTips then
                local recWave = groupTips:getBoundingBox()
                for k,v in pairs(self._scene._dataModel.m_fishList) do
                    local fishPos = cc.p(v:getPositionX(), v:getPositionY())
                    if cc.rectContainsPoint(recWave, fishPos) or not cc.rectContainsPoint(cc.rect(0,0,yl.WIDTH,yl.HEIGHT), fishPos) then
                        v.m_CreatDelayTime = 10000
                    end
                end
                --[[
                for k,v in pairs(self._scene.bullet) do
                    local fishPos = cc.p(v:getPositionX(), v:getPositionY())
                    if cc.rectContainsPoint(recWave, fishPos) then
                        v.ifdie = true
                    end
                end
                ]]
            end
        end
    end

    if nil == self.m_scheduleWaveSea then
        self.m_scheduleWaveSea = scheduler:scheduleScriptFunc(update, 0, false)
    end
end

function GameViewLayer:unscheduleWaveSea()

    if nil ~= self.m_scheduleWaveSea then
        scheduler:unscheduleScriptEntry(self.m_scheduleWaveSea)
        self.m_scheduleWaveSea = nil
    end
end

function GameViewLayer:setAutoShoot(b,target)              
    if b then
        self.byself:loadTextures("game_res/auto_btn4.png", "game_res/auto_btn3.png", "", 0)
    else
        self.byself:loadTextures("game_res/auto_btn2.png", "game_res/auto_btn1.png", "", 0)
    end 
end

function GameViewLayer:setAutoLock(b,target)       
    if b then
        self.lock:loadTextures("game_res/lock_btn4.png", "game_res/lock_btn3.png", "", 0)
    else
        self.lock:loadTextures("game_res/lock_btn2.png", "game_res/lock_btn1.png", "", 0)
        --取消自动射击
        self._scene._dataModel.m_fishIndex = Game_CMD.INT_MAX

        --删除自动锁定图标
        local cannonPos = self._scene.m_nChairID
        cannonPos = CannonSprite.getPos(self._scene._dataModel.m_reversal,cannonPos)

        local cannon = self._scene.m_cannonLayer:getCannoByPos(cannonPos + 1)
        cannon:removeLockTag()
    end              
end

--function GameViewLayer:setAutoSpeed(b,target) 
    --if b then
        --self.speed:loadTextures("game_res/speed_fast.png", "game_res/speed_fast.png", "", 0)
        --self._scene.m_cannonLayer.m_bulletSpeed = 0.8
    --else
        --self.speed:loadTextures("game_res/speed_slow.png", "game_res/speed_slow.png", "", 0)
        --self._scene.m_cannonLayer.m_bulletSpeed = 0.5
    --end    
--end

function GameViewLayer:onBankSuccess( )
    self._scene:dismissPopWait()
    local bank_success = self._scene.bank_success
    self._scene.Copylscore = self._scene.Copylscore + (bank_success.lUserScore - self.Themoney)
    showToast(cc.Director:getInstance():getRunningScene(), bank_success.szDescribrString, 2)
    GlobalUserItem.lUserInsure = bank_success.lUserInsure
    self:refreshScore()
    if true then
        return
    end
    
    if nil == bank_success then
        return
    end

    local addScore = bank_success.lUserScore - GlobalUserItem.lUserScore
    --dyj1
    --GlobalUserItem.lUserScore = self._scene._dataModel.m_secene.lPlayCurScore[1][self._scene.m_nChairID + 1] + addScore
    GlobalUserItem.lUserScore = self._scene.m_pUserItem.lScore + addScore

    self:refreshScore()

end

--银行操作失败
function GameViewLayer:onBankFailure( )

     self._scene:dismissPopWait()
    local bank_fail = self._scene.bank_fail
    if nil == bank_fail then
        return
    end

    showToast(cc.Director:getInstance():getRunningScene(), bank_fail.szDescribeString, 2)
end


  --刷新游戏币
function GameViewLayer:refreshScore( )
    --携带游戏币
    --dyj1
    local str = ExternalFun.numberThousands(self._scene.m_pUserItem.lScore)
    --dyj2
    self.Themoney = self._scene.m_pUserItem.lScore

    if string.len(str) > 19 then
        str = string.sub(str, 1, 19)
    end

    if true == self._scene.m_bLeaveGame then
        --print("----------LeaveGame refreshScore---------------")
        return
    end

    if nil == self.textCurrent then
        return
    end
    self.textCurrent:setString(str)

    --银行存款
    str = ExternalFun.numberThousands(GlobalUserItem.lUserInsure)
    if string.len(str) > 19 then
        str = string.sub(str, 1, 19)
    end

    self.textBank:setString(ExternalFun.numberThousands(GlobalUserItem.lUserInsure))
    self:updateUserScore(self._scene.m_pUserItem.lScore)
end

function GameViewLayer:upScore()
    -- body
    local scoredata=CCmd_Data:create(1)
    scoredata:setcmdinfo(yl.MDM_GF_GAME, Game_CMD.SUB_C_ADDORDOWNSCORE)
    scoredata:pushbool(true)
    --发送失败
    if not  self._scene:sendNetData(scoredata) then
        --print("发送上分消息失败")
    else
        local cannonPos = self._scene.m_nChairID
        cannonPos = CannonSprite.getPos(self._scene._dataModel.m_reversal,cannonPos)
        if self._scene.Copylscore - self._scene.ScoreM >= 0 then
            self._scene.ScoreCount = self._scene.ScoreCount + self._scene.ScoreM
            self._scene.Copylscore = self._scene.Copylscore - self._scene.ScoreM
        else
            self._scene.ScoreCount = self._scene.ScoreCount + self._scene.Copylscore
            self._scene.Copylscore = 0
        end
        self._scene.m_cannonLayer:updateUpScore(self._scene.ScoreCount,cannonPos+1)
    end
end

--子菜单
function GameViewLayer:subMenuEvent( sender , eventType)
    ExternalFun.playClickEffect()
    local tag = sender:getTag()
    if 3 == tag then --帮助
        --添加帮助层
        self.helpLayer = HelpLayer:create()
        self.helpLayer:addTo(self,30)
    elseif 4 == tag then
        if self.Music then 
            sender:loadTextures("game_res/sound0.png", "game_res/sound0.png", "", 0)
            self.Music = false
            AudioEngine.stopMusic()
        else
            AudioEngine.playMusic(cc.FileUtils:getInstance():fullPathForFilename(Game_CMD.Music_Back_1),true)
            self.Music = true
            sender:loadTextures("game_res/sound1.png", "game_res/sound1.png", "", 0)
        end
    elseif 5 == tag then
        if GlobalUserItem.bLKFishSound then 
            sender:loadTextures("game_res/soundeffect1.png", "game_res/soundeffect1.png", "", 0)
            GlobalUserItem.bLKFishSound = false
		    --AudioEngine.setEffectsVolume(0)
        else
            GlobalUserItem.bLKFishSound = true
            --AudioEngine.setEffectsVolume(GlobalUserItem.nSound/100.00)
            sender:loadTextures("game_res/soundeffect0.png", "game_res/soundeffect0.png", "", 0)
        end
    end
end


function GameViewLayer:ButtonEvent( sender , eventType)
    
    if eventType == ccui.TouchEventType.ended then
            ExternalFun.playClickEffect()
            local function getCannonPos()
                 --获取自己炮台
              local cannonPos = self._scene.m_nChairID

              cannonPos = CannonSprite.getPos(self._scene._dataModel.m_reversal,cannonPos)
              
              return cannonPos
            end

            local tag = sender:getTag()
            if tag == TAG.tag_autoshoot then --自动射

              self._scene._dataModel.m_autoshoot = not self._scene._dataModel.m_autoshoot
              self:setAutoShoot(self._scene._dataModel.m_autoshoot,sender)

              local bAuto = false
              if self._scene._dataModel.m_autoshoot or self._scene._dataModel.m_autolock then
                  bAuto = true
              end
              local cannon = self._scene.m_cannonLayer:getCannoByPos(getCannonPos() + 1)
              cannon:setAutoShoot(bAuto)
              cannon:setCanAutoShoot(self._scene._dataModel.m_autoshoot) 
              if self._scene._dataModel.m_autoshoot then
                  cannon:removeLockTag()
              end
                    
            elseif tag == TAG.tag_autolock then --自动锁定

              self._scene._dataModel.m_autolock = not self._scene._dataModel.m_autolock
              self:setAutoLock(self._scene._dataModel.m_autolock,sender) 
              
              local bAuto = false
              if self._scene._dataModel.m_autoshoot or self._scene._dataModel.m_autolock then
                  bAuto = true
              end
              local cannon = self._scene.m_cannonLayer:getCannoByPos(getCannonPos() + 1)
              cannon:setAutoShoot(bAuto)

              if self._scene._dataModel.m_autoshoot then
                  cannon:removeLockTag()
              end
           --elseif tag == TAG.tag_speed then --加速

              --self._scene._dataModel.m_speed = not self._scene._dataModel.m_speed
              --self:setAutoSpeed(self._scene._dataModel.m_speed,sender) 
            elseif tag == TAG.tag_upScore then --银行
                local currTime = currentTime()
                local aaa  = currTime - self._scene.FirstTime
                if eventType == ccui.TouchEventType.ended and aaa > 50 then
                    self.m_touchTime = currTime
                    self._scene.FirstTime = aaa
                    local scoredata=CCmd_Data:create(1)
                    scoredata:setcmdinfo(yl.MDM_GF_GAME, Game_CMD.SUB_C_ADDORDOWNSCORE)
                    scoredata:pushbool(false)
                    --发送失败
                    if not  self._scene:sendNetData(scoredata) then
                        --print("发送上分消息失败")
                    else
                    local cannonPos = self._scene.m_nChairID
                            cannonPos = CannonSprite.getPos(self._scene._dataModel.m_reversal,cannonPos)
                    if self._scene.ScoreCount > 0 then
                        self._scene.Copylscore = self._scene.Copylscore + self._scene.ScoreCount
                        self._scene.ScoreCount = 0
                    end
                        self._scene.m_cannonLayer:updateUpScore(self._scene.ScoreCount,cannonPos+1)
                    end
                end
            elseif tag == TAG.tag_downScore then
                local currTime = currentTime()
                local aaa  = currTime - self._scene.FirstTime
                if eventType == ccui.TouchEventType.ended and aaa > 50 then
                    self.m_touchTime = currTime
                    self._scene.FirstTime = aaa
                    local scoredata=CCmd_Data:create(1)
                    scoredata:setcmdinfo(yl.MDM_GF_GAME, Game_CMD.SUB_C_ADDORDOWNSCORE)
                    scoredata:pushbool(true)
                    --发送失败
                    if not  self._scene:sendNetData(scoredata) then
                        --print("发送上分消息失败")
                    else
                    local cannonPos = self._scene.m_nChairID
                    cannonPos = CannonSprite.getPos(self._scene._dataModel.m_reversal,cannonPos)
                    if self._scene.Copylscore - self._scene.ScoreM >= 0 then
                        self._scene.ScoreCount = self._scene.ScoreCount + self._scene.ScoreM
                        self._scene.Copylscore = self._scene.Copylscore - self._scene.ScoreM
                    else
                        self._scene.ScoreCount = self._scene.ScoreCount + self._scene.Copylscore
                        self._scene.Copylscore = 0
                    end
                        self._scene.m_cannonLayer:updateUpScore(self._scene.ScoreCount,cannonPos+1)
                    end
                end     
            elseif tag == TAG.tag_Menu then --菜单
                self:showMenu()
                end 
    end
end

function GameViewLayer:showMenu()
    -- body
    local MenuBG = ccui.ImageView:create()
    MenuBG:setContentSize(cc.size(yl.WIDTH, yl.HEIGHT))
    MenuBG:setScale9Enabled(true)
    MenuBG:setPosition(yl.WIDTH/2, yl.HEIGHT/2)
    MenuBG:setTouchEnabled(true)
    self:addChild(MenuBG,21)
    MenuBG:addTouchEventListener(function (sender,eventType)
        if eventType == ccui.TouchEventType.ended then
            MenuBG:removeFromParent()
        end
    end)


    --添加菜单背景
    local bg = ccui.ImageView:create("game_res/im_bt_frame.png")
    bg:setScale9Enabled(true)
    bg:setContentSize(cc.size(bg:getContentSize().width, 380))
    bg:setAnchorPoint(1.0,0.0)

    bg:setPosition(yl.WIDTH - 5, 700)
    MenuBG:addChild(bg)

    bg:runAction(cc.MoveTo:create(0.2,cc.p(yl.WIDTH-5,320)))

    local function subCallBack( sender , eventType )
        if eventType == ccui.TouchEventType.ended  then
            --sender:getParent():getParent():removeFromParent()
            self:subMenuEvent(sender,eventType)
        end
    end

    
    local help = ccui.Button:create("game_res/help.png","game_res/help.png")
    help:setTag(3)
    help:addTouchEventListener(subCallBack)
    help:setPosition(bg:getContentSize().width/2, bg:getContentSize().height - 73)
    bg:addChild(help)

    local sound = ccui.Button:create("game_res/sound1.png", "game_res/sound1.png")
    sound:setTag(4)
    sound:addTouchEventListener(subCallBack)
    sound:setPosition(bg:getContentSize().width/2, bg:getContentSize().height - 173)
    bg:addChild(sound)

    local soundEffect = nil
    if GlobalUserItem.bLKFishSound then
        soundEffect = ccui.Button:create("game_res/soundeffect0.png", "game_res/soundeffect0.png")
    else
        soundEffect = ccui.Button:create("game_res/soundeffect1.png", "game_res/soundeffect1.png")
    end
    soundEffect:setTag(5)
    soundEffect:addTouchEventListener(subCallBack)
    soundEffect:setPosition(bg:getContentSize().width/2, bg:getContentSize().height - 273)
    bg:addChild(soundEffect)
end

function GameViewLayer:Showtips( tips )
  
    local lb =  cc.Label:createWithTTF(tips, "base/fonts/round_body.ttf", 20)
    local bg = ccui.ImageView:create("game_res/clew_box.png")
    lb:setTextColor(cc.YELLOW)
    bg:setScale9Enabled(true)
    bg:setContentSize(cc.size(lb:getContentSize().width + 60  , 40))
    bg:setScale(0.1)
    lb:setPosition(bg:getContentSize().width/2, 20)
    bg:addChild(lb)

    self:ShowTipsForBg(bg)

end

function GameViewLayer:Showtips1( tips, tips_score )
  
    local lb = display.newSprite(tips_score)
    local lb1 = display.newSprite(tips)
    
    local bg = display.newSprite("tips/tips_bg.png")
    local panel = ccui.Layout:create()
    panel:setAnchorPoint(0.5, 0.5)
    panel:setContentSize(500, 200)
    panel:addChild(bg)
    bg:setPosition(panel:getContentSize().width / 2, 70)
    bg:setTag(1)
    panel:addChild(lb)
    lb:setPosition(panel:getContentSize().width / 2, 63)
    lb:setTag(2)
    panel:addChild(lb1)
    lb1:setPosition(panel:getContentSize().width / 2, 145)
    lb1:setTag(3)
    self:ShowTipsForBg(panel)

end

function GameViewLayer:getCoinPos(pos, num)
    pos = cc.p(pos.x + random(-5,5), pos.y + random(-8,8))
    if num == 1 then
        return pos
    elseif num == 2 then
        return cc.p(pos.x - 90, pos.y)
    elseif num == 3 then
        return cc.p(pos.x + 90, pos.y)
    elseif num == 4 then
        return cc.p(pos.x - 180, pos.y)
    elseif num == 5 then
        return cc.p(pos.x + 180, pos.y)
    end
end


--dyj1 (保留)
function GameViewLayer:ShowCoin( score,wChairID,pos,fishtype )

  local nMyNum = self.m_pUserItem.wChairID >= 1
  local nPlayerNum = wChairID >= 1
  self._scene._dataModel:playEffect(Game_CMD.Coinfly)
  
  local nPos = wChairID
--获取炮台
  nPos = CannonSprite.getPos(self._scene._dataModel.m_reversal,nPos)

   local cannon = self._scene.m_cannonLayer:getCannoByPos(nPos + 1)

   if nil == cannon then
      return
   end

    local cannonPos = cc.p(cannon:getPositionX(),cannon:getPositionY())

   local anim = cc.AnimationCache:getInstance():getAnimation("GoldAnim")
   local coinNum = 1
   local frameName = "gold_coin_0.png"
   local distant = 62

   --金币类型
    if score ~= nil and  score == 100 then
        coinNum = 1
    elseif  score ~= nil and score >= 200 and score <= 1000 then
        coinNum = 2
    elseif  score ~= nil and score >= 1100 and score <= 10000 then
        coinNum = 3
    elseif  score ~= nil and score >= 11000 and score <= 100000 then
        coinNum = 4
    elseif  score ~= nil and score > 100000 then
        coinNum = 5
    end

    if nil ~= anim then
        local action = cc.RepeatForever:create(cc.Animate:create(anim))
    
        local num = cc.LabelAtlas:_create(ExternalFun.formatScoreFloatText(score),"game_res/scoreNum1.png",39,54,string.byte("."))
        num:setAnchorPoint(0.5,0.5)
        num:setPosition(pos)
        self:addChild(num, 21)

        num:runAction(cc.Sequence:create(cc.DelayTime:create(1.0), cc.CallFunc:create(function()
            num:removeFromParent(true)
        end))) --cc.RemoveSelf:create(true)))

        for i=1,coinNum do
            local coin = cc.Sprite:createWithSpriteFrameName(frameName)
            coin:runAction(action:clone())
            local coinPos = self:getCoinPos(pos, i)
            coin:setPosition(coinPos)
            self:addChild(coin, 20)
            local tempTime = math.sqrt((coinPos.x - cannonPos.x) * (coinPos.x - cannonPos.x) + (coinPos.y - cannonPos.y) * (coinPos.y - cannonPos.y)) * 0.003 + random(-10,10) * 0.01
            if tempTime <= 0 then
                tempTime = 0.3
            end
            coin:runAction(cc.Sequence:create(cc.MoveTo:create(tempTime, cannonPos), cc.CallFunc:create(function()
                coin:removeFromParent(true)
            end)))   --cc.RemoveSelf:create(true)))
        end

    end


    local angle = 70.0
    local time = 0.12
    local moveY = 30.0

    if  fishtype ~= nil and fishtype >= Game_CMD.FishType.FishType_JianYu and fishtype <= Game_CMD.FishType.FishType_LiKui then
        self._scene._dataModel:playEffect(Game_CMD.bingo)
        local reward = self:getChildByTag(TAG.tag_GoldCycle + wChairID )
        if nil == reward then
            local reward = cc.Sprite:create()
            reward:setTag(TAG.tag_GoldCycle + wChairID)
            reward:initWithSpriteFrameName("Reward_Box_0.png")
            local pos = wChairID
            pos = CannonSprite.getPos(self._scene._dataModel.m_reversal, pos)
            reward:setPosition(rewardPos[pos + 1] or cc.p(667,375))
            self:addChild(reward,6)
            local animation = cc.AnimationCache:getInstance():getAnimation("rewardCircleAnim")
            if nil ~= animation then
                local action = cc.RepeatForever:create(cc.Animate:create(animation))
                reward:runAction(action)
                reward:runAction(cc.Sequence:create(cc.DelayTime:create(time*16),cc.CallFunc:create(function()
                    reward:removeFromParent()
                end)))--cc.RemoveSelf:create(true)))
            end

            local goldTxt = self:getChildByTag(TAG.tag_GoldCycleTxt + wChairID)
            if goldTxt == nil then
    
                goldTxt = cc.LabelAtlas:_create(ExternalFun.formatScoreFloatText(score),"game_res/scoreNum1.png",39,54,string.byte("."))
                goldTxt:setAnchorPoint(0.5,0.5)
                goldTxt.lScore = score
                goldTxt:setPosition(rewardPos[pos + 1] or cc.p(667,375))      --(pos.x, pos.y)          
                self:addChild(goldTxt,6)

                local action = cc.Sequence:create(cc.RotateTo:create(time*2,angle),cc.RotateTo:create(time*4,-angle),cc.RotateTo:create(time*2,0))
                local action0 = action:clone()
                local call = cc.CallFunc:create(function()  
                    goldTxt:removeFromParent(true)
                    goldTxt = nil
                end)

                goldTxt:runAction(cc.Sequence:create(action, action0, call))
            end
        end
    end

    if  fishtype~=nil and fishtype ~= Game_CMD.FishType_BaoXiang then

    local bannerText = cc.LabelAtlas:_create(ExternalFun.formatScoreFloatText(score),"game_res/mutipleNum.png",12,16,string.byte("."))
    bannerText:setTag(TAG.tag_GoldsText)
    bannerText:setAnchorPoint(cc.p(0.5,0.5))

    if cannon.m_nBannerColor == 0 then
        cannon.m_nBannerColor = 1
    else
        cannon.m_nBannerColor = 0
    end
 end
end
--dyj2

function GameViewLayer:ShowAwardTip(data)


 local fishName = {"小黄刺鱼","小草鱼","热带黄鱼","大眼金鱼","热带紫鱼","小丑鱼","河豚鱼","狮头鱼","灯笼鱼","海龟","神仙鱼","蝴蝶鱼","铃铛鱼","剑鱼","魔鬼鱼","大白鲨","大金鲨",
    "巨型黄金鲨","金龙","绿色千年龟摇钱树","银色千年龟摇钱树","金色千年龟摇钱树","漂流瓶","屠龙刀","火山","宝箱","元宝"}

  local labelList = {}

  local tipStr  = ""
  local tipStr1 = ""
  local tipStr2 = ""

  if data.nFishMultiple >= 50 then
    if data.nScoreType == Game_CMD.SupplyType.EST_Cold then
       tipStr = "捕中了"..fishName[data.nFishType+1]..",获得"
    elseif data.nScoreType == Game_CMD.SupplyType.EST_Laser then
      
       tipStr = "使用激光,获得"
    end

  tipStr1 = string.format("%d倍 %d分数",data.nFishMultiple,data.lFishScore)
  if data.nFishMultiple > 500 then
     tipStr2 = "超神了!!!"
  elseif data.nFishMultiple == 19 then
       tipStr2 = "运气爆表!!!"   
  else
      tipStr2 = "实力超群!!!"     
  end

  local name = data.szPlayName
  local tableStr = nil
  if data.wTableID == self._scene.m_nTableID  then 
    tableStr = "本桌玩家"

  else
       tableStr = string.format("第%d桌玩家",data.wTableID+1)

  end

  local lb1 =  cc.Label:createWithTTF(tableStr, "base/fonts/round_body.ttf", 20)
  lb1:setTextColor(cc.YELLOW)
  lb1:setAnchorPoint(0,0.5)
  table.insert(labelList, lb1)
 

  local lb2 =  cc.Label:createWithTTF(name, "base/fonts/round_body.ttf", 20)
  lb2:setTextColor(cc.RED)
  lb2:setAnchorPoint(0,0.5)
  table.insert(labelList, lb2)

  local lb3 =  cc.Label:createWithTTF(tipStr, "base/fonts/round_body.ttf", 20)
  lb3:setTextColor(cc.YELLOW)
  lb3:setAnchorPoint(0,0.5)
  table.insert(labelList, lb3)

  local lb4 =  cc.Label:createWithTTF(tipStr1, "base/fonts/round_body.ttf", 20)
  lb4:setTextColor(cc.RED)
  lb4:setAnchorPoint(0,0.5)
  table.insert(labelList, lb4)

  local lb5 =  cc.Label:createWithTTF(tipStr2, "base/fonts/round_body.ttf", 20)
  lb5:setTextColor(cc.YELLOW)
  lb5:setAnchorPoint(0,0.5)
  table.insert(labelList, lb5)

  else

    local lb1 =  cc.Label:createWithTTF("恭喜你捕中了补给箱,获得", "base/fonts/round_body.ttf", 20)
    lb1:setTextColor(cc.YELLOW)
    lb1:setAnchorPoint(0,0.5)

    local lb1 =  cc.Label:createWithTTF(string.format("%d倍 %d分数 !", data.nFishMultiple,data.lFishScore), "base/fonts/round_body.ttf", 20)
    lb1:setTextColor(cc.RED)
    lb1:setAnchorPoint(0,0.5)

    table.insert(labelList, lb1)
    table.insert(labelList, lb2)

  end



  local length = 60
  for i=1,#labelList do
    local lb = labelList[i]
    lb:setPosition(length - 30 , 20)
    length =  length + lb:getContentSize().width + 5 
  end


   local bg = ccui.ImageView:create("game_res/clew_box.png")
    bg:setScale9Enabled(true)
  
    bg:setContentSize(length,40)
    bg:setScale(0.1)

    for i=1,#labelList do
      local lb = labelList[i]
      bg:addChild(lb)
    end

    self:ShowTipsForBg(bg)
    labelList = {}
end


function GameViewLayer:ShowTipsForBg( bg )

  local infoCount = #self._scene.m_infoList
  local sublist = {}

  while infoCount >= 3 do

    local node = self._scene.m_infoList[1]
    table.remove(self._scene.m_infoList,1)
    node:removeFromParent(true)

    for i=1,#self._scene.m_infoList do
      local bg1 = self._scene.m_infoList[i]
      bg1:runAction(cc.FadeTo:create(0.2, 0))
    end

    infoCount = #self._scene.m_infoList
  end

  bg:setPosition(yl.WIDTH/2, 375)
  self:addChild(bg,2000)
  table.insert(self._scene.m_infoList, bg)

  local call = cc.CallFunc:create(function()
    bg:removeAllChildren()
    bg:removeFromParent(true)
    for i=1,#self._scene.m_infoList do
      local _bg = self._scene.m_infoList[i]
      if bg == _bg then
        table.remove(self._scene.m_infoList,i)
        break
      end
    end

  end)
  local c1 = bg:getChildByTag(1)
  local c2 = bg:getChildByTag(2)
  local c3 = bg:getChildByTag(3)
  if c1 then
    c1:runAction(cc.Sequence:create(cc.DelayTime:create(3), cc.FadeTo:create(2, 0)))
  end
  if c2 then
    c2:runAction(cc.Sequence:create(cc.DelayTime:create(3), cc.FadeTo:create(2, 0)))
  end
  if c3 then
    c3:runAction(cc.Sequence:create(cc.DelayTime:create(3), cc.FadeTo:create(2, 0)))
  end
  bg:runAction(cc.Sequence:create(cc.DelayTime:create(3), cc.FadeTo:create(2, 0),call)) 
end

--打中宝箱
function GameViewLayer:catchBox(wChairID, index)
    index = index or 0
    index = index + 1
    local pos = wChairID
    pos = CannonSprite.getPos(self._scene._dataModel.m_reversal, pos)

    local spZhuan = cc.Sprite:create("tips/ZhuanPan.png")
	spZhuan:addTo(self, 20)
    local spZhuanZhen = cc.Sprite:create("tips/ZhuanPanZhen.png")
	spZhuanZhen:addTo(self, 20)

    if wChairID ==  self.m_pUserItem.wChairID then
        spZhuan:setPosition(cc.p(yl.WIDTH/2,yl.HEIGHT/2))
        spZhuanZhen:setPosition(cc.p(yl.WIDTH/2,yl.HEIGHT/2))
        spZhuan:setScale(1.8)
        spZhuanZhen:setScale(1.8)
    else
	    spZhuan:setPosition(rewardPos[pos + 1])
	    spZhuanZhen:setPosition(rewardPos[pos + 1])
    end
	



    local angle = 45 / 2 * (index * 2 - 1) + 360 * 5
	local act = cc.RotateTo:create(5, angle)
	local easeRotate = cc.EaseCircleActionOut:create(act)
	local call1 = cc.CallFunc:create(function()
		local sp = display.newSprite(string.format("tips/tips_box_%d.png", index))
        if pos ==  self.m_pUserItem.wChairID then
            sp:setPosition(cc.p(yl.WIDTH/2,yl.HEIGHT/2))
            sp:setScale(1.8)
        else
			sp:setPosition(rewardPos[pos + 1])
        end
			sp:addTo(self, 20)
			sp:setName("tips_reward")
	end)
	local call2 = cc.CallFunc:create(function() 
		local sp = self:getChildByName("tips_reward")
		if sp ~= nil then
			sp:removeFromParent(true)
		end
        spZhuan:removeFromParent(true)
        spZhuanZhen:removeFromParent(true) 
	end)

	spZhuan:runAction(cc.Sequence:create(easeRotate, call1, cc.DelayTime:create(2.5), call2))

end
--打中宝箱
function GameViewLayer:setControlCfg(dataBuffer)
    local data = ExternalFun.read_netdata(Game_CMD.CMD_S_CONTROL, dataBuffer)

    self.m_controlLayer.total_return_rate = data.total_return_rate_
	self.m_controlLayer.revenue_score = data.revenue_score
    self.m_controlLayer.stock_score0 = data.stock_score0
	self.m_controlLayer.stock_score1 = data.stock_score1
	self.m_controlLayer.total_probability = data.zhengtigailv;
	self.m_controlLayer.easy = data.easy
	self.m_controlLayer.hard = data.hard

    self.m_controlLayer:UpdateEdit()
end

return GameViewLayer
