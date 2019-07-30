local CardLayer = class("CardLayer", function(scene)
	local cardLayer = display.newLayer()
	return cardLayer
end)

local ExternalFun = appdf.req(appdf.EXTERNAL_SRC.."ExternalFun")
local GameLogic = appdf.req(appdf.GAME_SRC.."yule.sparrowhz.src.models.GameLogic")
local cmd = appdf.req(appdf.GAME_SRC.."yule.sparrowhz.src.models.CMD_Game")

local posTableCard = {cc.p(393, 546), cc.p(292, 179), cc.p(940, 187), cc.p(1044, 593)}
local posHandCard = {cc.p(280, 600), cc.p(243, 186), cc.p(1271, 0), cc.p(1110, 700)}
local posHandDownCard = {cc.p(955, 616), cc.p(251, 675), cc.p(25, 70), cc.p(1110, 215)}
local posDiscard = {cc.p(922, 465), cc.p(374, 535), cc.p(436, 258), cc.p(986, 204)}
local posBpBgCard = {cc.p(980, 616), cc.p(251, 720), cc.p(0, 81), cc.p(1111, 165)}
local anchorPointHandCard = {cc.p(0, 0), cc.p(0, 0), cc.p(1, 0), cc.p(0, 1)}
local multipleTableCard = {{1, 0}, {0, 1}, {-1, 0}, {0, -1}}
--local multipleDownCard = {{1, 0}, {0, -1}, {1, 0}, {0, -1}}
local multipleBpBgCard = {{-1, 0}, {0, -1}, {1, 0}, {0, 1}}

--local cbCardData = {1, 5, 7, 6, 34, 12, 32, 25, 18, 19, 27, 22, 33, 33}

CardLayer.TAG_BUMPORBRIDGE = 1
CardLayer.TAG_CARD_FONT = 1
CardLayer.TAG_LISTEN_FLAG = 2

CardLayer.ENUM_CARD_NORMAL = nil
CardLayer.ENUM_CARD_POPUP = 1
CardLayer.ENUM_CARD_MOVING = 2
CardLayer.ENUM_CARD_OUT = 3

CardLayer.Z_ORDER_TOP = 50

function CardLayer:onInitData()
	--body
	math.randomseed(os.time())
	self.cbCardData = {}
	self.cbCardCount = {cmd.MAX_COUNT, cmd.MAX_COUNT, cmd.MAX_COUNT, cmd.MAX_COUNT}
	self.nDiscardCount = {0, 0, 0, 0}
	self.nBpBgCount = {0, 0, 0, 0}
	self.bCardGray = {}
	self.cbCardStatus = {}
	self.nCurrentTouchCardTag = 0
	self.currentTag = 0
	self.cbListenList = {}
	self.bWin = false
	self.currentOutCard = 0
	self.nTableTailCardTag = 112
	self.nRemainCardNum = 112
	self.posTemp = cc.p(0, 0)
	self.nZOrderTemp = 0
	self.nMovingIndex = 0
	self.finishPeople = 0
	self.bSpreadCardEnabled = false
	self.bSendOutCardEnabled = false
	self.cbBpBgCardData = {{}, {}, {}, {}}
	self.userCardData = {{}, {}, {}, {}}
end

function CardLayer:onResetData()
	
	--body
	for i = 1, cmd.GAME_PLAYER do
		self.cbCardCount[i] = cmd.MAX_COUNT
		self.nDiscardCount[i] = 0
		self.nBpBgCount[i] = 0
		self.nodeDiscard[i]:removeAllChildren()
		self.nodeBpBgCard[i]:removeAllChildren()

		for j = 1, cmd.MAX_COUNT do
			local card = self.nodeHandCard[i]:getChildByTag(j)
			
			
			card:setColor(cc.c3b(255, 255, 255))
			card:setVisible(false)

			if i == cmd.MY_VIEWID then
				local width = 88
				local height = 136
				local fSpacing = width
				local widthTotal = fSpacing*cmd.MAX_COUNT
				local posX = widthTotal - width/2 - fSpacing*(j - 1)
				local posY = height/2
				
				card:setPosition(posX, posY)
				if j == 1 then
					card:setPosition(posX + 20, posY)						--每次抓的牌
				end
			end
			self.nodeHandDownCard[i]:getChildByTag(j):setVisible(false)
			self.nodeHandDownCard[i]:getChildByTag(j):removeAllChildren()
		end
		self.nodeHandDownCard[i]:setPosition(posHandDownCard[i])
	end
	self:stopAllActions()
	self.cbCardData = {}
	self.bCardGray = {}
	self.cbCardStatus = {}
	self.nCurrentTouchCardTag = 0
	self.nMovingIndex = 0
	self.nZOrderTemp = 0
	self.currentTag = 0
	self.cbListenList = {}
	self.bWin = false
	self.currentOutCard = 0
	self.nTableTailCardTag = 112
	self.nRemainCardNum = 112
	self.posTemp = cc.p(0, 0)
	self.finishPeople = 0
	self:promptListenOutCard(nil)
	self.bSpreadCardEnabled = false
	self.bSendOutCardEnabled = false
	self.cbBpBgCardData = {{}, {}, {}, {}}
	self.userCardData = {{}, {}, {}, {}}
	self.beginPoint = nil
end

function CardLayer:ctor(scene)
	self._scene = scene
	self:onInitData()

	ExternalFun.registerTouchEvent(self, true)
	--桌牌
	--self.nodeTableCard = self:createTableCard()
	--手牌
	self.nodeHandCard = self:createHandCard()
	--铺着的手牌
	self.nodeHandDownCard = self:createHandDownCard()
	--弃牌
	self.nodeDiscard = self:createDiscard()
	--碰或杠牌
	self.nodeBpBgCard = self:createBpBgCard()

	
end

