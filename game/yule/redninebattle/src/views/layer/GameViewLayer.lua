--
-- Author: zhouweixiang
-- Date: 2016-11-28 14:17:03
--
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local ClipText = appdf.req(appdf.EXTERNAL_SRC .. "ClipText")
local PopupInfoHead = appdf.req(appdf.EXTERNAL_SRC .. "PopupInfoHead")
local HeadSprite = appdf.req(appdf.EXTERNAL_SRC.."HeadSprite")
--local QueryDialog = appdf.req("base.src.app.views.layer.other.QueryDialog")
local QueryDialog = appdf.req("app.views.layer.other.QueryDialog")
local cmd = appdf.req(appdf.GAME_SRC.."yule.redninebattle.src.models.CMD_Game")

local Game_CMD = appdf.req(appdf.GAME_SRC.."yule.redninebattle.src.models.CMD_Game")
local GameLogic = appdf.req(appdf.GAME_SRC.."yule.redninebattle.src.models.GameLogic")

local CardSprite = appdf.req(appdf.GAME_SRC.."yule.redninebattle.src.views.layer.CardSprite")
local SitRoleNode = appdf.req(appdf.GAME_SRC.."yule.redninebattle.src.views.layer.SitRoleNode")

--弹出层
local SettingLayer = appdf.req(appdf.GAME_SRC.."yule.redninebattle.src.views.layer.SettingLayer")
local UserListLayer = appdf.req(appdf.GAME_SRC.."yule.redninebattle.src.views.layer.UserListLayer")
local PlayerlistLayer = appdf.req(appdf.GAME_SRC.."yule.redninebattle.src.views.layer.PlayerlistLayer")
local ApplyListLayer = appdf.req(appdf.GAME_SRC.."yule.redninebattle.src.views.layer.ApplyListLayer")
local GameRecordLayer = appdf.req(appdf.GAME_SRC.."yule.redninebattle.src.views.layer.GameRecordLayer")
local GameResultLayer = appdf.req(appdf.GAME_SRC.."yule.redninebattle.src.views.layer.GameResultLayer")
local GameRuleLayer = appdf.req(appdf.GAME_SRC.."yule.redninebattle.src.views.layer.GameRuleLayer")
local CardRecordLayer = appdf.req(appdf.GAME_SRC.."yule.redninebattle.src.views.layer.CardRecordLayer")
local ControlLayer = appdf.req(appdf.GAME_SRC.."yule.redninebattle.src.views.layer.ControlLayer")

local GameViewLayer = class("GameViewLayer",function(scene)
        local gameViewLayer = display.newLayer()
    return gameViewLayer
end)

local TAG_START             = 100
local enumTable = 
{
    "HEAD_BANKER",  --庄家头像
    "TAG_CARD_TXT",  --特殊牌点数跟普通点
    "TAG_CARD",     --牌
    "BT_MENU",		--菜单按钮
    "BT_LUDAN",     --路单
    "BT_BANK",		--银行
    "BT_CLOSEBANK", --关闭银行
    "BT_TAKESCORE",	--银行取款
    "BT_SET",       --设置
    "BT_QUIT",      --退出
    "BT_HELP",      --帮助
    "BT_SUPPERROB", --超级抢庄
    "BT_APPLY",     --申请上庄
    "BT_USERLIST",  --用户列表
	"BT_REBET",  	--重复下注
	"BT_DOUBLEDOWN",--加倍下注
	"BT_GAMERULE",	--游戏规则
	"BT_CARDRECORD",
    "BT_JETTONAREA_0",  --下注区域
    "BT_JETTONAREA_1",
    "BT_JETTONAREA_2",
    "BT_JETTONAREA_3",
    "BT_JETTONAREA_4",
    "BT_JETTONAREA_5",
    "BT_JETTONSCORE_0", --下注按钮
    "BT_JETTONSCORE_1",
    "BT_JETTONSCORE_2",
    "BT_JETTONSCORE_3",
    "BT_JETTONSCORE_4",
    "BT_JETTONSCORE_5",
    "BT_JETTONSCORE_6",
    "BT_SEAT_0",       --坐下  
    "BT_SEAT_1",
    "BT_SEAT_2",
    "BT_SEAT_3",
    "BT_SEAT_4",  
    "BT_SEAT_5",
	"BT_CONTROL",
}
local TAG_ENUM = ExternalFun.declarEnumWithTable(TAG_START, enumTable)

enumTable = {
    "ZORDER_JETTON_GOLD_Layer", --下注时游戏币层级
    "ZORDER_CARD_Layer", --牌层
    "ZORDER_Other_Layer", --用户列表层等
}
local ZORDER_LAYER = ExternalFun.declarEnumWithTable(2, enumTable)

local zorders = 
{
	"DROPDOWN_ZORDER",--菜单层级
	"REGIONAL_CHIP_ZORDER", --区域下注统计
	"POPUP_LAYER_ZORDER",--规则、无座玩家弹出框层
	
}
local TAG_ZORDER = ExternalFun.declarEnumWithTable(200, zorders)

local enumApply =
{
    "kCancelState",
    "kApplyState",
    "kApplyedState",
    "kSupperApplyed"
}

GameViewLayer._apply_state = ExternalFun.declarEnumWithTable(0, enumApply)
local APPLY_STATE = GameViewLayer._apply_state

local enumtipType = 
{
    "TypeNoBanker",           --无人坐庄
    "TypeChangBanker",        --切换庄家
    "TypeSelfBanker",         --自己上庄
    "TypeContinueSend",       --继续发牌
    "TypeReSend",             --重新发牌
	"TypeTongSha",			  --通杀
	"TypeTongPei",			  --通赔
}
local TIP_TYPE = ExternalFun.declarEnumWithTable(3, enumtipType)

local MaxTimes = 1   ---最大赔率

--下注数值
GameViewLayer.m_BTJettonScore = {1, 5, 10, 50, 100, 500, 1000}

--下注值对应游戏币个数
--GameViewLayer.m_JettonGoldBaseNum = {1, 1, 2, 2, 3, 3, 4}
GameViewLayer.m_JettonGoldBaseNum = {1, 1, 1, 1, 1, 1, 1}
--获得基本游戏币个数
GameViewLayer.m_WinGoldBaseNum = {2, 2, 4, 4, 6, 6, 6}
--获得最多游戏币个数
GameViewLayer.m_WinGoldMaxNum = {6, 6, 8, 8, 12, 12, 12}

--发牌位置
local cardpoint = {cc.p(570, 565), cc.p(250, 438), cc.p(570, 250), cc.p(900, 438)}
--自己头像位置
local selfheadpoint = cc.p(60, 58)
--庄家头像位置
local bankerheadpoint = cc.p(540, 640) 
--玩家列表按钮位置
local userlistpoint = cc.p(1273, 60)


function GameViewLayer:ctor(scene)
	--注册node事件
    ExternalFun.registerNodeEvent(self)	

	self._scene = scene

    --初始化
    self:paramInit()
	
	--加载资源
	self:loadResource()
	
	--主界面功能
	self:GameMainDraw()
	
	--控制端界面
	self:GameControl()
	
    ExternalFun.playBackgroudAudio("ingameBGMMono.wav")
	
	--点击事件
	self:setTouchEnabled(true)
	self:registerScriptTouchHandler(function(eventType, x, y)
		return self:onEventTouchCallback(eventType, x, y)
	end)
	
	--CC_SHOW_FPS = true
	--if CC_SHOW_FPS then
    --    cc.Director:getInstance():setDisplayStats(true)
    --end
	
end

function GameViewLayer:paramInit()
    --用户列表
    self:getDataMgr():initUserList(self:getParentNode():getUserList())

    --是否显示菜单层
    -- self.m_bshowMenu = false

    --菜单栏
    -- self.m_menulayout = nil

    --庄家背景框
    self.m_bankerbg = nil
    --庄家名称
    self.m_bankerName = nil

    --自己背景框
    self.m_selfbg = nil

    --下注筹码
    self.m_JettonBtn = {}

    --下注按钮背后光(圈型)
    self.m_JettonLight = nil
	--下注按钮背后光(矩形)
    self.m_JettonRectLight = nil
	
    --选中筹码
    self.m_nJettonSelect = 0

    --自己区域下注分
    self.m_lUserJettonScore = {}
    --自己下注总分
    self.m_lUserAllJetton = 0
	
	--记录自己区域下注分
    self.m_lUserRecordJettonScore = {}
	
    --玩家区域总下注分
    self.m_lAllJettonScore = {}
    --下注区域
    self.m_JettonArea = {}

    --自己下注分数文字
    self.m_selfJettonScore = {}
	--自己下注分数单位符号(万)
	self.m_selfJettonFuhaoWan = {}
    --总下注分数文字((小于万、万)、百万、(千万、亿))
    self.m_tAllJettonScore = {}
	self.m_tAllJettonScoreMil = {}
	self.m_tAllJettonScoreTenMil = {}
	--自己下注分数符号(万、亿)
	self.m_selfJettonFuhaoWan = {}
	self.m_selfJettonFuhaoYi = {}
	--总下注分数符号(万、百万、千万、亿)
	self.m_tAllJettonFuhaoWan = {}
	self.m_tAllJettonFuhaoMil = {}
	self.m_tAllJettonFuhaoTenMil = {}
	self.m_tAllJettonFuhaoYi = {}
	
	--自己下注区域灰色背景
    self.m_selfJettonBg = {}
	
    --下注区域亮光
    self.m_JettAreaLight = {}
	
	--两个色子的点数总和
	self.m_dicepoint = 2
	self.m_dicefirst = 0
	self.m_dicesecond = 0
	
    --牌显示层
    self.m_cardLayer = nil

    --游戏币显示层
    self.m_goldLayer = nil
	
	--提示显示层--通杀通赔
    self.m_TipLayer = nil

    --游戏币列表
    self.m_goldList = {{}, {}, {}, {}, {}, {}, {}}

    --玩家列表层
    self.m_userListLayer = nil
	
    --控制层
	self.m_ControlLayer = nil
	
    --上庄列表层
    self.m_applyListLayer = nil

    --游戏银行层
    self.m_bankLayer = nil

    --路单层
    self.m_GameRecordLayer = nil
	
	--开牌记录层
    self.m_cardrecordListLayer = nil
	
    --游戏结算层
    self.m_gameResultLayer = nil

    --倒计时Layout
    self.m_timeLayout = nil

    --当前庄家
    self.m_wBankerUser = yl.INVALID_CHAIR
    --当前庄家分数
    self.m_lBankerScore = 0
    --当前庄家成绩
    self.m_lBankerWinAllScore = 0
    --庄家局数
    self.m_cbBankerTime = 0
    --开牌轮数
	self.m_cbCardRecordCount = 1
	
    --系统能否做庄
    self.m_bEnableSysBanker = false

    --游戏状态
    self.m_cbGameStatus = Game_CMD.GAME_SCENE_FREE
    --剩余时间
    self.m_cbTimeLeave = 0

    --显示分数
    self.m_showScore = self:getMeUserItem().lScore or 0

    --最大下注
    self.m_lUserMaxScore = 0

    --申请条件
    self.m_lApplyBankerCondition = 0
	self.m_llCondition = 0
	
    --区域限制
    self.m_lAreaLimitScore = 0

    --桌面扑克数据
    self.m_cbTableCardArray = {}
    --桌面扑克
    self.m_CardArray = {}
	--桌面点数显示或者特殊牌显示
    self.m_cardPointLayout = {}
	--特殊牌数值>1或者普通牌点值1
    self.m_cardPoint = {}
    --区域输赢
    self.m_bUserOxCard = {}

    --是否练习房，练习房不能使用银行
    self.m_bGenreEducate = false

    --自己占位
    self.m_nSelfSitIdx = nil

    --用户坐下配置
    self.m_tabSitDownConfig = {}
    self.m_tabSitDownUser = {}
    --自己坐下
    self.m_nSelfSitIdx = nil

    --座位
    self.m_TableSeat = {}
	
	self.m_bIsGameCheatUser = false
	
	--座位玩家结算数字
    self.m_situserResultFont = {}
	self.m_situserResultLoseFont = {}
	
    --游戏结算数据
    --坐下玩家赢分
    self.m_lOccupySeatUserWinScore = nil

    --本局赢分
    self.m_lSelfWinScore = 0

    --本局返还分
    self.m_lSelfReturnScore = 0

    --庄家赢分
    self.m_lBankerWinScore = 0
    --庄家昵称
    self.m_tBankerName = ""

    --超级抢庄按钮
    self.m_btSupperRob = nil
    --申请状态
    self.m_enApplyState = APPLY_STATE.kCancelState
    --超级抢庄申请
    self.m_bSupperRobApplyed = false
    --超级抢庄配置
    self.m_tabSupperRobConfig = {}
    --游戏币抢庄提示
    self.m_bRobAlert = false
    --当前抢庄用户
    self.m_wCurrentRobApply = yl.INVALID_CHAIR

    --是否播放游戏币飞入音效
    self.m_bPlayGoldFlyIn = true
    --下注倒计时
    self.m_fJettonTime = 0.1
	
	self.nicknameConfig = string.getConfig("base/fonts/round_body.ttf", 20)

end

function GameViewLayer:loadResource()
    --加载卡牌纹理
    cc.Director:getInstance():getTextureCache():addImage("game_res/im_card.png")
	--加载卡牌纹理(开牌记录小扑克)
	cc.Director:getInstance():getTextureCache():addImage("game_res/im_small_card.png")

    -- cc.Director:getInstance():getTextureCache():addImage("game_res/dtjCards.png")
	-- cc.SpriteFrameCache:getInstance():addSpriteFrames("game_res/dtjCards.plist")


    local csbPath = "GameScene.csb"
    local rootLayer, csbNode = ExternalFun.loadRootCSB(csbPath, self)
	self.m_rootLayer = rootLayer
    self.m_scbNode = csbNode

    --动画加载
    self._csbNodeAni=cc.CSLoader:createTimeline(csbPath)
    self.m_scbNode:stopAllActions()
    self.m_scbNode:runAction(self._csbNodeAni)
    self.m_getCodeTime = 0

