local GameViewLayer = class("GameViewLayer",function(scene)
		local gameViewLayer =  display.newLayer()
    return gameViewLayer
end)

if not yl then
require("client.src.plaza.models.yl")
end
local GameChat = appdf.req(appdf.CLIENT_SRC.."plaza.views.layer.game.GameChatLayer")
local cmd = appdf.req(appdf.GAME_SRC.."yule.zhajinhua.src.models.CMD_Game")
local SetLayer = appdf.req(appdf.GAME_SRC.."yule.zhajinhua.src.views.layer.SetLayer")
local PopupInfoHead = appdf.req("client.src.external.PopupInfoHead")

local CompareView = appdf.req(appdf.GAME_SRC.."yule.zhajinhua.src.views.layer.CompareView")
local GameEndView = appdf.req(appdf.GAME_SRC.."yule.zhajinhua.src.views.layer.GameEndView")
local ExternalFun = require(appdf.EXTERNAL_SRC .. "ExternalFun")
local AnimationMgr = appdf.req(appdf.EXTERNAL_SRC .. "AnimationMgr")
local scheduler = cc.Director:getInstance():getScheduler()

GameViewLayer.BT_EXIT 				= 1
GameViewLayer.BT_CHAT 				= 2
GameViewLayer.BT_GIVEUP				= 3
GameViewLayer.BT_READY				= 4
GameViewLayer.BT_LOOKCARD			= 5
GameViewLayer.BT_FOLLOW				= 6
GameViewLayer.BT_ADDSCORE			= 7
GameViewLayer.BT_CHIP				= 8
GameViewLayer.BT_CHIP_1				= 9
GameViewLayer.BT_CHIP_2				= 10
GameViewLayer.BT_CHIP_3				= 11
GameViewLayer.BT_CHIP_4				= 12


GameViewLayer.BT_COMPARE 			= 15
GameViewLayer.BT_CARDTYPE			= 16
GameViewLayer.BT_SET				= 17
GameViewLayer.BT_MENU				= 18
GameViewLayer.BT_BANK 				= 19
GameViewLayer.BT_VOICE_ENDED		= 20
GameViewLayer.BT_VOICE_BEGAN		= 21
GameViewLayer.BT_HELP 				= 22
GameViewLayer.BT_CLICKBLANK			= 23
GameViewLayer.BT_CHANGETABLE		= 24
GameViewLayer.BT_FOLLOWFOREVER      = 25
GameViewLayer.BT_HOW				= 26	

GameViewLayer.BT_TABLETIMER			= 27

GameViewLayer.BT_HIDERAISE			= 28

GameViewLayer.BT_SHOWCARD			= 29

GameViewLayer.CHIPNUM 				= 100

local ptPlayer = {cc.p(206.27, 66.05),cc.p(207.2, 65.77),cc.p(205.97, 66.76), cc.p(71.46, 44.86),cc.p(47.17, 73.15),cc.p(46.73, 73.20),cc.p(45.86, 179.82)}
--local ptCoin = {cc.p(865, 560), cc.p(980, 450), cc.p(980, 275), cc.p(680, 190), cc.p(325, 275), cc.p(325, 450), cc.p(480, 560)}
local ptCoin = {cc.p(480, 560), cc.p(325, 450), cc.p(325, 275), cc.p(680, 190), cc.p(980, 275),  cc.p(980, 450), cc.p(865, 560)}

--local ptCard = {cc.p(835, 560), cc.p(950, 450), cc.p(950, 275), cc.p(622, 190), cc.p(310, 275), cc.p(310, 450), cc.p(450, 560)}
local ptCard = {cc.p(450, 560), cc.p(310, 450), cc.p(310, 275), cc.p(622, 190), cc.p(950, 275),  cc.p(950, 450), cc.p(835, 560)}
local ptArrow = {cc.p(835, 560), cc.p(950, 450), cc.p(950, 275), cc.p(622, 190), cc.p(295, 275), cc.p(295, 450), cc.p(450, 560)}
local ptReady = {cc.p(490, 580), cc.p(244, 520), cc.p(244, 310), cc.p(640, 297), cc.p(1090, 310), cc.p(1090, 550), cc.p(820, 580)}
--local ptLookCard = {cc.p(865, 560), cc.p(980, 450), cc.p(980, 275), cc.p(680, 190), cc.p(345, 275), cc.p(345, 450), cc.p(480, 560)}
local ptLookCard = {cc.p(480, 560), cc.p(345, 450), cc.p(345, 275), cc.p(680, 190),cc.p(980, 275), cc.p(980, 450), cc.p(865, 560)}
local ptAddScore = {cc.p(480, 560), cc.p(345, 450), cc.p(345, 275), cc.p(680, 190),cc.p(980, 275), cc.p(980, 450), cc.p(865, 560)}
local ptGiveUpCard = {cc.p(865, 560), cc.p(980, 450), cc.p(980, 275), cc.p(680, 190), cc.p(345, 275), cc.p(345, 450), cc.p(480, 560)}
local ptChat = {cc.p(490, 580), cc.p(175, 635), cc.p(175, 395), cc.p(524, 312), cc.p(1159, 395), cc.p(1159, 635), cc.p(820, 580)}
--local ptUserInfo = {cc.p(750, 500),cc.p(920, 520),cc.p(920, 320), cc.p(75, 49.82),cc.p(75,320),cc.p(75, 520),cc.p(350, 500)}
local ptUserInfo = {cc.p(350, 500),cc.p(75, 520), cc.p(75,320), cc.p(75, 49.82), cc.p(920, 320), cc.p(920, 520),cc.p(750, 500)}

local ptSitDown = {cc.p(425, 650),cc.p(75, 475), cc.p(75,275), cc.p(75, 50), cc.p(1275, 275), cc.p(1275, 475),cc.p(975, 650)}

local anchorPoint = {cc.p(0, 0), cc.p(0, 0), cc.p(0, 0), cc.p(0, 0), cc.p(1, 0), cc.p(1, 0), cc.p(0, 0)}
-- ptWinLoseAnimate = {cc.p(800, 600), cc.p(1130, 430), cc.p(1130, 230), cc.p(180, 30), cc.p(150, 230), cc.p(150, 430), cc.p(480, 600)}
local ptWinLoseAnimate = {cc.p(480, 600), cc.p(150, 420), cc.p(150, 220),  cc.p(180, 30), cc.p(1130, 220), cc.p(1130, 420), cc.p(800, 600)}

local pChangeChairReady = cc.p(667,375)
local pChangeChairEnd = cc.p(667,171)

local AnimationRes = 
{
	{name = "yellow", file = cmd.RES.."animation_yellow/yellow_", nCount = 5, fInterval = 0.2, nLoops = 1},
	{name = "blue", file = cmd.RES.."animation_blue/blue_", nCount = 5, fInterval = 0.2, nLoops = 1}
}

function GameViewLayer:OnResetView()
	self:stopAllActions()

	self.btReady:setVisible(false)
	self.btChangeTable:setVisible(false)
	print("btChangeTable:setVisible false:OnResetView")
	--self:OnShowIntroduce(false)

	--self.m_ChipBG:setVisible(false)
	self.nodeButtomButton:setVisible(false)
    self.m_GameEndView:setVisible(false)
	self.btLookCard:setVisible(false)
	self.Netwaititem:setVisible(false)
	self.Netwaititem_2:setVisible(false)
	self:SetBanker(yl.INVALID_CHAIR)
	self:SetAllTableScore(0)

	--liuyang，总轮数，第几轮
	self:SetRounds(0,0,0)
	
	self.isFoldChair = false
	
	--跟到底ok
	self.m_ChkOK = false
	
	self:SetCompareCard(false)
	self:StopCompareCard()
	self:SetMaxCellScore(0)

	for i = 1 ,cmd.GAME_PLAYER do
		self:SetLookCard(i, false)
		self:SetUserCardType(i)
		self:SetUserTableScore(i, 0)
		self:SetUserGiveUp(i,false)
		self:SetUserCard(i, nil)
        self:clearCard(i)
		self:clearDisplay(i)
		self.m_FlashLight[i]:setVisible(false)
		if self.GameScoreNum[i] ~= nil then
			self.GameScoreNum[i]:removeFromParent()
			self.GameScoreNum[i] = nil
		end
	end
	
	self.bCardOut = {false, false, false}
	
	self._scene.m_bEndState = 1
	self:CleanAllJettons()
end

function GameViewLayer:onExit()
	--print("GameViewLayer onExit")
	cc.SpriteFrameCache:getInstance():removeSpriteFramesFromFile(cmd.RES.."zjh1.plist")
	cc.Director:getInstance():getTextureCache():removeTextureForKey(cmd.RES.."zjh1.png")
	cc.SpriteFrameCache:getInstance():removeSpriteFramesFromFile(cmd.RES.."game_zjh_res.plist")
	cc.Director:getInstance():getTextureCache():removeTextureForKey(cmd.RES.."game_zjh_res.png")
	cc.Director:getInstance():getTextureCache():removeUnusedTextures()
    cc.SpriteFrameCache:getInstance():removeUnusedSpriteFrames()
	
	if nil ~= self.m_scheduler then
		--print("stop dispatch")
		scheduler:unscheduleScriptEntry(self.m_scheduler)
		self.m_scheduler = nil
	end
	if nil ~= self.m_schedulerupdata then
		--print("stop dispatch")
		scheduler:unscheduleScriptEntry(self.m_schedulerupdata)
		self.m_schedulerupdata = nil
	end

    AnimationMgr.removeCachedAnimation(cmd.VOICE_ANIMATION_KEY)
			    --播放大厅背景音乐
    ExternalFun.playPlazzBackgroudAudio()
    --self.m_actVoiceAni:release()
    --self.m_actVoiceAni = nil
end

function GameViewLayer:getParentNode()
    return self._scene
end

function GameViewLayer:ctor(scene)
	local this = self

	local function onNodeEvent(event)  
       if "exit" == event then  
            this:onExit()  
        end  
    end  
	
	self.isFoldChair = false
	
    self.m_UserChat = {}
  
    self:registerScriptHandler(onNodeEvent)  

	self._scene = scene

	self.nChip = {1, 2, 5, 10}
	
	self:preloadUI()
		
	-- 加载csb资源
    local rootLayer, m_csbMain = ExternalFun.loadRootCSB("MainScene.csb", self )
    self.m_rootLayer = rootLayer

	display.loadSpriteFrames(cmd.RES.."game_zjh_res.plist",cmd.RES.."game_zjh_res.png")
	display.loadSpriteFrames(cmd.RES.."zjh1.plist",cmd.RES.."zjh1.png")
	display.loadSpriteFrames(cmd.RES.."zjh2.plist",cmd.RES.."zjh2.png")

	-- 语音动画
    AnimationMgr.loadAnimationFromFrame("record_play_ani_%d.png", 1, 3, cmd.VOICE_ANIMATION_KEY)

	--背景显示
--[[	display.newSprite(cmd.RES.."game_desk.png")
		:move(667,375)
		:addTo(self)--]]

	--按钮回调
	local  btcallback = function(ref, type)
        if type == ccui.TouchEventType.began then
            ExternalFun.popupTouchFilter(1, false)
        elseif type == ccui.TouchEventType.canceled then
            ExternalFun.dismissTouchFilter()
        elseif type == ccui.TouchEventType.ended then
        	ExternalFun.dismissTouchFilter()
			this:OnButtonClickedEvent(ref:getTag(),ref)
        end
    end
	
	--顶部下拉菜单--
	self.BtMenu = m_csbMain:getChildByName("Btn_Menu")
	self.BtMenu:setTag(GameViewLayer.BT_MENU)
	self.BtMenu:addTouchEventListener(btcallback)
	
	--牌型按钮
	self.BtCardType = m_csbMain:getChildByName("Btn_How")
	self.BtCardType:setTag(GameViewLayer.BT_HOW)
	self.BtCardType:addTouchEventListener(btcallback)
	self.BtCardType:setLocalZOrder(51)
	
	--坐下动画
	self.m_csbAniSitDown = ExternalFun.loadCSB("AniSitDown.csb", self.m_rootLayer)
	self.m_SitDown = ExternalFun.loadTimeLine(cmd.RES.."AniSitDown.csb")
	self.m_csbAniSitDown:setVisible(false)
	self.m_csbAniSitDown:runAction(self.m_SitDown)
	
	--定庄动画
	self.m_winsize = cc.Director:getInstance():getWinSize()
	self.m_csbAniBank = ExternalFun.loadCSB("AniBank.csb", self.m_rootLayer)
	self.m_AniBank = ExternalFun.loadTimeLine(cmd.RES.."AniBank.csb")
	self.m_csbAniBank:setVisible(false)
	self.m_csbAniBank:runAction(self.m_AniBank)
	self.m_csbAniBank:move(self.m_winsize.width / 2,self.m_winsize.height /2)
	self.btnBank = ExternalFun.getChildRecursiveByName(self.m_csbAniBank, "NodeBank")
	
	--豹子动画
	self.m_csbAniBaozi = ExternalFun.loadCSB("AniBaozi.csb", self.m_rootLayer)
	self.m_AniBaozi = ExternalFun.loadTimeLine(cmd.RES.."AniBaozi.csb")
	self.m_csbAniBaozi:setVisible(false)
	self.m_csbAniBaozi:runAction(self.m_AniBaozi)
	self.m_csbAniBaozi:move(self.m_winsize.width / 2 + 20,self.m_winsize.height *2/3)
	
	--同花顺动画
	self.m_csbAniTonghuashun = ExternalFun.loadCSB("AniTonghuashun.csb", self.m_rootLayer)
	self.m_AniTonghuashun = ExternalFun.loadTimeLine(cmd.RES.."AniTonghuashun.csb")
	self.m_csbAniTonghuashun:setVisible(false)
	self.m_csbAniTonghuashun:runAction(self.m_AniTonghuashun)
	self.m_csbAniTonghuashun:move(self.m_winsize.width / 2 + 20,self.m_winsize.height *2/3)
	
	--同花动画
	self.m_csbAniTonghua = ExternalFun.loadCSB("AniTonghua.csb", self.m_rootLayer)
	self.m_AniTonghua = ExternalFun.loadTimeLine(cmd.RES.."AniTonghua.csb")
	self.m_csbAniTonghua:setVisible(false)
	self.m_csbAniTonghua:runAction(self.m_AniTonghua)
	self.m_csbAniTonghua:move(self.m_winsize.width / 2 + 20,self.m_winsize.height *2/3)
		
	--设置按钮
	self.m_csbAniMenu = ExternalFun.loadCSB("AniMenu.csb", self.m_rootLayer)
	btn = ExternalFun.getChildRecursiveByName(self.m_csbAniMenu, "set_btn")
	btn:setTag(GameViewLayer.BT_SET)
	btn:setSwallowTouches(true)
	btn:addTouchEventListener(btcallback)
	
	--退出按钮
	self.btBack = ExternalFun.getChildRecursiveByName(self.m_csbAniMenu, "back_btn")
	self.btBack:setTag(GameViewLayer.BT_EXIT)
	self.btBack:setSwallowTouches(true)
	self.btBack:addTouchEventListener(btcallback)
	
	--除更多下拉框之外其他区域做成按钮
	self.m_btnBackMore = ExternalFun.getChildRecursiveByName(self.m_csbAniMenu, "back_more_btn")
	self.m_btnBackMore:setTag(GameViewLayer.BT_CLICKBLANK)
	self.m_btnBackMore:setSwallowTouches(true)
	self.m_btnBackMore:addTouchEventListener(btcallback)
	self.m_btnBackMore:setEnabled(false)
	self.m_btnBackMore:setVisible(false)
	
	----顶部下拉菜单End----
	
	---加注筹码
