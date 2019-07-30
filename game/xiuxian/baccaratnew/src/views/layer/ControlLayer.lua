
--控制层

local ExternalFun = require(appdf.EXTERNAL_SRC .. "ExternalFun")
local module_pre = "game.xiuxian.baccaratnew.src";
local g_var = ExternalFun.req_var
local Game_CMD = appdf.req(appdf.GAME_SRC.."xiuxian.baccaratnew.src.models.CMD_Game")

local ControlLayer = class("ControlLayer", cc.Layer)
ControlLayer.BT_XIANPAIR = 11
ControlLayer.BT_XIAN = 12		
ControlLayer.BT_XIANTIAN = 13
ControlLayer.BT_PING = 14
ControlLayer.BT_TONGDIANPING = 15
ControlLayer.BT_ZHUANGPAIR = 16
ControlLayer.BT_ZHUANG = 17
ControlLayer.BT_ZHUANGTIAN = 18
ControlLayer.BT_TIP = 19
ControlLayer.BT_EXIT = 20
ControlLayer.BT_CHOOSE = 21
ControlLayer.BT_RUN = 22
ControlLayer.BT_CANCEL = 23
ControlLayer.userpeizhiadd =  24
ControlLayer.androidxiazhuang = 25
--构造
function ControlLayer:ctor( viewParent )
		--用户列
	self.m_parent = viewParent
	--加载csb资源
	local csbNode = ExternalFun.loadCSB("control/ControlLayer.csb", self)
	
	--按钮列表
	local function btnEvent( sender, eventType )
		if eventType == ccui.TouchEventType.ended then
			self:onButtonClickedEvent(sender:getTag(), sender);
		end
	end
	--控制区域按钮
	local btn_controlArea = csbNode
	
	self.m_btnControlArea = {}
	--庄
	local btn = btn_controlArea:getChildByName("Button_zhuang");
	btn:setTag(ControlLayer.BT_ZHUANG);
	btn:addTouchEventListener(btnEvent);
	self.m_btnControlArea[3] = btn;
	--闲
	btn = btn_controlArea:getChildByName("Button_xian");
	btn:setTag(ControlLayer.BT_XIAN);
	btn:addTouchEventListener(btnEvent);
	self.m_btnControlArea[1] = btn;
	--庄对子
	btn = btn_controlArea:getChildByName("Button_zhuangdui");
	btn:setTag(ControlLayer.BT_ZHUANGPAIR);
	btn:addTouchEventListener(btnEvent);
	self.m_btnControlArea[8] = btn;
	--闲对子
	btn = btn_controlArea:getChildByName("Button_xiandui");
	btn:setTag(ControlLayer.BT_XIANPAIR);
	btn:addTouchEventListener(btnEvent);
	self.m_btnControlArea[7] = btn;
	--庄天王
	btn = btn_controlArea:getChildByName("Button_zhuangtian");
	btn:setTag(ControlLayer.BT_ZHUANGTIAN);
	btn:addTouchEventListener(btnEvent);
	self.m_btnControlArea[5] = btn;
	--闲天王
	btn = btn_controlArea:getChildByName("Button_xiantian");
	btn:setTag(ControlLayer.BT_XIANTIAN);
	btn:addTouchEventListener(btnEvent);
	self.m_btnControlArea[4] = btn;
	--平
	btn = btn_controlArea:getChildByName("Button_ping");
	btn:setTag(ControlLayer.BT_PING);
	btn:addTouchEventListener(btnEvent);
	self.m_btnControlArea[2] = btn;
	--同点平
	btn = btn_controlArea:getChildByName("Button_tongdianping");
	btn:setTag(ControlLayer.BT_TONGDIANPING);
	btn:addTouchEventListener(btnEvent);
	self.m_btnControlArea[6] = btn;
	--当前执行标识
	self.controling = {}
	local str = ""
	for i=1,8 do
		str = string.format("controling_%d",i)
		self.controling[i] = btn_controlArea:getChildByName(str);
		self.controling[i]:setVisible(false);
	end
	--选中标识
	self.m_secletSymbol = {}
	for i=1,8 do
		str = string.format("Image_select_%d",i)
		self.m_secletSymbol[i] = btn_controlArea:getChildByName(str);
		self.m_secletSymbol[i]:setVisible(false);	
	end
	--剩余时间
	self.m_timeLeftText = btn_controlArea:getChildByName("Text_timeleft");
	self.m_timeLeftText:setString("")
	--状态标识
	self.m_sceneTip = btn_controlArea:getChildByName("Image_scenetip");
	self.m_sceneTip:setVisible(false)
	--底部按钮
	local btn_bgBottom = csbNode:getChildByName("bgBottom")
	
	--提示
	btn = btn_bgBottom:getChildByName("Button_tip")
	btn:setTag(ControlLayer.BT_TIP);
	btn:addTouchEventListener(btnEvent);
	--退出
	btn = csbNode:getChildByName("Button_exit")
	btn:setTag(ControlLayer.BT_EXIT);
	btn:addTouchEventListener(btnEvent);
	--选择次数
	btn = btn_bgBottom:getChildByName("Button_choose")
	btn:setTag(ControlLayer.BT_CHOOSE);
	btn:addTouchEventListener(btnEvent);
	--执行
	btn = btn_bgBottom:getChildByName("Button_run")
	btn:setTag(ControlLayer.BT_RUN);
	btn:addTouchEventListener(btnEvent);
	--取消
	btn = btn_bgBottom:getChildByName("Button_cancel")
	btn:setTag(ControlLayer.BT_CANCEL);
	btn:addTouchEventListener(btnEvent);
	--控制次数文本
	self.m_controlTimesText = btn_bgBottom:getChildByName("Text_controltimes")
	self.m_controlTimesText:setString("1")
	
	--提示图片
	self.m_imageTip0 = csbNode:getChildByName("Image_tip_0")
	self.m_imageTip0:setVisible(false)
	
	self.m_imageTip1 = csbNode:getChildByName("Image_tip_1")
	self.m_imageTip1:setVisible(false)
	
	self.m_imageTip2 = csbNode:getChildByName("Image_tip_2")
	self.m_imageTip2:setVisible(false)
	
	--选择控制次数按钮
	self.m_controltimes_node = csbNode:getChildByName("controltimes_node")
	self.m_btnControlTimes = {}
	local str = ""
	for i=1,10 do
		str = string.format("controltime_%d",i)
		self.m_btnControlTimes[i] = self.m_controltimes_node:getChildByName(str);
		self.m_btnControlTimes[i]:setTag(i)
		self.m_btnControlTimes[i]:addTouchEventListener(btnEvent);
	end
	self.m_controltimes_node:setVisible(false)
	
	--当前控制次数
	self.m_currentTimes = 1
	--当前控制区域
	self.m_currentArea = 0
	
	--各区域玩家总下注文本(真人下注)
	self.m_areaTotalText = {}
	--各区域玩家总下注文本(机器人下注)
	self.m_areaTotleAndroidText = {}
	--各区域各个玩家下注明细
	self.m_areaBetListView = {}
	
	local str = ""
	local backgroundNode = nil
	for i=1,8 do
		str = string.format("Text_totlebet_%d",i)
		self.m_areaTotalText[i] = csbNode:getChildByName(str)
		self.m_areaTotalText[i]:setString("0")
		
		str = string.format("Text_totlebet_android_%d",i)
		self.m_areaTotleAndroidText[i] = csbNode:getChildByName(str)
		self.m_areaTotleAndroidText[i]:setString("0")
	end
	self.m_areaBetListView = csbNode:getChildByName("ListView")
	self.m_item = csbNode:getChildByName("Listitem")

	--各区域总下注值(真人下注)
	self.m_areaTotalScore = {}
	--各区域总下注值(机器人下注)
	self.m_areaTotalAndroidScore = {}
	--玩家今日输赢值
	self.m_tdWinScore = {}
	--玩家总输赢值
	self.m_totleWinScore = {}
	
	--玩家配置
	self.m_userpeizhi = csbNode:getChildByName("userbg_4")
	
	self.userpeizhiListView = self.m_userpeizhi:getChildByName("userpeizhiListView")
	
	self.uesepeizhiadd = self.m_userpeizhi:getChildByName("AddUserGameID")
	self.uesepeizhiadd:setTag(ControlLayer.userpeizhiadd)
	self.uesepeizhiadd:addTouchEventListener(btnEvent)
	
	self.UserGameID = self.m_userpeizhi:getChildByName("UserGameID")
	self.m_userpeizhiitem = csbNode:getChildByName("userpeizhiitem")
	--密码输入	
	self.edit_UserGameID = ccui.EditBox:create(cc.size(self.UserGameID:getContentSize().width,self.UserGameID:getContentSize().height), ccui.Scale9Sprite:create("control/text_field_space.png"))
		:move(self.UserGameID:getPosition())
		:setFontName("fonts/round_body.ttf")
		:setPlaceholderFontName("fonts/round_body.ttf")
		:setFontSize(20)
		:setPlaceholderFontSize(20)
		:setMaxLength(32)
		:setFontColor(cc.c4b(0,0,0,255))
		:setInputMode(cc.EDITBOX_INPUT_MODE_NUMERIC)
		:setPlaceHolder("")
		:addTo(self,10)
		
				--玩家配置
	self.m_android = csbNode:getChildByName("adnroidbg")
	
	local AndroidShimosho = self.m_android:getChildByName("Button_androidxiazhuang")
	AndroidShimosho:setTag(ControlLayer.androidxiazhuang)
	AndroidShimosho:addTouchEventListener(btnEvent)	
		
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
				local peizhicount = table.maxn(self.userpeizhiListView:getItems())
				local useritem = self.m_areaBetListView:getChildByTag(dwGameID)
				if useritem ~= nil then
					useritem:getChildByName("Text_gameID"):setColor(cc.c3b(255,255,255))
					local str = ""
					for i = 1, 8 do
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
function ControlLayer:OnAddpeizhi(dwGameID,score)
--[[	local item = self.m_userpeizhiitem:clone()
	local str = ""
	str = string.format("%d", dwGameID)
	item:getChildByName("peishigameid"):setString(str)
	
	--str = string.format("%d", score)
	item:getChildByName("peishiscore"):setString(ExternalFun.formatScoreText(score))
	
	local removeuserpeizhi = item:getChildByName("AddUserGameID_0")
	removeuserpeizhi:setTag(dwGameID)
	removeuserpeizhi:addTouchEventListener(handler(self,self.userpeizhibtnEvent))
	
	self.userpeizhiListView:pushBackCustomItem(item)
	self:removeuserArea(dwGameID);--]]
	
	local bOK = false
	local lItemCount = table.maxn(self.userpeizhiListView:getItems()) 
	for i = 1,lItemCount  do
		local lItem = self.userpeizhiListView:getItem(i-1)
		if lItem ~= nil then
			local lGameID = nil
			lGameID  = tonumber(lItem:getChildByName("peishigameid"):getString())
			if dwGameID == lGameID then
				lItem:getChildByName("peishiscore"):setString(ExternalFun.formatScoreText(score))
				bOK = true
				break
			end
		end
	end
	if bOK == false then
		local item = self.m_userpeizhiitem:clone()
		local str = ""
		str = string.format("%d", dwGameID)
		item:getChildByName("peishigameid"):setString(str)
		
		--str = string.format("%d", score)
		item:getChildByName("peishiscore"):setString(ExternalFun.formatScoreText(score))
		item:setTag(dwGameID)
		local removeuserpeizhi = item:getChildByName("AddUserGameID_0")
		removeuserpeizhi:setTag(dwGameID)
		removeuserpeizhi:addTouchEventListener(handler(self,self.userpeizhibtnEvent))
		
		self.userpeizhiListView:pushBackCustomItem(item)
		self:removeuserArea(dwGameID);
	end
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
				local str = ""
				for i = 1, 8 do
					str = string.format("Text_betScore_%d", i)
					lItem:getChildByName(str):setColor(cc.c3b(255,0,0))
				end
				return
			end
		end
	end
