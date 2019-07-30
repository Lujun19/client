local GameModel = appdf.req(appdf.CLIENT_SRC.."gamemodel.GameModel")

local GameLayer = class("GameLayer", GameModel)
local GameLayer = class("GameLayer", GameModel)

local cmd = appdf.req(appdf.GAME_SRC.."yule.oxsixex.src.models.CMD_Game")
local GameLogic = appdf.req(appdf.GAME_SRC.."yule.oxsixex.src.models.GameLogic")
local GameViewLayer = appdf.req(appdf.GAME_SRC.."yule.oxsixex.src.views.layer.GameViewLayer")
local QueryDialog = appdf.req("app.views.layer.other.QueryDialog")
local pointBankerFlag = {cc.p(375, 677), cc.p(82, 407), cc.p(585, 70), cc.p(1230, 407),cc.p(975, 683)}
-- 初始化界面
function GameLayer:ctor(frameEngine,scene)
    GameLayer.super.ctor(self, frameEngine, scene)

end

--创建场景
function GameLayer:CreateView()
    return GameViewLayer:create(self):addTo(self)
end

-- 初始化游戏数据
function GameLayer:OnInitGameEngine()
    self.cbPlayStatus = {0, 0, 0, 0}
    self.cbCardData = {}
    self.wBankerUser = yl.INVALID_CHAIR
    self.cbDynamicJoin = 0
    self.m_tabPrivateRoomConfig = {}
    self.m_bStartGame = false

    GameLayer.super.OnInitGameEngine(self)
--[[	local cbCardData = {2,3,4,5,6}
	GameLogic:SortCardList(cbCardData, 5)--]]
end

--换位
function GameLayer:onChangeDesk()
     self._gameFrame:QueryChangeDesk()
end

-- 椅子号转视图位置,注意椅子号从0~nChairCount-1,返回的视图位置从1~nChairCount
function GameModel:SwitchViewChairID(chair)
    local viewid = yl.INVALID_CHAIR
    local nChairCount = 5
    local nChairID = self:GetMeChairID()
    if chair ~= yl.INVALID_CHAIR and chair < nChairCount then
        viewid = math.mod(chair + math.floor(nChairCount * 3/2) - nChairID, nChairCount) + 1
    end
    return viewid
end

-- 重置游戏数据
function GameLayer:OnResetGameEngine()
    -- body
    GameLayer.super.OnResetGameEngine(self)
end

--获取gamekind
function GameLayer:getGameKind()
    return cmd.KIND_ID
end

-- 时钟处理
function GameLayer:OnEventGameClockInfo(chair,time,clockId)
    -- body
    if clockId == cmd.IDI_NULLITY then
        if time <= 5 then
            self:PlaySound(GameViewLayer.RES_PATH.."sound/GAME_WARN.WAV")
        end
    elseif clockId == cmd.IDI_START_GAME then
        if time <= 0 then
            self._gameFrame:setEnterAntiCheatRoom(false)--退出防作弊
        elseif time <= 5 then
            self:PlaySound(GameViewLayer.RES_PATH.."sound/GAME_WARN.WAV")
        end
    elseif clockId == cmd.IDI_CALL_BANKER then
        if time < 1 then
            -- 非私人房处理叫庄
            if not GlobalUserItem.bPrivateRoom then
                self._gameView:onButtonClickedEvent(GameViewLayer.BT_CANCEL)
            end
        end
    elseif clockId == cmd.IDI_TIME_USER_ADD_SCORE then
        if time < 1 then
            if not GlobalUserItem.bPrivateRoom then
                self._gameView:onButtonClickedEvent(GameViewLayer.BT_CHIP + 1)
            end
        elseif time <= 5 then
            self:PlaySound(GameViewLayer.RES_PATH.."sound/GAME_WARN.WAV")
        end
    elseif clockId == cmd.IDI_TIME_OPEN_CARD then
        if time < 1 then
            -- 非私人房处理摊牌
            --if not GlobalUserItem.bPrivateRoom then
                self._gameView:onButtonClickedEvent(GameViewLayer.BT_OPENCARD)
            --end
		elseif time <= 5 then
            self:PlaySound(GameViewLayer.RES_PATH.."sound/GAME_WARN.WAV")
        end
    end
end

--用户聊天
function GameLayer:onUserChat(chat, wChairId)
    self._gameView:userChat(self:SwitchViewChairID(wChairId), chat.szChatString)
end

--用户表情
function GameLayer:onUserExpression(expression, wChairId)
    self._gameView:userExpression(self:SwitchViewChairID(wChairId), expression.wItemIndex)
end

-- 语音播放开始
function GameLayer:onUserVoiceStart( useritem, filepath )
    local viewid = self:SwitchViewChairID(useritem.wChairID)
    self._gameView:onUserVoiceStart(viewid)
end

-- 语音播放结束
function GameLayer:onUserVoiceEnded( useritem, filepath )
    local viewid = self:SwitchViewChairID(useritem.wChairID)
    self._gameView:onUserVoiceEnded(viewid)
end

--退出桌子
function GameLayer:onExitTable()
    self:KillGameClock()
    local MeItem = self:GetMeUserItem()
    if MeItem and MeItem.cbUserStatus > yl.US_FREE then
        --self:showPopWait()
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
	self._gameFrame:onCloseSocket()
	AppFacade:getInstance():sendNotification(GAME_COMMAMD.POP_VIEW, {Name = VIEW_LIST.GAME_LAYER})
end

function GameLayer:onExit()
    self:KillGameClock()
    self:dismissPopWait()
    GameLayer.super.onExit(self)
end

function GameLayer:onGetSitUserNum()
    local num = 0
    for i = 1, cmd.GAME_PLAYER do
        if nil ~= self._gameView.m_tabUserItem[i] then
            num = num + 1
        end
    end

    return num
end

function GameLayer:getUserInfoByChairID(chairId)
    local viewId = self:SwitchViewChairID(chairId)
    return self._gameView.m_tabUserItem[viewId]
end

function GameLayer:onGetNoticeReady()
    print("牛牛 系统通知准备")
    if nil ~= self._gameView and nil ~= self._gameView.btStart then
        self._gameView.btStart:setVisible(true)
    end
end

--系统消息
function GameLayer:onSystemMessage( wType,szString )
    print("处理金币不足")
    if self.m_bStartGame then
        local msg = szString or ""
        self.m_querydialog = QueryDialog:create(msg,function()
            self:onExitTable()
        end,nil,1)
        self.m_querydialog:setCanTouchOutside(false)
        self.m_querydialog:addTo(self)
    else
        self.m_bPriScoreLow = true
        self.m_szScoreMsg = szString
    end
end

function GameModel:addPrivateGameLayer( layer )
    if nil == layer then
        return
    end

    self._gameView:addChild(layer, 2)
end

