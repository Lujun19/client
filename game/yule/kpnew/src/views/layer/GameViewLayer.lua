local GameViewLayer = class("GameViewLayer",function(scene)
		local gameViewLayer =  display.newLayer()
    return gameViewLayer
end)

require("client/src/plaza/models/yl")
local cmd = appdf.req(appdf.GAME_SRC.."yule.kpnew.src.models.CMD_Game")
local SetLayer = appdf.req(appdf.GAME_SRC.."yule.kpnew.src.views.layer.SetLayer")
local PopupInfoHead = appdf.req("client.src.external.PopupInfoHead")
local GameChatLayer = appdf.req(appdf.CLIENT_SRC.."plaza.views.layer.game.GameChatLayer")
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local AnimationMgr = appdf.req(appdf.EXTERNAL_SRC .. "AnimationMgr")
local GameLogic = appdf.req(appdf.GAME_SRC.."yule.kpnew.src.models.GameLogic")
local scheduler = cc.Director:getInstance():getScheduler()
GameViewLayer.BT_PROMPT 			= 2
GameViewLayer.BT_OPENCARD 			= 3
GameViewLayer.BT_START 				= 4
GameViewLayer.BT_CHIP 				= 7
GameViewLayer.BT_CHIP1 				= 8
GameViewLayer.BT_CHIP2 				= 9
GameViewLayer.BT_CHIP3 				= 10
GameViewLayer.BT_CHIP4 				= 11

GameViewLayer.BT_SWITCH 			= 12
GameViewLayer.BT_SET 				= 13
GameViewLayer.BT_EXIT 				= 14
GameViewLayer.BT_CHAT 				= 15
GameViewLayer.BT_HOWPLAY 			= 16

GameViewLayer.BT_TRADETABLE			= 17
GameViewLayer.BT_TABLETIMER			= 18
--GameViewLayer.BT_SOUND 				= 15
--GameViewLayer.BT_TAKEBACK 			= 16
--表示20-25已经用了。不要再用了
GameViewLayer.BT_CALLBANKER 		= 20
GameViewLayer.BT_CANCEL 			= 25

GameViewLayer.FRAME 				= 1
GameViewLayer.NICKNAME 				= 2
GameViewLayer.SCORE 				= 3
GameViewLayer.FACE 					= 7

GameViewLayer.TIMENUM   			= 1
GameViewLayer.CHIPNUM 				= 1
GameViewLayer.SCORENUM 				= 1

--牌间距
GameViewLayer.CARDSPACING 			= 35

GameViewLayer.VIEWID_CENTER 		= 5

GameViewLayer.RES_PATH 				= "game/yule/kpnew/res/"

local pointPlayer = {cc.p(380, 685), cc.p(88, 410), cc.p(590, 75), cc.p(1238, 410), cc.p(980, 685)}
local pointCard = {cc.p(457, 577), cc.p(318, 402), cc.p(667, 200), cc.p(1008, 402),cc.p(860, 577)}
local pointClock = {cc.p(1017, 640), cc.p(88, 560), cc.p(-50, 150), cc.p(1238, 560),cc.p(1017, 640)}
local pointOpenCard = {cc.p(470, 520), cc.p(160, 280), cc.p(665, 280), cc.p(1175, 280),cc.p(930, 520)}
local pointTableScore = {cc.p(577, 705), cc.p(331, 420), cc.p(220, 170), cc.p(935, 410),cc.p(707, 705)}
local pointBankerFlag = {cc.p(375 + 8, 677 + 8), cc.p(82 + 8, 407 + 8), cc.p(585 + 8 - 470, 70 + 8), cc.p(1230 + 8, 407+ 8),cc.p(975+ 8, 683+ 8)}
local pointChat = {cc.p(767, 690), cc.p(160, 525), cc.p(230, 250), cc.p(1173, 525),cc.p(767, 690)}
local pointUserInfo = {cc.p(350, 555), cc.p(88, 410), cc.p(590, 75), cc.p(838, 410),cc.p(620, 555)}
local pointmultiple = {cc.p(627, 675), cc.p(338, 395), cc.p(220, 170), cc.p(985, 395),cc.p(727, 675)}
local anchorPoint = {cc.p(0, 1), cc.p(0, 0), cc.p(0, 0), cc.p(1, 0),cc.p(1, 1)}

local AnimationRes = 
{
	--{name = "banker", file = GameViewLayer.RES_PATH.."animation_banker/banker_", nCount = 11, fInterval = 0.2, nLoops = 1},
	--{name = "faceFlash", file = GameViewLayer.RES_PATH.."animation_faceFlash/faceFlash_", nCount = 2, fInterval = 0.6, nLoops = 3},
	--{name = "lose", file = GameViewLayer.RES_PATH.."animation_lose/lose_", nCount = 17, fInterval = 0.1, nLoops = 1},
	--{name = "start", file = GameViewLayer.RES_PATH.."animation_start/start_", nCount = 11, fInterval = 0.15, nLoops = 1},
	--{name = "victory", file = GameViewLayer.RES_PATH.."animation_victory/victory_", nCount = 17, fInterval = 0.13, nLoops = 1},
	{name = "yellow", file = GameViewLayer.RES_PATH.."animation_yellow/yellow_", nCount = 5, fInterval = 0.2, nLoops = 1},
	{name = "blue", file = GameViewLayer.RES_PATH.."animation_blue/blue_", nCount = 5, fInterval = 0.2, nLoops = 1}
}

function GameViewLayer:onInitData()
	self.bCardOut = {false, false, false, false, false}
	self.lUserMaxScore = {0, 0, 0, 0}
	self.chatDetails = {}
	self.bCanMoveCard = false
	self.cbGender = {}
	self.bBtnInOutside = false
	self.bBtnMoving = false
end

function GameViewLayer:onExit()
	print("GameViewLayer onExit")
	cc.Director:getInstance():getTextureCache():removeTextureForKey("card.png")
	cc.SpriteFrameCache:getInstance():removeSpriteFramesFromFile("gameScene_oxnew.plist")
	cc.Director:getInstance():getTextureCache():removeTextureForKey("gameScene_oxnew.png")
    cc.Director:getInstance():getTextureCache():removeUnusedTextures()
    cc.SpriteFrameCache:getInstance():removeUnusedSpriteFrames()
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
    AnimationMgr.removeCachedAnimation(cmd.VOICE_ANIMATION_KEY)
	
	    --播放大厅背景音乐
    ExternalFun.playPlazzBackgroudAudio()
end

local this



function GameViewLayer:ctor(scene)
	this = self
	self._scene = scene
	self:onInitData()
	self:preloadUI()
	self._setLayer = SetLayer:create(self):addTo(self, 3)

	--节点事件
	local function onNodeEvent(event)
		if event == "exit" then
			self:onExit()
		end
	end
	self:registerScriptHandler(onNodeEvent)

	display.newSprite(GameViewLayer.RES_PATH.."game/background.png")
		:move(display.center)
		:addTo(self)
	display.newSprite(GameViewLayer.RES_PATH.."game/table.png")
		:move(display.center.x,display.center.y)
		:addTo(self)
    display.newSprite(GameViewLayer.RES_PATH.."game/logo.png")
		:move(display.center.x,display.center.y + 130)
		:addTo(self)
	self._csbNode = cc.CSLoader:createNode(GameViewLayer.RES_PATH.."game/GameScene.csb")
		:addTo(self, 1)

--	self._csbcardType = cc.CSLoader:createNode(GameViewLayer.RES_PATH.."game/anim_DN_cardType.csb")
--        :setVisible(false)
--		:addTo(self, 1)

	--self._csbstart = cc.CSLoader:createNode(GameViewLayer.RES_PATH.."game/anim_DN_start.csb")
        --:setVisible(false)
		--:addTo(self, 1)



	local  btcallback = function(ref, type)
        if type == ccui.TouchEventType.ended then
         	this:onButtonClickedEvent(ref:getTag(),ref)
        end
    end

    --特殊按钮
	self.spButtonBg = self._csbNode:getChildByName("sp_buttonBg"):setScaleY(0.4)
	self.spButtonBg:setVisible(false)
    --:setGlobalZOrder(1110)
	self.btSwitch = self._csbNode:getChildByName("bt_switch")
		:setTag(GameViewLayer.BT_SWITCH)
	self.btSwitch:addTouchEventListener(btcallback)

	local posSwitchX, posSwitchY = self.spButtonBg:getPosition()
	local posSwitch = cc.p(posSwitchX, posSwitchY + 50)

	self.btSet = self._csbNode:getChildByName("bt_set")
		:setTag(GameViewLayer.BT_SET)
		:setPosition(posSwitch.x,posSwitch.y - 10)
		:setTouchEnabled(false)
	self.btSet:addTouchEventListener(btcallback)

    self.btExit = self._csbNode:getChildByName("bt_exit")
		:setTag(GameViewLayer.BT_EXIT)
		:setPosition(posSwitch)
		:setTouchEnabled(false)
	self.btExit:addTouchEventListener(btcallback)

	self.btChat = self._csbNode:getChildByName("bt_chat")
		:setTag(GameViewLayer.BT_CHAT)
--		:setPosition(posSwitch)
--		:setTouchEnabled(false)
        :setVisible(false)
	self.btChat:addTouchEventListener(btcallback)

	self.btHowPlay = self._csbNode:getChildByName("bt_howPlay")
		:setTag(GameViewLayer.BT_HOWPLAY)
--		:setPosition(posSwitch)
--		:setTouchEnabled(false)
	self.btHowPlay:addTouchEventListener(btcallback)



	--普通按钮
	self.btPrompt = self._csbNode:getChildByName("bt_prompt")
		:move(yl.WIDTH - 163, 60)
		:setTag(GameViewLayer.BT_PROMPT)
		:setVisible(false)
	self.btPrompt:addTouchEventListener(btcallback)

	self.btOpenCard = self._csbNode:getChildByName("bt_showCard")
		:move(yl.WIDTH - 163, 112)
		:setTag(GameViewLayer.BT_OPENCARD)
		:setVisible(false)
	self.btOpenCard:addTouchEventListener(btcallback)

	self.btTable = self._csbNode:getChildByName("bt_table_0")
		:move(yl.WIDTH - 163, 52)
		:setVisible(false)
		:setTag(GameViewLayer.BT_TRADETABLE)
	self.btTable:addTouchEventListener(btcallback)
	cc.Label:createWithTTF("(3s)","base/fonts/round_body.ttf",18)
		:move(self.btTable:getContentSize().width/2 + 50, self.btTable:getContentSize().height/2 + 5)
		:setVisible(false)
		:setTag(GameViewLayer.BT_TABLETIMER)
		:setColor(cc.c3b(242, 199, 89))
		:addTo(self.btTable)
    self.btStart = self._csbNode:getChildByName("bt_start")
		:move(yl.WIDTH - 163, 142)
		:setVisible(false)
		:setTag(GameViewLayer.BT_START)
	self.btStart:addTouchEventListener(btcallback)

	--叫庄按钮
	self.btCallBanker = {}
	for i = 1, 5 do
		local frame = string.format("bt_callBanker_%d", i)
		self.btCallBanker[i] = self._csbNode:getChildByName(frame)
		:setTag(GameViewLayer.BT_CALLBANKER + i)
		:setVisible(false)
		self.btCallBanker[i]:addTouchEventListener(btcallback)
	end
