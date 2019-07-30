local GameModel = appdf.req(appdf.CLIENT_SRC.."gamemodel.GameModel")
local GameLayer = class("GameLayer", GameModel)

local module_pre = "game.qipai.landnoshuffle.src"
local ExternalFun =  appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local cmd = appdf.req(module_pre .. ".models.CMD_Game")
local GameLogic = appdf.req(module_pre .. ".models.GameLogic")
local GameViewLayer = appdf.req(module_pre .. ".views.layer.GameViewLayer")
local GameResultLayer = appdf.req(module_pre .. ".views.layer.GameResultLayer")

function GameLayer:ctor( frameEngine,scene )   

    self:cachePublicRes()
    self.super.ctor(self, frameEngine, scene)
    self:OnInitGameEngine()
    self._roomRule = self._gameFrame._dwServerRule
    self.m_bLeaveGame = false    

    -- 一轮结束
    self.m_bRoundOver = false
    -- 自己是否是地主
    self.m_bIsMyBanker = false
    -- 地主座椅
    self.m_cbBankerChair = nil
    -- 提示牌数组
    self.m_tabPromptList = {}
    -- 当前出牌
    self.m_tabCurrentCards = {}
    -- 提示牌
    self.m_tabPromptCards = {}
    -- 比牌结果
    self.m_bLastCompareRes = false
    -- 上轮出牌视图
    self.m_nLastOutViewId = cmd.INVALID_VIEWID
    -- 上轮出牌
    self.m_tabLastCards = {}

    -- 是否叫分状态进入
    self.m_bCallStateEnter = false

    self.m_bTrustee=false
	
	-- 底注
	self.m_lCellScore = 0
	-- 叫分
	self.m_bankerscore = 0
	-- 叫分数组
	self.m_scoreinfo = {}

    --jipaiqi
    self.m_CardLeftCount = {};
    for i=1,15 do
        self.m_CardLeftCount[i] = 0
    end
end
function GameLayer:cachePublicRes(  )

    cc.SpriteFrameCache:getInstance():addSpriteFrames("plaza/plaza.plist")
    local dict = cc.FileUtils:getInstance():getValueMapFromFile("plaza/plaza.plist")
    framesDict = dict["frames"]
    if nil ~= framesDict and type(framesDict) == "table" then
        for k,v in pairs(framesDict) do
            local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame(k)
            if nil ~= frame then
                frame:retain()
            end
        end
    end
end

--获取gamekind
function GameLayer:getGameKind()
    return cmd.KIND_ID
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

function GameLayer:logData(msg)
    if nil ~= self._scene.logData then
        self._scene:logData(msg)
    end
end

function GameLayer:reSetData()
    self.m_bIsMyBanker = false
	self.m_cbBankerChair = nil
    self.m_tabPromptList = {}
    self.m_tabCurrentCards = {}
    self.m_tabPromptCards = {}
    self.m_bLastCompareRes = false
    self.m_nLastOutViewId = cmd.INVALID_VIEWID
    self.m_tabLastCards = {}    
end

function GameLayer:resetAllTrustee()
	self._gameView:resetAllTrustee()
end

---------------------------------------------------------------------------------------
------继承函数
-- 椅子号转视图位置,注意椅子号从0~nChairCount-1,返回的视图位置从1~nChairCount
function GameLayer:SwitchViewChairID(chair)
    local viewid = yl.INVALID_CHAIR
    local nChairCount = cmd.PLAYER_COUNT
    local nChairID = self:GetMeChairID()
    if chair ~= yl.INVALID_CHAIR and chair < nChairCount then
        viewid = math.mod(chair + math.floor(nChairCount * 3/2) - nChairID, nChairCount) + 1
    end
    return viewid
end

function GameLayer:onEnterTransitionFinish()
    GameLayer.super.onEnterTransitionFinish(self)
end

function GameLayer:onExit()
    cc.SpriteFrameCache:getInstance():removeSpriteFramesFromFile("plaza/plaza.plist")
    cc.Director:getInstance():getTextureCache():removeTextureForKey("plaza/plaza.png")
    self:KillGameClock()
    self:dismissPopWait()
    GameLayer.super.onExit(self)
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

--换位
function GameLayer:onChangeDesk()
     self._gameFrame:QueryChangeDesk()
end

--离开房间
function GameLayer:onExitRoom()
	self:getFrame():onCloseSocket()
	AppFacade:getInstance():sendNotification(GAME_COMMAMD.POP_VIEW, {Name = VIEW_LIST.GAME_LAYER})
end

-- 计时器响应
function GameLayer:OnEventGameClockInfo(chair,time,clockId)
    if nil ~= self._gameView and nil ~= self._gameView.updateClock then
        self._gameView:updateClock(clockId, time)
    end
end

-- 设置计时器
function GameLayer:SetGameClock(chair,id,time)
    GameLayer.super.SetGameClock(self,chair,id,time)
end

function GameLayer:onGetSitUserNum()
    return table.nums(self._gameView.m_tabUserHead)
end

function GameLayer:getUserInfoByChairID( chairid )
    local viewId = self:SwitchViewChairID(chairid)
    return self._gameView.m_tabUserItem[viewId]
end

function GameLayer:OnResetGameEngine()
    self:reSetData() 
    GameLayer.super.OnResetGameEngine(self)
end