--创建立着的手牌
function CardLayer:createHandCard()
	local res = 
	{
		cmd.RES_PATH.."game/card_back_up.png",
		cmd.RES_PATH.."game/card_left.png", 
		cmd.RES_PATH.."game/font_big/card_up.png",
		cmd.RES_PATH.."game/card_right.png"
	}

	local nodeCard = {}

	for i = 1, cmd.GAME_PLAYER do
		local bVert = i == 1 or i == cmd.MY_VIEWID
		local width = 0
		local height = 0
		local fSpacing = 0
		if i == 1 then
			width = 44
			height = 67
			fSpacing = width
		elseif i == cmd.MY_VIEWID then
			width = 88
			height = 136
			fSpacing = width
		else
			width = 28
			height = 75
			fSpacing = 31
		end

		local widthTotal = fSpacing*cmd.MAX_COUNT
		local heightTotal = height + fSpacing*(cmd.MAX_COUNT - 1)
		nodeCard[i] = cc.Node:create()
			:move(posHandCard[i])
			:setContentSize(bVert and cc.size(widthTotal, height) or cc.size(width, heightTotal))
			:setAnchorPoint(anchorPointHandCard[i])
			:addTo(self, 1)

		
		for j = 1, cmd.MAX_COUNT do
			if i == 1 then
				pos = cc.p(width/2 + fSpacing*(j - 1), height/2)
			elseif i == 2 then
				pos = cc.p(width/2, height/2 + fSpacing*(j - 1))
			elseif i == cmd.MY_VIEWID then
				pos = cc.p(widthTotal - width/2 - fSpacing*(j - 1), height/2)
			elseif i == 4 then
				pos = cc.p(width/2, heightTotal - height/2 - fSpacing*(j - 1))
			end
			local card = display.newSprite(res[i])
				:move(pos)
				:setTag(j)
				:setVisible(false)
				:addTo(nodeCard[i])



			if i == cmd.MY_VIEWID then
				local cardData = GameLogic.MAGIC_DATA
				local nValue = math.mod(cardData, 16)
				local nColor = math.floor(cardData/16)
				local strFile = cmd.RES_PATH.."game/font_big/font_"..nColor.."_"..nValue..".png"
				local font = display.newSprite(strFile)
					:move(width/2, height/2 - 15)
					:setTag(1)
					:addTo(card)
				if cardData == 0x35 then
				    --local lai = cc.Sprite:create(cmd.RES_PATH.."game/lai.png"):move(70.5,112):addTo(card)
				end

				--card:setTextureRect(cc.rect(0, 0, 69, 136))
				if j == 1 then
					local x, y = card:getPosition()
					card:setPositionX(x + 20)						--每次抓的牌
				end
				--提示听牌的小标记
				display.newSprite("#sp_listenPromptFlag.png")
					:move(69/2, 136 + 25)
					:setTag(CardLayer.TAG_LISTEN_FLAG)
					:setVisible(false)
					:addTo(card)
			elseif i == 2 then
				card:setLocalZOrder(30 - j)	--修改了Z轴顺序，设置重叠效果   **** 需注意处理 ******
			end
		end
	end
	nodeCard[cmd.MY_VIEWID]:setLocalZOrder(2)

	return nodeCard
end

--创建铺着的手牌
function CardLayer:createHandDownCard()
	local width = {44, 55, 88, 55}
	local height = {67, 47, 136, 47}
	local fSpacing = {width[1], 32, width[cmd.MY_VIEWID], 32}
	local res = 
	{
		cmd.RES_PATH.."game/font_small/card_back.png",
		cmd.RES_PATH.."game/font_small_side/card_back.png",
		cmd.RES_PATH.."game/font_big/card_back.png",
		cmd.RES_PATH.."game/font_small_side/card_back.png"
	}

	

	local nodeCard = {}
	for i = 1, cmd.GAME_PLAYER do
		nodeCard[i] = cc.Node:create()
			:move(posHandDownCard[i])
			--:setContentSize(1, 1)
			:setAnchorPoint(cc.p(0, 0))
			:addTo(self, 2)
		for j = 1, cmd.MAX_COUNT do
			local card = display.newSprite(res[i])
				--:move(fSpacing[i]*multipleDownCard[i][1]*j, fSpacing[i]*multipleDownCard[i][2]*j)
				--:setTextureRect(cc.rect(0, 0, width[i], height[i]))
				:setVisible(false)
				:setTag(cmd.MAX_COUNT - j +1)
				:addTo(nodeCard[i])
			
			if i==1 then
				card:move(-fSpacing[i]*j, 0)
			elseif i==2 then
				card:move(0, -fSpacing[i]*j)
			elseif i==3 then
				card:move(fSpacing[i]*j, 0)
			elseif i==4 then
				card:move(0, fSpacing[i]*j)
				card:setLocalZOrder(cmd.MAX_COUNT - j +1)
			end
			
		end
	end

	return nodeCard
end

--创建弃牌
function CardLayer:createDiscard()
	local nodeCard = {}
	for i = 1, cmd.GAME_PLAYER do
		nodeCard[i] = cc.Node:create()
			:move(posDiscard[i])
			--:setScale(0.7)        --缩小打出的牌（桌面不够用）    **** 需注意处理 ******
			:addTo(self)
	end
	--nodeCard[1]:setLocalZOrder(2)

	return nodeCard
end
--创建碰或杠牌
function CardLayer:createBpBgCard()
	local nodeCard = {}
	for i = 1, cmd.GAME_PLAYER do
		nodeCard[i] = cc.Node:create()
			:move(posBpBgCard[i])
			:addTo(self)
	end
	nodeCard[cmd.MY_VIEWID]:setLocalZOrder(2)
	nodeCard[4]:setLocalZOrder(1)

	return nodeCard
