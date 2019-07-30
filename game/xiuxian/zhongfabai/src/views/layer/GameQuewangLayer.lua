--
--
--游戏记录界面
local module_pre = "game.xiuxian.zhongfabai.src";
local ExternalFun = require(appdf.EXTERNAL_SRC .. "ExternalFun")
local g_var = ExternalFun.req_var;
local cmd = require(module_pre .. ".models.CMD_Game")

local GameQuewangLayer = class("GameQuewangLayer", cc.Layer)

GameQuewangLayer.BT_CLOSE = 1
GameQuewangLayer.BT_HELP = 2
GameQuewangLayer.BT_TODAYRANK = 3
GameQuewangLayer.BT_YESTERDAYRANK = 4
GameQuewangLayer.BT_GETKINGREWARD = 5

function GameQuewangLayer:ctor(viewparent)
	--注册事件
	local function onLayoutEvent( event )
		if event == "exit" then
			self:onExit();
        elseif event == "enterTransitionFinish" then
        	self:onEnterTransitionFinish();
        end
	end
	self:registerScriptHandler(onLayoutEvent);

	self.m_parent = viewparent


	--加载csb资源
	local csbNode = ExternalFun.loadCSB("quewang/Game_quewan.csb", self)
	local Node1 = csbNode:getChildByName("Image_bg")

	--统计数据
	--彩金
	self.m_kingReward = Node1:getChildByName("king_reward_font")
	--今日押注总额
	self.m_todayBet = Node1:getChildByName("Text_todayBet")
	--今日押注排行
	self.m_todayBetRank = Node1:getChildByName("Text_todayBetRank")
	--昨日押注排行
	self.m_yesterdayBetRank = Node1:getChildByName("Text_yesterdayBetRank")
	--昨日彩金奖励
	self.m_yesterdayReward = Node1:getChildByName("Text_yesterdayReward")
	
	self.m_kingReward:setString("")
	self.m_todayBet:setString("今日押注总额：")
	self.m_todayBetRank:setString("今日押注排行：")
	self.m_yesterdayBetRank:setString("昨日押注排行：")
	self.m_yesterdayReward:setString("昨日彩金奖励：")
	
	local function btnEvent( sender, eventType )
		if eventType == ccui.TouchEventType.ended then
			self:onButtonClickedEvent(sender:getTag(), sender);
		end
	end	
	--关闭按钮
	local  btn = Node1:getChildByName("Button_close")
	btn:setTag(GameQuewangLayer.BT_CLOSE);
	btn:addTouchEventListener(btnEvent);
	--帮助按钮
	btn = Node1:getChildByName("Button_help")
	btn:setTag(GameQuewangLayer.BT_HELP);
	btn:addTouchEventListener(btnEvent);
	--今日排行
	self.m_btTodayRank = Node1:getChildByName("Button_todayRank")
	self.m_btTodayRank:setTag(GameQuewangLayer.BT_TODAYRANK);
	self.m_btTodayRank:addTouchEventListener(btnEvent);
	--昨日排行
	self.m_btYesterDayRank = Node1:getChildByName("Button_yesterdayRank")
	self.m_btYesterDayRank:setTag(GameQuewangLayer.BT_YESTERDAYRANK);
	self.m_btYesterDayRank:addTouchEventListener(btnEvent);
	--领取奖励
	self.m_btGetKingReward = Node1:getChildByName("Button_king_get")
	self.m_btGetKingReward:setTag(GameQuewangLayer.BT_GETKINGREWARD);
	self.m_btGetKingReward:addTouchEventListener(btnEvent);
	--排行列表
	self.m_rankListView = Node1:getChildByName("ListView")
	self.m_rankItem = csbNode:getChildByName("Listitem")
	--背景图片
	self.m_spBg = csbNode:getChildByName("Image_bg")
	--帮助界面
	self.m_helpBg = csbNode:getChildByName("Image_helpBg")
	self.m_helpBg:setVisible(false)
	
end

function GameQuewangLayer:onEnterTransitionFinish()
	self:registerTouch()
end

