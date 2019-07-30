local GameModel = appdf.req(appdf.CLIENT_SRC.."gamemodel.GameModel")

local GameLayer = class("GameLayer", GameModel)

local cmd = appdf.req(appdf.GAME_SRC.."yule.oxsixx.src.models.CMD_Game")
local GameLogic = appdf.req(appdf.GAME_SRC.."yule.oxsixx.src.models.GameLogic")
local GameViewLayer = appdf.req(appdf.GAME_SRC.."yule.oxsixx.src.views.layer.GameViewLayer")
local QueryDialog = appdf.req("app.views.layer.other.QueryDialog")
local ExternalFun =  appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local ShowTip = appdf.req(appdf.GAME_SRC.."yule.oxsixx.src.views.layer.ShowTip")
local RoomListLayer = appdf.req(appdf.CLIENT_SRC .. "plaza.views.layer.plaza.RoomListLayer")

-- 初始化界面
function GameLayer:ctor(frameEngine,scene)
    GameLayer.super.ctor(self, frameEngine, scene)

end

function GameLayer:getParentNode()
    return self._scene
end
--创建场景
function GameLayer:CreateView()
    return GameViewLayer:create(self):addTo(self)
end

-- 初始化游戏数据
function GameLayer:OnInitGameEngine()
    self.cbPlayStatus = {0, 0, 0, 0,0,0} --游戏状态
    self.lGameEndScore = {0,0,0,0} --游戏结束分数
    self.lFreeConif = {0, 0, 0, 0} --积分
    self.lPercentConfig = {0, 0, 0, 0} --百分比
    self.lCardType = {}         --牌型
    self.cbCardData = {}
    self.wBankerUser = yl.INVALID_CHAIR
    self.cbDynamicJoin = 0
    self.m_tabPrivateRoomConfig = {}
    self.m_bStartGame = false
    self.isPriOver = false
    self.bAddScore = false
    self.m_lMaxTurnScore = 0

    self.m_tabUserItem = {}

    --约战
    self.m_userRecord = {}   --用户记录

    self._MyChairID = self:GetMeChairID()   


--    self.m_tabRoomListInfo = {}
--	for k,v in pairs(GlobalUserItem.roomlist) do
--		if tonumber(v[1]) == GlobalUserItem.nCurGameKind then
--			local listinfo = v[2]
--			if type(listinfo) ~= "table" then
--				break
--			end
--			local normalList = {}
--			for k,v in pairs(listinfo) do
--				if v.wServerType ~= yl.GAME_GENRE_PERSONAL then
--					table.insert( normalList, v)
--				end
--			end
--			self.m_tabRoomListInfo = normalList
--			break
--		end
--	end	

--    print("----------------cccccccccccccc-------------"..self.m_tabRoomListInfo[2].lCellScore)

    GameLayer.super.OnInitGameEngine(self)
end

-- 重置游戏数据
function GameLayer:OnResetGameEngine()

    GameLayer.super.OnResetGameEngine(self)
    self._gameView:onResetView()

    self.m_lMaxTurnScore = 0

    --print("重置游戏数据")
    self.cbPlayStatus = {0, 0, 0, 0 ,0 ,0} --游戏状态
    self.lFreeConif = {0, 0, 0, 0} --积分
    self.lPercentConfig = {0, 0, 0, 0} --百分比
    self.lCardType = {}

    --self.cbCardData = {}
    self.wBankerUser = yl.INVALID_CHAIR
    self.cbDynamicJoin = 0
    self.m_tabPrivateRoomConfig = {}
    self.m_bStartGame = false
    self.isPriOver = false
    self.bAddScore = false

end

-- 椅子号转视图位置,注意椅子号从0~nChairCount-1,返回的视图位置从1~nChairCount
function GameLayer:SwitchViewChairID(chair)
    local viewid = yl.INVALID_CHAIR
    local nChairCount = 6
    local meChairID = self:GetMeChairID()
    if meChairID>6 then
        meChairID = self._MyChairID
    end
    if chair ~= yl.INVALID_CHAIR and chair < nChairCount then
        viewid = math.mod(chair + math.floor(nChairCount * 4/3) - meChairID, nChairCount) + 1                            
    end
    return viewid
end

--将视图id转换为普通id
function GameLayer:SwitchChairID( viewid )
    if viewid < 1 or viewid >6 then
        error("this is error viewid")
    end
    for i=1,cmd.GAME_PLAYER do
        if self:SwitchViewChairID(i-1) == viewid then
            return i
        end
    end
end

--是否正在玩
function GameLayer:isPlayerPlaying(viewId)
    if viewId < 1 or viewId > 6 then
        --print("view chair id error!")
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

--获取gamekind
function GameLayer:getGameKind()
    return cmd.KIND_ID
end

-- 时钟处理
function GameLayer:OnEventGameClockInfo(chair,time,clockId)

    self._gameView:logicClockInfo(chair,time,clockId)
   
end

--用户分数
function GameLayer:onEventUserScore( item )
    if item.wTableID ~= self:GetMeUserItem().wTableID then
       return
    end

    self._gameView:updateScore(self:SwitchViewChairID(item.wChairID))
end

--用户聊天
function GameLayer:onUserChat(chat, wChairId)
    --print("玩家聊天", chat.szChatString)
    self._gameView:onUserChat(chat, self:SwitchViewChairID(wChairId))
end

--用户表情
function GameLayer:onUserExpression(expression, wChairId)
    self._gameView:onUserExpression(expression, self:SwitchViewChairID(wChairId))
end

-- 语音播放开始
function GameLayer:onUserVoiceStart( useritem, filepath )
    local viewid = self:SwitchViewChairID(useritem.wChairID)
    if viewid and viewid ~= yl.INVALID_CHAIR then
        --print("语音播放开始 viewid",viewid)
        self._gameView:ShowUserVoice(viewid, true)
    end
end



-- 语音播放结束
function GameLayer:onUserVoiceEnded( useritem, filepath )
    local viewid = self:SwitchViewChairID(useritem.wChairID)
    if viewid and viewid ~= yl.INVALID_CHAIR then
        --print("语音播放结束,viewid",viewid)
        self._gameView:ShowUserVoice(viewid, false)
    end
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
                    --print("delay leave")
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
    self._scene:onKeyBack()
end