end

function ControlLayer:setPlayerAlljettion(dwGameID,lTdTotalScore,lTotalScore)
	local lItemCount = table.maxn(self.m_areaBetListView:getItems()) 
	for i = 1,lItemCount  do
		local lItem = self.m_areaBetListView:getItem(i-1)
		if lItem ~= nil then
			local lGameID = nil
			lGameID  = tonumber(lItem:getChildByName("Text_gameID"):getString())
			if dwGameID == lGameID then
				self.m_tdWinScore[i] = lTdTotalScore
				self.m_totleWinScore[i] = lTotalScore
			end
		end
	end
	
	
	local item = self.m_areaBetListView:getChildByTag(dwGameID)
	if (nil ~= item) then
		
		local strlTdTotalScore = nil;
		if lTdTotalScore  < 0 then
			lTdTotalScore = -lTdTotalScore;
			strlTdTotalScore = ExternalFun.formatScoreText(lTdTotalScore)
			strlTdTotalScore = "-"..strlTdTotalScore
			local ltdTotalScore = item:getChildByName("Text_DtLoseWin")
			ltdTotalScore:setString(strlTdTotalScore)
		else
			local ltdTotalScore = item:getChildByName("Text_DtLoseWin")
			ltdTotalScore:setString(ExternalFun.formatScoreText(lTdTotalScore))
		end

		if lTotalScore  < 0 then
			lTotalScore = -lTotalScore;
			strlTdTotalScore = ExternalFun.formatScoreText(lTotalScore)
			strlTdTotalScore = "-"..strlTdTotalScore
			local ltdTotalScore = item:getChildByName("Text_AllLoseWin")
			ltdTotalScore:setString(strlTdTotalScore)
		else
			local ltotalScore = item:getChildByName("Text_AllLoseWin")
			ltotalScore:setString(ExternalFun.formatScoreText(lTotalScore))
		end
			
	end

