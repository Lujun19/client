local GameModel = appdf.req(appdf.CLIENT_SRC.."gamemodel.GameModel")
local GameLayer = class("GameLayer", GameModel)

--local Game2Layer = class("Game2Layer", GameModel)

local module_pre = "game.xiuxian.shuiguolaba.src";
require("cocos.init")
local ExternalFun =  appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local cmd = module_pre .. ".models.CMD_Game"

local GameViewLayer = appdf.req(module_pre .. ".views.layer.GameViewLayer")

local g_var = ExternalFun.req_var
local GameLogic = appdf.req(module_pre .. ".models.GameLogic")
--local GameFrame = appdf.req(module_pre .. ".models.GameFrame")

local emGameState =
{
    "GAME_STATE_WAITTING",              --等待
    "GAME_STATE_WAITTING_RESPONSE",     --等待服务器响应
    "GAME_STATE_MOVING",                --转动
    "GAME_STATE_RESULT",                --结算
    "GAME_STATE_WAITTING_GAME2",        --等待游戏2
    "GAME_STATE_END"                    --结束
}
local GAME_STATE = ExternalFun.declarEnumWithTable(0, emGameState)


--获取gamekind
function GameLayer:getGameKind()
    return g_var(cmd).KIND_ID
end

function GameLayer:ctor( frameEngine,scene )

    ExternalFun.registerNodeEvent(self)

    self.m_bLeaveGame = false

    GameLayer.super.ctor(self,frameEngine,scene)

    --self._gameFrame:QueryUserInfo( self:GetMeUserItem().wTableID,yl.INVALID_CHAIR)

    self:addAnimationEvent()  --监听加载完动画的事件
end

--创建场景
function GameLayer:CreateView()
     self._gameView = GameViewLayer[1]:create(self)
     self:addChild(self._gameView,0,2001)
     return self._gameView


end

function GameLayer:OnInitGameEngine()
    GameLayer.super.OnInitGameEngine(self)

    self._cardnum               = 0       --中奖记录
    self.m_bIsLeave             = false     --是否离开游戏
    self.m_bIsPlayed            = false       --是否玩过游戏
    self.m_cbGameStatus         = 0         --游戏状态

    self.m_cbGameMode           = 0         --游戏模式

    --游戏逻辑操作
    self.m_bIsItemMove          = false     --动画是否滚动的标示
    self.m_lCoins               = 0         --金币
    self.m_lYaxian              = 1        --压线
    self.m_lYafen               = 1         --压分
    self.m_lTotalYafen          = 0         --总压分
    self.m_lGetCoins            = 0         --获得金钱

    self.m_bEnterGame3          = false     --是否小玛丽
    self.m_bEnterGame2          = true     --是否比倍
    self.m_bYafenIndex          = 1         --压分索引（数组索引）
    self.m_lBetScore            = {{0,0,0,0,0},{0,0,0,0,0},{0,0,0,0,0}}          --压分存储数组

    self.m_cbItemInfo           = {{0,0,0,0,0},{0,0,0,0,0},{0,0,0,0,0}}          --开奖信息

    --中奖位置
    self.m_ptZhongJiang = {}
    for i=1,GameLogic.ITEM_COUNT do
        self.m_ptZhongJiang[i] = {}
        for j=1,GameLogic.ITEM_X_COUNT do
            self.m_ptZhongJiang[i][j] = {}
            self.m_ptZhongJiang[i][j].x = 0
            self.m_ptZhongJiang[i][j].y = 0
        end
    end

    self.m_UserActionYaxian     = {}           --用户压线的情况

    self.m_bIsAuto              = false        --控制自动开始按钮
    --self.m_bYafenIndexNow       = 0         --发送服务器时的压分索引
    self.m_bIsAuto                 = false        --控制自动开始按钮
    self.m_bReConnect1             = false
    self.m_bReConnect2             = false
    self.m_bReConnect3             = false

    self.tagActionOneKaiJian = {}
    self.tagActionOneKaiJian.nCurIndex = 0
    self.tagActionOneKaiJian.nMaxIndex = 0
    self.tagActionOneKaiJian.lScore = 0
    self.tagActionOneKaiJian.lQuanPanScore = 0
    self.tagActionOneKaiJian.cbGameMode = 0
    self.tagActionOneKaiJian.bZhongJiang = {}
    for i=1, GameLogic.ITEM_Y_COUNT do
        self.tagActionOneKaiJian.bZhongJiang[i] = {}
        for j=1,GameLogic.ITEM_X_COUNT do
             self.tagActionOneKaiJian.bZhongJiang[i][j] = false
        end
    end

    --游戏2结果
    self.m_pGame2Result = {}
    self.m_pGame2Result.cbOpenSize = {0,0}
    self.m_pGame2Result.lScore = 0
