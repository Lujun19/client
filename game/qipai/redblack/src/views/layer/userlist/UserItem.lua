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
	self.m_clipText = csbNode:getChildByName("text_name")
	self.m_clipText:setString("")
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
	self.m_head = PopupInfoHead:createNormal(useritem, 60)
	self.m_head:setPosition(cc.p(self.m_headFrame:getPositionX(),self.m_headFrame:getPositionY()))
	self.m_csbNode:addChild(self.m_head)
	--self.m_head:enableInfoPop(true, cc.p(350,220), cc.p(1.0, yPer))

	
	--更新昵称
	local szNick = ""
	if nil ~= useritem.dwGameID then
		szNick = useritem.dwGameID
	end
	self.m_clipText:setString("ID: "..szNick)
	 --更新归属地
	local ipLocation = ""
	ipLocation = useritem.szAdressLocation

	self.m_textCoin:setString(ipLocation)
--[[	--更新金币
	local coin = 0
	if nil ~= useritem.lScore then
		coin = useritem.lScore
	end
	local str = string.format("%.2f",coin)
	self.m_textCoin:setString(str)--]]
end

return UserItem