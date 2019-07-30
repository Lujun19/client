 --
-- Author: zhong
-- Date: 2016-11-02 17:28:24
--
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local GameChatLayer = appdf.req(appdf.CLIENT_SRC.."plaza.views.layer.game.GameChatLayer")
local ClipText = appdf.req(appdf.EXTERNAL_SRC .. "ClipText")
local AnimationMgr = appdf.req(appdf.EXTERNAL_SRC .. "AnimationMgr")

local module_pre = "game.qipai.landnoshuffle.src"
local cmd = appdf.req(module_pre .. ".models.CMD_Game")
local Define = appdf.req(module_pre .. ".models.Define")
local GameRoleItem = appdf.req(module_pre .. ".views.layer.GameRoleItem")
local CardSprite = appdf.req(module_pre .. ".views.layer.gamecard.CardSprite")
local CardsNode = appdf.req(module_pre .. ".views.layer.gamecard.CardsNode")
local GameLogic = appdf.req(module_pre .. ".models.GameLogic")
local GameResultLayer = appdf.req(module_pre .. ".views.layer.GameResultLayer")
local SetLayer = appdf.req(module_pre .. ".views.layer.SetLayer")
local PopupInfoHead = appdf.req(appdf.EXTERNAL_SRC .. "PopupInfoHead")
local scheduler = cc.Director:getInstance():getScheduler()

local TAG_ENUM = Define.TAG_ENUM
local TAG_ZORDER = Define.TAG_ZORDER

-- 玩家牌的位置
local tabCardPosition =
{
	cc.p(-51, 585),
	cc.p(636, 90),
	cc.p(1390, 585)
}

local tabOtherCardPosition =
{
	cc.p(222, 700),
	cc.p(636, 186),
	cc.p(1020, 700)
}

local tabBankerCardPosition =
{
	cc.p(-36, 12),
	cc.p(0, 12),
	cc.p(36, 12)
}

local tabOutNormalCardPosition =
{
	cc.p(49, 651),
	cc.p(636, 200),
	cc.p(1254, 651)
}

local tabOutSpecialCardPosition =
{
	cc.p(252, 489),
	cc.p(636, 417),
	cc.p(943, 489)
}

--庄家牌纹理宽高
local small_CARD_WIDTH = 40
local small_CARD_HEIGHT = 51

local GameViewLayer = class("GameViewLayer", function (scene)
	local gameViewLayer = display.newLayer()
	return gameViewLayer
end)

function GameViewLayer:ctor(scene)
	--注册node事件
	ExternalFun.registerNodeEvent(self)
	self._scene = scene

	--初始化
	self:paramInit()
	self.time = 5
	--加载资源
	self:loadResource()
end

function GameViewLayer:paramInit()
	-- 聊天层
	self.m_chatLayer = nil
	-- 结算层
	self.m_resultLayer = nil

	-- 手牌控制
	self.m_cardControl = nil
	-- 手牌数量
	self.m_tabCardCount = {}
	-- 报警动画
--	self.m_tabSpAlarm = {}

	-- 叫分atlas
	self.m_atlasGameCall = nil
	-- 庄家牌
	self.m_nodeBankerCard = nil
	self.m_tabBankerCard = {}
	-- 准备按钮
--	self.m_btnReady = nil

	-- 准备标签
	self.m_tabReadySp = {}
	-- 状态标签
	self.m_tabStateSp = {}

	-- 叫分控制
	self.m_callScoreControl = nil
	self.m_nMaxCallScore = 0
	self.m_tabNotCallBtn = {}
	self.m_tabCallScoreBtn = {}

	-- 加倍控制
	self.m_multipleControl = nil
	self.m_btnMultiple = nil
	self.m_btnNoMultiple = nil
	-- 操作控制
	self.m_onGameControl = nil
	self.m_btnOutCard = nil
	self.m_btnPass = nil
	self.m_bMyCallBanker = false
	self.m_bMyOutCards = false

	-- 出牌控制
	self.m_outCardsControl = nil
	-- 能否出牌
	self.m_bCanOutCard = false

	-- 用户信息
	self.m_userinfoControl = nil
	-- 用户头像
	self.m_tabUserHead = {}
	self.m_tab_head_info = {}

	self.m_tabUserNode = {}
	self.m_tabUserAniNode = {}
	self.m_tabUserAni = {}
	self.b_tabUserAni = {false,false,false}
	self.m_tabUserAction = {};

	-- local csbPath = "test/nan1.csb"
	-- self._netWait = ExternalFun.loadCSB(csbPath, self)
	-- self._netWait:setPosition(yl.WIDTH / 2, yl.HEIGHT / 2)
	-- self._netWaitAni = ExternalFun.loadTimeLine(csbPath)
	-- self._netWait:runAction(self._netWaitAni)
	-- self._netWait:setLocalZOrder(yl.MAX_INT)

--	self.m_tabUserHeadPos = {}
	-- 玩家身份帽子
--	self.m_identityHat = {}
--	self.m_lordMask = {}
	-- 用户信息
	self.m_tabUserItem = {}
	-- 用户昵称
	--    self.m_tabCacheUserNick = {}
	-- 用户游戏币
	--    self.m_atlasScore = nil
	-- 底分
	self.m_atlasDiFeng = nil
	-- 提示
	self.m_spInfoTip = nil
	-- 一轮提示组合
	self.m_promptIdx = 0
	-- 倒计时
	self.m_spTimer = nil
	-- 倒计时
	self.m_atlasTimer = nil
--	self.m_tabTimerPos = {}
    --jipaiqi
    self.m_cardLeftCountLabel = {}

	-- 托管
	self.m_trusteeshipControl = nil

	-- 扑克
	self.m_tabNodeCards = {}
	self.m_tabNodeOtherCards = {}
--[[	-- 火箭
	self.m_actRocketRepeat = nil
	-- 火箭飞行
	self.m_actRocketShoot = nil

	-- 飞机
	self.m_actPlaneRepeat = nil
	-- 飞机飞行
	self.m_actPlaneShoot = nil

	-- 炸弹
	self.m_actBomb = nil--]]

	-- 结果缓存，点击结算详情才打开
	self.m_temp_settle = nil

	-- 上轮的出牌动画名字
	self.m_tab_last_outCard_ani  = {}

	-- 换桌
	self.m_tabletimer = 3
	self.bdeleteuserdata = false
	self.btTable = nil
	self.m_scheduler = nil
	self.m_schedulerupdata = nil
	self.istable = false
	self.clockViewId = nil

	-- 庄家视图
	self.m_bankerViewId = nil
end

function GameViewLayer:getParentNode()
	return self._scene
end

function GameViewLayer:addToRootLayer( node , zorder)
	if nil == node then
		return
	end

	self.m_rootLayer:addChild(node)
	if type(zorder) == "number" then
		node:setLocalZOrder(zorder)
	end
end


function GameViewLayer:showAnimal( view, action )
	self.m_tabUserAniNode[view]:getChildByName("buyao"):setVisible(false);
	self.m_tabUserAniNode[view]:getChildByName("chupai"):setVisible(false);
	self.m_tabUserAniNode[view]:getChildByName("wait"):setVisible(false);
	self.m_tabUserAniNode[view]:getChildByName("chupaikaishi"):setVisible(false);
	self.m_tabUserAniNode[view]:getChildByName(action):setVisible(true);
end


function GameViewLayer:playUserAnimal( view, action, loop, nextAction, loop2 )
		self.m_tabUserAction[view] = action;
		if self.b_tabUserAni[view] == false then
			self.b_tabUserAni[view] = true;
	    end
	   self:showAnimal( view, action );
	   self.m_tabUserAni[view]:clearLastFrameCallFunc()
	   -- self.m_tabUserAniNode[view]:stopAllActions()
		if action == "wait" then 
			local move = cc.CallFunc:create(function (  )
				-- body
				self.m_tabUserAni[view]:setLastFrameCallFunc(function(frame,evt)

						self.m_tabUserAni[view]:gotoFrameAndPause(1)
					end)
					self.m_tabUserAni[view]:play("wait", false)
				
		 	end)
		 --	local time  = math.random(5,8)

			local delay = cc.DelayTime:create(self.time)
			self.time = self.time + 1
			if self.time > 9 then 
				self.time = 5
			end
			local seq1 = cc.Sequence:create(move, delay)
			local action2 = cc.RepeatForever:create(seq1)
			self.m_tabUserAniNode[view]:runAction(action2)
		else
			self.m_tabUserAni[view]:play(action, loop)
		end

		if nextAction == "wait" then 
			self.m_tabUserAni[view]:clearLastFrameCallFunc()
			 self:showAnimal( view, nextAction );
			 local move = cc.CallFunc:create(function (  )
				-- body
				self.m_tabUserAni[view]:setLastFrameCallFunc(function(frame,evt)

						self.m_tabUserAni[view]:gotoFrameAndPause(1)
					end)
					self.m_tabUserAni[view]:play("wait", false)
				
		 	end)
			local delay = cc.DelayTime:create(5)

			local seq1 = cc.Sequence:create(move, delay)
			local action2 = cc.RepeatForever:create(seq1)
			self.m_tabUserAniNode[view]:runAction(action2)
		end
	

end


function GameViewLayer:stopUserAnimal( view )

		self.m_tabUserAniNode[view]:stopAllActions();

end

function GameViewLayer:loadResource()
	-- 加载卡牌纹理
	cc.Director:getInstance():getTextureCache():addImage("game/card.png")
	cc.Director:getInstance():getTextureCache():addImage("game/cardsmall.png")
	-- 加载动画纹理
	cc.SpriteFrameCache:getInstance():addSpriteFrames("game/animation.plist")

	cc.SpriteFrameCache:getInstance():addSpriteFrames("animation/renwu/nv1.plist")

--[[	-- 叫分
	AnimationMgr.loadAnimationFromFrame("call_point_0%d.png", 0, 5, Define.CALLSCORE_ANIMATION_KEY)
	-- 一分
	AnimationMgr.loadAnimationFromFrame("call_point_0%d.png", 5, 3, Define.CALLONE_ANIMATION_KEY)
	-- 两分
	AnimationMgr.loadAnimationFromFrame("call_point_1%d.png", 5, 3, Define.CALLTWO_ANIMATION_KEY)
	-- 三分
	AnimationMgr.loadAnimationFromFrame("call_point_2%d.png", 5, 3, Define.CALLTHREE_ANIMATION_KEY)--]]
	-- 飞机
--	AnimationMgr.loadAnimationFromFrame("plane_%d.png", 0, 5, Define.AIRSHIP_ANIMATION_KEY)
	-- 火箭
--	AnimationMgr.loadAnimationFromFrame("rocket_%d.png", 0, 5, Define.ROCKET_ANIMATION_KEY)
	-- 报警
--	AnimationMgr.loadAnimationFromFrame("game_alarm_0%d.png", 0, 5, Define.ALARM_ANIMATION_KEY)
	-- 炸弹
--	AnimationMgr.loadAnimationFromFrame("game_bomb_0%d.png", 0, 5, Define.BOMB_ANIMATION_KEY)
	-- 语音动画
	AnimationMgr.loadAnimationFromFrame("record_play_ani_%d.png", 1, 3, Define.VOICE_ANIMATION_KEY)

	--播放背景音乐
	ExternalFun.playBackgroudAudio("background.mp3")

	local rootLayer, csbNode = ExternalFun.loadRootCSB("game/GameLayerNew.csb", self)
	self.m_rootLayer = rootLayer
	self.m_csbNode = csbNode


	local function btnEvent( sender, eventType )
		if eventType == ccui.TouchEventType.began then
			ExternalFun.popupTouchFilter(1, false)
		elseif eventType == ccui.TouchEventType.canceled then
			ExternalFun.dismissTouchFilter()
		elseif eventType == ccui.TouchEventType.ended then
			ExternalFun.dismissTouchFilter()
			self:onButtonClickedEvent(sender:getTag(), sender)
		end
	end
	local csbNode = self.m_csbNode

	self.m_cardControl = csbNode:getChildByName("card_control")
	self.cardActionNode =  csbNode:getChildByName("cardActionNode")
	self.m_tabCardCount[cmd.LEFT_VIEWID] = self.m_cardControl:getChildByName("card_count_" .. cmd.LEFT_VIEWID)
	self.m_tabCardCount[cmd.LEFT_VIEWID]:setLocalZOrder(1)
	self.m_tabCardCount[cmd.RIGHT_VIEWID] = self.m_cardControl:getChildByName("card_count_" .. cmd.RIGHT_VIEWID)
	self.m_tabCardCount[cmd.RIGHT_VIEWID]:setLocalZOrder(1)
	------
	--更多菜单
	-- self.m_moreNode = ExternalFun.loadCSB("game/MoreLayerNew.csb", self.m_rootLayer)
	--托管按钮
--[[	btn = ExternalFun.getChildRecursiveByName(self.m_moreNode, "tru_btn")
	btn:setTag(TAG_ENUM.BT_TRU)
	btn:setSwallowTouches(true)
	btn:addTouchEventListener(btnEvent)
	btn:setEnabled(not GlobalUserItem.bPrivateRoom)--]]
	--[[if GlobalUserItem.bPrivateRoom then
		btn:setOpacity(125)
	end--]]


	------
	--顶部菜单

	local top = csbNode:getChildByName("btn_layout")
	--更多按钮
-- 	self.m_btnMore = top:getChildByName("more_btn")
-- --	self.m_btnMore:setTag(TAG_ENUM.BT_MORE)
-- 	self.m_btnMore:setTag(TAG_ENUM.BT_MORE)
-- 	--self.m_btnMore:setSwallowTouches(true)
-- 	self.m_btnMore:addTouchEventListener(btnEvent)

	--叫分
	self.m_atlasGameCall = top:getChildByName("gamecall_atlas")
	self.m_atlasGameCall:setString("")
	-- 庄家扑克
	self.m_nodeBankerCard = cc.Node:create()
	self.m_nodeBankerCard:setPosition(670, 697)
	top:addChild(self.m_nodeBankerCard)

	--托管按钮
	self.temp_tru_btn = top:getChildByName("temp_tru_btn")
	self.temp_tru_btn:setTag(TAG_ENUM.BT_TRU)
	self.temp_tru_btn:setVisible(false)
	self.temp_tru_btn:addTouchEventListener(btnEvent)


	self.Trusteeship=top:getChildByName("Image_1")
	self.Trusteeship:setVisible(false)

	

		--设置按钮
	self.m_btnSet = top:getChildByName("set_btn")
	self.m_btnSet:setTag(TAG_ENUM.BT_SET)
	self.m_btnSet:setSwallowTouches(true)
	self.m_btnSet:addTouchEventListener(btnEvent)


	self.m_btnQuit = top:getChildByName("quit_btn")
	self.m_btnQuit:setTag(TAG_ENUM.BT_EXIT)
	self.m_btnQuit:setSwallowTouches(true)
	self.m_btnQuit:addTouchEventListener(btnEvent)

	--除更多下拉框之外其他区域做成按钮
	-- self.m_btnBackMore = ExternalFun.getChildRecursiveByName(self.m_moreNode, "back_more_btn")
	-- self.m_btnBackMore:setTag(TAG_ENUM.BT_BACK_MORE)
	-- self.m_btnBackMore:setSwallowTouches(true)
	-- self.m_btnBackMore:addTouchEventListener(btnEvent)
	-- self.m_btnBackMore:setEnabled(false)
	-- self.m_btnBackMore:setVisible(false)

	--准备按钮，主界面的准备按钮屏蔽掉，进入直接默认准备状态