--[[	self.m_ChipBG = display.newSprite("#game_chip_bg.png")		--背景
		:move(1000, 145)
		:setVisible(false)
		:addTo(self)--]]
	--self.m_csbAniRaise = ExternalFun.loadCSB("AniRaise.csb", self.m_rootLayer)

	self.btChip = {}
	self.addscorek = {}
	self.addscorew = {}
	for i = 1, 4 do
		local strBigChip = string.format("chipbtn%d", i)
		self.btChip[i] = ExternalFun.getChildRecursiveByName(self.m_csbAniMenu, strBigChip)
		self.btChip[i]:setSwallowTouches(true)
		self.btChip[i]:setTag(GameViewLayer.BT_CHIP + i)
		self.btChip[i]:addTouchEventListener(btcallback)
		
--[[		cc.Label:createWithTTF("0", "fonts/round_body.ttf", 20)
			:move(50, 60)
			:setColor(cc.c3b(48, 48, 48))
			:setTag(GameViewLayer.CHIPNUM)
			:addTo(self.btChip[i])	--]]
			
		self.btChip[i].ChipAtlas = self.btChip[i]:getChildByName("chipatlas")
		self.btChip[i].ChipAtlas:setVisible(false)
		
		self.btChip[i].k = self.btChip[i]:getChildByName("k")
		self.btChip[i].k:setVisible(false)
		
		self.btChip[i].w = self.btChip[i]:getChildByName("w")
		self.btChip[i].w:setVisible(false)
		
			
	end
	
	--除更多下拉框之外其他区域做成按钮
--[[	self.m_btnHideRaise = ExternalFun.getChildRecursiveByName(self.m_csbAniMenu, "hide_btn")
	self.m_btnHideRaise:setTag(GameViewLayer.BT_HIDERAISE)
	self.m_btnHideRaise:setSwallowTouches(true)
	self.m_btnHideRaise:addTouchEventListener(btcallback)
	self.m_btnHideRaise:setEnabled(false)
	self.m_btnHideRaise:setVisible(false)--]]
	
	--筹码事件监听
--[[	local function onTouchBegan(touch,event)        
		local locationInNode = self.m_ChipBG:convertToNodeSpace(touch:getLocation())
		local size = self.m_ChipBG:getContentSize()
		local rect = cc.rect(0,0,size.width,size.height)
		if not cc.rectContainsPoint(rect,locationInNode) then
			if self.m_ChipBG:isVisible() == true then
				self.nodeButtomButton:setVisible(true)
				self.m_ChipBG:setVisible(false)
			end
			return true;
		end
		return false;
	end

	local function onTouchMoved(touch,event)        
	end

	local function onTouchEnded(touch, event)
	end
			
	local m_Listener = cc.EventListenerTouchOneByOne:create()
	--self.m_Listener:setSwallowTouches(true)
	m_Listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN)
	m_Listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED)
	m_Listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED)

	local dispacther = cc.Director:getInstance():getEventDispatcher()
	dispacther:addEventListenerWithSceneGraphPriority(m_Listener,  self.m_ChipBG)--]]
	---加注筹码end
	
	--筹码缓存
	self.nodeChipPool = m_csbMain:getChildByName("Nd_nodeChipPool")

	--顶部信息
	self.m_AllScoreBG= m_csbMain:getChildByName("RoomBetInfo")
	self.m_AllScoreBG:setVisible(false)
	self.m_AllScoreBG:setLocalZOrder(50)
	self.m_AllScoreBG:setAnchorPoint(cc.p(0.5,0.5))

    --所有下注
	self.m_txtAllScore = self.m_AllScoreBG:getChildByName("AllBetScore_Atlas")
	self.m_txtAllScore:setAnchorPoint(cc.p(0,0.5))
	
	--单注
	self.m_txtCellScore = self.m_AllScoreBG:getChildByName("CellBetScore_Atlas")
	self.m_txtCellScore:setAnchorPoint(cc.p(0,0.5))
	
	--轮次
	self.m_txtRounds = self.m_AllScoreBG:getChildByName("Rounds_Text")
	self.m_txtRounds:setAnchorPoint(cc.p(0,0.5))

	--底部按钮父节点
	self.nodeButtomButton = m_csbMain:getChildByName("Nd_nodeButtomButton")
	self.nodeButtomButton:setVisible(false)

--[[	--弃牌按钮
	self.btGiveUp = self.nodeButtomButton:getChildByName("Btn_Fold")
	self.btGiveUp:setEnabled(false)
	self.btGiveUp:setTag(GameViewLayer.BT_GIVEUP)--]]
	

	--看牌按钮
--[[	self.btLookCard = self.nodeButtomButton:getChildByName("Btn_LookCard")
	self.btLookCard:setEnabled(false)
	self.btLookCard:setTag(GameViewLayer.BT_LOOKCARD)--]]

	self.bCompareChoose = false
	--比牌按钮
	self.btCompare = self.nodeButtomButton:getChildByName("Btn_ShowDown")
	self.btCompare:setEnabled(false)
	self.btCompare:setTag(GameViewLayer.BT_COMPARE)
	
	--加注按钮
	self.btAddScore = self.nodeButtomButton:getChildByName("Btn_Raise")
	self.btAddScore:setEnabled(false)
	self.btAddScore:setTag(GameViewLayer.BT_ADDSCORE)
	
	--跟注按钮
	self.btFollow = self.nodeButtomButton:getChildByName("Btn_Follow")
	self.btFollow:setEnabled(false)
	self.btFollow:setTag(GameViewLayer.BT_FOLLOW)
	
	--跟注分值
	self.txt_CallScore = self.nodeButtomButton:getChildByName("CallScore_Atlas")
	self.txt_CallScore:setAnchorPoint(cc.p(0,0.5))
	self.txt_CallScore:setEnabled(false)
	
	--self.btLookCard:addTouchEventListener(btcallback)
	self.btCompare:addTouchEventListener(btcallback)
	self.btAddScore:addTouchEventListener(btcallback)
	self.btFollow:addTouchEventListener(btcallback)

	--玩家
	self.nodePlayer = {}
	--比牌判断区域
	self.rcCompare = {}

	self.m_UserHead = {}
	
	--探照灯
	self.m_FlashLight = {}

	self.txtConfig = string.getConfig("base/fonts/round_body.ttf" , 20)
	self.MytxtConfig = string.getConfig("base/fonts/round_body.ttf" , 24)

	--时钟
	self.m_TimeProgress = {}
	
	self.m_TimeProgressMask = {}
	
	--self.m_sp = {}
	
	--比牌箭头
	self.m_flagArrow = {}
	
	--比牌框
	self.m_compareframe = {}
	
	--个人下注池
	self.m_personchip={}

	--print("时钟.......")
	for i = 1, cmd.GAME_PLAYER do
		--玩家总节点
		self.nodePlayer[i] = m_csbMain:getChildByName("UserInfo_" .. i)
		self.nodePlayer[i]:setVisible(false)
		
		--等待比牌箭头
		self.m_flagArrow[i] = self.nodePlayer[i]:getChildByName("Arrow")
		self.m_flagArrow[i]:setVisible(false)
		
		--等待比牌框框
		self.m_compareframe[i] = self.nodePlayer[i]:getChildByName("compareframe")
		self.m_compareframe[i]:setVisible(false)
		
		
		local posArrow = cc.p(self.m_compareframe[i]:getPositionX(), self.m_compareframe[i]:getPositionY())
		posArrow = self.nodePlayer[i]:convertToWorldSpace(posArrow)			
		self.rcCompare[i] = cc.rect(posArrow.x -80 , posArrow.y - 80 , 150 , 150)
		
		self.m_UserHead[i] = {}
		--玩家背景
		self.m_UserHead[i].bg = self.nodePlayer[i]:getChildByName("Headbg")

		local txtsize = (i == cmd.MY_VIEWID and 24 or 20)
		local namepos = i == cmd.MY_VIEWID and cc.p(228,110) or cc.p(72,182)
		local scorepos = i == cmd.MY_VIEWID and cc.p(175,69) or cc.p(32,28)

		--昵称
		self.m_UserHead[i].id = self.nodePlayer[i]:getChildByName("NickName_Text")
		self.m_UserHead[i].id:setString("")
		--self.m_UserHead[i].name:setLineBreakWithoutSpace(false)
		
		--金币
		self.m_UserHead[i].score = self.nodePlayer[i]:getChildByName("GameScore_Atlas")
		self.m_UserHead[i].score:setAnchorPoint(cc.p(0,0.5))
		self.m_UserHead[i].score:setScale(0.5)
		
		--"万"字
		self.m_UserHead[i].Wanzi = self.nodePlayer[i]:getChildByName("wanzi")
		self.m_UserHead[i].Wanzi:setVisible(false)
		--"亿"字
		self.m_UserHead[i].Yizi = self.nodePlayer[i]:getChildByName("yizi")
		self.m_UserHead[i].Yizi:setVisible(false)
		
		self.m_UserHead[i].Control = self.nodePlayer[i]:getChildByName("Control")
		self.m_UserHead[i].Control:setVisible(false)
		
		--头像状态
		self.m_UserHead[i].m_bNormalState = {}
		
		--探照灯
		self.m_FlashLight[i] = {}
		self.m_FlashLight[i] = self.nodePlayer[i]:getChildByName("FlashLight")
				:setVisible(false)

		--计时器
--[[		self.m_TimeProgressMask[i]	 = display.newSprite("#progress-1.png")
			:setVisible(false)
			:setAnchorPoint(cc.p(0.5,0.5))
			:addTo(self.m_rootLayer)--]]
			
--[[		self.m_sp[i] = cc.Node:create()
		:addTo(self.m_rootLayer)--]]
		
		
		local ptProgress = {}
		self.m_TimeProgress[i] = cc.ProgressTimer:create(display.newSprite("#progress.png"))
             :setReverseDirection(false)
             --:move(ptPlayer[i])
             :setVisible(false)
			 :setAnchorPoint(cc.p(0.5,0.5))
             :setPercentage(100)
             --:addTo(self.nodePlayer[i])
			:addTo(self.m_rootLayer)
			
		self.m_ReadyProgress = cc.ProgressTimer:create(display.newSprite("#myprogress.png"))
		 :setReverseDirection(false)
		 :setVisible(false)
		 :setAnchorPoint(cc.p(0.5,0.5))
		 :setPercentage(100)
		 :addTo(self.m_rootLayer)
		
		self.m_personchip[i]={}
		
	end
	--手牌显示
	self.userCard = {}
	--下注显示背景框
	self.m_ScoreView = {}
	--准备显示
	self.m_flagReady = {}
	--看牌标示
	self.m_LookCard = {}
	--弃牌标示
	self.m_GiveUp = {}
	--旁观标示
	self.m_LookOn = {}
	--庄家标示
	self.m_BankerFlag = {}
	--比牌输标示
	self.m_CompareLose = {}

	--print("下注背景.......")
	for i = 1, cmd.GAME_PLAYER do
		self.m_ScoreView[i] = {}
		--下注背景
		self.m_ScoreView[i].frame = self.nodePlayer[i]:getChildByName("BetFrame")
		--self.m_ScoreView[i].frame:setAnchorPoint(cc.p(0,0.5))
		self.m_ScoreView[i].frame:setVisible(false)
		
		self.m_ScoreView[i].logo = self.nodePlayer[i]:getChildByName("BetScore")
		--self.m_ScoreView[i].logo:setAnchorPoint(cc.p(0,0))
		self.m_ScoreView[i].logo:setVisible(false)

		--下注数额
		self.m_ScoreView[i].score = self.nodePlayer[i]:getChildByName("BetScore_Atlas")
		self.m_ScoreView[i].score:setAnchorPoint(cc.p(0,0))
		self.m_ScoreView[i].score:setVisible(false)
		self.m_ScoreView[i].score:setScale(0.6)

		self.userCard[i] = {}
		self.userCard[i].card = {}
		--牌区域
		self.userCard[i].area = cc.Node:create()
			:setVisible(false)
			:addTo(self.m_rootLayer)
--[[		self.userCard[i].area = self.nodePlayer[i]:getChildByName("Area")
		self.userCard[i].area:setVisible(false)--]]
			
