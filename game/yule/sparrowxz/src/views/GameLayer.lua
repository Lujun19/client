local GameModel = appdf.req(appdf.CLIENT_SRC.."gamemodel.GameModel")

local GameLayer = class("GameLayer", GameModel)

local cmd = appdf.req(appdf.GAME_SRC.."yule.sparrowxz.src.models.CMD_Game")
local GameLogic = appdf.req(appdf.GAME_SRC.."yule.sparrowxz.src.models.GameLogic")
local GameViewLayer = appdf.req(appdf.GAME_SRC.."yule.sparrowxz.src.views.layer.GameViewLayer")
local ExternalFun =  appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")

local  MAX_TIME_OUT		=		3									--最大超时次数

--------------------------------------------------------------------------
--自己、左、右、上的索引

function GameLayer:ctor(frameEngine, scene)
    GameLayer.super.ctor(self, frameEngine, scene)
    self:initData()
    self.name="sparrowxz"

    self.file = io.open(string.format("c:\\sparrowxz_%s.log",GlobalUserItem.szNickName), "a")
    if self.file==nil then self.file={write=function() end,close=function() end} end
    self.file:write("\n\n\n\n\n")
    self.file:write("GameLayer:ctor  ",os.date(),"\n")

 --    local oriWrite=self.file.write
 --    self.file.write=function(self.file,...)
 --    	local t={...}
 --    	local str=table.concat(t,",")
 --    	str=str.."\n"
 --    	oriWrite(self.file,str)
	-- end
   -- assert(self.file)

end

function GameLayer:CreateView()
    return GameViewLayer:create(self):addTo(self)
end

function GameLayer:getParentNode()
	return self._scene
end

function GameLayer:onExitRoom()
	self.file:close()
    self._gameFrame:onCloseSocket()
    self:stopAllActions()
    self:KillGameClock()
    self:dismissPopWait()
    --self._scene:onChangeShowMode(yl.SCENE_ROOMLIST)
    self._scene:onKeyBack()
    self.m_userRecord = {}
end

--构造函数
function GameLayer:initData()

	self.name="sparrowxz_gamelayer"
	--游戏变量
	self.m_bCheatMode=false
	self.m_wBankerUser=INVALID_CHAIR
	self.m_wCurrentUser=INVALID_CHAIR
	self.m_cbUserAction = 0
	self.m_lSiceCount = 0
	self.m_sparrowUserItem={}


	--托管变量
	self.m_bStustee=false
	self.m_wTimeOutCount =0

	--出牌信息
	self.m_cbOutCardData=0
	self.m_wOutCardUser=INVALID_CHAIR

	self.m_bCallCard={}
	self.tabHupaiInfo={{},{},{},{}}
	self.receivedCards={}
	self.discardCards={}
	self.myChirID = self:GetMeChairID()
	self.bEnd=false
	self.tabCallCard={}
end

function GameLayer:getGameKind()
    return cmd.KIND_ID
end

--重置框架
function GameLayer:OnResetGameEngine()
	GameLayer.super.OnResetGameEngine(self)
    self._gameView:onResetData()
	--游戏变量
	self.m_wBankerUser=INVALID_CHAIR
	self.m_wCurrentUser=INVALID_CHAIR
	self.m_cbUserAction = 0
	self.m_lSiceCount = 0


	--托管变量
	self.m_bTrustee=false
	self.m_wTimeOutCount =0

	--出牌信息
	self.m_cbOutCardData=0
	self.m_wOutCardUser=INVALID_CHAIR

	self.tabHupaiInfo={{},{},{},{}}
	self.myTagCharts={}
	self.outcardUser=yl.INVALID_CHAIR
	self.bEnd=false
	self.tabCallCard={}

	print("GameLayer:OnResetGameEngine()")
	self.bSendcard=false --临时调试用

end

-- 椅子号转视图位置,注意椅子号从0~nChairCount-1,返回的视图位置从1~nChairCount
function GameLayer:SwitchViewChairID(chair)
	print("SwitchViewChairID chair:",chair)
    local viewid = yl.INVALID_CHAIR
    local nChairCount = self._gameFrame:GetChairCount()
    --nChairCount = cmd.GAME_PLAYER
    local myChairID = yl.INVALID_CHAIR
    if self:GetMeChairID() ~= yl.INVALID_CHAIR then
    	myChairID = self:GetMeChairID()
    else
    	myChairID = self.myChirID
    end
 	 print("myChairID:",myChairID)
 	 local right = myChairID -1
 	 right = right < 0 and right + nChairCount or right
 	 local left  = myChairID -3
 	 left = left <0 and left + nChairCount or left
 	 local top = myChairID - 2
 	 top = top <0 and top + nChairCount or top
 	 print("right,top,left:",right,top,left)
 	 print("获取转换后的位置ID nChairCount chair, myChairID, right, top, left",nChairCount, chair, myChairID, right, top, left)
 	 if chair == myChairID then
 	 	return cmd.MY_VIEWID
 	 elseif chair == right then
 	 	return cmd.RIGHT_VIEWID
 	 elseif chair == left then
 	 	return cmd.LEFT_VIEWID
 	 elseif chair == top then
 	 	return cmd.TOP_VIEWID
 	 else
 	 --	assert(false) --SetGameClock时可能成立，传入的为viewId,被当做chairId
 	 end
end

function GameLayer:getMyTagCharts()
	return self.myTagCharts
end