end
function CardLayer:onTouchBegan(touch, event)
	local pos = touch:getLocation()
	local parentPosX, parentPosY = self.nodeHandCard[cmd.MY_VIEWID]:getPosition()
	local parentSize = self.nodeHandCard[cmd.MY_VIEWID]:getContentSize()
	local posRelativeCard = cc.p(0, 0)
	posRelativeCard.x = pos.x - (parentPosX - parentSize.width)
	posRelativeCard.y = pos.y - parentPosY

	for i = 1, cmd.MAX_COUNT do
		local card = self.nodeHandCard[cmd.MY_VIEWID]:getChildByTag(i)
		local cardRect = card:getBoundingBox()
		if cc.rectContainsPoint(cardRect, posRelativeCard) and card:isVisible() and not self.bCardGray[i] then
			--print("touch begin!", pos.x, pos.y)
			self.nCurrentTouchCardTag = i
			self.beginPoint = pos
			--缓存
			self.posTemp.x, self.posTemp.y = card:getPosition()
			self.nZOrderTemp = card:getLocalZOrder()
			--将牌补满(ui与值的对齐方式)
			local nCount = 0
			local num = math.mod(self.cbCardCount[cmd.MY_VIEWID], 3)
			if num == 2 then
				nCount = self.cbCardCount[cmd.MY_VIEWID]
			elseif num == 1 then
				nCount = self.cbCardCount[cmd.MY_VIEWID] + 1
			else
				assert(false)
			end
			local index = nCount - i + 1

			return true
		end
	end

	return false
end
function CardLayer:onTouchMoved(touch, event)
	local pos = touch:getLocation()
	--print("touch move!", pos.x, pos.y)

	local parentPosX, parentPosY = self.nodeHandCard[cmd.MY_VIEWID]:getPosition()
	local parentSize = self.nodeHandCard[cmd.MY_VIEWID]:getContentSize()
	local posRelativeCard = cc.p(0, 0)
	posRelativeCard.x = pos.x - (parentPosX - parentSize.width)
	posRelativeCard.y = pos.y - parentPosY

	if self.beginPoint and math.pow(pos.x - self.beginPoint.x,2) + math.pow(pos.y - self.beginPoint.y,2)  < 15*15 then
		
	   return true
	end

	--移动
	if self.nCurrentTouchCardTag ~= 0 then
		--将牌补满(ui与值的对齐方式)
		local nCount = 0
		local num = math.mod(self.cbCardCount[cmd.MY_VIEWID], 3)
		if num == 2 then
			nCount = self.cbCardCount[cmd.MY_VIEWID]
		elseif num == 1 then
			nCount = self.cbCardCount[cmd.MY_VIEWID] + 1
		else
			assert(false)
		end
		local index = nCount - self.nCurrentTouchCardTag + 1

		self.cbCardStatus[index] = CardLayer.ENUM_CARD_MOVING
		local card = self.nodeHandCard[cmd.MY_VIEWID]:getChildByTag(self.nCurrentTouchCardTag)
		card:setPosition(posRelativeCard)
		card:setLocalZOrder(CardLayer.Z_ORDER_TOP)
		--有则提示听牌
		local cbPromptHuCard ,leftCount= self._scene._scene:getListenPromptHuCard(self.cbCardData[index])
		if self.nMovingIndex ~= index and math.mod(self.cbCardCount[cmd.MY_VIEWID], 3) == 2 then
			self._scene:setListeningCard(cbPromptHuCard,leftCount)
		end
		self.nMovingIndex = index
	end

	return true
end
function CardLayer:onTouchEnded(touch, event)
	if self.nCurrentTouchCardTag == 0 then
		return true
	end

	local pos = touch:getLocation()
	-- --print("touch end!", pos.x, pos.y)
	local parentPosX, parentPosY = self.nodeHandCard[cmd.MY_VIEWID]:getPosition()
	local parentSize = self.nodeHandCard[cmd.MY_VIEWID]:getContentSize()
	local posRelativeCard = cc.p(0, 0)
	posRelativeCard.x = pos.x - (parentPosX - parentSize.width)
	posRelativeCard.y = pos.y - parentPosY

	for i = 1, cmd.MAX_COUNT do
		local card = self.nodeHandCard[cmd.MY_VIEWID]:getChildByTag(i)
		local cardRect = card:getBoundingBox()
		if cc.rectContainsPoint(cardRect, posRelativeCard) and card:isVisible() and not self.bCardGray[i] then
			--将牌补满(ui与值的对齐方式)
			local nCount = 0
			local num = math.mod(self.cbCardCount[cmd.MY_VIEWID], 3)
			if num == 2 then
				nCount = self.cbCardCount[cmd.MY_VIEWID]
			elseif num == 1 then
				nCount = self.cbCardCount[cmd.MY_VIEWID] + 1
			else
				assert(false)
			end
			local index = nCount - i + 1		--算出这张牌对应牌值在self.cbCardData里的下标(cbCardData与cbCardStatus保持一致)
			if self.nCurrentTouchCardTag == i then
				if self.cbCardStatus[index] == CardLayer.ENUM_CARD_NORMAL then 		--原始状态
					--恢复
					self.cbCardStatus = {}
					for v = 1, cmd.MAX_COUNT do
						local cardTemp = self.nodeHandCard[cmd.MY_VIEWID]:getChildByTag(v)
						cardTemp:setPositionY(136/2)
					end
					--弹出
					self.cbCardStatus[index] = CardLayer.ENUM_CARD_POPUP
					card:setPositionY(136/2 + 30)
					--有则提示听牌
					if math.mod(self.cbCardCount[cmd.MY_VIEWID], 3) == 2 then
						local cbPromptHuCard,leftCount = self._scene._scene:getListenPromptHuCard(self.cbCardData[index])
						self._scene:setListeningCard(cbPromptHuCard,leftCount)
					end
					
				elseif self.cbCardStatus[index] == CardLayer.ENUM_CARD_POPUP then 		--弹出状态
					if math.mod(self.cbCardCount[cmd.MY_VIEWID], 3) == 2 then
						--出牌"
						
						if self:touchSendOutCard(self.cbCardData[index]) then
						
							card:setVisible(false)
							self:removeHandCard(cmd.MY_VIEWID, {self.cbCardData[index]}, true)
							
						end
					else
						--弹回
					end
					if self.cbCardStatus[index] then
						self.cbCardStatus[index] = CardLayer.ENUM_CARD_NORMAL
					end
					card:setPositionY(136/2)
				elseif self.cbCardStatus[index] == CardLayer.ENUM_CARD_MOVING then 		--移动状态
					--恢复
					self.cbCardStatus = {}
					for v = 1, cmd.MAX_COUNT do
						local cardTemp = self.nodeHandCard[cmd.MY_VIEWID]:getChildByTag(v)
						cardTemp:setPositionY(136/2)
					end
					self.cbCardStatus[index] = CardLayer.ENUM_CARD_POPUP
					card:setPosition(self.posTemp.x, 136/2 + 30)
					card:setLocalZOrder(self.nZOrderTemp)
					--判断
					--local rectDiscardPool = cc.rect(324, 218, 686, 283)
					if math.mod(self.cbCardCount[cmd.MY_VIEWID], 3) == 2 and pos.y >= 190 then
						--出牌"
						if self:touchSendOutCard(self.cbCardData[index]) then
							card:setVisible(false)
							card:setPosition(self.posTemp.x, 136/2)
							self:removeHandCard(cmd.MY_VIEWID, {self.cbCardData[index]}, true)
						end
					end
				elseif self.cbCardStatus[index] == CardLayer.ENUM_CARD_OUT then 		--已出牌状态
					assert(false)
				end
				break
			end
		end
		--规避没点到牌的情况
		if i == cmd.MAX_COUNT then
			local cardTemp = self.nodeHandCard[cmd.MY_VIEWID]:getChildByTag(self.nCurrentTouchCardTag)
			cardTemp:setPosition(self.posTemp)
			cardTemp:setLocalZOrder(self.nZOrderTemp)
			self.cbCardStatus = {}
		end
	end
	self.nCurrentTouchCardTag = 0
	self.nZOrderTemp = 0
	return true