--[[		local pos = cc.p(self.nodePlayer[i]:getChildByName("Headbg"):getPositionX(), self.nodePlayer[i]:getChildByName("Headbg"):getPositionY())
		pos = self.nodePlayer[i]:convertToWorldSpace(pos)
			
		print("ptPlayer",i,pos.x,pos.y)--]]
			
		--牌显示	
		for j = 1, 3 do
			self.userCard[i].card[j] = display.newSprite("#card_back.png")
					:move(ptCard[i].x + (i==cmd.MY_VIEWID and 50 or 30)*(j - 1), ptCard[i].y)
					:setVisible(false)
					:addTo(self.userCard[i].area)
			if i ~= cmd.MY_VIEWID then
				self.userCard[i].card[j]:setScale(0.7)
			end
		end
		
		if  i == cmd.MY_VIEWID then
			--看牌按钮
			self.btLookCard = ccui.Button:create("bt_game_look_0.png","bt_game_look_0.png","bt_game_look_0.png",ccui.TextureResType.plistType)
					:move(ptCard[cmd.MY_VIEWID].x + 50 , ptCard[cmd.MY_VIEWID].y)
					:setVisible(false)
					--:setScaleY(1.3)
					:addTo(self.userCard[i].area)
					:setTag(GameViewLayer.BT_LOOKCARD)
--[[			--self.btLookCard:setEnabled(false)
			self.btLookCard:setVisible(false)
			self.btLookCard:setTag(GameViewLayer.BT_LOOKCARD)--]]
			self.btLookCard:addTouchEventListener(btcallback)
			self.btLookCard:setVisible(false)
			self.btLookCard:setEnabled(false)
		end
		
--[[		for j = 1, 3 do
			self.userCard[i].card[j] = m_csbMain:getChildByName("card_back" .. j)
			self.userCard[i].card[j]	:move(ptCard[i].x + (i==cmd.MY_VIEWID and 50 or 35)*(j - 1), ptCard[i].y)
			self.userCard[i].card[j]	:setVisible(false)
					:addTo(self.userCard[i].area)
			if i ~= cmd.MY_VIEWID then
				self.userCard[i].card[j]:setScale(0.7)
			end
		end--]]
		
		--牌类型
		self.userCard[i].cardType = display.newSprite("#card_type_0.png")
			:move(ptCard[i].x +  (i==cmd.MY_VIEWID and 50 or 35), ptCard[i].y- (i == cmd.MY_VIEWID and 50 or 21))
			:setVisible(false)
			:setScale(i==cmd.MY_VIEWID and 1.0 or 0.5)
			:addTo(self.userCard[i].area)
		
		--看牌标记
		self.m_LookCard[i] = display.newSprite("#game_flag_lookcard.png")
			:setVisible(false)
			:setScale(1.0)
			:move(ptLookCard[i])
			:addTo(self)
			
		--比牌输标记
		self.m_CompareLose[i] = display.newSprite("#Lose_img.png")
			:setVisible(false)
			:setScale(1.0)
			:move(ptLookCard[i])
			:addTo(self)

		--弃牌标示
		self.m_GiveUp[i] = self.nodePlayer[i]:getChildByName("Fold")
		self.m_GiveUp[i]:setVisible(false)
		
		--旁观标示
		self.m_LookOn[i] = self.nodePlayer[i]:getChildByName("LookOn")
		self.m_LookOn[i]:setVisible(false)

		--准备标示
		self.m_flagReady[i] =  self.nodePlayer[i]:getChildByName("Ready")
		self.m_flagReady[i]:setVisible(false)
		
		--庄家
		self.m_BankerFlag[i] = self.nodePlayer[i]:getChildByName("BankSign")
		self.m_BankerFlag[i]:setVisible(false)
				
	end
	
--[[	self.BtCardType = ccui.Button:create("bt_game_cardtype_0.png","bt_game_cardtype_1.png","bt_game_cardtype_0.png",ccui.TextureResType.plistType)
		:move(162,702)
		:setTag(GameViewLayer.BT_CARDTYPE)
		:addTo(self)
		:addTouchEventListener(btcallback)--]]

	--顶部信息
	local scoreinfo = display.newSprite("#game_bg_scoreinfo.png")
		:move(667,575)
		:addTo(self)
		:setVisible(false)
	display.newSprite("#game_word_cellscore.png")
		:move(50,25)
		:addTo(scoreinfo)
	display.newSprite("#game_word_maxscore.png")
		:move(220,25)
		:addTo(scoreinfo)
	--底注信息
	self.txt_CellScore = cc.LabelAtlas:create("0",cmd.RES.."game_num_score.png",14,20,string.byte("0"))
		:move(90,25)
		:setAnchorPoint(cc.p(0,0.5))
		:addTo(scoreinfo)
	--封顶显示
	self.txt_MaxCellScore = cc.LabelAtlas:create("0",cmd.RES.."game_num_score.png",14,20,string.byte("0"))
		:move(260, 25)
		:setAnchorPoint(cc.p(0,0.5))
		:addTo(scoreinfo)
	
	--准备按钮
	self.btReady = m_csbMain:getChildByName("Btn_Ready")
	self.btReady:setTag(GameViewLayer.BT_READY)
	self.btReady:setVisible(false);
	self.btReady:addTouchEventListener(btcallback)
	
	--亮牌按钮
	self.btShowCard = m_csbMain:getChildByName("Btn_ShowCard")
	self.btShowCard:setTag(GameViewLayer.BT_SHOWCARD)
	self.btShowCard:setVisible(false);
	self.btShowCard:addTouchEventListener(btcallback)
	
	--换桌按钮
	self.btChangeTable = m_csbMain:getChildByName("Btn_ChangeTable")
	self.btChangeTable:setTag(GameViewLayer.BT_CHANGETABLE)
	self.btChangeTable:setVisible(false)
	print("btChangeTable:setVisible false:ctor")
	self.m_AllScoreBG:setLocalZOrder(99)
	self.btChangeTable:addTouchEventListener(btcallback)
	
	cc.Label:createWithTTF("(3)","base/fonts/round_body.ttf",18)
	:move(self.btChangeTable:getContentSize().width/2 + 50, self.btChangeTable:getContentSize().height/2 + 5)
	:setVisible(false)
	:setTag(GameViewLayer.BT_TABLETIMER)
	:setColor(cc.c3b(242, 199, 89))
	:addTo(self.btChangeTable)
	
	self.m_ChangeTablepos = self:convertToWorldSpace(cc.p(self.btChangeTable:getPositionX(),self.btChangeTable:getPositionY()))	
	
	--弃牌按钮
	self.btGiveUp = m_csbMain:getChildByName("Btn_Fold")
	self.btGiveUp:setEnabled(true)
	self.btGiveUp:setVisible(false)
	self.btGiveUp:setTag(GameViewLayer.BT_GIVEUP)
	self.btGiveUp:addTouchEventListener(btcallback)
	
	--跟到底按钮
	self.btFollowForEver = m_csbMain:getChildByName("Btn_FollowForEver")
	self.btFollowForEver:setTag(GameViewLayer.BT_FOLLOWFOREVER)
	self.btFollowForEver:setVisible(false);
	self.btFollowForEver:addTouchEventListener(btcallback)
	
	--跟到底打钩图标
	self.chkFollowOK = m_csbMain:getChildByName("Chk_Ok")
	self.chkFollowOK:setVisible(false)
	
	--比牌时间显示按钮
	self.btCompareTime = m_csbMain:getChildByName("Btn_ComPare")
	self.btCompareTime:setEnabled(false)
	self.btCompareTime:setVisible(false)

--[[	--缓存聊天
	self.m_UserChatView = {}
	--聊天泡泡
	for i = 1 , cmd.GAME_PLAYER do
		if i <= cmd.MY_VIEWID then
		self.m_UserChatView[i] = display.newSprite("#game_chat_lbg.png"	,{scale9 = true ,capInsets=cc.rect(30, 14, 46, 20)})
			:setAnchorPoint(cc.p(0,0.5))
			:move(ptChat[i])
			:setVisible(false)
			:addTo(self)
		else
		self.m_UserChatView[i] = display.newSprite( "#game_chat_rbg.png",{scale9 = true ,capInsets=cc.rect(14, 14, 46, 20)})
			:setAnchorPoint(cc.p(1,0.5))
			:move(ptChat[i])
			:setVisible(false)
			:addTo(self)
		end
	end--]]
	
	--print("牌型介绍.......")

	--牌型介绍
	self.bIntroduce = false
	self.cardTypeIntroduce = display.newSprite("card_type.png")
		:move(-163, display.cy)
		:setVisible(false)
		:addTo(self)

	--点击事件
--[[	local touch = display.newLayer()
		:setLocalZOrder(10)
		:addTo(self)
	touch:setTouchEnabled(true)
	touch:registerScriptTouchHandler(function(eventType, x, y)
		return this:onTouch(eventType, x, y)
	end)--]]
		--点击事件
	self:setTouchEnabled(true)
	self:registerScriptTouchHandler(function(eventType, x, y)
		return self:onEventTouchCallback(eventType, x, y)
	end)

	--比牌层
	self.m_CompareView = CompareView:create()
		:setVisible(false)
		:addTo(self, 15)
	--普通结算层
	self.m_GameEndView	= GameEndView:create(self.MytxtConfig)
		:setVisible(false)
		:addTo(self, 20)

	--聊天窗口层
	self.m_GameChat = GameChat:create(scene._gameFrame)
		:setLocalZOrder(10)
        :addTo(self)

    --设置层
	self._setLayer = SetLayer:create(self)
		:addTo(self, 10)

--[[	-- 语音按钮 gameviewlayer -> gamelayer -> clientscene
	local btnVoice = ccui.Button:create("btn_voice_zjh_0.png","btn_voice_zjh_1.png","btn_voice_zjh_0.png",ccui.TextureResType.plistType)
		:move(380, 180)
		:setVisible(false)
		:addTo(self)
	btnVoice:addTouchEventListener(function(ref, eventType)
 		if eventType == ccui.TouchEventType.began then
 			self:getParentNode():getParentNode():startVoiceRecord()
        elseif eventType == ccui.TouchEventType.ended 
        	or eventType == ccui.TouchEventType.canceled then
        	self:getParentNode():getParentNode():stopVoiceRecord()
        end
	end)
    -- 语音动画
    local param = AnimationMgr.getAnimationParam()
    param.m_fDelay = 0.1
    param.m_strName = cmd.VOICE_ANIMATION_KEY
    local animate = AnimationMgr.getAnimate(param)
    self.m_actVoiceAni = cc.RepeatForever:create(animate)
    self.m_actVoiceAni:retain()--]]
	
	self.GameScoreNum = {}

	for i = 1,cmd.GAME_PLAYER do 
		self.GameScoreNum[i] = nil	
	end
	
	self.m_tabUserItem = {}
	self.m_scheduler = nil
	self.istable = false
	self.m_tabletimer = 3
	self.bdeleteuserdata = false
	self.m_schedulerupdata = nil
	function upuserdata(dt)
		local MyTable = self._scene:GetMeTableID()
		local n = table.maxn(self.m_tabUserItem)
        for j = 1,n do
			local userItem = self.m_tabUserItem[j]
			if userItem ~= nil then
				if self._scene ~= nil and self._scene._gameFrame ~= nil and self._scene._gameFrame._UserList[userItem.dwUserID] ~= nil then
					if self._scene._gameFrame._UserList[userItem.dwUserID].wTableID ~= MyTable then
						--self.nodePlayer[j]:setVisible(false)
						self.m_flagReady[j]:setVisible(false)
						--self.cbGender[j] = nil
						if self.m_UserHead[j].head then
							self.m_UserHead[j].head:setVisible(false)
						end

						self.nodePlayer[j]:setVisible(false)
						self.m_tabUserItem[j] = nil
					end				
				end
			end
        end
	end
	if nil == self.m_schedulerupdata then
		self.m_schedulerupdata = scheduler:scheduleScriptFunc(upuserdata, 0.3, false)
	end
	
	self.m_testtableid = cc.Label:create()
	:move(1100, 150)
	:setAnchorPoint(cc.p(1, 0.5))
	:setTextColor(cc.c3b(0, 0, 0))
	:setSystemFontSize(20)
	:addTo(self)
	:setVisible(false)
	
	self.m_testchairid = cc.Label:create()
	:move(1100, 100)
	:setAnchorPoint(cc.p(1, 0.5))
	:setTextColor(cc.c3b(0, 0, 0))
	:setSystemFontSize(20)
	:addTo(self)
	:setVisible(false)
	
	self.m_othertableid = cc.Label:create()
	:move(50, 200)
	:setAnchorPoint(cc.p(1, 0.5))
	:setTextColor(cc.c3b(0, 0, 0))
	:setSystemFontSize(20)
	:addTo(self)
	
	self.m_otherchairid = cc.Label:create()
	:move(50, 150)
	:setAnchorPoint(cc.p(1, 0.5))
	:setTextColor(cc.c3b(0, 0, 0))
	:setSystemFontSize(20)
	:addTo(self)
	
		--前端控数据 
	self.cbSurplusCardCount = 0       --剩余牌数量
	self.cbControlUserCardData = {}	  --每个玩家数据
	self.bAICount = {}				  --是否为机器人
	self.ControlCardData= {}		  --剩余牌数据
	self.ControlCardImage = {}
	self.bControlCardOut = {}
	for i = 1,52 do		
		self.ControlCardImage[i] = nil
		self.bControlCardOut[i] = false
	end
	self.Netwaititem =  display.newSprite(cmd.RES.."net_wait_item_bg.png")
	:move(display.cx + 10,display.cy + 80)
	:setVisible(false)
	:addTo(self,100)
	
	self.Netwaititem_2 =  display.newSprite(cmd.RES.."net_wait_item_bg_2.png")
	:move(display.cx + 10,display.cy + 80)
	:setVisible(false)
	:addTo(self,100)
