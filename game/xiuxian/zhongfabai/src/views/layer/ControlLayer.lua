
--控制层

local ExternalFun = require(appdf.EXTERNAL_SRC .. "ExternalFun")
local module_pre = "game.xiuxian.zhongfabai.src";
local g_var = ExternalFun.req_var
local Game_CMD = appdf.req(appdf.GAME_SRC.."xiuxian.zhongfabai.src.models.CMD_Game")


local ControlLayer = class("ControlLayer", cc.Layer)

ControlLayer.BT_TIP = 21
ControlLayer.BT_EXIT = 22
ControlLayer.BT_CHOOSE = 23
ControlLayer.BT_RUN = 24
ControlLayer.BT_CANCEL = 25
ControlLayer.BT_PLAYERLIST = 26
ControlLayer.BT_ANDROID = 27
ControlLayer.BT_ADDPLAYER = 28
ControlLayer.BT_CLOSEPLAYER = 29
--构造
function ControlLayer:ctor( viewParent )
		--用户列
	self.m_parent = viewParent
	--加载csb资源
	local csbNode = ExternalFun.loadCSB("control_new/ControlLayer.csb", self)
	
	--按钮列表
	local function btnEvent( sender, eventType )
		if eventType == ccui.TouchEventType.ended then
			self:onButtonClickedEvent(sender:getTag(), sender);
		end
	end
	--控制区域按钮
	local btn_controlArea = csbNode:getChildByName("Node_controlArea")
	
	self.m_btnControlArea = {}
	local str = ""
	for i=1,15 do
		str = string.format("Button_area_%d",i)
		self.m_btnControlArea[i] = btn_controlArea:getChildByName(str);
		self.m_btnControlArea[i]:setTag(i)
		self.m_btnControlArea[i]:addTouchEventListener(btnEvent);
	end
	
	--当前执行标识
	self.controling = {}
	local str = ""
	for i=1,15 do
		str = string.format("controling_%d",i)
		self.controling[i] = btn_controlArea:getChildByName(str);
		self.controling[i]:setVisible(false);
	end
	--选中标识
	self.m_secletSymbol = {}
	for i=1,15 do
		str = string.format("Image_select_%d",i)
		self.m_secletSymbol[i] = btn_controlArea:getChildByName(str);
		self.m_secletSymbol[i]:setVisible(false);	
	end

	--底部按钮
	local bottomNode = csbNode:getChildByName("Image_bottom")
	
	--剩余时间
	self.m_timeLeftText = bottomNode:getChildByName("Text_timeleft");
	self.m_timeLeftText:setString("")
	--状态标识
	self.m_sceneTip = bottomNode:getChildByName("Image_scenetip");
	self.m_sceneTip:setVisible(false)
	
	--提示
	local btn = bottomNode:getChildByName("Button_tip")
	btn:setTag(ControlLayer.BT_TIP);
	btn:addTouchEventListener(btnEvent);
	--退出
	btn = csbNode:getChildByName("Button_close")
	btn:setTag(ControlLayer.BT_EXIT);
	btn:addTouchEventListener(btnEvent);
	--选择次数
	btn = bottomNode:getChildByName("Button_selectTimes")
	btn:setTag(ControlLayer.BT_CHOOSE);
	btn:addTouchEventListener(btnEvent);
	--执行
	btn = bottomNode:getChildByName("Button_execute")
	btn:setTag(ControlLayer.BT_RUN);
	btn:addTouchEventListener(btnEvent);
	--取消
	btn = bottomNode:getChildByName("Button_cancel")
	btn:setTag(ControlLayer.BT_CANCEL);
	btn:addTouchEventListener(btnEvent);
	--玩家配置列表
	btn = bottomNode:getChildByName("Button_player")
	btn:setTag(ControlLayer.BT_PLAYERLIST);
	btn:addTouchEventListener(btnEvent);
	--btn:setVisible(false)
	--机器人控制
	btn = bottomNode:getChildByName("Button_android")
	btn:setTag(ControlLayer.BT_ANDROID);
	btn:addTouchEventListener(btnEvent);
	btn:setVisible(false)
	--控制次数图片
	self.m_controlTimesSp = bottomNode:getChildByName("Sprite_controltimes")
	self.m_controlTimesSp:setTexture("control_new/showTimes_1.png")
	
	--提示图片
	self.m_imageTip0 = csbNode:getChildByName("Image_tip_0")
	self.m_imageTip0:setVisible(false)
	
	self.m_imageTip1 = csbNode:getChildByName("Image_tip_1")
	self.m_imageTip1:setVisible(false)
	
	self.m_imageTip2 = csbNode:getChildByName("Image_tip_2")
	self.m_imageTip2:setVisible(false)
	
	self.m_imageTip3 = csbNode:getChildByName("Image_tip_3")
	self.m_imageTip3:setVisible(false)
	
	--选择控制次数按钮
	self.m_controltimes_node = csbNode:getChildByName("controltimes_node")
	self.m_btnControlTimes = {}
	local str = ""
	for i=1,5 do
		str = string.format("controltime_%d",i)
		self.m_btnControlTimes[i] = self.m_controltimes_node:getChildByName(str);
		self.m_btnControlTimes[i]:setTag(i+15)
		self.m_btnControlTimes[i]:addTouchEventListener(btnEvent);
	end
	self.m_controltimes_node:setVisible(false)
	
	--当前控制次数
	self.m_currentTimes = 1
	--当前控制区域
	self.m_bWinArea = {}
	for i=1,15 do
		self.m_bWinArea[i] = 0
	end
	--各区域各个玩家下注明细
	self.m_areaBetListView = csbNode:getChildByName("ListView")
	
	--各区域玩家总下注文本(真人下注)
	self.m_areaTotalText = {}
	--各区域玩家总下注文本(机器人下注)
	self.m_areaTotleAndroidText = {}
	
	local topNode = csbNode:getChildByName("Image_top")
	local str = ""
	for i=1,15 do
		str = string.format("Text_allbet_%d",i)
		self.m_areaTotalText[i] = topNode:getChildByName(str)
		self.m_areaTotalText[i]:setString("0")	
		
		str = string.format("Text_totlebet_android_%d",i)
		self.m_areaTotleAndroidText[i] = topNode:getChildByName(str)
		self.m_areaTotleAndroidText[i]:setString("0")
	end
		
	self.m_item = csbNode:getChildByName("Listitem")

	--各区域总下注值(真人下注)
	self.m_areaTotalScore = {}
	--各区域总下注值(机器人下注)
	self.m_areaTotalAndroidScore = {}
	
	--玩家配置列表
	self.m_playerListNode = csbNode:getChildByName("Node_playerList")
	self.m_playerListNode:setVisible(false)
	--添加
	btn = self.m_playerListNode:getChildByName("Button_add")
	btn:setTag(ControlLayer.BT_ADDPLAYER);
	btn:addTouchEventListener(btnEvent);
	--关闭
	btn = self.m_playerListNode:getChildByName("Button_closebtn")
	btn:setTag(ControlLayer.BT_CLOSEPLAYER);
	btn:addTouchEventListener(btnEvent);
	--添加列表
	self.m_addPlayerListView = self.m_playerListNode:getChildByName("ListView_addPlayer")
	
	self.UserGameID = self.m_playerListNode:getChildByName("TextField_nickput")
	
	self.m_addItem = csbNode:getChildByName("ListitemAdd")
	
	--玩家ID输入
	self.edit_UserGameID = ccui.EditBox:create(cc.size(self.UserGameID:getContentSize().width,self.UserGameID:getContentSize().height), ccui.Scale9Sprite:create("control_new/text_field_space.png"))
		:move(self.UserGameID:getPosition())
		:setFontName("fonts/round_body.ttf")
		:setPlaceholderFontName("fonts/round_body.ttf")
		:setFontSize(20)
		:setPlaceholderFontSize(20)
		:setMaxLength(32)
		:setFontColor(cc.c4b(0,0,0,255))
		:setInputMode(cc.EDITBOX_INPUT_MODE_NUMERIC)
		:setPlaceHolder("")
		:addTo(self.m_playerListNode,10)
		
		
	--机器人控制
	self.m_androidControlNode = csbNode:getChildByName("Node_androidControl")
	self.m_androidControlNode:setVisible(false)
		
