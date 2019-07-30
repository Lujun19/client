--
-- Author: zhouweixiang
-- Date: 2017-05-19 10:49:15
--
local CardButton = class("CardButton", ccui.Button)
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
--纹理宽高
local CARD_WIDTH = 89
local CARD_HEIGHT = 117

function CardButton:getCardData()
  return self.m_cardData
end

function CardButton:ctor(cbCardData, tagParam)
  tagParam = tagParam or {}
  self.m_nCardWidth = tagParam._width or CARD_WIDTH
  self.m_nCardHeight = tagParam._height or CARD_HEIGHT
  self.m_strCardFile = tagParam._file or "game_res/card_b.png"

	self.m_cardData = cbCardData or 0xffff
  self.m_cardValue = yl.POKER_VALUE[cbCardData] or 0
  self.m_cardColor = yl.CARD_COLOR[cbCardData]  or 0

  self:setScale9Enabled(true)
  self:setContentSize(self.m_nCardWidth, self.m_nCardHeight)
  self.m_sprite = nil
  self:createSprite()
end

--设置卡牌数值
function CardButton:setCardValue( cbCardData)
  self.m_cardData = cbCardData or 0xffff
  self.m_cardValue = yl.POKER_VALUE[cbCardData] or 0
  self.m_cardColor = yl.CARD_COLOR[cbCardData] or 0
end

--创建显示图片
function CardButton:createSprite()
	local rect = cc.rect((self.m_cardValue-1)*CARD_WIDTH, self.m_cardColor*CARD_HEIGHT, CARD_WIDTH, CARD_HEIGHT)
	local _sprite = cc.Sprite:create(self.m_strCardFile, rect)
	_sprite:setPosition(self.m_nCardWidth/2, self.m_nCardHeight/2)
	self:addChild(_sprite)
	self.m_sprite = _sprite	
end

return CardButton