--退出
function GameLayer:onExit()
    self:KillGameClock()
    self:dismissPopWait()
    GameLayer.super.onExit(self)
end

--坐下人数
function GameLayer:onGetSitUserNum()
    local num = 0
    for i = 1, cmd.GAME_PLAYER do
        if nil ~= self.m_tabUserItem[i] then
            num = num + 1
        end
    end
    return num
end

function GameLayer:getUserInfoByChairID(chairId)
    local viewId = self:SwitchViewChairID(chairId)
    return self.m_tabUserItem[viewId]
end

function GameLayer:onGetNoticeReady()
    --print("牛牛 系统通知准备")
    if nil ~= self._gameView and nil ~= self._gameView.btStart then
        self._gameView.btStart:setVisible(true)
    end
end

--系统消息
function GameLayer:onSystemMessage( wType,szString )
    if wType == 515 then  --515 当玩家没钱时候
       self.m_querydialog = ShowTip:create(szString,function()
        
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

        end,nil,1)
        self.m_querydialog:setCanTouchOutside(false)
        self.m_querydialog:addTo(self)
    end

    --print("处理游戏币不足")
    --if self.m_bStartGame then
    --    local msg = szString or ""
    --    self.m_querydialog = QueryDialog:create(msg,function()
    --        self:onExitTable()
    --    end,nil,1)
    --    self.m_querydialog:setCanTouchOutside(false)
    --    self.m_querydialog:addTo(self)
    --else
    --    self.m_bPriScoreLow = true
    --    self.m_szScoreMsg = szString
    --end
end

function GameLayer:addPrivateGameLayer( layer )
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
            --print("初始化已有玩家 i,wViewChairId",i,wViewChairId)
            self._gameView:OnUpdateUser(wViewChairId, userItem)
            self.m_tabUserItem[userItem.wChairID+1] = clone(userItem)
        end
    end
    --self._gameView:onResetView()
    self.m_cbGameStatus = cbGameStatus
    self._gameView:setClockBgVisible(false)
	if cbGameStatus == cmd.GS_TK_FREE	then				--空闲状态
        self:onSceneFree(dataBuffer)
	elseif cbGameStatus == cmd.GS_TK_CALL	then			--叫分状态
        self:onSceneCall(dataBuffer)
	elseif cbGameStatus == cmd.GS_TK_SCORE	then			--下注状态
        self:onSceneScore(dataBuffer)
    elseif cbGameStatus == cmd.GS_TK_PLAYING  then           --游戏状态
        self:onScenePlaying(dataBuffer)
	end
    self:dismissPopWait()

    -- 刷新房卡
    if PriRoom and GlobalUserItem.bPrivateRoom then
        if nil ~= self._gameView._priView and nil ~= self._gameView._priView.onRefreshInfo then
            self._gameView._priView:onRefreshInfo()
        end
    end
end

--空闲场景
function GameLayer:onSceneFree(dataBuffer)
    --print("onSceneFree")
    local cmd_table = ExternalFun.read_netdata(cmd.CMD_S_StatusFree, dataBuffer);
    --dump(cmd_table)

    --self.lCellScore = cmd_table.lCellScore
    self.lCellScore = RoomListLayer.lCellScore
    print("----------------------eeeeeeeeeeeeeeeeeeeeeeeeeeeeeee-----------------"..self.lCellScore)

    local lRoomStorageStart = cmd_table.lRoomStorageStart
    local lRoomStorageCurrent = cmd_table.lRoomStorageCurrent

    local lTurnScore = {}
    for i = 1, cmd.GAME_PLAYER do
        lTurnScore[i] = cmd_table.lTurnScore[1][i]
    end

    local lCollectScore = {}
    for i = 1, cmd.GAME_PLAYER do
        lCollectScore[i] = cmd_table.lCollectScore[1][i]
    end

    -- 反作弊标识
    local bIsAllowAvertCheat = cmd_table.bIsAllowAvertCheat
    --游戏牌型
    self.m_tabPrivateRoomConfig.cardType = cmd_table.ctConfig
    --发牌模式
    self.m_tabPrivateRoomConfig.sendCardType = cmd_table.stConfig
    -- 坐庄模式
    self.m_tabPrivateRoomConfig.bankGameType = cmd_table.bgtConfig
    print("bankGameType is ================"..self.m_tabPrivateRoomConfig.bankGameType)
    -- 下注模式
    self.m_tabPrivateRoomConfig.betType = cmd_table.btConfig
    -- 房卡积分模式


    self._gameView:showRoomRule(self.m_tabPrivateRoomConfig)
    

    if not GlobalUserItem.isAntiCheat() then
        local useritem = self:GetMeUserItem()

        if useritem.cbUserStatus == yl.US_SIT then
            self._gameView.btStart:setVisible(true)
        end

        if useritem.cbUserStatus > yl.US_SIT then
            return
        end
        
        -- 私人房无倒计时
        if not GlobalUserItem.bPrivateRoom then
            -- 设置倒计时
            self:KillGameClock()
            self:SetGameClock(self:GetMeChairID(), cmd.IDI_START_GAME, cmd.TIME_USER_START_GAME)
            self._gameView:setClockBgVisible(true)
        else
            self._gameView:setClockVisible(false)
        end
    end
