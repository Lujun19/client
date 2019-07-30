--
-- Author: zhong
-- Date: 2016-07-15 11:03:17
--
--游戏扑克层
local GameCardLayer = class("GameCardLayer", cc.Layer)
local module_pre = "game.qipai.redblack.src"
local ExternalFun = require(appdf.EXTERNAL_SRC .. "ExternalFun")
local g_var = ExternalFun.req_var;
local CardSprite = require(module_pre .. ".views.layer.gamecard.CardSprite")
local GameLogic = module_pre .. ".models.GameLogic"
local cmd = module_pre .. ".models.CMD_Game"
local bjlDefine = module_pre .. ".models.bjlGameDefine"
local AnimationMgr = appdf.req(appdf.EXTERNAL_SRC .. "AnimationMgr")

local scheduler = cc.Director:getInstance():getScheduler()

local kPointDefault = 0
local kDraw = 1 --平局
local kIdleWin = 2 --闲赢
local kMasterWin = 3 --庄赢
local DIS_SPEED = 0.5
local DELAY_TIME = 1.0
local kLEFT_ROLE = 1
local kRIGHT_ROLE = 2

function GameCardLayer:ctor(parent)
	self.m_parent = parent
	--加载csb资源
--[[	local csbNode = ExternalFun.loadCSB("game/GameCardLayer.csb",self)	
	self.m_actionNode = csbNode
	csbNode:setVisible(false)

	self.m_showCardAni = ExternalFun.loadTimeLine("game/GameCardLayer.csb")
	csbNode:runAction(self.m_showCardAni)--]]
	self.m_actionNode = ExternalFun.loadCSB("animate/Card.csb", self);
	self.m_showCardAni = ExternalFun.loadTimeLine("animate/Card.csb")
	self.m_actionNode:runAction(self.m_showCardAni)
	self.m_actionNode:move(cc.p(667,375))
--[[	--点数
	self.m_tabPoint = {}
	self.m_tabPoint[kLEFT_ROLE] = csbNode:getChildByName("FontLabel_zhong")
	self.m_tabPoint[kRIGHT_ROLE] = csbNode:getChildByName("FontLabel_bai")
	self.m_tabPoint[kLEFT_ROLE]:setVisible(false)
	self.m_tabPoint[kRIGHT_ROLE]:setVisible(false)--]]
	
	
	--四张显示数据的麻将
--[[	self.m_frontCards = {}
	local frontCardNode = csbNode:getChildByName("Node_frontCard")
	self.m_frontNode = frontCardNode
	self.m_frontNode:setVisible(false)

	self.m_frontCards[1] = {}
	self.m_frontCards[2] = {}
	self.m_frontCards[1][1] = frontCardNode:getChildByName("left_1")
	--self.m_frontCards[1][1]:setVisible(false)
	self.m_frontCards[1][2] = frontCardNode:getChildByName("left_2")
	--self.m_frontCards[1][2]:setVisible(false)
	self.m_frontCards[2][1] = frontCardNode:getChildByName("right_1")
	--self.m_frontCards[2][1]:setVisible(false)
	self.m_frontCards[2][2] = frontCardNode:getChildByName("right_2")--]]
	--self.m_frontCards[2][2]:setVisible(false)
	
	--翻牌动画
	-- AnimationMgr.loadAnimationFromFrame("dragon_card_droptile%d.png", 2, 4, cmd.SHOWCARD_ANIMATION_KEY)
end

function GameCardLayer:clean(  )

	self.m_actionNode:stopAllActions()
	self.m_actionNode:setVisible(false)

--[[	self.m_frontNode:setVisible(false)
	
	self.m_frontCards[1][1]:setVisible(false)
	self.m_frontCards[1][2]:setVisible(false)
	self.m_frontCards[2][1]:setVisible(false)
	self.m_frontCards[2][2]:setVisible(false)
	self.m_tabPoint[kLEFT_ROLE]:setVisible(false)
	self.m_tabPoint[kRIGHT_ROLE]:setVisible(false)--]]
