--
-- Add by MXM
-- Date: 2018-03-30
--
--控制层

local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local Game_CMD = appdf.req(appdf.GAME_SRC.."yule.redninebattle.src.models.CMD_Game")

local ControlLayer = class("ControlLayer", cc.Layer)


ControlLayer.BT_CLOSE = 1
ControlLayer.BT_zhuangwin = 2
ControlLayer.BT_zhuanglose = 3
ControlLayer.BT_tian = 4
ControlLayer.BT_di = 5
ControlLayer.BT_xuan = 6

ControlLayer.BT_tip = 8
ControlLayer.BT_execute = 9
ControlLayer.BT_cancel = 10
ControlLayer.BT_choose = 11
ControlLayer.btcontroltime_1 = 12
ControlLayer.btcontroltime_2 = 13
ControlLayer.btcontroltime_3 = 14
ControlLayer.btcontroltime_4 = 15
ControlLayer.btcontroltime_5 = 16
ControlLayer.btcontroltime_6 = 17
ControlLayer.btcontroltime_7 = 18
ControlLayer.btcontroltime_8 = 19
ControlLayer.btcontroltime_9 = 20
ControlLayer.btcontroltime_10 = 21
ControlLayer.userpeizhiadd 	  = 22
ControlLayer.androidxiazhuang = 23