--[[		self.cardTypeIntroduce = display.newSprite("#card_type.png")
		:move(-163, display.cy)
		:setVisible(false)
		:addTo(self)--]]
	
--[[	self.m_winsize = cc.Director:getInstance():getWinSize()
	self.tamara  = display.newSprite("#chip_icon.png")
	--:setVisible(true)
	:setPosition(cc.p(self.m_winsize.width / 2, self.m_winsize.height / 3))
	:addTo(self, 200)--]]
	
end

--更新时钟
function GameViewLayer:OnUpdataClockView(viewid,time)

end

--更新用户显示
function GameViewLayer:OnUpdateUserStatus(viewid)
	self.nodePlayer[viewid]:setVisible(false)
	self.m_flagReady[viewid]:setVisible(false)

	if self.m_UserHead[viewid].head then
		self.m_UserHead[viewid].head:setVisible(false)
	end
	self.nodePlayer[viewid]:setVisible(false)
	self.m_tabUserItem[viewid] = nil
end


--更新用户显示
function GameViewLayer:OnUpdateUser(viewid,userItem,bStatus)
	if userItem ~= nil  then
		if userItem.cbUserStatus == yl.US_LOOKON then
			return		
		end
	end
	if not viewid or viewid == yl.INVALID_CHAIR then
		--print("OnUpdateUser viewid is nil")
		return
	end
	--self.nodePlayer[viewid]:setVisible(userItem ~= nil)
				
	local MyChair = self._scene:GetMeChairID() + 1
	--播放坐下动画
	if userItem ~= nil then
		--游戏未开始
		if self._scene.m_bStartGame == false then
			if self._scene.m_bEndState == 1 and self._scene.m_cbGameStatus == cmd.GAME_STATUS_FREE then
				if (userItem.cbUserStatus == yl.US_SIT) and viewid ~= cmd.MY_VIEWID and self._scene.m_lTableScore[userItem.wChairID + 1] == 0 and self._scene.m_cbPlayStatus[userItem.wChairID + 1] == 0 then	
					self.m_csbAniSitDown:setVisible(true)
					self.m_SitDown:play("SitDown", false)
					self.m_csbAniSitDown:setVisible(true)
					self.m_csbAniSitDown:move(ptSitDown[viewid].x,ptSitDown[viewid].y)
					ExternalFun.playSoundEffect("GAME_SITDOWN.mp3")
					function callBack()
						self.m_csbAniSitDown:setVisible(false)
					end
					self.m_SitDown:setLastFrameCallFunc(callBack)
				end			
			end
			
			--换桌过来的，游戏正在进行
			if  self._scene.m_cbGameStatus == cmd.GAME_STATUS_PLAY then
				if (userItem.cbUserStatus == yl.US_SIT) and viewid ~= cmd.MY_VIEWID and self._scene.m_lTableScore[userItem.wChairID + 1] == 0 and self._scene.m_cbPlayStatus[userItem.wChairID + 1] == 0 then	
					self.m_csbAniSitDown:setVisible(true)
					self.m_SitDown:play("SitDown", false)
					self.m_csbAniSitDown:setVisible(true)
					self.m_csbAniSitDown:move(ptSitDown[viewid].x,ptSitDown[viewid].y)
					ExternalFun.playSoundEffect("GAME_SITDOWN.mp3")
					function callBack()
						self.m_csbAniSitDown:setVisible(false)
					end
					self.m_SitDown:setLastFrameCallFunc(callBack)
				end			
			end
			
		else
		--游戏开始了
		local a ={}
		for i = 1,cmd.GAME_PLAYER do
			a[i] = self._scene.m_lTableScore[i]
		end
			
			if (userItem.cbUserStatus == yl.US_SIT) and viewid ~= cmd.MY_VIEWID and self._scene.m_lTableScore[userItem.wChairID + 1] == 0 then	
				self.m_csbAniSitDown:setVisible(true)
				self.m_SitDown:play("SitDown", false)
				self.m_csbAniSitDown:setVisible(true)
				self.m_csbAniSitDown:move(ptSitDown[viewid].x,ptSitDown[viewid].y)
				ExternalFun.playSoundEffect("GAME_SITDOWN.mp3")
				function callBack()
					self.m_csbAniSitDown:setVisible(false)
				end
				self.m_SitDown:setLastFrameCallFunc(callBack)
			end	
		
		end
	end

--[[	if userItem ~= nil then
		if (userItem.cbUserStatus == yl.US_READY or userItem.cbUserStatus == yl.US_SIT) and viewid ~= cmd.MY_VIEWID then	
			if self._scene.m_bStartGame == true then
				self.m_csbAniSitDown:setVisible(true)
				self.m_SitDown:play("SitDown", false)
				self.m_csbAniSitDown:setVisible(true)
				self.m_csbAniSitDown:move(ptSitDown[viewid].x,ptSitDown[viewid].y)
				ExternalFun.playSoundEffect("GAME_SITDOWN.mp3")
				function callBack()
					self.m_csbAniSitDown:setVisible(false)
				end
				self.m_SitDown:setLastFrameCallFunc(callBack)
			end
		end	
	end--]]

	if userItem == nil and self.btReady:isVisible() == false then
        --self:clearCard(viewid)
	end
	
	if viewid == cmd.MY_VIEWID and userItem ~= nil then
		if userItem.dwGameID == 189509 or userItem.dwGameID == 191477 or userItem.dwGameID == 733752 or userItem.dwGameID == 205491 or userItem.dwGameID == 115243 then
			--显示自己桌子椅子
			local strtableid = "我的桌子ID:"..self._scene._gameFrame:GetTableID()
			self.m_testtableid:setString(strtableid)
			self.m_testtableid:setVisible(true)

			local strchairid = "我的椅子ID:"..self._scene:GetMeChairID() + 1
			self.m_testchairid:setString(strchairid)
			self.m_testchairid:setVisible(true)
		end
	end
	
	if userItem ~= nil then
		for i = 1, cmd.GAME_PLAYER do
			local wViewChairId = self._scene:SwitchViewChairID(i-1)
			if wViewChairId == viewid then
				local userItem = self._scene:getUserInfoByChairID(i - 1)
					for j = 1, 3 do
						local bStatus = self._scene.m_cbPlayStatus[i]
						if self._scene.m_cbPlayStatus[i] == 1 then
							self.userCard[viewid].card[j]:setVisible(true)
							--self.userCard[viewid].card[j]:setSpriteFrame("card_back.png")
						else
							--self.userCard[viewid].card[j]:setVisible(false)
						end
					end
				break
			end
		end
	end
	
	
--[[	if userItem ~= nil and userItem.cbUserStatus == yl.US_SIT and self._scene.m_lTableScore[viewid] > 0 then
		self.m_GiveUp[viewid]:setVisible(true)
	end--]]

	print("self._gameView.btChangeTableself._gameView.btChangeTable enable:",self.btChangeTable:isEnabled())
	
	if not userItem then
		if self.m_UserHead[viewid].head then
			self.m_UserHead[viewid].head:setVisible(false)
		end
		self.m_UserHead[viewid].id:setString("")
		self.m_UserHead[viewid].score:setString("")
		self.m_flagReady[viewid]:setVisible(false)
		
		--local MyChair = self._scene:GetMeChairID() + 1
		--self:clearCard(viewid)
		self.nodePlayer[viewid]:setVisible(false)
	else
		
		if self.bdeleteuserdata ==  true then
			for i = 1,cmd.GAME_PLAYER do	
				self.nodePlayer[i]:setVisible(false)
				self.m_flagReady[i]:setVisible(false)
				--self.cbGender[i] = nil
				if self.m_UserHead[i].head then
					self.m_UserHead[i].head:setVisible(false)
				end
				self.nodePlayer[i]:setVisible(false)
				self.m_tabUserItem[i] = nil
			end
		end
		self.bdeleteuserdata = false
		self.m_tabUserItem[viewid] = userItem

--[[		if userItem.cbUserStatus == yl.US_OFFLINE then
			for i = 1, 3 do
				self.userCard[viewid].card[i]:setVisible(true)
				self.userCard[viewid].card[i]:setSpriteFrame("card_break.png")
			end
		elseif  self._scene.m_bStartGame == true and userItem.cbUserStatus ==  yl.US_PLAYING  then
			local MyChair = self._scene:GetMeChairID() + 1
			if userItem.wChairID + 1 == MyChair then
				if self._scene.m_bLookCard[userItem.wChairID+1] == false then
					for i = 1, 3 do
						self.userCard[viewid].card[i]:setVisible(true)
						self.userCard[viewid].card[i]:setSpriteFrame("card_back.png")
					end
				end
			else
					for i = 1, 3 do
						self.userCard[viewid].card[i]:setVisible(true)
						self.userCard[viewid].card[i]:setSpriteFrame("card_back.png")
					end
			end		
		end--]]
		
		self.nodePlayer[viewid]:setVisible(true)
		local str = string.format("ID:%d", userItem.dwGameID)
		self.m_UserHead[viewid].id:setString(string.EllipsisByConfig(str,viewid == cmd.MY_VIEWID and 180 or 180,viewid == cmd.MY_VIEWID and self.MytxtConfig or self.txtConfig))

		--self.m_UserHead[viewid].score:setString(string.EllipsisByConfig(string.formatNumberThousands(userItem.lScore,true),viewid == cmd.MY_VIEWID and 150 or 105,viewid == cmd.MY_VIEWID and self.MytxtConfig or self.txtConfig))
		
		--local scoreStr = string.formatNumberThousands(userItem.lScore,true,"/")
		
--[[		for i = 1, cmd.GAME_PLAYER do
			local wViewChairId = self._scene:SwitchViewChairID(i-1)
			
			if wViewChairId == viewid then
				local userItem = self._scene:getUserInfoByChairID(i - 1)
				if userItem ~= nil then
					local numscore = userItem.lScore - self._scene.m_lTableScore[i]
					self.m_UserHead[viewid].score:setString(ExternalFun.formatScoreText(numscore))
				end
				break
			end
		end--]]

--]]
		self.m_UserHead[viewid].score:setString(string.formatNumberFhousands(userItem.lScore))
		
		local pos = cc.p(self.m_UserHead[viewid].score:getPositionX(),
					self.m_UserHead[viewid].score:getPositionY())
		
		--pos = self.nodePlayer[viewid]:convertToWorldSpace(pos)	

--[[		if userItem.lScore < 100000000 then
			if userItem.lScore < 10000 then
				self.m_UserHead[viewid].Wanzi:setVisible(false)
				self.m_UserHead[viewid].Yizi:setVisible(false)
				self.m_UserHead[viewid].Wanzi:move(pos.x + self.m_UserHead[viewid].score:getContentSize().width * 0.6 + 5,pos.y)
			else
				self.m_UserHead[viewid].Wanzi:setVisible(true)
				self.m_UserHead[viewid].Yizi:setVisible(false)
				self.m_UserHead[viewid].Wanzi:move(pos.x + self.m_UserHead[viewid].score:getContentSize().width * 0.6 + 5,pos.y)
			end

		else
			self.m_UserHead[viewid].Wanzi:setVisible(false)
			self.m_UserHead[viewid].Yizi:setVisible(true)
			self.m_UserHead[viewid].Yizi:move(pos.x + self.m_UserHead[viewid].score:getContentSize().width * 0.6 + 5,pos.y)
		end--]]
		
		--self.m_UserHead[viewid].Wanzi:move(pos.x,pos.y)
		
--[[		if viewid ~= cmd.MY_VIEWID then
			local aa = pos.x + self.m_UserHead[viewid].score:getContentSize().width
			local bb = pos.y * 0.6 + 12
		end--]]
		
		--liuyang,followok
		if viewid == cmd.MY_VIEWID then
			self.btFollowForEver:setVisible(yl.US_PLAYING == userItem.cbUserStatus)
			self.chkFollowOK:setVisible(self.m_ChkOK == true)
			if yl.US_PLAYING ~= userItem.cbUserStatus then
				self.chkFollowOK:setVisible(false)
			end
		end
		
--[[		if yl.US_SIT == userItem.cbUserStatus and yl.US_PLAYING ~= userItem.cbUserStatus then
			self.m_LookOn[viewid]:setVisible(true)
		end--]]
		
		for i = 1, cmd.GAME_PLAYER do
			print("self._scene.m_cbPlayStatus[i]:",self._scene.m_cbPlayStatus[i])
			print("self._scene.m_lTableScore[i]:",self._scene.m_lTableScore[i])
			
			if yl.US_SIT == userItem.cbUserStatus and yl.US_PLAYING ~= userItem.cbUserStatus then
				--self.m_LookOn[viewid]:setVisible(true)
				if self._scene.m_cbPlayStatus[i] ~= 1 and self._scene.m_lTableScore[i] <= 0 and  self._scene.m_bReallyStart == 1 then
					if  viewid == self._scene:SwitchViewChairID(i-1) then
						--self:SetUserGiveUp(viewid, true)
						self.m_LookOn[viewid]:setVisible(true)
					end
				end	
			end
		end

		self.m_flagReady[viewid]:setVisible(yl.US_READY == userItem.cbUserStatus)
		if not self.m_UserHead[viewid].head then
			--self.m_UserHead[viewid].head = PopupInfoHead:createNormal(userItem, 82)
			self.m_UserHead[viewid].head   = PopupInfoHead:createNormalCircle(userItem, 85,("Circleframe.png"))
			--self.m_sp[viewid] = HeadSprite:createNormalCircle(userItem, 95,("Circleframe.png"))
