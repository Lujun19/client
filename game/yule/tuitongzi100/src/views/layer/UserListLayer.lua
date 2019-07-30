local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local ClipText = appdf.req(appdf.EXTERNAL_SRC .. "ClipText")
local PopupInfoHead = appdf.req(appdf.EXTERNAL_SRC .. "PopupInfoHead")
local publicFunc = appdf.req(appdf.GAME_SRC.."yule.tuitongzi100.src.models.publicFunc")

local UserListLayer = class("UserListLayer", cc.Layer)
function UserListLayer:ctor( userList )
	--加载csb资源
	local function btnEvent( sender, eventType )
		if eventType == ccui.TouchEventType.ended then
			self:onBtnClick(sender:getTag(), sender)
		end
	end
	
	self.userList = userList

	local rootLayer, csbNode = ExternalFun.loadRootCSB("playerlist/userListLayer.csb", self)
	local sp_bg = csbNode:getChildByName("bg")
	local listView = sp_bg:getChildByName("ListView")

	--遮罩层
	local mask = csbNode:getChildByName("Panel_1"):addClickEventListener(function (sender) ExternalFun.playClickEffect() self:removeFromParent() end)

	--退出
	sp_bg:getChildByName("close_btn"):addClickEventListener(function (sender) ExternalFun.playClickEffect() self:removeSelf() end)

	local tmp = #self.userList 
	if tmp >= 20 then
		tmp = 20
	end

	for i=1, tmp do
		local layout = ccui.Layout:create()
		layout:setContentSize(cc.size(418, 45))

		local name = self.userList[i].szNickName
		local score = self.userList[i].lScore
		local label = cc.LabelTTF:create(i, "Arial", 26)          
			label:setPosition(cc.p(30, 20))
			label:addTo(layout)
		local nameText = ClipText:createClipText(cc.size(160, 26), name)
			nameText:setPosition(cc.p(90, 10))
			nameText:addTo(layout)
		local scoreText = publicFunc:createScoreLabel(score, "game/no/no2.png", "0")
			scoreText:setPosition(cc.p(210, 10))
			scoreText:addTo(layout)

		  	listView:pushBackCustomItem(layout)
	end
end

return UserListLayer