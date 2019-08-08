local CardLayer = class("CardLayer", function(scene)
	local cardLayer = display.newLayer()
	return cardLayer
end)

local ExternalFun = appdf.req(appdf.EXTERNAL_SRC.."ExternalFun")
local GameLogic = appdf.req(appdf.GAME_SRC.."yule.sparrowxz.src.models.GameLogic")
local cmd = appdf.req(appdf.GAME_SRC.."yule.sparrowxz.src.models.CMD_Game")

--桌面麻将布局参数  布局格式  自己为1  右边为2 左边为3 对面为4
--手牌
local posHandCard = {cc.p(62, 74), cc.p(1280, 220), cc.p(200, 650), cc.p(1000, 665)}
local anchorPointHandCard = {cc.p(0, 0), cc.p(0, 0), cc.p(1, 0), cc.p(0, 1)} --方向
local pramHandCard = {{88, 136, 88, 0}, {28, 75, -10, 31}, {28, 75, -10, -31},{43, 68, -43, 0}} --宽 高 x方向偏移量 y方向偏移量
local zorderCard = {1, -1, 1, -1}

--出牌
local posOutcard = {cc.p(400, 210), cc.p(1105, 212), cc.p(260, 600), cc.p(900, 550)}
local pramOutCard = {{44, 67, 44, 52}, {55, 47, -55, 32}, {55, 47, 55, -32},{44, 67, -44, -52}} --宽 高 x方向偏移量 y方向偏移量

local numPerLine = 10    --打出的牌，每行多少个

--碰牌，杠牌
local posActiveCard = {cc.p(1285, 62), cc.p(1180, 680), cc.p(200, 150), cc.p(340, 665)}
local anchorPointActiveCard = {{-1, 0}, {0, -1}, {0, 1}, {1, 0}}--方向
local pramActiveCard = {{44, 67, -44, 0}, {55, 47, -10, -32}, {55, 47, -10, 32},{44, 67, 44, 0}} --宽 高 x方向偏移量 y方向偏移量
local offsetPer = 10  --每个碰杠牌之间间隔

--local cbCardData = {1, 5, 7, 6, 34, 12, 32, 25, 18, 19, 27, 22, 33, 33}

CardLayer.TAG_BUMPORBRIDGE = 1
CardLayer.TAG_CARD_FONT = 1
CardLayer.TAG_LISTEN_FLAG = 2

CardLayer.ENUM_CARD_NORMAL = nil
CardLayer.ENUM_CARD_POPUP = 1
CardLayer.ENUM_CARD_MOVING = 2
CardLayer.ENUM_CARD_OUT = 3

CardLayer.Z_ORDER_TOP = 50


function CardLayer:findMyGangCard()
	local cards=self.cbCardData[cmd.MY_VIEWID] --暗杠
	local tabNum={}
	for k,v in pairs(cards) do
		tabNum[v]=(tabNum[v] or 0)+1
	end
	for k,v in pairs(tabNum) do
		if v==4 and math.ceil(k/16)~=self.callcardKind then
			return k
		end
	end

	local activeCards=self.cbActiveCardData[cmd.MY_VIEWID] --补杠
	for i=1,#activeCards do
		local activeInfo =activeCards[i]
		for j=1,#cards do
			if activeInfo.cbCardValue[1] ==cards[j] then
				return cards[j]
			end
		end
	end

	return nil
end

--创建立着的手牌
function CardLayer:createStandCardSprite(viewId, value)
	local resCsb =
	{
		cmd.RES_PATH.."card/Node_majong_my.csb",
		cmd.RES_PATH.."card/Node_majong_right.csb",
		cmd.RES_PATH.."card/Node_majong_left.csb",
		cmd.RES_PATH.."card/Node_majong_top.csb",
	}
	local resValue =
	{
		cmd.RES_PATH.."card/my_big/tile_me_up_",
		cmd.RES_PATH.."card/left_right/tile_leftRight_",
		cmd.RES_PATH.."card/left_right/tile_leftRight_",
		cmd.RES_PATH.."card/my_small/tile_meUp_",
	}

	local card =  cc.CSLoader:createNode(resCsb[viewId])
	card:setContentSize(cc.size(pramHandCard[viewId][1], pramHandCard[viewId][2]))
	--print("我的麻将尺寸", card:getContentSize().width, card:getContentSize().height)
	--print("创建立着的麻将,玩家位置", viewId)
	if nil ~= value then --其他玩家的牌不处理
		--获取数值
		print("创建立着的麻将", value)
		local cardIndex = GameLogic.SwitchToCardIndex(value)
		local sprPath = resValue[viewId]
		if cardIndex < 10 then
			sprPath = sprPath..string.format("0%d", cardIndex)..".png"
		else
			sprPath = sprPath..string.format("%d", cardIndex)..".png"
		end
		local spriteValue = display.newSprite(sprPath)
		--获取精灵
		local sprCard = card:getChildByName("card_value")
		if nil ~= sprCard then
			sprCard:setSpriteFrame(spriteValue:getSpriteFrame())
		end
		-- print("math.ceil(value/16):",math.ceil(value/16))
		-- print("self.callcardKind:",self.callcardKind)
		-- if math.ceil(value/16)==self.callcardKind then
		-- 	convertToGraySprite(sprCard)
		-- 	convertToGraySprite(card:getChildByName("card_bg"))
		-- end
	end
	return card
end

--创建非自己的碰杠牌和打出去的牌
function CardLayer:createOutOrActiveCardSprite(viewId, value)
	print("创建打出的手牌",viewId, value)
	local resCsb =
	{
		cmd.RES_PATH.."card/Node_majong_my_downsmall.csb",
		cmd.RES_PATH.."card/Node_majong_right_down.csb",
		cmd.RES_PATH.."card/Node_majong_left_down.csb",
		cmd.RES_PATH.."card/Node_majong_top_dowm.csb",
	}
	local resValue =
	{
		cmd.RES_PATH.."card/my_small/tile_meUp_",
		cmd.RES_PATH.."card/left_right/tile_leftRight_",
		cmd.RES_PATH.."card/left_right/tile_leftRight_",
		cmd.RES_PATH.."card/my_small/tile_meUp_",
	}
	local card =  cc.CSLoader:createNode(resCsb[viewId])
	card:setContentSize(cc.size(pramOutCard[1], pramOutCard[2]))
	card:setAnchorPoint(cc.p(0.5, 0.5))
	--获取数值
	local cardIndex = GameLogic.SwitchToCardIndex(value)
	local sprPath = resValue[viewId]
	if cardIndex < 10 then
		sprPath = sprPath..string.format("0%d", cardIndex)..".png"
	else
		sprPath = sprPath..string.format("%d", cardIndex)..".png"
	end
	local spriteValue = display.newSprite(sprPath)
	--获取精灵
	local sprCard = card:getChildByName("card_value")
	if nil ~= sprCard then
		sprCard:setSpriteFrame(spriteValue:getSpriteFrame())
	end

	return card
end

--创建我的碰杠牌（我的碰杠牌比较大）
function CardLayer:createMyActiveCardSprite(value)
	local card =  cc.CSLoader:createNode(cmd.RES_PATH.."card/Node_majong_my_downnormal.csb")
	--获取数值
	local cardIndex = GameLogic.SwitchToCardIndex(value)
	local sprPath = cmd.RES_PATH.."card/my_normal/tile_me_"
	if cardIndex < 10 then
		sprPath = sprPath..string.format("0%d", cardIndex)..".png"
	else
		sprPath = sprPath..string.format("%d", cardIndex)..".png"
	end
	local spriteValue = display.newSprite(sprPath)
	--获取精灵
	local sprCard = card:getChildByName("card_value")
	if nil ~= sprCard then
		sprCard:setSpriteFrame(spriteValue:getSpriteFrame())
	end

	return card
end

--碰杠牌显示背面
function CardLayer:showActiveCardBack( viewid, card )
	if nil ~= card then
		--获取精灵
		local sprCard = card:getChildByName("card_value")
		if nil ~= sprCard then
			sprCard:setVisible(false)
		end

		local sprPath =
		{
			cmd.RES_PATH.."card/back_small.png",
			cmd.RES_PATH.."card/left_right_back.png",
			cmd.RES_PATH.."card/left_right_back.png",
			cmd.RES_PATH.."card/back_small.png",
		}
		local spriteBg = display.newSprite(sprPath[viewid])
		local sprCardBg = card:getChildByName("card_bg")
		if nil ~= sprCardBg then
			sprCardBg:setSpriteFrame(spriteBg:getSpriteFrame())
		end

		return card
	end
	return nil
