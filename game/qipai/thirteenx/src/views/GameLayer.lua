--
-- Author: Tang
-- Date: 2016-12-08 15:41:53
--
local GameModel = appdf.req(appdf.CLIENT_SRC.."gamemodel.GameModel")
local GameLayer = class("GameLayer", GameModel)

local module_pre = "game.qipai.thirteenx.src"
local ExternalFun =  appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local cmd = appdf.req(module_pre..".models.cmd_game")
local GameLogic = appdf.req(module_pre .. ".models.GameLogic")
local GameViewLayer = appdf.req(module_pre .. ".views.layer.GameViewLayer")
local QueryDialog   = appdf.req("app.views.layer.other.QueryDialog")

function GameLayer:ctor( frameEngine,scene )
    GameLayer.super.ctor(self, frameEngine, scene)
    self:OnInitGameEngine()
    self._roomRule = self._gameFrame._dwServerRule
    self.m_bLeaveGame = false
    self._clockTimeLeave = 0
    self._wBankerUser = yl.INVALID_CHAIR

    self._bUserGameStatus = {false,false,false,false}

    self._cbHandCard = {}  --13张自己手牌数据
    self._sortedCard = {}  --选牌结束后的扑克列表
    self._scoreTimes = {}  --每段比分
    self._scoreEnd = {} --结算分数
    self._selfscoreEnd = 0  --自己的结算分数
    self._bSpecialType = {} --是否特殊牌型
    self._cbautoCard = {}   --自动出牌
    self._bDetailAll = {}   --单蹦
    self._cbAllDetaiUser = yl.INVALID_CHAIR --通蹦玩家
    self._bHaveBanker = 0   --是否霸王庄模式
    self._nAllWinTimes = 0      --额外打枪模式
    --约战需要
    self.m_tabUserItem = {}
    self.m_bjoinGame = false  --当前是否参与游戏
    self.m_bPriEnd = false      --是否有约战结算

    self._gameFrame:QueryUserInfo(self:GetMeUserItem().wTableID,yl.INVALID_CHAIR)
end

--获取gamekind
function GameLayer:getGameKind()
    return cmd.KIND_ID
end

--创建场景
function GameLayer:CreateView()
     self._gameView = GameViewLayer:create(self)
     self:addChild(self._gameView)
     return self._gameView
end

function GameLayer:getParentNode( )
    return self._scene
end

function GameLayer:getFrame( )
    return self._gameFrame
end

function GameLayer:logData(msg)
    if nil ~= self._scene.logData then
        self._scene:logData(msg)
    end
end

function GameLayer:reSetData()
    self._cbautoCard = {}   --自动出牌
end

--相对索引 return 1-6
function GameLayer:getUserIndex( wChairID )
    local viewIndex = cmd.InvalidIndex
    local MyChair = self:GetMeUserItem().wChairID
    viewIndex = math.mod((wChairID-MyChair+cmd.GAME_PLAYER),cmd.GAME_PLAYER)
    return  viewIndex+1
end

--相对索引座位 return 0-5
function GameLayer:getUserChair( viewIndex )
    local MyChair = self:GetMeUserItem().wChairID
    return  math.mod(viewIndex-1+MyChair,cmd.GAME_PLAYER)
end

---------------------------------------------------------------------------------------
------继承函数
function GameLayer:onEnterTransitionFinish()
    GameLayer.super.onEnterTransitionFinish(self)
end

function GameLayer:onExit()
    self:KillGameClock()
    self:dismissPopWait()
    GameLayer.super.onExit(self)
    print("GameLayer onExit")
end

--退出桌子
function GameLayer:onExitTable()
    self:KillGameClock()
    local MeItem = self:GetMeUserItem()
    if MeItem and MeItem.cbUserStatus > yl.US_FREE then
        self:showPopWait()
        self:runAction(cc.Sequence:create(
            cc.CallFunc:create(
                function ()
                    self._gameFrame:StandUp(1)
                end
                ),
            cc.DelayTime:create(10),
            cc.CallFunc:create(
                function ()
                    print("delay leave")
                    self:onExitRoom()
                end
                )
            )
        )
        return
    end

   self:onExitRoom()