end
function ControlLayer:onButtonClickedEvent( tag, sender )
	ExternalFun.playClickEffect()
	if ControlLayer.BT_EXIT == tag then
		self:setVisible(false)
	elseif ControlLayer.BT_TIP == tag then
		self.m_imageTip0:setVisible(not self.m_imageTip0:isVisible())
	elseif ControlLayer.BT_CHOOSE == tag then
		self.m_controltimes_node:setVisible(not self.m_controltimes_node:isVisible())
	elseif ControlLayer.BT_RUN == tag then
		self:runControl()
	elseif ControlLayer.BT_CANCEL == tag then
		self:cancelRun()
	elseif ControlLayer.BT_PLAYERLIST == tag then
		self.m_playerListNode:setVisible(not self.m_playerListNode:isVisible())
	elseif ControlLayer.BT_ANDROID == tag then
		return
		--self.m_androidControlNode:setVisible(not self.m_androidControlNode:isVisible())
	elseif ControlLayer.BT_ADDPLAYER == tag then
		self:addPlayerList()
	elseif ControlLayer.BT_CLOSEPLAYER == tag then
		self.m_playerListNode:setVisible(false)
	end
	--控制次数
	for i=1,5 do
		if i+15 == tag then
			local str = string.format("control_new/showTimes_%d.png",i)
			self.m_controltimes_node:setVisible(false)
			self.m_currentTimes = i
			self.m_controlTimesSp:setTexture(str)
			self.m_controlTimesSp:setVisible(true)
		end
	end
	
	local bControl = false
	--控制区域
	if tag >=1 and tag <=3 then
		if self.m_secletSymbol[tag]:isVisible() then
			self.m_secletSymbol[tag]:setVisible(false)
			self.m_bWinArea[tag] = 0	
		else
			self.m_secletSymbol[tag]:setVisible(true)
			self.m_bWinArea[tag] = 1
		end
		local count = 0
		for m=1,3 do
			if self.m_secletSymbol[m]:isVisible() then
				count = count + 1
			end
		end
		if count > 1 then
			for i = 1, 3 do
				self.m_secletSymbol[i]:setVisible(false)
				self.m_bWinArea[i] = 0
				self.controling[i]:setVisible(false)
			end
			self.m_secletSymbol[tag]:setVisible(true)
			self.m_bWinArea[tag] = 1
		end
		bControl = true
	end
	
	if tag >=4 and tag <=15 then		
		if self.m_secletSymbol[tag]:isVisible() then
			self.m_secletSymbol[tag]:setVisible(false)
			self.m_bWinArea[tag] = 0	
		else
			self.m_secletSymbol[tag]:setVisible(true)
			self.m_bWinArea[tag] = 1
		end
		local count = 0
		for m=4,15 do
			if self.m_secletSymbol[m]:isVisible() then
				count = count + 1
			end
		end
		if count > 2 then
			for n=4,15 do
				self.m_secletSymbol[n]:setVisible(false)
				self.m_bWinArea[n] = 0
				self.controling[n]:setVisible(false)
			end
			self.m_secletSymbol[tag]:setVisible(true)
			self.m_bWinArea[tag] = 1
		end	
		
		bControl = true		
	end
	
	if bControl == true then
		self:runControl()
		
		local count = 0
		for i=1,15 do
			if self.m_bWinArea[i] == 1 then
				count = count + 1
			end
		end
		if count <= 0 then
			self.m_imageTip1:setVisible(false)
		end
	end