end

function GameLayer:ResetAction( )
     self.tagActionOneKaiJian.nCurIndex = 0
     self.tagActionOneKaiJian.nMaxIndex = 0
     self.tagActionOneKaiJian.lScore = 0
     self.tagActionOneKaiJian.lQuanPanScore = 0
     self.tagActionOneKaiJian.cbGameMode = 0
     self.tagActionOneKaiJian.bZhongJiang = {}
     for i=1, GameLogic.ITEM_Y_COUNT do
         self.tagActionOneKaiJian.bZhongJiang[i] = {}
         for j=1,GameLogic.ITEM_X_COUNT do
             self.tagActionOneKaiJian.bZhongJiang[i][j] = false
         end
     end
end

function GameLayer:resetData()
    --GameLayer.super.resetData(self)

    self.m_cbGameStatus         = 0         --游戏状态

    self.m_cbGameMode           = 0         --游戏模式

    --游戏逻辑操作
    self.m_bIsItemMove          = false     --动画是否滚动的标示
    self.m_lCoins               = 0         --金币
    self.m_lYaxian              = 1         --压线
    self.m_lYafen               = self.m_lBetScore[self.m_bYafenIndex]        --压分
    self.m_lTotalYafen          = self.m_lBetScore[self.m_bYafenIndex]*self.m_lYaxian         --总压分
    self.m_lGetCoins            = 0         --获得金钱

    self.m_bEnterGame3          = false     --是否小玛丽
    self.m_bEnterGame2          = false     --是否比倍
    self.m_bYafenIndex          = 1         --压分索引（数组索引）
    self.m_lBetScore            = {{0,0,0,0,0},{0,0,0,0,0},{0,0,0,0,0}}         --压分存储数组
    self.m_cbItemInfo           = {{0,0,0,0,0},{0,0,0,0,0},{0,0,0,0,0}}         --开奖信息
    --self.m_ptZhongJiang         = {{},{},{}}         
    --中奖位置
    self.m_ptZhongJiang = {}
    for i=1,GameLogic.ITEM_COUNT do
        self.m_ptZhongJiang[i] = {}
        for j=1,5 do
            self.m_ptZhongJiang[i][j] = {}
            self.m_ptZhongJiang[i][j].x = 0
            self.m_ptZhongJiang[i][j].y = 0
        end
    end

    self.m_bIsAuto                 = false        --控制自动开始按钮
    self.m_bReConnect1             = false
    self.m_bReConnect2             = false
    self.m_bReConnect3             = false
    --游戏2结果
    self.m_pGame2Result = {}
    self.m_pGame2Result.cbOpenSize = {0,0}
    self.m_pGame2Result.lScore = 0
end

-- 重置游戏数据
function GameLayer:OnResetGameEngine()

    local useritem = self:GetMeUserItem()
       if ( useritem.cbUserStatus == yl.US_PLAYING and self.m_cbGameStatus == 101) then--g_var(cmd).SHZ_GAME_SCENE_FREE 
        print("游戏1断线重连")
        self.m_bReConnect1 = true

    elseif self.m_cbGameStatus == 103  then--g_var(cmd).g_var(cmd).SHZ_GAME_SCENE_THREE 
        print("游戏3断线重连")
        self.m_bReConnect3 = true
    end

end

function GameLayer:addAnimationEvent()
   --通知监听
  local function eventListener(event)
    cc.Director:getInstance():getEventDispatcher():removeCustomEventListeners(g_var(cmd).Event_LoadingFinish)
    --self._gameView:initMainView()
    if self._gameView then
        self:SendUserReady()
    end
  end

  local listener = cc.EventListenerCustom:create(g_var(cmd).Event_LoadingFinish, eventListener)
  cc.Director:getInstance():getEventDispatcher():addEventListenerWithFixedPriority(listener, 1)
end
--------------------------------------------------------------------------------------
function GameLayer:onExit()
    self:KillGameClock()
    self:dismissPopWait()
end