end

function GameCardLayer:cleanCardAnimation()
	self.m_actionNode:setVisible(false)
end

function GameCardLayer:showLayer( var )
	self:setVisible(var)
	self.m_actionNode:setVisible(var)
end
function GameCardLayer:showCards( tabRes, bAni, cbTime,cbWinArea, cbTimeLeave)
	local isResult = true
	if not bAni and cbTimeLeave <= 10 then
		isResult = false
	end
	if not isResult then
		self.m_parent:updateTopCard(false)
		return
	end
	local str = ""
	local cardNode = self.m_actionNode:getChildByName("card")
	for i=1,3 do
		local cbCardData = tabRes.m_idleCards[i]
		local node = cardNode:getChildByName("cardFace_left_0" .. i)
		local sprite = node:getChildByName("faceCard")
		CardSprite:updateSprite(sprite, cbCardData)
	end
	for j=1,3 do
		local cbCardData = tabRes.m_masterCards[j]
		local node = cardNode:getChildByName("cardFace_right_0" .. j)
		local sprite = node:getChildByName("faceCard")
		CardSprite:updateSprite(sprite, cbCardData)
	end
	for k=1,2 do
		local sprite = cardNode:getChildByName("cardType_" .. k):getChildByName("sprite")
		local png = "card_" .. tabRes.m_cardsType[k] .. ".png"
		local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame(png)
		if nil ~= frame then
		   sprite:setSpriteFrame(frame)
		end
	end
	self.m_actionNode:move(cc.p(667,375))
	self.m_actionNode:setVisible(true)
	self.m_parent:updateTopCard(false)
	self.m_showCardAni:play("openCard", false)
		
	local call1 = cc.CallFunc:create(function()
		ExternalFun.playSoundEffect("dragon_flip_card.mp3")
	end)
	local call2 = cc.CallFunc:create(function()
		ExternalFun.playSoundEffect("card_" .. tabRes.m_cardsType[1].. ".mp3")
	end)
	local call3 = cc.CallFunc:create(function()
		ExternalFun.playSoundEffect("card_"  .. tabRes.m_cardsType[2].. ".mp3")
	end)
	self:runAction(cc.Sequence:create(call1,cc.DelayTime:create(0.3),call1,cc.DelayTime:create(0.3),call1,cc.DelayTime:create(0.3),call1,cc.DelayTime:create(1),call1,cc.DelayTime:create(0.3),call2,cc.DelayTime:create(1.2),call1,cc.DelayTime:create(0.6),call3))
end
	
--获取游戏结果
function GameCardLayer:getGameRecord(tabRes,cbWinArea)
	if nil ~= self.m_parent and false == yl.m_bDynamicJoin then
		--添加记录
		local rec = g_var(bjlDefine).getEmptyRecord()

        local serverrecord = g_var(bjlDefine).getEmptyServerRecord()
		serverrecord.cbGameResult = cbWinArea[1] == 1 and 0 or 2
		for i=4,9 do
			if cbWinArea[i] then
				serverrecord.cbWinType = i-1
				break
			end
		end
		if serverrecord.cbWinType == 0 then
			local winIndex = cbWinArea[1] == 1 and 1 or 2
			serverrecord.cbWinType = tabRes.m_cardsType[winIndex]
		end
        rec.m_pServerRecord = serverrecord
		rec.m_cbGameResult = serverrecord.cbGameResult

        self.m_parent:getDataMgr():addGameRecord(rec)
	end
	