--[[	self.btCallBanker = self._csbNode:getChildByName("bt_callBanker")
		:move(display.cx - 150, 300)
		:setTag(GameViewLayer.BT_CALLBANKER)
		:setVisible(false)
	self.btCallBanker:addTouchEventListener(btcallback)

	self.btCancel = self._csbNode:getChildByName("bt_cancel")
		:move(display.cx + 150, 300)
		:setTag(GameViewLayer.BT_CANCEL)
		:setVisible(false)
	self.btCancel:addTouchEventListener(btcallback)--]]

	--四个下注的筹码按钮
	self.btChip = {}
	for i = 1, 4 do
		self.btChip[i] = ccui.Button:create("bt_chip_0.png", "bt_chip_1.png", "", ccui.TextureResType.plistType)
			:move(450 + 165*(i - 1), 293)
			:setTag(GameViewLayer.BT_CHIP + i)
			:setVisible(false)
			:addTo(self)
		self.btChip[i]:addTouchEventListener(btcallback)
		cc.LabelAtlas:_create("123456", GameViewLayer.RES_PATH.."num_chip.png", 17, 24, string.byte("."))
			:move(self.btChip[i]:getContentSize().width/2, self.btChip[i]:getContentSize().height/2 + 5)
			:setAnchorPoint(cc.p(0.5, 0.5))
			:setTag(GameViewLayer.CHIPNUM)
			:addTo(self.btChip[i])
	end

	self.txt_CellScore = cc.Label:createWithTTF("底注：250","base/fonts/round_body.ttf",24)                        
		:move(display.center.x,display.center.y + 50)
		:setVisible(false)
		:addTo(self)
	self.txt_TableID = cc.Label:createWithTTF("桌号：38","base/fonts/round_body.ttf",24)
		:move(333, yl.HEIGHT-20)
		:setVisible(false)
		:addTo(self)
    	--牌提示背景
	self.chip_frame = display.newSprite("#chip_frame.png")
		:move(display.center.x,display.center.y + 50)
		:setVisible(false)
		:addTo(self)

	--牌提示背景
	self.spritePrompt = display.newSprite("#prompt.png")
		:move(display.cx, display.cy - 80)
		:setVisible(false)
		:addTo(self)
	--牌值
	self.labAtCardPrompt = {}
	for i = 1, 4 do
		self.labAtCardPrompt[i] = cc.LabelAtlas:_create("", GameViewLayer.RES_PATH.."num_prompt.png", 39, 38, string.byte("0"))
			:move(60 + 93*(i - 1), 55)
			:setAnchorPoint(cc.p(0.5, 0.5))
			:addTo(self.spritePrompt)
	end
	self.labCardType = cc.Label:createWithTTF("", "base/fonts/round_body.ttf", 34)
		:move(430, 55)
		:addTo(self.spritePrompt)

	--时钟
	self.spriteClock = display.newSprite("#sprite_clock.png")
		self.spriteClock:move(pointClock[cmd.MY_VIEWID].x + 180 ,pointClock[cmd.MY_VIEWID].y +50 )
		:setVisible(false)
		:addTo(self)
	local labAtTime = cc.LabelAtlas:_create("", GameViewLayer.RES_PATH.."num_time.png", 42, 39, string.byte("0"))
		:move(self.spriteClock:getContentSize().width/2, self.spriteClock:getContentSize().height/2)
		:setAnchorPoint(cc.p(0.5, 0.5))
		:setScale(0.7)
		:setTag(GameViewLayer.TIMENUM)
		:addTo(self.spriteClock)
	--用于发牌动作的那张牌
	self.animateCard = display.newSprite(GameViewLayer.RES_PATH.."card.png")
		:move(display.center)
		:setVisible(false)
		:setLocalZOrder(2)
		:addTo(self)
	local cardWidth = self.animateCard:getContentSize().width/13
	local cardHeight = self.animateCard:getContentSize().height/5
	self.animateCard:setTextureRect(cc.rect(cardWidth*2, cardHeight*4, cardWidth, cardHeight))

	--五个玩家
	self.nodePlayer = {}
	for i = 1 ,cmd.GAME_PLAYER do
		--玩家结点
		self.nodePlayer[i] = cc.Node:create()
			:move(pointPlayer[i])
			:setVisible(false)
			:addTo(self,2)
		--人物框
		local spriteFrame = display.newSprite("#oxnew_frame.png")
			:setTag(GameViewLayer.FRAME)
			:addTo(self.nodePlayer[i],1)
        if i == 4 or i == 5 then
            local right_head_score_bg = display.newSprite("#right_head_score_bg.png")
            :move(-107, 0)
		    :setTag(GameViewLayer.FRAME)
		    :addTo(self.nodePlayer[i])

            local money_icon = display.newSprite("#money_icon.png")
            :move(-175, -25)
		    :setTag(GameViewLayer.FRAME)
		    :addTo(self.nodePlayer[i])
			
			local ID = display.newSprite("#ID.png")
			:setScale(0.8)
            :move(-175, 5)
		    :setTag(GameViewLayer.FRAME)
		    :addTo(self.nodePlayer[i])
			
			
            		--昵称
		self.nicknameConfig = string.getConfig("base/fonts/round_body.ttf", 26)
		cc.Label:createWithTTF("568422", "base/fonts/round_body.ttf", 26)
			:move(-115, 5)
			:setScaleX(0.8)
			:setColor(cc.c3b(255, 255, 255))
			:setTag(GameViewLayer.NICKNAME)
			:addTo(self.nodePlayer[i])
		--金币
		cc.Label:createWithTTF("(3s)","base/fonts/round_body.ttf",22)
			:move(-117, -25)
			:setAnchorPoint(cc.p(0.5, 0.5))
			:setTag(GameViewLayer.SCORE)
			:addTo(self.nodePlayer[i])
        else
            local left_head_score_bg = display.newSprite("#left_head_score_bg.png")
            :move(107, 0)
		    :setTag(GameViewLayer.FRAME)
		    :addTo(self.nodePlayer[i])

            local money_icon = display.newSprite("#money_icon.png")
            :move(60, -25)
		    :setTag(GameViewLayer.FRAME)
		    :addTo(self.nodePlayer[i])
			
			
			local ID = display.newSprite("#ID.png")
			:setScale(0.8)
            :move(65, 5)
		    :setTag(GameViewLayer.FRAME)
		    :addTo(self.nodePlayer[i])
            		--昵称
		    self.nicknameConfig = string.getConfig("base/fonts/round_body.ttf", 26)
		    cc.Label:createWithTTF("568422", "base/fonts/round_body.ttf", 26)
			:move(125, 5)
			:setScaleX(0.8)
			:setColor(cc.c3b(255, 255, 255))
			:setTag(GameViewLayer.NICKNAME)
			:addTo(self.nodePlayer[i])
		--金币
		    cc.Label:createWithTTF("(3s)","base/fonts/round_body.ttf",22)
			:move(120, -25)
			:setAnchorPoint(cc.p(0.5, 0.5))
			:setTag(GameViewLayer.SCORE)
			:addTo(self.nodePlayer[i])
        end


	end

	--自己方牌框
--	self.cardFrame = {}
--	for i = 1, 5 do
--		self.cardFrame[i] = ccui.CheckBox:create("cardFrame_0.png",
--												"cardFrame_1.png",
--												"cardFrame_0.png",
--												"cardFrame_0.png",
--												"cardFrame_0.png", ccui.TextureResType.plistType)
--			:move(335 + 166*(i - 1), 110)
--			:setTouchEnabled(false)
--			:setVisible(false)
--			:addTo(self)
--	end
    --自己牌数据
    self.cbMyCardData = {}
	--牌节点
	self.nodeCard = {}
    self.MynodeCard = {}
	--牌的类型
	self.cardType = {}
	--桌面金币
	self.tableScore = {}
	--准备标志
	self.flag_ready = {}
	--摊牌标志
	--self.flag_openCard = {}
    self.tableUserAddScore = {}

    self._csbheadWin = {}
     self._csbheadWinNode = {}
	for i = 1, cmd.GAME_PLAYER do
--		--牌
--		self.nodeCard[i] = cc.Node:create()
--			:move(pointCard[i])
--			:setAnchorPoint(cc.p(0.5, 0.5))
--			:addTo(self)
--		for j = 1, 5 do
--			local card = display.newSprite(GameViewLayer.RES_PATH.."card.png")
--				:setTag(j)
--				:setVisible(false)
--				:setTextureRect(cc.rect(cardWidth*2, cardHeight*4, cardWidth, cardHeight))
--				:addTo(self.nodeCard[i])
--		end
        self.nodeCard[i] = {}
		for j = 1, 5 do
            local frame = string.format("Image_%d_%d", i,j)
	        self.nodeCard[i][j] = self._csbNode:getChildByName(frame)
            :setTag(j)
            :setVisible(false)
        end

        if i == 3 then
            for k = 1, 5 do
                local frame = string.format("Image_%d_%d_0", i,k)
	            self.MynodeCard[k] = self._csbNode:getChildByName(frame)
                :setTag(k)
                :setVisible(false)
            end
        end
		--牌型
--		self.cardType[i] = display.newSprite("#ox_10.png")
--			:move(pointOpenCard[i])
--			:setVisible(false)
--			:addTo(self)
		--桌面金币
         self.tableScore[i] = {}

         self._csbheadWinNode[i] = cc.CSLoader:createNode(GameViewLayer.RES_PATH.."anim_DN_headWin.csb")
		 :addTo(self, 1)
         self._csbheadWin[i] = ExternalFun.loadTimeLine(GameViewLayer.RES_PATH.."anim_DN_headWin.csb")
	     self._csbheadWin[i]:retain()
         self._csbheadWinNode[i]:runAction(self._csbheadWin[i])
         self._csbheadWinNode[i]:move(pointPlayer[i])
         self._csbheadWinNode[i]:setVisible(false)

--        for j = 1, 14 do
--            self.tableScore[i][j] = display.newSprite(string.format("#%d.png", i))
--			:move(pointTableScore[i])
--			:setVisible(false)
--			:addTo(self,j)
--        end

		    self.tableUserAddScore[i] = cc.LabelAtlas:_create("1008611", GameViewLayer.RES_PATH.."num_chipScore.png", 20, 28, string.byte("."))
			:move(pointTableScore[i].x + 40,pointTableScore[i].y - 50)
			:setAnchorPoint(cc.p(0.5, 0.5))
			:setTag(GameViewLayer.SCORENUM)
            :setVisible(false)
			:addTo(self)
		--准备
		self.flag_ready[i] = display.newSprite("#sprite_prompt.png")
			:move(pointCard[i])
			:setVisible(false)
			:addTo(self)
		--摊牌
--		self.flag_openCard[i] = display.newSprite("#sprite_openCard.png")
--			:move(pointOpenCard[i])
--			:setVisible(false)
--			:addTo(self)
	end
    --开始动画
    self._csbGameStart = cc.CSLoader:createNode(GameViewLayer.RES_PATH.."anim_DN_start.csb")
	:addTo(self, 1)
    self._csbstart = ExternalFun.loadTimeLine(GameViewLayer.RES_PATH.."anim_DN_start.csb")
	self._csbstart:retain()
    self._csbGameStart:runAction(self._csbstart)
    self._csbGameStart:move(self._csbGameStart:getPositionX() + 660,self._csbGameStart:getPositionY() + 400)
    self._csbGameStart:setVisible(false)
    --玩家牌型
    self._csbcardType = {}
    self._csbUsercardType = {}

    self._csbcardTypeTure = {}
    self._csbcard_finish = {}

    for i = 1 ,cmd.GAME_PLAYER do
         self._csbcardType[i] = cc.CSLoader:createNode(GameViewLayer.RES_PATH.."anim_DN_cardType.csb")
		 :addTo(self, 1)
         self._csbUsercardType[i] = ExternalFun.loadTimeLine(GameViewLayer.RES_PATH.."anim_DN_cardType.csb")
	     self._csbUsercardType[i]:retain()
         self._csbcardType[i]:runAction(self._csbUsercardType[i])
         self._csbcardType[i]:move(pointOpenCard[i])
         self._csbcardType[i]:setVisible(false)

         self._csbcardTypeTure[i] = cc.CSLoader:createNode(GameViewLayer.RES_PATH.."anim_DN_cardTypeTure.csb")
		 :addTo(self, 1)
         self._csbcard_finish[i] = ExternalFun.loadTimeLine(GameViewLayer.RES_PATH.."anim_DN_cardTypeTure.csb")
	     self._csbcard_finish[i]:retain()
         self._csbcardTypeTure[i]:runAction(self._csbcard_finish[i])
         self._csbcardTypeTure[i]:move(pointOpenCard[i])
         self._csbcardTypeTure[i]:setVisible(false)

    end
    --选庄动画
    self._csbNodebank = cc.CSLoader:createNode(GameViewLayer.RES_PATH.."anim_DN_bank.csb")
	:addTo(self, 1)
    self._csbbank = ExternalFun.loadTimeLine(GameViewLayer.RES_PATH.."anim_DN_bank.csb")
	self._csbbank:retain()
    self._csbNodebank:runAction(self._csbbank)
    --self._csbNodebank:move(pointBankerFlag[4])
    self._csbNodebank:setVisible(false)
    --选庄动画
    self._csbNodebankTop = cc.CSLoader:createNode(GameViewLayer.RES_PATH.."anim_DN_bankTop.csb")
	:addTo(self, 3)
    self._csbbankTop = ExternalFun.loadTimeLine(GameViewLayer.RES_PATH.."anim_DN_bankTop.csb")
	self._csbbankTop:retain()
    self._csbNodebankTop:runAction(self._csbbankTop)
    --self._csbNodebank:move(pointBankerFlag[4])
    self._csbNodebankTop:setVisible(false)

	self.nodeLeaveCard = cc.Node:create():addTo(self)

	self.spriteBankerFlag = display.newSprite()
		:setVisible(false)
		:setLocalZOrder(2)
		:addTo(self)

	--聊天框
    self._chatLayer = GameChatLayer:create(self._scene._gameFrame)
    self._chatLayer:addTo(self, 50)
	--聊天泡泡
	self.chatBubble = {}
	for i = 1 , cmd.GAME_PLAYER do
		if i == 2 or i == 3 then
			self.chatBubble[i] = display.newSprite(GameViewLayer.RES_PATH.."game_chat_lbg.png"	,{scale9 = true ,capInsets=cc.rect(0, 0, 180, 110)})
				:setAnchorPoint(cc.p(0,0.5))
				:move(pointChat[i])
				:setVisible(false)
				:addTo(self, 2)
		else
			self.chatBubble[i] = display.newSprite(GameViewLayer.RES_PATH.."game_chat_rbg.png",{scale9 = true ,capInsets=cc.rect(0, 0, 180, 110)})
				:setAnchorPoint(cc.p(1,0.5))
				:move(pointChat[i])
				:setVisible(false)
				:addTo(self, 2)
		end
	end

	self.GameScoreNum = {}
	self.multiple = {}
	self.multiplecount = {}
	for i = 1,cmd.GAME_PLAYER do 
		self.GameScoreNum[i] = nil
		self.multiple[i] = nil
		self.multiplecount[i]=nil
	end
		
    self._csbGameRuleLayer = cc.CSLoader:createNode(GameViewLayer.RES_PATH.."game/GameRuleLayer.csb")
    :setVisible(false)
    :move( - 500,0)
	:addTo(self, 100)
    self.bGameRuleLayer = false;
	
	