function GameQuewangLayer:onExit()
	local eventDispatcher = self:getEventDispatcher()
	eventDispatcher:removeEventListener(self.listener)
end
function GameQuewangLayer:onButtonClickedEvent( tag, sender )
	
	if GameQuewangLayer.BT_CLOSE == tag then
		self:setVisible(false)
	elseif GameQuewangLayer.BT_HELP == tag then
		self.m_helpBg:setVisible(true)
	elseif GameQuewangLayer.BT_TODAYRANK == tag then
		self:showTodayRank()
	elseif GameQuewangLayer.BT_YESTERDAYRANK == tag then
		self:showYesterdayRank()
	elseif GameQuewangLayer.BT_GETKINGREWARD == tag then
		self:getKingReward()
	end
end
--今日排行
function GameQuewangLayer:showTodayRank()
	
end
--昨日排行
function GameQuewangLayer:showYesterdayRank()
	
end
--领取奖励
function GameQuewangLayer:getKingReward()
	
end
function GameQuewangLayer:registerTouch(  )
	local function onTouchBegan( touch, event )
		return self:isVisible()
	end

	local function onTouchEnded( touch, event )
		local pos = touch:getLocation();
		local m_spBg = self.m_spBg
        pos = m_spBg:convertToNodeSpace(pos)
        local rec = cc.rect(0, 0, m_spBg:getContentSize().width, m_spBg:getContentSize().height)
        if false == cc.rectContainsPoint(rec, pos) then
            self:showLayer(false)
        end
		self.m_helpBg:setVisible(false)
 
	end

	local listener = cc.EventListenerTouchOneByOne:create();
	listener:setSwallowTouches(true)
	self.listener = listener;
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN );
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED );
    local eventDispatcher = self:getEventDispatcher();
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self);
end

function GameQuewangLayer:showLayer( var )
	self:setVisible(var)
end

--刷新押注排行
function GameQuewangLayer:refreshRewardRank( userlist,totlebet )
	if nil == self.m_parent then
		return
	end
	self.m_rankListView:removeAllChildren()
	
	local betRank = {}
	
	for i=1, #userlist do
		betRank[i] = i
		local userdata = userlist[i]
		local item = self.m_rankItem:clone()
		if item ~= nil and userdata ~= nil  then
			item:getChildByName("Text_nickName"):setString(userdata.szNickName)
			item:getChildByName("Text_totleBet"):setString(totlebet)
			
			if betRank[i] == 1 then
				item:getChildByName("Text_rank"):setString("")
				item:getChildByName("Image_jiangbei"):loadTexture("quewang/dragon_rank_1.png")
				item:getChildByName("Text_kingReward"):setString("彩金*50%")
			elseif betRank[i] == 2 then
				item:getChildByName("Text_rank"):setString("")
				item:getChildByName("Image_jiangbei"):loadTexture("quewang/dragon_rank_2.png")
				item:getChildByName("Text_kingReward"):setString("彩金*22%")
			elseif betRank[i] == 3 then
				item:getChildByName("Text_rank"):setString("")
				item:getChildByName("Image_jiangbei"):loadTexture("quewang/dragon_rank_3.png")
				item:getChildByName("Text_kingReward"):setString("彩金*8%")
			elseif betRank[i] >=4 and betRank[i] <= 6 then
				item:getChildByName("Text_rank"):setString(betRank[i])
				item:getChildByName("Image_jiangbei"):setVisible(false)
				item:getChildByName("Text_kingReward"):setString("彩金*2%")
			else
				item:getChildByName("Text_rank"):setString(betRank[i])
				item:getChildByName("Image_jiangbei"):setVisible(false)
				item:getChildByName("Text_kingReward"):setString("彩金*1%")
			end
		end
		self.m_rankListView:pushBackCustomItem(item)
	end

	
end
--刷新彩金和自己的押注金额、排行
function GameQuewangLayer:refreshKingReward()
	
	self.m_kingReward:setString("")
	self.m_todayBet:setString("今日押注总额：")
	self.m_todayBetRank:setString("今日押注排行：")
	
end
return GameQuewangLayer