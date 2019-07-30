--
-- Author: zhong
-- Date: 2016-07-12 17:03:14
--
--路单界面
local module_pre = "game.qipai.redblack.src";
local ExternalFun = require(appdf.EXTERNAL_SRC .. "ExternalFun")
local g_var = ExternalFun.req_var;
local cmd = require(module_pre .. ".models.CMD_Game")

local WallBillLayer = class("WallBillLayer", cc.Layer)
local BT_CLOSE = 101

function WallBillLayer:ctor(viewparent)
	--注册事件
	local function onLayoutEvent( event )
		if event == "exit" then
			self:onExit();
        elseif event == "enterTransitionFinish" then
        	self:onEnterTransitionFinish();
        end
	end
	self:registerScriptHandler(onLayoutEvent);
	--按钮事件
	local function btnEvent( sender, eventType )
		if eventType == ccui.TouchEventType.ended then
			self:onButtonClickedEvent(sender:getTag(), sender)
		end
	end
	self.m_parent = viewparent

	self.m_spRecord = {}
	for i = 1, 20 do
		self.m_spRecord[i] = {}
		for j = 1, 6 do
			self.m_spRecord[i][j] = nil
		end
	end
	self.m_recordWin = {}
	self.m_recordWinType = {}

--[[	self.m_spRecord2 = {}
	for i = 1, 14 do
		self.m_spRecord2[i] = {}
		for j = 1, 6 do
			self.m_spRecord2[i][j] = nil
		end
	end--]]

	--加载csb资源
	local csbNode = ExternalFun.loadCSB("game/WallBill.csb", self)
	
	--统计数据
	self.m_layoutSettle = csbNode:getChildByName("settle_layout")
    self.m_textBlackSettle = self.m_layoutSettle:getChildByName("black_settle")
    self.m_textRedSettle = self.m_layoutSettle:getChildByName("red_settle")
--[[	self.m_textPingSettle = self.m_layoutSettle:getChildByName("ping_settle")
    
    self.m_textXianDoubleCount = self.m_layoutSettle:getChildByName("xiandouble_count")
    self.m_textZhuangDoubleCount = self.m_layoutSettle:getChildByName("zhuangdouble_count")
    self.m_textXianTianCount = self.m_layoutSettle:getChildByName("xiantian_count")
    self.m_textZhuangTianCount = self.m_layoutSettle:getChildByName("zhuangtian_count")--]]

	--简易路单
	local m_layoutBillSp = csbNode:getChildByName("bill_layout")
	local str = ""
	local idx = 0
	for i = 1, 20 do
		idx = i - 1
		str = string.format("record%d_sp", idx)
		self.m_spRecord[i][1] = m_layoutBillSp:getChildByName(str)
	end
	self.m_layoutBillSp = m_layoutBillSp
	
	local recent_result_layout = csbNode:getChildByName("recent_result_layout")
	for i=1,20 do
		str1 = string.format("Sprite_win_%d", i)
		self.m_recordWin[i] = recent_result_layout:getChildByName(str1)
		self.m_recordWin[i]:setVisible(false)
	end
	for i=1,20 do
		str2 = string.format("Sprite_win_type_%d", i)
		self.m_recordWinType[i] = recent_result_layout:getChildByName(str2)
		self.m_recordWinType[i]:setVisible(false)
	end

--[[	--路单
	local m_layoutBillSp2 = csbNode:getChildByName("bill2_layout")
	idx = 0
	for i = 1, 14 do
		idx = i - 1
		str = string.format("record%d_sp", idx)
		self.m_spRecord2[i][1] = m_layoutBillSp2:getChildByName(str)
	end
	self.m_layoutBillSp2 = m_layoutBillSp2--]]
	--关闭按钮
	local btn = csbNode:getChildByName("baseNode"):getChildByName("close_btn")
	btn:setTag(BT_CLOSE)
	btn:addTouchEventListener(btnEvent)
	--位置
	self.m_vec2Pos = {}
	idx = 0
	for i = 1, 6 do
		idx = i - 1
		self.m_vec2Pos[i] = 437 - idx * 31
	end
	self.m_spBg = csbNode:getChildByName("baseNode"):getChildByName("bg")

	self:reSet()
end

function WallBillLayer:onButtonClickedEvent(tag,ref)
	ExternalFun.playClickEffect()
	if tag == BT_CLOSE then
		self:showLayer(false)
	else
		showToast(self,"功能尚未开放！",1)
	end
end

