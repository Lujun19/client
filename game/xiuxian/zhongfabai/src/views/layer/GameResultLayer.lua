--
-- Author: zhong
-- Date: 2016-07-04 19:06:23
--
--游戏结果层
local GameResultLayer = class("GameResultLayer", cc.Layer)
local ExternalFun = require(appdf.EXTERNAL_SRC .. "ExternalFun")
local g_var = ExternalFun.req_var
local module_pre = "game.xiuxian.zhongfabai.src"
local cmd = module_pre .. ".models.CMD_Game"
local PopupInfoHead = appdf.EXTERNAL_SRC .. "PopupInfoHead"

function GameResultLayer:ctor( )
	--加载csb资源
	local csbNode = ExternalFun.loadCSB("gameResult/GameResultLayer_zfb.csb",self)
	--local csbBg = csbNode:getChildByName("bg")
	
	self.m_panel = csbNode:getChildByName("Panel_1")
	--大赢家信息
	self.m_winnerInfo = csbNode:getChildByName("Node_playerInfo")
	self.m_winnerInfo:setVisible(false)
	--玩家昵称
	self.m_winnerNick = self.m_winnerInfo:getChildByName("player_name")
	self.m_winnerNick:setString("")
	--玩家分数
	self.m_winnerScore = self.m_winnerInfo:getChildByName("player_score")
	self.m_winnerScore:setString("")
	--动画
	self.m_winnerAni = ExternalFun.loadTimeLine("gameResult/GameResultLayer_zfb.csb")
	csbNode:runAction(self.m_winnerAni)
		
	self:hideGameResult()
end

function GameResultLayer:hideGameResult( )
	self:reSet()
	self:setVisible(false)
end

function GameResultLayer:showGameResult( useritem, winscore )
	self:reSet()
	self:setVisible(true)
	
	self.m_winnerInfo:setVisible(true)
	self.m_panel:setVisible(true)
	--玩家头像
	local tmp = self.m_winnerInfo:getChildByName("player_head")
	--local head = g_var(PopupInfoHead):createNormalCircle(useritem, tmp:getContentSize().width)
	--local head = g_var(PopupInfoHead):createNormalCircle(useritem, 90,("Circleframe.png"))
	local head = g_var(PopupInfoHead):createNormal(useritem, 90)
	head:setPosition(tmp:getPositionX(),tmp:getPositionY())
	self.m_winnerInfo:addChild(head)
	head:enableInfoPop(true)
	
	self.m_winnerNick:setString(useritem.dwGameID)
	
	local str = ""
	str = string.format("%.2f",winscore)
	if winscore>0 then
		str = "+"..str
	end
	self.m_winnerScore:setString(str)
	--播放动画
	self.m_winnerAni:play("resultAnimate",false)
	ExternalFun.playSoundEffect("dragon_winner_list.mp3")
	local call = cc.CallFunc:create(function()
		head:setVisible(false)
		self.m_panel:setVisible(false)
	end)
	head:runAction(cc.Sequence:create(cc.DelayTime:create(3.0), call))
	
end

function GameResultLayer:reSet( )
	
	self.m_winnerNick:setString("")
	self.m_winnerScore:setString("")
end
return GameResultLayer