end
--叫庄场景
function GameLayer:onSceneCall(dataBuffer)

    --移除所有子类
    self._gameView.nodeCallMul:removeAllChildren()

    local cmd_table = ExternalFun.read_netdata(cmd.CMD_S_StatusCall, dataBuffer);
    dump(cmd_table)

    local wCallBanker = cmd_table.wCallBanker
    self.cbDynamicJoin = cmd_table.cbDynamicJoin
    --print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~动态加入：", self.cbDynamicJoin)
    for i = 1, cmd.GAME_PLAYER do
        --游戏状态
        self.cbPlayStatus[i] = cmd_table.cbPlayStatus[1][i]
    end
    local lRoomStorageStart = cmd_table.lRoomStorageStart
    local lRoomStorageCurrent = cmd_table.lRoomStorageCurrent

    local lTurnScore = {}
    for i = 1, cmd.GAME_PLAYER do
        lTurnScore[i] = cmd_table.lTurnScore[1][i]
    end
    local lCollectScore = {}
    for i = 1, cmd.GAME_PLAYER do
        lCollectScore[i] = cmd_table.lCollectScore[1][i]
    end

    -- 反作弊标识
    local bIsAllowAvertCheat = cmd_table.bIsAllowAvertCheat
    --叫庄状态
    local cbCallBankerStatus = {}
    for i = 1, cmd.GAME_PLAYER do
        cbCallBankerStatus[i] = cmd_table.cbCallBankerStatus[1][i]
    end
    --叫庄倍数
    local cbCallBankerTimes = {}
    for i = 1, cmd.GAME_PLAYER do
        cbCallBankerTimes[i] = cmd_table.cbCallBankerTimes[1][i]
    end

    --游戏牌型
    self.m_tabPrivateRoomConfig.cardType = cmd_table.ctConfig
    --发牌模式
    self.m_tabPrivateRoomConfig.sendCardType = cmd_table.stConfig
    -- 坐庄模式
    self.m_tabPrivateRoomConfig.bankGameType = cmd_table.bgtConfig
    -- 下注模式
    self.m_tabPrivateRoomConfig.betType = cmd_table.btConfig


    --dump(cmd_table, "the call banker=====", 6)
    for i = 1, cmd.GAME_PLAYER do
        if self.cbPlayStatus[i] == 1 then --当前玩家没有叫庄
            local wViewChairId = self:SwitchViewChairID(i - 1)
            if cbCallBankerStatus[i] == 0 then
                if wViewChairId == cmd.MY_VIEWID then 
                    self.cbCardData  = {} 
                    self._gameView:gameCallBanker(cmd.MY_VIEWID, bFirstTimes)
                    if self.cbDynamicJoin == 0 then 
                        self._gameView:setClockBgVisible(true)
                        self:KillGameClock()
                        self:SetGameClock(cmd.MY_VIEWID, cmd.IDI_CALL_BANKER, 10) 
                    end
                     
                end
            else
                 self._gameView:setCallMultiple(wViewChairId,cbCallBankerTimes[i])   
            end
            
        end
    end      

    -- 刷新局数
    if PriRoom and GlobalUserItem.bPrivateRoom then
        local curcount = PriRoom:getInstance().m_tabPriData.dwPlayCount
        PriRoom:getInstance().m_tabPriData.dwPlayCount = curcount - 1
        if nil ~= self._gameView._priView and nil ~= self._gameView._priView.onRefreshInfo then
            self._gameView._priView:onRefreshInfo()
        end
    end
end
--叫分场景 
function GameLayer:onSceneScore(dataBuffer)

    --print("onSceneScore")
    local cmd_table = ExternalFun.read_netdata(cmd.CMD_S_StatusScore, dataBuffer);
    dump(cmd_table)
    for i = 1, cmd.GAME_PLAYER do
        --游戏状态
        self.cbPlayStatus[i] = cmd_table.cbPlayStatus[1][i]
        --积分配置
        self.lFreeConif[i] = cmd_table.lFreeConfig[1][i]
        --百分比配置
        self.lPercentConfig[i] = cmd_table.lPercentConfig[1][i]
    end
    self.cbDynamicJoin = cmd_table.cbDynamicJoin
    --print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~动态加入：", self.cbDynamicJoin)
    self.m_lMaxTurnScore = cmd_table.lTurnMaxScore

    --已下注分数
    local lTableScore = {}
    for i = 1, cmd.GAME_PLAYER do
        lTableScore[i] = cmd_table.lTableScore[1][i]
        if self.cbPlayStatus[i] == 1 then
            local wViewChairId = self:SwitchViewChairID(i - 1)
            self._gameView:setUserTableScore(wViewChairId, lTableScore[i])
        end
    end

    --庄家
    self.wBankerUser = cmd_table.wBankerUser
    local lRoomStorageStart = cmd_table.lRoomStorageStart
    local lRoomStorageCurrent = cmd_table.lRoomStorageCurrent
    local lTurnScore = {}
    for i = 1, cmd.GAME_PLAYER do
        lTurnScore[i] = cmd_table.lTurnScore[1][i]
    end
    local lCollectScore = {}
    for i = 1, cmd.GAME_PLAYER do
        lCollectScore[i] = cmd_table.lCollectScore[1][i]
    end

    -- 反作弊标识
    local bIsAllowAvertCheat = cmd_table.bIsAllowAvertCheat

    --游戏牌型
    self.m_tabPrivateRoomConfig.cardType = cmd_table.ctConfig
    --发牌模式
    self.m_tabPrivateRoomConfig.sendCardType = cmd_table.stConfig
    -- 坐庄模式
    self.m_tabPrivateRoomConfig.bankGameType = cmd_table.bgtConfig
    -- 下注模式
    self.m_tabPrivateRoomConfig.betType = cmd_table.btConfig

    --庄家信息
    self._gameView:setBankerUser(self:SwitchViewChairID(self.wBankerUser))
    self._gameView:setBankerMultiple(self:SwitchViewChairID(self.wBankerUser))

    -- 积分房卡配置的下注
    -- 下注类型
    if self:SwitchViewChairID(self.wBankerUser) ~= cmd.MY_VIEWID and lTableScore[self._MyChairID+1] == 0 then 
        print("my score is ===",lTableScore[self._MyChairID])
        if self.m_tabPrivateRoomConfig.betType == cmd.BETTYPE_CONFIG.BT_FREE_ then --自由配置额度
        --print("自由配置额度")
            self._gameView:setScoreJetton(self.lFreeConif)
        elseif self.m_tabPrivateRoomConfig.betType == cmd.BETTYPE_CONFIG.BT_PENCENT_ then --百分比配置额度
            --print("百分比配置额度")
            local Jettons = {}
            for i=1,#self.lPercentConfig do
                local percent = self.lPercentConfig[i]/100
                local jetton = math.floor(self.m_lMaxTurnScore * percent)
                table.insert(Jettons, jetton)
                self._gameView:setScoreJetton(Jettons)
            end
            dump(Jettons,"Jettons")
        else
            error("self.m_tabPrivateRoomConfig.betType error")
        end
        self._gameView:showChipBtn(self:SwitchViewChairID(self.wBankerUser))

    end

    self._gameView:resetEffect()
    
    --牌值
    for i = 1, cmd.GAME_PLAYER do
        self.cbCardData[i] = {}
        for j = 1, cmd.MAX_CARDCOUNT do
            self.cbCardData[i][j] = cmd_table.cbCardData[i][j]
        end
    end
    --dump(self.cbCardData)
    --显示牌并开自己的牌
    for i = 1, cmd.GAME_PLAYER do
        if self.cbPlayStatus[i] == 1 then
            local wViewChairId = self:SwitchViewChairID(i - 1)
            for j = 1, cmd.MAX_CARDCOUNT do

                if self.cbCardData[i][j] ~= 0 then
                    --print("wViewChairId",wViewChairId)
                    local card
                    if wViewChairId == 4 then --右手边
                        card = self._gameView.nodeCard[wViewChairId][j+1]
                    else
                        card = self._gameView.nodeCard[wViewChairId][j]
                    end
                    card:setVisible(true)
                    if wViewChairId == cmd.MY_VIEWID then          --是自己则打开牌
                        local value = GameLogic:getCardValue(self.cbCardData[i][j])
                        local color = GameLogic:getCardColor(self.cbCardData[i][j])
                        self._gameView:setCardTextureRect(wViewChairId, j, value, color)
                    end
                end

            end
        end
    end

    if self.cbDynamicJoin == 0 then 
        self:KillGameClock()
        self:SetGameClock(self.wBankerUser, cmd.IDI_TIME_USER_ADD_SCORE, 10)
        self._gameView:setClockBgVisible(true)
    end
    