end

function CardLayer:onTouchCancelled(touch, event)
	for j = 1, cmd.MAX_COUNT do
		local card = self.nodeHandCard[cmd.MY_VIEWID]:getChildByTag(j)
		width = 88
		height = 136
		fSpacing = width
		local widthTotal = fSpacing*cmd.MAX_COUNT
		local posX = widthTotal - width/2 - fSpacing*(j - 1)
		local posY = height/2
		card:setPosition(posX, posY)
		if j == 1 then
			card:setPosition(posX + 20, posY)						--每次抓的牌
		end
	end
end

--发牌
function CardLayer:sendCard(cardData, cardCount)
	assert(type(cardData) == "table" and type(cardCount) == "table")

	self.bSpreadCardEnabled = true
	self.userCardData = cardData
	self.cbCardData = clone(cardData[cmd.MY_VIEWID])
	self.cbCardCount = cardCount
	self.finishPeople = 0
	local fDelayTime = 0.2
	for i = 1, cmd.GAME_PLAYER do
		if cardCount[i] > 0 then
			self.finishPeople = self.finishPeople +1
			self:spreadCard(i, fDelayTime, 1)
		end
		self.nRemainCardNum = self.nRemainCardNum - self.cbCardCount[i]
	end

end

--伸展牌
function CardLayer:spreadCard(viewId, fDelayTime, nCurrentCount)
	if not self.bSpreadCardEnabled then
		return false
	end

	if not self._scene.bIsVideo then
		--posHandDownCard = {cc.p(955, 616), cc.p(251, 675), cc.p(25, 70), cc.p(1110, 215)}
		posHandDownCard = {cc.p(955, 665), cc.p(210, 670), cc.p(25, 70), cc.p(1165, 215)}
	end
	
	local nodeParent = self.nodeHandDownCard[viewId]

	if nCurrentCount <= self.cbCardCount[viewId] then
		--local posX, posY = nodeParent:getPosition()

		local downCard = nodeParent:getChildByTag(nCurrentCount)

		local downCardSize = downCard:getContentSize()
		downCard:setVisible(true)

		--posHandDownCard[viewId]

		if viewId == 1 then
			nodeParent:setPositionX(posHandDownCard[viewId].x + downCardSize.width*6.5 - downCardSize.width/2*nCurrentCount)
		elseif viewId == 2 then
			nodeParent:setPositionY(posHandDownCard[viewId].y + 32*6.5 -32/2*nCurrentCount)
		elseif viewId == 3 then
			if #self.cbCardData== 13 then
				nodeParent:setPositionX(posHandDownCard[viewId].x - downCardSize.width*7.5 + downCardSize.width/2*nCurrentCount)
			else
				nodeParent:setPositionX(posHandDownCard[viewId].x - downCardSize.width*7 + downCardSize.width/2*nCurrentCount)
			end
			
		elseif viewId == 4 then
			nodeParent:setPositionY(posHandDownCard[viewId].y - 32*6.5 +32/2*nCurrentCount)
		end


		self._scene._scene:PlaySound(cmd.RES_PATH.."sound/OUT_CARD.wav")

		self:runAction(cc.Sequence:create(
			cc.DelayTime:create(fDelayTime),
			cc.CallFunc:create(function(ref)
				return self:spreadCard(viewId, fDelayTime, nCurrentCount + 1)
			end)))
	else
		self.finishPeople = self.finishPeople -1
		
		if self.finishPeople <= 0 then
			self:spreadCardFinish()
			
		end
		if viewId~= cmd.MY_VIEWID then
			nodeParent:setPosition(posHandDownCard[viewId])
		end

		return true
	end
end

