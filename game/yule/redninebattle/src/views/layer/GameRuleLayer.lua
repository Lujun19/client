--
--2018.3.13 add-by MXM
--
--游戏规则界面
--local module_pre = "game.yule.redninebattle.src";
local ExternalFun =  appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")

--local PopupInfoLayer = require(appdf.EXTERNAL_SRC .. "PopupInfoLayer")

--local g_var = ExternalFun.req_var;
--local cmd = require(module_pre .. ".models.CMD_Game")

--local GameRuleLayer = class("GameRuleLayer", PopupLayer)
local GameRuleLayer = class("GameRuleLayer", cc.Layer)

GameRuleLayer.BT_CLOSE = 1

--复选框
local CBT_DUIPCOMPARE = 201
local CBT_DUIPEXPLAIN = 202
local CBT_DANPCOMPARE = 203
local CBT_DANPDUIYING = 204
local CBT_CARDSET 	  = 205

--设置复选框
local CBT_SELGUPAI = 301
local CBT_SELPOKER = 302

function GameRuleLayer:ctor(viewParent)

	self.m_parent = viewParent

	--加载csb资源
	local csbNode = ExternalFun.loadCSB("GameRuleLayer.csb", self)
	
	
	local function btnEvent( sender, eventType )
		if eventType == ccui.TouchEventType.ended then
			self:onButtonClickedEvent(sender:getTag(), sender);
		end
	end	
	
	--背景图片
	self.m_spBg = csbNode:getChildByName("rule_bg")
	
	self.m_ListView1 = self.m_spBg:getChildByName("ListView_1")
	self.m_ListView1:setScrollBarEnabled(false)
	self.m_ListView1:setVisible(true)
	
	self.m_ListView2 = self.m_spBg:getChildByName("ListView_2")
	self.m_ListView2:setScrollBarEnabled(false)
	self.m_ListView2:setVisible(false)
	
	self.m_ListView3 = self.m_spBg:getChildByName("ListView_3")
	self.m_ListView3:setScrollBarEnabled(false)
	self.m_ListView3:setVisible(false)
	
	self.m_ListView4 = self.m_spBg:getChildByName("ListView_4")
	self.m_ListView4:setScrollBarEnabled(false)
	self.m_ListView4:setVisible(false)
	
	--牌种显示
	self.m_CardSetPanel = self.m_spBg:getChildByName("Card_SetPanel")
	self.m_CardSetPanel:setVisible(false)
	
	--关闭按钮
	local  btn = self.m_spBg:getChildByName("closeBtn")
	btn:setTag(GameRuleLayer.BT_CLOSE);
	btn:addTouchEventListener(btnEvent);
	
	local function checkEvent( sender,eventType )
		self:onCheckBoxClickEvent(sender, eventType);
	end
	--对牌大小
	self.m_checkDuipcompare = self.m_spBg:getChildByName("CheckBox_Duipcompare")
	self.m_checkDuipcompare:setTag(CBT_DUIPCOMPARE)
	self.m_checkDuipcompare:addEventListener(checkEvent)
	self.m_checkDuipcompare:setSelected(true)
	--对牌说明
	self.m_checkDuipexplain = self.m_spBg:getChildByName("CheckBox_Duipexplain")
	self.m_checkDuipexplain:setTag(CBT_DUIPEXPLAIN)
	self.m_checkDuipexplain:addEventListener(checkEvent)
	self.m_checkDuipexplain:setSelected(false)
	--单牌大小
	self.m_checkDanpcompare = self.m_spBg:getChildByName("CheckBox_Danpcompare")
	self.m_checkDanpcompare:setTag(CBT_DANPCOMPARE)
	self.m_checkDanpcompare:addEventListener(checkEvent)
	self.m_checkDanpcompare:setSelected(false)
	--单牌对应
	self.m_checkDanpduiying = self.m_spBg:getChildByName("CheckBox_Danpduiying")
	self.m_checkDanpduiying:setTag(CBT_DANPDUIYING)
	self.m_checkDanpduiying:addEventListener(checkEvent)
	self.m_checkDanpduiying:setSelected(false)
	--设置
	self.m_checkCardSet = self.m_spBg:getChildByName("CheckBox_CardSet")
	self.m_checkCardSet:setTag(CBT_CARDSET)
	self.m_checkCardSet:addEventListener(checkEvent)
	self.m_checkCardSet:setSelected(false)
	--当前选择的box
	self.m_nSelectBox = CBT_DUIPCOMPARE
	
	
	--设置-骨牌
	self.m_checkSelGupai = self.m_CardSetPanel:getChildByName("CheckBox_SelGupai")
	self.m_checkSelGupai:setTag(CBT_SELGUPAI)
	self.m_checkSelGupai:addEventListener(checkEvent)
	self.m_checkSelGupai:setSelected(GlobalUserItem.bgupai)
	--设置-扑克
	self.m_checkSelPoker = self.m_CardSetPanel:getChildByName("CheckBox_SelPoker")
	self.m_checkSelPoker:setTag(CBT_SELPOKER)
	self.m_checkSelPoker:addEventListener(checkEvent)
	self.m_checkSelPoker:setSelected(GlobalUserItem.bpai)
	--当前选择的牌种box
	self.m_nSelectPaiBox = CBT_SELGUPAI