--构造
function ControlLayer:ctor(viewParent )
	--用户列
	self.m_parent = viewParent
		
	self.m_userlist = {}

	--加载csb资源
	local csbNode = ExternalFun.loadCSB("ControlLayer.csb", self)
	self._csbNode = csbNode
		
	--按钮列表
	local function btnEvent( sender, eventType )
		if eventType == ccui.TouchEventType.ended then
			self:onButtonClickedEvent(sender:getTag(), sender);
		end
	end	

	self.btzhuangwin = nil
	self.btzhuanglose = nil
	self.btShunMen = nil
	self.btTianMen = nil
	self.btDaoMen = nil
	self.btexecute = nil
	self.btcancel = nil
	self.ControlTimes = 1
	self.textcontroltimes = nil
	self.m_bWinArea = {false,false,false}
	self.m_curAreaControl = 0
	self.xuanzhong = {}
	--下注区域限制
	self.backgroud_1 = nil
	self.backgroud_2 = nil
	self.backgroud_3 = nil
	self.backgroud_4 = nil
	self.backgroud_5 = nil
	self.backgroud_6 = nil
	
	self.Image_tip = csbNode:getChildByName("Image_tip")
	self.Image_tip:setVisible(false)
	
	self.executefail_tip1 = csbNode:getChildByName("executefail_tip1")
	self.executefail_tip1:setVisible(false)
	
	self.executefail_tip2 = csbNode:getChildByName("executefail_tip2")
	self.executefail_tip2:setVisible(false)
	

	self.btzhuangwin = csbNode:getChildByName("Button_zhuangwin")
	self.btzhuangwin:setTag(ControlLayer.BT_zhuangwin)
	self.btzhuangwin:addTouchEventListener(btnEvent)
	
	self.btzhuanglose = csbNode:getChildByName("Button_zhuanglose")
	self.btzhuanglose:setTag(ControlLayer.BT_zhuanglose)
	self.btzhuanglose:addTouchEventListener(btnEvent)
		
	self.btShunMen = csbNode:getChildByName("Button_ShunMen")
	self.btShunMen:setTag(ControlLayer.BT_tian)
	self.btShunMen:addTouchEventListener(btnEvent)
			
	self.btTianMen = csbNode:getChildByName("Button_TianMen")
	self.btTianMen:setTag(ControlLayer.BT_di)
	self.btTianMen:addTouchEventListener(btnEvent)
	
	self.btDaoMen = csbNode:getChildByName("Button_DaoMen")
	self.btDaoMen:setTag(ControlLayer.BT_xuan)
	self.btDaoMen:addTouchEventListener(btnEvent)
	
	for i = 1,5 do
		self.xuanzhong[i] = csbNode:getChildByName("xuanzhong__" .. i)
		self.xuanzhong[i]:setVisible(false)
	end
	
	self.spritezhuangwin = csbNode:getChildByName("controling_zhuangwin")
	self.spritezhuangwin:setVisible(false)
	self.spritezhuanglose = csbNode:getChildByName("controling_zhuanglose")
	self.spritezhuanglose:setVisible(false)
	self.spriteshunmen = csbNode:getChildByName("controling_shunmen")
	self.spriteshunmen:setVisible(false)
	self.spritetianmen = csbNode:getChildByName("controling_tianmen")
	self.spritetianmen:setVisible(false)
	self.spritedaomen = csbNode:getChildByName("controling_daomen")
	self.spritedaomen:setVisible(false)
	
	self.spritscenetip = csbNode:getChildByName("Image_scenetip")
	self.spritscenetip_1 = csbNode:getChildByName("Image_scenetip_0")
	self.spritscenetip_1:setVisible(false)
	self.spritscenetip_2 = csbNode:getChildByName("Image_scenetip_1")
	self.spritscenetip_2:setVisible(false)
	
	self.sprittimeleft = csbNode:getChildByName("Text_timeleft")

	
	local sp_bgBottom = csbNode:getChildByName("bgBottom")
	
	local btexit = csbNode:getChildByName("Button_exit")
	btexit:setTag(ControlLayer.BT_CLOSE)
	btexit:addTouchEventListener(btnEvent)
	
	local bttip = csbNode:getChildByName("Button_tip")
	bttip:setTag(ControlLayer.BT_tip)
	bttip:addTouchEventListener(btnEvent)
	
	self.btexecute = csbNode:getChildByName("Button_execute")
	self.btexecute:setTag(ControlLayer.BT_execute)
	self.btexecute:addTouchEventListener(btnEvent)
	
	self.btcancel = csbNode:getChildByName("Button_cancel")
	self.btcancel:setTag(ControlLayer.BT_cancel)
	self.btcancel:addTouchEventListener(btnEvent)
	
	self.btchoose = csbNode:getChildByName("Button_choose")
	self.btchoose:setTag(ControlLayer.BT_choose)
	self.btchoose:addTouchEventListener(btnEvent)
	
	self.textcontroltimes = csbNode:getChildByName("Text_controltimes")


	
	self.m_bgControl = csbNode
	
	local sp_controltime_node = csbNode:getChildByName("controltime_node")
	
	self.btcontroltime = {}
	for i = 1,10 do
		self.btcontroltime[i] = sp_controltime_node:getChildByName("controltime_" .. i)
		self.btcontroltime[i]:setTag(ControlLayer.btcontroltime_1+i-1)
		self.btcontroltime[i]:addTouchEventListener(btnEvent)
		self.btcontroltime[i]:setVisible(false)
	end

	
	--区域下注金额
	self.backgroud_1 = csbNode:getChildByName("Text_totleBet_ShunMen")

	self.backgroud_2 = csbNode:getChildByName("Text_totleBet_ShunJiao")

	self.backgroud_3 = csbNode:getChildByName("Text_totleBet_Qiao")

	self.backgroud_4 = csbNode:getChildByName("Text_totleBet_TianMen")

	self.backgroud_5 = csbNode:getChildByName("Text_totleBet_DaoMen")

	self.backgroud_6 = csbNode:getChildByName("Text_totleBet_DaoJiao")
	
	--各区域各个玩家下注列表
	self.m_areaBetListView = nil
	
	
	self.m_areaBetListView = csbNode:getChildByName("ListView")

	self.m_item = csbNode:getChildByName("ListItem")
	
	--玩家配置
	self.m_userpeizhi = csbNode:getChildByName("userbg_4")
	
	self.userpeizhiListView = self.m_userpeizhi:getChildByName("userpeizhiListView")
	
	self.uesepeizhiadd = self.m_userpeizhi:getChildByName("AddUserGameID")
	self.uesepeizhiadd:setTag(ControlLayer.userpeizhiadd)
	self.uesepeizhiadd:addTouchEventListener(btnEvent)
	
	self.UserGameID = self.m_userpeizhi:getChildByName("UserGameID")
	self.m_userpeizhiitem = csbNode:getChildByName("userpeizhiitem")
	--输入玩家ID	
	local x,y = self.UserGameID:getPosition()
	self.edit_UserGameID = ccui.EditBox:create(cc.size(self.UserGameID:getContentSize().width,self.UserGameID:getContentSize().height), ccui.Scale9Sprite:create("control/text_field_space.png"))
		:move(x,y+25)
		--:setAnchorPoint(cc.p(0.5,0.5))
		:setFontName("fonts/round_body.ttf")
		:setPlaceholderFontName("fonts/round_body.ttf")
		:setFontSize(20)
		:setPlaceholderFontSize(20)
		:setMaxLength(32)
		:setFontColor(cc.c4b(0,0,0,255))
		:setInputMode(cc.EDITBOX_INPUT_MODE_NUMERIC)
		:setPlaceHolder("请输入玩家ID")
		:addTo(self,10)
		
		--玩家配置
	--self.m_android = csbNode:getChildByName("adnroidbg")
	
	local AndroidShimosho = csbNode:getChildByName("Button_androidxiazhuang")
	AndroidShimosho:setTag(ControlLayer.androidxiazhuang)
	AndroidShimosho:addTouchEventListener(btnEvent)	