--发完牌
function CardLayer:spreadCardFinish()
	--GameLogic.SortCardList(self.cbCardData)
	--[[local res1 = 
	{
		cmd.RES_PATH.."game/font_small/card_down.png",
		cmd.RES_PATH.."game/font_small_side/card_down.png", 
		cmd.RES_PATH.."game/font_small/card_down.png",
		cmd.RES_PATH.."game/font_small_side/card_down.png"
	}]]
	--print("kkkkkkkkkkkkkkkkkkkkkkkk1"..self.nRemainCardNum)
	--dump(self.cbCardCount,"kkkkkkkkkkkkkkkkkkkkkkkk2")
	for i = 1, cmd.GAME_PLAYER do
		GameLogic.SortCardList(self.userCardData[i])
		--self.nRemainCardNum = self.nRemainCardNum - self.cbCardCount[i]
		local childTable = self.nodeHandDownCard[i]:getChildren()
		for j = 1, #childTable do --cmd.MAX_COUNT do
			--if self._scene.bIsVideo and i~=cmd.MY_VIEWID  then
				--childTable[j]:setTexture(res1[i])
			--end
			childTable[j]:setVisible(false)
		end
		--dump(self.userCardData[i],"kkkkkkkkkkkkkk")
		self:setHandCard(i, self.cbCardCount[i], self.userCardData[i])
	end

	self._scene:setRemainCardNum(self.nRemainCardNum)
	self._scene:sendCardFinish()
end

--抓牌
function CardLayer:catchCard(viewId, cardData, bTail)
	--print("7777777777777777777,self.cbCardCount[viewId]="..self.cbCardCount[viewId])
	--assert(math.mod(self.cbCardCount[viewId], 3) == 1 , "Can't catch card!")
	self._scene._scene:playRandomSound(viewId)

	local HandCard = self.nodeHandCard[viewId]:getChildByTag(1)
	HandCard:setVisible(true)

	self.cbCardCount[viewId] = self.cbCardCount[viewId] + 1
	self.nRemainCardNum = self.nRemainCardNum - 1
	self._scene:setRemainCardNum(self.nRemainCardNum)
	if viewId == cmd.MY_VIEWID then
		table.insert(self.cbCardData, cardData)
		--设置纹理
		--local rectX = self:switchToCardRectX(cardData)
		local nValue = math.mod(cardData, 16)
		local nColor = math.floor(cardData/16)
		local strFile = cmd.RES_PATH.."game/font_big/font_"..nColor.."_"..nValue..".png"
		local cardFont = HandCard:getChildByTag(CardLayer.TAG_CARD_FONT)
		cardFont:setTexture(strFile)
		if HandCard:getChildByTag(666) then
			HandCard:removeChildByTag(666)
		end

		if cardData == GameLogic.MAGIC_DATA  then
		    local lai = cc.Sprite:create(cmd.RES_PATH.."game/lai.png"):move(70.5,112):setTag(666):addTo(HandCard)	    
		end

		--假如可以听牌
		local cbPromptCardData = self._scene._scene:getListenPromptOutCard()
		if #cbPromptCardData > 0 then
			self:promptListenOutCard(cbPromptCardData)
		end
	end
end

function CardLayer:catchCardVideo(viewId, cardData)
	self._scene._scene:playRandomSound(viewId)
	local HandCard = nil
	if viewId ~= cmd.MY_VIEWID then
		HandCard = self.nodeHandDownCard[viewId]:getChildByTag(1)
		HandCard:setVisible(true)
		--print("ggggggggggggggggggg111111111")
	else
		HandCard = self.nodeHandCard[viewId]:getChildByTag(1)
		HandCard:setVisible(true)
	end
	self.cbCardCount[viewId] = self.cbCardCount[viewId] + 1
	self.nRemainCardNum = self.nRemainCardNum - 1
	--print("hhhhhhhhhhh===========>,"..self.nRemainCardNum)
	self._scene:setRemainCardNum(self.nRemainCardNum)

	local res1 = 
	{
		cmd.RES_PATH.."game/font_small/",
		cmd.RES_PATH.."game/font_small_side/", 
		cmd.RES_PATH.."game/font_big/",
		cmd.RES_PATH.."game/font_small_side/"
	}
		table.insert(self.userCardData[viewId], cardData)
		if viewId == cmd.MY_VIEWID then
			self.cbCardData = self.userCardData[viewId]
		else
			HandCard:setTexture(res1[viewId].."card_down.png")
		end

		--设置纹理
		--local rectX = self:switchToCardRectX(cardData)
		local nValue = math.mod(cardData, 16)
		local nColor = math.floor(cardData/16)
		local strFile = res1[viewId].."font_"..nColor.."_"..nValue..".png"
		local cardFont = HandCard:getChildByTag(CardLayer.TAG_CARD_FONT)
		if cardFont then
			cardFont:setTexture(strFile)
		else
			local width =55
			local height = 47

			if viewId == 1 then
				 width =44
				 height = 67
			end
				
			local font = display.newSprite(strFile)
				:move(width/2, height/2 +8)
				:setTag(1)
				:addTo(HandCard)
		end

		HandCard:removeChildByTag(666)

		local point1=
				{
					cc.p(35,55),
					cc.p(42,25),
					cc.p(70.5,112),
					cc.p(12,38)
				}

		if cardData == GameLogic.MAGIC_DATA  then
		    local lai = cc.Sprite:create(cmd.RES_PATH.."game/lai.png"):move(point1[viewId]):setTag(666):addTo(HandCard)
			if viewId~= 3 then
				lai:setScale(0.5)
			end

			if viewId == 2 then
				lai:setRotation(90)
			elseif viewId == 4 then
				lai:setRotation(270)
			end	    
		end

		

end



