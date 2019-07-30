local GameModel = appdf.req(appdf.CLIENT_SRC .. "gamemodel.GameModel")
local GameLayer = class("GameLayer", GameModel)


require("cocos.init")
local module_pre = "game.yule.jcby.src"
local ExternalFun = require(appdf.EXTERNAL_SRC .. "ExternalFun")
local QueryDialog   = require("app.views.layer.other.QueryDialog")
local cmd = module_pre .. ".models.CMD_LKPYGame"
local g_var = ExternalFun.req_var
local GameFrame = appdf.req(module_pre ..  ".models.GameFrame")
local game_cmd = appdf.HEADER_SRC .. "CMD_GameServer"
local GameViewLayer = appdf.req(module_pre .. ".views.layer.GameViewLayer")
local Fish = appdf.req(module_pre .. ".views.layer.Fish1")
local CannonLayer = appdf.req(module_pre .. ".views.layer.CannonLayer1")
local CannonSprite = require(module_pre .. ".views.layer.Cannon1")
local PRELOAD = require(module_pre .. ".views.layer.PreLoading")
local scheduler = cc.Director:getInstance():getScheduler()
local Game_CMD = appdf.req(module_pre .. ".models.CMD_LKPYGame")

local TAG_ENUM =
{
    Tag_Fish = 200
}

local delayLeaveTime = 0.3

local exit_timeOut = 3
local SYNC_SECOND = 1

local winsize = cc.Director:getInstance():getVisibleSize()

local m_WScale = winsize.width / 1136 / 100                    -- 宽度比例
local m_HScale = winsize.height / 640 / 100                    -- 高度比例
local m_AScale = 0.01                                          -- 角度比例

local sinf = math.sin
local cosf = math.cos

function GameLayer:ctor(frameEngine, scene)
    --ExternalFun.registerNodeEvent(self)
 
    -- 创建物理世界
    cc.Director:getInstance():getRunningScene():initWithPhysics()
    cc.Director:getInstance():getRunningScene():getPhysicsWorld():setGravity(cc.p(0, -100))

    -- 鱼层
    self.fishBg = cc.Layer:create()
    self.m_fishLayer = cc.Layer:create()
    
    self.m_infoList = { }
    self.m_scheduleUpdate = nil
    self.m_secondCountSchedule = nil
    self._scene = scene
    self.m_bScene = false
    self.m_bSynchronous = false
    self.m_nSecondCount = 60
    self.m_catchFishCount = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
    self.m_fishLimitCount = { 10, 10, 8, 8, 7, 6, 6, 6, 6, 6, 4, 4, 4, 3, 3, 3, 2, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 }
    self.m_fishCurCount   = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
    self.m_fishTotalCount = 0
    --self._gameFrame = frameEngine
    --self._gameFrame:setKindInfo(cmd.KIND_ID, cmd.VERSION)
    
    self._dataModel = GameFrame:create()
    GameLayer.super.ctor(self, frameEngine, scene)
    GameLayer.super.OnInitGameEngine(self)

    self._roomRule = self._gameFrame._dwServerRule

    self.bulletLimitCount = 20
 
    self._gameView:addChild(self.fishBg, 4)
    self._gameView:addChild(self.m_fishLayer, 5)
 
    self.CurrShoot = { { } }
    self.m_pUserItem = self._gameFrame:GetMeUserItem()
    self.m_nTableID = self.m_pUserItem.wTableID
    self.m_nChairID = self.m_pUserItem.wChairID
    self.m_bLeaveGame = false

    self:setReversal()
    self:setPath()
    -- dyj1

    self.bullet = { }
    self.diebullet = { }
    -- 1;子弹 2;子弹偏移角度分解x,y距离 3;子弹速度speedx 4;子弹速度speedy 5;子弹角度
    self.FishMove = { }
    self.ifcopy = true
    self.power = 0
    self.ReFish = nil
    self.Tcount = 0
    self.FirstTime = 0
    self.ScoreM = 0
    self.ScoreCount = 0
    self.Copylscore = self.m_pUserItem.lScore
    -- 拷贝一个用户分数用来进行运算显示
    self.BulletSum = 0
    -- 子弹总花费
    self.FishSum = 0
    -- 捕获鱼所得
    self.morefish = { }
    -- 多余的鱼
    self.sum = 0
    self.iffishcomb = false
    self.ifFire = true
    
    self.specialFish = {}

    self.bFishStop = false
    self.bMinConnonMultiple = 0.1
    -- dyj2

    if self._dataModel.m_reversal then
        -- 物理世界旋转180
        self.fishBg:setRotation(180)
        self.m_fishLayer:setRotation(180)
    end

    -- 自己信息
    self._gameView:initUserInfo()

    -- 创建定时器
    self:onCreateSchedule()

    -- 60秒未开炮倒计时
    self:createSecoundSchedule()

    -- 注册事件
    ExternalFun.registerTouchEvent(self, true)

    self.s = 1


    -- 注册通知
    self:addEvent()

    self.m_laserTime = 30
    -- 打到激光自动开炮
    -- 打开调试模式
    -- cc.Director:getInstance():getRunningScene():getPhysicsWorld():setDebugDrawMask(cc.PhysicsWorld.DEBUGDRAW_ALL)

end

--创建场景
function GameLayer:CreateView()
    return GameViewLayer:create(self)
        :addTo(self)
end

function GameLayer:getParentNode( )
    return self._scene
end

function GameLayer:getFrame( )
    return self._gameFrame
end

-- 获取gamekind
function GameLayer:getGameKind()
    return Game_CMD.KIND_ID
end

function GameLayer:addEvent()


    -- 通知监听
    local function eventListener(event)


        -- 初始化界面
        self._gameView:initView()

        -- 添加炮台层
        self.m_cannonLayer = CannonLayer:create(self)
        self._gameView:addChild(self.m_cannonLayer, 8)

        -- 查询本桌其他用户
        self._gameFrame:QueryUserInfo(self.m_nTableID, yl.INVALID_CHAIR)
        -- self.m_cannonLayer:showPos()

        -- 播放背景音乐
        AudioEngine.playMusic(cc.FileUtils:getInstance():fullPathForFilename(Game_CMD.Music_Back_1), true)

        if not GlobalUserItem.bVoiceAble then

            AudioEngine.setMusicVolume(0)
            AudioEngine.pauseMusic()
            -- 暂停音乐
        end
        self:setUserMultiple()
    end

    local listener = cc.EventListenerCustom:create(Game_CMD.Event_LoadingFinish, eventListener)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithFixedPriority(listener, 1)

end

-- 判断自己位置 是否需翻转
function GameLayer:setReversal()

    if self.m_pUserItem then
        if self.m_pUserItem.wChairID < 2 then
            self._dataModel.m_reversal = true
        end
    end

    return self._dataModel.m_reversal

end

-- 添加碰撞
function GameLayer:addContact()

    local function onContactBegin(contact)

        local a = contact:getShapeA():getBody():getNode()
        local b = contact:getShapeB():getBody():getNode()

        local bullet

        if a and b then
            if a:getT() == 2 then
                bullet = a
            end

            if b:getT() == 2 then
                bullet = b
            end
        end

        local fish

        if a and b then
            if a:getT() == 1 then
                fish = a
            end

            if b:getT() == 1 then
                fish = b
            end
        end

        -- dyj1          碰撞出网清除子弹以及附带数据
        if nil ~= bullet then
            if nil ~= fish then
                fish:runAction(cc.Sequence:create(cc.TintTo:create(0.2, 255, 0, 0), cc.TintTo:create(0.2, 255, 255, 255)))
                self:AsendCathcFish(bullet, fish)
                bullet:fallingNet(fish)
                bullet.ifdie = true
            end
        end
        -- dyj2
        return true
    end

    local dispatcher = self:getEventDispatcher()
    self.contactListener = cc.EventListenerPhysicsContact:create()
    self.contactListener:registerScriptHandler(onContactBegin, cc.Handler.EVENT_PHYSICS_CONTACT_BEGIN)
    dispatcher:addEventListenerWithSceneGraphPriority(self.contactListener, self)

end

function GameLayer:AsendCathcFish(bullet, fish)

    if bullet:getTag() ~= Game_CMD.Tag_Laser then
        if bullet.m_cannon ~= nil and bullet.m_cannon.m_ChairID == nil then
            return
        end
    end

    local cmddata = CCmd_Data:create(18)
    cmddata:setcmdinfo(yl.MDM_GF_GAME, Game_CMD.SUB_C_CATCH_FISH);
    cmddata:pushword(bullet.chairId)
    cmddata:pushint(fish.m_data.fish_id)
    cmddata:pushint(bullet.m_Type)
    cmddata:pushint(bullet.m_index)
    cmddata:pushfloat(bullet.m_nScore)


    -- 发送失败
    if not self._gameFrame:sendSocketData(cmddata) then
        self._gameFrame._callBack(-1, "发送开火息失败")
    end

