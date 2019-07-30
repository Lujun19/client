local module_pre = "game.yule.animalbattle.src"
local ExternalFun =  appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")

local SettingLayer = appdf.req(module_pre .. ".views.layer.SettingLayer")
local BankLayer=appdf.req(module_pre .. ".views.layer.BankLayer")

local PlayerlistLayer=appdf.req(module_pre .. ".views.layer.PlayerlistLayer")

local MenuLayer=class("MenuLayer",cc.Layer)
local popZorder=10
function MenuLayer:ctor(scene,menuX,menuY)
	
	introBtn=ccui.Button:create("introbtn.png","introbtndown.png")
	setBtn=ccui.Button:create("setbtn.png","setbtndown.png")
	bankBtn=ccui.Button:create("bankbtn.png","bankbtndown.png")
	playerBtn=ccui.Button:create("playerbtn.png","playerbtndown.png")

	local h=70
	bankBtn:setPosition(menuX,menuY-h)
	playerBtn:setPosition(menuX,menuY-2*h)
	introBtn:setPosition(menuX,menuY-3*h)
	setBtn:setPosition(menuX,menuY-4*h)

	introBtn:addClickEventListener(function() self:removeSelf()  scene._scene._scene:popHelpLayer2(123,0) end)
	setBtn:addClickEventListener(function()  self:removeSelf() scene:addChild(SettingLayer:create(scene),popZorder)  end)
	playerBtn:addClickEventListener(function() self:removeSelf() scene:addChild(PlayerlistLayer:create(scene:getPlayerList()),popZorder) end )

	bankBtn:addClickEventListener(function() 
	self:removeSelf() 
	if 0 == GlobalUserItem.cbInsureEnabled then
   	 	showToast(scene, "初次使用，请先开通银行！", 1)
    	return 
	end
	scene._bankLayer=BankLayer:create(scene) 
	scene:addChild(scene._bankLayer,popZorder) 
	end )

	self:addChild(playerBtn)
	self:addChild(bankBtn)
	self:addChild(introBtn)
	self:addChild(setBtn)

	ExternalFun.registerTouchEvent(self,true)
	print("bankBtn:setPosition: ",bankBtn:getPosition())
	print("setBtn:setPosition: ",setBtn:getPosition())
end

function MenuLayer:onTouchBegan()
	return true
end

function MenuLayer:onTouchEnded()
	self:removeFromParent()
end

	


return MenuLayer

