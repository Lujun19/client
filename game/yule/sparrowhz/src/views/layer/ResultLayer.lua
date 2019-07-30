local cmd = appdf.req(appdf.GAME_SRC.."yule.sparrowhz.src.models.CMD_Game")
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC.."ExternalFun")
local CardLayer = appdf.req(appdf.GAME_SRC.."yule.sparrowhz.src.views.layer.CardLayer")
local PopupInfoHead = appdf.req("client.src.external.PopupInfoHead")
local GameLogic = appdf.req(appdf.GAME_SRC.."yule.sparrowhz.src.models.GameLogic")
local MultiPlatform = appdf.req(appdf.EXTERNAL_SRC .. "MultiPlatform")

local ClipText = appdf.req("client.src.external.ClipText")

local ResultLayer = class("ResultLayer", function(scene)
	local resultLayer = cc.CSLoader:createNode(cmd.RES_PATH.."gameResult/GameResultLayer.csb")
	return resultLayer
end)

ResultLayer.TAG_NODE_USER_1					= 1
ResultLayer.TAG_NODE_USER_2					= 2
ResultLayer.TAG_NODE_USER_3					= 3
ResultLayer.TAG_NODE_USER_4					= 4
ResultLayer.TAG_SP_ROOMHOST					= 5
ResultLayer.TAG_SP_BANKER					= 6
ResultLayer.TAG_BT_RECODESHOW				= 8
ResultLayer.TAG_BT_CONTINUE					= 9

ResultLayer.TAG_SP_HEADCOVER				= 1
ResultLayer.TAG_TEXT_NICKNAME				= 2
ResultLayer.TAG_ASLAB_SCORE					= 3
ResultLayer.TAG_HEAD 						= 4
ResultLayer.TAG_NODE_CARD					= 5

ResultLayer.WINNER_ORDER					= 1

local posBanker = {cc.p(135, 548), cc.p(135, 435), cc.p(135, 321), cc.p(135, 208)}

function ResultLayer:onInitData()
	--body
	self.winnerIndex = nil
	self.bShield = false
end

function ResultLayer:onResetData()
	--body
	self.winnerIndex = nil
	self.bShield = false
	self.nodeAwardCard:removeAllChildren()
	self.nodeRemainCard:removeAllChildren()
	for i = 1, cmd.GAME_PLAYER do
		self.nodeUser[i]:getChildByTag(ResultLayer.TAG_NODE_CARD):removeAllChildren()
		local score = self.nodeUser[i]:getChildByTag(ResultLayer.TAG_ASLAB_SCORE)
		if score then
			score:removeFromParent()
		end
	end
end

function ResultLayer:ctor(scene)
	self._scene = scene
	self:onInitData()
	ExternalFun.registerTouchEvent(self, true)
	--[[
	local btRecodeShow = self:getChildByTag(ResultLayer.TAG_BT_RECODESHOW)
	btRecodeShow:setVisible(false)
	btRecodeShow:addClickEventListener(function(ref)
		self:recodeShow()
	end)
]]
	local btContinue = self:getChildByName("Button_continue")

	--
	btContinue:addClickEventListener(function(ref)
		self:hideLayer()
		self._scene:onButtonClickedEvent(self._scene.BT_START)
	end)

	local btChange = self:getChildByName("Button_back")
	
	btChange:addClickEventListener(function(ref)
		self:hideLayer()
		self._scene:onButtonClickedEvent(self._scene.BT_CHANGE)
	end)

	if GlobalUserItem.isAntiCheat() or  GlobalUserItem.bPrivateRoom then
		btContinue:setPositionX(667)
		btChange:setVisible(false)
	end

	self.nodeUser = {}
	for i = 1, cmd.GAME_PLAYER do
		self.nodeUser[i] = self:getChildByTag(ResultLayer.TAG_NODE_USER_1 + i - 1)
		self.nodeUser[i]:setLocalZOrder(1)
		self.nodeUser[i]:getChildByTag(ResultLayer.TAG_SP_HEADCOVER):setLocalZOrder(1)
		--个人麻将
		local nodeUserCard = cc.Node:create()
			:setTag(ResultLayer.TAG_NODE_CARD)
			:addTo(self.nodeUser[i])
	end
	--奖码
	self.nodeAwardCard = cc.Node:create():addTo(self)
	--剩余麻将
	self.nodeRemainCard = cc.Node:create():addTo(self)
	--庄标志
	self.spBanker = self:getChildByTag(ResultLayer.TAG_SP_BANKER):setLocalZOrder(1)
