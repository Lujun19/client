
local PokerNormal = class("PokerNormal", function()
	return display.newNode()
end )
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local module_pre = "game.qipai.thirteenx.res"
local GameLogic = appdf.req("game.qipai.thirteenx.src.models.GameLogic")
local PokerSectorPos = {
	{ yl.WIDTH - 250, yl.HEIGHT / 2 + 40 },
	{ 250, yl.HEIGHT / 2 + 40 },
	{ yl.WIDTH * 0.5 + 200, yl.HEIGHT - 130 }
}
local CARD_WIDTH = 89
local CARD_HEIGHT = 117
local sendPokerSpeed = 0.08

function PokerNormal:ctor(Parent)
	self.node = nil
	print("PokerNormal:ctor(Parent)", cc.FileUtils:getInstance():isFileExist("game_res/gameView.csb"))
	local csbNode = ExternalFun.loadCSB("game_res/gameView.csb", self)

	print("aaa")
	self.cardlist = { }
	self.Parent = Parent
	self.st = { }
	self.choicePoker = csbNode
	--    self.choicePoker:hide()
	local daoshui = self.choicePoker:getChildByName("daoshui")
	daoshui:hide()
	self:ReadyButton()

	self.cancelPosX = self.cancelButton:getPositionX()

	self.curSel = { }

	self:CreatePoker(self)
	self.SetSegmentList = { }
	for i = 1, 3 do
		self.SetSegmentList[i] = { }
	end
	self.isChoisePoker = true
	self.node1 = ccui.Layout:create()
	:setScale(0.85, 0.85)
	:setContentSize(cc.size(600, 120))
	:setAnchorPoint( { x = 0.5, y = 0.5 })
	:setPosition(377 - 30, 225 + 60)
	self.node:addChild(self.node1)

	self.Parent:switchTypeBtn(self)

    self._specialDatas={}
    self._selectedDatas = { }
    self._specialType = 0
--    self._mobilePutCard = self.Parent:getParentNode()._cbautoCard

    if PriRoom and GlobalUserItem.bPrivateRoom then
       local time0 = self.choicePoker:getChildByName("txt_time_0")
       local time1 = self.choicePoker:getChildByName("txt_time_1")
       time0:hide()
       time1:hide()
    end
end

