--                            _ooOoo_  
--                           o8888888o  
--                           88" . "88  
--                           (| -_- |)  
--                            O\ = /O  
--                        ____/`---'\____  
--                      .   ' \\| |// `.  
--                      / \\||| : |||// \  
--                     / _||||| -:- |||||- \  
--                       | | \\\ - /// | |  
--                     | \_| ''\---/'' | |  
--                      \ .-\__ `-` ___/-. /  
--                   ___`. .' /--.--\ `. . __  
--                ."" '< `.___\_<|>_/___.' >'"".  
--               | | : `- \`.;`\ _ /`;.`/ - ` : | |  
--                 \ \ `-. \_ __\ /__ _/ .-` / /  
--         ======`-.____`-.___\_____/___.-`____.-'======  
--                            `=---='  
--  
--         .............................................  
--                  佛祖保佑             永无BUG 
local GameModel = appdf.req(appdf.CLIENT_SRC.."gamemodel.GameModel")

local GameLayer = class("GameLayer", GameModel)

local cmd = appdf.req(appdf.GAME_SRC.."yule.zhajinhua.src.models.CMD_Game")
local GameLogic = appdf.req(appdf.GAME_SRC.."yule.zhajinhua.src.models.GameLogic")
local GameViewLayer = appdf.req(appdf.GAME_SRC.."yule.zhajinhua.src.views.layer.GameViewLayer")
local QueryDialog = appdf.req("client.src.app.views.layer.other.QueryDialog")
local scheduler = cc.Director:getInstance():getScheduler()
local ExternalFun = require(appdf.EXTERNAL_SRC .. "ExternalFun")
local pChangeChairReady = cc.p(667,375)
local pChangeChairEnd = cc.p(667,171)
local ptSitDown = {cc.p(425, 650),cc.p(75, 475), cc.p(75,275), cc.p(75, 50), cc.p(1275, 275), cc.p(1275, 475),cc.p(975, 650)}

function GameLayer:onExit()
    self:KillGameClock()
    self:dismissPopWait()
    GameLayer.super.onExit(self)
end

--退出桌子
function GameLayer:onExitTable()
    if self.m_querydialog then
        return
    end
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
                    --print("delay leave")
                    self:onExitRoom()
                end
                )
            )
        )
        return
    end
	
	self.m_bEndState = 1

   self:onExitRoom()
end

--离开房间
function GameLayer:onExitRoom()
	self._gameFrame:onCloseSocket()
	AppFacade:getInstance():sendNotification(GAME_COMMAMD.POP_VIEW, {Name = VIEW_LIST.GAME_LAYER})
end
--系统消息
function GameLayer:onSystemMessage( wType,szString )
    if wType == 501 or wType == 515 then
        --print("扎金花金币不足消息", szString)
        GlobalUserItem.bWaitQuit = true
        self:onSubNoticeAddScore(szString)
    end
end


function GameLayer:SwitchViewChairID(chair)
    local viewid = yl.INVALID_CHAIR
    local nChairCount = 7
    --print("椅子ID", chair)
    local nChairID = self:GetMeChairID()
    if chair ~= yl.INVALID_CHAIR and chair < nChairCount then
        viewid = math.mod(chair + math.floor(nChairCount * 3/2) - nChairID, nChairCount) + 1
        --print("转换后的ID", viewid)
    end
    return viewid
end

--[[function GameLayer:onGetSitUserNum()
    local userNum = 0
    for i=1,table.nums(self._gameView.nodePlayer) do
        if self._gameView.nodePlayer[i]:isVisible() then
            userNum = userNum + 1
        end
    end
    return userNum
    --return table.nums(self._gameView.nodePlayer)
end
--]]
function GameLayer:getUserInfoByChairID(chairId)
    return self._gameFrame:getTableUserItem(self._gameFrame:GetTableID(), chairId)
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

--[[function GameLayer:getUserInfoByChairID(chairId)
    local viewId = self:SwitchViewChairID(chairId)
    return self._gameView.m_tabUserItem[viewId]
end--]]

--获取gamekind
function GameLayer:getGameKind()
    return cmd.KIND_ID
end

-- 初始化界面
function GameLayer:ctor(frameEngine,scene)
    GameLayer.super.ctor(self,frameEngine,scene)
end

-- 创建场景
function GameLayer:CreateView()
    --cc.FileUtils:getInstance():addSearchPath(device.writablePath..cmd.RES,true)
    return GameViewLayer:create(self)
        :addTo(self)
end

function GameLayer:getParentNode( )
    return self._scene
end
--设置私有房的层级
function GameModel:addPrivateGameLayer( layer )
    if nil == layer then
        return
    end
        self._gameView:addChild(layer, 9)
end

-- 初始化游戏数据
function GameLayer:OnInitGameEngine()

    GameLayer.super.OnInitGameEngine(self)

    self.m_wCurrentUser = yl.INVALID_CHAIR              						--当前用户
    self.m_wBankerUser = yl.INVALID_CHAIR               						--庄家用户

    self.m_cbPlayStatus = {0,0,0,0,0,0,0}                     					--游戏状态
    self.m_lTableScore = {0,0,0,0,0,0,0}                      					--下注数目

    self.m_lMaxCellScore = 0                            							--单元上限
    self.m_lCellScore = 0                               							--单元下注

    self.m_lCurrentTimes = 0                            							--当前倍数
    self.m_lUserMaxScore = 0                            							--最大分数

    self.m_bLookCard  = {false,false,false,false,false,false,false}        --看牌动作

    self.m_wLostUser = yl.INVALID_CHAIR                 --比牌失败
    self.m_wWinnerUser = yl.INVALID_CHAIR               --胜利用户 

    self.m_lAllTableScore = 0

    self.m_bNoScore = false   --金币不足
    self.m_bStartGame = false
    -- 提示
    self.m_szScoreMsg = ""
    
    self.chUserAESKey = 
    {
        0x32, 0x43, 0xF6, 0xA8,
        0x88, 0x5A, 0x30, 0x8D,
        0x31, 0x31, 0x98, 0xA2,
        0xE0, 0x37, 0x07, 0x34
    }
    self.nVoiceFollow = {0, 0, 0, 0, 0, 0, 0}
	
	self.nVoiceRaise = {0, 0, 0, 0, 0, 0, 0}
	
	self.nVoiceCompare = {0, 0, 0, 0, 0, 0, 0}
	
	self.nVoiceGiveup = {0, 0, 0, 0, 0, 0, 0}
	
	self.nVoiceLookCard = {0, 0, 0, 0, 0, 0, 0}
	
	self.nVoiceShowCard = {0, 0, 0, 0, 0, 0, 0}
	
	--当前轮次	
	self.m_nCurrentRound = 1
	--总轮数
	self.m_nTotalRound = 0
	
	self.m_bReallyStart = 0
	
	self.m_bEndState = 1
	
	self.m_cbCardData = {}
	
	self.m_cheat = 0
	self.dangqianfengshu  = 0
	--self.m_MyProgress = cc.ProgressTimer:create(display.newSprite("#progress.png"))
end

-- 重置游戏数据
function GameLayer:OnResetGameEngine()
    GameLayer.super.OnResetGameEngine(self)

    self._gameView:OnResetView()

    self.m_wCurrentUser = yl.INVALID_CHAIR             	 					--当前用户
    self.m_wBankerUser = yl.INVALID_CHAIR               						--庄家用户
    self.m_cbPlayStatus = {0,0,0,0,0,0,0}                     					--游戏状态
    self.m_lTableScore = {0,0,0,0,0,0,0}                      					--下注数目
    self.m_lMaxCellScore = 0                            							--单元上限
    self.m_lCellScore = 0                              							--单元下注
    self.m_lCurrentTimes = 0                            							--当前倍数
    self.m_lUserMaxScore = 0                            							--最大分数
    self.m_bLookCard  = {false,false,false,false,false,false,false}        --看牌动作
    self.m_wLostUser = yl.INVALID_CHAIR                 						--比牌失败
    self.m_wWinnerUser = yl.INVALID_CHAIR               						--胜利用户 
    self.m_lAllTableScore = 0
	self.m_nEnterScene = 0
	
	self.m_PlaySitDown = 1

    self.dangqianfengshu  = 0    --当前分数
end

-- 设置计时器
function GameLayer:SetGameClock(chair,id,time)
    GameLayer.super.SetGameClock(self,chair,id,time)
    local viewid = self:GetClockViewID()
    if viewid and viewid ~= yl.INVALID_CHAIR then
		if self:SwitchViewChairID(chair) ~= cmd.MY_VIEWID then
			local posid = self:SwitchViewChairID(chair)
			--printf("chair is %d, posid is %d", chair,posid)
		end
        local progress = self._gameView.m_TimeProgress[viewid]
		
		--self._gameView.m_UserHead[viewid].head
        if progress ~= nil then	
			--print("progress x:%d,y:%d",progress:getPositionX(),progress:getPositionY())
			
			if viewid == cmd.MY_VIEWID then		
--[[				local MeItem = self:GetMeUserItem()
				if (self.m_cbGameStatus == cmd.GAME_STATUS_PLAY and self.m_bStartGame == true) or
					(MeItem and MeItem.cbUserStatus == yl.US_PLAYING and self.m_cbGameStatus == cmd.GAME_STATUS_PLAY) then
					local pMyself = cc.p(self._gameView.btGiveUp:getPositionX(), self._gameView.btGiveUp:getPositionY())
					pMyself = self._gameView.nodeButtomButton:convertToWorldSpace(pMyself)	
					progress:move(pMyself.x,pMyself.y)
				else
					progress = self._gameView.m_ReadyProgress
					local pMyself = cc.p(self._gameView.btReady:getPositionX(), self._gameView.btReady:getPositionY())
					pMyself = self._gameView:convertToWorldSpace(pMyself)	
					progress:move(pMyself.x,pMyself.y)
				end--]]
				
				    --self.m_cbGameStatus == cmd.GAME_STATUS_FREE	
				
				--if self._gameView.btReady:isVisible() == true and self.m_cbGameStatus == cmd.GAME_STATUS_FREE then
				if self.m_cbGameStatus == cmd.GAME_STATUS_FREE and self.m_bStartGame == false then
					progress = self._gameView.m_ReadyProgress
					local pMyself = cc.p(self._gameView.btReady:getPositionX(), self._gameView.btReady:getPositionY())
					pMyself = self._gameView:convertToWorldSpace(pMyself)	
					progress:move(pMyself.x,pMyself.y)
				else			
					if id == cmd.IDI_USER_COMPARE_CARD then
						self._gameView.btGiveUp:setVisible(false)
						self._gameView.btCompareTime:setVisible(true)
					else
						self._gameView.btGiveUp:setVisible(true)
						self._gameView.btCompareTime:setVisible(false)
					end
					
					local pMyself = cc.p(self._gameView.btGiveUp:getPositionX(), self._gameView.btGiveUp:getPositionY())
					--pMyself = self._gameView.nodeButtomButton:convertToWorldSpace(pMyself)	
					pMyself = self._gameView:convertToWorldSpace(pMyself)
					progress:move(pMyself.x,pMyself.y)
				end

			else
				
				local pOther = cc.p(self._gameView.nodePlayer[viewid]:getChildByName("Headbg"):getPositionX()
				, self._gameView.nodePlayer[viewid]:getChildByName("Headbg"):getPositionY())
				pOther = self._gameView.nodePlayer[viewid]:convertToWorldSpace(pOther)	

				progress:move(pOther.x,pOther.y)

--[[				local sp = self._gameView.m_sp[viewid]
				
				if self._gameView.m_sp[viewid] ~= nil then
					if self._gameView.m_sp[viewid].m_head ~= nil then
						progress:setSprite(self._gameView.m_sp[viewid].m_head)
					end
				end

			
				self._gameView.m_TimeProgressMask[viewid]:move(pOther.x,pOther.y)--]]
			end
			
			--per 走了多少时间,time剩余时间
			local per = 0
--[[			if id == cmd.IDI_START_GAME then
				per = time/cmd.TIME_START_GAME
			elseif	id == cmd.IDI_USER_ADD_SCORE		then
				per = time/cmd.TIME_USER_ADD_SCORE
			elseif	id == cmd.IDI_USER_COMPARE_CARD		then
				per = time/cmd.TIME_USER_COMPARE_CARD
			end--]]
			if id == cmd.IDI_START_GAME then
				per = (cmd.TIME_START_GAME - time)/cmd.TIME_START_GAME
			elseif	id == cmd.IDI_USER_ADD_SCORE		then
				per = (cmd.TIME_USER_ADD_SCORE - time)/cmd.TIME_USER_ADD_SCORE
			elseif	id == cmd.IDI_USER_COMPARE_CARD		then
				per = (cmd.TIME_USER_COMPARE_CARD - time)/cmd.TIME_USER_COMPARE_CARD
			end
			
			if time <= 0 and id == cmd.IDI_USER_ADD_SCORE then
				self:onGiveUp()
				return
			end
			
            progress:setPercentage(0+per*100)
            progress:setVisible(true)
			--self._gameView.m_TimeProgressMask[viewid]:setVisible(true)

            progress:runAction(cc.Sequence:create(cc.ProgressTo:create(time, 100), cc.CallFunc:create(function()
                progress:setVisible(false)
				--self._gameView.m_TimeProgressMask[viewid]:setVisible(false)
                self:OnEventGameClockInfo(viewid, id)
            end)))
        end
    end
end

-- 关闭计时器
function GameLayer:KillGameClock(notView)
    local viewid = self:GetClockViewID()
    if viewid and viewid ~= yl.INVALID_CHAIR then
        local progress = self._gameView.m_TimeProgress[viewid]
        if progress ~= nil then
            progress:stopAllActions()
            progress:setVisible(false)
        end
		
		local Readyprogress = self._gameView.m_ReadyProgress
        if Readyprogress ~= nil then
            Readyprogress:stopAllActions()
            Readyprogress:setVisible(false)
        end
    end
    
    GameLayer.super.KillGameClock(self,notView)
end

--获得当前正在玩的玩家数量
function GameLayer:getPlayingNum()
    local num = 0
    for i = 1, cmd.GAME_PLAYER do
        if self.m_cbPlayStatus[i] == 1 then
            num = num + 1
        end
    end
    return num
end

-- 时钟处理
function GameLayer:OnEventGameClockInfo(chair,time,clockid)
     --房卡不托管
    if GlobalUserItem.bPrivateRoom then
        print("倒计时处理，房卡返回")
        if time <= 0 then
            return true
        end
    end 
    if time < 5 then
        --self:PlaySound(cmd.RES.."sound_res/GAME_WARN.wav")
		ExternalFun.playSoundEffect("GAME_WARN.mp3")
    end
    if clockid == cmd.IDI_START_GAME then
        if time <= 0 then
            self._gameFrame:setEnterAntiCheatRoom(false)--退出防作弊
            return true
        end
    elseif clockid == cmd.IDI_DISABLE then
        if time <= 0 then
            return true
        end
    elseif clockid == cmd.IDI_USER_ADD_SCORE then
        if time <= 0 then
            if self.m_wCurrentUser == self:GetMeChairID() then
                    self:onGiveUp()
					self._gameView:HideRaiseMenu()
                return true
            end
        end
		
		--探照灯
		if self:SwitchViewChairID(self.m_wCurrentUser) ~= yl.INVALID_CHAIR then
			self._gameView.m_FlashLight[self:SwitchViewChairID(self.m_wCurrentUser)]:setVisible(true)
		end
		
		for i = 1, cmd.GAME_PLAYER  do
			if  i ~= self:SwitchViewChairID(self.m_wCurrentUser) then
				self._gameView.m_FlashLight[i]:setVisible(false)
			end
		end
		
		--followok
		if self.m_wCurrentUser == self:GetMeChairID() and self._gameView.m_ChkOK then
			local MyChair = self:GetMeChairID()
			local userCount = self:getPlayingNum()
			MyChair = MyChair + 1
			local lTempTime =(self.m_bLookCard[MyChair] == true and 2 or 1)
			if (self.m_lUserMaxScore - self.m_lTableScore[MyChair] >= 
				self.m_lCellScore*(lTempTime + self.m_lCurrentTimes) and (self.m_nCurrentRound < self.m_nTotalRound)) then
				self:addScore(0)
			end
		end
    elseif clockid == cmd.IDI_USER_COMPARE_CARD then
        if time <= 0 then
            self._gameView:SetCompareCard(false)
            self:onAutoCompareCard()
            return true
        end
    end
end

-- 场景信息
function GameLayer:onEventGameScene(cbGameStatus,dataBuffer)
    --辅助读取int64
    local int64 = Integer64.new()

    --初始化已有玩家
--[[    for i = 1, cmd.GAME_PLAYER do
        local userItem = self._gameFrame:getTableUserItem(self._gameFrame:GetTableID(), i-1)
        local wViewChairId = self:SwitchViewChairID(i-1)
        self._gameView:OnUpdateUser(wViewChairId, userItem)
    end	--]]
	
    self.m_cbGameStatus = cbGameStatus
	if cbGameStatus == cmd.GAME_STATUS_FREE	then				--空闲状态

		if(self._gameView.istable == false) then
			self._gameView.btChangeTable:setEnabled(true)
		end
		
        self.m_lCellScore = dataBuffer:readdouble()
        --local lRoomStorageStart = dataBuffer:readdouble()
        --local lRoomStorageCurrent = dataBuffer:readdouble()
        --机器人配置
        for i = 1, 40 do
            dataBuffer:readbyte()
        end
        --初始秘钥
        for i = 1, 16 do
            self.chUserAESKey[i] = dataBuffer:readbyte()
        end
        --房间名称
        local szServerName = dataBuffer:readstring(32)

        self._gameView:SetCellScore(self.m_lCellScore)
		self._gameView.btGiveUp:setVisible(false)
		self._gameView.btCompareTime:setVisible(false)
        if not GlobalUserItem.isAntiCheat() then
            self._gameView.btReady:setVisible(self:GetMeUserItem().cbUserStatus == yl.US_SIT)
			self._gameView.btChangeTable:setVisible(self:GetMeUserItem().cbUserStatus == yl.US_SIT)
			if self:GetMeUserItem().cbUserStatus == yl.US_SIT then
				print("btChangeTable:setVisible true:GAME_STATUS_FREE")
			else
				print("btChangeTable:setVisible false:GAME_STATUS_FREE")
			end
			
			self._gameView.btChangeTable:move(self._gameView.m_ChangeTablepos.x,self._gameView.m_ChangeTablepos.y)
			
			for i = 1, cmd.GAME_PLAYER do
				self._gameView.m_LookOn[i]:setVisible(false)
			end
                -- 私人房无倒计时
            if not GlobalUserItem.bPrivateRoom then
                -- 设置倒计时
                self:SetGameClock(self:GetMeChairID(),cmd.IDI_START_GAME,cmd.TIME_START_GAME)
            end   
        end

	elseif cbGameStatus == cmd.GAME_STATUS_PLAY	then			--游戏状态
        print("game status is play!")
        local MyChair = self:GetMeChairID() + 1
        --参数设置
        self.m_lMaxCellScore = dataBuffer:readdouble()
        self.m_lCellScore = dataBuffer:readdouble()
        self.m_lCurrentTimes = dataBuffer:readdouble()
        self.m_lUserMaxScore = dataBuffer:readdouble()
        self.m_wBankerUser = dataBuffer:readword()
        self.m_wCurrentUser = dataBuffer:readword()
        for i = 1, cmd.GAME_PLAYER do
            self.m_cbPlayStatus[i] = dataBuffer:readbyte()
            print("状态", self.m_cbPlayStatus[i])
        end

        for i = 1, cmd.GAME_PLAYER  do
            self.m_bLookCard[i] = dataBuffer:readbool()
        end
        for i = 1, cmd.GAME_PLAYER do
            self.m_lTableScore[i]  = dataBuffer:readdouble()
        end
        --local lRoomStorageStart = dataBuffer:readdouble()
        --local lRoomStorageCurrent = dataBuffer:readdouble()
        --机器人数据
        for i = 1, 40 do
            dataBuffer:readbyte()
        end
        local cardData = {}
        for i = 1, 3 do
            cardData[i] = dataBuffer:readbyte()
        end
        local bCompareStatus = dataBuffer:readbool()
        --初始秘钥
        for i = 1, 16 do
            self.chUserAESKey[i] = dataBuffer:readbyte()
        end
        --房间名称
        local szServerName = dataBuffer:readstring(32)

        self.m_lAllTableScore = 0

        --底注信息
        self._gameView:SetCellScore(self.m_lCellScore)
        self._gameView:SetMaxCellScore(self.m_lMaxCellScore)

        --庄家信息
        self._gameView:SetBanker(self:SwitchViewChairID(self.m_wBankerUser))
		
		if self:SwitchViewChairID(self.m_wCurrentUser) ~= yl.INVALID_CHAIR then
			self._gameView.m_FlashLight[self:SwitchViewChairID(self.m_wCurrentUser)]:setVisible(true)
		end
		
		local nMeChairID = self:GetMeChairID()
        for i = 1, cmd.GAME_PLAYER do
            --视图位置
            local viewid = self:SwitchViewChairID(i-1)
            --手牌显示
            if self.m_cbPlayStatus[i] == 1 then
				--开始游戏，屏蔽换桌按钮
				if i == MyChair then
					--self._gameView.btChangeTable:setVisible(false)
					print("btChangeTable:setVisible false:GAME_STATUS_PLAY")
					self._gameView.btGiveUp:setVisible(true)
				end
				
				if i == MyChair  and self.m_bLookCard[MyChair] == false then
					self._gameView.btLookCard:setEnabled(true)
					self._gameView.btLookCard:setVisible(true)
				end
				
                self._gameView.userCard[viewid].area:setVisible(true)
                if i == MyChair  and self.m_bLookCard[MyChair] == true then
					local cbCardSort = {}
					cbCardSort = GameLogic:sortCard(cardData)
			
--[[                    local cardIndex = {}
                    for k = 1 , 3 do
                        cardIndex[k] = GameLogic:getCardColor(cbCardSort[k])*13 + GameLogic:getCardValue(cbCardSort[k])
                    end--]]
                    self._gameView:SetUserCard(viewid,cbCardSort)
                    
                else
                    self._gameView:SetUserCard(viewid,{0xff,0xff,0xff})
					for i = 1, 3 do
						self._gameView.userCard[viewid].card[i]:setVisible(true)
					end
                end
				
				if i == MyChair then
					if self.m_bLookCard[MyChair] == false then
						self._gameView.btLookCard:setVisible(true)
						self._gameView.btLookCard:setEnabled(true)		
					end
				end
            else
				self._gameView:clearDisplay(viewid)
                self._gameView.userCard[viewid].area:setVisible(false)
                self._gameView:SetUserCard(viewid)
				self._gameView.m_LookOn[viewid]:setVisible(true)
				
		 
				if i == self:GetMeChairID() + 1 then
					self._gameView.btChangeTable:setVisible(true)
					--self._gameView.btChangeTable:setEnabled(true)
					print("btChangeTable:setVisible true:GAME_STATUS_PLAY")
					self._gameView.btChangeTable:move(pChangeChairReady.x,pChangeChairReady.y)
					
					self._gameView.btGiveUp:setVisible(false)
					self._gameView.btCompareTime:setVisible(false)
				end
            end
            --看牌显示
            self._gameView:SetLookCard(viewid,self.m_bLookCard[i])
            self._gameView:SetUserTableScore(viewid, self.m_lTableScore[i])
            self.m_lAllTableScore = self.m_lAllTableScore + self.m_lTableScore[i]

			if self.m_lTableScore[i] > 0 then
				self._gameView:PlayerJetton(viewid,self.m_lTableScore[i],true)
			end
			
            --是否弃牌
            if self.m_cbPlayStatus[i] ~= 1 and self.m_lTableScore[i] > 0 then
                --self._gameView.userCard[viewid].area:setVisible(true)
                --self._gameView:SetUserGiveUp(viewid, true)
--[[				self._gameView.btChangeTable:setVisible(true)
				self._gameView.btChangeTable:setEnabled(true)--]]
				--self._gameView.m_GiveUp[viewid]:setVisible(true)
				
				self._gameView.m_GiveUp[viewid]:setVisible(true)
				self._gameView.m_LookOn[viewid]:setVisible(false)
				self._gameView.m_LookCard[viewid]:setVisible(false)
				self._gameView.m_flagReady[viewid]:setVisible(false)
				self._gameView.m_CompareLose[viewid]:setVisible(false)
				
				print("btChangeTable:setVisible true:GAME_STATUS_PLAY fold")
				--self._gameView.btChangeTable:move(pChangeChairReady.x,pChangeChairReady.y)
				self._gameView.isFoldChair = true
				--退出按钮可用
				self._gameView.btBack:setEnabled(true)
            end
        end
		
--[[		local delayCount = 1
		for index = 1 , 3 do
			for i = 1, cmd.GAME_PLAYER do
				local chair = math.mod(self.m_wBankerUser + i - 1,cmd.GAME_PLAYER) 
				if self.m_cbPlayStatus[chair + 1] == 1 then
					self._gameView:SendCard(self:SwitchViewChairID(chair),index,delayCount*0.1)
					delayCount = delayCount + 1
				end
			end
		end--]]

        --总下注
        self._gameView:SetAllTableScore(self.m_lAllTableScore)
		
		self.m_nCurrentRound = dataBuffer:readint()
		self.m_nTotalRound = dataBuffer:readint()
		--liuyang，总轮数，第几轮
		self._gameView:SetRounds(self.m_lAllTableScore,self.m_nCurrentRound,self.m_nTotalRound)
		
		--计时器剩余几秒
		self.m_nElapseTime = dataBuffer:readdouble()

        --控件信息
        self._gameView.nodeButtomButton:setVisible(false)

        if not bCompareStatus then
            --控件信息
            if self:GetMeChairID() == self.m_wCurrentUser then
                self:UpdataControl()
            end
            --设置时间
            --self:SetGameClock(self.m_wCurrentUser, cmd.IDI_USER_ADD_SCORE, cmd.TIME_USER_ADD_SCORE)
			self:SetGameClock(self.m_wCurrentUser, cmd.IDI_USER_ADD_SCORE, self.m_nElapseTime/1000)
        else

            if self:GetMeChairID() == self.m_wCurrentUser then
                --选择玩家比牌
                local compareStatus={false,false,false,false,false,false,false}
                for i = 1 ,cmd.GAME_PLAYER do
                    if self.m_cbPlayStatus[i] == 1 and i ~= MyChair then
                        compareStatus[self:SwitchViewChairID(i-1)] = true
                    end
                end
                self._gameView:SetCompareCard(true,compareStatus)
				
				self._gameView.btGiveUp:setVisible(false)
				self._gameView.btCompareTime:setVisible(true)
				
				
                --设置时间
                --self:SetGameClock(self.m_wCurrentUser, cmd.IDI_USER_COMPARE_CARD, cmd.TIME_USER_COMPARE_CARD)
				self:SetGameClock(self.m_wCurrentUser, cmd.IDI_USER_COMPARE_CARD, self.m_nElapseTime/1000)
            else
                self._gameView:SetCompareCard(false)
                --设置时间
                --self:SetGameClock(self.m_wCurrentUser, cmd.IDI_DISABLE, cmd.TIME_USER_COMPARE_CARD)
				self:SetGameClock(self.m_wCurrentUser, cmd.IDI_DISABLE, self.m_nElapseTime/1000)
            end
        end
	end

    for i = 1, cmd.GAME_PLAYER do
        local userItem = self._gameFrame:getTableUserItem(self._gameFrame:GetTableID(), i-1)
        local wViewChairId = self:SwitchViewChairID(i-1)
        self._gameView:OnUpdateUser(wViewChairId, userItem)
    end	
	
	
    -- 刷新房卡
    --print("场景消息PriRoom GlobalUserItem.bPrivateRoom", PriRoom, GlobalUserItem.bPrivateRoom)
    if PriRoom and GlobalUserItem.bPrivateRoom then
        --print("场景消息 self._gameView._priView self._gameView._priView.onRefreshInfo", self._gameView._priView, self._gameView._priView.onRefreshInfo)
        if nil ~= self._gameView._priView and nil ~= self._gameView._priView.onRefreshInfo then
            --print("场景消息 刷新房卡信息")
            self._gameView._priView:onRefreshInfo()
        end
    end
    self:dismissPopWait()
	
end

-- 游戏消息
function GameLayer:onEventGameMessage(sub,dataBuffer)
	if sub == cmd.SUB_S_GAME_START then 
		self:onSubGameStart(dataBuffer)
	elseif sub == cmd.SUB_S_ADD_SCORE then 
		self:onSubAddScore(dataBuffer)
	elseif sub == cmd.SUB_S_LOOK_CARD then 
		self:onSubLookCard(dataBuffer)
	elseif sub == cmd.SUB_S_COMPARE_CARD then 
		self:onSubCompareCard(dataBuffer)
	elseif sub == cmd.SUB_S_GIVE_UP then 
		self:onSubGiveUp(dataBuffer)
	elseif sub == cmd.SUB_S_PLAYER_EXIT then 
		self:onSubPlayerExit(dataBuffer)
    elseif sub == cmd.SUB_S_GAME_END then 
        self:onSubGameEnd(dataBuffer)
    elseif sub == cmd.SUB_S_WAIT_COMPARE then 
        self:onSubWaitCompare(dataBuffer)
    elseif sub == cmd.SUB_S_UPDATEAESKEY then
        self:onSubUpdateAesKey(dataBuffer)
    elseif sub == cmd.SUB_S_RC_TREASURE_DEFICIENCY then
       --self:onSubNoticeAddScore("你的金币不足，无法继续游戏")
	elseif sub == cmd.SUB_S_SHOW_CARD then
        self:onSubShowCard(dataBuffer)
	elseif sub == cmd.SUB_S_AUTO_COMPARE then
        self:onSubAutoCompare(dataBuffer)
	elseif sub == cmd.SUB_S_ALL_CARD then 
		self:onSubControl(dataBuffer)
	elseif sub == cmd.SUB_S_ADMIN_COLTERCARD then 
		self:onSubUpdataControlResult(dataBuffer)
	else
		print("unknow gamemessage sub is"..sub)
	end
end

function GameLayer:onSubUpdataControlResult(dataBuffer)
	local wPlayerID = dataBuffer:readword()
	
	for j = 1, 3 do
		self.m_cbCardData[wPlayerID + 1][j] = dataBuffer:readbyte()
	end
	
	--控制玩家需要执行
	if self._gameView.cbSurplusCardCount > 0 then
		--更新自己的牌
		self._gameView:SetUserCard(self:SwitchViewChairID(wPlayerID), self.m_cbCardData[wPlayerID + 1])

		
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
		
		self._gameView.ControlCardData = GameLogic:SortCardList(self._gameView.ControlCardData, self._gameView.cbSurplusCardCount, 0)
	
		for i = 1,self._gameView.cbSurplusCardCount do
			local card_index = GameLogic:GetCardLogicValueToInt(self._gameView.ControlCardData[i]);
			
			if i < self._gameView.cbSurplusCardCount*2/3 then
				self._gameView.ControlCardImage[i] = display.newSprite(cmd.RES.."card/pocker_middle/"..string.format("card_%d.png",card_index))
				self._gameView.ControlCardImage[i]:setPosition(330+i*30,700)
				:setVisible(true)
				:setLocalZOrder(2)
				:addTo(self,200)
			else
				self._gameView.ControlCardImage[i] = display.newSprite(cmd.RES.."card/pocker_middle/"..string.format("card_%d.png",card_index))
				self._gameView.ControlCardImage[i]:setPosition(0+i*30 - self._gameView.cbSurplusCardCount/2 * 30 - 80,370)
				:setVisible(true)
				:setLocalZOrder(2)
				:addTo(self,200)
			end
		end
	
		
		
	end
end

--超控
function GameLayer:onSubControl(dataBuffer)
	local bAndroid = {}
	for i = 1, cmd.GAME_PLAYER do
		bAndroid[i] = dataBuffer:readbool()
	end
	
	for i = 1, cmd.GAME_PLAYER do
		self._gameView.bAICount[self:SwitchViewChairID(i-1)] = bAndroid[i]
	end
	for i = 1, cmd.GAME_PLAYER do
		if self._gameView.bAICount[i] == true and self._gameView.m_UserHead[i] ~= nil then
			self._gameView.m_UserHead[i].Control:setVisible(true)
		end
	end

	
	for i = 1, cmd.GAME_PLAYER do
        self._gameView.cbControlUserCardData[i] = {}
        for j = 1, 3 do
            self._gameView.cbControlUserCardData[i][j] = dataBuffer:readbyte()
        end
    end
	self._gameView.cbSurplusCardCount = dataBuffer:readbyte()
	for i = 1, 52 do
		self._gameView.ControlCardData[i] = dataBuffer:readbyte()
	end

	self._gameView.ControlCardData = GameLogic:SortCardList(self._gameView.ControlCardData, self._gameView.cbSurplusCardCount, 0)
	
	for i = 1,self._gameView.cbSurplusCardCount do
		local card_index = GameLogic:GetCardLogicValueToInt(self._gameView.ControlCardData[i]);
		
		if i < self._gameView.cbSurplusCardCount*2/3 then
			self._gameView.ControlCardImage[i] = display.newSprite(cmd.RES.."card/pocker_middle/"..string.format("card_%d.png",card_index))
			self._gameView.ControlCardImage[i]:setPosition(330+i*30,700)
			:setVisible(true)
			:setLocalZOrder(2)
			:addTo(self,200)
		else
			self._gameView.ControlCardImage[i] = display.newSprite(cmd.RES.."card/pocker_middle/"..string.format("card_%d.png",card_index))
			self._gameView.ControlCardImage[i]:setPosition(0+i*30 - self._gameView.cbSurplusCardCount/2 * 30 - 80,370)
			:setVisible(true)
			:setLocalZOrder(2)
			:addTo(self,200)
		end
	end
	
	self.m_cheat = 1
	
end

--游戏开始
function GameLayer:onSubGameStart(dataBuffer)

    local int64 = Integer64.new()

    self.m_cbGameStatus = cmd.GAME_STATUS_PLAY

    self.m_lMaxCellScore = dataBuffer:readdouble()
    self.m_lCellScore = dataBuffer:readdouble()
    self.m_lCurrentTimes = dataBuffer:readdouble()
    self.m_lUserMaxScore = dataBuffer:readdouble()

    --print("游戏开始底注信息 MaxCellScore   CellScore", self.m_lMaxCellScore, self.m_lCellScore) 

    self.m_wBankerUser = dataBuffer:readword()
    self.m_wCurrentUser = dataBuffer:readword()
	
	for i = 1, cmd.GAME_PLAYER do
        self.m_cbCardData[i] = {}
        for j = 1, 3 do
            self.m_cbCardData[i][j] = dataBuffer:readbyte()
        end
		
		local cbCardSort = {}
		cbCardSort = GameLogic:sortCard(self.m_cbCardData[i])
		
        local cardIndex = {}
        for k = 1 , 3 do
            cardIndex[k] = GameLogic:getCardColor(cbCardSort[k])*13 + GameLogic:getCardValue(cbCardSort[k])
        end
    end
	
	self._gameView.m_csbAniBank:setVisible(true)
    self._gameView.m_AniBank:play("AniBank", false)
	local viewid = self:SwitchViewChairID(self.m_wBankerUser)
    function callBack()
		point = cc.p(ptSitDown[viewid].x, ptSitDown[viewid].y)
		self._gameView.m_csbAniBank:runAction(cc.Sequence:create(
		cc.MoveTo:create(0.3, point), 
		cc.CallFunc:create(function()
				local winsize = cc.Director:getInstance():getWinSize()
				self._gameView.m_csbAniBank:move(winsize.width / 2,winsize.height /2)
				self._gameView.m_csbAniBank:setVisible(false)
				self._gameView:SetBanker(self:SwitchViewChairID(self.m_wBankerUser))
				
				--发牌
				local delayCount = 1
				for index = 1 , 3 do
					for i = 1, cmd.GAME_PLAYER do
						local chair = math.mod(self.m_wBankerUser + i - 1,cmd.GAME_PLAYER) 
						if self.m_cbPlayStatus[chair + 1] == 1 then
							self._gameView:SendCard(self:SwitchViewChairID(chair),index,delayCount*0.1,chair,self.m_wCurrentUser)
							delayCount = delayCount + 1 
						end
					end
				end
				
				self._gameView.m_FlashLight[self:SwitchViewChairID(self.m_wCurrentUser)]:setVisible(true)
				
--[[				if self.m_wCurrentUser == self:GetMeChairID() then
					self:UpdataControl()
				end
				self:SetGameClock(self.m_wCurrentUser,cmd.IDI_USER_ADD_SCORE,cmd.TIME_USER_ADD_SCORE)--]]
			end)
		))
    end
	
    self._gameView.m_AniBank:setLastFrameCallFunc(callBack)
    
    self._gameView:SetCellScore(self.m_lCellScore)
    self._gameView:SetMaxCellScore(self.m_lMaxCellScore)

    self.m_lAllTableScore = 0
	
	self.m_PlaySitDown = 1
			
	--清总池
    self._gameView:CleanAllJettons()
	
    for i = 1, cmd.GAME_PLAYER  do
        --跟新玩家
        local userItem = self._gameFrame:getTableUserItem(self._gameFrame:GetTableID(), i-1)
        local wViewChairId = self:SwitchViewChairID(i-1)
        self._gameView:OnUpdateUser(wViewChairId, userItem)
		self._gameView.m_flagReady[wViewChairId]:setVisible(false)
		
        --读取游戏状态
        local data = dataBuffer:readbyte()
        self.m_cbPlayStatus[i] = data
        if self.m_cbPlayStatus[i] == 1 then 
            self.m_lAllTableScore = self.m_lAllTableScore + self.m_lCellScore
            self.m_lTableScore[i] = self.m_lCellScore
            --用户下注
            self._gameView:SetUserTableScore(wViewChairId, self.m_lCellScore)
            --移动筹码
            self._gameView:PlayerJetton(wViewChairId,self.m_lTableScore[i])
			
--[[			local userItem = self:getUserInfoByChairID(i - 1)
			if userItem ~= nil then
				local numscore = userItem.lScore - self.m_lTableScore[i]
				self._gameView.m_UserHead[i].score:setString(ExternalFun.formatScoreText(numscore))
			end--]]
        end
    end
	
	self._gameView.m_SitDown:setLastFrameCallFunc(nil)

    --总计下注
    self._gameView:SetAllTableScore(self.m_lAllTableScore)
	
	self.m_nCurrentRound = dataBuffer:readint()
	self.m_nTotalRound = dataBuffer:readint()
	--liuyang，总轮数，第几轮
	self._gameView:SetRounds(self.m_lAllTableScore,self.m_nCurrentRound,self.m_nTotalRound)

    --发牌
    --self:PlaySound(cmd.RES.."sound_res/SEND_CARD_BEGIN.wav")
--[[    local delayCount = 1
    for index = 1 , 3 do
        for i = 1, cmd.GAME_PLAYER do
            local chair = math.mod(self.m_wBankerUser + i - 1,cmd.GAME_PLAYER) 
            if self.m_cbPlayStatus[chair + 1] == 1 then
                self._gameView:SendCard(self:SwitchViewChairID(chair),index,delayCount*0.1)
                delayCount = delayCount + 1
            end
        end
    end--]]
   
    --self:SetGameClock(self.m_wCurrentUser,cmd.IDI_USER_ADD_SCORE,cmd.TIME_USER_ADD_SCORE)

	--liuyang
--[[	self._gameView.btLookCard:setEnabled(true)
	self._gameView.btLookCard:setVisible(true)--]]
	
	self._gameView.btChangeTable:setVisible(false)
	print("btChangeTable:setVisible false:onSubGameStart")
	
	--退出按钮不可用
	self._gameView.btBack:setEnabled(false)
	
--[[    if self.m_wCurrentUser == self:GetMeChairID() then
        self:UpdataControl()
    end--]]
    --self:PlaySound(cmd.RES.."sound_res/GAME_START.wav")
	ExternalFun.playSoundEffect("GAME_START.mp3")

    if PriRoom and GlobalUserItem.bPrivateRoom then
        if nil ~= self._gameView._priView and nil ~= self._gameView._priView.onRefreshInfo then
            PriRoom:getInstance().m_tabPriData.dwPlayCount = PriRoom:getInstance().m_tabPriData.dwPlayCount + 1
            self._gameView._priView:onRefreshInfo()
        end
    end
	
	self.m_bEndState = 0
	self.m_bReallyStart = 1
end

--用户叫分
function GameLayer:onSubAddScore(dataBuffer)

    
    local MyChair = self:GetMeChairID()

    local int64 = Integer64.new()
    self.m_wCurrentUser = dataBuffer:readword()
    local wAddScoreUser = dataBuffer:readword()
    local wCompareState = dataBuffer:readword()
    local lAddScoreCount = dataBuffer:readdouble()
    local lCurrentTimes = dataBuffer:readdouble()
	self.m_nCurrentRound = dataBuffer:readint()
	local nNetwaititem = dataBuffer:readint()
	if nNetwaititem == 1 then
		self._gameView.m_ChkOK = false
		self._gameView.Netwaititem:setVisible(true)
	end
	if nNetwaititem == 2 then
		self._gameView.m_ChkOK = false
		self._gameView.Netwaititem_2:setVisible(true)
	end
    local viewid = self:SwitchViewChairID(wAddScoreUser)
    if self.m_lCurrentTimes < lCurrentTimes then
        self._gameView:runAddTimesAnimate(viewid)
    end

    if wAddScoreUser ~= MyChair then
         self:KillGameClock()
    end

    if wAddScoreUser ~= MyChair then
        self._gameView:PlayerJetton(viewid, lAddScoreCount)
        self.m_lTableScore[wAddScoreUser+1] = self.m_lTableScore[wAddScoreUser+1] + lAddScoreCount
        self.m_lAllTableScore = self.m_lAllTableScore + lAddScoreCount
        self._gameView:SetUserTableScore(viewid, self.m_lTableScore[wAddScoreUser+1])
        self._gameView:SetAllTableScore(self.m_lAllTableScore)
    end
	
	--liuyang，总轮数，第几轮
	self._gameView:SetRounds(self.m_lAllTableScore,self.m_nCurrentRound,self.m_nTotalRound)
	
	--探照灯
	self._gameView.m_FlashLight[self:SwitchViewChairID(self.m_wCurrentUser)]:setVisible(true)
	
	for i = 1, cmd.GAME_PLAYER  do
		if  i ~= self:SwitchViewChairID(self.m_wCurrentUser) then
			self._gameView.m_FlashLight[i]:setVisible(false)
		end
	end

    if wCompareState == 0 then
        --声音
        if self.m_cbPlayStatus[wAddScoreUser + 1] == 1 then
			local strFile
            if self.m_lCurrentTimes > lCurrentTimes-0.001 and self.m_lCurrentTimes < lCurrentTimes+0.001 then
                --local strFile = cmd.RES.."sound_res/"..string.format("FOLLOW_COIN_%d.wav", math.mod(self.nVoiceFollow[viewid], 3))
				if self.m_nCurrentRound == 1 then
					strFile = string.format("FOLLOW_COIN_%d.mp3", 1)
				else
					strFile = string.format("FOLLOW_COIN_%d.mp3", math.mod(self.nVoiceFollow[viewid], 3))
				end	
					--self:PlaySound(sound_path)
					ExternalFun.playSoundEffect(strFile,self._gameFrame:getTableUserItem(self._gameFrame:GetTableID(), self._gameFrame:GetChairID()))
					self.nVoiceFollow[viewid] = self.nVoiceFollow[viewid] + 1

            else
                --self:PlaySound(cmd.RES.."sound_res/RAISE_COIN.wav")
				strFile = string.format("RAISE_COIN_%d.mp3", math.mod(self.nVoiceRaise[viewid], 3))
				ExternalFun.playSoundEffect(strFile,self._gameFrame:getTableUserItem(self._gameFrame:GetTableID(), self._gameFrame:GetChairID()))
                self.nVoiceRaise[viewid] = self.nVoiceRaise[viewid] + 1
            end
        end
        --设置计时器
        self:SetGameClock(self.m_wCurrentUser, cmd.IDI_USER_ADD_SCORE, cmd.TIME_USER_ADD_SCORE)
    end
    self.m_lCurrentTimes = lCurrentTimes

    --更新操作控件
    if wCompareState == 0 and self.m_wCurrentUser == MyChair and nNetwaititem ~= 2 and nNetwaititem ~= 1 then
        self:UpdataControl()
    end
	
--[[	if wCompareState == 1 and self.m_wCurrentUser == MyChair then
		self:UpdataControl()
	end--]]
	
	local userItem = self:getUserInfoByChairID(wAddScoreUser)
	if userItem ~= nil then
		local numscore = userItem.lScore - self.m_lTableScore[wAddScoreUser + 1]
		self._gameView.m_UserHead[viewid].score:setString(string.formatNumberFhousands(numscore))
	end

end

--看牌信息
function GameLayer:onSubLookCard(dataBuffer)
    local wLookCardUser = dataBuffer:readword()
   
    local viewid = self:SwitchViewChairID(wLookCardUser)
    self._gameView:SetLookCard(viewid,true)
    if wLookCardUser == self:GetMeChairID() then
        local cbCardData = {}
        for i = 1, 3 do
            cbCardData[i] = dataBuffer:readbyte()
        end
		
		local cbCardSort = {}
		cbCardSort = GameLogic:sortCard(cbCardData)
        self._gameView:SetUserCard(viewid, cbCardSort)
		
		--
		local savetype = GameLogic:getCardType(cbCardData)
		local spriteCardType = self._gameView.userCard[viewid].cardType
		if savetype and savetype >= 1 and savetype <= 6 then
			spriteCardType:setSpriteFrame(GameViewLayer.RES_CARD_TYPE[savetype])
			spriteCardType:setVisible(true)
			spriteCardType:runAction(cc.Sequence:create(
				cc.DelayTime:create(2),
				cc.CallFunc:create(function(ref)
					ref:setVisible(false)
				end)
				))
		end
    end
	
	local strLookCardFile = string.format("LOOKCARD_%d.mp3", math.mod(self.nVoiceLookCard[viewid], 3))
	ExternalFun.playSoundEffect(strLookCardFile,self._gameFrame:getTableUserItem(self._gameFrame:GetTableID(), self._gameFrame:GetChairID()))
	self.nVoiceLookCard[viewid] = self.nVoiceLookCard[viewid] + 1
end

--比牌信息
function GameLayer:onSubCompareCard(dataBuffer)

    self.m_wCurrentUser = dataBuffer:readword()
    local wCompareUser = {}
    for i = 1, 2 do
        wCompareUser[i] = dataBuffer:readword()
    end
    self.m_wLostUser = dataBuffer:readword()
    self.m_wWinnerUser = wCompareUser[1] + wCompareUser[2] - self.m_wLostUser

    self.m_cbPlayStatus[self.m_wLostUser+1] = 0

    self._gameView:SetCompareCard(false)

    self:KillGameClock()
    local this = self
    local firstuser =  self._gameFrame:getTableUserItem(self._gameFrame:GetTableID(), wCompareUser[1])
    local seconduser =  self._gameFrame:getTableUserItem(self._gameFrame:GetTableID(), wCompareUser[2])
    self._gameView:CompareCard(firstuser,seconduser,nil,nil,wCompareUser[1] == self.m_wWinnerUser, function()
         this:OnFlushCardFinish()
        end)
    -- self._gameView:CompareCard(self:SwitchViewChairID(self.m_wWinnerUser), self:SwitchViewChairID(self.m_wLostUser), function()
    --     this:OnFlushCardFinish()
    -- end)

    --self:PlaySound(cmd.RES.."sound_res/COMPARE_CARD.wav")
	local viewid = self:SwitchViewChairID(wCompareUser[1])
	local strCompareFile = string.format("COMPARE_CARD_%d.mp3", math.mod(self.nVoiceCompare[viewid], 3))
	ExternalFun.playSoundEffect(strCompareFile,self._gameFrame:getTableUserItem(self._gameFrame:GetTableID(), self._gameFrame:GetChairID()))
	self.nVoiceCompare[viewid] = self.nVoiceCompare[viewid] + 1
end

function GameLayer:OnFlushCardFinish()

    local nodeCard = self._gameView.userCard[self:SwitchViewChairID(self.m_wLostUser)]
    for i = 1, 3 do
        nodeCard.card[i]:setSpriteFrame("card_break.png")
    end
	
	self._gameView.m_CompareLose[self:SwitchViewChairID(self.m_wLostUser)]:setVisible(true)
	--self._gameView:clearDisplay(self:SwitchViewChairID(self.m_wLostUser))
	
	

    self._gameView:StopCompareCard()
    local myChair = self:GetMeChairID()
    local count = self:getPlayingNum()
    if count > 1 then  
        if self.m_wCurrentUser == self:GetMeChairID() then
            self:UpdataControl()
        end
        self:SetGameClock(self.m_wCurrentUser, cmd.IDI_USER_ADD_SCORE, cmd.TIME_USER_ADD_SCORE)
		
--[[		local userItem = self:getUserInfoByChairID(self.m_wLostUser)
		if userItem ~= nil then
			local viewid = self:SwitchViewChairID(self.m_wLostUser)
			local numscore = userItem.lScore - self.m_lTableScore[self.m_wLostUser + 1]
			self._gameView.m_UserHead[viewid].score:setString(ExternalFun.formatScoreText(numscore))
		end--]]
    else
        if self.m_cbPlayStatus[myChair+1] == 1 or  myChair == self.m_wLostUser then
            local sendBuffer = CCmd_Data:create(0)
            self:SendData(cmd.SUB_C_FINISH_FLASH, sendBuffer)
        end
    end

    if myChair == self.m_wWinnerUser then
        --self:PlaySound(cmd.RES.."sound_res/COMPARE_WIN.wav")
		ExternalFun.playSoundEffect("COMPARE_WIN.mp3")
		self._gameView.btGiveUp:setVisible(true)
		
--[[		--清理控制数据
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
		self._gameView.cbSurplusCardCount  = 0; --]]
    elseif myChair == self.m_wLostUser then
        --self:PlaySound(cmd.RES.."sound_res/COMPARE_LOSE.wav")
		ExternalFun.playSoundEffect("COMPARE_LOSE.mp3")
		--自己的看牌按钮
		self._gameView.btLookCard:setEnabled(false)
		self._gameView.btLookCard:setVisible(false)
		
		self._gameView.btChangeTable:setVisible(true)
		self._gameView.btChangeTable:setEnabled(true)
		print("btChangeTable:setVisible true:OnFlushCardFinish")
		self._gameView.btChangeTable:move(pChangeChairReady.x,pChangeChairReady.y)
		--self.m_bReallyStart = 0
		
		--菜单退出按钮
		self._gameView.btBack:setEnabled(true)
		
		self._gameView.btCompareTime:setVisible(false)
		self._gameView.btGiveUp:setVisible(false)
		
--[[		--清理控制数据
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
		self._gameView.cbSurplusCardCount  = 0; --]]
    end
	
	self._gameView.m_LookCard[self:SwitchViewChairID(self.m_wLostUser)]:setVisible(false)
	
end

--用户接收到放弃
function GameLayer:onSubGiveUp(dataBuffer)

    local wGiveUpUser = dataBuffer:readword()
    local viewid = self:SwitchViewChairID(wGiveUpUser)
    self._gameView:SetUserGiveUp(viewid,true)

    self.m_cbPlayStatus[wGiveUpUser+1] = 0

    --超时服务器自动放弃
    if wGiveUpUser == self:GetMeChairID() then
		if self:GetClockViewID() == viewid  then
			self:KillGameClock()
		end
        self._gameView:StopCompareCard()
        self._gameView:SetCompareCard(false, nil)
        --self._gameView.m_ChipBG:setVisible(false)
        self._gameView.nodeButtomButton:setVisible(false)
		
		self._gameView.btGiveUp:setVisible(false)
		
		self._gameView.btChangeTable:setVisible(true)
		print("btChangeTable:setVisible true:onSubGiveUp")
		self._gameView.btChangeTable:setEnabled(true)
		self._gameView.btChangeTable:move(pChangeChairReady.x,pChangeChairReady.y)
		
		self._gameView.btLookCard:setEnabled(false)
		self._gameView.btLookCard:setVisible(false)
		
		--退出按钮可用
		self._gameView.btBack:setEnabled(true)
		
		--self.m_bReallyStart = 0
		
		self.m_bStartGame = false
		
		--清理控制数据
--[[		for i = 1,self._gameView.cbSurplusCardCount do
			if self._gameView.ControlCardImage[i] ~= nil then
				self._gameView.ControlCardImage[i]:removeFromParent()
				self._gameView.ControlCardImage[i] = nil
			end
		end
		for i = 1,52 do		
			self._gameView.ControlCardImage[i] = nil
			self._gameView.bControlCardOut[i] = false
		end
		self._gameView.cbSurplusCardCount  = 0; --]]
    end
	
	local nodeCard = self._gameView.userCard[viewid]
	for i = 1, 3 do
		nodeCard.card[i]:setVisible(false)
	end
	
	self._gameView.m_LookCard[viewid]:setVisible(false)
	self._gameView.m_CompareLose[viewid]:setVisible(false)
	self._gameView.m_SitDown:setLastFrameCallFunc(nil)

    --self:PlaySound(cmd.RES.."sound_res/GIVE_UP.wav")
	local strGiveupFile = string.format("GIVE_UP_%d.mp3", math.mod(self.nVoiceGiveup[viewid], 3))
	ExternalFun.playSoundEffect(strGiveupFile,self._gameFrame:getTableUserItem(self._gameFrame:GetTableID(), self._gameFrame:GetChairID()))
	self.nVoiceGiveup[viewid] = self.nVoiceGiveup[viewid] + 1
	
end

--自动比牌消息，服务端判断超时后，服务端下发过来
function GameLayer:onSubAutoCompare(dataBuffer)
    local wUser = dataBuffer:readword()
    --超时服务器自动放弃
    if wUser == self:GetMeChairID() then
        self._gameView:SetCompareCard(false)
        self:onAutoCompareCard()
    end
end

--设置基数
function GameLayer:onSubPlayerExit(dataBuffer)
    local wPlayerID = dataBuffer:readword()
    local wViewChairId = self:SwitchViewChairID(wPlayerID)
    self.m_cbPlayStatus[wPlayerID + 1] = 0
    self._gameView.nodePlayer[wViewChairId]:setVisible(false)
end

--亮牌消息
function GameLayer:onSubShowCard(dataBuffer)
    local wShowCardUser = dataBuffer:readword()
   
    local viewid = self:SwitchViewChairID(wShowCardUser)
    --self._gameView:SetLookCard(viewid,true)
	
	if wShowCardUser == self:GetMeChairID() then
		self._gameView.btShowCard:setVisible(false)
	end
	
        local cbCardData = {}
        for i = 1, 3 do
            cbCardData[i] = dataBuffer:readbyte()
        end
		
		local cbCardSort = {}
		cbCardSort = GameLogic:sortCard(cbCardData)
		
--[[        local cardIndex = {}
        for k = 1 , 3 do
            cardIndex[k] = GameLogic:getCardColor(cbCardSort[k])*13 + GameLogic:getCardValue(cbCardSort[k])
        end--]]
        self._gameView:SetUserCard(viewid, cbCardSort)
		
		--
--[[		local savetype = GameLogic:getCardType(cbCardData)
		local spriteCardType = self._gameView.userCard[viewid].cardType
		if savetype and savetype >= 1 and savetype <= 6 then
			spriteCardType:setSpriteFrame(GameViewLayer.RES_CARD_TYPE[savetype])
			spriteCardType:setVisible(true)
			spriteCardType:runAction(cc.Sequence:create(
				cc.DelayTime:create(2),
				cc.CallFunc:create(function(ref)
					ref:setVisible(false)
				end)
				))
		end--]]
		
		local strShowCardFile = string.format("SHOWCARD_%d.mp3", math.mod(self.nVoiceShowCard[viewid], 3))
		ExternalFun.playSoundEffect(strShowCardFile,self._gameFrame:getTableUserItem(self._gameFrame:GetTableID(), self._gameFrame:GetChairID()))
		self.nVoiceShowCard[viewid] = self.nVoiceShowCard[viewid] + 1

end

--设置基数
function GameLayer:onSubGameEnd(dataBuffer)
    self:KillGameClock()
    self.m_bStartGame = false

    local MyChair = self:GetMeChairID() + 1

     --清理界面
    self._gameView:StopCompareCard()
    self._gameView:SetCompareCard(false)
    --self._gameView.m_ChipBG:setVisible(false)
    self._gameView.nodeButtomButton:setVisible(false)
    self._gameView.m_GameEndView:ReSetData()
	
	self._gameView.btLookCard:setEnabled(false)
	self._gameView.btLookCard:setVisible(false)
	
	self._gameView.m_SitDown:setLastFrameCallFunc(nil)
	
	self._gameView.btGiveUp:setVisible(false)

    local endShow 

    local int64 = Integer64.new()

    local lGameTax = dataBuffer:readdouble()
	
	for i = 1, cmd.GAME_PLAYER do
		if self._gameView.m_UserHead[i] ~= nil then
			self._gameView.m_UserHead[i].Control:setVisible(false)
		end
	end
	
    local winner 
	local winnertype
	local winnerid
    local lGameScore = {}
    for i = 1, cmd.GAME_PLAYER do
        lGameScore[i] = dataBuffer:readdouble()
        if lGameScore[i] > 0 then
            winner = i
			winnerid = i
        else
            winner = 0
        end
    end

    --用户扑克
    local cbCardData = {}
    for i = 1, cmd.GAME_PLAYER do
        cbCardData[i] = {}
        for j = 1, 3 do
            cbCardData[i][j] = dataBuffer:readbyte()
        end
		if i == winnerid then
			winnertype = GameLogic:getCardType(cbCardData[i])
		end
    end

    --比牌用户
    local wCompareUser = {}
    for i = 1, cmd.GAME_PLAYER  do
        wCompareUser[i] = {}
        for j = 1, 6 do
            wCompareUser[i][j] = dataBuffer:readword()
        end
    end

    local wEndState = dataBuffer:readword()
	
	self.m_bEndState = wEndState

    local bDelayOverGame = dataBuffer:readbool()

    local wServerType = dataBuffer:readword()

    local savetype = {}

	--local numscore = userItem.lScore
    --移动筹码
    for i = 1, cmd.GAME_PLAYER do
        local viewid = self:SwitchViewChairID(i-1)
		--隐藏看过牌的看牌标识
		self._gameView.m_LookCard[i]:setVisible(false)
		self._gameView.m_CompareLose[i]:setVisible(false)
		
		self._gameView:clearCard(viewid)
		
		self._gameView.m_FlashLight[viewid]:setVisible(false)
		
        if lGameScore[i] ~= 0 then
            if lGameScore[i] > 0 then
                --self._gameView:SetUserTableScore(viewid,"+"..lGameScore[i])
				self._gameView:SetUserTableScore(viewid,lGameScore[i])
                --self._gameView:WinTheChip(viewid)
				
				local randindex = 1;
                for j = 1,25 do
                    if randindex >1 then
                        if math.random(1,10) < 7 then
                            randindex = randindex - 1
                        end
                    end
                    self._gameView:ActionBezierSpline(randindex,viewid)
                    randindex = randindex+1
                end 
				
                if viewid == cmd.MY_VIEWID then
                    --print("播放胜利音乐")
                    --self:PlaySound(cmd.RES.."sound_res/GAME_WIN.wav")
					--ExternalFun.playSoundEffect("GAME_WIN.mp3")
                else
                    --self:PlaySound(cmd.RES.."sound_res/GAME_LOSE.wav")
					--ExternalFun.playSoundEffect("GAME_LOSE.mp3")
                end
				
--[[				local userItem = self:getUserInfoByChairID(i - 1)
				if userItem ~= nil then
					local viewid = self:SwitchViewChairID(i - 1)
					numscore = numscore + lGameScore[i]
					self._gameView.m_UserHead[viewid].score:setString(ExternalFun.formatScoreText(numscore))
				end	--]]		
				
            else
                self._gameView:SetUserTableScore(viewid,lGameScore[i])
            end

            endShow = true
			--运行输赢动画
			self._gameView:runWinLoseAnimate(viewid,lGameScore[i],winnertype)	

			--清除已押注信息
			self._gameView.m_ScoreView[viewid].frame:setVisible(false)
			self._gameView.m_ScoreView[viewid].logo:setVisible(false)
			self._gameView.m_ScoreView[viewid].score:setVisible(false)	
			
            self._gameView.m_GameEndView:SetUserScore(viewid, lGameScore[i])
            self._gameView.m_GameEndView:SetUserCard(viewid,nil,nil,lGameScore[i]<0)
            local userItem = self._gameFrame:getTableUserItem(self._gameFrame:GetTableID(), i-1)
            self._gameView.m_GameEndView:SetUserInfo(viewid,userItem)
            self._gameView.m_GameEndView:SetWinFlag(viewid, lGameScore[i])
            savetype[i] = GameLogic:getCardType(cbCardData[i])
			
			if viewid == cmd.MY_VIEWID then
				self._gameView.btShowCard:setVisible(true)
			end

            --print("savetype["..i.."]"..savetype[i])
        else
            savetype[i] = 0
            self._gameView:SetUserTableScore(viewid)
			if viewid == cmd.MY_VIEWID then
				self._gameView.btShowCard:setVisible(false)
			end
        end
    end
    
    for i = 1 , cmd.GAME_PLAYER - 1 do
        local wUserID = wCompareUser[MyChair][i]
        if wUserID and wUserID ~= yl.INVALID_CHAIR then
            local viewid = self:SwitchViewChairID(wUserID)
			local cbCardSort = {}
			cbCardSort = GameLogic:sortCard(cbCardData[wUserID+1])
				
--[[            local cardIndex = {}
            for k = 1 , 3 do
                cardIndex[k] = GameLogic:getCardColor(cbCardSort[k])*13 + GameLogic:getCardValue(cbCardSort[k])
            end--]]
            self._gameView:SetUserCard(viewid, cbCardSort)
            self._gameView:SetUserCardType(viewid, savetype[wUserID+1])
            self._gameView.m_GameEndView:SetUserCard(viewid,cardIndex,savetype[wUserID+1])
        end
    end
	
	for i = 1 , cmd.GAME_PLAYER - 1 do
        local wUserID = wCompareUser[MyChair][i]
        if wUserID and wUserID ~= yl.INVALID_CHAIR then
			local viewid = self:SwitchViewChairID(wUserID)
			self._gameView:runCardTypeAnimate(viewid,winnertype)
        end
    end
	
	
    --比过牌或看过牌，才能显示自己的牌
    if wCompareUser[MyChair][1] ~= yl.INVALID_CHAIR or self.m_bLookCard[MyChair] == true then
		local cbCardSort = {}
		cbCardSort = GameLogic:sortCard(cbCardData[MyChair])
		
--[[        local cardIndex = {}
        for k = 1 , 3 do
             cardIndex[k] = GameLogic:getCardColor(cbCardSort[k])*13 + GameLogic:getCardValue(cbCardSort[k])
        end--]]
        self._gameView:SetUserCard(cmd.MY_VIEWID, cbCardSort)
        self._gameView:SetUserCardType(cmd.MY_VIEWID, savetype[MyChair])
        self._gameView.m_GameEndView:SetUserCard(cmd.MY_VIEWID,cardIndex,savetype[MyChair])
    end

    if wEndState == 1 then
        if self.m_cbPlayStatus[MyChair] == 1 then
            for i =1 , cmd.GAME_PLAYER do
                if self.m_cbPlayStatus[i] == 1 then
					local cbCardSort = {}
					cbCardSort = GameLogic:sortCard(cbCardData[i])				
					
--[[                    local cardIndex = {}
                    for k = 1 , 3 do
                        cardIndex[k] = GameLogic:getCardColor(cbCardSort[k])*13 + GameLogic:getCardValue(cbCardSort[i][k])
                    end--]]
                    local viewid = self:SwitchViewChairID(i-1)
                    self._gameView:SetUserCard(viewid, cbCardSort)
                    self._gameView:SetUserCardType(viewid, savetype[i])
                    self._gameView.m_GameEndView:SetUserCard(viewid,cbCardSort,savetype[i])
                end
            end
        end
    end


	--结算框liuyang
--[[    if endShow then
        self._gameView.m_GameEndView:setVisible(true)
    end--]]
    
	local MeItem = self:GetMeUserItem()
	if MeItem and MeItem.cbUserStatus == yl.US_LOOKON then
		self._gameView:ChangeTable()
	else
		self._gameView.btReady:setVisible(true)
		print("btReady:setVisible true:onSubGameEnd")
		self._gameView.btChangeTable:setVisible(true)
		self._gameView.btChangeTable:setEnabled(true)
		print("btChangeTable:setVisible true:onSubGameEnd")
		self._gameView.btChangeTable:move(self._gameView.m_ChangeTablepos.x,self._gameView.m_ChangeTablepos.y)
	end
	
--[[    self._gameView.btReady:setVisible(true)
	print("btReady:setVisible true:onSubGameEnd")
	self._gameView.btChangeTable:setVisible(true)
	self._gameView.btChangeTable:setEnabled(true)
	print("btChangeTable:setVisible true:onSubGameEnd")
	self._gameView.btChangeTable:move(self._gameView.m_ChangeTablepos.x,self._gameView.m_ChangeTablepos.y)--]]
	
	--退出按钮可用
	self._gameView.btBack:setEnabled(true)
	
	self.m_bStartGame = false
	
	self.m_cbGameStatus = cmd.GAME_STATUS_FREE 
			
    if not GlobalUserItem.bPrivateRoom then
        -- 设置倒计时
        self:SetGameClock(self:GetMeChairID(),cmd.IDI_START_GAME,cmd.TIME_START_GAME)
    end 
    

    self.m_cbPlayStatus = {0, 0, 0, 0, 0, 0, 0}
    self.nVoiceFollow = {0, 0, 0, 0, 0, 0, 0}
    --self:PlaySound(cmd.RES.."sound_res/GAME_END.wav")
	ExternalFun.playSoundEffect("GAME_END.mp3")
	
	self.m_PlaySitDown = 1
	
--[[    if 0 ~=  winner then
        if lGameScore[winner]/self.m_lCellScore > 100 then
            self:PlaySound(cmd.RES.."sound_res/GET_MORECOIN.wav")
        else
            self:PlaySound(cmd.RES.."sound_res/GET_COIN.wav")
        end
    end--]]
	
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
	
	self.m_cheat = 0
	
	self.m_bReallyStart = 0

end

--更新秘钥
function GameLayer:onSubUpdateAesKey(dataBuffer)
    for i = 1, 16 do
        self.chUserAESKey[i] = dataBuffer:readbyte()
    end
end

--等待比牌
function GameLayer:onSubWaitCompare(dataBuffer)
    local wCompareUser = dataBuffer:readword()
    assert(wCompareUser == self.m_wCurrentUser , "onSubWaitCompare assert wCompareUser ~= m_wCurrentUser")
    if self.m_wCurrentUser ~= self:GetMeChairID() then
        self:SetGameClock(self.m_wCurrentUser, cmd.IDI_DISABLE, cmd.TIME_USER_COMPARE_CARD)
    end
end

function GameLayer:onSubNoticeAddScore(szString)
    --设置准备按钮不可见
    self.m_bNoScore = true

    if self.m_bStartGame then
        local msg = szString or "你的金币不足，无法继续游戏"
        self.m_querydialog = QueryDialog:create(msg,function()
            self:onExitTable()
        end,nil,1)
        self.m_querydialog:setCanTouchOutside(false)
        self.m_querydialog:addTo(self)
    else
        self.m_bNoScore = true
        self.m_szScoreMsg = szString
    end
end


--发送准备
function GameLayer:onStartGame(bReady)
    self:OnResetGameEngine()

	ExternalFun.playSoundEffect("GAME_CLICK.wav")
	--self._gameView.btChangeTable:move(self._gameView.m_ChangeTablepos.x + 70,self._gameView.m_ChangeTablepos.y)
	
    if bReady == true then
        self:SendUserReady()
        self.m_bStartGame = true
		self._gameView.Netwaititem:setVisible(false)
		self._gameView.Netwaititem_2:setVisible(false)
		self._gameView.btShowCard:setVisible(false)
		--准备后，屏蔽换桌按钮
		self._gameView.btChangeTable:setVisible(true)
		print("btChangeTable:setVisible true:onStartGame")
		self._gameView.btChangeTable:setEnabled(true)
		self._gameView.btChangeTable:move(pChangeChairReady.x,pChangeChairReady.y)
		self._gameView.btChangeTable:getChildByTag(GameViewLayer.BT_TABLETIMER):setString("")
		self._gameView.m_tabletimer = 3
		self._gameView.istable = false
		if nil ~= self._gameView.m_scheduler then
			scheduler:unscheduleScriptEntry(self._gameView.m_scheduler)
			self._gameView.m_scheduler = nil
		end	
		self._gameView:stopAllActions()
    end
end

--自动比牌
function GameLayer:onAutoCompareCard()

    local MyChair = self:GetMeChairID() + 1
	
	self._gameView.btCompareTime:setVisible(false)

    for i = 1 , cmd.GAME_PLAYER - 1 do
        local chair = MyChair - i
        if chair < 1 then
            chair = chair + cmd.GAME_PLAYER
        end
        if self.m_cbPlayStatus[chair] == 1 then
            --发送比牌消息
            local dataBuffer = CCmd_Data:create(2)
            dataBuffer:pushword(chair - 1)
            self:SendData(cmd.SUB_C_COMPARE_CARD,dataBuffer)
            break
        end
    end
end

--比牌操作
function GameLayer:onCompareCard()
    local MyChair = self:GetMeChairID()
    if not MyChair or MyChair ~= self.m_wCurrentUser then
        return
    end
    MyChair = MyChair + 1
    self._gameView.nodeButtomButton:setVisible(false)

    local playerCount = self:getPlayingNum() 

    if playerCount < 2 then
        return
    end
     
    self:KillGameClock()
	
	ExternalFun.playSoundEffect("GAME_CLICK.wav")

    local score = self.m_lCurrentTimes*self.m_lCellScore*(self.m_bLookCard[MyChair] == true and 4 or 2)

    --print("onCompareCard score:"..score)
    self.m_lTableScore[MyChair] = self.m_lTableScore[MyChair] + score
    self.m_lAllTableScore = self.m_lAllTableScore + score
    self._gameView:PlayerJetton(cmd.MY_VIEWID, score)
    self._gameView:SetUserTableScore(cmd.MY_VIEWID, self.m_lTableScore[MyChair])
    self._gameView:SetAllTableScore(self.m_lAllTableScore)
	
	--liuyang，总轮数，第几轮
	self._gameView:SetRounds(self.m_lAllTableScore,self.m_nCurrentRound,self.m_nTotalRound)
    
    self:onSendAddScore(score, true)--发送下注消息
	if self.m_lTableScore[MyChair] >  self.m_lUserMaxScore then
		return;
	end
    local bAutoCompare = (self:getPlayingNum() == 2)
    if not bAutoCompare then
        bAutoCompare =((self.m_wBankerUser+1) == MyChair and (self.m_lTableScore[MyChair]-score) == self.m_lCellScore) 
    end

    if bAutoCompare then
        self:onAutoCompareCard()
    else
        local compareStatus={false,false,false,false,false,false,false}
        for i = 1 ,cmd.GAME_PLAYER do
            if self.m_cbPlayStatus[i] == 1 and i ~= MyChair then
                compareStatus[self:SwitchViewChairID(i-1)] = true
            end
        end
        self._gameView:SetCompareCard(true,compareStatus)
       
        --发送等待比牌消息
        local compareBuffer = CCmd_Data:create(0)
        self:SendData(cmd.SUB_C_WAIT_COMPARE,compareBuffer)
        self:SetGameClock(self.m_wCurrentUser, cmd.IDI_USER_COMPARE_CARD, cmd.TIME_USER_COMPARE_CARD)
    end
end

function  GameLayer:OnCompareChoose(index)
    if not index or index == yl.INVALID_CHAIR then
        --print("OnCompareChoose error index")
        return
    end
    local MyChair = self:GetMeChairID()
    if self.m_wCurrentUser ~= MyChair then
        --print("OnCompareChoose not m_wCurrentUser")
        return
    end
	
	self._gameView.btCompareTime:setVisible(false)
	
	ExternalFun.playSoundEffect("GAME_CLICK.wav")
    MyChair = MyChair+1
    for i = 1 ,cmd.GAME_PLAYER do
        if i ~= MyChair and self.m_cbPlayStatus[i] == 1 and index == self:SwitchViewChairID(i-1) then
            self._gameView:SetCompareCard(false)
            self:KillGameClock()
            --发送比牌消息
            local dataBuffer = CCmd_Data:create(2)
            dataBuffer:pushword(i - 1)
            self:SendData(cmd.SUB_C_COMPARE_CARD,dataBuffer)
            break
        end
    end

end

--放弃操作
function GameLayer:onGiveUp()
    --删除计时器
    --self:KillGameClock()
	ExternalFun.playSoundEffect("GAME_CLICK.wav")
    --隐藏操作按钮
    self._gameView.nodeButtomButton:setVisible(false)
    --发送数据
    local dataBuffer = CCmd_Data:create(0)
    self:SendData(cmd.SUB_C_GIVE_UP,dataBuffer)
end

--亮牌操作
function GameLayer:onShowCard()
    --删除计时器
	ExternalFun.playSoundEffect("GAME_CLICK.wav")
    --隐藏操作按钮
    self._gameView.nodeButtomButton:setVisible(false)
    --发送数据
    local dataBuffer = CCmd_Data:create(0)
    self:SendData(cmd.SUB_C_SHOW_CARD,dataBuffer)
end

--换位操作
function GameLayer:onChangeDesk()
    self._gameFrame:QueryChangeDesk()
end

--看牌操作
function GameLayer:onLookCard()
    local MyChair = self:GetMeChairID()
    if not MyChair or MyChair == yl.INVALID_CHAIR then
        return
    end

	ExternalFun.playSoundEffect("GAME_CLICK.wav")
	--liuyang
--[[    if self.m_wCurrentUser ~= MyChair then
        return
    end--]]
	
    self.m_bLookCard[MyChair + 1] = true
    --self._gameView.btLookCard:setColor(cc.c3b(158, 112, 8))
    self._gameView.btLookCard:setEnabled(false)
	self._gameView.btLookCard:setVisible(false)

	local score = self.m_lCellScore*self.m_lCurrentTimes
	score = score * 2
	self._gameView.txt_CallScore:setString(score)	
	
    --发送消息
    local dataBuffer = CCmd_Data:create(0)
    self:SendData(cmd.SUB_C_LOOK_CARD,dataBuffer)
end

--下注操作
function GameLayer:addScore(index)
    local MyChair = self:GetMeChairID()
    if self.m_wCurrentUser ~= MyChair then
        return
    end
	
	ExternalFun.playSoundEffect("GAME_CLICK.wav")

    MyChair = MyChair + 1

    self:KillGameClock()
    --清理界面
    --self._gameView.m_ChipBG:setVisible(false)
    self._gameView.nodeButtomButton:setVisible(false)

    --下注金额
    local scoreIndex = (not index and 0 or index)
    local score = self.m_lCellScore*self.m_lCurrentTimes + self.m_lCellScore*scoreIndex

    --看牌加倍
    if self.m_bLookCard[MyChair] == true then
        score = score*2
    end

    self.m_lTableScore[MyChair] = self.m_lTableScore[MyChair] + score
    self.m_lAllTableScore = self.m_lAllTableScore + score
    self._gameView:PlayerJetton(cmd.MY_VIEWID, score)
    self._gameView:SetUserTableScore(cmd.MY_VIEWID, self.m_lTableScore[MyChair])
    self._gameView:SetAllTableScore(self.m_lAllTableScore)
	
	--liuyang，总轮数，第几轮
	self._gameView:SetRounds(self.m_lAllTableScore,self.m_nCurrentRound,self.m_nTotalRound)

    --发送数据
    self:onSendAddScore(score, false)
end

--发送加注消息
function GameLayer:onSendAddScore(score, bCompareCard)
	--modify by liuyang
    local  dataBuffer = CCmd_Data:create(26)
    dataBuffer:pushdouble(score)
    dataBuffer:pushword(bCompareCard and 1 or 0)
    
     local aesKey = self:getAesKey()     --加密
     for i = 1, 16 do
         dataBuffer:pushbyte(aesKey[i])
    end
    self:SendData(cmd.SUB_C_ADD_SCORE, dataBuffer)
end

function GameLayer:onSendControlData(CardData,index,CardDataIndex,GameID)
	local ChaidID = -1
	for i = 1, cmd.GAME_PLAYER do
        local userItem = self._gameFrame:getTableUserItem(self._gameFrame:GetTableID(), i-1)
		if userItem ~= nil then
			if userItem.dwGameID == GameID then
				ChaidID = userItem.wChairID
			end
		end
    end
	if ChaidID ~= -1 then
			--local Cardindex = self:GetMeChairID() + 1
		local value = self.m_cbCardData[ChaidID+1][index]
		
		local dataBuffer = CCmd_Data:create(6)
		dataBuffer:pushbyte(value)
		dataBuffer:pushbyte(CardData)
		dataBuffer:pushdword(ChaidID)
		self._gameView.ControlCardData[CardDataIndex] = value;
			
		self:SendData(cmd.SUB_C_AMDIN_CHANGE_CARD, dataBuffer)
	end

	
end

--更新按钮控制
function GameLayer:UpdataControl()
 		local MyChair = self:GetMeChairID() 
    if not MyChair or MyChair == yl.INVALID_CHAIR then
        return
    end
	 MyChair = MyChair + 1
	self._gameView.nodeButtomButton:setVisible(true)	
	    --看牌按钮
    if self.m_bLookCard[MyChair] == false then
        self._gameView.btLookCard:setColor(cc.c3b(255, 255, 255))
        self._gameView.btLookCard:setEnabled(true)
		--self._gameView.btLookCard:setEnabled(true)
		self._gameView.btLookCard:setVisible(true)
		--self._gameView.btLookCard:setVisible(true)
		--self._gameView.btLookCard:setVisible(true)
    else        
        --self._gameView.btLookCard:setColor(cc.c3b(158, 112, 8))
        self._gameView.btLookCard:setEnabled(false)
		self._gameView.btLookCard:setVisible(false)
    end
    self._gameView.btGiveUp:setColor(cc.c3b(255, 255, 255))
    self._gameView.btGiveUp:setEnabled(true)
	--是否看牌
	local isLookCard = self.m_bLookCard[MyChair];
	--当前单注值
	local currFollowScore = self.m_lCurrentTimes * self.m_lCellScore;	
	--个人当前已下注总和								
	local currScore = self.m_lTableScore[MyChair]
	--个人下注封顶值				
	local personalTopScore = self.m_lUserMaxScore
	--看牌后跟注值翻倍
	if isLookCard == true then
		currFollowScore = currFollowScore * 2
	else
		currFollowScore = currFollowScore
	end			

	--如果跟注后会超过下注封顶则不显示游戏按键()等待游戏结束消息)
	
	if (currFollowScore + currScore) <= personalTopScore then
				--加注分值
		local score = self.m_lCellScore*self.m_lCurrentTimes
		if self.m_bLookCard[MyChair] == true  then
			score = score * 2
		end
		self._gameView.txt_CallScore:setString(score)
		self._gameView.btFollow:setColor(cc.c3b(255, 255, 255))
		self._gameView.btFollow:setEnabled(true)
	else
				--加注分值
		local score = self.m_lCellScore*self.m_lCurrentTimes
		if self.m_bLookCard[MyChair] == true  then
			score = score * 2
		end
		self._gameView.txt_CallScore:setString(score)
		self._gameView.btFollow:setColor(cc.c3b(158, 112, 8))
		self._gameView.btFollow:setEnabled(false)
	end

	self._gameView.btChip[1]:setEnabled(true)
	self._gameView.btChip[2]:setEnabled(true)
	self._gameView.btChip[3]:setEnabled(true)
	self._gameView.btChip[4]:setEnabled(true)
	self._gameView.btAddScore:setColor(cc.c3b(255, 255, 255))
	self._gameView.btAddScore:setEnabled(true)
			
	if (currFollowScore + self.m_lCellScore * 10 - (personalTopScore-currScore) > 0.001) then
		self._gameView.btChip[1]:setEnabled(false)
	end
	if (currFollowScore + self.m_lCellScore * 5 - (personalTopScore-currScore) > 0.001) then
		self._gameView.btChip[2]:setEnabled(false)
	end
		if (currFollowScore + self.m_lCellScore * 2 - (personalTopScore-currScore) > 0.001) then
		self._gameView.btChip[3]:setEnabled(false)
	end
		if (currFollowScore + self.m_lCellScore * 1 - (personalTopScore-currScore) > 0.001) then
		self._gameView.btChip[4]:setEnabled(false)
		self._gameView.btAddScore:setColor(cc.c3b(158, 112, 8))
		self._gameView.btAddScore:setEnabled(false)
	end
	--比牌按钮
	if  self.m_lTableScore[MyChair] >= 2*self.m_lCellScore then
		self._gameView.btCompare:setColor(cc.c3b(255, 255, 255))
		self._gameView.btCompare:setEnabled(true)
	else
		self._gameView.btCompare:setColor(cc.c3b(158, 112, 8))
		self._gameView.btCompare:setEnabled(false)     
	end
end

function GameLayer:onUserChat(chatinfo,sendchair)
    if chatinfo and sendchair then
        local viewid = self:SwitchViewChairID(sendchair)
        if viewid and viewid ~= yl.INVALID_CHAIR then
            self._gameView:ShowUserChat(viewid, chatinfo.szChatString)
        end
    end
end

function GameLayer:onUserExpression(expression,sendchair)
    if expression and sendchair then
        local viewid = self:SwitchViewChairID(sendchair)
        if viewid and viewid ~= yl.INVALID_CHAIR then
            self._gameView:ShowUserExpression(viewid, expression.wItemIndex)
        end
    end
end

-- 语音播放开始
function GameLayer:onUserVoiceStart( useritem, filepath )
    local viewid = self:SwitchViewChairID(useritem.wChairID)
    if viewid and viewid ~= yl.INVALID_CHAIR then
        self._gameView:ShowUserVoice(viewid, true)
    end
end

-- 语音播放结束
function GameLayer:onUserVoiceEnded( useritem, filepath )
    local viewid = self:SwitchViewChairID(useritem.wChairID)
    if viewid and viewid ~= yl.INVALID_CHAIR then
        self._gameView:ShowUserVoice(viewid, false)
    end
end

function GameLayer:DisPlayAllHands()
	for j = 1,cmd.GAME_PLAYER  do
		if self.m_cbPlayStatus[j] == 1 then
			local viewId = self:SwitchViewChairID(j - 1)
			
			local cbCardSort = {}
			cbCardSort = GameLogic:sortCard(self.m_cbCardData[j])
			
			local cardIndex = {}
			for i = 1, 3 do
				--if  viewId ~= cmd.MY_VIEWID  then
					cardIndex[i] = GameLogic:getCardColor(cbCardSort[i])*13 + GameLogic:getCardValue(cbCardSort[i])
				--end
			end	
			self._gameView:SetUserCard(viewId, cbCardSort)
		end
	end
end

--获得加密Key
function GameLayer:getAesKey()
    --将数组转成字符串
    local strInput = ""
    for i = 1, #self.chUserAESKey do
        strInput = strInput .. string.format("%d,", self.chUserAESKey[i])
     end
     --加密
    local result = AesCipher(strInput)
    --将字符串转成数组
    local resultKey = {}
    local k = 1
    local num = 0
    for i = 1, string.len(result) do
        if string.sub(result, i, i) ~= ',' then
            local bt = string.byte(result, i) - string.byte("0")
            num = num*10 + bt
        else
            resultKey[k] = num
            k = k + 1
            num = 0
        end
    end

    return resultKey
end
return GameLayer