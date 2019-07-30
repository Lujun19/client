local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local module_pre = "game.yule.animalbattle.src"
local PopupLayer=appdf.req(module_pre..".views.layer.PopupLayer")
local cmd = appdf.req(module_pre .. ".models.CMD_Game")
local SettingLayer = class("SettingLayer",PopupLayer)

SettingLayer.CBT_SILENCE 	= 1
SettingLayer.CBT_SOUND   	= 2

function SettingLayer:ctor(parentNode)
	self._parentNode=parentNode
	SettingLayer.super.ctor(self)
 	self.csbNode=ExternalFun.loadCSB("SettingLayer.csb",self)
 	self.csbNode:setAnchorPoint(0.5,1)
 	self.csbNode:setPosition(yl.WIDTH/2,yl.HEIGHT+20)

 	local cbtlistener = function (sender,eventType)
    	self:onSelectedEvent(sender:getTag(),sender,eventType)
    end

 	self.effectAudio = appdf.getNodeByName(self.csbNode,"effect")
	self.effectAudio:setSelected(GlobalUserItem.bSoundAble)
		:setTag(self.CBT_SOUND)
		:addEventListener(cbtlistener)

	self.bgAudio = appdf.getNodeByName(self.csbNode,"music")
	self.bgAudio:setSelected(GlobalUserItem.bVoiceAble)
		:setTag(self.CBT_SILENCE)
		:addEventListener(cbtlistener)

	appdf.getNodeByName(self.csbNode,"Button_1")
		:addClickEventListener(function() self:removeSelf() end)

	ccui.Text:create("游戏版本"..cmd.VERSION_CLIENT,"fonts/round_body.ttf",26)
    					:addTo(self.csbNode)
    					:setPosition(cc.p(650,120))
                        :setTextColor(cc.c4b(140,230,100,255))
end


function SettingLayer:onSelectedEvent(tag,sender,eventType)
	if tag == SettingLayer.CBT_SILENCE then
		GlobalUserItem.setVoiceAble(eventType == ccui.CheckBoxEventType.selected)
		self._parentNode:playBackgroundMusic()
	elseif tag == SettingLayer.CBT_SOUND then
		GlobalUserItem.setSoundAble(eventType == ccui.CheckBoxEventType.selected)
	end
end

return SettingLayer