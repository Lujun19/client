local cmd = appdf.req(appdf.GAME_SRC.."yule.sparrowhz.src.models.CMD_Game")
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC.."ExternalFun")
local CardLayer = appdf.req(appdf.GAME_SRC.."yule.sparrowhz.src.views.layer.CardLayer")
local PopupInfoHead = appdf.req("client.src.external.PopupInfoHead")
local GameLogic = appdf.req(appdf.GAME_SRC.."yule.sparrowhz.src.models.GameLogic")

local TransitionLayer = appdf.req(appdf.EXTERNAL_SRC .. "TransitionLayer")
local GameVideoResultLayer = class("GameVideoResultLayer", TransitionLayer)


-- local GameVideoResultLayer = class("ResultLayer", function(scene)
-- 	local resultLayer = cc.CSLoader:createNode(cmd.RES_PATH.."video/Layer_VideoResult.csb")
-- 	return resultLayer
-- end)


GameVideoResultLayer.WINNER_ORDER					= 1


function GameVideoResultLayer:onInitData()
	--body
	self.winnerIndex = nil
	self.bShield = false

end

function GameVideoResultLayer:onResetData()
	--body
	self.winnerIndex = nil
	self.bShield = false
end

function GameVideoResultLayer:onExit()
	--重置搜索路径
    local oldPaths = cc.FileUtils:getInstance():getSearchPaths()
    local newPaths = {}
    for k,v in pairs(oldPaths) do
        if tostring(v) ~= tostring(self._searchPath) then
            table.insert(newPaths, v)
        end
    end
    cc.FileUtils:getInstance():setSearchPaths(newPaths)
    GameVideoResultLayer.super.onExit(self)
end

function GameVideoResultLayer:ctor(scene)
	GameVideoResultLayer.super.ctor(self, scene)

   self._searchPath = device.writablePath.."game/yule/sparrowhz/res/"
   cc.FileUtils:getInstance():addSearchPath(self._searchPath)

    -- 加载csb资源
    self.csbNode = cc.CSLoader:createNode("video/Layer_VideoResult.csb")
    self:addChild(self.csbNode)

   	self.m_bg = self.csbNode:getChildByName("Panel_1")

	self._scene = scene
	self:onInitData()
	ExternalFun.registerTouchEvent(self, true)

	-- 遮罩
    self.m_bg:addTouchEventListener(function(ref, tType)
    	if tType == ccui.TouchEventType.ended then
         	self:scaleTransitionOut(self.m_bg)
        end
	end)

	local btnExit = self.m_bg:getChildByName("Btn_close")
	btnExit:addTouchEventListener(function(ref, tType)
		if tType == ccui.TouchEventType.ended then
         	self:scaleTransitionOut(self.m_bg)
        end
	end)

	-- 加载动画
    self:scaleTransitionIn(self.m_bg)
end