end

function ControlLayer:refreshList( userlist )
--[[	self:setVisible(true)
	self.m_userlist = userlist
	self.m_tableView:reloadData()--]]
end

--tableview
function ControlLayer.cellSizeForTable( view, idx )
	--[[return UserItem.getSize()--]]
end

function ControlLayer:numberOfCellsInTableView( view )
--[[	if nil == self.m_userlist then
		return 0
	else
		return #self.m_userlist
	end--]]
end

function ControlLayer:tableCellAtIndex( view, idx )

end


function ControlLayer:onButtonClickedEvent( tag, sender )
	ExternalFun.playClickEffect()
	if ControlLayer.BT_CLOSE == tag then
		self:setVisible(false)
	elseif ControlLayer.BT_tip == tag then
		self.Image_tip:setVisible(not self.Image_tip:isVisible())
	elseif ControlLayer.BT_zhuangwin == tag then

		if self.xuanzhong[1]:isVisible() then
			self.xuanzhong[1]:setVisible(false)
			self.m_curAreaControl = 0
		else
			self.xuanzhong[1]:setVisible(true)
			self.m_curAreaControl = Game_CMD.CS_BANKER_WIN
		end
		
		for	i = 1,5 do
			if i ~= 1 then
				self.xuanzhong[i]:setVisible(false)
			end
		end
		
		for i = 1,3  do
			self.m_bWinArea[i] = false
		end
		self:onexecute()
	elseif ControlLayer.BT_zhuanglose == tag then
		
		if self.xuanzhong[2]:isVisible() then
			self.xuanzhong[2]:setVisible(false)

			
			local count = 0
			for i = 1,3 do
				if self.m_bWinArea[i] == false then
					count = count + 1
				end
			end
			if count == 3  then
				self.m_curAreaControl = 0
			end
			
		else
			self.xuanzhong[2]:setVisible(true)
			self.m_curAreaControl = Game_CMD.CS_BANKER_LOSE
		end

		for	i = 1,5 do
			if i ~= 2 then
				self.xuanzhong[i]:setVisible(false)
			end
		end
		
		for i = 1,3  do
			self.m_bWinArea[i] = false
		end
		self:onexecute()
	elseif ControlLayer.BT_tian == tag then
		self.xuanzhong[1]:setVisible(false)
		self.xuanzhong[2]:setVisible(false)
		
		if self.xuanzhong[3]:isVisible() then
			self.xuanzhong[3]:setVisible(false)

			self.m_bWinArea[1] = false
			
			local count = 0
			for i = 1,3 do
				if self.m_bWinArea[i] == false then
					count = count + 1
				end
			end
			if count == 3  then
				self.m_curAreaControl = 0
			end
			
		else
			self.xuanzhong[3]:setVisible(true)
			self.m_curAreaControl = Game_CMD.CS_BET_AREA
			self.m_bWinArea[1] = true
		end
		
		self:onexecute()
	elseif ControlLayer.BT_di == tag then
		self.xuanzhong[1]:setVisible(false)
		self.xuanzhong[2]:setVisible(false)
		
		if self.xuanzhong[4]:isVisible() then
			self.xuanzhong[4]:setVisible(false)
			self.m_bWinArea[2] = false
			
			local count = 0
			for i = 1,3 do
				if self.m_bWinArea[i] == false then
					count = count + 1
				end
			end
			if count == 3  then
				self.m_curAreaControl = 0
			end
		else
			self.xuanzhong[4]:setVisible(true)
			self.m_curAreaControl = Game_CMD.CS_BET_AREA
			self.m_bWinArea[2] = true

		end
		self:onexecute()
	elseif ControlLayer.BT_xuan == tag then
		
		self.xuanzhong[1]:setVisible(false)
		self.xuanzhong[2]:setVisible(false)

		
		if self.xuanzhong[5]:isVisible() then
			self.xuanzhong[5]:setVisible(false)
			self.m_bWinArea[3] = false
			
			local count = 0
			for i = 1,3 do
				if self.m_bWinArea[i] == false then
					count = count + 1
				end
			end
			if count == 3  then
				self.m_curAreaControl = 0
			end
			
		else
			self.xuanzhong[5]:setVisible(true)
			self.m_curAreaControl = Game_CMD.CS_BET_AREA
			self.m_bWinArea[3] = true
		end
		self:onexecute()
	
	elseif ControlLayer.BT_choose == tag then
		if self.btcontroltime[1]:isVisible() then
			for i = 1,5 do
				self.btcontroltime[i]:setVisible(false)
			end
		else
			for i = 1,5 do
				self.btcontroltime[i]:setVisible(true)
			end
		end
	elseif ControlLayer.btcontroltime_1 <=  tag and  ControlLayer.btcontroltime_10 >=  tag then
		self.ControlTimes = tag - 11
		self.textcontroltimes:setString(self.ControlTimes)
		for i = 1,5 do
			self.btcontroltime[i]:setVisible(false)
		end
	elseif ControlLayer.BT_execute == tag then
		self:onexecute()
	elseif ControlLayer.BT_cancel == tag then
		local cmddata = ExternalFun.create_netdata(Game_CMD.CMD_C_AdminReq)
		cmddata:pushbyte(Game_CMD.RQ_RESET_CONTROL)
		self.m_parent:executecontrol(cmddata)
	elseif ControlLayer.userpeizhiadd == tag then
		local GameID =  string.gsub(self.edit_UserGameID:getText(),"([^0-9])","")
		GameID = string.gsub(GameID, "[.]", "")
		local GameID_1 = tonumber(GameID)
		
		local cmddata = ExternalFun.create_netdata(Game_CMD.CMD_C_peizhiVec)
		cmddata:pushdword(GameID_1)
		self.m_parent:ControlAddPeizhi(cmddata)
	elseif ControlLayer.androidxiazhuang == tag then
		self.m_parent:androidxiazhuang()
	end
