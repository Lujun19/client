local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local GameLogic = appdf.req(appdf.GAME_SRC.."yule.tuitongzi100.src.models.GameLogic")
local CardSprite = class("CardSprite", cc.Sprite);

--纹理宽高
local CARD_WIDTH = 80;
local CARD_HEIGHT = 115;
local BACK_Z_ORDER = 2;

local SMALL_CARD_WIDTH = 27	
local SMALL_CARD_HEIGHT = 41

local BANK_CARD_WIDTH =  61
local BANK_CARD_HEIGHT = 86

--手牌数组
CardSprite.card = {}
CardSprite.scaleX = SMALL_CARD_WIDTH/CARD_WIDTH
CardSprite.scaleY = SMALL_CARD_HEIGHT/CARD_HEIGHT

--发一张牌需要的时间
CardSprite.sendCardTime = 0.3
--翻一张牌需要的时间
CardSprite.reserveCardTime = 0.4

--背面牌的位置
CardPos = {cc.p(870,558),cc.p(870,568), cc.p(898,558),cc.p(898,568),
		   cc.p(926,558),cc.p(926,568), cc.p(954,558),cc.p(954,568)}
--手牌位置，从庄家开始，逆时针
HandBankCardPos = {cc.p(636, 545), cc.p(701, 545),
			   cc.p(269, 219), cc.p(349, 219),
			   cc.p(627, 219), cc.p(707, 219),
			   cc.p(985, 219), cc.p(1065, 219)}
--从天门开始
HandTianCardPos = {
			   cc.p(269, 219), cc.p(349, 219),
			   cc.p(627, 219), cc.p(707, 219),
			   cc.p(985, 219), cc.p(1065, 219),
			   cc.p(636, 545), cc.p(701, 545)}
--从中门开始
HandZhongCardPos = {
			   cc.p(627, 219), cc.p(707, 219),
			   cc.p(985, 219), cc.p(1065, 219),
			   cc.p(636, 545), cc.p(701, 545),
			   cc.p(269, 219), cc.p(349, 219)}
--从地门开始
HandDiCardPos = {
			   cc.p(985, 219), cc.p(1065, 219),
			   cc.p(636, 545), cc.p(701, 545),
			   cc.p(269, 219), cc.p(349, 219),
			   cc.p(627, 219), cc.p(707, 219)}

local cardBack = 
{
    "CARD1",
    "CARD2",
    "CARD3",
    "CARD4",
    "CARD5",
    "CARD6",
    "CARD7",
    "CARD8", 
}

local CARD_TAG = ExternalFun.declarEnumWithTable(1, cardBack)

function CardSprite:ctor()
	--手牌数组
	CardSprite.card = {}
end

--根据骰子点数，获得发牌位置
function CardSprite:getSendCardPos( point )
	if not point then return nil end
	if point == 5 or point == 9 then
		return 1
	elseif point == 2 or point == 6 or point == 10 then
		return 2
	elseif point == 3 or point == 7 or point == 11 then
		return 3
	elseif point == 4 or point == 8 or point == 12 then
		return 4
	end
	return nil
end

--创建扑克
function CardSprite:createCard( data )
    local mjSprite = cc.Sprite:create("card/mj_2.png")
    local index = GameLogic.SwitchToCardIndex(data)
    local img = cc.Sprite:create(string.format("card/font%d.png", index))
    img:setPosition(cc.p(39.55, 64.9))
    img:setScale(0.9)
    img:addTo(mjSprite)
    return mjSprite
end

--创建点数图片
function CardSprite:createPoint( tab )
	local img = cc.Sprite:create()
	if not img then return end
	
    local cardType, point = GameLogic.GetCardType(tab)
    if cardType == GameLogic.CARD_TYPE.PAIR_CARD then
        img:setTexture(string.format("point/pair.png", point))
    elseif cardType == GameLogic.CARD_TYPE.SPECIAL_CARD then
        img:setTexture(string.format("point/28.png"))
    elseif cardType == GameLogic.CARD_TYPE.POINT_CARD then
        img:setTexture(string.format("point/point_%d.png", point))
    end
    return img
end

--创建背面
function CardSprite:createBack( node )
	--创建八张桌面牌
	self._cardUI = node
	if not node then
		return 
	end
	for i=1, 8 do
		local img = cc.Sprite:create("card/mj_0.png"):addTo(node)
		img:setTag(9-i)
		img:setScale(CardSprite.scaleX, CardSprite.scaleY)
		img:setPosition(CardPos[i])
		table.insert(CardSprite.card, img)
	end
end