end
function GameLayer:setPath()
    if self.m_nChairID + 1 > 3 then
        -- 限制条件4
        Game_CMD.PathIndex[2][2][3] = 330

        Game_CMD.PathIndex[3][2][3] = 90
        Game_CMD.PathIndex[3][3][3] = 170
        Game_CMD.PathIndex[3][3][5] = 500

        Game_CMD.PathIndex[6][2][3] = 330
        Game_CMD.PathIndex[6][3][3] = 185
        Game_CMD.PathIndex[6][3][5] = 500

        Game_CMD.PathIndex[7][1][1] = 1550
        Game_CMD.PathIndex[7][1][2] = 400
        Game_CMD.PathIndex[7][1][3] = 460
        Game_CMD.PathIndex[7][1][5] = 10
        Game_CMD.PathIndex[7][2][3] = 280
        Game_CMD.PathIndex[7][3][3] = 230
        Game_CMD.PathIndex[7][4][3] = 310
        Game_CMD.PathIndex[7][5][3] = 250

        Game_CMD.PathIndex[9][1][3] = 440
        Game_CMD.PathIndex[9][2][3] = 440
        Game_CMD.PathIndex[9][3][3] = 490
        Game_CMD.PathIndex[9][4][3] = 410
        Game_CMD.PathIndex[9][5][3] = 470

        Game_CMD.PathIndex[11][2][3] = 455
        Game_CMD.PathIndex[11][3][3] = 180

        Game_CMD.PathIndex[12][1][2] = 240
        Game_CMD.PathIndex[12][1][3] = 460
        Game_CMD.PathIndex[12][1][5] = 10
        Game_CMD.PathIndex[12][2][3] = 290
        Game_CMD.PathIndex[12][2][5] = 180
        Game_CMD.PathIndex[12][2][6] = 0.01
        Game_CMD.PathIndex[12][3][3] = 230
        Game_CMD.PathIndex[12][3][5] = 120
        Game_CMD.PathIndex[12][3][6] = -0.02
        Game_CMD.PathIndex[12][4][3] = 310
        Game_CMD.PathIndex[12][4][5] = 210
        Game_CMD.PathIndex[12][5][3] = 250

        Game_CMD.PathIndex[13][2][3] = 310

        Game_CMD.PathIndex[19][2][3] = 455

        Game_CMD.PathIndex[20][2][3] = 275
        Game_CMD.PathIndex[20][3][3] = 235

        Game_CMD.PathIndex[23][1][5] = 150
        Game_CMD.PathIndex[23][2][3] = 310
        Game_CMD.PathIndex[23][2][5] = 40
        Game_CMD.PathIndex[23][3][5] = 5
        Game_CMD.PathIndex[23][3][7] = 1
        Game_CMD.PathIndex[23][4][3] = 90
        Game_CMD.PathIndex[23][4][5] = 1000

        Game_CMD.PathIndex[24][2][3] = 440

        Game_CMD.PathIndex[28][1][3] = 430
        Game_CMD.PathIndex[28][2][3] = 440
        Game_CMD.PathIndex[28][3][3] = 490
        Game_CMD.PathIndex[28][4][3] = 410
        Game_CMD.PathIndex[28][5][3] = 470

        Game_CMD.PathIndex[32][2][3] = 270
        Game_CMD.PathIndex[32][3][3] = 90

        Game_CMD.PathIndex[34][2][3] = 120

        Game_CMD.PathIndex[35][2][3] = 290
        Game_CMD.PathIndex[35][2][5] = 60
        Game_CMD.PathIndex[35][3][3] = 250
        Game_CMD.PathIndex[35][3][5] = 10
        Game_CMD.PathIndex[35][4][3] = 80

    else
        -- 限制条件8
        Game_CMD.PathIndex[2][2][3] = 150

        Game_CMD.PathIndex[3][2][3] = 270
        Game_CMD.PathIndex[3][3][3] = 300
        Game_CMD.PathIndex[3][3][5] = 20

        Game_CMD.PathIndex[6][2][3] = 120
        Game_CMD.PathIndex[6][3][3] = 30
        Game_CMD.PathIndex[6][3][5] = 10

        Game_CMD.PathIndex[7][1][1] = 1350
        Game_CMD.PathIndex[7][1][2] = 280
        Game_CMD.PathIndex[7][1][3] = 280
        Game_CMD.PathIndex[7][1][5] = 50
        Game_CMD.PathIndex[7][2][3] = 100
        Game_CMD.PathIndex[7][3][3] = 50
        Game_CMD.PathIndex[7][4][3] = 130
        Game_CMD.PathIndex[7][5][3] = 70

        Game_CMD.PathIndex[9][1][3] = 260
        Game_CMD.PathIndex[9][2][3] = 260
        Game_CMD.PathIndex[9][3][3] = 310
        Game_CMD.PathIndex[9][4][3] = 230
        Game_CMD.PathIndex[9][5][3] = 290

        Game_CMD.PathIndex[11][2][3] = 275
        Game_CMD.PathIndex[11][3][3] = 360

        Game_CMD.PathIndex[12][1][2] = 180
        Game_CMD.PathIndex[12][1][3] = 290
        Game_CMD.PathIndex[12][1][5] = 50
        Game_CMD.PathIndex[12][2][3] = 110
        Game_CMD.PathIndex[12][2][5] = 130
        Game_CMD.PathIndex[12][2][6] = 0.02
        Game_CMD.PathIndex[12][3][3] = 50
        Game_CMD.PathIndex[12][3][5] = 80
        Game_CMD.PathIndex[12][3][6] = -0.03
        Game_CMD.PathIndex[12][4][3] = 130
        Game_CMD.PathIndex[12][4][5] = 120
        Game_CMD.PathIndex[12][5][3] = 80

        Game_CMD.PathIndex[13][2][3] = 130

        Game_CMD.PathIndex[19][2][3] = 275

        Game_CMD.PathIndex[20][2][3] = 95
        Game_CMD.PathIndex[20][3][3] = 65

        Game_CMD.PathIndex[23][1][5] = 200
        Game_CMD.PathIndex[23][2][3] = 70
        Game_CMD.PathIndex[23][2][5] = 20
        Game_CMD.PathIndex[23][3][5] = 30
        Game_CMD.PathIndex[23][3][7] = 0
        Game_CMD.PathIndex[23][4][3] = 280
        Game_CMD.PathIndex[23][4][5] = 420

        Game_CMD.PathIndex[24][2][3] = 260

        Game_CMD.PathIndex[28][1][3] = 250
        Game_CMD.PathIndex[28][2][3] = 260
        Game_CMD.PathIndex[28][3][3] = 310
        Game_CMD.PathIndex[28][4][3] = 230
        Game_CMD.PathIndex[28][5][3] = 290

        Game_CMD.PathIndex[32][2][3] = 90
        Game_CMD.PathIndex[32][3][3] = 270

        Game_CMD.PathIndex[34][2][3] = 320

        Game_CMD.PathIndex[35][2][3] = 120
        Game_CMD.PathIndex[35][2][5] = 50
        Game_CMD.PathIndex[35][3][3] = 90
        Game_CMD.PathIndex[35][3][5] = 50
        Game_CMD.PathIndex[35][4][3] = 270
    end
end

-- dyj2

-- 60开炮倒计时
function GameLayer:setSecondCount(dt)
    self.m_nSecondCount = dt

    if dt == 60 then
        local tipBG = self._gameView:getChildByTag(10000)
        if nil ~= tipBG then
            tipBG:removeFromParent(true)
        end
    end

end


-- 创建定时器
function GameLayer:onCreateSchedule()
    local isBreak0 = false
    local isBreak1 = true

    -- 定位大鱼
    local function selectMaxFish()

        -- 自动锁定
        if self._dataModel.m_autolock then

            local fish = self._dataModel.m_fishList[self._dataModel.m_fishIndex]
            -- 获取自动锁定的鱼

            if nil == fish then
                self._dataModel.m_fishIndex = self._dataModel:selectMaxFish()
                return
            end

            local rect = cc.rect(0, 0, yl.WIDTH, yl.HEIGHT)
            local pos = cc.p(fish:getPositionX(), fish:getPositionY())
            -- 如果鱼在屏幕里
            if not cc.rectContainsPoint(rect, pos) then
                self._dataModel.m_fishIndex = self._dataModel:selectMaxFish()
            end

        end
    end

    local function update_fish(dt)
        self:updateFish(dt)
        -- 筛选大鱼
        selectMaxFish()
    end

    local function bullet_update(dt)
        self:updateBullet(dt)
    end

    -- 游戏定时器
    if nil == self.m_scheduleUpdate then
        self.m_scheduleUpdate = scheduler:scheduleScriptFunc(update_fish, 0.031, false)
    end

    if nil == self.m_scheduleUpdateBullet then
        self.m_scheduleUpdateBullet = scheduler:scheduleScriptFunc(bullet_update, 0.031, false)
    end

end