end
--删除按钮
function ControlLayer:userpeizhibtnEvent( sender, eventType )
	if eventType == ccui.TouchEventType.ended then
		self:onpeizhiButtonClickedEvent(sender:getTag(), sender);
	end
end	
function ControlLayer:onpeizhiButtonClickedEvent( tag, sender )
	ExternalFun.playClickEffect()
	local lItemCount = table.maxn(self.m_addPlayerListView:getItems()) 
	for i = 1,lItemCount  do
		local lItem = self.m_addPlayerListView:getItem(i-1)
		if lItem ~= nil then
			local lGameID = nil
			lGameID  = tonumber(lItem:getChildByName("Text_gameid"):getString())
			if tag == lGameID then
				local cmddata = ExternalFun.create_netdata(Game_CMD.CMD_C_DelPeizhi)
				cmddata:pushdword(lGameID)
				self.m_parent:ControlDelPeizhi(cmddata)		
				return
			end
		end
	end
end

function ControlLayer:OnDelPeizhi(dwGameID)
	ExternalFun.playClickEffect()
	local lItemCount = table.maxn(self.m_addPlayerListView:getItems()) 
	for i = 1,lItemCount  do
		local lItem = self.m_addPlayerListView:getItem(i-1)
		if lItem ~= nil then
			local lGameID = nil
			lGameID  = tonumber(lItem:getChildByName("Text_gameid"):getString())
			if dwGameID == lGameID then
				self.m_addPlayerListView:removeItem(i-1);
				
				local peizhicount = table.maxn(self.m_addPlayerListView:getItems())
				local useritem = self.m_areaBetListView:getChildByTag(dwGameID)
				if useritem ~= nil then
					useritem:getChildByName("Text_gameID"):setColor(cc.c3b(255,255,255))
					local str = ""
					for i = 1, 15 do
						str = string.format("Text_betScore_%d", i)
						useritem:getChildByName(str):setColor(cc.c3b(255,255,255))
					end
					useritem:retain()
					self.m_areaBetListView:removeItem(self.m_areaBetListView:getIndex(useritem))
					self.m_areaBetListView:insertCustomItem(useritem, peizhicount);
					useritem:release()
				end
				return
			end
		end
	end
