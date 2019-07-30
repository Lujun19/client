local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")

local HelpLayer = class("HelpLayer", cc.Layer)

HelpLayer.BT_CLOSE = 1
HelpLayer.TAG_MASK  = 2

function HelpLayer:ctor()
	local function btnEvent( sender, eventType )
		if eventType == ccui.TouchEventType.ended then
			self:onBtnClick(sender:getTag(), sender)
		end
	end
	
	local csbNode = ExternalFun.loadCSB("help/helpLayer.csb", self)
	self.csbNode = csbNode

	local mask = csbNode:getChildByName("Panel_1")	
	mask:setTouchEnabled(true)
	mask:setTag(HelpLayer.TAG_MASK)
	mask:addTouchEventListener(btnEvent)

	--关闭
	local btn = csbNode:getChildByName("Button_exit")
	btn:setTag(HelpLayer.BT_CLOSE)
	btn:addTouchEventListener(btnEvent)

	self.csbNode:getChildByName("ListView"):setScrollBarAutoHideEnabled(true)
end

function HelpLayer:onBtnClick( tag, sender )
	if HelpLayer.BT_CLOSE == tag or HelpLayer.TAG_MASK == tag then
		ExternalFun.playClickEffect()
		self:removeSelf()
	end
end

return HelpLayer