--退出房间
function GameLayer:onExitRoom()
    print("退出房间")
    --发送退出消息
    local MeItem = self:GetMeUserItem()
    if MeItem and  MeItem.lScore < 90  then--and  MeItem.cbUserStatus > yl.US_FREE
        local seq = cc.Sequence:create(
            cc.CallFunc:create(function ( )
                ExternalFun.dismissTouchFilter()
                ExternalFun.popupTouchFilter(2, false)
                showToast(self, "提醒：游戏币不足", 2)
                --self._gameFrame:StandUp(1)
            end),
       --     cc.DelayTime:create(2),
            cc.CallFunc:create(function (  )
                ExternalFun.dismissTouchFilter()
                self._gameFrame:onCloseSocket()
                self:stopAllActions()
                self:KillGameClock()
                self:dismissPopWait()
                  -- self._scene:onChangeShowMode(yl.SCENE_ROOMLIST)
                   AppFacade:getInstance():sendNotification(GAME_COMMAMD.POP_VIEW, {Name = VIEW_LIST.GAME_LAYER})

        end))
        self:runAction(seq)
    else
        self._gameFrame:onCloseSocket()
        self:stopAllActions()
        self:KillGameClock()
        self:dismissPopWait()
       -- self._scene:onChangeShowMode(yl.SCENE_ROOMLIST)
       AppFacade:getInstance():sendNotification(GAME_COMMAMD.POP_VIEW, {Name = VIEW_LIST.GAME_LAYER})
    end
    AudioEngine.stopMusic()
    ExternalFun.playPlazzBackgroudAudio()
end

--退出桌子
function GameLayer:onExitTable()
    print("退出桌子")
    self:KillGameClock()
    local MeItem = self:GetMeUserItem()
     if self.m_bIsLeave == true and  MeItem.cbUserStatus > yl.US_FREE then --MeItem.lScore <= 0 and
            local seq = cc.Sequence:create(
                cc.CallFunc:create(
                    function ()   
                        self:showPopWait()
                        if not self.m_bIsPlayed then
                            --结束游戏1消息
                            self:sendEndGame1Msg()
                        end
                    end),
             --   cc.DelayTime:create(1),
                cc.CallFunc:create(function ( )
                    self._gameFrame:StandUp(1)
                end),
          --      cc.DelayTime:create(1),
                cc.CallFunc:create(function (  )
                    self:onExitRoom()
            end)
            )
            self:runAction(seq)
            return

    elseif  self.m_bIsLeave == false and MeItem.cbUserStatus == yl.US_FREE and MeItem.lScore > 90 then
        local seq = cc.Sequence:create(
            cc.CallFunc:create(
                function ()   
                    --self:showPopWait()
                    ExternalFun.popupTouchFilter(2, false)
                    showToast(self, "提醒：长时间未操作", 2)
                end),
         --   cc.DelayTime:create(2),
            cc.CallFunc:create(function ( )
                --self._gameFrame:StandUp(1)
                ExternalFun.dismissTouchFilter()
                self:onExitRoom()
            end)
        )
        self:runAction(seq)
        return
    end
   self:onExitRoom()
end

-- -------------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------------场景消息

-- -- 场景信息
function GameLayer:onEventGameScene(cbGameStatus,dataBuffer)
    if cbGameStatus == 100 then
        print("aaa")
    end
    print("场景数据:" .. cbGameStatus)
    --self._gameView:removeAction()
    self:KillGameClock()
--[[
    self.temp1 = {}
    local num = 0
      for i = 1, 100 do
      local temp = math.random(1,100)  
      local b_bool = 1
        for j = 1, 100 do
         if self.temp1[j] == temp  then
           b_bool = 0
           break
         end
       end
       self.temp1[i] = temp  
       if b_bool == 1 then
       local userItem = self._gameFrame:getTableUserItem(temp-1, 0)
         if nil ~= userItem then
           if userItem.dwUserID ~= GlobalUserItem.dwUserID then
                num = num + 1
                if  num > 5 then
                   break
                end
                self._gameView:OnUpdateUser(num, userItem)

                if PriRoom then
                    PriRoom:getInstance():onEventUserState(wViewChairId, userItem, false)
                end
            end
          end
       end
    end

  --]]

    self._gameView.m_cbGameStatus = cbGameStatus;
	if cbGameStatus == g_var(cmd).SHZ_GAME_SCENE_FREE	then                        --空闲状态
        self:onEventGameSceneFree(dataBuffer);
	elseif cbGameStatus == g_var(cmd).SHZ_GAME_SCENE_ONE 	then                      
        self:onEventGameSceneStatus(dataBuffer);
	elseif cbGameStatus == g_var(cmd).SHZ_GAME_SCENE_TWO	then               
        self:onEventGame2SceneStatus(dataBuffer);
    elseif cbGameStatus == g_var(cmd).SHZ_GAME_SCENE_THREE    then                         
        --self:onEventGameSceneStatus(dataBuffer);
	end
    self:dismissPopWait()
end