--[[			if viewid == cmd.MY_VIEWID then
				self.m_UserHead[viewid].head:move(50, 50)
			else
				self.m_UserHead[viewid].head:move(50, 50)
			end--]]
			self.m_UserHead[viewid].head:move(51, 54)
			--self.m_UserHead[viewid].head:enableHeadFrame(true)
			self.m_UserHead[viewid].head:enableInfoPop(true, ptUserInfo[viewid], anchorPoint[viewid])
			self.m_UserHead[viewid].head:addTo(self.m_UserHead[viewid].bg)
			
			self.m_UserHead[viewid].m_bNormalState = true
		else
			self.m_UserHead[viewid].head:updateHead(userItem)
			--self.m_sp[viewid] = self.m_UserHead[viewid].head:updateHead(userItem)
		end
		self.m_UserHead[viewid].head:setVisible(true)
		
		
		--掉线头像变灰
		if userItem.cbUserStatus == yl.US_OFFLINE then
			if self.m_UserHead[viewid].m_bNormalState then
				convertToGraySprite(self.m_UserHead[viewid].head.m_head.m_spRender)
			end
			self.m_UserHead[viewid].m_bNormalState = false
		else
			if not self.m_UserHead[viewid].m_bNormalState then
				convertToNormalSprite(self.m_UserHead[viewid].head.m_head.m_spRender)
			end
			self.m_UserHead[viewid].m_bNormalState = true
		end
	end
end

--屏幕点击
function GameViewLayer:onEventTouchCallback(eventType, x, y)

	if eventType == "began" then
		--牌型显示判断
		if self.bIntroduce == true then
			return true
		end

		if self.m_bShowMenu == true then
			local rc = self.m_AreaMenu:getBoundingBox()
			if rc then
				if not cc.rectContainsPoint(rc,cc.p(x,y)) then
					self:ShowMenu(false)
					return true
				end
			end
		end

		--比牌选择判断
		if self.bCompareChoose == true then
			for i = 1, cmd.GAME_PLAYER do
				if cc.rectContainsPoint(self.rcCompare[i],cc.p(x,y)) then
					return true
				end
			end
		end

		--结算框
		if self.m_GameEndView:isVisible() then
			local rc = self.m_GameEndView:GetMyBoundingBox()
			if rc and not cc.rectContainsPoint(rc, cc.p(x, y)) then
				self.m_GameEndView:setVisible(false)
				return true
			end
		end

		return true
	elseif eventType == "ended" then
		--取消牌型显示
		if self.bIntroduce == true then
			local rectIntroduce = self.cardTypeIntroduce:getBoundingBox()
			if rectIntroduce and not cc.rectContainsPoint(rectIntroduce, cc.p(x, y)) then
				self:OnShowIntroduce(false)
			end
		end

		--比牌选择
		if self.bCompareChoose == true then
			for i = 1, cmd.GAME_PLAYER do
				if cc.rectContainsPoint(self.rcCompare[i],cc.p(x,y)) then
					self._scene:OnCompareChoose(i)
					break
				end
			end
		end
		
		for m = 1,cmd.GAME_PLAYER do
			-- 判断手上是否有牌
			if self.userCard[m].card[1]:isVisible()  == true and self.bAICount[m] == true  then
				 --return true
				for i = 3, 1,-1 do
					local pos = cc.p(x, y)
					local rectLayerBg = self.userCard[m].card[i]:getBoundingBox()
					local x2, y2 = self.userCard[m].card[i]:getPosition()
					if cc.rectContainsPoint(rectLayerBg, pos) then
						local GameID =  string.gsub(self.m_UserHead[m].id:getString(),"([^0-9])","")
						GameID = string.gsub(GameID, "[.]", "")
						local lgameID = tonumber(GameID)
						if self.cbSurplusCardCount > 0 then
							for j = self.cbSurplusCardCount, 1,-1 do
								if true == self.bControlCardOut[j] then
	
									self._scene:onSendControlData(self.ControlCardData[j],i,j,lgameID)
									
									local x3, y3 = self.ControlCardImage[j]:getPosition()
									self.ControlCardImage[j]:move(x3, y3 - 30)
									self.bControlCardOut[j] = false
									return true
								end
							end
						end
						return true
					end
				end
			end		
		end

		
		--点击控制牌
		if self.cbSurplusCardCount > 0 then
			for i = self.cbSurplusCardCount, 1,-1 do
				local pos = cc.p(x, y)
				local rectLayerBg = self.ControlCardImage[i]:getBoundingBox()
				local x2, y2 = self.ControlCardImage[i]:getPosition()
				if cc.rectContainsPoint(rectLayerBg, pos) then
					if false == self.bControlCardOut[i] then
						self.ControlCardImage[i]:move(x2, y2 + 30)
						self._scene:PlaySound(cmd.RES.."sound_res/selectcard.wav")
					elseif true == self.bControlCardOut[i] then
						self.ControlCardImage[i]:move(x2, y2 - 30)
						self._scene:PlaySound(cmd.RES.."sound_res/start.wav")
					end
					self.bControlCardOut[i] = not self.bControlCardOut[i]
					for j = self.cbSurplusCardCount, 1,-1 do
						if i ~= j then
							if true == self.bControlCardOut[j] then
								local x3, y3 = self.ControlCardImage[j]:getPosition()
								self.ControlCardImage[j]:move(x3, y3 - 30)
								self._scene:PlaySound(cmd.RES.."sound_res/start.wav")
								self.bControlCardOut[j] = false
							end
						end
					end
					return true
				end
            end
		end
		
		
		
		
		
	end

	return true
end

--牌类型介绍的弹出与弹入
function GameViewLayer:OnShowIntroduce(bShow)
	if self.bIntroduce == bShow then
		return
	end

	local point
	if bShow then
		point = cc.p(163, display.cy+20) 			--移入的位置
	else
		point = cc.p(-163, display.cy+20)			--移出的位置
	end
	self.bIntroduce = bShow
	self.cardTypeIntroduce:stopAllActions()
	if bShow == true then
		self.cardTypeIntroduce:setVisible(true)
		--self:ShowMenu(false)
	end
	local this = self
	self.cardTypeIntroduce:runAction(cc.Sequence:create(
		cc.MoveTo:create(0.3, point), 
		cc.CallFunc:create(function()
				this.cardTypeIntroduce:setVisible(this.bIntroduce)
			end)
		))

end

--筹码移动
function GameViewLayer:PlayerJetton(wViewChairId, num,notani)
--[[	if not num or num < 1 or not self.m_lCellScore or self.m_lCellScore < 1 then
		return
	end--]]
	
	if not num or num < 0.0001 or not self.m_lCellScore or self.m_lCellScore < 0.0001 then
		return
	end
	
	if notani == true then
		local n = table.maxn(self.m_personchip[wViewChairId])
		for j = 1,n do
			if nil ~= self.m_personchip[wViewChairId][j] and nil ~= self.m_personchip[wViewChairId][j]:getParent() then
				self.m_personchip[wViewChairId][j]:setVisible(false)
				self.m_personchip[wViewChairId][j]:removeFromParent()
				self.m_personchip[wViewChairId][j] = nil
			end
		end
		self.m_personchip[wViewChairId] = {}
	end

	local nIndex = 1
	local chipscore = num
	while chipscore > 0 
	do
		local strChip
		local strScore 
--[[		if chipscore >= self.m_lCellScore * 5 then
			strChip = "#chipBtn1.png"
			chipscore = chipscore - self.m_lCellScore * 5
			strScore = (self.m_lCellScore*5)..""
		elseif chipscore >= self.m_lCellScore*2 then
			strChip = "#chipBtn1.png"
			chipscore = chipscore - self.m_lCellScore * 2
			strScore = (self.m_lCellScore*2)..""
		else
			strChip = "#chipBtn1.png"
			chipscore = chipscore - self.m_lCellScore 
			strScore = self.m_lCellScore..""
		end--]]
		if chipscore >= 400000 then
			strChip = "#Coin400K.png"
			chipscore = chipscore - 400000
		elseif chipscore >= 200000 then
			strChip = "#Coin200K.png"
			chipscore = chipscore - 200000
		elseif chipscore >= 100000 then
			strChip = "#Coin100K.png"
			chipscore = chipscore - 100000
		elseif chipscore >= 50000 then
			strChip = "#Coin50K.png"
			chipscore = chipscore - 50000			
		elseif chipscore >= 20000 then
			strChip = "#Coin20K.png"
			chipscore = chipscore - 20000
		elseif chipscore >= 10000 then
			strChip = "#Coin10K.png"
			chipscore = chipscore - 10000
		elseif chipscore >= 5000 then
			strChip = "#Coin5K.png"
			chipscore = chipscore - 5000
		elseif chipscore >= 1000 then
			strChip = "#Coin1K.png"
			chipscore = chipscore - 1000
		elseif chipscore >= 500 then
			strChip = "#Coin500.png"
			chipscore = chipscore - 500
		elseif chipscore >= 100 then
			strChip = "#Coin100.png"
			chipscore = chipscore - 100
		elseif chipscore >= 50 then
			strChip = "#Coin50.png"
			chipscore = chipscore - 50
		elseif chipscore >= 10 then
			strChip = "#Coin10.png"
			chipscore = chipscore - 10
		elseif chipscore >= 5 then
			strChip = "#Coin5.png"
			chipscore = chipscore - 5
		elseif chipscore >= 1 then
			strChip = "#Coin1.png"
			chipscore = chipscore - 1		
		elseif chipscore >= 0.5 then
			strChip = "#Coin05.png"
			chipscore = chipscore - 0.5				
		else
			strChip = "#Coin01.png"
			chipscore = chipscore - 0.1	
		end

		self.m_personchip[wViewChairId][nIndex]= display.newSprite(strChip)
			:setScale(1.0)
			:addTo(self.nodeChipPool)

--[[		cc.Label:createWithTTF(strScore, "base/fonts/round_body.ttf", 20)
			:move(50, 60)
			:setColor(cc.c3b(48, 48, 48))
			:addTo(self.m_personchip[wViewChairId][nIndex])--]]
		if notani == true then
			if wViewChairId < 4 then	
				self.m_personchip[wViewChairId][nIndex]:move( cc.p(600+ math.random(200), 310 + math.random(120)))
			elseif wViewChairId > 4 then
				self.m_personchip[wViewChairId][nIndex]:move(cc.p(600+ math.random(200), 310 + math.random(120)))
			else
				self.m_personchip[wViewChairId][nIndex]:move(cc.p(600+ math.random(200), 310 + math.random(120)))
			end
		else
			self.m_personchip[wViewChairId][nIndex]:move(ptCoin[wViewChairId].x,  ptCoin[wViewChairId].y)
			if wViewChairId < 4 then	
				self.m_personchip[wViewChairId][nIndex]:runAction(cc.MoveTo:create(0.2, cc.p(600+ math.random(200), 310 + math.random(120))))
			elseif wViewChairId > 4 then
				self.m_personchip[wViewChairId][nIndex]:runAction(cc.MoveTo:create(0.2, cc.p(600+ math.random(200), 310 + math.random(120))))
			else
				self.m_personchip[wViewChairId][nIndex]:runAction(cc.MoveTo:create(0.2, cc.p(600+ math.random(200), 310 + math.random(120))))
			end
		end
		
		nIndex = nIndex+1
	end
	if not notani then
		--self._scene:PlaySound(cmd.RES.."sound_res/ADD_SCORE.wav")
		ExternalFun.playSoundEffect("ADD_SCORE.mp3")
	end
end

--停止比牌动画
function GameViewLayer:StopCompareCard()
	self.m_CompareView:setVisible(false)
	self.m_CompareView:StopCompareCard()
end

--比牌
function GameViewLayer:CompareCard(firstuser,seconduser,firstcard,secondcard,bfirstwin,callback)
	self.m_CompareView:setVisible(true)
	self.m_CompareView:CompareCard(firstuser,seconduser,firstcard,secondcard,bfirstwin,callback)
end

--底注显示
function GameViewLayer:SetCellScore(cellscore)
	self.m_lCellScore = cellscore
	if not cellscore then
		--self.txt_CellScore:setString("0")
		self.m_txtCellScore:setString("0")
		for i = 1, 3 do
			self.btChip[i]:getChildByTag(GameViewLayer.CHIPNUM):setString("")
		end
	else
		self.m_txtCellScore:setString(cellscore)
		for i = 1, 4 do
			if cellscore*self.nChip[i]>0 and cellscore*self.nChip[i] < 1000 then
				self.btChip[i].ChipAtlas:setString(cellscore*self.nChip[i])
				self.btChip[i].ChipAtlas:setVisible(true)	
				self.btChip[i].k:setVisible(false)
				self.btChip[i].w:setVisible(false)	
			elseif cellscore*self.nChip[i]>=1000 and  cellscore*self.nChip[i] < 10000 then
				self.btChip[i].ChipAtlas:setString((cellscore*self.nChip[i])/1000)
				self.btChip[i].ChipAtlas:setVisible(true)	
				self.btChip[i].k:setVisible(true)
				self.btChip[i].w:setVisible(false)				
			elseif cellscore*self.nChip[i]>=10000 then
				self.btChip[i].ChipAtlas:setString((cellscore*self.nChip[i])/10000)
				self.btChip[i].ChipAtlas:setVisible(true)	
				self.btChip[i].k:setVisible(false)
				self.btChip[i].w:setVisible(true)	
			end
			
			--self.btChip[i]:getChildByTag(GameViewLayer.CHIPNUM):setString(cellscore*self.nChip[i])
		end
	end
end

--封顶分数
function GameViewLayer:SetMaxCellScore(cellscore)
	if not cellscore then
		self.txt_MaxCellScore:setString("")
	else
		self.txt_MaxCellScore:setString(""..cellscore)
	end
end

--庄家显示
function GameViewLayer:SetBanker(viewid)
	if not viewid or viewid == yl.INVALID_CHAIR then
		for i = 1, cmd.GAME_PLAYER do
			self.m_BankerFlag[i]:setVisible(false)
		end
		return
	end

	self.m_BankerFlag[viewid]:setVisible(true)
end

--下注总额
function GameViewLayer:SetAllTableScore(score)
	if not score or score == 0 then
		self.m_AllScoreBG:setVisible(false)
	else
		self.m_txtAllScore:setString(score)
		self.m_AllScoreBG:setVisible(true)
	end
	