end

--离开房间
function GameLayer:onExitRoom()
    -- self._scene:onKeyBack()
    self:getFrame():onCloseSocket()
    AppFacade:getInstance():sendNotification(GAME_COMMAMD.POP_VIEW, {Name = VIEW_LIST.GAME_LAYER})
end

function GameLayer:OnEventGameClockInfo(chair,clocktime,clockID)
    if nil ~= self._gameView  and self._gameView.UpdataClockTime then
        self._gameView:UpdataClockTime(clockID,clocktime)
    end
end

-- 设置计时器
function GameLayer:SetGameClock(chair,id,time)
    self:KillGameClock()
    GameLayer.super.SetGameClock(self,chair,id,time)
end

function GameLayer:OnResetGameEngine()
    print("OnResetGameEngine")
    self:reSetData()
    GameLayer.super.OnResetGameEngine(self)
end

--比牌完成
function GameLayer:sendCompleteCompare()
    local cmddata = CCmd_Data:create(0)
    self:SendData(cmd.SUB_C_COMPLETE_COMPARE, cmddata)
    print("比牌完成11111")
end

-- 发送托管
function GameLayer:sendRobot( value )
    local cmddata = CCmd_Data:create(1)
    cmddata:pushbyte(value)
    self:SendData(cmd.SUB_C_TRUSTEE,cmddata)
end

--系统消息
function GameLayer:onSystemMessage( wType,szString )
    if wType == 501 or wType == 515 then
        print("十三水游戏币不足消息", szString)
        local msg = szString or "你的游戏币不足，无法继续游戏"
        local query = QueryDialog:create(msg, function(ok)
                if ok == true then
                    self:onExitTable()
                end
            end):setCanTouchOutside(false)
                :addTo(self)
    end
end


-- 场景信息
function GameLayer:onEventGameScene(cbGameStatus,dataBuffer)
    print("场景数据:" .. cbGameStatus)
    if self.m_bOnGame then
        return
    end
    self.m_bOnGame = true
    self.m_cbGameStatus = cbGameStatus
    if cbGameStatus == cmd.GS_WK_FREE  then                        --空闲状态
        self:onEventGameSceneFree(dataBuffer)
    elseif cbGameStatus == cmd.GS_WK_PLAYING then
        self:onEventGameSceneStatus(dataBuffer)
    end
    -- 刷新房卡
    if PriRoom and GlobalUserItem.bPrivateRoom then
        if nil ~= self._gameView._priView and nil ~= self._gameView._priView.onRefreshInfo then
            self._gameView._priView:onRefreshInfo()
        end
    end

    self:dismissPopWait()
end

function GameLayer:onEventGameSceneFree( dataBuffer )
    print("空闲场景")
    local  free_data = ExternalFun.read_netdata(cmd.CMD_S_StatusFree, dataBuffer)
    --dump(free_data, "the free data is =========== > ", 6)

    self.m_tTimeStartGame = free_data.cbTimeStartGame or 30
    self.m_tTimeShowCard  = free_data.cbTimeRangeCard  or 60
    --self.m_tTimeShowCard  = 10

    --显示准备
    self._gameView:showReadyBtn(true)
    if GlobalUserItem.bPrivateRoom == true and PriRoom then

    else
        self:SetGameClock(self:GetMeUserItem().wChairID,cmd.Clock_free, self.m_tTimeStartGame)
    end

    self._bHaveBanker = free_data.bHaveBanker --霸王庄模式
    self._nAllWinTimes = free_data.nAllWinTimes --额外打枪
end