end

--添加玩家配置列表
function ControlLayer:addPlayerList()

	local GameID =  string.gsub(self.edit_UserGameID:getText(),"([^0-9])","")
	GameID = string.gsub(GameID, "[.]", "")
	local GameID_1 = tonumber(GameID)
	
	local cmddata = ExternalFun.create_netdata(Game_CMD.CMD_C_peizhiVec)
	cmddata:pushdword(GameID_1)
	self.m_parent:ControlAddPeizhi(cmddata)
	
end
function ControlLayer:removeAllItem()
	self.m_addPlayerListView:removeAllItems()
	self.m_areaBetListView:removeAllItems()
end
function ControlLayer:OnAddpeizhi(dwGameID,score)
--[[	local item = self.m_addItem:clone()
	local str = ""
	str = string.format("%d", dwGameID)
	item:getChildByName("Text_gameid"):setString(str)	
	
	item:getChildByName("Text_score"):setString(string.format("%.2f",score))
	
	
	local removeuserpeizhi = item:getChildByName("Button_delete")
	removeuserpeizhi:setTag(dwGameID)
	removeuserpeizhi:addTouchEventListener(handler(self,self.userpeizhibtnEvent))
	
	self.m_addPlayerListView:pushBackCustomItem(item)
	self:removeuserArea(dwGameID);--]]
	
	local bOK = false
	local lItemCount = table.maxn(self.m_addPlayerListView:getItems()) 
	for i = 1,lItemCount  do
		local lItem = self.m_addPlayerListView:getItem(i-1)
		if lItem ~= nil then
			local lGameID = nil
			lGameID  = tonumber(lItem:getChildByName("Text_gameid"):getString())
			if dwGameID == lGameID then
				lItem:getChildByName("Text_score"):setString(string.format("%.2f",score))
				bOK = true
				break
			end
		end
	end
	if bOK == false then
		local item = self.m_addItem:clone()
		local str = ""
		str = string.format("%d", dwGameID)
		item:getChildByName("Text_gameid"):setString(str)
		
		item:getChildByName("Text_score"):setString(string.format("%.2f",score))
		item:setTag(dwGameID)
		local removeuserpeizhi = item:getChildByName("Button_delete")
		removeuserpeizhi:setTag(dwGameID)
		removeuserpeizhi:addTouchEventListener(handler(self,self.userpeizhibtnEvent))
		
		self.m_addPlayerListView:pushBackCustomItem(item)
		self:removeuserArea(dwGameID);
	end