end
--根据玩家今日输赢值从大到小排序
function ControlLayer:UptdwinscoreItemList( )
	local gameid = {}
	local tdWincore = {}
	local totleWinscore = {}
	local sortGameid = {}
	
	local lItemCount = table.maxn(self.m_areaBetListView:getItems()) 
	local pzItemCount = table.maxn(self.userpeizhiListView:getItems())
	local ncount = 0
	for i = 1,lItemCount  do
		local lItem = self.m_areaBetListView:getItem(i-1)
		if lItem ~= nil then
			local bok = true
			local lGameID = nil
			lGameID  = tonumber(lItem:getChildByName("Text_gameID"):getString())
			for j =1,pzItemCount do
				local pzItem = self.userpeizhiListView:getItem(i-1)
				if pzItem ~= nil then
					local lpzGameID = nil
					lpzGameID  = tonumber(pzItem:getChildByName("peishigameid"):getString())
					if lGameID == lpzGameID then
						bok = false
						break
					end
				end
			end
			if bok == true then
				ncount = ncount + 1
				gameid[ncount] = lGameID
				sortGameid[ncount] = lGameID	
				tdWincore[ncount] = self.m_tdWinScore[i] or 0
				totleWinscore[ncount] = self.m_totleWinScore[i] or 0				
			end
		end
	end
	--排序操作
	local bSorted = true;
	local cbLast = ncount - 1;
	repeat
		bSorted = true;
		for i=1,cbLast do
			if tdWincore[i] < tdWincore[i+1] then
				--设置标志
				bSorted = false;
				--排序权位
				sortGameid[i], sortGameid[i + 1] = sortGameid[i + 1], sortGameid[i];
				tdWincore[i],tdWincore[i + 1] = tdWincore[i + 1], tdWincore[i];
				totleWinscore[i],totleWinscore[i + 1] = totleWinscore[i + 1], totleWinscore[i];
			end
		end
		cbLast = cbLast - 1;
	until bSorted ~= false
	
	for i=1, ncount do
		local item = self.m_areaBetListView:getChildByTag(sortGameid[i])
		if (nil ~= item) then			
			for j = 1, ncount do
				if sortGameid[i] == gameid[j] then
					item:retain()				
					self.m_areaBetListView:removeItem(self.m_areaBetListView:getIndex(item))
					self.m_areaBetListView:insertCustomItem(item, pzItemCount+i-1);
					item:release()
					break
				end
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
			if dwGameID == lGameID then
				lItem:getChildByName("peishiscore"):setString(ExternalFun.formatScoreText(lscore))
				return
			end
		end
	end
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
	elseif ControlLayer.userpeizhiadd == tag then
		local GameID =  string.gsub(self.edit_UserGameID:getText(),"([^0-9])","")
		GameID = string.gsub(GameID, "[.]", "")
		local GameID_1 = tonumber(GameID)
		
		local cmddata = ExternalFun.create_netdata(Game_CMD.CMD_C_peizhiVec)
		cmddata:pushdword(GameID_1)
		self.m_parent:ControlAddPeizhi(cmddata)
		
		self.edit_UserGameID:setText("")
	elseif ControlLayer.androidxiazhuang == tag then
		self.m_parent:androidxiazhuang()
	end
	--控制次数
	for i=1,10 do
		if i == tag then
			self.m_controltimes_node:setVisible(false)
			self.m_currentTimes = i
			self.m_controlTimesText:setString(self.m_currentTimes)
		end
	end
	local bOK = false
	--控制区域
	for i=1,8 do
		if i+10 == tag then
			for j=1,8 do
				self.m_secletSymbol[j]:setVisible(false)
			end
			self.m_currentArea = i
			self.m_secletSymbol[i]:setVisible(true)		
			bOK	 = true
		end
	end
	if bOK == true then
		self:runControl()
	end
	