end

function ControlLayer:onexecute()
	if self.ControlTimes <= 0 then
		self.executefail_tip2:setVisible(true)
		return
	elseif self.m_curAreaControl == 0 then
		self.executefail_tip1:setVisible(true)
		return
	end
		
	local cmddata = ExternalFun.create_netdata(Game_CMD.CMD_C_AdminReq)
	local nnn = cmddata:getlen()
			
	cmddata:pushbyte(Game_CMD.RQ_SET_WIN_AREA)
	
	local cmddata_1 = ExternalFun.create_netdata(Game_CMD.tagAdminReq)
	cmddata_1:pushbyte(self.ControlTimes)
	cmddata_1:pushbyte(self.m_curAreaControl)
	for i = 1,3 do
		cmddata_1:pushbool(self.m_bWinArea[i])
	end

	self.executefail_tip2:setVisible(false)
	self.executefail_tip1:setVisible(false)
		
	cmddata:pushData(cmddata_1:getbuffer(),cmddata_1:getlen())
	self.m_parent:executecontrol(cmddata)
	
end

function ControlLayer:onEventTouchCallback(eventType, x, y)
	if eventType == "ended" then
		for i = 1,10 do
			self.btcontroltime[i]:setVisible(false)
		end
	end
	return true	
end
function ControlLayer:OnUpdataClockView(time,state)
	self.sprittimeleft:setString(string.format("%02d", time))