--[[	self.m_btnReady = top:getChildByName("ready_btn")
	self.m_btnReady:setTag(TAG_ENUM.BT_READY)
	self.m_btnReady:addTouchEventListener(btnEvent)
	self.m_btnReady:setEnabled(false)
	self.m_btnReady:setVisible(false)--]]

	-- 邀请按钮
	self.m_btnInvite = top:getChildByName("btn_invite")
	self.m_btnInvite:setTag(TAG_ENUM.BT_INVITE)
	self.m_btnInvite:addTouchEventListener(btnEvent)
	if GlobalUserItem.bPrivateRoom then
		self.m_btnInvite:setVisible(false)
		self.m_btnInvite:setEnabled(false)
	end

	--换桌按钮
	local change_table_btn =top:getChildByName("btn_change_table")
	self.begin_table_btn_pos = cc.p(change_table_btn:getPosition())
	self.btTable = change_table_btn
	change_table_btn:setTag(TAG_ENUM.BT_TRADETABLE)
	change_table_btn:setSwallowTouches(true)
	change_table_btn:addTouchEventListener(btnEvent)
	local left_seconds = self.btTable:getChildByName("left_seconds")
	left_seconds:setTag(TAG_ENUM.BT_TABLETIMER)

	-- 底分
	self.m_atlasDiFeng = top:getChildByName("dizhu_atlas")
	self.m_atlasDiFeng:setString("")

	-- 屏蔽语音和帮助按钮
--[[	-- 语音按钮 gameviewlayer -> gamelayer -> clientscene
	self:getParentNode():getParentNode():createVoiceBtn(cc.p(1250, 120), 0, top)

	-- 帮助按钮 gameviewlayer -> gamelayer -> clientscene
	local url = BaseConfig.WEB_HTTP_URL .. "/Mobile/Introduce.aspx?kindid=200&typeid=0"
	self:getParentNode():getParentNode():createHelpBtn(cc.p(1287, 698), 0, url, top)--]]

	--顶部菜单
	------
	------
	--用户状态
	local userState = csbNode:getChildByName("userstate_control")

	--标签
	local str = ""
	for i = 1, 3 do
		-- 准备标签
		str = "ready" .. i
		local tmpsp = userState:getChildByName(str)
		self.m_tabReadySp[i] = tmpsp

		-- 状态标签
		str = "state_sp" .. i
		tmpsp = userState:getChildByName(str)
		self.m_tabStateSp[i] = tmpsp

		-- 扑克牌
		self.m_tabNodeCards[i] = CardsNode:createEmptyCardsNode(i)
		-- 玩家牌的节点self.m_tabNodeCards[i]
		self.m_tabNodeCards[i]:setPosition(tabCardPosition[i])
		self.m_tabNodeCards[i]:setListener(self)
		self.m_cardControl:addChild(self.m_tabNodeCards[i])

		-- 看其它人的牌
		self.m_tabNodeOtherCards[i] = cc.Node:create()
		self.m_tabNodeOtherCards[i]:setPosition(tabOtherCardPosition[i])
		self.m_cardControl:addChild(self.m_tabNodeOtherCards[i])
		self.m_tabNodeOtherCards[i]:setName("other_card_" .. i)

		-- 庄家扑克牌
		tmpsp = CardSprite:createCard(0, {_width = small_CARD_WIDTH, _height = small_CARD_HEIGHT, _file = "game/cardsmall.png"})
		tmpsp:setVisible(false)
		tmpsp:setPosition(tabBankerCardPosition[i])
		-- 庄家牌的节点self.m_nodeBankerCard
		self.m_nodeBankerCard:addChild(tmpsp)
		self.m_tabBankerCard[i] = tmpsp

--[[		-- 报警动画
		tmpsp = self.m_cardControl:getChildByName("alarm_" .. i)
		self.m_tabSpAlarm[i] = tmpsp--]]
	end

	--用户状态
	------

	------
	--叫分控制

	local callScore = csbNode:getChildByName("callscore_control")
	self.m_callScoreControl = callScore
	self.m_callScoreControl:setVisible(false)
	--不叫/不抢按钮
	for i = 1, 2 do
		local str = "BT_NO_" .. i
		local btn = callScore:getChildByName(str)
		btn:setTag(TAG_ENUM[str])
		btn:addTouchEventListener(btnEvent)
		self.m_tabNotCallBtn[i] = btn
		self.m_tabNotCallBtn[i]:setVisible(false)
	end
	--叫地主/抢地主按钮
	for i = 1, 2 do
		local str = "BT_YES_" .. i
		local btn = callScore:getChildByName(str)
		btn:setTag(TAG_ENUM[str])
		btn:addTouchEventListener(btnEvent)
		self.m_tabCallScoreBtn[i] = btn
		self.m_tabCallScoreBtn[i]:setVisible(false)
	end
	--叫分控制
	------

	------
	--加倍控制
	local multiple = csbNode:getChildByName("multiple_control")
	self.m_multipleControl = multiple
	self.m_multipleControl:setVisible(false)
	-- 加倍按钮
	btn = multiple:getChildByName("multiple_btn")
	btn:setTag(TAG_ENUM.BT_MULTIPLE)
	btn:addTouchEventListener(btnEvent)
	self.m_btnMultiple = btn
	-- 不加倍按钮
	btn = multiple:getChildByName("no_multiple_btn")
	btn:setTag(TAG_ENUM.BT_NO_MULTIPLE)
	btn:addTouchEventListener(btnEvent)
	self.m_btnNoMultiple = btn

	--加倍控制
	------

	------
	--操作控制

	local onGame = csbNode:getChildByName("ongame_control")
	self.m_onGameControl = onGame
	self.m_onGameControl:setVisible(false)

	--不出按钮
	btn = onGame:getChildByName("pass_btn")
	btn:setTag(TAG_ENUM.BT_PASS)
	btn:addTouchEventListener(btnEvent)
	self.m_btnPass = btn

	--提示按钮
	btn = onGame:getChildByName("suggest_btn")
	btn:setTag(TAG_ENUM.BT_SUGGEST)
	btn:addTouchEventListener(btnEvent)

	--出牌按钮
	btn = onGame:getChildByName("outcard_btn")
	btn:setTag(TAG_ENUM.BT_OUTCARD)
	btn:addTouchEventListener(btnEvent)
	btn:setSwallowTouches(true)
	self.m_btnOutCard = btn

	--操作控制
	------

	------
	-- 出牌控制
	self.m_outCardsControl = csbNode:getChildByName("outcards_control")
	-- 出牌控制
	------

	------
	-- 用户信息

	local infoLayout = csbNode:getChildByName("info")
	self.m_userinfoControl = infoLayout

	local gameNodeLayout = csbNode:getChildByName("gameNode")
	self.m_userAniControl = infoLayout

	--用户昵称
	--[[    self.m_clipNick = ClipText:createClipText(cc.size(200, 30), GlobalUserItem.szNickName, "base/fonts/round_body.ttf", 30)
	local tmp = infoLayout:getChildByName("nick_text_2")
	self.m_clipNick:setPosition(tmp:getPosition())
	self.m_clipNick:setAnchorPoint(tmp:getAnchorPoint())
	infoLayout:addChild(self.m_clipNick)
	tmp:removeFromParent()--]]

	-- 游戏币
	--    self.m_atlasScore = self.m_userinfoControl:getChildByName("score_atlas_".. cmd.MY_VIEWID)

	self.m_tab_head_info[cmd.MY_VIEWID] = infoLayout:getChildByName("head_info_" .. cmd.MY_VIEWID)
	self.m_tab_head_info[cmd.LEFT_VIEWID] = infoLayout:getChildByName("head_info_" .. cmd.LEFT_VIEWID)
	self.m_tab_head_info[cmd.RIGHT_VIEWID] = infoLayout:getChildByName("head_info_" .. cmd.RIGHT_VIEWID)


	--
	local csbPath = "animation/renwu/nv1.csb"
	-- self._netWait = ExternalFun.loadCSB(csbPath, self)
	-- self._netWait:setPosition(yl.WIDTH / 2, yl.HEIGHT / 2)
	-- self._netWaitAni = ExternalFun.loadTimeLine(csbPath)
	-- self._netWait:runAction(self._netWaitAni)
	-- self._netWait:setLocalZOrder(yl.MAX_INT)

	self.m_tabUserNode[cmd.MY_VIEWID] = csbNode:getChildByName("user_node_" .. cmd.MY_VIEWID);
	self.m_tabUserNode[cmd.LEFT_VIEWID] = csbNode:getChildByName("user_node_" .. cmd.LEFT_VIEWID);
	self.m_tabUserNode[cmd.RIGHT_VIEWID] = csbNode:getChildByName("user_node_" .. cmd.RIGHT_VIEWID);

	self.m_tabUserAniNode[cmd.MY_VIEWID] = ExternalFun.loadCSB("animation/renwu/nv1_l.csb", 	self.m_tabUserNode[cmd.MY_VIEWID]);
	self.m_tabUserAniNode[cmd.MY_VIEWID]:setPosition(-20, 40)
	self.m_tabUserAni[cmd.MY_VIEWID] = ExternalFun.loadTimeLine("animation/renwu/nv1_l.csb");
	self.m_tabUserAniNode[cmd.MY_VIEWID]:runAction(self.m_tabUserAni[cmd.MY_VIEWID]);

	self.m_tabUserAniNode[cmd.LEFT_VIEWID] = ExternalFun.loadCSB("animation/renwu/nv1_l.csb", 	self.m_tabUserNode[cmd.LEFT_VIEWID]);
	self.m_tabUserAniNode[cmd.LEFT_VIEWID]:setPosition(-20, 40)
	self.m_tabUserAni[cmd.LEFT_VIEWID] = ExternalFun.loadTimeLine("animation/renwu/nv1_l.csb");
	self.m_tabUserAniNode[cmd.LEFT_VIEWID]:runAction(self.m_tabUserAni[cmd.LEFT_VIEWID]);


	self.m_tabUserAniNode[cmd.RIGHT_VIEWID] = ExternalFun.loadCSB("animation/renwu/nv1_r.csb", 	self.m_tabUserNode[cmd.RIGHT_VIEWID]);
	self.m_tabUserAniNode[cmd.RIGHT_VIEWID]:setPosition(-20,40)
	self.m_tabUserAni[cmd.RIGHT_VIEWID] = ExternalFun.loadTimeLine("animation/renwu/nv1_r.csb");
	self.m_tabUserAniNode[cmd.RIGHT_VIEWID]:runAction(self.m_tabUserAni[cmd.RIGHT_VIEWID]);

	-- self:playUserAnimal(cmd.LEFT_VIEWID, "wait",true);
	self.m_tabUserNode[cmd.MY_VIEWID]:setVisible(false);
	self.m_tabUserNode[cmd.LEFT_VIEWID]:setVisible(false);
	self.m_tabUserNode[cmd.RIGHT_VIEWID]:setVisible(false);
	-- self:playUserAnimal(cmd.MY_VIEWID, "wait",true);
	-- self:playUserAnimal(cmd.RIGHT_VIEWID, "wait",true);

	-- self:playUserAnimal(cmd.MY_VIEWID, "wait",true);
	-- self:playUserAnimal(cmd.LEFT_VIEWID, "wait",true);
	-- self:playUserAnimal(cmd.RIGHT_VIEWID, "wait",true);





	self:gameHeadInit()

	-- 头像位置
--[[	local my_head_bg = my_head_info:getChildByName("head_bg")
	self.m_tabUserHeadPos[cmd.MY_VIEWID] = cc.p(my_head_bg:getPositionX(),my_head_bg:getPositionY())
	local left_head_bg = left_head_info:getChildByName("head_bg")
	self.m_tabUserHeadPos[cmd.LEFT_VIEWID] = cc.p(left_head_bg:getPositionX(),left_head_bg:getPositionY())
	local right_head_bg = right_head_info:getChildByName("head_bg" )
	self.m_tabUserHeadPos[cmd.RIGHT_VIEWID] = cc.p(right_head_bg:getPositionX(),right_head_bg:getPositionY())--]]

	-- 身份帽子
--[[	self.m_identityHat[cmd.MY_VIEWID]= my_head_info:getChildByName("identity_hat")
	self.m_identityHat[cmd.LEFT_VIEWID]= left_head_info:getChildByName("identity_hat")
	self.m_identityHat[cmd.RIGHT_VIEWID]= right_head_info:getChildByName("identity_hat")--]]

--[[	-- 地主标记
	self.m_lordMask[cmd.MY_VIEWID]= infoLayout:getChildByName("lord_mask_" .. cmd.MY_VIEWID)
	self.m_lordMask[cmd.LEFT_VIEWID]= infoLayout:getChildByName("lord_mask_" .. cmd.LEFT_VIEWID)
	self.m_lordMask[cmd.RIGHT_VIEWID]= infoLayout:getChildByName("lord_mask_" .. cmd.RIGHT_VIEWID)--]]

	-- 提示tip
	self.m_spInfoTip = infoLayout:getChildByName("info_tip")

    --jifenqi

  --   local csbbgImageNode = csbNode:getChildByName("game_bg_0_1")
  --   local csbJifenqiNode = csbbgImageNode:getChildByName("jipaiqi_1")
  --   for i = 1, 15 do
  --       self.m_cardLeftCountLabel[i]= csbJifenqiNode:getChildByName("cardleftcount" ..(i-1))
	-- end
	-- 倒计时
--	local call_score_clock = self.m_callScoreControl:getChildByName("score_clock_" .. cmd.MY_VIEWID) -- 自己视角的叫分倒计时
	self.m_spTimer = infoLayout:getChildByName("bg_clock")
	self.m_atlasTimer = self.m_spTimer:getChildByName("atlas_time")
--[[	local tmp_left_clock = infoLayout:getChildByName("tmp_clock_" .. cmd.LEFT_VIEWID)
	local tmp_right_clock = infoLayout:getChildByName("tmp_clock_" .. cmd.RIGHT_VIEWID)--]]
--	self.m_tabTimerPos[cmd.MY_VIEWID] = cc.p(call_score_clock:getPositionX(),call_score_clock:getPositionY())
--[[	self.m_tabTimerPos[cmd.MY_VIEWID] = cc.p(self.m_spTimer:getPositionX(),self.m_spTimer:getPositionY())
	self.m_tabTimerPos[cmd.LEFT_VIEWID] = cc.p(tmp_left_clock:getPositionX(),tmp_left_clock:getPositionY())
	self.m_tabTimerPos[cmd.RIGHT_VIEWID] = cc.p(tmp_right_clock:getPositionX(),tmp_right_clock:getPositionY())--]]
--[[	tmp_left_clock:removeFromParent()
	tmp_right_clock:removeFromParent()--]]

	--聊天按钮
	local btn = infoLayout:getChildByName("chat_btn")
	btn:setTag(TAG_ENUM.BT_CHAT)
	btn:setSwallowTouches(true)
	btn:addTouchEventListener(btnEvent)

	-- 信息
	------

	------
	-- 出牌动画容器
	self.m_outcard_node = csbNode:getChildByName("outcard_control")
	-- 出牌动画容器
	------

	------
	-- 托管界面
	self.m_trusteeshipControl = csbNode:getChildByName("tru_control")
	local btn = self.m_trusteeshipControl:getChildByName("btn_cancel_tru")
	btn:setTag(TAG_ENUM.BT_CANCEL_TRU)
	btn:setSwallowTouches(true)
	btn:addTouchEventListener(btnEvent)

