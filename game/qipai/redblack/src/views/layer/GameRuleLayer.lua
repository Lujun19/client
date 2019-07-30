--
--
--游戏规则界面
local module_pre = "game.qipai.redblack.src";
local ExternalFun = require(appdf.EXTERNAL_SRC .. "ExternalFun")
local g_var = ExternalFun.req_var;
local cmd = require(module_pre .. ".models.CMD_Game")

local GameRuleLayer = class("GameRuleLayer", cc.Layer)

GameRuleLayer.BT_CLOSE = 1

function GameRuleLayer:ctor(viewparent)
	--注册事件
	local function onLayoutEvent( event )
		if event == "exit" then
			self:onExit();
        elseif event == "enterTransitionFinish" then
        	self:onEnterTransitionFinish();
        end
	end
	self:registerScriptHandler(onLayoutEvent);

	self.m_parent = viewparent

	--加载csb资源
	local csbNode = ExternalFun.loadCSB("record/Game_rule.csb", self)
	
	local function btnEvent( sender, eventType )
		if eventType == ccui.TouchEventType.ended then
			self:onButtonClickedEvent(sender:getTag(), sender);
		end
	end	
	--关闭按钮
	local  btn = csbNode:getChildByName("Button_close")
	btn:setTag(GameRuleLayer.BT_CLOSE);
	btn:addTouchEventListener(btnEvent);

	--背景图片
	self.m_spBg = csbNode:getChildByName("Image_bg")
		
end

function GameRuleLayer:onEnterTransitionFinish()
	self:registerTouch()
end

function GameRuleLayer:onExit()
	local eventDispatcher = self:getEventDispatcher()
	eventDispatcher:removeEventListener(self.listener)
end
function GameRuleLayer:onButtonClickedEvent( tag, sender )
	
	if GameRuleLayer.BT_CLOSE == tag then
		self:setVisible(false)
	end
end
function GameRuleLayer:registerTouch(  )
	local function onTouchBegan( touch, event )
		return self:isVisible()
	end

	local function onTouchEnded( touch, event )
		local pos = touch:getLocation();
		local m_spBg = self.m_spBg
        pos = m_spBg:convertToNodeSpace(pos)
        local rec = cc.rect(0, 0, m_spBg:getContentSize().width, m_spBg:getContentSize().height)
        if false == cc.rectContainsPoint(rec, pos) then
            self:showLayer(false)
        end        
	end

	local listener = cc.EventListenerTouchOneByOne:create();
	listener:setSwallowTouches(true)
	self.listener = listener;
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN );
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED );
    local eventDispatcher = self:getEventDispatcher();
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self);
end

function GameRuleLayer:showLayer( var )
	self:setVisible(var)
end

return GameRuleLayer