function PokerNormal:CreatePoker(Parent)
	print("PokerNormal:CreatePoker(Parent)")
	self.selectCardIndex = 2
	self.selectCardList = { { }, { }, { } }
	self.xianggong = self.choicePoker:getChildByName("daoshui")
	self.front = self.choicePoker:getChildByName("chosePoker"):getChildByName("front")
	self.frontActive = false
	self.playerPoker = { }
	for i = 1, 3 do
		local sNode = ccui.Layout:create()
		sNode:setContentSize(cc.size(390, 150))
		sNode:setAnchorPoint( { x = 0.5, y = 0.5 })

		self:addChild(sNode)
		sNode:setScale(0.5)
		if i == 1 then
			sNode:setRotation(-90)
		elseif i == 2 then
			sNode:setRotation(90)
		elseif i == 3 then
			sNode:setRotation(-180)
		end
		sNode:setPosition(PokerSectorPos[i][1], PokerSectorPos[i][2])
		for l = 1, 13 do
			local node = ccui.Layout:create():addTo(sNode)
			node:setContentSize(cc.size(88, 125))
			node:setAnchorPoint( { x = 0.5, y = 0.5 })
			node:setPosition(l * 30, 75)
			node:setTag(l)
		end
		sNode:hide()
		table.insert(self.playerPoker, sNode)
	end


	self.front:addTouchEventListener( function(sender, event)
		AudioEngine.playEffect(cc.FileUtils:getInstance():fullPathForFilename("sound_res/select.mp3"), false)
		if event == ccui.TouchEventType.ended and self.frontActive and next(self.selectCardList[1]) == nil then
			self:choiceDaoShu(sender, event)
			print("front")
		elseif event == ccui.TouchEventType.ended and not self.frontActive and next(self.selectCardList[1]) ~= nil then
			self:cancelPoker("cancel1")
		end
	end )
	self.mid = self.choicePoker:getChildByName("chosePoker"):getChildByName("mid")
	self.midActive = false
	self.mid:addTouchEventListener( function(sender, event)
		AudioEngine.playEffect(cc.FileUtils:getInstance():fullPathForFilename("sound_res/select.mp3"), false)
		if event == ccui.TouchEventType.ended and self.midActive and next(self.selectCardList[2]) == nil then
			self:choiceDaoShu(sender, event)
			print("mid")
		elseif event == ccui.TouchEventType.ended and not self.midActive and next(self.selectCardList[2]) ~= nil then
			self:cancelPoker("cancel2")
		end

	end )
	self.back = self.choicePoker:getChildByName("chosePoker"):getChildByName("back")
	self.backActive = false
	--    self.back:setColor(cc.c3b(128,128,128))
	self.back:addTouchEventListener( function(sender, event)
		AudioEngine.playEffect(cc.FileUtils:getInstance():fullPathForFilename("sound_res/select.mp3"), false)
		if event == ccui.TouchEventType.ended and self.backActive and next(self.selectCardList[3]) == nil then
			self:choiceDaoShu(sender, event)
			print("back")
		elseif event == ccui.TouchEventType.ended and not self.backActive and next(self.selectCardList[3]) ~= nil then

			self:cancelPoker("cancel3")
		end
	end )

	local sNode = ccui.Layout:create()

	Parent:addChild(sNode)
	sNode:setContentSize(cc.size(700, 150))
	sNode:setScale(1.4)
	sNode:setPosition(display.cx, display.bottom + 100)
	sNode:setAnchorPoint( { x = 0.5, y = 0.5 })
	sNode.node = { }

	for l = 1, 13 do

		local node = ccui.Layout:create()

		sNode:addChild(node)

		node:setContentSize(cc.size(88, 125))
		node:setAnchorPoint( { x = 0.5, y = 0.5 })
		node:setPosition(l * 50, 75)
		node.orPos = cc.p(node:getPosition())
		node:setCascadeOpacityEnabled(true)
		node:hide()
		node.m_bSelectOver_ = true
		sNode.node[l] = node

		local s = node:getContentSize()
		local bg = self:createBack():addTo(sNode.node[l])
		bg:setPosition(s.width / 2, s.height / 2)
		Adaptive(bg).w(88).h(125)
		node.bg = bg
		--                end

	end
	sNode:hide()

	self.m_pListener = cc.EventListenerTouchOneByOne:create()
	self.m_pListener:setSwallowTouches(false)
	self.m_pListener:registerScriptHandler( function(touch, event) return self:onTouchBegan(touch, event) end, cc.Handler.EVENT_TOUCH_BEGAN)
	self.m_pListener:registerScriptHandler( function(touch, event) self:onTouchMoved(touch, event) end, cc.Handler.EVENT_TOUCH_MOVED)
	self.m_pListener:registerScriptHandler( function(touch, event) self:onTouchEnded(touch, event) end, cc.Handler.EVENT_TOUCH_ENDED)
	local eventDispatcher = sNode:getEventDispatcher()
	eventDispatcher:addEventListenerWithSceneGraphPriority(self.m_pListener, sNode)

	self.node = sNode

	---------------------------------------------------------------------------------------------------------------------------------



	local sNode = display.newNode():addTo(Parent)
	sNode:setPosition(display.left + 140, display.cy + 5)

	sNode.node = { }

	for l = 1, 3 do
		local node = display.newNode():addTo(sNode)

		node:setPosition(l == 3 and l * 105 or l * 91, 0)
		sNode.node[l] = node
		node:hide()
	end
	local a, b = 1, 1
	for l = 1, 13 do
		if l == 4 or l == 9 then
			a = a + 1
			b = 1
		end
		local X = sNode.node[a]:getPositionX()
		local Y = sNode.node[a]:getPositionY()

		local bg = self:createBack():addTo(sNode.node[a])
		bg:setPosition(X + 40 * b, Y)
		Adaptive(bg).w(88).h(125)
		sNode.node[a][b] = bg
		b = b + 1

	end
	sNode:hide()


	self.SegmentNode = sNode

end


function PokerNormal:createBack()

	local tex = cc.Director:getInstance():getTextureCache():getTextureForKey("game_res/card_b.png");
	-- 纹理区域
	local rect = cc.rect(2 * CARD_WIDTH, 4 * CARD_HEIGHT, CARD_WIDTH, CARD_HEIGHT);

	local m_spBack = cc.Sprite:createWithTexture(tex, rect);

	return m_spBack
end


function PokerNormal:SpriteRect(data, value, type)


	local m_cardData = data
	local m_cardValue = value==13 and 1 or (value+1)
	local m_cardColor = type


	local rect = cc.rect((m_cardValue - 1) * CARD_WIDTH,(m_cardColor - 1) * CARD_HEIGHT, CARD_WIDTH, CARD_HEIGHT);

	if 0x4F == m_cardData then
		rect = cc.rect(0, 4 * CARD_HEIGHT, CARD_WIDTH, CARD_HEIGHT);
	elseif 0x4E == m_cardData then
		rect = cc.rect(CARD_WIDTH, 4 * CARD_HEIGHT, CARD_WIDTH, CARD_HEIGHT);
	end

	return rect
end