end

function ResultLayer:onTouchBegan(touch, event)
	local pos = touch:getLocation()
	--print(pos.x, pos.y)
	local rect = cc.rect(17, 25, 1330, 750)
	if not cc.rectContainsPoint(rect, pos) then
		self:hideLayer()
	end
	return self.bShield
end

function ResultLayer:showLayer(resultList, cbAwardCard, cbRemainCard, wBankerChairId, cbHuCard)
	assert(type(resultList) == "table" and type(cbAwardCard) == "table" and type(cbRemainCard) == "table")
	local width = 44
	local height = 67
	for i = 1, #resultList do
		if resultList[i].cbChHuKind >= GameLogic.WIK_CHI_HU then
			self.winnerIndex = i
			break
		end
	end
	local nBankerOrder = 1
	for i = 1, cmd.GAME_PLAYER do
		local order = self:switchToOrder(i)
		if i <= #resultList then
			self.nodeUser[i]:setVisible(true)
			--头像
			local head = self.nodeUser[i]:getChildByTag(ResultLayer.TAG_HEAD)
			if head then
				head:updateHead(resultList[i].userItem)
			else
				head = PopupInfoHead:createNormal(resultList[i].userItem, 65)
				head:setPosition(0, 2)			--初始位置
				head:enableHeadFrame(false)
				head:enableInfoPop(false)
				head:setTag(ResultLayer.TAG_HEAD)
				self.nodeUser[i]:addChild(head)
			end
			--输赢积分
			local strFile = nil
			if resultList[i].lScore >= 0 then
				strFile = cmd.RES_PATH.."gameResult/num_win.png"
			else
				strFile = cmd.RES_PATH.."gameResult/num_lose.png"
				resultList[i].lScore = -resultList[i].lScore
			end
			local strNum = "/"..resultList[i].lScore --"/"代表“+”或者“-”
			labAtscore = cc.LabelAtlas:_create(strNum, strFile, 21, 27, string.byte("/"))
				:move(1130, -9)
				:setAnchorPoint(cc.p(0.5, 0.5))
				:setTag(ResultLayer.TAG_ASLAB_SCORE)
				:addTo(self.nodeUser[i])
			--昵称
			local textNickname = self.nodeUser[i]:getChildByTag(ResultLayer.TAG_TEXT_NICKNAME)
			textNickname:setVisible(false)
			--textNickname:setString(resultList[i].userItem.szNickName)

			local nick =  ClipText:createClipText(cc.size(101, 23),resultList[i].userItem.szNickName,"fonts/round_body.ttf",19);	   
			      nick:setAnchorPoint(cc.p(0.5,0.5))
			      nick:setPosition(cc.p(0,-48.3))
			      nick:setTextColor(cc.c3b(254, 255, 157))
			      self.nodeUser[i]:addChild(nick)


			
			--个人麻将
			local nodeUserCard = self.nodeUser[i]:getChildByTag(ResultLayer.TAG_NODE_CARD)
			local fX = 80
			local fY = -22
			local same=1
			for j = 1, #resultList[i].cbBpBgCardData do 											--碰杠牌
				--牌底
				--local rectX = CardLayer:switchToCardRectX(resultList[i].cbBpBgCardData[j])
				local card = display.newSprite(cmd.RES_PATH.."game/font_small/card_down.png")
					--:setTextureRect(cc.rect(width*rectX, 0, width, height))
					:move(fX, fY)
					:addTo(nodeUserCard)
				--字体
				local nValue = math.mod(resultList[i].cbBpBgCardData[j], 16)
				local nColor = math.floor(resultList[i].cbBpBgCardData[j]/16)
				display.newSprite("game/font_small/font_"..nColor.."_"..nValue..".png")
					:move(width/2, height/2 + 8)
					:addTo(card)
				if resultList[i].cbBpBgCardData[j] == resultList[i].cbBpBgCardData[j - 1] then
					if j~=1 then
						same = same +1
					end
				else
					same = 1
				end


				if same==4 then
					card:setPosition(cc.p(fX - 2*width,fY + 15))

					fX = fX + 8
					
				else
					if resultList[i].cbBpBgCardData[j] == resultList[i].cbBpBgCardData[j + 1] then
						fX = fX + width
					else
						fX = fX + width + 8
					end
				end
				
				--末尾
				if j == #resultList[i].cbBpBgCardData then
					fX = fX + 10
				end
			end
			for j = 1, #resultList[i].cbCardData do  											 	--剩余手牌
				--牌底
				--local rectX = CardLayer:switchToCardRectX(resultList[i].cbCardData[j])
				local card = display.newSprite(cmd.RES_PATH.."game/font_small/card_down.png")
					--:setTextureRect(cc.rect(width*rectX, 0, width, height))
					:move(fX, fY)
					:addTo(nodeUserCard)
				--字体
				local nValue = math.mod(resultList[i].cbCardData[j], 16)
				local nColor = math.floor(resultList[i].cbCardData[j]/16)
				display.newSprite("game/font_small/font_"..nColor.."_"..nValue..".png")
					:move(width/2, height/2 + 8)
					:addTo(card)

				fX = fX + width
			end
			--胡的那张牌
			if resultList[i].cbChHuKind >= GameLogic.WIK_CHI_HU then
				fX = fX + 20
				--牌底
				--local rectX = CardLayer:switchToCardRectX(cbHuCard)
				local huCard = display.newSprite(cmd.RES_PATH.."game/font_small/card_down.png")
					--:setTextureRect(cc.rect(width*rectX, 0, width, height))
					:move(fX, fY)
					:addTo(nodeUserCard)
				--字体
				local nValue = math.mod(cbHuCard, 16)
				local nColor = math.floor(cbHuCard/16)
				display.newSprite("game/font_small/font_"..nColor.."_"..nValue..".png")
					:move(width/2, height/2 + 8)
					:addTo(huCard)
				--自摸或放炮标记
				display.newSprite("#sp_ziMo.png")
					:move(fX + 21, fY + 32)
					:addTo(nodeUserCard)
				local path = self._scene._scene.cbMaCount == 1  and "gameResult/title_ymqz.png" or "gameResult/title_blzm.png"
				display.newSprite(cmd.RES_PATH..path)
					:move(889, 29)
					:addTo(nodeUserCard)
				local bg = self.nodeUser[i]:getChildByName("Sprite_1")
				bg:setTexture(cmd.RES_PATH.."gameResult/cellBg2.png")

				nick:setTextColor(cc.c3b(89,53,18))
			end
			--奖码
			fX = 909-(width+3)*(self._scene._scene.cbMaCount/2) 

			for j = 1, #resultList[i].cbAwardCard do
				--local rectX = CardLayer:switchToCardRectX(resultList[i].cbAwardCard[j])
				--local x = 788 + 52*j
				local y = -22
				--牌底
				local card = display.newSprite(cmd.RES_PATH.."game/font_small/card_down.png")
					--:setTextureRect(cc.rect(width*rectX, 0, width, height))
					:move(fX, fY)
					:addTo(nodeUserCard)
				--字体
				local nValue = math.mod(resultList[i].cbAwardCard[j], 16)
				local nColor = math.floor(resultList[i].cbAwardCard[j]/16)
				display.newSprite("game/font_small/font_"..nColor.."_"..nValue..".png")
					:move(width/2, height/2 + 8)
					:addTo(card)
				if nil ~= self.winnerIndex and 
					(nValue == 1 or
					nValue == 5 or
					nValue == 9 or
					resultList[i].cbAwardCard[j] == GameLogic.MAGIC_DATA) then
					display.newSprite("#sp_chooseFlag.png")
						:move(fX + 5, fY - 30)
						:addTo(nodeUserCard)
				end
				fX = fX + width+3
			end
			--if #resultList[i].cbAwardCard  self.wBankerUser
			--庄家
			if wBankerChairId == resultList[i].userItem.wChairID then
				nBankerOrder = i
			end
		else
			self.nodeUser[i]:setVisible(false)
		end
	end
	--剩余麻将
	local nLimlt = 29
	for i = 1, #cbRemainCard do
		local pos = cc.p(285+(i-1)*width, 602)
	
		--牌底
		--local rectX = CardLayer:switchToCardRectX(cbRemainCard[i])
		local card = display.newSprite(cmd.RES_PATH.."game/font_small/card_up.png")
			--:setTextureRect(cc.rect(width*rectX, 0, width, height))
			:move(pos)
			:addTo(self.nodeRemainCard)
		--字体
		local nValue = math.mod(cbRemainCard[i], 16)
		local nColor = math.floor(cbRemainCard[i]/16)
		display.newSprite("game/font_small/font_"..nColor.."_"..nValue..".png")
			:move(width/2, height/2 - 8)
			:addTo(card)
		if i==20 then
			break
		end
	end
	--庄家
	self:setBanker(nBankerOrder)

	self.bShield = true
	self:setVisible(true)
	--self:setLocalZOrder(yl.MAX_INT)