end
--游戏场景
function GameLayer:onScenePlaying(dataBuffer)
    --print("onScenePlaying")
    local cmd_table = ExternalFun.read_netdata(cmd.CMD_S_StatusPlay, dataBuffer);
    dump(cmd_table)
    for i = 1, cmd.GAME_PLAYER do
        --游戏状态
        self.cbPlayStatus[i] = cmd_table.cbPlayStatus[1][i]
        --积分配置
        self.lFreeConif[i] = cmd_table.lFreeConfig[1][i]
        --百分比配置
        self.lPercentConfig[i] = cmd_table.lPercentConfig[1][i]
    end
    self.cbDynamicJoin = cmd_table.cbDynamicJoin
    --print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~动态加入：", self.cbDynamicJoin)
    self.m_lMaxTurnScore = cmd_table.lTurnMaxScore
    local lTableScore = {}
    for i = 1, cmd.GAME_PLAYER do
        lTableScore[i] = cmd_table.lTableScore[1][i]
        if self.cbPlayStatus[i] == 1 and lTableScore[i] ~= 0 then
            local wViewChairId = self:SwitchViewChairID(i - 1)
            self._gameView:gameAddScore(wViewChairId, lTableScore[i])
        end
    end
    self.wBankerUser = cmd_table.wBankerUser
    local lRoomStorageStart = cmd_table.lRoomStorageStart
    local lRoomStorageCurrent = cmd_table.lRoomStorageCurrent

    for i = 1, cmd.GAME_PLAYER do
        self.cbCardData[i] = {}
        for j = 1, #cmd_table.cbHandCardData[1] do
            self.cbCardData[i][j] = cmd_table.cbHandCardData[i][j]
        end
    end
   
    local bOxCard = {}
    for i = 1, cmd.GAME_PLAYER do
        bOxCard[i] = cmd_table.bOpenCard[1][i]
        local wViewChairId = self:SwitchViewChairID(i - 1)
        if self.cbPlayStatus[i] == 1 then
            if true == bOxCard[i]  then
                self._gameView:onButtonConfirm(wViewChairId)
            end

            if  cmd.MY_VIEWID == wViewChairId then 
                print("i-------------",i)
                dump(bOxCard, "666666", 6)
               
                if not bOxCard[i] then
                    self._gameView:setCombineCard(self.cbCardData[i])
                    self._gameView:setSpecialInfo(cmd_table.bSpecialCard[1][i],cmd_table.cbOriginalCardType[1][i])
                    self._gameView:gameScenePlaying()
                end
                
            end
            self._gameView:setOpenCardVisible(wViewChairId, true, bOxCard[i])
        end
    end

    local lTurnScore = {}
    for i = 1, cmd.GAME_PLAYER do
        lTurnScore[i] = cmd_table.lTurnScore[i]
    end
    local lCollectScore = {}
    for i = 1, cmd.GAME_PLAYER do
        lCollectScore[i] =  cmd_table.lCollectScore[i]
    end

    -- 反作弊标识
    local bIsAllowAvertCheat = cmd_table.bIsAllowAvertCheat

    --游戏牌型
    self.m_tabPrivateRoomConfig.cardType = cmd_table.ctConfig
    --发牌模式
    self.m_tabPrivateRoomConfig.sendCardType = cmd_table.stConfig
    -- 坐庄模式
    self.m_tabPrivateRoomConfig.bankGameType = cmd_table.bgtConfig
    -- 下注模式
    self.m_tabPrivateRoomConfig.betType = cmd_table.btConfig


    --显示牌并开自己的牌
    for i = 1, cmd.GAME_PLAYER do
        if self.cbPlayStatus[i] == 1 then
            local wViewChairId = self:SwitchViewChairID(i - 1)
            for j = 1, 5 do
                local card = self._gameView.nodeCard[wViewChairId][j]
                card:setVisible(true)
                if wViewChairId == cmd.MY_VIEWID then          --是自己则打开牌
                    local value = GameLogic:getCardValue(self.cbCardData[i][j])
                    local color = GameLogic:getCardColor(self.cbCardData[i][j])
                    self._gameView:setCardTextureRect(wViewChairId, j, value, color)
                end
            end
        end
    end
    self._gameView:setBankerUser(self:SwitchViewChairID(self.wBankerUser))
    
    if self.cbDynamicJoin == 0 then 
        self._gameView:setClockBgVisible(true)
        self:KillGameClock()
        self:SetGameClock(self.wBankerUser, cmd.IDI_TIME_OPEN_CARD, 10)
    end
end