-- 场景信息
function GameLayer:onEventGameScene(cbGameStatus, dataBuffer)
    --初始化已有玩家   
    local tableId = self._gameFrame:GetTableID()
    --self._gameView:setTableID(tableId) 
    for i = 1, cmd.GAME_PLAYER do
        local userItem = self._gameFrame:getTableUserItem(tableId, i-1)
        if nil ~= userItem then
            local wViewChairId = self:SwitchViewChairID(i-1)
            self._gameView:OnUpdateUser(wViewChairId, userItem)
        end
		if nil == userItem then
			local wViewChairId = self:SwitchViewChairID(i-1)
			self._gameView:OnUpdateUser(wViewChairId, nil)
		end
    end
    self._gameView:onResetView()
    self.m_cbGameStatus = cbGameStatus

	if cbGameStatus == cmd.GS_TK_FREE	then				--空闲状态
        self:onSceneFree(dataBuffer)
	elseif cbGameStatus == cmd.GS_TK_CALL	then			--叫分状态
        self:onSceneCall(dataBuffer)
	elseif cbGameStatus == cmd.GS_TK_SCORE	then			--下注状态
        self:onSceneScore(dataBuffer)
    elseif cbGameStatus == cmd.GS_TK_PLAYING  then            --游戏状态
        self:onScenePlaying(dataBuffer)
	end
    self:dismissPopWait()
end

--空闲场景
function GameLayer:onSceneFree(dataBuffer)
    print("onSceneFree")
	self:stopAllActions()
	
	self._gameView.animateCard:stopAllActions()
	self._gameView.animateCard:setVisible(false)
	for i = 1, cmd.GAME_PLAYER do
		for j = 1, 5 do
	        self._gameView.nodeCard[i][j]:setVisible(false)         
        end
        if i == cmd.MY_VIEWID then
            for k = 1, 5 do
	            self._gameView.MynodeCard[k]:setVisible(false)
             end
        end
	end
	
	local tableId = self._gameFrame:GetTableID()
    for i = 1, cmd.GAME_PLAYER do
        local userItem = self._gameFrame:getTableUserItem(tableId, i-1)
        if nil ~= userItem then
            local wViewChairId = self:SwitchViewChairID(i-1)
			if yl.US_READY == userItem.cbUserStatus then
				self._gameView.flag_ready[wViewChairId]:setVisible(true)
			else
				self._gameView.flag_ready[wViewChairId]:setVisible(false)
			end
        end
	end
	
    local int64 = Integer64.new()
    local lCellScore = dataBuffer:readdouble()
    self._gameView:setCellScore(lCellScore)
--    local lRoomStorageStart = dataBuffer:readdouble()
--    local lRoomStorageCurrent = dataBuffer:readdouble()
    self._gameView.btTable:setVisible(true)
    local lTurnScore = {}
    for i = 1, cmd.GAME_PLAYER do
        lTurnScore[i] = dataBuffer:readdouble()
    end

    local lCollectScore = {}
    for i = 1, cmd.GAME_PLAYER do
        lCollectScore[i] = dataBuffer:readdouble()
    end
    self.szGameRoomName = dataBuffer:readstring(cmd.SERVER_LEN)
--    local lRobotScoreMin = dataBuffer:readdouble()
--    local lRobotScoreMax = dataBuffer:readdouble()
--    local lRobotBankGet = dataBuffer:readdouble()
--    local lRobotBankGetBanker = dataBuffer:readdouble()
--    local lRobotBankStoMul = dataBuffer:readdouble()
--    -- 反作弊标识
--    local bIsAllowAvertCheat = dataBuffer:readbool()
--    -- 坐庄模式
--    self.m_tabPrivateRoomConfig.bankerMode = dataBuffer:readint()
--    -- 房卡积分模式
--    self.m_tabPrivateRoomConfig.bRoomCardScore = dataBuffer:readbool()
--    -- 积分房卡配置的下注
--    local tabJetton = {}
--    tabJetton[1] = dataBuffer:readdouble()
--    tabJetton[2] = dataBuffer:readdouble()
--    tabJetton[3] = dataBuffer:readdouble()
--    tabJetton[4] = dataBuffer:readdouble()
--    self.m_tabPrivateRoomConfig.lRoomCardJetton = tabJetton    

--    -- 反作弊标识
--    local bIsAllowAvertCheat = dataBuffer:readbool()
    self._gameView:onSetButton(true)
    if not GlobalUserItem.isAntiCheat() then
        self._gameView.btStart:setVisible(true)
        self._gameView:setClockPosition(cmd.MY_VIEWID)

        -- 私人房无倒计时
        if not GlobalUserItem.bPrivateRoom then
            -- 设置倒计时
            self:SetGameClock(self:GetMeChairID(), cmd.IDI_START_GAME, cmd.TIME_USER_START_GAME)
        else
            self._gameView.spriteClock:setVisible(false)
        end
    end
--    for j = 1,cmd.GAME_PLAYER do
--        for i = 1, 5 do
--        --local data = self.cbCardData[index][i]
--        --local value = GameLogic:getCardValue(data)
--        --local color = GameLogic:getCardColor(data)
--        --local card = self._gameView.nodeCard[viewId]:getChildByTag(i)
--        self._gameView:setCardTextureRect(j, i, 0, 0)
--        end
--    end
       -- self._gameView:gameSendCard(self:SwitchViewChairID(1), 4*5)
end
--叫庄场景
function GameLayer:onSceneCall(dataBuffer)
    print("onSceneCall")
	
	self._gameView.animateCard:stopAllActions()
	self._gameView.animateCard:setVisible(false)
	for i = 1, cmd.GAME_PLAYER do
		for j = 1, 5 do
	        self._gameView.nodeCard[i][j]:setVisible(false)         
        end
        if i == cmd.MY_VIEWID then
            for k = 1, 5 do
	            self._gameView.MynodeCard[k]:setVisible(false)
             end
        end
	end
	
	self:stopAllActions()
    local int64 = Integer64.new()
    local lCellScore = dataBuffer:readdouble()
    self._gameView:setCellScore(lCellScore)
    local wCallBanker = dataBuffer:readword()
    self.cbDynamicJoin = dataBuffer:readbyte()
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~动态加入：", self.cbDynamicJoin)
    for i = 1, cmd.GAME_PLAYER do
        self.cbPlayStatus[i] = dataBuffer:readbyte()
    end
    if self.cbDynamicJoin == 1 then
        self._gameView.btTable:setVisible(true)
        self._gameView:onSetButton(true)
    else
        self._gameView:onSetButton(false)
		self._gameView.btTable:setVisible(false)
    end
--    local lRoomStorageStart = dataBuffer:readdouble()
--    local lRoomStorageCurrent = dataBuffer:readdouble()
    local lTurnScore = {}
    for i = 1, cmd.GAME_PLAYER do
        lTurnScore[i] = dataBuffer:readdouble()
    end
    local lCollectScore = {}
    for i = 1, cmd.GAME_PLAYER do
        lCollectScore[i] = dataBuffer:readdouble()
    end
    self.szGameRoomName = dataBuffer:readstring(cmd.SERVER_LEN)