--荷官
-- print (armature_heguan)
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(cmd.RES_PATH.."new/heguan_paijiu/heguan_paijiu.ExportJson")
    armature_heguan= ccs.Armature:create("heguan_paijiu")
    -- pAni->getAnimation()->playWithIndex(0); 
   armature_heguan:setPosition(cc.p(667,475))
    self:addChild(armature_heguan)
    self.armature_heguan=armature_heguan
     self.armature_heguan:setVisible(false)

     --骰子动画
     -- print(armature_touzi1)
     ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(cmd.RES_PATH.."new/touzi_paijiu/touzi_paijiu.ExportJson")
     local armature_touzi2 = ccs.Armature:create("touzi_paijiu")
      self.armature_touzi2=armature_touzi2
      self.armature_touzi2:setPosition(cc.p(119,550))
      self.armature_touzi2:setVisible(false)
      self:addChild(armature_touzi2)
     local armature_touzi = ccs.Armature:create("touzi_paijiu")
     -- armature:getAnimation():playWithIndex(0)
     -- pAni->getAnimation()->playWithIndex(0); 
     self.armature_touzi=armature_touzi
     self.armature_touzi:setPosition(cc.p(134,550))
     self.armature_touzi:setVisible(false)
      self:addChild(armature_touzi)
      local armature_touzi0 = ccs.Armature:create("touzi_paijiu")
      self.armature_touzi0=armature_touzi0
      self.armature_touzi0:setPosition(cc.p(94,550))
      self.armature_touzi0:setVisible(false)
      self:addChild(armature_touzi0)
      local armature_touzi1 = ccs.Armature:create("touzi_paijiu")
      self.armature_touzi1=armature_touzi1
      self.armature_touzi1:setPosition(cc.p(119,550))
      self.armature_touzi1:setVisible(false)
      self:addChild(armature_touzi1)


    local publicLayer=self.m_scbNode:getChildByName("publicLayer")
    self.m_publicLayer=publicLayer

    local btnLayer = self.m_scbNode:getChildByName("btnlayer")
    self.m_btnLayer = btnLayer

    self.Card_stack=self.m_publicLayer:getChildByName("card")

    role_control_rank=self.m_publicLayer:getChildByName("role_control_rank")
    role_control_rank:setVisible(false)

	local function btnEvent( sender, eventType )
        if eventType == ccui.TouchEventType.ended then
            self:onButtonClickedEvent(sender:getTag(), sender)
        end
    end

    --菜单栏
    --self.m_menulayout = csbNode:getChildByName("im_menu")
    --self.m_menulayout:setPositionY(843.00)
    --self.m_menulayout:retain()
    --self.m_menulayout:removeFromParent()
    --self:addToRootLayer(self.m_menulayout, TAG_ZORDER.DROPDOWN_ZORDER)
    --self.m_menulayout:release()
	
	-- self.m_menulayout = btnLayer:getChildByName("im_menu");
	--self.m_menulayout:setScaleY(0.0000001)
	--self.m_menulayout:setLocalZOrder(TAG_ZORDER.DROPDOWN_ZORDER)
	--self.m_menulayout:retain()
    --self.m_menulayout:removeFromParent()
    --self:addToRootLayer(self.m_menulayout, TAG_ZORDER.DROPDOWN_ZORDER)
    --self.m_menulayout:release()
	self.stopbetbg_ = self.m_publicLayer:getChildByName("stopbetbg_3")
    self.cardmove_num = self.m_publicLayer:getChildByName("card")
    self.cardmove_num:setVisible(false)

	-- local menulistener = cc.EventListenerTouchOneByOne:create()
	-- menulistener:setSwallowTouches(true)
	-- menulistener:registerScriptHandler(function(touch, eventType)
	-- 	local pos = touch:getLocation();
	-- 	pos = self.m_menulayout:convertToNodeSpace(pos)
	-- 	local rec = cc.rect(0, 0, self.m_menulayout:getContentSize().width, self.m_menulayout:getContentSize().height)
	-- 	if false == cc.rectContainsPoint(rec, pos) then
	-- 		if (self.m_bshowMenu ~= false) then
	-- 			self:showMenu()
	-- 		end
	-- 	end
	-- 	return self.m_bshowMenu
	-- end,cc.Handler.EVENT_TOUCH_BEGAN)
	-- --listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
	-- menulistener:registerScriptHandler(function(touch, eventType)
	-- end,cc.Handler.EVENT_TOUCH_ENDED )
	
	-- self:getEventDispatcher():addEventListenerWithSceneGraphPriority(menulistener, self.m_menulayout)	
	
 --    self.m_menulayout:setScale(1.0, 0.01)
 --    self.m_menulayout:setVisible(false) 
	
	
    --菜单按钮
    -- local  btn = self.m_btnLayer:getChildByName("bt_pull")
    -- btn:setTag(TAG_ENUM.BT_MENU)
    -- btn:addTouchEventListener(btnEvent)

    -- --银行
    -- btn = self.m_menulayout:getChildByName("bt_bank")
    -- btn:setTag(TAG_ENUM.BT_BANK)
    -- btn:addTouchEventListener(btnEvent)

    --设置
    btn = btnLayer:getChildByName("bt_set")
    -- :setSelected(GlobalUserItem.bSoundAble)
    -- :setSelected(GlobalUserItem.bVoiceAble)
    btn:setTag(TAG_ENUM.BT_SET)
    btn:addTouchEventListener(btnEvent)

    -- --玩家列表
    -- btn = self.m_menulayout:getChildByName("bt_player")
    -- btn:setTag(TAG_ENUM.BT_USERLIST)
    -- btn:addTouchEventListener(btnEvent)

    -- --帮助
    -- btn = self.m_menulayout:getChildByName("bt_help")
    -- btn:setTag(TAG_ENUM.BT_HELP)
    -- btn:addTouchEventListener(btnEvent)

    --退出
    self.btquit = btnLayer:getChildByName("bt_quit")
    self.btquit:setTag(TAG_ENUM.BT_QUIT)
    self.btquit:addTouchEventListener(btnEvent)

    -- --路单
    -- btn = publicLayer:getChildByName("bt_ludan")
    -- btn:setTag(TAG_ENUM.BT_LUDAN)
    -- btn:addTouchEventListener(btnEvent)
	
	
    --超级抢庄--Ma屏蔽超级抢庄
    --[[self.m_btSupperRob = csbNode:getChildByName("bt_supperrob")
    self.m_btSupperRob:setTag(TAG_ENUM.BT_SUPPERROB)
    self.m_btSupperRob:addTouchEventListener(btnEvent)
    self.m_btSupperRob:setEnabled(false)--]]

    --申请上庄
    self.btnapply = publicLayer:getChildByName("bt_apply")
    self.btnapply:setTag(TAG_ENUM.BT_APPLY)
    self.btnapply:addTouchEventListener(btnEvent)

    --倒计时
    self.m_timeLayout = publicLayer:getChildByName("layout_time")
	
    --庄家背景框
    self.m_bankerbg = publicLayer:getChildByName("layout_banker")

    --.//,,
    -- self.m_bankerbg:setVisible(false)

    --自己背景框
    self.m_selfbg = publicLayer:getChildByName("layout_self")

    --下注筹码
    for i=1,7 do
        local str = string.format("bt_jetton_%d", i-1)
        btn = publicLayer:getChildByName(str)
        btn:setTag(TAG_ENUM.BT_JETTONSCORE_0+i-1)
        btn:addTouchEventListener(btnEvent)
        self.m_JettonBtn[i] = btn
    end

	--下注按钮背后光
	self.m_JettonLight = publicLayer:getChildByName("im_jetton_effect")
	--self.m_JettonLight:runAction(cc.RepeatForever:create(cc.Blink:create(1.0,1)))--忽闪效果
	self.m_JettonLight:runAction(cc.RepeatForever:create(cc.RotateBy:create(1.0 , 360)))


	---下注按钮背后转动(6,7按钮)
	local cache = cc.SpriteFrameCache:getInstance()
	cache:addSpriteFrames("game_res/jetton_light.plist")
	
	self.m_JettonRectLight = cc.Sprite:createWithSpriteFrameName("jettonlight_0.png")

	local spritebatch = cc.SpriteBatchNode:create("game_res/jetton_light.png")
	spritebatch:addChild(self.m_JettonRectLight)
	self:addChild(spritebatch)
	
	local animFrames = {}
	for i = 1,17 do 
		local frame = cache:getSpriteFrame( string.format("jettonlight_%d.png", i) )
		animFrames[i] = frame
	end

	local animation = cc.Animation:createWithSpriteFrames(animFrames, 0.03)
	self.m_JettonRectLight:stopAllActions()
	self.m_JettonRectLight:runAction( cc.RepeatForever:create( cc.Animate:create(animation) ) )
	self.m_JettonRectLight:setVisible(false)

	
    --下注区域
    for i=1,6 do
        local str = string.format("bt_area_%d", i)
        btn = publicLayer:getChildByName(str)
        btn:setTag(TAG_ENUM.BT_JETTONAREA_0+i-1)
        btn:addTouchEventListener(btnEvent)
        self.m_JettonArea[i] = btn
		
		--各区域下注值
		-- <100万
        local txttemp = btn:getChildByName("txt_all_jetton")
        self.m_tAllJettonScore[i] = txttemp
        txttemp:setVisible(false)

		-- >=100万<1000万
		local txttemp = btn:getChildByName("txt_all_jetton_0")
        self.m_tAllJettonScoreMil[i] = txttemp
        txttemp:setVisible(false)
		
		-- >=1000万(亿)
		local txttemp = btn:getChildByName("txt_all_jetton_1")
        self.m_tAllJettonScoreTenMil[i] = txttemp
        txttemp:setVisible(false)
		
		--自己区域下注灰色背景
        txttemp = btn:getChildByName("m_selfJetton_bg")
        self.m_selfJettonBg[i] = txttemp
        txttemp:setVisible(false)
		
		--自己区域下注值
        txttemp = btn:getChildByName("txt_self_jetton")
        self.m_selfJettonScore[i] = txttemp
        txttemp:setVisible(false)
		
		--自己区域下注值单位(万)
		local txttemp = btn:getChildByName("num_self_wan")
        self.m_selfJettonFuhaoWan[i] = txttemp
        txttemp:setVisible(false)
		
		--灯光
        txttemp = btn:getChildByName("im_win_light")
        self.m_JettAreaLight[i] = txttemp
        txttemp:setVisible(false)
		
		-->1万<100万字
		txttemp = btn:getChildByName("num_all_jetton_1_wan")
        self.m_tAllJettonFuhaoWan[i] = txttemp
        txttemp:setVisible(false)
		
		-->=100万字
		txttemp = btn:getChildByName("num_all_jetton_2_wan")
        self.m_tAllJettonFuhaoMil[i] = txttemp
        txttemp:setVisible(false)
		
		-- >=1000万字
		txttemp = btn:getChildByName("num_all_jetton_3_wan")
        self.m_tAllJettonFuhaoTenMil[i] = txttemp
        txttemp:setVisible(false)
		
		--亿
		txttemp = btn:getChildByName("num_all_jetton_3_yi")
        self.m_tAllJettonFuhaoYi[i] = txttemp
        txttemp:setVisible(false)
		
    end

   --[[ --座位
    for i=1,4 do
        local str = string.format("bt_seat_%d", i)
        btn = csbNode:getChildByName(str)
        btn:setTag(TAG_ENUM.BT_SEAT_0+i-1)
        btn:addTouchEventListener(btnEvent)
        self.m_TableSeat[i] = btn
    end--]]
	--初始化座位列表
	self:initSitDownList(publicLayer)
	
    self:initBankerInfo()
    self:initSelfInfo()

    --牌类层
    --self.m_cardLayer = cc.Layer:create()
    --self:addToRootLayer(self.m_cardLayer, ZORDER_LAYER.ZORDER_CARD_Layer)
	self.m_cardLayer = publicLayer:getChildByName("cardLayer")
    local gupai = 0
    if GlobalUserItem.bgupai then
        gupai  = 1
    end

    for i=1,4 do
        local temp = {}
		local mm = (self.m_dicepoint + i - 2)%4+1
        for j=1,2 do
            -- temp[j] = CardSprite:createCard(0,gupai)
            temp[j] = CardSprite:createCard(0,gupai)
            temp[j]:setVisible(false)
            temp[j]:setAnchorPoint(0, 0.5)
            temp[j]:setTag(TAG_ENUM.TAG_CARD)
            self.m_cardLayer:addChild(temp[j])
        end
        self.m_CardArray[mm] = temp
		
		---------------
		--self.m_cardPointLayout[i] = ccui.ImageView:create("im_point_failed_bg.png", UI_TEX_TYPE_PLIST)
		self.m_cardPointLayout[mm] = ccui.ImageView:create("105_im_blank.png",UI_TEX_TYPE_PLIST)
        self.m_cardPointLayout[mm]:setTag(TAG_ENUM.TAG_CARD_TXT)
		
        self.m_cardPointLayout[mm]:setPosition(cardpoint[mm].x+90, cardpoint[mm].y-30)
        self.m_cardPointLayout[mm]:setVisible(false)
        self.m_cardLayer:addChild(self.m_cardPointLayout[mm])
		---------------
		
    end
	
    --游戏币层--下注的筹码层
	self.m_goldLayer = publicLayer:getChildByName("goldLayer")
    --self.m_goldLayer = cc.Layer:create()
    --self:addToRootLayer(self.m_goldLayer, ZORDER_LAYER.ZORDER_JETTON_GOLD_Layer)
	
	--提示层
	self.m_TipLayer = cc.Layer:create()
    self:addToRootLayer(self.m_TipLayer, 20)
end

--座位列表
function GameViewLayer:initSitDownList( publicLayer )
	local m_roleSitDownLayer = publicLayer:getChildByName("role_control")
	self.m_roleSitDownLayer = m_roleSitDownLayer
	
	--按钮列表
	local function btnEvent( sender, eventType )
		if eventType == ccui.TouchEventType.ended then
			self:onSitDownClick(sender:getTag(), sender);
		end
	end
	
	local str = ""
	for i=1,4 do
		str = string.format("bt_seat_%d", i)
		self.m_TableSeat[i] = m_roleSitDownLayer:getChildByName(str)
		self.m_TableSeat[i]:setTag(i)
		self.m_TableSeat[i]:addTouchEventListener(btnEvent);
	end
	
end

--绘画主界面功能
function GameViewLayer:GameMainDraw()
	
	local function btnEvent( sender, eventType )
        if eventType == ccui.TouchEventType.ended then
            self:onButtonClickedEvent(sender:getTag(), sender)
        end
    end
	
	--色子
    self.shaizi=self.m_publicLayer:getChildByName("shaizi")
	self.m_sicebg1 = self.shaizi:getChildByName("sicebg1")
	self.m_sicebg1:setVisible(false)
		
	self.m_sicebg2 = self.shaizi:getChildByName("sicebg2")
	self.m_sicebg2:setVisible(false)
		
	--显示输赢趋势
	if nil == self.m_GameRecordLayer then
		self.m_GameRecordLayer = GameRecordLayer:create(self)
		self:addToRootLayer(self.m_GameRecordLayer, ZORDER_LAYER.ZORDER_Other_Layer)
    end
    local recordList = self:getDataMgr():getGameRecord()     
    self.m_GameRecordLayer:refreshRecord(recordList)
    --.//,,
    -- self.m_GameRecordLayer:setVisible(false)
	
	--上庄列表
	if nil == self.m_applyListLayer then
		self.m_applyListLayer = ApplyListLayer:create(self)
		self:addToRootLayer(self.m_applyListLayer, ZORDER_LAYER.ZORDER_Other_Layer)
	end
	local userList = self:getDataMgr():getApplyBankerUserList() 
	self.m_applyListLayer:showLayer()    
	self.m_applyListLayer:refreshList(userList)
    --.//,,
    self.m_applyListLayer:setVisible(false)
	
	--无座玩家列表
	self.bt_nositplayer = self.m_publicLayer:getChildByName("bt_nositplayer")
    self.bt_nositplayer:setTag(TAG_ENUM.BT_USERLIST)
    self.bt_nositplayer:addTouchEventListener(btnEvent)
	
	--3轮总下注及自己下注goldLayer
	self.m_bets_tj_bg = self.m_publicLayer:getChildByName("im_bets_tj_bg")
	--self._infolayout:setGlobalZOrder(TAG_ZORDER.REGIONAL_CHIP_ZORDER)
	
	--轮数
	--self.m_lunshu = self.m_cbCardRecordCount
	self.text_lunshu = self.m_bets_tj_bg:getChildByName("Text_lunshu")
	--self.text_lunshu:setString(""..self.m_cbCardRecordCount)
	
	--所有区域总下注值
	self.textAllJetton = self.m_bets_tj_bg:getChildByName("AllJetton")
	--玩家自己总下注值
	self.textUserAllJetton = self.m_bets_tj_bg:getChildByName("user_AllJetton")
	
	--重复下注
	self.bt_rebet = self.m_publicLayer:getChildByName("bt_rebet")
    self.bt_rebet:setTag(TAG_ENUM.BT_REBET)
	self.bt_rebet:addTouchEventListener(btnEvent)
	--加倍下注
	self.bt_doubledown = self.m_publicLayer:getChildByName("bt_doubledown")
    self.bt_doubledown:setTag(TAG_ENUM.BT_DOUBLEDOWN)
	self.bt_doubledown:addTouchEventListener(btnEvent)
	
	--游戏规则说明
	self.bt_rule = self.m_btnLayer:getChildByName("bt_rule")
	self.bt_rule:setTag(TAG_ENUM.BT_GAMERULE)
	self.bt_rule:addTouchEventListener(btnEvent)
	
	--控制透明按钮
	self.btcontrol = self.m_publicLayer:getChildByName("btcontrol")
    self.btcontrol:setTag(TAG_ENUM.BT_CONTROL)
    self.btcontrol:addTouchEventListener(btnEvent)
	
	--时钟动画
	self.m_TimeProgress = {}
	self.m_TimeProgress = cc.ProgressTimer:create(display.newSprite("#im_clock_effect.png"))
		 :setReverseDirection(true)
         -- :setPosition( self.animation_time:getPositionX(), self.animation_time:getPositionY())
		 :move(self.m_timeLayout:getPositionX()+60,self.m_timeLayout:getPositionY()+35)
		 :setVisible(true)
		 :setAnchorPoint(cc.p(0.5,0.5))
		 :setPercentage(100)
		:addTo(self.m_rootLayer)
	
	--开牌记录
	self.bt_cardrecord = self.m_btnLayer:getChildByName("bt_cardrecord")
	self.bt_cardrecord:setTag(TAG_ENUM.BT_CARDRECORD)
	self.bt_cardrecord:addTouchEventListener(btnEvent)
	
	--自己结算数字
	self.m_selfResultFont = self.m_selfbg:getChildByName("selfResult_font");
	self.m_selfResultFont:setVisible(false)
	self.m_selfResultFont:setString("")
	
	self.m_selfResultLoseFont = self.m_selfbg:getChildByName("selfResult_lose_font");
	self.m_selfResultLoseFont:setVisible(false)
	self.m_selfResultLoseFont:setString("")
	
	--庄家结算数字
	self.m_bankerResultFont = self.m_bankerbg:getChildByName("BankerResult_font")
    self.m_bankerResultFont:setVisible(false)
	self.m_bankerResultFont:setString("")
	
	self.m_bankerResultLoseFont = self.m_bankerbg:getChildByName("BankerResult_lose_font")
    self.m_bankerResultLoseFont:setVisible(false)
	self.m_bankerResultLoseFont:setString("")
	
	--坐下玩家结算数字
	--赢
	for i=1,4 do
		local str = string.format("SituserResult%d_font", i)
        local SituserResult = self.m_publicLayer:getChildByName(str)
        self.m_situserResultFont[i] = SituserResult
		self.m_situserResultFont[i]:setVisible(false)
		self.m_situserResultFont[i]:setString("")
    end
	--输
	for i=1,4 do
		local str = string.format("SituserResult%d_lose_font", i)
        local SituserResult = self.m_publicLayer:getChildByName(str)
        self.m_situserResultLoseFont[i] = SituserResult
		self.m_situserResultLoseFont[i]:setVisible(false)
		self.m_situserResultLoseFont[i]:setString("")
    end
	
end

--控制端
function GameViewLayer:GameControl()
	if self.m_ControlLayer == nil then
		self.m_ControlLayer = ControlLayer:create(self)
		:addTo(self, 1000)
		self.m_ControlLayer:setVisible(false)
	end

	for k,v in pairs(self:getParentNode():getUserList()) do
		self.m_ControlLayer:setPlayerAreaBet(v.dwGameID,0,0,0,0,0,v.bAndroid,0,0,0)
    end	
	
end

--初始化庄家信息
function GameViewLayer:initBankerInfo()
    local infolayout = self.m_bankerbg:getChildByName("layout_txt")
    local temp = infolayout:getChildByName("txt_name")
    local pbankername = ClipText:createClipText(cc.size(160, 35), "无人坐庄");
    pbankername:setAnchorPoint(temp:getAnchorPoint())
    pbankername:setName(temp:getName())
    pbankername:setPosition(temp:getPosition())
    temp:removeFromParent()
    infolayout:addChild(pbankername)
    self.m_bankerName = pbankername

    temp = infolayout:getChildByName("txt_gold_num")
    temp:setString("0")
	
    temp = infolayout:getChildByName("txt_score")
    temp:setString("0")

    temp = infolayout:getChildByName("txt_count")
    temp:setString("0")

    temp = self.m_bankerbg:getChildByName("im_no_banker")
    temp:setVisible(false)
end

--刷新庄家信息
function GameViewLayer:resetBankerInfo()
    local infolayout = self.m_bankerbg:getChildByName("layout_txt")
    local temp = infolayout:getChildByName("txt_gold_num")
    local scoretemp = infolayout:getChildByName("txt_score")
    local counttemp = infolayout:getChildByName("txt_count")
    if self.m_wBankerUser == yl.INVALID_CHAIR then
        if self.m_bEnableSysBanker == false then
            self.m_bankerName:setString("无人坐庄")
            temp:setString("-------")
            scoretemp:setString("-------")
            counttemp:setString("-------")
        else
            self.m_bankerName:setString("系统坐庄")
			self.m_bankerName:setTextColor(cc.c3b(248, 235, 13))
			--numberThousands 改为 formatScoreText
			--self.m_lBankerScore = 0.00
            local bankerstr = ExternalFun.formatScoreFloatText(self.m_lBankerScore)
            temp:setString(bankerstr)
            scoretemp:setString(ExternalFun.formatScoreFloatText(self.m_lBankerWinAllScore))
            counttemp:setString(""..self.m_cbBankerTime)
			--self.text_lunshu:setString(""..self.m_cbCardRecordCount)
			local headlsystem = self.m_bankerbg:getChildByName("system_head")
			headlsystem:setVisible(true)
        end
    else
        local userItem = self:getDataMgr():getChairUserList()[self.m_wBankerUser+1]
        if nil ~= userItem then
			local headlsystem = self.m_bankerbg:getChildByName("system_head")
			headlsystem:setVisible(false)
			local headlayout = self.m_bankerbg:getChildByName("layout_head")
			local head = PopupInfoHead:createClipHead(nil, 80,("head_mask.png"))
			head:setPosition(headlayout:getPosition())
			headlayout:addChild(head)
			--head:enableInfoPop(true)
			
			local name = string.EllipsisByConfig(userItem.dwGameID, 200, self.nicknameConfig)
            self.m_bankerName:setString("ID:"..name)
			self.m_bankerName:setTextFontSize(24)
            local bankerstr = ExternalFun.formatScoreFloatText(self.m_lBankerScore)
            temp:setString(bankerstr)
            scoretemp:setString(ExternalFun.formatScoreFloatText(self.m_lBankerWinAllScore))
            counttemp:setString(""..self.m_cbBankerTime)
			--self.text_lunshu:setString(""..self.m_cbCardRecordCount)
        end
    end
end

--初始化自己信息
function GameViewLayer:initSelfInfo()
	
	--头像
    local temp = PopupInfoHead:createClipHead(self:getMeUserItem(), 83, "head_mask.png")
    temp:setPosition(57,46)
    self.m_selfbg:addChild(temp)
    temp:enableInfoPop(true)
	
	--昵称
    local temp = self.m_selfbg:getChildByName("txt_name")
    local pselfname = ClipText:createClipText(cc.size(145, 26), "ID: "..self:getMeUserItem().dwGameID);
    pselfname:setAnchorPoint(temp:getAnchorPoint())
    pselfname:setPosition(temp:getPosition())
    pselfname:setName(temp:getName())
    temp:removeFromParent()
    self.m_selfbg:addChild(pselfname)
	
	--游戏币--艺术字
    --temp = self.m_selfbg:getChildByName("txt_score")
    --temp:setString(""..self.m_showScore)
	
	--游戏币--普通文本
	self.m_textScore = self.m_selfbg:getChildByName("score_text")
	self.m_textScore:setLocalZOrder(1)
end

--刷新自己信息
function GameViewLayer:resetSelfInfo()
    --local txt_score = self.m_selfbg:getChildByName("txt_score")
    --txt_score:setString(""..self.m_showScore)
	local str = ExternalFun.formatScoreFloatText(self.m_showScore)
	self.m_textScore:setString(str)
	
    --self.m_textScore:setString(string.format("%.2f",self.m_showScore))
end

--更新用户显示
function GameViewLayer:OnUpdateUserStatus(viewId)
	
end

--开始下一局，清空上局数据
function GameViewLayer:resetGameData() 
    if nil ~= self.m_cardLayer then
        self.m_cardLayer:stopAllActions()
    end
    
    for i=1,4 do
		if self.m_cardPointLayout[i] ~= nil then
            self.m_cardPointLayout[i]:removeAllChildren()
            self.m_cardPointLayout[i]:setVisible(false)
        end
        if self.m_CardArray[i] ~= nil then
            for k,v in pairs(self.m_CardArray[i]) do
                v:stopAllActions()
                v:setVisible(false)
                v:showCardBack(true)
            end
        end
        
    end
    self.m_lAllJettonScore = {0,0,0,0,0,0,0}
    self.m_lUserJettonScore = {0,0,0,0,0,0,0}
    self.m_lUserAllJetton = 0
    self:updateAreaScore(false)

    for k,v in pairs(self.m_JettAreaLight) do
        v:stopAllActions()
        v:setVisible(false)
    end

    --清空坐下用户下注分数
    for i=1,Game_CMD.MAX_OCCUPY_SEAT_COUNT do
        if nil ~= self.m_tabSitDownUser[i] then
            self.m_tabSitDownUser[i]:clearJettonScore()
        end
    end

    --游戏币清除
    self.m_goldLayer:removeAllChildren()
    self.m_goldList = {{}, {}, {}, {}, {}, {}, {}}

    if nil ~= self.m_gameResultLayer then
        self.m_gameResultLayer:setVisible(false)
    end
	
	self.m_sicebg1:stopAllActions()
	self.m_sicebg2:stopAllActions()
	self.m_sicebg1:setVisible(false)
	self.m_sicebg2:setVisible(false)
	
    self.m_bPlayGoldFlyIn = true
	
	self:stopAllActions()
