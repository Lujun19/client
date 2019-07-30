--
-- Author: luo
-- Date: 2016年12月30日 17:50:01
--
--设置界面
--设置界面
local ExternalFun = require(appdf.EXTERNAL_SRC .. "ExternalFun")

local SettingLayer = class("SettingLayer", cc.Layer)

SettingLayer.BT_EFFECT = 1
SettingLayer.BT_MUSIC = 2
SettingLayer.BT_CLOSE = 3
--构造
function SettingLayer:ctor( )
self._scene = scene
    --注册触摸事件
    ExternalFun.registerTouchEvent(self, true)
    --加载csb资源
    local csbNode = ExternalFun.loadCSB("setting/SettingLayer.csb", self)
    local cbtlistener = function (sender,eventType)
       if eventType == ccui.TouchEventType.ended then
           self:OnButtonClickedEvent(sender:getTag(),sender)
       end
    end


    local sp_bg = csbNode:getChildByName("setting_bg")
    local bgSize = sp_bg:getContentSize()
    self.m_spBg = sp_bg


    local btn = csbNode:getChildByName("close_btn")
    if btn then
        btn:setTag(SettingLayer.BT_CLOSE)
        btn:addTouchEventListener(function (ref, eventType)
        if eventType == ccui.TouchEventType.ended then
            ExternalFun.playClickEffect()
            self:removeFromParent()
        end
    end)
    end
   
       --音效
    self.m_btnEffect = sp_bg:getChildByName("Effect")
    self.m_btnEffect:setTag(SettingLayer.BT_EFFECT)
    self.m_btnEffect:addTouchEventListener(cbtlistener)
    --音乐
    self.m_btnMusic = sp_bg:getChildByName("Music")
    self.m_btnMusic:setTag(SettingLayer.BT_MUSIC)
    self.m_btnMusic:addTouchEventListener(cbtlistener)

    --音效--0
    self.m_btnEffect_0 = sp_bg:getChildByName("Effect_0")
    self.m_btnEffect_0:setTag(SettingLayer.BT_EFFECT)
    self.m_btnEffect_0:addTouchEventListener(cbtlistener)
    --音乐--0
    self.m_btnMusic_0 = sp_bg:getChildByName("Music_0")
    self.m_btnMusic_0:setTag(SettingLayer.BT_MUSIC)
    self.m_btnMusic_0:addTouchEventListener(cbtlistener)

    if GlobalUserItem.bVoiceAble == true then 
       self.m_btnMusic:setVisible(true)
       self.m_btnMusic_0:setVisible(false)
    else
        self.m_btnMusic_0:setVisible(true)
        self.m_btnMusic:setVisible(false)
    end
    if GlobalUserItem.bSoundAble == true then 
         self.m_btnEffect:setVisible(true)
         self.m_btnEffect_0:setVisible(false)
    else
        self.m_btnEffect_0:setVisible(true)
        self.m_btnEffect:setVisible(false)
    end

--        --音乐开关
--    self.m_btnMusic = sp_bg:getChildByName("Music")
--    self.m_btnMusic:setTag(SettingLayer.BT_MUSIC)
--    self.m_btnMusic:addEventListener(cbtlistener)
--    self.m_btnMusic:setPercent(cc.UserDefault:getInstance():getIntegerForKey("gamemusicvalue",10))


--    --音效开关
--    self.m_btnEffect = sp_bg:getChildByName("Effect")
--    self.m_btnEffect:setTag(SettingLayer.BT_EFFECT)
--    self.m_btnEffect:addEventListener(cbtlistener)
--    self.m_btnEffect:setPercent(cc.UserDefault:getInstance():getIntegerForKey("gameeffectvalue",10))


end
--

function SettingLayer:onTouchBegan(touch, event)
    return self:isVisible()
end

function SettingLayer:onTouchEnded(touch, event)
    dump(event)
    local pos = touch:getLocation() 
    local m_spBg = self.m_spBg
    pos = m_spBg:convertToNodeSpace(pos)
    local rec = cc.rect(0, 0, m_spBg:getContentSize().width, m_spBg:getContentSize().height)
    if false == cc.rectContainsPoint(rec, pos) then
        self:removeFromParent()
        -- local parent = self:getParent()
        -- parent.m_AreaMenu:setVisible(false)
        -- parent.m_bShowMenu = not parent.m_bShowMenu
    end
end

function SettingLayer:onClickCallBack(eventType, x, y)
    print(eventType)
    if eventType=="began" then
         return true
    end
     local pos = cc.p(x, y)
     local rectMusic = self.m_btnMusic:getBoundingBox()
     local rectEffect = self.m_btnEffect:getBoundingBox()


     if not (cc.rectContainsPoint(rectLayerBg, pos) or cc.rectContainsPoint(rectLayertitle, pos)) then
    	self:hideLayer()
     end
  
     return true
end

function SettingLayer:showLayer()
	self.colorLayer:setTouchEnabled(true)
	self:setVisible(true)
end

function SettingLayer:OnButtonClickedEvent( tag, sender )
    if SettingLayer.BT_MUSIC == tag then
        local music = not GlobalUserItem.bVoiceAble
        GlobalUserItem.setVoiceAble(music)
        if GlobalUserItem.bVoiceAble == true then 
            ExternalFun.playBackgroudAudio("beijingyinyue.mp3")
            self.m_btnMusic:setVisible(true)
            self.m_btnMusic_0:setVisible(false)
        else
            AudioEngine.stopMusic()
            self.m_btnMusic:setVisible(false)
            self.m_btnMusic_0:setVisible(true)
        end
    elseif SettingLayer.BT_EFFECT == tag then
        local effect = not GlobalUserItem.bSoundAble
        GlobalUserItem.setSoundAble(effect)
        if GlobalUserItem.bSoundAble == true then 
            self.m_btnEffect_0:setVisible(false)
            self.m_btnEffect:setVisible(true)
        else
            self.m_btnEffect_0:setVisible(true)
            self.m_btnEffect:setVisible(false)
        end
    end
end


----------------------------------------------------------------
function SettingLayer:hideLayer()
    cc.UserDefault:getInstance():setIntegerForKey("gamemusicvalue",self.m_btnMusic:getPercent())
    cc.UserDefault:getInstance():setIntegerForKey("gameeffectvalue",self.m_btnEffect:getPercent())
end


function SettingLayer:onSoundEvent(tag,sender,eventType)
    if tag == SettingLayer.BT_MUSIC then
        AudioEngine.setMusicVolume(self.m_btnMusic:getPercent()/100.0)
    elseif tag== SettingLayer.BT_EFFECT then      
        AudioEngine.setEffectsVolume(self.m_btnEffect:getPercent()/100.0)   
    end
end
return SettingLayer