function GameLayer:onEventGameSceneStatus( dataBuffer )
    print("游戏场景")
    local status = ExternalFun.read_netdata(cmd.CMD_S_StatusPlay, dataBuffer)
    dump(status, "the status data is ==============", 6)
    self.m_tTimeStartGame = status.cbTimeStartGame or 30
    self.m_tTimeShowCard  = status.cbTimeRangeCard  or 60

    --变量赋值
    self._cbHandCard = status.bHandCardData[1]
    self._bUserGameStatus = status.bGameStatus[1]

    self._bHaveBanker = status.bHaveBanker --霸王庄模式
    self._nAllWinTimes = status.nAllWinTimes --额外打枪

    --清空视图
    self._gameView:gameClean()

    self._wBankerUser = status.wBanker

    --扑克信息
    local dispatchInfo = {}
    dispatchInfo.playerIndex = {}
    dispatchInfo.playerCount = status.cbPlayCount
    dispatchInfo.cardCount   = cmd.HAND_CARD_COUNT
    for i=1,#self._bUserGameStatus do
        local bGameStatus = self._bUserGameStatus[i]
        if true == bGameStatus then
          local viewIndex = self:getUserIndex(i-1)
          table.insert(dispatchInfo.playerIndex, viewIndex)
        end
     end

    --完成分段
    local finishSelect = status.bFinishSegment[1]

    local bPopSelectView = false
    if true == self._bUserGameStatus[self:GetMeUserItem().wChairID+1] and not finishSelect[self:GetMeUserItem().wChairID+1] then
        bPopSelectView = true
    end
    --是否游戏中
    self.m_bjoinGame = self._bUserGameStatus[self:GetMeUserItem().wChairID+1]

    self._gameView:dispatchCard(dispatchInfo,false,bPopSelectView)
     --设置分段数据bPopSelectView
    local bcompare = true
    local viewUser = {}
    for i=1,cmd.GAME_PLAYER do
        local datas = {}
        if i == 1 then
            datas = clone(status.bSegmentCard1)
        elseif i == 2 then
            datas = clone(status.bSegmentCard2)
        elseif i == 3 then
            datas = clone(status.bSegmentCard3)
        elseif i == 4 then
            datas = clone(status.bSegmentCard4)
        end
        local userIndex = self:getUserIndex(i-1)
        self._bSpecialType[userIndex] = 0
        if  self._bUserGameStatus[i] then
            if true == finishSelect[i] then
                local cardInfo = {}
                cardInfo.Front = {datas[1][1],datas[1][2],datas[1][3]}
                cardInfo.Mid   = {datas[2][1],datas[2][2],datas[2][3],datas[2][4],datas[2][5]}
                cardInfo.Tail  = {datas[3][1],datas[3][2],datas[3][3],datas[3][4],datas[3][5]}
                self._sortedCard[userIndex] = cardInfo

                local cardData = {}
                for k,v in pairs(cardInfo.Front) do
                    table.insert(cardData, v)
                end
                for k,v in pairs(cardInfo.Mid) do
                    table.insert(cardData, v)
                end
                for k,v in pairs(cardInfo.Tail) do
                    table.insert(cardData, v)
                end

                self:runAction(cc.Sequence:create(cc.DelayTime:create(0.2), cc.CallFunc:create(function()
                    self._gameView:showSelectedCard(userIndex, cardData)
                    end)))
            else
                print("选牌未完成", userIndex)
                self._gameView:showSelectAction(userIndex)
                bcompare = false
            end
            self._scoreTimes[userIndex] = status.lScoreTimes[i]
            self._bSpecialType[userIndex] = status.bSpecialType[1][i]
            if status.bSpecialType[1][i] == 0 then
                table.insert(viewUser,userIndex)
            end
        end
    end
    --需要比牌
    if bcompare == true then
        print("需要比牌", bcom)
        self:runAction(cc.Sequence:create(cc.DelayTime:create(0.3), cc.CallFunc:create(function()
                self._gameView:compareCard(viewUser)
            end)))
    end
end