-- 游戏消息
function GameLayer:onEventGameMessage(sub,dataBuffer)
	if sub == cmd.SUB_S_CALL_BANKER then           --叫庄
        self.m_cbGameStatus = cmd.GS_TK_CALL
		self:onSubCallBanker(dataBuffer)  
    elseif sub == cmd.SUB_S_CALL_BANKERINFO then
        self:onSubCallBankerInfo(dataBuffer)              --
	elseif sub == cmd.SUB_S_GAME_START then        --游戏开始
        self.m_cbGameStatus = cmd.GS_TK_CALL 
		self:onSubGameStart(dataBuffer)
	elseif sub == cmd.SUB_S_ADD_SCORE then         --加注结果
        self.m_cbGameStatus = cmd.GS_TK_SCORE
		self:onSubAddScore(dataBuffer)
	elseif sub == cmd.SUB_S_SEND_CARD then         --发牌消息
        self.m_cbGameStatus = cmd.GS_TK_PLAYING
		self:onSubSendCard(dataBuffer)
	elseif sub == cmd.SUB_S_OPEN_CARD then         --用户摊牌
        self.m_cbGameStatus = cmd.GS_TK_PLAYING
		self:onSubOpenCard(dataBuffer)
	elseif sub == cmd.SUB_S_PLAYER_EXIT then       --用户强退
        self.m_cbGameStatus = cmd.GS_TK_PLAYING
		self:onSubPlayerExit(dataBuffer)
	elseif sub == cmd.SUB_S_GAME_END then          --游戏结束
        self.m_cbGameStatus = cmd.GS_TK_PLAYING
		self:onSubGameEnd(dataBuffer)
    elseif sub == cmd.SUB_S_RECORD then            --游戏记录
        self:onSubGameRecord(dataBuffer)
	else
        --print("unknow gamemessage sub is"..sub)
        --error("unknow gamemessage sub")
	end
end

--用户叫庄
function GameLayer:onSubCallBanker(dataBuffer)
    --print("dataBuffer len",dataBuffer:getlen())
    self.cbCardData  = {} 
    self._gameView:gameCallBanker(cmd.MY_VIEWID, bFirstTimes)

    if self.cbDynamicJoin == 0 then 
        self:KillGameClock()
        self._gameView:setClockBgVisible(true)
        self:SetGameClock(cmd.MY_VIEWID, cmd.IDI_CALL_BANKER, cmd.TIME_USER_CALL_BANKER)
    end
    

    -- 刷新房卡
    if PriRoom and GlobalUserItem.bPrivateRoom then
        if nil ~= self._gameView._priView and nil ~= self._gameView._priView.onRefreshInfo then
            self._gameView._priView:onRefreshInfo()
        end
    end
end

function GameLayer:onSubCallBankerInfo(dataBuffer)
    print("叫庄倍数")
    local cmd_table = ExternalFun.read_netdata(cmd.CMD_S_CallBankerInfo, dataBuffer)
    self.cbCardData  = {} 
    dump(cmd_table, "call banker info")

     --叫庄状态
    local cbCallBankerStatus = {}
    for i = 1, cmd.GAME_PLAYER do
        cbCallBankerStatus[i] = cmd_table.cbCallBankerStatus[1][i]
    end

    --叫庄倍数
    local cbCallBankerTimes = {}
    for i = 1, cmd.GAME_PLAYER do
        cbCallBankerTimes[i] = cmd_table.cbCallBankerTimes[1][i]
    end

    for i=1,cmd.GAME_PLAYER do 
        if 1 == cbCallBankerStatus[i] then
           local wViewChairId = self:SwitchViewChairID(i - 1)
           if wViewChairId == cmd.MY_VIEWID then 
               self._gameView:setClockBgVisible(false)
               self._gameView:showCallBankerMul(0)
           end
           --显示倍数
           self._gameView:setCallMultiple(wViewChairId,cbCallBankerTimes[i])
        end
    end

end
--游戏开始
function GameLayer:onSubGameStart(dataBuffer)
    local cmd_table = ExternalFun.read_netdata(cmd.CMD_S_GameStart, dataBuffer);
    --dump(cmd_table)

    self._gameView:playEffect("gameStart.mp3")
    self.m_lMaxTurnScore = cmd_table.lTurnMaxScore
    self.wBankerUser = cmd_table.wBankerUser

    dump(cmd_table, "the game start info")
    print("m_lMaxTurnScore is ",self.m_lMaxTurnScore)

    -- 玩家状态
    for i = 1, cmd.GAME_PLAYER do
        --游戏状态
        self.cbPlayStatus[i] = cmd_table.cbPlayerStatus[1][i]
        --积分配置
        self.lFreeConif[i] = cmd_table.lFreeConfig[1][i]
        --百分比配置
        self.lPercentConfig[i] = cmd_table.lPercentConfig[1][i]
    end

    --显示庄家标识
    self._gameView:setBankerUser(self:SwitchViewChairID(self.wBankerUser))
    --只显示庄家倍数
    self._gameView:setBankerMultiple(self:SwitchViewChairID(self.wBankerUser))

    --庄家等待下注Tips
    for i=1,cmd.GAME_PLAYER do
       if 1 == self.cbPlayStatus[i]  then
           local viewId = self:SwitchViewChairID(i-1)
           if (viewId ~= cmd.MY_VIEWID) then 
                if i-1 ~= self.wBankerUser  then
                    local bNormal 
                    if self.m_tabPrivateRoomConfig.sendCardType == cmd.SENDCARDTYPE_CONFIG.ST_BETFIRST then
                        bNormal = true
                    elseif self.m_tabPrivateRoomConfig.sendCardType == cmd.SENDCARDTYPE_CONFIG.ST_SENDFOUR then
                        bNormal = false  
                    end
                    

                    self._gameView:setBankerWaitIcon(viewId,true,bNormal)
                end
           end
       end
    end

    --发牌模式
    self.m_tabPrivateRoomConfig.sendCardType = cmd_table.stConfig
    -- 坐庄模式
    self.m_tabPrivateRoomConfig.bankGameType = cmd_table.bgtConfig
    -- 下注模式
    self.m_tabPrivateRoomConfig.betType = cmd_table.btConfig

    if self:SwitchViewChairID(self.wBankerUser) ~=  cmd.MY_VIEWID then
           -- 下注类型
        if self.m_tabPrivateRoomConfig.betType == cmd.BETTYPE_CONFIG.BT_FREE_ then --自由配置额度
            --print("自由配置额度")
            self._gameView:setScoreJetton(self.lFreeConif)
        elseif self.m_tabPrivateRoomConfig.betType == cmd.BETTYPE_CONFIG.BT_PENCENT_ then --百分比配置额度
            --print("百分比配置额度")
            local Jettons = {}
            for i=1,#self.lPercentConfig do
                local percent = self.lPercentConfig[i]/100
                local jetton = math.floor(self.m_lMaxTurnScore * percent)
                table.insert(Jettons, jetton)
                self._gameView:setScoreJetton(Jettons)
            end
        else
            error("self.m_tabPrivateRoomConfig.betType error")
        end
        self._gameView:showChipBtn(self:SwitchViewChairID(self.wBankerUser))
    end
    
    self._gameView:resetEffect()
    --
    self._gameView:setClockBgVisible(false)
    if self.m_tabPrivateRoomConfig.sendCardType == cmd.SENDCARDTYPE_CONFIG.ST_BETFIRST then
        if self.cbDynamicJoin == 0 then 
            self:SetGameClock(self.wBankerUser, cmd.IDI_TIME_USER_ADD_SCORE, cmd.TIME_USER_ADD_SCORE)
            self._gameView:setClockBgVisible(true)
        end

        
    end
    

    --发牌
    for i = 1, cmd.GAME_PLAYER do
        self.cbCardData[i] = {}
        for j = 1, 5 do
            self.cbCardData[i][j] = cmd_table.cbCardData[i][j]
        end
    end
    --打开自己的牌
    --dump(self._gameView.nodeCard[cmd.MY_VIEWID])
    for i = 1, cmd.MAX_CARDCOUNT do
        local index = self:GetMeChairID() + 1
        local data = self.cbCardData[index][i]
        local value = GameLogic:getCardValue(data)
        local color = GameLogic:getCardColor(data)
        local card = self._gameView.nodeCard[cmd.MY_VIEWID][i]
        --self._gameView:setCardTextureRect(cmd.MY_VIEWID, i, value, color)
    end

    local sendCount = 0
    if self.m_tabPrivateRoomConfig.sendCardType == cmd.SENDCARDTYPE_CONFIG.ST_SENDFOUR then
        sendCount = 4
    end
    self._gameView:gameSendCard(self:SwitchViewChairID(self.wBankerUser),sendCount)

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
    print("用户下注")

    self.bAddScore = true
    local cmd_table = ExternalFun.read_netdata(cmd.CMD_S_AddScore, dataBuffer);
    --dump(cmd_table)
    local wAddScoreUser = cmd_table.wAddScoreUser
    local lAddScoreCount = cmd_table.lAddScoreCount

    local userViewId = self:SwitchViewChairID(wAddScoreUser)
    self._gameView:gameAddScore(userViewId, lAddScoreCount)
    self._gameView:setBankerWaitIcon(userViewId,false)
    self._gameView:playEffect("ADD_SCORE.WAV")