end

function GameViewLayer:onExit()
    self:stopAllActions()
    self:unloadResource()
end

--点击事件
function GameViewLayer:onEventTouchCallback(eventType, x, y)
	if eventType == "ended" then
		local pos = cc.p(x,y)
		self.m_bshowMenu = true
		self:showMenu()
		
		if self.m_ControlLayer ~= nil then
			if self.m_ControlLayer:isVisible() then
				self.m_ControlLayer:onEventTouchCallback(eventType, x, y)
			end		
		end
		
	end
	return true	
end

--释放资源
function GameViewLayer:unloadResource()
    --特殊处理game_res blank.png 冲突
    cc.SpriteFrameCache:getInstance():removeSpriteFramesFromFile("game_res.plist")
    cc.Director:getInstance():getTextureCache():removeTextureForKey("game_res.png")
	
    cc.Director:getInstance():getTextureCache():removeTextureForKey("game_res/im_card.png")
	cc.Director:getInstance():getTextureCache():removeTextureForKey("game_res/im_small_card.png")
    cc.Director:getInstance():getTextureCache():removeUnusedTextures()
    cc.SpriteFrameCache:getInstance():removeUnusedSpriteFrames()

    --播放大厅背景音乐
    ExternalFun.playPlazzBackgroudAudio()

    -- --重置搜索路径
    -- local oldPaths = cc.FileUtils:getInstance():getSearchPaths();
    -- local newPaths = {};
    -- for k,v in pairs(oldPaths) do
    --     if tostring(v) ~= tostring(self._searchPath) then
    --         table.insert(newPaths, v);
    --     end
    -- end
    -- cc.FileUtils:getInstance():setSearchPaths(newPaths);

    self:getDataMgr():removeAllUser()
    self:getDataMgr():clearRecord()
	self:getDataMgr():clearCardRecord()
	
	--变量释放
	--self.m_actDropIn:release();
	--self.m_actDropOut:release();
	if nil ~= self.m_cardrecordListLayer then
		self.m_cardrecordListLayer:clear()

	end
	
    if nil ~= self.m_gameResultLayer then
        self.m_gameResultLayer:clear()
    end
end

function GameViewLayer:onButtonClickedEvent(tag, ref)
	ExternalFun.playClickEffect()
	if TAG_ENUM.BT_MENU == tag then
		self:showMenu()
	elseif TAG_ENUM.BT_CONTROL == tag then
		if self.m_ControlLayer == nil and self.m_bIsGameCheatUser == true then
			self.m_ControlLayer = ControlLayer:create(self)
			:addTo(self, 1000)
			self.m_ControlLayer:setVisible(true)
		elseif self.m_bIsGameCheatUser == true then
			self.m_ControlLayer:setVisible(true)
		end 
    elseif TAG_ENUM.BT_LUDAN == tag then
        if nil == self.m_GameRecordLayer then
            self.m_GameRecordLayer = GameRecordLayer:create(self)
            self:addToRootLayer(self.m_GameRecordLayer, ZORDER_LAYER.ZORDER_Other_Layer)
        end
        local recordList = self:getDataMgr():getGameRecord()     
        self.m_GameRecordLayer:refreshRecord(recordList)
    elseif TAG_ENUM.BT_BANK == tag then
        self:showMenu()
        if self.m_bGenreEducate == true then
            showToast(self, "练习模式，不能使用银行", 1.5)
            return
        end
        if 0 == GlobalUserItem.cbInsureEnabled then
            showToast(self, "初次使用，请先开通银行！", 1)
        end
        --空闲状态才能存款
        if nil == self.m_bankLayer then
            self:createBankLayer()
        end
        self.m_bankLayer:setVisible(true)
        self:refreshBankScore()
    elseif TAG_ENUM.BT_CLOSEBANK == tag  then
        if nil ~= self.m_bankLayer then
            self.m_bankLayer:setVisible(false)
        end
    elseif TAG_ENUM.BT_TAKESCORE == tag then
        self:onTakeScore()
    elseif TAG_ENUM.BT_SET == tag then
        --[[self:showMenu()
        local mgr = self._scene:getParentNode():getApp():getVersionMgr()
        local verstr = mgr:getResVersion(Game_CMD.KIND_ID) or "0"
        verstr = "游戏版本:" .. appdf.BASE_C_VERSION .. "." .. verstr
        local setting = SettingLayer:create(verstr)
        self:addToRootLayer(setting, ZORDER_LAYER.ZORDER_Other_Layer)--]]
		--版本号		
		local function asyncUpdateVersion(version)
			local strVersion = "游戏版本："..BaseConfig.BASE_C_VERSION.."."..(version or "0.0")
			if strVersion ~= nil then
				local setting = SettingLayer:create(strVersion)
				self:addToRootLayer(setting, ZORDER_LAYER.ZORDER_Other_Layer)
			end
		end
		local customEvent = cc.EventCustom:new(yl.RY_GET_GAME_VERSION_NOTIFY)
		customEvent.obj = {KindID = Game_CMD.KIND_ID, callback = asyncUpdateVersion}
		cc.Director:getInstance():getEventDispatcher():dispatchEvent(customEvent)

    -- if eventType == 1 then
    --     GlobalUserItem.setVoiceAble(eventType == 0)
    --     GlobalUserItem.setSoundAble(eventType == 0)
    --     eventType=0
    -- elseif eventType == 0 then
    --     GlobalUserItem.setVoiceAble(music)
    --     GlobalUserItem.setSoundAble(eventType == true)
    -- end
		
    elseif TAG_ENUM.BT_HELP == tag then
        self:showMenu()
        self._scene:getParentNode():popHelpLayer2(Game_CMD.KIND_ID, 0, 5)
    elseif TAG_ENUM.BT_QUIT == tag then
        --self:showMenu()
        self._scene:onQueryExitGame()
    --座位按钮
    elseif TAG_ENUM.BT_SEAT_0 <= tag and TAG_ENUM.BT_SEAT_5 >= tag then
        self:onSitDownClick(ref:getTag()-TAG_ENUM.BT_SEAT_0+1, ref)
    --下注按钮
    elseif TAG_ENUM.BT_JETTONSCORE_0 <= tag and TAG_ENUM.BT_JETTONSCORE_6 >= tag then
        self:onJettonButtonClicked(ref:getTag()-TAG_ENUM.BT_JETTONSCORE_0+1, ref)
    --下注区域
    elseif TAG_ENUM.BT_JETTONAREA_0 <= tag and  TAG_ENUM.BT_JETTONAREA_5 >= tag then
        self:onJettonAreaClicked(ref:getTag()-TAG_ENUM.BT_JETTONAREA_0+1, ref)
    elseif tag == TAG_ENUM.BT_USERLIST then
        --self:showMenu()
       --[[ if nil == self.m_userListLayer then
            self.m_userListLayer = UserListLayer:create()
            self:addToRootLayer(self.m_userListLayer, ZORDER_LAYER.ZORDER_Other_Layer)
        end
        local userList = self:getDataMgr():getUserList()
        self.m_userListLayer:showLayer()        
        self.m_userListLayer:refreshList(userList)--]]
		self:addToRootLayer(PlayerlistLayer:create(self._scene:getUserList()), TAG_ZORDER.POPUP_LAYER_ZORDER)
    elseif tag == TAG_ENUM.BT_APPLY then
         -- self.m_applyListLayer:setVisible(true)
        if nil == self.m_applyListLayer then
            self.m_applyListLayer = ApplyListLayer:create(self)
            self:addToRootLayer(self.m_applyListLayer, ZORDER_LAYER.ZORDER_Other_Layer)
        end
        local userList = self:getDataMgr():getApplyBankerUserList() 
        self.m_applyListLayer:showLayer()    
        self.m_applyListLayer:refreshList(userList)
    elseif tag == TAG_ENUM.BT_SUPPERROB then
        --超级抢庄
        if Game_CMD.SUPERBANKER_CONSUMETYPE == self.m_tabSupperRobConfig.superbankerType then
            local str = "超级抢庄将花费 " .. self.m_tabSupperRobConfig.lSuperBankerConsume .. ",确定抢庄?"
            local query = QueryDialog:create(str, function(ok)
                if ok == true then
                    self:getParentNode():sendRobBanker()
                end
            end):setCanTouchOutside(false)
                :addTo(self) 
        else
            self:getParentNode():sendRobBanker()
        end
	--重复下注
	elseif tag == TAG_ENUM.BT_REBET then
		self:onJettonAreaReClicked(self.m_nJettonArea, ref)

	--加倍下注
	elseif tag == TAG_ENUM.BT_DOUBLEDOWN then
		self:onJettonAreaDoubleClicked(self.m_nJettonArea, ref)
	elseif tag == TAG_ENUM.BT_GAMERULE then
		--游戏规则

        -- self._csbNodeAni:setAnimationEndCallFunc("stop1", function ()
        -- --self:enterViewFinished()
        --  --    self.armature:getAnimation():playWithIndex(4)
        --      self._csbNodeAni:play("SceneDown", false)
        -- end)


        --   self._csbNodeAni:setAnimationEndCallFunc("SceneDown", function ()
        -- --self:enterViewFinished()
        --  --    self.armature:getAnimation():playWithIndex(4)
        --     self.armature:getAnimation():playWithIndex(2)
        -- end)

        -- self:Animations()

         
		self:addToRootLayer(GameRuleLayer:create(self), TAG_ZORDER.POPUP_LAYER_ZORDER)
	elseif tag == TAG_ENUM.BT_CARDRECORD then
		--开牌记录
		if nil == self.m_cardrecordListLayer then
			self.m_cardrecordListLayer = CardRecordLayer:create(self)
			self:addToRootLayer(self.m_cardrecordListLayer, TAG_ZORDER.POPUP_LAYER_ZORDER)
		end
		local cardRecordList = self:getDataMgr():getCardRecord() 
		--self.m_cardrecordListLayer:showLayer()    
		self.m_cardrecordListLayer:refreshCardRecord(cardRecordList)
		--self:addToRootLayer(CardRecordLayer:create(self), TAG_ZORDER.POPUP_LAYER_ZORDER)
    else
        showToast(self,"功能尚未开放！",1)
	end
end


function GameViewLayer:Animations()


        local function animationEvent(armatureBack,movementType,movementID)
            local id = movementID
            print("............."..movementID)
            print("movementType")
            dump(movementType)
            if movementType == ccs.MovementEventType.complete then
                if 
                    -- id == "Animation1" and movementType == 1 then
                    -- self.armature_heguan:getAnimation():playWithIndex(3)
                
                 -- elseif
                  id=="Animation4"and movementType == 1 then

               --   --   armatureBack::runAction(cc.Sequence:create(cc.CallFunc:create(function()self.armature:getAnimation():playWithIndex(2)end)))
                    self.armature_heguan:getAnimation():playWithIndex(2)
                    self.Card_stack:setVisible(true)
                   
                    -- self.armature_touzi:setVisible(true)
                    -- self.armature_touzi:getAnimation():playWithIndex(1)
                    -- self.armature_touzi2:getAnimation():playWithIndex(self.m_dicesecond+5)
                    -- self.armature_shaizhong1:getAnimation():playWithIndex(12)
                    -- self.armature_shaizhong1:getAnimation():playWithIndex(13)
                elseif id=="Animation3"and movementType == 1 then
                    if self.playTime == nil then 
                        self.playTime = 1
                    elseif self.playTime == 4 then
                        self.playTime=1
                    end

                     self.armature_touzi:setVisible(true)
                    self.armature_touzi:getAnimation():playWithIndex(self.m_dicefirst)
                    self.armature_touzi0:setVisible(true)
                    self.armature_touzi0:getAnimation():playWithIndex(self.m_dicesecond)
                    self.armature_touzi1:setVisible(true)
                    self.armature_touzi1:getAnimation():playWithIndex(13)
                    self.armature_touzi2:setVisible(true)
                    self.armature_touzi2:getAnimation():playWithIndex(12)
                    -- self:sendCard_num(self.playTime)
                    
                    -- self._csbNodeAni:play("cardmove1", false)
                     -- self: CardMoveNum(self.playTime)
                    -- self:sendCard_num(self.playTime)

                    self.armature_heguan:getAnimation():playWithIndex(1,-1,0)
                 elseif id=="Animation2"and movementType == 1 then
                    self.Card_stack:setVisible(true)
                    self.cardmove_num:setVisible(true)
                    -- self: CardMoveNum(self.playTime)
                    -- 
                    -- if self.playTime <= 4 then 
                        
                    --      self.playTime =  self.playTime + 1
                          
                    --      -- self:sendCard_num(self.playTime)
                         self: CardMoveNum(self.playTime)
                    --      -- self:CardMoveNum(self.playTime)
                                                   
                    -- else
                    --     -- self.m_TimeProgress:move(self.m_TimeProgress:getPositionX(),self.m_TimeProgress:getPositionY()+130)
                    -- end
                    -- self.armature:setVisible(false)
                end
            end
        end

        self.armature_heguan:getAnimation():setMovementEventCallFunc(animationEvent)

        self.m_TimeProgress:runAction(cc.Sequence:create(cc.CallFunc:create(function()
                    self._csbNodeAni:play("stop1", false)
                    
                    -- self._csbNodeAni:play("stop2", false)
                    self.stopbetbg_:setVisible(true)

            end)
          ,cc.DelayTime:create(0.5),
            cc.CallFunc:create(function()

                    self._csbNodeAni:play("stop2", false)
                    self.stopbetbg_:setVisible(false)
                    end),cc.DelayTime:create(0.5),
            cc.CallFunc:create(function()
                self.m_TimeProgress:move(self.m_TimeProgress:getPositionX(),self.m_TimeProgress:getPositionY()-130)
                self.btnapply:setVisible(false)
                    self._csbNodeAni:play("SceneDown", false)
                     self.m_GameRecordLayer:setVisible(false)
                     -- self.m_applyListLayer:setVisible(false)
                     self.m_bankerbg:setVisible(false)
                    self.armature_heguan:setVisible(true)
            end),cc.DelayTime:create(0.5),
            cc.CallFunc:create(function()

                      self.armature_heguan:getAnimation():playWithIndex(3)
                    -- self.armature_heguan:getAnimation():playWithIndex(0)
            end)
            --,cc.DelayTime:create(2), 
            -- cc.CallFunc:create(function()
            --        self.armature:getAnimation():playWithIndex(3)
            -- end),cc.DelayTime:create(4),
            -- cc.CallFunc:create(function()m_menulayout
            --         self.armature:getAnimation():playWithIndex(2)
            -- end),cc.DelayTime:create(2),
            -- cc.CallFunc:create(function()
            --        self.armature:getAnimation():playWithIndex(1)
            -- end),cc.DelayTime:create(3),
            -- cc.CallFunc:create(function()
            --      self.armature:setVisible(false)
            --     self._csbNodeAni:play("SceneUP", false)
            --     self.armature:getAnimation():playWithIndex(0)
            -- end)
    
        ))

    -- body
end

--移动判断
function GameViewLayer:CardMoveNum(num)
            -- body
            if num == 1 then
                -- self.playTime = 1
                self:sendCard_num(num)
                self._csbNodeAni:play("cardmove1", false)
            elseif num == 2 then
                self:sendCard_num(num)
                self._csbNodeAni:play("cardmove2", false)
            elseif num==3 then
                self:sendCard_num(num)
                self._csbNodeAni:play("cardmove3", false)
            elseif num==4 then
                self:sendCard_num(num)
                self._csbNodeAni:play("cardmove4", false)
            end
end
--test
function GameViewLayer:sendCard_num(num)
    
    if num then
        local delaytime = 0.1
            local mm = (self.m_dicepoint + num - 2)%4+1
            for j=1,2 do
                local card = self.m_CardArray[mm][j]
                local index = (num-1)*5 + j - 1
                card:setPosition(677, 580)
                card:stopAllActions()
                self.card=card
                card:runAction(cc.Sequence:create(
                    -- cc.DelayTime:create(delaytime*index), 
                    cc.CallFunc:create(
                    function()
                        if j == 1 then
                            ExternalFun.playSoundEffect("send_card.wav")
                        end
                        card:setOpacity(0)
                        card:setVisible(true)
                        card:runAction(cc.FadeTo:create(0.04, 255))
                        card:runAction(cc.Sequence:create(cc.MoveTo:create(0.33, cardpoint[mm]), 
                            cc.MoveBy:create(0.04*(j-1), cc.p(70*(j-1),0))))
                    end
                    
                ),cc.CallFunc:create(function ()
                        if j==2 then

                            if self.playTime<4 then
                                
                                -- self:CardMoveNum(self.playTime)
                                self.playTime =  self.playTime + 1
                                self.armature_heguan:getAnimation():playWithIndex(1,-1,0)
                                

                            else

                                self.playTime=1
                                -- self.playTime =  self.playTime + 1
                                 self.armature_touzi:setVisible(false)
                                self.armature_touzi0:setVisible(false)
                                self.armature_touzi1:setVisible(false)
                                self.armature_touzi2:setVisible(false)
                                self.cardmove_num:setVisible(false)
                                self.armature_heguan:setVisible(false)
                                 self.m_GameRecordLayer:setVisible(true)
                                 self.btnapply:setVisible(true)
                                 -- self.m_applyListLayer:setVisible(true)
                                 self.m_bankerbg:setVisible(true)
                                 self.m_TimeProgress:move(self.m_TimeProgress:getPositionX(),self.m_TimeProgress:getPositionY()+130)
                                 self._csbNodeAni:play("SceneUP", false)
                            end
                        end
                    end)))    
            end
    else
        for i=1,4 do
            for j=1,2 do
                local card = self.m_CardArray[i][j]
                card:setVisible(true)
                card:setPosition(cardpoint[i].x + (j-1)*70, cardpoint[i].y)
            end
        end
    end
   
    
end


--下注响应
function GameViewLayer:onJettonButtonClicked(tag, ref)
    self.m_nJettonSelect = tag
	if self.m_nJettonSelect >= 0 and self.m_nJettonSelect <= 5 then
		self.m_JettonRectLight:setVisible(false)
		self.m_JettonLight:setVisible(true)
		--self.m_JettonLight:setPositionX(ref:getPositionX())
		self.m_JettonLight:setPosition(ref:getPosition())
	else
		self.m_JettonLight:setVisible(false)
		self.m_JettonRectLight:setVisible(true)
		self.m_JettonRectLight:setPosition(ref:getPosition())
		--self.m_JettonRectLight:setPositionX(ref:getPositionX())
		--self.m_JettonRectLight:setPositionY(ref:getPositionY()+3)
	end
    
	
end



--下注区域
function GameViewLayer:onJettonAreaClicked(tag, ref)
	
	self.m_nJettonArea = tag
    --非下注状态
    if self.m_cbGameStatus ~= Game_CMD.GAME_SCENE_JETTON or self.m_nJettonSelect == 0 then
        return
    end

    if self:isMeChair(self.m_wBankerUser) == true then
        return
    end
    
    if self.m_bEnableSysBanker == 0 and self.m_wBankerUser == yl.INVALID_CHAIR then
        showToast(self,"无人坐庄，不能下注",1) 
        return
    end

    local jettonscore = GameViewLayer.m_BTJettonScore[self.m_nJettonSelect]
    --
    local selfscore  = (jettonscore + self.m_lUserAllJetton)*MaxTimes
    if  selfscore > self.m_lUserMaxScore then
        showToast(self,"已超过个人最大下注值",1)
        return
    end

    local areascore = self.m_lAllJettonScore[tag+1] + jettonscore
    if areascore > self.m_lAreaLimitScore then
        showToast(self,"已超过该区域最大下注值",1)
        return
    end

    if self.m_wBankerUser ~= yl.INVALID_CHAIR then
        local allscore = jettonscore
        for k,v in pairs(self.m_lAllJettonScore) do
            allscore = allscore + v
        end
        allscore = allscore*MaxTimes
        if allscore > self.m_lBankerScore then
            showToast(self,"总下注已超过庄家下注上限",1)
            return
        end
    end
    
    self.m_lUserAllJetton = self.m_lUserAllJetton + jettonscore
    self:updateJettonList(self.m_lUserMaxScore - self.m_lUserAllJetton*MaxTimes)
    local userself = self:getMeUserItem()   
    if userself and userself.lScore < 50 then
     self.btquit:setEnabled(true)
     self.m_lUserAllJetton=0
		showToast(self, "真遗憾!玩家金币大于 " .. 50 .. " 才可以下注!", 1)
        
        return
	end
    self:getParentNode():SendPlaceJetton(jettonscore, tag)