--设置本方牌值
function CardLayer:setHandCard(viewId, cardCount, cardData)
	
	if cardCount == 0  or not cardCount then
		return
	end

	--先全部隐藏
	for j = 1, cmd.MAX_COUNT do
		self.nodeHandCard[viewId]:getChildByTag(j):setVisible(false)
		self.nodeHandDownCard[viewId]:getChildByTag(j):setVisible(false)
	end

	self.cbCardCount[viewId] = cardCount

	self.bSendOutCardEnabled = true
	
	--再显示

	if self.cbCardCount[viewId] ~= 0 then
		local nCount = 0
		print("kkkkkkkkkkkkkkkkkkkkk,"..self.cbCardCount[viewId]..","..viewId)
		local num = math.mod(self.cbCardCount[viewId], 3)
		if num == 2 then
			nCount = self.cbCardCount[viewId]
		elseif num == 1 then
			nCount = self.cbCardCount[viewId] + 1
		else

			assert(false)
		end
		

		for j = 1, self.cbCardCount[viewId] do
			local card = self.nodeHandCard[viewId]:getChildByTag(nCount - j + 1)
			if card then
				card:setVisible(true)
			end
			
			if viewId == cmd.MY_VIEWID then

				if #cardData == 0 or not cardData then
					break
				else		
					self.cbCardData = clone(cardData)
					self.userCardData[3] = self.cbCardData
				end

				if j<= #self.cbCardData then
					local cardFont = card:getChildByTag(CardLayer.TAG_CARD_FONT)
					local nValue = math.mod(self.cbCardData[j], 16)
					local nColor = math.floor(self.cbCardData[j]/16)
					local strFile = "game/font_big/font_"..nColor.."_"..nValue..".png"

					if card:getChildByTag(666) then
						card:removeChildByTag(666)
					end

					if self.cbCardData[j] == GameLogic.MAGIC_DATA then
					    local lai = cc.Sprite:create(cmd.RES_PATH.."game/lai.png"):move(70.5,112):setTag(666):addTo(card)				    
					end
					
					cardFont:setTexture(strFile)
				end
			end

			--*****************************************************回放************************************************************

			if self._scene.bIsVideo and viewId ~= cmd.MY_VIEWID then
				local res1 = 
				{
					cmd.RES_PATH.."game/font_small/",
					cmd.RES_PATH.."game/font_small_side/", 
					cmd.RES_PATH.."game/font_small/",
					cmd.RES_PATH.."game/font_small_side/"
				}

				local point1=
				{
					cc.p(35,55),
					cc.p(42,25),
					cc.p(0,0),
					cc.p(12,38)
				}

				if card then
					card:setVisible(false)
				end

				local othercard = self.nodeHandDownCard[viewId]:getChildByTag(nCount - j + 1)
					if othercard then
						othercard:setVisible(true)
					end
				local width =55
				local height = 47

				if viewId == 1 then
					 width =44
					 height = 67
				end
				self.userCardData[viewId] = clone(cardData)
				
				if j<= #self.userCardData[viewId] then

					
					othercard:setTexture(res1[viewId].."card_down.png")

					if othercard:getChildByTag(1) then
						othercard:removeChildByTag(1)
					end

					local nValue = math.mod(self.userCardData[viewId][j], 16)
					local nColor = math.floor(self.userCardData[viewId][j]/16)
					local strFile = res1[viewId].."font_"..nColor.."_"..nValue..".png"
					local font = display.newSprite(strFile)
						:move(width/2, height/2 +8)
						:setTag(1)
						:addTo(othercard)
					if viewId == 4 then
						font:setRotation(180)
					end


					if othercard:getChildByTag(666) then
						othercard:removeChildByTag(666)
					end

					if self.userCardData[viewId][j] == GameLogic.MAGIC_DATA then
					    local lai = cc.Sprite:create(cmd.RES_PATH.."game/lai.png"):move(point1[viewId]):setScale(0.5):setTag(666):addTo(othercard)				    
						if viewId == 2 then
							lai:setRotation(90)
						elseif viewId == 4 then
							lai:setRotation(270)
						end
					end
					
					
				end
			end
		end
	end
end

