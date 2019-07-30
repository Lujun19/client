local BankerList = class("BankerList", cc.Layer)
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local publicFunc = appdf.req(appdf.GAME_SRC.."yule.tuitongzi100.src.models.publicFunc")
local ClipText = appdf.req(appdf.EXTERNAL_SRC .. "ClipText")

function BankerList:ctor(bankerList)
    self.bankerList = bankerList
    self:initResourse()
end

function BankerList:initResourse()
	local rootLayer, csbNode = ExternalFun.loadRootCSB("game/applyBankerLayer.csb", self)
    self.csbNode = csbNode

    --遮罩层
    local mask = csbNode:getChildByName("Panel_1"):addClickEventListener(function (sender) ExternalFun.playClickEffect() self:removeFromParent() end)
    	
    self.csbNode:getChildByName("Button_Bank"):addClickEventListener(function (sender) ExternalFun.playClickEffect() self:removeFromParent() end)

	local listView = self.csbNode:getChildByName("bankerList")

	for i=1, #self.bankerList do
		local layout = ccui.Layout:create()
		layout:setContentSize(cc.size(423, 43))

		local name = self.bankerList[i].szNickName
		local score = self.bankerList[i].lScore

		local label = cc.LabelTTF:create(i, "Arial", 26)          
			label:setPosition(cc.p(25, 15))
			label:addTo(layout)
		local nameText = ClipText:createClipText(cc.size(160, 26), name)
			nameText:setPosition(cc.p(90, 5))
			nameText:addTo(layout)
		local scoreText = publicFunc:createScoreLabel(score)
			scoreText:setPosition(cc.p(220, 1))
			scoreText:addTo(layout)

		listView:pushBackCustomItem(layout)
	end
end
return BankerList