--[[self.multipleoo = {} 
	for i = 1,cmd.GAME_PLAYER do
		self.multipleoo[i] = display.newSprite(string.format("#multiple_%d.png", 1))
		:move(pointmultiple[i].x ,pointmultiple[i].y)
		:addTo(self)
	end--]]
	
	--点击事件
	self:setTouchEnabled(true)
	self:registerScriptTouchHandler(function(eventType, x, y)
		return self:onEventTouchCallback(eventType, x, y)
	end)
    self.lTableScore = {}
    --底分
    self.lCellScore = 0
	-- 玩家头像
	self.m_bNormalState = {}
	--房卡需要
	self.m_tabUserItem = {}
	--语音按钮 gameviewlayer -> gamelayer -> clientscene
--    self._scene._scene:createVoiceBtn(cc.p(1150, 230), 0, self)
    --选择庄动画圈数
    self.randIndex = 0

    self.wFisrtChooseCallUser = 1

    self.randIndexbak = -1
	self.iMaxTimes = {}
    self.wFisrtChooseCallUserBak = 1

    self.tableScoreImage = {400000,200000,100000,50000,20000,10000,5000,1000,500,100,50,10,5,1,0.5,0.1}
    self.tableScoreIndex = {16,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1}
    -- 语音动画
    AnimationMgr.loadAnimationFromFrame("record_play_ani_%d.png", 1, 3, cmd.VOICE_ANIMATION_KEY)
	self.istable = false;
	self.m_scheduler = nil
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
					if self._scene._gameFrame._UserList[userItem.dwUserID].wTableID ~= MyTable 
						or self._scene._gameFrame._UserList[userItem.dwUserID].wChairID ~= self.m_tabUserItem[j].wChairID
						or j ~= self._scene:SwitchViewChairID(self._scene._gameFrame._UserList[userItem.dwUserID].wChairID) then
						local head = self.nodePlayer[j]:getChildByTag(GameViewLayer.FACE)
						self.nodePlayer[j]:setVisible(false)
						self.flag_ready[j]:setVisible(false)
						self.cbGender[j] = nil
						if head then
							head:setVisible(false)
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
	
		self.Alltamara = {}
	self.AlltamaraCount = 1
end
function GameViewLayer:onUpdataControlResult(nMyIndex,i,card_index)
	 self.nodeCard[nMyIndex][i]:loadTexture("card/pocker_big/"..string.format("card_%d.png",card_index))
end
function GameViewLayer:onControl()
	
	self.ControlCardData = GameLogic:SortCardList(self.ControlCardData, self.cbSurplusCardCount, 0)
	
	for i = 1,self.cbSurplusCardCount do
		local card_index = GameLogic:GetCardLogicValueToInt(self.ControlCardData[i]);
		
		if i < self.cbSurplusCardCount/2 then
			self.ControlCardImage[i] = display.newSprite(GameViewLayer.RES_PATH.."card/pocker_middle/"..string.format("card_%d.png",card_index))
			self.ControlCardImage[i]:setPosition(330+i*30,480)
			:setVisible(true)
			:setLocalZOrder(2)
			:addTo(self,200)
		else
			self.ControlCardImage[i] = display.newSprite(GameViewLayer.RES_PATH.."card/pocker_middle/"..string.format("card_%d.png",card_index))
			self.ControlCardImage[i]:setPosition(330+i*30 - self.cbSurplusCardCount/2 * 30,350)
			:setVisible(true)
			:setLocalZOrder(2)
			:addTo(self,200)
		end
	end
end
function GameViewLayer:onResetView()
	self.nodeLeaveCard:removeAllChildren()
	self.spriteBankerFlag:setVisible(false)
	self._csbNodebankTop:setVisible(false)
	--self.spritePrompt:setVisible(false)

    for i = 1, cmd.GAME_PLAYER do
		for j = 1, 5 do
	        self.nodeCard[i][j]:setVisible(false)
            self.nodeCard[i][j]:loadTexture("card/pocker_middle/"..string.format("card_%d.png",54))
        end

        if i == cmd.MY_VIEWID then
            for k = 1, 5 do
                self.MynodeCard[k]:loadTexture("card/pocker_middle/"..string.format("card_%d.png",54))
	            self.MynodeCard[k]:setVisible(false)
            end
        end

        self._csbcardType[i]:setVisible(false);
        self._csbcardTypeTure[i]:setVisible(false);
	end

	--重排列牌
	local cardWidth = self.animateCard:getContentSize().width
	local cardHeight = self.animateCard:getContentSize().height
	for i = 1, cmd.GAME_PLAYER do
		local fSpacing		--牌间距
		local fX 			--起点
		local fWidth 		--宽度
		--以上三个数据是保证牌节点的坐标位置位于其下五张牌的正中心
		if i == cmd.MY_VIEWID then
			fSpacing = 166
			fX = fSpacing/2
			fWidth = fSpacing*5
		else
			fSpacing = GameViewLayer.CARDSPACING
			fX = cardWidth/2
			fWidth = cardWidth + fSpacing*4
		end
--		self.nodeCard[i]:setContentSize(cc.size(fWidth, cardHeight))
--		for j = 1, 5 do
--			local card = self.nodeCard[i]:getChildByTag(j)
--				:move(fX + fSpacing*(j - 1), cardHeight/2)
--				:setTextureRect(cc.rect(cardWidth*2, cardHeight*4, cardWidth, cardHeight))
--				:setVisible(false)
--				:setLocalZOrder(1)
--		end
        local n = table.maxn(self.tableScore[i])
        for j = 1,n do
            if self.tableScore[i][j] ~= nil then
		        self.tableScore[i][j]:setVisible(false)
                self.tableScore[i][j]:removeFromParent()
                self.tableScore[i][j] = nil
            end
        end
        self.tableUserAddScore[i]:setVisible(false)
        self.lTableScore[i] = 0
		--self.cardType[i]:setVisible(false)
	end
	self.bCardOut = {false, false, false, false, false}
	self.bBtnMoving = false
	self.labCardType:setString("")
	for i = 1, 4 do
		self.labAtCardPrompt[i]:setString("")
        self.btChip[i]:setVisible(false)
	end
	
	for i = 1,cmd.GAME_PLAYER do
		if self.GameScoreNum[i] ~= nil then
			self.GameScoreNum[i]:removeFromParent()
			self.GameScoreNum[i] = nil
		end
		if self.multiple[i] ~= nil then
			self.multiple[i]:setVisible(false)
			self.multiple[i]:removeFromParent()
			self.multiple[i] = nil
		end
	end
	

	
end
--更新用户显示
function GameViewLayer:OnUpdateUserStatus(viewId)
	local head = self.nodePlayer[viewId]:getChildByTag(GameViewLayer.FACE)
	self.nodePlayer[viewId]:setVisible(false)
	self.flag_ready[viewId]:setVisible(false)
	self.cbGender[viewId] = nil
	if head then
		head:setVisible(false)
	end
	self.nodePlayer[viewId]:setVisible(false)
	self.m_tabUserItem[viewId] = nil
end
--更新用户显示
function GameViewLayer:OnUpdateUser(viewId, userItem)
	if userItem ~= nil  then
		if userItem.cbUserStatus == yl.US_LOOKON then
			return		
		end
	end
	if not viewId or viewId == yl.INVALID_CHAIR then
		print("OnUpdateUser viewId is nil")
		return
	end
	

	if self.bdeleteuserdata ==  true then
		for i = 1,cmd.GAME_PLAYER do	
			local head = self.nodePlayer[i]:getChildByTag(GameViewLayer.FACE)
			self.nodePlayer[i]:setVisible(false)
			self.flag_ready[i]:setVisible(false)
			self.cbGender[i] = nil
			if head then
				head:setVisible(false)
			end
			self.nodePlayer[i]:setVisible(false)
			self.m_tabUserItem[i] = nil
		end
	end

	self.bdeleteuserdata = false		
	--dump(userItem, "OnUpdateUser" .. viewId, 6)
	self.m_tabUserItem[viewId] = userItem
	local head = self.nodePlayer[viewId]:getChildByTag(GameViewLayer.FACE)
	if not userItem then
		self.nodePlayer[viewId]:setVisible(false)
		self.flag_ready[viewId]:setVisible(false)
		self.cbGender[viewId] = nil
		if head then
			head:setVisible(false)
		end
	else
		self.nodePlayer[viewId]:setVisible(true)

		self:setNickname(viewId, userItem.dwGameID)
		
		self:setScore(viewId, userItem.lScore)
		self.flag_ready[viewId]:setVisible(yl.US_READY == userItem.cbUserStatus)
		self.cbGender[viewId] = userItem.cbGender
		if not head then
			head = PopupInfoHead:createNormalCircle(userItem, 87,("Circleframe.png"))
			--head:setPosition(8, 8)
			head:enableHeadFrame(false)
			head:enableInfoPop(true, pointUserInfo[viewId], anchorPoint[viewId])
			head:setTag(GameViewLayer.FACE)
			self.nodePlayer[viewId]:addChild(head)

			--遮盖层，美化头像
			--display.newSprite("#oxnew_frameTop.png")
				--:move(1, 1)
				--:addTo(head)
			self.m_bNormalState[viewId] = true
		else
			head:updateHead(userItem)
		end
		head:setVisible(true)
		--掉线头像变灰
		if userItem.cbUserStatus == yl.US_OFFLINE then
			if self.m_bNormalState[viewId] then
				convertToGraySprite(head.m_head.m_spRender)
			end
			self.m_bNormalState[viewId] = false
		else
			if not self.m_bNormalState[viewId] then
				convertToNormalSprite(head.m_head.m_spRender)
			end
			self.m_bNormalState[viewId] = true
		end
	end
end

--****************************      计时器        *****************************--
function GameViewLayer:OnUpdataClockView(viewId, time)
	if not viewId or viewId == yl.INVALID_CHAIR or not time then
		self.spriteClock:getChildByTag(GameViewLayer.TIMENUM):setString("")
		self.spriteClock:setVisible(false)
	else
		self.spriteClock:getChildByTag(GameViewLayer.TIMENUM):setString(time)
	end
end

function GameViewLayer:setClockPosition(viewId)
--	if viewId then
--		self.spriteClock:move(pointClock[viewId])
--	else
--		self.spriteClock:move(display.cx, display.cy + 50)
--	end
    self.spriteClock:setVisible(true)
end

--**************************      点击事件        ****************************--
--点击事件
function GameViewLayer:onEventTouchCallback(eventType, x, y)
	if eventType == "began" then
		if self.bBtnInOutside then

            local pos = cc.p(x, y)
            local rectLayerBg = self.spButtonBg:getBoundingBox()
            local x2, y2 = self.spButtonBg:getPosition()
            if not cc.rectContainsPoint(rectLayerBg, pos) then
			    self:onButtonSwitchAnimate()
                self.btSwitch:setVisible(true) 
            end

			return true
		end
        if self.bGameRuleLayer then
           self.bGameRuleLayer = false;
           local x2, y2 = self._csbGameRuleLayer:getPosition()
           self._csbGameRuleLayer:runAction(cc.MoveTo:create(0.3,cc.p(x2 - 500, y2)))
           self._csbGameRuleLayer:setVisible(true)
        end

	elseif eventType == "ended" then
		--用于触发手牌
		if self.bCanMoveCard ~= true then
			return true
		end