end

function ControlLayer:removeuserArea(GameID)
	local lpeizhiItemCount = table.maxn(self.m_addPlayerListView:getItems())
	
	local lItemCount = table.maxn(self.m_areaBetListView:getItems()) 
	for i = 1,lItemCount  do
		local lItem = self.m_areaBetListView:getItem(i-1)
		if lItem ~= nil then
			local lGameID = nil
			lGameID  = tonumber(lItem:getChildByName("Text_gameID"):getString())
			if GameID == lGameID then
				lItem:retain()
				self.m_areaBetListView:removeItem(i-1)
				self.m_areaBetListView:insertCustomItem(lItem, lpeizhiItemCount-1);
				lItem:release()
				lItem:getChildByName("Text_gameID"):setColor(cc.c3b(255,255,0))
				local str = ""
				for i = 1, 15 do
					str = string.format("Text_betScore_%d", i)
					lItem:getChildByName(str):setColor(cc.c3b(255,255,0))
				end
				return
			end
		end
	end
end
function ControlLayer:UppeizhiLIst(dwGameID,lscore)

	local lItemCount = table.maxn(self.m_addPlayerListView:getItems()) 
	for i = 1,lItemCount  do
		local lItem = self.m_addPlayerListView:getItem(i-1)
		if lItem ~= nil then
			local lGameID = nil
			lGameID  = tonumber(lItem:getChildByName("Text_gameid"):getString())
			if dwGameID == lGameID then
				lItem:getChildByName("Text_score"):setString(string.format("%.2f",lscore))
				return
			end
		end
	end
end
--剩余时间
function ControlLayer:showLeftTime(time)
	local str = string.format("%02d", time)
	self.m_timeLeftText:setString(str)
end
--状态标识
function ControlLayer:showSceneTip(tag)
	
	local str = string.format("control_new/scene_tip_%d.png", tag)
	
	self.m_sceneTip:setVisible(false)	
	self.m_sceneTip:setTexture(str)
	self.m_sceneTip:setVisible(true)
	
end

--各区域总下注
function ControlLayer:setAreaTotalBet(index,totalScore,bAndroid)
	if bAndroid == nil then
		return
	end
	if bAndroid == false then
		self.m_areaTotalScore[index] = (self.m_areaTotalScore[index] or 0)+ totalScore
		self.m_areaTotalText[index]:setString(self.m_areaTotalScore[index])
	else
		self.m_areaTotalAndroidScore[index] = (self.m_areaTotalAndroidScore[index] or 0)+ totalScore
		self.m_areaTotleAndroidText[index]:setString(self.m_areaTotalAndroidScore[index])
	end

end
--断线回来显示下注信息
function ControlLayer:UpBetInfo(index,lPlayerbet,lAndroidBet,lPlayerAreaBet,dwGameID,lPlayerTotleBet)
	
	self.m_areaTotalScore[index] = lPlayerbet
	self.m_areaTotalAndroidScore[index] = lAndroidBet
	self.m_areaTotalText[index]:setString(lPlayerbet)
	self.m_areaTotleAndroidText[index]:setString(lAndroidBet)
	
	local item = self.m_areaBetListView:getChildByTag(dwGameID)
	if nil ~= item then
		local str = ""		
		str = string.format("Text_betScore_%d", index)
		local userScore = item:getChildByName(str)
		userScore:setString(string.format("%.2f",lPlayerAreaBet))	
	end