--通过结算信息，绘制结算界面
function GameVideoResultLayer:showLayer(resultList,cbHuCard)
	assert(type(resultList) == "table")
	local width = 44
	local height = 67

    --self._cardLayer = CardLayer:create(self)
	for i = 1, cmd.GAME_PLAYER do
		--print("hhhhhhhhhhhhhhhhhhhh,"..#resultList )
		if i <= #resultList and resultList[i].userItem then
			--获取node
			local node = self.m_bg:getChildByName("Node_"..string.format("%d", i))
			local infoNode = cc.CSLoader:createNode(cmd.RES_PATH.."video/Node_info.csb")--self.csbNode:getChildByName("Node_"..string.format("%d", i))
			self.m_bg:addChild(infoNode)
			infoNode:setPosition(node:getPosition())

			print("获取玩家信息", "Node_"..string.format("%d", i), infoNode)
			if nil ~= infoNode then
				
				--展示麻将
				local nodeCard = infoNode:getChildByName("Node_Card")
				print("获取麻将node", nodeCard)
				local pos = cc.p(-50, 0)

                --self._cardLayer.cbMagicData = clone(resultList[i].cbMagicData)


				--展示手牌
				for j=1,#resultList[i].cbCardData do
					local sprCard = self:creatCard(resultList[i].cbCardData[j])--self._cardLayer:createOutOrActiveCardSprite(cmd.MY_VIEWID, resultList[i].cbCardData[j], false)
					if nil ~= sprCard then
						nodeCard:addChild(sprCard)
						pos = cc.p(pos.x + width, 0)
						sprCard:setPosition(pos)
						print("结算麻将位置1",pos.x, pos.y)
					end
				end
				--显示碰刚的牌
				pos = cc.p(pos.x + 10, 0)
				if nil ~=  resultList[i].cbActiveCardData then
					print("kkkkkkkkkkkkkkkkkkkkkkk")
					for j=1,#resultList[i].cbActiveCardData do
						local tagAvtiveCard = resultList[i].cbActiveCardData[j]
						pos = cc.p(pos.x + 6, 0)
						for num=1,tagAvtiveCard.cbCardNum do
							local sprCard = self:creatCard(tagAvtiveCard.cbCardValue[1])--self._cardLayer:createOutOrActiveCardSprite(cmd.MY_VIEWID, tagAvtiveCard.cbCardValue[1], false)
							--sprCard:setAnchorPoint(cc.p(0.5, 0))
							if nil ~= sprCard then
								nodeCard:addChild(sprCard)
								if 4 ~= num then
									pos = cc.p(pos.x + width, 0)
									sprCard:setPosition(pos)
								else --第四张放上面，但是不影响POS的值
									local posUp = cc.p(pos.x - width, 8)
									sprCard:setPosition(posUp)
								end
							end
						end
					end
				end

				--显示胡的牌
				local nodeHuCard = infoNode:getChildByName("Node_HuCard")
				if resultList[i].dwChiHuRight[1] > 0 and 0 ~= cbHuCard then
					local sprCard = self:creatCard(cbHuCard)--self._cardLayer:createOutOrActiveCardSprite(cmd.MY_VIEWID, cbHuCard, false)
					if nil ~= sprCard then
						nodeHuCard:addChild(sprCard)
					end
				end

				if nil ~= resultList[i].userItem then
					--ID
					local name = infoNode:getChildByName("Text_id")
					if nil ~= name then
						name:setString(resultList[i].userItem.dwGameID.."")
					end

					--昵称
					local name = infoNode:getChildByName("Text_name")
					if nil ~= name then
						
						local strNickname = string.EllipsisByConfig(resultList[i].userItem.szNickName, 100, 
	                                                            string.getConfig("fonts/round_body.ttf", 20))
						name:setString(strNickname)
					end

					--玩家头像
					local nodeFace = infoNode:getChildByName("Node_face")
			        if nil ~= nodeFace then
			            -- 头像
			            local head = PopupInfoHead:createNormal(resultList[i].userItem, 63)
			            head:enableInfoPop(false)
			            nodeFace:addChild(head)
			        end
		    	end

				local labHu = infoNode:getChildByName("Text_score") 
				if nil ~= labHu then
					labHu:setString(resultList[i].lScore.."")
				end
			end
		else
			local node = self.m_bg:getChildByName("Node_"..string.format("%d", i))
			node:setVisible(false)
		end
	end
	self.bShield = true
	self:setVisible(true)
	self:setLocalZOrder(yl.MAX_INT)
end

function GameVideoResultLayer:creatCard(cardData)
	local card = display.newSprite(cmd.RES_PATH.."game/font_small/card_down.png")
			
		--字体
		local nValue = math.mod(cardData, 16)
		local nColor = math.floor(cardData/16)
		display.newSprite(cmd.RES_PATH.."game/font_small/font_"..nColor.."_"..nValue..".png")
			:move(44/2, 67/2 + 8)
			:addTo(card)
	return card
end

--胡牌信息描述
function GameVideoResultLayer:createResultDes(title, num, unit)
	local nodeDes = cc.CSLoader:createNode(cmd.RES_PATH.."gameResult/node_des.csb")
	local sprTitle = nodeDes:getChildByName("title")
	if nil ~= sprTitle then
		local spr = cc.Sprite:create(cmd.RES_PATH.."gameResult/"..title)
		if nil ~= spr then
			sprTitle:setSpriteFrame(spr:getSpriteFrame())
		end
	end

	local labelNum = nodeDes:getChildByName("num")
	if nil ~= labelNum then
		labelNum:setString(num.."")
	end

	local sprUnit = nodeDes:getChildByName("unit")
	if nil ~= sprUnit and 2 == unit then
		local spr = cc.Sprite:create(cmd.RES_PATH.."gameResult/fan.png")
		if nil ~= spr then
			sprUnit:setSpriteFrame(spr:getSpriteFrame())
		end
	end
	return nodeDes
end

function GameVideoResultLayer:hideLayer()
	--重置搜索路径
    local oldPaths = cc.FileUtils:getInstance():getSearchPaths()
    local newPaths = {}
    for k,v in pairs(oldPaths) do
        if tostring(v) ~= tostring(device.writablePath.."game/yule/sparrowgdex/res/") then
            table.insert(newPaths, v)
        end
    end
    cc.FileUtils:getInstance():setSearchPaths(newPaths)

	self:onResetData()
	--self._scene.btStart:setVisible(true)
	self:removeFromParent()
end

function GameVideoResultLayer:animationRemove()
    self:scaleTransitionOut(self.m_bg)
end

function GameVideoResultLayer:onTransitionInBegin()
	print("GameVideoResultLayer:onTransitionInBegin")
    self:sendShowEvent()
end

function GameVideoResultLayer:onTransitionOutBegin()
    self:sendHideEvent()
end

function GameVideoResultLayer:onTransitionOutFinish()
   self:removeFromParent()
end


return GameVideoResultLayer