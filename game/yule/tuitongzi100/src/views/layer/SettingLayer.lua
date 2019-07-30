local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")

local SettingLayer = class("SettingLayer", cc.Layer)

SettingLayer.BT_EFFECT = 1
SettingLayer.BT_MUSIC = 2
SettingLayer.BT_CLOSE = 3
SettingLayer.TAG_MASK = 4

function SettingLayer:ctor(verstr)
	--加载csb资源
	 --注册触摸事件
	local csbNode = ExternalFun.loadCSB("setting/settingLayer.csb", self)

	local function btnEvent( sender, eventType )
		if eventType == ccui.TouchEventType.ended then
			self:onBtnClick(sender:getTag(), sender)
		end
	end

	local mask = csbNode:getChildByName("Panel_1")	
	mask:setTouchEnabled(true)
	mask:setTag(SettingLayer.TAG_MASK)
	mask:addTouchEventListener(btnEvent)

	--关闭按钮
	local btn = csbNode:getChildByName("close_btn")
	btn:setTag(SettingLayer.BT_CLOSE)
	btn:addTouchEventListener(btnEvent)

    self.m_btnEffect = csbNode:getChildByName("effect_btn")
    self.m_btnEffect:setTag(SettingLayer.BT_EFFECT)
    self.m_btnEffect:addTouchEventListener(btnEvent)
    --音乐
    self.m_btnMusic = csbNode:getChildByName("music_btn")
    self.m_btnMusic:setTag(SettingLayer.BT_MUSIC)
    self.m_btnMusic:addTouchEventListener(btnEvent)
	self:refreshBtnState()
end

function SettingLayer:onBtnClick( tag, sender )
	if SettingLayer.BT_CLOSE == tag or SettingLayer.TAG_MASK == tag then
		ExternalFun.playClickEffect()
		self:removeSelf()
	elseif SettingLayer.BT_MUSIC == tag then
		local music = not GlobalUserItem.bVoiceAble
		GlobalUserItem.setVoiceAble(music)
		self:refreshMusicBtnState()
		if GlobalUserItem.bVoiceAble == true then
			ExternalFun.playBackgroudAudio("BACK_GROUND.mp3")
		else
			AudioEngine.stopMusic()
		end
	elseif SettingLayer.BT_EFFECT == tag then
		local effect = not GlobalUserItem.bSoundAble
		GlobalUserItem.setSoundAble(effect)
		self:refreshEffectBtnState()
	end
end

function SettingLayer:refreshBtnState(  )
	self:refreshEffectBtnState()
	self:refreshMusicBtnState()
end

function SettingLayer:refreshEffectBtnState(  )
	if GlobalUserItem.bSoundAble then
		self.m_btnEffect:setBright(true)
	else
		self.m_btnEffect:setBright(false)
	end
end

function SettingLayer:refreshMusicBtnState(  )
	if GlobalUserItem.bVoiceAble then
		self.m_btnMusic:setBright(true)
	else
		self.m_btnMusic:setBright(false)
	end
end

return SettingLayer