end
--剩余时间
function ControlLayer:showLeftTime(time)
	self.m_timeLeftText:setString(time)
end
--状态标识
function ControlLayer:showSceneTip(tag)
	
	local str = string.format("control/scene_tip_%d.png", tag)
	
	self.m_sceneTip:setVisible(false)	
	self.m_sceneTip:setTexture(str)
	self.m_sceneTip:setVisible(true)
	
end
--各区域总下注
function ControlLayer:setAreaTotalBet(index,totalScore,bAndroid)
	if bAndroid == nil then
		return
	end
	if bAndroid == 0 then
		self.m_areaTotalScore[index] = (self.m_areaTotalScore[index] or 0)+ totalScore
		self.m_areaTotalText[index]:setString(self.m_areaTotalScore[index])
	else
		self.m_areaTotalAndroidScore[index] = (self.m_areaTotalAndroidScore[index] or 0)+ totalScore
		self.m_areaTotleAndroidText[index]:setString(self.m_areaTotalAndroidScore[index])
	end

end
--断线回来显示各区域总下注
function ControlLayer:showAreaTotalBet(index,totalScore,bAndroid)
	
	if bAndroid == false then
		self.m_areaTotalScore[index] = totalScore
		self.m_areaTotalText[index]:setString(totalScore)
	else
		self.m_areaTotalAndroidScore[index] = totalScore
		self.m_areaTotleAndroidText[index]:setString(totalScore)
	end
		