--[[	self.m_trusteeshipControl:addTouchEventListener(function ( ref, tType)
		if tType == ccui.TouchEventType.ended then
			if self.m_trusteeshipControl:isVisible() then
				self.m_trusteeshipControl:setVisible(false)
			end
		end
	end)--]]
	-- 游戏托管
	------
	-- local result_big = csbNode:getChildByName("result")
	-- self.m_result_big = result_big
	-- self.m_result_big:setVisible(false)

	-- 游戏结束csb加载
	---------
	self.m_resultNode = ExternalFun.loadCSB("game/GameResultLayerNew.csb", self.m_rootLayer)
	self.m_resultNode:setVisible(false)
	local m_resultNode = self.m_resultNode
	--准备按钮
	local btnReady = m_resultNode:getChildByName("ready_btn")
	btnReady:setTag(TAG_ENUM.BT_READY)
	btnReady:addTouchEventListener(btnEvent)
	--结算详情按钮
	local btnSettle = m_resultNode:getChildByName("settle_btn")
	btnSettle:setTag(TAG_ENUM.BT_SETTLE)
	btnSettle:addTouchEventListener(btnEvent)
	--结束换桌按钮坐标
	local  end_table_btn =  m_resultNode:getChildByName("btn_change_table")
	self.end_table_btn = end_table_btn
	-- 游戏结束csb加载
	---------

	function upuserdata(dt)
		local MyTable = self._scene:GetMeTableID()
		local n = table.maxn(self.m_tabUserItem)
        for j = 1,n do
			local userItem = self.m_tabUserItem[j]
			if userItem ~= nil then
				if self._scene ~= nil and self._scene._gameFrame ~= nil and self._scene._gameFrame._UserList[userItem.dwUserID] ~= nil then
					if self._scene._gameFrame._UserList[userItem.dwUserID].wTableID ~= MyTable then
						local roleItem = self.m_tabUserHead[j]
						if nil ~= roleItem then
							roleItem:removeFromParent()
							self.m_tabUserHead[j] = nil
							self.m_tab_head_info[j]:setVisible(false)
						end
						self.m_tabReadySp[j]:setVisible(false)
						self.m_tabStateSp[j]:setSpriteFrame("blank.png")
					end
				end
			end
        end
	end
	if nil == self.m_schedulerupdata then
		self.m_schedulerupdata = scheduler:scheduleScriptFunc(upuserdata, 0.3, false)
	end

	self._setLayer = SetLayer:create(self):addTo(self, TAG_ZORDER.SET_ZORDER)
	self:createAnimation()
	self:reSetGame()
end

function GameViewLayer:setCallScoreControl(isVisible)
	for i=1,2 do
		self.m_tabCallScoreBtn[i]:setVisible(isVisible)
		self.m_tabCallScoreBtn[i]:setEnabled(isVisible)
		self.m_tabNotCallBtn[i]:setVisible(isVisible)
		self.m_tabNotCallBtn[i]:setEnabled(isVisible)
	end
end

function GameViewLayer:setUserAnimal(viewId,action)


		-- local node = ExternalFun.loadCSB("animation/doudizhu_nan1_buyao.csb", self.m_tab_head_info[viewId])
		-- local node_ani = ExternalFun.loadTimeLine( "animation/doudizhu_nan1_buyao.csb")
		-- node:runAction(node_ani);
		-- node:move(cc.p(500,500));
	--
	-- 	self.m_resultBgNode = ExternalFun.loadCSB("animation/ResultBg.csb", self.m_resultNode)
	-- 	self.m_resultBgAni = ExternalFun.loadTimeLine( "animation/ResultBg.csb")
	-- --	ExternalFun.SAFE_RETAIN(self.m_resultBgAni)
	-- 	self.m_resultBgNode:runAction(self.m_resultBgAni)
	-- 	self.m_resultBgNode:move(self.m_resultNode:getChildByName("animation"):getPosition())


end

function GameViewLayer:createAnimation()
--[[	local param = AnimationMgr.getAnimationParam()
	param.m_fDelay = 0.1
	-- 火箭动画
	param.m_strName = Define.ROCKET_ANIMATION_KEY
	local animate = AnimationMgr.getAnimate(param)
	if nil ~= animate then
		local rep = cc.RepeatForever:create(animate)
		self.m_actRocketRepeat = rep
		self.m_actRocketRepeat:retain()
		local moDown = cc.MoveBy:create(0.1, cc.p(0, -20))
		local moBy = cc.MoveBy:create(2.0, cc.p(0, 500))
		local fade = cc.FadeOut:create(2.0)
		local seq = cc.Sequence:create(cc.DelayTime:create(2.0), cc.CallFunc:create(function ()
			end), fade)
		local spa = cc.Spawn:create(cc.EaseExponentialIn:create(moBy), seq)
		self.m_actRocketShoot = cc.Sequence:create(cc.CallFunc:create(function ( ref )
			ref:runAction(rep)
			end), moDown, spa, cc.RemoveSelf:create(true))
		self.m_actRocketShoot:retain()
	end
	-- 飞机动画
	param.m_strName = Define.AIRSHIP_ANIMATION_KEY
	local animate = AnimationMgr.getAnimate(param)
	if nil ~= animate then
		local rep = cc.RepeatForever:create(animate)
		self.m_actPlaneRepeat = rep
		self.m_actPlaneRepeat:retain()
		local moTo = cc.MoveTo:create(3.0, cc.p(0, yl.HEIGHT * 0.5))
		local fade = cc.FadeOut:create(1.5)
		local seq = cc.Sequence:create(cc.DelayTime:create(1.5), cc.CallFunc:create(function ()
			ExternalFun.playSoundEffect("common_plane.wav")
			end), fade)
		local spa = cc.Spawn:create(moTo, seq)
		self.m_actPlaneShoot = cc.Sequence:create(cc.CallFunc:create(function ( ref )
			ref:runAction(rep)
			end), spa, cc.RemoveSelf:create(true))
		self.m_actPlaneShoot:retain()
	end

	-- 炸弹动画
	param.m_strName = Define.BOMB_ANIMATION_KEY
	local animate = AnimationMgr.getAnimate(param)
	if nil ~= animate then
		local fade = cc.FadeOut:create(1.0)
		-- removeSelf run一次就回收掉
		self.m_actBomb = cc.Sequence:create(animate, fade, cc.RemoveSelf:create(true))
		-- retain加一次，release减少一次，减到0就回收。适用于多次调用的，没用这个的话下一帧就回收了
		self.m_actBomb:retain()
	end--]]
	--[[	function callBack()
		self.m_resultAnimation:setLastFrameCallFunc(nil)
		self.m_resultAnimation:play("lose_cycle", true)
    end
--	self.m_resultAnimationNode:setVisible(false)
	self.m_resultAnimation:play("landlord_lose", false)
	self.m_resultAnimation:setLastFrameCallFunc(callBack)--]]


--	self.m_resultAnimationNode:setVisible(true)
--	self.m_resultAnimation:gotoFrameAndPlay(0, true)
--[[	self.m_csbNode:stopAllActions()
	planeAni:gotoFrameAndPlay(0, true)
	planeAni:play("clock_animation_1", true)
	self.m_csbNode:runAction(planeAni)--]]

--[[	local color_layer = cc.LayerColor:create(cc.c4b(0,0,255,128))
	self.m_rootLayer:addChild(color_layer)--]]

	--local rootCsb = ExternalFun.loadCSB("animation/clock1.csb", self.m_csbNode)

--[[local rootLayer, csbNode = ExternalFun.loadRootCSB("game/GameLayer1.csb", self)
	self.m_rootLayer = rootLayer
	self.m_csbNode = csbNode--]]


--[[	local plane_layer = cc.LayerColor:create(cc.c4b(0,255,0,128),20,20)
	planeNode:addChild(plane_layer)--]]
--	self.m_spTimer:setSpriteFrame("blank.png")
--	planeNode:setPosition(self.m_spTimer:getPosition())
----	planeAni:gotoFrameAndPlay(0,true)  --去第0帧开始播放

--	planeNode:runAction(planeAni)

--[[ display.m_actDg = ExternalFun.loadTimeLine( "animation/clock.csb")
    local ani_dg = ExternalFun.loadCSB("animation/clock.csb", self)
            :setPosition(self.m_spTimer:getPosition())
    display.m_ani_dg = ani_dg

    ExternalFun.SAFE_RETAIN(display.m_actDg)
    display.m_ani_dg:stopAllActions()
    display.m_actDg:gotoFrameAndPlay(0,true)
    display.m_ani_dg:runAction(display.m_actDg)--]]
--[[	local plane_layer = cc.LayerColor:create(cc.c4b(0,255,0,128),20,20)
	self.m_spTimer:addChild(plane_layer)
	local clockAni = ExternalFun.loadTimeLine( "game/GameLayer.csb" )
	self.m_spTimer:runAction(clockAni)
	clockAni:play("clock_animation_1",true)	--]]
	-- 49,576
	--	1254,571

	-- 计时器动画
	self.m_timeAnimation = ExternalFun.loadTimeLine( "game/GameLayerNew.csb")
	ExternalFun.SAFE_RETAIN(self.m_timeAnimation)
	self.m_csbNode:runAction(self.m_timeAnimation)

	-- 结算动画
-- 	self.m_resultBgNode = ExternalFun.loadCSB("animation/ResultBg.csb", self.m_resultNode)
-- 	self.m_resultBgAni = ExternalFun.loadTimeLine( "animation/ResultBg.csb")
-- --	ExternalFun.SAFE_RETAIN(self.m_resultBgAni)
-- 	self.m_resultBgNode:runAction(self.m_resultBgAni)
-- 	self.m_resultBgNode:move(self.m_resultNode:getChildByName("animation"):getPosition())

-- 	self.m_resultRoleNode = ExternalFun.loadCSB("animation/ResultRole.csb", self.m_resultNode)
-- 	self.m_resultRoleAni = ExternalFun.loadTimeLine( "animation/ResultRole.csb")
-- --	ExternalFun.SAFE_RETAIN(self.m_resultRoleAni)
-- 	self.m_resultRoleNode:runAction(self.m_resultRoleAni)
-- 	self.m_resultRoleNode:move(self.m_resultNode:getChildByName("animation"):getPosition())

	--- 出牌动画

	-- 单张/对/飞机/炸弹/顺子
	self.m_outCard_normal_left_node = ExternalFun.loadCSB("animation/shunZi_L.csb", self.m_outcard_node)
	self.m_outCard_normal_left_ani = ExternalFun.loadTimeLine( "animation/shunZi_L.csb")
--	ExternalFun.SAFE_RETAIN(self.m_outCard_normal_left_ani)
	self.m_outCard_normal_left_node:runAction(self.m_outCard_normal_left_ani)
	self.m_outCard_normal_left_node:move(tabOutNormalCardPosition[cmd.LEFT_VIEWID])
	self.m_outCard_normal_right_node = ExternalFun.loadCSB("animation/shunZi_R.csb", self.m_outcard_node)
	self.m_outCard_normal_right_ani = ExternalFun.loadTimeLine( "animation/shunZi_R.csb")
	self.m_outCard_normal_right_node:runAction(self.m_outCard_normal_right_ani)
	self.m_outCard_normal_right_node:move(tabOutNormalCardPosition[cmd.RIGHT_VIEWID])
--	ExternalFun.SAFE_RETAIN(self.m_outCard_normal_right_ani)
	self:resetOutCardAniNode("normal", cmd.LEFT_VIEWID)
	self:resetOutCardAniNode("normal", cmd.RIGHT_VIEWID)

	-- 连对
	self.m_outCard_duizi_left_node = ExternalFun.loadCSB("animation/duiZi_L.csb", self.m_outcard_node)
	self.m_outCard_duizi_left_ani = ExternalFun.loadTimeLine( "animation/duiZi_L.csb")
--	ExternalFun.SAFE_RETAIN(self.m_outCard_duizi_left_ani)
	self.m_outCard_duizi_left_node:runAction(self.m_outCard_duizi_left_ani)
	self.m_outCard_duizi_left_node:move(tabOutNormalCardPosition[cmd.LEFT_VIEWID])
	self.m_outCard_duizi_right_node = ExternalFun.loadCSB("animation/duiZi_R.csb", self.m_outcard_node)
	self.m_outCard_duizi_right_ani = ExternalFun.loadTimeLine( "animation/duiZi_R.csb")
	self.m_outCard_duizi_right_node:runAction(self.m_outCard_duizi_right_ani)
	self.m_outCard_duizi_right_node:move(tabOutNormalCardPosition[cmd.RIGHT_VIEWID])
--	ExternalFun.SAFE_RETAIN(self.m_outCard_duizi_right_ani)
	self:resetOutCardAniNode("duizi", cmd.LEFT_VIEWID)
	self:resetOutCardAniNode("duizi", cmd.RIGHT_VIEWID)

	-- 三张
	self.m_outCard_sanzhang_left_node = ExternalFun.loadCSB("animation/sanZhang_L.csb", self.m_outcard_node)
	self.m_outCard_sanzhang_left_ani = ExternalFun.loadTimeLine( "animation/sanZhang_L.csb")
--	ExternalFun.SAFE_RETAIN(self.m_outCard_sanzhang_left_ani)
	self.m_outCard_sanzhang_left_node:runAction(self.m_outCard_sanzhang_left_ani)
	self.m_outCard_sanzhang_left_node:move(tabOutSpecialCardPosition[cmd.LEFT_VIEWID])
	self.m_outCard_sanzhang_right_node = ExternalFun.loadCSB("animation/sanZhang_R.csb", self.m_outcard_node)
	self.m_outCard_sanzhang_right_ani = ExternalFun.loadTimeLine( "animation/sanZhang_R.csb")
	self.m_outCard_sanzhang_right_node:runAction(self.m_outCard_sanzhang_right_ani)
	self.m_outCard_sanzhang_right_node:move(tabOutSpecialCardPosition[cmd.RIGHT_VIEWID])
--	ExternalFun.SAFE_RETAIN(self.m_outCard_sanzhang_right_ani)
	self.m_outCard_sanzhang_bottom_node = ExternalFun.loadCSB("animation/sanZhang_B.csb", self.m_outcard_node)
	self.m_outCard_sanzhang_bottom_ani = ExternalFun.loadTimeLine( "animation/sanZhang_B.csb")
	self.m_outCard_sanzhang_bottom_node:runAction(self.m_outCard_sanzhang_bottom_ani)
	self.m_outCard_sanzhang_bottom_node:move(tabOutSpecialCardPosition[cmd.MY_VIEWID])
--	ExternalFun.SAFE_RETAIN(self.m_outCard_sanzhang_bottom_ani)
	self:resetOutCardAniNode("sanzhang", cmd.LEFT_VIEWID)
	self:resetOutCardAniNode("sanzhang", cmd.MY_VIEWID)
	self:resetOutCardAniNode("sanzhang", cmd.RIGHT_VIEWID)

	-- 压
	self.m_outCard_ya_left_node = ExternalFun.loadCSB("animation/outCard_L.csb", self.m_outcard_node)
	self.m_outCard_ya_left_ani = ExternalFun.loadTimeLine( "animation/outCard_L.csb")
--	ExternalFun.SAFE_RETAIN(self.m_outCard_ya_left_ani)
	self.m_outCard_ya_left_node:runAction(self.m_outCard_ya_left_ani)
	self.m_outCard_ya_left_node:move(tabOutSpecialCardPosition[cmd.LEFT_VIEWID])
	self.m_outCard_ya_right_node = ExternalFun.loadCSB("animation/outCard_R.csb", self.m_outcard_node)
	self.m_outCard_ya_right_ani = ExternalFun.loadTimeLine( "animation/outCard_R.csb")
	self.m_outCard_ya_right_node:runAction(self.m_outCard_ya_right_ani)
	self.m_outCard_ya_right_node:move(tabOutSpecialCardPosition[cmd.RIGHT_VIEWID])