end

--碰杠牌显示正面
function CardLayer:tileActiveCard(viewid)
	local node = self.nodeActiveCard[viewid]
	if nil ~= node then
		local allChild = node:getChildren()
		for k, v in pairs(allChild) do
			--获取精灵
			local sprCard = v:getChildByName("card_value")
			if nil ~= sprCard then
				sprCard:setVisible(true)
			end

			local sprPath =
			{
				cmd.RES_PATH.."card/dowm_small.png",
				cmd.RES_PATH.."card/left_right_down.png",
				cmd.RES_PATH.."card/left_right_down.png",
				cmd.RES_PATH.."card/dowm_small.png",
			}
			local spriteBg = display.newSprite(sprPath[viewid])
			local sprCardBg = v:getChildByName("card_bg")
			if nil ~= sprCardBg then
				sprCardBg:setSpriteFrame(spriteBg:getSpriteFrame())
			end
		end
	end
end

--我的麻将倒下
function CardLayer:createMyTileCardSprite(value)
	local card =  cc.CSLoader:createNode(cmd.RES_PATH.."card/Node_majong_my_downbig.csb")
	--获取数值
	local cardIndex = GameLogic.SwitchToCardIndex(value)
	local sprPath = cmd.RES_PATH.."card/my_big/tile_me_up_"
	if cardIndex < 10 then
		sprPath = sprPath..string.format("0%d", cardIndex)..".png"
	else
		sprPath = sprPath..string.format("%d", cardIndex)..".png"
	end
	local spriteValue = display.newSprite(sprPath)
	--获取精灵
	local sprCard = card:getChildByName("card_value")
	if nil ~= sprCard then
		sprCard:setSpriteFrame(spriteValue:getSpriteFrame())
	end

	return card
end

function CardLayer:onInitData()
	--body
	math.randomseed(os.time())
	self.cbCardData = {{}, {}, {}, {}}
	self.cbCardCount = {0, 0, 0, 0}
	self.cbOutcardCount = {0, 0, 0, 0}

	self.cbActiveCardData = {{}, {}, {}, {}}
	self.isTouchEnable = false -- 设置自己是否可以触摸
	self.nCurrentTouchCardTag = 0 --touchBegin选中的麻将，判断按下和离开是不是同一张麻将
	self.selectTag = 0 --选中的卡牌的tag
	self.isMoving = false --是否移动出牌
	self.beginPoint = nil


	--玩家要听牌可以打的牌
	self.cbListenList = {}
	--玩家打完听牌可以胡的牌 14个
	self.cbHuCard = {}
	--玩家打完听牌可以胡的牌番数
	self.cbHuCardFan = {}
	--玩家打完听牌可以胡的牌剩余张数
	self.cbHuCardLeft = {}

	self.myHandCardPopStatus={}
	self.myHandCardPopN=0
end

