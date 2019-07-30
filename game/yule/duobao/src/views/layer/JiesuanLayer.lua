--
-- Author: garry
-- Date: 2017-2-23
--
local JiesuanLayer = class("JiesuanLayer", function (scene)
    local layer = display.newLayer()
	return layer
end)
local ExternalFun = require(appdf.EXTERNAL_SRC .. "ExternalFun")


function JiesuanLayer:ctor(scene)
	release_print("JiesuanLayer...")
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

           local rootLayer, csbNode = ExternalFun.loadRootCSB("game_res/csb/Jiesuan.csb",self)
           self._rootNode = csbNode
           

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

function JiesuanLayer:initData(score1,score2)
   local allScore  = self._rootNode:getChildByName("AtlasLabel_1")
   allScore:setString(""..score1*self._scene._gameView.gameData.exchange)

   self._scene._gameView.lastScore = score1

   local benju = self._rootNode:getChildByName("AtlasLabel_2")
   benju:setString(""..score2*self._scene._gameView.gameData.exchange)

    print("score1. = "..score1..",score2 = "..score2)

end


function JiesuanLayer:initButtonAndView()

    local okBtn  = self._rootNode:getChildByName("Button_1")
    okBtn:addTouchEventListener(function(sender,eventType)

            
            if eventType == ccui.TouchEventType.ended then
                
                self._scene._gameView:gameDataReset()
                
                
                self:removeFromParent()
            end

        end)


end



return JiesuanLayer