--	ExternalFun.SAFE_RETAIN(self.m_outCard_ya_right_ani)
	self.m_outCard_ya_bottom_node = ExternalFun.loadCSB("animation/outCard_B.csb", self.m_outcard_node)
	self.m_outCard_ya_bottom_ani = ExternalFun.loadTimeLine( "animation/outCard_B.csb")
	self.m_outCard_ya_bottom_node:runAction(self.m_outCard_ya_bottom_ani)
	self.m_outCard_ya_bottom_node:move(tabOutSpecialCardPosition[cmd.MY_VIEWID])
--	ExternalFun.SAFE_RETAIN(self.m_outCard_ya_bottom_ani)
	self:resetOutCardAniNode("ya", cmd.LEFT_VIEWID)
	self:resetOutCardAniNode("ya", cmd.MY_VIEWID)
	self:resetOutCardAniNode("ya", cmd.RIGHT_VIEWID)

	-- 特殊牌动画
	self.m_special_card_node = ExternalFun.loadCSB("animation/GameSpecialCard.csb", self.m_outcard_node)
	self.m_special_card_ani = ExternalFun.loadTimeLine( "animation/GameSpecialCard.csb")
	self.m_special_card_node:runAction(self.m_special_card_ani)

	self.m_spring_node = ExternalFun.loadCSB("animation/spring.csb", self.m_outcard_node)
	self.m_spring_ani = ExternalFun.loadTimeLine( "animation/spring.csb")
	self.m_spring_node:runAction(self.m_spring_ani)
	self.m_spring_node:move(cc.p(667,375))

	-- 倍数动画
	self.m_beishu_node = ExternalFun.loadCSB("animation/beiShu.csb", self.m_csbNode)
	self.m_beishu_ani = ExternalFun.loadTimeLine( "animation/beiShu.csb")
	self.m_beishu_node:runAction(self.m_beishu_ani)
	self.m_beishu_node:move(cc.p(769,690))

end

function GameViewLayer:unloadResource()
	cc.SpriteFrameCache:getInstance():removeSpriteFramesFromFile("game/animation.plist")
	cc.Director:getInstance():getTextureCache():removeTextureForKey("game/animation.png")
	cc.SpriteFrameCache:getInstance():removeSpriteFramesFromFile("animation/renwu/nv1.plist")
	cc.Director:getInstance():getTextureCache():removeTextureForKey("animation/renwu/nv1.png")
--[[	AnimationMgr.removeCachedAnimation(Define.CALLSCORE_ANIMATION_KEY)
	AnimationMgr.removeCachedAnimation(Define.CALLONE_ANIMATION_KEY)
	AnimationMgr.removeCachedAnimation(Define.CALLTWO_ANIMATION_KEY)
	AnimationMgr.removeCachedAnimation(Define.CALLTHREE_ANIMATION_KEY)--]]
--	AnimationMgr.removeCachedAnimation(Define.AIRSHIP_ANIMATION_KEY)
--	AnimationMgr.removeCachedAnimation(Define.ROCKET_ANIMATION_KEY)
--	AnimationMgr.removeCachedAnimation(Define.ALARM_ANIMATION_KEY)
--	AnimationMgr.removeCachedAnimation(Define.BOMB_ANIMATION_KEY)
	AnimationMgr.removeCachedAnimation(Define.VOICE_ANIMATION_KEY)

	cc.Director:getInstance():getTextureCache():removeTextureForKey("game/card.png")
	cc.Director:getInstance():getTextureCache():removeTextureForKey("game/cardsmall.png")
	cc.SpriteFrameCache:getInstance():removeSpriteFramesFromFile("game/game.plist")
	cc.Director:getInstance():getTextureCache():removeTextureForKey("game/game.png")
	cc.SpriteFrameCache:getInstance():removeSpriteFramesFromFile("public_res/public_res.plist")
	cc.Director:getInstance():getTextureCache():removeTextureForKey("public_res/public_res.png")
	cc.Director:getInstance():getTextureCache():removeUnusedTextures()
	cc.SpriteFrameCache:getInstance():removeUnusedSpriteFrames()
end

-- 游戏头像相关初始化
function GameViewLayer:gameHeadInit()
	for k,v in pairs(self.m_tab_head_info) do
		if (cmd.MY_VIEWID ~= k) then
			v:setVisible(false)
		else
			self:resetHeadByViewId(k)
		end
	end
end

-- 重置所有头像
function GameViewLayer:resetAllHead()
	for k,v in pairs(self.m_tab_head_info) do
		self:resetHeadByViewId(k)
	end
end

-- 重置头像
function GameViewLayer:resetHeadByViewId(viewId)
	local head_info = self.m_tab_head_info[viewId]
	if (nil ~= head_info) then
		local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame("farmer_image.png")
		if nil ~= frame then
			-- head_info:getChildByName("identity_hat"):setSpriteFrame(frame)
		end
		-- head_info:getChildByName("identity_hat"):setVisible(false)
		head_info:getChildByName("lord_mask"):setVisible(false)
	end
end

-- 重置
function GameViewLayer:reSetGame()
	self:reSetUserState()

--[[	self.m_spTimer:setVisible(false)
	self.m_atlasTimer:setVisible(false)--]]
	self.m_timeAnimation:play("reset", false)
	self.m_atlasTimer:setString("")
	-- 取消托管
	self.m_trusteeshipControl:setVisible(false)
	self.temp_tru_btn:setVisible(true)
--	self:onGameTrusteeship(false)

	self.m_bMyCallBanker = false
	self.m_bMyOutCards = false
end

-- 重置(新一局)
function GameViewLayer:reSetForNewGame()
	-- 清理手牌
	for k,v in pairs(self.m_tabNodeCards) do
		v:removeAllCards()

--[[		self.m_tabSpAlarm[k]:stopAllActions()
		self.m_tabSpAlarm[k]:setSpriteFrame("blank.png")--]]
	end
--[[	for k,v in pairs(self.m_tabNodeOtherCards) do
		v:removeAllCards()
	end--]]
	for k,v in pairs(self.m_tabCardCount) do
		v:getChildByName("atlas_count"):setString("")
		v:setVisible(false)
	end
	-- 清理桌面
	self.m_outCardsControl:removeAllChildren()
	-- 庄家叫分
	self.m_atlasGameCall:setString("")
	-- 庄家扑克
	for k,v in pairs(self.m_tabBankerCard) do
		v:setVisible(false)
		v:setCardValue(0)
	end
	-- 用户切换
	for k,v in pairs(self.m_tabUserHead) do
		v:reSet()
	end
	-- 清理出牌动画
	for k,v in pairs(self.m_tab_last_outCard_ani) do
		self:resetOutCardAniNode(v, tonumber(k))
	end
	-- 清除分数显示
	-- local m_result_big = self.m_result_big
	-- for i=1,3  do
	-- 	local resultBig = m_result_big:getChildByName("result_big_" .. i)
	-- 	if nil ~= resultBig then
	-- 		resultBig:removeFromParent()
	-- 	end
	-- end
	-- m_result_big:setVisible(false)
	-- 清理结束动画
	-- self.m_resultRoleNode:setVisible(false)
	-- self.m_resultRoleAni:play("reset", false)
	-- self.m_resultBgNode:setVisible(false)
	-- self.m_resultBgAni:play("reset", false)
	-- self.m_spring_ani:setLastFrameCallFunc(nil)
end

-- 重置用户状态
function GameViewLayer:reSetUserState()
	for k,v in pairs(self.m_tabReadySp) do
		v:setVisible(false)
	end

	for k,v in pairs(self.m_tabStateSp) do
		v:setSpriteFrame("blank.png")
	end
end

-- 重置用户信息
function GameViewLayer:reSetUserInfo()
	local score = self:getParentNode():GetMeUserItem().lScore or 0
	local scoreStr,  unit = ExternalFun.formatScoreUnit(score)
	local scoreStr = score
	if nil ~= unit then
		local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame("game_" .. unit .. ".png")
		local head_info = self.m_userinfoControl:getChildByName("head_info_" .. cmd.MY_VIEWID)
		if nil ~= frame then
			local score_atlas = head_info:getChildByName("score_atlas")
			head_info:removeChildByName("unit")
			local sprite = cc.Sprite:createWithSpriteFrame(frame)
			sprite:setName("unit")
			sprite:setScale(0.7)
			sprite:setPosition(cc.p(score_atlas:getPositionX() + string.len(scoreStr)/2*25*0.8, score_atlas:getPositionY()))
			head_info:addChild(sprite)
			score_atlas:setString(string.formatNumberFhousands(scoreStr))
		end
	end
end

-- 层被关闭的时候的回调
function GameViewLayer:onExit()
--[[	if nil ~= self.m_actRocketRepeat then
		self.m_actRocketRepeat:release()
		self.m_actRocketRepeat = nil
	end--]]

--[[	if nil ~= self.m_actRocketShoot then
		self.m_actRocketShoot:release()
		self.m_actRocketShoot = nil
	end--]]

--[[	if nil ~= self.m_actPlaneRepeat then
		self.m_actPlaneRepeat:release()
		self.m_actPlaneRepeat = nil
	end--]]

--[[	if nil ~= self.m_actPlaneShoot then
		self.m_actPlaneShoot:release()
		self.m_actPlaneShoot = nil
	end--]]

--[[	if nil ~= self.m_actBomb then
		self.m_actBomb:release()
		self.m_actBomb = nil
	end--]]
	if nil ~= self.m_timeAnimation then
		self.m_timeAnimation:release()
		self.m_timeAnimation = nil
	end
	self:unloadResource()

	self.m_tabUserItem = {}
	if nil ~= self.m_scheduler then
		print("stop dispatch")
		scheduler:unscheduleScriptEntry(self.m_scheduler)
		self.m_scheduler = nil
	end
	if nil ~= self.m_schedulerupdata then
		print("stop dispatch")
		scheduler:unscheduleScriptEntry(self.m_schedulerupdata)
		self.m_schedulerupdata = nil
	end
	--播放大厅背景音乐
    ExternalFun.playPlazzBackgroudAudio()
end

-- 通过类型和视角获取动画节点和动画
function GameViewLayer:getOutCardAniNodeByType(type, viewId)
	local outCard_node_str, outCard_ani_str
	if	viewId  == cmd.LEFT_VIEWID then
		outCard_node_str = "m_outCard_" .. type .. "_left_node"
		outCard_ani_str = "m_outCard_" .. type .. "_left_ani"
	elseif viewId == cmd.RIGHT_VIEWID then
		outCard_node_str = "m_outCard_" .. type .. "_right_node"
		outCard_ani_str = "m_outCard_" .. type .. "_right_ani"
	else
		outCard_node_str = "m_outCard_" .. type .. "_bottom_node"
		outCard_ani_str = "m_outCard_" .. type .. "_bottom_ani"
	end
	local outCard_node = self[outCard_node_str]
	local outCard_ani = self[outCard_ani_str]
	return outCard_node, outCard_ani
end

-- 重置出牌动画节点
function GameViewLayer:resetOutCardAniNode(type, viewId)
	local outCard_node, outCard_ani = self:getOutCardAniNodeByType(type, viewId)
	if nil == outCard_node or nil == outCard_ani then
		return
	end
	local all_card_node = outCard_node:getChildByName("all_card")
	local num = 1
	while true do
		local card_node_num = all_card_node:getChildByName("card_" .. num)
		if not card_node_num or card_node_num:isVisible() == false then
			break
		else
			card_node_num:getChildByName("animate"):getChildByName("sprite"):removeChildByTag(num)
			card_node_num:setVisible(false)
			num = num + 1
		end
	end
	outCard_ani:gotoFrameAndPause(0)
end

function GameViewLayer:onButtonClickedEvent(tag, ref)
	ExternalFun.playClickEffect()
	ExternalFun.playSoundEffect( "button.wav" )
	if TAG_ENUM.BT_CHAT == tag then             --聊天
		if nil == self.m_chatLayer then
			local noShowSend = true
			self.m_chatLayer = GameChatLayer:create(self._scene._gameFrame, noShowSend)
			self:addToRootLayer(self.m_chatLayer, TAG_ZORDER.CHAT_ZORDER)
		end
		self.m_chatLayer:showGameChat(true)
	elseif TAG_ENUM.BT_MORE == tag then			-- 更多
		self:onMore()
	elseif TAG_ENUM.BT_BACK_MORE == tag then        -- 除更多下拉框屏幕其他地方做成按钮
		self:onBackMore()
	elseif TAG_ENUM.BT_TRU == tag then          --托管
		self:getParentNode():sendUserTrustee(true)
		self.temp_tru_btn:setVisible(false)
		self.Trusteeship:setVisible(true)
		-- self:setUserTrustee(ref,true)
		-- self.m_trusteeshipControl:setVisible(true)
--		self:onGameTrusteeship(true)
--		self:onBackMore()
	elseif TAG_ENUM.BT_CANCEL_TRU  == tag then		--	 取消托管
		self:getParentNode():sendUserTrustee(false)
		self.temp_tru_btn:setVisible(true)
		self.Trusteeship:setVisible(false)
		-- self.m_trusteeshipControl:setVisible(false)
	elseif TAG_ENUM.BT_SET == tag then          --设置
--[[		local set = SetLayer:create()
		self:addToRootLayer(set, TAG_ZORDER.SET_ZORDER)--]]
		self._setLayer:showLayer()

	elseif TAG_ENUM.BT_EXIT == tag then         --退出
		self:getParentNode():onQueryExitGame()
--		self:onBackMore()
	elseif TAG_ENUM.BT_READY == tag then        --准备
		self:onClickReady()
--		self:onGetGameConclude()
--		self:onSettleInfo()
	elseif TAG_ENUM.BT_TRADETABLE == tag then	 -- 换桌
		self:changeTable()
	elseif TAG_ENUM.BT_SETTLE == tag then 	     -- 结算详情
		self:onSettleInfo()
--		self:resetTempSettle()			-- 清除结算缓存数据
	elseif TAG_ENUM.BT_INVITE == tag then       -- 邀请
		GlobalUserItem.bAutoConnect = false
		self:getParentNode():getParentNode():popTargetShare(function (target, bMyFriend)
			bMyFriend = bMyFriend or false
			local function sharecall( isok )
				if type(isok) == "string" and isok == "true" then
					--showToast(self, "分享成功", 2)
				end
				GlobalUserItem.bAutoConnect = true
			end
			local shareTxt = "斗地主游戏精彩刺激, 一起来玩吧! "
			local url = GlobalUserItem.getShareUrl()
			if bMyFriend then
				PriRoom:getInstance():getTagLayer(PriRoom.LAYTAG.LAYER_FRIENDLIST, function ( frienddata )
					dump(frienddata)
				end)
			elseif nil ~= target then
				MultiPlatform:getInstance():shareToTarget(target, sharecall, "斗地主游戏邀请", shareTxt, url, "")
			end
		end)
	elseif TAG_ENUM.BT_NO_1 == tag then   --不叫
--		ExternalFun.playSoundEffect( "cs0.wav", self:getParentNode():GetMeUserItem())
		self:getParentNode():sendCallScore(255)
		self:setCallScoreControl(false)
	elseif TAG_ENUM.BT_YES_1 == tag then   --叫地主
--		ExternalFun.playSoundEffect( "cs1.wav", self:getParentNode():GetMeUserItem())
		self:getParentNode():sendCallScore(1)
		self:setCallScoreControl(false)
	elseif TAG_ENUM.BT_NO_2 == tag then   --不抢