end

--下注区域--重复下注
function GameViewLayer:onJettonAreaReClicked(tag, ref)
	
	self.m_nJettonArea = tag
    --非下注状态
    if self.m_cbGameStatus ~= Game_CMD.GAME_SCENE_JETTON or self.m_nJettonSelect == 0 then
        return
    end

    if self:isMeChair(self.m_wBankerUser) == true then
        return
    end
    
    if self.m_bEnableSysBanker == 0 and self.m_wBankerUser == yl.INVALID_CHAIR then
        showToast(self,"无人坐庄，不能下注",1) 
        return
    end
	

	--[[for k,v in pairs(self.m_lUserRecordJettonScore) do
		self.m_lUserRecordJettonScore = self.m_lUserRecordJettonScore + v
	 end--]]
	self.m_lUserAllRecordJettonScore = self.m_lUserRecordJettonScore[2] + self.m_lUserRecordJettonScore[3]+self.m_lUserRecordJettonScore[4]
									 +self.m_lUserRecordJettonScore[5]+self.m_lUserRecordJettonScore[6]+self.m_lUserRecordJettonScore[7]
    local jettonscore = GameViewLayer.m_BTJettonScore[self.m_nJettonSelect]
    --
    local selfscore  = (jettonscore + self.m_lUserAllJetton)*MaxTimes
	local selfrecordscore = (self.m_lUserAllRecordJettonScore + self.m_lUserAllJetton)*MaxTimes
    if  selfscore > self.m_lUserMaxScore or selfrecordscore > self.m_lUserMaxScore then
        showToast(self,"已超过个人最大下注值",1)
        return
    end

    local areascore = self.m_lAllJettonScore[tag+1] + jettonscore
	local arearecordscore = self.m_lAllJettonScore[tag+1] + self.m_lUserAllRecordJettonScore
    if areascore > self.m_lAreaLimitScore or arearecordscore > self.m_lAreaLimitScore then
        showToast(self,"已超过该区域最大下注值",1)
        return
    end

    if self.m_wBankerUser ~= yl.INVALID_CHAIR then
        local allscore = jettonscore
		local allrecordscore = self.m_lUserAllRecordJettonScore
        for k,v in pairs(self.m_lAllJettonScore) do
            allscore = allscore + v
        end
        allscore = allscore*MaxTimes
		allrecordscore = allrecordscore*MaxTimes
        if allscore > self.m_lBankerScore or allrecordscore > self.m_lBankerScore then
            showToast(self,"总下注已超过庄家下注上限",1)
            return
        end
    end
    
    self.m_lUserAllJetton = self.m_lUserAllJetton + jettonscore
    self:updateJettonList(self.m_lUserMaxScore - self.m_lUserAllJetton*MaxTimes)
    local userself = self:getMeUserItem()   
    --self:getParentNode():SendPlaceJetton(jettonscore, tag)
	
	for i=1,6 do
		if self.m_lUserRecordJettonScore[i+1] > 0 then
			self:getParentNode():SendPlaceJetton(self.m_lUserRecordJettonScore[i+1], i)
		end
	end
	
	self.bt_rebet:setEnabled(false)
	self.bt_doubledown:setEnabled(false)
end

--下注区域-加倍下注
function GameViewLayer:onJettonAreaDoubleClicked(tag, ref)
	
	self.m_nJettonArea = tag
	
    --非下注状态
    if self.m_cbGameStatus ~= Game_CMD.GAME_SCENE_JETTON or self.m_nJettonSelect == 0 then
        return
    end
    if self.m_recordlUserAllJetton == 0 or self.m_recordlUserAllJetton == nil then
		return
	end
	
    if self:isMeChair(self.m_wBankerUser) == true then
        return
    end
    
    if self.m_bEnableSysBanker == 0 and self.m_wBankerUser == yl.INVALID_CHAIR then
        showToast(self,"无人坐庄，不能下注",1) 
        return
    end
	
	--上局玩家自己下注总值*2即为加倍下注后的值
	--local jettonscore = self.m_recordlUserAllJetton *2
    --
    self.m_lUserAllRecordJettonScore = self.m_lUserRecordJettonScore[2]*2 + self.m_lUserRecordJettonScore[3]*2+self.m_lUserRecordJettonScore[4]*2
									 +self.m_lUserRecordJettonScore[5]*2+self.m_lUserRecordJettonScore[6]*2+self.m_lUserRecordJettonScore[7]*2
    local jettonscore = GameViewLayer.m_BTJettonScore[self.m_nJettonSelect]
    --
    local selfscore  = (jettonscore + self.m_lUserAllJetton)*MaxTimes
	local selfrecordscore = (self.m_lUserAllRecordJettonScore + self.m_lUserAllJetton)*MaxTimes
    if  selfscore > self.m_lUserMaxScore or selfrecordscore > self.m_lUserMaxScore then
        showToast(self,"已超过个人最大下注值",1)
        return
    end

    local areascore = self.m_lAllJettonScore[tag+1] + jettonscore
	local arearecordscore = self.m_lAllJettonScore[tag+1] + self.m_lUserAllRecordJettonScore
    if areascore > self.m_lAreaLimitScore or arearecordscore > self.m_lAreaLimitScore then
        showToast(self,"已超过该区域最大下注值",1)
        return
    end

    if self.m_wBankerUser ~= yl.INVALID_CHAIR then
        local allscore = jettonscore
		local allrecordscore = self.m_lUserAllRecordJettonScore
        for k,v in pairs(self.m_lAllJettonScore) do
            allscore = allscore + v
        end
        allscore = allscore*MaxTimes
		allrecordscore = allrecordscore*MaxTimes
        if allscore > self.m_lBankerScore or allrecordscore > self.m_lBankerScore then
            showToast(self,"总下注已超过庄家下注上限",1)
            return
        end
    end
    
    self.m_lUserAllJetton = self.m_lUserAllJetton + jettonscore
    self:updateJettonList(self.m_lUserMaxScore - self.m_lUserAllJetton*MaxTimes)
    local userself = self:getMeUserItem()   
    --self:getParentNode():SendPlaceJetton(jettonscore, tag)
	
	for i=1,6 do
		if self.m_lUserRecordJettonScore[i+1] > 0 then
			self:getParentNode():SendPlaceJetton(self.m_lUserRecordJettonScore[i+1]*2, i)
		end
	end
	
	self.bt_rebet:setEnabled(false)
	self.bt_doubledown:setEnabled(false)
end

function GameViewLayer:onSitDownClick( tag, sender )
    print("sit ==> " .. tag)
    local useritem = self:getMeUserItem()
    if nil == useritem then
        return
    end

    --重复判断
    if nil ~= self.m_nSelfSitIdx and tag == self.m_nSelfSitIdx then
        return
    end

    if nil ~= self.m_nSelfSitIdx and nil ~= self.m_tabSitDownUser[tag] then --and tag ~= self.m_nSelfSitIdx  then
        return
    elseif nil ~= self.m_nSelfSitIdx then
        showToast(self, "当前已占 " .. self.m_nSelfSitIdx .. " 号位置,不能重复占位!", 1)
        return
        -- return
    end

    if nil ~= self.m_tabSitDownUser[tag] and nil == self.m_nSelfSitIdx then
        showToast(self, self.m_tabSitDownUser[tag]:getNickName().."已经捷足先登了!", 1)
        return
    end

    if useritem.lScore < self.m_tabSitDownConfig.lForceStandUpCondition then
        local str = "坐下需要携带 " .. self.m_tabSitDownConfig.lForceStandUpCondition .. " 游戏币,游戏币不足!"
        showToast(self, str, 2)
        return
    end

    --坐下条件限制
    if self.m_tabSitDownConfig.occupyseatType == Game_CMD.OCCUPYSEAT_CONSUMETYPE then --游戏币占座
        if useritem.lScore < self.m_tabSitDownConfig.lOccupySeatConsume then
            local str = "坐下需要消耗 " .. self.m_tabSitDownConfig.lOccupySeatConsume .. " 游戏币,游戏币不足!"
            showToast(self, str, 1)
            return
        end
        local str = "坐下将花费 " .. self.m_tabSitDownConfig.lOccupySeatConsume .. ",确定坐下?"
            local query = QueryDialog:create(str, function(ok)
                if ok == true then
                    self:getParentNode():sendSitDown(tag - 1, useritem.wChairID)
                end
            end):setCanTouchOutside(false)
                :addTo(self)
    elseif self.m_tabSitDownConfig.occupyseatType == Game_CMD.OCCUPYSEAT_VIPTYPE then --会员占座
        if useritem.cbMemberOrder < self.m_tabSitDownConfig.enVipIndex then
            local str = "坐下需要会员等级为 " .. self.m_tabSitDownConfig.enVipIndex .. " 会员等级不足!"
            showToast(self, str, 1)
            return
        end
        self:getParentNode():sendSitDown(tag - 1, self:getMeUserItem().wChairID)
    elseif self.m_tabSitDownConfig.occupyseatType == Game_CMD.OCCUPYSEAT_FREETYPE then --免费占座
        if useritem.lScore < self.m_tabSitDownConfig.lOccupySeatFree then
            local str = "免费坐下需要携带游戏币大于 " .. self.m_tabSitDownConfig.lOccupySeatFree .. " ,当前携带游戏币不足!"
            showToast(self, str, 1)
            return
        end
        self:getParentNode():sendSitDown(tag - 1, self:getMeUserItem().wChairID)
    end
end

function GameViewLayer:OnUpdataClockView(chair, time)
    local selfchair = self:getParent():GetMeChairID()
    local temp = self.m_timeLayout:getChildByName("txt_time")
    temp:setString(string.format("%d", time))

    if chair == self:getParentNode():SwitchViewChairID(selfchair) then
		if self.m_ControlLayer ~= nil and self.m_bIsGameCheatUser == true then
			if self.m_ControlLayer:isVisible() then
				self.m_ControlLayer:OnUpdataClockView(time)
				self.m_ControlLayer:OnUpdatastate(self.m_cbGameStatus)
			end		
		end
		
        if self.m_cbGameStatus == Game_CMD.GAME_SCENE_JETTON then
            self.m_bPlayGoldFlyIn = true
            self.m_fJettonTime = math.min(0.1, time)
        end
    else
        if self.m_cbGameStatus ~= Game_CMD.GAME_SCENE_END then
            return
        end
		
		if self.m_ControlLayer ~= nil and self.m_bIsGameCheatUser == true then
			if self.m_ControlLayer:isVisible() then
				self.m_ControlLayer:OnUpdataClockView(time)
				self.m_ControlLayer:OnUpdatastate(self.m_cbGameStatus)
			end		
		end
		
		if time == self.m_cbTimeLeave then
			-- self:ShowDice(true)
			-- self.m_sicebg1:setVisible(true)
			-- self.m_sicebg2:setVisible(true)
   --      elseif time == self.m_cbTimeLeave-2 then
   --          --发牌处理
   --          self:sendCard(true)
         self:Animations()
		elseif time == self.m_cbTimeLeave-12 then
			self.m_sicebg1:stopAllActions()
			self.m_sicebg2:stopAllActions()
			self.m_sicebg1:setVisible(false)
			self.m_sicebg2:setVisible(false)
        elseif time == self.m_cbTimeLeave-13  then
            --显示点数
            self:showCard(true)
        elseif time == self.m_cbTimeLeave-18 then
            --游戏币处理
            self:showGoldMove()
        end
    end
end

--获取数据
function GameViewLayer:getParentNode()
    return self._scene
end

function GameViewLayer:getMeUserItem()
    if nil ~= GlobalUserItem.dwUserID then
        return self:getDataMgr():getUidUserList()[GlobalUserItem.dwUserID]
    end
    return nil
end

function GameViewLayer:isMeChair( wchair )
    local useritem = self:getDataMgr():getChairUserList()[wchair + 1]
    if nil == useritem then
        return false
    else 
        return useritem.dwUserID == GlobalUserItem.dwUserID
    end
end

function GameViewLayer:addToRootLayer( node , zorder)
    if nil == node then
        return
    end

    self.m_rootLayer:addChild(node)
    node:setLocalZOrder(zorder)
end

function GameViewLayer:getChildFromRootLayer( tag )
    if nil == tag then
        return nil
    end
    return self.m_rootLayer:getChildByTag(tag)
end

function GameViewLayer:getDataMgr( )
    return self:getParentNode():getDataMgr()
end

function GameViewLayer:getApplyState(  )
    return self.m_enApplyState
end

function GameViewLayer:getApplyCondition(  )
    return self.m_llCondition
end

--获取能否上庄
function GameViewLayer:getApplyable(  )
    --自己超级抢庄已申请，则不可进行普通申请
    if APPLY_STATE.kSupperApplyed == self.m_enApplyState then
        return false
    end

    local userItem = self:getMeUserItem()
    if nil ~= userItem then
        return userItem.lScore > self.m_llCondition
    else
        return false
    end
end

--获取能否取消上庄
function GameViewLayer:getCancelable(  )
    return self.m_cbGameStatus == Game_CMD.GAME_SCENE_FREE
end

function GameViewLayer:logData(msg)
    local p = self:getParentNode()
    if nil ~= p.logData then
        p:logData(msg)
    end 
end

function GameViewLayer:showPopWait( )
    self:getParentNode():showPopWait()
end

function GameViewLayer:dismissPopWait( )
    self:getParentNode():dismissPopWait()
end

----网络消息处理------- 
function GameViewLayer:onGameSceneFree(cmd_table)
    --玩家分数
    self.m_lUserMaxScore = cmd_table.lUserMaxScore
    self.m_lApplyBankerCondition = cmd_table.lApplyBankerCondition
    self.m_cbTimeLeave = cmd_table.cbTimeLeave
    self.m_wBankerUser = cmd_table.wBankerUser
    self.m_lBankerScore = cmd_table.lBankerScore
    self.m_lBankerWinAllScore = cmd_table.lBankerWinScore
    self.m_cbBankerTime = cmd_table.cbBankerTime
    self.m_bEnableSysBanker = cmd_table.bEnableSysbanker
    self.m_lAreaLimitScore = cmd_table.lAreaLimitScore
    self.m_bGenreEducate = cmd_table.bGenreEducate
	self.m_cbCardRecordCount = cmd_table.cbCardRecordCount
	self.m_bIsGameCheatUser = cmd_table.bIsGameCheatUser
	
    self:resetBankerInfo()
    self:resetSelfInfo()
    self.m_cbGameStatus = Game_CMD.GAME_SCENE_FREE
    self:showGameStatus()
    self.m_lAllJettonScore = {0,0,0,0,0,0,0}
    self.m_lUserJettonScore = {0,0,0,0,0,0,0}
    self.m_lUserAllJetton = 0
	
    --获取到占位信息
    self:onGetSitDownInfo(cmd_table.occupyseatConfig, cmd_table.wOccupySeatChairID[1])
    --抢庄条件
    self:onGetApplyBankerCondition(cmd_table.lApplyBankerCondition, cmd_table.superbankerConfig)
    self:setJettonEnable(false)
    self:updateAreaScore(false)
    --self:updateJettonList(self.m_lUserMaxScore)
	
	if self.m_sicebg1 or self.m_sicebg2 ~=nil then
		self.m_sicebg1:stopAllActions()
		self.m_sicebg2:stopAllActions()
		self.m_sicebg1:setVisible(false)
		self.m_sicebg2:setVisible(false)
	end
	
	if self.m_ControlLayer ~= nil then
				self.m_ControlLayer:removeAllItem()
		if cmd_table.cbControlStyle ~= 0 then
			self.m_ControlLayer:OnControlstate(cmd_table.cbControlStyle,cmd_table.cbArea[1])		
		end
	end
	
end

function GameViewLayer:onGameScenePlaying(cmd_table)
    --玩家分数
    self.m_lUserMaxScore = cmd_table.lUserMaxScore
    self.m_lApplyBankerCondition = cmd_table.lApplyBankerCondition
    self.m_cbTimeLeave = cmd_table.cbTimeLeave
    self.m_wBankerUser = cmd_table.wBankerUser
    self.m_lBankerScore = cmd_table.lBankerScore
    self.m_lBankerWinAllScore = cmd_table.lBankerWinScore
    self.m_cbBankerTime = cmd_table.cbBankerTime
    self.m_bEnableSysBanker = cmd_table.bEnableSysbanker
    self.m_lAreaLimitScore = cmd_table.lAreaLimitScore
    self.m_bGenreEducate = cmd_table.bGenreEducate
	self.m_cbCardRecordCount = cmd_table.cbCardRecordCount
	self.m_bIsGameCheatUser = cmd_table.bIsGameCheatUser
	
    self:resetBankerInfo()
    self:resetSelfInfo()
    self.m_cbGameStatus = Game_CMD.GAME_SCENE_FREE
    self.m_lAllJettonScore = cmd_table.lAllJettonScore[1]
    self.m_lUserJettonScore = cmd_table.lUserJettonScore[1]

    self.m_lOccupySeatUserWinScore = cmd_table.lOccupySeatUserWinScore

    local bankername = "系统"
    if  self.m_wBankerUser ~= yl.INVALID_CHAIR then
        local useritem = self:getDataMgr():getChairUserList()[self.m_wBankerUser + 1]
        if nil ~= useritem then
            bankername = useritem.szNickName
        end
    end
    self.m_tBankerName = bankername
	
	if self:isMeChair(self.m_wBankerUser) == true then

		self.btquit:setEnabled(false)
		self.m_enApplyState = APPLY_STATE.kApplyedState
	end
	
    self.m_lSelfWinScore = cmd_table.lEndUserScore
    self.m_lSelfReturnScore = cmd_table.lEndUserReturnScore
    self.m_lBankerWinScore = cmd_table.lEndBankerScore
    for k,v in pairs(self.m_lUserJettonScore) do
        self.m_lUserAllJetton = self.m_lUserAllJetton + v
    end
    
    self.m_cbTableCardArray = cmd_table.cbTableCardArray
    if cmd_table.cbGameStatus == Game_CMD.GAME_SCENE_JETTON then
        self.m_cbGameStatus = Game_CMD.GAME_SCENE_JETTON
        self:getParent():SetGameClock(self:getParent():GetMeChairID(), 1, cmd_table.cbTimeLeave)
        self:setJettonEnable(true)
        self:updateJettonList(self.m_lUserMaxScore - self.m_lUserAllJetton*MaxTimes)
        self:updateAreaScore(true)
    else
        self:setJettonEnable(false)
        --自己是否下注
        local jettonscore = 0
        for k,v in pairs(cmd_table.lUserJettonScore[1]) do
            jettonscore = jettonscore + v
        end
        --自己是否有输赢
        jettonscore = jettonscore + self.m_lSelfWinScore
        self.m_cbGameStatus = Game_CMD.GAME_SCENE_END
        self:getParent():SetGameClock(self:getParent():GetMeChairID(), 1, self.m_cbTimeLeave)
        self:sendCard(false) 
        self:showCard(false)
        self:showGameEnd(false)
        self:updateAreaScore(true)
            
    end
    self:showGameStatus()
    --获取到占位信息
    self:onGetSitDownInfo(cmd_table.occupyseatConfig, cmd_table.wOccupySeatChairID[1])
    --抢庄条件
    self:onGetApplyBankerCondition(cmd_table.lApplyBankerCondition, cmd_table.superbankerConfig)
	
	if self.m_sicebg1 or self.m_sicebg2 ~=nil then
		self.m_sicebg1:stopAllActions()
		self.m_sicebg2:stopAllActions()
		self.m_sicebg1:setVisible(false)
		self.m_sicebg2:setVisible(false)
	end
	
	if self.m_ControlLayer ~= nil then
				self.m_ControlLayer:removeAllItem()
		if cmd_table.cbControlStyle ~= 0 then
			self.m_ControlLayer:OnControlstate(cmd_table.cbControlStyle,cmd_table.cbArea[1])		
		end
	end
	
end

