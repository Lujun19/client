--
-- Author: garry
-- Date: 2017-2-23
--
local SetLayer = class("SetLayer", function (scene)
    local layer = display.newLayer()
	return layer
end)
local ExternalFun = require(appdf.EXTERNAL_SRC .. "ExternalFun")


function SetLayer:ctor(str )
	release_print("SetLayer...")
           self._ver = str 
           self._pageNum = 1
	local winSize = cc.Director:getInstance():getWinSize()

	local black = cc.c4b(0,0,0,0.5)
	local rect={cc.p(0,0),cc.p(winSize.width,0),cc.p(winSize.width,winSize.height),cc.p(0,winSize.height)}
	local greyBg=cc.DrawNode:create()
	greyBg:setAnchorPoint(cc.p(0,0))
	greyBg:setPosition(cc.p(0, 0))
	greyBg:drawPolygon(rect, 4, black, 0, black)
	self:addChild(greyBg)

           local rootLayer, csbNode = ExternalFun.loadRootCSB("game_res/csb/Set.csb",self)
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


function SetLayer:initButtonAndView()

    local version  = self._rootNode:getChildByName("Text_6")
    version:setString(self._ver)

    self.checkBox  = self._rootNode:getChildByName("CheckBox_1")
    self.checkBox:addEventListener(function(sender,eventType)

                if eventType == ccui.CheckBoxEventType.selected then
                        GlobalUserItem.setSoundAble(false)
                        GlobalUserItem.setVoiceAble(false)
                elseif eventType == ccui.CheckBoxEventType.unselected then
                        GlobalUserItem.setSoundAble(true)
                        GlobalUserItem.setVoiceAble(true)
                        AudioEngine.playMusic("sound_res/BACK_MUSIC.mp3", true)
                        
                end
                AudioEngine.playEffect("sound_res/BUTTON_SOUND.wav")
                self:updateMusic()
        end)


    self.effectBtn = self._rootNode:getChildByName("Button_2")

            self.effectBtn:addTouchEventListener(function( ref, tType)
                    if tType == ccui.TouchEventType.ended then
                         AudioEngine.playEffect("sound_res/BUTTON_SOUND.wav")
                         local effect = not GlobalUserItem.bSoundAble
                         GlobalUserItem.setSoundAble(effect)
                         if effect then
                            print("9999999999999")
                         else
                            print("88888888888888")
                         end
                         self:updateMusic()
                    end

                end)

    self.musicBtn = self._rootNode:getChildByName("Button_1")

            self.musicBtn:addTouchEventListener(function( ref, tType)
                    if tType == ccui.TouchEventType.ended then
                        AudioEngine.playEffect("sound_res/BUTTON_SOUND.wav")
                        local music = not GlobalUserItem.bVoiceAble

                        GlobalUserItem.setVoiceAble(music)
                        if GlobalUserItem.bVoiceAble then
                            AudioEngine.playMusic("sound_res/BACK_MUSIC.mp3", true)
                        end
                         self:updateMusic()

                    end

                end)


    local closeBtn = self._rootNode:getChildByName("Button_3")
            closeBtn:addTouchEventListener(function( ref, tType)
                    if tType == ccui.TouchEventType.ended then
                        AudioEngine.playEffect("sound_res/BUTTON_SOUND.wav")
                       self:removeFromParent()
                    end

                end)

        self:updateMusic()

end


function SetLayer:updateMusic()

       local btnBg1 = self._rootNode:getChildByName("Sprite_6")

       local btnBg2 = self._rootNode:getChildByName("Sprite_7")

        if GlobalUserItem.bSoundAble then
                self.effectBtn:setPosition(840.5,506.5)
                btnBg1:setTexture(cc.Director:getInstance():getTextureCache():addImage("game_res/setOn.png"))
        else
                self.effectBtn:setPosition(730,506.5)
                btnBg1:setTexture(cc.Director:getInstance():getTextureCache():addImage("game_res/setOff.png"))
        end

        if GlobalUserItem.bVoiceAble then
                self.musicBtn:setPosition(840.5,400)
                btnBg2:setTexture(cc.Director:getInstance():getTextureCache():addImage("game_res/setOn.png"))

        else
                self.musicBtn:setPosition(730,400)
                btnBg2:setTexture(cc.Director:getInstance():getTextureCache():addImage("game_res/setOff.png"))
        end

        if not GlobalUserItem.bVoiceAble and not GlobalUserItem.bSoundAble then
            self.checkBox:setSelected(true)
         else
            self.checkBox:setSelected(false)
         end
end

return SetLayer

