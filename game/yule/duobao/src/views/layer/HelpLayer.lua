--
-- Author: garry
-- Date: 2017-2-23
--
local HelpLayer = class("HelpLayer", function (scene)
    local layer = display.newLayer()
	return layer
end)
local ExternalFun = require(appdf.EXTERNAL_SRC .. "ExternalFun")


function HelpLayer:ctor(scene)
	release_print("HelpLayer...")
           self._scene = scene
           self._pageNum = 1
	local winSize = cc.Director:getInstance():getWinSize()

	local black = cc.c4b(0,0,0,0.5)
	local rect={cc.p(0,0),cc.p(winSize.width,0),cc.p(winSize.width,winSize.height),cc.p(0,winSize.height)}
	local greyBg=cc.DrawNode:create()
	greyBg:setAnchorPoint(cc.p(0,0))
	greyBg:setPosition(cc.p(0, 0))
	greyBg:drawPolygon(rect, 4, black, 0, black)
	self:addChild(greyBg)

           local rootLayer, csbNode = ExternalFun.loadRootCSB("game_res/csb/Help.csb",self)
           self._rootNode = csbNode:getChildByName("Sprite_1")
           

            self:initButtonAndView()
    
 	    --设置触摸吞噬
    local dispatcher = self:getEventDispatcher()
    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)
    listener:registerScriptHandler(function ( touches, event )
    	return true
    	end, cc.Handler.EVENT_TOUCH_BEGAN)

    dispatcher:addEventListenerWithSceneGraphPriority(listener, self)

end


function HelpLayer:initButtonAndView()

    local pageImg =  self._rootNode:getChildByName("Sprite_3")

    local duobaotitle = self._rootNode:getChildByName("Sprite_5")
    duobaotitle:setVisible(false)

    local upBtn = self._rootNode:getChildByName("Button_1")
    local downBtn = self._rootNode:getChildByName("Button_2")

            upBtn:setEnabled(false)
            upBtn:addTouchEventListener(function( ref, tType)
                    if tType == ccui.TouchEventType.ended then
                        AudioEngine.playEffect("sound_res/BUTTON_SOUND.wav")
                        self._pageNum = self._pageNum - 1
                        pageImg:setTexture(cc.Director:getInstance():getTextureCache():addImage("game_res/shuoming"..self._pageNum..".png"))
                       

                        if self._pageNum == 1 then
                            upBtn:setEnabled(false)
                        elseif self._pageNum == 4 then
                            duobaotitle:setVisible(false)
                            pageImg:setPosition(543,350)
                            downBtn:setEnabled(true)
                        end
                    end

                end)

    
            downBtn:addTouchEventListener(function( ref, tType)
                    if tType == ccui.TouchEventType.ended then
                        AudioEngine.playEffect("sound_res/BUTTON_SOUND.wav")
                       self._pageNum = self._pageNum + 1
                       pageImg:setTexture(cc.Director:getInstance():getTextureCache():addImage("game_res/shuoming"..self._pageNum..".png"))

                       if 5 == self._pageNum then
                            downBtn:setEnabled(false)
                            duobaotitle:setVisible(true)
                            pageImg:setPosition(543,322)

                       elseif 2 == self._pageNum then
                            upBtn:setEnabled(true)
                       end
                    end

                end)


    local closeBtn = self._rootNode:getChildByName("Button_3")
            closeBtn:addTouchEventListener(function( ref, tType)
                    if tType == ccui.TouchEventType.ended then
                        AudioEngine.playEffect("sound_res/BUTTON_SOUND.wav")
                       self:removeFromParent()
                    end

                end)

end


return HelpLayer

