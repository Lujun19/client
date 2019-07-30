
--
-- Author: garry
-- Date: 2017-2-23
--
local DuobaoLayer = class("DuobaoLayer", function (scene)
    local layer = display.newLayer()
	return layer
end)


local module_pre = "game.yule.duobao.src"
local ExternalFun = require(appdf.EXTERNAL_SRC .. "ExternalFun")
local g_var = ExternalFun.req_var

local cmd = module_pre .. ".models.cmd_game"



function DuobaoLayer:ctor(scene)
	release_print("DuobaoLayer...")
           self._scene = scene
           self.index = 0
	local winSize = cc.Director:getInstance():getWinSize()

	local black = cc.c4b(0,0,0,0.5)
	local rect={cc.p(0,0),cc.p(winSize.width,0),cc.p(winSize.width,winSize.height),cc.p(0,winSize.height)}
	local greyBg=cc.DrawNode:create()
	greyBg:setAnchorPoint(cc.p(0,0))
	greyBg:setPosition(cc.p(0, 0))
	greyBg:drawPolygon(rect, 4, black, 0, black)
	self:addChild(greyBg)

           local rootLayer, csbNode = ExternalFun.loadRootCSB("game_res/csb/Duobao.csb",self)
           self._rootNode = csbNode 
           local duobaoBtn = self._rootNode:getChildByName("Button_1")
            duobaoBtn:addTouchEventListener(function( ref, tType)
                    if tType == ccui.TouchEventType.ended then
                        --self.index = math.random(5)
                        --print("qiu=========================,"..self.index)
                        duobaoBtn:setVisible(false)
                        duobaoBtn:setEnabled(false)
                        self:drop()
                        AudioEngine.playEffect("sound_res/INDINAN_AWARD.wav")
                        
                    end

                end)

            self.qiu = self:addQiu()
            self.qiu:setPosition(672,705)
            self:addChild(self.qiu, 10, 10)
    
 	    --设置触摸吞噬
    local dispatcher = self:getEventDispatcher()
    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)
    listener:registerScriptHandler(function ( touches, event )
    	return true
    	end, cc.Handler.EVENT_TOUCH_BEGAN)

    dispatcher:addEventListenerWithSceneGraphPriority(listener, self)

end


function DuobaoLayer:initData(scoreTable,index)


    self.index = index+1

    --print("8888888888888888888,"..index)
    for i=1,5 do
        local scoreTxt = self._rootNode:getChildByName("socre"..i)
          scoreTxt:setString(""..scoreTable[i]*self._scene._gameView.gameData.exchange)
    end


 end 

function DuobaoLayer:drop()

    local luxian ={
    --1
    {
        {1,1,1,1}
    },
    --2
    {
        {1,1,1,-1},
        {-1,1,1,1},
        {1,-1,1,1},
        {1,1,-1,1}
    },
    --3
    {
        {1,-1,1,-1},
        {1,1,-1,-1},
        {-1,-1,1,1},
        {-1,1,-1,1}
    },
    --4
    {
        {-1,-1,-1,1},
        {1,-1,-1,-1},
        {-1,1,-1,-1},
        {-1,-1,1,-1}

    },
    --5
    {
        {-1,-1,-1,-1}
    }

}
    

    self.xianluTable = {}
    if self.index == 1 or self.index==5 then
        self.xianluTable = luxian[self.index][1]
    else
        local xianlu = math.random(4)
        self.xianluTable = luxian[self.index][xianlu]
    end


    self.qiu:runAction(cc.Sequence:create(cc.MoveBy:create(0.1,cc.p(0,-38)),cc.CallFunc:create(function ()
                self.num = 1
                self:action()

        end)))

end

function DuobaoLayer:action()
    local bezier1 = {
        cc.p(0, 0),
        cc.p(-66, 0),
        cc.p(-66, -105),
    }

    local bezier2 = {
        cc.p(0, 0),
        cc.p(66, 0),
        cc.p(66, -105),
    }

    local bezier3 = {
        cc.p(0, 0),
        cc.p(-62, 0),
        cc.p(-62, -200),
    }

    local bezier4 = {
        cc.p(0, 0),
        cc.p(62, 0),
        cc.p(62, -200),
    } 

    local bezier1= cc.BezierBy:create(0.3, bezier1)
    local bezier2= cc.BezierBy:create(0.3, bezier2)
    local bezier3= cc.BezierBy:create(0.3, bezier3)
    local bezier4= cc.BezierBy:create(0.3, bezier4)

    local move1 =cc.MoveBy:create(0.1,cc.p(-37,0))
    local move2 =cc.MoveBy:create(0.1,cc.p(37,0))


        if self.xianluTable[self.num] == 1 then
            local bAction = (self.num == 4) and bezier3 or bezier1
            self.qiu:runAction(cc.Sequence:create(move1,bAction,cc.CallFunc:create(function ()
                self.num = self.num + 1
                if self.num >4 then
                     
                     self.qiu:removeFromParent()
                     self:runAction(cc.Sequence:create(cc.DelayTime:create(0.5),cc.CallFunc:create(function ()
                
                                --self:removeFromParent()
                                self:exitLayer()

                            end)))
                else
                    self:action()
                end

            end)))
        else
            local bAction = (self.num == 4) and bezier4 or bezier2

            self.qiu:runAction(cc.Sequence:create(move2,bAction,cc.CallFunc:create(function ()
                self.num = self.num + 1
                if self.num >4 then
                   
                   self.qiu:removeFromParent()
                    self:runAction(cc.Sequence:create(cc.DelayTime:create(0.5),cc.CallFunc:create(function ()
                
                                --self:removeFromParent()
                                self:exitLayer()


                            end)))
                   

                else
                    self:action()
                end

            end)))
        end
    
end

function DuobaoLayer:exitLayer()
            local dataBuffer = CCmd_Data:create()
                     --dataBuffer:pushint()
                    self._scene:SendData(g_var(cmd).SUB_C_INDIANA,dataBuffer)
                    self:stopAllActions()
                    self:removeFromParent()
end


function DuobaoLayer:addQiu()

    local frames = {}

    for i=1,29 do
      local frame = cc.SpriteFrame:create("game_res/im_ball.png",cc.rect(32*((i-1)%6),(32*math.floor((i-1)/6)),32,32))
      table.insert(frames, frame)
    end

    local  animation =cc.Animation:createWithSpriteFrames(frames,0.03)

    local sprite = cc.Sprite:createWithSpriteFrame(cc.SpriteFrame:create("game_res/im_ball.png",cc.rect(0,0,32,32)))
    sprite:setScale(1.2)

    local action = cc.RepeatForever:create(cc.Animate:create(animation))
    sprite:runAction(action)
   

    return sprite
end



return DuobaoLayer