end

function GameRuleLayer:onButtonClickedEvent( tag, sender )
	
	if GameRuleLayer.BT_CLOSE == tag then
		self:setVisible(false)
	end
end

function GameRuleLayer:onCheckBoxClickEvent(sender, eventType)
	if nil == sender then
		return
	end

	local tag = sender:getTag()
	if self.m_nSelectBox == tag then
		sender:setSelected(true)
		return
	end
	if self.m_nSelectPaiBox == tag then
		sender:setSelected(true)
		return
	end
	self.m_nSelectBox = tag
	self.m_nSelectPaiBox = tag
	
	--规则说明
	if tag == CBT_DUIPCOMPARE then
		self.m_checkDuipexplain:setSelected(false)
		self.m_checkDanpcompare:setSelected(false)
		self.m_checkDanpduiying:setSelected(false)
		self.m_checkCardSet:setSelected(false)
		
		self.m_ListView1:setVisible(true)
		self.m_ListView2:setVisible(false)
		self.m_ListView3:setVisible(false)
		self.m_ListView4:setVisible(false)
		self.m_CardSetPanel:setVisible(false)
		
	elseif tag == CBT_DUIPEXPLAIN then
		self.m_checkDuipcompare:setSelected(false)
		self.m_checkDanpcompare:setSelected(false)
		self.m_checkDanpduiying:setSelected(false)
		self.m_checkCardSet:setSelected(false)
		
		self.m_ListView1:setVisible(false)
		self.m_ListView2:setVisible(true)
		self.m_ListView3:setVisible(false)
		self.m_ListView4:setVisible(false)
		self.m_CardSetPanel:setVisible(false)
		
	elseif tag == CBT_DANPCOMPARE then
		self.m_checkDuipexplain:setSelected(false)
		self.m_checkDuipcompare:setSelected(false)
		self.m_checkDanpduiying:setSelected(false)
		self.m_checkCardSet:setSelected(false)
		
		self.m_ListView1:setVisible(false)
		self.m_ListView2:setVisible(false)
		self.m_ListView3:setVisible(true)
		self.m_ListView4:setVisible(false)
		self.m_CardSetPanel:setVisible(false)
		
	elseif tag == CBT_DANPDUIYING then
		self.m_checkDuipexplain:setSelected(false)
		self.m_checkDuipcompare:setSelected(false)
		self.m_checkDanpcompare:setSelected(false)
		self.m_checkCardSet:setSelected(false)
		
		self.m_ListView1:setVisible(false)
		self.m_ListView2:setVisible(false)
		self.m_ListView3:setVisible(false)
		self.m_ListView4:setVisible(true)
		self.m_CardSetPanel:setVisible(false)
		
	elseif tag == CBT_CARDSET then
		self.m_checkDuipexplain:setSelected(false)
		self.m_checkDuipcompare:setSelected(false)
		self.m_checkDanpcompare:setSelected(false)
		self.m_checkDanpduiying:setSelected(false)
		
		self.m_ListView1:setVisible(false)
		self.m_ListView2:setVisible(false)
		self.m_ListView3:setVisible(false)
		self.m_ListView4:setVisible(false)
		self.m_CardSetPanel:setVisible(true)
	end
	
	--牌种选择
	if tag == CBT_SELGUPAI then
		self.m_checkSelPoker:setSelected(false)
		self.m_checkSelGupai:setSelected(true)
        GlobalUserItem.bgupai = true
        GlobalUserItem.bpai = false
		cc.UserDefault:getInstance():setBoolForKey("bgupai",GlobalUserItem.bgupai)
        cc.UserDefault:getInstance():setBoolForKey("bpai",GlobalUserItem.bpai)
	elseif tag == CBT_SELPOKER then
		self.m_checkSelGupai:setSelected(true)
		self.m_checkSelGupai:setSelected(false)
        GlobalUserItem.bgupai = false
        GlobalUserItem.bpai = true
        cc.UserDefault:getInstance():setBoolForKey("bgupai",GlobalUserItem.bgupai)
        cc.UserDefault:getInstance():setBoolForKey("bpai",GlobalUserItem.bpai)
	end
end

return GameRuleLayer