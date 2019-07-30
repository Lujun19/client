--
-- Author: tom
-- Date: 2017-02-20 19:11:27
--
local cmd = appdf.req(appdf.GAME_SRC.."yule.sparrowhz.src.models.CMD_Game")
local PopupInfoHead = appdf.req(appdf.EXTERNAL_SRC .. "PopupInfoHead")

local DismissLayer = class("DismissLayer", function(scene)
	local dismissLayer = cc.CSLoader:createNode("privateRoom/DismissLayer.csb")
	return dismissLayer
end)

local TAG_BT_AGREE = 1
local TAG_BT_OPPOSE = 2

local MAX_TIME = 120

function DismissLayer:onInitData()
	--body
	self._timeId = nil
	self.time = 0
	self.nOrder = {}
	self.bAgreeList = {}
	self.wMyChairId = self._scene._gameLayer:GetMeChairID()
end

function DismissLayer:onResetData()
	--body
end

function DismissLayer:ctor(scene)
	self._scene = scene
	self:onInitData()

	local function btcallback(ref, tType)
        if tType == ccui.TouchEventType.ended then
            self:onButtonClickedEvent(ref:getTag(),ref)
        end
    end

    --屏蔽层
    self.layoutShield = ccui.Layout:create()
        :setContentSize(cc.size(display.width, display.height))
        :addTo(self)

    local btAgree = self:getChildByName("bt_agree")
    btAgree:setTag(TAG_BT_AGREE)
    btAgree:setLocalZOrder(1)
    btAgree:addTouchEventListener(btcallback)

    local btOppose = self:getChildByName("bt_oppose")
    btOppose:setTag(TAG_BT_OPPOSE)
    btOppose:setLocalZOrder(1)
    btOppose:addTouchEventListener(btcallback)

    self.textCountDown = self:getChildByName("Text_countDown"):setVisible(true)

    self:setVisible(false)
end

function DismissLayer:showLayer(remainTime)
    --self.time = cc.UserDefault:getInstance():getIntegerForKey("dismissLayerTime", MAX_TIME)
    self.time = remainTime
    if not self._timeId then
    	self.textCountDown:setVisible(true)
	    self._timeId = cc.Director:getInstance():getScheduler():scheduleScriptFunc(function()
	    	self:onUpdateClock()
	    end, 1, false)
	    self:onUpdateClock()
	end

	self.layoutShield:setTouchEnabled(true)
	self:setVisible(true)
end

function DismissLayer:hideLayer()
	--self.time = MAX_TIME
	self:setVisible(false)
	self:setButtonVisible(true)
	self.layoutShield:setTouchEnabled(false)
    self.textCountDown:setVisible(false)
	--cc.UserDefault:getInstance():setIntegerForKey("dismissLayerTime", MAX_TIME)
	if self._timeId then
		cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self._timeId)
		self._timeId = nil
	end
end

function DismissLayer:onButtonClickedEvent( tag, sender )
	if tag == TAG_BT_AGREE then
		print("同意")
        PriRoom:getInstance():getNetFrame():sendRequestReply(1)
        self:setButtonVisible(false)
        self:requestReply(self._scene._gameLayer:GetMeUserItem(), true)
	elseif tag == TAG_BT_OPPOSE then
		print("不同意")
		PriRoom:getInstance():getNetFrame():sendRequestReply(0)
		self:setButtonVisible(false)
        self:requestReply(self._scene._gameLayer:GetMeUserItem(), false)
	end
end

function DismissLayer:onUpdateClock()
	self.textCountDown:setString("( "..self.time.." )")
	self.time = self.time - 1

	if self.time <= 0 then
        -- 默认同意
        PriRoom:getInstance():getNetFrame():sendRequestReply(1)
        
    	self.textCountDown:setVisible(false)
		if self._timeId then
			cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self._timeId)
			self._timeId = nil
		end
		if self:getChildByTag(TAG_BT_OPPOSE):isVisible() then
			self:onButtonClickedEvent(TAG_BT_OPPOSE)
		end
	end

	if math.mod(self.time, 10) == 0 then
	end
