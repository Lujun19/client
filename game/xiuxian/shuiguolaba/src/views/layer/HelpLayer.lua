--
-- Author: luo
-- Date: 2016年12月26日 20:24:43
--

local ExternalFun = require(appdf.EXTERNAL_SRC .. "ExternalFun")

local HelpLayer = class("HelpLayer", cc.Layer)
HelpLayer.BT_CLOSE = 1
HelpLayer.CHECKBOX1 = 2
HelpLayer.CHECKBOX2 = 3

function HelpLayer:ctor( )
    --注册触摸事件
--    ExternalFun.registerTouchEvent(self, true)

	self._csbNode = ExternalFun.loadCSB("game1/HelpLayer.csb",self) --cc.CSLoader:createNode("game/poke/land/res/game/GamePlaye.csb")

    local function btnEvent( sender, eventType )
      self:onButtonClickedEvent(sender:getTag(), sender)
    end
    self:setVisible(true)

	local btnClose = self._csbNode:getChildByName("Button_close");
    btnClose:setTag(HelpLayer.BT_CLOSE);
    btnClose:addTouchEventListener(btnEvent);

    self.CheckBox_1 = self._csbNode:getChildByName("CheckBox_3");
    self.CheckBox_1:setTag(HelpLayer.CHECKBOX1);
    self.CheckBox_1:addTouchEventListener(btnEvent);

    self.CheckBox_2 = self._csbNode:getChildByName("CheckBox_4");
    self.CheckBox_2:setTag(HelpLayer.CHECKBOX2);
    self.CheckBox_2:addTouchEventListener(btnEvent);

    self.image1 = self._csbNode:getChildByName("Image_bg");
    self.image1:setVisible(true)
    self.image2 = self._csbNode:getChildByName("Image_bg_0");
    self.image2:setVisible(false)

    self.image3 = self._csbNode:getChildByName("Image_1");
    self.image3:setVisible(false)
    self.image4 = self._csbNode:getChildByName("Image_2");
    self.image4:setVisible(true)

end

function HelpLayer:onButtonClickedEvent(tag,ref)
    if tag == HelpLayer.BT_CLOSE then
        self:setVisible(false)
        ExternalFun.playClickEffect("guanbihelp.wav")
        self:removeFromParent()
    elseif tag == HelpLayer.CHECKBOX1 then
        self.image1:setVisible(true)
        self.image2:setVisible(false)
        self.image3:setVisible(false)
        self.image4:setVisible(true)
    elseif tag == HelpLayer.CHECKBOX2 then
        self.image1:setVisible(false)
        self.image2:setVisible(true)
        self.image3:setVisible(true)
        self.image4:setVisible(false)
    end
 
end



return HelpLayer