function GameLayer:onEventGameMessage(sub,dataBuffer)
    if nil == self._gameView then
        return
    end

    if sub == cmd.SUB_S_SHOW_CARD then                       --玩家摊牌
        self:OnSubShowCard(dataBuffer)
    elseif sub == cmd.SUB_S_GAME_START  then                     --游戏开始
        self:onSubGameStart(dataBuffer)
    elseif sub == cmd.SUB_S_PLAYER_EXIT then                     --用户强退
        self:OnSubPlayerExit(dataBuffer)
    elseif sub == cmd.SUB_S_SEND_CARD_EX then                    --开始发牌
         self.m_cbGameStatus = cmd.GS_WK_PLAYING
        self:OnSubDispatchCard(dataBuffer)
    elseif sub == cmd.SUB_S_COMPARE_CARD then                    --比较扑克
        self:OnSubCompareCard(dataBuffer)
    elseif sub == cmd.SUB_S_GAME_END then                        --游戏结束
        self.m_cbGameStatus = cmd.GS_WK_FREE
        self:OnSubGameEnd(dataBuffer)
    elseif sub == cmd.SUB_S_TRUSTEE then                         --玩家托管
        self:OnSubTrustTee(dataBuffer)
    elseif sub == cmd.SUB_S_MOBILE_PUTCARD then                 --手机托管发牌
        self._cbautoCard = ExternalFun.read_netdata(cmd.CMD_S_MobilePutCard, dataBuffer)
        dump(self._cbautoCard, "手机托管发牌", 10)
        self._gameView:mobilePutCard()
    end
    print("onEventGameMessage ======== >"..sub)
end

-- 游戏开始
function GameLayer:onSubGameStart(dataBuffer)
    print("游戏开始")
    print("buffer len is ==== >"..dataBuffer:getlen())
    for i=1,cmd.GAME_PLAYER do
        self._gameView:showReady(i,false)
    end
end

function GameLayer:OnSubTrustTee(dataBuffer)
     local trustTee = ExternalFun.read_netdata(cmd.CMD_S_Trustee, dataBuffer)
     local item = self:GetMeUserItem()
     if trustTee.wChairID == item.wChairID then
         return
     end

     local userIndex = self:getUserIndex(trustTee.wChairID)
     local bTrustee  = trustTee.bTrustee
     self._gameView:trustTeeDeal(userIndex,bTrustee)
end

function GameLayer:OnSubDispatchCard( dataBuffer )
    print("开始发牌")
    print("the buffer len is ================ >"..dataBuffer:getlen())
    local send_data = ExternalFun.read_netdata(cmd.CMD_S_SendCard, dataBuffer)

    --dump(send_data, "6666666666666666666", 6)

    self._cbHandCard = send_data.bCardData[1]
    self._bUserGameStatus = send_data.bGameStatus[1]
    self.m_bjoinGame = self._bUserGameStatus[self:GetMeUserItem().wChairID+1]
    self._wBankerUser = send_data.wBanker
    if self._wBankerUser ~= yl.INVALID_CHAIR then
        local userIndex = self:getUserIndex(self._wBankerUser)
        self._gameView:showBankerIcon(userIndex)
    end
    print("当前庄家", self._wBankerUser)
    --发牌信息
    local dispatchInfo = {}
    dispatchInfo.playerIndex = {}
    dispatchInfo.playerCount = send_data.cbPlayCount
    dispatchInfo.cardCount   = cmd.HAND_CARD_COUNT
    for i=1,#self._bUserGameStatus do
        local bGameStatus = self._bUserGameStatus[i]
        if bGameStatus then
          local viewIndex = self:getUserIndex(i-1)
          table.insert(dispatchInfo.playerIndex, viewIndex)
        end
     end

    self._gameView:dispatchCard(dispatchInfo,true,true)


    for i=1,cmd.GAME_PLAYER do
       self._gameView:showReady(i, false)
    end

    -- 刷新房卡
    if PriRoom and GlobalUserItem.bPrivateRoom then
        if nil ~= self._gameView._priView and nil ~= self._gameView._priView.onRefreshInfo then
            PriRoom:getInstance().m_tabPriData.dwPlayCount = PriRoom:getInstance().m_tabPriData.dwPlayCount + 1
            self._gameView._priView:onRefreshInfo()
        end
    end
end