end

--当前轮次，总轮数
function GameViewLayer:SetRounds(score,current,total)
	if not score or score == 0 then
		self.m_AllScoreBG:setVisible(false)
	else
		--self.m_txtRounds:setString("第"..current.."/"..total.."轮")
		self.m_txtRounds:setString(string.format("第 %d/%d 轮", current,total))
		self.m_AllScoreBG:setVisible(true)
	end
end

--玩家下注
function GameViewLayer:SetUserTableScore(viewid, score)
	--增加桌上下注金币
	if not score or score == 0 then
		--if viewid ~= cmd.MY_VIEWID then
			self.m_ScoreView[viewid].frame:setVisible(false)
		--end
		self.m_ScoreView[viewid].score:setVisible(false)
		self.m_ScoreView[viewid].logo:setVisible(false)
	else
		--if viewid ~= cmd.MY_VIEWID then
			self.m_ScoreView[viewid].frame:setVisible(true)
		--end
		self.m_ScoreView[viewid].score:setVisible(true)
		self.m_ScoreView[viewid].score:setString(string.formatNumberFhousands(score))
		self.m_ScoreView[viewid].logo:setVisible(true)
	end
end

function GameViewLayer:preloadUI()
	for i = 1, #AnimationRes do
		local animation = cc.Animation:create()
		animation:setDelayPerUnit(AnimationRes[i].fInterval)
		animation:setLoops(AnimationRes[i].nLoops)

		for j = 1, AnimationRes[i].nCount do
			local strFile = AnimationRes[i].file..string.format("%d.png", j)
			animation:addSpriteFrameWithFile(strFile)
		end

		cc.AnimationCache:getInstance():addAnimation(animation, AnimationRes[i].name)
	end
end

function GameViewLayer:getAnimate(name, bEndRemove)
	local animation = cc.AnimationCache:getInstance():getAnimation(name)
	local animate = cc.Animate:create(animation)

	if bEndRemove then
		animate = cc.Sequence:create(animate, cc.CallFunc:create(function(ref)
			ref:removeFromParent()
		end))
	end

	return animate
end

--运行输赢动画
function GameViewLayer:runWinLoseAnimate(viewid, score,winnertype)
	local strAnimate
	local strSymbol
	local strNum

	local bkScore = string.format("%.2f",score)
	local scorelen = string.len(bkScore)
	if(scorelen > 10 ) then
		score = 0
	end	
	
	if score > 0 then
		strAnimate = "yellow"
		strSymbol = "#jia.png"
		strNum = cmd.RES.."num_add.png"
	else
		score = -score
		strAnimate = "blue"
		strSymbol = "#jian.png"
		strNum = cmd.RES.."num_reduce.png"
	end

	--加减
	self.GameScoreNum[viewid] = cc.Node:create()
		:move(ptWinLoseAnimate[viewid])
		:setAnchorPoint(cc.p(0.5, 0.5))
		:setOpacity(0)
		:setCascadeOpacityEnabled(true)
		:addTo(self, 4)

	local spriteSymbol = display.newSprite(strSymbol)		--符号
		:addTo(self.GameScoreNum[viewid])
	local sizeSymbol = spriteSymbol:getContentSize()
	if strAnimate == "yellow" then
		spriteSymbol:move(sizeSymbol.width/2, sizeSymbol.height/2 + 5)
	else
		spriteSymbol:move(sizeSymbol.width/2, sizeSymbol.height/2 + 5)
	end
	
	local labAtNum = cc.LabelAtlas:_create(bkScore, strNum, 22, 30, string.byte("."))		--数字
		:setAnchorPoint(cc.p(0.5, 0.5))
		:addTo(self.GameScoreNum[viewid])
	local sizeNum = labAtNum:getContentSize()
	labAtNum:move(sizeSymbol.width + sizeNum.width/2, sizeNum.height/2)

	self.GameScoreNum[viewid]:setContentSize(sizeSymbol.width + sizeNum.width, sizeSymbol.height)

	--底部动画
	local nTime = 1.0
--[[	local spriteAnimate = display.newSprite()
		:move(ptWinLoseAnimate[viewid])
		:addTo(self, 3)
	spriteAnimate:runAction(cc.Sequence:create(
		cc.Spawn:create(
			cc.MoveBy:create(nTime, cc.p(0, 110)),
			self:getAnimate(strAnimate)
		),
		cc.DelayTime:create(0.1),
		cc.CallFunc:create(function(ref)
			ref:removeFromParent()
			if winnertype then
				if winnertype == 4 then
					self.m_csbAniTonghua:setVisible(true)
					self.m_AniTonghua:play("AniTonghua", false)
					self.m_csbAniTonghua:setVisible(true)
					ExternalFun.playSoundEffect("tonghua.mp3")
					function callBack()
						self.m_csbAniTonghua:setVisible(false)
					end
					self.m_AniTonghua:setLastFrameCallFunc(callBack)
				elseif winnertype == 5 then
					self.m_csbAniTonghuashun:setVisible(true)
					self.m_AniTonghuashun:play("AniTonghuashun", false)
					self.m_csbAniTonghuashun:setVisible(true)
					ExternalFun.playSoundEffect("tonghuashun.mp3")
					function callBack()
						self.m_csbAniTonghuashun:setVisible(false)
					end
					self.m_AniTonghuashun:setLastFrameCallFunc(callBack)
				elseif winnertype == 6 then
					self.m_csbAniBaozi:setVisible(true)
					self.m_AniBaozi:play("AniBaozi", false)
					self.m_csbAniBaozi:setVisible(true)
					ExternalFun.playSoundEffect("baozi.mp3")
					function callBack()
						self.m_csbAniBaozi:setVisible(false)
					end
					self.m_AniBaozi:setLastFrameCallFunc(callBack)
				end
			end
		end)
	))--]]

	self.GameScoreNum[viewid]:runAction(cc.Sequence:create(
		cc.Spawn:create(
			cc.MoveBy:create(nTime, cc.p(0, 110)), 
			cc.FadeIn:create(nTime)
		),
		cc.DelayTime:create(1),
		cc.CallFunc:create(function(ref)
			--ref:removeFromParent()
		end)
	))
end

--运行牌型动画
function GameViewLayer:runCardTypeAnimate(viewid,winnertype)
	local strAnimate
	local strSymbol

	--底部动画
	local nTime = 1.0
	local spriteAnimate = display.newSprite()
		--:move(ptWinLoseAnimate[viewid])
		:addTo(self, 3)
	spriteAnimate:runAction(cc.Sequence:create(
		cc.DelayTime:create(0.1),
		cc.CallFunc:create(function(ref)
			ref:removeFromParent()
			if winnertype then
				if winnertype == 4 then
					self.m_csbAniTonghua:setVisible(true)
					self.m_AniTonghua:play("AniTonghua", false)
					self.m_csbAniTonghua:setVisible(true)
					ExternalFun.playSoundEffect("tonghua.mp3")
					function callBack()
						self.m_csbAniTonghua:setVisible(false)
					end
					self.m_AniTonghua:setLastFrameCallFunc(callBack)
				elseif winnertype == 5 then
					self.m_csbAniTonghuashun:setVisible(true)
					self.m_AniTonghuashun:play("AniTonghuashun", false)
					self.m_csbAniTonghuashun:setVisible(true)
					ExternalFun.playSoundEffect("tonghuashun.mp3")
					function callBack()
						self.m_csbAniTonghuashun:setVisible(false)
					end
					self.m_AniTonghuashun:setLastFrameCallFunc(callBack)
				elseif winnertype == 6 then
					self.m_csbAniBaozi:setVisible(true)
					self.m_AniBaozi:play("AniBaozi", false)
					self.m_csbAniBaozi:setVisible(true)
					ExternalFun.playSoundEffect("baozi.mp3")
					function callBack()
						self.m_csbAniBaozi:setVisible(false)
					end
					self.m_AniBaozi:setLastFrameCallFunc(callBack)
				end
			end
		end)
	))
end

--发牌
function GameViewLayer:SendCard(viewid,index,fDelay,chair,currentuser)
	if not viewid or viewid == yl.INVALID_CHAIR then
		return
	end
	local fInterval = 0.1

	local this = self
	local nodeCard = self.userCard[viewid]
	nodeCard.area:setVisible(true)

	local spriteCard = nodeCard.card[index]
	spriteCard:stopAllActions()
	spriteCard:setScale(1.0)
	spriteCard:setVisible(true)
	spriteCard:setSpriteFrame("card_back.png")
	spriteCard:move(display.cx, display.cy + 170)
	spriteCard:runAction(
		cc.Sequence:create(
		cc.DelayTime:create(fDelay),
		cc.CallFunc:create(
			function ()
				--this._scene:PlaySound(cmd.RES.."sound_res/CENTER_SEND_CARD.wav")
				ExternalFun.playSoundEffect("CENTER_SEND_CARD.mp3")
			end
			),
			cc.Spawn:create(
				cc.ScaleTo:create(0.25,viewid==cmd.MY_VIEWID and 1.5 or 0.7),
				cc.MoveTo:create(0.25, cc.p(
					ptCard[viewid].x + (viewid==cmd.MY_VIEWID and 50 or 35)*(index- 1),ptCard[viewid].y))
				),
			cc.CallFunc:create(
				function ()		
					if viewid == cmd.MY_VIEWID and index == 3 then
						self.btLookCard:setVisible(true)
						self.btLookCard:setEnabled(true)
						self.btGiveUp:setVisible(true)
						
						if self._scene.m_cheat == 1 then
								self._scene:DisPlayAllHands()
						end
						
						if currentuser == self._scene:GetMeChairID() then
							self._scene:UpdataControl()		
						end
						self._scene:SetGameClock(currentuser,cmd.IDI_USER_ADD_SCORE,cmd.TIME_USER_ADD_SCORE)
					end
				end
				)
			)
		)

end

--看牌状态
function GameViewLayer:SetLookCard(viewid , bLook)
	if viewid == cmd.MY_VIEWID then
		return
	end

	--看拍按钮显示错误
	self.m_LookCard[viewid]:setVisible(bLook)
end

--弃牌状态
function GameViewLayer:SetUserGiveUp(viewid ,bGiveup)
	local nodeCard = self.userCard[viewid]
    for i = 1, 3 do
		if nodeCard ~= nil and nodeCard.card[i] ~= nil then
			nodeCard.card[i]:setSpriteFrame("card_break.png")
			nodeCard.card[i]:setVisible(true)
		end
    end
    self.m_GiveUp[viewid]:setVisible(bGiveup)
    if bGiveup == true then
    	self:SetLookCard(viewid, false)
    end
end

--清理牌
function GameViewLayer:clearCard(viewid)
	local nodeCard = self.userCard[viewid]
	for i = 1, 3 do
		nodeCard.card[i]:setSpriteFrame("card_break.png")
		nodeCard.card[i]:setVisible(false)
	end

end

function GameViewLayer:clearDisplay(viewid)
	self.m_GiveUp[viewid]:setVisible(false)
	self.m_LookOn[viewid]:setVisible(false)
	self.m_LookCard[viewid]:setVisible(false)
	self.m_CompareLose[viewid]:setVisible(false)
	--self.m_flagReady[viewid]:setVisible(false)
end

--显示牌值
function GameViewLayer:SetUserCard(viewid, cardData)
	if not viewid or viewid == yl.INVALID_CHAIR then
		return
	end
	for i = 1, 3 do
		self.userCard[viewid].card[i]:stopAllActions()
		self.userCard[viewid].card[i]:setScale(1.5)
		if viewid ~= cmd.MY_VIEWID then
			self.userCard[viewid].card[i]:setScale(0.7)
		end
		self.userCard[viewid].card[i]:move(ptCard[viewid].x +  (viewid==cmd.MY_VIEWID and 50 or 35)*(i- 1),ptCard[viewid].y)
	end
	--纹理
	if not cardData then
		for i = 1, 3 do
			self.userCard[viewid].card[i]:setSpriteFrame("card_back.png")
			self.userCard[viewid].card[i]:setVisible(false)
		end
	else
		for i = 1, 3 do
			local spCard = self.userCard[viewid].card[i]
			if not cardData[i] or cardData[i] == 0 or cardData[i] == 0xff  then
				spCard:setSpriteFrame("card_back.png")
			else
				local strCard = string.format("card_player_%02d.png",cardData[i])
				spCard:setSpriteFrame(strCard)
			end

			local userItem = self._scene:getUserInfoByChairID(self._scene:GetMeChairID())
			if GlobalUserItem.isAntiCheatValid(userItem.dwUserID) then
				local strCard = string.format("card_player_%02d.png",cardData[i])
				spCard:setSpriteFrame(strCard)
			end
			
			
			self.userCard[viewid].card[i]:setVisible(true)
		end
	end
end

GameViewLayer.RES_CARD_TYPE = {"card_type_0.png","card_type_1.png","card_type_2.png","card_type_3.png","card_type_4.png","card_type_5.png"}
--显示牌类型
function GameViewLayer:SetUserCardType(viewid,cardtype)
	local spriteCardType = self.userCard[viewid].cardType
	if cardtype and cardtype >= 1 and cardtype <= 6 then
		spriteCardType:setSpriteFrame(GameViewLayer.RES_CARD_TYPE[cardtype])
		spriteCardType:setVisible(true)
	else
		spriteCardType:setVisible(false)
	end
end