end
function ControlLayer:OnUpdatastate(state)
	if state == Game_CMD.GAME_SCENE_FREE then
		self.spritscenetip:setVisible(false)
		self.spritscenetip_1:setVisible(false)
		self.spritscenetip_2:setVisible(true)
	elseif state == Game_CMD.GAME_SCENE_JETTON then
		self.spritscenetip:setVisible(true)
		self.spritscenetip_1:setVisible(false)
		self.spritscenetip_2:setVisible(false)
	else
		self.spritscenetip:setVisible(false)
		self.spritscenetip_1:setVisible(true)
		self.spritscenetip_2:setVisible(false)
	end
end
function ControlLayer:OnUpdataControlstate()
	self.spritezhuangwin:setVisible(false)
	self.spritezhuanglose:setVisible(false)
	self.spriteshunmen:setVisible(false)
	self.spritetianmen:setVisible(false)
	self.spritedaomen:setVisible(false)
	
	if self.m_curAreaControl == 2 then
		self.spritezhuangwin:setVisible(true)
	elseif self.m_curAreaControl == 1 then
		self.spritezhuanglose:setVisible(true)
	else
		if self.m_bWinArea[1] == true  then
			self.spriteshunmen:setVisible(true)
		end
		if self.m_bWinArea[2] == true   then
			self.spritetianmen:setVisible(true)
		end
		if self.m_bWinArea[3] == true   then
			self.spritedaomen:setVisible(true)
		end
	end
end
--控制结束
function ControlLayer:OnControlEnd()
	self.spritezhuangwin:setVisible(false)
	self.spritezhuanglose:setVisible(false)
	self.spriteshunmen:setVisible(false)
	self.spritetianmen:setVisible(false)
	self.spritedaomen:setVisible(false)
	
	for i = 1,5 do
		self.xuanzhong[i] = self._csbNode:getChildByName("xuanzhong__" .. i)
		self.xuanzhong[i]:setVisible(false)
	end
	
	for i = 1,3  do
		self.m_bWinArea[i] = false
	end					
	
end
	--关闭按钮
function ControlLayer:userpeizhibtnEvent( sender, eventType )
	if eventType == ccui.TouchEventType.ended then
		self:onpeizhiButtonClickedEvent(sender:getTag(), sender);
	end
end	
function ControlLayer:onpeizhiButtonClickedEvent( tag, sender )
	ExternalFun.playClickEffect()
	local lItemCount = table.maxn(self.userpeizhiListView:getItems()) 
	for i = 1,lItemCount  do
		local lItem = self.userpeizhiListView:getItem(i-1)
		if lItem ~= nil then
			local lGameID = nil
			lGameID  = tonumber(lItem:getChildByName("peishigameid"):getString())
			if tag == lGameID then
				

					local cmddata = ExternalFun.create_netdata(Game_CMD.CMD_C_DelPeizhi)
					cmddata:pushdword(lGameID)
					self.m_parent:ControlDelPeizhi(cmddata)
		
				--self.userpeizhiListView:removeItem(i-1);
				return
			end
		end
	end
end
function ControlLayer:UppeizhiLIst(dwGameID,lscore)
	ExternalFun.playClickEffect()
	local lItemCount = table.maxn(self.userpeizhiListView:getItems()) 
	for i = 1,lItemCount  do
		local lItem = self.userpeizhiListView:getItem(i-1)
		if lItem ~= nil then
			local lGameID = nil
			lGameID  = tonumber(lItem:getChildByName("peishigameid"):getString())
			if tag == lGameID then
				lItem:getChildByName("peishiscore"):setString(ExternalFun.formatScoreText(lscore))
				return
			end
		end
	end