function GameLayer:updateFish(dt)
    -- dyj1(FC++)
    for k, m_fish in pairs(self._dataModel.m_fishList) do
        --local m_fish = v
        -- 鱼移动
        if m_fish ~= nil and m_fish.m_pathIndex ~= nil and m_fish.m_pathIndex > -1 then
                
            local die = false
            m_fish.m_CreatDelayTime = m_fish.m_CreatDelayTime or 0
                
            if m_fish.m_CreatDelayTime > 8000 then
                die = true
            elseif m_fish.ifdie then
                die = true
            elseif currentTime() - m_fish.m_CreatDelayTime > 1000 and m_fish.Xpos < -200 then
                die = true
            elseif currentTime() - m_fish.m_CreatDelayTime > 1000 and m_fish.Ypos < -200 then
                die = true
            elseif currentTime() - m_fish.m_CreatDelayTime > 1000 and m_fish.Xpos > 1534 then
                die = true
            elseif currentTime() - m_fish.m_CreatDelayTime > 1000 and m_fish.Ypos > 950 then
                die = true
            end
            if die then
                self._dataModel.m_fishList[k] = nil
                -- 减少鱼的数量记录
                if m_fish.bReal then
                    self.m_fishCurCount[m_fish.fish_kind + 1] = self.m_fishCurCount[m_fish.fish_kind + 1] - 1
                    self.m_fishTotalCount = self.m_fishTotalCount - 1
                end
                if m_fish.ifdie then

                    self:runAction(cc.Sequence:create(cc.DelayTime:create(0.5), cc.CallFunc:create( function()
                        m_fish:removeAllChildren()
                        m_fish:removeFromParent()
                        m_fish = nil
                    end )))
                else
                    m_fish:removeAllChildren()
                    m_fish:removeFromParent()
                    m_fish = nil
                end
                    
            else
                if not self.bFishStop then
                    m_fish.m_CreatDelayTime = m_fish.m_CreatDelayTime + 1

                    m_fish.MoveTime = m_fish.MoveTime + 1
                    local fishtSmallBili = 1
                    if m_fish.m_data.fish_kind >= 10 and m_fish.m_data.fish_kind < 14 then
                        fishtSmallBili = fishtSmallBili * 1.2
                    elseif m_fish.m_data.fish_kind >= 14 and m_fish.m_data.fish_kind < 17 then
                        fishtSmallBili = fishtSmallBili * 1.3
                    elseif m_fish.m_data.fish_kind >= 17 then
                        fishtSmallBili = fishtSmallBili * 1.4
                    end

                    if m_fish.MoveTime >= Game_CMD.PathIndex[m_fish.m_pathIndex][m_fish.CurrPathindex][5] / Game_CMD.FISHMOVEBILI * fishtSmallBili and m_fish.CurrPathindex < 5 then
                        local NextRolation = Game_CMD.PathIndex[m_fish.m_pathIndex][m_fish.CurrPathindex + 1][3]
                        if self.m_nChairID + 1 > 3 then
                            if m_fish.m_pathIndex ~= 30 then
                                -- 限制条件5
                                NextRolation = NextRolation + 180
                            end
                        end
                        if NextRolation > 360 then
                            NextRolation = NextRolation - 360
                        end
                        if m_fish.Rolation == NextRolation then
                            m_fish.CurrPathindex = m_fish.CurrPathindex + 1
                            m_fish:runAction(cc.RotateTo:create(Game_CMD.PathIndex[m_fish.m_pathIndex][m_fish.CurrPathindex][7], m_fish.Rolation + m_fish.disAngle))
                            m_fish.MoveTime = 0
                        else
                            if Game_CMD.PathIndex[m_fish.m_pathIndex][m_fish.CurrPathindex + 1][7] == 0 then
                                m_fish.Rolation = m_fish.Rolation + 1
                                if m_fish.Rolation > 360 then
                                    m_fish.Rolation = m_fish.Rolation - 360
                                end
                            elseif Game_CMD.PathIndex[m_fish.m_pathIndex][m_fish.CurrPathindex + 1][7] == 1 then
                                m_fish.Rolation = m_fish.Rolation - 1
                                if m_fish.Rolation < 0 then
                                    m_fish.Rolation = m_fish.Rolation + 360
                                end
                            end
                            if m_fish.m_pathIndex ~= 20 then
                                -- 限制条件6
                                m_fish:setRotation(m_fish.Rolation - 180)
                            else
                                m_fish:setRotation(m_fish.Rolation)
                            end
                        end
                    end
                    m_fish.Speed = m_fish.Speed + Game_CMD.PathIndex[m_fish.m_pathIndex][m_fish.CurrPathindex][6] * 1

                    if m_fish.m_pathIndex ~= 47 and m_fish.m_pathIndex ~= 46 and m_fish.m_pathIndex ~= 48 then
                        m_fish.Xpos = m_fish.Xpos + Game_CMD.FISHMOVEBILI * m_fish.mX * m_fish.Speed * 1.2 * sinf(m_fish.Rolation * 0.0174533) / fishtSmallBili
                        m_fish.Ypos = m_fish.Ypos + Game_CMD.FISHMOVEBILI * m_fish.mY * m_fish.Speed * 1.2 * cosf(m_fish.Rolation * 0.0174533) / fishtSmallBili
                    else
                        m_fish.Xpos = m_fish.Xpos + Game_CMD.FISHMOVEBILI * m_fish.mX * m_fish.Speed * 1.2 * sinf(m_fish.Rolation * 0.0174533)
                        m_fish.Ypos = m_fish.Ypos + Game_CMD.FISHMOVEBILI * m_fish.mY * m_fish.Speed * 1.2 * cosf(m_fish.Rolation * 0.0174533) 
                    end
                    m_fish:setConvertPoint(cc.p(m_fish.Xpos + m_fish.offsetX, m_fish.Ypos + m_fish.offsetY))
                end
            end
        elseif m_fish ~= nil and m_fish.m_pathIndex ~= nil then
            -- 鱼移动
            if m_fish.index >= #m_fish.fscene or m_fish.ifdie then
                self._dataModel.m_fishList[k] = nil
                if m_fish.ifdie then
                    self:runAction(cc.Sequence:create(cc.DelayTime:create(0.5), cc.CallFunc:create( function()
                        m_fish:removeAllChildren()
                        m_fish:removeFromParent()
                        m_fish = nil
                    end )))
                else
                    m_fish:removeAllChildren()
                    m_fish:removeFromParent()
                    m_fish = nil
                end
                self.m_fishTotalCount = self.m_fishTotalCount - 1
            else
                if m_fish.stoptime > 0 and m_fish.index == m_fish.stopindex and m_fish.m_producttime < m_fish.stoptime then
                    m_fish.m_producttime = m_fish.m_producttime + 1
                    if m_fish.m_producttime >= m_fish.stoptime then
                        m_fish.stoptime = 0
                        m_fish.stopindex = 0
                        m_fish.m_producttime = 0
                    end
                else
                    m_fish:setConvertPoint1(cc.p(m_fish.fscene[m_fish.index][1] * m_WScale, m_fish.fscene[m_fish.index][2] * m_HScale),(m_fish.fscene[m_fish.index][3] * m_AScale))
                    m_fish.index = m_fish.index + 1
                end
            end
        end
    end
    -- dyj2
end

function GameLayer:updateBullet(dt)
    for i = #self.bullet, 1, -1 do
        if self.bullet[i].ifdie then    --子弹死亡
            if self.bullet[i].chairId == self.m_nChairID then
                self.m_cannonLayer.m_bullet_cur_count = self.m_cannonLayer.m_bullet_cur_count - 1
                if self.m_cannonLayer.m_bullet_cur_count <= 0 then
                    self.m_cannonLayer.m_bullet_cur_count = 0
                end 
            end
            self.bullet[i]:removeAllChildren(true)
            self.bullet[i]:removeFromParent(true)
            table.remove(self.bullet, i)
        else
            -- 子弹移动
            if self.bullet[i].m_fishIndex == Game_CMD.INT_MAX then
                local pox = self.bullet[i]:getPositionX() + self.bullet[i].movedir.x * self.bullet[i].spx
                local poy = self.bullet[i]:getPositionY() + self.bullet[i].movedir.y * self.bullet[i].spy
                if pox <= 0 or pox >= winsize.width then
                    self.bullet[i].spx = - self.bullet[i].spx
                    self.bullet[i].orignalAngle = - self.bullet[i].orignalAngle
                    self.bullet[i]:setRotation(self.bullet[i].orignalAngle)
                end
                if poy <= 0 or poy >= winsize.height then
                    self.bullet[i].spy = - self.bullet[i].spy
                    self.bullet[i].orignalAngle = 180 - self.bullet[i].orignalAngle
                    self.bullet[i]:setRotation(self.bullet[i].orignalAngle)
                end
                self.bullet[i]:setPosition(cc.p(pox, poy))
            else    --锁定鱼
                local fish = self._dataModel.m_fishList[self.bullet[i].m_fishIndex]
                if nil == fish then
                    self.bullet[i].m_fishIndex = Game_CMD.INT_MAX
                    self.bullet[i]:initPhysicsBody()
                else
                    if not cc.rectContainsPoint(cc.rect(0, 0, yl.WIDTH, yl.HEIGHT), cc.p(fish:getPositionX(), fish:getPositionY())) then
		                self.bullet[i].m_fishIndex = Game_CMD.INT_MAX
                        self.bullet[i]:initPhysicsBody()
                    else
                        local fishPos = cc.p(fish:getPositionX(), fish:getPositionY())
	                    if self._dataModel.m_reversal then
		                    fishPos = cc.p(yl.WIDTH - fishPos.x, yl.HEIGHT - fishPos.y)
	                    end
                        local angle = self._dataModel:getAngleByTwoPoint(fishPos, cc.p(self.bullet[i]:getPositionX(), self.bullet[i]:getPositionY()))
                        self.bullet[i]:setRotation(angle)
                        
                        angle = math.rad(90 - angle)
	                    local movedir = cc.pForAngle(angle)
	                    movedir = cc.p(movedir.x * 55 , movedir.y * 55)
                        self.bullet[i].movedir = movedir

                        local pox = self.bullet[i]:getPositionX() + self.bullet[i].movedir.x * self.bullet[i].spx
                        local poy = self.bullet[i]:getPositionY() + self.bullet[i].movedir.y * self.bullet[i].spy

                        if pox <= 0 or pox >= winsize.width or poy >= winsize.height then
                            self.bullet[i].m_fishIndex = Game_CMD.INT_MAX
                            self.bullet[i]:initPhysicsBody()
                        else
                            self.bullet[i]:setPosition(cc.p(pox, poy))
                            local rec = fish:getBoundingBox()
                            
                            if cc.pGetDistance(fishPos, cc.p(pox, poy)) <= 25  then
                                self.bullet[i].m_fishIndex = Game_CMD.INT_MAX
                                self.bullet[i]:initPhysicsBody()
	                        end
                        end
	                end
                end
            end
        end
    end
end

function GameLayer:createSecoundSchedule()

    local function setSecondTips()
        -- 提示

        if nil == self._gameView:getChildByTag(10000) then

            local tipBG = cc.Sprite:create("game_res/secondTip.png")
            tipBG:setPosition(667, 630)
            tipBG:setTag(10000)
            self._gameView:addChild(tipBG, 100)


            local watch = cc.Sprite:createWithSpriteFrameName("watch_0.png")
            watch:setPosition(60, 45)
            tipBG:addChild(watch)

            local animation = cc.AnimationCache:getInstance():getAnimation("watchAnim")
            if nil ~= animation then
                watch:runAction(cc.RepeatForever:create(cc.Animate:create(animation)))
            end

            local time = cc.Label:createWithTTF(string.format("%d秒", self.m_nSecondCount), "base/fonts/round_body.ttf", 20)
            time:setTextColor(cc.YELLOW)
            time:setAnchorPoint(0.0, 0.5)
            time:setPosition(117, 55)
            time:setTag(1)
            tipBG:addChild(time)

            local buttomTip = cc.Label:createWithTTF("60秒未开炮,即将退出游戏", "base/fonts/round_body.ttf", 20)
            buttomTip:setAnchorPoint(0.0, 0.5)
            buttomTip:setPosition(117, 30)
            tipBG:addChild(buttomTip)

        else

            local tipBG = self._gameView:getChildByTag(10000)
            local time = tipBG:getChildByTag(1)
            time:setString(string.format("%d秒", self.m_nSecondCount))
        end

    end

    local function removeTip()

        local tipBG = self._gameView:getChildByTag(10000)
        if nil ~= tipBG then
            tipBG:removeFromParent(true)
        end

    end


    local function update(dt)

        if self.m_nSecondCount == 0 then
            -- 发送起立
            removeTip()
            self:runAction(cc.Sequence:create(
            cc.DelayTime:create(delayLeaveTime),
            cc.CallFunc:create(
            function()
                self.m_bLeaveGame = true
                self._gameView:StopLoading(false)
                self._gameFrame:StandUp(1)
            end
            ),
            cc.DelayTime:create(exit_timeOut),
            cc.CallFunc:create(
            function()
                -- 强制离开游戏(针对长时间收不到服务器消息的情况)
                --print("delay leave")
                self:onExitRoom()
            end
            )
            )
            )
            return
        end
        if self.m_nSecondCount == 60 - self.m_laserTime then

            local pos = self.m_nChairID
            pos = CannonSprite.getPos(self._dataModel.m_reversal, pos)
            local cannon = self.m_cannonLayer:getCannoByPos(pos + 1)
            if nil ~= cannon then
                if cannon.m_Type == Game_CMD.CannonType.Laser_Cannon then
                    cannon:shootLaser()
                end
            end

        end

        if self.m_nSecondCount <= 60 - SYNC_SECOND then
            if nil ~= self.m_cannonLayer then
                local cannonPos = self.m_nChairID
                if self._dataModel.m_reversal then
                    cannonPos = 5 - cannonPos
                end
                local cannon = self.m_cannonLayer:getCannoByPos(cannonPos + 1)
                if not cannon then
                    return
                end
            end
        end

        if self.m_nSecondCount - 1 >= 0 then
            self.m_nSecondCount = self.m_nSecondCount - 1
        end

        if self.m_nSecondCount <= 10 then
            setSecondTips()
        end

    end

    if nil == self.m_secondCountSchedule then
        self.m_secondCountSchedule = scheduler:scheduleScriptFunc(update, 2.0, false)
    end