--空闲
function GameViewLayer:onGameFree(cmd_table)
    self.m_cbGameStatus = Game_CMD.GAME_SCENE_FREE
    self.m_cbTimeLeave = cmd_table.cbTimeLeave
    self:showGameStatus()
	self.btquit:setEnabled(true)
	
	--记录上局玩家各区域的下注值
	for i = 1,6  do
		self.m_lUserRecordJettonScore[i+1] = self.m_lUserJettonScore[i+1]
	end
    self.m_lAllJettonScore = {0,0,0,0,0,0,0}
    self.m_lUserJettonScore = {0,0,0,0,0,0,0}
	self.textAllJetton:setString(0)
	self.textUserAllJetton:setString(0)
	--记录上局用户总下注值
	self.m_recordlUserAllJetton = self.m_lUserAllJetton
    self:resetGameData()
    self:setJettonEnable(false)
    --上庄条件刷新
    self:refreshCondition()
	
	if cmd_table.cbControl == 0 then
		if self.m_ControlLayer ~= nil and self.m_bIsGameCheatUser == true then
			self.m_ControlLayer:OnControlEnd()
			for i = 1,6  do
				self.m_ControlLayer:OnSetAreaScore(i,0)
			end
			self.m_ControlLayer:cleanAreaBet()
		end
	end
	if self.m_ControlLayer ~= nil and self.m_bIsGameCheatUser == true then
		for i = 1,6  do
			self.m_ControlLayer:OnSetAreaScore(i,0)
		end
		self.m_ControlLayer:cleanAreaBet()
	end
	
    --申请按钮状态更新
    self:refreshApplyBtnState()
end

--开始下注
function GameViewLayer:onGameStart(cmd_table)
    ExternalFun.playSoundEffect("game_start.wav")
    self.m_cbGameStatus = Game_CMD.GAME_SCENE_JETTON
    self.m_cbTimeLeave = cmd_table.cbTimeLeave
    self.m_lUserMaxScore = cmd_table.lUserMaxScore
    self.m_wBankerUser = cmd_table.wBankerUser
    self.m_lBankerScore = cmd_table.lBankerScore
    self:showGameStatus()
    self:setJettonEnable(true)
    self:resetBankerInfo()
    self:updateJettonList(self.m_lUserMaxScore)
    print("下注最大值,",self.m_lUserMaxScore)
    if self:isMeChair(self.m_wBankerUser) == true then
        self:setJettonEnable(false)
    end

   if self.m_lUserAllJetton > 0 then
    self.btquit:setEnabled(false)
    else
    self.btquit:setEnabled(true)
    end


    --申请按钮状态更新
    self:refreshApplyBtnState()

    --显示提示
    if cmd_table.bContinueCard then
        self:showGameTips(TIP_TYPE.TypeContinueSend)
    else
        self:showGameTips(TIP_TYPE.TypeReSend)
    end
end

--结束
function GameViewLayer:onGameEnd(cmd_table)
    dump(cmd_table, "比赛结束信息", 10)
    self.m_cbGameStatus = Game_CMD.GAME_SCENE_END
	self.m_cbTimeLeave = cmd_table.cbTimeLeave
    self.m_cbTableCardArray = cmd_table.cbTableCardArray
    self.m_lSelfWinScore = cmd_table.lUserScore
    self.m_lSelfReturnScore = cmd_table.lUserReturnScore
    self.m_lBankerWinScore = cmd_table.lBankerScore
    self.m_lOccupySeatUserWinScore = cmd_table.lOccupySeatUserWinScore
    self.m_lBankerWinAllScore = cmd_table.lBankerTotallScore
    self.m_cbBankerTime = cmd_table.nBankerTime
	self.m_cbCardRecordCount = cmd_table.nCardRecordCount
	
	--获取色子的点数
	self.m_dicefirst = cmd_table.bcFirstCard
	self.m_dicesecond = cmd_table.bcNextCard
	--两个色子的和(色子总点数)
	self.m_dicepoint = self.m_dicefirst + self.m_dicesecond
	
    local bankername = "系统"
    if  self.m_wBankerUser ~= yl.INVALID_CHAIR then
        local useritem = self:getDataMgr():getChairUserList()[self.m_wBankerUser + 1]
        if nil ~= useritem then
            bankername = useritem.szNickName
        end
    end
    self.m_tBankerName = bankername
    --self:resetBankerInfo()
    self:showGameStatus()
    self:setJettonEnable(false)
	
	if self:isMeChair(self.m_wBankerUser) == true then
        self:setJettonEnable(false)
		self.btquit:setEnabled(false)
    end
end

--用户下注
function GameViewLayer:onPlaceJetton(cmd_table)
    if self:isMeChair(cmd_table.wChairID) == true then
        local oldscore = self.m_lUserJettonScore[cmd_table.cbJettonArea+1]
        self.m_lUserJettonScore[cmd_table.cbJettonArea+1] = oldscore + cmd_table.lJettonScore  
    end
    
    local oldscore = self.m_lAllJettonScore[cmd_table.cbJettonArea+1]
    self.m_lAllJettonScore[cmd_table.cbJettonArea+1] = oldscore + cmd_table.lJettonScore
	
	local useritem = self:getDataMgr():getChairUserList()[cmd_table.wChairID + 1]
	if self.m_ControlLayer ~= nil then
		for i = 1,6  do
			self.m_ControlLayer:OnSetAreaScore(i,self.m_lAllJettonScore[i+1])
		end
		if nil~=useritem then
			self.m_ControlLayer:setPlayerAreaBet(useritem.dwGameID,cmd_table.cbJettonArea,cmd_table.lJettonScore,cmd_table.lJettonScore,0,0,cmd_table.bIsAndroid,0,cmd_table.lAreaAllJetton,cmd_table.lAllJetton)
		end
	end
	if self.m_lUserAllJetton > 0 then
    self.btquit:setEnabled(false)
    else
    self.btquit:setEnabled(true)
    end
    self:showUserJetton(cmd_table)
    self:updateAreaScore(true)
end

function GameViewLayer:removeuserAreaBet(GameID)
	self.m_ControlLayer:removeuserAreaBet(GameID)
	self.m_ControlLayer:OnDelPeizhi(GameID)
end
function GameViewLayer:setuserAreaBet(gameID,cbArea,lScore,lallbetScore,llosewin,lalllosewin,bIsAndroid)
	self.m_ControlLayer:setPlayerAreaBet(gameID,cbArea,lScore,lallbetScore,llosewin,lalllosewin,bIsAndroid,0,0,0)
end

--下注失败
function GameViewLayer:onPlaceJettonFail(cmd_table)
    if self:isMeChair(cmd_table.wPlaceUser) == true then
        self.m_lUserAllJetton = self.m_lUserAllJetton - cmd_table.lPlaceScore 
    end
end

--提前开牌
function GameViewLayer:onAdvanceOpenCard()
    showToast(self, "下注已超上限，提前开牌", 1)
end

--申请上庄
function GameViewLayer:onApplyBanker( cmd_table)
    if self:isMeChair(cmd_table.wApplyUser) == true then
        self.m_enApplyState = APPLY_STATE.kApplyState
    end

    self:refreshApplyList()
end

--切换庄家
function GameViewLayer:onChangeBanker(cmd_table)
    --上一个庄家是自己，且当前庄家不是自己，标记自己的状态
    if self.m_wBankerUser ~= wBankerUser and self:isMeChair(self.m_wBankerUser) then
        self.m_enApplyState = APPLY_STATE.kCancelState
    end
    self.m_wBankerUser = cmd_table.wBankerUser
    self.m_lBankerScore = cmd_table.lBankerScore
    self.m_cbBankerTime = 0
    self.m_lBankerWinAllScore = 0
	
	--切换庄家后开牌轮数变为第一轮
	self.m_cbCardRecordCount = 1
	self.text_lunshu:setString(""..self.m_cbCardRecordCount)
	
	--切换庄家后清空开牌记录
	self:getDataMgr():clearCardRecord()
	self:refreshCardRecord()

    self:resetBankerInfo()
    print("切换庄家", cmd_table.lBankerScore)

    --自己上庄
    if self:isMeChair(cmd_table.wBankerUser) == true then
        self.m_enApplyState = APPLY_STATE.kApplyedState
        --显示提示
        self:showGameTips(TIP_TYPE.TypeSelfBanker)
    elseif self.m_wBankerUser == yl.INVALID_CHAIR then
        if self.m_bEnableSysBanker == false then
            self:showGameTips(TIP_TYPE.TypeNoBanker)
        else
            self:showGameTips(TIP_TYPE.TypeChangBanker)
        end
    else
        self:showGameTips(TIP_TYPE.TypeChangBanker)
    end

    --如果是超级抢庄用户上庄
    if cmd_table.wBankerUser == self.m_wCurrentRobApply then
        self.m_wCurrentRobApply = yl.INVALID_CHAIR
        self:refreshCondition()
    end

    --坐下用户庄家
    local chair = -1
    for i = 1, Game_CMD.MAX_OCCUPY_SEAT_COUNT do
        if nil ~= self.m_tabSitDownUser[i] then
            chair = self.m_tabSitDownUser[i]:getChair()
            self.m_tabSitDownUser[i]:updateBanker(chair == cmd_table.wBankerUser)
        end
    end
end

--取消申请
function GameViewLayer:onGetCancelBanker(cmd_table)
    if self:isMeChair(cmd_table.wCancelUser) == true then
        self.m_enApplyState = APPLY_STATE.kCancelState
    end

    self:refreshApplyList()
end

--抢庄条件
function GameViewLayer:onGetApplyBankerCondition( llCon , rob_config)
    self.m_llCondition = llCon
    --超级抢庄配置
    self.m_tabSupperRobConfig = rob_config

    self:refreshCondition()
end

--超级抢庄申请
function GameViewLayer:onGetSupperRobApply(  )
    if yl.INVALID_CHAIR ~= self.m_wCurrentRobApply then
        self.m_bSupperRobApplyed = true
        --ExternalFun.enableBtn(self.m_btSupperRob, false)
    end
    --如果是自己
    if true == self:isMeChair(self.m_wCurrentRobApply) then
        --普通上庄申请不可用
        self.m_enApplyState = APPLY_STATE.kSupperApplyed
    end
end

--超级抢庄用户离开
function GameViewLayer:onGetSupperRobLeave( wLeave )
    if yl.INVALID_CHAIR == self.m_wCurrentRobApply then
        --普通上庄申请不可用
        self.m_bSupperRobApplyed = false

        --ExternalFun.enableBtn(self.m_btSupperRob, true)
    end
end

--座位坐下信息
function GameViewLayer:onGetSitDownInfo( config, info )
    self.m_tabSitDownConfig = config
    
    local pos = cc.p(0,0)
    --获取已占位信息
    for i = 1, Game_CMD.MAX_OCCUPY_SEAT_COUNT do
        print("sit chair " .. info[i])
        self:onGetSitDown(i - 1, info[i], false)
    end
end
--座位坐下
function GameViewLayer:onGetSitDown( index, wchair, bAni )
    local isInValid = false
    if  wchair == yl.INVALID_CHAIR then 
        isInValid = true
        local userList =  self:getDataMgr():getChairUserList()
        local count = #self.m_tabSitDownUser+1 
        local addCount = 0
        for k,v in pairs(userList) do
            addCount = addCount + 1
            if addCount == count then 
              --  if wchair ~= self.m_wBankerUser then 
                    wchair = k - 1
               -- end
            end
        end
       
    end
   
    if wchair ~= nil and nil ~= index and index ~= Game_CMD.SEAT_INVALID_INDEX   then
        local useritem = self:getDataMgr():getChairUserList()[wchair + 1]
        dump(useritem)
        if nil ~= useritem then
            --下标加1
            index = index + 1
            if nil == self.m_tabSitDownUser[index] then
                self.m_tabSitDownUser[index] = SitRoleNode:create(self, index)
                self.m_tabSitDownUser[index]:setPosition(self.m_TableSeat[index]:getPosition())
    self.m_roleSitDownLayer:addChild(self.m_tabSitDownUser[index])
                --self:addToRootLayer(self.m_tabSitDownUser[index], 1)
            end
            if isInValid then 
                self.m_tabSitDownUser[index].isInValid = true
            else
                self.m_tabSitDownUser[index].isInValid = false
            end
            self.m_tabSitDownUser[index]:onSitDown(useritem, bAni, wchair == self.m_wBankerUser)

            if useritem.dwUserID == GlobalUserItem.dwUserID then
                self.m_nSelfSitIdx = index
            end
        end
    end
end



--座位失败/离开
function GameViewLayer:onGetSitDownLeave( index )
    if index ~= Game_CMD.SEAT_INVALID_INDEX 
        and nil ~= index then
        index = index + 1
        if nil ~= self.m_tabSitDownUser[index] and self.m_tabSitDownUser[index].isInValid  == false then
            self.m_tabSitDownUser[index]:removeFromParent()
            self.m_tabSitDownUser[index] = nil
        end
    end
end

--银行操作成功
function GameViewLayer:onBankSuccess( )
    local bank_success = self:getParentNode().bank_success
    if nil == bank_success then
        return
    end
    GlobalUserItem.lUserScore = bank_success.lUserScore
    GlobalUserItem.lUserInsure = bank_success.lUserInsure

    if nil ~= self.m_bankLayer and true == self.m_bankLayer:isVisible() then
        self:refreshBankScore()
    end

    showToast(self, bank_success.szDescribrString, 2)
end

--银行操作失败
function GameViewLayer:onBankFailure( )
    local bank_fail = self:getParentNode().bank_fail
    if nil == bank_fail then
        return
    end

    showToast(self, bank_fail.szDescribeString, 2)
end

--银行资料
function GameViewLayer:onGetBankInfo(bankinfo)
    bankinfo.wRevenueTake = bankinfo.wRevenueTake or 10
    if nil ~= self.m_bankLayer then
        local str = "温馨提示:取款将扣除" .. bankinfo.wRevenueTake .. "‰的手续费"
        self.m_bankLayer.m_textTips:setString(str)
    end
end

-------界面显示更新--------
--菜单栏操作
-- function GameViewLayer:showMenu()
-- 	--MXM修复官方原本BUG
-- 	local btpull = self.m_btnLayer:getChildByName("bt_pull")
-- 	if self.m_bshowMenu == false then
--         self.m_bshowMenu = true
--         self.m_menulayout:setVisible(true)
--         self.m_menulayout:runAction(cc.ScaleTo:create(0.2, 1.0))
-- 		btpull:loadTextureNormal("bt_pull_up_0.png", UI_TEX_TYPE_PLIST)
--         btpull:loadTexturePressed("bt_pull_up_1.png", UI_TEX_TYPE_PLIST)
-- 		btpull:setScale9Enabled(true)
-- 		local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame("bt_pull_up_0.png")
-- 		local bt_pull_up = cc.Sprite:createWithSpriteFrame(frame)
-- 		btpull:setContentSize(bt_pull_up:getContentSize())
--     else
--     -- dump(TAG_ENUM.BT_MENU, "隐藏菜单层", 6)
--         self.m_bshowMenu = false
--         self.m_menulayout:runAction(cc.Sequence:create(
--             cc.ScaleTo:create(0.2, 1.0, 0.0001), 
--             cc.CallFunc:create(
--                 function()
--                     self.m_menulayout:setVisible(false)
-- 					btpull:loadTextureNormal("bt_pull_down_0.png", UI_TEX_TYPE_PLIST)
-- 					btpull:loadTexturePressed("bt_pull_down_1.png", UI_TEX_TYPE_PLIST)
-- 					btpull:setScale9Enabled(true)
-- 					local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame("bt_pull_down_0.png")
-- 					local bt_pull_down = cc.Sprite:createWithSpriteFrame(frame)
-- 					btpull:setContentSize(bt_pull_down:getContentSize())
--                 end
--                 )
--             )
--         )
		
--     end
-- end

--更新游戏状态显示
function GameViewLayer:showGameStatus()
	
	--重复下注跟加倍下注按钮状态
	if self.m_nJettonArea == nil then
		self.bt_rebet:setEnabled(false)
		self.bt_doubledown:setEnabled(false)
	else
		self.bt_rebet:setEnabled(true)
		self.bt_doubledown:setEnabled(true)
	end
	
	if self.m_recordlUserAllJetton == 0 or self.m_recordlUserAllJetton == nil then
		self.bt_rebet:setEnabled(false)
		self.bt_doubledown:setEnabled(false)
	end
	
    local content = self.m_timeLayout:getChildByName("im_txt")
    local time = self.m_timeLayout:getChildByName("txt_time")
    time:setString(string.format("%02d", self.m_cbTimeLeave))
	
    if self.m_cbGameStatus == Game_CMD.GAME_SCENE_FREE then
        content:loadTexture("txt_free_timeicon.png", UI_TEX_TYPE_PLIST)
		self.m_TimeProgress:stopAllActions()
		self.m_TimeProgress:setVisible(true)
		self.m_TimeProgress:setPercentage(100)
		self.m_TimeProgress:runAction(cc.Sequence:create(cc.ProgressTo:create(self.m_cbTimeLeave, 0), cc.CallFunc:create(function()
					self.m_TimeProgress:setVisible(false)
				end)))
		self.m_bets_tj_bg:setVisible(false)
		--每3轮后清空开牌记录
		if self.m_cbCardRecordCount ==1 then
			self:getDataMgr():clearCardRecord()
			self:refreshCardRecord()
		end
		
    elseif self.m_cbGameStatus == Game_CMD.GAME_SCENE_JETTON then
        content:loadTexture("im_drop_timeicon.png", UI_TEX_TYPE_PLIST)
		self.m_TimeProgress:stopAllActions()
		self.m_TimeProgress:setVisible(true)
		self.m_TimeProgress:setPercentage(100)
		self.m_TimeProgress:runAction(cc.Sequence:create(cc.ProgressTo:create(self.m_cbTimeLeave, 0), cc.CallFunc:create(function()
					self.m_TimeProgress:setVisible(false)
                    
				end )
        -- ,cc.CallFunc:create(function()
        --            self._csbNodeAni:play("stop1", false)
        --             self.stopbetbg_3:setVisible(true)
        --         end
        --         ),cc.CallFunc:create(function()
        --             self._csbNodeAni:play("stop2",false)
        --             self.stopbetbg_3:setVisible(false)

        --         end),cc.CallFunc:create(function()
        --             self._csbNodeAni:play("stop3",false)
        --         end
        --         ),cc.CallFunc:create(function()
        --             self._csbNodeAni:play("SceneDown",false)
        --         end
        --         ),cc.CallFunc:create(function()
        --             self._csbNodeAni:play("SceneUP",false)
        --         end
        --         )
        ))
		self.m_bets_tj_bg:setVisible(true)
		
		--轮数
		self.text_lunshu:setString(""..self.m_cbCardRecordCount)
		--游戏结束
    elseif self.m_cbGameStatus == Game_CMD.GAME_SCENE_END then   
        content:loadTexture("txt_open_timeicon.png", UI_TEX_TYPE_PLIST)
		self.m_TimeProgress:stopAllActions()
		self.m_TimeProgress:setVisible(true)
		self.m_TimeProgress:setPercentage(100)
		self.m_TimeProgress:runAction(cc.Sequence:create(cc.ProgressTo:create(self.m_cbTimeLeave, 0), cc.CallFunc:create(function()
					self.m_TimeProgress:setVisible(false)
				end)))
		self.m_bets_tj_bg:setVisible(true)
    end
	
end

--色子动画
function GameViewLayer:ShowDice(banim)

	if banim then
		--导入动画
		local animationCache = cc.AnimationCache:getInstance()
		for i = 1, 12 do
			local strColor = ""
			local index = 0
			if i <= 6 then
				strColor = "white"
				index = i
			else
				strColor = "red"
				index = i - 6
			end
			local animation = cc.Animation:create()
			animation:setDelayPerUnit(0.1)
			animation:setLoops(1)
			for j = 1, 9 do
				local strFile = cmd.RES_PATH.."Animate_sice_"..strColor..string.format("/sice_%d.png", index)
				local spFrame = cc.SpriteFrame:create(strFile, cc.rect(207*(j - 1), 0, 207, 322))
				animation:addSpriteFrame(spFrame)
			end

			local strName = "sice_"..strColor..string.format("_%d", index)
			animationCache:addAnimation(animation, strName)
		end

		self.m_sicebg1:stopAllActions()
		self.m_sicebg2:stopAllActions()
		
		local animation = cc.AnimationCache:getInstance():getAnimation("sice_white_"..self.m_dicefirst)
		local animate = cc.Animate:create(animation)
		self.m_sicebg1:runAction(animate)
		
		local animation2 = cc.AnimationCache:getInstance():getAnimation("sice_red_"..self.m_dicesecond)
		local animate2 = cc.Animate:create(animation2)
		self.m_sicebg2:runAction(animate2)
	end
	