function GameViewLayer:ActionBezierSpline(index,wWinner)
	self.m_winsize = cc.Director:getInstance():getWinSize()
	self.tamara  = display.newSprite("#chip_icon.png")
	:setPosition(cc.p(self.m_winsize.width / 2, self.m_winsize.height / 2 - 50))
	:addTo(self, 200)
	:setScale(1.5)
		
	local pos = cc.p(self.nodePlayer[wWinner]:getChildByName("Headbg"):getPositionX()
				, self.nodePlayer[wWinner]:getChildByName("Headbg"):getPositionY())
	pos = self.nodePlayer[wWinner]:convertToWorldSpace(pos)	
	
	local bezierTo1 = nil;
	if wWinner == 1  then
			local bezier2 ={
				cc.p(math.random(400,500)  ,  math.random(400,500)),
				cc.p(math.random(350,400)  ,  math.random(550,600)),
			   cc.p(pos.x ,pos.y)
			}
			  bezierTo1 = cc.BezierTo:create(0.6 , bezier2)
		elseif wWinner == 2   then
			local bezier2 ={
				cc.p(math.random(400,500)  ,  math.random(400,450)),
				cc.p(math.random(350,400)  ,  math.random(500,550)),
			   cc.p(pos.x ,pos.y)
			}
			  bezierTo1 = cc.BezierTo:create(0.6 , bezier2)
		elseif wWinner == 3   then
			local bezier2 ={
				cc.p(math.random(400,500)  ,  math.random(200,250)),
				cc.p(math.random(300,400)  ,  math.random(150,200)),
			   cc.p(pos.x ,pos.y)
			}
			  bezierTo1 = cc.BezierTo:create(0.6 , bezier2)
		elseif wWinner == 4   then
			local bezier2 ={
				cc.p(math.random(400,500)  ,  math.random(200,250)),
				cc.p(math.random(200,400)  ,  math.random(100,150)),
			   cc.p(pos.x ,pos.y)
			}
			bezierTo1 = cc.BezierTo:create(0.6 , bezier2)
		elseif wWinner == 5   then
			local bezier2 ={
				cc.p(math.random(800,900)  ,  math.random(200,250)),
				cc.p(math.random(1100,1200)  ,  math.random(150,200)),
			   cc.p(pos.x ,pos.y)
			}
			bezierTo1 = cc.BezierTo:create(0.6 , bezier2)
		elseif wWinner == 6   then
			local bezier2 ={
				cc.p(math.random(800,900)  ,  math.random(400,450)),
				cc.p(math.random(1100,1200)  ,  math.random(500,550)),
			   cc.p(pos.x ,pos.y)
			}
			bezierTo1 = cc.BezierTo:create(0.6 , bezier2)
		elseif wWinner == 7   then
			local bezier2 ={
				cc.p(math.random(800,900)  ,  math.random(400,500)),
				cc.p(math.random(1000,1100)  ,  math.random(550,600)),
			   cc.p(pos.x ,pos.y)
			}
			bezierTo1 = cc.BezierTo:create(0.6 , bezier2)
	end

	local tamarabak =  self.tamara
	if bezierTo1 ~= nil then 
			self.tamara:runAction(cc.Sequence:create(
				cc.DelayTime:create(0.1*index),
				bezierTo1,
				cc.CallFunc:create(function()
					tamarabak:removeFromParent()
				end)))
	end
	
	local children = self.nodeChipPool:getChildren()
	for k, v in pairs(children) do
		v:removeFromParent()
	end
	
end