end

function GameLayer:unSchedule()

    -- 游戏定时器
    if nil ~= self.m_scheduleUpdate then
        scheduler:unscheduleScriptEntry(self.m_scheduleUpdate)
        self.m_scheduleUpdate = nil
    end
    if nil ~= self.m_scheduleUpdateBullet then
        scheduler:unscheduleScriptEntry(self.m_scheduleUpdateBullet)
        self.m_scheduleUpdateBullet = nil
    end

    -- 60秒倒计时定时器
    if nil ~= self.m_secondCountSchedule then
        scheduler:unscheduleScriptEntry(self.m_secondCountSchedule)
        self.m_secondCountSchedule = nil
    end
end

function GameLayer:onEnter()

    --print("onEnter of gameLayer")
    self.m_bLeaveGame = false
end

function GameLayer:onEnterTransitionFinish()

    --print("onEnterTransitionFinish of gameLayer")

    -- AudioEngine.playMusic(Game_CMD.Music_Back_1,true)

    -- 碰撞监听
    self:addContact()

end

function GameLayer:onExit()

    --print("gameLayer onExit()....")
    self.m_bLeaveGame = true
    -- 移除碰撞监听
    cc.Director:getInstance():getEventDispatcher():removeEventListener(self.contactListener)

    cc.Director:getInstance():getEventDispatcher():removeCustomEventListeners(Game_CMD.Event_LoadingFinish)

    for i = #self.bullet,1,-1 do
        self.bullet[i]:removeAllChildren()
        self.bullet[i]:removeFromParent(true)
    end

    AudioEngine.stopMusic()
    -- 释放游戏所有定时器
    self:unSchedule()

    for k, v in pairs(self._dataModel.m_fishList) do
        if v ~= nil then
            self._dataModel.m_fishList[k] = nil
            v:removeAllChildren()
            v:removeFromParent(true)
        end
     end
end



-- 用户进入
function GameLayer:onEventUserEnter(wTableID, wChairID, useritem)

    if wTableID ~= self.m_nTableID or useritem.cbUserStatus == yl.US_LOOKON or not self.m_cannonLayer then
        return
    end

    self.m_cannonLayer:onEventUserEnter(wTableID, wChairID, useritem)
    -- dyj1(Fc++)
    local systime = currentTime()
    self._dataModel.m_enterTime = systime

    -- self:setUserMultiple()
end

-- 用户状态
function GameLayer:onEventUserStatus(useritem, newstatus, oldstatus)

    if useritem.cbUserStatus == yl.US_LOOKON or not self.m_cannonLayer then
        return
    end


    self.m_cannonLayer:onEventUserStatus(useritem, newstatus, oldstatus)

    -- self:setUserMultiple()

end

-- 用户分数
function GameLayer:onEventUserScore(item)
    --print("fishlk onEventUserScore...")
end
 

-- 初始化游戏数据
function GameLayer:onInitData()

end



-- 重置游戏数据
function GameLayer:onResetData()
    -- body
end

function GameLayer:setUserMultiple()

    if not self.m_cannonLayer then
        return
    end

    -- 设置炮台倍数
    for i = 1, 10 do

        local pos = i - 1
        pos = CannonSprite.getPos(self._dataModel.m_reversal, pos)
        local cannon = self.m_cannonLayer:getCannoByPos(pos)
        local nMultipleIndex = self.CurrShoot[1][i]
        if nil ~= cannon then
            cannon:setMultiple(nMultipleIndex)
        end
    end
end

-- 场景信息

function GameLayer:onEventGameScene(cbGameStatus, dataBuffer)

    --print("场景数据")


    if self.m_bScene then
        self:dismissPopWait()
        return
    end
    self.m_bScene = true
    local systime = currentTime()
    self._dataModel.m_enterTime = systime

    self._dataModel.m_secene = ExternalFun.read_netdata(Game_CMD.GameScene, dataBuffer)

    self.ScoreCount = self._dataModel.m_secene.fish_score[1][self.m_nChairID + 1]

    self.Copylscore = self.m_pUserItem.lScore - self.ScoreCount

    for i = 1, Game_CMD.GAME_PLAYER do
        table.insert(self.CurrShoot[1], self._dataModel.m_secene.MinShoot)
    end
    --如果是鱼阵
    if self._dataModel.m_secene.isYuZhen then
        --提示鱼阵等待
        local spFishWait = display.newSprite("game_res/fish_wait.png")
        spFishWait:addTo(self)
        spFishWait:move(display.center)
        spFishWait:setName("fish_wait")
        spFishWait:setLocalZOrder(1000)
    end
    self.CellShoot = self._dataModel.m_secene.MinShoot
    self:setUserMultiple()
    self:dismissPopWait()
end

-- 游戏消息
function GameLayer:onEventGameMessage(sub, dataBuffer)

    if self.m_bLeaveGame or nil == self._gameView then
        return
    end

    if sub == Game_CMD.SUB_S_SYNCHRONOUS and not self.m_bSynchronous then
        -- 同步信息
        self:onSubSynchronous(dataBuffer)

    elseif sub == Game_CMD.SUB_S_FISH_CREATE then

        -- dyj1
        local Star = ExternalFun.read_netdata(Game_CMD.CMD_S_GameConfig, dataBuffer)
        self.ScoreM = Star.exchange_count 
        self.bMinConnonMultiple = Star.min_bullet_multiple
        self._gameView.m_bIsGameCheatUser = Star.bIsGameCheatUser
        print("buyu admin:%d",Star.bIsGameCheatUser)
        -- dyj2

    elseif sub == Game_CMD.SUB_S_FISH_CATCH and true == PRELOAD.bLoadingFinish then
        -- 捕获鱼
        self:onSubFishCatch(dataBuffer)
    elseif sub == Game_CMD.SUB_S_EXCHANGE_SCENE and true == PRELOAD.bLoadingFinish then
        -- 切换场景
        self:onSubExchangeScene(dataBuffer)
    elseif sub == Game_CMD.SUB_S_FIRE and true == PRELOAD.bLoadingFinish then
        -- 开炮
        self:onSubFire(dataBuffer)
    elseif sub == Game_CMD.SUB_S_NOFISH and true == PRELOAD.bLoadingFinish then
        -- 返还分数
        self:onBackScore(dataBuffer)
    elseif sub == Game_CMD.SUB_S_MULTIPLE and true == PRELOAD.bLoadingFinish then
        -- 上下分
        self:onSubMultiple(dataBuffer)
    elseif sub == Game_CMD.SUB_S_NoFire then
        -- 限制子弹数
        -- self.ifFire = false
        self:onSubSetBulletLimitCount(dataBuffer)
    elseif sub == Game_CMD.SUB_S_TimeUp and true == PRELOAD.bLoadingFinish then
        -- 限制60s
        showToast(cc.Director:getInstance():getRunningScene(), "由于您一分钟未发射子弹，强制将您请出房间！！！", 3)
    elseif sub == Game_CMD.SUB_S_TRACE_POINT and true == PRELOAD.bLoadingFinish then
        -- 鱼
        self:onSubCreateMoreFishd(dataBuffer)
    elseif sub == Game_CMD.SUB_S_Zongfen and true == PRELOAD.bLoadingFinish then
        -- 更新总分
        self:onSubUpdateAllScore(dataBuffer)
    elseif sub == Game_CMD.SUB_S_BULLET_ION_TIMEOUT and true == PRELOAD.bLoadingFinish then
        --停止超级炮
        self:onSubStopSuperPao(dataBuffer)
    elseif sub == Game_CMD.SUB_S_CATCH_SWEEP_FISH and true == PRELOAD.bLoadingFinish then
        --抓到BOSS和炸弹时
        self:onSubCatchFishKing(dataBuffer)
    elseif sub == Game_CMD.SUB_S_CATCH_SWEEP_FISH_RESULT and true == PRELOAD.bLoadingFinish then
        --抓到BOSS和炸弹的结果
        self:onSubCatchFishKingResult(dataBuffer)
    elseif sub == Game_CMD.SUB_S_ControlCfg and true == PRELOAD.bLoadingFinish then
        --抓到BOSS和炸弹的结果
        self._gameView:setControlCfg(dataBuffer)
    elseif sub == Game_CMD.SUB_S_LOCK_TIMEOUT then
        --锁定时间到
        self:onSubFishStopEnd(dataBuffer)
    end
end

--锁定时间到
function GameLayer:onSubFishStopEnd(databuffer)
    
    self.bFishStop = false
    local maskBlue = self:getChildByName("maskBlue")
    if nil ~= maskBlue then
        maskBlue:removeFromParent(true)
    end
end

--抓到BOSS和炸弹的结果
function GameLayer:onSubCatchFishKingResult(databuffer)
    local data = ExternalFun.read_netdata(Game_CMD.CMD_S_CatchSweepFishResult, databuffer)
    for i = 1, 300 do
        if data.catch_fish_id[1][i] ~= 0 then
            for k, fish in pairs(self._dataModel.m_fishList) do
                if data.catch_fish_id[1][i] == fish.fish_id then
                    local fishPos = cc.p(fish:getPositionX(), fish:getPositionY())
                    if self._dataModel.m_reversal then
                        fishPos = cc.p(yl.WIDTH - fishPos.x, yl.HEIGHT - fishPos.y)
                    end
                    self._gameView:ShowCoin(data.fish_score, data.wChairID, fishPos, fish.m_data.fish_kind)
                    fish.ifdie = true
                    break
                end
            end
        else
            break
        end
    end
    