--		local size1 = self.nodeCard[cmd.MY_VIEWID]:getContentSize()
--		local x1, y1 = self.nodeCard[cmd.MY_VIEWID]:getPosition()
       -- 判断手上是否有牌
		if not self.nodeCard[cmd.MY_VIEWID][1]:isVisible() then
			 return true
		end
		if self._scene.m_cbGameStatus == cmd.GS_TK_PLAYING then
			for i = 5, 1,-1 do
				--local card = self.nodeCard[cmd.MY_VIEWID][i]:getChildByTag(i)
				local pos = cc.p(x, y)
				local rectLayerBg = self.nodeCard[cmd.MY_VIEWID][i]:getBoundingBox()
				local x2, y2 = self.nodeCard[cmd.MY_VIEWID][i]:getPosition()
				if cc.rectContainsPoint(rectLayerBg, pos) then
					
					if self.cbSurplusCardCount > 0 then
						for j = self.cbSurplusCardCount, 1,-1 do
							if true == self.bControlCardOut[j] then
								self._scene:onSendControlData(self.ControlCardData[j],i,j)
								return true
							end
						end
					end
				
				
					if false == self.bCardOut[i] then
						self.nodeCard[cmd.MY_VIEWID][i]:move(x2, y2 + 30)
						--self.cardFrame[i]:setSelected(true)
						self._scene:PlaySound(GameViewLayer.RES_PATH.."sound/selectcard.wav")
					elseif true == self.bCardOut[i] then
						self.nodeCard[cmd.MY_VIEWID][i]:move(x2, y2 - 30)
						self._scene:PlaySound(GameViewLayer.RES_PATH.."sound/start.wav")
						--self.cardFrame[i]:setSelected(false)
					end
					self.bCardOut[i] = not self.bCardOut[i]
					self:updateCardPrompt()
					return true
				end
			end
		end
				--点击控制牌
		if self.cbSurplusCardCount > 0 then
			for i = self.cbSurplusCardCount, 1,-1 do
			--local card = self.nodeCard[cmd.MY_VIEWID][i]:getChildByTag(i)
				local pos = cc.p(x, y)
				local rectLayerBg = self.ControlCardImage[i]:getBoundingBox()
				local x2, y2 = self.ControlCardImage[i]:getPosition()
				if cc.rectContainsPoint(rectLayerBg, pos) then
				if false == self.bControlCardOut[i] then
				    self.ControlCardImage[i]:move(x2, y2 + 30)
					self._scene:PlaySound(GameViewLayer.RES_PATH.."sound/selectcard.wav")
				elseif true == self.bControlCardOut[i] then
					self.ControlCardImage[i]:move(x2, y2 - 30)
				    self._scene:PlaySound(GameViewLayer.RES_PATH.."sound/start.wav")
				end
				self.bControlCardOut[i] = not self.bControlCardOut[i]
				for j = self.cbSurplusCardCount, 1,-1 do
					if i ~= j then
						if true == self.bControlCardOut[j] then
							local x3, y3 = self.ControlCardImage[j]:getPosition()
							self.ControlCardImage[j]:move(x3, y3 - 30)
							self._scene:PlaySound(GameViewLayer.RES_PATH.."sound/start.wav")
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
function GameViewLayer:ExchangeTable()
	self.bdeleteuserdata = true
        for i = 1,cmd.GAME_PLAYER do
	        local head = self.nodePlayer[i]:getChildByTag(GameViewLayer.FACE)
		    self.nodePlayer[i]:setVisible(false)
		    self.flag_ready[i]:setVisible(false)
		    self.cbGender[i] = nil
		    if head then
			    head:setVisible(false)
		    end
			self.nodePlayer[i]:setVisible(false)
			self.m_tabUserItem[i] = nil
        end
		
		
		self._scene:onChangeDesk()
				
 		--self:onResetView() 								--重置
		if nil ~= self.m_scheduler then

			print("stop dispatch")

			scheduler:unscheduleScriptEntry(self.m_scheduler)

			self.m_scheduler = nil

		end
		self:stopAllActions()
		self.animateCard:stopAllActions()
		self._csbbank:setLastFrameCallFunc(nil)
		self._csbNodebank:setVisible(false)
		self.animateCard:setVisible(false)
		local function countDown(dt)
			if self.m_tabletimer > 0 then
				self.m_tabletimer = self.m_tabletimer - 1
				self.btTable:getChildByTag(GameViewLayer.BT_TABLETIMER):setString(string.format("(%ds)",self.m_tabletimer))
				if self.m_tabletimer == 0 then
					self.btTable:setEnabled(true)
					self.m_tabletimer = 3
					self.istable = false
					self.btTable:getChildByTag(GameViewLayer.BT_TABLETIMER):setVisible(false)
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
		
				for i = 1,self.AlltamaraCount do
			if self.Alltamara[i]  ~= nil then
				self.Alltamara[i]:removeFromParent()
				self.Alltamara[i] = nil
			end
		end
		self.AlltamaraCount = 1
		self.istable = true
		self.btTable:setEnabled(false)
		self.btTable:getChildByTag(GameViewLayer.BT_TABLETIMER):setVisible(true)
		self.btTable:getChildByTag(GameViewLayer.BT_TABLETIMER):setString(string.format("(%ds)",self.m_tabletimer))
		


        self.nodeLeaveCard:removeAllChildren()
	    self.spriteBankerFlag:setVisible(false)
	    self._csbNodebankTop:setVisible(false)

        for i = 1, cmd.GAME_PLAYER do
		    for j = 1, 5 do
	            self.nodeCard[i][j]:setVisible(false)
                self.nodeCard[i][j]:loadTexture("card/pocker_middle/"..string.format("card_%d.png",54))
            end
            if i == cmd.MY_VIEWID then
                for k = 1, 5 do
	                self.MynodeCard[k]:setVisible(false)
                end
            end
            self._csbcardType[i]:setVisible(false);
            self.lTableScore[i] = 0
	    end

	--重排列牌
	    local cardWidth = self.animateCard:getContentSize().width
	    local cardHeight = self.animateCard:getContentSize().height
	for i = 1, cmd.GAME_PLAYER do
		local fSpacing		--牌间距
		local fX 			--起点
		local fWidth 		--宽度
		--以上三个数据是保证牌节点的坐标位置位于其下五张牌的正中心
		if i == cmd.MY_VIEWID then
			fSpacing = 166
			fX = fSpacing/2
			fWidth = fSpacing*5
		else
			fSpacing = GameViewLayer.CARDSPACING
			fX = cardWidth/2
			fWidth = cardWidth + fSpacing*4
		end

        local n = table.maxn(self.tableScore[i])
        for j = 1,n do
            if self.tableScore[i][j] ~= nil then
		        self.tableScore[i][j]:setVisible(false)
                self.tableScore[i][j]:removeFromParent()
                self.tableScore[i][j] = nil
            end
        end
        self.tableUserAddScore[i]:setVisible(false)
		

				
		--self.cardType[i]:setVisible(false)
		end
		self.bCardOut = {false, false, false, false, false}
		self.bBtnMoving = false
		self.labCardType:setString("")
		for i = 1, 4 do
			self.labAtCardPrompt[i]:setString("")
			self.btChip[i]:setVisible(false)
		end
		for i = 1,cmd.GAME_PLAYER do
			if self.GameScoreNum[i] ~= nil then
				self.GameScoreNum[i]:removeFromParent()
				self.GameScoreNum[i] = nil
			end
			if self.multiple[i] ~= nil then
				self.multiple[i]:setVisible(false)
				self.multiple[i]:removeFromParent()
				self.multiple[i] = nil
			end
		end
end
--按钮点击事件
function GameViewLayer:onButtonClickedEvent(tag,ref)
	ExternalFun.playClickEffect()
	if tag == GameViewLayer.BT_START then
		self.btStart:setVisible(false)
		self._scene:onStartGame()
		self._scene:PlaySound(GameViewLayer.RES_PATH.."sound/start.wav")
--    for i = 1, cmd.GAME_PLAYER do
--    	self:gameAddScore(i,123564)
--    end

       -- self:test(this)
--       local randindex = 1;
--       for j = 1,cmd.GAME_PLAYER do
--           if j ~= 5 then
--            randindex = 1
--                for i = 1,25 do
--                    if randindex >1 then
--                        if math.random(1,10) < 7 then
--                            randindex = randindex - 1
--                        end
--                    end
--                    self:ActionCardinalSpline(this,randindex,5,j)
--                    randindex = randindex+1
--                end 
--            end
--        end


--        for i = 1,cmd.GAME_PLAYER do

--        self:runWinLoseAnimate(i, 10000)
--        end
--        local score = 1235
--        local nIndex = 1
--         while score > 0 do
--               for i = 1,14 do

--                   if score >=  self.tableScoreImage[i] then
--                   score = score - self.tableScoreImage[i]
--                   self.tableScore[3][nIndex] = display.newSprite(string.format("#%d.png", self.tableScoreIndex[i]))
--    			   :move(pointTableScore[3].x + math.random(1, 70),pointTableScore[3].y + math.random(1, 30))
--    			   :addTo(self,self.tableScoreIndex[i])
--                   nIndex = nIndex+1
--                   break
--                   end
--               end
--         end
--            --选择庄动画圈数
--        self.randIndex = 2
--        --选择庄动画圈数
--        self.wFisrtChooseCallUser = 1
--        self.wBankerViewChairId = 5

--        self.randIndexbak = -1

--        self.wFisrtChooseCallUserBak = 1
--        self:runChooseBankerAnimate()


--        for i = 1 ,cmd.GAME_PLAYER do
--            self._csbcardType[i]:setVisible(true);
--            self._csbUsercardType[i]:play("niu_01", false)
--        end

--        self._csbGameStart:setVisible(true)
--        self._csbstart:play("gameStart", false)
--        function callBack()
--            self._csbGameStart:setVisible(false)
--        end
--           self._csbstart:setLastFrameCallFunc(callBack)

           --用时间控制
--         local block = cc.CallFunc:create(function(sender)
--            callBack()
--         end )
--        local speed = self._csbstart:getTimeSpeed()

--        local startFrame = self._csbstart:getStartFrame()
--        local endFrame = self._csbstart:getEndFrame()
--        local frameNum = endFrame - startFram
--        self:runAction(cc.Sequence:create(cc.DelayTime:create(1.0 /(speed * 60.0) * frameNum), block))
    elseif tag == GameViewLayer.BT_TRADETABLE then
		self:ExchangeTable();
	elseif tag == GameViewLayer.BT_SWITCH then
		self:onButtonSwitchAnimate()
        self.btSwitch:setVisible(false)
	elseif tag == GameViewLayer.BT_CHAT then
		self._chatLayer:showGameChat(true)
	elseif tag == GameViewLayer.BT_SET then
		print("设置")
		self._setLayer:showLayer()
	elseif tag == GameViewLayer.BT_HOWPLAY then
		print("玩法")
		--self._scene._scene:popHelpLayer2(cmd.KIND_ID, 0, yl.ZORDER.Z_HELP_WEBVIEW)
        self.bGameRuleLayer = true;
        local x2, y2 = self._csbGameRuleLayer:getPosition()
        self._csbGameRuleLayer:runAction(cc.MoveTo:create(0.3,cc.p(x2 + 500, y2)))
        self._csbGameRuleLayer:setVisible(true)