--    local lRobotScoreMin = dataBuffer:readdouble()
--    local lRobotScoreMax = dataBuffer:readdouble()
--    local lRobotBankGet = dataBuffer:readdouble()
--    local lRobotBankGetBanker = dataBuffer:readdouble()
--    local lRobotBankStoMul = dataBuffer:readdouble()
--    -- 反作弊标识
--    local bIsAllowAvertCheat = dataBuffer:readbool()
--    -- 坐庄模式
--    self.m_tabPrivateRoomConfig.bankerMode = dataBuffer:readint()
--    -- 房卡积分模式
--    self.m_tabPrivateRoomConfig.bRoomCardScore = dataBuffer:readbool()
--    -- 积分房卡配置的下注
--    local tabJetton = {}
--    tabJetton[1] = dataBuffer:readdouble()
--    tabJetton[2] = dataBuffer:readdouble()
--    tabJetton[3] = dataBuffer:readdouble()
--    tabJetton[4] = dataBuffer:readdouble()
--    self.m_tabPrivateRoomConfig.lRoomCardJetton = tabJetton

    local wViewBankerId = self:SwitchViewChairID(wCallBanker)
    
    self._gameView:gameCallBanker(self:SwitchViewChairID(wCallBanker))
    self._gameView:setClockPosition(wViewBankerId)
    self:SetGameClock(wCallBanker, cmd.IDI_CALL_BANKER, cmd.TIME_USER_CALL_BANKER)

    -- 刷新局数
    if PriRoom and GlobalUserItem.bPrivateRoom then
        local curcount = PriRoom:getInstance().m_tabPriData.dwPlayCount
        PriRoom:getInstance().m_tabPriData.dwPlayCount = curcount - 1
        if nil ~= self._gameView._priView and nil ~= self._gameView._priView.onRefreshInfo then
            self._gameView._priView:onRefreshInfo()
        end
    end
end
--下注场景
function GameLayer:onSceneScore(dataBuffer)
    print("onSceneScore")
	self:stopAllActions()
	self._gameView.animateCard:stopAllActions()
	self._gameView.animateCard:setVisible(false)
	for i = 1, cmd.GAME_PLAYER do
		for j = 1, 5 do
	        self._gameView.nodeCard[i][j]:setVisible(false)         
        end
        if i == cmd.MY_VIEWID then
            for k = 1, 5 do
	            self._gameView.MynodeCard[k]:setVisible(false)
             end
        end
	end
	
    self._gameView._csbGameStart:setVisible(false)
    self._gameView._csbNodebank:setVisible(false)
    self._gameView._csbNodebankTop:setVisible(false)
    self._gameView._csbbank:setLastFrameCallFunc(nil)
    self._gameView._csbstart:setLastFrameCallFunc(nil)
    local int64 = Integer64.new()
    local lCellScore = dataBuffer:readdouble()
    self._gameView:setCellScore(lCellScore)
    local cbPassTime = dataBuffer:readbyte();
    for i = 1, cmd.GAME_PLAYER do
        self.cbPlayStatus[i] = dataBuffer:readbyte()
    end
    self.cbDynamicJoin = dataBuffer:readbyte()
    if self.cbDynamicJoin == 1 then
        self._gameView.btTable:setVisible(true)
	else
		self._gameView.btTable:setVisible(false)
    end
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~动态加入：", self.cbDynamicJoin)
    local lTurnMaxScore = dataBuffer:readdouble()

    for i = 1,cmd.GAME_PLAYER do
        local n = table.maxn(self._gameView.tableScore[i])
        for j = 1,n do
            if self._gameView.tableScore[i][j] ~= nil then
		        self._gameView.tableScore[i][j]:setVisible(false)
                self._gameView.tableScore[i][j]:removeFromParent()
                self._gameView.tableScore[i][j] = nil
            end
        end
        self._gameView.tableUserAddScore[i]:setVisible(false)
    end

    local lTableScore = {}
--    for i = 1, cmd.GAME_PLAYER do
--        lTableScore[i] = dataBuffer:readdouble() 
--        if self.cbPlayStatus[i] == 1 then
--            local wViewChairId = self:SwitchViewChairID(i - 1)
--            self._gameView:setUserTableScore(wViewChairId, lTableScore[i])
--        end
--    end
    for i = 1, cmd.GAME_PLAYER do
        lTableScore[i] = dataBuffer:readdouble()
        if self.cbPlayStatus[i] == 1 and lTableScore[i] ~= 0 then
            local wViewChairId = self:SwitchViewChairID(i - 1)
            self._gameView:gameAddScore(wViewChairId, lTableScore[i])
        end
    end
    self.wBankerUser = dataBuffer:readword()

    self.szGameRoomName = dataBuffer:readstring(cmd.SERVER_LEN)
--    local lRoomStorageStart = dataBuffer:readdouble()
--    local lRoomStorageCurrent = dataBuffer:readdouble()
    local lTurnScore = {}
    for i = 1, cmd.GAME_PLAYER do
        lTurnScore[i] = dataBuffer:readdouble()
    end
    local lCollectScore = {}
    for i = 1, cmd.GAME_PLAYER do
        lCollectScore[i] = dataBuffer:readdouble()
    end

--    local lRobotScoreMin = dataBuffer:readdouble()
--    local lRobotScoreMax = dataBuffer:readdouble()
--    local lRobotBankGet = dataBuffer:readdouble()
--    local lRobotBankGetBanker = dataBuffer:readdouble()
--    local lRobotBankStoMul = dataBuffer:readdouble()
    -- 反作弊标识
--    local bIsAllowAvertCheat = dataBuffer:readbool()
--    -- 坐庄模式
--    self.m_tabPrivateRoomConfig.bankerMode = dataBuffer:readint()
--    -- 房卡积分模式
--    self.m_tabPrivateRoomConfig.bRoomCardScore = dataBuffer:readbool()
--    -- 积分房卡配置的下注
--    local tabJetton = {}
--    tabJetton[1] = dataBuffer:readdouble()
--    tabJetton[2] = dataBuffer:readdouble()
--    tabJetton[3] = dataBuffer:readdouble()
--    tabJetton[4] = dataBuffer:readdouble()
--    self.m_tabPrivateRoomConfig.lRoomCardJetton = tabJetton

    
    -- 积分房卡配置的下注
--    if self.m_tabPrivateRoomConfig.bRoomCardScore then
--        self._gameView:setScoreRoomJetton(tabJetton)
--    else
--        self._gameView:setTurnMaxScore(lTurnMaxScore)
--    end
    self._gameView.btStart:setVisible(false);
    self._gameView:setBankerUser(self:SwitchViewChairID(self.wBankerUser))
--    self._gameView._csbbankTop:setLastFrameCallFunc(nil)  
    self._gameView._csbNodebankTop:setVisible(true)
    self._gameView._csbNodebankTop:move(pointBankerFlag[self:SwitchViewChairID(self.wBankerUser)])
    self._gameView._csbbankTop:play("bankAnimTop", false)
    if self.cbPlayStatus[self:GetMeChairID() + 1] == 1 and lTableScore[self:GetMeChairID() + 1] == 0 then
        self._gameView:setTurnMaxScore(lTurnMaxScore)
        self._gameView:gameStart(self:SwitchViewChairID(self.wBankerUser))
    end
    self._gameView:setClockPosition()
    self:SetGameClock(self.wBankerUser, cmd.IDI_TIME_USER_ADD_SCORE, cbPassTime)