end

--发牌消息
function GameLayer:onSubSendCard(dataBuffer)

    print("用户发牌")
    local cmd_table = ExternalFun.read_netdata(cmd.CMD_S_SendCard, dataBuffer);
    dump(cmd_table)
    for i = 1, cmd.GAME_PLAYER do
        self.cbCardData[i] = {}
        for j = 1, 5 do
            self.cbCardData[i][j] = cmd_table.cbCardData[i][j]
        end

        if self:SwitchViewChairID(i-1) == cmd.MY_VIEWID then  --原始数据
            self._gameView:setCombineCard(self.cbCardData[i])
            self._gameView:setSpecialInfo(cmd_table.bSpecialCard[1][i],cmd_table.cbOriginalCardType[1][i])
        end
    end

    
    --打开自己的牌
    --dump(self._gameView.nodeCard[cmd.MY_VIEWID])
    for i = 1, cmd.MAX_CARDCOUNT do
        local index = self:GetMeChairID() + 1
        local data = self.cbCardData[index][i]
        local value = GameLogic:getCardValue(data)
        local color = GameLogic:getCardColor(data)
        local card = self._gameView.nodeCard[cmd.MY_VIEWID][i]
        self._gameView:setCardTextureRect(cmd.MY_VIEWID, i, value, color)
    end
    local sendCount = 5
    if self.m_tabPrivateRoomConfig.sendCardType == cmd.SENDCARDTYPE_CONFIG.ST_SENDFOUR then
        sendCount = 1
    end
    self._gameView:gameSendCard(self:SwitchViewChairID(self.wBankerUser),sendCount)

    if self.cbDynamicJoin == 0 then 
        self:KillGameClock()
        self:SetGameClock(self:GetMeChairID(), cmd.IDI_TIME_OPEN_CARD, cmd.TIME_USER_OPEN_CARD)
    end

    if self:isPlayerPlaying(cmd.MY_VIEWID) then
        --出现计分器
        self._gameView:showCalculate(true,true)
    end

     --庄家等待下注Tips
    for i=1,cmd.GAME_PLAYER do 
        self._gameView:setBankerWaitIcon(i,false)
    end
end

--用户摊牌
function GameLayer:onSubOpenCard(dataBuffer)
    local cmd_table = ExternalFun.read_netdata(cmd.CMD_S_Open_Card, dataBuffer);
    --dump(cmd_table)
    --print("用户摊牌 wPlayerID",wPlayerID)
    local wPlayerID = cmd_table.wOpenChairID
    local bOpen = cmd_table.bOpenCard
    local wViewChairId = self:SwitchViewChairID(wPlayerID)
    if wViewChairId == cmd.MY_VIEWID then
        self._gameView:onButtonConfirm(wViewChairId)
        self._gameView:setClockBgVisible(false)
    end
    self._gameView:stopCardAni(wViewChairId)
    self._gameView:setOpenCardVisible(wViewChairId,true,bOpen)

    self._gameView:playEffect("SEND_CARD.wav")
end

--用户强退
function GameLayer:onSubPlayerExit(dataBuffer)
    local cmd_table = ExternalFun.read_netdata(cmd.CMD_S_PlayerExit, dataBuffer);
    --dump(cmd_table)
    local wPlayerID = cmd_table.wPlayerID
    local wViewChairId = self:SwitchViewChairID(wPlayerID)
    self.cbPlayStatus[wPlayerID + 1] = 0
    self._gameView.bCanMoveCard = false
    self._gameView.nodePlayer[wViewChairId]:setVisible(false)
    --self._gameView.btOpenCard:setVisible(false)
    --self._gameView.btPrompt:setVisible(false)
    self._gameView.spriteCalculate:setVisible(false)
    for i = 1, 5 do
        -- self._gameView.cardFrame[i]:setVisible(false)
        -- self._gameView.cardFrame[i]:setSelected(false)
    end
    self._gameView:setOpenCardVisible(wViewChairId, false)