--    local point
--	if bShow then
--		point = cc.p(163, display.cy) 			--移入的位置
--	else
--		point = cc.p(-163, display.cy)			--移出的位置
--	end
--	self.bIntroduce = bShow
--	self._csbGameRuleLayer:stopAllActions()
--	if bShow == true then
--		self._csbGameRuleLayer:setVisible(true)
--	end
--	local this = self
--	self._csbGameRuleLayer:runAction(cc.Sequence:create(
--		cc.MoveTo:create(0.3, point), 
--		cc.CallFunc:create(function()
--				this._csbGameRuleLayer:setVisible(this.bIntroduce)
--			end)
--		))

	elseif tag == GameViewLayer.BT_EXIT then
		self._scene:onQueryExitGame()
	elseif tag == GameViewLayer.BT_OPENCARD then
		self.bCanMoveCard = false
		self.btOpenCard:setVisible(false)
		--self.btPrompt:setVisible(false)
		self.spritePrompt:setVisible(false)

        for i = 5, 1,-1 do
                local x2, y2 = self.nodeCard[cmd.MY_VIEWID][i]:getPosition()
				if true == self.bCardOut[i] then
					self.nodeCard[cmd.MY_VIEWID][i]:move(x2, y2 - 30)
				end
         end
		self._scene:onOpenCard()
	elseif tag == GameViewLayer.BT_PROMPT then
		self:promptOx()
	elseif tag == GameViewLayer.BT_CALLBANKER+1  then
		self._scene:onBanker(tag - GameViewLayer.BT_CALLBANKER)
		for i = 1, 5 do
			self.btCallBanker[i]:setVisible(false)
		end
	elseif tag == GameViewLayer.BT_CALLBANKER+2  then
		self._scene:onBanker(tag - GameViewLayer.BT_CALLBANKER)
		for i = 1, 5 do
			self.btCallBanker[i]:setVisible(false)
		end
	elseif tag == GameViewLayer.BT_CALLBANKER+3  then
		self._scene:onBanker(tag - GameViewLayer.BT_CALLBANKER)
		for i = 1, 5 do
			self.btCallBanker[i]:setVisible(false)
		end
	elseif tag == GameViewLayer.BT_CALLBANKER+4  then
		self._scene:onBanker(tag - GameViewLayer.BT_CALLBANKER)
		for i = 1, 5 do
			self.btCallBanker[i]:setVisible(false)
		end
	elseif tag == GameViewLayer.BT_CALLBANKER+5  then
		--self.btCallBanker:setVisible(false)
		--self.btCancel:setVisible(false)
		self._scene:onBanker(tag - GameViewLayer.BT_CALLBANKER)
		for i = 1, 5 do
			self.btCallBanker[i]:setVisible(false)
		end
	elseif tag == GameViewLayer.BT_CANCEL then
		--self.btCallBanker:setVisible(false)
		--self.btCancel:setVisible(false)
		--self._scene:onBanker(0)
	elseif tag - GameViewLayer.BT_CHIP == 1 or
			tag - GameViewLayer.BT_CHIP == 2 or
			tag - GameViewLayer.BT_CHIP == 3 or
			tag - GameViewLayer.BT_CHIP == 4 then
		for i = 1, 4 do
			self.btChip[i]:setVisible(false)
		end
		local index = tag - GameViewLayer.BT_CHIP
		self._scene:onAddScore(self.lUserMaxScore[index])
	else
		showToast(self,"功能尚未开放！",1)
	end
end
function GameViewLayer:onSetButton(show)
	self.btExit:setEnabled(show)
end
function GameViewLayer:onButtonSwitchAnimate()
	if self.bBtnMoving then
		return
	end
	self.bBtnMoving = true 		--正在滚
	local fInterval = 0.15
	local spacing = 70
	local fScale = 0

	if self.bBtnInOutside then
		fScale = 0.1
		self.btSwitch:setTouchEnabled(true)
	else
		fScale = 1
		self.btSwitch:setTouchEnabled(false)
		self.spButtonBg:setVisible(true)
	end

	--背景图移动
	local timeMax = fInterval*(GameViewLayer.BT_EXIT - GameViewLayer.BT_SET + 1)
	self.spButtonBg:runAction(cc.ScaleTo:create(timeMax, 1, fScale, 1))
	--按钮滚动
	for i = GameViewLayer.BT_SET, GameViewLayer.BT_EXIT do
		local nCount = i - GameViewLayer.BT_SET + 1
		local button = self._csbNode:getChildByTag(i)
		button:setTouchEnabled(false)
		--算时间和距离
		local fRotate = 60
		local time = fInterval*nCount
		local pointTarget = cc.p(0, spacing*nCount)
		if not self.bBtnInOutside then 			--滚出
			fRotate = -fRotate
			pointTarget = cc.p(-pointTarget.x, -pointTarget.y)
		end

		button:runAction(cc.Sequence:create(
--			cc.Spawn:create(cc.MoveBy:create(time, pointTarget), cc.RotateBy:create(time, fRotate))
--           cc.RotateBy:create(time, fRotate),
        cc.MoveBy:create(time, pointTarget), 
			cc.CallFunc:create(function(ref)
				if not this.bBtnInOutside then
                	--ref:setEnabled(false)
					ref:setTouchEnabled(true)
				else
					self.spButtonBg:setVisible(false)
				end

				if i == GameViewLayer.BT_EXIT then
					this.bBtnInOutside = not this.bBtnInOutside
					self.bBtnMoving = false
				end
			end)))
	end
end

function GameViewLayer:gameCallBanker()
	--if callBankerViewId == cmd.MY_VIEWID then
		if self._scene.cbDynamicJoin == 0  then
			local usercount = 0
			for m = 1,cmd.GAME_PLAYER do
				if self._scene:isPlayerPlaying(m) == true then
					usercount = usercount + 1
				end
			end
			
	        for i = 1, 4 do
				if self.m_tabUserItem[cmd.MY_VIEWID].lScore >= ((usercount-1)*4*self.lCellScore*i) then
					self.btCallBanker[i]:setVisible(true)
					self.btCallBanker[i]:setEnabled(true)
				else
					self.btCallBanker[i]:setVisible(true)
					self.btCallBanker[i]:setEnabled(false)
				end
	        end
			self.btCallBanker[5]:setVisible(true)
        end
    --end

--    if bFirstTimes then
--		display.newSprite()
--			:move(display.center)
--			:addTo(self, 1)
--			:runAction(self:getAnimate("start", true))
--    end
end

function GameViewLayer:gameStart(bankerViewId)
    if bankerViewId ~= cmd.MY_VIEWID then
    	if self._scene.cbDynamicJoin == 0 then
				local usercount = 0
				for m = 1,cmd.GAME_PLAYER do
					if self._scene:isPlayerPlaying(m) == true then
						usercount = usercount + 1
					end
				end
				--if self.wBankerViewChairId ~= m and self.multiple[self.wBankerViewChairId] ~= nil then
					
				for i = 1, 4 do
					if self.m_tabUserItem[cmd.MY_VIEWID].lScore >= 4*self.lCellScore*i*self.multiplecount[self.wBankerViewChairId] 
					and self.m_tabUserItem[self.wBankerViewChairId].lScore >= (usercount - 1)*4*self.lCellScore*i*self.multiplecount[self.wBankerViewChairId]  then
						self.btChip[i]:setVisible(true)
						self.btChip[i]:setEnabled(true)
					else
						self.btChip[i]:setVisible(false)
						self.btChip[i]:setEnabled(false)
					end
				end
	    end
    end
end

function GameViewLayer:gameAddScore(viewId, score)
	local strScore = ""..score
	if score < 0 then
		strScore = "/"..(-score)
	end
	self.tableUserAddScore[viewId]:setString(string.formatNumberFhousands(score))
    self.tableUserAddScore[viewId]:setVisible(true)
    self.lTableScore[viewId] = score
--    self._csbheadWinNode[viewId]:setVisible(true)
--    self._csbheadWin[viewId]:play("headWin", false)
    local n = table.maxn(self.tableScore[viewId])
    for j = 1,n do
        if self.tableScore[viewId][j] ~= nil then
		    self.tableScore[viewId][j]:setVisible(false)
            self.tableScore[viewId][j]:removeFromParent()
            self.tableScore[viewId][j] = nil
        end
    end

    local nIndex = 1
    local userscore = score
    while userscore > 0.001 do
        for i = 1,16 do
                   
            local scoreNum = self.tableScoreImage[i]
            if math.abs (userscore -  scoreNum) < 0.001 or  userscore > scoreNum then
            userscore = userscore - self.tableScoreImage[i]
            self.tableScore[viewId][nIndex] = display.newSprite(string.format("#%d.png", self.tableScoreIndex[i]))
    		:move(pointTableScore[viewId].x + math.random(1, 60),pointTableScore[viewId].y + math.random(1, 20) - 10)
    		:addTo(self,self.tableScoreIndex[i])
            nIndex = nIndex+1
            break
            end
        end
    end


    --local labelScore = self.nodePlayer[viewId]:getChildByTag(GameViewLayer.SCORE)
   -- local lScore = tonumber(labelScore:getString())
    --self:setScore(viewId, lScore - score)

    -- 自己下注, 隐藏下注信息
    if viewId == cmd.MY_VIEWID then
    	for i = 1, 4 do
	        self.btChip[i]:setVisible(false)
	    end
    end
end

function GameViewLayer:gameSendCard(firstViewId, totalCount)
	--开始发牌
	self:runSendCardAnimate(firstViewId, totalCount)
end
function GameViewLayer:gameSendCard2(firstViewId, totalCount)
	--开始发牌
	self:runSendCardAnimate2(firstViewId, totalCount)
end
--开牌
function GameViewLayer:gameOpenCard(wViewChairId, cbOx, bEnded)
	local cardWidth = self.animateCard:getContentSize().width
	local cardHeight = self.animateCard:getContentSize().height
	local fSpacing = GameViewLayer.CARDSPACING
	local fWidth
	if cbOx > 0 then
		fWidth = cardWidth + fSpacing*2
	else
		fWidth = cardWidth + fSpacing*4
	end
	--牌型
    if bEnded == true then

		if cbOx > 10 then
		    --self._scene:PlaySound(GameViewLayer.RES_PATH.."sound/GAME_OXOX.wav")
			if cbOx == GameLogic.OX_FOURKING then
				cbOx = 11
			elseif cbOx == GameLogic.OX_FIVEKING  then
				cbOx = 12
			else 
				cbOx = 10
			end
	    end
	    local strFile = string.format("ox_%d.png", cbOx)
	    local spriteFrame = cc.SpriteFrameCache:getInstance():getSpriteFrame(strFile)
        local strFile = string.format("niu_%d", cbOx)
        self._csbcardType[wViewChairId]:setVisible(true);
        self._csbUsercardType[wViewChairId]:play(strFile, false)

	    --隐藏摊牌图标
        self:setOpenCardVisible(wViewChairId, false)
		if cbOx > 10 then
		    --self._scene:PlaySound(GameViewLayer.RES_PATH.."sound/GAME_OXOX.wav")
		    cbOx = 10
	    end
        --声音
        --if bEnded and wViewChairId == cmd.MY_VIEWID then
        if bEnded == true then
    	    local strGender = "GIRL"
    	    if self.cbGender[wViewChairId] == 1 then
			    strGender = "BOY"
		    end
    	    local strSound = GameViewLayer.RES_PATH.."sound/"..strGender.."/ox_"..cbOx..".MP3"
		    self._scene:PlaySound(strSound)
        end
    else	    --隐藏摊牌图标
        self:setOpenCardVisible(wViewChairId, true)
    end
end

function GameViewLayer:gameEnd(bMeWin)
--	local name
--	if bMeWin then
--		name = "victory"
--		self._scene:PlaySound(GameViewLayer.RES_PATH.."sound/GAME_WIN.WAV")
--	else
--		name = "lose"
--		self._scene:PlaySound(GameViewLayer.RES_PATH.."sound/GAME_LOST.WAV")
--	end

	local MeItem = self._scene:GetMeUserItem()
	local MeItem = self._scene:GetMeUserItem()
	if MeItem and MeItem.cbUserStatus == yl.US_LOOKON then
		self:ExchangeTable();
	else
		self.btStart:setVisible(true)
		self.btTable:setVisible(true)
		self.spritePrompt:setVisible(false)	
	end
end

function GameViewLayer:gameScenePlaying()
	if self._scene.cbDynamicJoin == 0 then
--	    self.btOpenCard:setVisible(true)
	    --self.btPrompt:setVisible(true)
	    --self.spritePrompt:setVisible(true)
	    for i = 1, 5 do
	    	--self.cardFrame[i]:setVisible(true)
	    end
	end
end

function GameViewLayer:setCellScore(cellscore)
	if not cellscore then
		self.txt_CellScore:setString("底注：")
	else
		self.txt_CellScore:setString("看牌牛牛   底注："..string.formatNumberFhousands(cellscore))
        self.txt_CellScore:setVisible(true)
        self.chip_frame:setVisible(true)
        self.lCellScore = cellscore;
	end
end

function GameViewLayer:setCardTextureRect(wViewChairId,index,cardData,bMyCardData,bMyOpenCardData)
--	if viewId < 1 or viewId > 4 or tag < 1 or tag > 5 then
--		print("card texture rect error!")
--		return
--	end
    if bMyCardData then
	    self.cbMyCardData[index] = cardData
--        local card_index = GameLogic:GetCardLogicValueToInt(cardData);
--        self.MynodeCard[index]:loadTexture("card/pocker_middle/"..string.format("card_%d.png",card_index))
    else
        local card_index = GameLogic:GetCardLogicValueToInt(cardData);
        self.nodeCard[wViewChairId][index]:loadTexture("card/pocker_middle/"..string.format("card_%d.png",card_index))
    end
    if bMyOpenCardData == true then
        self.cbMyCardData[index] = cardData
        local card_index = GameLogic:GetCardLogicValueToInt(cardData);
        self.nodeCard[wViewChairId][index]:loadTexture("card/pocker_big/"..string.format("card_%d.png",card_index))
    end
	--self.nodeCard[viewId][tag]:setVisible(true)