end

--清除下注
function ControlLayer:cleanAreaBet()
	for i=1,15 do
		self.m_areaTotalScore[i] = 0
		self.m_areaTotalText[i]:setString("0")
		self.m_areaTotalAndroidScore[i] = 0
		self.m_areaTotleAndroidText[i]:setString("0")
	end
	
	local lItemCount = table.maxn(self.m_areaBetListView:getItems()) 
	for i = 1,lItemCount  do
		local lItem = self.m_areaBetListView:getItem(i-1)
		if lItem ~= nil then
			local str = ""	
			for j = 1,15 do
				str = string.format("Text_betScore_%d", j)
				local userScore = lItem:getChildByName(str)
				userScore:setString(0)
			end		
		end
	end

end
--执行命令
function ControlLayer:runControl()
	
	self.m_imageTip1:setVisible(false)
	self.m_imageTip2:setVisible(false)
	self.m_imageTip3:setVisible(false)
	for i=1,15 do
		self.controling[i]:setVisible(false)
	end
	
	if self.m_currentTimes <=0 then
		self.m_imageTip2:setVisible(true)
		
		self:cancelRun()
		return
	end
	local count = 0
	for i=1,15 do
		if self.m_bWinArea[i] == 1 then
			count = count + 1
		end
	end
	if count <= 0 then
		self.m_imageTip1:setVisible(true)
		
		self:cancelRun()
		return
	end
	if count>3 or (self.m_bWinArea[2]==1 and count>2) then
		self.m_imageTip3:setVisible(true)
		
		self:cancelRun()
		return
	end
	--平和豹子不能同时选
	if self.m_bWinArea[2]==1 and self.m_bWinArea[14]==1 then
		self.m_imageTip3:setVisible(true)
		
		self:cancelRun()
		return
	end
	
	for i=1,15 do
		if self.m_bWinArea[i] == 1 then
			self.controling[i]:setVisible(true)
		else
			self.controling[i]:setVisible(false)
		end
	end
	
	--发送消息
	local cmddata = ExternalFun.create_netdata(Game_CMD.CMD_C_AdminReq)
	
	cmddata:pushbyte(Game_CMD.RQ_SET_WIN_AREA)
	cmddata:pushint(self.m_currentTimes)
		
	for i = 1,#self.m_bWinArea do
		cmddata:pushbyte(self.m_bWinArea[i])	
	end
	
	self.m_parent:executecontrol(cmddata)
	
	
end
--取消命令
function ControlLayer:cancelRun()
	self.m_currentTimes = 1
	for i=1,15 do		
		self.controling[i]:setVisible(false)
		self.m_secletSymbol[i]:setVisible(false)
		self.m_bWinArea[i] = 0
	end
	--self.m_controlTimesSp:setVisible(false)
	self.m_controlTimesSp:setTexture("control_new/showTimes_1.png")
	self.m_controltimes_node:setVisible(false)
	--self.m_imageTip1:setVisible(false)
	--self.m_imageTip2:setVisible(false)
	--self.m_imageTip3:setVisible(false)
	
	--发送消息
	local cmddata = ExternalFun.create_netdata(Game_CMD.CMD_C_AdminReq)
	cmddata:pushbyte(Game_CMD.RQ_RESET_CONTROL)
	self.m_parent:executecontrol(cmddata)
		
end
--执行完控制后重置
function ControlLayer:reSetControl()
	self.m_currentTimes = 1
	self.m_controlTimesSp:setTexture("control_new/showTimes_1.png")
	--self.m_controlTimesSp:setVisible(false)
	for i=1,15 do		
		self.controling[i]:setVisible(false)
		self.m_secletSymbol[i]:setVisible(false)
		self.m_bWinArea[i] = 0
	end
	
	self.m_imageTip1:setVisible(false)
	self.m_imageTip2:setVisible(false)
	self.m_imageTip3:setVisible(false)