--用户状态
function GameLayer:onEventUserStatus(useritem,newstatus,oldstatus)
	if useritem.dwUserID==GlobalUserItem.dwUserID then
		self.m_MyStatus=useritem.cbUserStatus
	end

    print("change user " .. useritem.wChairID .. "; nick " .. useritem.szNickName)
    if newstatus.cbUserStatus == yl.US_FREE or newstatus.cbUserStatus == yl.US_NULL then

	    if (oldstatus.wTableID ~= self:GetMeUserItem().wTableID) then
	        return
	    end

        if yl.INVALID_CHAIR ==  useritem.wChairID then
        	--print("查找人数",#self._gameView.m_UserItem)
        	for i=1, 4 do
	        	if self._gameView.m_UserItem[i] and self._gameView.m_UserItem[i].dwUserID == useritem.dwUserID then
	        		--print("查找",#self._gameView.m_UserItem, useritem.szNickName, self._gameView.m_UserItem[i].szNickName)
	        		self._gameView:OnUpdateUserExit(i)
	        		self._gameView:showUserState(i, false)
	        	end
        	end
        else
        	local wViewChairId = self:SwitchViewChairID(useritem.wChairID)
        	self._gameView:OnUpdateUserExit(wViewChairId)
        	print("删除", wViewChairId)

        	self._gameView:showUserState(wViewChairId, false)
        end

    else

    	if (newstatus.wTableID ~= self:GetMeUserItem().wTableID) then
	        return
	    end
	    local wViewChairId = self:SwitchViewChairID(useritem.wChairID)
	    if newstatus.cbUserStatus == yl.US_READY then
            self._gameView:showUserState(wViewChairId, true)
        end
        self.m_sparrowUserItem[useritem.wChairID +1] = useritem
        --刷新用户信息
        -- if useritem == self:GetMeUserItem() then
        --     return
        -- end
        --先判断是否是换桌
        -- print("更新新玩家", wViewChairId, useritem.szNickName)
    	self._gameView:OnUpdateUser(wViewChairId, useritem)
    end
end

--用户进入
function GameLayer:onEventUserEnter(tableid,chairid,useritem)

	local i=0
	while i<10 do
		i=i+1
		print("用户进入 beg",tableid,chairid,useritem.szNickName)
	end
  --刷新用户信息
    if useritem == self:GetMeUserItem() or tableid ~= self:GetMeUserItem().wTableID then
        return
    end
    local wViewChairId = self:SwitchViewChairID(useritem.wChairID)
    self.m_sparrowUserItem[useritem.wChairID +1] = useritem
    self._gameView:OnUpdateUser(wViewChairId, useritem)
    i=0
	while i<10 do
		i=i+1
		print("用户进入 end",tableid,chairid,useritem.szNickName)
	end
end

function GameLayer:getUserInfoByChairID(chairId)
	return self.m_sparrowUserItem[chairId]
end

-- 计时器响应
function GameLayer:OnEventGameClockInfo(viewId,time,clockId)
	--指针指向
    self._gameView:OnUpdataClockPointView(viewId)
    --设置转盘时间
    self._gameView:OnUpdataClockTime(time)

	if GlobalUserItem.bPrivateRoom then
    	return
    end
    -- body

    if clockId == cmd.IDI_START_GAME then
    	if viewId~=cmd.MY_VIEWID then return end
		if time <= 0 then
			self._gameFrame:setEnterAntiCheatRoom(false)--退出防作弊，如果有的话
			--self:onExitTable()
		elseif time <= 5 then
    		self:PlaySound(cmd.RES_PATH.."sound/GAME_WARN.wav")
		end
	elseif clockId ==cmd.IDI_CHANGE_CARD then
		if viewId~=cmd.MY_VIEWID then return end
		if time <= 0 then
			local cards=self._gameView._cardLayer:getChangeCards()
			if cards==nil or #cards~=3 or math.ceil(cards[1]/16)~=math.ceil(cards[2]/16)
				or math.ceil(cards[1]/16)~=math.ceil(cards[3]/16) then
				self._gameView._cardLayer:getChangeCardHint()
				cards=self._gameView._cardLayer:getChangeCards()
			end

			assert(cards~=nil)
			print("#cards:",#cards)
			assert(#cards==3)
			if  math.ceil(cards[1]/16)~=math.ceil(cards[2]/16)
				or math.ceil(cards[1]/16)~=math.ceil(cards[3]/16) then
				showToast(self,"非同一花色，换三张算法错误",3)
			end
			print("self:sendChangeCard:",cards[1],cards[2],cards[3])
			self:sendChangeCard(cards)
		end
	elseif clockId ==cmd.IDI_CALL_CARD then
		if viewId~=cmd.MY_VIEWID then return end
		if time <= 0 then
			local kind=self._gameView._cardLayer:getCallCardHint()
			self:sendCallCard(kind)
			self._gameView._cardLayer:setCallcardKind(kind)
		end
    elseif clockId == cmd.IDI_OUT_CARD then
    	if viewId~=cmd.MY_VIEWID then return end
		if time <= 0 then
			assert(viewId==cmd.MY_VIEWID)
			self:sendUserTrustee()
		elseif time <= 5 then
			self:PlaySound(cmd.RES_PATH.."sound/GAME_WARN.wav")
		end
    elseif clockId == cmd.IDI_OPERATE_CARD then
    		if self.bMeOperater==true then
	    		--超时
	    		if time <= 0 then
	    			--放弃，进入托管,隐藏操作按钮
	    			self._gameView:ShowGameBtn(GameLogic.WIK_NULL)
	    			self:sendUserTrustee()
	    			self.bMeOperater=false
	    		elseif time <= 5 then
	    			self:PlaySound(cmd.RES_PATH.."sound/GAME_WARN.wav")
	    		end
	    	else

	    	end
    end
end

--创建网络消息包
local function create_netdata( keyTable )
	local len = 0;
	for i=1,#keyTable do
		local keys = keyTable[i];
		local keyType = string.lower(keys["t"]);

		--todo 数组长度计算
		local keyLen = 0;
		if "byte" == keyType or "bool" == keyType then
			keyLen = 1;
		elseif "score" == keyType or "double" == keyType then
			keyLen = 8;
		elseif "word" == keyType or "short" == keyType then
			keyLen = 2;
		elseif "dword" == keyType or "int" == keyType or "float" == keyType then
			keyLen = 4;
		elseif "string" == keyType then
			keyLen = keys["s"];
		elseif "tchar" == keyType then
			keyLen = keys["s"] * 2
		elseif "ptr" == keyType then
			keyLen = keys["s"]
		else
			print("error keytype ==> ", keyType);
		end

		local multi=0
		local lenTable=keys["l"]
		if lenTable then
			for i=1,#lenTable do
				multi=multi+lenTable[i]
			end
		else
			multi=1
		end

		len = len + keyLen*multi
	end
	print("net len ==> ", len)
	return CCmd_Data:create(len);
end


--创建网络消息包
local function getLenthOfNetData( keyTable )
	local len = 0;
	for i=1,#keyTable do
		local keys = keyTable[i];
		local keyType = string.lower(keys["t"]);

		--todo 数组长度计算
		local keyLen = 0;
		if "byte" == keyType or "bool" == keyType then
			keyLen = 1;
		elseif "score" == keyType or "double" == keyType then
			keyLen = 8;
		elseif "word" == keyType or "short" == keyType then
			keyLen = 2;
		elseif "dword" == keyType or "int" == keyType or "float" == keyType then
			keyLen = 4;
		elseif "string" == keyType then
			keyLen = keys["s"];
		elseif "tchar" == keyType then
			keyLen = keys["s"] * 2
		elseif "ptr" == keyType then
			keyLen = keys["s"]
		elseif "table"==keyType then
			keyLen=getLenthOfNetData(keys["d"])
			print(keyTable["k"],"table len:",keyLen)
		else
			print("error keytype ==> ", keyType);
		end

		local multi=0
		local lenTable=keys["l"]
		if lenTable then
			for i=1,#lenTable do
				multi=multi+lenTable[i]
			end
		else
			multi=1
		end

		len = len + keyLen*multi
	end
	print("net len ==> ", len)
	return len
end

-- --游戏场景

function GameLayer:onEventGameScene(cbGameStatus,dataBuffer)

	 for i = 1, cmd.GAME_PLAYER do
        local userItem = self._gameFrame:getTableUserItem(self._gameFrame:GetTableID(), i-1)
        if nil ~= userItem then
            local wViewChairId = self:SwitchViewChairID(i-1)
            self.m_sparrowUserItem[i] = userItem
            self._gameView:OnUpdateUser(wViewChairId, userItem)
            if userItem.cbUserStatus == yl.US_READY then
        		self._gameView:showUserState(wViewChairId, true)
        	else
        		self._gameView:showUserState(wViewChairId, false)
    		end
            if PriRoom then
                PriRoom:getInstance():onEventUserState(wViewChairId, userItem, false)
            end
        end
    end

    -- 刷新房卡
    if PriRoom and GlobalUserItem.bPrivateRoom then
        if nil ~= self._gameView._priView and nil ~= self._gameView._priView.onRefreshInfo then
            self._gameView._priView:onRefreshInfo()
        end
    end

	if cbGameStatus==cmd.GS_MJ_FREE then

		local pStatusFree = ExternalFun.read_netdata(cmd.CMD_S_StatusFree, dataBuffer)

		--设置数据
		self.m_bCheatMode=pStatusFree.bCheatMode
		self.m_wBankerUser=pStatusFree.wBankerUser
		self._gameView:SetCellScore(pStatusFree.lCellScore)

		self._gameView:setBtnTrustEnabled(false)
		--设置控件

		self._gameView:setShowStartBtn(true)

		self.cbTimeOutCard = pStatusFree.cbTimeOutCard
		self.cbTimeOperateCard = pStatusFree.cbTimeOperateCard
		self.cbTimeStartGame = pStatusFree.cbTimeStartGame
		self.cbTimeWaitEnd = pStatusFree.cbTimeWaitEnd

		--if GlobalUserItem.bPrivateRoom then
			self._gameView:showPlayRule(pStatusFree.bHuanSanZhang,pStatusFree.bHuJiaoZhuanYi)
		--end
		print("pStatusFree.bHuanSanZhang,pStatusFree.bHuJiaoZhuanYi:",pStatusFree.bHuanSanZhang,pStatusFree.bHuJiaoZhuanYi)
		--showToast(self._gameView,pStatusFree.bHuanSanZhang,pStatusFree.bHuanSanZhang..","..pStatusFree.bHuanSanZhang,pStatusFree.bHuJiaoZhuanYi,6)

		if GlobalUserItem.bPrivateRoom then
			self._gameView.userPoint:setVisible(false)
		else
			self:SetGameClock(cmd.MY_VIEWID, cmd.IDI_START_GAME, self.cbTimeStartGame)
		end

		self._gameView:setShowStartBtn(true)

	elseif cbGameStatus==cmd.GS_MJ_CHANGECARD then --换三张状态

		-- showToast(self,"换三张场景",1)
		 assert(self.bSendcard~=true)
		 print(" GS_MJ_CHANGECARD dataBuffer len: ",dataBuffer:getlen())
	     local pStatusChange = ExternalFun.read_netdata(cmd.CMD_S_StatusChangeCard, dataBuffer)

	     local sendcard=nil
	     if pStatusChange.wBankerUser==self:GetMeChairID() then
	     	sendcard=pStatusChange.cbSendCardData
	     end
	     print(" GameLogic.SortCardList(pStatusChange.cbCardData[1],sendcard)")
	     GameLogic.SortCardList(pStatusChange.cbCardData[1],sendcard)

	     self.cbTimeOutCard = pStatusChange.cbTimeOutCard
		self.cbTimeOperateCard = pStatusChange.cbTimeOperateCard
		self.cbTimeStartGame = pStatusChange.cbTimeStartGame
		self.cbTimeWaitEnd = pStatusChange.cbTimeWaitEnd

		self._gameView:setBtnTrustEnabled(false)

		self.m_wBankerUser=pStatusChange.wBankerUser
		local viewCardCount={13,13,13,13}
		viewCardCount[self:SwitchViewChairID(self.m_wBankerUser)]=14
		--手牌
		for i=1,cmd.GAME_PLAYER do
			if i == cmd.MY_VIEWID then
				assert(# pStatusChange.cbCardData[1]==13 or #pStatusChange.cbCardData[1]==14)
				print(#self._gameView._cardLayer.cbCardData[i])
				print("card1",self._gameView._cardLayer.cbCardData[i][1])
				print("card2",self._gameView._cardLayer.cbCardData[i][2])
				print("card2",self._gameView._cardLayer.cbCardData[i][3])
				assert(#self._gameView._cardLayer.cbCardData[i]==0)
				self._gameView._cardLayer:createHandCard(i, pStatusChange.cbCardData[1], viewCardCount[i])
				print(#self._gameView._cardLayer.cbCardData[i])
				assert(#self._gameView._cardLayer.cbCardData[i]==13 or #self._gameView._cardLayer.cbCardData[i]==14)
			else
				self._gameView._cardLayer:createHandCard(i, nil, viewCardCount[i])
			end
		end
	    --self._gameView:updateLeftCard()
	    if not pStatusChange.bChangeCard[1][self:GetMeChairID()+1] then
	    	self._gameView:setShowLabelClock(true)
	    	self._gameView:showChangCardHint(true)
	    	self:SetGameClock(cmd.MY_VIEWID,cmd.IDI_CHANGE_CARD,5) --temp 5
	    end
	    if pStatusChange.bChangeCard[1][self:GetMeChairID()+1] then
	    	self._gameView._cardLayer:removeHandCards(cmd.MY_VIEWID, pStatusChange.cbChangeCardDataBefore[self:GetMeChairID()+1])
			self._gameView._cardLayer:sortHandCard(cmd.MY_VIEWID)
		end
		self._gameView:onUpdataLeftCard(108-13*4-1)
		self._gameView:SetBankerUser(self:SwitchViewChairID(self.m_wBankerUser))
		-- if self:GetMeChairID()==self.m_wBankerUser then
		-- 	self._gameView._cardLayer:setMySendcardRightest(pStatusChange.cbSendCardData)
		-- end
		--if GlobalUserItem.bPrivateRoom then
			self._gameView:showPlayRule(pStatusChange.bHuanSanZhang,pStatusChange.bHuJiaoZhuanYi)
		--end
	elseif cbGameStatus==cmd.GS_MJ_CALL then  --选缺状态
		   --showToast(self,"选缺场景",1)
			--效验数据
			local pStatusCall = ExternalFun.read_netdata(cmd.CMD_S_StatusCall, dataBuffer)
			--print("pStatusCall:getlen:",dataBuffer:getlen())
			local sendcard=nil
	     	if pStatusCall.wBankerUser==self:GetMeChairID() then
	     		sendcard=pStatusCall.cbSendCardData
	    	end
	    	--缺门信息
			self.m_bCallCard=pStatusCall.bCallCard[1]
			self.m_cbCallCard=pStatusCall.cbCallCard[1]

			local myCallcardKind=nil
			if self.m_bCallCard[self:GetMeChairID()+1]==true then
				myCallcardKind=self.m_cbCallCard[self:GetMeChairID()+1]
				myCallcardKind=math.ceil(myCallcardKind/16)
				self._gameView._cardLayer:setCallcardKind()
			end

			print("GameLogic.SortCardList(pStatusCall.cbCardData[1],sendcard,myCallcardKind)")
			GameLogic.SortCardList(pStatusCall.cbCardData[1],sendcard,myCallcardKind)
			 self.cbTimeOutCard = pStatusCall.cbTimeOutCard
			self.cbTimeOperateCard = pStatusCall.cbTimeOperateCard
			self.cbTimeStartGame = pStatusCall.cbTimeStartGame
			self.cbTimeWaitEnd = pStatusCall.cbTimeWaitEnd

			self._gameView:setBtnTrustEnabled(false)
			--辅助变量
			local wViewChairID={}

			for i=1,cmd.GAME_PLAYER do
				 wViewChairID[i]=self:SwitchViewChairID(i-1)
			end

			--设置数据
			self.m_wBankerUser=pStatusCall.wBankerUser
			print("pStatusCall.wBankerUser: ",pStatusCall.wBankerUser)
			self._gameView:SetCellScore(pStatusCall.lCellScore)
			print("wViewChairID[self.m_wBankerUser]:",wViewChairID[self.m_wBankerUser])

			--界面设置
			self._gameView:SetBankerUser(self:SwitchViewChairID(self.m_wBankerUser))

			self._gameView:onUpdataLeftCard(108-13*4-1)
			-- local viewCardCount={13,13,13,13}
			-- viewCardCount[self:SwitchViewChairID(self.m_wBankerUser)]=14
			--扑克变量

			print("pStatusCall.cbCardCount:",pStatusCall.cbCardCount)
				print("#pStatusCall.cbCardData[1]:",#pStatusCall.cbCardData[1])
			if self.m_wBankerUser==self:GetMeChairID() then
				assert(pStatusCall.cbCardCount==14)
			else
				assert(pStatusCall.cbCardCount==13)
			end

			print("GS_MJ_CALL dataBuffer len: ",dataBuffer:getlen())
			create_netdata(cmd.CMD_S_StatusCall)
			print("#pStatusCall.cbCardData[1]:",#pStatusCall.cbCardData[1])
			print("pStatusCall.cbCardCount:",pStatusCall.cbCardCount)
			assert(pStatusCall.cbCardCount==13 or pStatusCall.cbCardCount==14)
			for i=1,pStatusCall.cbCardCount do
				print("pStatusCall.cbCardData[1]"..i,pStatusCall.cbCardData[1][i])
				assert(pStatusCall.cbCardData[1][i]>0)
				assert(pStatusCall.cbCardData[1][i]<42)
			end

			local viewCardCount={13,13,13,13}
			viewCardCount[self:SwitchViewChairID(self.m_wBankerUser)]=14
			--扑克设置
			--手牌
			for i = 1, cmd.GAME_PLAYER do
				if i == cmd.MY_VIEWID then
					self._gameView._cardLayer:createHandCard(i, pStatusCall.cbCardData[1], pStatusCall.cbCardCount)
				else
					self._gameView._cardLayer:createHandCard(i, nil, viewCardCount[i])
				end
			end


			for i=1,cmd.GAME_PLAYER do
				print("callcard: ",wViewChairID[i],self.m_cbCallCard[i])
				local viewId=self:SwitchViewChairID(i-1)
				if self.m_bCallCard[i]==true then
					--self._gameView:setCallCardKind(wViewChairID[i],nil) --self.m_cbCallCard[i]
					if viewId~=cmd.MY_VIEWID then self._gameView:setShowCallingCard(viewId,false) end
				else
					if viewId==cmd.MY_VIEWID then
						self._gameView:setShowLabelClock(true)
						self._gameView:showCallCardHint()
						self:SetGameClock(cmd.MY_VIEWID,cmd.IDI_CALL_CARD,5)
					else
						self._gameView:setShowCallingCard(viewId,true)
					end
					--self._gameView:setCallCardKind(wViewChairID[i],nil)
				end
			end

			--if GlobalUserItem.bPrivateRoom then
				self._gameView:showPlayRule(pStatusCall.bHuanSanZhang,pStatusCall.bHuJiaoZhuanYi)
			--end
			-- if self.m_bCallCard[self:GetMeChairID()+1]==true then
			-- 	self._gameView._cardLayer:sortHandCard(cmd.MY_VIEWID)
			-- end

			-- if pStatusCall.wBankerUser==self:GetMeChairID() then
			-- 	self._gameView._cardLayer:setMySendcardRightest(pStatusCall.cbSendCardData)
			-- end
	elseif cbGameStatus==cmd.GS_MJ_PLAY then	--游戏状态

		   -- showToast(self,"play场景",1)
			local pStatusPlay = ExternalFun.read_netdata(cmd.CMD_S_StatusPlay, dataBuffer)
			print("pStatusPlay len: ",dataBuffer:getlen())
			print("getLenthOfNetData:",getLenthOfNetData(cmd.CMD_S_StatusPlay))

			self.m_bTrustee= pStatusPlay.bTrustee[1][self:GetMeChairID()+1]
			print("self.m_bTrustee:",self.m_bTrustee)
			self._gameView:setTrustee(self.m_bTrustee)


			local myCallcardKind=pStatusPlay.cbCallCard[1][self:GetMeChairID()+1]
			self._gameView._cardLayer:setCallcardKind(math.ceil(myCallcardKind/16))

			local sendcard=nil
	     	if pStatusPlay.wCurrentUser==self:GetMeChairID() and pStatusPlay.cbSendCardData~=0 then --碰牌后无sendcard
	     		sendcard=pStatusPlay.cbSendCardData
	     	end
	     	print("sencard:",sendcard)
	     	GameLogic.SortCardList(pStatusPlay.cbCardData[1],sendcard,math.ceil(myCallcardKind/16))

	     	-- local myHuCard=pStatusPlay.cbChiHuCardArray[1][self:GetMeChairID()+1]
	     	-- if myHuCard>=1 and myHuCard<=41 then  --胡牌置于末尾
	     	-- 	local index=-1
	     	-- 	local n=#pStatusPlay.cbCardData[1]
	     	-- 	local t=pStatusPlay.cbCardData[1]
	     	-- 	for i=n,1,-1 do
	     	-- 		if t[i]==myHuCard then
	     	-- 			index=i
	     	-- 			break
	     	-- 		end
	     	-- 	end
	     	-- 	assert(index~=-1)
	     	-- 	local card=t[index]
	     	-- 	table.remove(t,index)
	     	-- 	table.insert(t,card)
	     	-- end

	     	local ss=table.concat(pStatusPlay.cbCardData[1],",")
	     	print("GameLogic.SortCardList(pStatusPlay.",ss)

			self.myTagCharts= pStatusPlay.tagHistoryChart[self:GetMeChairID()+1]

			print("me:",GlobalUserItem.szNickName)
			print("#self.myTagCharts:",#self.myTagCharts)
			for i=1,#self.myTagCharts do
				print("self.myTagCharts"..i..".charttype:", self.myTagCharts[i].charttype)
				self.myTagCharts[i].bEffectChairID=self.myTagCharts[i].bEffectChairID[1]
				print(type(self.myTagCharts[i].bEffectChairID))
				assert(type(self.myTagCharts[i].bEffectChairID)=="table")
			end

			self.tabCallCard=pStatusPlay.cbCallCard[1]

			--出牌
			for i=1,cmd.GAME_PLAYER do
				local viewId=self:SwitchViewChairID(i-1)
				local userItem = self._gameFrame:getTableUserItem(self._gameFrame:GetTableID(), i-1)
				print("userName:",userItem.szNickName)
				print("出牌数：",pStatusPlay.cbDiscardCount[1][i])
				for j=1,pStatusPlay.cbDiscardCount[1][i] do
					print("出牌"..j,pStatusPlay.cbDiscardCard[i][j])
				end
				self._gameView._cardLayer:createOutCard(viewId,pStatusPlay.cbDiscardCard[i],pStatusPlay.cbDiscardCount[1][i])
			end

			--if GlobalUserItem.bPrivateRoom then
				self._gameView:showPlayRule(pStatusPlay.bHuanSanZhang,pStatusPlay.bHuJiaoZhuanYi)
			--end
			self._gameView:setBtnTrustEnabled(true)

			self.m_wBankerUser=pStatusPlay.wBankerUser

			-- if pStatusPlay.wBankerUser~=self:GetMeChairID() and pStatusPlay.wCurrentUser~=self:GetMeChairID() then
				--assert(#pStatusPlay.cbCardData[1]<14) --无碰杠即胡牌玩家也可能14张
			--end

			self._gameView:SetBankerUser(self:SwitchViewChairID(self.m_wBankerUser))

			local viewCardCount={13,13,13,13}
			print("pStatusPlay.wCurrentUser:",pStatusPlay.wCurrentUser)
			if pStatusPlay.wCurrentUser~=yl.INVALID_CHAIR then
				viewCardCount[self:SwitchViewChairID(pStatusPlay.wCurrentUser)]=14
			end

			self.m_cbCallCard=pStatusPlay.cbCallCard[1]

			local t={}
			t[1]=1
			t[17]=2
			t[33]=3
			for i=1,cmd.GAME_PLAYER do
				local viewId=self:SwitchViewChairID(i-1)
				if viewId==cmd.MY_VIEWID then
					print(GlobalUserItem.szNickName.."cbWeaveCount:", pStatusPlay.cbWeaveCount[1][i])

				end
				viewCardCount[viewId]=viewCardCount[viewId]-pStatusPlay.cbWeaveCount[1][i]*3
				print("pStatusPlay.cbDiscardCount[1]"..i,pStatusPlay.cbWeaveCount[1][i])
				print("viewCardCount[viewId]:",viewCardCount[viewId])
				assert(viewCardCount[viewId]>=0)
				self._gameView:setCallCardKind(viewId,t[self.m_cbCallCard[i]])
				self._gameView:setShowCallCard(true)
			end

			--手牌
			for i=1,cmd.GAME_PLAYER do
				if i == cmd.MY_VIEWID then
					self._gameView._cardLayer:createHandCard(i, pStatusPlay.cbCardData[1], pStatusPlay.cbCardCount)
				else
					print("i:",i)
					assert(viewCardCount[i]>0)
					self._gameView._cardLayer:createHandCard(i, nil, viewCardCount[i])
				end
			end

			 self.cbTimeOutCard = pStatusPlay.cbTimeOutCard
			self.cbTimeOperateCard = pStatusPlay.cbTimeOperateCard
			self.cbTimeStartGame = pStatusPlay.cbTimeStartGame
			self.cbTimeWaitEnd = pStatusPlay.cbTimeWaitEnd
			--计时器
			--self:SetGameClock(self:SwitchViewChairID(self.wCurrentUser), cmd.IDI_OUT_CARD, self.cbTimeOutCard)
			--碰杠牌
			-- for i=1,cmd.GAME_PLAYER do
			-- 	self._gameView._cardLayer:createActiveCardReEnter()
		-- end
			self.outcardUser=pStatusPlay.wOutCardUser
			self.m_wCurrentUser=pStatusPlay.wCurrentUser
			print("self.outcardUser,self.m_wCurrentUser",self.outcardUser,self.m_wCurrentUser)

			if self.m_wCurrentUser~=yl.INVALID_CHAIR then
			  --	showToast(self._gameView,"show out clock",1)
			    self._gameView:setShowLabelClock(true)
				self:SetGameClock(self:SwitchViewChairID(self.m_wCurrentUser), cmd.IDI_OUT_CARD, self.cbTimeOutCard)
			elseif pStatusPlay.wOutCardUser~=yl.INVALID_CHAIR then
				--showToast(self._gameView,"show operate clock",1)
				self._gameView:setShowLabelClock(true)
				self:SetGameClock(self:SwitchViewChairID(pStatusPlay.wOutCardUser), cmd.IDI_OPERATE_CARD, self.cbTimeOperateCard)
			end

			if self.m_wCurrentUser==self:GetMeChairID() then
				self._gameView._cardLayer:setMyCardTouchEnabled(true)
			end
			--self.m_cbLeftCardCount=pStatusPlay.cbLeftCardCount
			self._gameView:onUpdataLeftCard(pStatusPlay.cbLeftCardCount)

			self.file:write("pStatusPlay.cbActionMask,pStatusPlay.cbActionCard:"..pStatusPlay.cbActionMask..","..pStatusPlay.cbActionCard)
			self.file:write("\n")

			self._gameView:ShowGameBtn(pStatusPlay.cbActionMask,pStatusPlay.cbActionCard)

			for i=1,cmd.GAME_PLAYER do
				local wViewChairId = self:SwitchViewChairID(i - 1)
				if pStatusPlay.cbWeaveCount[1][i] > 0 then
					for j = 1, pStatusPlay.cbWeaveCount[1][i] do
						local cbOperateData = {} --此处为tagAvtiveCard
						local weaveItem=pStatusPlay.WeaveItemArray[i][j]
						print("weaveItem:",weaveItem.cbWeaveKind,cbCenterCard,cbPublicCard,wProvideUser,self:GetMeChairID())

						cbOperateData.cbCardValue = {weaveItem.cbCenterCard}

						local nShowStatus = GameLogic.SHOW_NULL
						local cbParam = weaveItem.cbWeaveKind

						if cbParam == GameLogic.WIK_PENG then
							nShowStatus = GameLogic.SHOW_PENG
							cbOperateData.cbCardNum = 3
						elseif cbParam == GameLogic.WIK_GANG then
							if weaveItem.cbPublicCard==0 then
								nShowStatus = GameLogic.SHOW_AN_GANG
							else --==1
								if weaveItem.wProvideUser==i-1 then
									nShowStatus=GameLogic.SHOW_BU_GANG
								else
									nShowStatus=GameLogic.SHOW_MING_GANG
								end
							end
							cbOperateData.cbCardNum = 4
						end
						cbOperateData.cbType = nShowStatus
						self._gameView._cardLayer:createActiveCardReEnter(wViewChairId, cbOperateData)
					end
				end
			end

			--self._gameView._cardLayer:sortHandCard(cmd.MY_VIEWID)
			if pStatusPlay.wCurrentUser==self:GetMeChairID() and pStatusPlay.cbSendCardData~=0 then
				self._gameView._cardLayer:setMySendcardOffset(pStatusPlay.cbSendCardData)
			end

			-- local huCards=pStatusPlay.cbChiHuCardArray[1]
      --
      --
			-- for i=1,cmd.GAME_PLAYER do
			-- 	if huCards[i]~=0 then
			-- 		local viewid=self:SwitchViewChairID(i-1)
      --     -- local jsonStr = cjson.encode(scoreList)
      --     LogAsset:getInstance():logData("husignA", true)
      --     LogAsset:getInstance():logData("huCards="..huCards[i], true)
			-- 		self._gameView:showHuSign(viewid)
			-- 		self._gameView._cardLayer:playSceneTileHuMajong(viewid,huCards[i])
			-- 		self.tabHupaiInfo[viewid].bHu=true
			-- 	end
			-- end


	end
	self:dismissPopWait()
end

function GameLayer:onEventGameMessage( wSubCmdID, dataBuffer)
	--showToast(self,"wSubCmdID: "..wSubCmdID,2)
	if wSubCmdID==cmd.SUB_S_GAME_START then		--游戏开始
		print("SUB_S_GAME_START")
		return self:OnSubGameStart(dataBuffer)
	elseif wSubCmdID==cmd.SUB_S_CALL_CARD then		--用户选缺
		print("SUB_S_CALL_CARD")
		return self:OnSubCallCard(dataBuffer, wDataSize)
	elseif wSubCmdID==cmd.SUB_S_BANKER_INFO then		--庄家信息
		print("SUB_S_BANKER_INFO")
		return self:OnSubBankerInfo(dataBuffer)
	elseif wSubCmdID==cmd.SUB_S_OUT_CARD then		--用户出牌
		print("SUB_S_OUT_CARD")
		return self:OnSubOutCard(dataBuffer)
	elseif wSubCmdID==cmd.SUB_S_SEND_CARD then		--发牌消息
		print("SUB_S_SEND_CARD")
		return self:OnSubSendCard(dataBuffer)
	elseif wSubCmdID==cmd.SUB_S_OPERATE_NOTIFY then	--操作提示
		print("SUB_S_OPERATE_NOTIFY")
		return self:OnSubOperateNotify(dataBuffer)
	elseif wSubCmdID==cmd.SUB_S_OPERATE_RESULT then	--操作结果
		print("SUB_S_OPERATE_RESULT")
		return self:OnSubOperateResult(dataBuffer)
	elseif wSubCmdID==cmd.SUB_S_GAME_END then		--游戏结束
		print("SUB_S_GAME_END")
		return self:OnSubGameEnd(dataBuffer)
	elseif wSubCmdID==cmd.SUB_S_TRUSTEE then			--用户托管
		print("SUB_S_TRUSTEE")
		return self:OnSubTrustee(dataBuffer)
	elseif wSubCmdID==cmd.SUB_S_CHI_HU then			--用户吃胡
		print("SUB_S_CHI_HU")
		--showToast(self,"有人胡了",3)
		return self:OnSubUserChiHu( dataBuffer )
	elseif wSubCmdID==cmd.SUB_S_GANG_SCORE then		--杠牌分数
		print("SUB_S_GANG_SCORE")
		return self:OnSubGangScore(dataBuffer)
	elseif wSubCmdID==cmd.SUB_S_WAIT_OPERATE then	--等待操作
		return self:onSubWaitOperate()
	elseif wSubCmdID==cmd.SUB_S_RECORD then
		return self:OnSubGameRecord(dataBuffer)
	elseif wSubCmdID==cmd.SUB_S_CHANGE_CARD_RESULT then  --已经互换三张
		return self:OnSubChangeCard(dataBuffer)
	elseif wSubCmdID==cmd.SUB_S_ASK_HANDCARD then
		return self:OnSubAskHandCard(dataBuffer)
	end
end

function GameLayer:onSubWaitOperate( )
	self:SetGameClock(self:SwitchViewChairID(self.outcardUser),IDI_OPERATE_CARD,self.cbTimeOperateCard)
end

function GameLayer:OnSubGameRecord(dataBuffer)
	local data = ExternalFun.read_netdata(cmd.CMD_S_RECORD, dataBuffer)
	self.record={guafeng={},xiayu={},fangpao={},zimo={},allscore={}}
	for i=1,cmd.GAME_PLAYER do --chairId+1
		self.record.guafeng[i]=data.cbGuaFeng[1][i]
		self.record.xiayu[i]=data.cbXiaYu[1][i]
		self.record.fangpao[i]=data.cbFangPao[1][i]
		self.record.zimo[i]=data.cbZiMo[1][i]
		self.record.allscore[i]=data.lAllScore[1][i]
	end
end

function GameLayer:getRecord()
	return self.record
end

function GameLayer:OnSubAskHandCard(dataBuffer)
	local data = ExternalFun.read_netdata(cmd.CMD_S_Askhandcard, dataBuffer)
	local t=data.cbCardData[1]
	local kind={"万","条","筒"}
	local tab={}
	for i=1,#t do
		print("牌"..i,t[i])
		if t[i]>0 then
			local k=math.ceil(t[i]/16)
			local str=(t[i]%16)..kind[k]
			table.insert(tab,str)
		end
	end
	local str=table.concat(tab," ")
	print("玩家:",GlobalUserItem.szNickName)
	print("手牌:",str)
	self.file:write(GlobalUserItem.szNickName.."手牌为"..str,"\n")
end

function GameLayer:OnSubGameEnd(dataBuffer)

	local pGameEnd = ExternalFun.read_netdata(cmd.CMD_S_GameEnd, dataBuffer)

	self.bEnd=true
	self.leftUserViewId=self:SwitchViewChairID(pGameEnd.wLeftUser)
	self:KillGameClock()
	self.myTagCharts=pGameEnd.tagHistoryChart[self:GetMeChairID()+1]
	print("OnSubGameEnd")
	for i=1,#self.myTagCharts do
		print("self.myTagCharts"..i..".charttype:", self.myTagCharts[i].charttype)
		self.myTagCharts[i].bEffectChairID=self.myTagCharts[i].bEffectChairID[1]
	end

	for chairId=1,cmd.GAME_PLAYER do
		local cbCardData={}
		print("pGameEnd.cbCardCount[1][viewId]: ",pGameEnd.cbCardCount[1][chairId])
		for i=1,pGameEnd.cbCardCount[1][chairId] do
			table.insert(cbCardData,pGameEnd.cbCardData[chairId][i])
		end
		local viewId=self:SwitchViewChairID(chairId-1)

		self._gameView._cardLayer:showUserTileMajong( viewId, cbCardData,self.tabCallCard[viewId])

		self.tabHupaiInfo[viewId].gameScore=pGameEnd.lGameScore[1][chairId]
	end

	self._gameView:showGameResult(self.tabHupaiInfo)
	self.m_bTrustee=false
	self._gameView:setTrustee(false)
	self._gameView:stopAllActions()
end

function GameLayer:OnSubGangScore(dataBuffer) --有玩家杠牌后所有玩家马上收到此消息
	--各玩家显示+-分动画
	local pGangScore = ExternalFun.read_netdata(cmd.CMD_S_GangScore, dataBuffer)
	--self._gameView:showGang(pGangScore.wChairId,pGangScore.cbXiaYu) --显示一会刮风or下雨图片
	--pGangScore.cbXiaYu --
	self._gameView:showGangScore(pGangScore.lGangScore[1])
end

function GameLayer:OnSubChangeCard(dataBuffer) --所有玩家已互换三张
	--CMD_S_ChangeCardResult.cbSendDataCard
	--showToast(self,"收到换三张",3)
	local pChangeCard = ExternalFun.read_netdata(cmd.CMD_S_ChangeCardResult, dataBuffer)
	local changeType=pChangeCard.cbChangeType

	assert(#pChangeCard.cbChangeCardResult[1]==3)

	-- if self:GetMeChairID()==self.m_wBankerUser then
	-- 	self._gameView._cardLayer:setMySendcardRightest(pChangeCard.cbSendCardData)
	-- end
	self._gameView:runAction(cc.Sequence:create(
		cc.CallFunc:create(function() self._gameView:setShowChangeTypeSps(true,math.random(1,2)) end),
		cc.DelayTime:create(1.5),
		cc.CallFunc:create(function()
			self._gameView:exchangeCard(pChangeCard.cbChangeCardResult[1],self.m_wBankerUser==self:GetMeChairID())
		end),
		cc.DelayTime:create(0.5),
		cc.CallFunc:create(function() self._gameView:showCallCardHint() self:SetGameClock(cmd.MY_VIEWID,cmd.IDI_CALL_CARD,5) end)
	))
end


-- --游戏开始
function GameLayer:OnSubGameStart(dataBuffer)

	self:KillGameClock()
	print("dataBuffer len: ",dataBuffer:getlen())
	local pGameStart = ExternalFun.read_netdata(cmd.CMD_S_GameStart, dataBuffer)
	self.m_wBankerUser=pGameStart.wBankerUser
	self.m_wCurrentUser=pGameStart.wCurrentUser
	print("pGameStart.bHuanSanZhang: ",pGameStart.bHuanSanZhang)
	self.bHuanSanZhang=pGameStart.bHuanSanZhang
	--assert(pGameStart.bHuanSanZhang==true) --temp
	local viewCardCount={13,13,13,13}
	local wViewBankerUser=self:SwitchViewChairID(self.m_wBankerUser)
	viewCardCount[wViewBankerUser]=14
	self._gameView:SetBankerUser(wViewBankerUser)

	print("isMeBanker: ",wViewBankerUser==cmd.MY_VIEWID)
	for i=1,14 do
		print("card "..i,pGameStart.cbCardData[1][i])
	end

	--开始发牌
	self._gameView:gameStart(wViewBankerUser, pGameStart.cbCardData[1], cbCardCount, pGameStart.cbUserAction)
	--self.m_cbLeftCardCount=pGameStart.cbLeftCardCount

	-- 刷新房卡
    if PriRoom and GlobalUserItem.bPrivateRoom then
        if nil ~= self._gameView._priView and nil ~= self._gameView._priView.onRefreshInfo then
        	PriRoom:getInstance().m_tabPriData.dwPlayCount = PriRoom:getInstance().m_tabPriData.dwPlayCount + 1
            self._gameView._priView:onRefreshInfo()
        end
    end

end

--用户选缺
function GameLayer:OnSubCallCard(dataBuffer)
 	--消息处理
 	local pCallCard = ExternalFun.read_netdata(cmd.CMD_S_CallCard, dataBuffer)
 	--设置变量
 	self.m_bCallCard[pCallCard.wCallUser] = true
 	--self._gameView: --将正在选缺sprite隐藏
 	local viewid=self:SwitchViewChairID(pCallCard.wCallUser)
 	--self._gameView:calledCard(viewid,viewid==cmd.MY_VIEWID and self.callCardKind or nil) --马上显示or收到bankerinfo后显示

 	if viewid==cmd.MY_VIEWID then
 		assert(self._gameView._cardLayer.callcardKind)
 		self._gameView._cardLayer:sortHandCard(cmd.MY_VIEWID)
 	end
end

--庄家信息 所有玩家选完缺后发送此消息过来
function GameLayer:OnSubBankerInfo(dataBuffer)

	local pBankerInfo = ExternalFun.read_netdata(cmd.CMD_S_BankerInfo, dataBuffer)
	self.m_wCurrentUser=pBankerInfo.wCurrentUser
	for i=1,cmd.GAME_PLAYER do
		print(i..":",pBankerInfo.cbCallCard[1][i])
	end
	local t={} --万 是  1  索  17  童  33
	t[1]=1
	t[17]=2
	t[33]=3
	for i=1,cmd.GAME_PLAYER do
		local viewid=self:SwitchViewChairID(i-1)
		self.tabCallCard[viewid]= t[pBankerInfo.cbCallCard[1][i]]
		self._gameView:setCallCardKind(viewid,t[pBankerInfo.cbCallCard[1][i]])
	end

	self._gameView:setShowCallCard(true)
	self.m_wBankerUser=pBankerInfo.wBankerUser
	if self.m_wBankerUser==self:GetMeChairID() then
		self._gameView._cardLayer:setMyCardTouchEnabled(true)
	end
	self:SetGameClock(self:SwitchViewChairID(self.m_wBankerUser),cmd.IDI_OUT_CARD,self.cbTimeOutCard)

	--如果我可以操作，显示操作栏
	if GameLogic.WIK_NULL ~=  pBankerInfo.cbActionMask and pBankerInfo.wCurrentUser == self:GetMeChairID()then
		if bit:_and(GameLogic.WIK_GANG, pBankerInfo.cbUserAction) ~= GameLogic.WIK_NULL then
			local cardGang = self._gameView._cardLayer:findMyGangCard()
			if nil ~= cardGang then
				self.cbActionMask = pBankerInfo.cbUserAction
				self.cbActionCard = cardGang
				self._gameView:ShowGameBtn(pBankerInfo.cbUserAction,cardGang)
			end
		-- else
		-- 	self._gameView:ShowGameBtn(pBankerInfo.cbUserAction,0) --temp 0
		-- 	self.cbActionMask = pBankerInfo.cbUserAction
		end
	end
	self._gameView:setBtnTrustEnabled(true)
end

--用户出牌
function GameLayer:OnSubOutCard(dataBuffer)
	--assert(false)
	local pOutCard = ExternalFun.read_netdata(cmd.CMD_S_OutCard, dataBuffer)

	 self:playCardDataSound(pOutCard.wOutCardUser,pOutCard.cbOutCardData)
	print("me:",GlobalUserItem.szNickName)
	--变量定义
	 wMeChairID=self:GetMeChairID()
	 wOutViewChairID=self:SwitchViewChairID(pOutCard.wOutCardUser)
	 self.outcardUser=pOutCard.wOutCardUser

	 print("wOutViewChairID, pOutCard.cbOutCardData",wOutViewChairID, pOutCard.cbOutCardData)
	 local a=#self._gameView._cardLayer.cbCardData[wOutViewChairID]
	 local b=#(self._gameView._cardLayer.nodeHandCard[wOutViewChairID]:getChildren())
	 print("before client out card:",a,b)

	 local pstr=self._gameView.m_UserItem[wOutViewChairID].szNickName.."出牌"..pOutCard.cbOutCardData
	 print(pstr)
	-- showToast(self._gameView,pstr,5)

	 if wOutViewChairID==cmd.MY_VIEWID then
	 	self.bSendcard=false
	 end

	--设置变量
	self.m_wCurrentUser=yl.INVALID_CHAIR
	self.m_wOutCardUser=pOutCard.wOutCardUser
	self.m_cbOutCardData=pOutCard.cbOutCardData

	self._gameView:gameOutCard(wOutViewChairID, pOutCard.cbOutCardData)

	 local c=#self._gameView._cardLayer.cbCardData[wOutViewChairID]
	 local d=#(self._gameView._cardLayer.nodeHandCard[wOutViewChairID]:getChildren())
	 print("after client out card:",c,d)
	-- assert(a-1==c)
	 -- if wOutViewChairID==cmd.MY_VIEWID and true==self.m_bTrustee then
		-- assert(b-1==d)
	 -- end

end

--发牌消息
function GameLayer:OnSubSendCard(dataBuffer)
	local pSendCard=ExternalFun.read_netdata(cmd.CMD_S_SendCard,dataBuffer)

	print("GameLayer:OnSubSendCard()")

	--设置变量
	local wMeChairID=self:GetMeChairID()
	self.m_wCurrentUser=pSendCard.wCurrentUser
	print("pSendCard.wCurrentUser:",pSendCard.wCurrentUser)
	local wCurrentViewId = self:SwitchViewChairID(self.m_wCurrentUser)
	if wCurrentViewId==cmd.MY_VIEWID then
		print("pSendCard.cbCardData:",pSendCard.cbCardData)
		assert(pSendCard.cbCardData>=1 and pSendCard.cbCardData<=41)
	end
	self._gameView:gameSendCard(wCurrentViewId, pSendCard.cbCardData,self.m_bTrustee)
	if wCurrentViewId==cmd.MY_VIEWID then
		print("收到牌"..pSendCard.cbCardData)
		--showToast(self,"收到牌"..pSendCard.cbCardData,3)
		table.insert(self.receivedCards ,pSendCard.cbCardData)
	end

	--设置时间
	-- if pSendCard.cbActionMask~=GameLogic.WIK_NULL then
	-- 	self:SetGameClock(self:SwitchViewChairID(self.m_wCurrentUser),cmd.IDI_OPERATE_CARD,self.cbTimeOperateCard)
	-- else
		self:SetGameClock(self:SwitchViewChairID(self.m_wCurrentUser),cmd.IDI_OUT_CARD,self.cbTimeOutCard)
	--end

	if pSendCard.wCurrentUser==self:GetMeChairID() then
		print("me",GlobalUserItem.szNickName)
		print("pSendCard.wCurrentUser:",pSendCard.wCurrentUser)
		print("pSendCard.wCurrentUser viewiD:",self:SwitchViewChairID(pSendCard.wCurrentUser))
		print(" pSendCard.cbCardData:", pSendCard.cbCardData)
		--assert(self.bSendcard~=true)
		if self.bSendcard==true then
			--showToast(self._gameView,"assert(self.bSendcard~=true)",5)
		end
		self.bSendcard=true
	end

	self.file:write("pSendCard.cbActionMask,pSendCard.cbCardData:",pSendCard.cbActionMask,",",pSendCard.cbCardData,"\n")

	self._gameView:onUpdataLeftCard(-1)
	--如果我可以操作，显示操作栏
	if GameLogic.WIK_NULL ~=  pSendCard.cbActionMask and pSendCard.wCurrentUser == self:GetMeChairID()then
		self._gameView:ShowGameBtn(pSendCard.cbActionMask,pSendCard.cbCardData)
		if bit:_and(GameLogic.WIK_GANG, pSendCard.cbActionMask) ~= GameLogic.WIK_NULL then
			local cardGang = self._gameView._cardLayer:findMyGangCard()
			print("pSendCard.cbCardData:",pSendCard.cbCardData)
			--assert(cardGang)
			if cardGang then
				self.cbActionMask=pSendCard.cbActionMask
				self.cbActionCard = cardGang
				self._gameView:ShowGameBtn(pSendCard.cbActionMask,cardGang)
			end

		else
			self._gameView:ShowGameBtn(pSendCard.cbActionMask,pSendCard.cbCardData)
			self.cbActionMask = pSendCard.cbActionMask
			self.cbActionCard = pSendCard.cbCardData
		end
	end
end

--操作提示
function GameLayer:OnSubOperateNotify(dataBuffer)

	--变量定义
	local pOperateNotify=ExternalFun.read_netdata(cmd.CMD_S_OperateNotify,dataBuffer)
	self._gameView:ShowGameBtn(pOperateNotify.cbActionMask,pOperateNotify.cbActionCard)
	self._gameView.cbActionCard = pOperateNotify.cbActionCard

	self.bMeOperater=true

	self.cbActionMask = pOperateNotify.cbActionMask
	self.cbActionCard = pOperateNotify.cbActionCard
	local outUserViewId=self:SwitchViewChairID( self.outcardUser)
	self:SetGameClock(outUserViewId,cmd.IDI_OPERATE_CARD,self.cbTimeOperateCard)
	--showToast(self,"OnSubOperateNotify"..(pOperateNotify.cbActionCard or ""),3)
	print("OnSubOperateNotify self.cbActionMask,self.cbActionCard",self.cbActionMask,self.cbActionCard)
	self.file:write("OnSubOperateNotify self.cbActionMask,self.cbActionCard:"..self.cbActionMask..","..self.cbActionCard)
	self.file:write("\n")
end

function GameLayer:OnSubOperateResult(dataBuffer)
	print("OnSubOperateResult len:",dataBuffer:getlen())
	local pOperateResult=ExternalFun.read_netdata(cmd.CMD_S_OperateResult,dataBuffer)

	self:playCardOperateSound(pOperateResult.wOperateUser,pOperateResult.cbOperateCode)
	--showToast(self,"收到操作 "..pOperateResult.cbOperateCode,2)
	print("收到操作 "..pOperateResult.cbOperateCode)
	if pOperateResult.cbOperateCode == GameLogic.WIK_NULL then
		assert(false, "没有操作也会进来？")
		return true
	end

	-- if bit:_and(pOperateResult.cbOperateCode, GameLogic.WIK_CHI_HU) ~= GameLogic.WIK_NULL then
	-- 	showToast(self,"收到胡牌操作",3)
	-- end

	local wOperateViewId = self:SwitchViewChairID(pOperateResult.wOperateUser)
	local wProvideViewId = self:SwitchViewChairID(pOperateResult.wProvideUser)

	local tagAvtiveCard={}
	tagAvtiveCard.cbType = GameLogic.SHOW_NULL
	if pOperateResult.cbOperateCode == GameLogic.WIK_PENG then
		tagAvtiveCard.cbType = GameLogic.SHOW_PENG
		tagAvtiveCard.cbCardNum = 3
		local card=pOperateResult.cbOperateCard
		tagAvtiveCard.cbCardValue = {card,card,card}
	elseif pOperateResult.cbOperateCode == GameLogic.WIK_GANG then
		--判断杠类型
		if wOperateViewId ~= wProvideViewId then
			tagAvtiveCard.cbType = GameLogic.SHOW_MING_GANG
		else
			for i=1,#self._gameView._cardLayer.cbActiveCardData[wOperateViewId] do
				--查找是否已经碰
				local activeInfo = self._gameView._cardLayer.cbActiveCardData[wOperateViewId][i]
				if activeInfo.cbCardValue[1] == pOperateResult.cbOperateCard then --有碰
					tagAvtiveCard.cbType = GameLogic.SHOW_BU_GANG --SHOW_BU_GANG --补杠的 wOperateViewId 一定等于wProvideViewId吗？
				end
			end
			if tagAvtiveCard.cbType == GameLogic.SHOW_NULL then
				tagAvtiveCard.cbType = GameLogic.SHOW_AN_GANG
			end
		end
		tagAvtiveCard.cbCardNum = 4
		local card = pOperateResult.cbOperateCard
		tagAvtiveCard.cbCardValue = {card,card,card,card}
		print("操作的麻将信息", tagAvtiveCard.cbType, tagAvtiveCard.cbCardNum, tagAvtiveCard.cbCardValue[1])
	end

	print("pOperateResult type ",tagAvtiveCard.cbType)
	self._gameView._cardLayer:createActiveCard(wOperateViewId, tagAvtiveCard, wProvideViewId)

	if pOperateResult.cbOperateCode == GameLogic.WIK_PENG then
		self._gameView:showOperateAction(wOperateViewId,GameLogic.WIK_PENG+60)
	elseif pOperateResult.cbOperateCode == GameLogic.WIK_GANG then
		local operateTagCharts=pOperateResult.tagHistoryChart[pOperateResult.wOperateUser+1]
		local opType
		for i=cmd.MAX_CHART_COUNT,1,-1 do
			local tagChart=operateTagCharts[i]
			if tagChart.charttype ~=cmd.CHARTTYPE.INVALID_CHARTTYPE then
				self._gameView:showOperateAction(wOperateViewId,tagChart.charttype)
				opType=tagChart.charttype
				break
			end
		end

		if pOperateResult.cbOperateCode == GameLogic.WIK_GANG then
			print("opType:",opType)
			assert(opType==cmd.CHARTTYPE.GUAFENG_TYPE or opType==cmd.CHARTTYPE.XIAYU_TYPE)
		end
	end

	--playsound
	--SetGameClock
	self.myTagCharts=pOperateResult.tagHistoryChart[self:GetMeChairID()+1]
	for i=1,#self.myTagCharts do
		self.myTagCharts[i].bEffectChairID=self.myTagCharts[i].bEffectChairID[1]
	end
	if pOperateResult.wOperateUser==self:GetMeChairID() then
		print("tagHistoryChart:",pOperateResult.tagHistoryChart)
		for i=1,cmd.GAME_PLAYER do
			for j=1,cmd.MAX_CHART_COUNT do
				local t=pOperateResult.tagHistoryChart[i][j]
				local str="content:"
				if i-1==self:GetMeChairID() then
					str="MYYYY content:"
					print(i,j,str,t.charttype,t.lTimes,t.lScore,t.bEffectChairID[1],t.bEffectChairID[2],t.bEffectChairID[3],t.bEffectChairID[4])
				end
			end
		end
	end

	self:SetGameClock(wOperateViewId, cmd.IDI_OUT_CARD, self.cbTimeOutCard)
end


--用户托管
function GameLayer:OnSubTrustee(dataBuffer, wDataSize)
	--消息处理
	local pTrustee=ExternalFun.read_netdata(cmd.CMD_S_Trustee, dataBuffer)
	-- local viewid=self:SwitchViewChairID(pTrustee.wChairID)
	-- showToast(self,"viewid "..viewid.."托管",3)
	if pTrustee.wChairID==self:GetMeChairID() then
		self._gameView:setTrustee(pTrustee.bTrustee)
		self.m_bTrustee=pTrustee.bTrustee
	end
end

--胡牌消息
function GameLayer:OnSubUserChiHu( dataBuffer, wDataSize )
	local data=ExternalFun.read_netdata(cmd.CMD_S_ChiHu, dataBuffer)
	local viewId=self:SwitchViewChairID(data.wChiHuUser)
	self.tabHupaiInfo[viewId].bHu=true
	self.tabHupaiInfo[viewId].gameScore=data.lGameScore
	self.tabHupaiInfo[viewId].winOrder=data.cbWinOrder
	if data.wChiHuUser==self:GetMeChairID() then
		self._gameView._cardLayer:setMyCardTouchEnabled(false)
	end
	local huViewId=self:SwitchViewChairID(data.wChiHuUser)
	self._gameView:showOperateAction(huViewId,GameLogic.WIK_CHI_HU)
	--将胡的那张牌摊开
	self._gameView._cardLayer:tileHuMajong(self:SwitchViewChairID(data.wProviderUser),huViewId,data.cbChiHuCard )

	self.myTagCharts=data.tagHistoryChart[self:GetMeChairID()+1]
	for i=1,#self.myTagCharts do
		self.myTagCharts[i].bEffectChairID=self.myTagCharts[i].bEffectChairID[1]
	end

	self._gameView:disableOpereteBtn()
end

--开始游戏
function GameLayer:sendGameStart()
	self:SendUserReady()
	self:OnResetGameEngine()

	self._gameView.userPoint:setVisible(false)
end

function GameLayer:sendUserTrustee()--请求或取消托管
	local cmd_data = CCmd_Data:create(1)
	cmd_data:pushbool(not self.m_bTrustee)
	print("self.m_bTrustee:",self.m_bTrustee)
	print("self.m_MyStatus: ",self.m_MyStatus)
	local ret=self:SendData(cmd.SUB_C_TRUSTEE, cmd_data)
	print("ret: ",ret)
	--assert(ret==true)
	--self:KillGameClock()
end

function GameLayer:sendChangeCard(cards)
	print("GameLayer:sendChangeCard(cards)")
	print(GlobalUserItem.szNickName,"换三张",cards[1],cards[2],cards[3])
	print("#cards:",#cards)
	assert(#cards==3)
	local tabKind={}
	for i=1,3 do
		tabKind[i]=math.ceil(cards[i]/16)
		assert(tabKind[i]>=1 and tabKind[i]<=3)
		assert(cards[i]%16>=1 and cards[i]%16<=9)
	end
	print("tabkind:",tabKind[1],tabKind[2],tabKind[3])
	assert(tabKind[1]==tabKind[2] and tabKind[3]==tabKind[2])
	local cmd_data = CCmd_Data:create(3)
	for i=1,3 do
		cmd_data:pushbyte(cards[i])
	end
	local ret=self:SendData(cmd.SUB_C_CHANGE_CARD, cmd_data)
	print("sendChangeCard ret: ",ret)
	assert(ret==true)
	self:KillGameClock()
	--showToast(self,"发送换三张:"..cards[1]..","..cards[2]..","..cards[3],2)
	self._gameView:showChangCardHint(false)
	self._gameView:removeMyChangeCards()
end

function GameLayer:sendCallCard(kind)
	self.callCardKind=kind
	--showToast(self,"叫缺"..kind,3)
	 local cmd_data = CCmd_Data:create(1)
	 cmd_data:pushbyte(kind)
	self:SendData(cmd.SUB_C_CALL_CARD,cmd_data)
	self._gameView:setShowCallCardBar(false)
	self:KillGameClock()
end

function GameLayer:sendOutCard(card)
	assert(card)
	print("发送出牌：", card)
	local cmd_data = CCmd_Data:create(1)
	cmd_data:pushbyte(card)
	local ret= self:SendData(cmd.SUB_C_OUT_CARD, cmd_data)
	self.file:write(GlobalUserItem.szNickName.."发送出牌"..card,"\n")
	print("card:",card)
	print("ret: ",ret)
	assert(ret==true) --ret为false执行不到此处
	self:KillGameClock()
	return ret
end

function GameLayer:sendAskHandCard( )
	local cmd_data=CCmd_Data:create()
	self:SendData(cmd.SUB_C_ASK_HANDCARD, cmd_data)
end

--操作扑克
function GameLayer:sendOperateCard(cbOperateCode, cbOperateCard)
	--showToast(self,"发送操作："..cbOperateCode,2)
	print("发送操作："..cbOperateCode)

	-- if bit:_and(cbOperateCode, GameLogic.WIK_CHI_HU) ~= GameLogic.WIK_NULL then
	-- 	showToast(self,"发送胡牌操作",3)
	-- end

	if bit:_and(cbOperateCode, GameLogic.WIK_GANG) ~= GameLogic.WIK_NULL then
		self.bSendcard=false
	end

	print("OnSubOperateNotify 接收cbActionMask,cbActionCard",self.cbActionMask,self.cbActionCard)
	print("sendOperateCard cbOperateCode, cbOperateCard",cbOperateCode, cbOperateCard)

	self.file:write("sendOperateCard cbOperateCode, cbOperateCard:"..cbOperateCode..","..cbOperateCard)
	self.file:write("\n")

    local cmd_data = CCmd_Data:create(2)
	cmd_data:pushbyte(cbOperateCode)
	cmd_data:pushbyte(cbOperateCard)
	--dump(cmd_data, "operate")
	local ret=self:SendData(cmd.SUB_C_OPERATE_CARD, cmd_data)
	assert(ret==true)
	self.bMeOperater=false
	self:KillGameClock()
	if cbOperateCode==GameLogic.WIK_NULL then --发送GameLogic.WIK_NULL都收不到operateResult,其他玩家的时钟显示怎么办
		self:SetGameClock(cmd.MY_VIEWID, cmd.IDI_OUT_CARD, self.cbTimeOutCard)
	end
end

--用户聊天
function GameLayer:onUserChat(chat, wChairId)
	print("玩家聊天", chat.szChatString)
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

--播放麻将数据音效（哪张）
function GameLayer:playCardDataSound(chairID, card)
	local strGender = ""
	if self._gameFrame:getTableUserItem(self:GetMeTableID(), chairID) == 1 then
		strGender = "1"
	else
		strGender = "0"
	end
	local color = {"0_", "1_", "2_", "3_"}
	local nCardColor = math.floor(card/16) + 1
	local nValue = math.mod(card, 16)

	local strFile = cmd.RES_PATH.."sound/"..strGender.."/"..color[nCardColor]..nValue..".wav"
	self:PlaySound(strFile)
end
--播放麻将操作音效
function GameLayer:playCardOperateSound(chairID, operateCode)
	assert(operateCode ~= GameLogic.WIK_NULL)

	local strGender = ""
	if self._gameFrame:getTableUserItem(self:GetMeTableID(), chairID) == 1 then
		strGender = "1"
	else
		strGender = "0"
	end
	local strName = ""

	if operateCode >= GameLogic.WIK_CHI_HU then
		strName = "action_64.wav"
	elseif operateCode == GameLogic.WIK_GANG then
		strName = "action_16.wav"
	elseif operateCode == GameLogic.WIK_PENG then
		strName = "action_8.wav"
	end

	local strFile = cmd.RES_PATH.."sound/"..strGender.."/"..strName
	self:PlaySound(strFile)
end

return GameLayer
