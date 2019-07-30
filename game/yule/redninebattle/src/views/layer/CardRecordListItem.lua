--
-- Add by MXM
-- Date: 2018-03-21
--开牌记录列表

local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local ClipText = appdf.req(appdf.EXTERNAL_SRC .. "ClipText")
local CardSprite = appdf.req(appdf.GAME_SRC.."yule.redninebattle.src.views.layer.CardSprite")

local CardRecordListItem = class("CardRecordListItem", cc.Node)

function CardRecordListItem:ctor()
	--加载csb资源
	local csbNode = ExternalFun.loadCSB("CardRecordListItem.csb", self)
	self.m_csbNode = csbNode

end

function CardRecordListItem.getSize( )
	return 774,116
end

--type == 1
function CardRecordListItem:refresh( m_cardValue1,m_cardValue2,m_cardValue3,m_cardValue4,m_cardValue5,m_cardValue6,m_cardValue7,m_cardValue8, yPer, showtype)
	if nil == m_cardValue1 then
		return
	end
	
	local m_cardrecord1 = self.m_csbNode:getChildByName("Card_1")
	local m_cardrecord2 = self.m_csbNode:getChildByName("Card_2")
	local m_cardrecord3 = self.m_csbNode:getChildByName("Card_3")
	local m_cardrecord4 = self.m_csbNode:getChildByName("Card_4")
	local m_cardrecord5 = self.m_csbNode:getChildByName("Card_5")
	local m_cardrecord6 = self.m_csbNode:getChildByName("Card_6")
	local m_cardrecord7 = self.m_csbNode:getChildByName("Card_7")
	local m_cardrecord8 = self.m_csbNode:getChildByName("Card_8")
	
	local temp = {}
	temp[1] = CardSprite:createSmallCard(m_cardValue1)
	temp[1]:setVisible(true)
	temp[1]:setAnchorPoint(0, 0)
	m_cardrecord1:addChild(temp[1])
	
	temp[2] = CardSprite:createSmallCard(m_cardValue2)
	temp[2]:setVisible(true)
	temp[2]:setAnchorPoint(0, 0)
	m_cardrecord2:addChild(temp[2])
	
	temp[3] = CardSprite:createSmallCard(m_cardValue3)
	temp[3]:setVisible(true)
	temp[3]:setAnchorPoint(0, 0)
	m_cardrecord3:addChild(temp[3])
	
	temp[4] = CardSprite:createSmallCard(m_cardValue4)
	temp[4]:setVisible(true)
	temp[4]:setAnchorPoint(0, 0)
	m_cardrecord4:addChild(temp[4])
	
	temp[5] = CardSprite:createSmallCard(m_cardValue5)
	temp[5]:setVisible(true)
	temp[5]:setAnchorPoint(0, 0)
	m_cardrecord5:addChild(temp[5])
	
	temp[6] = CardSprite:createSmallCard(m_cardValue6)
	temp[6]:setVisible(true)
	temp[6]:setAnchorPoint(0, 0)
	m_cardrecord6:addChild(temp[6])
	
	temp[7] = CardSprite:createSmallCard(m_cardValue7)
	temp[7]:setVisible(true)
	temp[7]:setAnchorPoint(0, 0)
	m_cardrecord7:addChild(temp[7])
	
	temp[8] = CardSprite:createSmallCard(m_cardValue8)
	temp[8]:setVisible(true)
	temp[8]:setAnchorPoint(0, 0)
	m_cardrecord8:addChild(temp[8])
	
	
	--[[for j=1,8 do
		temp[j] = CardSprite:createCard(tonumber(m_cardRecord.."%d",j))
		temp[j]:setVisible(true)
		temp[j]:setAnchorPoint(0, 0.5)
		temp[j]:setPosition(self.bt_cardrecord1:getPosition()+j*5)
		--self.bt_cardrecord1:addChild(temp1[j])
		self.plant:addChild(temp1[j])
	end--]]
	
end

return CardRecordListItem