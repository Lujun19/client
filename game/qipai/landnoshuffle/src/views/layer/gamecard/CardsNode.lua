--
-- Author: zhong
-- Date: 2016-06-27 09:42:21
--
local module_pre = "game.qipai.landnoshuffle.src"
local CardSprite = appdf.req(module_pre .. ".views.layer.gamecard.CardSprite")
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local cmd = appdf.req(module_pre .. ".models.CMD_Game")
local GameLogic = appdf.req(module_pre .. ".models.GameLogic")

--横向间隔
local CARD_X_DIS = 66
local CARD_X_DIS_ADD_ONE = 2			-- 多一张牌的间距
--local CARD_X_DIS_ADD = 60
--纵向间隔
local CARD_Y_DIS = 25

local ANI_BEGIN = 0.1
--弹出动画
local CARD_SHOOT_TIME = 0.2
--弹回动画
local CARD_BACK_TIME = 0.2
--地主牌弹回动画
local BANKER_CARD_BACK_TIME = 1.6
--弹出距离
local CARD_SHOOT_DIS = 30
--最低叠放层级
local MIN_DRAW_ORDER = 0
--最高叠放层级
local MAX_DRAW_ORDER = 20
--过滤模式
local kHIGHEST = 1
local kLOWEST = 2
--拖动方向
local kMoveNull = 0
local kMoveToLeft = 1
local kMoveToRight = 2
-- 自己扑克尺寸
local CARD_SHOW_SCALE = 1.0
-- 非自己扑克尺寸
local CARD_HIDE_SCALE = 0.5
-- 亮牌尺寸
local CARD_LEFT_SCALE = 0.5

local function ANI_RATE( var )
	return var * 0.05
end

local CardsNode = class("CardsNode", cc.Node)
CardsNode.CARD_X_DIS = CARD_X_DIS
CardsNode.CARD_Y_DIS = CARD_Y_DIS
CardsNode.CARD_X_DIS_ADD_ONE = CARD_X_DIS_ADD_ONE

function CardsNode:ctor()
	ExternalFun.registerTouchEvent(self)

	--扑克管理
	self.m_mapCard = {}
	self.m_vecCard = {}
	--扑克数据
	self.m_cardsData = {}
	self.m_cardsHolder = nil

	--视图id
	self.m_nViewId = cmd.INVALID_VIEWID
	--是否可点击
	self.m_bClickable = false
	--是否发牌
	self.m_bDispatching = false
	--提示出牌
	self.m_bSuggested = false

	------
	-- 扑克操控

	--开始点击位置
	self.m_beginTouchPoint = cc.p(0,0)
	--开始点击选牌
	self.m_beginSelectCard = nil
	--结束点击选牌
	self.m_endSelectCard = nil
	--是否拖动
	self.m_bDragCard = false
	--是否触摸
	self.m_bTouched = false
	--拖动方向
	self.m_dragMoveDir = kMoveNull

	--选牌管理
	self.m_mapSelectedCards = {}
	--拖动选择
	self.m_mapDragSelectCards = {}
	--选择扑克
	self.m_tSelectCards = {}

	--回调监听
	self.m_pSelectedListener = nil
	-- 扑克操控
	------
end

function CardsNode:createEmptyCardsNode(viewId)
	local node = CardsNode.new()
	if nil ~= node and node:init() then
		node.m_nViewId = viewId
		node.m_bClickable = (viewId == cmd.MY_VIEWID)
		node:addCardsHolder()

		return node
	end
	return nil;
end

--[[function CardsNode:createCardsNode(viewId, cards, isShowCard)
	local node = CardsNode.new()
	if nil ~= node and node:init() then
		node.m_nViewId = viewId
		node.m_bClickable = (viewId == cmd.MY_VIEWID)
		node:addCardsHolder()
		node:updateCardsNode(cards, isShowCard, false, nil)		

		return node
	end
	return nil
end--]]

function CardsNode:setListener( pNode )
	self.m_pSelectedListener = pNode
end

function CardsNode:onExit()
	self:removeAllCards()

	self.m_pSelectedListener = nil
end

function CardsNode:onTouchBegan(touch, event)
	if false == self:isVisible() or false == self.m_bClickable or true == self.m_bDispatching then
		return false
	end
	local location = touch:getLocation()

	self.m_endSelectCard = nil
	self.m_bDragCard = false
	self.m_beginTouchPoint = self:convertToNodeSpace(location)
	self.m_beginSelectCard = self:filterCard(kHIGHEST, location)
	if nil ~= self.m_beginSelectCard 
		and nil ~= self.m_beginSelectCard.getCardData then
		--选牌效果
		self.m_beginSelectCard:showSelectEffect(true)
		self.m_mapSelectedCards[self.m_beginSelectCard:getCardData()] = self.m_beginSelectCard
	end
	self.m_bTouched = (self.m_beginSelectCard ~= nil)
	return true
end

