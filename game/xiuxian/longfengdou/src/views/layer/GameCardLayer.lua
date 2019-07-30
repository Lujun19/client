--
-- Author: zhong
-- Date: 2016-07-15 11:03:17
--
--游戏扑克层
local GameCardLayer = class("GameCardLayer", cc.Layer)

local module_pre = "game.xiuxian.longfengdou.src"
local ExternalFun = require(appdf.EXTERNAL_SRC .. "ExternalFun")
local g_var = ExternalFun.req_var;
local CardsNode = module_pre .. ".views.layer.gamecard.CardsNode"
local GameLogic = module_pre .. ".models.GameLogic"
local cmd = module_pre .. ".models.CMD_Game"
local bjlDefine = module_pre .. ".models.bjlGameDefine"
local AnimationMgr = appdf.req(appdf.EXTERNAL_SRC .. "AnimationMgr")

local scheduler = cc.Director:getInstance():getScheduler()

local kPointDefault = 0
local kDraw = 1 --平局
local kIdleWin = 2 --闲赢
local kMasterWin = 3 --庄赢
local DIS_SPEED = 0.5
local DELAY_TIME = 1.0
local kLEFT_ROLE = 1
local kRIGHT_ROLE = 2

function GameCardLayer:ctor(parent)
	self.m_parent = parent
	--加载csb资源
	local csbNode = ExternalFun.loadCSB("game/lfdGameCardLayer.csb",self)	
	self.m_actionNode = csbNode
	csbNode:setVisible(false)

	self.m_showCardAni = ExternalFun.loadTimeLine("game/lfdGameCardLayer.csb")
	csbNode:runAction(self.m_showCardAni)

	
	--显示数据的扑克
	self.m_frontCards = {}
	local node1 = csbNode:getChildByName("Node_1")
	self.m_frontCards[1] = node1:getChildByName("cardFaceLeft"):getChildByName("card_left")
	self.m_frontCards[2] = node1:getChildByName("cardFaceRight"):getChildByName("card_right")
	self.m_frontCards[1]:setVisible(false)
	self.m_frontCards[2]:setVisible(false)
end

function GameCardLayer:clean(  )

	self.m_actionNode:stopAllActions()
	self.m_actionNode:setVisible(false)
	
	self.m_frontCards[1]:setVisible(false)
	self.m_frontCards[2]:setVisible(false)

end

function GameCardLayer:showLayer( var )
	self:setVisible(var)
	self.m_actionNode:setVisible(var)
end
function GameCardLayer:showCards( tabRes, bAni, cbTime,cbWinArea )
			
	local str = ""
	local cbCardData1 = tabRes.m_idleCards[1]
	local cbCardData2 = tabRes.m_masterCards[1]
	
	str = string.format("card_%d.png",cbCardData1)
	local frame1 = cc.SpriteFrameCache:getInstance():getSpriteFrame(str)
	if nil ~= frame1 then
		self.m_frontCards[1]:setSpriteFrame(frame1)
	end
	
	str = string.format("card_%d.png",cbCardData2)
	local frame2 = cc.SpriteFrameCache:getInstance():getSpriteFrame(str)
	if nil ~= frame2 then
		self.m_frontCards[2]:setSpriteFrame(frame2)
	end
	
	
	--赢的区域
	local cbBetAreaBlink = {0,0,0}
	cbBetAreaBlink = cbWinArea
	self.m_parent:getDataMgr().m_tabBetArea = cbBetAreaBlink
	
	self.m_frontCards[1]:setVisible(true)
	self.m_frontCards[2]:setVisible(true)
	
	if bAni then	
		--播放动画
		self.m_showCardAni:play("showCardAni",false)
		
		local call1 = cc.CallFunc:create(function()				
				if nil ~= self.m_parent then
					self.m_parent:showBetAreaBlink()
				end
			end)
		self:runAction(cc.Sequence:create(cc.DelayTime:create(2.0),call1))
	else
		if nil ~= self.m_parent then
			self.m_parent:showBetAreaBlink()
		end
	end
		

end
--获取游戏结果
function GameCardLayer:getGameRecord(tabRes,cbWinArea)
	
	--点数
	local idlePoint = g_var(GameLogic).GetCardListPip(tabRes.m_idleCards)
	local masterPoint = g_var(GameLogic).GetCardListPip(tabRes.m_masterCards)

	if nil ~= self.m_parent and false == yl.m_bDynamicJoin then
		--添加记录
		local rec = g_var(bjlDefine).getEmptyRecord()

        local serverrecord = g_var(bjlDefine).getEmptyServerRecord();

        serverrecord.cbPlayerCount = idlePoint
        serverrecord.cbBankerCount = masterPoint
		for i=1, 3 do
			if cbWinArea[i] == 1 then
				serverrecord.cbGameResult = i-1
			end
		end
        rec.m_pServerRecord = serverrecord;
		rec.m_cbGameResult = serverrecord.cbGameResult;

        self.m_parent:getDataMgr():addGameRecord(rec)
	end
	
end


return GameCardLayer