--赢得筹码
function GameViewLayer:WinTheChip(wWinner)
	--筹码动作
	local children = self.nodeChipPool:getChildren()
	
	local pos = cc.p(self.nodePlayer[wWinner]:getChildByName("Headbg"):getPositionX()
				, self.nodePlayer[wWinner]:getChildByName("Headbg"):getPositionY())
	pos = self.nodePlayer[wWinner]:convertToWorldSpace(pos)	
	--print("winpos",wWinner,pos.x,pos.y)
	
	for k, v in pairs(children) do
		local bezierTo1 = nil;
		if wWinner == 1  then
			local bezier2 ={
				cc.p(math.random(300,400)  ,  math.random(500,600)),
				cc.p(math.random(300,400)  ,  math.random(500,600)),
			   cc.p(pos.x ,pos.y)
			}
			  bezierTo1 = cc.BezierTo:create(0.5 , bezier2)
		elseif wWinner == 2   then
			local bezier2 ={
				cc.p(math.random(300,400)  ,  math.random(500,600)),
				cc.p(math.random(300,400)  ,  math.random(500,600)),
			   cc.p(pos.x ,pos.y)
			}
			  bezierTo1 = cc.BezierTo:create(0.5 , bezier2)
		elseif wWinner == 3   then
			local bezier2 ={
				cc.p(math.random(300,400)  ,  math.random(500,600)),
				cc.p(math.random(300,400)  ,  math.random(500,600)),
			   cc.p(pos.x ,pos.y)
			}
			  bezierTo1 = cc.BezierTo:create(0.5 , bezier2)
		elseif wWinner == 4   then
			local bezier2 ={
				cc.p(math.random(300,400)  ,  math.random(500,600)),
				cc.p(math.random(300,400)  ,  math.random(500,600)),
			   cc.p(pos.x ,pos.y)
			}
			bezierTo1 = cc.BezierTo:create(0.5 , bezier2)
		elseif wWinner == 5   then
			local bezier2 ={
				cc.p(math.random(300,400)  ,  math.random(500,600)),
				cc.p(math.random(300,400)  ,  math.random(500,600)),
			   cc.p(pos.x ,pos.y)
			}
			bezierTo1 = cc.BezierTo:create(0.5 , bezier2)
		elseif wWinner == 6   then
			local bezier2 ={
				cc.p(math.random(300,400)  ,  math.random(500,600)),
				cc.p(math.random(300,400)  ,  math.random(500,600)),
			   cc.p(pos.x ,pos.y)
			}
			bezierTo1 = cc.BezierTo:create(0.5 , bezier2)
		elseif wWinner == 7   then
			local bezier2 ={
				cc.p(math.random(300,400)  ,  math.random(500,600)),
				cc.p(math.random(300,400)  ,  math.random(500,600)),
			   cc.p(pos.x ,pos.y)
			}
			bezierTo1 = cc.BezierTo:create(0.5 , bezier2)
		end
	
		v:runAction(cc.Sequence:create(cc.DelayTime:create(0.1*(#children - k)),
			--cc.MoveTo:create(0.4, cc.p(ptPlayer[wWinner].x, ptPlayer[wWinner].y )),
			 --cc.MoveTo:create(0.4, cc.p(pos.x, pos.y)),
			bezierTo1,
			cc.CallFunc:create(function(node)
				node:removeFromParent()
			end)))
			
	end
	
--[[	for k, v in pairs(children) do
		v:runAction(cc.Sequence:create(cc.DelayTime:create(0.1*(#children - k)),
			--cc.MoveTo:create(0.4, cc.p(ptPlayer[wWinner].x, ptPlayer[wWinner].y )),
			 --cc.MoveTo:create(0.4, cc.p(pos.x, pos.y)),
			bezierTo1,
			cc.CallFunc:create(function(node)
				node:removeFromParent()
			end)))
			
	end--]]
	
--[[	self.tamara:setVisible(true)
	local randindex = 1;
	for j = 1,25 do
		if randindex >1 then
			if math.random(1,10) < 7 then
				randindex = randindex - 1
			end
		end
		
		--self.tamara:setPosition(pointPlayer[animationfirst].x - 20 + math.random(1,40),pointPlayer[animationfirst].y - 20 + math.random(1,40))
		local bezierTo1 = nil;
		local bezier2 ={
				cc.p(math.random(300,400), self.m_winsize.height / 2 - 40 + math.random(1,30)),
				cc.p(math.random(300,400),  self.m_winsize.height / 2 - 45+ math.random(1,30)),
			   cc.p(pos.x - 20 + math.random(1,40),pos.y - 20 + math.random(1,40))
			}
			  bezierTo1 = cc.BezierTo:create(0.5 , bezier2)



		local tamarabak =  self.tamara
		if bezierTo1 ~= nil then 
				self.tamara:runAction(cc.Sequence:create(
					cc.DelayTime:create(0.1*randindex),
					bezierTo1,
					cc.CallFunc:create(function()
						tamarabak:removeFromParent()
					end)))
		end
	
		randindex = randindex+1
	end --]]
	

	
	
	
	
end

--清理筹码
function GameViewLayer:CleanAllJettons()
	for i = 1 ,cmd.GAME_PLAYER do
		local n = table.maxn(self.m_personchip[i])
		for j = 1,n do
			if nil ~= self.m_personchip[i][j] then
				self.m_personchip[i][j] = {}
			end
		end
		self.m_personchip[i] = {}
	end
	
	self.nodeChipPool:removeAllChildren()
end

--取消比牌选择
function GameViewLayer:SetCompareCard(bchoose,status)
	self.bCompareChoose = bchoose
    for i = 1, cmd.GAME_PLAYER do
    	if bchoose and status and status[i] then
			self.m_compareframe[i]:setVisible(true)
    	 	self.m_flagArrow[i]:setVisible(true)
    	 	self.m_flagArrow[i]:runAction(cc.RepeatForever:create(cc.Sequence:create(
    	 		cc.ScaleTo:create(0.3,1.5),
    	 		cc.ScaleTo:create(0.3,1.0)
    	 		)))
    	else
    		self.m_flagArrow[i]:stopAllActions()
    	 	self.m_flagArrow[i]:setVisible(false)
			self.m_compareframe[i]:setVisible(false)
    	end 
        
    end
end

--按键响应
function GameViewLayer:OnButtonClickedEvent(tag,ref)
	if tag == GameViewLayer.BT_EXIT then
		self._scene:onQueryExitGame()
		ExternalFun.playSoundEffect("GAME_CLICK.wav")
	elseif tag == GameViewLayer.BT_READY then
		self._scene:onStartGame(true)
	elseif tag == GameViewLayer.BT_GIVEUP then
		self._scene:onGiveUp()
	elseif tag == GameViewLayer.BT_LOOKCARD then
        print"----------------------------------------------------------------"
        print("   "..self._scene:GetMeChairID().."    "..(0.02+self.m_lCellScore))
           if self._scene.m_lTableScore[self._scene:GetMeChairID()+1] > (0.02+self.m_lCellScore) then
               self._scene:onLookCard()
           end 
	elseif tag == GameViewLayer.BT_ADDSCORE then
		--self.nodeButtomButton:setVisible(false)
		--self.m_ChipBG:setVisible(true)
		self:ShowRaiseChipMenu()
		ExternalFun.playSoundEffect("GAME_CLICK.wav")
	elseif tag == GameViewLayer.BT_COMPARE then
		self._scene:onCompareCard()
	elseif tag == GameViewLayer.BT_CARDTYPE then
		--self:OnShowIntroduce(true)
		self:ShowCardTypeMenu()
	elseif tag == GameViewLayer.BT_FOLLOWFOREVER then
		self:OnFollowOk()
	elseif tag == GameViewLayer.BT_FOLLOW then
		self._scene:addScore(0)
	elseif tag == GameViewLayer.BT_CHIP_1 then
		self._scene:addScore(1)
		self:HideRaiseMenu()
	elseif tag == GameViewLayer.BT_CHIP_2 then
		self._scene:addScore(2)
		self:HideRaiseMenu()
	elseif tag == GameViewLayer.BT_CHIP_3 then
		self._scene:addScore(5)
		self:HideRaiseMenu()
	elseif tag == GameViewLayer.BT_CHIP_4 then
		self._scene:addScore(10)
		self:HideRaiseMenu()
	elseif tag == GameViewLayer.BT_SHOWCARD then
		self._scene:onShowCard()
	elseif tag == GameViewLayer.BT_CHAT then
		self.m_GameChat:showGameChat(true)
		self:ShowMenu(false)
	elseif tag == GameViewLayer.BT_MENU then
		self:ShowMenu(not self.m_bShowMenu)
		ExternalFun.playSoundEffect("GAME_CLICK.wav")
	elseif tag == GameViewLayer.BT_CLICKBLANK then
		self:HideMenu()
	elseif tag == GameViewLayer.BT_HIDERAISE then
		self:HideRaiseMenu()	
	elseif tag == GameViewLayer.BT_HELP then
		self._scene._scene:popHelpLayer2(cmd.KIND_ID, 0)
	elseif tag == GameViewLayer.BT_SET then
		self:ShowMenu(false)
		ExternalFun.playSoundEffect("GAME_CLICK.wav")
		self._setLayer:showLayer()
	elseif tag == GameViewLayer.BT_HOW then
		--self:ShowCardTypeMenu()
		self:OnShowIntroduce(true)
		ExternalFun.playSoundEffect("GAME_CLICK.wav")
	elseif tag == GameViewLayer.BT_BANK then
		showToast(self, "该功能尚未开放，敬请期待...", 1)
	elseif tag == GameViewLayer.BT_CHANGETABLE then
		self:ChangeTable()
	end
end

function GameViewLayer:ChangeTable()
--[[	if self._scene.m_bReallyStart == 1 then
		return
	end	--]]
	
			--清理控制数据
	for i = 1,self.cbSurplusCardCount do
		if self.ControlCardImage[i] ~= nil then
			self.ControlCardImage[i]:removeFromParent()
			self.ControlCardImage[i] = nil
		end
	end
	for i = 1,52 do		
		self.ControlCardImage[i] = nil
		self.bControlCardOut[i] = false
	end
	self.cbSurplusCardCount  = 0;
		
	for i = 1, cmd.GAME_PLAYER do
		if self.m_UserHead[i] ~= nil then
			self.m_UserHead[i].Control:setVisible(false)
		end
	end
	
		
	self.Netwaititem:setVisible(false)
	self.Netwaititem_2:setVisible(false)
	self.m_bReallyStart = 0
	
	self.bCardOut = {false, false, false}
	
	self._scene.m_bStartGame = false
	
	self._scene.m_bEndState = 1
	
	ExternalFun.playSoundEffect("GAME_CLICK.wav")
	
	self._scene:KillGameClock()
	
	local customEvent = cc.EventCustom:new("RemoveChangeTable")
	--customEvent.obj = code
	cc.Director:getInstance():getEventDispatcher():dispatchEvent(customEvent)
	
	self.bdeleteuserdata = true
	if nil ~= self.m_scheduler then
		scheduler:unscheduleScriptEntry(self.m_scheduler)
		self.m_scheduler = nil
	end
	
	self:OnResetView()
	
	local MyChair = self._scene:GetMeChairID() + 1
	local viewid = self._scene:SwitchViewChairID(self._scene:GetMeChairID())
	self:clearCard(viewid)
	self:clearDisplay(viewid)
	
	self.btShowCard:setVisible(false)

	local function countDown(dt)
		if self.m_tabletimer > 0 then
			self.m_tabletimer = self.m_tabletimer - 1
			self.btChangeTable:getChildByTag(GameViewLayer.BT_TABLETIMER):setString(string.format("(%d)",self.m_tabletimer))
			if self.m_tabletimer == 0 then
				self.btChangeTable:setEnabled(true)
				print("btChangeTable:setVisible true:ChangeTable(countDown)")
				self.btChangeTable:setVisible(true)
				
				--changetable
				local userItem = self._scene:getUserInfoByChairID(self._scene:GetMeChairID())
				local PlayStatus = {}
				local Playtablescore = {}
				for i = 1,7 do
					PlayStatus[i] = self._scene.m_cbPlayStatus[i]
					Playtablescore[i] = self._scene.m_lTableScore[i]
				end
				if userItem ~= nil then
					--local viewid = self._scene:SwitchViewChairID(self._scene:GetMeChairID())
					if self._scene.m_cbPlayStatus[MyChair] == 1 and self._scene.m_lTableScore[MyChair] > 0 and userItem.cbUserStatus == yl.US_PLAYING then
						self.btChangeTable:setVisible(false)
					end
				end
				


--[[				if self._scene.m_cbGameStatus == cmd.GAME_STATUS_PLAY then
					self.btChangeTable:move(pChangeChairReady.x,pChangeChairReady.y)
					self.btReady:setVisible(false)
				elseif(self._scene.m_cbGameStatus == cmd.GAME_STATUS_FREE) then
					self.btChangeTable:move(self.m_ChangeTablepos.x,self.m_ChangeTablepos.y)
				end--]]
				
				self.m_tabletimer = 3
				self.istable = false
				self.btChangeTable:getChildByTag(GameViewLayer.BT_TABLETIMER):setVisible(false)
				if nil ~= self.m_scheduler then
					--print("stop dispatch")
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
	self.btChangeTable:setEnabled(false)
	self.btChangeTable:setVisible(true)
	print("btChangeTable:setVisible true:ChangeTable")
	self.btChangeTable:getChildByTag(GameViewLayer.BT_TABLETIMER):setVisible(true)
	self.btChangeTable:getChildByTag(GameViewLayer.BT_TABLETIMER):setString(string.format("(%d)",self.m_tabletimer))
	
	--liuyang
	if self._scene.m_cbGameStatus == cmd.GAME_STATUS_PLAY  then
		self.btChangeTable:move(pChangeChairReady.x,pChangeChairReady.y)
		self.btReady:setVisible(false)
		print("btChangeTable:move pChangeChairReady")
	elseif(self._scene.m_cbGameStatus == cmd.GAME_STATUS_FREE) then 
		self.btChangeTable:move(self.m_ChangeTablepos.x,self.m_ChangeTablepos.y)
	end
	
	if self._scene.m_cbPlayStatus[MyChair] == 1 then
		self.btReady:setVisible(false)
		self.btChangeTable:setVisible(false)
	end
	
--[[	for i = 1,cmd.GAME_PLAYER do
		self.nodePlayer[i]:setVisible(false)
		self.m_flagReady[i]:setVisible(false)
		--self.cbGender[i] = nil
		if self.m_UserHead[i].head then
			self.m_UserHead[i].head:setVisible(false)
		end
		self.nodePlayer[i]:setVisible(false)
		self.m_tabUserItem[i] = nil
	end--]]
	
	for i = 1,cmd.GAME_PLAYER do
		if self.GameScoreNum[i] ~= nil then
			self.GameScoreNum[i]:removeFromParent()
			self.GameScoreNum[i] = nil
		end
	end
	
	self:stopAllActions()
		
	self._scene:onChangeDesk()
		
end

function GameViewLayer:OnFollowOk()
	if self.m_ChkOK then
		self.chkFollowOK:setVisible(false)
	else
		self.chkFollowOK:setVisible(true)
	end
	
	ExternalFun.playSoundEffect("GAME_CLICK.wav")
	self.m_ChkOK = not self.m_ChkOK
end

function GameViewLayer:ShowMenu(bShow)	
	self.AniSetMenu = ExternalFun.loadTimeLine( "AniMenu.csb" )
	ExternalFun.SAFE_RETAIN(AniSetMenu)
	self.AniSetMenu:play("enterAni", false)	-- true循环播放

	self.m_csbAniMenu:runAction(self.AniSetMenu)
	-- 隐藏更多按钮
	self.BtMenu:setEnabled(false)
	self.BtMenu:setVisible(false)
	-- 显示其他按钮
	self.m_btnBackMore:setEnabled(true)
	self.m_btnBackMore:setVisible(true) 

end

function GameViewLayer:ShowCardTypeMenu()	
	self.AniSetMenu = ExternalFun.loadTimeLine( "AniMenu.csb" )
	ExternalFun.SAFE_RETAIN(AniSetMenu)
	self.AniSetMenu:play("cardtypeAni", false)	-- true循环播放

	self.m_csbAniMenu:runAction(self.AniSetMenu)
	-- 隐藏更多按钮
	self.BtCardType:setEnabled(false)
	self.BtCardType:setVisible(false)
	-- 显示其他按钮
	self.m_btnBackMore:setEnabled(true)
	self.m_btnBackMore:setVisible(true) 

end

function GameViewLayer:ShowRaiseChipMenu()	
	self.AniSetMenu = ExternalFun.loadTimeLine( "AniMenu.csb" )
	ExternalFun.SAFE_RETAIN(AniSetMenu)
	self.AniSetMenu:play("chipAni", false)	-- true循环播放

	self.m_csbAniMenu:runAction(self.AniSetMenu)
	
	self.m_bRaiseAni = true
--[[	-- 隐藏更多按钮
	self.BtCardType:setEnabled(false)
	self.BtCardType:setVisible(false)--]]
	-- 显示其他按钮
	self.m_btnBackMore:setEnabled(true)
	self.m_btnBackMore:setVisible(true) 

end

function GameViewLayer:HideMenu()
	if self.AniSetMenu then
		local Ani = self.AniSetMenu:clone()
		if self.BtMenu:isVisible() == false and self.BtCardType:isVisible() == true then
			local eventFrameCall = function(frame)
				local eventName = frame:getEvent()
				--动画exitani最后一帧设置事件over
				if eventName == "over" then
					-- 显示更多按钮
					self.BtMenu:setEnabled(true)
					self.BtMenu:setVisible(true)
					-- 隐藏其他按钮
					self.m_btnBackMore:setEnabled(false)
					self.m_btnBackMore:setVisible(false)
				end
			end
			
			Ani:clearFrameEventCallFunc()
			Ani:setFrameEventCallFunc(eventFrameCall)
			Ani:play("exitAni", false)	-- true循环播放

			self.m_csbAniMenu:runAction(Ani)
		end
		
		if self.BtCardType:isVisible() == false and self.BtMenu:isVisible() == true then
			-- 显示更多按钮
			self.BtCardType:setEnabled(true)
			self.BtCardType:setVisible(true)
			-- 隐藏其他按钮
			self.m_btnBackMore:setEnabled(false)
			self.m_btnBackMore:setVisible(false)
			
			Ani:play("cardtypeAniExit", false)	-- true循环播放
	
			self.m_csbAniMenu:runAction(Ani)
		end
		
		if self.m_bRaiseAni == true then
			-- 显示更多按钮
			--self.nodeButtomButton:setVisible(true)
			-- 隐藏其他按钮
			self.m_btnBackMore:setEnabled(false)
			self.m_btnBackMore:setVisible(false)
			
			Ani:play("chipAniExit", false)	-- true循环播放
	
			self.m_csbAniMenu:runAction(Ani)
		end
		
		self.m_bRaiseAni = false
	end
end

function GameViewLayer:HideRaiseMenu()
	if self.AniSetMenu then
		local Ani = self.AniSetMenu:clone()
		if self.nodeButtomButton:isVisible() == false then
			-- 隐藏其他按钮
			self.m_btnBackMore:setEnabled(false)
			self.m_btnBackMore:setVisible(false)
			
			Ani:play("chipAniExit", false)	-- true循环播放
	
			self.m_csbAniMenu:runAction(Ani)
		end
		self.m_bRaiseAni = false
	end
end

function GameViewLayer:setMenuBtnEnabled(bAble)
	self.m_AreaMenu:getChildByTag(GameViewLayer.BT_SET):setEnabled(bAble)
	self.m_AreaMenu:getChildByTag(GameViewLayer.BT_HELP):setEnabled(bAble)
	self.m_AreaMenu:getChildByTag(GameViewLayer.BT_CHAT):setEnabled(bAble)
	self.m_AreaMenu:getChildByTag(GameViewLayer.BT_EXIT):setEnabled(bAble)
end

--事件监听模板
function GameViewLayer:runAddTimesAnimate(viewid)
	local ChangeTableNode = display.newSprite("#game_flag_addscore.png")
		:move(ptAddScore[viewid])
		:setScale(viewid == cmd.MY_VIEWID and 1.3 or 1.1)
		:addTo(self)
		ChangeTableNode:runAction(cc.Sequence:create(
						cc.DelayTime:create(2),
						cc.CallFunc:create(function(ref)
							ref:removeFromParent()
						end)
						))
						

	
	--监听消息
	local listener = cc.EventListenerCustom:create("RemoveChangeTable",function (event)
		ChangeTableNode:stopAllActions()
		ChangeTableNode:removeFromParent()
	end)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, ChangeTableNode)
end

--显示聊天
function GameViewLayer:ShowUserChat(viewid ,message)
	if message and #message > 0 then
		self.m_GameChat:showGameChat(false) --设置聊天不可见，要显示私有房的邀请按钮（如果是房卡模式）
		--取消上次
		if self.m_UserChat[viewid] then
			self.m_UserChat[viewid]:stopAllActions()
			self.m_UserChat[viewid]:removeFromParent()
			self.m_UserChat[viewid] = nil
		end

		--创建label
		local limWidth = 20*12
		local labCountLength = cc.Label:createWithSystemFont(message,"Arial", 20)  
		if labCountLength:getContentSize().width > limWidth then
			self.m_UserChat[viewid] = cc.Label:createWithSystemFont(message,"Arial", 20, cc.size(limWidth, 0))
		else
			self.m_UserChat[viewid] = cc.Label:createWithSystemFont(message,"Arial", 20)
		end
		self.m_UserChat[viewid]:addTo(self)
		if viewid <= 3 then
			self.m_UserChat[viewid]:move(ptChat[viewid].x + 14 , ptChat[viewid].y + 5)
				:setAnchorPoint( cc.p(0, 0.5) )
		else
			self.m_UserChat[viewid]:move(ptChat[viewid].x - 14 , ptChat[viewid].y + 5)
				:setAnchorPoint(cc.p(1, 0.5))
		end
		--改变气泡大小
		self.m_UserChatView[viewid]:setContentSize(self.m_UserChat[viewid]:getContentSize().width+28, self.m_UserChat[viewid]:getContentSize().height + 27)
			:setVisible(true)
		--动作
		self.m_UserChat[viewid]:runAction(cc.Sequence:create(
						cc.DelayTime:create(3),
						cc.CallFunc:create(function()
							self.m_UserChatView[viewid]:setVisible(false)
							self.m_UserChat[viewid]:removeFromParent()
							self.m_UserChat[viewid]=nil
						end)
				))
	end
end

--显示表情
function GameViewLayer:ShowUserExpression(viewid,index)
	self.m_GameChat:showGameChat(false)
	--取消上次
	if self.m_UserChat[viewid] then
		self.m_UserChat[viewid]:stopAllActions()
		self.m_UserChat[viewid]:removeFromParent()
		self.m_UserChat[viewid] = nil
	end
	local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame( string.format("e(%d).png", index))
	if frame then
		self.m_UserChat[viewid] = cc.Sprite:createWithSpriteFrame(frame)
			:addTo(self)
		if viewid <= 3 then
			self.m_UserChat[viewid]:move(ptChat[viewid].x + 45 , ptChat[viewid].y + 5)
		else
			self.m_UserChat[viewid]:move(ptChat[viewid].x - 45 , ptChat[viewid].y + 5)
		end
		self.m_UserChatView[viewid]:setVisible(true)
			:setContentSize(90,65)
		self.m_UserChat[viewid]:runAction(cc.Sequence:create(
						cc.DelayTime:create(3),
						cc.CallFunc:create(function()
							self.m_UserChatView[viewid]:setVisible(false)
							self.m_UserChat[viewid]:removeFromParent()
							self.m_UserChat[viewid]=nil
						end)
				))
	end
end

--显示语音
function GameViewLayer:ShowUserVoice(viewid, isPlay)
	--取消文字，表情
	if self.m_UserChat[viewid] then
		self.m_UserChat[viewid]:stopAllActions()
		self.m_UserChat[viewid]:removeFromParent()
		self.m_UserChat[viewid] = nil
	end
	self.m_UserChatView[viewid]:stopAllActions()
	self.m_UserChatView[viewid]:removeAllChildren()
	self.m_UserChatView[viewid]:setVisible(isPlay)
	if isPlay == false then

	else
		--创建帧动画
	    -- 聊天表情
	    local sp = display.newSprite("#blank.png")
	    sp:setAnchorPoint(cc.p(0.5, 0.5))
		sp:runAction(self.m_actVoiceAni)
		sp:addTo(self.m_UserChatView[viewid])
		sp:setPosition(cc.p(45, 33))
		-- 转向
		if viewid <= 3 then
			sp:setRotation(180)
		end
	end
end

return GameViewLayer