--	local rectCard = card:getTextureRect()
--	rectCard.x = rectCard.width*(cardValue - 1)
--	rectCard.y = rectCard.height*cardColor
--	card:setTextureRect(rectCard)
end

function GameViewLayer:setNickname(viewId, dwGameID)
	local str = string.format("%d", dwGameID)

	local labelNickname = self.nodePlayer[viewId]:getChildByTag(GameViewLayer.NICKNAME)
	labelNickname:setString(str)
end

function GameViewLayer:setScore(viewId, lScore)
	local labelScore = self.nodePlayer[viewId]:getChildByTag(GameViewLayer.SCORE)
	--labelScore:setString(ExternalFun.formatScoreText(lScore))
	labelScore:setString(string.formatNumberFhousands(lScore))
	--labelScore:setString(lScore)
	local labelWidth = labelScore:getContentSize().width
	if labelWidth > 96 then
		labelScore:setScaleX(96/labelWidth)
	elseif labelScore:getScaleX() ~= 1 then
		labelScore:setScaleX(1)
	end
end

function GameViewLayer:setTableID(id)
	if not id or id == yl.INVALID_TABLE then
		self.txt_TableID:setString("桌号：")
	else
		self.txt_TableID:setString("桌号："..(id + 1))
	end
end

function GameViewLayer:setUserScore(wViewChairId, lScore)
	self.nodePlayer[wViewChairId]:getChildByTag(GameViewLayer.SCORE):setString(lScore)
end

function GameViewLayer:setReadyVisible(wViewChairId, isVisible)
	self.flag_ready[wViewChairId]:setVisible(isVisible)
end

function GameViewLayer:setOpenCardVisible(wViewChairId, isVisible)
	--self.flag_openCard[wViewChairId]:setVisible(isVisible)
    if isVisible == true then
        self._csbcardTypeTure[wViewChairId]:setVisible(isVisible);
        self._csbcard_finish[wViewChairId]:play("card_finish", false)
    else
        self._csbcardTypeTure[wViewChairId]:setVisible(isVisible);
    end
end

function GameViewLayer:setTurnMaxScore(lTurnMaxScore)
--	for i = 1, 4 do
--		self.lUserMaxScore[i] = math.max(lTurnMaxScore, 1)
--		self.btChip[i]:getChildByTag(GameViewLayer.CHIPNUM):setString(self.lUserMaxScore[i])
--		lTurnMaxScore = math.floor(lTurnMaxScore/2)
--	end

    if self.lCellScore  then
	    for i = 4, 1, -1 do
		    self.lUserMaxScore[i] = self.lCellScore * i
		    self.btChip[i]:getChildByTag(GameViewLayer.CHIPNUM):setString(string.formatNumberFhousands(self.lUserMaxScore[i]))
	    end
    end
end

-- 积分房卡配置的下注
function GameViewLayer:setScoreRoomJetton( tabJetton )
	self.lUserMaxScore = tabJetton
	for i = 1, 4 do
		self.btChip[i]:getChildByTag(GameViewLayer.CHIPNUM):setString(string.formatNumberFhousands(self.lUserMaxScore[i]))
	end
end

function GameViewLayer:setBankerUser(wViewChairId)
    --庄家试图位置
    self.wBankerViewChairId = wViewChairId
--	self.spriteBankerFlag:move(pointBankerFlag[wViewChairId])
--	self.spriteBankerFlag:setVisible(true)
--	self.spriteBankerFlag:runAction(self:getAnimate("banker"))
--	--闪烁动画
--	display.newSprite()
--		:move(pointPlayer[wViewChairId].x + 2, pointPlayer[wViewChairId].y - 12)
--		:addTo(self)
--		:runAction(self:getAnimate("faceFlash", true))
end

function GameViewLayer:setUserTableScore(wViewChairId, lScore)
	if lScore == 0 then
		return
	end

	local strScore = ""..lScore
	if lScore < 0 then
		strScore = "/"..(-lScore)
	end
--	self.tableUserAddScore[wViewChairId]:setString(strScore)
--    self.tableUserAddScore[wViewChairId]:setVisible(true)
--     local nIndex = 1
--    local userscore = lScore
--    while userscore > 0 do
--        for i = 1,14 do

--            if userscore >=  self.tableScoreImage[i] then
--            userscore = userscore - self.tableScoreImage[i]
--            self.tableScore[wViewChairId][nIndex] = display.newSprite(string.format("#%d.png", self.tableScoreIndex[i]))
--    		:move(pointTableScore[wViewChairId].x + math.random(1, 70),pointTableScore[wViewChairId].y + math.random(1, 30))
--    		:addTo(self,self.tableScoreIndex[i])
--            nIndex = nIndex+1
--            break
--            end
--        end
--    end

end
function GameViewLayer:runBankerAnimate()
	function bankTop()
        self._csbNodebank:setVisible(false)
		for m = 1,cmd.GAME_PLAYER do
			if self.wBankerViewChairId ~= m and self.multiple[m] ~= nil then
				self.multiple[m]:setVisible(false)
			end
		end
		
        if self.wBankerViewChairId ~= cmd.MY_VIEWID then
    	    if self._scene.cbDynamicJoin == 0 and self.lTableScore[cmd.MY_VIEWID] == 0 then
--[[	            for i = 1, 4 do
	                self.btChip[i]:setVisible(true)
	            end
		        	--]]		
				local usercount = 0
				for m = 1,cmd.GAME_PLAYER do
					if self._scene:isPlayerPlaying(m) == true then
						usercount = usercount + 1
					end
				end
				--if self.wBankerViewChairId ~= m and self.multiple[self.wBankerViewChairId] ~= nil then
					
				for i = 1, 4 do
					if self.m_tabUserItem[cmd.MY_VIEWID].lScore >= 4*self.lCellScore*i*self.multiplecount[self.wBankerViewChairId] 
					and self.m_tabUserItem[self.wBankerViewChairId].lScore >= (usercount - 1)*4*self.lCellScore*i*self.multiplecount[self.wBankerViewChairId]  then
						self.btChip[i]:setVisible(true)
						self.btChip[i]:setEnabled(true)
					else
						self.btChip[i]:setVisible(false)
						self.btChip[i]:setEnabled(false)
					end
				end
			end	
        end
    end

	self._csbNodebankTop:setVisible(true)
	self._csbNodebankTop:move(pointBankerFlag[self.wBankerViewChairId].x ,pointBankerFlag[self.wBankerViewChairId].y)
	self._csbbankTop:play("bankAnimTop", false)
	self._csbbankTop:setLastFrameCallFunc(bankTop)  
	self._scene:PlaySound(GameViewLayer.RES_PATH.."sound/bankersure.wav")
	
end
	
function GameViewLayer:runChooseBankerAnimate(isAllNoRop)

    function callBack()
        self:runChooseBankerAnimate(isAllNoRop)
    end
    function bankTop()
        self._csbNodebank:setVisible(false)
		
		for m = 1,cmd.GAME_PLAYER do
			if self.wBankerViewChairId ~= m and self.multiple[m] ~= nil then
				self.multiple[m]:setVisible(false)
			end
		end
		
        if self.wBankerViewChairId ~= cmd.MY_VIEWID then
    	    if self._scene.cbDynamicJoin == 0 and self.lTableScore[cmd.MY_VIEWID] == 0 then
--[[	            for i = 1, 4 do
	                self.btChip[i]:setVisible(true)
	            end--]]
				local usercount = 0
				for m = 1,cmd.GAME_PLAYER do
					if self._scene:isPlayerPlaying(m) == true then
						usercount = usercount + 1
					end
				end
				--if self.wBankerViewChairId ~= m and self.multiple[self.wBankerViewChairId] ~= nil then
					
				for i = 1, 4 do
					if self.m_tabUserItem[cmd.MY_VIEWID].lScore >= 4*self.lCellScore*i*self.multiplecount[self.wBankerViewChairId] 
					and self.m_tabUserItem[self.wBankerViewChairId].lScore >= (usercount - 1)*4*self.lCellScore*i*self.multiplecount[self.wBankerViewChairId]  then
						self.btChip[i]:setVisible(true)
						self.btChip[i]:setEnabled(true)
					else
						self.btChip[i]:setVisible(false)
						self.btChip[i]:setEnabled(false)
					end
				end
	        end
        end
    end
      self._csbbank:setLastFrameCallFunc(nil)
      self._csbNodebank:setVisible(true)
      self._csbNodebank:move(pointBankerFlag[self.wFisrtChooseCallUserBak])
      self._csbbank:play("randBank", false)
      self._scene:PlaySound(GameViewLayer.RES_PATH.."sound/CALLBANKER.wav")
      --self._csbNodebank:move(pointBankerFlag[4])



    if self.wFisrtChooseCallUserBak == self.wBankerViewChairId and  self.randIndexbak == self.randIndex then 
        self._csbNodebank:move(pointBankerFlag[self.wFisrtChooseCallUserBak].x - 2,pointBankerFlag[self.wFisrtChooseCallUserBak].y + 1 )
        self._csbbank:play("bankAnimBottom", false)
        self._csbNodebankTop:setVisible(true)
		self._csbNodebankTop:move(pointBankerFlag[self.wBankerViewChairId].x ,pointBankerFlag[self.wBankerViewChairId].y)
        self._csbbankTop:play("bankAnimTop", false)
        self._csbbankTop:setLastFrameCallFunc(bankTop)  
		self._scene:PlaySound(GameViewLayer.RES_PATH.."sound/bankersure.wav")
        return
    end
    if self.wFisrtChooseCallUser == self.wFisrtChooseCallUserBak then 
        self.randIndexbak = self.randIndexbak + 1
    end

	self.wFisrtChooseCallUserBak = self.wFisrtChooseCallUserBak + 1
	if self.wFisrtChooseCallUserBak > cmd.GAME_PLAYER then
		self.wFisrtChooseCallUserBak = 1
	end

	if isAllNoRop == true then
		while not self._scene:isPlayerPlaying(self.wFisrtChooseCallUserBak) do
			self.wFisrtChooseCallUserBak = self.wFisrtChooseCallUserBak + 1
			if self.wFisrtChooseCallUserBak > cmd.GAME_PLAYER then
				self.wFisrtChooseCallUserBak = 1
			end
		end
	else
		while not self._scene:isPlayerPlaying(self.wFisrtChooseCallUserBak) or (self.iMaxTimes[self.wFisrtChooseCallUserBak] == -1) do
			self.wFisrtChooseCallUserBak = self.wFisrtChooseCallUserBak + 1
			if self.wFisrtChooseCallUserBak > cmd.GAME_PLAYER then
				self.wFisrtChooseCallUserBak = 1
			end
		end
	end


    self._csbbank:setLastFrameCallFunc(callBack)


end
--发牌动作
function GameViewLayer:runSendCardAnimate2(wViewChairId, nCount)
	local nPlayerNum = self._scene:getPlayNum()
	print("GameViewLayer:runSendCardAnimate count,player ==> ", nCount, nPlayerNum)
	if nCount == nPlayerNum*4 then
		self.animateCard:setVisible(true)
    	self._scene:PlaySound(GameViewLayer.RES_PATH.."sound/SEND_CARD.wav")
	elseif nCount < 1 then
		self.animateCard:setVisible(false)

		if self._scene.cbDynamicJoin == 0 then
			--self.btOpenCard:setVisible(true)
			--self.btPrompt:setVisible(true)
			--self.spritePrompt:setVisible(true)
			if self._scene.m_cbGameStatus == cmd.GS_TK_CALL then
				self:gameCallBanker()			
			end

		end
		--self._scene:sendCardFinish()
		self.bCanMoveCard = true
		return
	end

	local pointMove = {cc.p(-100, 250), cc.p(-310, 0), cc.p(0, -180), cc.p(310, 0),cc.p(100, 250)}
	self.animateCard:runAction(cc.Sequence:create(
			cc.MoveBy:create(0.15, pointMove[wViewChairId]),
			cc.CallFunc:create(function(ref)
				ref:move(display.center)
				--显示一张牌
				local nTag = math.floor(4 - nCount/nPlayerNum) + 1
				self.nodeCard[wViewChairId][nTag]:setVisible(true)
                if wViewChairId == 3 then
                    
                    local card_index = GameLogic:GetCardLogicValueToInt(self.cbMyCardData[nTag]);
                    self.nodeCard[wViewChairId][nTag]:loadTexture("card/pocker_big/"..string.format("card_%d.png",card_index))
                end
				self._scene:PlaySound(GameViewLayer.RES_PATH.."sound/SEND_CARD.wav")
				--开始下一个人的发牌
				wViewChairId = wViewChairId + 1
				if wViewChairId > cmd.GAME_PLAYER then
					wViewChairId = 1
				end
				while not self._scene:isPlayerPlaying(wViewChairId) do
					wViewChairId = wViewChairId + 1
					if wViewChairId > cmd.GAME_PLAYER then
						wViewChairId = 1
					end
				end
				self:runSendCardAnimate2(wViewChairId, nCount - 1)
			end)))