end

--抓到BOSS和炸弹时
function GameLayer:onSubCatchFishKing(databuffer)

    local data = ExternalFun.read_netdata(Game_CMD.CMD_S_CatchSweepFish, databuffer)
    
    local fishType = 1 
    local fishRealType = 1
    local fishPos = cc.p(0,0)
    local catchFish = nil
    for k,fish in pairs(self._dataModel.m_fishList) do
        if fish.fish_id == data.dwFishID then
            fishType = fish.m_data.fish_kind
            fishRealType = fish.fish_kind
            catchFish = fish
            fishPos = cc.p(fish:getPositionX(), fish:getPositionY())
            break
        end
    end

    if fishRealType + 1 == Game_CMD.FishType_ZhongYiTang then
        --定屏炸弹
        self.bFishStop = true
        
        return
    elseif fishRealType + 1 == Game_CMD.FishType_ShuiHuZhuan then
        --局部炸弹
        if data.wChairID == self.m_nChairID then
            local catchCount = 0
            local fishId = {}
            for k,fish in pairs(self._dataModel.m_fishList) do
                local pos = cc.p(fish:getPositionX(), fish:getPositionY())
                if pos.x > 0 and pos.x < 1334 and pos.y > 0 and pos.y < 750 
                    and pos.x > fishPos.x - 150 and pos.x < fishPos.x + 150 and pos.y > fishPos.y - 150 and  pos.y < fishPos.y + 150 then
                        catchCount = catchCount + 1
                        table.insert(fishId, fish.fish_id)
                end
            end

            if catchCount > 0 then
                local cmddata = CCmd_Data:create(1210)
                cmddata:setcmdinfo(yl.MDM_GF_GAME, Game_CMD.SUB_C_CATCH_SWEEP_FISH);
                cmddata:pushword(self.m_nChairID)
                cmddata:pushint(data.dwFishID)
                cmddata:pushint(catchCount)
                for i = 1, catchCount do
                    cmddata:pushint(fishId[i])
                end
                for i = catchCount + 1, 300 do
                    cmddata:pushint(0)
                end
                for i = #fishId, 1, -1 do
                    table.remove(fishId, i)
                end

                -- 发送失败
                if not self._gameFrame:sendSocketData(cmddata) then
                    self._gameFrame._callBack(-1, "发送消息失败")
                end
            end
        end
    elseif fishRealType + 1 == Game_CMD.FishType_QuanPingZhadan then
        --全屏炸弹
        if data.wChairID == self.m_nChairID then
            local catchCount = 0
            local fishId = {}
            for k,fish in pairs(self._dataModel.m_fishList) do
                local pos = cc.p(fish:getPositionX(), fish:getPositionY())
                if pos.x > 0 and pos.x < 1334 and pos.y > 0 and pos.y < 750 then
                    catchCount = catchCount + 1
                    table.insert(fishId, fish.fish_id)
                end
            end

            if catchCount > 0 then
                local cmddata = CCmd_Data:create(1210)
                cmddata:setcmdinfo(yl.MDM_GF_GAME, Game_CMD.SUB_C_CATCH_SWEEP_FISH);
                cmddata:pushword(self.m_nChairID)
                cmddata:pushint(data.dwFishID)
                cmddata:pushint(catchCount)
                for i = 1, catchCount do
                    cmddata:pushint(fishId[i])
                end
                for i = catchCount + 1, 300 do
                    cmddata:pushint(0)
                end
                for i = #fishId, 1, -1 do
                    table.remove(fishId, i)
                end

                -- 发送失败
                if not self._gameFrame:sendSocketData(cmddata) then
                    self._gameFrame._callBack(-1, "发送消息失败")
                end
            end
        end
    elseif fishRealType + 1 >= 31 and fishRealType + 1 <= 40 then 
        --鱼王
        if data.wChairID == self.m_nChairID then
            local catchCount = 0
            local fishId = {}
            for k,fish in pairs(self._dataModel.m_fishList) do
                if fishRealType == fish.fish_kind then
                    --黄金气泡
                    local fishPos = cc.p(fish:getPositionX(), fish:getPositionY())
                    if self._dataModel.m_reversal then
                        fishPos = cc.p(yl.WIDTH - fishPos.x, yl.HEIGHT - fishPos.y)
                    end
                    self:fishKingBubble(fishPos)
                end
                if fish.m_data.fish_kind == fishType then
                    local pos = cc.p(fish:getPositionX(), fish:getPositionY())
                    if pos.x > 0 and pos.x < 1334 and pos.y > 0 and pos.y < 750 then
                        catchCount = catchCount + 1
                        table.insert(fishId, fish.fish_id)
                    end
                end
            end
            if catchCount > 0 then
                local cmddata = CCmd_Data:create(1210)
                cmddata:setcmdinfo(yl.MDM_GF_GAME, Game_CMD.SUB_C_CATCH_SWEEP_FISH);
                cmddata:pushword(self.m_nChairID)
                cmddata:pushint(data.dwFishID)
                cmddata:pushint(catchCount)
                for i = 1, catchCount do
                    cmddata:pushint(fishId[i])
                end
                for i = catchCount + 1, 300 do
                    cmddata:pushint(0)
                end
                for i = #fishId, 1, -1 do
                    table.remove(fishId, i)
                end

                -- 发送失败
                if not self._gameFrame:sendSocketData(cmddata) then
                    self._gameFrame._callBack(-1, "发送消息失败")
                end
            end
        end
    end
end

--停止超级炮
function GameLayer:onSubStopSuperPao(databuffer)
    local data = ExternalFun.read_netdata(Game_CMD.CMD_S_BulletIonTimeout, databuffer)
    local chairId = data.chair_id
    local cannonPos = CannonSprite.getPos(self._dataModel.m_reversal, chairId)
    local cannon = self.m_cannonLayer:getCannoByPos(cannonPos + 1)
    if cannon ~= nil then
        cannon:setCannonType(Game_CMD.CannonType.Normal_Cannon)
    end
end

-- 更新总分
function GameLayer:onSubUpdateAllScore(databuffer)
    local data = ExternalFun.read_netdata(Game_CMD.CMD_S_UpdateAllScore, databuffer)
    local chairId = data.wChairID
    
    local fish = self._dataModel.m_fishList[data.dwFishID]

    if fish ~= nil and fish.m_data ~= nil and fish.m_data.fish_kind == Game_CMD.FishType_BaoXiang then  --打中宝箱
        local index = data.app
        self._gameView:catchBox(data.wChairID, index)
    end
    local cannonPos = CannonSprite.getPos(self._dataModel.m_reversal, chairId)
    local cannon = self.m_cannonLayer:getCannoByPos(cannonPos + 1)
    if chairId == self.m_nChairID then
        self.ScoreCount = data.lFishScore
        if cannon ~= nil then
            self.m_cannonLayer:updateUpScore(self.ScoreCount, cannon.m_pos + 1)
            --超级炮
            if data.bullet_ion then
                cannon:setCannonType(Game_CMD.CannonType.Special_Cannon)
            end
        end
    else
        self._dataModel.m_secene.fish_score[1][chairId + 1] = data.lFishScore
        if cannon ~= nil then
            self.m_cannonLayer:updateUpScore(self._dataModel.m_secene.fish_score[1][chairId + 1], cannon.m_pos + 1)
            if data.bullet_ion then
                cannon:setCannonType(Game_CMD.CannonType.Special_Cannon)
            end
        end
    end
end

function GameLayer:onSubSetBulletLimitCount(databuffer)
    local data = ExternalFun.read_netdata(Game_CMD.CMD_S_BulletLimitCount, databuffer)
    local count = data.bullet_limit_count
    if count ~= nil then
        if count > 0 then
            self.bulletLimitCount = count
            if self.m_cannonLayer ~= nil and self.m_cannonLayer.m_bullet_limit_count ~= nil then
                self.m_cannonLayer.m_bullet_limit_count = count
            end
        end
    end

end

function GameLayer:onSubAwardTip(databuffer)
    local award = ExternalFun.read_netdata(Game_CMD.CMD_S_AwardTip, databuffer)
    local mutiple = award.nFishMultiple

    if mutiple >= 50 or(award.nFishType == 19 and award.nScoreType == Game_CMD.SupplyType.EST_Cold and award.wChairID == self.m_nChairID) then
        self._gameView:ShowAwardTip(award)
    end
end

function GameLayer:onSubBankTake(databuffer)
    local take = ExternalFun.read_netdata(Game_CMD.CMD_S_BankTake, databuffer)

    -- dyj1
    self._dataModel.m_secene.m_lUserAllScore[1][take.wChairID + 1] = self._dataModel.m_secene.m_lUserAllScore[1][take.wChairID + 1] + take.lPlayScore
    -- dyj2
    if not self.m_cannonLayer then
        return
    end
    local cannonPos = take.wChairID

    cannonPos = CannonSprite.getPos(self._dataModel.m_reversal, cannonPos)

    local cannon = self.m_cannonLayer:getCannoByPos(cannonPos + 1)
    if not cannon then
        return
    end

    if take.wChairID == self.m_nChairID then
        -- dyj1
        GlobalUserItem.lUserScore = self._dataModel.m_secene.m_lUserAllScore[1][take.wChairID + 1]
        -- dyj2

        if nil ~= self._gameView and false == self.m_bLeaveGame then
            self._gameView:refreshScore()
        end

    end
end

function GameLayer:onSubShootLaser(databuffer)
    local laser = ExternalFun.read_netdata(Game_CMD.CMD_S_Laser, databuffer)

    local cannonPos = laser.wChairID
    if laser.wChairID == self.m_nChairID then
        return
    end
    cannonPos = CannonSprite.getPos(self._dataModel.m_reversal, cannonPos)
    local cannon = self.m_cannonLayer:getCannoByPos(cannonPos + 1)
    if nil ~= cannon then
        local ifchange = false
        if self.m_nChairID > 1 then
            if laser.wChairID > 1 then
                -- 4,5,6同边位置
                ifchange = true
            else
                ifchange = false
            end
        else
            if laser.wChairID < 2 then
                -- 1,2,3同边位置
                ifchange = true
            else
                ifchange = false
            end
        end
        if ifchange then
            cannon.fangle = laser.fAngle
        else
            cannon.fangle = laser.fAngle + 180
        end
        cannon:shootLaser()
    end