end
function ControlLayer:OnAddpeizhi(dwGameID,score)
	local item = self.m_userpeizhiitem:clone()
	local str = ""
	str = string.format("%d", dwGameID)
	item:getChildByName("peishigameid"):setString(str)
	
	--str = string.format("%d", score)
	item:getChildByName("peishiscore"):setString(ExternalFun.formatScoreText(score))
	
	local removeuserpeizhi = item:getChildByName("AddUserGameID_0")
	removeuserpeizhi:setTag(dwGameID)
	removeuserpeizhi:addTouchEventListener(handler(self,self.userpeizhibtnEvent))
	
	self.userpeizhiListView:pushBackCustomItem(item)
	self:removeuserArea(dwGameID);
end

function ControlLayer:removeuserArea(GameID)
	local lpeizhiItemCount = table.maxn(self.userpeizhiListView:getItems())
	
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
				lItem:getChildByName("Text_gameID"):setColor(cc.c3b(255,0,0))
				return
			end
		end
	end
end

function ControlLayer:OnControlstate(AreaControl,WinArea)
	
	self.spritezhuangwin:setVisible(false)
	self.spritezhuanglose:setVisible(false)
	self.spriteshunmen:setVisible(false)
	self.spritetianmen:setVisible(false)
	self.spritedaomen:setVisible(false)

	
	if AreaControl == 2 then
		self.spritezhuangwin:setVisible(true)
	elseif AreaControl == 1 then
		self.spritezhuanglose:setVisible(true)
	else
		if WinArea[1] == 1  then
			self.spriteshunmen:setVisible(true)
		end
		if WinArea[2] == 1   then
			self.spritetianmen:setVisible(true)
		end
		if WinArea[3] == 1   then
			self.spritedaomen:setVisible(true)
		end
		
	end
end
function ControlLayer:OnSetAreaScore(Area,score)
	if Area == 1 then
		self.backgroud_1:setString(ExternalFun.formatScoreText(score))
	elseif Area == 2 then
		self.backgroud_2:setString(ExternalFun.formatScoreText(score))
	elseif Area == 3 then
		self.backgroud_3:setString(ExternalFun.formatScoreText(score))
	elseif Area == 4 then
		self.backgroud_4:setString(ExternalFun.formatScoreText(score))
	elseif Area == 5 then
		self.backgroud_5:setString(ExternalFun.formatScoreText(score))
	elseif Area == 6 then
		self.backgroud_6:setString(ExternalFun.formatScoreText(score))
	end
end
function ControlLayer:removeuserAreaBet(GameID)
	local lItemCount = table.maxn(self.m_areaBetListView:getItems()) 
	for i = 1,lItemCount  do
		local lItem = self.m_areaBetListView:getItem(i-1)
		if lItem ~= nil then
			local lGameID = nil
			lGameID  = tonumber(lItem:getChildByName("Text_gameID"):getString())
			if GameID == lGameID then
				self.m_areaBetListView:removeItem(i-1)
				local useritem = self.m_areaBetListView:getChildByTag(lGameID)
				return
			end
		end
	end
