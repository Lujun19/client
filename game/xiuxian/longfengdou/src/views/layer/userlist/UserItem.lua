--
-- Author: zhong
-- Date: 2016-07-07 18:55:48
--
local ExternalFun = require(appdf.EXTERNAL_SRC .. "ExternalFun")
local g_var = ExternalFun.req_var
local ClipText = appdf.EXTERNAL_SRC .. "ClipText"
local PopupInfoHead = appdf.EXTERNAL_SRC .. "PopupInfoHead"

local UserItem = class("UserItem", cc.Node)

function UserItem:ctor()
	--加载csb资源
	local csbNode = ExternalFun.loadCSB("game/UserItem.csb", self)
	self.m_csbNode = csbNode

	--头像
	local tmp = csbNode:getChildByName("sp_head")	
	self.m_headSize = tmp:getContentSize().width
	self.m_headFrame = tmp
	tmp:removeFromParent()
	csbNode:addChild(self.m_headFrame)
	self.m_headFrame:setVisible(false)
	--昵称
--[[	tmp = csbNode:getChildByName("text_name")
	local clipText = g_var(ClipText):createClipText(tmp:getContentSize(), "")
	clipText:setTextFontSize(30)
	clipText:setAnchorPoint(tmp:getAnchorPoint())
	clipText:setPosition(tmp:getPosition())
	csbNode:addChild(clipText)
	tmp:removeFromParent()--]]
	self.m_clipText = csbNode:getChildByName("text_name")
	self.m_clipText:setString("")
	--抢庄标志
--[[	local rob = csbNode:getChildByName("sp_rob")
	rob:setVisible(false)
	self.m_spRob = rob--]]

	--金币1
	local coin = csbNode:getChildByName("text_coin")
	coin:setString("")
	self.m_textCoin = coin
end

function UserItem.getSize(  )
	return 175,50
end

function UserItem:refresh( useritem,var_bRob, yPer)
	if nil == useritem then
		return
	end
	--更新头像
	if nil ~= self.m_head and nil ~= self.m_head:getParent() then
		self.m_head:removeFromParent()
		self.m_head = nil
	end
	--self.m_head = g_var(PopupInfoHead):createNormalCircle(useritem, 40,("Circleframe.png"))
	self.m_head = g_var(PopupInfoHead):createNormal(useritem,30)
	self.m_head:setPosition(cc.p(self.m_headFrame:getPositionX(),self.m_headFrame:getPositionY()))
	self.m_csbNode:addChild(self.m_head)
	self.m_head:setVisible(false)
	--更新昵称
	local szNick = ""
	if nil ~= useritem.dwGameID then
		szNick = useritem.dwGameID
	end
	self.m_clipText:setString("ID  "..szNick)
	--self.m_clipText:setString(useritem.szNickName)
	 --更新归属地
	local ipLocation = ""
	ipLocation = useritem.szAdressLocation

	self.m_textCoin:setString(ipLocation)
	--local str = ExternalFun.formatScoreText(useritem.lScore);
	--self.m_textCoin:setString(str)
	
	--更新抢庄标志
--[[	local bRob = var_bRob or false
	self.m_spRob:setVisible(bRob)--]]

	--更新金币
--[[	local coin = 0
	if nil ~= useritem.lScore then
		coin = useritem.lScore
	end
	local str = ExternalFun.numberThousands(coin)
	if string.len(str) > 11 then
		str = string.sub(str, 1, 7) .. "..."
	end
	self.m_textCoin:setString(str)--]]
end

return UserItem