end

function GameLayer:onSubBeginLaser(databuffer)
    local laser = ExternalFun.read_netdata(Game_CMD.CMD_S_BeginLaser, databuffer)
    local cannonPos = laser.wChairID
    cannonPos = CannonSprite.getPos(self._dataModel.m_reversal, cannonPos)
    local cannon = self.m_cannonLayer:getCannoByPos(cannonPos + 1)
    if nil ~= cannon then
        cannon.m_laserBeginConvertPos.x = laser.ptPos.x
        cannon.m_laserBeginConvertPos.y = laser.ptPos.y
        cannon.m_laserBeginConvertPos = self._dataModel:convertCoordinateSystem(cc.p(cannon.m_laserBeginConvertPos.x, cannon.m_laserBeginConvertPos.y), 0, self._dataModel.m_reversal)
    end
end

function GameLayer:onSubUpdateFishScore(databuffer)
    local updateFish = ExternalFun.read_netdata(Game_CMD.CMD_S_UpdateFishScore, databuffer)
    local fish = self._dataModel.m_fishList[updateFish.nFishKey]
    if nil ~= fish then
        fish:setScore(updateFish.nFishScore)
    end

end

function GameLayer:onSubSupplyTip(databuffer)

    if not self.m_cannonLayer then
        return
    end

    local tip = ExternalFun.read_netdata(Game_CMD.CMD_S_SupplyTip, databuffer)

    local tipStr = ""
    if tip.wChairID == self.m_nChairID then
        tipStr = "获得一个补给箱！击中可能获得大量奖励哟！赶快击杀！"
    else
        local cannonPos = tip.wChairID
        cannonPos = CannonSprite.getPos(self._dataModel.m_reversal, cannonPos)

        local cannon = self.m_cannonLayer:getCannoByPos(cannonPos + 1)
        local userid = self.m_cannonLayer:getUserIDByCannon(cannonPos + 1)
        local userItem = self._gameFrame._UserList[userid]

        if not userItem then
            return
        end
        tipStr = userItem.szNickName .. " 获得了一个补给箱！羡慕吧，继续努力，你也可能得到！"
    end

    self._gameView:Showtips(tipStr)
end

function GameLayer:onSubMultiple(databuffer)

    local mutiple = ExternalFun.read_netdata(Game_CMD.CMD_S_ExchangeFishScore, databuffer)
    local cannonPos = mutiple.chair_id
    cannonPos = CannonSprite.getPos(self._dataModel.m_reversal, cannonPos)
    local cannon = self.m_cannonLayer:getCannoByPos(cannonPos + 1)
    if mutiple.chair_id == self.m_nChairID then
        self.ScoreCount = self.ScoreCount + mutiple.swap_fish_score
        if cannon ~= nil then
            self.m_cannonLayer:updateUpScore(self.ScoreCount, cannon.m_pos + 1)
        end
    else
        self._dataModel.m_secene.fish_score[1][mutiple.chair_id + 1] = self._dataModel.m_secene.fish_score[1][mutiple.chair_id + 1] + mutiple.swap_fish_score
        if cannon ~= nil then
            self.m_cannonLayer:updateUpScore(self._dataModel.m_secene.fish_score[1][mutiple.chair_id + 1], cannon.m_pos + 1)
        end
    end

end

function GameLayer:onSubUpdateGame(databuffer)
    local update = ExternalFun.read_netdata(Game_CMD.CMD_S_UpdateGame, databuffer)
    self._dataModel.m_secene.nMultipleValue = update.nMultipleValue
    self._dataModel.m_secene.nFishMultiple = update.nFishMultiple
end

-- dyj1(废弃)
function GameLayer:onSubStayFish(databuffer)

end
-- dyj2

function GameLayer:onSubSupply(databuffer)
    local supply = ExternalFun.read_netdata(Game_CMD.CMD_S_Supply, databuffer)
    local cannonPos = supply.wChairID
    cannonPos = CannonSprite.getPos(self._dataModel.m_reversal, cannonPos)

    if supply.nSupplyType == Game_CMD.SupplyType.EST_Gift then

        if supply.wChairID == self.m_nChairID then
            self._dataModel.m_lScoreCopy = self._dataModel.m_lScoreCopy + supply.lSupplyCount
        end
    end

    if not self.m_cannonLayer then
        return
    end

    local cannon = self.m_cannonLayer:getCannoByPos(cannonPos + 1)
    if not cannon then
        return
    else
        if supply.nSupplyType == Game_CMD.SupplyType.EST_Gift then
            --print("=============== onSubSupply updateScore ============", supply.wChairID)

        end
    end

    cannon:ShowSupply(supply)

    local tipStr = ""

    local cannon = self.m_cannonLayer:getCannoByPos(cannonPos + 1)
    local userid = self.m_cannonLayer:getUserIDByCannon(cannonPos + 1)
    local userItem = self._gameFrame._UserList[userid]

    if supply.nSupplyType == Game_CMD.SupplyType.EST_Laser then
        if supply.wChairID == self.m_nChairID then

            self.m_laserTime = supply.lSupplyCount
            tipStr = self.m_pUserItem.szNickName .. "击中补给箱打出了激光！秒杀利器！赶快使用！"
        else
            tipStr = userItem.szNickName .. " 击中补给箱打出了激光！秒杀利器!"
        end

    elseif supply.nSupplyType == Game_CMD.SupplyType.EST_Speed then

        tipStr = userItem.szNickName .. " 击中补给箱打出了加速！所有子弹速度翻倍！"
    elseif supply.nSupplyType == Game_CMD.SupplyType.EST_Null then

        tipStr = "很遗憾！补给箱里面什么都没有！"

        self._dataModel:playEffect(Game_CMD.SmashFail)

    end

    if nil ~= tipStr then
        self._gameView:Showtips(tipStr)
    end

end

-- 同步时间
function GameLayer:onSubSynchronous(databuffer)
    self.m_bSynchronous = true
    local synchronous = ExternalFun.read_netdata(Game_CMD.CMD_S_FishFinish, databuffer)
    if 0 ~= synchronous.nOffSetTime then
        local offtime = synchronous.nOffSetTime
        self._dataModel.m_enterTime = self._dataModel.m_enterTime - offtime
    end

end

-- 创建鱼(废弃)
function GameLayer:onSubFishCreate(dataBuffer)

end