function CardSprite:getOrderCard(node, startPos)
	if startPos == 1 then
		for i=3, 8 do
			local img = node:getChildByTag(i)
			table.insert(self.cardManage, img)
		end
		table.insert(self.cardManage, node:getChildByTag(1))
		table.insert(self.cardManage, node:getChildByTag(2))
	elseif startPos == 2 then
		for i=1, 8 do
			local img = node:getChildByTag(i)
			table.insert(self.cardManage, img)
		end
	elseif startPos == 3 then
		table.insert(self.cardManage, node:getChildByTag(7))
		table.insert(self.cardManage, node:getChildByTag(8))
		for i=1, 6 do
			local img = node:getChildByTag(i)
			table.insert(self.cardManage, img)
		end
	elseif startPos == 4 then
		for i=5, 8 do
			local img = node:getChildByTag(i)
			table.insert(self.cardManage, img)
		end
		for i=1, 4 do
			local img = node:getChildByTag(i)
			table.insert(self.cardManage, img)
		end
	end
end

--发牌动画
function CardSprite:sendCard( node, startPos, parent )
	--从天门开始存放牌值
	self.cardManage = {}
	self.parentNode = node:getParent()
	if not node or not startPos then
		return 
	end
	--发一张牌需要的时间
	local time = CardSprite.sendCardTime
	local scaleX = 0
	local scaleY = 0
	if startPos == 1 then
		ExternalFun.playSoundEffect("DISPATCH_CARD.wav")
		self:getOrderCard(node, startPos)
		--庄家为起始位置
		for i=1, 8 do
			if i==1 or i==2 then
				scaleX = BANK_CARD_WIDTH/SMALL_CARD_WIDTH
				scaleY = BANK_CARD_HEIGHT/SMALL_CARD_HEIGHT
			else
				scaleX = CARD_WIDTH/SMALL_CARD_WIDTH
				scaleY = CARD_HEIGHT/SMALL_CARD_HEIGHT
			end

			local delay = (i-1) * time
			local delayTime = cc.DelayTime:create(delay)
			if i==8 then
				node:getChildByTag(i):runAction(cc.Sequence:create(delayTime, cc.Spawn:create(cc.MoveTo:create(time, HandBankCardPos[i]), cc.ScaleBy:create(time, scaleX, scaleY )), 
												cc.DelayTime:create(2), cc.CallFunc:create(function () self:showCardAnimate(parent) end)))
			else
				node:getChildByTag(i):runAction(cc.Sequence:create(delayTime, cc.Spawn:create(cc.MoveTo:create(time, HandBankCardPos[i]), cc.ScaleBy:create(time, scaleX, scaleY ))))
			end
		end
	elseif startPos == 2 then
		self:getOrderCard(node, startPos)
		--天门为起始位置
		for i=1, 8 do
			if i==7 or i==8 then
				scaleX = BANK_CARD_WIDTH/SMALL_CARD_WIDTH
				scaleY = BANK_CARD_HEIGHT/SMALL_CARD_HEIGHT
			else
				scaleX = CARD_WIDTH/SMALL_CARD_WIDTH
				scaleY = CARD_HEIGHT/SMALL_CARD_HEIGHT
			end

			local delay = (i-1) * time
			local delayTime = cc.DelayTime:create(delay)
			if i==8 then
				node:getChildByTag(i):runAction(cc.Sequence:create(delayTime, cc.Spawn:create(cc.MoveTo:create(time, HandTianCardPos[i]), cc.ScaleBy:create(time, scaleX, scaleY )), 
												cc.DelayTime:create(2), cc.CallFunc:create(function () self:showCardAnimate(parent) end)))
			else
				node:getChildByTag(i):runAction(cc.Sequence:create(delayTime, cc.Spawn:create(cc.MoveTo:create(time, HandTianCardPos[i]), cc.ScaleBy:create(time, scaleX, scaleY ))))
			end
		end
	elseif startPos == 3 then
		self:getOrderCard(node, startPos)
		--中门为起始位置
		for i=1, 8 do
			if i==5 or i==6 then
				scaleX = BANK_CARD_WIDTH/SMALL_CARD_WIDTH
				scaleY = BANK_CARD_HEIGHT/SMALL_CARD_HEIGHT
			else
				scaleX = CARD_WIDTH/SMALL_CARD_WIDTH
				scaleY = CARD_HEIGHT/SMALL_CARD_HEIGHT
			end

			local delay = (i-1) * time
			local delayTime = cc.DelayTime:create(delay)
			if i==8 then
				node:getChildByTag(i):runAction(cc.Sequence:create(delayTime, cc.Spawn:create(cc.MoveTo:create(time, HandZhongCardPos[i]), cc.ScaleBy:create(time, scaleX, scaleY )), 
												cc.DelayTime:create(2), cc.CallFunc:create(function () self:showCardAnimate(parent) end)))
			else
				node:getChildByTag(i):runAction(cc.Sequence:create(delayTime, cc.Spawn:create(cc.MoveTo:create(time, HandZhongCardPos[i]), cc.ScaleBy:create(time, scaleX, scaleY ))))
			end
		end
	elseif startPos == 4 then
		self:getOrderCard(node, startPos)
		--地门为起始位置
		for i=1, 8 do
			if i==3 or i==4 then
				scaleX = BANK_CARD_WIDTH/SMALL_CARD_WIDTH
				scaleY = BANK_CARD_HEIGHT/SMALL_CARD_HEIGHT
			else
				scaleX = CARD_WIDTH/SMALL_CARD_WIDTH
				scaleY = CARD_HEIGHT/SMALL_CARD_HEIGHT
			end

			local delay = (i-1) * time
			local delayTime = cc.DelayTime:create(delay)

			if i==8 then
				node:getChildByTag(i):runAction(cc.Sequence:create(delayTime, cc.Spawn:create(cc.MoveTo:create(time, HandDiCardPos[i]), cc.ScaleBy:create(time, scaleX, scaleY )), 
												cc.DelayTime:create(2), cc.CallFunc:create(function () self:showCardAnimate(parent) end)))
			else
				node:getChildByTag(i):runAction(cc.Sequence:create(delayTime, cc.Spawn:create(cc.MoveTo:create(time, HandDiCardPos[i]), cc.ScaleBy:create(time, scaleX, scaleY ))))
			end
		end
	end