end

--断线回来显示玩家各区域下注
function ControlLayer:showPlayerAreaBet(index,arealScore,dwGameID,totleBet)
	
	local item = self.m_areaBetListView:getChildByTag(dwGameID)
	if nil ~= item then
		local str = ""		
		str = string.format("Text_betScore_%d", index)
		local userScore = item:getChildByName(str)
		userScore:setString(ExternalFun.formatScoreText(arealScore))
		
		local TableBetSocre = item:getChildByName("Text_TablebetScore")
		TableBetSocre:setString(ExternalFun.formatScoreText(totleBet))		
	end
end

--清除下注
function ControlLayer:cleanAreaBet()
	for i=1,8 do
		self.m_areaTotalScore[i] = 0
		self.m_areaTotalAndroidScore[i] = 0
		self.m_areaTotalText[i]:setString("0")
		self.m_areaTotleAndroidText[i]:setString("0")
	end
	
	local lItemCount = table.maxn(self.m_areaBetListView:getItems()) 
	for i = 1,lItemCount  do
		local lItem = self.m_areaBetListView:getItem(i-1)
		if lItem ~= nil then
			for j = 1,8 do
				str = string.format("Text_betScore_%d", j)
				local userScore = lItem:getChildByName(str)
				userScore:setString(ExternalFun.formatScoreText(0))
			end
			
			local TableBetSocre = lItem:getChildByName("Text_TablebetScore")
			TableBetSocre:setString(ExternalFun.formatScoreText(0))
		
		end
	end
	
	--self.m_areaBetListView:removeAllChildren()