function GameLayer:onEventGameSceneFree(buffer)    --空闲 
    local cmd_table = ExternalFun.read_netdata(g_var(cmd).SHZ_CMD_S_StatusFree, buffer)
    --初始化数据
    --押分
    self.m_bMaxNum = cmd_table.cbBetCount
    self.m_lYafen = cmd_table.lCellScore
    --压线
    self.m_bXMaxNum = cmd_table.cbBetLine
      --奖池奖金
    self.m_bonus =cmd_table.bonus

    self.m_lCoins = self:GetMeUserItem().lScore



    self.m_lBetScore = GameLogic:copyTab(cmd_table.lBetScore[1])
    self.m_lTotalYafen = self.m_lBetScore[self.m_bYafenIndex]*self.m_lYaxian
    --self.m_lTotalYafen = self.m_lBetScore[self.m_bYafenIndex]*self.m_lYafen*self.m_lYaxian
    --
    self._gameView.m_textYaxian:setString(self.m_lYaxian)

    self._gameView.m_textYafen:setString(tostring(self.m_lBetScore[self.m_bYafenIndex]))
    --总压分  Text_allyafen
    self._gameView.m_textAllyafen:setString(tostring(self.m_lTotalYafen))
    --奖池奖金
    self._gameView.m_bonus:setString(self.m_bonus)

end

--断线重连
function GameLayer:onEventGameSceneStatus(cbGameStatus,dataBuffer)   
    --local cmd_table = ExternalFun.read_netdata(g_var(cmd).CMD_S_StatusPlay, buffer)
    print("···游戏1 ====================== >")

end

function GameLayer:onEventGame2SceneStatus(buffer)   
    --local cmd_table = ExternalFun.read_netdata(g_var(cmd).CMD_S_StatusPlay, buffer)
    print("···游戏2 ====================== >")

end


-----------------------------------------------------------------------------------
-- 游戏消息
function GameLayer:onEventGameMessage(sub,dataBuffer)
    if sub == g_var(cmd).SUB_S_GAME_START then 
        --print("watermargin 游戏开始")
        self:onGame1Start(dataBuffer)                       --游戏开始
    elseif sub == g_var(cmd).SUB_S_GAME_CONCLUDE then 
        --print("watermargin 压线结束")
        self:onSubGame1End(dataBuffer)                      --压线结束
    elseif sub == g_var(cmd).SUB_S_THREE_START then         --小游戏 翻牌开始
        --print("watermargin 小游戏开始")
        self:onGame2Start(dataBuffer)
    elseif sub == g_var(cmd).SUB_S_GAME_RECORD then      --中奖记录
        self:onRecord(dataBuffer)
    else
        print("unknow gamemessage sub is "..sub)
    end
end



--游戏1开始
function GameLayer:onGame1Start(dataBuffer) --游戏开始
    print("GameLayer -------游戏开始------")
    self._gameView.m_textScore:setString(self.m_lCoins)
    local cmd_table = ExternalFun.read_netdata(g_var(cmd).SHZ_CMD_S_GameStart, dataBuffer)

    --奖池奖金
    self._gameView.m_bonus:setString(cmd_table.cbbonus)

    self.m_lGetCoins = cmd_table.lScore --中奖的分数
    --进入小玛丽
    if g_var(cmd).GM_THREE == cmd_table.cbGameMode then    ---这里可以更改成那个小游戏 然后做一个判断如何进入
        self.m_bEnterGame3 = true
    else
        self.m_bEnterGame3 = false
    end

    self.m_cbItemInfo = {{0,0,0,0,0},{0,0,0,0,0},{0,0,0,0,0}} 
    self.m_cbItemInfo = GameLogic:copyTab(cmd_table.cbItemInfo)
--    self.m_cbItemInfo = {{1,1,1,1,1},{2,2,2,2,2},{1,1,1,1,1}}

    --检验是否中奖
--    if self.m_lYaxian == 9 then
    GameLogic:GetAllZhongJiangInfo(self.m_cbItemInfo,self.m_ptZhongJiang)