end

function DismissLayer:onLeaveGame()
	--cc.UserDefault:getInstance():setIntegerForKey("dismissLayerTime", self.time)
end

function DismissLayer:onExit()
	--正在倒计时
	if self._timeId then
		cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self._timeId)
		self._timeId = nil

		--cc.UserDefault:getInstance():setIntegerForKey("dismissLayerTime", self.time)
	end
end

function DismissLayer:requestDismissRoom(requestUser, remaintime)
	self._requestUser = requestUser
	--隐藏
	for i = 1, 4 do
		self:getChildByName("Text_user"..i):setVisible(false)
		self:getChildByName("Text_user"..i.."_action"):setVisible(false)
		self:getChildByName("Node_"..i):setVisible(false)
	end

	--请求者
	local strNickname = string.EllipsisByConfig(requestUser.szNickName, 140, 
                                                string.getConfig("fonts/round_body.ttf", 20))
	self:getChildByName("Text_user"):setString(strNickname)

	--其他人
	local nUserCount = 2
	for i = 1, 4 do
		local wChairID = i - 1
        local userItem = self._scene._gameLayer:getUserInfoByChairID(i-1)
        if userItem then
        	print("ppppppppppppppppppppppppppp,"..i)
        	if userItem.dwUserID == requestUser.dwUserID then
        		print("hhhhhhhhhhhhhhhhhhhhhh")
        		local textUser = self:getChildByName("Text_user"..1)
				local strNickname = string.EllipsisByConfig(userItem.szNickName, 140, 
                                                string.getConfig("fonts/round_body.ttf", 20))
	        	textUser:setString(strNickname)
	        	textUser:setVisible(true)

	        	self:getChildByName("Text_user1_action"):setString("申请解散")
                self:getChildByName("Text_user1_action"):setVisible(true)

	        	--头像
	        	local faceNode = self:getChildByName("Node_1")
	        	local head = PopupInfoHead:createNormal(userItem, 88)
	        	head:enableInfoPop(false)
		        faceNode:addChild(head)
		        faceNode:setVisible(true)
        	else
	        	local textUser = self:getChildByName("Text_user"..nUserCount)
        		local strNickname = string.EllipsisByConfig(userItem.szNickName, 140, 
                                            string.getConfig("fonts/round_body.ttf", 20))
	        	textUser:setString(strNickname)
	        	textUser:setVisible(true)

	        	local textUserAction = self:getChildByName("Text_user"..nUserCount.."_action")
	        	textUserAction:setString("正在选择..")
	        	textUserAction:setVisible(true)

	        	--头像
	        	local faceNode = self:getChildByName("Node_"..nUserCount)
	        	local head = PopupInfoHead:createNormal(userItem, 88)
	        	head:enableInfoPop(false)
		        faceNode:addChild(head)
		        faceNode:setVisible(true)

				self.nOrder[i] = nUserCount
	        	nUserCount = nUserCount + 1
	        	if nUserCount > 4 then
	        		nUserCount = 4
	        	end
        	end
        end
    end

    if requestUser.wChairID == self.wMyChairId then
    	self:setButtonVisible(false)
    else
    	self:setButtonVisible(true)
    end

    -- --解散者隐藏按钮
    -- if bSelf then
    -- 	self:setButtonVisible(false)
    -- else
    -- 	self:setButtonVisible(true)
    -- end

	--cc.UserDefault:getInstance():setIntegerForKey("dismissLayerTime", MAX_TIME)
    self:showLayer(remaintime or MAX_TIME)
end