end
--动态加入显示控制信息
function ControlLayer:OnControlstate(ControlTimes,WinArea)
		
	for i=1,15 do
		self.controling[i]:setVisible(false)
		self.m_secletSymbol[i]:setVisible(false)
		if WinArea[i] ~=0 then
			self.controling[i]:setVisible(true)
			self.m_secletSymbol[i]:setVisible(true)
		end
	end
	if ControlTimes > 0 then
		self.m_controlTimesSp:setVisible(true)
		local str = string.format("control_new/showTimes_%d.png",ControlTimes)
		self.m_controlTimesSp:setTexture(str)
	end

end
--显示玩家下注值
function ControlLayer:setPlayerEnter(gameID,cbAndroidUser)
	--不显示机器人下注
	if cbAndroidUser == true then 
		return
	end
	local item = self.m_areaBetListView:getChildByTag(gameID)
	if (nil == item) then
		local item = self.m_item:clone()
		local str = ""
		str = string.format("%d", gameID)
		item:getChildByName("Text_gameID"):setString(str)
		
		local areaBet = {}
		for i = 1, 15 do
			str = string.format("Text_betScore_%d", i)
			areaBet[i] = item:getChildByName(str)
			areaBet[i]:setString(0)
		end	
		
		item:setTag(gameID)
		
		local btn_gameid = item:getChildByName("Button_gameID")
		btn_gameid:setTag(gameID)
		btn_gameid:addTouchEventListener(handler(self,self.playeridbtnEvent))
		
		self.m_areaBetListView:pushBackCustomItem(item)
	end
end
--玩家ID按钮
function ControlLayer:playeridbtnEvent( sender, eventType )
	if eventType == ccui.TouchEventType.ended then
		self:playeridButtonClickedEvent(sender:getTag(), sender);
	end
end	
function ControlLayer:playeridButtonClickedEvent( tag, sender )
	ExternalFun.playClickEffect()
	local lItemCount = table.maxn(self.m_areaBetListView:getItems()) 
	for i = 1,lItemCount  do
		local lItem = self.m_areaBetListView:getItem(i-1)
		if lItem ~= nil then
			local lGameID = nil
			lGameID  = tonumber(lItem:getChildByName("Text_gameID"):getString())
			if tag == lGameID then
				local gameText  = lItem:getChildByName("Text_gameID"):getString()
				self.edit_UserGameID:setText(gameText)
				return
			end
		end
	end
end	
function ControlLayer:removeuserAreaBet(dwGameID)
	local item = self.m_areaBetListView:getChildByTag(dwGameID)
	if (nil ~= item) then
		self.m_areaBetListView:getIndex(item)
		self.m_areaBetListView:removeItem(self.m_areaBetListView:getIndex(item))
	end
	self:OnDelPeizhi(dwGameID);
end

--设置各玩家各区域下注值
function ControlLayer:setPlayerAreaBet(gameID,cbArea,lScore,cbAndroidUser)
	--不显示机器人下注	
	if cbAndroidUser == true then 
		return
	end
	local item = self.m_areaBetListView:getChildByTag(gameID)
	if (nil == item) then
		local item = self.m_item:clone()
		local str = ""
		str = string.format("%d", gameID)
		item:getChildByName("Text_gameID"):setString(str)
		
		local areaBet = {}
		for i = 1, 15 do
			str = string.format("Text_betScore_%d", i)
			areaBet[i] = item:getChildByName(str)
			areaBet[i]:setString(0)
		end		
		areaBet[cbArea]:setString(string.format("%.2f",lScore))
			
		item:setTag(gameID)

		self.m_areaBetListView:pushBackCustomItem(item)
	else		
		local str = string.format("Text_betScore_%d", cbArea)
		local areaBet = item:getChildByName(str)
		areaBet:setString(string.format("%.2f",lScore))
	end
	
end

return ControlLayer