end
--游戏场景
function GameLayer:onScenePlaying(dataBuffer)

    print("onScenePlaying")
	self._gameView.animateCard:stopAllActions()
	self._gameView.animateCard:setVisible(false)
	for i = 1, cmd.GAME_PLAYER do
		for j = 1, 5 do
	        self._gameView.nodeCard[i][j]:setVisible(false)         
        end
        if i == cmd.MY_VIEWID then
            for k = 1, 5 do
	            self._gameView.MynodeCard[k]:setVisible(false)
             end
        end
	end
	
	self:stopAllActions()
    local int64 = Integer64.new()
    local lCellScore = dataBuffer:readdouble()
    self._gameView:setCellScore(lCellScore)
    local cbPassTime = dataBuffer:readbyte();
	if cbPassTime>30 then
		cbPassTime = 2
	end
    for i = 1, cmd.GAME_PLAYER do
        self.cbPlayStatus[i] = dataBuffer:readbyte()
    end
    self.cbDynamicJoin = dataBuffer:readbyte()
    if self.cbDynamicJoin == 1 then
        self._gameView.btTable:setVisible(true)
        self._gameView:onSetButton(true)
    else
        self._gameView:onSetButton(false)
		self._gameView.btTable:setVisible(false)
    end
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~动态加入：", self.cbDynamicJoin)
    local lTurnMaxScore = dataBuffer:readdouble()

        for i = 1,cmd.GAME_PLAYER do
        local n = table.maxn(self._gameView.tableScore[i])
        for j = 1,n do
            if self._gameView.tableScore[i][j] ~= nil then
		        self._gameView.tableScore[i][j]:setVisible(false)
                self._gameView.tableScore[i][j]:removeFromParent()
                self._gameView.tableScore[i][j] = nil
            end
        end
        self._gameView.tableUserAddScore[i]:setVisible(false)
    end
    self._gameView.animateCard:stopAllActions()
    self._gameView.animateCard:setVisible(false)
    local lTableScore = {}
    for i = 1, cmd.GAME_PLAYER do
        lTableScore[i] = dataBuffer:readdouble()
        if self.cbPlayStatus[i] == 1 and lTableScore[i] ~= 0 then
            local wViewChairId = self:SwitchViewChairID(i - 1)
            self._gameView:gameAddScore(wViewChairId, lTableScore[i])
        end
    end
    self.wBankerUser = dataBuffer:readword()
    --local lRoomStorageStart = dataBuffer:readdouble()
    --local lRoomStorageCurrent = dataBuffer:readdouble()
	self._gameView:setBankerUser(self:SwitchViewChairID(self.wBankerUser))
	self._gameView._csbNodebankTop:setVisible(true)
    self._gameView._csbNodebankTop:move(pointBankerFlag[self:SwitchViewChairID(self.wBankerUser)])
    self._gameView._csbbankTop:play("bankAnimTop", false)
	
    for i = 1, cmd.GAME_PLAYER do
        self.cbCardData[i] = {}
        for j = 1, 5 do
            self.cbCardData[i][j] = dataBuffer:readbyte()
        end
    end

    local bOxCard = {}
    for i = 1, cmd.GAME_PLAYER do
        bOxCard[i] = dataBuffer:readbyte()
        local wViewChairId = self:SwitchViewChairID(i - 1)
        if bOxCard[i] < 2 and self.cbPlayStatus[i] == 1  then
            self._gameView:setOpenCardVisible(wViewChairId, true)
        end

        if bOxCard[i] < 2 and self:GetMeChairID() + 1 == i then
            self._gameView.spritePrompt:setVisible(false)
            self._gameView.btOpenCard:setVisible(false)



        elseif bOxCard[i] > 2 and self:GetMeChairID() + 1 == i and  self.cbDynamicJoin == 0 then
            self._gameView.spritePrompt:setVisible(true)
            self._gameView.btOpenCard:setVisible(true)
            if self.cbPlayStatus[self:GetMeChairID() + 1] == 1 then
                self._gameView.nodePlayer[cmd.MY_VIEWID]:move(590 - 470, 75)
				
                if cmd.MY_VIEWID == self._gameView.wBankerViewChairId then 
					self._gameView._csbNodebankTop:move(585,70)
                    self._gameView._csbNodebankTop:move(585 - 470,70)
                end
            end
        end
    end
	


	
    self._gameView.btStart:setVisible(false);
    local lTurnScore = {}
    for i = 1, cmd.GAME_PLAYER do
        lTurnScore[i] = dataBuffer:readdouble()
    end
    local lCollectScore = {}
    for i = 1, cmd.GAME_PLAYER do
        lCollectScore[i] = dataBuffer:readdouble()
    end
        self.szGameRoomName = dataBuffer:readstring(cmd.SERVER_LEN)


    --self._gameView.spritePrompt:setVisible(false);



--    local lRobotScoreMin = dataBuffer:readdouble()
--    local lRobotScoreMax = dataBuffer:readdouble()
--    local lRobotBankGet = dataBuffer:readdouble()
--    local lRobotBankGetBanker = dataBuffer:readdouble()
--    local lRobotBankStoMul = dataBuffer:readdouble()
    -- 反作弊标识
--    local bIsAllowAvertCheat = dataBuffer:readbool()
--    -- 坐庄模式
--    self.m_tabPrivateRoomConfig.bankerMode = dataBuffer:readint()
--    -- 房卡积分模式
--    self.m_tabPrivateRoomConfig.bRoomCardScore = dataBuffer:readbool()
--    -- 积分房卡配置的下注
--    local tabJetton = {}
--    tabJetton[1] = dataBuffer:readdouble()
--    tabJetton[2] = dataBuffer:readdouble()
--    tabJetton[3] = dataBuffer:readdouble()
--    tabJetton[4] = dataBuffer:readdouble()
--    self.m_tabPrivateRoomConfig.lRoomCardJetton = tabJetton

    --显示牌并开自己的牌
    for i = 1, cmd.GAME_PLAYER do
        if self.cbPlayStatus[i] == 1 then
            if bOxCard[i] >=2 then
                local  wViewChairId = self:SwitchViewChairID(i - 1)
                for j = 1, 5 do
                    local card = self._gameView.nodeCard[wViewChairId][j]:setVisible(true)
                    --card:setVisible(true)
                    if wViewChairId == cmd.MY_VIEWID then          --是自己则打开牌
                        local value = GameLogic:getCardValue(self.cbCardData[i][j])
                        local color = GameLogic:getCardColor(self.cbCardData[i][j])
                        self._gameView:setCardTextureRect(wViewChairId,j, self.cbCardData[i][j],true,true)
                    end
                end
            else
                local wViewChairId = self:SwitchViewChairID(i - 1)
                for j = 1, 5 do
                    local card = self._gameView.nodeCard[wViewChairId][j]:setVisible(false)
                    if wViewChairId == cmd.MY_VIEWID then          --是自己则打开牌
                        self._gameView.MynodeCard[j]:setVisible(true)
                    else
                        self._gameView.nodeCard[wViewChairId][j]:setVisible(true)
                    end
                end
            end
        end
    end
		self._gameView._csbstart:setLastFrameCallFunc(nil)
	self._gameView._csbGameStart:setVisible(false)
    self._gameView:setBankerUser(self:SwitchViewChairID(self.wBankerUser))
    self._gameView:gameScenePlaying()
    self._gameView:setClockPosition()
    self:SetGameClock(self.wBankerUser, cmd.IDI_TIME_OPEN_CARD, cbPassTime)
	print("-----------------------------------------")
	print("----开牌剩余时间------",cbPassTime)
	print("-----------------------------------------")
    self._gameView.bCanMoveCard = true
    -- 刷新局数
    if PriRoom and GlobalUserItem.bPrivateRoom then
        local curcount = PriRoom:getInstance().m_tabPriData.dwPlayCount
        PriRoom:getInstance().m_tabPriData.dwPlayCount = curcount - 1
        if nil ~= self._gameView._priView and nil ~= self._gameView._priView.onRefreshInfo then
            self._gameView._priView:onRefreshInfo()
        end
    end