-- 切换场景
function GameLayer:onSubExchangeScene(dataBuffer)

    --print("场景切换")

    self.iffishcomb = true
    local count = math.floor(dataBuffer:getlen() / 2408)
    if count >= 1 then
        local FishComb = ExternalFun.read_netdata(Game_CMD.CMD_S_SwitchScene, dataBuffer)
        -- 鱼阵数据
        exchangeScene = FishComb.scene_kind % 5


        self:runAction(cc.Sequence:create(cc.DelayTime:create(5.5), cc.CallFunc:create( function()
            for k, v in pairs(self._dataModel.m_fishList) do
                if v ~= nil then
                    v.m_CreatDelayTime = 10000
                end
            end

            self.m_fishTotalCount = self.m_fishTotalCount + FishComb.fish_count
            -- 记录总鱼数
            if true then

                if FishComb.scene_kind == 0 then
                    self.s = 1
                    for i = 1, FishComb.fish_count do
                        local fishdef = { }
                        fishdef.fish_kind = FishComb.fish_kind[1][i]
                        fishdef.fish_id = FishComb.fish_id[1][i]
                        fishdef.cmd_version = -1

                        local fish = Fish:create(fishdef, self)
                        fish:initAnim1()
                        fish.Speed = 1
                        fish:setTag(fishdef.fish_id)
                        fish:setName(Game_CMD.FISH)

                        local fishTrace = { }
                        if i <= 41 then
                            fishTrace = PRELOAD.fishTrace1_1[i]
                        elseif i > 41 and i <= 86 then
                            fishTrace = PRELOAD.fishTrace1_2[i - 41]
                        elseif i > 86 and i <= 127 then
                            fishTrace = PRELOAD.fishTrace1_3[i - 86]
                        elseif i > 127 and i <= 169 then
                            fishTrace = PRELOAD.fishTrace1_4[i - 127]
                        elseif i > 169 and i <= 210 then
                            fishTrace = PRELOAD.fishTrace1_5[i - 169]
                        end
                        fish:setindex(#fishTrace)
                        fish:setscene(fishTrace)
                        fish:setConvertPoint1(cc.p(fishTrace[1][1] * m_WScale, fishTrace[1][2] * m_HScale), fishTrace[1][3] * m_AScale)

                        self.m_fishLayer:addChild(fish, fish.m_data.fish_kind + 1)
                        self._dataModel.m_fishList[fish.fish_id] = fish
                    end
                elseif FishComb.scene_kind == 1 then
                    for i = 1, FishComb.fish_count do
                        local fishdef = { }
                        fishdef.fish_kind = FishComb.fish_kind[1][i]
                        fishdef.fish_id = FishComb.fish_id[1][i]
                        fishdef.cmd_version = -1

                        local fish = Fish:create(fishdef, self)
                        fish:initAnim1()
                        fish.Speed = 2
                        fish:setTag(fishdef.fish_id)
                        fish:setName(Game_CMD.FISH)

                        local fishTrace = { }
                        if i <= 190 then
                            fishTrace = PRELOAD.fishTrace2_1[i]
                        elseif i > 190 and i <= 214 then
                            fishTrace = PRELOAD.fishTrace2_2[i - 190]
                        end
                        fish:setindex(#fishTrace)
                        fish:setscene(fishTrace)
                        fish:setConvertPoint1(cc.p(fishTrace[1][1] * m_WScale, fishTrace[1][2] * m_HScale), fishTrace[1][3] * m_AScale)

                        self.m_fishLayer:addChild(fish, fish.m_data.fish_kind + 1)
                        self._dataModel.m_fishList[fish.fish_id] = fish

                        if i <= 200 then
                            fish.stopindex = PRELOAD.scene_kind_2_small_fish_stop_index_[i]
                            fish.stoptime = PRELOAD.scene_kind_2_small_fish_stop_count_ + fish.m_producttime
                        else
                            fish.stopindex = PRELOAD.scene_kind_2_big_fish_stop_index_ + 1
                            fish.stoptime = PRELOAD.scene_kind_2_big_fish_stop_count_ + fish.m_producttime
                        end
                    end
                    local num = #self._dataModel.m_fishList
                    --print("2 end")
                elseif FishComb.scene_kind == 2 then
                    self.s = 3
                    for i = 1, FishComb.fish_count do
                        local fishdef = { }
                        fishdef.fish_kind = FishComb.fish_kind[1][i]
                        fishdef.fish_id = FishComb.fish_id[1][i]
                        fishdef.cmd_version = -1

                        local fish = Fish:create(fishdef, self)
                        fish:initAnim1()
                        fish.Speed = 1.2
                        fish:setTag(fishdef.fish_id)
                        fish:setName(Game_CMD.FISH)

                        local fishTrace = { }
                        if i <= 41 then
                            fishTrace = PRELOAD.fishTrace3_1[i]
                        elseif i > 41 and i <= 82 then
                            fishTrace = PRELOAD.fishTrace3_2[i - 41]
                        elseif i > 82 and i <= 122 then
                            fishTrace = PRELOAD.fishTrace3_3[i - 82]
                        elseif i > 122 and i <= 161 then
                            fishTrace = PRELOAD.fishTrace3_4[i - 122]
                        elseif i > 161 and i <= 202 then
                            fishTrace = PRELOAD.fishTrace3_5[i - 161]
                        elseif i > 202 and i <= 242 then
                            fishTrace = PRELOAD.fishTrace3_6[i - 202]
                        end
                        fish:setindex(#fishTrace)
                        fish:setscene(fishTrace)
                        fish:setConvertPoint1(cc.p(fishTrace[1][1] * m_WScale, fishTrace[1][2] * m_HScale), fishTrace[1][3] * m_AScale)
                        -- 使左边整个鱼阵出现在另一个鱼阵的上面
                        if i <= 121 then
                            self.m_fishLayer:addChild(fish, fish.m_data.fish_kind + 1)
                        else
                            self.m_fishLayer:addChild(fish,(fish.m_data.fish_kind + 1) * 100)
                        end
                        self._dataModel.m_fishList[fish.fish_id] = fish
                    end
                elseif FishComb.scene_kind == 3 then
                    for i = 1, FishComb.fish_count do
                        local fishdef = { }
                        fishdef.fish_kind = FishComb.fish_kind[1][i]
                        fishdef.fish_id = FishComb.fish_id[1][i]
                        fishdef.cmd_version = -1

                        local fish = Fish:create(fishdef, self)
                        fish:initAnim1()
                        fish.Speed = 2
                        fish:setTag(fishdef.fish_id)
                        fish:setName(Game_CMD.FISH)

                        local fishTrace = { }
                        if i <= 31 then
                            fishTrace = PRELOAD.fishTrace4_1[i]
                        elseif i > 31 and i <= 64 then
                            fishTrace = PRELOAD.fishTrace4_2[i - 31]
                        end
                        fish:setindex(#fishTrace)
                        fish:setscene(fishTrace)
                        fish:setConvertPoint1(cc.p(fishTrace[1][1] * m_WScale, fishTrace[1][2] * m_HScale), fishTrace[1][3] * m_AScale)

                        self.m_fishLayer:addChild(fish, fish.m_data.fish_kind + 1)
                        self._dataModel.m_fishList[fish.fish_id] = fish
                    end
                    local num = #self._dataModel.m_fishList
                    --print("4 end")
                elseif FishComb.scene_kind == 4 then
                    self.s = 5
                    for i = 1, FishComb.fish_count do
                        local fishdef = { }
                        fishdef.fish_kind = FishComb.fish_kind[1][i]
                        fishdef.fish_id = FishComb.fish_id[1][i]
                        fishdef.cmd_version = -1

                        local fish = Fish:create(fishdef, self)
                        fish:initAnim1()
                        fish.Speed = 1.2
                        fish:setTag(fishdef.fish_id)
                        fish:setName(Game_CMD.FISH)

                        local fishTrace = { }
                        if i <= 51 then
                            fishTrace = PRELOAD.fishTrace5_1[i]
                        elseif i > 51 and i <= 102 then
                            fishTrace = PRELOAD.fishTrace5_2[i - 51]
                        elseif i > 102 and i <= 153 then
                            fishTrace = PRELOAD.fishTrace5_3[i - 102]
                        elseif i > 153 and i <= 193 then
                            fishTrace = PRELOAD.fishTrace5_4[i - 153]
                        elseif i > 193 and i <= 236 then
                            fishTrace = PRELOAD.fishTrace5_5[i - 193]
                        end
                        fish:setindex(#fishTrace)
                        fish:setscene(fishTrace)
                        fish:setConvertPoint1(cc.p(fishTrace[1][1] * m_WScale, fishTrace[1][2] * m_HScale), fishTrace[1][3] * m_AScale)

                        self.m_fishLayer:addChild(fish, fish.m_data.fish_kind + 1)
                        self._dataModel.m_fishList[fish.fish_id] = fish
                    end
                end
            end
        end )))
    end

    self._dataModel._exchangeSceneing = true

    local callfunc = cc.CallFunc:create( function()
        self._dataModel._exchangeSceneing = false
    end )

    if exchangeScene ~= nil then
        self._gameView:updteBackGround(exchangeScene, 5.5)
        self._dataModel:playEffect(Game_CMD.Change_Scene)
        self:runAction(cc.Sequence:create(cc.DelayTime:create(6), callfunc))
    end

end

--大三元
function GameLayer:big3yuan(Fishmore1, Fishmore2)
    local fish1 = Fish:create(Fishmore1, self)
    fish1:initAnim()
    fish1.offsetX = -65
    fish1.offsetY = 95
    fish1.bReal = false
    local fish2 = Fish:create(Fishmore2, self)
    fish2:initAnim()
    fish2.offsetX = -130
    fish2.offsetY = 0
    fish2.bReal = false
    for s = 1001, 1080 do
        if self._dataModel.m_fishList[fish1.fish_id + s] == nil then
            self.m_fishLayer:addChild(fish1, fish1.m_data.fish_kind + 1)
            self._dataModel.m_fishList[fish1.fish_id + s] = fish1
            break
        end
    end
    for s = 1002, 1080 do
        if self._dataModel.m_fishList[fish2.fish_id + s] == nil then
            self.m_fishLayer:addChild(fish2, fish2.m_data.fish_kind + 1)
            self._dataModel.m_fishList[fish2.fish_id + s] = fish2
            break
        end
    end
end

--大四喜
function GameLayer:big4happy(Fishmore1, Fishmore2, Fishmore3)
    local fish1 = Fish:create(Fishmore1, self)
    fish1:initAnim()
    fish1.offsetX = 0
    fish1.offsetY = 110
    fish1.bReal = false
    local fish2 = Fish:create(Fishmore2, self)
    fish2:initAnim()
    fish2.offsetX = -115
    fish2.offsetY = 0
    fish2.bReal = false
    local fish3 = Fish:create(Fishmore3, self)
    fish3:initAnim()
    fish3.offsetX = -115
    fish3.offsetY = 110
    fish3.bReal = false
    for s = 1001, 1080 do
        if self._dataModel.m_fishList[fish1.fish_id + s] == nil then
            self.m_fishLayer:addChild(fish1, fish1.m_data.fish_kind + 1)
            self._dataModel.m_fishList[fish1.fish_id + s] = fish1
            break
        end
    end
    for s = 1002, 1080 do
        if self._dataModel.m_fishList[fish2.fish_id + s] == nil then
            self.m_fishLayer:addChild(fish2, fish2.m_data.fish_kind + 1)
            self._dataModel.m_fishList[fish2.fish_id + s] = fish2
            break
        end
    end
    for s = 1003, 1080 do
        if self._dataModel.m_fishList[fish3.fish_id + s] == nil then
            self.m_fishLayer:addChild(fish3, fish3.m_data.fish_kind + 1)
            self._dataModel.m_fishList[fish3.fish_id + s] = fish3
            break
        end
    end
end

-- dyj1 (重写)(Fc++)
function GameLayer:onSubCreateMoreFishd(databuffer)
    local spFishWait = self:getChildByName("fish_wait")
    if spFishWait ~= nil then
        spFishWait:removeFromParent()
        spFishWait = nil
    end
    local count = math.floor(databuffer:getlen() / 57)
    self.iffishcomb = false
    if count >= 1 then
        for i = 1, count do
            local Fishmore = ExternalFun.read_netdata(Game_CMD.CMD_S_FishTrace, databuffer)
            
--            if Fishmore.fish_kind >= 40 then    --测试
--                break
--            end
--            Fishmore.fish_kind = 19
            -- 判断该类型鱼当前有几条
            local curCount = self.m_fishCurCount[Fishmore.fish_kind + 1]
            if curCount < self.m_fishLimitCount[Fishmore.fish_kind + 1] then
                -- 记录该类型鱼数量
                self.m_fishCurCount[Fishmore.fish_kind + 1] = self.m_fishCurCount[Fishmore.fish_kind + 1] + 1
                self.m_fishTotalCount = self.m_fishTotalCount + 1
                local Fishmore1 = clone(Fishmore)
                local fish = Fish:create(Fishmore, self)
                fish:initAnim()
                fish:setTag(fish.fish_id)
                fish:setName(Game_CMD.FISH)
                self.m_fishLayer:addChild(fish, fish.m_data.fish_kind + 1)
                self._dataModel.m_fishList[fish.fish_id] = fish
                if fish.lockType == 3 then
                    if fish.m_data.fish_kind == 4 or fish.m_data.fish_kind == 5 or fish.m_data.fish_kind == 7 then      --大三元
                        local Fishmore2 = clone(Fishmore1)
                        self:big3yuan(Fishmore1, Fishmore2)

                    elseif fish.m_data.fish_kind == 6 or fish.m_data.fish_kind == 8 or fish.m_data.fish_kind == 10 then --大四喜
                        local Fishmore2 = clone(Fishmore1)
                        local Fishmore3 = clone(Fishmore1)
                        self:big4happy(Fishmore1, Fishmore2, Fishmore3)
                        
                    end
                end
            else
                return
            end
        end
    end
end

function GameLayer:onBackScore(databuffer)

    local score = ExternalFun.read_netdata(Game_CMD.CMD_S_FishMissed, databuffer)

    local cannonPos = score.chair_id
    cannonPos = CannonSprite.getPos(self._dataModel.m_reversal, cannonPos)


    local cannon = self.m_cannonLayer:getCannoByPos(cannonPos + 1)


    if self.m_cannonLayer ~= nil then
        if score.chair_id == self.m_nChairID then
            self.ScoreCount = self.ScoreCount + score.bullet_mul
            if cannon ~= nil then
                self.m_cannonLayer:updateUpScore(self.ScoreCount, cannon.m_pos + 1)
            end
        else
            self._dataModel.m_secene.fish_score[1][score.chair_id + 1] = self._dataModel.m_secene.fish_score[1][score.chair_id + 1] + score.bullet_mul
            if cannon ~= nil then
                self.m_cannonLayer:updateUpScore(self._dataModel.m_secene.fish_score[1][score.chair_id + 1], cannon.m_pos + 1)
            end
        end
    end
end

-- dyj2

function GameLayer:onSubFire(databuffer)
    local fire = ExternalFun.read_netdata(Game_CMD.CMD_S_UserFire, databuffer)

    local cannonPos = fire.chair_id
    cannonPos = CannonSprite.getPos(self._dataModel.m_reversal, cannonPos)

    if fire.chair_id == self.m_nChairID then
        self._dataModel.m_lScoreCopy = self._dataModel.m_lScoreCopy - fire.bullet_mulriple
        return
    end


    if not self.m_cannonLayer then
        return
    end

    local cannon = self.m_cannonLayer:getCannoByPos(cannonPos + 1)
    if nil ~= cannon then
        cannon:othershoot(fire)
    end

    if nil ~= self.m_cannonLayer then
        if nil == cannon then
            return
        end

        if fire.chair_id ~= self.m_nChairID then
            self.CurrShoot[1][fire.chair_id + 1] = fire.bullet_mulriple
            cannon:setMultiple(fire.bullet_mulriple)
            self._dataModel.m_secene.fish_score[1][fire.chair_id + 1] = self._dataModel.m_secene.fish_score[1][fire.chair_id + 1] - fire.bullet_mulriple
	    self.m_cannonLayer:updateUpScore(self._dataModel.m_secene.fish_score[1][fire.chair_id + 1], cannon.m_pos + 1)
        else
            self._gameView:updateMultiple(fire.bullet_mulriple)
        end
    end

end

function GameLayer:onSubFishCatch(databuffer)

    local catchNum = math.floor(databuffer:getlen() / 27)
    --print("======= onSubFishCatch =======", databuffer:getlen())
    if catchNum >= 1 then
        for j = 1, catchNum do
            while true do
                local catchData = ExternalFun.read_netdata(Game_CMD.CMD_S_CaptureFish, databuffer)
                if not self.m_cannonLayer then
                    --
                else
                    local fish = self._dataModel.m_fishList[catchData.dwFishID]
                    if fish ~= nil and fish.m_data ~= nil and fish.m_data.fish_id == catchData.dwFishID then
                    else
                        for k, v in pairs(self._dataModel.m_fishList) do
                            if v.fish_id == catchData.dwFishID then
                                fish = v
                                break
                            end
                        end
                    end
                    if fish ~= nil and fish.m_data ~= nil and fish.m_data.fish_id == catchData.dwFishID then
                        -- 获取炮台视图位置
                        local cannonPos = catchData.wChairID
                        cannonPos = CannonSprite.getPos(self._dataModel.m_reversal, cannonPos)
                        local fishtype = 21
                        if nil ~= fish then
                            fishtype = fish.m_data.fish_kind
                        end

                        if nil ~= fish then

--                            if fish.m_data ~= nil and fish.m_data.fish_kind == Game_CMD.FishType_BaoXiang then  --打中宝箱

--                                break
--                            end

                            local smallSound = string.format("sound_res/samll_%d.wav", math.random(5))

                            if fish.m_data ~= nil and fish.m_data.fish_kind < Game_CMD.FISH_KING_MAX then
                                self._dataModel:playEffect(smallSound)
                            else
                                if fish.m_data ~= nil and fish.m_data.fish_kind >= 7 and fish.m_data.fish_kind <= 16 then
                                    local bigSound = string.format("sound_res/big_%d.wav", fish.m_data.fish_kind)
                                    self._dataModel:playEffect(bigSound)
                                end
                            end

                            local fishPos = cc.p(fish:getPositionX(), fish:getPositionY())
                            if self._dataModel.m_reversal then
                                fishPos = cc.p(yl.WIDTH - fishPos.x, yl.HEIGHT - fishPos.y)
                            end

                            if fish.m_data.fish_kind == Game_CMD.FishType_ZhongYiTang then
                                self.bFishStop = true
                                --定屏
                                self:stopScreen(fishPos)

                            elseif fish.m_data ~= nil and fish.m_data.fish_kind >= Game_CMD.FishType_DaJinSha and fish.m_data.fish_kind <= Game_CMD.FishType_LiKui then
                                --大鱼震动
                                self:shockScreen()
                                --气泡
                                self:bigFishBubble(fishPos)
                            end

                            -- 鱼死亡处理
                            if fish.lockType == 3 then
                                --气泡
                                self:bigFishBubble(fishPos)
                                for k, v in pairs(self._dataModel.m_fishList) do
                                    if v.fish_id == catchData.dwFishID then
                                        v.ifdie = true
                                        v:deadDeal()
                                    end
                                end
                            else
                                fish.ifdie = true
                                fish:deadDeal()
                            end
                            -- 游戏币动画
                            self._gameView:ShowCoin(catchData.lFishScore, catchData.wChairID, fishPos, fishtype)
                        end
                    end
                end
                break
            end
        end
    end
end


-- 银行 
function GameLayer:onSocketInsureEvent(sub, dataBuffer)
    --print(sub)

    self:dismissPopWait()

    if sub == g_var(game_cmd).SUB_GR_USER_INSURE_SUCCESS then
        local cmd_table = ExternalFun.read_netdata(g_var(game_cmd).CMD_GR_S_UserInsureSuccess, dataBuffer)
        self.bank_success = cmd_table

        self._gameView:onBankSuccess()

    elseif sub == g_var(game_cmd).SUB_GR_USER_INSURE_FAILURE then

        local cmd_table = ExternalFun.read_netdata(g_var(game_cmd).CMD_GR_S_UserInsureFailure, dataBuffer)
        self.bank_fail = cmd_table

        self._gameView:onBankFailure()
    else
        --print("unknow gamemessage sub is ==>" .. sub)
    end
end


--退出桌子
function GameLayer:onExitTable()
	local MeItem = self:GetMeUserItem()
	if MeItem and MeItem.cbUserStatus > yl.US_FREE then
		--self:showPopWait()
        --self:sendCancelOccupy()
		self._gameFrame:StandUp(1)
        self:onExitRoom()

--		self:runAction(cc.Sequence:create(
--			cc.DelayTime:create(2),
--			cc.CallFunc:create(
--				function ()
--					self:sendCancelOccupy()
--					self._gameFrame:StandUp(1)
--                    self:onExitRoom()
--				end
--				),
--			cc.DelayTime:create(10),
--			cc.CallFunc:create(
--				function ()
--					self:onExitRoom()
--				end
--				)
--			)
--		)
		return
	end
	self:onExitRoom()
end

--离开房间
function GameLayer:onExitRoom()
	self._gameFrame:onCloseSocket()
	self:KillGameClock()
	AppFacade:getInstance():sendNotification(GAME_COMMAMD.POP_VIEW, {Name = VIEW_LIST.GAME_LAYER})
    self.m_bLeaveGame = true 
end

function GameLayer:onKeyBack()
    if nil == PRELOAD.loadingBar then
       self:onQueryExitGame()
    else

        self:runAction(cc.Sequence:create(
        cc.DelayTime:create(delayLeaveTime),
        cc.CallFunc:create(
        function()
            self._m_bLeaveGame = true
            self._gameView:StopLoading(false)
            self._gameFrame:StandUp(1)
        end
        ),
        cc.DelayTime:create(exit_timeOut),
        cc.CallFunc:create(
        function()
            -- 强制离开游戏(针对长时间收不到服务器消息的情况)
            --print("delay leave")
            self:onExitRoom()
        end
        )
        )
        )
    end
    return true
end


function GameLayer:getDataMgr()
    return self._dataModel;
end

function GameLayer:sendNetData(cmddata)
    return self._gameFrame:sendSocketData(cmddata);
end


 

--屏幕震动
function GameLayer:shockScreen()
    local a1 = cc.MoveBy:create(0.03, cc.p(-16, 0))
	local a2 = cc.MoveBy:create(0.03, cc.p(0, -16))
	local a3 = cc.MoveBy:create(0.03, cc.p(16, 0))
	local a4 = cc.MoveBy:create(0.03, cc.p(0, 16))
	local action = cc.Repeat:create(cc.Sequence:create(a1, a2, a3, a4), 8)
	self.m_fishLayer:runAction(action)
end

--定屏
function GameLayer:stopScreen(pos)

    local praticle = cc.ParticleSystemQuad:create("particle/particle_stopscreen.plist")
    praticle:setPosition(pos)
    praticle:setPositionType(cc.POSITION_TYPE_GROUPED)
    self:addChild(praticle, 10)
    praticle:setAutoRemoveOnFinish(true)

    local maskBlue = cc.Sprite:create("game_res/maskBlue.png")
    maskBlue:setPosition(pos)
    maskBlue:setScale(0.1)
    maskBlue:setOpacity(180)
    self:addChild(maskBlue, 7)
    maskBlue:setName("maskBlue")
    maskBlue:runAction(cc.ScaleTo:create(2, 7))
end

--大鱼气泡
function GameLayer:bigFishBubble(pos)
    local praticle = cc.ParticleSystemQuad:create("particle/particle_bubbleyellow.plist")
    praticle:setPosition(pos)
    praticle:setPositionType(cc.POSITION_TYPE_GROUPED)
    self:addChild(praticle, 10)
    praticle:setAutoRemoveOnFinish(true)

    praticle = cc.ParticleSystemQuad:create("particle/particle_bigfish.plist")
    praticle:setPosition(pos)
    praticle:setPositionType(cc.POSITION_TYPE_GROUPED)
    self:addChild(praticle, 10)
    praticle:setAutoRemoveOnFinish(true)
end

--鱼王气泡
function GameLayer:fishKingBubble(pos)
    local praticle = cc.ParticleSystemQuad:create("particle/particle_fishking.plist")
    praticle:setPosition(pos)
    praticle:setPositionType(cc.POSITION_TYPE_GROUPED)
    self:addChild(praticle, 10)
    praticle:setAutoRemoveOnFinish(true)
end

return GameLayer