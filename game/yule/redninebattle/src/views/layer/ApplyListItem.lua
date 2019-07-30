--
-- Author: zhong
-- Date: 2016-07-07 18:55:48
--
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local ClipText = appdf.req(appdf.EXTERNAL_SRC .. "ClipText")
local PopupInfoHead = appdf.req(appdf.EXTERNAL_SRC .. "PopupInfoHead")

local ApplyListItem = class("ApplyListItem", cc.Node)

function ApplyListItem:ctor()
	--加载csb资源
	local csbNode = ExternalFun.loadCSB("ApplyListItem.csb", self)
	self.m_csbNode = csbNode

	--昵称
	tmp = csbNode:getChildByName("text_name")
	local clipText = ClipText:createClipText(tmp:getContentSize(), "")
	clipText:setTextFontSize(17)
	clipText:setAnchorPoint(tmp:getAnchorPoint())
	clipText:setPosition(tmp:getPosition())
	csbNode:addChild(clipText)
	tmp:removeFromParent()
	self.m_clipText = clipText

	--抢庄标志
	local rob = csbNode:getChildByName("sp_rob")
	rob:setVisible(false)
	self.m_spRob = rob

	--游戏币1
	local coin = csbNode:getChildByName("text_coin")
	coin:setString("")
	self.m_textCoin = coin
end

function ApplyListItem.getSize( )
	return 206,31
end

--type == 1表示上庄申请列表
function ApplyListItem:refresh( useritem,var_bRob, yPer, showtype)
	if nil == useritem then
		return
	end

	--更新昵称
	local szNick = ""
	if nil ~= useritem.dwGameID then
		szNick = useritem.dwGameID
	end
	self.m_clipText:setString("ID "..szNick)
	--[[if string.len(szNick) > 8 then
		szNick = string.sub(szNick,1,4) .. "..."
	end--]]
	--更新归属地
	local ipLocation = ""
	ipLocation = useritem.szAdressLocation

	self.m_textCoin:setString(ipLocation)
	
	--更新抢庄标志
	local bRob = var_bRob or false
	self.m_spRob:setVisible(bRob)

	--更新游戏币
	--[[local coin = 0
	if nil ~= useritem.lScore then
		coin = useritem.lScore
	end
	local str = ExternalFun.formatScoreText(coin)
	self.m_textCoin:setString(str)--]]
end

return ApplyListItem