end

-- 游戏消息
function GameLayer:onEventGameMessage(sub,dataBuffer)
	if sub == cmd.SUB_S_CALL_BANKER then 
        self.m_cbGameStatus = cmd.GS_TK_CALL
		self:onSubCallBanker(dataBuffer)
	elseif sub == cmd.SUB_S_GAME_START then
        self.m_cbGameStatus = cmd.GS_TK_CALL 
		self:onSubGameStart(dataBuffer)
	elseif sub == cmd.SUB_S_ADD_SCORE then 
        self.m_cbGameStatus = cmd.GS_TK_SCORE
		self:onSubAddScore(dataBuffer)
	elseif sub == cmd.SUB_S_SEND_CARD then 
        self.m_cbGameStatus = cmd.GS_TK_PLAYING
		self:onSubSendCard(dataBuffer)
	elseif sub == cmd.SUB_S_OPEN_CARD then 
        self.m_cbGameStatus = cmd.GS_TK_PLAYING
		self:onSubOpenCard(dataBuffer)
	elseif sub == cmd.SUB_S_PLAYER_EXIT then 
        self.m_cbGameStatus = cmd.GS_TK_PLAYING
		self:onSubPlayerExit(dataBuffer)
	elseif sub == cmd.SUB_S_GAME_END then 
        self.m_cbGameStatus = cmd.GS_TK_PLAYING
		self:onSubGameEnd(dataBuffer)
	elseif sub == cmd.SUB_S_ALL_CARD then 
        --self.m_cbGameStatus = cmd.GS_TK_PLAYING
		self:onSubControl(dataBuffer)
	elseif sub == cmd.SUB_S_ADMIN_COLTERCARD then 
        --self.m_cbGameStatus = cmd.GS_TK_PLAYING
		self:onSubUpdataControlResult(dataBuffer)
	else
		print("unknow gamemessage sub is"..sub)
	end
end
function GameLayer:onSubUpdataControlResult(dataBuffer)
	local wPlayerID = dataBuffer:readword()
	
	for j = 1, 5 do
		self.cbCardData[wPlayerID + 1][j] = dataBuffer:readbyte()
	end
	
	--控制玩家需要执行
	if self._gameView.cbSurplusCardCount > 0 then
		--打开自己的牌
		for i = 1, 5 do
			local index = self:GetMeChairID() + 1
			local data = self.cbCardData[index][i]

			self._gameView:setCardTextureRect(index,i, self.cbCardData[index][i],true,false)
			
			local card_index = GameLogic:GetCardLogicValueToInt(data);
			local nMyIndex = self:SwitchViewChairID(wPlayerID)
			self._gameView:onUpdataControlResult(nMyIndex,i,card_index)
		end
		
			--清理控制数据
		for i = 1,self._gameView.cbSurplusCardCount do
			if self._gameView.ControlCardImage[i] ~= nil then
				self._gameView.ControlCardImage[i]:removeFromParent()
				self._gameView.ControlCardImage[i] = nil
			end
		end
		for i = 1,52 do		
			self._gameView.ControlCardImage[i] = nil
			self._gameView.bControlCardOut[i] = false
		end
		
		self._gameView:onControl()
	end
end

function GameLayer:onSendControlData(CardData,index,CardDataIndex)
	
	local Cardindex = self:GetMeChairID() + 1
    local value = self.cbCardData[Cardindex][index]
	
	local dataBuffer = CCmd_Data:create(2)
    dataBuffer:setcmdinfo(yl.MDM_GF_GAME, cmd.SUB_C_AMDIN_CHANGE_CARD)
    dataBuffer:pushbyte(value)
	dataBuffer:pushbyte(CardData)
	
	self._gameView.ControlCardData[CardDataIndex] = value;
		
    return self._gameFrame:sendSocketData(dataBuffer)
	
end
function GameLayer:onSubControl(dataBuffer)
	
	for i = 1, cmd.GAME_PLAYER do
		self._gameView.bAICount[i] = dataBuffer:readbool()
	end
	for i = 1, cmd.GAME_PLAYER do
        self._gameView.cbControlUserCardData[i] = {}
        for j = 1, 5 do
            self._gameView.cbControlUserCardData[i][j] = dataBuffer:readbyte()
        end
    end
	self._gameView.cbSurplusCardCount = dataBuffer:readbyte()
	for i = 1, 52 do
		self._gameView.ControlCardData[i] = dataBuffer:readbyte()
	end
	for j = 1,cmd.GAME_PLAYER  do
		if self.cbPlayStatus[j] == 1 then
			local viewId = self:SwitchViewChairID(j - 1)
			for i = 1, 5 do
				local data = self.cbCardData[j][i]

				if  viewId ~= cmd.MY_VIEWID  then
					self._gameView:setCardTextureRect(viewId,i, self.cbCardData[j][i],false,false)
					
					local cbOx = GameLogic:getCardType(self.cbCardData[j])
					if cbOx > 10 then	
						if cbOx == GameLogic.OX_FOURKING then
							cbOx = 11
						elseif cbOx == GameLogic.OX_FIVEKING  then
							cbOx = 12
						else 
							cbOx = 10
						end
					end
					local strFile = string.format("niu_%d", cbOx)
					self._gameView._csbcardType[viewId]:setVisible(true);
					self._gameView._csbUsercardType[viewId]:play(strFile, false)
				end
			end	
		end
	end

	
	
	self._gameView:onControl()
	