--		ExternalFun.playSoundEffect( "cs2.wav", self:getParentNode():GetMeUserItem())
		self:getParentNode():sendCallScore(255)
		self:setCallScoreControl(false)
	elseif TAG_ENUM.BT_YES_2 == tag then   --抢地主
--		ExternalFun.playSoundEffect( "cs3.wav", self:getParentNode():GetMeUserItem())
		self:getParentNode():sendCallScore(1)
		self:setCallScoreControl(false)
	elseif TAG_ENUM.BT_PASS == tag then         --不出
		self:onPassOutCard()
	elseif TAG_ENUM.BT_SUGGEST == tag then      --提示
		self:onPromptOut(false)
	elseif TAG_ENUM.BT_OUTCARD == tag then      --出牌
		self:onOutCard()
	elseif TAG_ENUM.BT_MULTIPLE == tag then		--加倍
		self:onMultiple(true)
		self.m_multipleControl:setVisible(false)
	elseif TAG_ENUM.BT_NO_MULTIPLE == tag then -- 不加倍
		self:onMultiple(false)
		self.m_multipleControl:setVisible(false)
	end
end

-- 加倍/不加倍
function GameViewLayer:onMultiple(isMultiple, wChairID)
	self:getParentNode():sendMultiple(isMultiple, wChairID)
end

function GameViewLayer:onOutCard()
	local sel = self.m_tabNodeCards[cmd.MY_VIEWID]:getSelectCards()
	-- 扑克对比
	self:getParentNode():compareWithLastCards(sel, cmd.MY_VIEWID)

	self.m_onGameControl:setVisible(false)
	ExternalFun.playSoundEffect( "outcard.wav" )
	--		local vec = self.m_tabNodeCards[cmd.MY_VIEWID]:outCard(sel)
	--		self:outCardEffect(cmd.MY_VIEWID, sel, vec)
	self:getParentNode():sendOutCard(sel)
	-- self:playUserAnimal(cmd.MY_VIEWID,);
	self:playUserAnimal(cmd.MY_VIEWID,"chupai", false, "wait", true);

	if cmd.MY_VIEWID == callViewId and not self:getParentNode().m_bRoundOver then
		-- self._gameView:onPromptOut(false)
			-- self._gameView:onOutCard()
	end
end

function GameViewLayer:onGetStartOutCard(bankerView)
	self.m_multipleControl:setVisible(false)
	self.m_tabStateSp[bankerView]:setSpriteFrame("blank.png")
end

-- 换桌
function GameViewLayer:changeTable()
	self.bdeleteuserdata = true
	if nil ~= self.m_scheduler then

		print("stop dispatch")

		scheduler:unscheduleScriptEntry(self.m_scheduler)

		self.m_scheduler = nil

	end
	self:stopAllActions()
	-- self.m_resultRoleNode:setVisible(false)
	-- self.m_resultRoleAni:play("reset", false)
	-- self.m_resultBgNode:setVisible(false)
	-- self.m_resultBgAni:play("reset", false)
	-- self.m_spring_ani:setLastFrameCallFunc(nil)
	local function countDown(dt)
		if self.m_tabletimer > 0 then
			self.m_tabletimer = self.m_tabletimer - 1
			self.btTable:getChildByTag(TAG_ENUM.BT_TABLETIMER):setString(string.format("(%ds)",self.m_tabletimer))
			if self.m_tabletimer == 0 then
				self.btTable:setEnabled(true)
				self.m_tabletimer = 3
				self.istable = false
				self.btTable:getChildByTag(TAG_ENUM.BT_TABLETIMER):setVisible(false)
				if nil ~= self.m_scheduler then
					print("stop dispatch")
					scheduler:unscheduleScriptEntry(self.m_scheduler)
					self.m_scheduler = nil
				end
			end
		end
	end
	if nil == self.m_scheduler then
		self.m_scheduler = scheduler:scheduleScriptFunc(countDown, 1, false)
	end
	if(self.istable) then
		return
	end
	self.istable = true
	self.btTable:setEnabled(false)
	self.btTable:getChildByTag(TAG_ENUM.BT_TABLETIMER):setVisible(true)
	self.btTable:getChildByTag(TAG_ENUM.BT_TABLETIMER):setString(string.format("(%ds)",self.m_tabletimer))
	for i = 1,cmd.PLAYER_COUNT do
		local roleItem = self.m_tabUserHead[i]
		if nil ~= roleItem then
			roleItem:removeFromParent()
			self.m_tabUserHead[i] = nil
			self.m_tab_head_info[i]:setVisible(false)
		end
		self.m_tabReadySp[i]:setVisible(false)
		self.m_tabStateSp[i]:setSpriteFrame("blank.png")
	end
	self._scene:onChangeDesk()
	self:resetTempSettle()				-- 清除结算缓存数据
	-- self.m_resultNode:setVisible(false) -- 隐藏结束界面
	-- local m_result_big = self.m_result_big
	-- for i=1,3  do
	-- 	local resultBig = m_result_big:getChildByName("result_big_" .. i)
	-- 	if nil ~= resultBig then
	-- 		resultBig:removeFromParent()
	-- 	end
	-- end
	-- m_result_big:setVisible(false)
end

function GameViewLayer:onClickReady()
--[[	self.m_btnReady:setEnabled(false)
	self.m_btnReady:setVisible(false)--]]

	self:getParentNode():sendReady()

	if self:getParentNode().m_bRoundOver then
		self:getParentNode().m_bRoundOver = false
		-- 界面清理
		self:reSetForNewGame()
	end
	-- 自己视角的叫分倒计时设置位置
--	self:setCallTimerPosition()
	self:resetTempSettle()			-- 清除结算缓存数据
	self.m_resultNode:setVisible(false) -- 隐藏结束界面
	self.btTable:setVisible(true) -- 显示换桌按钮
	-- 换桌按钮位置移动
	self.btTable:setPosition(self.begin_table_btn_pos)
--	self:onSettleInfo()
end

--- 结算详情
function GameViewLayer:onSettleInfo()
	local rs = self.m_temp_settle
	-- 结算
	if nil == self.m_resultLayer then
		self.m_resultLayer = GameResultLayer:create(self)
		self:addToRootLayer(self.m_resultLayer, TAG_ZORDER.RESULT_ZORDER)
	end
	--[[	rs = {enResult = cmd.kLanderLose,
			settles = {},
			m_lCellScore = 3,
			m_bankerscore = 3,
			m_all_multiple = 4
}
	rs.settles[1] = {
			m_userItem = self:getUserItem(cmd.MY_VIEWID),
			m_settleCoin = 13,
			m_identity = "farmer"
			}
	rs.settles[2] = {
		m_userItem = self:getUserItem(cmd.MY_VIEWID),
		m_settleCoin = 16,
		m_identity = "farmer",
		}
	rs.settles[3] = {
		m_userItem = self:getUserItem(cmd.MY_VIEWID),
		m_settleCoin = -18,
		m_identity = "lord"
		}--]]
	self.m_resultLayer:showGameResult(rs)
--	self:resetTempSettle()			-- 清除结算缓存数据
--	self.m_resultNode:setVisible(false) -- 隐藏结束界面
--[[	if not GlobalUserItem.bPrivateRoom then
		self:runAction(cc.Sequence:create(cc.DelayTime:create(2), cc.CallFunc:create(function ()
			self.m_resultLayer:showGameResult(rs)
		end)))
	else
		self.m_resultLayer:showGameResult(rs)
	end--]]
	self.open_result_layer = true
end

function GameViewLayer:resetTempSettle()
	self.m_temp_settle = nil
	self.open_result_layer = nil
end

function GameViewLayer:showLeftCards(viewId, cards)
	local last_outCard_ani_name = self.m_tab_last_outCard_ani[viewId]
	if nil ~= last_outCard_ani_name then
		self:resetOutCardAniNode(last_outCard_ani_name, viewId)
	end
	self.m_tab_last_outCard_ani[viewId] = nil
	self.m_tabNodeCards[viewId]:showLeftCards(cards)
end

-- 更新倍数
function  GameViewLayer:updateMultiple(multiple)
	self.m_atlasGameCall:setString(string.format("%d:",multiple))
end

-- 出牌效果
-- @param[outViewId]        出牌视图id
-- @param[outCards]         出牌数据
-- @param[vecCards]         扑克精灵

function GameViewLayer:outCardEffect(outViewId, outCards, vecCards)
	local controlSize = self.m_outCardsControl:getContentSize()

	-- 移除出牌
	local outCount = #outCards
	-- 计算牌型
	local cardType, value = GameLogic:GetCardType(outCards, outCount)
	if GameLogic.CT_THREE_TAKE_ONE == cardType then
		if outCount > 4 then
			cardType = GameLogic.CT_THREE_LINE
		end
	end
	if GameLogic.CT_THREE_TAKE_TWO == cardType then
		if outCount > 5 then
			cardType = GameLogic.CT_THREE_LINE
		end
	end
	local outCardAniName = "normal", order
	if cardType == GameLogic.CT_DOUBLE_LINE then
		outCardAniName = "duizi"
	elseif cardType == GameLogic.CT_THREE or cardType == GameLogic.CT_THREE_TAKE_ONE or cardType ==GameLogic.CT_THREE_TAKE_TWO then
		order = value
		outCardAniName = "sanzhang"
	elseif cardType == GameLogic.CT_SINGLE and value == 0x4F then
		outCardAniName = "ya"
	end
	if nil ~= self.m_outCardsControl:getChildByTag(outViewId) then
		local last_outCard_ani_name = self.m_tab_last_outCard_ani[outViewId]
		if nil ~= last_outCard_ani_name then
			self:resetOutCardAniNode(last_outCard_ani_name, outViewId)
		end
		self.m_outCardsControl:removeChildByTag(outViewId)
	end
	if cmd.MY_VIEWID == outViewId and outCardAniName ~= "sanzhang" and outCardAniName ~= "ya" then
		local center = outCount * 0.5
		local scale = 0.6
		local holder = cc.Node:create()
		self.m_outCardsControl:addChild(holder)
		holder:setTag(outViewId)
		holder:setPosition(self.m_tabNodeCards[outViewId]:getPosition())
		local targetPos = holder:convertToNodeSpace(cc.p(controlSize.width * 0.5, controlSize.height * 0.50))
		for k,v in pairs(vecCards) do
			v:retain()
			v:removeFromParent()
			holder:addChild(v)
			v:release()
			v:showCardBack(false)
			local pos = cc.p((k - center) * CardsNode.CARD_X_DIS * scale + targetPos.x, targetPos.y)
			local moveTo = cc.MoveTo:create(0.3, pos)
			local spa = cc.Spawn:create(moveTo, cc.ScaleTo:create(0.3, scale))
			v:stopAllActions()
			v:runAction(spa)
		end
	else
		local outCard_node, outCard_ani = self:getOutCardAniNodeByType(outCardAniName, outViewId)
		local all_card_node = outCard_node:getChildByName("all_card")
		local lordIndex = 1
		if outViewId == cmd.LEFT_VIEWID or  "sanzhang" == outCardAniName  then
			lordIndex = outCount
		end
		local holder = cc.Node:create()
		self.m_outCardsControl:addChild(holder)
		holder:setTag(outViewId)
		for k=1,outCount do
			local card_node_num = all_card_node:getChildByName("card_" .. k)
			card_node_num:setVisible(true)
			local card_node = card_node_num:getChildByName("animate"):getChildByName("sprite")
			local card = card_node:getChildByName( "card")
			local index = k
			if "reverse" == order then
				index = outCount - k + 1
			end
			v = vecCards[index]
--			local lord = card_node:getChildByName( "lord")
			v:setScale(0.61)
			v:retain()
			v:removeFromParent()
			card_node:addChild(v)
			v:setTag(k)
			v:setPosition(card:getPosition())