--删除手上的牌
function CardLayer:removeHandCard(viewId, cardData, bOutCard)
	assert(type(cardData) == "table")
	local cbRemainCount = self.cbCardCount[viewId] - #cardData
	if bOutCard and math.mod(cbRemainCount, 3) ~= 1 then
		return false
	end
	
	self.cbCardCount[viewId] = cbRemainCount

	if viewId == cmd.MY_VIEWID or self._scene.bIsVideo then
		for i = 1, #cardData do
			for j = #self.userCardData[viewId],1,-1 do
				if self.userCardData[viewId][j] == cardData[i] then
					table.remove(self.userCardData[viewId], j)
					break
				end
				--assert(j ~= #self.cbCardData, "WithOut this card to remove!")
			end
		end
		if viewId == cmd.MY_VIEWID then
			self.cbCardData = clone(self.userCardData[viewId])
		end
		--dump(self.cbCardData,"hhhhhhhhhhhhhhh")

		GameLogic.SortCardList(self.userCardData[viewId])
	end

	

	self:setHandCard(viewId, self.cbCardCount[viewId], self.userCardData[viewId])
	
	return true
end

--牌打到弃牌堆
function CardLayer:discard(viewId, cardData)
	local res1 = 
	{
		cmd.RES_PATH.."game/font_small/",
		cmd.RES_PATH.."game/font_small_side/", 
		cmd.RES_PATH.."game/font_small/",
		cmd.RES_PATH.."game/font_small_side/"
	}
	local res = cmd.RES_PATH..string.format("game/cardDown_%d.png", viewId)
	local width = 0
	local height = 0
	local fSpacing = 0
	local posX = 0
	local posY = 0
	local pos = cc.p(0, 0)
	local nLimit = 0
	local fBase = 0
	local countTemp = self.nDiscardCount[viewId]
	local bVert = viewId == 1 or viewId == cmd.MY_VIEWID
	if bVert then
		width = 44
		height = 67
		fSpacing = width
		nLimit = 12

		while countTemp >= nLimit*2 do   	--超过一层
			fBase = fBase + height - 51
			countTemp = countTemp - nLimit*2
		end

		while countTemp >= nLimit do 		--超过一行
			posY = posY - 51
			countTemp = countTemp - nLimit
		end

		local posX = fSpacing*countTemp
		pos = viewId == cmd.MY_VIEWID and cc.p(posX, posY + fBase) or cc.p(-posX, -posY + fBase)
	else
		width = 55
		height = 47
		fSpacing = 33
		nLimit = 11

		while countTemp >= nLimit*2 do 		--超过一层
			fBase = fBase + 14
			countTemp = countTemp - nLimit*2
		end

		while countTemp >= nLimit do 		--超过一行
			posX = posX - width
			countTemp = countTemp - nLimit
		end

		local posY = fSpacing*countTemp
		pos = viewId == 4 and cc.p(-posX, posY + fBase) or cc.p(posX, -posY + fBase)
	end

	--local rectX = self:switchToCardRectX(cardData)
	local nValue = math.mod(cardData, 16)
	local nColor = math.floor(cardData/16)
	--牌底
	local card = display.newSprite(res1[viewId].."card_down.png")
		:move(pos)
		--:setTextureRect(cc.rect(width*rectX, 0, width, height))
		:setTag(self.nDiscardCount[viewId] + 1)
		:addTo(self.nodeDiscard[viewId])
	--字体
	local strFile = res1[viewId].."font_"..nColor.."_"..nValue..".png"
	local cardFont = display.newSprite(strFile)
		:move(width/2, height/2 + 8)
		:addTo(card)
	if viewId == 1 or viewId == 4 then
		cardFont:setRotation(180)
	end	
	--修改了Z轴顺序，设置重叠效果   **** 需注意处理 ******
	if viewId == 1 or viewId == 4 then
		local nOrder = 0
		if self.nDiscardCount[viewId] >= nLimit*6 then
			assert(false)
		elseif self.nDiscardCount[viewId] >= nLimit*4 then
			nOrder = 80 - (self.nDiscardCount[viewId] - nLimit*4)
		elseif self.nDiscardCount[viewId] >= nLimit*2 then
			nOrder = 80 - (self.nDiscardCount[viewId] - nLimit*2)*2
		else
			nOrder = 80 - self.nDiscardCount[viewId]*3
		end
		card:setLocalZOrder(nOrder)
	end
	--计数
	self.nDiscardCount[viewId] = self.nDiscardCount[viewId] + 1
end

--从弃牌堆回收牌（有人要这张牌，碰或杠等）
function CardLayer:recycleDiscard(viewId)
	self.nodeDiscard[viewId]:getChildByTag(self.nDiscardCount[viewId]):removeFromParent()
	self.nDiscardCount[viewId] = self.nDiscardCount[viewId] - 1
end

--碰或杠
function CardLayer:bumpOrBridgeCard(viewId, cbCardData, nShowStatus)
	assert(type(cbCardData) == "table")
	local resCard = 
	{
		cmd.RES_PATH.."game/font_small/card_down.png",
		cmd.RES_PATH.."game/font_small_side/card_down.png", 
		cmd.RES_PATH.."game/font_middle/card_down.png",
		cmd.RES_PATH.."game/font_small_side/card_down.png"
	}
	local resFont = 
	{
		cmd.RES_PATH.."game/font_small/",
		cmd.RES_PATH.."game/font_small_side/", 
		cmd.RES_PATH.."game/font_middle/",
		cmd.RES_PATH.."game/font_small_side/"
	}
	local width = 0
	local height = 0
	local widthTotal = 0
	local heightTotal = 0
	local fSpacing = 0
	if viewId == 1 then
		width = 44
		height = 67
		fSpacing = width
	elseif viewId == 3 then
		width = 80
		height = 116
		fSpacing = width
	else
		width = 55
		height = 47
		fSpacing = 32
	end

	local fN = {15, 15, 15, 15}
	local fParentSpacing = fSpacing*3 + fN[viewId]
	local nodeParent = cc.Node:create()
		:move(self.nBpBgCount[viewId]*fParentSpacing*multipleBpBgCard[viewId][1], 
				self.nBpBgCount[viewId]*fParentSpacing*multipleBpBgCard[viewId][2])
		:addTo(self.nodeBpBgCard[viewId])

	if nShowStatus ~= GameLogic.SHOW_CHI then
		--明杠
		if nShowStatus == GameLogic.SHOW_MING_GANG then
			nodeParentMG = self.nodeBpBgCard[viewId]:getChildByTag(cbCardData[1])
			--assert(nodeParentMG, "None of this bump card!")
			if nodeParentMG then
				self.nBpBgCount[viewId] = self.nBpBgCount[viewId] - 1
				nodeParent:removeFromParent()
				nodeParentMG:removeAllChildren()
				nodeParent = nodeParentMG
			end
		end
		nodeParent:setTag(cbCardData[1])
	end

	for i = 1, #cbCardData do
		--local rectX = self:switchToCardRectX(cbCardData[i])
		--牌底
		local card = display.newSprite(resCard[viewId])
			:move(i*fSpacing*multipleBpBgCard[viewId][1], i*fSpacing*multipleBpBgCard[viewId][2])
			--:setTextureRect(cc.rect(width*rectX, 0, width, height))
			:addTo(nodeParent)
		--字体
		local nValue = math.mod(cbCardData[i], 16)
		local nColor = math.floor(cbCardData[i]/16)
		local strFile = resFont[viewId].."font_"..nColor.."_"..nValue..".png"
		local cardFont = display.newSprite(strFile)
			:move(width/2, height/2 + 8)
			:setTag(1)
			:addTo(card)
		if viewId == 4 or (viewId == 1 and not self._scene.bIsVideo )then
			cardFont:setRotation(180)
		end
		

		if viewId == 4 then
			card:setLocalZOrder(5 - i)
		end
		if i == 4 then 		--杠
			local moveUp = {17, 14, 23, 14}
			card:move(2*fSpacing*multipleBpBgCard[viewId][1], 2*fSpacing*multipleBpBgCard[viewId][2] + moveUp[viewId])
			card:setLocalZOrder(5)
		elseif nShowStatus == GameLogic.SHOW_AN_GANG then 		--暗杠
			card:setTexture(resFont[viewId].."card_back.png")
			card:removeChildByTag(1)
		end
		--添加牌到记录里
		if nShowStatus ~= GameLogic.SHOW_MING_GANG or i == 4 then
			local pos = 1
			while pos <= #self.cbBpBgCardData[viewId] do
				if self.cbBpBgCardData[viewId][pos] == cbCardData[i] then
					break
				end
				pos = pos + 1
			end
			table.insert(self.cbBpBgCardData[viewId], pos, cbCardData[i])
		end
	end
	self.nBpBgCount[viewId] = self.nBpBgCount[viewId] + 1
end

--检查碰、杠牌里是否有这张牌
function CardLayer:checkBumpOrBridgeCard(viewId, cbCardData)
	local card = self.nodeBpBgCard[viewId]:getChildByTag(cbCardData)
	if card then
		return true
	else
		return false
	end
end

function CardLayer:getBpBgCardData()
	return self.cbBpBgCardData
end

function CardLayer:gameEnded()
	self.bSendOutCardEnabled = false
end

function CardLayer:switchToCardRectX(data)
	assert(data, "this card is nil")
	local cardIndex = GameLogic.SwitchToCardIndex(data)
	local rectX = cardIndex == GameLogic.MAGIC_INDEX and 32 or cardIndex
	return rectX
end



function CardLayer:promptListeningCard(cardData)
	--assert(#self.cbListenList > 0)

	if nil == cardData then
		assert(self.currentOutCard > 0)
		cardData = self.currentOutCard
	end

	for i = 1, #self.cbListenList do
		if self.cbListenList[i].cbOutCard == cardData then
			self._scene:setListeningCard(self.cbListenList[i].cbListenCard)
			break
		end
	end
end

function CardLayer:startListenCard()
	for i = 1, cmd.MAX_COUNT do
		local card = self.nodeHandCard[cmd.MY_VIEWID]:getChildByTag(i)
		if i == 1 then
			card:setColor(cc.c3b(255, 255, 255))
			self.bCardGray[i] = false
		else
			card:setColor(cc.c3b(100, 100, 100))
			self.bCardGray[i] = true
		end
	end
end

function CardLayer:promptListenOutCard(cbPromptOutData)
	--还原
	local cbCardCount = #self.cbCardData
	for i = 1, cmd.MAX_COUNT do
		local card = self.nodeHandCard[cmd.MY_VIEWID]:getChildByTag(i)
		card:getChildByTag(CardLayer.TAG_LISTEN_FLAG):setVisible(false)
	end
	if cbPromptOutData == nil then
		return 
	end
	--校验
	--assert(type(cbPromptOutData) == "table")
	--assert(math.mod(cbCardCount - 2, 3) == 0, "You can't out card now!")
	for i = 1, #cbPromptOutData do
		if cbPromptOutData[i] ~= GameLogic.MAGIC_DATA then
			for j = 1, cbCardCount do
				if cbPromptOutData[i] == self.cbCardData[j] and self.cbCardData[j] ~= 0 then
					local nTag = cbCardCount - j + 1
					local card = self.nodeHandCard[cmd.MY_VIEWID]:getChildByTag(nTag)
					if card then
						card:getChildByTag(CardLayer.TAG_LISTEN_FLAG):setVisible(true)
					end
				end
			end
		end
	end
end



function CardLayer:touchSendOutCard(cbCardData)
	if not self.bSendOutCardEnabled then
		return false
	end
	
	self.currentOutCard = cbCardData
	self._scene:setListeningCard(nil)
	--发送消息
	return self._scene._scene:sendOutCard(cbCardData)
	
end

function CardLayer:outCardAuto()
	local nCount = #self.cbCardData
	if math.mod(nCount - 2, 3) ~= 0 then
		return false
	end
	for i = nCount, 1, -1 do
		if self.cbCardData[i] == 0 then
			break
		end

		local nTag = nCount - i + 1
		local bOk = not self.bCardGray[nTag]
		if self.cbCardData[i] ~= GameLogic.MAGIC_DATA and bOk   then
			self:touchSendOutCard(self.cbCardData[i])
			break
		end
	end

	return true
end
--检查手里的杠
function CardLayer:getGangCard(data)
	local cbCardCount = #self.cbCardData
	local num = 0
	if math.mod(cbCardCount, 3) == 2 then
		num = 4
	elseif math.mod(cbCardCount, 3) == 1 then
		num = 3
	else
		assert(false, "This is a not bridge card time!")
	end
	local cbCardIndex = GameLogic.DataToCardIndex(self.cbCardData)
	if data and data > 0 then
		local index = GameLogic.SwitchToCardIndex(data)
		if cbCardIndex[index] == num then
			return data
		end
	end
	for i = 1, GameLogic.NORMAL_INDEX_MAX do
		local dataTemp = GameLogic.SwitchToCardData(i)
		if cbCardIndex[i] == num then
			data = dataTemp
		end
	end
	return data
end

function CardLayer:isUserMustWin()

	if #self.cbCardData == 2 then
		if self.cbCardData[1] == self.cbCardData[2] and 
			self.cbCardData[2] == GameLogic.MAGIC_DATA then
			print("ggggggggggggggggggggggggg")
			return true
		end
	end

	return false
end

function CardLayer:isUserCanPeng()
	if #self.cbCardData == 4 then
		if self.cbCardData[1] == self.cbCardData[2] and 
			self.cbCardData[2] == GameLogic.MAGIC_DATA  and 
			self.cbCardData[3] == self.cbCardData[4]
			then
			return false
		end
	end

	return true
end

return CardLayer