end
--用户叫庄
function GameLayer:onSubCallBanker(dataBuffer)

    self._gameView._csbGameStart:setVisible(true)
    self._gameView._csbstart:play("gameStart", false)
    function callBack()
        self._gameView._csbGameStart:setVisible(false)
        self._gameView:gameCallBanker(self:SwitchViewChairID(self.wCallBanker), self.bFirstTimes)
    end
        self._gameView._csbstart:setLastFrameCallFunc(callBack)

    local wCallBanker = dataBuffer:readword()
    local bFirstTimes = dataBuffer:readbool()
    if bFirstTimes then
        self.cbDynamicJoin = 0
        for i = 1, cmd.GAME_PLAYER do
            self.cbPlayStatus[i] = dataBuffer:readbyte()
        end
    end
    self.wCallBanker = wCallBanker
    self.bFirstTimes = bFirstTimes
    --self._gameView:gameCallBanker(self:SwitchViewChairID(wCallBanker), bFirstTimes)
    self._gameView:setClockPosition(self:SwitchViewChairID(wCallBanker))
    self:SetGameClock(wCallBanker, cmd.IDI_CALL_BANKER, cmd.TIME_USER_CALL_BANKER)
    self:PlaySound(GameViewLayer.RES_PATH.."sound/GAME_START.WAV")
    -- 刷新房卡
    if PriRoom and GlobalUserItem.bPrivateRoom then
        if nil ~= self._gameView._priView and nil ~= self._gameView._priView.onRefreshInfo then
            PriRoom:getInstance().m_tabPriData.dwPlayCount = PriRoom:getInstance().m_tabPriData.dwPlayCount + 1
            self._gameView._priView:onRefreshInfo()
        end
    end
end

--游戏开始
function GameLayer:onSubGameStart(dataBuffer)

    local int64 = Integer64:new()
    local lTurnMaxScore = dataBuffer:readdouble() 
    self.wBankerUser = dataBuffer:readword()
    for i = 1, cmd.GAME_PLAYER do
        self.cbPlayStatus[i] = dataBuffer:readbyte()
    end
    self._gameView.wFisrtChooseCallUser = self:SwitchViewChairID(dataBuffer:readword())
    self._gameView.randIndex = dataBuffer:readword()
    local lCellScore = dataBuffer:readdouble()
    self._gameView:setCellScore(lCellScore)
    self._gameView.btTable:setVisible(false)
    self._gameView.randIndexbak = -1

    self._gameView.wFisrtChooseCallUserBak = self._gameView.wFisrtChooseCallUser

    -- 坐庄模式
--    self.m_tabPrivateRoomConfig.bankerMode = dataBuffer:readint()

--    -- 房卡积分模式
--    self.m_tabPrivateRoomConfig.bRoomCardScore = dataBuffer:readbool()
--    -- 积分房卡配置的下注
--    local tabJetton = {}
--    tabJetton[1] = dataBuffer:readdouble()
--    tabJetton[2] = dataBuffer:readdouble()
--    tabJetton[3] = dataBuffer:readdouble()
--    tabJetton[4] = dataBuffer:readdouble()
--    self.m_tabPrivateRoomConfig.lRoomCardJetton = tabJetton

    self.cbDynamicJoin = 0
--    -- 玩家状态
--    for i = 1, cmd.GAME_PLAYER do
--        self.cbPlayStatus[i] = dataBuffer:readbyte()
--    end
    self._gameView:setBankerUser(self:SwitchViewChairID(self.wBankerUser))
    self._gameView:onSetButton(false)
    self._gameView._csbGameStart:setVisible(true)
    self._gameView._csbstart:play("gameStart", false)
    function callBack()
        self._gameView._csbGameStart:setVisible(false)
        self._gameView:runChooseBankerAnimate()
        --self._gameView:gameCallBanker(self:SwitchViewChairID(self.wCallBanker), self.bFirstTimes)
    end
        self._gameView._csbstart:setLastFrameCallFunc(callBack)
        
        


--    -- 积分房卡配置的下注
--    if self.m_tabPrivateRoomConfig.bRoomCardScore then
--        self._gameView:setScoreRoomJetton(tabJetton)
--    else
        self._gameView:setTurnMaxScore(lTurnMaxScore)
--    end

    --self._gameView:gameStart(self:SwitchViewChairID(self.wBankerUser))
    self._gameView:setClockPosition()
    self:SetGameClock(self.wBankerUser, cmd.IDI_TIME_USER_ADD_SCORE, cmd.TIME_USER_ADD_SCORE)
    self:PlaySound(GameViewLayer.RES_PATH.."sound/GAME_START.WAV")


    -- 刷新房卡
    if PriRoom and GlobalUserItem.bPrivateRoom then
        if nil ~= self._gameView._priView and nil ~= self._gameView._priView.onRefreshInfo then
            PriRoom:getInstance().m_tabPriData.dwPlayCount = PriRoom:getInstance().m_tabPriData.dwPlayCount + 1
            self._gameView._priView:onRefreshInfo()
        end
    end
end

--用户下注
function GameLayer:onSubAddScore(dataBuffer)
    local int64 = Integer64:new()
    local wAddScoreUser = dataBuffer:readword()
    local lAddScoreCount = dataBuffer:readdouble()

    local userViewId = self:SwitchViewChairID(wAddScoreUser)
    self._gameView:gameAddScore(userViewId, lAddScoreCount)

    self:PlaySound(GameViewLayer.RES_PATH.."sound/ADD_SCORE.WAV")
end

--发牌消息
function GameLayer:onSubSendCard(dataBuffer)
	--初始化已有玩家   
    local tableId = self._gameFrame:GetTableID()
    for i = 1, cmd.GAME_PLAYER do
        local userItem = self._gameFrame:getTableUserItem(tableId, i-1)
        if nil ~= userItem then
            local wViewChairId = self:SwitchViewChairID(i-1)
            self._gameView:OnUpdateUser(wViewChairId, userItem)
        end
		if nil == userItem then
			local wViewChairId = self:SwitchViewChairID(i-1)
			self._gameView:OnUpdateUser(wViewChairId, nil)
		end
    end
	
    local int64 = Integer64:new()
	self.wBankerUser = dataBuffer:readword()
    local lCellScore = dataBuffer:readdouble()
    self._gameView:setCellScore(lCellScore)
	
    for i = 1, cmd.GAME_PLAYER do
        self.cbPlayStatus[i] = dataBuffer:readbyte()
    end
	
    for i = 1, cmd.GAME_PLAYER do
        self.cbCardData[i] = {}
        for j = 1, 5 do
            self.cbCardData[i][j] = dataBuffer:readbyte()
        end
    end
	
    local x2, y2 = self._gameView.nodePlayer[cmd.MY_VIEWID]:getPosition()
    local x3, y3 = self._gameView._csbNodebankTop:getPosition()	
    if self.cbPlayStatus[self:GetMeChairID() + 1] == 1 then
        self._gameView.nodePlayer[cmd.MY_VIEWID]:runAction(cc.MoveTo:create(0.3,cc.p(x2 - 470, y2)))
        if cmd.MY_VIEWID == self._gameView.wBankerViewChairId then 
            self._gameView._csbNodebankTop:runAction(cc.MoveTo:create(0.3,cc.p(x3 - 470,y3)))
        end
    end

	--通比玩家自动下底注
	for i = 1,cmd.GAME_PLAYER do
		if self.cbPlayStatus[i] == 1 then
			local userViewId = self:SwitchViewChairID(i-1)
			self._gameView:gameAddScore(userViewId, lCellScore)
		end
	end
	self._gameView.btTable:setVisible(false)
    --打开自己的牌
    for i = 1, 5 do
        local index = self:GetMeChairID() + 1
        local data = self.cbCardData[index][i]
        local value = GameLogic:getCardValue(data)
        local color = GameLogic:getCardColor(data)
        --local card = self._gameView.nodeCard[cmd.MY_VIEWID]:getChildByTag(i)
        self._gameView:setCardTextureRect(index,i, self.cbCardData[index][i],true,false)
    end
	self:PlaySound(GameViewLayer.RES_PATH.."sound/GAME_START.WAV")
	self.cbDynamicJoin = 0
    self._gameView:onSetButton(false)
    self._gameView._csbGameStart:setVisible(true)
    self._gameView._csbstart:play("gameStart", false)
    function callBack()
        self._gameView._csbGameStart:setVisible(false)
         self._gameView:gameSendCard(self:SwitchViewChairID(self.wBankerUser), self:getPlayNum()*5)
    end
        self._gameView._csbstart:setLastFrameCallFunc(callBack)
		
		
		
   
    self:KillGameClock()