function GameLayer:OnSubShowCard(dataBuffer)
    print("玩家摊牌")
   local showcardBuff = ExternalFun.read_netdata(cmd.CMD_S_ShowCard, dataBuffer)
   --dump(showcardBuff, "ShowCard data is =============== > ", 6)
   local user = showcardBuff.wCurrentUser

   -- if user == self:GetMeUserItem().wChairID then   --过滤自己
   --    return
   -- end

   local userindex = self:getUserIndex(user)

   --玩家摊牌数据
   local cardInfo = {}
   cardInfo.Front = showcardBuff.bFrontCard[1]
   cardInfo.Mid   = showcardBuff.bMidCard[1]
   cardInfo.Tail  = showcardBuff.bBackCard[1]
   self._sortedCard[userindex] = cardInfo
   local cardData = {}
   for k,v in pairs(cardInfo.Front) do
       table.insert(cardData, v)
   end
   for k,v in pairs(cardInfo.Mid) do
       table.insert(cardData, v)
   end
   for k,v in pairs(cardInfo.Tail) do
       table.insert(cardData, v)
   end
   self._gameView:showSelectedCard(userindex, cardData)
end

function GameLayer:OnSubCompareCard(dataBuffer)
    print("开始比牌")
    --清空自动出牌数据
    self._cbautoCard = {}
    local compareCardBuff = ExternalFun.read_netdata(cmd.CMD_S_CompareCard, dataBuffer)
    self._wBankerUser = compareCardBuff.wBanker
    if self._wBankerUser ~= yl.INVALID_CHAIR then
        local userIndex = self:getUserIndex(self._wBankerUser)
        self._gameView:showBankerIcon(userIndex)
    end
    --比牌数据
    for i=1,cmd.GAME_PLAYER do
        local datas = {}
        if i == 1 then
            datas = clone(compareCardBuff.bSegmentCard1)
        elseif i == 2 then
            datas = clone(compareCardBuff.bSegmentCard2)
        elseif i == 3 then
            datas = clone(compareCardBuff.bSegmentCard3)
        elseif i == 4 then
            datas = clone(compareCardBuff.bSegmentCard4)
        end
        local userIndex = self:getUserIndex(i-1)
        if self._bUserGameStatus[i] and cmd.ME_VIEW_CHAIR ~= userIndex then
            --玩家摊牌数据
           local cardInfo = {}
           cardInfo.Front = {datas[1][1],datas[1][2],datas[1][3]}
           cardInfo.Mid   = {datas[2][1],datas[2][2],datas[2][3],datas[2][4],datas[2][5]}
           cardInfo.Tail  = {datas[3][1],datas[3][2],datas[3][3],datas[3][4],datas[3][5]}
           self._sortedCard[userIndex] = cardInfo
            --设置玩家手牌数据
           self._gameView:setSelectCardData(userIndex)
        end
    end

    --每段比分
    local viewUser = {}
    for i=1,#self._bUserGameStatus do
        local userIndex = self:getUserIndex(i-1)
        if true == self._bUserGameStatus[i]  then
            self._scoreTimes[userIndex] = compareCardBuff.lScoreTimes[i]
            --是否特殊牌型
            self._bSpecialType[userIndex] = compareCardBuff.bSpecialType[1][i]
            if compareCardBuff.bSpecialType[1][i] == 0 then
                table.insert(viewUser,userIndex)
            end
        else
            self._bSpecialType[userIndex] = 0
        end
    end
    --比牌动画
    self._gameView:compareCard(viewUser)
end

function GameLayer:OnSubPlayerExit(dataBuffer)
    print("用户强退")
    local PlayerExit = ExternalFun.read_netdata(cmd.CMD_S_PlayerExit, dataBuffer)

    --玩家iD
    local exitUser = PlayerExit.wPlayerID
    self._bUserGameStatus[exitUser+1] = false
end

function GameLayer:OnSubGameEnd(dataBuffer)
   print("游戏结束")
    local endBuffer = ExternalFun.read_netdata(cmd.CMD_S_GameEnd, dataBuffer)
    local time  = (self.m_tTimeStartGame == 0) and 30 or self.m_tTimeStartGame
    if GlobalUserItem.bPrivateRoom == true and PriRoom then

    else
        self:SetGameClock(self:GetMeUserItem().wChairID,cmd.Clock_end, time)
        self._gameView:setClockVisible(false)
    end

    self._scoreEnd = endBuffer.lGameScore[1]

    dump(self._scoreEnd, "结束显示分数", 10)
    self._selfscoreEnd = endBuffer.lScoreTimes[1][self:GetMeUserItem().wChairID+1]

    self._gameView:showEndScore(self._scoreEnd, endBuffer.bEndMode)