end

--发牌动画
function GameViewLayer:sendCard(banim)
	
    if banim then
        local delaytime = 0.1
        for i=1,4 do
			local mm = (self.m_dicepoint + i - 2)%4+1
            for j=1,2 do
                local card = self.m_CardArray[mm][j]
                local index = (i-1)*5 + j - 1
                card:setPosition(677, 580)
				card:stopAllActions()
                card:runAction(cc.Sequence:create(cc.DelayTime:create(delaytime*index), cc.CallFunc:create(
                    function()
                        if j == 1 then
                            ExternalFun.playSoundEffect("send_card.wav")
                        end
                        card:setOpacity(0)
                        card:setVisible(true)
                        card:runAction(cc.FadeTo:create(0.04, 255))
                        card:runAction(cc.Sequence:create(cc.MoveTo:create(0.33, cardpoint[mm]), 
                            cc.MoveBy:create(0.04*(j-1), cc.p(70*(j-1),0))))
                    end
                )))    
            end
        end
    else
        for i=1,4 do
            for j=1,2 do
                local card = self.m_CardArray[i][j]
                card:setVisible(true)
                card:setPosition(cardpoint[i].x + (j-1)*70, cardpoint[i].y)
            end
        end
    end
	
	
end

--显示牌跟牌值
function GameViewLayer:showCard(banim)
    for i=1,4 do
		local mm = (self.m_dicepoint + i - 2)%4+1
		----------------------------------------
		local cardtypevalue = GameLogic:GetCardType(self.m_cbTableCardArray[mm], 2)
        self.m_cardPoint[mm] = cardtypevalue
		dump(cardtypevalue, "特殊牌值---------", 10)
        local pbglayout = self.m_cardPointLayout[mm]
		pbglayout:setLocalZOrder(100) 
       -- pbglayout:loadTexture("im_point_failed_bg.png", UI_TEX_TYPE_PLIST) 
		pbglayout:loadTexture("105_im_blank.png",UI_TEX_TYPE_PLIST)
		
		self.TestcbFirstPip = GameLogic:GetCardListPip(self.m_cbTableCardArray[mm])
		
		dump(self.TestcbFirstPip ,"开牌点数---------", 1)
        local ptemp = self:getSpecialTxt(cardtypevalue,self.m_cbTableCardArray[mm])
        ptemp:setPosition(pbglayout:getContentSize().width/2-55, pbglayout:getContentSize().height/2-70)
        pbglayout:addChild(ptemp)
		
		-----------------------------------------
		
        if mm > 1 then
            local a = GameLogic:CompareCard(self.m_cbTableCardArray[1], self.m_cbTableCardArray[mm])
            self.m_bUserOxCard[mm] = a
        end
        local function showFunction(value)
            for j=1,2 do
                local card = self.m_CardArray[value][j]
                local cardvalue = self.m_cbTableCardArray[value][j]
                card:setCardValue(cardvalue)
                card:showCardBack(false)
            end
			---------------
			if pbglayout ~= nil then
                pbglayout:setVisible(true)
            end
			------------------
        end

        if banim then
            local delaytime = 0
		--[[if mm == 1 then
                delaytime = 3.6
            else
                delaytime = (mm-2)*1.2
            end--]]
			delaytime = delaytime + i * 1.2
            self.m_cardLayer:runAction(cc.Sequence:create(cc.DelayTime:create(delaytime), cc.CallFunc:create(
                function ()
					--local nnn = mm
                    ExternalFun.playSoundEffect("open_card.wav")
                    showFunction(mm)
                end
                )))
        else
            showFunction(mm)
        end
    end

    self.m_bUserOxCard[Game_CMD.ID_DAO_MEN+1] = self.m_bUserOxCard[4]
    self.m_bUserOxCard[Game_CMD.ID_DUI_MEN+1] = self.m_bUserOxCard[3]
    self.m_bUserOxCard[Game_CMD.ID_JIAO_L+1] = self.m_bUserOxCard[Game_CMD.ID_SHUN_MEN+1] + self.m_bUserOxCard[Game_CMD.ID_DUI_MEN+1]
    self.m_bUserOxCard[Game_CMD.ID_QIAO+1] = self.m_bUserOxCard[Game_CMD.ID_SHUN_MEN+1] + self.m_bUserOxCard[Game_CMD.ID_DAO_MEN+1]
    self.m_bUserOxCard[Game_CMD.ID_JIAO_R+1] = self.m_bUserOxCard[Game_CMD.ID_DUI_MEN+1] + self.m_bUserOxCard[Game_CMD.ID_DAO_MEN+1]

    dump(self.m_bUserOxCard, "各区域输赢", 10)
    local function lightfunction()
        for i=1,6 do
            if self.m_bUserOxCard[i+1] > 0 and nil ~= self.m_JettAreaLight[i] then
                self.m_JettAreaLight[i]:setVisible(true)
				self.m_JettAreaLight[i]:stopAllActions()
                self.m_JettAreaLight[i]:runAction(cc.RepeatForever:create(cc.Blink:create(1.0,1)))
            end
        end
    end

    local delaytime  = 5.0
    if banim == false then
        delaytime = 0.2
    end
    self.m_cardLayer:runAction(cc.Sequence:create(cc.DelayTime:create(delaytime), cc.CallFunc:create(
        function ()
            lightfunction()
        end
        )))
	
	--显示通杀通赔
	self.m_TipLayer:stopAllActions()
	self.m_TipLayer:runAction(cc.Sequence:create(cc.DelayTime:create(5*1.0), cc.CallFunc:create(
	function ()
		local winindex  = 0
		local loseindex  = 0
		for i=1,Game_CMD.AREA_COUNT do
			--表示该区域庄家输分
			if self.m_bUserOxCard[i+1] ==1 then
				winindex = winindex+1
			end
		end
		
			
		if winindex == 0 then
			ExternalFun.playSoundEffect("hundreds_tongsha.mp3")
			self:showGameTips(TIP_TYPE.TypeTongSha)
		--elseif winindex == Game_CMD.AREA_COUNT then
		elseif winindex == 3 then
			ExternalFun.playSoundEffect("hundreds_tongpei.mp3")
			self:showGameTips(TIP_TYPE.TypeTongPei)
		else
			self:showGameEndFrame()
		end
	end
	)))
	
end

--特殊牌型显示跟普通牌点显示
function GameViewLayer:getSpecialTxt(cardtypevalue,cbCardData)
    local width = 50
    local height = 30
    local playout = ccui.Layout:create()
    playout:setAnchorPoint(0.5, 0.5)
	
	--特殊牌型显示
	cc.SpriteFrameCache:getInstance():addSpriteFrames("game_res/card_type.plist")
	--获取点数
	local cbSortValue = clone(cbCardData)
	local cbFirstCardValue = GameLogic.GetCardValue(cbSortValue[1])
	local cbSecondCardValue = GameLogic.GetCardValue(cbSortValue[2])
	
	--获取花色
	local cbFistCardColor = GameLogic.GetCardColor(cbSortValue[1])
	local cbSecondCardColor = GameLogic.GetCardColor(cbSortValue[2])
	local psprite = cc.Sprite:create("105_im_blank.png")	
	--双天
	if cardtypevalue == GameLogic.HJ_CT_SPECIAL_1 then
		psprite = cc.Sprite:createWithSpriteFrameName("card_type_17.png")
		psprite:setAnchorPoint(0.0, 0.5)
		psprite:setPosition(0, height/2)
		playout:addChild(psprite)
		return playout
	end
	--双地
	if cardtypevalue == GameLogic.HJ_CT_SPECIAL_2 then
		psprite = cc.Sprite:createWithSpriteFrameName("card_type_16.png")
		psprite:setAnchorPoint(0.0, 0.5)
		psprite:setPosition(0, height/2)
		playout:addChild(psprite)
		return playout
	end
	--至尊
	if cardtypevalue == GameLogic.HJ_CT_SPECIAL_3 then
		psprite = cc.Sprite:createWithSpriteFrameName("card_type_18.png")
		psprite:setAnchorPoint(0.0, 0.5)
		psprite:setPosition(0, height/2)
		playout:addChild(psprite)
		return playout
	end
	--双人
	if cardtypevalue == GameLogic.HJ_CT_SPECIAL_4 then
		psprite = cc.Sprite:createWithSpriteFrameName("card_type_15.png")
		psprite:setAnchorPoint(0.0, 0.5)
		psprite:setPosition(0, height/2)
		playout:addChild(psprite)
		return playout
	end
	--双鹅
	if cardtypevalue == GameLogic.HJ_CT_SPECIAL_5 then
		psprite = cc.Sprite:createWithSpriteFrameName("card_type_14.png")
		psprite:setAnchorPoint(0.0, 0.5)
		psprite:setPosition(0, height/2)
		playout:addChild(psprite)
		return playout
	end
	--双板凳、双红头、双零零
	if cardtypevalue == GameLogic.HJ_CT_SPECIAL_6 then
		if 10 == cbFirstCardValue then
			psprite = cc.Sprite:createWithSpriteFrameName("card_type_9.png")
			psprite:setAnchorPoint(0.0, 0.5)
			psprite:setPosition(0, height/2)
			playout:addChild(psprite)
			return playout
		elseif 6 == cbFirstCardValue then
			psprite = cc.Sprite:createWithSpriteFrameName("card_type_7.png")
			psprite:setAnchorPoint(0.0, 0.5)
			psprite:setPosition(0, height/2)
			playout:addChild(psprite)
			return playout
		elseif 4 == cbFirstCardValue then
			psprite = cc.Sprite:createWithSpriteFrameName("card_type_11.png")
			psprite:setAnchorPoint(0.0, 0.5)
			psprite:setPosition(0, height/2)
			playout:addChild(psprite)
			return playout
		end
	end
	--双梅>双长三>双斧头>双高脚
	if cardtypevalue == GameLogic.HJ_CT_SPECIAL_7 then
		if 10 == cbFirstCardValue and cbFistCardColor + cbSecondCardColor == 4  then
			psprite = cc.Sprite:createWithSpriteFrameName("card_type_13.png")
			psprite:setAnchorPoint(0.0, 0.5)
			psprite:setPosition(0, height/2)
			playout:addChild(psprite)
			return playout
		elseif 6 == cbFirstCardValue and cbFistCardColor + cbSecondCardColor == 4  then
			psprite = cc.Sprite:createWithSpriteFrameName("card_type_12.png")
			psprite:setAnchorPoint(0.0, 0.5)
			psprite:setPosition(0, height/2)
			playout:addChild(psprite)
			return playout
		elseif 11 == cbFirstCardValue and cbFistCardColor + cbSecondCardColor == 4  then
			psprite = cc.Sprite:createWithSpriteFrameName("card_type_10.png")
			psprite:setAnchorPoint(0.0, 0.5)
			psprite:setPosition(0, height/2)
			playout:addChild(psprite)
			return playout
		end
		if 7 == cbFirstCardValue and cbFistCardColor + cbSecondCardColor == 2  then
			psprite = cc.Sprite:createWithSpriteFrameName("card_type_8.png")
			psprite:setAnchorPoint(0.0, 0.5)
			psprite:setPosition(0, height/2)
			playout:addChild(psprite)
			return playout
		end
	end
	--杂九>杂八>杂七>杂五
	if cardtypevalue == GameLogic.HJ_CT_SPECIAL_8 then
		if 9 == cbFirstCardValue and cbFistCardColor + cbSecondCardColor == 2  then
			psprite = cc.Sprite:createWithSpriteFrameName("card_type_6.png")
			psprite:setAnchorPoint(0.0, 0.5)
			psprite:setPosition(0, height/2)
			playout:addChild(psprite)
			return playout
		elseif 5 == cbFirstCardValue and cbFistCardColor + cbSecondCardColor == 2  then
			psprite = cc.Sprite:createWithSpriteFrameName("card_type_3.png")
			psprite:setAnchorPoint(0.0, 0.5)
			psprite:setPosition(0, height/2)
			playout:addChild(psprite)
			return playout
		end
		if 8 == cbFirstCardValue and cbFistCardColor + cbSecondCardColor == 4  then
			psprite = cc.Sprite:createWithSpriteFrameName("card_type_5.png")
			psprite:setAnchorPoint(0.0, 0.5)
			psprite:setPosition(0, height/2)
			playout:addChild(psprite)
			return playout
		elseif 7 == cbFirstCardValue and cbFistCardColor + cbSecondCardColor == 4  then
			psprite = cc.Sprite:createWithSpriteFrameName("card_type_4.png")
			psprite:setAnchorPoint(0.0, 0.5)
			psprite:setPosition(0, height/2)
			playout:addChild(psprite)
			return playout
		end
		
	end
	--天王
	if cardtypevalue == GameLogic.HJ_CT_SPECIAL_9 then
		--if 12 == cbFirstCardValue and 9 == cbSecondCardValue then
			psprite = cc.Sprite:createWithSpriteFrameName("card_type_2.png")
			psprite:setAnchorPoint(0.0, 0.5)
			psprite:setPosition(0, height/2)
			playout:addChild(psprite)
			return playout
		--end
	end
	--天杠
	if cardtypevalue == GameLogic.HJ_CT_SPECIAL_10 then
		--if 12 == cbFirstCardValue and 8 == cbSecondCardValue then
			psprite = cc.Sprite:createWithSpriteFrameName("card_type_1.png")
			psprite:setAnchorPoint(0.0, 0.5)
			psprite:setPosition(0, height/2)
			playout:addChild(psprite)
			return playout
		--end
	end
	--地杠
	if cardtypevalue == GameLogic.HJ_CT_SPECIAL_11 then
		psprite = cc.Sprite:createWithSpriteFrameName("card_type_0.png")
		psprite:setAnchorPoint(0.0, 0.5)
		psprite:setPosition(0, height/2)
		playout:addChild(psprite)
		return playout
	end
	
   
	
	cc.SpriteFrameCache:getInstance():addSpriteFrames("game_res/num_point.plist")

	local pdian = cc.Sprite:createWithSpriteFrameName("point_dian.png")
    pdian:setAnchorPoint(0.0, 0.5)
	
	--这里判断显示1点到9点
    if cardtypevalue < GameLogic.HJ_CT_SPECIAL_11 then
		local pnum = cc.Sprite:create("105_im_blank.png")
		if self.TestcbFirstPip == 0 then
			pnum = cc.Sprite:createWithSpriteFrameName("point_0.png")
		elseif self.TestcbFirstPip == 1 then
			pnum = cc.Sprite:createWithSpriteFrameName("point_1.png")
		elseif self.TestcbFirstPip == 2 then
			pnum = cc.Sprite:createWithSpriteFrameName("point_2.png")
		elseif self.TestcbFirstPip == 3 then
			pnum = cc.Sprite:createWithSpriteFrameName("point_3.png")
		elseif self.TestcbFirstPip == 4 then
			pnum = cc.Sprite:createWithSpriteFrameName("point_4.png")
		elseif self.TestcbFirstPip == 5 then
			pnum = cc.Sprite:createWithSpriteFrameName("point_5.png")
		elseif self.TestcbFirstPip == 6 then
			pnum = cc.Sprite:createWithSpriteFrameName("point_6.png")
		elseif self.TestcbFirstPip == 7 then
			pnum = cc.Sprite:createWithSpriteFrameName("point_7.png")
		elseif self.TestcbFirstPip == 8 then
			pnum = cc.Sprite:createWithSpriteFrameName("point_8.png")
		elseif self.TestcbFirstPip == 9 then
			pnum = cc.Sprite:createWithSpriteFrameName("point_9.png")
		end			
		
        pnum:setAnchorPoint(0.0, 0.5)
        if cardtypevalue == GameLogic.HJ_CT_POINT then
            pnum:setPosition(0,height/2)
            pdian:setPosition(width,height/2)
			playout:addChild(pnum)
            playout:addChild(pdian)
            return playout
        end
	end

    return playout
end

--显示用户下注
function GameViewLayer:showUserJetton(cmd_table)
    --如果是自己，游戏币从自己出飞出
    if self.m_cbGameStatus ~= Game_CMD.GAME_SCENE_JETTON then
        return
    end
    local goldnum = self:getGoldNum(cmd_table.lJettonScore)
    local beginpos = userlistpoint
    local offsettime = math.min(self.m_fJettonTime, 1)
    local bself = 0
    if self:isMeChair(cmd_table.wChairID) == true then
        beginpos = selfheadpoint
        ExternalFun.playSoundEffect("coins_fly_in.wav")
    else
        local seatUser = self:getIsUserSit(cmd_table.wChairID)
        --坐下玩家下注
        if seatUser ~= nil then
            local posindex = seatUser:getIndex()
            seatUser:addJettonScore(cmd_table.lJettonScore, cmd_table.cbJettonArea)
            beginpos = cc.p(self.m_TableSeat[posindex]:getPosition())
            ExternalFun.playSoundEffect("coins_fly_in.wav") 
        --其他玩家下注
        else
            bself = 1
            offsettime = math.min(self.m_fJettonTime, 3)
            if self.m_bPlayGoldFlyIn == true then
                ExternalFun.playSoundEffect("coins_fly_in.wav")
                self.m_bPlayGoldFlyIn = false
            end
        end    
    end
    for i=1,goldnum do

		local nIdx = self.m_idx
		local str = string.format("im_fly_gold_%d.png", nIdx)
		
        --local pgold = cc.Sprite:createWithSpriteFrameName("im_fly_gold.png")
		local pgold = cc.Sprite:createWithSpriteFrameName(str)
        pgold:setPosition(beginpos)
        self.m_goldLayer:addChild(pgold)
        
        if i == 1 then
            local moveaction = self:getMoveAction(beginpos, self:getRandPos(self.m_JettonArea[cmd_table.cbJettonArea]), 0, bself)
			pgold:stopAllActions()
            pgold:runAction(moveaction)
        else
            local randnum = math.random()*offsettime
            pgold:setVisible(false)
			pgold:stopAllActions()
            pgold:runAction(cc.Sequence:create(cc.DelayTime:create(randnum), cc.CallFunc:create(
                    function ()
                        local moveaction = self:getMoveAction(beginpos, self:getRandPos(self.m_JettonArea[cmd_table.cbJettonArea]), 0, bself)
                        pgold:setVisible(true)
                        pgold:runAction(moveaction)
                    end
                )))
        end
        table.insert(self.m_goldList[cmd_table.cbJettonArea+1], pgold)
    end
end