end

--用户摊牌
function GameLayer:onSubOpenCard(dataBuffer)
    local wPlayerID = dataBuffer:readword()
    local bOpen = dataBuffer:readbyte()
    local wViewChairId = self:SwitchViewChairID(wPlayerID)
    if wViewChairId == cmd.MY_VIEWID then
        self:openCard(wPlayerID)
        local x2, y2 = self._gameView.nodePlayer[cmd.MY_VIEWID]:getPosition()
        self._gameView.nodePlayer[cmd.MY_VIEWID]:runAction(cc.MoveTo:create(0.3,cc.p(x2 + 470, y2)))
            local x3, y3 = self._gameView._csbNodebankTop:getPosition()
            if cmd.MY_VIEWID == self._gameView.wBankerViewChairId then
                self._gameView._csbNodebankTop:runAction(cc.MoveTo:create(0.3,cc.p(x3 + 470, y3)))
            end
    else
        self._gameView:setOpenCardVisible(wViewChairId, true)
    end
    self:PlaySound(GameViewLayer.RES_PATH.."sound/OPEN_CARD.wav")
end

--用户强退
function GameLayer:onSubPlayerExit(dataBuffer)
    local wPlayerID = dataBuffer:readword()
    local wViewChairId = self:SwitchViewChairID(wPlayerID)
    self._gameView.nodePlayer[wViewChairId]:setVisible(false)
    self.cbPlayStatus[wPlayerID + 1] = 0
    if wViewChairId == cmd.MY_VIEWID then
        self._gameView.bCanMoveCard = false
        self._gameView.btOpenCard:setVisible(false)
        self._gameView.spritePrompt:setVisible(false)
    end
--    for i = 1, 5 do
--        self._gameView.cardFrame[i]:setVisible(false)
--        self._gameView.cardFrame[i]:setSelected(false)
--    end
    self._gameView:setOpenCardVisible(wViewChairId, false)
end


--游戏结束
function GameLayer:onSubGameEnd(dataBuffer)
    local int64 = Integer64:new()
	self._gameView.btOpenCard:setVisible(false)
	self._gameView.spritePrompt:setVisible(false)
    local lGameTax = {}
    for i = 1, cmd.GAME_PLAYER do
        lGameTax[i] = dataBuffer:readdouble()
    end
    self._gameView:onSetButton(true)
    self.lGameScore = {}
    for i = 1, cmd.GAME_PLAYER do
        self.lGameScore[i] = dataBuffer:readdouble()
    end
	
	--清理控制数据
	for i = 1,self._gameView.cbSurplusCardCount do
		if self._gameView.ControlCardImage[i] ~= nil then
			self._gameView.ControlCardImage[i]:removeFromParent()
			self._gameView.ControlCardImage[i] = nil
		end
	end
	for i = 1,52 do		
		self._gameView.ControlCardImage[i] = nil
		self._gameView.bControlCardOut[i] = false
	end
	self._gameView.cbSurplusCardCount  = 0; 
	
	
	-------------------------------------------
    --开牌
    self.data = {}
	local bCardData = {};
	for i = 1, cmd.GAME_PLAYER do
		bCardData[i] = i
        self.data[i] = {}
        for j = 1, 5 do
            self.data[i][j] = dataBuffer:readbyte()
        end
    end

	local bTempCardDataFont = {};


	local bSorted = false;
	local bTempData= cmd.GAME_PLAYER
    local bLast = cmd.GAME_PLAYER - 1
	
	for i = 1, bLast  do
		if self.cbPlayStatus[i] == 1 then
			for  j = i + 1,  cmd.GAME_PLAYER do
				if self.cbPlayStatus[j] == 1 then
					local data1 = 0
					local data2 = 0
					if GameLogic:getOxCard(self.data[i]) == true then
						data1 = 1
					end
					if GameLogic:getOxCard(self.data[j]) == true then
						data2 = 1
					end
					if GameLogic:CompareCard(self.data[i], self.data[j], 5, data1, data2) == true then
						--交换位置
						bTempData = bCardData[i];
						bCardData[i] = bCardData[j];
						bCardData[j] = bTempData;

						for m = 1,5 do
							bTempCardDataFont[m] = self.data[i][m]
							self.data[i][m] = self.data[j][m]
							self.data[j][m] = bTempCardDataFont[m]
						end
						bSorted = false;
					end
				end
			end
		end
	end
	local  nIndex = 0
	local  wViewChairId = 0
	for i = 1, cmd.GAME_PLAYER  do
		if self.cbPlayStatus[i] == 1 then
			wViewChairId = bCardData[i]
			local ChairId = wViewChairId
			self:runAction(cc.Sequence:create(cc.DelayTime:create(0.8 * nIndex),
			cc.CallFunc:create(function()
				self:openCard(ChairId - 1,true)
			end)))
		nIndex =  nIndex + 1
		end
	end
	       
	 self:runAction(cc.Sequence:create(cc.DelayTime:create(0.4 + 0.8 * nIndex),
	cc.CallFunc:create(function()
		self:GameEnd()
	end)))


		
 --[[   local  wViewChairId = self.wBankerUser + 1
    local  nIndex = 0
    while true do
    	--开始下一个人的发牌
		wViewChairId = wViewChairId + 1
		if wViewChairId > cmd.GAME_PLAYER then
	        wViewChairId = 1
		end

		while self.cbPlayStatus[wViewChairId] == 0 do
		   wViewChairId = wViewChairId + 1
	        if wViewChairId > cmd.GAME_PLAYER then
			    wViewChairId = 1
			end
		end 
        local ChairId = wViewChairId
        self:runAction(cc.Sequence:create(cc.DelayTime:create(0.8 * nIndex),
        cc.CallFunc:create(function()
            self:openCard(ChairId - 1,true)
        end)))
        nIndex =  nIndex + 1
        if wViewChairId == self.wBankerUser + 1 then
             self:runAction(cc.Sequence:create(cc.DelayTime:create(0.4 + 0.8 * nIndex),
            cc.CallFunc:create(function()
                self:GameEnd()
            end)))
            break
         end
    end--]]