end

--游戏结束
function GameLayer:onSubGameEnd(dataBuffer)
    local cmd_table = ExternalFun.read_netdata(cmd.CMD_S_GameEnd, dataBuffer);
    dump(cmd_table,"the end data is =========",6)
    --error("message",0)
    self.m_bStartGame = false
    self.cbDynamicJoin = 0

     --牌值
    for i = 1, cmd.GAME_PLAYER do
        self.cbCardData[i] = {}
        for j = 1, cmd.MAX_CARDCOUNT do
            self.cbCardData[i][j] = cmd_table.cbCardData[i][j]
        end
    end

    local lGameTax = {}
    for i = 1, cmd.GAME_PLAYER do
        lGameTax[i] = cmd_table.lGameTax[1][i]
    end

    self.lCardType = {0,0,0,0,0,0}

    for i = 1, cmd.GAME_PLAYER do
        self.lGameEndScore[i] = cmd_table.lGameScore[1][i]
        if self.cbPlayStatus[i] == 1 then
            local wViewChairId = self:SwitchViewChairID(i - 1)

            self.lCardType[i] = cmd_table.cbCardType[1][i]
        end
        --self.cbPlayStatus[i] = 0
    end

    local cbDelayOverGame = cmd_table.cbDelayOverGame

    --开牌动画
    for i = 1, cmd.GAME_PLAYER do
        local viewid = self:SwitchViewChairID(i - 1)
        --if (viewid ~= cmd.MY_VIEWID) then  
            --dump(self.cbCardData, "the poker is ======")
            if (self.cbCardData and #self.cbCardData>0) then
                if self.cbCardData[i][1] > 0 then
                    self._gameView:stopCardAni(viewid)
                   -- print("jj viewid is ===",viewid)
                   -- print("jj i is =======",i)
                    self._gameView:openCardAnimate(viewid)
                end
            end
        --end
    end

   

    local lCardType = clone(self.lCardType)
    dump(lCardType)
    self._gameView:gameEnd(self.lGameEndScore,lCardType)


    -- 私人房无倒计时
    if not GlobalUserItem.bPrivateRoom then
        -- 设置倒计时
        if self.cbDynamicJoin == 0 then 
            self:KillGameClock()
            self._gameView:setClockBgVisible(true)
            self:SetGameClock(self:GetMeChairID(), cmd.IDI_START_GAME, cmd.TIME_USER_START_GAME)
        end

        
    else
        self._gameView:setClockBgVisible(false)
    end

   
    local callfunc = function( )
        self._gameView:onResetView()
    end
    self:runAction(cc.Sequence:create(cc.DelayTime:create(8),cc.CallFunc:create(callfunc)))
   
    
end
--游戏记录
function GameLayer:onSubGameRecord(dataBuffer)
    --print("游戏记录")
    local cmd_data = ExternalFun.read_netdata(cmd.CMD_S_RECORD, dataBuffer)
     
    self.m_userRecord.wincount = {}
    self.m_userRecord.losecount = {}
    self.m_userRecord.totalcount = cmd_data.nCount
    for i=1,cmd.GAME_PLAYER do
        self.m_userRecord.wincount[i] = cmd_data.lUserWinCount[1][i]
        self.m_userRecord.losecount[i] = cmd_data.lUserLostCount[1][i]
    end
    self.isPriOver = true
    --self._gameView.btStart:setVisible(false)
    --dump(self.m_userRecord,"约战记录")
end
--用户状态
function GameLayer:onEventUserStatus(useritem,newstatus,oldstatus)

    --print("change user " .. useritem.wChairID .. "; nick " .. useritem.szNickName .. "; newstatus " ..newstatus.cbUserStatus .."; oldstatus " ..oldstatus.cbUserStatus )
    if newstatus.cbUserStatus == yl.US_FREE or newstatus.cbUserStatus == yl.US_NULL then

        if (oldstatus.wTableID ~= self:GetMeUserItem().wTableID) then
            return
        end
        if yl.INVALID_CHAIR ==  useritem.wChairID then
            if self.isPriOver == true then
                return
            end
            ----print("查找人数",#self._gameView.m_UserItem)
            for i=1, cmd.GAME_PLAYER do
                --print("self.m_tabUserItem[i]",self.m_tabUserItem[i])
                ----print("self.m_tabUserItem[i].dwUserID",self.m_tabUserItem[i].dwUserID)
                --print("useritem.dwUserID ",useritem.dwUserID)
                if self.m_tabUserItem[i] and self.m_tabUserItem[i].dwUserID == useritem.dwUserID then
                    --print("查找",#self.m_tabUserItem, useritem.szNickName, self.m_tabUserItem[i].szNickName)
                    local wViewChairId = self:SwitchViewChairID(i-1)
                    self._gameView:OnUpdateUserExit(wViewChairId)
                    self._gameView:setReadyVisible(wViewChairId, false)
                    if not (PriRoom and GlobalUserItem.bPrivateRoom) then  
                       self.m_tabUserItem[i] = nil
                    end
                end
            end
        else
            local wViewChairId = self:SwitchViewChairID(useritem.wChairID)
            self._gameView:setReadyVisible(wViewChairId, false)
            self._gameView:OnUpdateUserExit(wViewChairId)
            if not (PriRoom and GlobalUserItem.bPrivateRoom) then  
                 self.m_tabUserItem[useritem.wChairID+1] = nil
            end
           
            --print("删除", wViewChairId)
        end
    else
        --print("改变状态")
        if (newstatus.wTableID ~= self:GetMeUserItem().wTableID) then
            --print("tableID is error")
            return
        end
        self.m_tabUserItem[useritem.wChairID+1] = clone(useritem)
        local viewid = self:SwitchViewChairID(useritem.wChairID)
        --刷新用户信息
        if useritem == self:GetMeUserItem() then
            if PriRoom and GlobalUserItem.bPrivateRoom then
                if PriRoom:getInstance().m_tabPriData.dwTableOwnerUserID == useritem.dwUserID then
                    --self._gameView:showFangzhuIcon(1)
                    
                end
            end
        end
        
        --print("更新用户资料 wChairID,viewid,szNickName",useritem.wChairID,viewid,useritem.szNickName)
        self._gameView:OnUpdateUser(viewid,useritem)
        if newstatus.cbUserStatus == yl.US_READY then
            --local viewid = self:SwitchViewChairID(useritem.wChairID)
            self._gameView:setReadyVisible(viewid, true)

            if viewid == cmd.MY_VIEWID then
                self._gameView:setClockBgVisible(false)
            end
        end
    end    
end

--用户进入
function GameLayer:onEventUserEnter(tableid,chairid,useritem)

    --print("the table id is ================>"..tableid.." chairid==>"..chairid)

  --刷新用户信息
    if useritem == self:GetMeUserItem() or tableid ~= self:GetMeUserItem().wTableID then
        return
    end

    self.m_tabUserItem[useritem.wChairID+1] = clone(useritem)

    local wViewChairId = self:SwitchViewChairID(chairid)
    --print("wViewChairId",wViewChairId)
    self._gameView:OnUpdateUser(wViewChairId, userItem)
    if useritem.cbUserStatus == yl.US_READY then
        self._gameView:setReadyVisible(wViewChairId, true)
    end

    -- 刷新房卡
    if PriRoom and GlobalUserItem.bPrivateRoom then
        if nil ~= self._gameView._priView and nil ~= self._gameView._priView.onRefreshInfo then
            self._gameView._priView:onRefreshInfo()
        end
    end
end

------------------------------------------------------------------------

------------------------------------------------------------------------
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
       
        self:KillGameClock()
        self._gameView:setClockBgVisible(false)
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

function GameLayer:sendCardFinish()
    if self.cbDynamicJoin == 1 then 
        return
    end 

    self._gameView:setClockBgVisible(true)
    self:KillGameClock()
    if not self.bAddScore then 
        self:SetGameClock(self:GetMeChairID(), cmd.IDI_TIME_USER_ADD_SCORE, cmd.TIME_USER_ADD_SCORE)
        return
    end
    self:SetGameClock(self:GetMeChairID(), cmd.IDI_TIME_OPEN_CARD, cmd.TIME_USER_OPEN_CARD)
end

--开单张牌
function GameLayer:openOneCard(viewid,index,bEnd)--, bEnded)
    local chairId = self:SwitchChairID(viewid)

    if self.cbCardData[chairId][index] == 0 then
       -- print("the viewid is ======",viewid)
        --print("the chairid is ========",chairId)
        return false
    end

    local data = self.cbCardData[chairId][index]
    --dump(self.cbCardData, "poker data ====  ", 6)
    local value = GameLogic:getCardValue(data)
    local color = GameLogic:getCardColor(data)
    local card = self._gameView.nodeCard[viewid][index]
    self._gameView:setCardTextureRect(viewid, index, value, color)

    if bEnd and (index == cmd.MAX_CARDCOUNT) then
        self._gameView:resetCardByType(clone(self.cbCardData),clone(self.lCardType))
    end

    return true
end

function GameLayer:openCard(chairId)--, bEnded)
    --排列cbCardData
    local index = chairId + 1
    if self.cbCardData[index] == nil then
        --print("出错")
        return false
    end
    GameLogic:getOxCard(self.cbCardData[index])
    local cbOx = GameLogic:getCardType(self.cbCardData[index])

    local viewId = self:SwitchViewChairID(chairId)
    for i = 1,cmd.MAX_CARDCOUNT  do
        local data = self.cbCardData[index][i]
        local value = GameLogic:getCardValue(data)
        local color = GameLogic:getCardColor(data)
        local card = self._gameView.nodeCard[viewId][i]
        self._gameView:setCardTextureRect(viewId, i, value, color)
    end

    self._gameView:gameOpenCard(viewId, cbOx)--, bEnded)

    return true