function CardsNode:onTouchMoved(touch, event)
	if true == self.m_bTouched then
		local location = touch:getLocation()

		self.m_endSelectCard = self:filterCard(kHIGHEST, location)
		self.m_bDragCard = true
		local touchRect = self:makeTouchRect(self:convertToNodeSpace(location))

		--筛选在触摸区域内的卡牌
		local mapTouchCards = self:inTouchAreaCards(touchRect)

		--过滤有效卡牌,选择叠放最高
		if type(mapTouchCards) ~= "table" or 0 == table.nums(mapTouchCards) then
			return
		end

		if nil ~= self.m_endSelectCard 
			and nil ~= self.m_endSelectCard.getCardData then			
			--拖动选择
			if false == self.m_endSelectCard:getCardDragSelect() then
				self.m_endSelectCard:showSelectEffect(true)
				self.m_endSelectCard:setCardDragSelect(true)
				if nil ~= self.m_beginSelectCard 
					and self.m_beginSelectCard:getCardData() ~= self.m_endSelectCard:getCardData() then
					self.m_mapDragSelectCards[self.m_endSelectCard:getCardData()] = self.m_endSelectCard
				end
			end
		end

		--剔除不在触摸区域内，但已选择的卡牌
		for k,v in pairs(self.m_mapDragSelectCards) do
			local tmpCard = mapTouchCards[k]
			if nil == tmpCard then
				self.m_mapDragSelectCards[k]:setCardDragSelect(false)
				self.m_mapDragSelectCards[k]:showSelectEffect(false)
				self.m_mapDragSelectCards[k] = nil
			end
		end	
	end
end