end

--执行翻牌动画
function CardSprite:showCardAnimate(parent)
	--执行单个翻牌需要的时间
	local times = CardSprite.reserveCardTime
	local count = 0
	for i=1, 8 do
		local delayTime = (i-1)*times

		--为播放点数声音留1秒
		if i==3 or i==5 or i==7 then
			count = count + 1
		end

		if i>2 then
			delayTime = delayTime + count *1
		end

		local pos = HandTianCardPos[i]
		CardSprite:reserveCardAnimate(pos, delayTime, parent, i)
	end
end

--翻牌动画
function CardSprite:reserveCardAnimate(pos, delay, parent, cardTag)
	local delayTime = cc.DelayTime:create(delay)
    if not self.cardManage[cardTag] then return end
    local img = self.cardManage[cardTag]
 
    img:runAction(cc.Sequence:create(delayTime, cc.CallFunc:create(function() 
    													img:setTexture("card/mj_1.png") 
    												end), cc.DelayTime:create(0.1), 
    											cc.CallFunc:create(function() 
	    												img:setTexture("card/mj_2.png")
	    												self:showCardValue(parent, img, cardTag)
    												end)))
		CardSprite.bankerCardTag = {7, 8}
end

--获取麻将画面
function CardSprite:showCardValue(parent, imgSprite, cardTag)
	if not parent then 
		return 
	end
	parent:showCardValue(imgSprite, cardTag)
end

function CardSprite:showGameEndPoint(parent)
	if next(parent.cbTableCardArray) == nil then return end
	--显示点数
	local cardArray = parent.cbTableCardArray
	for i=1, 4 do
		local img = parent.csbNode:getChildByName(string.format("win_type%d.png", i))

		if not img then return end

        local cardType, point = GameLogic.GetCardType(cardArray[i])
        if cardType == GameLogic.CARD_TYPE.PAIR_CARD then
        	img:setTexture(string.format("point/pair_%d.png", point))
		elseif cardType == GameLogic.CARD_TYPE.SPECIAL_CARD then
        	img:setTexture(string.format("point/point_0.png", point))
		elseif cardType == GameLogic.CARD_TYPE.POINT_CARD then
			img:setTexture(string.format("point/point_0.png", point))
		end
    end 

    --显示动画
    for i=2, 4 do
    	local winer = GameLogic.GetWinner(cardArray[1], cardArray[i])

    	--玩家获胜
    	if winder == GameLogic.WINER.PLAYER_TWO then
    		parent.areaFrameAnimate(i-1)
    	end
    end
end

--断线重连显示牌以及点数从天门开始
function CardSprite:showGameEndUI(cardArray)
	local node = cc.Node:create()
	local scaleX = BANK_CARD_WIDTH/CARD_WIDTH
	local scaleY = BANK_CARD_HEIGHT/CARD_HEIGHT
	local temp = {}
	for i=1, #cardArray do
		for j=1, #cardArray[i] do
			table.insert(temp, cardArray[i][j])
		end
	end
	assert(#temp == 8, "The number of card is error!!")

	for i=1, #temp do
		local tmp = CardSprite:createCard(temp[i])
				:setPosition(HandTianCardPos[i])
				:addTo(node)
		if i==7 or i==8 then
			tmp:setScale(scaleX, scaleY)
		end
	end

	return node
end


return CardSprite