function WallBillLayer:onEnterTransitionFinish()
	self:registerTouch()
end

function WallBillLayer:onExit()
	local eventDispatcher = self:getEventDispatcher()
	eventDispatcher:removeEventListener(self.listener)
end

function WallBillLayer:registerTouch(  )
	local function onTouchBegan( touch, event )
		return self:isVisible()
	end

	local function onTouchEnded( touch, event )
		local pos = touch:getLocation();
		local m_spBg = self.m_spBg
        pos = m_spBg:convertToNodeSpace(pos)
        local rec = cc.rect(0, 0, m_spBg:getContentSize().width, m_spBg:getContentSize().height)
        if false == cc.rectContainsPoint(rec, pos) then
            self:showLayer(false)
        end        
	end

	local listener = cc.EventListenerTouchOneByOne:create();
	listener:setSwallowTouches(true)
	self.listener = listener;
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN );
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED );
    local eventDispatcher = self:getEventDispatcher();
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self);
end

function WallBillLayer:showLayer( var )
	self:setVisible(var)
end

function WallBillLayer:reSet(  )
	local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame("rbBlank.png")
	if nil == frame then
		return
	end

	for i = 1, 20 do
		for j = 1, 6 do
			if nil ~= self.m_spRecord[i][j] then				
				self.m_spRecord[i][j]:setSpriteFrame(frame)
			end
		end
	end
	for i=1,20 do
		self.m_recordWin[i]:setSpriteFrame(frame)
		self.m_recordWin[i]:setVisible(false)
	end
	for i=1,20 do
		self.m_recordWinType[i]:setSpriteFrame(frame)
		self.m_recordWinType[i]:setVisible(false)
	end

--[[	for i = 1, 14 do
		for j = 1, 6 do
			if nil ~= self.m_spRecord2[i][j] then
				self.m_spRecord2[i][j]:setSpriteFrame(frame)
			end
		end
	end--]]

	self.m_textBlackSettle:setString("")
--    self.m_textPingSettle:setString("")
    self.m_textRedSettle:setString("")
    
--    self.m_textXianDoubleCount:setString("")
--    self.m_textZhuangDoubleCount:setString("")
--    self.m_textXianTianCount:setString("")
--    self.m_textZhuangTianCount:setString("")
end

function WallBillLayer:refreshWallBillList(  )
	if nil == self.m_parent then
		return
	end
	local mgr = self.m_parent:getDataMgr()
	self:reSet()
	self:refreshList()

	--[[--统计数据
	local vec = mgr:getRecords()
	local nTotal = #vec
	local nXian = 0
	local nZhuang = 0
	local nPing = 0
	local nXianDouble = 0
	local nZhuangDouble = 0
	local nXianTian = 0
	local nZhuangTian = 0
	for i = 1, nTotal do
		local rec = vec[i]
		if cmd.AREA_XIAN == rec.m_cbGameResult then
			nXian = nXian + 1
		elseif cmd.AREA_ZHUANG == rec.m_cbGameResult then
			nZhuang = nZhuang + 1
		end

		if rec.m_pServerRecord.bBankerTwoPair then
			nZhuangDouble = nZhuangDouble + 1
		end

		if rec.m_pServerRecord.bPlayerTwoPair then
			nXianDouble = nXianDouble + 1
		end

		if cmd.AREA_XIAN_TIAN == rec.m_pServerRecord.cbKingWinner then
			nXianTian = nXianTian + 1
		end

		if cmd.AREA_ZHUANG_TIAN == rec.m_pServerRecord.cbKingWinner then
			nZhuangTian = nZhuangTian + 1
		end
	end

	local per = (nXian / nTotal) * 100
	local str = string.format("%d    %.2f%%", nXian, per)
	self.m_textBlackSettle:setString(str)

	per = (nPing / nTotal) * 100
	str = string.format("%d    %.2f%%", nPing, per)
	self.m_textPingSettle:setString(str)

	per = (nZhuang/nTotal) * 100
	str = string.format("%d    %.2f%%", nZhuang, per)
	self.m_textRedSettle:setString(str)

	str = string.format("%d", nXianDouble)
	self.m_textXianDoubleCount:setString(str)

	str = string.format("%d", nZhuangDouble)
	self.m_textZhuangDoubleCount:setString(str)

	str = string.format("%d", nXianTian)
	self.m_textXianTianCount:setString(str)

	str = string.format("%d", nZhuangTian)
	self.m_textZhuangTianCount:setString(str)--]]

	self:showLayer(true)
end

