--
-- Author: zhouweixiang
-- Date: 2016-12-27 16:03:00
--
--游戏记录
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")

local GameRecordLayer = class("GameRecordLayer", cc.Layer)
GameRecordLayer.BT_CLOSE = 1

function GameRecordLayer:ctor(viewParent)
	self.m_parent = viewParent

	--加载csb资源
	local csbNode = ExternalFun.loadCSB("LudanLayer.csb", self)

	local sp_bg = csbNode:getChildByName("im_ludan_bg")
	self.m_spBg = sp_bg
	--关闭按钮
	local function btnEvent( sender, eventType )
		if eventType == ccui.TouchEventType.ended then
			self:onButtonClickedEvent(sender:getTag(), sender);
		end
	end

	--[[local layoutbg = csbNode:getChildByName("layout_bg")
	layoutbg:setTag(GameRecordLayer.BT_CLOSE)
	layoutbg:addTouchEventListener(btnEvent)--]]

	--
	self.m_content = sp_bg:getChildByName("layout_content")
end

function GameRecordLayer:onButtonClickedEvent( tag, sender )
	ExternalFun.playClickEffect()
	if GameRecordLayer.BT_CLOSE == tag then
		self:setVisible(false)
	end
end

function GameRecordLayer:refreshRecord(vecRecord)
	self:setVisible(true)
	if nil == vecRecord then
		return
	end
	self.m_content:removeAllChildren()

	for i,v in ipairs(vecRecord) do
		local pimage = cc.Sprite:createWithSpriteFrameName("im_sign_right.png")
		if v.bWinShunMen == false then
			pimage:setSpriteFrame("im_sign_pass.png")
		end
		pimage:setPosition(66+(i-1)*24, 80)
		self.m_content:addChild(pimage)

		pimage = cc.Sprite:createWithSpriteFrameName("im_sign_right.png")
		if v.bWinDuiMen == false then
			pimage:setSpriteFrame("im_sign_pass.png")
		end
		pimage:setPosition(66+(i-1)*24, 50)
		self.m_content:addChild(pimage)

		pimage = cc.Sprite:createWithSpriteFrameName("im_sign_right.png")
		if v.bWinDaoMen == false then
			pimage:setSpriteFrame("im_sign_pass.png")
		end
		pimage:setPosition(66+(i-1)*24, 20)
		self.m_content:addChild(pimage)
 
	end
end

return GameRecordLayer