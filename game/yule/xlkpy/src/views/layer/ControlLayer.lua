
--控制层

local ExternalFun = require(appdf.EXTERNAL_SRC .. "ExternalFun")
local module_pre = "game.yule.xlkpy.src";
local g_var = ExternalFun.req_var
local Game_CMD = appdf.req(module_pre .. ".models.CMD_LKPYGame")


local ControlLayer = class("ControlLayer", cc.Layer)

ControlLayer.BT_RUN = 21  --send update config data to server
ControlLayer.BT_EXIT = 22
ControlLayer.BT_SYN = 23
--构造
function ControlLayer:ctor( viewParent )
		--用户列
	self.m_parent = viewParent
	--加载csb资源
	local csbNode = ExternalFun.loadCSB("game_res/ControlLayer.csb", self)
	
	--按钮列表
	local function btnEvent( sender, eventType )
		if eventType == ccui.TouchEventType.ended then
			self:onButtonClickedEvent(sender:getTag(), sender);
		end
	end
 
	--control data
    self.total_return_rate = 0;
	self.revenue_score = 0; 
    self.stock_score0 = 0;
	self.stock_score1 = 0; 
	self.total_probability = 0; 
	self.easy = 0;
	self.hard = 0;

	--当前执行标识
	--self.controling = {}
	--local str = ""
	--for i=1,9 do
	--	str = string.format("controling_%d",i)
	--	self.controling[i] = btn_controlArea:getChildByName(str);
	--	self.controling[i]:setVisible(false);
	--end
	 

	--底部按钮
	local bottomNode = csbNode:getChildByName("Image_bottom")
 
	
 
	--退出
	btn = csbNode:getChildByName("Button_close")
	btn:setTag(ControlLayer.BT_EXIT);
	btn:addTouchEventListener(btnEvent);
 
	--执行
	btn = csbNode:getChildByName("Button_execute")
	btn:setTag(ControlLayer.BT_RUN);
	btn:addTouchEventListener(btnEvent);

    	--执行
	btn = csbNode:getChildByName("Button_getcontrol")
	btn:setTag(ControlLayer.BT_SYN);
	btn:addTouchEventListener(btnEvent);
 
	self.edit_total_return_rate = csbNode:getChildByName("total_return_rate")
 	
	--玩家ID输入 
	self.edit_total_return_rate:setMaxLength(32)  
	 
		 
    self.edit_revenue_score = csbNode:getChildByName("revenue_score")
 	
	--玩家ID输入 
	self.edit_revenue_score:setMaxLength(32)  
 

    self.edit_zhengtigailv = csbNode:getChildByName("zhengtigailv")
 	
	--玩家ID输入 
	self.edit_zhengtigailv:setMaxLength(32)  

    self.edit_stock_score0 = csbNode:getChildByName("stock_score0")
 	
	--kucun 0 
	self.edit_stock_score0:setMaxLength(32)  
 

    self.edit_stock_score1 = csbNode:getChildByName("stock_score1")
 
	self.edit_stock_score1:setMaxLength(32)  
 
    self.edit_hard = csbNode:getChildByName("hard")
 
	self.edit_hard:setMaxLength(32)  
 

    self.edit_easy = csbNode:getChildByName("easy")
 
	self.edit_easy:setMaxLength(32)  
 

end
function ControlLayer:onButtonClickedEvent( tag, sender )
	ExternalFun.playClickEffect()
	if ControlLayer.BT_EXIT == tag then
		self:setVisible(false) 
	elseif ControlLayer.BT_RUN == tag then
		self:runControl()
    elseif ControlLayer.BT_SYN == tag then
		self:synFromServer()
	end
end
 
--执行命令
function ControlLayer:runControl() 
    self.total_return_rate = tonumber(self.edit_total_return_rate:getString())
	self.revenue_score = tonumber(self.edit_revenue_score:getString())
    self.stock_score0 = tonumber(self.edit_stock_score0:getString())
	self.stock_score1 = tonumber(self.edit_stock_score1:getString()) 
	self.total_probability = tonumber(self.edit_zhengtigailv:getString())
	self.easy = tonumber(self.edit_easy:getString())
	self.hard = tonumber(self.edit_hard:getString())
	--发送消息
	 
    local cmddata = CCmd_Data:create(56)
    cmddata:setcmdinfo(yl.MDM_GF_GAME, Game_CMD.SUB_C_ControlCfg ); 
	cmddata:pushdouble(self.total_return_rate)
     cmddata:pushdouble(self.revenue_score)
     cmddata:pushdouble(self.total_probability)
     cmddata:pushdouble(self.stock_score0)
     cmddata:pushdouble(self.stock_score1)
     cmddata:pushdouble(self.hard)
     cmddata:pushdouble(self.easy)
     
 

    -- 发送失败
    if not  self.m_parent._scene:sendNetData(cmddata) then
        self.m_parent._scene._gameFrame._callBack(-1, "发送消息失败")
    end
	
	
end

--执行命令
function ControlLayer:synFromServer()
	 
 
    local cmddata = CCmd_Data:create(0)
    cmddata:setcmdinfo(yl.MDM_GF_GAME, Game_CMD.SUB_C_GetSControl); 
    -- 发送失败
    if not self.m_parent._scene:sendNetData(cmddata) then
        self.m_parent._scene._gameFrame._callBack(-1, "发送消息失败")
    end
	
	
end
 
function ControlLayer:UpdateEdit()
    self.edit_total_return_rate:setText(string.format("%0.2f", self.total_return_rate))
	self.edit_revenue_score:setText(string.format("%0.2f", self.revenue_score)) 
    self.edit_stock_score0:setText(string.format("%0.2f", self.stock_score0))
	self.edit_stock_score1:setText(string.format("%0.2f", self.stock_score1))
	self.edit_zhengtigailv:setText(string.format("%0.2f", self.total_probability))
	self.edit_hard:setText(string.format("%0.2f", self.hard))
    self.edit_easy:setText(string.format("%0.2f", self.easy))
end

return ControlLayer