function CardsNode:onTouchEnded(touch, event)
	if true == self.m_bTouched then
		local location = touch:getLocation()

		self.m_endSelectCard = self:filterCard(kHIGHEST, location)
		if false == self.m_bDragCard then
			if nil ~= self.m_endSelectCard 
				and nil ~= self.m_endSelectCard.getCardData then
				self.m_endSelectCard:setCardDragSelect(true)

				if nil ~= self.m_beginSelectCard
					and nil ~= self.m_beginSelectCard.getCardData
					and self.m_beginSelectCard:getCardData() ~= self.m_endSelectCard:getCardData() then
					self.m_mapSelectedCards[self.m_endSelectCard:getCardData()] = self.m_endSelectCard
				end
			end
			--选牌音效
			ExternalFun.playSoundEffect("button.wav")
		end

		--选牌效果
		if nil ~= self.m_beginSelectCard then
			self.m_beginSelectCard:showSelectEffect(false)
		end
	end

	local vecSelectCard = self:filterDragSelectCards(self.m_bTouched)
	local m_tSelectCards = {}
	local tmp_cards = {}
	for k,v in pairs(vecSelectCard) do
		if nil ~= v and nil ~= v.getCardData then
			table.insert(m_tSelectCards, v:getCardData())
			tmp_cards[v:getCardData()] = v
		end		
	end
	local result = GameLogic:SearchOutCardTouch(m_tSelectCards, #m_tSelectCards, {}, 0)
	 --dump(result, "出牌提示", 6)    
    local resultCount = result[1]
    print("## 选中牌组 " .. resultCount)
	local newVecSelectCard = {}
	if resultCount == 0 then
		newVecSelectCard = vecSelectCard
		self:dragCards(newVecSelectCard)
	else
		local tmplist = {}
		local total = result[2][1]
		local cards = result[3][1]
		for j = 1, total do
			local cbCardData = cards[j] or 0
			table.insert(tmplist, cbCardData)
			table.insert(newVecSelectCard, tmp_cards[cbCardData])
			tmp_cards[cbCardData] = nil
		end
		self:dragCards(newVecSelectCard, tmp_cards)
	end
	if true == self.m_bSuggested then
		self.m_bSuggested = (0 ~= table.nums(self.m_mapSelectedCards))
	end
	self.m_beginSelectCard = nil
    self.m_endSelectCard = nil
    self.m_bDragCard = false
    self.m_bTouched = false
end

function CardsNode:onTouchCancelled(touch, event)
end

-- 更新
-- @param[cards] 新的扑克数据
-- @param[isShowCard] 是否显示正面
-- @param[bAnimation] 是否动画效果
-- @param[pCallBack] 更新回调
-- 发牌动画
function CardsNode:updateCardsNode( cards, isShowCard, bAnimation, pCallBack)
	if type(cards) ~= "table"  then
		return
	end

	local m_cardsData = cards
	local m_cardCount = #cards
	bAnimation = bAnimation or false
	isShowCard = isShowCard or false

	if 0 == m_cardCount then
		print("count = 0")
		return
	end	

	self.m_bAddCards = false
	self.m_bDispatching = true

	self:removeAllCards()
	self:reSetCards()
	self.m_cardsData = m_cardsData
	self.m_cardsCount = m_cardCount
	self.m_bShowCard = isShowCard

	--转换为相对于自己的中间位置
	local winSize = cc.Director:getInstance():getWinSize()
	local centerPos = cc.p(winSize.width * 0.5, winSize.height * 0.62)
	centerPos = self:convertToNodeSpace(centerPos)
	local toPos = centerPos

	local mapKey = 0
	local m_cardsHolder = self.m_cardsHolder

	if cmd.LEFT_VIEWID == self.m_nViewId then
		toPos = self:convertToNodeSpace(cc.p(winSize.width * 0.3, winSize.height * 0.62))
	elseif cmd.RIGHT_VIEWID == self.m_nViewId then
		toPos = self:convertToNodeSpace(cc.p(winSize.width * 0.7, winSize.height * 0.62))
	end
	m_cardsData = GameLogic:SortCardList(m_cardsData, m_cardCount, 0)
	--创建扑克
	for i = 1, m_cardCount do
		local tmpSp = CardSprite:createCard(m_cardsData[i])
		tmpSp:setPosition(centerPos)
		tmpSp:setDispatched(false)
		tmpSp:showCardBack(true)
		m_cardsHolder:addChild(tmpSp)
		if 0 == m_cardsData[i] then
			mapKey = i
		else
			mapKey = m_cardsData[i]
		end
		self.m_mapCard[mapKey] = tmpSp
	end
	--运行动画
	if ((cmd.RIGHT_VIEWID == self.m_nViewId) 
		or (cmd.LEFT_VIEWID == self.m_nViewId)
		or (cmd.MY_VIEWID == self.m_nViewId))
		and (true == bAnimation) then
		self:arrangeAllCards({bAnimation=false,pCallBack=pCallBack})
		-- for i = 1, m_cardCount do
		-- 	local key = (m_cardsData[i] ~= 0) and m_cardsData[i] or i
		-- 	local tmpSp = self.m_mapCard[key]

		-- 	if nil ~= tmpSp then
		-- 		-- 洗牌动画
		-- 		local moveTo = cc.MoveTo:create((0.3 + i / 16)*0.3, toPos)
		-- 		local backTo = cc.MoveTo:create(0.3*0.3, centerPos)
		-- 		local seq = nil
		-- 		if i == m_cardCount then
		-- 			seq = cc.Sequence:create(moveTo, backTo, cc.CallFunc:create(function()
		-- 				self:arrangeAllCards({bAnimation=bAnimation,pCallBack=pCallBack})
		-- 			end))
		-- 		else
		-- 			seq = cc.Sequence:create(moveTo, backTo)
		-- 		end

		-- 		tmpSp:stopAllActions()
		-- 		tmpSp:runAction(seq)
		-- 	end			
		-- end
	else
		self:arrangeAllCards({bAnimation=false,pCallBack=pCallBack})
	end
end

--[[-- 更新
-- @param[cards] 新扑克数据
function CardsNode:updateCardsData( cards )
	if type(cards) ~= "table"  then
		return
	end

	local m_cardsData = cards
	self.m_cardsData = m_cardsData
	self.m_cardsCount = #m_cardsData

	local vecChildren = self.m_cardsHolder:getChildren()
	self.m_mapCard = {}

	--数量检查
	if #vecChildren ~= #cards then
		print("children count " .. #vecChildren .. " cards count " .. #cards)
		return
	end

	for k,v in pairs(vecChildren) do
		local cbCardData = m_cardsData[k]
		v:setCardValue(cbCardData)
		self.m_mapCard[cbCardData] = v
	end
end--]]

-- 加牌
function CardsNode:addCards( addCards, handCards )
	if type(addCards) ~= "table"  then
		return
	end

	local tmpcount = #handCards
	self.m_cardsData = handCards	
	if tmpcount > cmd.MAX_COUNT then
		print("超出最大牌数")
		return
	end

	--转换为相对于自己的中间位置
	local winSize = cc.Director:getInstance():getWinSize()
	local centerPos = cc.p(winSize.width * 0.5, winSize.height * 0.62)
	centerPos = self:convertToNodeSpace(centerPos)
	local banker_card_key_array = {}
	for i = 1, #addCards do
		local tmpSp = CardSprite:createCard(addCards[i])
		tmpSp:setPosition(centerPos)
		tmpSp:setDispatched(false)
		tmpSp:showCardBack(true)
		self.m_cardsHolder:addChild(tmpSp)
		if 0 == self.m_cardsData[i] then
			mapKey = self.m_cardsCount + i
		else
			mapKey = addCards[i]
		end
		table.insert(banker_card_key_array, mapKey)
		self.m_mapCard[mapKey] = tmpSp
	end
	self.m_cardsCount = tmpcount
	self:arrangeAllCards({bAnimation=true, banker_card_key_array=banker_card_key_array})
end

-- 出牌
-- @param[cards] 	 	出牌
-- @param[bNoSubCount]	不减少牌数
-- @return 需要移除的牌精灵
function CardsNode:outCard( cards, bNoSubCount )
	bNoSubCount = bNoSubCount or false
	if type(cards) ~= "table"  then
		return
	end

	local vecOut = {}
	local outCount = #cards
	local handCount = self.m_cardsCount
	local m_cardsHolder = self.m_cardsHolder

	local bOutOk = false
	local haveCardData = self.m_nViewId == cmd.MY_VIEWID
	if 0 ~= handCount and haveCardData then
		self.m_bDispatching = true
		for k,v in pairs(cards) do
            local removeIdx = nil
            for k1,v1 in pairs(self.m_cardsData) do            
                if v == v1 then
                    removeIdx = k1
                end
            end
            if nil ~= removeIdx then
                table.remove(self.m_cardsData, removeIdx)
            end
        end
        self.m_cardsCount = #self.m_cardsData

		for i = 1, outCount do
			local tag = cards[i]
			--print("***** 出牌:" .. yl.POKER_VALUE[tag])
			local tmpSp = m_cardsHolder:getChildByTag(tag)
			if nil ~= tmpSp then
				table.insert(vecOut, tmpSp)
			end

			self.m_mapCard[tag] = nil
		end
		bOutOk = true
		self:reSortCards()
	elseif not bNoSubCount then
		local afterCards = {}
        for i = 1, self.m_cardsCount - outCount do
            table.insert(afterCards, 0)
        end
        self.m_cardsData = afterCards
        self.m_cardsCount = #self.m_cardsData

		local vecChildren = m_cardsHolder:getChildren()
		if 0 ~= #vecChildren then
			for i = 1, outCount do
				local tag = cards[i]
				--print("##### 出牌:" .. yl.POKER_VALUE[tag])
				local tmpSp = vecChildren[i]
				if nil ~= tmpSp then
					if tmpSp:getTag() ~= tag then
						tmpSp:setCardValue(tag)
					end
					table.insert(vecOut, tmpSp)
				end

				self.m_mapCard[tag] = nil
			end
			bOutOk = true
		end			
	end

	if not bOutOk then
		for i = 1, outCount do
			local cbCardData = cards[i] or 0
			local tmpSp = CardSprite:createCard(cbCardData)
			tmpSp:setPosition(0, 0)
			tmpSp:showCardBack(true)
			tmpSp:setScale(CARD_HIDE_SCALE)
			m_cardsHolder:addChild(tmpSp)
			table.insert(vecOut, tmpSp)
		end
	end

	--清除选中
	for k,v in pairs(self.m_mapSelectedCards) do 
		v:showSelectEffect(false)
		v:setCardDragSelect(false)
		v:setPositionY(0)
	end
	for k,v in pairs(self.m_mapDragSelectCards) do 
		v:showSelectEffect(false)
		v:setCardDragSelect(false)
		v:setPositionY(0)
	end
	self.m_mapSelectedCards = {}
	self.m_mapDragSelectCards = {}
	self.m_tSelectCards = {}
	self.m_bSuggested = false

	--变动通知
	if nil ~= self.m_pSelectedListener and nil ~= self.m_pSelectedListener.onCountChange then
		self.m_pSelectedListener:onCountChange( self.m_cardsCount, self, true )
	end
	return vecOut
end

-- 主动出牌(单张/对子的时候主动出牌)
function CardsNode:autoOutCard()
end

-- 显示扑克
function CardsNode:showCards()
	for k,v in pairs(self.m_mapCard) do
		if nil ~= v and nil ~= v.showCardBack then
			v:showCardBack(false)
		end		
	end
end

-- 结算显示
-- @param[cards] 实际扑克数据
function CardsNode:showLeftCards( cards )
	if type(cards) ~= "table"  then
		return
	end

	if cmd.MY_VIEWID == self.m_nViewId then
		return
	end
	dump(cards, "left cards", 6)

	local vecChildren = self.m_cardsHolder:getChildren()
	local num = 1
	local center = 0
	if cmd.RIGHT_VIEWID == self.m_nViewId then
		center = #vecChildren
		num = -1
	end

	if #cards <= self.m_cardsCount then
		for i = 1, self.m_cardsCount do
			local cbCardData = cards[i]
			local tmp = vecChildren[i]
			if nil ~= tmp then
				tmp:setCardValue(cbCardData)
				tmp:setScale(0.4)   --缩放0.4倍
				-- 牌间距缩小为52
				local pos = cc.p((i - center) * 52/2 + num * 100, -106)   -- 调整结算牌的位置
				local moveTo = cc.MoveTo:create(0.5 + i / 16, pos)
				local call = cc.CallFunc:create(function ()
					tmp:showCardBack(false)
				end)
				local spa = cc.Spawn:create(moveTo, call)
				tmp:stopAllActions()
				tmp:runAction(spa)
			end
		end
	end
	--变动通知
	if nil ~= self.m_pSelectedListener and nil ~= self.m_pSelectedListener.onCountChange then
		self.m_pSelectedListener:onCountChange( self.m_cardsCount, self )
	end
end

-- 重置
function CardsNode:reSetCards()
	self.m_beginSelectCard = nil
	self.m_endSelectCard = nil

	self:dragCards(self:filterDragSelectCards(false))
	self.m_mapSelectedCards = {}
	self.m_mapDragSelectCards = {}

	self.m_bSuggested = false
end

-- 提示弹出
-- @param[cards] 提示牌
function CardsNode:suggestShootCards( cards )
	if type(cards) ~= "table"  then
		return
	end

	if false == self.m_bTouched then
		self.m_beginSelectCard = nil
		self.m_endSelectCard = nil
	end

	--更新已选择扑克
	self:dragCards(self:filterDragSelectCards(false))
	self.m_mapSelectedCards = {}
	self.m_mapDragSelectCards = {}

	if false == self.m_bSuggested then
		local count = #cards
		for i = 1, count do
			local cbCardData = cards[i]
			local tmp = self.m_mapCard[cbCardData]
			if nil ~= tmp then
				tmp:setCardDragSelect(true)
				self.m_mapSelectedCards[cbCardData] = tmp
			end
		end
		self:dragCards(self:filterDragSelectCards(false))
	end
	self.m_bSuggested = not self.m_bSuggested
end

function CardsNode:getSelectCards()
	return self.m_tSelectCards
end

function CardsNode:getHandCards(  )
	return self.m_cardsData
end

--
function CardsNode:addCardsHolder(  )
	if nil == self.m_cardsHolder then
		self.m_cardsHolder = cc.Node:create();
		self:addChild(self.m_cardsHolder);
	end
end

function CardsNode:removeAllCards()
	self.m_mapCard = {}
	self.m_vecCard = {}
	if nil ~= self.m_cardsHolder then
		self.m_cardsHolder:removeAllChildren();
	end
	self.m_cardsData = {}
end

-- 自己视角设置地主牌
function CardsNode:setLordIdentify()
		local cards = self.m_cardsData	
		local count = self.m_cardsCount
		for i = 1, count do
			local cardData = cards[i]
			local tmp = self.m_mapCard[cardData]
			local sprite = cc.Sprite:create("animation/image/cardTips.png")
			sprite:setPosition(83,112)
			tmp:addChild(sprite)
		end
end

function CardsNode:arrangeAllCards( argsTab )
	local showAnimation = argsTab.bAnimation
	local pCallBack = argsTab.pCallBack
--	local addCard = argsTab.addCard
	local banker_card_key_array = argsTab.banker_card_key_array
	local idx = 0;
	local count = self.m_cardsCount
	local real_card_x_dis = CARD_X_DIS - (count - cmd.NORMAL_COUNT) * CARD_X_DIS_ADD_ONE
--[[	if addCard then
		real_card_x_dis = CARD_X_DIS_ADD
	end--]]
	if showAnimation then
		local cards = self.m_cardsData
		if cmd.MY_VIEWID == self.m_nViewId then
			local center = count * 0.5
			local selfViewArrangeCard = function (i)
				local cardData = cards[i]
				local tmp = self.m_mapCard[cardData]
				if nil ~= tmp then
					tmp:setLocalZOrder(i)					
					tmp:showSelectEffect(false) 
					tmp:setScale(CARD_SHOW_SCALE)
					local posX = (i - center) * real_card_x_dis
					local PosY = 0
					-- 是否是庄家牌
					local isAddCard = false
					-- 新加的三张牌弹出
					if banker_card_key_array and (banker_card_key_array[1]== cardData or banker_card_key_array[2]== cardData or banker_card_key_array[3]== cardData)then
						PosY = CARD_SHOOT_DIS		-- 弹出距离
						isAddCard = true
					end
					local pos = cc.p(posX, PosY)
					tmp:stopAllActions()
					if tmp:getDispatched() then
						tmp:setPosition(pos)
					else
						tmp:setDispatched(true)
						local moveTo = cc.MoveTo:create(ANI_BEGIN, pos)
						local delay = cc.DelayTime:create(ANI_BEGIN)
						local hideBack = cc.CallFunc:create(function ()
							tmp:showCardBack(false)
							ExternalFun.playSoundEffect("sendcard.wav")
						end)
						local seq = cc.Sequence:create(delay, hideBack)
						local spa = cc.Spawn:create(moveTo, cc.ScaleTo:create(ANI_BEGIN, CARD_SHOW_SCALE), cc.CallFunc:create(function()
							if i == count then
								if nil ~= pCallBack then
									tmp:runAction(pCallBack)
									pCallBack:release()
									self.m_bDispatching = false							
								else
									self.m_bDispatching = false
								end								
							end							
						end), seq)
						if isAddCard then
							tmp:runAction(cc.Sequence:create(cc.DelayTime:create(ANI_RATE(idx)) , spa, cc.MoveTo:create(BANKER_CARD_BACK_TIME, cc.p(posX, 0))))
						else
							tmp:runAction(cc.Sequence:create(cc.DelayTime:create(ANI_RATE(idx)) , spa))
						end	
						idx = idx + 1
					end
				end
			end
			if  not banker_card_key_array then
				self:runAction(cc.Sequence:create(cc.CallFunc:create(function()
					for i = 1, 6 do
						selfViewArrangeCard(i)
					end
					end), cc.DelayTime:create(0.3),cc.CallFunc:create(function()
					for i = 7, 12 do
						selfViewArrangeCard(i)
					end
					end), cc.DelayTime:create(0.3), cc.CallFunc:create(function()
					for i = 13, 17 do
						selfViewArrangeCard(i)
					end
					end), cc.DelayTime:create(1), cc.CallFunc:create(function()
						
--[[						GameLogic:SortCardList(self.m_cardsData, cmd.NORMAL_COUNT, 0)
						self:reSortCards()--]]
						for i=1, count do
							local cardData = cards[i]
							local tmp = self.m_mapCard[cardData]
							local moveTo = cc.MoveTo:create(ANI_BEGIN, cc.p(8.5, 0))
							tmp:runAction(moveTo)
						end
					end),cc.DelayTime:create(0.3), cc.CallFunc:create(function()
						GameLogic:SortCardList(self.m_cardsData, cmd.NORMAL_COUNT, 0)
						local real_card_x_dis = CARD_X_DIS - (count - cmd.NORMAL_COUNT) * CARD_X_DIS_ADD_ONE
						local center = count * 0.5
--[[						for i=1, count do
							local cardData = self.m_cardsData[i]
							local tmp = self.m_mapCard[cardData]
							local pos = cc.p((i - center) * real_card_x_dis, 0)
--							local moveTo = cc.MoveTo:create(5, pos)
--							tmp:runAction(moveTo)
							tmp:setPosition(pos)
						end--]]
						for i = 1, count do
							local cardData = self.m_cardsData[i]
							local tmp = self.m_mapCard[cardData]
							if nil ~= tmp then
								-- 排列牌的层级及序列不能乱
								tmp:setLocalZOrder(i)
								tmp:setDispatched(true)
								tmp:showSelectEffect(false)
								tmp:showCardBack(false)
								tmp:setScale(CARD_SHOW_SCALE)

								local pos = cc.p((i - center) * real_card_x_dis, 0)
								tmp:stopAllActions()
								tmp:setPosition(pos)
								if (i == count) then
									self.m_bDispatching = false
								end
							end
						end
					end)
				))
			else
				for i=1,count do
					selfViewArrangeCard(i)
				end
			end
		else
			local otherViewArrangeCard = function(i)
				local cardData = cards[i]
				cardData = (cardData ~= 0) and cardData or i
				local tmp = self.m_mapCard[cardData]
				if nil ~= tmp then
					tmp:setLocalZOrder(i)					
					tmp:showSelectEffect(false)

					local pos = cc.p(0, 0)
					tmp:stopAllActions()
					if tmp:getDispatched() then
						tmp:setPosition(pos)
					else
						tmp:setDispatched(true)

						local moveTo = cc.MoveTo:create(ANI_BEGIN, pos)
						local delay = cc.DelayTime:create(ANI_BEGIN)
						local showBack = cc.CallFunc:create(function ()
							tmp:showCardBack(true)
							if i == count then
								self.m_bDispatching = false
							end

							--变动通知
							if nil ~= self.m_pSelectedListener and nil ~= self.m_pSelectedListener.onCountChange then
								self.m_pSelectedListener:onCountChange( i, self )
							end
						end)
						local seq = cc.Sequence:create(delay, showBack)
						local spa = cc.Spawn:create(moveTo, cc.ScaleTo:create(ANI_BEGIN, CARD_HIDE_SCALE), seq)

						tmp:runAction(cc.Sequence:create(cc.DelayTime:create(ANI_RATE(idx)) , spa))
						idx = idx + 1
					end
				end
			end
			if  not banker_card_key_array then
				self:runAction(cc.Sequence:create(cc.CallFunc:create(function()
					for i = 1, 6 do
						otherViewArrangeCard(i)
					end
					end), cc.DelayTime:create(0.3),cc.CallFunc:create(function()
					for i = 7, 12 do
						otherViewArrangeCard(i)
					end
					end), cc.DelayTime:create(0.3), cc.CallFunc:create(function()
					for i = 13, 17 do
						otherViewArrangeCard(i)
					end
				end)
				))
			else
				for i=1,count do
					otherViewArrangeCard(i)
				end
			end
		end
	else
		--整理卡牌位置
		self:reSortCards({addCard=addCard})
	end
end

function CardsNode:reSortCards(argsTab)
	local count = self.m_cardsCount
	local cards = self.m_cardsData
--[[	if argsTab then
		addCard  = argsTab.addCard
	end--]]
	local real_card_x_dis = CARD_X_DIS - (count - cmd.NORMAL_COUNT) * CARD_X_DIS_ADD_ONE
--[[	if addCard then
		real_card_x_dis = CARD_X_DIS_ADD
	end--]]
	--布局
	if cmd.MY_VIEWID == self.m_nViewId then
		local center = count * 0.5
		for i = 1, count do
			local cardData = cards[i]
			local tmp = self.m_mapCard[cardData]
			if nil ~= tmp then
				tmp:setLocalZOrder(i)
				tmp:setDispatched(true)
				tmp:showSelectEffect(false)
				tmp:showCardBack(false)
				tmp:setScale(CARD_SHOW_SCALE)

				local pos = cc.p((i - center) * real_card_x_dis, 0)
				tmp:stopAllActions()
				tmp:setPosition(pos)
				if (i == count) then
					self.m_bDispatching = false
				end
			end
		end
	else
		for i = 1, count do
			local cardData = cards[i]
			cardData = (cardData ~= 0) and cardData or i
			local tmp = self.m_mapCard[cardData]
			if nil ~= tmp then
				tmp:setLocalZOrder(i)
				tmp:setDispatched(true)
				tmp:showSelectEffect(false)
				tmp:showCardBack(true)
				tmp:setScale(CARD_HIDE_SCALE)

				local pos = cc.p(0, 0)
				tmp:stopAllActions()
				tmp:setPosition(pos)
				if (i == count) then
					self.m_bDispatching = false
				end
			end
		end

		--变动通知
		if nil ~= self.m_pSelectedListener and nil ~= self.m_pSelectedListener.onCountChange then
			self.m_pSelectedListener:onCountChange( self.m_cardsCount, self)
		end
	end
end

function CardsNode:dragCards( vecCard , backVecCards)
	if type(vecCard) ~= "table"  then
		return
	end
	local backVecCard = function(v)
		local pos = cc.p(v:getPositionX(), v:getPositionY())
		local shoot = cc.MoveTo:create(CARD_SHOOT_TIME,cc.p(pos.x,0))
		v:runAction(shoot)
		v:setCardShoot(false)
		if nil ~= self.m_pSelectedListener 
			and nil ~= self.m_pSelectedListener.onCardsStateChange 
			and self.m_bClickable then            
			self.m_pSelectedListener:onCardsStateChange(v:getCardData(), false, self)
		end
		self.m_mapSelectedCards[v:getCardData()] = nil
	end
	for k,v in pairs(vecCard) do
		v:stopAllActions()
		if not v:getCardShoot() then
			local pos = cc.p(v:getPositionX(), v:getPositionY())
			local shoot = cc.MoveTo:create(CARD_SHOOT_TIME,cc.p(pos.x,CARD_SHOOT_DIS))
            v:runAction(shoot)
            v:setCardShoot(true)
            if nil ~= self.m_pSelectedListener 
            	and nil ~= self.m_pSelectedListener.onCardsStateChange 
            	and self.m_bClickable then            
                self.m_pSelectedListener:onCardsStateChange(v:getCardData(), true, self)
            end
            self.m_mapSelectedCards[v:getCardData()] = v
        else
			backVecCard(v)
		end
	end
	if nil ~= backVecCards then
		for k,v in pairs(backVecCards) do
			v:stopAllActions()
			backVecCard(v)
		end
	end
	local tmpShow = (cmd.MY_VIEWID == self.m_nViewId) and false or not self.m_bShowCard
	local vecChildren = self.m_cardsHolder:getChildren()
	for k,v in pairs(vecChildren) do
		v:showCardBack(tmpShow)
		v:setCardDragSelect(false)
		v:showSelectEffect(false)
	end

	self.m_tSelectCards = {}
	for k,v in pairs(self.m_mapSelectedCards) do
		if nil ~= v and nil ~= v.getCardData then
			table.insert(self.m_tSelectCards, v:getCardData())
		end		
	end
	self.m_tSelectCards = GameLogic:SortCardList(self.m_tSelectCards, #self.m_tSelectCards, 0)

	--通知
	if nil ~= self.m_pSelectedListener and nil ~= self.m_pSelectedListener.onSelectedCards then
		self.m_pSelectedListener:onSelectedCards(self.m_tSelectCards, self)
	end

	self.m_mapDragSelectCards = {}
end

--触摸操控
function CardsNode:filterCard(flag, touchPoint)
	local tmpSel = {}
	for k,v in pairs(self.m_mapCard) do
		local locationInNode = v:convertToNodeSpace(touchPoint)
		local rec = cc.rect(0, 0, v:getContentSize().width, v:getContentSize().height)
		if cc.rectContainsPoint(rec, locationInNode) then
	        table.insert(tmpSel, v)
	    end
	end

	if 0 == #tmpSel then
		return nil
	end

	table.sort(tmpSel,function( a,b )
		return a:getLocalZOrder() < b:getLocalZOrder()
	end)

	if kHIGHEST == flag then
		return tmpSel[#tmpSel]
	else
		return tmpSel[1]
	end
end

function CardsNode:inTouchAreaCards( touchRect )
	local tmpMap = {}
	for k,v in pairs(self.m_mapCard) do
		if nil ~= v then
			local locationInNode = cc.p(v:getPositionX(), v:getPositionY())
			local anchor = v:getAnchorPoint()
			local tmpSize = v:getContentSize()

			local ori = cc.p(locationInNode.x - tmpSize.width * anchor.x, locationInNode.y - tmpSize.height * anchor.y)
			local rect = cc.rect(ori.x, ori.y, tmpSize.width , tmpSize.height)
			if cc.rectIntersectsRect(rect, touchRect) and nil ~= v.getCardData then
		        tmpMap[v:getCardData()] = v
		    end
		end		 
	end

	return self:filterDragSelectCards(true, tmpMap, true)
end

function CardsNode:makeTouchRect( endTouch )
	local movePoint = endTouch
	local m_beginTouchPoint = self.m_beginTouchPoint

	--判断拖动方向(左右)
	local toRight = (m_beginTouchPoint.x < movePoint.x) and true or false
	--判断拖动方向(上下)
	local toTop = (m_beginTouchPoint.y < movePoint.y) and true or false
	self.m_dragMoveDir = (toRight == true) and kMoveToRight or kMoveToLeft

	if toRight and toTop then
		return cc.rect(m_beginTouchPoint.x, m_beginTouchPoint.y, movePoint.x - m_beginTouchPoint.x, movePoint.y - m_beginTouchPoint.y)
	elseif toRight and not toTop then
		return cc.rect(m_beginTouchPoint.x, movePoint.y, movePoint.x - m_beginTouchPoint.x, m_beginTouchPoint.y - movePoint.y)
	elseif not toRight and toTop then
		return cc.rect(movePoint.x, m_beginTouchPoint.y, m_beginTouchPoint.x - movePoint.x, movePoint.y - m_beginTouchPoint.y)
	elseif not toRight and not toTop then
		return cc.rect(movePoint.x, movePoint.y, m_beginTouchPoint.x - movePoint.x, m_beginTouchPoint.y - movePoint.y)
	end
	return cc.rect(0, 0, 0, 0)
end

function CardsNode:filterDragSelectCards( bFilter, cards, bMap)
	local lowOrder = self:getLowOrder()
	local hightOrder = self:getHightOrder()
	bMap = bMap or false

	--过滤对象
	local tmpMap = {}
	if nil == cards or type(cards) ~= "table" or 0 == table.nums(cards) then
		--合并
		for k,v in pairs(self.m_mapSelectedCards) do
			if nil ~= v and nil ~= v.getCardData then
				tmpMap[v:getCardData()] = v
			end			
		end
		for k,v in pairs(self.m_mapDragSelectCards) do
			if nil ~= v and nil ~= v.getCardData then
				tmpMap[v:getCardData()] = v
			end	
		end
	else
		tmpMap = cards
	end

	local tmp = {}
	if bMap then
		if bFilter then
			for k,v in pairs(tmpMap) do
				if v:getLocalZOrder() >= lowOrder and v:getLocalZOrder() <= hightOrder then
					tmp[v:getCardData()] = v
				end			
			end
		else
			for k,v in pairs(tmpMap) do
				tmp[v:getCardData()] = v
			end
		end
	else
		if bFilter then
			for k,v in pairs(tmpMap) do
				if v:getLocalZOrder() >= lowOrder and v:getLocalZOrder() <= hightOrder then
					table.insert(tmp, v)
				end			
			end
		else
			for k,v in pairs(tmpMap) do
				table.insert(tmp, v)
			end
		end
	end	
	return tmp
end

function CardsNode:getLowOrder()
	local beginOrder = (self.m_beginSelectCard ~= nil) and self.m_beginSelectCard:getLocalZOrder() or MIN_DRAW_ORDER
	local endOrder = nil
	if nil ~= self.m_endSelectCard then
		endOrder = self.m_endSelectCard:getLocalZOrder()
	end
	if kMoveToLeft == self.m_dragMoveDir then
		endOrder = endOrder or MIN_DRAW_ORDER
	else
		endOrder = endOrder or MAX_DRAW_ORDER
	end
	return math.min(beginOrder, endOrder)
end

function CardsNode:getHightOrder()
	local beginOrder = (self.m_beginSelectCard ~= nil) and self.m_beginSelectCard:getLocalZOrder() or MIN_DRAW_ORDER
	local endOrder = nil
	if nil ~= self.m_endSelectCard then
		endOrder = self.m_endSelectCard:getLocalZOrder()
	end
	if kMoveToLeft == self.m_dragMoveDir then
		endOrder = endOrder or MAX_DRAW_ORDER
	else
		endOrder = endOrder or MIN_DRAW_ORDER
	end
	return math.max(beginOrder, endOrder)
end
--触摸操控

return CardsNode