--结算游戏币处理
function GameViewLayer:showGoldMove()
    if self.m_cbGameStatus ~= Game_CMD.GAME_SCENE_END then
        return
    end
    local winAreaNum = 0
    local winScore = 0
    for i=1,Game_CMD.AREA_COUNT do
        --表示该区域庄家赢分
        if self.m_bUserOxCard[i+1] < 0 then
            winAreaNum = winAreaNum + 1
            winScore = winScore + self.m_lAllJettonScore[i+1]
            self:showGoldToZ(i)
        end
    end

    --庄家未赢钱
    if winScore == 0 then
       self:showGoldToArea()
    else
		self.m_goldLayer:stopAllActions()
        self.m_goldLayer:runAction(cc.Sequence:create(cc.DelayTime:create(0.6), cc.CallFunc:create(
                function ()
                    self:showGoldToArea()
                end
            ))) 
    end
	
	---------------------------------------------------------
	--[[local cmd_gameend = self:getDataMgr().m_tabGameEndCmd
	if nil == cmd_gameend then
		return
	end--]]
	
	local call = cc.CallFunc:create(function()
		local score = self.m_lBankerWinScore
			if score<0 then
				score = -score
			end
			local str = ExternalFun.formatScoreFloatText(score)
			if self.m_lBankerWinScore>0 then
				str = "+"..str
				self.m_bankerResultFont:setString(str)
				self.m_bankerResultFont:stopAllActions()
				self.m_bankerResultFont:setVisible(true)
				self.m_bankerResultFont:setPositionY(55)
				
				--飞行动画
				local moveAct = cc.MoveBy:create(1.0, cc.p(0, 40))
				local hideAct = cc.Hide:create()
				local scoreAct = cc.Sequence:create(moveAct, cc.DelayTime:create(2.0), hideAct)
				self.m_bankerResultFont:runAction(scoreAct)
			elseif self.m_lBankerWinScore<0 then				
				str = "-"..str
				self.m_bankerResultLoseFont:setString(str)
				self.m_bankerResultLoseFont:stopAllActions()
				self.m_bankerResultLoseFont:setVisible(true)
				self.m_bankerResultLoseFont:setPositionY(55)
				
				--飞行动画
				local moveAct = cc.MoveBy:create(1.0, cc.p(0, 40))
				local hideAct = cc.Hide:create()
				local scoreAct = cc.Sequence:create(moveAct, cc.DelayTime:create(2.0), hideAct)
				self.m_bankerResultLoseFont:runAction(scoreAct)
			--[[else
				str = "0"--]]
			end
			
	end)
	local delay = cc.DelayTime:create(1.0)
	
	local call2 = cc.CallFunc:create(function()
		--if true == self:getDataMgr().m_bJoin then
			if self.m_lUserAllJetton > 0 then
				local score = self.m_lSelfWinScore
				if score<0 then
					score = -score
				end
				local str = ExternalFun.formatScoreFloatText(score)
				if self.m_lSelfWinScore>0 then
					str = "+"..str
					self.m_selfResultFont:setString(str)
					self.m_selfResultFont:stopAllActions()
					self.m_selfResultFont:setVisible(true)
					self.m_selfResultFont:setPositionY(55)

					--飞行动画
					local moveAct = cc.MoveBy:create(1.0, cc.p(0, 50))
					local hideAct = cc.Hide:create()
					local scoreAct = cc.Sequence:create(moveAct, cc.DelayTime:create(2.0), hideAct)
					self.m_selfResultFont:runAction(scoreAct)
				elseif self.m_lSelfWinScore<0 then				
					str = "-"..str
					self.m_selfResultLoseFont:setString(str)
					self.m_selfResultLoseFont:stopAllActions()
					self.m_selfResultLoseFont:setVisible(true)
					self.m_selfResultLoseFont:setPositionY(55)

					--飞行动画
					local moveAct = cc.MoveBy:create(1.0, cc.p(0, 50))
					local hideAct = cc.Hide:create()
					local scoreAct = cc.Sequence:create(moveAct, cc.DelayTime:create(2.0), hideAct)
					self.m_selfResultLoseFont:runAction(scoreAct)
				--[[else
					str = "0"--]]
				end
				
		end
	end)
	
	--坐下的
	local call3 = cc.CallFunc:create(function()
		for i = 1, Game_CMD.MAX_OCCUPY_SEAT_COUNT do
			if nil ~= self.m_tabSitDownUser[i] then
				--非自己
				local chair = self.m_tabSitDownUser[i]:getChair()
					local score = self.m_lOccupySeatUserWinScore[1][i]
					if score<0 then
						score = -score
					end
					local str = ExternalFun.formatScoreFloatText(score)
					if self.m_lSelfWinScore>0 then
						str = "+"..str
						self.m_situserResultFont[i]:setString(str)
						self.m_situserResultFont[i]:stopAllActions()
						self.m_situserResultFont[i]:setLocalZOrder(2000)
						self.m_situserResultFont[i]:setVisible(true)
						--self.m_situserResultFont[i]:setPositionY(55)

						--飞行动画
						local moveAct = cc.MoveBy:create(1.0, cc.p(0, 50))
						local hideAct = cc.Hide:create()
						local scoreAct = cc.Sequence:create(moveAct, cc.DelayTime:create(2.0), hideAct)
						self.m_situserResultFont[i]:runAction(scoreAct)
					elseif self.m_lSelfWinScore<0 then				
						str = "-"..str
						self.m_situserResultLoseFont[i]:setString(str)
						self.m_situserResultLoseFont[i]:stopAllActions()
						self.m_situserResultLoseFont[i]:setLocalZOrder(2000)
						self.m_situserResultLoseFont[i]:setVisible(true)
						--self.m_situserResultFont[i]:setPositionY(55)

						--飞行动画
						local moveAct = cc.MoveBy:create(1.0, cc.p(0, 50))
						local hideAct = cc.Hide:create()
						local scoreAct = cc.Sequence:create(moveAct, cc.DelayTime:create(2.0), hideAct)
						self.m_situserResultLoseFont[i]:runAction(scoreAct)
					--[[else
						str = "0"--]]
					end
					
			end
		end
	end)

	local delay3 = cc.DelayTime:create(0.5)	
	
	local seq = cc.Sequence:create(call,call3,call2,cc.DelayTime:create(1.0))
	self:stopAllActions()
	self:runAction(seq)	
	
end

--显示游戏币飞到庄家处
function GameViewLayer:showGoldToZ(cbArea)
    local goldnum = #self.m_goldList[cbArea+1]
    if goldnum == 0 then
        return
    end
    ExternalFun.playSoundEffect("coinCollide.wav")
    --分十次飞行完成
    local cellnum = math.floor(goldnum/10)
    if cellnum == 0 then
        cellnum = 1
    end
    local cellindex = 0
    local outnum = 0
    for i=goldnum, 1, -1 do
        local pgold = self.m_goldList[cbArea+1][i]
        table.remove(self.m_goldList[cbArea+1], i)
        table.insert(self.m_goldList[1], pgold)
        outnum = outnum + 1
        local moveaction = self:getMoveAction(cc.p(pgold:getPosition()), bankerheadpoint, 1, 0)
        pgold:runAction(cc.Sequence:create(cc.DelayTime:create(cellindex*0.03), moveaction, cc.CallFunc:create(
                function ()
                    pgold:setVisible(false)
                end
            )))
        if outnum >= cellnum then
            cellindex = cellindex + 1
            outnum = 0
        end
    end
end

--显示游戏币庄家飞到下注区域
function GameViewLayer:showGoldToArea()
    if self.m_cbGameStatus ~= Game_CMD.GAME_SCENE_END then
        return
    end
	--隐藏输赢平局结算框
	if nil ~= self.m_gameResultLayer then
		self.m_gameResultLayer:setVisible(false)
	end
					
    local winAreaNum = 0
    for i=1,Game_CMD.AREA_COUNT do
        --表示该区域庄家输分
        if self.m_bUserOxCard[i+1] > 0  then
            local lJettonScore = self.m_lAllJettonScore[i+1]
            if lJettonScore > 0 then
                self:showGoldToAreaWithID(i)
            end
        end
        --表示该区域庄家未赢
        if self.m_bUserOxCard[i+1] >= 0 then
            winAreaNum = winAreaNum + 1
        end
    end

    --庄家全赢
    if winAreaNum == 0 then
        --坐下用户
        for i = 1, Game_CMD.MAX_OCCUPY_SEAT_COUNT do
            if nil ~= self.m_tabSitDownUser[i] then
                local chair = self.m_tabSitDownUser[i]:getChair()
                local score = self.m_lOccupySeatUserWinScore[1][i]
                local useritem = self:getDataMgr():getChairUserList()[chair + 1]
                --游戏币动画
                self.m_tabSitDownUser[i]:gameEndScoreChange(useritem, score)
            end 
        end
        self:showGameEnd()
    else
		self.m_goldLayer:stopAllActions()
        self.m_goldLayer:runAction(cc.Sequence:create(cc.DelayTime:create(0.8), cc.CallFunc:create(
                function ()
                    self:showGoldToUser()
                end
            )))
    end
end

function GameViewLayer:showGoldToAreaWithID(cbArea)
    ExternalFun.playSoundEffect("coinCollide.wav")
    local goldnum = self:getWinGoldNumWithAreaID(cbArea)
    local listnum = #self.m_goldList[1]
    --当前列表游戏币数不足
    local addnum = 0
    if goldnum > listnum then
        addnum = goldnum - listnum
    end
    local fornum = math.min(goldnum, listnum)

    if fornum > 0 then
        for i=1,fornum do
            local pgold = self.m_goldList[1][listnum-i+1]
            table.remove(self.m_goldList[1], listnum-i+1)
            table.insert(self.m_goldList[cbArea + 1], pgold)
            pgold:setPosition(bankerheadpoint)
            pgold:runAction(cc.Sequence:create(cc.DelayTime:create(0.01*i), cc.CallFunc:create(
                    function ()
                        local moveaction = self:getMoveAction(bankerheadpoint, self:getRandPos(self.m_JettonArea[cbArea]), 0, 1)
                        pgold:setVisible(true)
                        pgold:runAction(moveaction)
                    end
                )
            ))
        end
    end
    

    if addnum == 0 then
        return
    end
    for i=1,addnum do
		if self.m_idx == nil or  self.m_idx == "" then
			self.m_idx =  math.random(1,6)
		end
		local nIdx = self.m_idx
		local str = string.format("im_fly_gold_%d.png", nIdx)
		local pgold = cc.Sprite:createWithSpriteFrameName(str)
        --local pgold = cc.Sprite:createWithSpriteFrameName("im_fly_gold.png")
        pgold:setPosition(bankerheadpoint)
        pgold:setVisible(false)
        self.m_goldLayer:addChild(pgold)

        table.insert(self.m_goldList[cbArea + 1], pgold)
        pgold:runAction(cc.Sequence:create(cc.DelayTime:create(0.01*(i+fornum)), cc.CallFunc:create(
                function ()
                    local moveaction = self:getMoveAction(bankerheadpoint, self:getRandPos(self.m_JettonArea[cbArea]), 0, 1)
                    pgold:setVisible(true)
					pgold:stopAllActions()
                    pgold:runAction(moveaction)
                end
            )
        ))
    end
end

--显示游戏币下注区域飞到玩家
function GameViewLayer:showGoldToUser()
    if self.m_cbGameStatus ~= Game_CMD.GAME_SCENE_END then
        return
    end
    for i=1,Game_CMD.AREA_COUNT do
        --表示该区域庄家输分
        if self.m_bUserOxCard[i+1] >= 0 then
            local lJettonScore = self.m_lAllJettonScore[i+1]
            if lJettonScore > 0 then
                self:showGoldAreaToUser(i)
            end
        end
    end
	
    self:runAction(cc.Sequence:create(cc.DelayTime:create(1), cc.CallFunc:create(
            function ()
                self:showGameEnd()
            end
        )))
end

function GameViewLayer:showGoldAreaToUser(cbArea)
    ExternalFun.playSoundEffect("coinCollide.wav")
    local listnum = #self.m_goldList[cbArea + 1]
    local selfgoldnum = self:getWinGoldNum(self.m_lUserJettonScore[cbArea+1], 1)
    if self.m_lUserJettonScore[cbArea+1] == self.m_lAllJettonScore[cbArea+1] then
        selfgoldnum = listnum
    end
    --自己游戏币移动
    self:GoldMoveToUserDeal(cbArea, selfgoldnum, selfheadpoint)

    --坐下用户
    for i = 1, Game_CMD.MAX_OCCUPY_SEAT_COUNT do
        if nil ~= self.m_tabSitDownUser[i] then
            local seatJettonScore = self.m_tabSitDownUser[i]:getJettonScoreWithArea(cbArea)
            if seatJettonScore > 0 then
                local seatGoldNum = self:getWinGoldNum(seatJettonScore, 1)
                print("坐下用户游戏币数", seatGoldNum)
                local endpos = cc.p(self.m_TableSeat[i]:getPosition())
                self:GoldMoveToUserDeal(cbArea, seatGoldNum, endpos)

                local chair = self.m_tabSitDownUser[i]:getChair()
                local score = self.m_lOccupySeatUserWinScore[1][i]
                local useritem = self:getDataMgr():getChairUserList()[chair + 1]
                --游戏币动画
                self.m_tabSitDownUser[i]:gameEndScoreChange(useritem, score)
            end 
        end
    end

    listnum = #self.m_goldList[cbArea + 1]
    self:GoldMoveToUserDeal(cbArea, listnum, userlistpoint)
end

function GameViewLayer:GoldMoveToUserDeal(cbArea, goldNum, endpos)
    local listnum = #self.m_goldList[cbArea + 1]
    if goldNum > listnum then
        goldnum = listnum
    end
    if goldnum == 0 then
        return
    end
    for i=1,goldNum do
        local pgold = self.m_goldList[cbArea+1][listnum-i+1]
        table.remove(self.m_goldList[cbArea+1], listnum-i+1)
		pgold:stopAllActions()
        pgold:runAction(cc.Sequence:create(cc.DelayTime:create(i*0.01), cc.CallFunc:create(
                function ()
                    local moveaction = self:getMoveAction(cc.p(pgold:getPosition()), endpos, 1, 1)
					pgold:stopAllActions()
                    pgold:runAction(cc.Sequence:create(moveaction, cc.CallFunc:create(
                            function ()
                                pgold:removeFromParent()
                            end
                        )))
                end
            )))
    end
end

--显示游戏结算
function GameViewLayer:showGameEnd(bRecord)
    if self.m_cbGameStatus ~= Game_CMD.GAME_SCENE_END then
        return
    end
    if bRecord == nil then
        local record = Game_CMD.getEmptyGameRecord()
        record.bWinShunMen = self.m_bUserOxCard[Game_CMD.ID_SHUN_MEN+1] > 0 and true or false
        record.bWinDuiMen = self.m_bUserOxCard[Game_CMD.ID_DUI_MEN+1] > 0 and true or false
        record.bWinDaoMen = self.m_bUserOxCard[Game_CMD.ID_DAO_MEN+1] >0 and true or false

        self:getDataMgr():addGameRecord(record)
        self:refreshGameRecord()
    end
	

	if bRecord == nil then
		local cardRecord = Game_CMD.getEmptyCardRecord()

		cardRecord.m_card1 = self.m_cbTableCardArray[1][1]
		cardRecord.m_card2 = self.m_cbTableCardArray[1][2]
		
		cardRecord.m_card3 = self.m_cbTableCardArray[2][1]
		cardRecord.m_card4 = self.m_cbTableCardArray[2][2]
		
		cardRecord.m_card5 = self.m_cbTableCardArray[3][1]
		cardRecord.m_card6 = self.m_cbTableCardArray[3][2]
		
		cardRecord.m_card7 = self.m_cbTableCardArray[4][1]
		cardRecord.m_card8 = self.m_cbTableCardArray[4][2]
		
		 self:getDataMgr():addCardRecord(cardRecord)
         self:refreshCardRecord()
		
	end

    --表示未赢分
    -- local jettonscore = 0
    -- for i,v in ipairs(self.m_lUserJettonScore) do
    --     jettonscore = jettonscore + v
    -- end
    -- if self.m_lSelfWinScore == 0 and jettonscore == 0 then
    --     return
    -- end
	
	--[[--MXM如果玩家下注了才显示结算框反之则不创建结算框
	if self.m_lUserAllJetton > 0 then
		--创建结算框
	   if nil == self.m_gameResultLayer then
			self.m_gameResultLayer = GameResultLayer:create(self)
			self:addToRootLayer(self.m_gameResultLayer, ZORDER_LAYER.ZORDER_Other_Layer)
		end
		self.m_gameResultLayer:showGameResult(self.m_lSelfWinScore, self.m_lSelfReturnScore, self.m_lBankerWinScore)
	end--]]
end

--显示结算框
function GameViewLayer:showGameEndFrame()
	--MXM如果玩家下注了才显示结算框反之则不创建结算框
	if self.m_lUserAllJetton > 0 then
		--创建结算框
	   if nil == self.m_gameResultLayer then
			self.m_gameResultLayer = GameResultLayer:create(self)
			self:addToRootLayer(self.m_gameResultLayer, ZORDER_LAYER.ZORDER_Other_Layer)
		end
		self.m_gameResultLayer:showGameResult(self.m_lSelfWinScore, self.m_lSelfReturnScore, self.m_lBankerWinScore)
	end
end

--显示提示
function GameViewLayer:showGameTips(showtype)
    local pimagestr = "txt_banker_null.png"
    if showtype == TIP_TYPE.TypeChangBanker then
        pimagestr = "txt_change_banker_icon.png"
    elseif showtype == TIP_TYPE.TypeSelfBanker then
        pimagestr = "txt_banker_selficon.png"
    elseif showtype == TIP_TYPE.TypeContinueSend then
        pimagestr = "txt_continue_sendcard.png"
    elseif showtype == TIP_TYPE.TypeReSend then
        pimagestr = "txt_game_resortpoker.png"
	elseif showtype == TIP_TYPE.TypeTongSha then
        pimagestr = "txt_tongsha.png"
	elseif showtype == TIP_TYPE.TypeTongPei then
        pimagestr = "txt_tongpei.png"
    end
	
	--效果一 从上往下
  --[[  local ptipimage = cc.Sprite:createWithSpriteFrameName(pimagestr)
    ptipimage:setPosition(cc.p(yl.WIDTH/2, 580))
    self:addToRootLayer(ptipimage, 2)
    ptipimage:runAction(cc.Sequence:create(cc.DelayTime:create(1.5), cc.MoveBy:create(0.17, cc.p(0,170)), cc.CallFunc:create(
        function()
            ptipimage:removeFromParent()
        end    
        )))--]]
	
	--效果二 淡出 渐入
	local ptipimage = cc.Sprite:createWithSpriteFrameName(pimagestr)
	 ptipimage:setPosition(cc.p(yl.WIDTH/2, yl.HEIGHT/2))
	self:addToRootLayer(ptipimage, 20)
	 
	 local action = cc.FadeOut:create(1.0)--淡出
	 --local action2 = cc.FadeIn:create(1.5) -- 渐入
	 ptipimage:stopAllActions()
	 ptipimage:runAction(cc.Sequence:create(action))
end

--设置下注按钮是否可以点击
function GameViewLayer:setJettonEnable(value)
--    for k,v in pairs(self.m_JettonBtn) do
--        v:setEnabled(value)

       if self.m_lUserAllJetton > 0 then
		self.btquit:setEnabled(bEnable)
	elseif true == self:isMeChair(self.m_wBankerUser) then
		self.btquit:setEnabled(false)
	else
		self.btquit:setEnabled(true)
	end
	if self.m_nJettonSelect >= 0 and self.m_nJettonSelect <= 5 then
		if nil ~= self.m_JettonLight then
			self.m_JettonLight:setVisible(value)
			if value == false then
				self.m_JettonLight:stopAllActions()
			elseif value == true then
				--self.m_JettonLight:runAction(cc.RepeatForever:create(cc.Blink:create(1.0,1)))
				self.m_JettonLight:runAction(cc.RepeatForever:create(cc.RotateBy:create(1.0 , 360)))
			end
		end
	else
		if nil ~= self.m_JettonRectLight then
			self.m_JettonRectLight:setVisible(value)
			if value == false then
				self.m_JettonRectLight:stopAllActions()
			elseif value == true then

				---下注按钮背后转动(6,7按钮)
				---------------------------------------
				--使用代码创建动画，csb动画存在bug
				cc.SpriteFrameCache:getInstance():addSpriteFrames("game_res/jetton_light.plist")
				
				local frames = {}
				for i=1, 17 do
					local frameName = string.format("jettonlight_%d.png", i)
					local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame(frameName) 
					table.insert(frames, frame)
				end
				local  animation =cc.Animation:createWithSpriteFrames(frames,0.03)

				if nil ~= animation then
					local backjettonlight = cc.Sprite:createWithSpriteFrameName("jettonlight_0.png")
					local spritebatch = cc.SpriteBatchNode:create("game_res/jetton_light.png")
					spritebatch:addChild(backjettonlight)
					self:addChild(spritebatch)
					local action = cc.RepeatForever:create(cc.Animate:create(animation))
					self.m_JettonRectLight:stopAllActions()
					self.m_JettonRectLight:runAction(action)
				end
				--------------------------------------------------------------
			end
		end
	end
	
end

--更新下注按钮
--score：可以下注金额*MaxTimes
function GameViewLayer:updateJettonList(score)
    local btjettonscore = 0
    local judgeindex = 0
    if self.m_nJettonSelect == 0 then
        self.m_nJettonSelect = 1
    end
    for i=1,7 do
       -- btjettonscore = btjettonscore + GameViewLayer.m_BTJettonScore[i]
		btjettonscore = GameViewLayer.m_BTJettonScore[i]
        local judgescore = btjettonscore*MaxTimes
        --print("最大下注只", judgescore)
        if judgescore > score then
            self.m_JettonBtn[i]:setEnabled(false)
        else
            self.m_JettonBtn[i]:setEnabled(true)
            judgeindex = i
        end
    end
    if self.m_nJettonSelect > judgeindex then
        self.m_nJettonSelect = judgeindex
        if judgeindex == 0 then
            self:setJettonEnable(false)
        --[[elseif judgeindex == 6 or judgeindex == 7 then
			self.m_JettonRectLight:setPosition(self.m_JettonBtn[judgeindex]:getPosition())--]]
		else
            --self.m_JettonLight:setPositionX(self.m_JettonBtn[judgeindex]:getPositionX())
			self.m_JettonRectLight:setVisible(false)
			self.m_JettonLight:setVisible(true)
			self.m_JettonLight:setPosition(self.m_JettonBtn[judgeindex]:getPosition())
        end
    end