end

function GameLayer:getMeCardLogicValue(num)
    local index = self:GetMeChairID() + 1
    local value = GameLogic:getCardLogicValue(self.cbCardData[index][num])
    local str = string.format("index:%d, num:%d, self.cbCardData[index][num]:%d, return:%d", index, num, self.cbCardData[index][num], value)
    --print(str)
    return value
end

function GameLayer:getMeCardValue( index )
    local chairID = self:GetMeChairID() + 1
    if index == nil then
       return self.cbCardData[chairID]
    end
   
    local value = self.cbCardData[chairID][index]
    return value 
end

function GameLayer:getOxCard(cbCardData)
    return GameLogic:getOxCard(cbCardData)
end

function GameLayer:getPrivateRoomConfig()
    return self.m_tabPrivateRoomConfig
end
--约战记录
function GameLayer:getDetailScore()
    return self.m_userRecord
end

--********************   发送消息     *********************--
--叫庄
function GameLayer:onBanker(cbBanker,mul)

    local dataBuffer = CCmd_Data:create(2)
    dataBuffer:setcmdinfo(yl.MDM_GF_GAME,cmd.SUB_C_CALL_BANKER)
    dataBuffer:pushbyte(cbBanker)
    dataBuffer:pushbyte(mul)
    return self._gameFrame:sendSocketData(dataBuffer)
end

function GameLayer:onAddScore(lScore)
    --print("牛牛 发送下注 lScore",lScore)
    if lScore == nil then
        error("send lScore is nil !")
    end
    if self:SwitchViewChairID(self.wBankerUser) == cmd.MY_VIEWID then
        --print("牛牛: 自己庄家不下注")
        return
    end
    local dataBuffer = CCmd_Data:create(8)
    dataBuffer:setcmdinfo(yl.MDM_GF_GAME, cmd.SUB_C_ADD_SCORE)
    dataBuffer:pushscore(lScore)
    return self._gameFrame:sendSocketData(dataBuffer)
end

--发送开牌消息
function GameLayer:onOpenCard(data)

    dump(data, "the combine card is =====")
    local dataBuffer = CCmd_Data:create(5)
    dataBuffer:setcmdinfo(yl.MDM_GF_GAME, cmd.SUB_C_OPEN_CARD)
    for i=1,#data do
       dataBuffer:pushbyte(data[i])
    end

    return self._gameFrame:sendSocketData(dataBuffer)
end

function GameLayer:getChairCount()
    return table.nums(self.m_tabUserItem)
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