--
-- Author: David
-- Date: 2017-4-6 18:39:13
--
--设置界面
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC.."ExternalFun")
local GameLogic = appdf.req(appdf.GAME_SRC.."yule.sparrowxz.src.models.GameLogic")
local cmd = appdf.req(appdf.GAME_SRC.."yule.sparrowxz.src.models.CMD_Game")

local SettingLayer = class("SettingLayer", cc.Layer)

SettingLayer.BT_EFFECT = 1
SettingLayer.BT_MUSIC = 2
SettingLayer.BT_CLOSE = 3
--构造
function SettingLayer:ctor( parent )
    self.m_parent = parent
    --注册触摸事件
    ExternalFun.registerTouchEvent(self, true)

    --加载csb资源
    local csbNode = ExternalFun.loadCSB("setting/SettingLayer.csb", self)

    local cbtlistener = function (sender,eventType)
        self:onSelectedEvent(sender:getTag(),eventType)
    end

    local sp_bg = csbNode:getChildByName("setting_bg")
    self.m_spBg = sp_bg

    -- --关闭按钮
    -- local btn = sp_bg:getChildByName("close_btn")
    -- btn:setTag(SettingLayer.BT_CLOSE)
    -- btn:addTouchEventListener(function (ref, eventType)
    --     if eventType == ccui.TouchEventType.ended then
    --         ExternalFun.playClickEffect()
    --         self:removeFromParent()
    --     end
    -- end)

    --switch
    --音效
    self.m_btnEffect = sp_bg:getChildByName("btn_bg")
    self.m_btnEffect:setTag(SettingLayer.BT_EFFECT)
    self.m_btnEffect:addTouchEventListener(cbtlistener)
    if GlobalUserItem.bSoundAble == true then   
        --设置纹理
        self.m_btnEffect:loadTextureNormal(cmd.RES_PATH.."setting/OFF_1.png")
        self.m_btnEffect:loadTexturePressed(cmd.RES_PATH.."setting/OFF_2.png")
    else
         --设置纹理
        self.m_btnEffect:loadTextureNormal(cmd.RES_PATH.."setting/ON_1.png")
        self.m_btnEffect:loadTexturePressed(cmd.RES_PATH.."setting/ON_2.png")
    end

    --音乐
    self.m_btnMusic = sp_bg:getChildByName("btn_effect")
    self.m_btnMusic:setTag(SettingLayer.BT_MUSIC)
    self.m_btnMusic:addTouchEventListener(cbtlistener)
    if GlobalUserItem.bVoiceAble == true then
        --设置纹理
        self.m_btnMusic:loadTextureNormal(cmd.RES_PATH.."setting/OFF_1.png")
        self.m_btnMusic:loadTexturePressed(cmd.RES_PATH.."setting/OFF_2.png")
    else
         --设置纹理
        self.m_btnMusic:loadTextureNormal(cmd.RES_PATH.."setting/ON_1.png")
        self.m_btnMusic:loadTexturePressed(cmd.RES_PATH.."setting/ON_2.png")
    end

    -- 版本号
    local mgr = self.m_parent:getParentNode():getParentNode():getApp():getVersionMgr()
    local verstr = mgr:getResVersion(391) or "0"
    verstr = "游戏版本:" .. appdf.BASE_C_VERSION .. "." .. verstr
    local txt_ver = sp_bg:getChildByName("Text_3")
    txt_ver:setString(verstr)
    --txt_ver:setString("客服端测试版1.0")
end

--
function SettingLayer:showLayer( var )
    self:setVisible(var)
end

function SettingLayer:onSelectedEvent( tag, eventType )
    if SettingLayer.BT_MUSIC == tag then
        if eventType == ccui.TouchEventType.ended then
            local music = not GlobalUserItem.bVoiceAble
            print("按钮状态，音乐", music)
            GlobalUserItem.setVoiceAble(music)
            if GlobalUserItem.bVoiceAble == true then
                AudioEngine.playMusic("sound/backgroud.mp3", true)
                --设置纹理
                self.m_btnMusic:loadTextureNormal(cmd.RES_PATH.."setting/OFF_1.png")
                self.m_btnMusic:loadTexturePressed(cmd.RES_PATH.."setting/OFF_2.png")
            else
                 --设置纹理
                self.m_btnMusic:loadTextureNormal(cmd.RES_PATH.."setting/ON_1.png")
                self.m_btnMusic:loadTexturePressed(cmd.RES_PATH.."setting/ON_2.png")
            end
        end
    elseif SettingLayer.BT_EFFECT == tag then
        if eventType == ccui.TouchEventType.ended then
            local effect = not GlobalUserItem.bSoundAble
            GlobalUserItem.setSoundAble(effect)
            if GlobalUserItem.bSoundAble == true then
                --设置纹理
                self.m_btnEffect:loadTextureNormal(cmd.RES_PATH.."setting/OFF_1.png")
                self.m_btnEffect:loadTexturePressed(cmd.RES_PATH.."setting/OFF_2.png")
            else
                 --设置纹理
                self.m_btnEffect:loadTextureNormal(cmd.RES_PATH.."setting/ON_1.png")
                self.m_btnEffect:loadTexturePressed(cmd.RES_PATH.."setting/ON_2.png")
            end
        end
    end
end

function SettingLayer:onTouchBegan(touch, event)
    return self:isVisible()
end

function SettingLayer:onTouchEnded(touch, event)
    local pos = touch:getLocation() 
    local m_spBg = self.m_spBg
    pos = m_spBg:convertToNodeSpace(pos)
    local rec = cc.rect(0, 0, m_spBg:getContentSize().width, m_spBg:getContentSize().height)
    if false == cc.rectContainsPoint(rec, pos) then
        self:removeFromParent()
    end
end

return SettingLayer