end
--执行命令
function ControlLayer:runControl()
	
	self.m_imageTip1:setVisible(false)
	self.m_imageTip2:setVisible(false)
	for i=1,8 do
		self.controling[i]:setVisible(false)
	end
	
	if self.m_currentTimes <=0 then
		self.m_imageTip2:setVisible(true)
		return
	end
	if self.m_currentArea <= 0 then
		self.m_imageTip1:setVisible(true)
		return
	end
	
	self.controling[self.m_currentArea]:setVisible(true)
	
	--发送消息
	local cmddata = ExternalFun.create_netdata(Game_CMD.CMD_C_AdminReq)
				
	cmddata:pushbyte(Game_CMD.RQ_SET_WIN_AREA)
	cmddata:pushbyte(self.m_currentArea)
	cmddata:pushbyte(self.m_currentTimes)
	self.m_parent:executecontrol(cmddata)
	
	
end
--取消命令
function ControlLayer:cancelRun()
	self.m_currentArea = 0
	self.m_currentTimes = 1
	for i=1,8 do		
		self.controling[i]:setVisible(false)
		self.m_secletSymbol[i]:setVisible(false)
	end
	self.m_controlTimesText:setString("1")
	self.m_controltimes_node:setVisible(false)
	self.m_imageTip1:setVisible(false)
	self.m_imageTip2:setVisible(false)
	
	--发送消息
	local cmddata = ExternalFun.create_netdata(Game_CMD.CMD_C_AdminReq)
	cmddata:pushbyte(Game_CMD.RQ_RESET_CONTROL)
	self.m_parent:executecontrol(cmddata)
		
	
	
end
--执行完控制后重置
function ControlLayer:reSetControl()
	self.m_currentArea = 0
	self.m_currentTimes = 1
	self.m_controlTimesText:setString("1")
	for i=1,8 do		
		self.controling[i]:setVisible(false)
		self.m_secletSymbol[i]:setVisible(false)
	end
	
end
--动态加入显示控制信息
function ControlLayer:OnControlstate(ControlTimes,WinArea)
	for i=1,8 do
		self.controling[i]:setVisible(false)
		self.m_secletSymbol[i]:setVisible(false)
		if WinArea[i] ~=0 then
			self.controling[WinArea[i]]:setVisible(true)
			self.m_secletSymbol[WinArea[i]]:setVisible(true)
		end
	end

--[[	if ControlTimes ~=0 then
		self.m_controlTimesText:setString(ControlTimes)
	end--]]
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
		
		item:setTag(gameID)

		local Button_gameID = item:getChildByName("Button_gameID")
		Button_gameID:setTag(gameID)
		Button_gameID:addTouchEventListener(handler(self,self.playeridbtnEvent))
	
		self.m_areaBetListView:pushBackCustomItem(item)
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
function ControlLayer:setPlayerAreaBet(gameID,cbArea,lScore,cbAndroidUser,lAllJetton)
	--不显示机器人下注
	if cbAndroidUser == 1 then 
		return
	end
	local item = self.m_areaBetListView:getChildByTag(gameID)
	if (nil == item) then
		local item = self.m_item:clone()
		local str = ""
		str = string.format("%d", gameID)
		item:getChildByName("Text_gameID"):setString(str)
		
		str = string.format("Text_betScore_%d", cbArea)
		local userScore = item:getChildByName(str)
		userScore:setString(ExternalFun.formatScoreText(lScore))
		

		local TableBetSocre = item:getChildByName("Text_TablebetScore")
		TableBetSocre:setString(ExternalFun.formatScoreText(lAllJetton))
		
		item:setTag(gameID)

		self.m_areaBetListView:pushBackCustomItem(item)
		
		print("下注玩家------",gameID,cbArea,lScore)
	else
		
		str = string.format("Text_betScore_%d", cbArea)
		local userScore = item:getChildByName(str)
		userScore:setString(ExternalFun.formatScoreText(lScore))
		
		local TableBetSocre = item:getChildByName("Text_TablebetScore")
		TableBetSocre:setString(ExternalFun.formatScoreText(lAllJetton))
	
		print("下注玩家------",gameID,cbArea,lScore)

	end
end
function ControlLayer:removeAllItem()
	self.userpeizhiListView:removeAllItems()
	self.m_areaBetListView:removeAllItems()
end
return ControlLayer