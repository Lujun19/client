--
-- Add by MXM
-- Date: 2018-03-20
--
--开牌记录
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local CardRecordListItem = appdf.req(appdf.GAME_SRC.."yule.redninebattle.src.views.layer.CardRecordListItem")

local CardRecordLayer = class("CardRecordLayer", cc.Layer)
CardRecordLayer.BT_CLOSE = 1
CardRecordLayer.BT_APPLY = 2

function CardRecordLayer:ctor( viewParent)
	self.m_parent = viewParent

	--开牌记录列表
	self.m_cardrecordlist = {}

	--加载csb资源
	local csbNode = ExternalFun.loadCSB("OpenCardRecordLayer.csb", self)

	local sp_bg = csbNode:getChildByName("template_bg")
	self.m_spBg = sp_bg
	local content = sp_bg:getChildByName("content")
    self._content = content
	--用户列表
	local m_tableView = cc.TableView:create(content:getContentSize())
	m_tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
	m_tableView:setPosition(content:getPosition())
	m_tableView:setDelegate()
	m_tableView:registerScriptHandler(self.cellSizeForTable, cc.TABLECELL_SIZE_FOR_INDEX)
	m_tableView:registerScriptHandler(handler(self, self.tableCellAtIndex), cc.TABLECELL_SIZE_AT_INDEX)
	m_tableView:registerScriptHandler(handler(self, self.numberOfCellsInTableView), cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
	sp_bg:addChild(m_tableView)
	self.m_tableView = m_tableView;
	content:removeFromParent()
	
	self.item_bg_1 = self.m_spBg:getChildByName("item_bg_1")
	self.text1 = self.m_spBg:getChildByName("Text_7")
	
	self.item_bg_2 = self.m_spBg:getChildByName("item_bg_2")
	self.text2 = self.m_spBg:getChildByName("Text_8")
	
	self.item_bg_3 = self.m_spBg:getChildByName("item_bg_3")
	self.text3 = self.m_spBg:getChildByName("Text_9")
	
	--关闭按钮
	local function btnEvent( sender, eventType )
		if eventType == ccui.TouchEventType.ended then
			self:onButtonClickedEvent(sender:getTag(), sender);
		end
	end

	local bt_close = sp_bg:getChildByName("closeBtn")
	bt_close:setTag(CardRecordLayer.BT_CLOSE)
	bt_close:addTouchEventListener(btnEvent)

	local function applyBtn( sender, eventType )
		if eventType == ccui.TouchEventType.ended then
			self:onApplyClickedEvent(sender:getTag(), sender);
		end
	end

	content:removeFromParent()
end

function CardRecordLayer:showLayer()
	self:setVisible(true)
	--self.m_spBg:setPositionX(1490)
	--self.m_spBg:runAction(cc.MoveTo:create(0.17, cc.p(1182, self.m_spBg:getPositionY())))
end

function CardRecordLayer:removeAllItem()
	self._content:removeFromParent()
end

function CardRecordLayer:refreshCardRecord( vecRecord )
	self:setVisible(true)
	self.item_bg_1:setVisible(true)
	self.text1:setVisible(true)
	self.item_bg_2:setVisible(true)
	self.text2:setVisible(true)
	self.item_bg_3:setVisible(true)
	self.text3:setVisible(true)
	self.m_cardrecordlist = vecRecord
	if nil == vecRecord then
		
		return
	end
	self.m_tableView:reloadData()

end

--tableview
function CardRecordLayer.cellSizeForTable( view, idx )
	--return CardRecordListItem.getSize()
	return 774 , 120
end

function CardRecordLayer:numberOfCellsInTableView( view )
	if nil == self.m_cardrecordlist then
		return 0
	else
		return #self.m_cardrecordlist
	end
end

function CardRecordLayer:tableCellAtIndex( view, idx )
	local cell = view:dequeueCell()
	
	if nil == self.m_cardrecordlist then
		return cell
	end
	if idx == 0 then
		self.item_bg_1:setVisible(false)
		self.text1:setVisible(false)
	end
	if idx == 1 then
		self.item_bg_2:setVisible(false)
		self.text2:setVisible(false)
	end
	if idx == 2 then
		self.item_bg_3:setVisible(false)
		self.text3:setVisible(false)
	end
	
	local m_cardValue1 = self.m_cardrecordlist[idx+1].m_card1
	local m_cardValue2 = self.m_cardrecordlist[idx+1].m_card2
	local m_cardValue3 = self.m_cardrecordlist[idx+1].m_card3
	local m_cardValue4 = self.m_cardrecordlist[idx+1].m_card4
	local m_cardValue5 = self.m_cardrecordlist[idx+1].m_card5
	local m_cardValue6 = self.m_cardrecordlist[idx+1].m_card6
	local m_cardValue7 = self.m_cardrecordlist[idx+1].m_card7
	local m_cardValue8 = self.m_cardrecordlist[idx+1].m_card8
	
	local item = nil

	if nil == cell then
		cell = cc.TableViewCell:new()
		item = CardRecordListItem:create()
		item:setPosition(view:getViewSize().width * 0.5, 43)
		item:setName("card_item_view")
		cell:addChild(item)
	else
		item = cell:getChildByName("card_item_view")
	end

	if nil ~= m_cardValue1 and nil ~= item then
		item:refresh(m_cardValue1,m_cardValue2,m_cardValue3,m_cardValue4,m_cardValue5,m_cardValue6,m_cardValue7,m_cardValue8,0.5, 1)
	end

	return cell
end
--

function CardRecordLayer:onButtonClickedEvent( tag, sender )
	ExternalFun.playClickEffect()
	if CardRecordLayer.BT_CLOSE == tag then
		self:setVisible(false)
	end
end

function CardRecordLayer:clear()
	
end

return CardRecordLayer