--    end
    self._BonusNum = 0
    for i = 1, 3 do
       for j = 1, 5 do
        if self.m_cbItemInfo[i][j] == 8 then
           self._BonusNum = self._BonusNum+1
          end
        end
    end

    --改变状态
    self.m_cbGameStatus = g_var(cmd).SHZ_GAME_SCENE_ONE

    if self.m_lGetCoins > 0 then
        --清空数组

        self.m_UserActionYaxian = {}
        --获取中奖信息，压线和中奖结果
        for i=1,self.m_lYaxian do

            if GameLogic:getZhongJiangInfo(i,self.m_cbItemInfo,self.m_ptZhongJiang) ~= 0 then
                local pActionOneYaXian = {}
                pActionOneYaXian.nZhongJiangXian = i
                pActionOneYaXian.lXianScore = GameLogic:GetZhongJiangTime(i,self.m_cbItemInfo)*self.m_lYafen*self.m_lBetScore[self.m_bYafenIndex]
                pActionOneYaXian.lScore = self.m_lGetCoins
                pActionOneYaXian.ptXian = self.m_ptZhongJiang[pActionOneYaXian.nZhongJiangXian]
                self.m_UserActionYaxian[#self.m_UserActionYaxian+1] = pActionOneYaXian
            end
        end
        self:ResetAction()
        self.tagActionOneKaiJian.nCurIndex = 0
        self.tagActionOneKaiJian.nMaxIndex = 0
        self.tagActionOneKaiJian.cbGameMode = cmd_table.cbGameMode
        self.tagActionOneKaiJian.lQuanPanScore = cmd_table.lScore
        self.tagActionOneKaiJian.lScore = cmd_table.lScore
        if GameLogic:GetQuanPanJiangTime(self.m_cbItemInfo) ~= 0 then
            for i=1,GameLogic.ITEM_Y_COUNT do
                for j=1,GameLogic.ITEM_X_COUNT do
                    self.tagActionOneKaiJian.bZhongJiang[i][j] = true
                end
            end
        else
            for i=1,self.m_lYaxian do               
                for j=1,GameLogic.ITEM_X_COUNT do
                    if self.m_ptZhongJiang[i][j].x ~= 0xff then
  --                      self.tagActionOneKaiJian.bZhongJiang[1][1] = true     --有问题 待修改   
                        self.tagActionOneKaiJian.bZhongJiang[self.m_ptZhongJiang[i][j].x][self.m_ptZhongJiang[i][j].y] = true
                    end
                end
            end
        end
    end
    self.m_bIsItemMove = true   --上面进行判断是否中奖 之后执行动画
     
    self._gameView:game1Begin()
    --  拉杆动画  如果有需求再更改  自动的话也是每次都需要开始候调用一次
   
    self._gameView:updateStartButtonState(true)
    ExternalFun.playSoundEffect("state.wav")
end
--游戏结束
function GameLayer:onSubGame1End( dataBuffer )
    print("GameLayer -------游戏1结束------")

   print( self.m_cbGameStatus )
    if self.m_lTotalYafen > self.m_lCoins + self.m_lGetCoins then
        --提示游戏币不足
        showToast(self, "提醒：游戏币不足", 1)
        self.m_bIsAuto = false
        self._gameView:setAutoStart(false)
    else
        if self.m_bIsAuto == true then
            self._gameView.m_textScore:setString(self.m_lCoins)   --self.m_lCoins
            self:addUserScore(self.m_lGetCoins)
            if  (self:getGameMode() == GAME_STATE.GAME_STATE_END) then--and (self:getGameMode() == GAME_STATE.GAME_STATE_WAITTING_GAME2  or (self:getGameMode() == GAME_STATE.GAME_STATE_WAITTING) or (self:getGameMode() == GAME_STATE.GAME_STATE_END))  then
                self._gameView:stopAllActions()
                local useritem = self:GetMeUserItem()

                if useritem.cbUserStatus ~= yl.US_READY then --self.m_bIsPlayed == true and 
                    self:SendUserReady()
                end
                --发送准备消息
                self:sendReadyMsg()

                self.m_cbGameStatus = g_var(cmd).SHZ_GAME_SCENE_FREE
                self:setGameMode(1)
            end
        end
    end
    if self.m_bIsAuto == true then
        self._gameView:setBtnEnabled(false)
    else
        self._gameView:setBtnEnabled(true)
    end
     self._gameView.m_textScore:setString(self.m_lCoins)   --self.m_lCoins
     self:addUserScore(self.m_lGetCoins)
    self.flage=1
end
--事件处理
function GameLayer:setGameMode( state )
    if state == 0 then
        self.m_cbGameMode = GAME_STATE.GAME_STATE_WAITTING  --等待
    elseif state == 1 then
        self.m_cbGameMode = GAME_STATE.GAME_STATE_WAITTING_RESPONSE --等待服务器响应
    elseif state == 2 then
        self.m_cbGameMode = GAME_STATE.GAME_STATE_MOVING --转动
    elseif state == 3 then
        self.m_cbGameMode = GAME_STATE.GAME_STATE_RESULT --结算
    elseif state == 4 then
        self.m_cbGameMode = GAME_STATE.GAME_STATE_WAITTING_GAME2 --等待游戏2
    elseif state == 5 then
        self.m_cbGameMode = GAME_STATE.GAME_STATE_END  --结束
    else
        print("未知状态")
    end
     --self.m_cbGameMode = GAME_STATE[state]
end

--获取游戏状态
function GameLayer:getGameMode()
    if self.m_cbGameMode then
        return self.m_cbGameMode
    end
end

--游戏开始
function GameLayer:onGameStart()
   --self._gameView:game1Begin()
   self:refreshScore()
    local useritem = self:GetMeUserItem()
     self._gameView.m_textScore:setString(self.m_lCoins)
     --   self._gameView:onHideTopMenu()
    --自动开始
    print("ljb ---onGameStart---,self:getGameMode()",self:getGameMode())
    if self.m_bIsAuto == true then
        if self:getGameMode() == GAME_STATE.GAME_STATE_MOVING then
            self._gameView:game1End()
             self._gameView.m_textScore:setString(self.m_lCoins)
            --return
        elseif self:getGameMode() == GAME_STATE.GAME_STATE_WAITTING_GAME2  then
            print("游戏开始")

            self.m_bIsPlayed = true
            self._gameView:stopAllActions()

             if self.m_lTotalYafen > self.m_lCoins + self.m_lGetCoins then
                --提示游戏币不足0
                showToast(self, "提醒：游戏币不足", 1)
                return
            end
            self:SendUserReady()
            --发送准备消息
            self:sendReadyMsg()
            self.m_cbGameStatus = g_var(cmd).SHZ_GAME_SCENE_FREE
            self:setGameMode(1)
            --return 
        else
            --return
        end
    end
    --开始
   --    print("游戏开始*******************************************************************************")
   -- -- if self:getGameMode() == GAME_STATE.GAME_STATE_MOVING then
   --  if self.flage==1 then
   --        print("游戏暂停GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG*******************************************************************************")
   --      self._gameView:game1End()
   --      self.flage=0
   --       self._gameView.m_textScore:setString(self.m_lCoins)
    --elseif  self.m_bIsItemMove == false and  (self:getGameMode() == GAME_STATE.GAME_STATE_WAITTING_GAME2) or (self:getGameMode() == GAME_STATE.GAME_STATE_WAITTING) or (self:getGameMode() == GAME_STATE.GAME_STATE_END) then
    if  (self:getGameMode() == GAME_STATE.GAME_STATE_WAITTING) or (self:getGameMode() == GAME_STATE.GAME_STATE_END) then


        if self.m_lTotalYafen > self.m_lCoins + self.m_lGetCoins then
            --提示游戏币不足
            showToast(self, "提醒：游戏币不足", 1)
            return
        end
        self.m_bIsPlayed = true
        self._gameView:stopAllActions()

        self:SendUserReady()
        --发送准备消息
        self:sendReadyMsg()
        self.m_cbGameStatus = g_var(cmd).SHZ_GAME_SCENE_FREE
        self:setGameMode(1)
    end
end

--自动游戏
function GameLayer:onAutoStart( )
 --   self._gameView:onHideTopMenu()

    --判断金钱是否够自动开始
    if self.m_bIsAuto == true then
        self.m_bIsAuto = false
        self._gameView:setAutoStart(false)
    else
        self.m_bIsAuto = true
        if self.m_lTotalYafen > self.m_lCoins + self.m_lGetCoins then
            --提示游戏币不足
            showToast(self, "提醒：游戏币不足", 1)
            self.m_bIsAuto = false
            self._gameView:setAutoStart(false)
            return
        end
        self._gameView:setAutoStart(true)  --切换纹理勾选
        if  self.m_bIsItemMove == false  then--and (self:getGameMode() == GAME_STATE.GAME_STATE_WAITTING_GAME2  or (self:getGameMode() == GAME_STATE.GAME_STATE_WAITTING) or (self:getGameMode() == GAME_STATE.GAME_STATE_END))  then
            self._gameView:stopAllActions()
            
            self.m_bIsPlayed = true
            local useritem = self:GetMeUserItem()
            if useritem.cbUserStatus ~= yl.US_READY then
                self:SendUserReady()
            end
            --发送准备消息
            self:sendReadyMsg()
            self.m_cbGameStatus = g_var(cmd).SHZ_GAME_SCENE_FREE
            self:setGameMode(1) --"GAME_STATE_WAITTING_RESPONSE",     --等待服务器响应
        end
    end
end


--最大加注
function GameLayer:onAddMaxScore()

 --   self._gameView:onHideTopMenu()

    self.m_bYafenIndex = self.m_bMaxNum 
    self.m_lTotalYafen = self.m_lBetScore[self.m_bYafenIndex]*self.m_lYaxian
    --压分
    self._gameView.m_textYafen:setString(self.m_lBetScore[self.m_bYafenIndex])
    --总压分
    self._gameView.m_textAllyafen:setString(self.m_lTotalYafen)

end
-- 最大压线
function GameLayer:onAddMaxThread()
 --   self._gameView:onHideTopMenu()
    self.m_lYaxian =  9
    self.m_lTotalYafen = self.m_lBetScore[self.m_bYafenIndex]*self.m_lYaxian
    --压线
    self._gameView.m_textYaxian:setString(self.m_lYaxian)
    --总压分
    self._gameView.m_textAllyafen:setString(self.m_lTotalYafen)
end
--最小加注  --重置   押注改成最小 压线也改成最小
function GameLayer:onAddMinScore( )
 --   self._gameView:onHideTopMenu()
    self.m_bYafenIndex = 1
    self.m_lYaxian =1
    self.m_lTotalYafen = self.m_lBetScore[self.m_bYafenIndex]*self.m_lYaxian
    --压分
    self._gameView.m_textYafen:setString(self.m_lBetScore[self.m_bYafenIndex])
    --压线
    self._gameView.m_textYaxian:setString(self.m_bYafenIndex)
    --总压分
    self._gameView.m_textAllyafen:setString(self.m_lTotalYafen)

end
--加注
function GameLayer:onAddScore()
  --  self._gameView:onHideTopMenu()
    if self.m_bYafenIndex < self.m_bMaxNum then
        self.m_bYafenIndex = self.m_bYafenIndex + 1
    else
        self.m_bYafenIndex = self.m_bMaxNum  -- self.m_bMaxNum   --这个是服务器传过来的
    end
    self.m_lTotalYafen = self.m_lBetScore[self.m_bYafenIndex]*self.m_lYaxian

    --压分
    self._gameView.m_textYafen:setString(self.m_lBetScore[self.m_bYafenIndex])
    --总压分
    self._gameView.m_textAllyafen:setString(self.m_lTotalYafen)
end
--减注
function GameLayer:onSubScore()
 --   self._gameView:onHideTopMenu()
    if self.m_bYafenIndex > 1  then
        self.m_bYafenIndex = self.m_bYafenIndex - 1
    else
        self.m_bYafenIndex = 1
    end
    self.m_lTotalYafen = self.m_lBetScore[self.m_bYafenIndex]*self.m_lYaxian

    --压分
    self._gameView.m_textYafen:setString(self.m_lBetScore[self.m_bYafenIndex])
    --总压分
    self._gameView.m_textAllyafen:setString(self.m_lTotalYafen)
end
--加线
function GameLayer:onAddThread()
    if self.m_lYaxian < self.m_bMaxNum then
        self.m_lYaxian =self.m_lYaxian + 1
    else
        self.m_lYaxian = self.m_bMaxNum
    end
    self.m_lTotalYafen = self.m_lBetScore [self.m_bYafenIndex]*self.m_lYaxian

    --压线
    self._gameView.m_textYaxian:setString(self.m_lYaxian)
    --总压分
    self._gameView.m_textAllyafen:setString(self.m_lTotalYafen)
end
--减线
function GameLayer:onSubThread()
    if self.m_lYaxian > 1 then
        self.m_lYaxian =self.m_lYaxian - 1
    else
        self.m_lYaxian = 1
    end
    self.m_lTotalYafen = self.m_lBetScore [self.m_bYafenIndex]*self.m_lYaxian

    --压线
    self._gameView.m_textYaxian:setString(self.m_lYaxian)
    --总压分
    self._gameView.m_textAllyafen:setString(self.m_lTotalYafen)
end

--发送准备消息
function GameLayer:sendReadyMsg()
    print("发送准备消息成功")
    local  dataBuffer = CCmd_Data:create(16)
    print("elf.m_bYafenIndex="..self.m_bYafenIndex)
    print("elf.m_lYaxian="..self.m_lYaxian)

    dataBuffer:pushscore(self.m_lYaxian)
    dataBuffer:pushscore(self.m_bYafenIndex)

    self:SendData(g_var(cmd).SHZ_SUB_C_ONE_START, dataBuffer)

    --释放线条
   for i =1,#self.m_UserActionYaxian do
       if self._gameView.sprLine1[i] ~= nil then
          self._gameView.sprLine1[i]:runAction(
          cc.Hide:create())
       end
    end

   if self.m_lGetCoins and self.m_lGetCoins > 0 then
 --       ExternalFun.playSoundEffect("defen.wav")
--        self.m_lCoins = self.m_lCoins + self.m_lGetCoins
        self.m_lGetCoins = 0

 --       self:changeUserScore(-self.m_lTotalYafen)
        self._gameView.m_textGetScore:setString(self.m_lGetCoins)       --self._scene.m_lCoins
  end

     self._gameView.m_textScore:setString(self.m_lCoins)   --self.m_lCoins
     self:changeUserScore(-self.m_lTotalYafen)

end

--发送放弃游戏一消息
function GameLayer:sendEndGame1Msg()
    print("发送结束游戏1消息")
    --发送数据
    local  dataBuffer= CCmd_Data:create(1)
    --dataBuffer:pushscore(0)

    self:SendData(g_var(cmd).SHZ_SUB_C_ONE_END, dataBuffer)
    self.setGameMode(2)
end

--发送中奖记录
function GameLayer:sendRecord()
  print("请求中奖记录消息")
      --发送数据
    local  dataBuffer= CCmd_Data:create(1)
    --dataBuffer:pushscore(0)
    self:SendData(g_var(cmd).SHZ_SUB_C_CHECK_BONUS, dataBuffer)
end

--中奖记录 -----------------------------=======================================
function GameLayer:onRecord(dataBuffer)
    
    local len = dataBuffer:getlen()
    local cmd_table = ExternalFun.read_netdata(g_var(cmd).SHZ_S_RECORD,dataBuffer)
    self._Name ={}
    self._Bonus ={}
    local cmd_time ={}
    self.strTime = {}
    self._num = cmd_table.number
    for i = 1,self._num do
       self._Name[i] = cmd_table.name[1][i]  --昵称 
       self._Bonus[i] = cmd_table.bouns[1][i]  --奖金
       cmd_time[i] = cmd_table.time[1][i]

       self.strTime[i] = string.format("%d-%02d-%02d %02d:%02d:%02d", cmd_time[i].wYear, cmd_time[i].wMonth, cmd_time[i].wDay, cmd_time[i].wHour, cmd_time[i].wMinute, cmd_time[i].wSecond)

      -- self._gameView.record_name:setString(self._Name[i])
      -- self._gameView.record_time:setString(strTime)
      -- self._gameView.record_amount:setString(self._Bonus[i])


    end
    self._gameView:onRecord()
end


--刷新服务器分数
function GameLayer:refreshScore()
    local useritem = self:GetMeUserItem()
    self._gameView.m_textScore:setString(useritem.lScore)--(seritem.lScore)   --useritem.lScore

    self.m_lCoins = self:GetMeUserItem().lScore
end

function GameLayer:changeUserScore( changeScore )
    self.m_lCoins = self.m_lCoins + changeScore
    self._gameView.m_textScore:setString(self.m_lCoins)  --self.m_lCoins

end
-----------------
function GameLayer:addUserScore( addScore )
    self.m_lCoins = self.m_lCoins + addScore
    self._gameView.m_textScore:setString(self.m_lCoins)  --self.m_lCoins

end


----进入小玛丽   --====                --改为进入抽奖小游戏  翻牌
function GameLayer:onEnterGame2( )

    if self.m_cbGameStatus == g_var(cmd).GAME_FANPAI then
        self._gameView:stopAllActions()

        self._game2View = GameViewLayer[2]:create(self)
        self:addChild(self._game2View)
        self._gameView:setPosition(-1334,0) --把现在的游戏移出屏幕外

    end
 
end
--------------------------
--                      游戏3 小玛丽    --小游戏 翻牌
----------------------------------------------------------------

--function GameLayer:game2DataInit(  )

--end

function GameLayer:onGame2Start( dataBuffer )

    print("翻牌开始")
    local cmd_table = ExternalFun.read_netdata(g_var(cmd).CMD_S_SmallStart, dataBuffer)
    --dump(cmd_table)
    local pGame3Info = GameLogic:copyTab(cmd_table)

    self.data = {{0,0,0,0,0},{0,0,0,0,0},{0,0,0,0,0},{0,0,0,0,0}}
    self.m_lGetCoins3 = 0    --赢取的金币

    self.m_card = 0          --关卡
    self.m_CardScore = 0     --每关点击的金币

    for i = 1,4 do
       for j = 1,5 do
       self.data[i][j] = pGame3Info.SamllGameFruitData[i][j]
      end
   end

end

--  结算
function GameLayer:onGame2Result(  )
    print("小玛丽结算")

end

--发送关卡消息
function GameLayer:sendReadyMsg2()  
    --发送数据
    local dataBuffer = CCmd_Data:create(10)
    print("self.= cbcard ="..self.m_card)
    print("self.SmallSorce="..self.m_CardScore)
    
   
    dataBuffer:pushbool(0)
    dataBuffer:pushbyte(self.m_card)
    dataBuffer:pushscore(self.m_CardScore)

    self:SendData(g_var(cmd).SHZ_SUB_C_THREE_START, dataBuffer)
end

function GameLayer:sendThreeEnd(  )  --结束
      --发送数据
    local  dataBuffer= CCmd_Data:create(1)

    self:SendData(g_var(cmd).SHZ_SUB_C_THREE_END, dataBuffer)  
end

return GameLayer