local cardButtonWord = { "对子", "三条", "顺子", "同花", "葫芦", "炸弹", "同花顺" }
function PokerNormal:ReadyButton()
	print("PokerNormal:ReadyButton()")
	-- 出牌按钮 4/10
	self.ReadyButton = ccui.Button:create("", "", ""):addTo(self)
	:loadTextureNormal("game_res/11.png", ccui.TextureResType.plistType)
	:setPosition(757, 161)

	self.ReadyButton:addTouchEventListener( function(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			--                          self:buttonCheckSound()
			self:CardReady()
			print("PokerNormal:ReadyButton()end")

		end
	end )
	self.ReadyButton:hide()


	self.cancelButton = ccui.Button:create("", "", ""):addTo(self)
	:loadTextureNormal("game_res/10.png", ccui.TextureResType.plistType)
	:setPosition(539, 161)
	self.cancelButton:addTouchEventListener( function(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			--              self:buttonCheckSound()
			self:cancelPoker("cancel2")
			self:cancelPoker("cancel3")
			self:cancelPoker("cancel1")
			self.ReadyButton:setEnabled(false)
			self.cancelButton:setEnabled(false)

		end
	end )
	self.cancelButton:hide()

	self.buttonCheckout = { }
	for i = 1, 7 do
		local Button = self.choicePoker:getChildByName("Button_" .. i)

		Button:addTouchEventListener( function(sender, eventType)
			if eventType == ccui.TouchEventType.ended then
				--              self:buttonCheckSound()
				self:buttonLisen(sender, eventType)
			end
		end )

		Button:setTag(i)
		self.buttonCheckout[i] = false
		Button.key = cardButtonWord[i]
		Button.active = false

	end
end


function PokerNormal:PokerSetSegment(type, cardData)
	print("设置每墩扑克........................." .. 1)
	self.SegmentNode:show()
	local cards = cardData

	if type == 0 or type == 1 or type == 2 then


		local cNode = self.SegmentNode.node
		for i = 1, 3 do
			if cNode[i].bSet == nil or not cNode[i].bSet then
				cNode[i]:hide()
			end
		end
		local count = cards == nil and 0 or #cards
		if count == 3 or count == 5 then
         	table.sort(cards, PokerUtils.sortRise)
			cNode[type + 1].bSet = true
			cNode[type + 1]:show()

			for i = 1, count do
				local id = cards[i]

				cNode[type + 1][i]:setTextureRect(self:SpriteRect(data, id.value, id.type))
				Adaptive(cNode[type + 1][i]).w(88).h(125)
			end
			self.selectCardIndex = self.selectCardIndex + 1
		else
			cNode[type + 1]:hide()
		end
	else
		print("PokerSetSegment error , the type = ", type)
	end
end

-- 是否相公
function PokerNormal:messire()
	print("PokerNormal:messire().........................")

	local tGroup = PokerUtils.tGroup
	local t3Group = { PokerUtils.santiao, PokerUtils.yiduiThree, PokerUtils.wulongThree }
	local cards_3, cards_2, cards_1 = { }, { }, { }
	for i = 1, 5 do
		cards_3[i] = self.selectCardList[3][i]
		cards_2[i] = self.selectCardList[2][i]

		if i < 4 then
			cards_1[i] = self.selectCardList[1][i]
		end
	end
	local tArr, cflag = { }, true
	for i = 1, #t3Group do
		if not tArr[3] then
			local t1 = t3Group[i](cards_1)
			if #t1 > 0 then
				tArr[3] = i == 1 and 7 or i == 2 and 9 or 10
				tArr[4] = t1[1]
			end
		end
	end
	for i = 1, #tGroup do
		if not tArr[1] then
			local t3 = tGroup[i](cards_3)
			if #t3 > 0 then
				tArr[1] = i
				tArr[6] = t3
			end
		end
		if not tArr[2] then
			local t2 = tGroup[i](cards_2)
			if #t2 > 0 then
				tArr[2] = i
				tArr[5] = t2
			end
		end
		if tArr[1] and tArr[2] and tArr[3] then
			if tArr[1] <= tArr[2] then
				if tArr[1] == tArr[2] then
					cflag = PokerUtils.isMessireFive(11 - tArr[1], tArr[6][1], tArr[5][1])
					cflag = cflag == false
				end
				if cflag then
					if tArr[2] == tArr[3] then
						cflag = PokerUtils.isMessireThree(tArr[2], tArr[5], tArr[4], 1)
					elseif tArr[2] > tArr[3] then
						cflag = false
					end
				end
			elseif tArr[1] > tArr[2] then
				cflag = false
			end
			break
		end
	end
	-- dump(tArr)
	print(cflag)
	if not cflag then
		print("相公了")
		self.xianggong:show()
		self.xianggong:setString("倒水了，请重新选牌！！！")

		self.cancelButton:show()
		self.cancelButton:setEnabled(true);
		self.cancelButton:setPositionX(self.cancelPosX + 100)
		return
	elseif #tArr ~= 6 then

		print("出牌错误")
		self.xianggong:show()
		self.xianggong:setString("出牌错误，请重新选牌！！！")
		self.cancelButton:show()
		self.cancelButton:setEnabled(true);
		self.cancelButton:setPositionX(self.cancelPosX + 100)


		return

	else
		self.cancelButton:setPositionX(self.cancelPosX)
		self.ReadyButton:show()
		self.cancelButton:show()
		self.ReadyButton:setEnabled(true);
		self.cancelButton:setEnabled(true);
	end
	print("self.choicePoker:getChildByName(show):show()")
end 
function PokerNormal:buttonLisen(sender, eventType)
	-- 出牌类型按钮回调

	if sender.active then

		print(sender.key)
		local typeArr = { }
		local arr = self.Arr[sender:getTag()]

		self.curSel = { }
		self:PokerReOrder(self.cardlist)

		for i = #self.cardlist, 1, -1 do
			local id = self.node.node[i].id
			for m, n in pairs(arr) do
				if id.type == n.type and id.value == n.value then

					self:setSelectCard(i, true)
				end
			end
		end

		self:refreshButton(self.cardlist)
	end
end

function PokerNormal:refreshButton(Arr)
	-- "对子","两对","三条","顺子","同花","葫芦","铁支","同花顺"
	local arr = clone(Arr)
	if #arr == 0 then

		for i = 1, 7 do

			local button = self.choicePoker:getChildByName("Button_" .. i)
			button.active = false
			button:setEnabled(button.active)

		end
		return
	end
	local ydArr = PokerUtils.yiduiFiveNew(arr)

	local stArr = PokerUtils.santiaoFiveNew(arr)
	local szArr = PokerUtils.shunziNew(arr)
	local thArr = PokerUtils.tonghuaNew(arr)
	local hlArr = PokerUtils.huluNew(arr)
	local tzArr = PokerUtils.tiezhiNew(arr)
	local thsArr = PokerUtils.tonghuashunNew(arr)
	self.Arr = { ydArr, stArr, szArr, thArr, hlArr, tzArr, thsArr }

	--    print("..............................")
	for k, v in pairs(self.Arr) do
		local button = self.choicePoker:getChildByName("Button_" .. k)
		local frame = nil
		if next(v) == nil then

			button.active = false
			button:setEnabled(button.active)

		else
			print("包含" .. cardButtonWord[k])
			button.active = true
			button:setEnabled(button.active)

		end

	end

end

function PokerNormal:GetTouchCard(pos)
	local pSel = false
	for i = 13, 1, -1 do
		local cardNode = self.node.node[i]
		if cardNode then
			local bSel = cc.rectContainsPoint(cardNode:getBoundingBox(), pos)
			pSel = bSel
			if bSel then
				return i

			end
		end
	end

	local fSel = false

	fSel = cc.rectContainsPoint(self.node1:getBoundingBox(), pos)

	if pSel == false and fSel == false and self.isChoisePoker then
		self.curSel = { }
		self:setChoiceSprite()

		self:PokerReOrder(self.cardlist)
	end
	return nil
end



function PokerNormal:isCanTouch()

	return true

end

function PokerNormal:onTouchBegan(touch, event)
	if not self:isCanTouch() then
		return false
	end
	local target = event:getCurrentTarget()
	local beginPoint = target:convertToNodeSpace(touch:getLocation())

	print("beginPoint.x===%f,beginPoint.y=====%f", beginPoint.x, beginPoint.y)

	self.m_allTouchIndex = { }
	if #self.cardlist ~= 0 then
		print("#self.cardlist==" .. #self.cardlist)
		local nIdx = self:GetTouchCard(beginPoint)
		for i = 13, 1, -1 do

			if nIdx ~= nil then

				table.insert(self.m_allTouchIndex, nIdx)
				self.m_bClick_ = true
				print("self.m_TouchIndex_====" .. nIdx)

				if self.node.node[nIdx].m_bSelect_ then
					self.node.node[nIdx].bg:setColor(cc.c3b(255, 255, 255))
				else
					self.node.node[nIdx].bg:setColor(cc.c3b(128, 128, 128))
				end
				return true
			end
		end

	end
	return true
end

function PokerNormal:onTouchMoved(touch, event)


	if not self:isCanTouch() then
		return false
	end
	local target = event:getCurrentTarget()
	local beginPoint = target:convertToNodeSpace(touch:getLocation())

	if #self.cardlist ~= 0 then
		local nIdx = self:GetTouchCard(beginPoint)
		for i = 13, 1, -1 do

			if nIdx ~= nil then

				local function isHasThisIndex(index)
					for k, v in pairs(self.m_allTouchIndex) do
						if v == index then
							return true
						end
					end
					return false
				end
				local Has = isHasThisIndex(nIdx)
				if not Has then

					table.insert(self.m_allTouchIndex, nIdx)

				end
				for k, v in pairs(self.m_allTouchIndex) do

					if self.node.node[v].m_bSelect_ then
						self.node.node[v].bg:setColor(cc.c3b(255, 255, 255))
					else
						self.node.node[v].bg:setColor(cc.c3b(128, 128, 128))
					end
				end
				self.m_bClick_ = true
				return true
			end
		end

	end
	return true
end

function PokerNormal:onTouchEnded(touch, event)

	for i = 1, #self.m_allTouchIndex do
		self:setSelectCard(self.m_allTouchIndex[i], true)
	end

	for k, v in pairs(self.m_allTouchIndex) do


		self.node.node[v].bg:setColor(cc.c3b(255, 255, 255))
	end

	self.m_allTouchIndex = { }
end


function PokerNormal:setSelectCard(idx, bSelect)
	if idx > 0 then
		self.choicePoker:show()
		local cardNode = self.node.node[idx]


		local function handleSel(bSel, id)
			-- body
			AudioEngine.playEffect(cc.FileUtils:getInstance():fullPathForFilename("sound_res/select.mp3"), false)
			if bSel then
				table.insert(self.curSel, id)

			else
				for k, v in pairs(self.curSel) do

					if v.type == id.type and v.value == id.value then

						table.remove(self.curSel, k)
						break
					end
				end
			end
		end
		if bSelect then
			if cardNode.m_bSelect_ then
				cardNode:setPositionY(cardNode.orPos.y)
				cardNode.m_bSelect_ = false
			else
				cardNode:setPositionY(15 + cardNode.orPos.y)
				cardNode.m_bSelect_ = true
			end
		else
			cardNode:setPositionY(cardNode.orPos.y)
			cardNode.m_bSelect_ = false
		end
		if cardNode.m_bSelectOver_ then
			handleSel(cardNode.m_bSelect_, cardNode.id)
		end

		local bSet = false

	end
	local count = table.getn(self.curSel)
	print("cur sel count ================", count)

	self:setChoiceSprite(count)

end

-- 选择道数回调
function PokerNormal:choiceDaoShu(sender, event)
	local name = sender:getName()
	--     print(name)
	if name == "front" then
		self:choiceArr(0)

	elseif name == "mid" then
		self:choiceArr(1)

	elseif name == "back" then
		self:choiceArr(2)

	else
		return
	end
	if #self.cardlist == 3 then
		self.curSel = self.cardlist
		self.cardlist = { }
		self:choiceArr(0)
	elseif #self.cardlist == 5 then
		for i = 1, 3 do
			if next(self.selectCardList[i]) == nil then
				print("剩余5张")
				self.curSel = self.cardlist
				self.cardlist = { }
				self:choiceArr(i - 1)
			end
		end
	end
	self:setChoiceSprite()

end
-- 设置选牌面板贴图
function PokerNormal:setChoiceSprite(nub)
	local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame("game_res/47.png")
	local frame2 = cc.SpriteFrameCache:getInstance():getSpriteFrame("game_res/48.png")
	if nub == 3 then
		for i = 1, 3 do
			local sprite = self.front:getChildByName("Sprite_" .. i)
			sprite:setSpriteFrame(frame)
		end
		self.frontActive = true
	elseif nub == 5 then
		for i = 1, 5 do
			local sprite = self.mid:getChildByName("Sprite_" .. i)
			sprite:setSpriteFrame(frame)
			local sprite1 = self.back:getChildByName("Sprite_" .. i)
			sprite1:setSpriteFrame(frame)
		end
		self.midActive = true
		self.backActive = true
	else
		for i = 1, 3 do
			local sprite = self.front:getChildByName("Sprite_" .. i)
			sprite:setSpriteFrame(frame2)
		end
		for i = 1, 5 do
			local sprite = self.mid:getChildByName("Sprite_" .. i)
			sprite:setSpriteFrame(frame2)
			local sprite1 = self.back:getChildByName("Sprite_" .. i)
			sprite1:setSpriteFrame(frame2)
		end
		self.frontActive = false
		self.midActive = false
		self.backActive = false
	end
end

function PokerNormal:choiceArr(nub)

	self:PokerSetSegment(nub, self.curSel)
	self.selectCardList[nub + 1] = self.curSel
	print("self.selectCardList...............")
	local count = table.getn(self.curSel)
	for i = 1, count do
		for k, v in pairs(self.cardlist) do
			if v.type == self.curSel[i].type and v.value == self.curSel[i].value then

				table.remove(self.cardlist, k)
				break
			end
		end
	end
	self.curSel = { }
	--    table.sort(self.cardlist, function(a, b) return a.value < b.value end)


	self:refreshButton(self.cardlist)
	self:PokerReOrder(self.cardlist)
end

-- 取消的选择
function PokerNormal:cancelPoker(name)
	print("cancel........................." .. name)

	self.xianggong:hide()
	if name == "cancel2" and self.selectCardList[2] ~= nil then
		for i = 1, #self.selectCardList[2] do
			table.insert(self.cardlist, self.selectCardList[2][i])
		end
		self:PokerSetSegment(1)

		self:PokerReOrder(self.cardlist)
		self.selectCardList[2] = { }


	elseif name == "cancel3" and self.selectCardList[3] ~= nil then
		for i = 1, #self.selectCardList[3] do
			table.insert(self.cardlist, self.selectCardList[3][i])
		end
		self:PokerSetSegment(2)

		self:PokerReOrder(self.cardlist)
		self.selectCardList[3] = { }

	elseif name == "cancel1" and self.selectCardList[1] ~= nil then
		for i = 1, #self.selectCardList[1] do
			table.insert(self.cardlist, self.selectCardList[1][i])
		end
		self:PokerSetSegment(0)

		self:PokerReOrder(self.cardlist)
		self.selectCardList[1] = { }
	end

	self.curSel = { }
	self:refreshButton(self.cardlist)
	self:setSelectCard(0, false)
end



-- 扑克初始化
function PokerNormal:PokerReOrder(cardData)
	self.node:show()
	--    self.node.button.start:hide()
	self.ReadyButton:hide()
	self.cancelButton:hide()
	self.ReadyButton:setEnabled(false);
	self.cancelButton:setEnabled(false);
	print("card count =======================", #cardData)

	--    table.sort(cardData, PokerUtils.sortRise)
	self.cardlist = { }
	for i = 1, 13 do
		self.node.node[i]:hide()
		self.node.node[i]:setPositionY(self.node.node[i].orPos.y)
		self.node.node[i].m_bSelect_ = false
		self.node.node[i].m_bSelectOver_ = false
		self.node.node[i].bg:setColor(cc.c3b(255, 255, 255))
	end
	self.isChoisePoker = true
	if #cardData == 0 then

		self.isChoisePoker = false
		self:messire()

		return
	end
	table.sort(cardData, PokerUtils.sortDescent)
	local n = #cardData
	for i = 1, #cardData do
		self.node.node[i]:show()
		local card = self.node.node[i].bg
		if card then
			local id = cardData[n]

			card:setTextureRect(self:SpriteRect(data, id.value, id.type))
			self.node.node[i].id = id
			self.cardlist[n] = id
			self.node.node[i].m_bSelectOver_ = true
			n = n - 1
			Adaptive(card).w(88).h(125)
		else
			print("not found the card node !!!!", i)
		end
	end
end

function PokerNormal:CardReady()
	-- 出牌
	local arr = { }

	for k, v in pairs(self.selectCardList) do
		for m, n in pairs(v) do
			table.insert(arr, PokerUtils.singleCardsEncode(n))
		end
	end

	self.Parent:finishSelect(arr)
end



-- 扑克初始化
function PokerNormal:PokerContrastInit(decodeCardData, cardData)
	print("PokerNormal:PokerContrastInit(cardData)")
--cardData ={0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x0D}
--decodeCardData=PokerUtils.cardsDecode(cardData)
    dump(cardData)

	self.node:show()
	self.choicePoker:show()
	self.isChoisePoker = true

	--    print("card count =======================", #cardData)
	table.sort(decodeCardData, PokerUtils.sortDescent)
	local n = 13
	for i = 1, #decodeCardData do
		self.node.node[i]:show()
		local card = self.node.node[i].bg
		if card then
			if decodeCardData and #decodeCardData == 13 then
				local id = decodeCardData[n]

				card:setTextureRect(self:SpriteRect(data, id.value, id.type))
				self.node.node[i].id = id
				self.node.node[i].m_bSelectOver_ = true

				self.cardlist[n] = id
				n = n - 1
			else

				card:setSpriteFrame(RoomController.pokerSpriteFrame[5])
			end
			Adaptive(card).w(88).h(125)
		else
			print("not found the card node !!!!", i)
		end
	end

	self:refreshButton(self.cardlist)
	--    dump(self.cardlist)
--	 cardData ={0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x0D}
	self:initEvent(cardData)
end
local SpecialTypeDes = {
	[GameLogic.CT_EX_SANTONGHUA] = "三同花",
	[GameLogic.CT_EX_SANSHUNZI] = "三顺子",
	[GameLogic.CT_EX_LIUDUIBAN] = "六对半",
	[GameLogic.CT_EX_SITAOSANTIAO] = "四套三条",
	[GameLogic.CT_EX_SANFENGTIANXIA] = "三分天下",
	[GameLogic.CT_EX_SANTONGHUASHUN] = "三同花顺",
	[GameLogic.CT_EX_YITIAOLONG] = "一条龙",
	[GameLogic.CT_EX_ZHIZUNQINGLONG] = "至尊清龙",
}
function PokerNormal:initEvent(cardDate)
	print("初始化事件")
	-- 非托管模式
	if self.Parent._bTrustTee == false then
		--    if true then
		local typevalue, linedata = GameLogic:GetSpecialType(cardDate, #cardDate)
		-- 特殊牌型
		if typevalue > GameLogic.CT_EX_INVALID then
			self._specialDatas = clone(linedata)
			self._specialType = typevalue
			print("self._specialType", self._specialType)
			 		dump(self._specialDatas, "获取特殊牌型", 10)
			self._specialNode = cc.CSLoader:createNode("game_res/SelectTips.csb")
			self._specialNode:setPosition(0, 0)
			self:addChild(self._specialNode, 10)

			local _specialbg = self._specialNode:getChildByName("im_bg")

			local tipstr = "你的牌型符合【" .. SpecialTypeDes[typevalue] .. "】,你是否要打出此牌型？"
			local _labtips = cc.LabelTTF:create(tipstr, "fonts/round_body.ttf", 28, cc.size(450, 0), cc.TEXT_ALIGNMENT_CENTER)
			_labtips:setPosition(_specialbg:getContentSize().width / 2, _specialbg:getContentSize().height / 2)
			_labtips:setColor(cc.c3b(255, 245, 248))
			_specialbg:addChild(_labtips)

			local btensure = _specialbg:getChildByName("bt_ensure")
			btensure:addTouchEventListener(handler(self,self.specialSelect))

			local btcancel = _specialbg:getChildByName("bt_cancel")
			btcancel:addTouchEventListener( function(sender, eventType)
				if eventType == ccui.TouchEventType.ended then
					self:removeSpecialNode()
				end
			end )
		end
	end
end

function PokerNormal:specialSelect(sender, eventType)
	if eventType == ccui.TouchEventType.ended then
		self._selectedDatas = { }
		for i = 1, 3 do
			table.insert(self._selectedDatas, self._specialDatas[1][i])
		end
		for k, v in pairs(self._specialDatas[2]) do
			table.insert(self._selectedDatas, v)
		end
		for k, v in pairs(self._specialDatas[3]) do
			table.insert(self._selectedDatas, v)
		end

		dump(self._selectedDatas, "特殊牌型", 10)
		self.Parent:finishSelect(self._selectedDatas, self._specialType)
	end
end

function PokerNormal:removeSpecialNode()
	if nil ~= self._specialNode then
		self._specialNode:removeFromParent()
		self._specialNode = nil
	end
end
function PokerNormal:initPoker()
	print("PokerNormal:initPoker()")
	self.cardlist = { }
	self.curSel = { }
	self.isChoisePoker = false
	self.selectCardIndex = 2
	self.selectCardList = { { }, { }, { } }
	self.choicePoker:hide()
	self.xianggong:hide()
	self.ReadyButton:hide()
	self.cancelButton:hide()
	self:sendPokerAnimInit()
	for i = 1, 13 do
		local cardNode = self.node.node[i]
		cardNode:setPositionY(cardNode.orPos.y)
		cardNode.m_bSelect_ = false
	end
	self:setChoiceSprite()

end

function PokerNormal:readyPoker()
	local poker = { }
	for k, v in pairs(self.selectCardList) do
		for m, n in pairs(v) do
			table.insert(poker, n)
		end
	end
	return poker
end

function PokerNormal:sendPokerAnim(cardData)
	print("PokerNormal:sendPokerAnim(cardData)")
	for i = 1, 4 do
		RoomController:playerStateChange(i, RoomController.playerState.none)
	end

	local tablePlayer = #(self.Parent._scene:TablePlayer()) < 5 and #(self.Parent._scene:TablePlayer()) or 4

	local tableUseritem = self.Parent._scene:TablePlayer()

	local chairIDs = { }
	for k, v in pairs(tableUseritem) do
		local chairID = RoomController:cardsPos(v.wChairID + 1)

		table.insert(chairIDs, chairID)

	end

	local spaceBetween = self.sendPokerLen /(13 * tablePlayer)
	self:sendPokerAnimInit()
	local usePoker = tablePlayer * 13

	for i = 1, usePoker do
		self.animPoker:getChildByTag(i):show()
		self.animPoker:getChildByTag(i):setPosition(i * spaceBetween, 30)
	end
	self.animPoker:show()

	for k, v in pairs(chairIDs) do
		if v == 1 then
			self:SelfSendPokerAnimInit(cardData)
		else

		end

	end
	local getPokerPlayer = 1
	local playerPokerIndex = 1
	self.st['send'] = scheduler.scheduleGlobal( function()

		local pnode = nil
		if chairIDs[getPokerPlayer] == 1 then
			pnode = self.node.node[playerPokerIndex]
		else
			pnode = self.playerPoker[chairIDs[getPokerPlayer] -1]:getChildByTag(playerPokerIndex)
		end

		local targetPos = { x = pnode:getNodeToWorldTransform()[13], y = pnode:getNodeToWorldTransform()[14] }




		self.sequence = transition.sequence( {
			cc.MoveTo:create(sendPokerSpeed - 0.01,cc.p(targetPos.x - self.animPoker:getPositionX(),targetPos.y - self.animPoker:getPositionY())),
			cc.CallFunc:create( function(obj)
				AudioEngine.playEffect(cc.FileUtils:getInstance():fullPathForFilename("sound/xuanpai.wav"), false)
				if obj.player == 1 then
					obj:hide()
				elseif obj.player == 2 or obj.player == 3 then
					obj:setRotation(90)
				end


				pnode:show()
			end )
		} )
		self.animPoker:getChildByTag(usePoker).player = chairIDs[getPokerPlayer]
		self.animPoker:getChildByTag(usePoker):runAction(self.sequence)
		if (getPokerPlayer + 1) > #chairIDs then
			getPokerPlayer = 1
			playerPokerIndex =(playerPokerIndex + 1) > 13 and 13 or playerPokerIndex + 1
		else
			getPokerPlayer = getPokerPlayer + 1
		end
		usePoker = usePoker - 1
		if usePoker < 1 then
			scheduler.unscheduleGlobal(self.st['send'])
		end
	end , sendPokerSpeed)

	self.st['show'] = scheduler.performWithDelayGlobal( function()
		self:sendPokerAnimInit()
		self.Parent.GameStartBtn:hide()
		RoomController.PokerNormalInit(PokerUtils.cardsDecode(cardData))
		RoomController:refreshCardButton(PokerUtils.cardsDecode(cardData))
		for i = 1, 4 do
			RoomController:playerStateChange(i, RoomController.playerState.baipai)
		end

	end , sendPokerSpeed * tablePlayer * 13 + 1)

end

function PokerNormal:SelfSendPokerAnimInit(cardData)
	self.node:show()

	cardData = PokerUtils.cardsDecode(cardData)
	local n = 13
	for i = 1, #cardData do

		local card = self.node.node[i].bg
		self.node.node[i]:hide()
		if card then
			if cardData and #cardData == 13 then
				local id = cardData[n]
				card:setSpriteFrame(RoomController.pokerSpriteFrame[id.type][id.value])
				n = n - 1
			else

				card:setSpriteFrame(RoomController.pokerSpriteFrame[5])
			end
			Adaptive(card).w(88).h(125)
		else

		end

	end

end

function PokerNormal:sendPokerAnimInit()
	for k, v in pairs(self.st) do
		scheduler.unscheduleGlobal(self.st[k])
	end
	for i = 1, 52 do
		if self.animPoker:getChildByTag(i).player == 2 or self.animPoker:getChildByTag(i).player == 3 then
			self.animPoker:getChildByTag(i).player = 1
		end
		self.animPoker:getChildByTag(i):setRotation(0)
		self.animPoker:getChildByTag(i):setPosition(i *(self.sendPokerLen / 52), 30)
		self.animPoker:getChildByTag(i):hide()
	end

	self.animPoker:hide()

end

function PokerNormal:logicTimeZero()
  if self._specialType == 0 then
--    self:selectCardFinish()
     self.Parent:finishSelect(self.Parent:getParentNode()._cbautoCard.cbMobilePutCard[1])
  else
--    self:specialSelect(nil, ccui.TouchEventType.ended)
	self:specialSelect(nil, ccui.TouchEventType.ended)
  end
end

function PokerNormal:UpdataClockTime(clockID,time)
  local time0 = self.choicePoker:getChildByName("txt_time_0")
  local time1 = self.choicePoker:getChildByName("txt_time_1")
  local str = string.format("%02d", time)
  time0:setString(string.sub(str,1,1))
  time1:setString(string.sub(str,2))
end

return PokerNormal