-- 刷新提示列表
-- @param[cards]        出牌数据
-- @param[handCards]    手牌数据
-- @param[outViewId]    出牌视图id
-- @param[curViewId]    当前视图id
function GameLayer:updatePromptList(cards, handCards, outViewId, curViewId)
    self.m_tabCurrentCards = cards
    self.m_tabPromptList = {}

    local result = {}
    if outViewId == curViewId then
        self.m_tabCurrentCards = {}
        result = GameLogic:SearchOutCard(handCards, #handCards, {}, 0)
    else
        result = GameLogic:SearchOutCard(handCards, #handCards, cards, #cards)
    end

    --dump(result, "出牌提示", 6)    
    local resultCount = result[1]
    print("## 提示牌组 " .. resultCount)
    for i = resultCount, 1, -1 do
        local tmplist = {}
        local total = result[2][i]
        local cards = result[3][i]
        for j = 1, total do
            local cbCardData = cards[j] or 0
            table.insert(tmplist, cbCardData)
        end
        table.insert(self.m_tabPromptList, tmplist)
    end
    self.m_tabPromptCards = self.m_tabPromptList[#self.m_tabPromptList] or {}
    self._gameView.m_promptIdx = 0
end

-- 扑克对比
-- @param[cards]        当前出牌
-- @param[outView]      出牌视图id
function GameLayer:compareWithLastCards( cards, outView)
    local bRes = false
    self.m_bLastCompareRes = false
    local outCount = #cards
    if outCount > 0 then
        if outView ~= self.m_nLastOutViewId then
            --返回true，表示cards数据大于m_tagLastCards数据
            self.m_bLastCompareRes = GameLogic:CompareCard(self.m_tabLastCards, #self.m_tabLastCards, cards, outCount)
            self.m_nLastOutViewId = outView
        end
        self.m_tabLastCards = cards
    end
    return bRes
end

------------------------------------------------------------------------------------------------------------
--网络处理
------------------------------------------------------------------------------------------------------------

-- 发送准备
function GameLayer:sendReady()
    self:KillGameClock()
    self._gameFrame:SendUserReady()
end

-- 发送叫分
function GameLayer:sendCallScore( score )
    self:KillGameClock()
    local cmddata = CCmd_Data:create(1)
    cmddata:pushbyte(score)
    self:SendData(cmd.SUB_C_CALL_SCORE,cmddata)
end

-- 发送托管
function GameLayer:sendUserTrustee(bTrustee)
	local cmd_data = CCmd_Data:create(1)
	cmd_data:pushbool(bTrustee)
	self:SendData(cmd.SUB_C_TRUSTEE, cmd_data)
end

-- 发送出牌
function GameLayer:sendOutCard(cards, bPass)
    self:KillGameClock()
    if bPass then
        local cmddata = CCmd_Data:create()
        self:SendData(cmd.SUB_C_PASS_CARD,cmddata)
    else
        local cardcount = #cards
        local cmddata = CCmd_Data:create(1 + cardcount)
        cmddata:pushbyte(cardcount)
        for i = 1, cardcount do
            cmddata:pushbyte(cards[i])
        end
        self:SendData(cmd.SUB_C_OUT_CARD,cmddata)
    end
end

-- 发送加倍/不加倍
function GameLayer:sendMultiple(isMultiple)
	self:KillGameClock()
	local cmd_data = CCmd_Data:create(1)
	cmd_data:pushbool(isMultiple)
	self:SendData(cmd.SUB_C_MULTIPLE, cmd_data)
end

-- 场景信息
function GameLayer:onEventGameScene(cbGameStatus,dataBuffer)
    print("场景数据:" .. cbGameStatus)
    if self.m_bOnGame then
        return
    end
    self.m_cbGameStatus = cbGameStatus
    self.m_bOnGame = true
    --初始化已有玩家
    for i = 1, cmd.PLAYER_COUNT do
        local userItem = self._gameFrame:getTableUserItem(self._gameFrame:GetTableID(), i-1)
        if nil ~= userItem then
            local wViewChairId = self:SwitchViewChairID(i-1)
            self._gameView:OnUpdateUser(wViewChairId, userItem)
            if PriRoom then
                PriRoom:getInstance():onEventUserState(wViewChairId, userItem, false)
            end
        end
    end
    
    if cbGameStatus == cmd.GAME_SCENE_FREE then                                 --空闲状态
        self:onEventGameSceneFree(dataBuffer)
    elseif cbGameStatus == cmd.GAME_SCENE_CALL then                             --叫分状态
        self.m_bCallStateEnter = true
        self:onEventGameSceneCall(dataBuffer)
    elseif cbGameStatus == cmd.GAME_SCENE_PLAY then                             --游戏状态
        self:onEventGameScenePlay(dataBuffer)
	elseif cbGameStatus == cmd.GAME_SCENE_MULTIPLE then						-- 加倍状态
		self:onEventGameSceneMultiple(dataBuffer)
    end
    self:dismissPopWait()
end

-- 开始游戏（空闲状态）
function GameLayer:onEventGameSceneFree( dataBuffer )
    local cmd_table = ExternalFun.read_netdata(cmd.CMD_S_StatusFree, dataBuffer)
    dump(cmd_table, "scene free", 6)
--    cmd.COUNTDOWN_READY = cmd_table.cbTimeStartGame
--    cmd.COUNTDOWN_CALLSCORE = cmd_table.cbTimeCallScore
--    cmd.COUNTDOWN_OUTCARD = cmd_table.cbTimeOutCard
--    cmd.COUNTDOWN_HANDOUTTIME = cmd_table.cbTimeHeadOutCard
    -- 更新底分
    self._gameView:onGetCellScore(cmd_table.lCellScore)
	self.m_lCellScore = cmd_table.lCellScore
	self:KillGameClock()
	
    -- 空闲消息, 进入游戏即发准备给服务端
    self._gameView:onGetGameFree()
	self._gameView:onClickReady()
	-- 进入游戏不用准备倒计时
--[[     -- 私人房无倒计时
	if not GlobalUserItem.bPrivateRoom then
        -- 设置倒计时
        self:SetGameClock(self:GetMeChairID(), cmd.TAG_COUNTDOWN_READY, cmd_table.cbTimeStartGame)
    end--]]
end

function GameLayer:onEventGameSceneCall( dataBuffer )
    local cmd_table = ExternalFun.read_netdata(cmd.CMD_S_StatusCall, dataBuffer)
    dump(cmd_table, "scene call", 6)
--    cmd.COUNTDOWN_READY = cmd_table.cbTimeStartGame
--    cmd.COUNTDOWN_CALLSCORE = cmd_table.cbTimeCallScore
--    cmd.COUNTDOWN_OUTCARD = cmd_table.cbTimeOutCard
--    cmd.COUNTDOWN_HANDOUTTIME = cmd_table.cbTimeHeadOutCard

    self.m_bRoundOver = false
    -- 更新底分
    self._gameView:onGetCellScore(cmd_table.lCellScore)
	self.m_lCellScore = cmd_table.lCellScore
    -- 叫分信息
    local scoreinfo = cmd_table.cbScoreInfo[1]
    local tmpScore = 0
    local lastScore = 0
    local lastViewId = self:SwitchViewChairID(cmd_table.wCurrentUser)
    for i = 1, 3 do
        local chair = i - 1
        local score = scoreinfo[i]
        -- 扑克
        local viewId = self:SwitchViewChairID(chair)
		self.m_scoreinfo[viewId] = score
        if chair ~= cmd_table.wCurrentUser and 0 ~= score then
            self._gameView:onGetCallScore(-1, viewId, 0, score, true)
        end

        if 0 ~= score then
            tmpScore = ((score == 255) and 0 or score)
        end

        if tmpScore > lastScore then
            lastScore = tmpScore
            lastViewId = viewId
        end
    end
    -- 叫分状态
    local currentScore = cmd_table.cbBankerScore
    local curViewId = self:SwitchViewChairID(cmd_table.wCurrentUser)

    -- 玩家拿牌
    local cards = GameLogic:SortCardList(cmd_table.cbHandCardData[1], cmd.NORMAL_COUNT, 0)
    self._gameView:onGetGameCard(cmd.MY_VIEWID, cards, true)
    -- 其余玩家
    local empTyCard = GameLogic:emptyCardList(cmd.NORMAL_COUNT)
    self._gameView:onGetGameCard(cmd.LEFT_VIEWID, empTyCard, true)
    empTyCard = GameLogic:emptyCardList(cmd.NORMAL_COUNT)
    self._gameView:onGetGameCard(cmd.RIGHT_VIEWID, empTyCard, true)

    self._gameView:onGetCallScore(curViewId, lastViewId, currentScore, lastScore, false, self.m_scoreinfo[lastViewId])
	self.m_scoreinfo[lastViewId] = lastScore
	-- 设置闹钟位于叫分位置
--	self._gameView:setCallTimerPosition()
    -- 设置倒计时
    self:SetGameClock(cmd_table.wCurrentUser, cmd.TAG_COUNTDOWN_CALLSCORE, cmd_table.cbTimeCallScore)

    -- 刷新局数
    if PriRoom and GlobalUserItem.bPrivateRoom then
        local curcount = PriRoom:getInstance().m_tabPriData.dwPlayCount
        PriRoom:getInstance().m_tabPriData.dwPlayCount = curcount - 1
        if nil ~= self._gameView._priView and nil ~= self._gameView._priView.onRefreshInfo then
            self._gameView._priView:onRefreshInfo()
        end
    end
	-- 隐藏换桌按钮
	self._gameView:hideChangeTable(false)
	self._gameView:resetTip()
	self._gameView:setQuitEnable(false)
end

function GameLayer:onEventGameSceneMultiple( dataBuffer )
    local cmd_table = ExternalFun.read_netdata(cmd.CMD_S_StatusMultiple, dataBuffer)
    dump(cmd_table, "scene multiple", 6)
--    cmd.COUNTDOWN_READY = cmd_table.cbTimeStartGame
--    cmd.COUNTDOWN_CALLSCORE = cmd_table.cbTimeCallScore
--    cmd.COUNTDOWN_OUTCARD = cmd_table.cbTimeOutCard
--    cmd.COUNTDOWN_HANDOUTTIME = cmd_table.cbTimeHeadOutCard

    self.m_bRoundOver = false
    -- 更新底分
    self._gameView:onGetCellScore(cmd_table.lCellScore)
	self.m_lCellScore = cmd_table.lCellScore
    -- 用户手牌
    local countlist = cmd_table.cbHandCardCount[1]
    for i = 1, 3 do
        local chair = i - 1
        local cards = {}
        local count = countlist[i]
        local viewId = self:SwitchViewChairID(chair)
        if cmd.MY_VIEWID == viewId then
            local tmp = cmd_table.cbHandCardData[1]
            for j = 1, count do
                table.insert(cards, tmp[j])
            end
            cards = GameLogic:SortCardList(cards, count, 0)
        else
            cards = GameLogic:emptyCardList(count)
        end
        self._gameView:onGetGameCard(viewId, cards, true)
    end

    -- 庄家信息    
    local bankerView = self:SwitchViewChairID(cmd_table.wBankerUser)
    local bankerCards = GameLogic:SortCardList(cmd_table.cbBankerCard[1], 3, 0)
    local bankerscore = cmd_table.cbBankerScore
	self.m_bankerscore = bankerscore
    if self:IsValidViewID(bankerView) then
        self._gameView:onGetBankerInfo(bankerView, bankerscore, bankerCards, true)
    end
    self.m_cbBankerChair = cmd_table.wBankerUser
    -- 自己是否庄家
    self.m_bIsMyBanker = (bankerView == cmd.MY_VIEWID)
	
	-- 托管信息
	local bTrustee = cmd_table.bTrustee[1]
	for k,v in pairs(bTrustee) do			
		local view = self:SwitchViewChairID(k-1)
		self._gameView:setUserTrustee(view, v)
	end
	self._gameView:onGameScenePlay(countlist)
	local isWaitMultiple = false
	-- 地主不加倍
	if bankerView ~= cmd.MY_VIEWID then
		isWaitMultiple = self._gameView:onSubStartMultiple(cmd_table.lEnterScore)
	end
	-- 设置倒计时
	if isWaitMultiple then
		self:SetGameClock(self:GetMeChairID(), cmd.TAG_MULTIPLE, cmd_table.cbMultiple)
	end
	-- 隐藏换桌按钮
	self._gameView:hideChangeTable(false)
	self._gameView:resetTip()
	self._gameView:setQuitEnable(false)
end

function GameLayer:onEventGameScenePlay( dataBuffer )
    local cmd_table = ExternalFun.read_netdata(cmd.CMD_S_StatusPlay, dataBuffer)
    dump(cmd_table, "scene play", 6)
--    cmd.COUNTDOWN_READY = cmd_table.cbTimeStartGame
--    cmd.COUNTDOWN_CALLSCORE = cmd_table.cbTimeCallScore
--    cmd.COUNTDOWN_OUTCARD = cmd_table.cbTimeOutCard
--    cmd.COUNTDOWN_HANDOUTTIME = cmd_table.cbTimeHeadOutCard

    self.m_bRoundOver = false
    -- 更新底分
    self._gameView:onGetCellScore(cmd_table.lCellScore)
	self.m_lCellScore = cmd_table.lCellScore
    -- 用户手牌
    local countlist = cmd_table.cbHandCardCount[1]
    for i = 1, 3 do
        local chair = i - 1
        local cards = {}
        local count = countlist[i]
        local viewId = self:SwitchViewChairID(chair)
        if cmd.MY_VIEWID == viewId then
            local tmp = cmd_table.cbHandCardData[1]
            for j = 1, count do
                table.insert(cards, tmp[j])
            end
            cards = GameLogic:SortCardList(cards, count, 0)
        else
            cards = GameLogic:emptyCardList(count)
        end
        self._gameView:onGetGameCard(viewId, cards, true)
    end
    -- 庄家信息
    local bankerView = self:SwitchViewChairID(cmd_table.wBankerUser)
	self._gameView:onGetStartOutCard(bankerView)
    local bankerCards = GameLogic:SortCardList(cmd_table.cbBankerCard[1], 3, 0)
    local bankerscore = cmd_table.cbBankerScore
	self.m_bankerscore = bankerscore
    if self:IsValidViewID(bankerView) then
        self._gameView:onGetBankerInfo(bankerView, bankerscore, bankerCards, true)
    end
    self.m_cbBankerChair = cmd_table.wBankerUser
    -- 自己是否庄家
    self.m_bIsMyBanker = (bankerView == cmd.MY_VIEWID)
    
    -- 出牌信息
    local cbOutTime = cmd_table.cbTimeOutCard
    local lastOutView = self:SwitchViewChairID(cmd_table.wTurnWiner)
    local outCards = {}
    local serverOut = cmd_table.cbTurnCardData[1]
    for i = 1, cmd_table.cbTurnCardCount do
        table.insert(outCards, serverOut[i])
    end
	
	-- 托管信息
	local bTrustee = cmd_table.bTrustee[1]
	for k,v in pairs(bTrustee) do			
		local view = self:SwitchViewChairID(k-1)
		self._gameView:setUserTrustee(view, v)
	end
	
    outCards = GameLogic:SortCardList(outCards, cmd_table.cbTurnCardCount, 0)
    local currentView = self:SwitchViewChairID(cmd_table.wCurrentUser)
	self._gameView:onGameScenePlay(countlist)
    if self:IsValidViewID(lastOutView) and self:IsValidViewID(currentView) then
        self.m_nLastOutViewId = lastOutView
        self:compareWithLastCards(outCards, lastOutView)

        if currentView == cmd.MY_VIEWID then
            -- 构造提示
            local handCards = self._gameView.m_tabNodeCards[cmd.MY_VIEWID]:getHandCards()

            
            self:updatePromptList(outCards, handCards, currentView, lastOutView)
        end

        -- 不出按钮
        if #self.m_tabPromptList > 0 then
            self._gameView:onChangePassBtnState(not (currentView == lastOutView--[[#self.m_tabPromptList > 0]]))
        else
            self._gameView:onChangePassBtnState( true )
        end        

        self._gameView:onGetOutCard(currentView, lastOutView, outCards, true)

		local promptList = self.m_tabPromptList
		local timeOutCard = cmd_table.cbTimeOutCard
		local timerId = cmd.TAG_COUNTDOWN_OUTCARD
		if currentView == cmd.MY_VIEWID and #promptList == 0 then
			timeOutCard = 5
			timerId = cmd.TAG_COUNTDOWN_PASS
		end
		-- 设置倒计时
		self:SetGameClock(cmd_table.wCurrentUser, timerId, timeOutCard)
    end
		-- 隐藏换桌按钮
	self._gameView:hideChangeTable(false)
	self._gameView:resetTip()
	self._gameView:setQuitEnable(false)
end

function GameLayer:onEventGameMessage(sub,dataBuffer)
    if nil == self._gameView then
        return
    end

    if cmd.SUB_S_GAME_START == sub then                 --游戏开始
        self.m_cbGameStatus = cmd.GAME_SCENE_CALL
        self:onSubGameStart(dataBuffer)
	elseif cmd.SUB_S_OTHER_CARDS == sub then                 --看其它人的牌
        self:onSubOtherCards(dataBuffer)
    elseif cmd.SUB_S_CALL_SCORE == sub then             --用户叫分
        self.m_cbGameStatus = cmd.GAME_SCENE_CALL
        self:onSubCallScore(dataBuffer)
    elseif cmd.SUB_S_BANKER_INFO == sub then            --庄家信息
        self.m_cbGameStatus = cmd.GAME_SCENE_PLAY
        self:onSubBankerInfo(dataBuffer)
    elseif cmd.SUB_S_OUT_CARD == sub then               --用户出牌
        self.m_cbGameStatus = cmd.GAME_SCENE_PLAY
        self:onSubOutCard(dataBuffer)
    elseif cmd.SUB_S_PASS_CARD == sub then              --用户放弃
        self.m_cbGameStatus = cmd.GAME_SCENE_PLAY
        self:onSubPassCard(dataBuffer)
	elseif sub == cmd.SUB_S_TRUSTEE then 					--用户托管
        self.m_btrustee=true
		return self:onSubTrustee(dataBuffer)
    elseif cmd.SUB_S_GAME_CONCLUDE == sub then          --游戏结束
        self.m_cbGameStatus = cmd.GAME_SCENE_END
        self:onSubGameConclude(dataBuffer)
	elseif cmd.SUB_S_MULTIPLE == sub then					--是否加倍
        self:onSubMultiple(dataBuffer)	
	elseif cmd.SUB_S_START_OUTCARD == sub then			-- 开始出牌
		self:onSubStartOutCard(dataBuffer)
    end
end

-- 文本聊天
function GameLayer:onUserChat(chatdata, chairid)
    local viewid = self:SwitchViewChairID(chairid)    
    if self:IsValidViewID(viewid) then
        self._gameView:onUserChat(chatdata, viewid)
    end
end

-- 表情聊天
function GameLayer:onUserExpression(chatdata, chairid)
    local viewid = self:SwitchViewChairID(chairid)
    if self:IsValidViewID(viewid) then
        self._gameView:onUserExpression(chatdata, viewid)
    end
end

-- 语音播放开始
function GameLayer:onUserVoiceStart( useritem, filepath )
    local viewid = self:SwitchViewChairID(useritem.wChairID)
    local roleItem = self._gameView.m_tabUserHead[viewid]
    if nil ~= roleItem then
        roleItem:onUserVoiceStart()
    end
end

-- 语音播放结束
function GameLayer:onUserVoiceEnded( useritem, filepath )
    local viewid = self:SwitchViewChairID(useritem.wChairID)
    local roleItem = self._gameView.m_tabUserHead[viewid]
    if nil ~= roleItem then
        roleItem:onUserVoiceEnded()
    end
end

-- 游戏开始
function GameLayer:onSubGameStart(dataBuffer)
    local cmd_table = ExternalFun.read_netdata(cmd.CMD_S_GameStart, dataBuffer)
    --dump(cmd_table, "onSubGameStart", 6)

    --clear jipaiqi
    for i=1,13 do
        self.m_CardLeftCount[i] = 4
    end
    self.m_CardLeftCount[14] = 1
    self.m_CardLeftCount[15] = 1
    self._gameView:updateCardLeftCount(self.m_CardLeftCount)

    self.m_bRoundOver = false
    self:reSetData()
	self:resetAllTrustee()
    --游戏开始
    self._gameView:onGameStart()
    -- print("cmd_table.wCurrentUser")
    -- dump(cmd_table.wCurrentUser)
    local curView = self:SwitchViewChairID(cmd_table.wCurrentUser)
    local startView = self:SwitchViewChairID(cmd_table.wStartUser)   

    self:KillGameClock()
    if self:IsValidViewID(curView) and self:IsValidViewID(startView) then
        print("&& 游戏开始 " .. curView .. " ## " .. startView)
        -- 游戏开始音效
        self.curView = curView
        self.startView = startView
        ExternalFun.playSoundEffect( "start.wav" )
        --发牌
--        local carddata = GameLogic:SortCardList(cmd_table.cbCardData[1], cmd.NORMAL_COUNT, 0)
        self._gameView:onGetGameCard(cmd.MY_VIEWID, cmd_table.cbCardData[1], false)

        self:runAction(cc.Sequence:create(cc.DelayTime:create(2),cc.CallFunc:create(function ( ... )
            -- body
            self._gameView:onGetCallScore(self.curView, self.startView, 0, -1, false)
             -- 设置倒计时
            self:SetGameClock(cmd_table.wCurrentUser, cmd.TAG_COUNTDOWN_CALLSCORE, cmd_table.cbTimeCallScore)
        end)))
            

    else
        print("viewid invalid" .. curView .. " ## " .. startView)
    end
end

-- 游戏看其它人的牌
function GameLayer:onSubOtherCards(dataBuffer)
    local cmd_table = ExternalFun.read_netdata(cmd.CMD_S_Other_CardData, dataBuffer)
	for i=1,3 do
		local viewId = self:SwitchViewChairID(i-1)
		if cmd.MY_VIEWID ~= viewId then
			self._gameView:onGetOtherCards(viewId, cmd_table.cbCardDataList[i])
		end
	end
end

-- 用户叫分
function GameLayer:onSubCallScore(dataBuffer)
    local cmd_table = ExternalFun.read_netdata(cmd.CMD_S_CallScore, dataBuffer)
    --dump(cmd_table, "CMD_S_CallScore", 3)

    local curView = self:SwitchViewChairID(cmd_table.wCurrentUser)
    print("curView")
    dump(cmd_table.wCurrentUser)
    local lastView = self:SwitchViewChairID(cmd_table.wCallScoreUser)    
	if self:IsValidViewID(lastView) then
		 print("&& 游戏叫分 " .. curView .. " ## " .. lastView)
        self._gameView:onGetCallScore(curView, lastView, cmd_table.cbCurrentScore, cmd_table.cbUserCallScore, false,self.m_scoreinfo[lastView])
		self.m_scoreinfo[lastView] = cmd_table.cbUserCallScore
	end
    if self:IsValidViewID(curView) and self:IsValidViewID(lastView) then
        -- 设置倒计时
        self:SetGameClock(cmd_table.wCurrentUser, cmd.TAG_COUNTDOWN_CALLSCORE, cmd_table.cbTimeCallScore)
    else
        print("viewid invalid" .. curView .. " ## " .. lastView)
    end    
end

-- 开始出牌
function GameLayer:onSubStartOutCard(dataBuffer)
	local cmd_table = ExternalFun.read_netdata(cmd.CMD_S_START_OUTCARD, dataBuffer)
	-- 构造提示
	local bankerView = self:SwitchViewChairID(self.m_cbBankerChair)
	local handCards = self._gameView.m_tabNodeCards[bankerView]:getHandCards()
	if bankerView == cmd.MY_VIEWID then
		self:updatePromptList({}, handCards, cmd.MY_VIEWID, cmd.MY_VIEWID)

		-- 不出按钮
		self._gameView:onChangePassBtnState(false)

		-- 开始出牌
		self._gameView:onGetOutCard(bankerView, bankerView, {})
	end
	self._gameView:onGetStartOutCard(bankerView)
	self.m_cbBankerChair = cmd_table.wBankerUser
	self:SetGameClock(self.m_cbBankerChair, cmd.TAG_COUNTDOWN_OUTCARD, cmd_table.cbTimeHeadOutCard)
end

-- 庄家信息
function GameLayer:onSubBankerInfo(dataBuffer)
    local cmd_table = ExternalFun.read_netdata(cmd.CMD_S_BankerInfo, dataBuffer)
    --dump(cmd_table, "onSubBankerInfo", 6)
    local bankerView = self:SwitchViewChairID(cmd_table.wBankerUser)
    local curView = self:SwitchViewChairID(cmd_table.wCurrentUser)
	-- 重置托管状态
	self:resetAllTrustee()
	
    -- 自己是否庄家
    self.m_bIsMyBanker = (bankerView == cmd.MY_VIEWID)

    -- 庄家信息
    if self:IsValidViewID(bankerView) and self:IsValidViewID(curView) then
       -- print("&& 庄家信息 " .. bankerView .. " ## " .. curView)
        -- 音效
        ExternalFun.playSoundEffect( "bankerinfo.wav" )

		self.m_cbBankerChair = cmd_table.wBankerUser
        local bankercard = GameLogic:SortCardList(cmd_table.cbBankerCard[1], 3, 0)
        self._gameView:onGetBankerInfo(bankerView, cmd_table.cbBankerScore, bankercard, false)
		self.m_bankerscore = cmd_table.cbBankerScore
        self.m_nLastOutViewId = bankerView
--[[        -- 构造提示
        local handCards = self._gameView.m_tabNodeCards[bankerView]:getHandCards()
        if bankerView == cmd.MY_VIEWID then
            self:updatePromptList({}, handCards, cmd.MY_VIEWID, cmd.MY_VIEWID)

            -- 不出按钮
            self._gameView:onChangePassBtnState(false)

            -- 开始出牌
            self._gameView:onGetOutCard(curView, curView, {})
        end--]]
		local isWaitMultiple = false
		-- 地主不加倍
		if bankerView ~= cmd.MY_VIEWID then
			isWaitMultiple = self._gameView:onSubStartMultiple(cmd_table.lEnterScore)
		end
        -- 设置倒计时
		if isWaitMultiple then
			self:SetGameClock(self:GetMeChairID(), cmd.TAG_MULTIPLE, cmd_table.cbMultiple)
		end
    else
        print("viewid invalid" .. bankerView .. " ## " .. curView)
    end

    -- 刷新局数
    if PriRoom and not self.m_bCallStateEnter and GlobalUserItem.bPrivateRoom then
        local curcount = PriRoom:getInstance().m_tabPriData.dwPlayCount
        PriRoom:getInstance().m_tabPriData.dwPlayCount = curcount + 1
        if nil ~= self._gameView._priView and nil ~= self._gameView._priView.onRefreshInfo then
            self._gameView._priView:onRefreshInfo()
        end
    end
    self.m_bCallStateEnter = false
end

-- 用户出牌
function GameLayer:onSubOutCard(dataBuffer)
self:KillGameClock()
    local cmd_table = ExternalFun.read_netdata(cmd.CMD_S_OutCard, dataBuffer)
    local cmddata=ExternalFun.read_netdata(cmd.CMD_S_Trustee, dataBuffer)
    --dump(cmd_table, "onSubOutCard", 6)

    local curView = self:SwitchViewChairID(cmd_table.wCurrentUser)
    local outView = self:SwitchViewChairID(cmd_table.wOutCardUser)

    -- local SubTrustee = self:SwitchViewChairID(cmddata.bTrustee)
  --  print("&&&&&&&&&&&&&&&出牌 " .. outView .. " ## " .. curView)
    local outCard = cmd_table.cbCardData[1]
    local outCount = #outCard
    local carddata = GameLogic:SortCardList(outCard, outCount, 0)

    --jipaishuju
    for i=1,outCount do 
        local cardValue = outCard[i]
        if cardValue == 0x4E then
            self.m_CardLeftCount[14] = self.m_CardLeftCount[14] -1
        else
            if cardValue == 0x4F then
                self.m_CardLeftCount[15] = self.m_CardLeftCount[15] -1
            else
               cardValue =  GameLogic:GetCardValue(cardValue)
               self.m_CardLeftCount[cardValue] = self.m_CardLeftCount[cardValue] -1
            end
        end
    end
    self._gameView:updateCardLeftCount(self.m_CardLeftCount)
    -- 扑克对比
    self:compareWithLastCards(carddata, outView)

    -- 构造提示
    local handCards = self._gameView.m_tabNodeCards[cmd.MY_VIEWID]:getHandCards()
    self:updatePromptList(carddata, handCards, outView, curView)
    local promptList = self.m_tabPromptList
    local isAutoOutCard = false
    if  curView == cmd.MY_VIEWID and #handCards == outCount and #handCards <= 20 and #promptList > 0  then
            local cbCardData = GameLogic:SortCardList(handCards, #handCards, 0)
            local cbCardCount = #handCards
            local cbOutType = GameLogic:GetCardType(cbCardData, cbCardCount)
            if cbOutType == GameLogic.CT_SINGLE or cbOutType == GameLogic.CT_DOUBLE or cbOutType == GameLogic.CT_THREE or cbOutType == GameLogic.CT_SINGLE_LINE
             or cbOutType == GameLogic.CT_DOUBLE_LINE or cbOutType == GameLogic.CT_THREE_LINE or cbOutType == GameLogic.CT_THREE_TAKE_ONE or cbOutType == GameLogic.CT_THREE_TAKE_TWO 
             or cbOutType == GameLogic.CT_FOUR_TAKE_ONE or cbOutType == GameLogic.CT_FOUR_TAKE_TWO or cbOutType == GameLogic.CT_BOMB_CARD or cbOutType == GameLogic.CT_MISSILE_CARD then
                -- 自动出牌
                isAutoOutCard = true
            end
    end
            
    -- 不出按钮
    self._gameView:onChangePassBtnState(true)

    self._gameView:onGetOutCard(curView, outView, carddata)
    -- 倍数更新
    self._gameView:updateMultiple(cmd_table.lMultiple)

    if isAutoOutCard then
        -- 自动出牌
        self._gameView:onPromptOut(false)
        self._gameView:onOutCard()
    else
        -- 设置倒计时
        local bSysOut = cmd_table.bSysOut
        local timeOutCard = cmd_table.cbTimeOutCard
        local timerId = cmd.TAG_COUNTDOWN_OUTCARD
        if curView == cmd.MY_VIEWID or bSysOut==true then 
            if #promptList == 0 then
                timeOutCard = 10
                timerId = cmd.TAG_COUNTDOWN_PASS
            else
                timeOutCard=10
                timerId = cmd.TAG_COUNTDOWN_OUTCARD 
            end

        end
        -- 设置倒计时
        self:SetGameClock(cmd_table.wCurrentUser, timerId, timeOutCard)
    end
end

-- 加倍
function GameLayer:onSubMultiple(dataBuffer)
	local cmd_table = ExternalFun.read_netdata(cmd.CMD_S_Multiple, dataBuffer)
	local viewId = self:SwitchViewChairID(cmd_table.wChairID)
	if viewId == cmd.MY_VIEWID then
		self:KillGameClock()
	end
	 local currentScore = cmd_table.cbBankerScore
	self._gameView:onGetMultiple(viewId, cmd_table.bIsMultiple, currentScore)
--[[	-- 构造提示
	local handCards = self._gameView.m_tabNodeCards[bankerView]:getHandCards()
	if self.m_bIsMyBanker then
		self:updatePromptList({}, handCards, cmd.MY_VIEWID, cmd.MY_VIEWID)

		-- 不出按钮
		self._gameView:onChangePassBtnState(false)

		-- 开始出牌
		self._gameView:onGetOutCard(cmd.MY_VIEWID, cmd.MY_VIEWID, {})
	end
	-- 设置倒计时
	self:SetGameClock(self.m_cbBankerChair, cmd.TAG_COUNTDOWN_OUTCARD, cmd_table.cbTimeHeadOutCard)--]]
end

-- 用户放弃
function GameLayer:onSubPassCard(dataBuffer)
	self:KillGameClock()
    local cmd_table = ExternalFun.read_netdata(cmd.CMD_S_PassCard, dataBuffer)
    --dump(cmd_table, "onSubPassCard", 6)

    local curView = self:SwitchViewChairID(cmd_table.wCurrentUser)
    local passView = self:SwitchViewChairID(cmd_table.wPassCardUser)
    if self:IsValidViewID(curView) and self:IsValidViewID(passView) then
        print("&& pass " .. curView .. " ## " .. passView)
		-- 构造提示
		local handCards = self._gameView.m_tabNodeCards[cmd.MY_VIEWID]:getHandCards()
        if 1 == cmd_table.cbTurnOver then
            print("一轮结束")
            -- 不出按钮
            self._gameView:onChangePassBtnState(false)
			self:compareWithLastCards({}, curView)
			self:updatePromptList({}, handCards, curView, curView)
        end
		local promptList = self.m_tabPromptList
		local isAutoOutCard = false
		if curView == cmd.MY_VIEWID and #promptList > 0 and #handCards <= 20 then
            local cbCardData = GameLogic:SortCardList(handCards, #handCards, 0)
            local cbCardCount = #handCards
            local cbOutType = GameLogic:GetCardType(cbCardData, cbCardCount)
            if cbOutType == GameLogic.CT_SINGLE or cbOutType == GameLogic.CT_DOUBLE or cbOutType == GameLogic.CT_THREE or cbOutType == GameLogic.CT_SINGLE_LINE
             or cbOutType == GameLogic.CT_DOUBLE_LINE or cbOutType == GameLogic.CT_THREE_LINE or cbOutType == GameLogic.CT_THREE_TAKE_ONE or cbOutType == GameLogic.CT_THREE_TAKE_TWO 
             or cbOutType == GameLogic.CT_FOUR_TAKE_ONE or cbOutType == GameLogic.CT_FOUR_TAKE_TWO or cbOutType == GameLogic.CT_BOMB_CARD or cbOutType == GameLogic.CT_MISSILE_CARD then
                    -- 自动出牌
                isAutoOutCard = true
            end
        end
        -- 不出牌
        self._gameView:onGetPassCard(passView)

        self._gameView:onGetOutCard(curView, curView, {})
		if isAutoOutCard then
			-- 自动出牌
			self._gameView:onPromptOut(false)
			self._gameView:onOutCard()
		else
			local timeOutCard = cmd_table.cbTimeOutCard
			local timerId = cmd.TAG_COUNTDOWN_OUTCARD
			if curView == cmd.MY_VIEWID and 1 ~= cmd_table.cbTurnOver and #promptList == 0 then
				timeOutCard = 10
				timerId = cmd.TAG_COUNTDOWN_PASS
			end
			-- 设置倒计时
			self:SetGameClock(cmd_table.wCurrentUser, timerId, timeOutCard)
		end
    else
        print("viewid invalid" .. curView .. " ## " .. passView)
    end
end

--用户托管
function GameLayer:onSubTrustee(dataBuffer)
	print("用户托管")
	local cmd_table = ExternalFun.read_netdata(cmd.CMD_S_Trustee, dataBuffer)
	dump(cmd_table, "trustee")
    local wViewChairId = self:SwitchViewChairID(cmd_table.wChairID)
    local handCards = self._gameView.m_tabNodeCards[cmd.MY_VIEWID]:getHandCards()
	
    -- self._gameView:UserTrustee(wViewChairId,cmd_table.bTrustee)
	self._gameView:setUserTrustee(wViewChairId, cmd_table.bTrustee)


    -- if dataBuffer then
    --     if curView==cmd.MY_VIEWID and #handCards<21 then
    --     self._gameView:onPromptOut(false)
    --     self._gameView:onOutCard()
    -- end
    -- end

    local promptList = self.m_tabPromptList
    local isAutoOutCard = false
    if cmd_table.bTrustee and curView==cmd.MY_VIEWID and #promptList>0 and #handCards<21 then 
        local cbCardData =GameLogic.SortCardList(handCards,#handCards,0)
        local  cbCardCount=#handCards
        local cbOutType = GameLogic:GetCardType(cbCardData,cbCardCount)
        if cbOutType == GameLogic.CT_SINGLE or cbOutType == GameLogic.CT_DOUBLE or cbOutType == GameLogic.CT_THREE or cbOutType == GameLogic.CT_SINGLE_LINE
             or cbOutType == GameLogic.CT_DOUBLE_LINE or cbOutType == GameLogic.CT_THREE_LINE or cbOutType == GameLogic.CT_THREE_TAKE_ONE or cbOutType == GameLogic.CT_THREE_TAKE_TWO 
             or cbOutType == GameLogic.CT_FOUR_TAKE_ONE or cbOutType == GameLogic.CT_FOUR_TAKE_TWO or cbOutType == GameLogic.CT_BOMB_CARD or cbOutType == GameLogic.CT_MISSILE_CARD then
                    -- 自动出牌
            -- self._gameView:onGetOutCard(curView, curView, {})
            isAutoOutCard=true

        end
        if isAutoOutCard then
            self._gameView:onPromptOut(false)
            self._gameView:onOutCard()
        else
            local timeOutCard = cmd_table.cbTimeOutCard
            local timerId = cmd.TAG_COUNTDOWN_OUTCARD
            if curView == cmd.MY_VIEWID and 1 ~= cmd_table.cbTurnOver and #promptList == 0 then
                timeOutCard = 10
                timerId = cmd.TAG_COUNTDOWN_PASS
            end
            -- 设置倒计时
            self:SetGameClock(cmd_table.wCurrentUser, timerId, timeOutCard)
        end
    end
    

    
    -- if cmd_table.bTrustee then
    --     self:compareWithLastCards({}, curView)
    --     self:updatePromptList({}, handCards, curView, curView)
    --     local isAutoOutCard=false
    --     local promptList = self.m_tabPromptList
    --     if wViewChairId==cmd.MY_VIEWID 
    --         and #promptList > 0 
    --         and #handCards<=20 
    --         then
    --         local cbCardData = GameLogic:SortCardList(handCards,#handCards,0)
    --         local cbCardCount = #handCards
    --         local cbOutType = GameLogic:GetCardType(cbCardData,cbCardCount)
    --         if cbOutType == GameLogic.CT_SINGLE or cbOutType == GameLogic.CT_DOUBLE or cbOutType == GameLogic.CT_THREE or cbOutType == GameLogic.CT_SINGLE_LINE
    --          or cbOutType == GameLogic.CT_DOUBLE_LINE or cbOutType == GameLogic.CT_THREE_LINE or cbOutType == GameLogic.CT_THREE_TAKE_ONE or cbOutType == GameLogic.CT_THREE_TAKE_TWO 
    --          or cbOutType == GameLogic.CT_FOUR_TAKE_ONE or cbOutType == GameLogic.CT_FOUR_TAKE_TWO or cbOutType == GameLogic.CT_BOMB_CARD or cbOutType == GameLogic.CT_MISSILE_CARD then
    --                 -- 自动出牌
    --             isAutoOutCard = true
    --         else
    --             self._gameView:onGetPassCard(passView)
    --         end
    --     end
    --     self._gameView:onGetOutCard(curView, curView, {})
    --     if isAutoOutCard then
    --         -- 自动出牌
    --         self._gameView:onPromptOut(false)
    --         self._gameView:onOutCard()
    --     else
    --         local timeOutCard = cmd_table.cbTimeOutCard
    --         local timerId = cmd.TAG_COUNTDOWN_OUTCARD
    --         if curView == cmd.MY_VIEWID and 1 ~= cmd_table.cbTurnOver and #promptList == 0 then
    --             timeOutCard = 5 
    --             timerId = cmd.TAG_COUNTDOWN_PASS
    --         end
    --         -- 设置倒计时
    --         self:SetGameClock(cmd_table.wChairID, timerId, timeOutCard)
    --     end

    -- end

--[[	if cmd_table.bTrustee then
		self:PlaySound(cmd.RES_PATH.."sound/GAME_TRUSTEE.wav")
	else
		self:PlaySound(cmd.RES_PATH.."sound/UNTRUSTEE.wav")
	end--]]

	return true
end

-- 游戏结束
function GameLayer:onSubGameConclude(dataBuffer)
    --clear jipaiqi
    for i=1,15 do
        self.m_CardLeftCount[i] = 0
    end 
    self._gameView:updateCardLeftCount(self.m_CardLeftCount)

	-- 重置托管状态
	self:resetAllTrustee()
    local cmd_table = ExternalFun.read_netdata(cmd.CMD_S_GameConclude, dataBuffer)
    --dump(cmd_table, "onSubGameConclude", 6)
    -- 音效
    ExternalFun.playSoundEffect( "gameconclude.wav" )

    self.m_bRoundOver = true
    local str = ""
    local rs = GameResultLayer.getTagGameResult()
	rs.m_lCellScore = self.m_lCellScore
	rs.m_bankerscore = self.m_bankerscore
    local scorelist = cmd_table.lGameScore[1]
    local countlist = cmd_table.cbCardCount[1]
    local cardlist = cmd_table.cbHandCardData[1]
	local bSpecialTip = cmd_table.bSpecialTip
	local bMultiple = cmd_table.bMultiple[1]
    local haveCount = 0
	local bankerView = self._gameView.m_bankerViewId  -- 庄家视图
    for i = 1, 3 do
        local chair = i - 1
        local viewId = self:SwitchViewChairID(chair)

        -- 结算
        local score = scorelist[i]
		local isMultiple = bMultiple[i]
--[[        if score > 0 then
            str = "+" .. score
        else
            str = "" .. score
        end--]]
        local settle = GameResultLayer.getTagSettle()
        settle.m_userItem = self._gameView:getUserItem(viewId)
		settle.m_identity = "farmer"
		settle.isMultiple = isMultiple == 2 and true or false
		if  viewId == bankerView then
			settle.m_identity = "lord"
		end
        settle.m_settleCoin = score
        if cmd.MY_VIEWID == viewId then
            rs.enResult = self:getWinDir(score)
        end
        rs.settles[viewId] = settle

        -- 手牌
        local count = countlist[i]
        local cards = {}
        for j = 1, count do 
            table.insert(cards, cardlist[j + haveCount])
        end
        haveCount = haveCount + count
        if count > 0 then
			self._gameView:showLeftCards(viewId, cards)
        end
    end
  --[[  -- 标志
    for i = 1, 3 do
        local chair = i - 1
        -- 春天
        if 1 == cmd_table.bChunTian then
            if chair == self.m_cbBankerViewId then
                rs.settles[i].m_cbFlag = cmd.kFlagChunTian
            end
        end

        -- 反春天
        if 1 == cmd_table.bFanChunTian then
            if chair ~= self.m_cbBankerViewId then
                rs.settles[i].m_cbFlag = cmd.kFlagFanChunTian
            end
        end
    end--]]
	
	-- 倍数
	rs.m_all_multiple = cmd_table.lAllMultiple
	-- 叫分
	rs.m_bank_multiple = cmd_table.cbBankerScore
	-- 炸弹
	if cmd_table.lBombMultiple > 1 then
		rs.m_bomb_multiple = cmd_table.lBombMultiple
	end
	-- 火箭
	if cmd_table.lRocketMultiple > 0 then
		rs.m_rocket_multiple = cmd_table.lRocketMultiple
	end
	-- 春天
	if 1 == cmd_table.bChunTian then
		rs.m_chuntian_multiple = cmd_table.lChunTianMultiple
	end
	-- 反春天
	if 1 == cmd_table.bFanChunTian then
		rs.m_fanchuntian_multiple = cmd_table.lFanChunTianMultiple
	end
	rs.bSpecialTip = bSpecialTip
	self._gameView:onGetGameConclude( rs )
    self:KillGameClock()
	
	-- 设置倒计时
	-- 准备时间
    self:SetGameClock(self:GetMeChairID(), cmd.TAG_COUNTDOWN_READY, cmd_table.cbTimeStartGame)
	
--[[    -- 私人房无倒计时
    if not GlobalUserItem.bPrivateRoom then
        -- 设置倒计时
        self:SetGameClock(self:GetMeChairID(), cmd.TAG_COUNTDOWN_READY, cmd_table.cbTimeStartGame)
    end--]]

    self:reSetData()
end
------------------------------------------------------------------------------------------------------------
--网络处理
------------------------------------------------------------------------------------------------------------

function GameLayer:getWinDir( score )
    print("## is my Banker")
    print(self.m_bIsMyBanker)
    print("## is my Banker")
    if true == self.m_bIsMyBanker then
        if score > 0 then
            return cmd.kLanderWin
        elseif score < 0 then
            return cmd.kLanderLose
        end
    else
        if score > 0 then
            return cmd.kFarmerWin
        elseif score < 0 then
            return cmd.kFarmerLose
        end
    end
    return cmd.kDefault
end
return GameLayer