--			card:setVisible(false)
			if outViewId == self.m_bankerViewId and k == lordIndex then
				local sprite = cc.Sprite:create("animation/image/cardTips.png")
				sprite:setPosition(83,112)
				v:addChild(sprite)
			end
			v:release()
			v:showCardBack(false)
		end
		if outCardAniName == "sanzhang" or outCardAniName == "ya" then
			outCard_ani:gotoFrameAndPlay(0,false)
		else
			outCard_ani:play("animation_" .. #vecCards, false)
		end
		self.m_tab_last_outCard_ani[outViewId] = outCardAniName
--		outCard_ani:setLastFrameCallFunc(function()  outCard_ani:gotoFrameAndPause(0) end)
--		self:resetOutCardAniNode(outcardAniName,  #vecCards)
	end
	--print("## 出牌类型")
	--print(cardType)
	--print("## 出牌类型")
	local headitem = self.m_tabUserHead[outViewId]
	if nil == headitem then
		return
	end

	--牌型音效
	local bCompare = self:getParentNode().m_bLastCompareRes
	if GameLogic.CT_SINGLE == cardType then
		-- 音效
		local poker = yl.POKER_VALUE[outCards[1]]
		if nil ~= poker then
			ExternalFun.playSoundEffect(poker .. ".wav", headitem.m_userItem)
		end
		if "ya" == outCardAniName then
			ExternalFun.playSoundEffect( "ya.wav" )
		end
	elseif GameLogic.CT_DOUBLE == cardType then
		-- 音效
		local poker = yl.POKER_VALUE[outCards[1]]
		if nil ~= poker then
			ExternalFun.playSoundEffect("d_" .. poker .. ".wav", headitem.m_userItem)
		end
	elseif GameLogic.CT_THREE == cardType then
				-- 音效
		local poker = yl.POKER_VALUE[outCards[1]]
		if nil ~= poker then
			ExternalFun.playSoundEffect("t_" .. poker .. ".wav", headitem.m_userItem)
		end
	else
		-- 音效
		ExternalFun.playSoundEffect( "type" .. cardType .. ".wav", headitem.m_userItem)
	end

	self.m_rootLayer:removeChildByName("__effect_ani_name__")

	if GameLogic.CT_THREE_LINE == cardType then     --        -- 飞机
		self.m_timeAnimation:play("feiji",true)
		ExternalFun.playSoundEffect( "outcard_aircraft.wav" )
	elseif GameLogic.CT_BOMB_CARD == cardType then          -- 炸弹
	--	self.m_special_card_ani:play("bomb", false)
		local srcFile = "zhandan"
	  	local aniName = "zahdandonghua"
	  	local spr = self:createGameAnimation(srcFile,aniName,nil,0,nil,nil,nil, panel)
	  	spr:setPosition(cc.p(display.width/2-200,280))
	  	spr:setName("zahdandonghua")
	  	self.m_special_card_node:addChild(spr)
		ExternalFun.playSoundEffect( "outcard_bomb.wav" )
	elseif GameLogic.CT_MISSILE_CARD == cardType then       -- 火箭
		local srcFile = "zhandan"
		local aniName = "wangzhadonghua"
		local spr = self:createGameAnimation(srcFile,aniName,nil,0,nil,nil,nil, panel)
		spr:setPosition(cc.p(display.width/2,320))
		self.m_special_card_node:addChild(spr)
		spr:setName("wangzhadonghua")
		ExternalFun.playSoundEffect( "outcard_rocket.wav" )
	elseif GameLogic.CT_SINGLE_LINE == cardType then			-- 顺子
		self.m_special_card_ani:play("shunzi", false)
	elseif GameLogic.CT_DOUBLE_LINE == cardType then			-- 连对
		self.m_special_card_ani:play("liandui", false)
	end
end

--xmlName 动画文件名 [必须]
--aniName 动画元件名  [必须]
--actName 动作名 默认动作play
--speed 播放速度 (< 1 慢) ( 1 正常)
--callfunc 动作回调
--parent 父节点
--pos 位置
--loop 1 循环 0 不循环
function GameViewLayer:createGameAnimation(xmlName,aniName,actName,loop,callfunc,speed,pos,parent)
	if not loop then loop = 0 end
	if not speed then speed = 0.4 end
	if not actName then actName = "play" end
	local pngStr = "animation/"..xmlName..".png"
    local plistStr = "animation/"..xmlName..".plist"
    local xmlStr = "animation/"..xmlName..".xml"
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(pngStr,plistStr,xmlStr)
    local spr = ccs.Armature:create(aniName)
    local ani = spr:getAnimation()
    ani:setSpeedScale(speed)
    ani:play(actName,-1,loop)
    if loop == 0 then
	    ani:setMovementEventCallFunc(function(armature, ntype, mentname)
	    	if ntype == ccs.MovementEventType.complete then
	    		if mentname == actName then
	    			if not callfunc then
	    				armature:removeFromParent()
	    			else
	    				callfunc()
	    			end			
	    		end
	    	end
	    end);
    end
    spr:setAnchorPoint(cc.p(0.5,0.5))
    if pos then
    	spr:setPosition(pos)
    end
    if parent then
    	parent:addChild(spr)
    end
    return spr
	-- body
end

function GameViewLayer:onChangePassBtnState( bEnable )
	self.m_btnPass:setEnabled(bEnable)
	if bEnable then
		self.m_btnPass:setOpacity(255)
	else
		self.m_btnPass:setOpacity(0)
	end
end

function GameViewLayer:onPassOutCard()
	self:getParentNode():sendOutCard({}, true)
	self.m_tabNodeCards[cmd.MY_VIEWID]:reSetCards()
	self.m_onGameControl:setVisible(false)
	-- 提示
	self.m_spInfoTip:setSpriteFrame("blank.png")
	self:playUserAnimal(cmd.MY_VIEWID,"buyao", false, "wait", true);

--[[	-- 显示不出 --随机显示不出/过
	local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame("guo_" .. math.random(0,1) ..".png")
	if nil ~= frame then
		self.m_tabStateSp[cmd.MY_VIEWID]:setSpriteFrame(frame)
	end

	-- 音效
	ExternalFun.playSoundEffect( "pass" .. math.random(0, 1) .. ".wav", self:getParentNode():GetMeUserItem())--]]
end

function GameViewLayer:getUserItem( viewId )
	if nil ~= self.m_tabUserHead[viewId] then
		return self.m_tabUserHead[viewId].m_userItem
	end
	return
end

function GameViewLayer:getUserHead(viewId)
	if nil ~= self.m_tabUserHead[viewId] then
		return self.m_tabUserHead[viewId].m_popHead
	end
	return
end

-- 隐藏换桌按钮
function GameViewLayer:hideChangeTable(isVisible)
	self.btTable:setVisible(isVisible)
end

-- 设置闹钟位于叫分位置
function GameViewLayer:setCallTimerPosition()
--	local call_score_clock = self.m_callScoreControl:getChildByName("score_clock_" .. cmd.MY_VIEWID)
--	self.m_tabTimerPos[cmd.MY_VIEWID] = cc.p(call_score_clock:getPositionX(),call_score_clock:getPositionY())
end

------
-- 扑克代理

-- 扑克状态变更
-- @param[cbCardData]       扑克数据
-- @param[status]           状态(ture:选取、false:非选取)
-- @param[cardsNode]        扑克节点
function GameViewLayer:onCardsStateChange( cbCardData, status, cardsNode )

end

-- 扑克选择
-- @param[selectCards]      选择扑克
-- @param[cardsNode]        扑克节点
function GameViewLayer:onSelectedCards( selectCards, cardsNode )
	-- 出牌对比
	local outCards = self:getParentNode().m_tabCurrentCards
	local outCount = #outCards

	local selectCount = #selectCards
	local selectType = GameLogic:GetCardType(selectCards, selectCount)

	local enable = false
	local opacity = 125

	if 0 == outCount then
		if true == self.m_bCanOutCard and GameLogic.CT_ERROR ~= selectType then
			enable = true
			opacity = 255
		end
	elseif GameLogic:CompareCard(outCards, outCount, selectCards, selectCount) and true == self.m_bCanOutCard then
		enable = true
		opacity = 255
	end

	self.m_btnOutCard:setEnabled(enable)
	self.m_btnOutCard:setOpacity(opacity)
end

-- 牌数变动
-- @param[outCards]         出牌数据
-- @param[cardsNode]        扑克节点
function GameViewLayer:onCountChange( count, cardsNode, isOutCard )
	isOutCard = isOutCard or false
	local viewId = cardsNode.m_nViewId
	if nil ~= self.m_tabCardCount[viewId] then
		self.m_tabCardCount[cardsNode.m_nViewId]:setVisible(true)
		self.m_tabCardCount[cardsNode.m_nViewId]:getChildByName("atlas_count"):setString(count .. "")
	end
	if count <= 2  and isOutCard then
--[[		local param = AnimationMgr.getAnimationParam()
		param.m_fDelay = 0.1
		param.m_strName = Define.ALARM_ANIMATION_KEY
		local animate = AnimationMgr.getAnimate(param)
		local rep = cc.RepeatForever:create(animate)
		self.m_tabSpAlarm[viewId]:runAction(rep)--]]

		-- 音效
		local headitem = self.m_tabUserHead[viewId]
		if nil == headitem then
			return
		end
		ExternalFun.playSoundEffect("baojing" .. count .. ".wav", headitem.m_userItem)
	end
end

------
-- 扑克代理

-- 提示出牌
-- @param[bOutCard]        是否出牌
function GameViewLayer:onPromptOut( bOutCard )
	bOutCard = bOutCard or false
	if bOutCard then
		local promptCard = self:getParentNode().m_tabPromptCards
		local promptCount = #promptCard
		if promptCount > 0 then
			promptCard = GameLogic:SortCardList(promptCard, promptCount, 0)

			-- 扑克对比
			self:getParentNode():compareWithLastCards(promptCard, cmd.MY_VIEWID)

			local vec = self.m_tabNodeCards[cmd.MY_VIEWID]:outCard(promptCard)
			self:outCardEffect(cmd.MY_VIEWID, promptCard, vec)
			self:getParentNode():sendOutCard(promptCard)
			self.m_onGameControl:setVisible(false)
		else
			self:onPassOutCard()
		end
	else
		if 0 >= self.m_promptIdx then
			self.m_promptIdx = #self:getParentNode().m_tabPromptList
		end

		if 0 ~= self.m_promptIdx then
			-- 提示回位
			local sel = self.m_tabNodeCards[cmd.MY_VIEWID]:getSelectCards()
			if #sel > 0
				and self.m_tabNodeCards[cmd.MY_VIEWID].m_bSuggested
				and #self:getParentNode().m_tabPromptList > 1 then
				self.m_tabNodeCards[cmd.MY_VIEWID]:suggestShootCards(sel)
			end
			-- 提示扑克
			local prompt = self:getParentNode().m_tabPromptList[self.m_promptIdx]
			print("## 提示扑克")
			for k,v in pairs(prompt) do
				print(yl.POKER_VALUE[v])
			end
			print("## 提示扑克")
			if #prompt > 0 then
				self.m_tabNodeCards[cmd.MY_VIEWID]:suggestShootCards(prompt)
			else
				self:onPassOutCard()
			end
			self.m_promptIdx = self.m_promptIdx - 1
			-- if 
		else
			self:onPassOutCard()
		end
	end
end

--[[function GameViewLayer:onGameTrusteeship( bTrusteeship )
	self.m_trusteeshipControl:setVisible(bTrusteeship)
	if bTrusteeship then
		if self.m_bMyCallBanker then
			self.m_bMyCallBanker = false
			self.m_callScoreControl:setVisible(false)
			self:getParentNode():sendCallScore(255)
		end

		if self.m_bMyOutCards then
			self.m_bMyOutCards = false
			self:onPromptOut(true)
		end
		local useritem = self:getUserItem(cmd.MY_VIEWID)
		useritem.robotFaceID = 999			--- 机器人头像ID
		local head = self:getUserHead(cmd.MY_VIEWID)
		head:updateHead( useritem )
	else
		local useritem = self:getUserItem(cmd.MY_VIEWID)
		if nil ~= useritem then
			useritem.robotFaceID = nil
			local head = self:getUserHead(cmd.MY_VIEWID)
			head:updateHead( useritem )
		end
	end
end--]]
-- function GameViewLayer:UserTrustee( bTrustee )
-- 	-- body
-- 	local bTrusteee = true
-- 	if bTrustee then
-- 		bTrusteee=false
-- 		self:onPromptOut(bTrusteee)
-- 		self:onOutCard()
-- 	else
-- 		-- bTrusteee=true
-- 	end

-- end

-- 设置托管视图
function GameViewLayer:setUserTrustee(viewId, bTrustee)
	local head_info = self.m_tab_head_info[viewId]
	local robot_sprite_name = head_info:getChildByName("robot")
	if bTrustee then
		if nil == robot_sprite_name then
			local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame("robot.png")
			if nil ~= frame then
				sprite = cc.Sprite:createWithSpriteFrame(frame)
			end
	--		local sprite = cc.Sprite:create("robot.png")
			sprite:setPosition(head_info:getChildByName("head_bg"):getPosition())
			sprite:setName("robot")
			head_info:addChild(sprite)
		end

	else
		local robot_sprite_name = head_info:getChildByName("robot")
		if nil ~= robot_sprite_name then
			robot_sprite_name:removeFromParent()
		end
	end
	if viewId == cmd.MY_VIEWID then
		self.m_trusteeshipControl:setVisible(bTrustee)
	end
end
-- function GameViewLayer:UserTrustee(viewId, bTrustee)
-- 	if bTrustee then

-- 	end
-- 	if viewId == cmd.MY_VIEWID then
-- 		self.m_trusteeshipControl:setVisible(bTrustee)
-- 	end
-- 	-- body
-- end


-- 重置所有机器人
function GameViewLayer:resetAllTrustee()
	for i=1, 3  do
		self:setUserTrustee(i, false)
	end
end


function GameViewLayer:onMore()
-- 	self.moreAni = ExternalFun.loadTimeLine( "game/MoreLayerNew.csb" )
-- 	local moreAni = self.moreAni
-- --	ExternalFun.SAFE_RETAIN(moreAni)
-- 	local m_moreNode = self.m_moreNode
-- 	moreAni:play("enterAni", false)	-- true循环播放
-- --	--	moreAni:gotoFrameAndPlay(0,false) -- 去第0帧开始播放,true循环播放
-- 	m_moreNode:runAction(moreAni)
-- 	-- 隐藏更多按钮
-- 	self.m_btnMore:setEnabled(false)
-- 	self.m_btnMore:setVisible(false)
-- 	-- 显示其他按钮
-- 	self.m_btnBackMore:setEnabled(true)
-- 	self.m_btnBackMore:setVisible(true)
end

function GameViewLayer:onBackMore()
	-- if self.moreAni then
	-- 	local moreAni = self.moreAni:clone()
	-- 	local m_moreNode = self.m_moreNode
	-- 	moreAni:play("exitAni", false)	-- true循环播放
	-- 	m_moreNode:runAction(moreAni)
	-- 	-- 显示更多按钮
	-- 	self.m_btnMore:setEnabled(true)
	-- 	self.m_btnMore:setVisible(true)
	-- 	-- 隐藏其他按钮
	-- 	self.m_btnBackMore:setEnabled(false)
	-- 	self.m_btnBackMore:setVisible(false)
	-- end
end

function GameViewLayer:updateCardLeftCount(cardLeftCount)

   --   for i = 1, 15 do
   --      if cardLeftCount[i] > 0 then
   --          self.m_cardLeftCountLabel[i]:setText(string.format("%d",cardLeftCount[i]))
   --      else
   --          self.m_cardLeftCountLabel[i]:setText("")
   --      end
	 -- end

end

function GameViewLayer:updateClock( clockId, cbTime)
	self.m_atlasTimer:setString( string.format("%02d", cbTime ))
	if cbTime <= 0 then
		if cmd.TAG_COUNTDOWN_READY == clockId then
			--退出防作弊
			self:getParentNode():getFrame():setEnterAntiCheatRoom(false)
--			self._scene:sendUserTrustee(true)
--[[		elseif cmd.TAG_COUNTDOWN_CALLSCORE == clockId then
			-- 私人房无自动托管
			if not GlobalUserItem.bPrivateRoom then
				self:onGameTrusteeship(true)
			end
		elseif cmd.TAG_COUNTDOWN_OUTCARD == clockId then
			-- 私人房无自动托管
			if not GlobalUserItem.bPrivateRoom then
				self:onGameTrusteeship(true)
			end--]]
		elseif cmd.TAG_COUNTDOWN_PASS  == clockId then
			self:onPassOutCard()
		end
	elseif cbTime <= 2 then
		--self.m_csbNode:stopAllActions()
		if self.clockViewId == cmd.MY_VIEWID and cmd.TAG_COUNTDOWN_READY == clockId then
			if self.open_result_layer and cmd.TAG_COUNTDOWN_READY == clockId then
				self.m_resultLayer:updateClock(clockId, cbTime)
			else
				self.m_timeAnimation:play("clock_animation_" .. self.clockViewId .. "_4", true)
			end
		else
			self.m_timeAnimation:play("clock_animation_" .. self.clockViewId .. "_2", true)
		end
	elseif cbTime <= 5 then
		--self.m_csbNode:stopAllActions()
		if self.clockViewId == cmd.MY_VIEWID and cmd.TAG_COUNTDOWN_READY == clockId then
			if self.open_result_layer and cmd.TAG_COUNTDOWN_READY == clockId then
				self.m_resultLayer:updateClock(clockId, cbTime)
			else
				self.m_timeAnimation:play("clock_animation_" .. self.clockViewId .. "_3", true)
			end
		else
			self.m_timeAnimation:play("clock_animation_" .. self.clockViewId .. "_1", true)
		end
	elseif cbTime > 5 then
		if self.clockViewId == cmd.MY_VIEWID and cmd.TAG_COUNTDOWN_READY == clockId then
			if self.open_result_layer and cmd.TAG_COUNTDOWN_READY == clockId then
				self.m_resultLayer:updateClock(clockId, cbTime)
			else
				self.m_timeAnimation:play("clock_normal_" .. self.clockViewId .. "_2" , true)
			end
	    else
			self.m_timeAnimation:play("clock_normal_" .. self.clockViewId , true)
		end
	end
end

function GameViewLayer:OnUpdataClockView( viewId, cbTime ,clockId)
	print("-----------------------@@@@@@@%%%%%%%%%%OnUpdataClockView","viewId:",viewId,"cbTime:",cbTime)
	local isVisible = cbTime ~= 0
--	self.m_spTimer:setVisible(isVisible)
--	self.m_atlasTimer:setVisible(isVisible)
	if isVisible == false and nil ~= self.m_timeAnimation then
		self.m_timeAnimation:play("reset", false)
	end
	self.m_atlasTimer:setString( string.format("%02d", cbTime ))

	if self:getParentNode():IsValidViewID(viewId) then
		self.clockViewId = viewId
--		self.m_spTimer:setPosition(self.m_tabTimerPos[viewId])
--		self.m_atlasTimer:setPosition(self.m_tabTimerPos[viewId])
	end
	self: updateClock( clockId, cbTime)
end
				------------------------------------------------------------------------------------------------------------
--更新
				------------------------------------------------------------------------------------------------------------

-- 文本聊天
function GameViewLayer:onUserChat(chatdata, viewId)
	local roleItem = self.m_tabUserHead[viewId]
	if nil ~= roleItem then
		roleItem:textChat(chatdata.szChatString)
	end
end

-- 表情聊天
function GameViewLayer:onUserExpression(chatdata, viewId)
	local roleItem = self.m_tabUserHead[viewId]
	if nil ~= roleItem then
		roleItem:browChat(chatdata.wItemIndex)
	end
end

--[[function GameViewLayer:onUserEnter(viewid, userItem)
	self:onClickReady()
	self:OnUpdateUser(viewid, useritem)
end--]]

--更新用户显示
function GameViewLayer:OnUpdateUserStatus(viewId)
	local roleItem = self.m_tabUserHead[viewId]
	if nil ~= roleItem then
		roleItem:removeFromParent()
		self.m_tabUserHead[viewId] = nil
	end
	self.m_tab_head_info[viewId]:setVisible(false)
	self.m_tabReadySp[viewId]:setVisible(false)
	self.m_tabStateSp[viewId]:setSpriteFrame("blank.png")
end

-- 用户更新
function GameViewLayer:OnUpdateUser(viewId, userItem, bLeave)
-- 		--过滤观看
	if userItem ~= nil  then
		if userItem.cbUserStatus == yl.US_LOOKON then
			return
		end
	end
	print(" update user " .. viewId)
	if self.bdeleteuserdata ==  true then
		for i = 1,cmd.PLAYER_COUNT do
			local roleItem = self.m_tabUserHead[i]
			if nil ~= roleItem then
				roleItem:removeFromParent()
				self.m_tabUserHead[i] = nil
				self.m_tab_head_info[i]:setVisible(false)
			end
			self.m_tabReadySp[i]:setVisible(false)
			self.m_tabStateSp[i]:setSpriteFrame("blank.png")
		end
	end
	self.bdeleteuserdata = false
	if bLeave then
		local roleItem = self.m_tabUserHead[viewId]
		if nil ~= roleItem then
			roleItem:removeFromParent()
			self.m_tabUserHead[viewId] = nil
			self.m_tab_head_info[viewId]:setVisible(false)
			self.m_tabUserNode[viewId]:setVisible(false);

		end
		self:onUserReady(viewId, false)
	end
	local bHide = ((table.nums(self.m_tabUserHead)) == (self:getParentNode():getFrame():GetChairCount()))
	if not GlobalUserItem.bPrivateRoom then
		self.m_btnInvite:setVisible(not bHide)
		self.m_btnInvite:setEnabled(not bHide)
	end
	self.m_btnInvite:setVisible(false)
	self.m_btnInvite:setEnabled(false)

	if nil == userItem then
		return
	end
	self.m_tabUserItem[viewId] = userItem

	local bReady = userItem.cbUserStatus == yl.US_READY
	self:onUserReady(viewId, bReady)
	local head_info = self.m_tab_head_info[viewId]

	local tabUserHead = self.m_tabUserHead[viewId]
	if not tabUserHead or tabUserHead.m_userItem.dwGameID ~= userItem.dwGameID then
		local roleItem = GameRoleItem:create(userItem, viewId)
		local x,y = head_info:getChildByName("head_bg"):getPosition()
		roleItem:setPosition(cc.p(x+8,y+4))     -- 位置校正
		if tabUserHead then
			tabUserHead:removeFromParent()
		end
		head_info:addChild(roleItem)

		-- 头像外层多加一层，美化作用
		local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame("head_frame.png")
		if nil ~= frame then
			local sprite = cc.Sprite:createWithSpriteFrame(frame)
			sprite:setPosition(x,y)
			head_info:addChild(sprite)
		end

		self.m_tabUserHead[viewId] = roleItem
		self.m_tab_head_info[viewId]:setVisible(false)
		self:resetHeadByViewId(viewId)


		head_info:getChildByName("head_bg"):setVisible(false);

		-- stopUserAnimal
		-- self:playUserAnimal()
		self.m_tabUserNode[viewId]:setVisible(true);
		self:playUserAnimal(cmd.MY_VIEWID, "wait",false);

		-- showToast()
		-- showToast(self, "分享成功"..viewId, 2)
		-- self:playUserAnimal(viewId, "wait",true);
		-- self.m_tabUserNode[viewId]:setVisible(true);

--		self.m_userinfoControl:addChild(roleItem)
		--
		if viewId ~= cmd.MY_VIEWID then
			head_info:setVisible(false)
		end
-- --[[		--	设置艺术字体
-- 		local tmpText = cc.LabelAtlas:_create("12", "game/result_add.png", 25, 33, string.byte('.'))
-- 		head_info:addChild(tmpText)
-- 		tmpText:setPosition(cc.p(150,50))
-- 		tmpText:setString("123")--]]
	end
	if not bLeave then
		self.m_tab_head_info[viewId]:setVisible(true)
		self.m_tabUserNode[viewId]:setVisible(true);
		self:playUserAnimal(viewId, "wait",true);
	end
	-- 显示ID
	head_info:getChildByName("nick_text"):setString("ID: " .. userItem.dwGameID)
--[[		local scoreStr = string.formatNumberThousands(userItem.lScore,true,"/")
	if string.len(scoreStr) > 11 then
		scoreStr = string.sub(scoreStr, 1, 11) .. "..."
	end--]]
	local scoreStr, unit = ExternalFun.formatScoreUnit(userItem.lScore)
	local scoreStr = userItem.lScore
	local score_atlas = head_info:getChildByName("score_atlas")
	score_atlas:setString(string.formatNumberFhousands(scoreStr))
	if nil ~= unit then
		local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame("game_" .. unit .. ".png")
		if nil ~= frame then
			head_info:removeChildByName("unit")
			local sprite = cc.Sprite:createWithSpriteFrame(frame)
			sprite:setScale(0.7)
			sprite:setPosition(cc.p(score_atlas:getPositionX() + string.len(scoreStr)/2*25*0.8, score_atlas:getPositionY()))
			sprite:setName("unit")
			head_info:addChild(sprite)
		end
	end
	self.m_tabUserHead[viewId].m_userItem = userItem
	self.m_tabUserHead[viewId]:updateStatus()
	if cmd.MY_VIEWID == viewId then
		self:reSetUserInfo()
	end
end

function GameViewLayer:onUserReady(viewId, bReady)
	--用户准备
	if bReady then
		local readySp = self.m_tabReadySp[viewId]
		if nil ~= readySp then
			readySp:setVisible(true)
		end
	else
		local readySp = self.m_tabReadySp[viewId]
		if nil ~= readySp then
			readySp:setVisible(false)
		end
	end
end

function GameViewLayer:onGetCellScore( score )
	score = score or 0
--[[	local str = ""
	if score < 0 then
		str = "." .. score
	else
		str = "" .. score
	end
	if string.len(str) > 11 then
		str = string.sub(str, 1, 11)
		str = str .. "///"
	end--]]
	score = string.formatNumberFhousands(score)
	self.m_atlasDiFeng:setString(score)
end

function GameViewLayer:onGetGameFree()
--[[	if false == self:getParentNode():getFrame().bEnterAntiCheatRoom then
		self.m_btnReady:setEnabled(true)
		self.m_btnReady:setVisible(true)
	end--]]
end

function GameViewLayer:resetTip()
	self.m_spInfoTip:setSpriteFrame("blank.png")
	for k,v in pairs(self.m_tabStateSp) do
		v:stopAllActions()
		v:setSpriteFrame("blank.png")
	end
end

function GameViewLayer:onGameStart()
	self.m_nMaxCallScore = 0
	self.m_atlasGameCall:setString("")
	for k,v in pairs(self.m_tabBankerCard) do
		v:setVisible(false)
		v:setCardValue(0)
	end
	self:resetTip()
	self.temp_tru_btn:setVisible(true)
	for k,v in pairs(self.m_tabCardCount) do
		-- 显示剩余牌数
		v:setVisible(true)
		v:getChildByName("atlas_count"):setString("")
	end
	self.m_promptIdx = 0
	-- 退出按钮置灰，不能点
	self:setQuitEnable(false)
	-- 隐藏换桌按钮
	self.btTable:setVisible(false)

	-- 重置身份标记/地主状态
	self:resetAllHead()
	-- 播放斗起来动画

	-- self:setUserAnimal(0);



end

function GameViewLayer:setQuitEnable(isEnable)
	-- 退出按钮置灰，不能点
	-- self.m_btn_back:setEnabled(isEnable)
	-- local opacity = 125
	-- if isEnable then
	-- 	opacity = 255
	-- end
	-- self.m_btn_back:setOpacity(opacity)
end

-- 获取到扑克数据
-- @param[viewId] 界面viewid
-- @param[cards] 扑克数据
-- @param[bReEnter] 是否断线重连
-- @param[pCallBack] 回调函数
function GameViewLayer:onGetGameCard(viewId, cards, bReEnter)
	if bReEnter then
		print(viewId)
		self.m_tabNodeCards[viewId]:updateCardsNode(cards, (viewId == cmd.MY_VIEWID), false)
	else
		-- if nil ~= pCallBack then
		-- 	pCallBack:retain()
		-- end
		local call = cc.CallFunc:create(function ()
			-- 非自己扑克
			local empTyCard = GameLogic:emptyCardList(cmd.NORMAL_COUNT)
			self.m_tabNodeCards[cmd.LEFT_VIEWID]:updateCardsNode(empTyCard, false, false)
			empTyCard = GameLogic:emptyCardList(cmd.NORMAL_COUNT)
			self.m_tabNodeCards[cmd.RIGHT_VIEWID]:updateCardsNode(empTyCard, false, false)
			-- 自己扑克
			self.m_tabNodeCards[cmd.MY_VIEWID]:updateCardsNode(cards, true, false)

			-- 庄家扑克
			-- 50 525
			-- 50 720
			for k,v in pairs(self.m_tabBankerCard) do
				v:setVisible(true)
			end
		end)
	
		--local seq = cc.Sequence:create(call2, cc.DelayTime:create(0.3), call)
		ExternalFun.playSoundEffect("dispatch.wav" )
		local ani = self:playAnimation("animation/fapai/fapai",33,false,self.cardActionNode,call)
    	ani:setPosition(cc.p(display.width * 0.5, 270))
    	ani:setAnchorPoint(cc.p(0.5, 0.5))
	end
end



function GameViewLayer:playAnimation(flaName, frameNum,loop, parent,callback)
	local src = flaName.."0001.png"
    local srcBase = flaName.."%04d.png"
    local image = cc.Sprite:create(src)
    image:setAnchorPoint(cc.p(0,0))
    image:setPosition(cc.p(0,0))
    local cache = cc.SpriteFrameCache:getInstance()
    local animation =  cc.Animation:create()
    --GameDump(src)
    for i = 1,frameNum do 
        local frame = string.format(srcBase, i)
        animation:addSpriteFrameWithFile(frame)
    end 
    animation:setDelayPerUnit(0.05)

    local action 
    if not loop then
    	action = cc.Sequence:create(cc.Animate:create(animation),cc.RemoveSelf:create(),callback)
    else
    	action = cc.RepeatForever:create(cc.Animate:create(animation))
    end

    image:runAction(action)

    if parent then
    	parent:addChild(image)
    	--image:setPosition(cc.p(parent:getPositionX()/2,parent:getPositionY()/2))
    end
    return image
	-- body
end

function  GameViewLayer:onGetOtherCards(viewId, oldCards)
	self.m_tabNodeOtherCards[viewId]:removeAllChildren()
	local count = #oldCards
	local center = count * 0.5
	local real_card_x_dis = 20
	local cards = GameLogic:SortCardList(oldCards, count, 0)
	local realCount = 1
	for i=1, #cards do
		if cards[i] ~= 0 then
			local tmpSp = CardSprite:createCard(cards[i])
			local pos = cc.p((realCount - center) * real_card_x_dis, 0)
			tmpSp:setPosition(pos)
			tmpSp:showSelectEffect(false)
			tmpSp:setDispatched(false)
			tmpSp:showCardBack(false)
			tmpSp:setScale(0.3)
			tmpSp:stopAllActions()
			self.m_tabNodeOtherCards[viewId]:addChild(tmpSp)
			realCount = realCount + 1
		end
	end
end

-- 加倍判断
function GameViewLayer:onSubStartMultiple(lEnterScore)
	self.m_multipleControl:setVisible(true)
	if lEnterScore and self.m_tabUserItem[cmd.MY_VIEWID].lScore >= 50*lEnterScore then
		self.m_btnNoMultiple:setVisible(true)
		self.m_btnMultiple:setVisible(true)
		self.m_multipleControl:getChildByName("multiple_not_enough"):setVisible(false)
		return true
	end
	self.m_multipleControl:getChildByName("multiple_not_enough"):setVisible(true)
	self:onMultiple(false)
end

-- 获取到玩家加倍
function GameViewLayer:onGetMultiple(multipleViewId, isMultiple, callScore)
	local pngName = "jiabei.png"
	local wavName = "jiabei.wav"
	if not isMultiple then
		pngName = "bujiabei.png"
		wavName = "bujiabei.wav"
	end
	local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame(pngName)
	if nil ~= frame then
		self.m_tabStateSp[multipleViewId]:setSpriteFrame(frame)
	end
	if isMultiple then
		local aniScore = 2
		local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame("x" .. aniScore .. ".png")
		local beishu = ExternalFun.getChildRecursiveByName(self.m_beishu_node, "beishu")
		if nil ~= frame then
			beishu:setSpriteFrame(frame)
			self.m_beishu_ani:gotoFrameAndPlay(0, false)
		end
		self.m_atlasGameCall:setString(callScore .. "")
	end
	local headitem = self.m_tabUserHead[multipleViewId]
	if headitem then
		ExternalFun.playSoundEffect(wavName, headitem.m_userItem)
	end
end

-- 获取到玩家叫分
-- @param[callViewId]   当前叫分玩家
-- @param[lastViewId]   上个叫分玩家
-- @param[callScore]    当前叫分分数
-- @param[lastScore]    上个叫分分数
-- @param[bReEnter]     是否断线重连
function GameViewLayer:onGetCallScore( callViewId, lastViewId, callScore, lastScore, bReEnter, lastViewFirstScore )
	--print("%%%%%%%%%%%%%%%%%%%%%%lastScore--------------------:",lastScore)
	print("当前到叫分~~~~~~~~~"..callViewId)
	bReEnter = bReEnter or false
	local waveName
	if 255 == lastScore then
		--print("不叫")
		-- 不叫
		local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame("pass.png")
		waveName = "bujiao"
		if callScore >= 3 then
			waveName = "buqiang"
			frame = cc.SpriteFrameCache:getInstance():getSpriteFrame("buqiang.png")
		end
		if nil ~= frame then
			self.m_tabStateSp[lastViewId]:setSpriteFrame(frame)
			
		end
	elseif lastScore > 0 and lastScore < 4 then
		local aniScore = 3
		waveName = "jiaodizhu"
		if callScore > 3 then
			aniScore = 2
			waveName = "qiang_1"
			if lastViewFirstScore == 1 then
				waveName = "qiang_2"
			end
		end
		local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame("x" .. aniScore .. ".png")
		-- 播放叫分动画
		if bReEnter then
			if nil ~= frame then
				self.m_tabStateSp[lastViewId]:setSpriteFrame(frame)
			end
		else
			local beishu = ExternalFun.getChildRecursiveByName(self.m_beishu_node, "beishu")
			if nil ~= frame then
				beishu:setSpriteFrame(frame)
				self.m_beishu_ani:gotoFrameAndPlay(0, false)
			end
		end
		self.m_atlasGameCall:setString(callScore .. "")
	end
	local headitem = self.m_tabUserHead[lastViewId]
	if nil ~= headitem and not bReEnter and waveName then
		-- 音效
		ExternalFun.playSoundEffect(waveName .. ".wav", headitem.m_userItem)
	end

	lastScore = (lastScore > 3) and 0 or lastScore
	if lastScore > self.m_nMaxCallScore then
		self.m_nMaxCallScore = lastScore
	end
	if cmd.MY_VIEWID == lastViewId then
		self:setCallScoreControl(false)
	end
	if not self:getParentNode():IsValidViewID(callViewId) then
		return
	end
	self.m_bMyCallBanker = (cmd.MY_VIEWID == callViewId)
	if cmd.MY_VIEWID == callViewId and not self:getParentNode().m_bRoundOver then
		-- 托管不叫
--[[		if self.m_trusteeshipControl:isVisible() then
			self:onGameTrusteeship(false)
			self:getParentNode():sendCallScore(0)
		else--]]
			self.m_spInfoTip:setSpriteFrame("blank.png")
--[[			-- 计算叫分
			local maxCall = self.m_nMaxCallScore + 1
			for i = 2, #self.m_tabCallScoreBtn do
				local btn = self.m_tabCallScoreBtn[i]
				btn:setEnabled(true)
				btn:setOpacity(255)
				if i <= maxCall  then
					btn:setEnabled(false)
					btn:setOpacity(125)
				end
			end--]]
			local callIndex = 1
			if callScore > 0 then
				callIndex = 2
			end
			print("自己~~~~~~~~~~~~~~~")
			self.m_tabCallScoreBtn[callIndex]:setVisible(true)
			self.m_tabCallScoreBtn[callIndex]:setEnabled(true)
			self.m_tabNotCallBtn[callIndex]:setVisible(true)
			self.m_tabNotCallBtn[callIndex]:setEnabled(true)
			self.m_callScoreControl:setVisible(true)
--		end
	else
		if not bReEnter and not self:getParentNode().m_bRoundOver then
			-- 等待叫分
			self.m_spInfoTip:setPosition(yl.WIDTH * 0.5, 375)
--			self.m_spInfoTip:setSpriteFrame("game_tips_01.png")
		end
	end
end


-- 获取到庄家信息
-- @param[bankerViewId]         庄家视图id
-- @param[cbBankerScore]        庄家分数
-- @param[bankerCards]          庄家牌
-- @param[bReEnter]             是否断线重连
function GameViewLayer:onGetBankerInfo(bankerViewId, cbBankerScore, bankerCards, bReEnter)
	bReEnter = bReEnter or false
	self.m_bMyCallBanker = false
	-- 更新庄家扑克
	if 3 == #bankerCards then
		for k,v in pairs(bankerCards) do
			self.m_tabBankerCard[k]:setVisible(true)
			self.m_tabBankerCard[k]:setCardValue(v)
		end
	end
	-- 叫分
	self.m_atlasGameCall:setString(cbBankerScore .. "")
	-- 确定庄家m
	-- 切换自己视角时钟位置到中间
--	local outcard_clock = self.m_onGameControl:getChildByName("outcard_clock_" .. cmd.MY_VIEWID)
--	self.m_tabTimerPos[cmd.MY_VIEWID] = cc.p(outcard_clock:getPositionX(),outcard_clock:getPositionY())
	-- 设置地主标志
	-- 身份帽子
	for k,v in pairs(self.m_tab_head_info) do
		local identity_hat = v:getChildByName("identity_hat")
		if (k == bankerViewId) then
			-- local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame("lord_image.png")
			-- if nil ~= frame then
			-- 	identity_hat:setSpriteFrame(frame)
			-- end
			v:getChildByName("lord_mask"):setVisible(true)
		end
--		identity_hat:setGlobalZOrder(999)				-- 地主/农民的帽子放在最上层
		  identity_hat:setVisible(false)
	end

	-- 庄家切换
	--[[    for k,v in pairs(self.m_tabUserHead) do
	v:switeGameState(k == bankerViewId)

	self.m_tabStateSp[k]:stopAllActions()
	self.m_tabStateSp[k]:setSpriteFrame("blank.png")
end--]]

	if false == bReEnter then
		-- 庄家增加牌
		local handCards = self.m_tabNodeCards[bankerViewId]:getHandCards()
		local count = #handCards
		if bankerViewId == cmd.MY_VIEWID then
			self.m_tabNodeCards[cmd.MY_VIEWID]:reSetCards()
			handCards[count + 1] = bankerCards[1]
			handCards[count + 2] = bankerCards[2]
			handCards[count + 3] = bankerCards[3]
			handCards = GameLogic:SortCardList(handCards, cmd.MAX_COUNT, 0)
		else
			handCards[count + 1] = 0
			handCards[count + 2] = 0
			handCards[count + 3] = 0
		end
		self.m_tabNodeCards[bankerViewId]:addCards(bankerCards, handCards)
	end
	if bankerViewId == cmd.MY_VIEWID then
		self.m_tabNodeCards[bankerViewId]:setLordIdentify()
	end
	-- 提示
	self.m_spInfoTip:setSpriteFrame("blank.png")
	self.m_bankerViewId = bankerViewId
	for k,v in pairs(self.m_tabStateSp) do
		v:setSpriteFrame("blank.png")
	end
end

-- 用户出牌
-- @param[curViewId]        当前出牌视图id
-- @param[lastViewId]       上局出牌视图id
-- @param[lastOutCards]     上局出牌
-- @param[bRenter]          是否断线重连
function GameViewLayer:onGetOutCard(curViewId, lastViewId, lastOutCards, bReEnter)
	bReEnter = bReEnter or false

	self.m_bMyOutCards = (curViewId == cmd.MY_VIEWID)
	if nil ~= self.m_tabStateSp[curViewId] then
		self.m_tabStateSp[curViewId]:setSpriteFrame("blank.png")
	end
	-- 移除上轮出牌
	local last_outCard_ani_name = self.m_tab_last_outCard_ani[curViewId]
	if nil ~= last_outCard_ani_name then
		self:resetOutCardAniNode(last_outCard_ani_name, curViewId)
	end
	self.m_outCardsControl:removeChildByTag(curViewId)
	-- 移除上轮出牌
	self.m_tab_last_outCard_ani[curViewId] = nil
	if curViewId ~= cmd.MY_VIEWID  then
		self.m_onGameControl:setVisible(false)
		-- self:playUserAnimal(curViewId,"chupai", false, "wait", true);
	end
	-- 自己出牌
	if curViewId == cmd.MY_VIEWID then
		self.m_spInfoTip:setSpriteFrame("blank.png")
		if self.m_trusteeshipControl:isVisible() == false then
			self.m_onGameControl:setVisible(true)

			self.m_btnOutCard:setEnabled(false)
			self.m_btnOutCard:setOpacity(125)

			local promptList = self:getParentNode().m_tabPromptList
			self.m_bCanOutCard = (#promptList > 0)

			-- 出牌控制
			if not self.m_bCanOutCard then
				self.m_spInfoTip:setSpriteFrame("game_tips_00.png")
				self.m_spInfoTip:setPosition(yl.WIDTH * 0.5, 160)
			else
				local sel = self.m_tabNodeCards[cmd.MY_VIEWID]:getSelectCards()
				local selCount = #sel
				if selCount > 0 then
					local selType = GameLogic:GetCardType(sel, selCount)
					if GameLogic.CT_ERROR ~= selType then
						local lastOutCount = #lastOutCards
						local outCards = self:getParentNode().m_tabCurrentCards
						local outCount = #outCards
						if lastOutCount == 0 then
							if outCount == 0 then
								self.m_btnOutCard:setEnabled(true)
								self.m_btnOutCard:setOpacity(255)
							end
						else
							outCards = lastOutCards
							outCount = lastOutCount
						end
						if outCount > 0 and GameLogic:CompareCard(outCards, outCount, sel, selCount) then
							self.m_btnOutCard:setEnabled(true)
							self.m_btnOutCard:setOpacity(255)
						end
					end
				end
			end
		end
	end

	-- 出牌消息
	if #lastOutCards > 0 then
		local vec = self.m_tabNodeCards[lastViewId]:outCard(lastOutCards, bReEnter)
		self:outCardEffect(lastViewId, lastOutCards, vec)
		self:playUserAnimal(lastViewId,"chupai", false, "wait", true);
	end
end
-- 斗地主  李逵捕鱼 通比牛牛 扎金花
-- 用户pass
-- @param[passViewId]       放弃视图id
function GameViewLayer:onGetPassCard( passViewId )
	local pass_type = math.random(0,2)
	if passViewId == cmd.MY_VIEWID then
		self.m_onGameControl:setVisible(false)
		self.m_tabNodeCards[cmd.MY_VIEWID]:reSetCards()
	else
		self:playUserAnimal(passViewId,"buyao", false, "wait", true);
	end
	local headitem = self.m_tabUserHead[passViewId]
	if nil ~= headitem then
		-- 音效
		ExternalFun.playSoundEffect( "pass" .. pass_type .. ".wav", headitem.m_userItem)
	end
	self.m_outCardsControl:removeChildByTag(passViewId)

	-- 显示不出
	local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame("pass" .. pass_type .. ".png")
	if nil ~= frame then
		self.m_tabStateSp[passViewId]:setSpriteFrame(frame)
	end
end

function GameViewLayer:onGameScenePlay(countlist)
	self:setCallScoreControl(false)
    for i = 1, 3 do
        local chair = i - 1
        local count = countlist[i]
        local viewId = self:getParentNode():SwitchViewChairID(chair)
		if nil ~= self.m_tabCardCount[viewId] and cmd.MY_VIEWID ~= viewId then
			self.m_tabCardCount[viewId]:setVisible(true)
			self.m_tabCardCount[viewId]:getChildByName("atlas_count"):setString(count .. "")
		end
	end
end

-- 游戏结束
function GameViewLayer:onGetGameConclude( rs )
	-- 界面重置
	self:reSetGame()
	self.temp_tru_btn:setVisible(false)
	-- 取消托管
	self.m_trusteeshipControl:setVisible(false)
--	self:onGameTrusteeship(false)

--[[	-- 显示准备
	self.m_btnReady:setEnabled(true)
	self.m_btnReady:setVisible(true)--]]

	self.m_spInfoTip:setSpriteFrame("blank.png")
	self.m_spInfoTip:setPosition(yl.WIDTH * 0.5, 375)
	local result = rs.enResult
	self.m_temp_settle = rs      -- 结算数据缓存
	self.m_rootLayer:removeChildByName("__effect_ani_name__")

	local function callback()
		-- 结束界面
		-- local m_resultNode = self.m_resultNode
		-- m_resultNode:setVisible(true)
		-- 播放动画
		-- local enResult = rs.enResult
		-- local result = ""
		-- local resultAnimationName = ""
		-- local cycAnimationName = ""
		-- if enResult == cmd.kLanderWin then
		-- 	resultAnimationName = "landlord_win"
		-- 	cycAnimationName = "win_cycle"
		-- 	result = "win"
		-- elseif  enResult == cmd.kLanderLose then
		-- 	resultAnimationName = "landlord_lose"
		-- 	cycAnimationName = "lose_cycle"
		-- 	result = "lose"
		-- elseif enResult == cmd.kFarmerWin then
		-- 	resultAnimationName = "farmer_win"
		-- 	cycAnimationName = "win_cycle"
		-- 	result = "win"
		-- elseif  enResult == cmd.kFarmerLose then
		-- 	resultAnimationName = "farmer_lose"
		-- 	cycAnimationName = "lose_cycle"
		-- 	result = "lose"
		-- end
		-- local m_result_big = self.m_result_big
		-- self:runAction(cc.Sequence:create(cc.CallFunc:create(function()
		-- 	m_result_big:setVisible(true)
		-- 	for i = 1, 3 do
		-- 		local settle = rs.settles[i]
		-- 		local coinChange = "add"
		-- 		if settle.m_settleCoin < 0 then
		-- 			coinChange = "reduce"
		-- 		end
		-- 		local result_big_string = "/" ..string.formatNumberFhousands(math.abs(settle.m_settleCoin))
		-- 		local resultBig =  cc.LabelAtlas:_create("12", "game/result_big_" .. coinChange .. ".png", 58, 88, string.byte('.'))
		-- 		resultBig:setPosition(m_result_big:getChildByName("tmp_" .. i):getPosition())
		-- 		resultBig:setString(result_big_string)
		-- 		m_result_big:addChild(resultBig)
		-- 		resultBig:setOpacity(0)
		-- 		resultBig:runAction(cc.Sequence:create( cc.FadeTo:create(2,255)))
		-- 		resultBig:setName("result_big_" .. i)
		-- 	end
		-- end), cc.CallFunc:create(function()
		-- 	ExternalFun.playSoundEffect( "settle_" .. result .. ".wav" )
		-- 	self.m_resultRoleNode:setVisible(true)
		self:onSettleInfo()
		-- 	self.m_resultRoleAni:play(resultAnimationName, false)
		-- 	self.m_resultBgNode:setVisible(true)
		-- 	self.m_resultBgAni:play(cycAnimationName, true)
		-- 	local MeItem = self._scene:GetMeUserItem()
		-- 	if MeItem and MeItem.cbUserStatus == yl.US_LOOKON then
		-- 		self:changeTable()
		-- 	end
		-- end), cc.DelayTime:create(4), cc.CallFunc:create(function()
		-- 	for i=1,3  do
		-- 		local resultBig = m_result_big:getChildByName("result_big_" .. i)
		-- 		if nil ~= resultBig then
		-- 			resultBig:runAction(cc.Sequence:create(cc.FadeTo:create(2,0), cc.CallFunc:create(function()
		-- 				resultBig:removeFromParent()
		-- 			end)))
		-- 		end
		-- 	end
		-- 	-- m_result_big:setVisible(false)
		-- end)
	-- ))
	end

	if nil ~= rs.m_chuntian_multiple then
		self.m_spring_ani:setLastFrameCallFunc(callback)
		self.m_spring_ani:play("chuntian", false)
		ExternalFun.playSoundEffect( "spring.wav" )
	elseif  nil ~= rs.m_fanchuntian_multiple then
		self.m_spring_ani:setLastFrameCallFunc(callback)
		self.m_spring_ani:play("chuntian", false)
		ExternalFun.playSoundEffect( "spring.wav" )
	else
		callback()
	end
	-- 退出按钮恢复正常
	self:setQuitEnable(true)

	for k,v in pairs(self.m_tabUserHead) do
		if v.m_userItem.cbUserStatus == yl.US_OFFLINE or  v.m_userItem.cbUserStatus == yl.US_NULL then
--[[			v:removeFromParent()
			self.m_tabUserHead[k] = nil--]]
			self.m_tab_head_info[k]:setVisible(false)
		end
	end
	-- 显示换桌按钮
	local end_table_btn = self.end_table_btn
	self.btTable:setVisible(true)
	self.btTable:setPosition(end_table_btn:getPosition())

	-- 将地主下面的小标志去掉，避免挡住牌
	if self.m_tab_head_info[self.m_bankerViewId] then
		self.m_tab_head_info[self.m_bankerViewId]:getChildByName("lord_mask"):setVisible(false)
	end
	-- 显示倒计时
--[[	local result_clock = self.m_resultNode:getChildByName("result_clock")
	local result_clock = self.m_resultNode:getChildByName("result_clock") --]]
--	self.m_tabTimerPos[cmd.MY_VIEWID] = cc.p(result_clock:getPositionX(),result_clock:getPositionY())
end

		------------------------------------------------------------------------------------------------------------
--更新
		------------------------------------------------------------------------------------------------------------
return GameViewLayer