end

--用户状态
function GameLayer:onEventUserStatus(useritem,newstatus,oldstatus)

    print("change user " .. useritem.wChairID .. "; nick " .. useritem.szNickName)
    if newstatus.cbUserStatus == yl.US_FREE or newstatus.cbUserStatus == yl.US_NULL then

        if (oldstatus.wTableID ~= self:GetMeUserItem().wTableID) then
            return
        end
        if self.m_bPriEnd == false then
            self._gameView:deleteUserInfo(useritem)
            print("删除")
        end
    else
        if (newstatus.wTableID ~= self:GetMeUserItem().wTableID) then
            return
        end

        self.m_tabUserItem[useritem.wChairID] = clone(useritem)

        --刷新用户信息
        if useritem == self:GetMeUserItem() then
            if PriRoom and GlobalUserItem.bPrivateRoom then
                if PriRoom:getInstance().m_tabPriData.dwTableOwnerUserID == useritem.dwUserID then
                    self._gameView:showFangzhuIcon(1)
                end
                self._gameView:updateScore(useritem)
            end
            return
        end
        self._gameView:showUserInfo(useritem)
        if newstatus.cbUserStatus == yl.US_READY then
            self._gameView:showReady(useritem.wChairID, true)
        end
    end
end

--用户进入
function GameLayer:onEventUserEnter(tableid,chairid,useritem)

    print("the table id is ================ >"..tableid)

  --刷新用户信息
    if tableid ~= self:GetMeUserItem().wTableID then
        return
    end

    self.m_tabUserItem[useritem.wChairID] = clone(useritem)

    if useritem == self:GetMeUserItem() then
        if PriRoom and GlobalUserItem.bPrivateRoom then
            if PriRoom:getInstance().m_tabPriData.dwTableOwnerUserID == useritem.dwUserID then
                self._gameView:showFangzhuIcon(1)
            end
            self._gameView:updateScore(useritem)
        end
        return
    end

    self._gameView:showUserInfo(useritem)
    if useritem.cbUserStatus == yl.US_READY then
        self._gameView:showReady(useritem.wChairID, true)
    end

    -- 刷新房卡
    if PriRoom and GlobalUserItem.bPrivateRoom then
        if nil ~= self._gameView._priView and nil ~= self._gameView._priView.onRefreshInfo then
            self._gameView._priView:onRefreshInfo()
        end
    end
end

--用户分数
function GameLayer:onEventUserScore( item )
    if item.wTableID ~= self:GetMeUserItem().wTableID then
       return
    end
    self._gameView:updateScore(item)
end

-- 文本聊天
function GameLayer:onUserChat(chatdata, chairid)
    local viewid = self:getUserIndex(chairid)
    self._gameView:onUserChat(chatdata, viewid)
end

-- 语音播放开始
function GameLayer:onUserVoiceStart( useritem, filepath )
    local viewid = self:getUserIndex(useritem.wChairID)
    self._gameView:onUserVoiceStart(viewid)
end

-- 语音播放结束
function GameLayer:onUserVoiceEnded( useritem, filepath )
    local viewid = self:getUserIndex(useritem.wChairID)
    self._gameView:onUserVoiceEnded(viewid)
end

--约战房处理
function GameLayer:onGetSitUserNum()
    return self._gameView:getUserNum()
end

--获取庄模式
function GameLayer:getBankerMode()
    return self._bHaveBanker
end

--获取额外打枪
function GameLayer:getGunNum()
    return self._nAllWinTimes
end

--获取用户数据
function GameLayer:getUserInfoByChairID(wchairid)
    for k,v in pairs(self.m_tabUserItem) do
        if v.wChairID == wchairid then
            return v
        end
    end
    return nil
end

--获取用户数据
function GameLayer:getUserInfoByUserID(dwUserID)
    for k,v in pairs(self.m_tabUserItem) do
        if v.dwUserID == dwUserID then
            return v
        end
    end
    return nil
end

return GameLayer
