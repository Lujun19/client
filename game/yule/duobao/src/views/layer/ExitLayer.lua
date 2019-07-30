--
-- Author: garry
-- Date: 2017-2-23
--
local ExitLayer = class("ExitLayer", function (scene)
    local layer = display.newLayer()
	return layer
end)

local module_pre = "game.yule.duobao.src"
local ExternalFun = require(appdf.EXTERNAL_SRC .. "ExternalFun")
local g_var = ExternalFun.req_var

local cmd = module_pre .. ".models.cmd_game"


function ExitLayer:ctor(scene)
	release_print("ExitLayer...")
           self._scene = scene

	local winSize = cc.Director:getInstance():getWinSize()

	local black = cc.c4b(0,0,0,0.5)
	local rect={cc.p(0,0),cc.p(winSize.width,0),cc.p(winSize.width,winSize.height),cc.p(0,winSize.height)}
	local greyBg=cc.DrawNode:create()
	greyBg:setAnchorPoint(cc.p(0,0))
	greyBg:setPosition(cc.p(0, 0))
	greyBg:drawPolygon(rect, 4, black, 0, black)
	self:addChild(greyBg)

           local rootLayer, csbNode = ExternalFun.loadRootCSB("game_res/csb/Exit.csb",self)
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


function ExitLayer:initButtonAndView()

    local allScore  = self._rootNode:getChildByName("AtlasLabel_1")
    allScore:setString(""..self._scene.gameData.playScore*self._scene.gameData.exchange)

    local benjuScore  = self._rootNode:getChildByName("AtlasLabel_2")
    benjuScore:setString(""..self._scene.gameData.showWinScore*self._scene.gameData.exchange)
    

    local save  = self._rootNode:getChildByName("Button_1")
        save:addTouchEventListener(function(sender,eventType)

                    if eventType == ccui.TouchEventType.ended then
                        local dataBuffer = CCmd_Data:create(4)
                        dataBuffer:pushint(1)
                        self._scene._scene:SendData(g_var(cmd).SUB_C_EXIT,dataBuffer)

                        self._scene._scene:showPopWait()
                        self:runAction(cc.Sequence:create(cc.DelayTime:create(0.2),cc.CallFunc:create(function ()
                            self._scene._scene:onExitTable(1)
                    
                        end)))
                    end
        end)

    local cancel  = self._rootNode:getChildByName("Button_2")
        cancel:addTouchEventListener(function(sender,eventType)

                    if eventType == ccui.TouchEventType.ended then
                            local dataBuffer = CCmd_Data:create(4)
                            dataBuffer:pushint(0)
                            self._scene._scene:SendData(g_var(cmd).SUB_C_EXIT,dataBuffer)
                            
                            self._scene._scene:showPopWait()
                            self:runAction(cc.Sequence:create(cc.DelayTime:create(0.2),cc.CallFunc:create(function ()
                                self._scene._scene:onExitTable(0)
                    
                        end)))
                    end


                
        end)

    local close  = self._rootNode:getChildByName("Button_3")
        close:addTouchEventListener(function(sender,eventType)

            self:removeFromParent()
                
        end)


end




return ExitLayer

