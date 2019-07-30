--
-- Author: Jacy Leung
-- Date: 2016-08-09 10:26:25
-- HelpLayer

local HelpLayer = class("HelpLayer", cc.Layer)

local module_pre = "game.yule.xlkpy.src"			
local ExternalFun = require(appdf.EXTERNAL_SRC.."ExternalFun")
local cmd = module_pre..".models.CMD_LKPYGame"
local g_var = ExternalFun.req_var
local scheduler = cc.Director:getInstance():getScheduler()
local Game_CMD = appdf.req(module_pre .. ".models.CMD_LKPYGame")

function HelpLayer:ctor()
    local csbNode = ExternalFun.loadCSB(Game_CMD.RES_PATH .. "help/HelpLayer.csb", self)
    self.csbNode = csbNode

    local panel = self.csbNode:getChildByName("Panel_1")

    local scrollview = panel:getChildByName("ScrollView_1")
    scrollview:setScrollBarEnabled(false)      --关闭滑动条

    local btn_close = panel:getChildByName("btn_close")
    btn_close:addTouchEventListener(function(ref, tType)
        if tType == ccui.TouchEventType.ended then
       --     ExternalFun.playCloseEffect()
            self:hideHelpLayer()
        end
    end)
    
    --加载所有鱼的动画

    --普通鱼
    for i = 1, 24 do
        local action = cc.CSLoader:createTimeline(Game_CMD.RES_PATH .. string.format("help/fish_anim/fish_anim_%02d.csb", i))
        local fish_bg = scrollview:getChildByName(string.format("fish_bg_%02d", i))
        fish_bg:runAction(action)
        if i == 1 or i == 7 or i == 12 then
            action:gotoFrameAndPlay(0, 50, true)
        elseif i == 2 or i == 10 or i == 23 then
            action:gotoFrameAndPlay(0, 70, true)
        elseif i >= 3 and i <= 5 or i == 9 or i == 11 or i == 13 or i >= 15 and i <= 17 or i == 22 then
            action:gotoFrameAndPlay(0, 110, true)
        elseif i == 6 then
            action:gotoFrameAndPlay(0, 120, true)
        elseif i == 8 or i == 14 then
            action:gotoFrameAndPlay(0, 90, true)
        elseif i == 18 then
            action:gotoFrameAndPlay(0, 80, true)
        elseif i == 19 then
            action:gotoFrameAndPlay(0, 150, true)
        elseif i == 20 then
            action:gotoFrameAndPlay(0, 190, true)
        elseif i == 21 then
            action:gotoFrameAndPlay(0, 140, true)
        elseif i == 24 then
            action:gotoFrameAndPlay(0, 180, true)
        end
    end

    --大三元
    local fish_bg = scrollview:getChildByName("fish_bg_25")
    for i = 1, 3 do
        local action = cc.CSLoader:createTimeline(Game_CMD.RES_PATH .. "help/fish_anim/fish_anim_04.csb")
        local fileNode = fish_bg:getChildByName(string.format("fish_node_%02d", i))
        fileNode:runAction(action)
        action:gotoFrameAndPlay(0, 110, true)

        action = cc.CSLoader:createTimeline(Game_CMD.RES_PATH .. "help/fish_anim/pan_anim_green.csb")
        fileNode = fish_bg:getChildByName(string.format("pan_node_%02d", i))
        fileNode:runAction(action)
        action:gotoFrameAndPlay(0, 180, true)
    end
    fish_bg = scrollview:getChildByName("fish_bg_26")
    for i = 1, 3 do
        local action = cc.CSLoader:createTimeline(Game_CMD.RES_PATH .. "help/fish_anim/fish_anim_05.csb")
        local fileNode = fish_bg:getChildByName(string.format("fish_node_%02d", i))
        fileNode:runAction(action)
        action:gotoFrameAndPlay(0, 110, true)

        action = cc.CSLoader:createTimeline(Game_CMD.RES_PATH .. "help/fish_anim/pan_anim_green.csb")
        fileNode = fish_bg:getChildByName(string.format("pan_node_%02d", i))
        fileNode:runAction(action)
        action:gotoFrameAndPlay(0, 180, true)
    end
    fish_bg = scrollview:getChildByName("fish_bg_27")
    for i = 1, 3 do
        local action = cc.CSLoader:createTimeline(Game_CMD.RES_PATH .. "help/fish_anim/fish_anim_07.csb")
        local fileNode = fish_bg:getChildByName(string.format("fish_node_%02d", i))
        fileNode:runAction(action)
        action:gotoFrameAndPlay(0, 50, true)

        action = cc.CSLoader:createTimeline(Game_CMD.RES_PATH .. "help/fish_anim/pan_anim_green.csb")
        fileNode = fish_bg:getChildByName(string.format("pan_node_%02d", i))
        fileNode:runAction(action)
        action:gotoFrameAndPlay(0, 180, true)
    end

    --大四喜
    fish_bg = scrollview:getChildByName("fish_bg_28")
    for i = 1, 4 do
        local action = cc.CSLoader:createTimeline(Game_CMD.RES_PATH .. "help/fish_anim/fish_anim_06.csb")
        local fileNode = fish_bg:getChildByName(string.format("fish_node_%02d", i))
        fileNode:runAction(action)
        action:gotoFrameAndPlay(0, 120, true)

        action = cc.CSLoader:createTimeline(Game_CMD.RES_PATH .. "help/fish_anim/pan_anim_green.csb")
        fileNode = fish_bg:getChildByName(string.format("pan_node_%02d", i))
        fileNode:runAction(action)
        action:gotoFrameAndPlay(0, 180, true)
    end
    fish_bg = scrollview:getChildByName("fish_bg_29")
    for i = 1, 4 do
        local action = cc.CSLoader:createTimeline(Game_CMD.RES_PATH .. "help/fish_anim/fish_anim_08.csb")
        local fileNode = fish_bg:getChildByName(string.format("fish_node_%02d", i))
        fileNode:runAction(action)
        action:gotoFrameAndPlay(0, 90, true)

        action = cc.CSLoader:createTimeline(Game_CMD.RES_PATH .. "help/fish_anim/pan_anim_green.csb")
        fileNode = fish_bg:getChildByName(string.format("pan_node_%02d", i))
        fileNode:runAction(action)
        action:gotoFrameAndPlay(0, 180, true)
    end
    fish_bg = scrollview:getChildByName("fish_bg_30")
    for i = 1, 4 do
        local action = cc.CSLoader:createTimeline(Game_CMD.RES_PATH .. "help/fish_anim/fish_anim_10.csb")
        local fileNode = fish_bg:getChildByName(string.format("fish_node_%02d", i))
        fileNode:runAction(action)
        action:gotoFrameAndPlay(0, 70, true)

        action = cc.CSLoader:createTimeline(Game_CMD.RES_PATH .. "help/fish_anim/pan_anim_green.csb")
        fileNode = fish_bg:getChildByName(string.format("pan_node_%02d", i))
        fileNode:runAction(action)
        action:gotoFrameAndPlay(0, 180, true)
    end

    --鱼王
    for i = 31, 40 do
        local action0 = cc.CSLoader:createTimeline(Game_CMD.RES_PATH .. string.format("help/fish_anim/fish_anim_%02d.csb", i - 30))
        local action1 = cc.CSLoader:createTimeline(Game_CMD.RES_PATH .. "help/fish_anim/pan_anim_purple.csb")
        local fish_bg = scrollview:getChildByName(string.format("fish_bg_%02d", i))
        fish_bg:runAction(action0)
        fish_bg:runAction(action1)
        action1:gotoFrameAndPlay(0, 180, true)
        if i == 31 or i == 37 then
            action0:gotoFrameAndPlay(0, 50, true)
        elseif i == 32 or i == 40 then
            action0:gotoFrameAndPlay(0, 70, true)
        elseif i >= 33 and i <= 35 or i == 39 then
            action0:gotoFrameAndPlay(0, 110, true)
        elseif i == 36 then
            action0:gotoFrameAndPlay(0, 120, true)
        elseif i == 38 then
            action0:gotoFrameAndPlay(0, 90, true)
        end
    end

    --宝箱
    local action = cc.CSLoader:createTimeline(Game_CMD.RES_PATH .. "help/fish_anim/box_anim.csb")
    csbNode:runAction(action)
    action:gotoFrameAndPlay(0, 110, true)

end

function HelpLayer:hideHelpLayer()
    self:setVisible(false)
end

function HelpLayer:showHelpLayer()
    self:setVisible(true)
end

function HelpLayer:removeSelf()
    self:setVisible(false)
    self:removeAllChildren()
    self:removeFromParent()
end

return HelpLayer