end

function ResultLayer:hideLayer()
	if not self:isVisible() then
		return
	end
	self:onResetData()
	self:setVisible(false)
	self._scene.btStart:setVisible(true)
end

--1~4转换到1~4
function ResultLayer:switchToOrder(index)
	assert(index >=1 and index <= cmd.GAME_PLAYER)
	if self.winnerIndex == nil then
		return index
	end
	local nDifference = ResultLayer.WINNER_ORDER - self.winnerIndex - 1
	local order = math.mod(index + nDifference, cmd.GAME_PLAYER) + 1
	return order
end

function ResultLayer:setBanker(order)
	assert(order ~= 0)
	self.spBanker:move(posBanker[order])
	self.spBanker:setVisible(true)
end

function ResultLayer:recodeShow()
	print("战绩炫耀")
	if not PriRoom then
		return
	end

    --GlobalUserItem.bAutoConnect = false
    PriRoom:getInstance():getPlazaScene():popTargetShare(function(target, bMyFriend)
        bMyFriend = bMyFriend or false
        local function sharecall( isok )
            if type(isok) == "string" and isok == "true" then
                showToast(self, "战绩炫耀成功", 2)
            end
            --GlobalUserItem.bAutoConnect = true
        end
        local url = GlobalUserItem.szWXSpreaderURL or yl.HTTP_URL
        -- 截图分享
        local framesize = cc.Director:getInstance():getOpenGLView():getFrameSize()
        local area = cc.rect(0, 0, framesize.width, framesize.height)
        local imagename = "grade_share.jpg"
        if bMyFriend then
            imagename = "grade_share_" .. os.time() .. ".jpg"
        end
        ExternalFun.popupTouchFilter(0, false)
        captureScreenWithArea(area, imagename, function(ok, savepath)
            ExternalFun.dismissTouchFilter()
            if ok then
                if bMyFriend then
                    PriRoom:getInstance():getTagLayer(PriRoom.LAYTAG.LAYER_FRIENDLIST, function( frienddata )
                        PriRoom:getInstance():imageShareToFriend(frienddata, savepath, "分享我的战绩")
                    end)
                elseif nil ~= target then
                    MultiPlatform:getInstance():shareToTarget(target, sharecall, "我的战绩", "分享我的战绩", url, savepath, "true")
                end            
            end
        end)
    end)
end

return ResultLayer