--重连解散界面(cbIsDeal)
function DismissLayer:reStartDismissRoom(requestUserChairId, cbIsDeal, remainTime)
	assert(type(cbIsDeal) == "table")
	print("cbIsDeal", table.concat(cbIsDeal, ","))
	local myChairId = self._scene._gameLayer:GetMeChairID()
	--先隐藏
	for i = 1, 4 do
		self:getChildByName("Text_user"..i):setVisible(false)
		self:getChildByName("Text_user"..i.."_action"):setVisible(false)
		self:getChildByName("Node_"..i):setVisible(false)
	end
	--再显示
	local nUserCount = 2
	for i = 1, 4 do
		local wChairID = i - 1
        local userItem = self._scene._gameLayer:getUserInfoByChairID(i-1)
        if userItem then
        	if userItem.wChairID == requestUserChairId then 		--请求解散者
        		self._requestUser = userItem
        		local textUser = self:getChildByName("Text_user")
        		textUser:setVisible(true)
        		local strNickname = string.EllipsisByConfig(userItem.szNickName, 140, 
                            string.getConfig("fonts/round_body.ttf", 20))
	        	textUser:setString(strNickname)

        		local textUser1 = self:getChildByName("Text_user1")
        		textUser1:setVisible(true)
        		textUser1:setString(strNickname)

        		local textUserAction = self:getChildByName("Text_user1_action")
        		textUserAction:setString("申请解散")
        		textUserAction:setVisible(true)

	        	--头像
	        	local faceNode = self:getChildByName("Node_1")
	        	local head = PopupInfoHead:createNormal(userItem, 88)
	        	head:enableInfoPop(false)
		        faceNode:addChild(head)
		        faceNode:setVisible(true)

        		if userItem.wChairID == myChairId then
	    			--隐藏按钮
	    			self:setButtonVisible(false)
	    		else
	    			self:setButtonVisible(true)
	    		end
        	else 										--非请求解散者
	        	local str = ""
	        	if cbIsDeal[i] == 0 then
	        		str = "正在选择.."
	        	elseif cbIsDeal[i] == 1 then
	        		str = "选择了同意"
	        		print("椅子号", userItem.wChairID, myChairId)
	        		if userItem.wChairID == myChairId then
	        			--隐藏按钮
	        			self:setButtonVisible(false)
	        		end
	        	elseif cbIsDeal[i] == 2 then
	        		str = "选择了拒绝"
	        	end

	        	local textUser = self:getChildByName("Text_user"..nUserCount)
        		local strNickname = string.EllipsisByConfig(userItem.szNickName, 140, 
                            string.getConfig("fonts/round_body.ttf", 20))
	        	textUser:setString(strNickname)
	        	textUser:setVisible(true)

	        	local textUserAction = self:getChildByName("Text_user"..nUserCount.."_action")
	        	textUserAction:setString(str)
	        	textUserAction:setVisible(true)

	        	--头像
	        	local faceNode = self:getChildByName("Node_"..nUserCount)
	        	local head = PopupInfoHead:createNormal(userItem, 88)
	        	head:enableInfoPop(false)
		        faceNode:addChild(head)
		        faceNode:setVisible(true)

				self.nOrder[i] = nUserCount
	        	nUserCount = nUserCount + 1
	        	if nUserCount > 4 then
	        		nUserCount = 4
	        	end
	        end
        end
    end

    self:showLayer(remainTime)
end

function DismissLayer:requestReply(replyUser, bAgree)
	local str = (bAgree and "选择了同意" or "选择了拒绝")
	local order = self.nOrder[replyUser.wChairID + 1]
	if order then
		local textUser = self:getChildByName("Text_user"..order)
		local strNickname = string.EllipsisByConfig(replyUser.szNickName, 140, 
                            string.getConfig("fonts/round_body.ttf", 20))
		textUser:setString(strNickname)

		local textUserAction = self:getChildByName("Text_user"..order.."_action")
		textUserAction:setString(str)

     	--头像
    	local faceNode = self:getChildByName("Node_"..order)
    	local head = PopupInfoHead:createNormal(replyUser, 88)
    	head:enableInfoPop(false)
        faceNode:addChild(head)
	else
		print("Error, request reply")
	end
end

function DismissLayer:setButtonVisible(bVisible)
    self:getChildByTag(TAG_BT_AGREE):setVisible(bVisible)
    self:getChildByTag(TAG_BT_OPPOSE):setVisible(bVisible)
end

return DismissLayer