end
--发牌动作
function GameViewLayer:runSendCardAnimate(wViewChairId, nCount)
	local nPlayerNum = self._scene:getPlayNum()
	print("GameViewLayer:runSendCardAnimate count,player ==> ", nCount, nPlayerNum)
	if nCount == nPlayerNum*1 then
		self.animateCard:setVisible(true)
    	self._scene:PlaySound(GameViewLayer.RES_PATH.."sound/SEND_CARD.wav")
	elseif nCount < 1 then
		self.animateCard:setVisible(false)

		if self._scene.cbDynamicJoin == 0 then
			self.btOpenCard:setVisible(true)
			--self.btPrompt:setVisible(true)
			self.spritePrompt:setVisible(true)
		end
		self._scene:sendCardFinish()
		self.bCanMoveCard = true
		return
	end

	local pointMove = {cc.p(-100, 250), cc.p(-310, 0), cc.p(0, -180), cc.p(310, 0),cc.p(100, 250)}
	self.animateCard:runAction(cc.Sequence:create(
			cc.MoveBy:create(0.15, pointMove[wViewChairId]),
			cc.CallFunc:create(function(ref)
				ref:move(display.center)
				--显示一张牌
				local nTag = math.floor(1 - nCount/nPlayerNum) + 1 + 4
				self.nodeCard[wViewChairId][nTag]:setVisible(true)
                if wViewChairId == 3 then
                    
                    local card_index = GameLogic:GetCardLogicValueToInt(self.cbMyCardData[nTag]);
                    self.nodeCard[wViewChairId][nTag]:loadTexture("card/pocker_big/"..string.format("card_%d.png",card_index))
                end
				self._scene:PlaySound(GameViewLayer.RES_PATH.."sound/SEND_CARD.wav")
				--开始下一个人的发牌
				wViewChairId = wViewChairId + 1
				if wViewChairId > cmd.GAME_PLAYER then
					wViewChairId = 1
				end
				while not self._scene:isPlayerPlaying(wViewChairId) do
					wViewChairId = wViewChairId + 1
					if wViewChairId > cmd.GAME_PLAYER then
						wViewChairId = 1
					end
				end
				self:runSendCardAnimate(wViewChairId, nCount - 1)
			end)))
end

--检查牌类型
function GameViewLayer:updateCardPrompt()
	--弹出牌显示，统计和
	local nSumTotal = 0
	local nSumOut = 0
	local nCount = 1

	for i = 1, 5 do
		local nCardValue = self._scene:getMeCardLogicValue(i)
		nSumTotal = nSumTotal + nCardValue
		if self.bCardOut[i] then
	 		if nCount <= 3 then
	 			self.labAtCardPrompt[nCount]:setString(nCardValue)
	 		end
	 		nCount = nCount + 1
			nSumOut = nSumOut + nCardValue
		end
	end
    self.labAtCardPrompt[4]:setString(nSumOut)
	for i = nCount, 3 do
		self.labAtCardPrompt[i]:setString("")
	end
	--判断是否构成牛
	local nDifference = nSumTotal - nSumOut
	if nCount == 1 then
		self.labCardType:setString("")
	elseif nCount == 3 then 		--弹出两张牌
		if self:mod(nDifference, 10) == 0 then
			self.labCardType:setString("牛  "..(nSumOut > 10 and nSumOut - 10 or nSumOut))
		else
			self.labCardType:setString("无牛")
		end
	elseif nCount == 4 then 		--弹出三张牌
		if self:mod(nSumOut, 10) == 0 then
			self.labCardType:setString("牛  "..(nDifference > 10 and nDifference - 10 or nDifference))
		else
			self.labCardType:setString("无牛")
		end
	else
		self.labCardType:setString("无牛")
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

function GameViewLayer:promptOx()
	--首先将牌复位
	for i = 1, 5 do
		if self.bCardOut[i] == true then
			local card = self.nodeCard[cmd.MY_VIEWID]:getChildByTag(i)
			local x, y = card:getPosition()
			y = y - 30
			card:move(x, y)
			self.bCardOut[i] = false
		end
	end
	--将牛牌弹出
	local index = self._scene:GetMeChairID() + 1
	local cbDataTemp = self:copyTab(self._scene.cbCardData[index])
	if self._scene:getOxCard(cbDataTemp) then
		for i = 1, 5 do
			for j = 1, 3 do
				if self._scene.cbCardData[index][i] == cbDataTemp[j] then
					local card = self.nodeCard[cmd.MY_VIEWID]:getChildByTag(i)
					local x, y = card:getPosition()
					y = y + 30
					card:move(x, y)
					self.bCardOut[i] = true
				end
			end
		end
	end
	self:updateCardPrompt()
end

--用户聊天
function GameViewLayer:userChat(wViewChairId, chatString)
	if chatString and #chatString > 0 then
		self._chatLayer:showGameChat(false)
		--取消上次
		if self.chatDetails[wViewChairId] then
			self.chatDetails[wViewChairId]:stopAllActions()
			self.chatDetails[wViewChairId]:removeFromParent()
			self.chatDetails[wViewChairId] = nil
		end

		--创建label
		local limWidth = 24*12
		local labCountLength = cc.Label:createWithSystemFont(chatString,"Arial", 24)  
		if labCountLength:getContentSize().width > limWidth then
			self.chatDetails[wViewChairId] = cc.Label:createWithSystemFont(chatString,"Arial", 24, cc.size(limWidth, 0))
		else
			self.chatDetails[wViewChairId] = cc.Label:createWithSystemFont(chatString,"Arial", 24)
		end
		if wViewChairId ==2 or wViewChairId == 3 then
			self.chatDetails[wViewChairId]:move(pointChat[wViewChairId].x + 24 , pointChat[wViewChairId].y + 9)
				:setAnchorPoint( cc.p(0, 0.5) )
		else
			self.chatDetails[wViewChairId]:move(pointChat[wViewChairId].x - 24 , pointChat[wViewChairId].y + 9)
				:setAnchorPoint(cc.p(1, 0.5))
		end
		self.chatDetails[wViewChairId]:addTo(self, 2)

	    --改变气泡大小
		self.chatBubble[wViewChairId]:setContentSize(self.chatDetails[wViewChairId]:getContentSize().width+48, self.chatDetails[wViewChairId]:getContentSize().height + 40)
			:setVisible(true)
		--动作
	    self.chatDetails[wViewChairId]:runAction(cc.Sequence:create(
	    	cc.DelayTime:create(3),
	    	cc.CallFunc:create(function(ref)
	    		self.chatDetails[wViewChairId]:removeFromParent()
				self.chatDetails[wViewChairId] = nil
				self.chatBubble[wViewChairId]:setVisible(false)
	    	end)))
    end
end

--用户表情
function GameViewLayer:userExpression(wViewChairId, wItemIndex)
	if wItemIndex and wItemIndex >= 0 then
		self._chatLayer:showGameChat(false)
		--取消上次
		if self.chatDetails[wViewChairId] then
			self.chatDetails[wViewChairId]:stopAllActions()
			self.chatDetails[wViewChairId]:removeFromParent()
			self.chatDetails[wViewChairId] = nil
		end

	    local strName = string.format("e(%d).png", wItemIndex)
	    self.chatDetails[wViewChairId] = cc.Sprite:createWithSpriteFrameName(strName)
	        :addTo(self, 2)
	    if wViewChairId ==2 or wViewChairId == 3 then
			self.chatDetails[wViewChairId]:move(pointChat[wViewChairId].x + 45 , pointChat[wViewChairId].y + 5)
		else
			self.chatDetails[wViewChairId]:move(pointChat[wViewChairId].x - 45 , pointChat[wViewChairId].y + 5)
		end

	    --改变气泡大小
		self.chatBubble[wViewChairId]:setContentSize(90,80)
			:setVisible(true)

	    self.chatDetails[wViewChairId]:runAction(cc.Sequence:create(
	    	cc.DelayTime:create(3),
	    	cc.CallFunc:create(function(ref)
	    		self.chatDetails[wViewChairId]:removeFromParent()
				self.chatDetails[wViewChairId] = nil
				self.chatBubble[wViewChairId]:setVisible(false)
	    	end)))
    end
end

-- 语音开始
function GameViewLayer:onUserVoiceStart( viewId )
	--取消上次
	if self.chatDetails[viewId] then
		self.chatDetails[viewId]:stopAllActions()
		self.chatDetails[viewId]:removeFromParent()
		self.chatDetails[viewId] = nil
	end
     -- 语音动画
    local param = AnimationMgr.getAnimationParam()
    param.m_fDelay = 0.1
    param.m_strName = cmd.VOICE_ANIMATION_KEY
    local animate = AnimationMgr.getAnimate(param)
    self.m_actVoiceAni = cc.RepeatForever:create(animate)

    self.chatDetails[viewId] = display.newSprite("#blank.png")
		:setAnchorPoint(cc.p(0.5, 0.5))
		:addTo(self, 3)
	if viewId == 2 or viewId == 3 then
		self.chatDetails[viewId]:setRotation(180)
		self.chatDetails[viewId]:move(pointChat[viewId].x + 45 , pointChat[viewId].y + 15)
	else
		self.chatDetails[viewId]:move(pointChat[viewId].x - 45 , pointChat[viewId].y + 15)
	end
	self.chatDetails[viewId]:runAction(self.m_actVoiceAni)

    --改变气泡大小
	self.chatBubble[viewId]:setContentSize(90,100)
		:setVisible(true)
end

-- 语音结束
function GameViewLayer:onUserVoiceEnded( viewId )
	if self.chatDetails[viewId] then
	    self.chatDetails[viewId]:removeFromParent()
	    self.chatDetails[viewId] = nil
	    self.chatBubble[viewId]:setVisible(false)
	end
end

--拷贝表
function GameViewLayer:copyTab(st)
    local tab = {}
    for k, v in pairs(st) do
        if type(v) ~= "table" then
            tab[k] = v
        else
            tab[k] = self:copyTab(v)
        end
    end
    return tab
 end

--取模
function GameViewLayer:mod(a,b)
    return a - math.floor(a/b)*b
end

--运行输赢动画
function GameViewLayer:runWinLoseAnimate(viewid, score)
	local ptWinLoseAnimate = {cc.p(467, 620), cc.p(198, 340), cc.p(710, 20), cc.p(1098, 340),cc.p(867, 620)}
	local strAnimate
	local strSymbol
	local strNum
	
		local bkScore = string.format("%.2f",score)
	local scorelen = string.len(bkScore)
	if(scorelen > 10 ) then

		score = 0
	end
	local bOK = false
	if score > 0 then
		strAnimate = "yellow"
		strSymbol = "#symbol_add.png"
		strNum = GameViewLayer.RES_PATH.."num_add.png"
	else
		bOK = true
		score = -score
		strAnimate = "blue"
		strSymbol = "#symbol_reduce.png"
		strNum = GameViewLayer.RES_PATH.."num_reduce.png"
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
	spriteSymbol:move(sizeSymbol.width/2, sizeSymbol.height/2 + 5)
	if bOK == true then 
		spriteSymbol:move(sizeSymbol.width/2 + 20, sizeSymbol.height/2 + 10)
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
			cc.MoveBy:create(nTime, cc.p(0, 100)),
			self:getAnimate(strAnimate)
		),
		cc.DelayTime:create(2),
		cc.CallFunc:create(function(ref)
			ref:removeFromParent()
		end)
	))--]]

	self.GameScoreNum[viewid]:runAction(cc.Sequence:create(
		cc.Spawn:create(
			cc.MoveBy:create(nTime, cc.p(0, 100)), 
			cc.FadeIn:create(nTime)
		),
		cc.DelayTime:create(2),
		cc.CallFunc:create(function(ref)
			--ref:removeFromParent()
		end)
	))