end
--清除下注
function ControlLayer:cleanAreaBet()
--[[	for i=1,4 do
		self.m_areaBetListView[i]:removeAllChildren()
	end--]]
	--self.m_areaBetListView:removeAllChildren()
	local lItemCount = table.maxn(self.m_areaBetListView:getItems()) 
	for i = 1,lItemCount  do
		local lItem = self.m_areaBetListView:getItem(i-1)
		if lItem ~= nil then
			local bet = nil
			bet  = lItem:getChildByName("Text_betScoreShunMen")
			if bet ~= nil   then
				bet:setString(0)
			end
			
			bet  = lItem:getChildByName("Text_betScoreShunJiao")
			if bet ~= nil   then
				bet:setString(0)
			end
			bet  = lItem:getChildByName("Text_betScoreQiao")
			if bet ~= nil  then
				bet:setString(0)
			end
			bet  = lItem:getChildByName("Text_betScoreTianMen")
			if bet ~= nil   then
				bet:setString(0)
			end
			bet  = lItem:getChildByName("Text_betScoreDaoMen")
			if bet ~= nil   then
				bet:setString(0)
			end
			bet  = lItem:getChildByName("Text_betScoreDaoJiao")
			if bet ~= nil   then
				bet:setString(0)
			end
			bet  = lItem:getChildByName("Text_allbetScore")
			if bet ~= nil   then
				bet:setString(0)
			end
		end
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
--设置各玩家各区域下注值
function ControlLayer:setPlayerAreaBet(gameID,cbArea,lScore,lallbetScore,llosewin,lalllosewin,bIsAndroid,bUpdata,lAreaAllJetton,lAllJetton)
	--不显示机器人下注
	if bIsAndroid == true then 
		return
	end