function WallBillLayer:refreshList(  )
	if nil == self.m_parent then
		return
	end	
	local mgr = self.m_parent:getDataMgr()
	local vec = mgr:getWallBills()
	local walllen = #vec
	self.m_nBeginIdx = 1
	if walllen > 19 then
		self.m_nBeginIdx = walllen - 19
	end

	local nCount = 1
	local str = ""
	for i = self.m_nBeginIdx, walllen do
		if nCount > 20 then
			break
		end
		local bill = vec[i]
		for j = 1, bill.m_cbIndex do
			--数量控制
			if j > 5 then
				break
			end

			str = ""
			if cmd.AREA_BLACK == bill.m_pRecords[j] then
				str = "h3card_pailu_hei.png"
			elseif cmd.AREA_RED == bill.m_pRecords[j] then
				str = "h3card_pailu_hong.png"
			end
			local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame(str)
			if nil ~= frame then
				if nil == self.m_spRecord[nCount][j] then
					self.m_spRecord[nCount][j] = cc.Sprite:createWithSpriteFrame(frame)
					self.m_layoutBillSp:addChild(self.m_spRecord[nCount][j])
				else
					self.m_spRecord[nCount][j]:setSpriteFrame(frame)
				end
				local pos = cc.p(self.m_spRecord[nCount][1]:getPositionX(), self.m_vec2Pos[j])
				self.m_spRecord[nCount][j]:setPosition(pos)
			end
		end

		if bill.m_bWinList then
			if cmd.AREA_BLACK == bill.m_pRecords[6] then
				str = "h3card_pailu_hei.png"
			elseif cmd.AREA_RED == bill.m_pRecords[6] then
				str = "h3card_pailu_hong.png"
			end

            local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame(str)
            if nil ~= frame then
            	if nil == self.m_spRecord[nCount][6] then
					self.m_spRecord[nCount][6] = cc.Sprite:createWithSpriteFrame(frame)
					self.m_layoutBillSp:addChild(self.m_spRecord[nCount][6])
				else
					self.m_spRecord[nCount][6]:setSpriteFrame(frame)
				end
				local pos = cc.p(self.m_spRecord[nCount][1]:getPositionX(), self.m_vec2Pos[6])
				self.m_spRecord[nCount][6]:setPosition(pos)
           	end       
		end

		nCount = nCount + 1
	end

	local vec2 = mgr:getRecords()
	local len = #vec2
	local nCount = 1
	local index = 1
	local str1 = ""
	local str2 = ""
	if len>19 then
		index = len - 19
	end
	
	local blackWinNum = 0
	local redWinNum = 0
	for i = len,index,-1 do
		local rec = vec2[i]
		self.m_recordWin[nCount]:setVisible(true)
		if cmd.AREA_BLACK == rec.m_cbGameResult then
			str1 = "h3card_pailu_black.png"
			blackWinNum = blackWinNum + 1
		elseif cmd.AREA_RED == rec.m_cbGameResult then
			str1 = "h3card_pailu_red.png"
			redWinNum = redWinNum + 1
		end
		local frame1 = cc.SpriteFrameCache:getInstance():getSpriteFrame(str1)
		if nil ~= frame1 then			
			self.m_recordWin[nCount]:setSpriteFrame(frame1)
		end
		nCount = nCount+1
	end
	if len > 0 then
		local maxNum = math.min(len, 20)
		local blackRate = blackWinNum*100/maxNum
		blackRate = math.ceil(blackRate) == blackRate and blackRate or math.ceil(blackRate) - 1
		self.m_textBlackSettle:setString(blackRate .. "%")
		local redRate = redWinNum*100/maxNum
		redRate = math.ceil(redRate) == redRate and redRate or math.ceil(redRate) - 1
		self.m_textRedSettle:setString(redRate .. "%")
	end
	
	if len>19 then
		index = len - 19
	end
	 nCount = 1
	if len%2 ~= 0 then
		nCount = 2
		if len > 19 then
			index = index + 1
		end
	end
	for i = len,index,-1 do
		local rec = vec2[i]
		self.m_recordWinType[nCount]:setVisible(true)
		str2 = "record_type_" .. rec.m_pServerRecord.cbWinType .. ".png"
		local frame2 = cc.SpriteFrameCache:getInstance():getSpriteFrame(str2)
		if nil ~= frame2 then
			self.m_recordWinType[nCount]:setSpriteFrame(frame2)
		end
		nCount = nCount+1
	end
end
return WallBillLayer