end

--更新下注分数显示
function GameViewLayer:updateAreaScore(bshow)
    if bshow == false then
        for k,v in pairs(self.m_selfJettonScore) do
            v:setVisible(bshow)
        end
        for k,v in pairs(self.m_tAllJettonScore) do
            v:setVisible(bshow)
        end
		for k,v in pairs(self.m_tAllJettonScoreMil) do
            v:setVisible(bshow)
        end
		for k,v in pairs(self.m_tAllJettonScoreTenMil) do
            v:setVisible(bshow)
        end
		for k,v in pairs(self.m_tAllJettonFuhaoWan) do
            v:setVisible(bshow)
        end
		for k,v in pairs(self.m_tAllJettonFuhaoMil) do
            v:setVisible(bshow)
        end
		for k,v in pairs(self.m_tAllJettonFuhaoTenMil) do
            v:setVisible(bshow)
        end
		for k,v in pairs(self.m_tAllJettonFuhaoYi) do
            v:setVisible(bshow)
        end
		for k,v in pairs(self.m_selfJettonBg) do
            v:setVisible(bshow)
        end
		for k,v in pairs(self.m_selfJettonFuhaoWan) do
            v:setVisible(bshow)
        end
        return
    end
    for i=1,6 do
		--自己在各区域的下注值
        if self.m_lUserJettonScore[i+1] > 0 then
			self.m_selfJettonBg[i]:setVisible(true)
            self.m_selfJettonScore[i]:setVisible(true)
           -- self.m_selfJettonScore[i]:setString(""..self.m_lUserJettonScore[i+1])
			
			local str = string.formatNumberTwoFloat(self.m_lUserJettonScore[i+1])
			self.m_selfJettonScore[i]:setString(str)
			
			--大于1万显示符号万
			if self.m_lUserJettonScore[i+1] >= 10000 then
				self.m_selfJettonFuhaoWan[i]:setVisible(true)
			end
			
        end
	
		--各区域的下注值
		--<100万
        if self.m_lAllJettonScore[i+1] > 0 and self.m_lAllJettonScore[i+1] < 1000 then
            self.m_tAllJettonScore[i]:setVisible(true)
			self.m_tAllJettonScoreMil[i]:setVisible(false)
			self.m_tAllJettonScoreTenMil[i]:setVisible(false)
            --self.m_tAllJettonScore[i]:setString(""..self.m_lAllJettonScore[i+1])
			
			local str = string.formatNumberTwoFloat(self.m_lAllJettonScore[i+1])
			self.m_tAllJettonScore[i]:setString(str)
        end
		
		-->=100万<1000万
		if self.m_lAllJettonScore[i+1] >= 1000 and self.m_lAllJettonScore[i+1] < 10000 then
            self.m_tAllJettonScoreMil[i]:setVisible(true)
			self.m_tAllJettonScore[i]:setVisible(false)
			self.m_tAllJettonScoreTenMil[i]:setVisible(false)
			
			local str = string.formatNumberTwoFloat(self.m_lAllJettonScore[i+1])
			self.m_tAllJettonScoreMil[i]:setString(str)
        end
		
		-->=1000万(>1亿)
		if self.m_lAllJettonScore[i+1] >= 10000 then
            self.m_tAllJettonScoreTenMil[i]:setVisible(true)
			self.m_tAllJettonScore[i]:setVisible(false)
            self.m_tAllJettonScoreMil[i]:setVisible(false)
			
			local str = string.formatNumberTwoFloat(self.m_lAllJettonScore[i+1])
			self.m_tAllJettonScoreTenMil[i]:setString(str)
        end
		
		--符号万
		if self.m_lAllJettonScore[i+1] >= 10000 and self.m_lAllJettonScore[i+1] < 1000000 then
            --self.m_tAllJettonFuhaoWan[i]:setVisible(true)
			self.m_tAllJettonFuhaoTenMil[i]:setVisible(true)
        end
		
		--符号百万
		if self.m_lAllJettonScore[i+1] >= 1000000 and self.m_lAllJettonScore[i+1] < 10000000 then
            self.m_tAllJettonFuhaoMil[i]:setVisible(true)
			self.m_tAllJettonFuhaoWan[i]:setVisible(false)
        end
		
		--符号千万
		if self.m_lAllJettonScore[i+1] >= 10000000 and self.m_lAllJettonScore[i+1] < 100000000 then
            self.m_tAllJettonFuhaoTenMil[i]:setVisible(true)
			self.m_tAllJettonFuhaoWan[i]:setVisible(false)
			self.m_tAllJettonFuhaoMil[i]:setVisible(false)
        end
		
		if self.m_lAllJettonScore[i+1] >= 100000000 then
			self.m_tAllJettonFuhaoYi[i]:setVisible(true)
			self.m_tAllJettonFuhaoWan[i]:setVisible(false)
			self.m_tAllJettonFuhaoMil[i]:setVisible(false)
			self.m_tAllJettonFuhaoTenMil[i]:setVisible(false)
        end
		
		--所有区域总下注值
		local AllJettonstr = ExternalFun.formatScoreFloatText(self.m_lAllJettonScore[1]+self.m_lAllJettonScore[2]+self.m_lAllJettonScore[3]+self.m_lAllJettonScore[4]+self.m_lAllJettonScore[5]+self.m_lAllJettonScore[6])
		self.textAllJetton:setString(AllJettonstr)
		
		--玩家自己总下注值
		local UserAllJettonstr = ExternalFun.formatScoreFloatText(self.m_lUserAllJetton)
		self.textUserAllJetton:setString(UserAllJettonstr)
		
    end
end

--刷新游戏记录
function GameViewLayer:refreshGameRecord()
    if nil ~= self.m_GameRecordLayer and self.m_GameRecordLayer:isVisible() then
        local recordList = self:getDataMgr():getGameRecord()     
        self.m_GameRecordLayer:refreshRecord(recordList)
    end
end

--刷新列表
function GameViewLayer:refreshApplyList(  )
    if nil ~= self.m_applyListLayer and self.m_applyListLayer:isVisible() then
        local userList = self:getDataMgr():getApplyBankerUserList()     
        self.m_applyListLayer:refreshList(userList)
    end
end

--刷新申请列表按钮状态
function GameViewLayer:refreshApplyBtnState(  )
    if nil ~= self.m_applyListLayer and self.m_applyListLayer:isVisible() then
        self.m_applyListLayer:refreshBtnState()
    end
end

--刷新用户列表
function GameViewLayer:refreshUserList(  )
    if nil ~= self.m_userListLayer and self.m_userListLayer:isVisible() then
        local userList = self:getDataMgr():getUserList()        
        self.m_userListLayer:refreshList(userList)
    end
end

--刷新抢庄按钮
function GameViewLayer:refreshCondition(  )
    local applyable = self:getApplyable()
    if applyable then
        ------
        --超级抢庄

        --如果当前有超级抢庄用户且庄家不是自己
        if (yl.INVALID_CHAIR ~= self.m_wCurrentRobApply) or (true == self:isMeChair(self.m_wBankerUser)) then
            --ExternalFun.enableBtn(self.m_btSupperRob, false)
        else
            local useritem = self:getMeUserItem()
            --判断抢庄类型
            if Game_CMD.SUPERBANKER_VIPTYPE == self.m_tabSupperRobConfig.superbankerType then
                --vip类型             
                --ExternalFun.enableBtn(self.m_btSupperRob, useritem.cbMemberOrder >= self.m_tabSupperRobConfig.enVipIndex)
            elseif Game_CMD.SUPERBANKER_CONSUMETYPE == self.m_tabSupperRobConfig.superbankerType then
                --游戏币消耗类型(抢庄条件+抢庄消耗)
                local condition = self.m_tabSupperRobConfig.lSuperBankerConsume + self.m_llCondition
                --ExternalFun.enableBtn(self.m_btSupperRob, useritem.lScore >= condition)
            end
        end     
    else
        --ExternalFun.enableBtn(self.m_btSupperRob, false)
    end
end

--刷新开牌记录列表
function GameViewLayer:refreshCardRecord( )
    if nil ~= self.m_cardrecordListLayer and self.m_cardrecordListLayer:isVisible() then
        local cardRecord = self:getDataMgr():getCardRecord()  
        self.m_cardrecordListLayer:refreshCardRecord(cardRecord)
    end
end

--刷新用户分数
function GameViewLayer:onGetUserScore( useritem )
    --自己
    if useritem.dwUserID == GlobalUserItem.dwUserID then
        self.m_showScore = useritem.lScore
        self:resetSelfInfo()

    end

    --坐下用户
    for i = 1, Game_CMD.MAX_OCCUPY_SEAT_COUNT do
        if nil ~= self.m_tabSitDownUser[i] then
            if useritem.wChairID == self.m_tabSitDownUser[i]:getChair() then
                self.m_tabSitDownUser[i]:updateScore(useritem.lScore)
            end
        end
    end

    --庄家
    if self.m_wBankerUser == useritem.wChairID then
        --庄家游戏币
        self.m_lBankerScore = useritem.lScore
        self:resetBankerInfo()
    end
end

--获取下注显示游戏币个数
function GameViewLayer:getGoldNum(lscore)
	
    local goldnum = 1
    for i=1,7 do
        if lscore >= GameViewLayer.m_BTJettonScore[i] then
            goldnum = i
			self.m_idx = goldnum
        end
    end
    return GameViewLayer.m_JettonGoldBaseNum[goldnum]
end

--获取输钱区域需要游戏币数
function GameViewLayer:getWinGoldNumWithAreaID(cbArea)
    local goldnum = 0
    local lAllJettonScore = self.m_lAllJettonScore[cbArea + 1]
    goldnum = goldnum + self:getWinGoldNum(self.m_lUserJettonScore[cbArea + 1])
    --全是自己下注
    if self.m_lUserJettonScore[cbArea+1] == self.m_lAllJettonScore[cbArea + 1] then
        return goldnum
    end
    lAllJettonScore = lAllJettonScore - self.m_lUserJettonScore[cbArea+1]

    --坐下用户
    for i = 1, Game_CMD.MAX_OCCUPY_SEAT_COUNT do
        if nil ~= self.m_tabSitDownUser[i] then
            local seatJettonScore = self.m_tabSitDownUser[i]:getJettonScoreWithArea(cbArea)
            if seatJettonScore > 0 then
               goldnum = goldnum + self:getWinGoldNum(seatJettonScore)
               lAllJettonScore = lAllJettonScore - seatJettonScore
            end 
        end
    end

    if lAllJettonScore <= 0 then
        return goldnum
    end

    goldnum = goldnum + self:getWinGoldNum(lAllJettonScore)
    return goldnum
end

--获取赢钱需要游戏币数
function GameViewLayer:getWinGoldNum(lscore, index)
    if lscore == 0 then
        return 0
    end
    local goldnum = 0
    for i=1,7 do
        if lscore >= GameViewLayer.m_BTJettonScore[i] then
            goldnum = i
        end
    end
    if index == nil then
        return GameViewLayer.m_WinGoldMaxNum[goldnum]
    end
    return GameViewLayer.m_WinGoldBaseNum[goldnum]
end

--获取随机显示位置
function GameViewLayer:getRandPos(nodeArea)
    --local beginpos = cc.p(nodeArea:getPositionX()-80, nodeArea:getPositionY()-65)
	local beginpos = cc.p(nodeArea:getPositionX()-70, nodeArea:getPositionY()-45)
    local offsetx = math.random()
    local offsety = math.random()

    --return cc.p(beginpos.x + offsetx*160, beginpos.y + offsety*130)
	return cc.p(beginpos.x + offsetx*130, beginpos.y + offsety*110)
end

--获取移动动画
--inorout,0表示加速飞出,1表示加速飞入
--isreverse,0表示不反转,1表示反转
function GameViewLayer:getMoveAction(beginpos, endpos, inorout, isreverse)
    local offsety = (endpos.y - beginpos.y)*0.7
    local controlpos = cc.p(beginpos.x, beginpos.y+offsety)
    if isreverse == 1 then
        offsety = (beginpos.y - endpos.y)*0.7
        controlpos = cc.p(endpos.x, endpos.y+offsety)
    end
    local bezier = {
        controlpos,
        endpos,
        endpos
    }
    local beaction = cc.BezierTo:create(0.42, bezier)
    if inorout == 0 then
        return cc.EaseOut:create(beaction, 1)
    else
        return cc.EaseIn:create(beaction, 1)
    end
end

--判断该用户是否坐下
function GameViewLayer:getIsUserSit(wChair)
    for i = 1, Game_CMD.MAX_OCCUPY_SEAT_COUNT do
        if nil ~= self.m_tabSitDownUser[i] then
            if wChair == self.m_tabSitDownUser[i]:getChair() then
                return self.m_tabSitDownUser[i]
            end
        end
    end
    return nil
end

--上庄状态
function GameViewLayer:applyBanker( state )
    if state == APPLY_STATE.kCancelState then
        self:getParentNode():sendApplyBanker()      
    elseif state == APPLY_STATE.kApplyState then
        self:getParentNode():sendCancelApply()
    elseif state == APPLY_STATE.kApplyedState then
        self:getParentNode():sendCancelApply()      
    end
end

------
--银行节点
function GameViewLayer:createBankLayer()
    self.m_bankLayer = cc.Node:create()
    self:addToRootLayer(self.m_bankLayer, ZORDER_LAYER.ZORDER_Other_Layer)

    --加载csb资源
    local publicLayer = ExternalFun.loadCSB("BankLayer.csb", self.m_bankLayer)
    local sp_bg = publicLayer:getChildByName("sp_bg")

    ------
    --按钮事件
    local function btnEvent( sender, eventType )
        if eventType == ccui.TouchEventType.ended then
            self:onButtonClickedEvent(sender:getTag(), sender)
        end
    end 
    --关闭按钮
    local btn = sp_bg:getChildByName("close_btn")
    btn:setTag(TAG_ENUM.BT_CLOSEBANK)
    btn:addTouchEventListener(btnEvent)

    local layout_bg = publicLayer:getChildByName("layout_bg")
    layout_bg:setTag(TAG_ENUM.BT_CLOSEBANK)
    layout_bg:addTouchEventListener(btnEvent)

    

    --取款按钮
    btn = sp_bg:getChildByName("out_btn")
    btn:setTag(TAG_ENUM.BT_TAKESCORE)
    btn:addTouchEventListener(btnEvent)
    ------

    ------
    --编辑框
    --取款金额
    local tmp = sp_bg:getChildByName("count_temp")
    local editbox = ccui.EditBox:create(tmp:getContentSize(),"im_bank_edit.png",UI_TEX_TYPE_PLIST)
        :setPosition(tmp:getPosition())
        :setFontName("fonts/round_body.ttf")
        :setPlaceholderFontName("fonts/round_body.ttf")
        :setFontSize(24)
        :setPlaceholderFontSize(24)
        :setMaxLength(32)
        :setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE)
        :setPlaceHolder("请输入取款金额")
    sp_bg:addChild(editbox)
    self.m_bankLayer.m_editNumber = editbox
    tmp:removeFromParent()

    --取款密码
    tmp = sp_bg:getChildByName("passwd_temp")
    editbox = ccui.EditBox:create(tmp:getContentSize(),"im_bank_edit.png",UI_TEX_TYPE_PLIST)
        :setPosition(tmp:getPosition())
        :setFontName("fonts/round_body.ttf")
        :setPlaceholderFontName("fonts/round_body.ttf")
        :setFontSize(24)
        :setPlaceholderFontSize(24)
        :setMaxLength(32)
        :setInputFlag(cc.EDITBOX_INPUT_FLAG_PASSWORD)
        :setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE)
        :setPlaceHolder("请输入取款密码")
    sp_bg:addChild(editbox)
    self.m_bankLayer.m_editPasswd = editbox
    tmp:removeFromParent()
    ------

    --当前游戏币
    self.m_bankLayer.m_textCurrent = sp_bg:getChildByName("text_current")

    --银行游戏币
    self.m_bankLayer.m_textBank = sp_bg:getChildByName("text_bank")

    --取款费率
    self.m_bankLayer.m_textTips = sp_bg:getChildByName("text_tips")
    self:getParentNode():sendRequestBankInfo()
end

--取款
function GameViewLayer:onTakeScore()
    --参数判断
    local szScore = string.gsub(self.m_bankLayer.m_editNumber:getText(),"([^0-9])","")
    local szPass = self.m_bankLayer.m_editPasswd:getText()

    if #szScore < 1 then 
        showToast(self,"请输入操作金额！",2)
        return
    end

    local lOperateScore = tonumber(szScore)
    if lOperateScore<1 then
        showToast(self,"请输入正确金额！",2)
        return
    end

    if #szPass < 1 then 
        showToast(self,"请输入银行密码！",2)
        return
    end
    if #szPass <6 then
        showToast(self,"密码必须大于6个字符，请重新输入！",2)
        return
    end

    self:showPopWait()  
    self:getParentNode():sendTakeScore(szScore,szPass)
end

--刷新银行游戏币
function GameViewLayer:refreshBankScore( )
    --携带游戏币
    local str = ExternalFun.numberThousands(GlobalUserItem.lUserScore)
    if string.len(str) > 19 then
        str = string.sub(str, 1, 19)
    end
    self.m_bankLayer.m_textCurrent:setString(str)

    --银行存款
    str = ExternalFun.numberThousands(GlobalUserItem.lUserInsure)
    if string.len(str) > 19 then
        str = string.sub(str, 1, 19)
    end
    self.m_bankLayer.m_textBank:setString(ExternalFun.numberThousands(GlobalUserItem.lUserInsure))

    self.m_bankLayer.m_editNumber:setText("")
    self.m_bankLayer.m_editPasswd:setText("")
end
------

function GameViewLayer:testPlayerlistLayer()
	local playerlist={}
	for i=1,3 do 
		playerlist[i]={}
		playerlist[i].szNickName="玩家"..i.."号"
		playerlist[i].wFaceID=100+i
		playerlist[i].lScore=i*i*i*i+10000
	end
	self:addChild(PlayerlistLayer:create(playerlist),10000)
end
--------------

function GameViewLayer:executecontrol(cmddata)
	self:getParentNode():executecontrol(cmddata)
end
function GameViewLayer:ControlAddPeizhi(cmddata)
	self:getParentNode():ControlAddPeizhi(cmddata)
end
function GameViewLayer:ControlDelPeizhi(cmddata)
	self:getParentNode():ControlDelPeizhi(cmddata)
end
function GameViewLayer:androidxiazhuang()
	self:getParentNode():androidxiazhuang()
end
function GameViewLayer:OnAdmincontorl(cmd_table)
	if cmd_table.cbResult == Game_CMD.CR_ACCEPT then
		if self.m_ControlLayer ~= nil then
			if cmd_table.cbAckType == Game_CMD.ACK_SET_WIN_AREA  then
				self.m_ControlLayer:OnUpdataControlstate()		
			elseif cmd_table.cbAckType == Game_CMD.ACK_RESET_CONTROL then
				self.m_ControlLayer:OnControlEnd()		
			end
		end
	else
	  showToast(self,"服务器拒绝您的操作",1)
	end	
end
function GameViewLayer:OnAdmincontorlpeizhi(cmd_table)
	self.m_ControlLayer:OnAddpeizhi(cmd_table.dwGameID,cmd_table.lscore)
end
function GameViewLayer:OnDelPeizhi(cmd_table)
	self.m_ControlLayer:OnDelPeizhi(cmd_table.dwGameID)
end
function GameViewLayer:OnUpAlllosewin(cmd_table)
	self.m_ControlLayer:setPlayerAreaBet(cmd_table.dwGameID,0,0,0,cmd_table.lTdTotalScore,cmd_table.lTotalScore,false,1,0,0)
	self.m_ControlLayer:UppeizhiLIst(cmd_table.dwGameID,cmd_table.lscore)
end
----------------

return GameViewLayer