end
--[[function GameCardLayer:refresh( tabRes, bAni, cbTime )
		
	self:reSet()

	local m_nTotalCount = #tabRes.m_idleCards + #tabRes.m_masterCards
	self.m_nTotalCount = m_nTotalCount
	
	local masterIdx = 1
	local idleIdx = 1
	local loopCount = m_nTotalCount - 1
	for i = 0, loopCount do
		local dis = g_var(bjlDefine).getEmptyDispatchCard()		
		if 0 ~= bit.band(i,1) then
			if nil ~= tabRes.m_masterCards[masterIdx] then
				dis.m_dir = kRIGHT_ROLE
				dis.m_cbCardData = tabRes.m_masterCards[masterIdx]
				masterIdx = masterIdx + 1
			else
				dis.m_dir = kLEFT_ROLE
				dis.m_cbCardData = tabRes.m_idleCards[idleIdx]
				idleIdx = idleIdx + 1
			end
		else
			if nil ~= tabRes.m_idleCards[idleIdx] then
				dis.m_dir = kLEFT_ROLE
				dis.m_cbCardData = tabRes.m_idleCards[idleIdx]
				idleIdx = idleIdx + 1
			else
				dis.m_dir = kRIGHT_ROLE
				dis.m_cbCardData = tabRes.m_masterCards[masterIdx]
				masterIdx = masterIdx + 1
			end
		end

		if 0 == dis.m_cbCardData then
			print("dis error")
		end		
		table.insert(self.m_vecDispatchCards, dis)
	end	
	
	self.m_bAnimation = bAni
	if bAni then
		self:switchLayout(false)
		if nil == self.m_action then 
			self:initAni()
		end
--		self.m_actionNode:stopAllActions()
		self.m_action:gotoFrameAndPlay(0,false)	
--		self.m_actionNode:runAction(self.m_action)
		ExternalFun.playSoundEffect("PK_EFECT.wav")	
	else
		--self:switchLayout(true)
		self.m_tabStatus[kLEFT_ROLE]:setVisible(true)
		self.m_tabStatus[kRIGHT_ROLE]:setVisible(true)

		--刷新点数
		self.m_tabCards[kLEFT_ROLE]:updateCardsNode(tabRes.m_idleCards, true, false)
		self.m_tabCards[kLEFT_ROLE]:setScale(0.75)
		self:refreshPoint(kLEFT_ROLE)
		
		self.m_tabCards[kRIGHT_ROLE]:updateCardsNode(tabRes.m_masterCards, true, false)
		self.m_tabCards[kRIGHT_ROLE]:setScale(0.75)
		self:refreshPoint(kRIGHT_ROLE)
		for	i = 1,#tabRes.m_idleCards do	
			print("断线回来仙家扑克数据 ====== ",tabRes.m_idleCards[i]);
		end
		for i = 1,#tabRes.m_masterCards do
			print("断线回来庄家扑克数据 ====== ",tabRes.m_masterCards[i]);
		end
		print("显示结果2222222-------")
		--self:calResult()
		self.m_vecDispatchCards = {}
	end	
end

function GameCardLayer:initAni(  )
	local act = ExternalFun.loadTimeLine("game/GameCardLayer.csb")
	self.m_action = act
	self.m_action:retain()
	local function onFrameEvent( frame )
		if nil == frame then
            return
        end        

        local str = frame:getEvent()
        print("frame event ==> "  .. str)
        if str == "end_fun" 
        and true == self.m_bAnimation
        and true == self:isVisible() then
--        	self.m_actionNode:stopAllActions()
        	self:onAnimationEnd()
        elseif str == "end_draw" then
        	self:switchLayout(true)
        end
	end
	act:setFrameEventCallFunc(onFrameEvent)
end

function GameCardLayer:reSet()
	self.m_vecDispatchCards = {}

	local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame("room_clearing_ldlefail.png")
	if nil == frame then
		frame = cc.SpriteFrameCache:getInstance():getSpriteFrame("blank.png")
	end
	--self.m_tabStatus[kLEFT_ROLE]:setSpriteFrame(frame)

	frame = cc.SpriteFrameCache:getInstance():getSpriteFrame("room_clearing_masterfail.png")
	if nil == frame then
		frame = cc.SpriteFrameCache:getInstance():getSpriteFrame("blank.png")
	end
	--self.m_tabStatus[kRIGHT_ROLE]:setSpriteFrame(frame)

	self.m_tabCards[kLEFT_ROLE]:removeAllCards()
	self.m_tabCards[kRIGHT_ROLE]:removeAllCards()

	frame = cc.SpriteFrameCache:getInstance():getSpriteFrame("blank.png")
	self.m_tabPoint[kLEFT_ROLE]:setSpriteFrame(frame)
	self.m_tabPoint[kRIGHT_ROLE]:setSpriteFrame(frame)
--	self.m_spDraw:setVisible(false)

	self.m_nTotalCount = 0
	self.m_nDispatchedCount = 0
	self.m_enPointResult = kPointDefault

	self.m_tabStatus[kLEFT_ROLE]:setPosition(334, 519)
	self.m_tabStatus[kLEFT_ROLE]:setOpacity(255)
	self.m_tabStatus[kRIGHT_ROLE]:setPosition(1000, 519)
	self.m_tabStatus[kRIGHT_ROLE]:setOpacity(255)
end

function GameCardLayer:onAnimationEnd( )
	--定时器发牌
	local function countDown(dt)
		print("发牌定时器-----");
		self:dispatchUpdate()	
	end
	if nil == self.m_scheduler then
		self.m_scheduler = scheduler:scheduleScriptFunc(countDown, DIS_SPEED, false)
	end
end

function GameCardLayer:dispatchUpdate( )
	print("self.m_vecDispatchCards-----",#self.m_vecDispatchCards)
	if 0 ~= #self.m_vecDispatchCards then
		self.m_nDispatchedCount = self.m_nDispatchedCount + 1
		local dis = self.m_vecDispatchCards[1]
		table.remove(self.m_vecDispatchCards, 1)

		local cbCard = dis.m_cbCardData
		local function callFun( sender, tab )
			self:refreshPoint(tab[1])
		end
		print("发牌------",cbCard);
		self:addCards(cbCard, dis.m_dir, cc.CallFunc:create(callFun,{dis.m_dir}))
	--	self:noticeTips()
	else
		print("显示结果1111111-------")
		--self:calResult()
		if nil ~= self.m_scheduler then
			scheduler:unscheduleScriptEntry(self.m_scheduler)
			self.m_scheduler = nil
		end	

		if nil ~= self.m_parent then
			self.m_parent:showBetAreaBlink()
		end
	end
end

function GameCardLayer:calResult( )
	--不做排序，按顺序计算
	local idleCards = self.m_tabCards[kLEFT_ROLE]:getHandCards()
	--g_var(GameLogic).SortCardList(idleCards, GameLogic.ST_ORDER)
	local idlePoint = g_var(GameLogic).GetCardListPip(idleCards)
	for i=1,#idleCards do
		print("calResult idleCards----",idleCards[i]);
	end
	local masterCards = self.m_tabCards[kRIGHT_ROLE]:getHandCards()
	--g_var(GameLogic).SortCardList(masterCards, GameLogic.ST_ORDER)
	local masterPoint = g_var(GameLogic).GetCardListPip(masterCards)
	for i=1,#masterCards do
		print("calResult masterCards----",masterCards[i]);
	end
	--点数记录
	self.m_parent:getDataMgr().m_tabGameResult.m_cbIdlePoint = idlePoint
	self.m_parent:getDataMgr().m_tabGameResult.m_cbMasterPoint = masterPoint

	local nowCBWinner = g_var(cmd).AREA_MAX
	local nowCBKingWinner = g_var(cmd).AREA_MAX

	local cbBetAreaBlink = {0,0,0,0,0,0,0,0}
	if idlePoint > masterPoint then		
		self.m_enPointResult = kIdleWin

		--闲
		nowCBWinner = g_var(cmd).AREA_XIAN
		cbBetAreaBlink[g_var(cmd).AREA_XIAN + 1] = 1
		--闲天王
		if 8 == idlePoint or 9 == idlePoint then
			nowCBKingWinner = g_var(cmd).AREA_XIAN_TIAN
			cbBetAreaBlink[g_var(cmd).AREA_XIAN_TIAN + 1] = 1
		end
	elseif idlePoint < masterPoint then
		self.m_enPointResult = kMasterWin

		--庄
		nowCBWinner = g_var(cmd).AREA_ZHUANG
		cbBetAreaBlink[g_var(cmd).AREA_ZHUANG + 1] = 1
		if 8 == masterPoint or 9 == masterPoint then
			nowCBKingWinner = g_var(cmd).AREA_ZHUANG_TIAN
			cbBetAreaBlink[g_var(cmd).AREA_ZHUANG_TIAN + 1] = 1
		end
	elseif idlePoint == masterPoint then
		self.m_enPointResult = kDraw

		--平
		nowCBWinner = g_var(cmd).AREA_PING
		cbBetAreaBlink[g_var(cmd).AREA_PING + 1] = 1
		--判断是否为同点平
		local bAllPointSame = false
		if #idleCards == #masterCards then
			local cbCardIdx = 1
			for i = cbCardIdx, #idleCards do
				local cbBankerValue = g_var(GameLogic).GetCardValue(masterCards[cbCardIdx])
				local cbIdleValue = g_var(GameLogic).GetCardValue(idleCards[cbCardIdx])

				if cbBankerValue ~= cbIdleValue then
					break
				end

				if cbCardIdx == #masterCards then
					bAllPointSame = true
				end
				cbCardIdx = cbCardIdx+1
			end
		end

		--同点平
		if true == bAllPointSame then
			nowCBKingWinner = g_var(cmd).AREA_TONG_DUI
			cbBetAreaBlink[g_var(cmd).AREA_TONG_DUI + 1] = 1
		end
	end

	--对子判断
	local nowBIdleTwoPair = false
	local nowBMasterTwoPair = false
	--闲对子
	if g_var(GameLogic).GetCardValue(idleCards[1]) == g_var(GameLogic).GetCardValue(idleCards[2]) then
		nowBIdleTwoPair = true
		cbBetAreaBlink[g_var(cmd).AREA_XIAN_DUI + 1] = 1
		ExternalFun.playSoundEffect("XianPair.wav")
	end
	--庄对子
	if g_var(GameLogic).GetCardValue(masterCards[1]) == g_var(GameLogic).GetCardValue(masterCards[2]) then
		nowBMasterTwoPair = true
		cbBetAreaBlink[g_var(cmd).AREA_ZHUANG_DUI + 1] = 1
		ExternalFun.playSoundEffect("ZhuangPair.wav")
	end
	self.m_parent:getDataMgr().m_tabBetArea = cbBetAreaBlink

	local bJoin = self.m_parent:getDataMgr().m_bJoin
	local res = self.m_parent:getDataMgr().m_tabGameResult
	if nil ~= self.m_parent and false == yl.m_bDynamicJoin then
		--添加路单记录
		local rec = g_var(bjlDefine).getEmptyRecord()

        local serverrecord = g_var(bjlDefine).getEmptyServerRecord()
        serverrecord.cbKingWinner = nowCBKingWinner
        serverrecord.bPlayerTwoPair = nowBIdleTwoPair
        serverrecord.bBankerTwoPair = nowBMasterTwoPair
        serverrecord.cbPlayerCount = idlePoint
        serverrecord.cbBankerCount = masterPoint
        rec.m_pServerRecord = serverrecord
        rec.m_cbGameResult = nowCBWinner
        
        rec.m_tagUserRecord.m_bJoin = bJoin
        if bJoin then        	
        	rec.m_tagUserRecord.m_bWin = res.m_llTotal > 0
        end

        self.m_parent:getDataMgr():addGameRecord(rec)
	end

	--刷新结果
	self:refreshResult(self.m_enPointResult)

	--播放音效
	if true == bJoin then
		--
		if res.m_llTotal > 0 then
			ExternalFun.playSoundEffect("END_WIN.wav")
		elseif res.m_llTotal < 0 then
			ExternalFun.playSoundEffect("END_LOST.wav")
		else
			ExternalFun.playSoundEffect("END_DRAW.wav")
		end
	else
		ExternalFun.playSoundEffect("END_DRAW.wav")
	end
end

function GameCardLayer:addCards( cbCard, dir, pCallBack )
	--print("on add card:" .. g_var(GameLogic).GetCardValue(cbCard) .. ";dir " .. dir)
	if nil == self.m_tabCards[dir] then
		return
	end

	if nil ~= pCallBack then
		pCallBack:retain()
	end
	self.m_tabCards[dir]:addCards(cbCard, pCallBack)
end

function GameCardLayer:refreshPoint( dir )
	if nil == self.m_tabCards[dir] then
		return
	end
	local handCards = self.m_tabCards[dir]:getHandCards()

	--切换动画
	local sca = cc.ScaleTo:create(0.2,0.0001,1.0)
	local call = cc.CallFunc:create(function ()
		local point = g_var(GameLogic).GetCardListPip(handCards)
		local str = string.format("clearing_%d.png", point)
		local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame(str)
		if nil ~= frame then
			self.m_tabPoint[dir]:setSpriteFrame(frame)
		end
	end)
	local sca2 = cc.ScaleTo:create(0.2,1.0)
	local seq = cc.Sequence:create(sca, call, sca2)
	self.m_tabPoint[dir]:stopAllActions()
	self.m_tabPoint[dir]:runAction(seq)

end

function GameCardLayer:refreshResult( enResult )
	local call_switch = cc.CallFunc:create(function()
		self:switchLayout(true)
	end)

	if kDraw == enResult then
		if nil == self.m_action then 
			self:initAni()
		end
		self.m_actionNode:stopAllActions()
		self.m_action:gotoFrameAndPlay(10,false)	
		self.m_actionNode:runAction(self.m_action)
		ExternalFun.playSoundEffect("PK_EFECT.wav")	
	elseif kIdleWin == enResult then
		local sca = cc.ScaleTo:create(0.2,0.0001,1.0)
		local call = cc.CallFunc:create(function(  )
			local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame("room_clearing_ldlewin.png")
			if nil ~= frame then
				self.m_tabStatus[kLEFT_ROLE]:setSpriteFrame(frame)
			end
		end)
		local sca2 = cc.ScaleTo:create(0.2,1.0)
		local seq = cc.Sequence:create(sca, call, sca2, cc.DelayTime:create(0.5), call_switch)
		self.m_tabStatus[kLEFT_ROLE]:stopAllActions()
		self.m_tabStatus[kLEFT_ROLE]:runAction(seq)
	elseif kMasterWin == enResult then
		local sca = cc.ScaleTo:create(0.2,0.0001,1.0)
		local call = cc.CallFunc:create(function(  )
			local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame("room_clearing_masterwin.png")
			if nil ~= frame then
				self.m_tabStatus[kRIGHT_ROLE]:setSpriteFrame(frame)
			end
		end)
		local sca2 = cc.ScaleTo:create(0.2,1.0)
		local seq = cc.Sequence:create(sca, call, sca2, cc.DelayTime:create(0.5), call_switch)
		self.m_tabStatus[kRIGHT_ROLE]:stopAllActions()
		self.m_tabStatus[kRIGHT_ROLE]:runAction(seq)
	end
end

function GameCardLayer:noticeTips(  )
	local m_nTotalCount = self.m_nTotalCount
	local m_nDispatchedCount = self.m_nDispatchedCount

	if m_nTotalCount > 4 then
		if m_nDispatchedCount >= 4 and nil ~= self.m_scheduler then
			scheduler:unscheduleScriptEntry(self.m_scheduler)
			self.m_scheduler = nil
			local call = cc.CallFunc:create(function()
				self:onAnimationEnd()
			end)
			local seq = cc.Sequence:create(cc.DelayTime:create(DELAY_TIME), call)
			self:stopAllActions()
			self:runAction(seq)
		end

		local idleCards = self.m_tabCards[kLEFT_ROLE]:getHandCards()
		--g_var(GameLogic).SortCardList(idleCards, GameLogic.ST_ORDER)
		local idlePoint = g_var(GameLogic).GetCardListPip(idleCards)

		local masterCards = self.m_tabCards[kRIGHT_ROLE]:getHandCards()
		--g_var(GameLogic).SortCardList(masterCards, GameLogic.ST_ORDER)
		local masterPoint = g_var(GameLogic).GetCardListPip(masterCards)

		local idleCount = #idleCards
		local masterCount = #masterCards
		local str = ""
		if m_nDispatchedCount == 4 then
			if idleCount == 2 and (6 == idlePoint or 7 == idlePoint) then
				str = string.format("闲前两张 %d 点,庄 %d 点,庄继续拿牌", idlePoint, masterPoint)
			elseif idleCount == 2 and idlePoint < 6 then
				str = string.format("闲 %d 点, 庄 %d 点,闲继续拿牌", idlePoint, masterPoint)
			elseif idleCount == 2 and (masterPoint >= 3 and masterPoint <= 5) then
				str = string.format("闲不补牌, 庄 %d 点,闲继续拿牌", masterPoint)
			end
		elseif m_nDispatchedCount == 5 then
			if idleCount == 3 and masterCount == 2 and m_nTotalCount == 6 then
				local cbValue = g_var(GameLogic).GetCardPip(idleCards[3])
				str = string.format("闲第三张牌 %d 点,庄 %d 点,庄继续拿牌", cbValue, masterPoint)
			end
		end

		if "" ~= str then
			showToast(self,str,1)
		end
	end
end

--调整显示界面 bDisOver 是否发牌结束
function GameCardLayer:switchLayout( bDisOver )
	if bDisOver then 
		if self.m_enPointResult == kDraw then
			self:cardMoveAni()
		else
			--状态位置挪动
			local mo = cc.MoveTo:create(0.2, cc.p(434, 519))
			self.m_tabStatus[kLEFT_ROLE]:stopAllActions()
			self.m_tabStatus[kLEFT_ROLE]:runAction(mo)

			mo = cc.MoveTo:create(0.2, cc.p(900, 519))
			local call = cc.CallFunc:create(function()
				self:cardMoveAni()
			end)
			local seq = cc.Sequence:create(mo, cc.DelayTime:create(0.5), call)
			self.m_tabStatus[kRIGHT_ROLE]:stopAllActions()
			self.m_tabStatus[kRIGHT_ROLE]:runAction(seq)
		end				
	else
		--回位
		self.m_tabCards[kLEFT_ROLE]:stopAllActions()
		self.m_tabCards[kLEFT_ROLE]:setScale(1.0)
		self.m_tabCards[kLEFT_ROLE]:setPosition(334, 400)
		self.m_tabCards[kRIGHT_ROLE]:stopAllActions()
		self.m_tabCards[kRIGHT_ROLE]:setScale(1.0)
		self.m_tabCards[kRIGHT_ROLE]:setPosition(1000, 400)	

		self.m_tabStatus[kLEFT_ROLE]:setPosition(334, 519)
		self.m_tabStatus[kLEFT_ROLE]:setOpacity(255)
		self.m_tabStatus[kRIGHT_ROLE]:setPosition(1000, 519)
		self.m_tabStatus[kRIGHT_ROLE]:setOpacity(255)

		self.m_tabPoint[kLEFT_ROLE]:setPosition(334, 296)
		self.m_tabPoint[kRIGHT_ROLE]:setPosition(1000, 296)
		self.m_spPk:setVisible(true)
	end
end

function GameCardLayer:cardMoveAni(  )
	--扑克、点数，移动位置
	self.m_tabCards[kLEFT_ROLE]:stopAllActions()
	local move = cc.MoveTo:create(0.2, cc.p(434,400))
	local scal = cc.ScaleTo:create(0.2, 0.75)
	local spa = cc.Spawn:create(move, scal)
	self.m_tabCards[kLEFT_ROLE]:runAction(spa)

	self.m_tabCards[kRIGHT_ROLE]:stopAllActions()
	move = cc.MoveTo:create(0.2, cc.p(900,400))
	scal = cc.ScaleTo:create(0.2, 0.75)
	spa = cc.Spawn:create(move, scal)
	self.m_tabCards[kRIGHT_ROLE]:runAction(spa)

	move = cc.MoveTo:create(0.2, cc.p(434,296))
	self.m_tabPoint[kLEFT_ROLE]:stopAllActions()
	self.m_tabPoint[kLEFT_ROLE]:runAction(move)

	move = cc.MoveTo:create(0.2, cc.p(900,296))
	self.m_tabPoint[kRIGHT_ROLE]:stopAllActions()
	self.m_tabPoint[kRIGHT_ROLE]:runAction(move)

	self:showAniBoard(false)
	--播放音效
	--点数
	local idlepoint = self.m_parent:getDataMgr().m_tabGameResult.m_cbIdlePoint
	local masterpoint = self.m_parent:getDataMgr().m_tabGameResult.m_cbMasterPoint
	local str1 = string.format("point_%d.mp3",idlepoint)
	local str2 = string.format("point_%d.mp3",masterpoint)
	
	local call1 = cc.CallFunc:create(function()
			ExternalFun.playSoundEffect("point_xian.mp3")
		end)	
	local call2 = cc.CallFunc:create(function()
			ExternalFun.playSoundEffect(str1)
		end)
	local call3 = cc.CallFunc:create(function()
			ExternalFun.playSoundEffect("point_zhuang.mp3")
		end)
	local call4 = cc.CallFunc:create(function()
			ExternalFun.playSoundEffect(str2)
		end)
		
	if self.m_enPointResult == kDraw then
		local call5 = cc.CallFunc:create(function()
			ExternalFun.playSoundEffect("Result_is_he.wav")
		end)	
		self:runAction(cc.Sequence:create(call1,cc.DelayTime:create(0.7),call2,cc.DelayTime:create(0.7),call3,cc.DelayTime:create(0.7),call4,cc.DelayTime:create(1.0),call5))
	elseif self.m_enPointResult == kIdleWin then
		local call6 = cc.CallFunc:create(function()
			ExternalFun.playSoundEffect("Result_is.wav")
		end)	
		local call7 = cc.CallFunc:create(function()
			ExternalFun.playSoundEffect("XianWin.wav")
		end)
		self:runAction(cc.Sequence:create(call1,cc.DelayTime:create(0.7),call2,cc.DelayTime:create(0.7),call3,cc.DelayTime:create(0.7),call4,cc.DelayTime:create(1.0),call6,cc.DelayTime:create(1.0),call7))
	elseif self.m_enPointResult == kMasterWin then
		local call8 = cc.CallFunc:create(function()
			ExternalFun.playSoundEffect("Result_is.wav")
		end)
		local call9 = cc.CallFunc:create(function()
			ExternalFun.playSoundEffect("ZhuangWin.wav")
		end)
		self:runAction(cc.Sequence:create(call1,cc.DelayTime:create(0.7),call2,cc.DelayTime:create(0.7),call3,cc.DelayTime:create(0.7),call4,cc.DelayTime:create(1.0),call8,cc.DelayTime:create(1.0),call9))

	end
end

function GameCardLayer:showAniBoard( bShow )
--	self.m_spLeftBoard:setVisible(bShow)
--	self.m_spRightBoard:setVisible(bShow)
--	self.m_spPk:setVisible(bShow)
end--]]

return GameCardLayer