function CardLayer:onResetData()
	--body
	for i = 1, cmd.GAME_PLAYER do
		self.cbCardCount[i] = cmd.MAX_COUNT
		self.nodeOutcard[i]:removeAllChildren()
		self.nodeActiveCard[i]:removeAllChildren()
		self.nodeHandCard[i]:removeAllChildren()
	end

	if self.heap and not tolua.isnull(self.heap) then
		self.heap:stopAllActions()
		self.heap:removeSelf()
	end

	print("CardLayer:onResetData()")
	local t=self.cbCardData[cmd.MY_VIEWID]
	print("mycard:",#self.cbCardData[cmd.MY_VIEWID],table.concat(t,","))

	self.cbCardData = {{}, {}, {}, {}}

	self.cbCardCount = {0, 0, 0, 0}
	self.cbOutcardCount = {0, 0, 0, 0}

	self.cbActiveCardData = {{}, {}, {}, {}}
	self.isTouchEnable = false
	self.nCurrentTouchCardTag = 0
	self.selectTag = 0

	self.isMoving = false --是否移动出牌
	self.beginPoint = nil

	--玩家要听牌可以打的牌
	self.cbListenList = {}
	--玩家打完听牌可以胡的牌 14个
	self.cbHuCard = {}
	--玩家打完听牌可以胡的牌番数
	self.cbHuCardFan = {}
	--玩家打完听牌可以胡的牌剩余张数
	self.cbHuCardLeft = {}

	self.myHandCardPopStatus={}
	self.myHandCardPopN=0
	self.callcardKind=nil

	t=self.cbCardData[cmd.MY_VIEWID]
	print("after reset mycard:",#self.cbCardData[cmd.MY_VIEWID],table.concat(t,","))

end

function CardLayer:ctor(scene)
	self._scene = scene
	self:onInitData()

	ExternalFun.registerTouchEvent(self, true)
	--桌牌
	--self.nodeTableCard = self:createTableCard()
	--手牌
	self.nodeHandCard = self:createHandCardNode()
	--出牌
	self.nodeOutcard = self:createOutCardNode()
	dump(self.nodeOutcard, "创建打出的手牌node")
	--碰或杠牌
	self.nodeActiveCard = self:createActiveCardNode()
end

function CardLayer:popMyHandCard(index,bPop,bFirst) --true弹起 false 还原
	print("popMyHandCard:",index,bPop,bFirst,self.bChangeCardStatus,self.myHandCardPopStatus[index])
	if self.bChangeCardStatus~=true then return end
	if bPop==self.myHandCardPopStatus[index] then return end

	local card = self.nodeHandCard[cmd.MY_VIEWID]:getChildByTag(index)
	if bPop==true then
		if self.myHandCardPopN>=3 then
			showToast(self._scene,"已经选中三个麻将",1)
			return
		end
		self.myHandCardPopStatus[index]=bPop
		if bFirst~=true then table.insert(self.changeCards,index) end
		self.myHandCardPopN=self.myHandCardPopN+1
		card:runAction(cc.MoveTo:create(0.1, cc.p(card:getPositionX(), card:getPositionY() + 20)))
	else
		self.myHandCardPopStatus[index]=bPop
		local temp={}
		for i=1,#self.changeCards do
			if self.changeCards[i]~=index then
				table.insert(temp,self.changeCards[i])
			end
		end
		assert(#temp<#self.changeCards)
		self.changeCards=temp
		self.myHandCardPopN=self.myHandCardPopN-1
		card:runAction(cc.MoveTo:create(0.1, cc.p(card:getPositionX(), card:getPositionY()-20)))
	end
end

function CardLayer:getChangeCardHint()
	self.changeCards=GameLogic.changeCardHint(self.cbCardData[cmd.MY_VIEWID])
	return self.changeCards
end

function CardLayer:startChangeCard()
	self.myHandCardPopStatus={}
	self.bChangeCardStatus=true
	self.myHandCardPopN=0
	self:setMyCardTouchEnabled(true)
	self.changeCards=GameLogic.changeCardHint(self.cbCardData[cmd.MY_VIEWID])
	for k,v in ipairs(self.changeCards) do
		self:popMyHandCard(v,true,true)
	end
end

function CardLayer:finishChangeCard()
	self.bChangeCardStatus=false
	self:setMyCardTouchEnabled(false)
	-- for i=1,self.cbCardCount[cmd.MY_VIEWID] do
	-- 	self:popMyHandCard(i,false)
	-- end
end

function CardLayer:getChangeCardsIndex()
	return self.changeCards
end

function CardLayer:getChangeCards()
	print("#self.changeCards",#self.changeCards)
	local ret={}
	for k,v in ipairs(self.changeCards) do
		print("index: ",v)
		table.insert(ret,self.cbCardData[cmd.MY_VIEWID][v])
	end
	return ret
end

function CardLayer:getCallCardHint()
	print("#self.cbCardData[cmd.MY_VIEWID]",#self.cbCardData[cmd.MY_VIEWID])
	return GameLogic.callCardHint(self.cbCardData[cmd.MY_VIEWID])
end

function CardLayer:setMySendcardOffset(sendcard)
	print("setMySendcardOffset")
	print("sendcard:",sendcard)
	assert(sendcard==nil or (sendcard>0 and sendcard<42))
	local t=self.cbCardData[cmd.MY_VIEWID]
	if sendcard then assert(t[#t]==sendcard) end
	if #t>1 then
		local card=self.nodeHandCard[cmd.MY_VIEWID]:getChildByTag(#t-1)
		local sendcardSp=self.nodeHandCard[cmd.MY_VIEWID]:getChildByTag(#t)
		if sendcardSp:getPositionX()-card:getPositionX()<sendcardSp:getContentSize().width+10 then
			sendcardSp:setPositionX(sendcardSp:getPositionX()+pramHandCard[cmd.MY_VIEWID][3]/2)
		end
	end
end

function CardLayer:setMySendcardRightest(sendcard) --wrong
	if sendcard==nil or math.ceil(sendcard/16)<1 or math.ceil(sendcard/16)>3 then return end
	local cards=self.cbCardData[cmd.MY_VIEWID]
	local index=#cards
	for i=#cards,1,-1 do
		if cards[i]==sendcard then
			index=i
			break
		end
	end

	if index==#cards then
		if #cards>1 then
			local card=self.nodeHandCard[cmd.MY_VIEWID]:getChildByTag(#cards-1)
			local sendcardSp=self.nodeHandCard[cmd.MY_VIEWID]:getChildByTag(index)
			if sendcardSp:getPositionX()-card:getPositionX()<sendcardSp:getContentSize().width+10 then
				sendcardSp:setPositionX(sendcardSp:getPositionX()+pramHandCard[cmd.MY_VIEWID][3]/2)
			end
		end
		return
	end

	local myHandCard=self.nodeHandCard[cmd.MY_VIEWID]
	local sendcardSp=myHandCard:getChildByTag(index)
	local lastcardSp=myHandCard:getChildByTag(#cards)
	sendcardSp:setPositionX(lastcardSp:getPositionX())

	for i=index+1,#cards do
		local card=myHandCard:getChildByTag(i)
		local leftcard=myHandCard:getChildByTag(i-1)
		card:setPositionX(leftcard:getPositionX())
	end

	sendcardSp:setTag(66666)
	for i=index+1,#cards do
		myHandCard:getChildByTag(i):setTag(i-1)
	end
	sendcardSp:setTag(#cards)

	if #cards>1 then
		local card=self.nodeHandCard[cmd.MY_VIEWID]:getChildByTag(#cards-1)
		if sendcardSp:getPositionX()-card:getPositionX()<sendcardSp:getContentSize().width+10 then
			sendcardSp:setPositionX(sendcardSp:getPositionX()+pramHandCard[cmd.MY_VIEWID][3]/2)
		end
	end
end

-- function CardLayer:insertMyHandCard(cards)
-- 	assert(#cards==3)
-- 	local t=self.cbCardData[cmd.MY_VIEWID]
-- 	for i=1,#cards do
-- 		local j=1
-- 		while j<=#t do
-- 			if cards[i]<t[j] then break else j=j+1 end
-- 		end
-- 		table.insert(t,j,cards[i])
-- 		self.cbCardCount[cmd.MY_VIEWID] = self.cbCardCount[cmd.MY_VIEWID] + 1
-- 		local card = self:createStandCardSprite(cmd.MY_VIEWID, cards[i])
-- 		if j==#t+1 then
-- 			local cardBefore=self.nodeHandCard[cmd.MY_VIEWID]:getChildByTag(j-1)
-- 			card:setPosition(cardBefore:getPositionX()+pramHandCard[cmd.MY_VIEWID][3],cardBefore:getPositionY())
-- 			card:setTag(j)
-- 			card:setLocalZOrder(cardBefore:getLocalZOrder()+zorderCard[cmd.MY_VIEWID])
-- 		else
-- 			local cardBehind=self.nodeHandCard[cmd.MY_VIEWID]:getChildByTag(j)
-- 			self.nodeHandCard[cmd.MY_VIEWID]:addChild(card,cardBehind:getLocalZOrder())
-- 			card:setPosition(cardBehind:getPosition())
-- 			card:setTag(j)
-- 			for k=j,#t do
-- 				local cardBehind=self.nodeHandCard[cmd.MY_VIEWID]:getChildByTag(k)
-- 				cardBehind:setPositionX(cardBehind:getPositionX()+pramHandCard[cmd.MY_VIEWID][3])
-- 				cardBehind:setTag(k+1)
-- 				cardBehind:setLocalZOrder(cardBehind:getLocalZOrder()+zorderCard[cmd.MY_VIEWID])
-- 			end
-- 		end
-- 	end
-- 	--如果是庄家，第十四张牌和其他牌间隔一定距离
-- 	--if isMeBanker then
-- 	--	self.nodeHandCard[cmd.MY_VIEWID]:getChildByTag(14):setPosition(最右的固定位置)
-- 	--end
-- end

function CardLayer:exchangeCard(receivedCards)          --receivedCards为牌值
	for i=1,#receivedCards do
		print("receivedcard"..i,receivedCards[i])
	end
	self:createHandCard(cmd.MY_VIEWID,receivedCards,#receivedCards)
	self:sortHandCard(cmd.MY_VIEWID)
end

--设置自己是否可以触摸
function CardLayer:setMyCardTouchEnabled(enable)
	self.isTouchEnable = enable
end

--初始化手牌NODE
function CardLayer:createHandCardNode()
	local nodeCard = {}
	for i = 1, cmd.GAME_PLAYER do
		nodeCard[i] = cc.Node:create()
		:move(posHandCard[i])
		:setAnchorPoint(anchorPointHandCard[i])
		:addTo(self, 5)
	end
	return nodeCard
end

--创建立着的手牌，传入卡牌数据，和viewID
function CardLayer:createHandCard(viewid, cbCardData, cbCardCount)
	if cbCardData then print("cbCardData:",table.concat(cbCardData,",")) end
	local n
	if viewid==cmd.MY_VIEWID then
		print("createHandCard",viewid,cbCardCount,cbCardData[1])
		if cbCardCount==1 and viewid==cmd.MY_VIEWID then
			print("createHandCard:",cbCardData[1])
		end
		n=#self.cbCardData[viewid]
		print("n：",n)
		local str=table.concat(self.cbCardData[viewid],",")
		print("str:",str)
	end
	for i=1,cbCardCount do
		--创建麻将
		local card = nil
		if nil ~= cbCardData then
			card = self:createStandCardSprite(viewid, cbCardData[i])
		else
			card = self:createStandCardSprite(viewid, nil)
		end

		if cmd.MY_VIEWID==viewid and card~=nil
			and math.ceil(cbCardData[i]/16)==self.callcardKind then
			card.bGray=true
			convertToGraySprite(card:getChildByName("card_value"))
			convertToGraySprite(card:getChildByName("card_bg"))
		end

		--添加到麻将node
		local numActive = #self.cbActiveCardData[viewid]
		self.nodeHandCard[viewid]:addChild(card, (self.cbCardCount[viewid] +numActive*3)* zorderCard[viewid])
		--设置位置 基础位置加上偏移量乘已经绘制的卡牌个数(如果是一张牌，那么是游戏中发牌，麻将与手牌中间有间隔)
		card:setPosition(cc.p(self.cbCardCount[viewid] * pramHandCard[viewid][3], self.cbCardCount[viewid] * pramHandCard[viewid][4]))

		if (13 - numActive*3) == self.cbCardCount[viewid] then --如果是发牌给玩家，偏离一点点
			card:setPosition(self.cbCardCount[viewid] *pramHandCard[viewid][3] + pramHandCard[viewid][3]/2 , self.cbCardCount[viewid] * pramHandCard[viewid][4] + pramHandCard[viewid][4]/2 )
		end
		--print("添加麻将到node", viewid, self.cbCardCount[viewid] +1, card:getPositionX(), card:getPositionY())
		self.cbCardCount[viewid] = self.cbCardCount[viewid] + 1 --个数加1
		card:setTag(self.cbCardCount[viewid])

		print("self.cbCardCount[viewid]:",self.cbCardCount[viewid])
		--卡牌添加到当前卡牌数组
		if nil ~= cbCardData then
			self.cbCardData[viewid][self.cbCardCount[viewid]] = cbCardData[i]
		else
			self.cbCardData[viewid][self.cbCardCount[viewid]] = nil
		end
	end
	if viewid==cmd.MY_VIEWID then
		print("#self.cbCardData[viewid]",#self.cbCardData[viewid])
		assert(#self.cbCardData[viewid]>n)
	end
	local found=false
	if cbCardData~=nil and cbCardData[1]~=nil and viewid==cmd.MY_VIEWID then
		for k,v in ipairs(self.cbCardData[viewid]) do
			if v==cbCardData[1] then found=true break end
		end
		assert(found==true)
	end
	print("createHandCard end")
	print("#self.cbCardData[viewid]",#self.cbCardData[viewid])
	for i=1,#self.cbCardData[viewid] do
		print("i:",self.cbCardData[viewid][i])
	end
	--print(table.concat(self.cbCardData[viewid]),",")
end


function CardLayer:setCallcardKind(kind)
	self.callcardKind=kind
end


--手牌排序
function CardLayer:sortHandCard(viewid,sendcard) --sendcard最右有bug
	print("sendcard:",sendcard)
	assert(nil==sendcard or (sendcard>0 and sendcard<42))
	if viewid==cmd.MY_VIEWID then
		print("sortHandCard")
		print("self.cbCardCount[viewid]:",self.cbCardCount[viewid])
		print("#self.cbCardData[viewid]:",#self.cbCardData[viewid])
		for i=1,#self.cbCardData[viewid] do
			print(i,self.cbCardData[viewid][i])
		end
	end
	--print("排序索引", viewid)
	--先将卡牌从新紧密布局
	local index = 0; --实际索引
	for i=1, cmd.MAX_COUNT do
		local card = self.nodeHandCard[viewid]:getChildByTag(i)
		if nil ~=  card then
			card:setPosition(cc.p(index * pramHandCard[viewid][3], index * pramHandCard[viewid][4]))
			--print("麻将重排位置",index, card:getPositionX(), card:getPositionY())
			card:setLocalZOrder(index *zorderCard[viewid])
			index = index +1
			card:setTag(index) --s索引从1开始
		end
	end

	if viewid == cmd.MY_VIEWID then

		if self.callcardKind==nil then
			table.sort(self.cbCardData[cmd.MY_VIEWID], function(a, b) return a < b end)
		else
			table.sort(self.cbCardData[cmd.MY_VIEWID], function(a, b)
				local kindA=math.ceil(a/16)
				local kindB=math.ceil(b/16)
				if kindA==self.callcardKind and kindB~=self.callcardKind then
					return false
				elseif kindA~=self.callcardKind and kindB==self.callcardKind then
					return true
				else
					return a < b
				end
			end)
		end

		local index=-1
		local tabC=self.cbCardData[cmd.MY_VIEWID]
		for i=1,#tabC do
			if tabC[i]==sendcard then
				index=i
				break
			end
		end

		if index~=-1 then
			table.remove(tabC,index)
			table.insert(tabC,sendcard)
		end

		print("callcard:",self.callcardKind)
		print("after sort:")
		for i=1,#self.cbCardData[cmd.MY_VIEWID] do
			print(i,self.cbCardData[cmd.MY_VIEWID][i])
		end

		local resValue =
		{
			cmd.RES_PATH.."card/my_big/tile_me_up_",
			cmd.RES_PATH.."card/left_right/tile_leftRight_",
			cmd.RES_PATH.."card/left_right/tile_leftRight_",
			cmd.RES_PATH.."card/my_small/tile_meUp_",
		}
		--重新设置麻将纹理
		--print("排序，卡牌数目", self.cbCardCount[viewid])
		dump(self.cbCardData[viewid], "排序，卡牌数据")
		for i=1, self.cbCardCount[viewid] do
			local card = self.nodeHandCard[viewid]:getChildByTag(i)
			if nil ~=  card then
				local sprPath = resValue[viewid]
				print("self.bChangeCardStatus: ",self.bChangeCardStatus)
				print("排序，卡牌数值","viewid:",viewid,"i:",i,self.cbCardData[viewid][i])
				local cardIndex = GameLogic.SwitchToCardIndex(self.cbCardData[viewid][i])
				if cardIndex < 10 then
					sprPath = sprPath..string.format("0%d", cardIndex)..".png"
				else
					sprPath = sprPath..string.format("%d", cardIndex)..".png"
				end

				local spriteValue = display.newSprite(sprPath)
				--获取麻将值纹理
				local cardValue = card:getChildByName("card_value")
				if nil ~= cardValue then
					cardValue:setSpriteFrame(spriteValue:getSpriteFrame())
				end
			end
		end

		if self.cbCardCount[viewid]==14 and viewid==cmd.MY_VIEWID then
			local lastcard=self.nodeHandCard[viewid]:getChildByTag(14)
			local x=self.nodeHandCard[viewid]:getChildByTag(13):getPositionX()
			print("lastcard:getPositionX() ",lastcard:getPositionX())
			print("x:",x)
			if lastcard:getPositionX()-x<lastcard:getContentSize().width+10 then
				lastcard:setPositionX(lastcard:getPositionX()+pramHandCard[cmd.MY_VIEWID][3]/2)
			end
		end
		for i=1,#self.cbCardData[cmd.MY_VIEWID] do
			if math.ceil(self.cbCardData[cmd.MY_VIEWID][i]/16)==self.callcardKind then
				local card=self.nodeHandCard[cmd.MY_VIEWID]:getChildByTag(i)
				if card.bGray~=true then
					convertToGraySprite(card:getChildByName("card_value"))
					convertToGraySprite(card:getChildByName("card_bg"))
					card.bGray=true
				end
			else
				local card=self.nodeHandCard[cmd.MY_VIEWID]:getChildByTag(i)
				if card ~= nil then
					if card.bGray==true then
						convertToNormalSprite(card:getChildByName("card_value"))
						convertToNormalSprite(card:getChildByName("card_bg"))
						card.bGray=false
					end
				end

			end
		end
	end
end

--创建打出的手牌node
function CardLayer:createOutCardNode()
	local nodeCard = {}
	for i = 1, cmd.GAME_PLAYER do
		nodeCard[i] = cc.Node:create()
			:move(posOutcard[i])
			:addTo(self)
	end
	nodeCard[1]:setLocalZOrder(2)
	return nodeCard
end

--创建打出的手牌
function CardLayer:createOutCard(viewid, cbCardData, cbCardCount)
	--print("创建打出的麻将", viewid,cbCardCount )
	local zorder = {-1, -1, 1, 1}  --排数的层级关系
	for i=1,cbCardCount do
		--获取已经打出去的麻将
		local numOutCard = self.cbOutcardCount[viewid]
		--计算本次应该打出的麻将的起始位置（正常只有一张，重连是全部的）
		local offsetX, offsetY = 0,0
		if cmd.MY_VIEWID == viewid or cmd.TOP_VIEWID ==  viewid then --我和对面
			offsetX = math.mod(numOutCard, numPerLine)
			offsetY = math.floor(numOutCard/numPerLine)
		elseif cmd.LEFT_VIEWID == viewid or cmd.RIGHT_VIEWID == viewid then
			-- offsetX = math.floor(numOutCard/numPerLine)
			offsetX = numOutCard
			offsetY = math.mod(numOutCard, numPerLine)
		end
		print("viewid: ",viewid)
		local pos  = cc.p(pramOutCard[viewid][3]* offsetX, pramOutCard[viewid][4]* offsetY)
		--创建麻将
		local card = self:createOutOrActiveCardSprite(viewid, cbCardData[i])
		--添加到麻将node
		--print("创建打出的麻将", pos.x, pos.y,offsetX, offsetY)
		self.nodeOutcard[viewid]:addChild(card, offsetX* zorderCard[viewid] + offsetY* zorder[viewid])
		--设置位置 基础位置加上偏移量乘已经绘制的卡牌个数
		card:setPosition(pos)

		--数目更新，设置TAG
		self.cbOutcardCount[viewid] = self.cbOutcardCount[viewid] +1
		card:setTag(self.cbOutcardCount[viewid])
	end
end

--创建碰杠牌的node
function CardLayer:createActiveCardNode()
	local nodeCard = {}
	for i = 1, cmd.GAME_PLAYER do
		nodeCard[i] = cc.Node:create()
			:move(posActiveCard[i])
			:addTo(self)
	end
	nodeCard[1]:setLocalZOrder(2)

	return nodeCard
end

--	          createActiveCard(wOperateViewId, tagAvtiveCard, wProvideViewId)
--创建碰杠牌
function CardLayer:createActiveCard(viewid, tagAvtiveCard, wProvideViewId) --传入tagAvtiveCard
	print("viewid,wProvideViewId",viewid,wProvideViewId)
	print("tagAvtiveCard.cbCardNum:",tagAvtiveCard.cbCardNum)
	print("tagAvtiveCard.cbCardValue:",tagAvtiveCard.cbCardValue[1],tagAvtiveCard.cbCardValue[2],tagAvtiveCard.cbCardValue[3],tagAvtiveCard.cbCardValue[4])
	--先判断类型
	local jsonStr = cjson.encode(tagAvtiveCard)
    LogAsset:getInstance():logData(jsonStr, true)
    print("createActiveCard type: ",tagAvtiveCard.cbType)

    print("before #self.cbActiveCardData[viewid]:",#self.cbActiveCardData[viewid])
    print("before #self.nodeActiveCard[viewid]:getChildren():",#(self.nodeActiveCard[viewid]:getChildren()))
	if tagAvtiveCard.cbType == GameLogic.SHOW_BU_GANG then --补杠 已经碰过，只添加一张
		--showToast(self,"tagAvtiveCard.cbType == GameLogic.SHOW_BU_GANG",5)
		--获取位置，只添加一张
		local index = 0
		for i=1,#self.cbActiveCardData[viewid] do
			--查找是否已经碰
			local activeInfo = self.cbActiveCardData[viewid][i]
			if activeInfo.cbCardValue[1] ==  tagAvtiveCard.cbCardValue[1] then --有碰
				print("tagAvtiveCard.cbCardValue[1]:",tagAvtiveCard.cbCardValue[1])
				index = i
				break
			end
		end
		print("index:",index)
		assert(index ~= 0,"pengpai not found")
		--计算开始位置(每墩3个，杠牌有一张放在上面)
		local pos = cc.p((pramActiveCard[viewid][3]*3 +anchorPointActiveCard[viewid][1] *offsetPer)*(index -1), (pramActiveCard[viewid][4]*3 +anchorPointActiveCard[viewid][2] *10) *(index -1))
		-- if cmd.MY_VIEWID == viewid then
		-- 	card = self:createMyActiveCardSprite(tagAvtiveCard.cbCardValue[1], false)
		-- else
		-- 	card = self:createOutOrActiveCardSprite(viewid, tagAvtiveCard.cbCardValue[1], false)
		-- end
		local card = self:createOutOrActiveCardSprite(viewid, tagAvtiveCard.cbCardValue[1])
		if nil ~= card then
			self.nodeActiveCard[viewid]:addChild(card, 4 + index *3)
			card:setTag((index -1)* 10 + 4) --设置索引，方便明杠时候移除
			local psoCard = cc.p(pos.x + pramActiveCard[viewid][3], pos.y + (anchorPointActiveCard[viewid][2] == 1 and pramActiveCard[viewid][2] *math.abs(anchorPointActiveCard[viewid][2])
				or pramActiveCard[viewid][4] *2 *math.abs(anchorPointActiveCard[viewid][2]) + pramActiveCard[viewid][2] *math.abs(anchorPointActiveCard[viewid][2]))
			+ math.abs(anchorPointActiveCard[viewid][1]) *pramActiveCard[viewid][2]/5)
			card:setPosition(psoCard)
		end
		self.cbActiveCardData[viewid][index] = clone(tagAvtiveCard)
	else -- 其余牌型重新绘制
		--获取之前已经存在的牌堆数
		local numActive = #self.cbActiveCardData[viewid]
		--计算开始位置(每墩3个，杠牌有一张放在上面)
		local pos = cc.p((pramActiveCard[viewid][3]*3 +anchorPointActiveCard[viewid][1] *offsetPer) *numActive , (pramActiveCard[viewid][4]*3 +anchorPointActiveCard[viewid][2] *offsetPer) *numActive)
		print("tagAvtiveCard.cbCardNum:",tagAvtiveCard.cbCardNum)
		print("tagAvtiveCard.cbCardValue[1]:",tagAvtiveCard.cbCardValue[1])
		for i=1,tagAvtiveCard.cbCardNum do
			--创建卡牌
			local card = self:createOutOrActiveCardSprite(viewid, tagAvtiveCard.cbCardValue[1], false)
			-- if cmd.MY_VIEWID == viewid then
			-- 	card = self:createMyActiveCardSprite(tagAvtiveCard.cbCardValue[1], false)
			-- else
			-- 	card = self:createOutOrActiveCardSprite(viewid, tagAvtiveCard.cbCardValue[1], false)
			-- end
			self.nodeActiveCard[viewid]:addChild(card, -(i + numActive *3) *zorderCard[viewid])
			card:setTag(numActive* 10 + i) --设置索引，方便明杠时候移除
			--计算当前麻将的位置
			local psoCard = cc.p(pos.x + pramActiveCard[viewid][3]*(i -1), pos.y + pramActiveCard[viewid][4]*(i -1))

			--如果是第四张，放在上面
			if 4 == i then  --此处参数比较复杂，推荐画图分析
				card:setLocalZOrder(4+ numActive *3)
				psoCard = cc.p(pos.x + pramActiveCard[viewid][3], pos.y + (anchorPointActiveCard[viewid][2] == 1 and pramActiveCard[viewid][2] *math.abs(anchorPointActiveCard[viewid][2])
					or pramActiveCard[viewid][4] *2 *math.abs(anchorPointActiveCard[viewid][2]) + pramActiveCard[viewid][2] *math.abs(anchorPointActiveCard[viewid][2]))
				+ math.abs(anchorPointActiveCard[viewid][1]) *pramActiveCard[viewid][2]/5)
			end
			if nil ~= card then
				card:setPosition(psoCard)
			end
			if tagAvtiveCard.cbType == GameLogic.SHOW_AN_GANG and (not (cmd.MY_VIEWID == viewid and 4 == i))then --自己第四张不盖着
				--显示背面
				self:showActiveCardBack( viewid, card )
			end
		end
		table.insert(self.cbActiveCardData[viewid], tagAvtiveCard)
	end

	print("after #self.cbActiveCardData[viewid]:",#self.cbActiveCardData[viewid])
    print("after #self.nodeActiveCard[viewid]:getChildren():",#(self.nodeActiveCard[viewid]:getChildren()))


	--删除手上的麻将
	local deleteNum = 0
	if GameLogic.SHOW_BU_GANG ==  tagAvtiveCard.cbType then --补杠
		deleteNum = 1
	elseif GameLogic.SHOW_AN_GANG ==  tagAvtiveCard.cbType then
		deleteNum = 4
	elseif GameLogic.SHOW_MING_GANG ==  tagAvtiveCard.cbType then
		deleteNum = 3
	elseif GameLogic.SHOW_PENG ==  tagAvtiveCard.cbType  then
		deleteNum = 2
	end
	local haveDelete = 0
	if viewid == cmd.MY_VIEWID then --自己的查找删除，别人随机删除
		for i = self.cbCardCount[viewid], 1, -1 do
			if self.cbCardData[viewid][i] == tagAvtiveCard.cbCardValue[1] then
				self:removeHandCard(viewid, i)
				haveDelete = haveDelete + 1
				print("玩家操作结果 应该删除， 已经删除 i", deleteNum, haveDelete, i)
				if deleteNum == haveDelete then
					break
				end
			end
		end
	else
		for i = deleteNum, 1, -1 do
			--local index = math.random(0, self.cbCardCount[viewid] -1)
			self:removeHandCard(viewid, i)
		end
	end

	--手牌重新排序
	--刷新麻将
	self:sortHandCard(viewid)

	--如果是碰或明杠，提供玩家最后一张牌出牌删除
	if GameLogic.SHOW_MING_GANG ==  tagAvtiveCard.cbType or GameLogic.SHOW_PENG == tagAvtiveCard.cbType then
		if nil ~= self.cbOutcardCount[wProvideViewId] then
			self.nodeOutcard[wProvideViewId]:removeChildByTag(self.cbOutcardCount[wProvideViewId])
			self.cbOutcardCount[wProvideViewId] = self.cbOutcardCount[wProvideViewId] -1
		end
	end

	if viewid == cmd.MY_VIEWID	 then
		--设置可以操作
		self:setMyCardTouchEnabled(true)
	end

	print("end #self.cbActiveCardData[viewid]:",#self.cbActiveCardData[viewid])
    print("end #self.nodeActiveCard[viewid]:getChildren():",#(self.nodeActiveCard[viewid]:getChildren()))

 --    if tagAvtiveCard.cbType ~= GameLogic.SHOW_PENG then
	-- 	assert(false)
	-- end
end

--创建碰杠牌 断线重连(断线重连没有删除牌的操作，没有重新排序手牌的操作)
function CardLayer:createActiveCardReEnter(viewid, tagAvtiveCard) --传入tagAvtiveCard
		--获取之前已经存在的牌堆数
		local numActive = #self.cbActiveCardData[viewid]
		--计算开始位置(每墩3个，杠牌有一张放在上面)
		local pos = cc.p((pramActiveCard[viewid][3]*3 +anchorPointActiveCard[viewid][1] *offsetPer) *numActive , (pramActiveCard[viewid][4]*3 +anchorPointActiveCard[viewid][2] *offsetPer) *numActive)
		for i=1,tagAvtiveCard.cbCardNum do
			--创建卡牌
			local card = self:createOutOrActiveCardSprite(viewid, tagAvtiveCard.cbCardValue[1])
			-- if cmd.MY_VIEWID == viewid then
			-- 	card = self:createMyActiveCardSprite(tagAvtiveCard.cbCardValue[1], false)
			-- else
			-- 	card = self:createOutOrActiveCardSprite(viewid, tagAvtiveCard.cbCardValue[1], false)
			-- end
			self.nodeActiveCard[viewid]:addChild(card, -(i + numActive *3) *zorderCard[viewid])
			card:setTag(numActive* 10 + i) --设置索引，方便明杠时候移除
			--计算当前麻将的位置
			local psoCard = cc.p(pos.x + pramActiveCard[viewid][3]*(i -1), pos.y + pramActiveCard[viewid][4]*(i -1))

			--如果是第四张，放在上面
			if 4 == i then  --此处参数比较复杂，推荐画图分析
				card:setLocalZOrder(4 + numActive *3)
				psoCard = cc.p(pos.x + pramActiveCard[viewid][3], pos.y + (anchorPointActiveCard[viewid][2] == 1 and pramActiveCard[viewid][2] *math.abs(anchorPointActiveCard[viewid][2])
					or pramActiveCard[viewid][4] *2 *math.abs(anchorPointActiveCard[viewid][2]) + pramActiveCard[viewid][2] *math.abs(anchorPointActiveCard[viewid][2]))
				+ math.abs(anchorPointActiveCard[viewid][1]) *pramActiveCard[viewid][2]/5)
			end
			if nil ~= card then
				card:setPosition(psoCard)
			end
			-- if tagAvtiveCard.cbType == GameLogic.SHOW_MING_GANG and 4 == i then
			-- 	--显示背面
			-- 	self:showActiveCardBack( viewid, card )
			-- end
			if tagAvtiveCard.cbType == GameLogic.SHOW_AN_GANG and (not (cmd.MY_VIEWID == viewid and 4 == i))then --自己第四张不盖着
				--显示背面
				self:showActiveCardBack( viewid, card )
			end
		end
		table.insert(self.cbActiveCardData[viewid], tagAvtiveCard)
end

--发牌动画(游戏开始)
function CardLayer:sendCardToPlayer(viewid, cbCardData, cbCardCount,bTrustee)
	print("发送扑克到用户", viewid, cbCardCount,cbCardData[1])
	local heap = nil
	local pos = posHandCard[viewid]
	if 4 == cbCardCount then
		heap = cc.CSLoader:createNode(cmd.RES_PATH.."card/Node_heap.csb")
		pos = cc.p(posHandCard[viewid].x + (self.cbCardCount[viewid] +2) *pramHandCard[viewid][3], posHandCard[viewid].y  + (self.cbCardCount[viewid] +2) *pramHandCard[viewid][4])
	else --一张牌
		heap = cc.Sprite:create(cmd.RES_PATH.."card/back_normal.png")
		pos = cc.p(posHandCard[viewid].x + self.cbCardCount[viewid] * pramHandCard[viewid][3], posHandCard[viewid].y  + self.cbCardCount[viewid] * pramHandCard[viewid][4])
	end

	heap:setPosition(cc.p(667, 375))

	function callbackWithArgs(viewid, cbCardData, cbCardCount)
          local ret = function ()
          print("callbackWithArgs createHandCard",viewid, cbCardCount,cbCardData[1])
          	self:createHandCard(viewid, cbCardData, cbCardCount)
          end
          return ret
    end
    local callFun = cc.CallFunc:create(callbackWithArgs(viewid, cbCardData, cbCardCount))
    if bTrustee==true and viewid==cmd.MY_VIEWID then
    	self:createHandCard(viewid, cbCardData, cbCardCount)
    else
    	self:addChild(heap)
	 	heap:runAction(cc.Sequence:create(cc.MoveTo:create(0.3, pos), cc.Hide:create(),callFun,cc.RemoveSelf:create()))
	end
	self.heap=heap
end

--出牌动画
function CardLayer:outCard(viewid, cbCardInfo) --viewid为自己，则cbCardInfo为索引；否则cbCardInfo为牌值
	print("function CardLayer:outCard(viewid, cbCardInfo)")
	print("function CardLayer:outCard(viewid, cbCardInfo)")
	print("function CardLayer:outCard(viewid, cbCardInfo)")
	if viewid==cmd.MY_VIEWID then
		table.insert(self._scene._scene.discardCards,self.cbCardData[viewid][cbCardInfo])
	end
	print("out card")
	print("self.cbCardCount[viewid]:",self.cbCardCount[viewid])
	print("#self.cbCardData[viewid]:",#self.cbCardData[viewid])
	for i=1,#self.cbCardData[viewid] do
		print(i,self.cbCardData[viewid][i])
	end
	--计算要出的牌的位置
	print("卡牌界面出牌", viewid, cbCardInfo)
	local numOutCard = self.cbOutcardCount[viewid]
	local offsetX, offsetY = 0,0
	if cmd.MY_VIEWID == viewid or cmd.TOP_VIEWID ==  viewid then --我和对面
		offsetX = math.mod(numOutCard, numPerLine)
		offsetY = math.floor(numOutCard/numPerLine)
	elseif cmd.LEFT_VIEWID == viewid or cmd.RIGHT_VIEWID == viewid then
		offsetX = math.floor(numOutCard/numPerLine)
		offsetY = math.mod(numOutCard, numPerLine)
	end
	local pos  = cc.p(pramOutCard[viewid][3]* offsetX, pramOutCard[viewid][4]* offsetY)

	--获取目标地点相对于玩家手牌的相对位置
	local posWorld = self.nodeOutcard[viewid]:convertToWorldSpace(pos)
	local posNode = self.nodeHandCard[viewid]:convertToNodeSpace(posWorld)

	function callbackWithArgs(viewid, cbCardInfo, index)
		local ret = function ()
			print("function CardLayer:outCard callbackWithArgs")
			print("function CardLayer:outCard callbackWithArgs")
			--创建麻将，自己出牌传索引，别人出牌算牌值
			--如果是自己出牌，跟据当前选中的卡牌索引
			local cbCardData = {}
			if cmd.MY_VIEWID == viewid then
				cbCardData[1] = self.cbCardData[cmd.MY_VIEWID][cbCardInfo]
			else
				cbCardData[1] = cbCardInfo
			end
	  		--添加到麻将node
			self:createOutCard(viewid, cbCardData, 1)
			--移除手牌(自己的话根据索引，别人的牌随机一张移除)
			self:removeHandCard(viewid, index)
			--刷新麻将
			self:sortHandCard(viewid)
		end
		return ret
    end
    print("创建出牌回调",viewid, cbCardInfo)
    local index = 0
	if cmd.MY_VIEWID == viewid then
		index = cbCardInfo
	else
		index = math.random(1, self.cbCardCount[viewid])
	end
	print("出牌索引", index)
	local card = self.nodeHandCard[viewid]:getChildByTag(index)

    -- callbackWithArgs(viewid, cbCardInfo, index)() --temp delete this line and uncomment below codes

    local callFun = cc.CallFunc:create(callbackWithArgs(viewid, cbCardInfo, index))
    if nil ~= card then
    	card:runAction(cc.Sequence:create(cc.MoveTo:create(0.3, posNode), callFun))
    end
end

--托管出牌动画
function CardLayer:outCardTrustee(cbCardInfo) --托管时同一张牌的SUB_S_OUT_CARD可能比cmd.SUB_S_SEND_CARD先到导致index为0吗
	local n=#self.cbCardData[cmd.MY_VIEWID]
	local cn=#self.nodeHandCard[cmd.MY_VIEWID]:getChildren()
	-- assert(n>13)
	-- assert(cn>13)
	--查找卡牌索引
	local index = 0
	for i = self.cbCardCount[cmd.MY_VIEWID], 1, -1 do
		print("self.cbCardData[cmd.MY_VIEWID]"..i,self.cbCardData[cmd.MY_VIEWID][i])
		if self.cbCardData[cmd.MY_VIEWID][i] == cbCardInfo then
			index = i
			break
		end
	end

	print("user:",GlobalUserItem.szNickName)
	print("index:",index)
	print("cbCardInfo",cbCardInfo)

	if index==0 then
		self._scene._scene:sendAskHandCard()
		print("index==0 something wrong")
		print("index==0 something wrong")
		print("index==0 something wrong")
	end

	local tt=self._scene._scene.receivedCards
	print("自己接收的牌",table.concat(tt,","))
	tt=self._scene._scene.discardCards
	print("自己打出的牌",table.concat(tt,","))
	assert(index~=0)

	--打出麻将
	self:outCard(cmd.MY_VIEWID, index)
	self:setMyCardTouchEnabled(false)
	self._scene.nodeTips:removeAllChildren()
	--清掉数据
	self.cbListenList = {}
	self.cbHuCard = {}
	self.cbHuCardFan = {}
	self.cbHuCardLeft = {}

end

--手牌移除
function CardLayer:removeHandCard(viewId, index)
	print("viewId:",viewId,"  index:",index)
	local sprCard = self.nodeHandCard[viewId]:getChildByTag(index)
	--assert(sprCard)
	if nil ~= sprCard then
		sprCard:removeFromParent()
		self.cbCardCount[viewId] = self.cbCardCount[viewId] -1
		table.remove(self.cbCardData[viewId], index)
	end
end

function CardLayer:removeHandCards(viewId, tabCard)
	local str=table.concat(tabCard,",")
	print("removeHandCards:",str)
	print("viewId:",viewId)
	local t=self.cbCardData[viewId]
	print("before remove",#t,table.concat(t,","))
	for k,card in pairs(tabCard) do
		local found=false
		for i=1,#t do
			if t[i]==card then
				found=true
				t[i]=-1
				self.cbCardCount[viewId] = self.cbCardCount[viewId] -1
				local sprCard = self.nodeHandCard[viewId]:getChildByTag(i)
				sprCard:removeFromParent()
				break
			end
		end
		if not found then print("card"..card.."not found") end
		assert(found==true)
	end
	local temp={}
	for i=1,#self.cbCardData[viewId] do
		if self.cbCardData[viewId][i]~=-1 then
			table.insert(temp,self.cbCardData[viewId][i])
		end
	end
	self.cbCardData[viewId]=temp

	t=self.cbCardData[viewId]
	print(table.concat(t,","))
	print("after remove",#t,table.concat(t,","))
	assert(#t==10 or #t==11)
end

function CardLayer:removeHandCardsByIndex(viewId, tabIndex)
	for k,index in pairs(tabIndex) do
		local sprCard = self.nodeHandCard[viewId]:getChildByTag(index)
		if nil ~= sprCard then
			sprCard:removeFromParent()
			self.cbCardCount[viewId] = self.cbCardCount[viewId] -1
			self.cbCardData[viewId][index]=-1
		end
	end
	local temp={}
	for i=1,#self.cbCardData[viewId] do
		if self.cbCardData[viewId][i]~=-1 then
			table.insert(temp,self.cbCardData[viewId][i])
		end
	end
	self.cbCardData[viewId]=temp
end

function CardLayer:insertHandCards(viewId,cards,removedIndexs)
	print("#cards",#cards)
	print("#removedIndexs:",#removedIndexs)
	print("viewId:",viewId)
	assert(#removedIndexs==3)
	assert(#cards==3)
	local n=#self.cbCardData[viewId]
	print("n:",n)
	assert(n==10 or n==11)
	for i=1,#cards do
		local card=self:createStandCardSprite(cmd.MY_VIEWID, cards[i])
		self.nodeHandCard[viewId]:addChild(card)
		card:setTag(removedIndexs[i])
		self.cbCardCount[viewId] = self.cbCardCount[viewId] +1
		table.insert(self.cbCardData[viewId],cards[i])
	end
	print("after insert #self.cbCardData[viewId]:",#self.cbCardData[viewId])
	assert(#self.cbCardData[viewId]-n==3)
end

function CardLayer:playSceneTileHuMajong(huViewID,card)
	local index
	if huViewID == cmd.MY_VIEWID then
		for i=self.cbCardCount[huViewID],1,-1 do
			if self.cbCardData[huViewID][i]==card then
				index=i
				break
			end
		end
	else
		index=self.cbCardCount[huViewID]
	end
	print("index:",index)
	local n=self.cbCardCount[huViewID]
	print("n:",n)
	if huViewID==cmd.MY_VIEWID then
		print("self.cbCardData[huViewID][n]:",self.cbCardData[huViewID][n])
		print("card:",card)
		assert(self.cbCardData[huViewID][n]==card)
	end

	local sprCard
	if huViewID==cmd.MY_VIEWID then
		sprCard = self:createMyTileCardSprite(card)
	else
		sprCard = self:createOutOrActiveCardSprite(huViewID,card)
	end
	self.nodeHandCard[huViewID]:removeChildByTag(n)
	self.nodeHandCard[huViewID]:addChild(sprCard,n)
	sprCard:setPosition(n*pramHandCard[huViewID][3] -pramHandCard[huViewID][3]/2 ,n* pramHandCard[huViewID][4] - pramHandCard[huViewID][4]/2 )
end

function CardLayer:tileHuMajong(provideViewID,huViewID,card)
	if provideViewID==huViewID then
		self.nodeHandCard[huViewID]:removeChildByTag(self.cbCardCount[huViewID])
	else
		local n=self.cbOutcardCount[provideViewID]
		self.nodeOutcard[provideViewID]:removeChildByTag(n)
		self.cbOutcardCount[provideViewID]=n-1
		local m=self.cbCardCount[huViewID]
		self.cbCardCount[huViewID]= m+1
		self.cbCardData[huViewID][m+1]=card
	end

	local sprCard
	if huViewID==cmd.MY_VIEWID then
		sprCard = self:createMyTileCardSprite(card)
	else
		sprCard = self:createOutOrActiveCardSprite(huViewID,card)
	end

	local n=self.cbCardCount[huViewID]
	self.nodeHandCard[huViewID]:addChild(sprCard,n)
	sprCard:setPosition(n*pramHandCard[huViewID][3] - pramHandCard[huViewID][3]/2 ,n* pramHandCard[huViewID][4] - pramHandCard[huViewID][4]/2 )
end

--显示玩家倒下的牌
function CardLayer:showUserTileMajong( viewID, cbCardData,callcardKind )

	--先移除之前的
	self.nodeHandCard[viewID]:removeAllChildren()
	for i=1,#cbCardData do
		local sprCard = nil
		if viewID == cmd.MY_VIEWID then
			sprCard = self:createMyTileCardSprite(cbCardData[i])
		else
			sprCard = self:createOutOrActiveCardSprite(viewID, cbCardData[i])
		end

		if sprCard~=nil and math.ceil(cbCardData[i]/16)==callcardKind then
			sprCard.bGray=true
			convertToGraySprite(sprCard:getChildByName("card_value"))
			convertToGraySprite(sprCard:getChildByName("card_bg"))
		end

		--设置位置
		self.nodeHandCard[viewID]:addChild(sprCard, i* zorderCard[viewID])
		sprCard:setPosition(cc.p((i -1) * pramHandCard[viewID][3], (i - 1) * pramHandCard[viewID][4]))
		print("显示玩家倒下的牌",i, sprCard:getPositionX(), sprCard:getPositionY())
		sprCard:setTag(i)
	end
end

--触摸事件处理
function CardLayer:onTouchBegan(touch, event)
	if self.isTouchEnable == false then
		return false
	end
	local pos = touch:getLocation()
	--转换到手牌node
	pos = self.nodeHandCard[cmd.MY_VIEWID]:convertToNodeSpace(pos)
	print("touch begin1!", pos.x, pos.y)
	for i = 1, self.cbCardCount[cmd.MY_VIEWID] do
		local card = self.nodeHandCard[cmd.MY_VIEWID]:getChildByTag(i)
		if nil ~= card then
			local cardRect = card:getBoundingBox()
			--自己算boundBoxing
			cardRect.x = cardRect.x - (pramHandCard[cmd.MY_VIEWID][1])/2
			cardRect.y = cardRect.y - (pramHandCard[cmd.MY_VIEWID][2])/2
			print("touch begin2!", cardRect.x, cardRect.y, cardRect.width, cardRect.height)
			if cc.rectContainsPoint(cardRect, pos) then
				print("touch begin3!",self.nCurrentTouchCardTag)
				self.beginPoint = pos
				self.nCurrentTouchCardTag = i
				return true
			end
		end
	end
	return true
end

function CardLayer:onTouchMoved(touch, event)
	if self.isTouchEnable == false then
		return true
	end
	local pos = touch:getLocation()
	--print("touch move!", pos.x, pos.y)
	pos = self.nodeHandCard[cmd.MY_VIEWID]:convertToNodeSpace(pos)
	if self.beginPoint and math.pow(pos.x - self.beginPoint.x,2) + math.pow(pos.y - self.beginPoint.y,2)  < 15*15 then
		self.isMoving = false
	   	return true
	end

	--移动
	if self.nCurrentTouchCardTag ~= 0 then
		if 0 ~= self.selectTag and self.nCurrentTouchCardTag ~= self.selectTag then
			--之前弹起的缩回去
			local card = self.nodeHandCard[cmd.MY_VIEWID]:getChildByTag(self.selectTag)
			--不再提示胡牌
			self._scene.nodeTips:removeAllChildren()
			if nil ~=  card then
				card:runAction(cc.MoveTo:create(0.1, cc.p(card:getPositionX(), 0)))
			end
			self.selectTag = 0
		end

		--将牌补满(ui与值的对齐方式)
		self.isMoving = true
	end

	return true
end

function CardLayer:onTouchEnded(touch, event)
	if self.isTouchEnable == false then
		return
	end
	local pos = touch:getLocation()
	--转换到手牌node
	pos = self.nodeHandCard[cmd.MY_VIEWID]:convertToNodeSpace(pos)

	--如果是移动
	if self.isMoving then
		self.isMoving = false
		if self.bChangeCardStatus==true then
			self:popMyHandCard(self.nCurrentTouchCardTag,not self.myHandCardPopStatus[self.nCurrentTouchCardTag])
			return
		end
		--判断移动位置，主要是Y轴
		if pos.y > pramHandCard[cmd.MY_VIEWID][2] then --移动生效，出牌
			--打出麻将
			local cardOut=self.cbCardData[cmd.MY_VIEWID][self.nCurrentTouchCardTag]
			print("self.nCurrentTouchCardTag:",self.nCurrentTouchCardTag)
			print("#self.cbCardData[cmd.MY_VIEWID]:",#self.cbCardData[cmd.MY_VIEWID])
			assert(self.nCurrentTouchCardTag<=#self.cbCardData[cmd.MY_VIEWID])
			self:outCard(cmd.MY_VIEWID, self.nCurrentTouchCardTag)
			if nil==self.cbCardData[cmd.MY_VIEWID][self.nCurrentTouchCardTag] then
				for i=1,#self.cbCardData[cmd.MY_VIEWID] do
					print("mycard"..i,self.cbCardData[cmd.MY_VIEWID][i])
				end
			end
			--发消息
			self._scene._scene:sendOutCard(cardOut)

			self:setMyCardTouchEnabled(false)
			self.selectTag = 0
			self.nCurrentTouchCardTag = 0

			--出牌隐藏操作按钮
			self._scene:ShowGameBtn(GameLogic.WIK_NULL)
			--出牌之后不再提示胡牌
			self._scene.nodeTips:removeAllChildren()
			--清掉数据
			self.cbListenList = {}
			self.cbHuCard = {}
			self.cbHuCardFan = {}
			self.cbHuCardLeft = {}
		else --还原
				--之前移动牌的放回去
				local card = self.nodeHandCard[cmd.MY_VIEWID]:getChildByTag(self.nCurrentTouchCardTag)
				--不再提示胡牌
				self._scene.nodeTips:removeAllChildren()
				--计算横坐标
				local posx = (self.nCurrentTouchCardTag -1) * pramHandCard[cmd.MY_VIEWID][3]
				if nil ~=  card then
					local numActive = #self.cbActiveCardData[cmd.MY_VIEWID]
					card:setLocalZOrder((self.nCurrentTouchCardTag -1)* zorderCard[cmd.MY_VIEWID])
					card:runAction(cc.MoveTo:create(0.1, cc.p(posx, 0)))
					self.nCurrentTouchCardTag = 0
					self.selectTag = 0
				end
		end
		return
	end
	local isTouchCard = false
	print("self.cbCardCount[cmd.MY_VIEWID]:",self.cbCardCount[cmd.MY_VIEWID])
	for i = 1, self.cbCardCount[cmd.MY_VIEWID] do
		local card = self.nodeHandCard[cmd.MY_VIEWID]:getChildByTag(i)
		if nil == card then
			break
		end
		local cardRect = card:getBoundingBox()
		--自己算boundBoxing（csb获取boundBoxing 不对）
		cardRect.x = cardRect.x - (pramHandCard[cmd.MY_VIEWID][1])/2
		cardRect.y = cardRect.y - (pramHandCard[cmd.MY_VIEWID][2])/2
		if cc.rectContainsPoint(cardRect, pos) then
			if self.bChangeCardStatus==true then
				self:popMyHandCard(i,not self.myHandCardPopStatus[i])
				return
			end
			if i == self.nCurrentTouchCardTag then --如果两次选中的是同一张,而且该麻将没有弹起
				isTouchCard = true
				--设置当前麻将弹起,设置为当前选中
				card:runAction(cc.MoveTo:create(0.1, cc.p(card:getPositionX(), card:getPositionY() + 20)))
				if i ~= self.selectTag then
					--之前弹起的缩回去
					local card = self.nodeHandCard[cmd.MY_VIEWID]:getChildByTag(self.selectTag)
					--不再提示胡牌

					self._scene.nodeTips:removeAllChildren()
					if nil ~=  card then
						card:runAction(cc.MoveTo:create(0.1, cc.p(card:getPositionX(), 0)))
					end
					self.selectTag = i

				else
					local cardOut=self.cbCardData[cmd.MY_VIEWID][i]
					--打出麻将
					self:outCard(cmd.MY_VIEWID, i)
					--发消息
					print("out index i:",i)
					for i=1,#self.cbCardData[cmd.MY_VIEWID] do
						print("self.cbCardData[cmd.MY_VIEWID]["..i,self.cbCardData[cmd.MY_VIEWID][i])
					end
					self._scene._scene:sendOutCard(cardOut)

					self:setMyCardTouchEnabled(false)
					self.selectTag = 0
					self.nCurrentTouchCardTag = 0

					--出牌隐藏操作按钮
					self._scene:ShowGameBtn(GameLogic.WIK_NULL)
					--出牌之后不再提示胡牌
					self._scene.nodeTips:removeAllChildren()
					--清掉数据
					self.cbListenList = {}
					self.cbHuCard = {}
					self.cbHuCardFan = {}
					self.cbHuCardLeft = {}
				end
			end
		end
	end
	print("touch", isTouchCard, self.selectTag)
	if not isTouchCard then --如果点击麻将外，之前弹起缩回
			--之前弹起的缩回去
			local card = self.nodeHandCard[cmd.MY_VIEWID]:getChildByTag(self.selectTag)
			if nil ~=  card then
				card:runAction(cc.MoveTo:create(0.1, cc.p(card:getPositionX(), 0 ))) --card:getPositionY() - 20
			end
			self.nCurrentTouchCardTag = 0
			self.selectTag = 0
			--不再提示胡牌
			self._scene.nodeTips:removeAllChildren()
	end
end
return CardLayer