--    for i = 1, cmd.GAME_PLAYER do
--        if self.cbPlayStatus[i] == 1 then
--            self:openCard(i - 1,true)
--        end
--    end

    local cbDelayOverGame = dataBuffer:readbyte()


end
function GameLayer:GameEnd()
	AudioEngine.playEffect(GameViewLayer.RES_PATH.."sound/CardType_Double_Line.wav")
	local winuser = 0
	for i = 1, cmd.GAME_PLAYER do
        if self.cbPlayStatus[i] == 1 and  self.lGameScore[i] > 0 then
			winuser = i
		end
	end
		for i = 1,self._gameView.AlltamaraCount do
		if self._gameView.Alltamara[i]  ~= nil then
			self._gameView.Alltamara[i]:removeFromParent()
			self._gameView.Alltamara[i] = nil
		end
	end
	self._gameView.AlltamaraCount = 1
	
    for i = 1, cmd.GAME_PLAYER do
        if self.cbPlayStatus[i] == 1 then
            local wViewChairId = self:SwitchViewChairID(i - 1)
            self._gameView:runWinLoseAnimate(wViewChairId, self.lGameScore[i])
            local bOK = false;
            if self.lGameScore[i] < 0 then
                bOK = true
                local randindex = 1;
                for j = 1,25 do
                    if randindex >1 then
                        if math.random(1,10) < 7 then
                            randindex = randindex - 1
                        end
                    end
                    self._gameView:ActionCardinal(randindex,wViewChairId,self:SwitchViewChairID(winuser - 1))
                    randindex = randindex+1
                end 
            end
        end
    end

    for i = 1, cmd.GAME_PLAYER do
        self.cbPlayStatus[i] = 0
    end

    local index = self:GetMeChairID() + 1
    self._gameView:gameEnd(self.lGameScore[index] > 0)

    self._gameView:setClockPosition(cmd.MY_VIEWID)
    -- 私人房无倒计时
    if not GlobalUserItem.bPrivateRoom then
        -- 设置倒计时
        self:SetGameClock(self:GetMeChairID(), cmd.IDI_START_GAME, cmd.TIME_USER_START_GAME)
    else
        self._gameView.spriteClock:setVisible(false)
    end
    --AudioEngine.playEffect(GameViewLayer.RES_PATH.."sound/GAME_END.WAV")
end
--开始游戏
function GameLayer:onStartGame()
    if true == self.m_bPriScoreLow then
        local msg = self.m_szScoreMsg or ""
        self.m_querydialog = QueryDialog:create(msg,function()
            self:onExitTable()
        end,nil,1)
        self.m_querydialog:setCanTouchOutside(false)
        self.m_querydialog:addTo(self)
    else
        -- body
        self:KillGameClock()
        self._gameView:onResetView()
        self._gameFrame:SendUserReady()
        self.m_bStartGame = true
    end

    
end

function GameLayer:getPlayNum()
    local num = 0
    for i = 1, cmd.GAME_PLAYER do
        if self.cbPlayStatus[i] == 1 then
            num = num + 1
        end
    end

    return num
end

--将视图id转换为普通id
function GameLayer:isPlayerPlaying(viewId)
    if viewId < 1 or viewId > cmd.GAME_PLAYER then
        print("view chair id error!")
        return false
    end

    for i = 1, cmd.GAME_PLAYER do
        if self:SwitchViewChairID(i - 1) == viewId then
            if self.cbPlayStatus[i] == 1 then
                return true
            end
        end
    end

    return false
end

function GameLayer:sendCardFinish()
    self._gameView:setClockPosition()
    self:SetGameClock(self:GetMeChairID(), cmd.IDI_TIME_OPEN_CARD, cmd.TIME_USER_OPEN_CARD)
end

function GameLayer:openCard(chairId, bEnded)
    --排列cbCardData
    local index = chairId + 1
    if self.cbCardData[index] == nil then
        print("出错")
        return false
    end
    GameLogic:getOxCard(self.cbCardData[index])
    local cbOx = GameLogic:getCardType(self.cbCardData[index])

    local viewId = self:SwitchViewChairID(chairId)
    for i = 1, 5 do
        local data = self.cbCardData[index][i]
        local value = GameLogic:getCardValue(data)
        local color = GameLogic:getCardColor(data)
        --local card = self._gameView.nodeCard[viewId]:getChildByTag(i)
        --self._gameView:setCardTextureRect(viewId,i, self.cbCardData[index][i],true)

       if viewId == cmd.MY_VIEWID then
            self._gameView.MynodeCard[i]:setVisible(true)
            self._gameView.nodeCard[viewId][i]:setVisible(false)
       end
       if  viewId ~= cmd.MY_VIEWID and bEnded == true   then
            self._gameView:setCardTextureRect(viewId,i, self.cbCardData[index][i],false,false)
       end
       if viewId == cmd.MY_VIEWID and bEnded == true   then
            local card_index = GameLogic:GetCardLogicValueToInt(data);
            self._gameView.MynodeCard[i]:loadTexture("card/pocker_middle/"..string.format("card_%d.png",card_index))
       end
    end

    self._gameView:gameOpenCard(viewId, cbOx, bEnded)

    return true
end

function GameLayer:getMeCardLogicValue(num)
    local index = self:GetMeChairID() + 1
    local value = GameLogic:getCardLogicValue(self.cbCardData[index][num])
    local str = string.format("index:%d, num:%d, self.cbCardData[index][num]:%d, return:%d", index, num, self.cbCardData[index][num], value)
    print(str)
    return value
end

function GameLayer:getOxCard(cbCardData)
    return GameLogic:getOxCard(cbCardData)
end

function GameLayer:getPrivateRoomConfig()
    return self.m_tabPrivateRoomConfig
end

--********************   发送消息     *********************--
function GameLayer:onBanker(cbBanker)
    local dataBuffer = CCmd_Data:create(1)
    dataBuffer:setcmdinfo(yl.MDM_GF_GAME,cmd.SUB_C_CALL_BANKER)
    dataBuffer:pushbyte(cbBanker)
    return self._gameFrame:sendSocketData(dataBuffer)
end

function GameLayer:onAddScore(lScore)
    print("牛牛 发送下注")
    if self:SwitchViewChairID(self.wBankerUser) == cmd.MY_VIEWID then
        print("牛牛: 自己庄家不下注")
        return
    end
    local dataBuffer = CCmd_Data:create(8)
    dataBuffer:setcmdinfo(yl.MDM_GF_GAME, cmd.SUB_C_ADD_SCORE)
    dataBuffer:pushdouble(lScore)
    return self._gameFrame:sendSocketData(dataBuffer)
end

function GameLayer:onOpenCard()
    local index = self:GetMeChairID() + 1
    local bOx = GameLogic:getOxCard(self.cbCardData[index])
    
    local dataBuffer = CCmd_Data:create(1)
    dataBuffer:setcmdinfo(yl.MDM_GF_GAME, cmd.SUB_C_OPEN_CARD)
    dataBuffer:pushbyte(bOx and 1 or 0)
    return self._gameFrame:sendSocketData(dataBuffer)
end

return GameLayer