--[[	local lcount = self.m_areaBetListView:getItems();
	if lcount ~= nil then
		local kkk = table.maxn(lcount)
		local lllll =0
	end--]]
	local item = self.m_areaBetListView:getChildByTag(gameID)
	if (nil == item) then
		local item = self.m_item:clone()
		local str = ""
		
		--bg:setVisible(true)
		--bg:setVisible(true)
		str = string.format("%d", gameID)
		item:getChildByName("Text_gameID"):setString(str)
		--if bIsAndroid == false then
			local lbetscore = nil
			if cbArea == 1 then
				local lbetscore = item:getChildByName("Text_betScoreShunMen")
				lbetscore:setString(ExternalFun.formatScoreText(lAreaAllJetton))
			elseif cbArea == 2 then
				lbetscore = item:getChildByName("Text_betScoreShunJiao")
				lbetscore:setString(ExternalFun.formatScoreText(lAreaAllJetton))
			elseif cbArea == 3 then
				lbetscore = item:getChildByName("Text_betScoreQiao")
				lbetscore:setString(ExternalFun.formatScoreText(lAreaAllJetton))
			elseif cbArea == 4 then
				lbetscore = item:getChildByName("Text_betScoreTianMen")
				lbetscore:setString(ExternalFun.formatScoreText(lAreaAllJetton))
			elseif cbArea == 5 then
				lbetscore = item:getChildByName("Text_betScoreDaoMen")
				lbetscore:setString(ExternalFun.formatScoreText(lAreaAllJetton))
			elseif cbArea == 6 then
				lbetscore = item:getChildByName("Text_betScoreDaoJiao")
				lbetscore:setString(ExternalFun.formatScoreText(lAreaAllJetton))
			end		
		--end
		
		local allbetScore = item:getChildByName("Text_allbetScore")
		allbetScore:setString(ExternalFun.formatScoreText(lAllJetton))
		
		if bUpdata == 1 then
			str = string.format("%d", llosewin)
			local losewin = item:getChildByName("Text_losewin")
			losewin:setString(ExternalFun.formatScoreText(llosewin))
			
			str = string.format("%d", lalllosewin)
			local alllosewin = item:getChildByName("Text_alllosewin")
			alllosewin:setString(ExternalFun.formatScoreText(lalllosewin))		
		end

		
		item:setTag(gameID)
		
		local Button_gameID = item:getChildByName("Button_gameID")
		Button_gameID:setTag(gameID)
		Button_gameID:addTouchEventListener(handler(self,self.playeridbtnEvent))
		--监听每个item的数值更新
		local listener = cc.EventListenerCustom:create("GAME_UPDATE_USER_SCORE",function (e)
			assert(type(e.obj) == "table", "expected table !")
			local gameid = e.obj.gameid
			assert(type(gameid) == "number", "expected number !")
			local cbarea = e.obj.cbarea
			assert(type(cbarea) == "number", "expected number !")
			local Score = e.obj.Score
			assert(type(Score) == "number", "expected number !")
			local allbetScore = e.obj.allbetScore
			assert(type(allbetScore) == "number", "expected number !")
			local losewin = e.obj.losewin
			assert(type(losewin) == "number", "expected number !")
			local alllosewin = e.obj.alllosewin
			assert(type(alllosewin) == "number", "expected number !")
			local bupdata = e.obj.bupdata
			assert(type(bupdata) == "number", "expected number !")
			local lareaAllJetton = e.obj.lareaAllJetton
			assert(type(lareaAllJetton) == "number", "expected number !")
			local lallJetton = e.obj.lallJetton
			assert(type(lallJetton) == "number", "expected number !")
--[[			local BIsAndroid = e.obj.BIsAndroid
			assert(type(BIsAndroid) == "bool", "expected bool !")--]]
		
			if (item:getTag() == gameid) then
				

				local lbetscore = nil
				if cbarea == 1 then
					local lbetscore = item:getChildByName("Text_betScoreShunMen")
					lbetscore:setString(ExternalFun.formatScoreText(lareaAllJetton))
				elseif cbarea == 2 then
					lbetscore = item:getChildByName("Text_betScoreShunJiao")
					lbetscore:setString(ExternalFun.formatScoreText(lareaAllJetton))
				elseif cbarea == 3 then
					lbetscore = item:getChildByName("Text_betScoreQiao")
					lbetscore:setString(ExternalFun.formatScoreText(lareaAllJetton))
				elseif cbarea == 4 then
					lbetscore = item:getChildByName("Text_betScoreTianMen")
					lbetscore:setString(ExternalFun.formatScoreText(lareaAllJetton))
				elseif cbArea == 5 then
					lbetscore = item:getChildByName("Text_betScoreDaoMen")
					lbetscore:setString(ExternalFun.formatScoreText(lareaAllJetton))
				elseif cbArea == 6 then
					lbetscore = item:getChildByName("Text_betScoreDaoJiao")
					lbetscore:setString(ExternalFun.formatScoreText(lareaAllJetton))
				end		

				local lallbetScore = item:getChildByName("Text_allbetScore")
				lallbetScore:setString(ExternalFun.formatScoreText(lallJetton))
				if bupdata == 1 then
					str = string.format("%d", losewin)
					local llosewin = item:getChildByName("Text_losewin")
					llosewin:setString(ExternalFun.formatScoreText(losewin))
					
					str = string.format("%d", alllosewin)
					local lalllosewin = item:getChildByName("Text_alllosewin")
					lalllosewin:setString(ExternalFun.formatScoreText(alllosewin))
				end
				
			end
		end)
		cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, item)
		self.m_areaBetListView:pushBackCustomItem(item)
	else
		local customEvent = cc.EventCustom:new("GAME_UPDATE_USER_SCORE")
		customEvent.obj = {gameid = gameID,cbarea=cbArea, Score = lScore,allbetScore= lallbetScore ,losewin= llosewin ,alllosewin= lalllosewin,bupdata = bUpdata,lareaAllJetton=lAreaAllJetton,lallJetton= lAllJetton }
		cc.Director:getInstance():getEventDispatcher():dispatchEvent(customEvent)
	end
end

function ControlLayer:removeAllItem()
	self.userpeizhiListView:removeAllItems()
end

function ControlLayer:OnDelPeizhi(dwGameID)
	ExternalFun.playClickEffect()
	local lItemCount = table.maxn(self.userpeizhiListView:getItems()) 
	for i = 1,lItemCount  do
		local lItem = self.userpeizhiListView:getItem(i-1)
		if lItem ~= nil then
			local lGameID = nil
			lGameID  = tonumber(lItem:getChildByName("peishigameid"):getString())
			if dwGameID == lGameID then
				self.userpeizhiListView:removeItem(i-1);
				local useritem = self.m_areaBetListView:getChildByTag(dwGameID)
				if useritem ~= nil then
					useritem:getChildByName("Text_gameID"):setColor(cc.c3b(255,255,255))
				end
				return
			end
		end
	end
end
return ControlLayer