end
local size = cc.Director:getInstance():getWinSize()
function GameViewLayer:initWithLayer(layer)
	self.grossini = cc.Sprite:create(GameViewLayer.RES_PATH.."game/1.png")
	self.tamara   = cc.Sprite:create(GameViewLayer.RES_PATH.."game/1.png")
	self.kathia   = cc.Sprite:create(GameViewLayer.RES_PATH.."game/1.png")

	--layer:addChild(self.grossini, 1)
	layer:addChild(self.tamara, 2)
	--layer:addChild(self.kathia, 3)

	self.grossini:setPosition(cc.p(size.width / 2, size.height / 3))
	self.tamara:setPosition(cc.p(size.width / 2, 2 * size.height / 3))
	self.kathia:setPosition(cc.p(size.width / 2, size.height / 2))

	--Helper.initWithLayer(layer)
end
function GameViewLayer:centerSprites(numberOfSprites)
	if numberOfSprites == 0 then
		self.tamara:setVisible(false)
		self.kathia:setVisible(false)
		self.grossini:setVisible(false)
	elseif numberOfSprites == 1 then
		self.tamara:setVisible(false)
		self.kathia:setVisible(false)
		self.grossini:setPosition(cc.p(size.width / 2, size.height / 2))
	elseif numberOfSprites == 2 then
		self.kathia:setPosition(cc.p(size.width / 3, size.height / 2))
		self.tamara:setPosition(cc.p(2 * size.width / 3, size.height / 2))
		self.grossini:setVisible(false)
	elseif numberOfSprites == 3 then
		self.grossini:setPosition(cc.p(size.width / 2, size.height / 2))
		self.tamara:setPosition(cc.p(size.width / 4, size.height / 2))
		self.kathia:setPosition(cc.p(3 * size.width / 4, size.height / 2))
	end
end
function GameViewLayer:ActionCardinal(index,animationfirst,animationend)
    self:ActionCardinalSpline(this,index,animationfirst,animationend)
end

function GameViewLayer:ActionCardinalSpline(layerFarm,index,animationfirst,animationend)

  local layer = layerFarm
  self:initWithLayer(layer)

  self:centerSprites(3)
 
--    local bezier = {
--        cc.p(0, size.height / 2),
--        cc.p(300, - size.height / 2),
--        cc.p(300, 100),
--    }
--    local bezierForward = cc.BezierBy:create(3, bezier)
--    local bezierBack = bezierForward:reverse()
--    local rep = cc.RepeatForever:create(cc.Sequence:create(bezierForward, bezierBack))

    -- sprite 2
    self.tamara:setPosition(pointPlayer[animationfirst].x - 20 + math.random(1,40),pointPlayer[animationfirst].y - 20 + math.random(1,40))
    local bezierTo1 = nil;
    if (animationfirst == 3 and animationend == 4) or (animationfirst == 4 and animationend == 3)  then
        local bezier2 ={
            cc.p(math.random(300,400) + pointPlayer[3].x, size.height / 2 - 40 + math.random(1,30)),
            cc.p(math.random(300,400) + pointPlayer[3].x,  size.height / 2 - 45+ math.random(1,30)),
           cc.p(pointPlayer[animationend].x - 20 + math.random(1,40),pointPlayer[animationend].y - 20 + math.random(1,40))
        }
          bezierTo1 = cc.BezierTo:create(0.7, bezier2)
    elseif (animationfirst == 3 and animationend == 5) or (animationfirst == 5 and animationend == 3)  then
        local bezier2 ={
            cc.p(math.random(300,400) + pointPlayer[3].x - 80, size.height / 2 - 40 + math.random(1,30)),
            cc.p(math.random(300,400) + pointPlayer[3].x - 80,  size.height / 2 - 45+ math.random(1,30)),
           cc.p(pointPlayer[animationend].x - 20 + math.random(1,40),pointPlayer[animationend].y - 20 + math.random(1,40))
        }
          bezierTo1 = cc.BezierTo:create(0.7, bezier2)
    elseif (animationfirst == 2 and animationend == 3) or (animationfirst == 3 and animationend == 2)  then
        local bezier2 ={
            cc.p(math.random(300,400) + pointPlayer[2].x, size.height / 2 - 40 + math.random(1,30)),
            cc.p(math.random(300,400) + pointPlayer[2].x,  size.height / 2 - 45+ math.random(1,30)),
             cc.p(pointPlayer[animationend].x - 20 + math.random(1,40),pointPlayer[animationend].y - 20 + math.random(1,40))
        }
          bezierTo1 = cc.BezierTo:create(0.7, bezier2)
    elseif (animationfirst == 1 and animationend == 3) or (animationfirst == 3 and animationend == 1)  then
        local bezier2 ={
            cc.p(math.random(10,40) + pointPlayer[1].x + 20, size.height / 2  + math.random(1,30)),
            cc.p(math.random(10,40) + pointPlayer[1].x + 20,  size.height / 2+ math.random(1,30)),
             cc.p(pointPlayer[animationend].x - 20 + math.random(1,40),pointPlayer[animationend].y - 20 + math.random(1,40))
        }
        bezierTo1 = cc.BezierTo:create(0.7, bezier2)
    elseif (animationfirst == 2 and animationend == 4) or (animationfirst == 4 and animationend == 2)  then
        local bezier2 ={
            cc.p(math.random(10,50) + size.width, size.height / 2 - 10  + math.random(1,40)),
            cc.p(math.random(10,50) + size.width,  size.height / 2 - 10 + math.random(1,40)),
             cc.p(pointPlayer[animationend].x - 20 + math.random(1,40),pointPlayer[animationend].y - 20 + math.random(1,40))
        }
        bezierTo1 = cc.BezierTo:create(0.7, bezier2)
    elseif (animationfirst == 2 and animationend == 1) or (animationfirst == 1 and animationend == 2)  then
        local bezier2 ={
            cc.p(math.random(10,50) + pointPlayer[2].x + 10, size.height / 2 + 20  + math.random(1,30)),
            cc.p(math.random(10,50) + pointPlayer[2].x + 10,  size.height / 2+ 20 +  math.random(1,30)),
             cc.p(pointPlayer[animationend].x - 20 + math.random(1,40),pointPlayer[animationend].y - 20 + math.random(1,40))
        }
        bezierTo1 = cc.BezierTo:create(0.7, bezier2)
    elseif (animationfirst == 2 and animationend == 5) or (animationfirst == 5 and animationend == 2)  then
        local bezier2 ={
            cc.p(math.random(10,50) + pointPlayer[2].x + 10, size.height / 2 + 20  + math.random(1,30)),
            cc.p(math.random(10,50) + pointPlayer[2].x + 10,  size.height / 2+ 20 +  math.random(1,30)),
                cc.p(pointPlayer[animationend].x - 20 + math.random(1,40),pointPlayer[animationend].y - 20 + math.random(1,40))
        }
        bezierTo1 = cc.BezierTo:create(0.7, bezier2)
    elseif (animationfirst == 4 and animationend == 1) or (animationfirst == 1 and animationend == 4)  then
        local bezier2 ={
            cc.p(math.random(10,50) + pointPlayer[1].x + 10, size.height / 2 + 200  + math.random(1,30)),
            cc.p(math.random(10,50) + pointPlayer[1].x + 10,  size.height / 2+ 200 +  math.random(1,30)),
             cc.p(pointPlayer[animationend].x - 20 + math.random(1,40),pointPlayer[animationend].y - 20 + math.random(1,40))
        }
        bezierTo1 = cc.BezierTo:create(0.7, bezier2)
    elseif (animationfirst == 4 and animationend == 5) or (animationfirst == 5 and animationend == 4)  then
        local bezier2 ={
            cc.p(math.random(10,50) + pointPlayer[5].x + 10, size.height / 2 + 200  + math.random(1,30)),
            cc.p(math.random(10,50) + pointPlayer[5].x + 10,  size.height / 2+ 200 +  math.random(1,30)),
             cc.p(pointPlayer[animationend].x - 20 + math.random(1,40),pointPlayer[animationend].y - 20 + math.random(1,40))
        }
        bezierTo1 = cc.BezierTo:create(0.7, bezier2)

    elseif (animationfirst == 5 and animationend == 1) or (animationfirst == 1 and animationend == 5)  then
        local bezier2 ={
            cc.p(math.random(10,50) + pointPlayer[1].x + 10, size.height / 2 + 300  + math.random(1,30)),
            cc.p(math.random(10,50) + pointPlayer[1].x + 10,  size.height / 2+ 300 +  math.random(1,30)),
             cc.p(pointPlayer[animationend].x - 20 + math.random(1,40),pointPlayer[animationend].y - 20 + math.random(1,40))
        }
        bezierTo1 = cc.BezierTo:create(0.7, bezier2)
    end



    -- sprite 3
--    self.kathia:setPosition(cc.p(400,160))
--    local bezierTo2 = cc.BezierTo:create(2, bezier2)

   --self.grossini:runAction(rep)
--        local randindex = math.random(1,10)
--        if randindex < 7 then
--            index = index - 1
--        end
            local tamarabak =  self.tamara
			local tamarabakIndex = self.AlltamaraCount;
			self.Alltamara[self.AlltamaraCount] = self.tamara
			self.AlltamaraCount = self.AlltamaraCount + 1
            if bezierTo1 ~= nil then 
   	                self.tamara:runAction(cc.Sequence:create(
	    	            cc.DelayTime:create(0.1*index),
                        bezierTo1,
                        cc.CallFunc:create(function()
--                        self._csbheadWinNode[animationend]:setVisible(true)
--                        self._csbheadWin[animationend]:play("headWin", false)
							self.Alltamara[tamarabakIndex] = nil
                        --function callBack()
                            --self._csbheadWinNode[animationend]:setVisible(false)
                            tamarabak:removeFromParent()
                        --end
                        --self._csbheadWin[animationend]:setLastFrameCallFunc(callBack)
                        end)))
            end
   --self.tamara:runAction(bezierTo1)
   --self.kathia:runAction(bezierTo2)
end

function GameViewLayer:clone(object)
    local lookup_table = {}
    local function _copy(object)
        if type(object) ~= "table" then
            return object
        elseif lookup_table[object] then
            return lookup_table[object]
        end
        local new_table = {}
        lookup_table[object] = new_table
        for key, value in pairs(object) do
            new_table[_copy(key)] = _copy(value)
        end
        return setmetatable(new_table, getmetatable(object))
    end
    return _copy(object)
end

--求阶乘
function GameViewLayer:factorial(n)
    if n== 0 then 
        return 1
    else
        return n * self:factorial(n-1)
    end
end

--获取贝塞尔曲线上面的点
function GameViewLayer:getBezierPos(posData,t)
    local data = self:clone(posData)
    local n = #data -1
    local x = 0
    local y = 0

    for idx,pos in pairs(data) do 
        x = x + pos.x *(self:factorial(n)/(self:factorial(n-idx+1)*self:factorial(idx-1))) * math.pow(1-t,n-idx+1) * math.pow(t,idx-1)
        y = y + pos.y *(self:factorial(n)/(self:factorial(n-idx+1)*self:factorial(idx-1))) * math.pow(1-t,n-idx+1) * math.pow(t,idx-1)
    end
    return cc.p(x,y)
end

function GameViewLayer:test(layerFarm)
    local drawNode = cc.DrawNode:create()
    layerFarm:addChild(drawNode)
    drawNode:setPosition(cc.p(5,100))
    --控制点
    local posData = {
        cc.p(100,150),--起始点
        cc.p(300,-80),--控制点可以有多个
        cc.p(400,200),--终点
    }

    local startPos = posData[1]       --起始点位置
    local distance = 20              --虚线的点之间的间隔
    local radius = 3                 --点的半径                 
    local color = cc.c4f(1,0,0,1)    --点的颜色
    local time = 0
    while time < 1 do 
        local pos = self:getBezierPos(posData,time)
        local d = cc.pGetDistance(pos,startPos)
        if d >= distance then 
             drawNode:drawDot(pos,radius,color)
             startPos = pos
        end
        time = time + 0.001
    end

    --查看配置相关控制点
    for idx,pos in pairs(posData)do 
        drawNode:drawDot(pos,5,color)
    end
end
function GameViewLayer:RopBnaker(wCallBankerCharid,cbmultiple)
	if self.multiple[wCallBankerCharid] ~= nil then
		self.multiple[wCallBankerCharid]:setVisible(false)
		self.multiple[wCallBankerCharid]:removeFromParent()
		self.multiple[wCallBankerCharid] = nil
    end
	self.multiplecount[wCallBankerCharid] = cbmultiple
	self.multiple[wCallBankerCharid] = display.newSprite(string.format("#multiple_%d.png", cbmultiple))
	:move(pointmultiple[wCallBankerCharid].x ,pointmultiple[wCallBankerCharid].y)
	:addTo(self)
end

return GameViewLayer