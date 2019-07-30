local GameViewLayer = class("GameViewLayer",function(scene) 
    return display.newLayer()  
end) 
 
if not yl then 
require("client.src.plaza.models.yl") 
end 
local GameChatLayer = appdf.req(appdf.CLIENT_SRC.."plaza.views.layer.game.GameChatLayer") 
 local cmd          = appdf.req(appdf.GAME_SRC.."yule.twohkstylefive.src.models.CMD_Game")
local PopupInfoHead = appdf.req("client.src.external.PopupInfoHead")
local SettingLayer  = appdf.req(appdf.GAME_SRC.."yule.twohkstylefive.src.views.layer.SettingLayer")
local CardSprite    = appdf.req(appdf.GAME_SRC.."yule.twohkstylefive.src.views.layer.CardSprite")
local AnimationMgr  = appdf.req(appdf.EXTERNAL_SRC .. "AnimationMgr")
local ExternalFun   = require(appdf.EXTERNAL_SRC .. "ExternalFun") 

GameViewLayer.RES_PATH 				= "game/yule/twohkstylefive/res/"
GameViewLayer.BT_START 				= 1     --开始
GameViewLayer.BT_MENU 				= 2     --菜单
GameViewLayer.BT_EXIT				= 3     --退出
GameViewLayer.BT_CHANGETABLE		= 4		--换桌
GameViewLayer.BT_FOLLOWGOLD			= 5
GameViewLayer.BT_ADDGOLD			= 6
GameViewLayer.BT_DONOTADDGOLD		= 7
GameViewLayer.BT_SUOHA				= 8
GameViewLayer.BT_GIVEUP 			= 9
GameViewLayer.BT_CHIP_1				= 10
GameViewLayer.BT_CHIP_2				= 11
GameViewLayer.BT_CHIP_3				= 12
GameViewLayer.BT_CHIP_4				= 13
GameViewLayer.BT_SLIDE				= 14
GameViewLayer.BT_CHAT				= 15
GameViewLayer.BT_SET				= 16
GameViewLayer.BT_SOUND				= 17    --音效
GameViewLayer.BT_MUSIC				= 18    --音乐
GameViewLayer.BT_CLOSE				= 19
GameViewLayer.BT_BANK 				= 20 
GameViewLayer.SLIDER				= 31 


local ptCoin     = {cc.p(637, 490), cc.p(180, 250), cc.p(637, 137), cc.p(1024, 250), cc.p(637, 490)} 
local ptCard     = {cc.p(610, 600), cc.p(210, 310), cc.p(610, 230), cc.p(950, 310), cc.p(610, 600)} 
local ptChat     = {cc.p(850, 635), cc.p(175, 395), cc.p(450, 312), cc.p(1150, 395), cc.p(850, 635)} 
local ptLookCard = {cc.p(1000, 500), cc.p(175, 395), cc.p(550, 162), cc.p(1150, 395), cc.p(1000, 500)} 

function GameViewLayer:onExit() 
	cc.SpriteFrameCache:getInstance():removeSpriteFramesFromFile(GameViewLayer.RES_PATH.."game/GameLayer.plist")
	cc.SpriteFrameCache:getInstance():removeSpriteFramesFromFile(GameViewLayer.RES_PATH.."animation/showHand.plist")
	cc.SpriteFrameCache:getInstance():removeSpriteFramesFromFile(GameViewLayer.RES_PATH.."set/set.plist")
	cc.Director:getInstance():getTextureCache():removeTextureForKey(GameViewLayer.RES_PATH.."cards_s.png")
	cc.Director:getInstance():getTextureCache():removeTextureForKey(GameViewLayer.RES_PATH.."game/SH_action_back.png")
	cc.Director:getInstance():getTextureCache():removeTextureForKey(GameViewLayer.RES_PATH.."game/SH_action_font.png")
	cc.Director:getInstance():getTextureCache():removeTextureForKey(GameViewLayer.RES_PATH.."game/SH_card_type-hd.png")
	cc.Director:getInstance():getTextureCache():removeUnusedTextures()
 	cc.SpriteFrameCache:getInstance():removeUnusedSpriteFrames()

    AudioEngine.stopMusic()
end 
function GameViewLayer:preloadUI() 
	cc.FileUtils:getInstance():addSearchPath(GameViewLayer.RES_PATH);
	cc.FileUtils:getInstance():addSearchPath(GameViewLayer.RES_PATH.."sound_res/"); --	声音
	cc.SpriteFrameCache:getInstance():addSpriteFrames(GameViewLayer.RES_PATH.."game/GameLayer.plist")
	cc.SpriteFrameCache:getInstance():addSpriteFrames(GameViewLayer.RES_PATH.."set/set.plist")
    cc.SpriteFrameCache:getInstance():addSpriteFrames(GameViewLayer.RES_PATH.."animation/showHand.plist") 
	cc.Director:getInstance():getTextureCache():addImage(GameViewLayer.RES_PATH.."cards_s.png");
	cc.Director:getInstance():getTextureCache():addImage(GameViewLayer.RES_PATH.."game/SH_action_back.png");
	cc.Director:getInstance():getTextureCache():addImage(GameViewLayer.RES_PATH.."game/SH_action_font.png");
	cc.Director:getInstance():getTextureCache():addImage(GameViewLayer.RES_PATH.."game/SH_card_type-hd.png");
   
    ExternalFun.playBackgroudAudio("LOAD_BACK.mp3")
end
--初始化数据 
function GameViewLayer:initData()
 	self.m_lCellScore = 0 	
 	self.m_LookCard = false
end 

 --更新用户显示
function GameViewLayer:OnUpdateUserStatus(viewId)

end

function GameViewLayer:ctor(scene) 
	local this = self
	self._scene = scene
    self.m_UserChat = {}
  	self:preloadUI()
	self:initData()
	--点击事件
	self.m_touch = display.newLayer()
		:setLocalZOrder(10)
		:addTo(self)
	self.m_touch:setTouchEnabled(true)
	self.m_touch:registerScriptTouchHandler(function(eventType, x, y)
		return this:onTouch(eventType, x, y)
	end)
    
	--节点事件
	local function onNodeEvent(event)
		if event == "exit" then
			self:onExit()
		end
	end
	self:registerScriptHandler(onNodeEvent)
	--按钮回调
	local btnCallback = function(ref, eventType)
		if eventType == ccui.TouchEventType.ended then
			self:OnButtonClickedEvent(ref:getTag(), ref)
		end
	end 
	rootLayer, self._csbNode = ExternalFun.loadRootCSB(GameViewLayer.RES_PATH.."game/GameScene.csb", self); 
	--开始
	self.btnStart = self._csbNode:getChildByName("Button_start")
	self.btnStart:setTag(GameViewLayer.BT_START)
	self.btnStart:addTouchEventListener(btnCallback)
	self.btnStart:setLocalZOrder(8)
    self.btnStart:setPosition(667,400)
    self.btnStart:setScale(0.7) 
	--聊天按钮
	self.btnChat = self._csbNode:getChildByName("Button_chat")
    self.btnChat:setPosition(80,150)
	self.btnChat:setTag(GameViewLayer.BT_CHAT)
	self.btnChat:addTouchEventListener(btnCallback) 
    self.btnChat:setScale(0.75)
    self.btnChat:setVisible(false)
	--弃牌按钮
	self.btnGiveUp = self._csbNode:getChildByName("Button_giveup")
    self.btnGiveUp:setContentSize(140,56)
    self.btnGiveUp:setPosition(770,50)
	self.btnGiveUp:setTag(GameViewLayer.BT_GIVEUP)
	self.btnGiveUp:setVisible(false)
	self.btnGiveUp:addTouchEventListener(btnCallback) 
	--梭哈按钮
	self.btnShowHand = self._csbNode:getChildByName("Button_showhand")
    self.btnShowHand:setContentSize(140,56)
    self.btnShowHand:setPosition(920,50)
	self.btnShowHand:setTag(GameViewLayer.BT_SUOHA)
	self.btnShowHand:setVisible(false)
	self.btnShowHand:addTouchEventListener(btnCallback) 
	--不加按钮
	self.btnNoAdd = self._csbNode:getChildByName("Button_noAdd")
    self.btnNoAdd:setContentSize(140,56)
    self.btnNoAdd:setPosition(1070,50)
	self.btnNoAdd:setTag(GameViewLayer.BT_DONOTADDGOLD)
	self.btnNoAdd:setVisible(false)
	self.btnNoAdd:addTouchEventListener(btnCallback) 
	--跟注按钮
	self.btnFollow = self._csbNode:getChildByName("Button_follow")
    self.btnFollow:setContentSize(140,56)
    self.btnFollow:setPosition(1070,50)
	self.btnFollow:setTag(GameViewLayer.BT_FOLLOWGOLD)
	self.btnFollow:setVisible(false)
	self.btnFollow:addTouchEventListener(btnCallback) 
	--加注按钮
	self.btnAddGold = self._csbNode:getChildByName("Button_addscore")
    self.btnAddGold:setContentSize(140,56)
    self.btnAddGold:setPosition(1220,50)
	self.btnAddGold:setTag(GameViewLayer.BT_ADDGOLD)
	self.btnAddGold:setVisible(false)
	self.btnAddGold:addTouchEventListener(btnCallback) 
	--滑动加注条
	self.m_slider = self._csbNode:getChildByName("Slider")
	self.m_slider:setTag(GameViewLayer.SLIDER)
	self.m_slider:setVisible(false)
	self.m_slider:setLocalZOrder(3)
	--self.btnAddGold:addTouchEventListener(btnCallback) onEvent 
	--滑动条
	self.m_slideProBar = self.m_slider:getChildByName("Slider")
	self.m_slideProBar:onEvent(handler(self,GameViewLayer.SlideEvent))
	self.m_slideProBar:setPercent(0) 
    self.m_slideProBar:setVisible(false)
	--滑动条下面的按钮
	self.m_slideBtn = self.m_slider:getChildByName("slideBtn")
	self.m_slideBtn:setTag(GameViewLayer.BT_SLIDE)
	self.m_slideBtn:addTouchEventListener(btnCallback) 
    self.m_slideBtn:setVisible(false)
	--滑动条上面的按钮
	self.m_slideAllInBtn = self.m_slider:getChildByName("allIn")
	self.m_slideAllInBtn:setTag(GameViewLayer.BT_SUOHA)
	self.m_slideAllInBtn:addTouchEventListener(btnCallback) 
    self.m_slideAllInBtn:setVisible(false)
	--游戏状态下显示总的筹码
	self.m_AllScoreBG = self._csbNode:getChildByName("total_chip_node")
	self.m_AllScoreBG:setVisible(false)
	self.m_AllScoreBG:setLocalZOrder(5)
	self.m_txtAllScore = self.m_AllScoreBG:getChildByName("add_chip_num") 
	--菜单按钮
	self.btnMenu = self._csbNode:getChildByName("Button_switch")
    self.btnMenu:setContentSize(115,64)
	self.btnMenu:setTag(GameViewLayer.BT_MENU)
	self.btnMenu:addTouchEventListener(btnCallback) 
	--菜单背景
	self.m_bShowMenu = false 
 
	self.m_AreaMenu = self._csbNode:getChildByName("menu") 
	self.m_AreaMenu:setVisible(false) 
	self.m_AreaMenu:setLocalZOrder(5) 
	self.m_AreaMenu:setTouchEnabled(true) 
	self.m_AreaMenu:setSwallowTouches(true)  
 
	--设置按钮 ---设置音乐按钮  hch  20171218
	local btnSetting = self.m_AreaMenu:getChildByName("Button_set") 
	btnSetting:setTag(GameViewLayer.BT_SET) 
	btnSetting:addTouchEventListener(btnCallback) 
    if GlobalUserItem.bVoiceAble == true then 
        btnSetting:loadTextureNormal("game/Set_Music_1.png",0)
    else
        btnSetting:loadTextureNormal("game/Set_Music_0.png",0)
    end  
	--换桌按钮
    --屏蔽换桌按钮  hch 20171214
    --音效   在换桌的基础上更改   hch  20171214
	self.btnChangetable = self.m_AreaMenu:getChildByName("Button_changetable")
--    self.btnChangetable:setVisible(false)
	self.btnChangetable:setTag(GameViewLayer.BT_CHANGETABLE)
	self.btnChangetable:addTouchEventListener(btnCallback)
    if GlobalUserItem.bSoundAble == true then
        self.btnChangetable:loadTextureNormal("game/Sound_1.png",0)
    else
        self.btnChangetable:loadTextureNormal("game/Sound_0.png",0)
    end 
     
	--防作弊判断
    if self._scene._gameFrame.bEnterAntiCheatRoom == true then
--        self.btnChangetable:setEnabled(false)
    end 
	--返回按钮
    self.btExit = self.m_AreaMenu:getChildByName("Button_leave")
	    self.btExit:setTag(GameViewLayer.BT_EXIT)
        self.btExit:setTouchEnabled(false)
	    self.btExit:addTouchEventListener(btnCallback) 
	--筹码缓存
	self.nodeChipPool = cc.Node:create():addTo(self._csbNode) 
       --玩法
     self.IntruceBtn = ccui.Button:create("game/pub_btn_introduce_0.png","game/pub_btn_introduce_1.png","game/pub_btn_introduce_0.png")--,"res/pub_btn_introduce_1.png","res/pub_btn_introduce_0.png")
     self.IntruceBtn:addTo(self)
     self.IntruceBtn:setPosition(cc.p(300, 695))
     self.IntruceBtn:addTouchEventListener(function(ref, tType)
                        if tType == ccui.TouchEventType.ended then
                          -- self._scene._scene:popHelpLayer(BaseConfig.WEB_HTTP_URL .. "/Mobile/Introduce.aspx?kindid=409&typeid=3")
                        end
                    end) 
    --底部显示金币数目  hch  20171211
    self.UserSelfScore = cc.Sprite:create("game/UserScore.png")
    self.UserSelfScore:setPosition(210,40)
    self.UserSelfScore:addTo(self._scene)
    self.UserSelfScore:setLocalZOrder(2) 
    
    --右上角底注信息    hch   20171211
    self.UserRecord = cc.Sprite:create("game/UserRecord.png")
    self.UserRecord:setPosition(1155,700)
    self.UserRecord:addTo(self._scene)
    self.UserRecord:setLocalZOrder(2) 

	--玩家 
	self.nodePlayer = {}
	self.readySp = {} 				--准备的精灵
	self.m_UserHead = {}            --用户的头像
	self.m_bOpenUserInfo = true  	--能都点击显示用户详情
	self.m_AddChipNode = {} 
	--时钟
	self.m_TimeProgress = {}
	 for i = 1, cmd.GAME_PLAYER do
	 	--玩家总节点
	 	local strNode = string.format("FileNode_%d",i)
	 	self.nodePlayer[i] = self._csbNode:getChildByName(strNode)
	 	self.nodePlayer[i]:setVisible(false)
	 	self.nodePlayer[i]:setLocalZOrder(2)
        if i==1 or i==5 then
            self.nodePlayer[i]:setPosition(967,575)
        end

	 	local m_TimeProgressBg = self.nodePlayer[i]:getChildByName("timeProBarBg")
		m_TimeProgressBg:setVisible(false) 
	 	--计时器
		self.m_TimeProgress[i] = cc.ProgressTimer:create(display.newSprite("#timeProBar_1.png"))
             :setReverseDirection(true)
             :move(0,0)
             :setVisible(false)
             :setPercentage(100)
             :addTo(self.nodePlayer[i])
		self.m_TimeProgress[i]:setLocalZOrder(2) 
	 	--准备
	 	local strNode = string.format("ready_%d",i)
	 	self.readySp[i] = self._csbNode:getChildByName(strNode)
	 	self.readySp[i]:setVisible(false)
		self.readySp[i]:setLocalZOrder(3)
        if i==1 or i==5 then
            self.readySp[i]:setPosition(967,575)
        elseif i == 3 then
            self.readySp[i]:setPosition(487,250)
        end
        
	 	--玩家背景
	 	self.m_UserHead[i] = {} 
	 	--玩家背景
	 	self.m_UserHead[i].bg = self.nodePlayer[i]:getChildByName("head_bg")
	 	local text_bg = self.nodePlayer[i]:getChildByName("text_bg")
	 	text_bg:setLocalZOrder(2) 
	 	--昵称
	 	self.m_UserHead[i].name = self.nodePlayer[i]:getChildByName("name")
	 	self.m_UserHead[i].name:setLocalZOrder(2) 
	 	--金币
	 	self.m_UserHead[i].score = self.nodePlayer[i]:getChildByName("chip")
	 	self.m_UserHead[i].score:setLocalZOrder(2)

        if i ==3 then
    	    local txtUserScore = string.format("%05d",10)
    	    self.txtUserScore1 = cc.LabelAtlas:create("",cmd.RES_PATH.."game/game_add_num.png",22,31,string.byte("/"))
        	    :move(330,25)
    		    :setAnchorPoint(cc.p(1,0.5))
    		    :addTo(self.UserSelfScore)
                :setLocalZOrder(20)            
        end
 
	end 

        --玩家金币显示


	--手牌显示
	self.userCard = {} --card area 
	--下注显示
	self.m_ScoreView = {} 
	--准备显示
    self.m_flagReady = {} 
	--弃牌标示
	self.m_GiveUp = {}
	for i=1,cmd.GAME_PLAYER do
		self.userCard[i] = {}
		self.userCard[i].card = {0,0,0,0,0} 
		--牌区域
		self.userCard[i].area = cc.Node:create()
			:setVisible(false)
			:addTo(self._csbNode)
		self.userCard[i].area:setLocalZOrder(2)
		self.m_ScoreView[i] = {}
	 	--加注出现的节点 
	 	local strNode = string.format("AddChipNode_%d",i)
	 	self.m_ScoreView[i].frame = self._csbNode:getChildByName(strNode)
	 	self.m_ScoreView[i].frame:setLocalZOrder(2)
	 	self.m_ScoreView[i].score = self.m_ScoreView[i].frame:getChildByName("chip_num")
	 	self.m_ScoreView[i].frame:setVisible(false)
        if i == 1 or i == 5 then
            self.m_ScoreView[i].frame:setPosition(800,580)
        end
	 	self.m_ScoreView[i].score:setString("0")
	end 
 
	--加注出现的四个按钮父节点 
	self.btChip = {}
	self.m_addChipNode = self._csbNode:getChildByName("addScoreNode")
	self.m_addChipNode:setVisible(false)
	--BT_OPENADDGOLD 4个子节点的按钮
	for i=1,4 do
		local strName = string.format("addScore_cell_%d",i)
		self.btChip[i] = self.m_addChipNode:getChildByName(strName)
		self.btChip[i]:setTag(GameViewLayer.BT_CHIP_1 + i - 1)
		self.btChip[i]:addTouchEventListener(btnCallback)
		self.btChip[i]:setTitleText("0")
--        self.btChip[i]:setLocalZOrder(3)
--        self.btChip[i]:setScale(0.6)
        

        --加注四个按钮位置   ---hch 20171215
        if i == 1 then
            self.btChip[i]:setPosition(650,150)            
            self.btChip[i]:loadTextureNormal("game/add1.png",0)
            self.btChip[i]:loadTexturePressed("game/add1.png",0)
            self.btChip[i]:loadTextureDisabled("game/add1.png",0)
        elseif i == 2 then
            self.btChip[i]:setPosition(650,240)
            self.btChip[i]:loadTextureNormal("game/add2.png",0)
            self.btChip[i]:loadTexturePressed("game/add2.png",0)
            self.btChip[i]:loadTextureDisabled("game/add2.png",0)
        elseif i == 3 then
            self.btChip[i]:setPosition(650,330)
            self.btChip[i]:loadTextureNormal("game/add3.png",0)
            self.btChip[i]:loadTexturePressed("game/add3.png",0)
            self.btChip[i]:loadTextureDisabled("game/add3.png",0)
        else 
            self.btChip[i]:setPosition(650,420)
            self.btChip[i]:loadTextureNormal("game/add4.png",0)
            self.btChip[i]:loadTexturePressed("game/add4.png",0)
            self.btChip[i]:loadTextureDisabled("game/add4.png",0)
        end

	end
	--顶部信息
	self.scoreInfo = self._csbNode:getChildByName("game_max_add_back")
    self.scoreInfo:setVisible(false)
	--底注信息
	local txtCellScoreStr = string.format("%05d",10)
	self.txtCellScore = cc.LabelAtlas:create(txtCellScoreStr,cmd.RES_PATH.."game/game_max_add_back_num.png",15,24,string.byte("0"))
    	:move(270,74)
		:setAnchorPoint(cc.p(1,0.5))
		:addTo(self.UserRecord)
        :setLocalZOrder(2)
	--封顶显示
	self.txtMaxCellScore = cc.LabelAtlas:create("0",cmd.RES_PATH.."game/game_max_add_back_num.png",15,24,string.byte("0"))
		:move(270,30)
		:setAnchorPoint(cc.p(1,0.5))
		:addTo(self.UserRecord)
        :setLocalZOrder(2) 

	--底部显示的文字
	self.m_operatorText =  cc.Label:createWithTTF("", "fonts/round_body.ttf", 32)
	self.m_operatorText:setTextColor(cc.c3b(255,255,255))
	self.m_operatorText:setAnchorPoint(cc.p(0.5,0.5))
	self.m_operatorText:setPosition(667,60)
	self:addChild(self.m_operatorText)
    --牌型显示
	self.m_cardType = cc.Node:create()
	self.m_cardType:setPosition(0,0)
	self.m_cardType:addTo(self._csbNode)
	self.m_cardType:setLocalZOrder(3)
	--缓存聊天
	self.m_UserChatView = {}
	--聊天泡泡
	for i = 1 , cmd.GAME_PLAYER do
		self.m_UserChatView[i] = {}
		--node
		self.m_UserChatView[i].node = cc.Node:create()
		self.m_UserChatView[i].node:setPosition(ptChat[i])
		self.m_UserChatView[i].node:addTo(self._csbNode)
		self.m_UserChatView[i].node:setVisible(false)	
		self.m_UserChatView[i].node:setLocalZOrder(3)
		if i < 3 then
			self.m_UserChatView[i].bg = display.newSprite("#chatBg_l.png",0,0,{capInsets = cc.rect(35,0,20,52)});
		else
			self.m_UserChatView[i].bg = display.newSprite("#chatBg_r.png",0,0,{capInsets = cc.rect(15,0,20,52)});
		end
		self.m_UserChatView[i].bg:setPosition(0,0)
		self.m_UserChatView[i].bg:addTo(self.m_UserChatView[i].node)
	end
    --聊天窗口
    self.m_chatLayer = GameChatLayer:create(self._scene._gameFrame)
    	:setLocalZOrder(9)
        :addTo(self._csbNode)
    	:setVisible(false)
   --看牌标识
        self.LookCardSign={}
        for i = 1 , cmd.GAME_PLAYER do
		    self.LookCardSign[i]=display.newSprite("game/LookCardPic.png")
            self.LookCardSign[i]:setPosition(ptLookCard[i])
            self.LookCardSign[i]:setVisible(false)
            self.LookCardSign[i]:setLocalZOrder(99999999)
            self.LookCardSign[i]:addTo(self._csbNode)
	    end 
end 
--重置游戏界面 
function GameViewLayer:OnResetView() 
	self:stopAllActions() 
	self.m_touch:setTouchEnabled(true) 
	--self.nodeChipPool:setVisible(false) 
	self:showOperateButton(false) 
	for i = 1 ,cmd.GAME_PLAYER do
        

		self.readySp[i]:setVisible(false) 
		self:OnUpdateUser(i,nil) 
 
		self:setCardType(i) 
		self:SetUserTableScore(i) 
		self:SetUserEndScore(i) 
		self:SetUserGiveUp(i,false) 
		self:clearCard(i)						--清除牌 
	end 
	self:SetAllTableScore(0) 
	self:SetCellScore(0) 
 
	self:CleanAllJettons() 
	self:SetMaxCellScore(0) 
 
end 
 
--更新用户显示 
function GameViewLayer:OnUpdateUser(viewid,userItem) 
	if not viewid or viewid == yl.INVALID_CHAIR then 
		print("OnUpdateUser viewid is nil") 
		return 
	end 
 
	self.nodePlayer[viewid]:setVisible(userItem ~= nil) 
 
	if not userItem then 
		if self.m_UserHead[viewid].head then 
			self.m_UserHead[viewid].head:setVisible(false) 
		end 
		self.m_UserHead[viewid].name:setString("") 
		self.m_UserHead[viewid].score:setString("") 
		self.readySp[viewid]:setVisible(false) 
	else 
		self.nodePlayer[viewid]:setVisible(true) 
		--昵称 
		self.nodePlayer[viewid]:getChildByName("name"):setString(userItem.szNickName) 
		--金币 
		self:setUserScore(viewid, userItem.lScore) 
        if viewid == 3 then
            self.txtUserScore1:setString(userItem.lScore)
        end 
		--准备 
		self.readySp[viewid]:setVisible(yl.US_READY == userItem.cbUserStatus) 
 
		local isReady = yl.US_READY == userItem.cbUserStatus 
        if  isReady == true then 
            local tempType = self.m_cardType:getChildByTag(viewid)  --卡牌类型 
            if tempType ~= nil then 
                self.m_cardType:removeChildByTag(viewid) 
            end 
        end 
		--头像 
		if not self.nodePlayer[viewid].head then 
			self.nodePlayer[viewid].head = PopupInfoHead:createClipHead(userItem, 125) 
			self.nodePlayer[viewid].head:setPosition(0, 0)			--初始位置 
			self.nodePlayer[viewid].head:enableHeadFrame(false) 
			--点击弹出的位置 
			if viewid < 3 then 
				self.nodePlayer[viewid].head:enableInfoPop(true, cc.p(self.nodePlayer[viewid]:getPositionX()-70,self.nodePlayer[viewid]:getPositionY()-162), cc.p(0.2, 0.5))    --原始的 
			elseif viewid > 3 then 
				self.nodePlayer[viewid].head:enableInfoPop(true, cc.p(self.nodePlayer[viewid]:getPositionX()-300,self.nodePlayer[viewid]:getPositionY()-162), cc.p(0.8, 0.5))    --原始的 
			else 
				self.nodePlayer[viewid].head:enableInfoPop(true, cc.p(self.nodePlayer[viewid]:getPositionX()-200,self.nodePlayer[viewid]:getPositionY()-162), cc.p(0.5, 0.5))	 --原始的 
			end 
			self.nodePlayer[viewid]:addChild(self.nodePlayer[viewid].head) 
		else 
			self.nodePlayer[viewid].head:updateHead(userItem) 
		end 
		self.nodePlayer[viewid].head:setVisible(true)
         
	end 
end 
 
--设置玩家金币 
function GameViewLayer:setUserScore(viewId, lScore) 
	local strName = string.format("FileNode_%d", viewId) 
	local textScore = self._csbNode:getChildByName(strName):getChildByName("chip") 
	textScore:setString(lScore) 
	--限宽 
	local limitWidth = 92 
	local scoreWidth = textScore:getContentSize().width 
	if scoreWidth > limitWidth then 
		textScore:setScaleX(limitWidth/scoreWidth) 
	elseif textScore:getScaleX() ~= 1 then 
		textScore:setScaleX(1) 
	end 
end 
 
--按键响应 
function GameViewLayer:OnButtonClickedEvent(tag,ref) 
	if tag == GameViewLayer.BT_EXIT then 				--退出 完成 
		self._scene:onQueryExitGame() 
	elseif tag == GameViewLayer.BT_START then 			--开始 完成 
		self._scene:onStartGame(true) 
	elseif tag == GameViewLayer.BT_GIVEUP then 			--弃牌   
		self._scene:onGiveUp() 
	elseif tag == GameViewLayer.BT_FOLLOWGOLD then 		--跟牌 
		self._scene:onFollowScore(true) 
	elseif tag == GameViewLayer.BT_ADDGOLD then 		--加注 
		self._scene:onAddScoreButton() -- 
	elseif tag == GameViewLayer.BT_DONOTADDGOLD then 	--不加	 
		self._scene:onDoNotAddScore() 
		self.btnNoAdd:setVisible(false) 
	elseif tag == GameViewLayer.BT_SUOHA then 			--梭哈 
		self._scene:onShowHand() 
	elseif tag == GameViewLayer.BT_CHIP_1 then  
		self._scene:onAddScore(1) 
	elseif tag == GameViewLayer.BT_CHIP_2 then 
		self._scene:onAddScore(2) 
	elseif tag == GameViewLayer.BT_CHIP_3 then 
		self._scene:onAddScore(3) 
	elseif tag == GameViewLayer.BT_CHIP_4 then 
		self._scene:onAddScore(4) 
	elseif tag == GameViewLayer.BT_SLIDE then 
		self._scene:onSlideAddScore() 
	elseif tag == GameViewLayer.BT_CHAT then 			--聊天  
        self.m_chatLayer:showGameChat(true) 
	elseif tag == GameViewLayer.BT_MENU then 			--菜单 完成 
		self:ShowMenu(not self.m_bShowMenu) 
	elseif tag == GameViewLayer.BT_SET then 			--设置  ----设置按钮位置换成音乐按钮
        self:Set_Music()
	elseif tag == GameViewLayer.BT_CHANGETABLE then 	--换桌  ----换桌按钮位置换成音效按钮
        self:Set_Sound()
	elseif tag == GameViewLayer.BT_BANK then 			--银行 
		showToast(self, "该功能尚未开放，敬请期待...", 1) 
	end 
end 

--设置音效    hch  20171218
function GameViewLayer:Set_Sound()
    local effect = not GlobalUserItem.bSoundAble
    GlobalUserItem.setSoundAble(effect)
    if GlobalUserItem.bSoundAble == true then
        self.btnChangetable:loadTextureNormal("game/Sound_1.png",0)
    else
        self.btnChangetable:loadTextureNormal("game/Sound_0.png",0)
    end      
end
--设置音乐    hch  20171218
function GameViewLayer:Set_Music()
    local music = not GlobalUserItem.bVoiceAble
    local btnSet_music = self.m_AreaMenu:getChildByName("Button_set") 
    GlobalUserItem.setVoiceAble(music)
    if GlobalUserItem.bVoiceAble == true then 
        ExternalFun.playBackgroudAudio("LOAD_BACK.mp3")
        btnSet_music:loadTextureNormal("game/Set_Music_1.png",0)
    else
        AudioEngine.stopMusic()
        btnSet_music:loadTextureNormal("game/Set_Music_0.png",0)
    end    
end 
 
 function GameViewLayer:onSetButton(show)
	self.btExit:setEnabled(show)
end

--滑块回调方法 
function GameViewLayer:SlideEvent(event) 
	if event.name == "ON_PERCENTAGE_CHANGED" then 
		local percent = event.target:getPercent() 
		self.m_slideProBar:setPercent(percent) 
		--判断相应的分数 
		if self._scene.m_lTurnLessScore and self._scene.m_lTurnMaxScore then 
 
			local MyChair = self._scene:GetMeChairID() 
			local myTotal = 0 
			if self._scene.m_wAddUser == yl.INVALID_CHAIR then 
				myTotal = self._scene.m_lTotalScore[MyChair+1] 
			else 
				myTotal = self._scene.m_lTotalScore[self._scene.m_wAddUser+1] 
			end 
		 
			local minScore = self._scene.m_lTurnLessScore - myTotal 
			if self._scene.m_llLastScore == 0 then 
				minScore = self.m_lCellScore 
			end 
			local maxScore = self._scene.m_lTurnMaxScore - myTotal  
			local goldNum = math.ceil(minScore + ((maxScore - minScore)/100*percent)) 
			local goldStr = tostring(goldNum) 
			self.m_slideBtn:setTitleText(goldStr) 
		end 
	end 
end 
--控制按钮显示 
function GameViewLayer:showOperateButton(isShow) 
	--弃牌按钮 
	self.btnGiveUp:setVisible(isShow) 
	--梭哈按钮 
	self.btnShowHand:setVisible(isShow) 
	--加注按钮 
	self.btnAddGold:setVisible(isShow) 
	if isShow == true then 
	   	if self._scene.m_llLastScore ~= 0 then --跟注按钮 
	        self.btnFollow:setVisible(true) 
	        self.btnNoAdd:setVisible(false) 
	    elseif self._scene.m_llLastScore == 0 then --不加按钮 
	        self.btnFollow:setVisible(false) 
	        self.btnNoAdd:setVisible(true) 
	    end 
	else 
 		self.btnFollow:setVisible(false) 
        self.btnNoAdd:setVisible(false) 
        self.m_slider:setVisible(false) 
	end 
	--梭哈按钮 
	if  self._scene.m_sendCardCount <3  then 
		self.m_slideAllInBtn:setEnabled(false) 
		self.btnShowHand:setEnabled(false) 
	else 
		self.m_slideAllInBtn:setEnabled(true) 
		self.btnShowHand:setEnabled(true) 
	end 
end 
 
--屏幕点击 
function GameViewLayer:onTouch(eventType, x, y) 
	if eventType == "began" then 
		--点击底牌 
		local  securiteCard = self.userCard[3].area:getChildByTag(1) 
		if securiteCard ~= nil then 
 
			local cardBox = securiteCard:getBoundingBox() 
			if  cc.rectContainsPoint(cardBox, cc.p(x, y)) == true then 
				--动作
                self.isMeLookCard=true 
				securiteCard:stopAllActions() 
				securiteCard:showCardBack(self.m_LookCard) 
				self.m_LookCard = not self.m_LookCard
                self._scene:onLookCard() 
				--延迟一秒后  显示背面 
				securiteCard:runAction(cc.Sequence:create( 
					cc.DelayTime:create(1), 
					cc.CallFunc:create(function () 
						securiteCard:showCardBack(self.m_LookCard) 
						self.m_LookCard = not self.m_LookCard 
					end) 
					)) 
			end 
		end 
		--菜单消失 
		local tempRect = cc.rect(0,400,200,350) 
		if self.m_AreaMenu:isVisible() == true and cc.rectContainsPoint(tempRect, cc.p(x, y)) == false then 
			self.m_bShowMenu = false 
			self.m_AreaMenu:setVisible(self.m_bShowMenu) 
		end 
		return false 
	elseif eventType == "ended" then 
 
	end 
end 
 
 
--筹码移动 
function GameViewLayer:PlayerJetton(wViewChairId, num,notani) 
	if not num or num < 1 or not self.m_lCellScore or self.m_lCellScore < 1 then 
		print("GameViewLayer:PlayerJetton return") 
		return 
	end 
	local chipscore = num 
	while chipscore > 0 do 
		local strChip 
		local strScore  
		--筹码数值显示
        ----------------------------------------------
       if chipscore >= 100000000  then 
			strChip = "#8bigchip.png" 
			chipscore = chipscore - 100000000 
			strScore = ("")..""
       elseif chipscore >= 10000000  then 
			strChip = "#7bigchip.png" 
			chipscore = chipscore - 10000000 
			strScore = ("").."" 
       elseif chipscore >= 1000000  then 
			strChip = "#6bigchip.png" 
			chipscore = chipscore - 1000000 
			strScore = ("").."" 
       elseif chipscore >= 100000  then 
			strChip = "#5bigchip.png" 
			chipscore = chipscore - 100000 
			strScore = ("").."" 
        elseif chipscore >= 10000  then 
			strChip = "#4bigchip.png" 
			chipscore = chipscore - 10000 
			strScore = ("").."" 
        ------------------------------------- 
		elseif chipscore >= 1000  then 
			strChip = "#2bigchip.png" 
			chipscore = chipscore - 1000 
			strScore = ("").."" 
		elseif  chipscore >= 100   then 
			strChip = "#1bigchip.png" 
			chipscore = chipscore - 100 
			strScore = ("").."" 
		else 
			strChip = "#3bigchip.png" 
			chipscore = chipscore - 10 
			strScore = ("") .."" 
		end 
		--筹码创建 
		local chip = display.newSprite(strChip) 
			:setScale(0.6) 
			:addTo(self.nodeChipPool) 
 
		cc.Label:createWithTTF(strScore,"fonts/round_body.ttf", 20) 
			:move(42, 50) 
			:setColor(cc.c3b(0, 0, 0)) 
			:addTo(chip) 
		--是否有动画 
		if notani == true then 
			if wViewChairId < 3 then	 
				chip:move( cc.p(517+ math.random(200), 315 + math.random(140))) 
			elseif wViewChairId > 3 then 
				chip:move(cc.p(617+ math.random(200), 315 + math.random(140))) 
			else 
				chip:move(cc.p(567+ math.random(100), 315 + math.random(140))) 
			end 
		else 
			chip:move(ptCoin[wViewChairId].x,  ptCoin[wViewChairId].y) 
			if wViewChairId < 3 then	 
				chip:runAction(cc.MoveTo:create(0.2, cc.p(517+ math.random(200), 315 + math.random(140)))) 
			elseif wViewChairId > 3 then 
				chip:runAction(cc.MoveTo:create(0.2, cc.p(617+ math.random(200), 315 + math.random(140)))) 
			else 
				chip:runAction(cc.MoveTo:create(0.2, cc.p(567+ math.random(100), 315 + math.random(140)))) 
			end 
		end 
	end 
	if not notani then 
		--ExternalFun.playSoundEffect("ADD_SCORE.wav") 
	end 
end 
 
--底注显示 
function GameViewLayer:SetCellScore(cellscore) 
	self.m_lCellScore = cellscore 
	if not cellscore then 
		self.txtCellScore:setString("0") 
		for i = 1, 4 do 
			self.btChip[i]:setTitleText("") 
		end 
	else 
		self.txtCellScore:setString(cellscore) 
		for i = 1, 4 do 
			self.btChip[i]:setTitleText(cellscore*5)
            if i== 4 then
               self.btChip[i]:setTitleText(20) 
            elseif i== 1 then
               self.btChip[i]:setTitleText(1)
            end
		end 
	end 
end 
 
--封顶分数 
function GameViewLayer:SetMaxCellScore(cellscore) 
	if not cellscore  then 
		self.txtMaxCellScore:setString("") 
	else 
		self.txtMaxCellScore:setString(""..cellscore) 
	end 
end 
 
--下注总额 
function GameViewLayer:SetAllTableScore(score) 
	if not score or score == 0 then 
		self.m_AllScoreBG:setVisible(false) 
	else 
		self.m_txtAllScore:setString(tostring(score)) 
		self.m_AllScoreBG:setVisible(true) 
	end 
end 
 
--玩家结算 
function GameViewLayer:SetUserEndScore(viewid, score) 
	local this = self 
	--增加桌上下注金币 
	if not score or score == 0 then 
		if self.m_ScoreView[viewid].score2 ~= nil  then 
			self.m_ScoreView[viewid].score2:removeFromParent() 
			self.m_ScoreView[viewid].score2 = nil 
		end 
	else 
		self.m_ScoreView[viewid].frame:setVisible(false) 
		self.m_ScoreView[viewid].score:setVisible(false) 
		if self.m_ScoreView[viewid].score2 == nil then 
			local endScoreStr = score > 0 and "game_add_num.png" or "game_reduce_num.png" 
			self.m_ScoreView[viewid].score2 = cc.LabelAtlas:create(txtCellScoreStr,cmd.RES_PATH.."game/" .. endScoreStr,22,31,string.byte("/")) 
				:move(self.m_ScoreView[viewid].frame:getPositionX(),self.m_ScoreView[viewid].frame:getPositionY()) 
				:setAnchorPoint(cc.p(0.5,0.5)) 
				:addTo(self._csbNode) 

            if viewid == 5 or viewid == 1 then
                self.m_ScoreView[viewid].score2:setPosition(800,580)
                self.m_ScoreView[viewid].score2:setLocalZOrder(2)
            end
			self.m_ScoreView[viewid].score2:setVisible(true) 
			self.m_ScoreView[viewid].score2:setString("/" .. math.abs(score)) 
		end 
	end 
end 
 
--玩家下注 
function GameViewLayer:SetUserTableScore(viewid, score) 
	local this = self 
	--增加桌上下注金币 
	if not score or score == 0 then 
		if viewid ~= cmd.MY_VIEWID then 
			self.m_ScoreView[viewid].frame:setVisible(false) 
 
		end 
		self.m_ScoreView[viewid].score:setVisible(false) 
	else 
		if viewid ~= cmd.MY_VIEWID then 
			self.m_ScoreView[viewid].frame:setVisible(true) 
		end 
		self.m_ScoreView[viewid].frame:setVisible(true) 
		self.m_ScoreView[viewid].score:setString(score) 
		self.m_ScoreView[viewid].score:setVisible(true) 
	end 
end 
 
--发牌 
function GameViewLayer:SendCard(viewid,value,cardIndex,fDelay,bDoNotMove,bPlayEffect) 
	if not viewid or viewid == yl.INVALID_CHAIR then 
		return 
	end 
	local fInterval = 0.1 
	local this = self 
	local spriteCard = CardSprite:createCard(value) 
	spriteCard:setTag(cardIndex) 
	spriteCard:addTo(self.userCard[viewid].area) 
	self.userCard[viewid].area:setVisible(true) 
	spriteCard:stopAllActions() 
	spriteCard:setScale(1.0) 
	spriteCard:setVisible(true) 
	--是否有动画 
	if bDoNotMove == false then 
		spriteCard:setScale(viewid==cmd.MY_VIEWID and 1.4 or 1.2) 
		spriteCard:setPosition(cc.p( 
						ptCard[viewid].x + (viewid==cmd.MY_VIEWID and 50 or 35)*(cardIndex- 1),ptCard[viewid].y)) 
	else 
		spriteCard:move(display.cx, display.cy + 170) 
		spriteCard:runAction( 
			cc.Sequence:create( 
				cc.DelayTime:create(fDelay), 
				cc.CallFunc:create( 
					function () 
						 
						ExternalFun.playSoundEffect("SEND_CARD.wav") 
					end 
					), 
				cc.Spawn:create( 
					cc.ScaleTo:create(0.25,viewid==cmd.MY_VIEWID and 1.4 or 1.2), 
					cc.MoveTo:create(0.25, cc.p(ptCard[viewid].x + (viewid==cmd.MY_VIEWID and 50 or 35)*(cardIndex- 1)+12,ptCard[viewid].y-20) 
					) 
				) 
			) 
		) 
 
	end 
	if cardIndex == 1 and viewid == 3 then 
		spriteCard:showCardBack(true) 
	end 
end 
 
--弃牌状态 
function GameViewLayer:SetUserGiveUp(viewid ,bGiveup) 
	local nodeCard = self.userCard[viewid] 
	local cardTable = nodeCard.area:getChildren() 
	for k,v in pairs(cardTable) do 
		v:showCardBack(true) 
        v:setVisible(true) 
	end 
end 
 
--清理牌 
function GameViewLayer:clearCard(viewid) 
	local nodeCard = self.userCard[viewid] 
	for i = 1, #nodeCard.card do 
		nodeCard.area:removeAllChildren() 
		nodeCard.card = {0,0,0,0,0} 
	end 
end 
 
--赢得筹码 
function GameViewLayer:WinTheChip(wWinner) 
	--加注界面消失 
    self.m_slider:setVisible(false) 
    self.m_addChipNode:setVisible(false) 
	--筹码动作 
	local children = self.nodeChipPool:getChildren() 
	for k, v in pairs(children) do 
		local tempTime = 1.5/#children  
		v:runAction(cc.Sequence:create(cc.DelayTime:create(tempTime*(#children - k)), 
		cc.MoveTo:create(tempTime, cc.p(self.nodePlayer[wWinner]:getPositionX(),self.nodePlayer[wWinner]:getPositionY())), 
		cc.CallFunc:create(function(node) 
			node:removeFromParent() 
		end))) 
	end 
	--显示开始按钮 
    self.btnStart:setVisible(true) 
end 
 
--牌值类型 
function GameViewLayer:setCardType(viewid,cardType) 
	if cardType and cardType >= 1 and cardType <= 9 then 
		local m_strCardFile = "game/yule/twohkstylefive/res/game/SH_card_type-hd.png"	 
		local tex = cc.Director:getInstance():getTextureCache():getTextureForKey(m_strCardFile); 
		local rect = cc.rect((cardType-1)*159,0,159,40) 
 
		local cardTypeSp = cc.Sprite:create() 
		cardTypeSp:initWithTexture(tex,tex:getContentSize()) 
		cardTypeSp:setPosition(ptCard[viewid].x + 80,ptCard[viewid].y) 
		cardTypeSp:addTo(self.m_cardType) 
		cardTypeSp:setTag(viewid) 
		cardTypeSp:setTextureRect(rect); 
	else 
	    self.m_cardType:removeAllChildren() 
	end 
end 
 
--清理筹码 
function GameViewLayer:CleanAllJettons() 
	self.nodeChipPool:removeAllChildren() 
end 
 
--菜单按钮回调方法 
function GameViewLayer:ShowMenu(bShow) 
	if self.m_bShowMenu ~= bShow then 
		self.m_bShowMenu = bShow 
		self.m_AreaMenu:stopAllActions() 
 
		self.m_AreaMenu:setVisible(self.m_bShowMenu) 
	end 
end 
 
--梭哈动画 
function GameViewLayer:runShowHandAnimate(viewid) 
	local sprite = display.newSprite() 
	sprite:setPosition(17,17) 
	self.nodePlayer[viewid]:addChild(sprite,99)  
	local animation =cc.Animation:create() 
	for i=1,28 do   
	    local frameName =string.format("allin_%02d.png",i)                                             
	    --print("frameName =%s",frameName)   
	    local spriteFrame = cc.SpriteFrameCache:getInstance():getSpriteFrame(frameName)                
	   animation:addSpriteFrame(spriteFrame)                                                              
	end   
   	animation:setDelayPerUnit(0.15)          --设置两个帧播放时间                    
   	animation:setRestoreOriginalFrame(true)    --动画执行后还原初始状态     
 
   	local action =cc.Animate:create(animation)                                                          
   	sprite:runAction(cc.Sequence:create(action,cc.CallFunc:create(function () 
   		sprite:removeFromParent() 
   	end) 
   	))     
end 
 
--点击按钮出现的操作提示 
function GameViewLayer:showTip(viewid,index) 
	self.m_UserChatView[viewid].node:setVisible(true) 
	self.m_UserChatView[viewid].bg:setVisible(true) 
	--取消上次 
	if self.m_UserChat[viewid] then 
		self.m_UserChat[viewid]:stopAllActions() 
		self.m_UserChat[viewid]:removeFromParent() 
		self.m_UserChat[viewid] = nil 
	end 
	if self.m_UserChatView[viewid].text then 
		self.m_UserChatView[viewid].text:stopAllActions() 
		self.m_UserChatView[viewid].text:removeFromParent() 
		self.m_UserChatView[viewid].text = nil 
	end 
	local m_strCardFile = "game/yule/twohkstylefive/res/game/SH_action_font.png"	 
	local tex = cc.Director:getInstance():getTextureCache():getTextureForKey(m_strCardFile); 
	local rect = cc.rect((index-1)*100,0,100,52) 
	--创建精灵 
	self.m_UserChatView[viewid].text = cc.Sprite:create() 
	self.m_UserChatView[viewid].text:initWithTexture(tex,tex:getContentSize()) 
	self.m_UserChatView[viewid].text:setPosition(0,5) 
	self.m_UserChatView[viewid].text:addTo(self.m_UserChatView[viewid].node) 
	self.m_UserChatView[viewid].text:setTextureRect(rect); 
	--精灵动作 
	self.m_UserChatView[viewid].node:runAction(cc.Sequence:create( 
		cc.DelayTime:create(1), 
		cc.CallFunc:create(function () 
			if self.m_UserChatView[viewid].text ~= nil then 
				self.m_UserChatView[viewid].node:setVisible(false) 
				self.m_UserChatView[viewid].text:removeFromParent() 
				self.m_UserChatView[viewid].text = nil 
			end 
		end) 
		)) 
end 

--显示看牌提示
function GameViewLayer:showLookCard(viewid)
    self.LookCardSign[viewid]:setVisible(true)
    self.LookCardSign[viewid]:runAction(cc.Sequence:create( 
		cc.DelayTime:create(1), 
		cc.CallFunc:create(function () 
		    self.LookCardSign[viewid]:setVisible(false)
		end))) 
end 

--显示聊天 
function GameViewLayer:ShowUserChat(viewid ,message) 
	if message and #message > 0 then 
		self.m_chatLayer:showGameChat(false) 
		--取消上次 
		if self.m_UserChat[viewid] then 
			self.m_UserChat[viewid]:stopAllActions() 
			self.m_UserChat[viewid]:removeFromParent() 
			self.m_UserChat[viewid] = nil 
		end 
		--创建label 
		local limWidth = 20*12 
		local labCountLength = cc.Label:createWithTTF(message,"fonts/round_body.ttf", 20)   
		if labCountLength:getContentSize().width > limWidth then 
			self.m_UserChat[viewid] = cc.Label:createWithTTF(message,"fonts/round_body.ttf", 20, cc.size(limWidth, 0)) 
		else 
			self.m_UserChat[viewid] = cc.Label:createWithTTF(message,"fonts/round_body.ttf", 20) 
		end 
		self.m_UserChat[viewid]:addTo(self._csbNode) 
		self.m_UserChat[viewid]:setLocalZOrder(3) 
 
		if viewid <= 3 then 
			self.m_UserChat[viewid]:move(ptChat[viewid].x  , ptChat[viewid].y+5) 
				:setAnchorPoint( cc.p(0.5, 0.5) ) 
		else 
			self.m_UserChat[viewid]:move(ptChat[viewid].x  , ptChat[viewid].y) 
				:setAnchorPoint(cc.p(0.5, 0.5)) 
		end 
		--改变气泡大小 
		self.m_UserChatView[viewid].node:setVisible(true) 
		self.m_UserChatView[viewid].bg:setContentSize(self.m_UserChat[viewid]:getContentSize().width+28, self.m_UserChat[viewid]:getContentSize().height + 27) 
			:setVisible(true) 
		self.m_UserChat[viewid]:setTextColor(cc.c3b(255,255,255)) 
		--动作 
		self.m_UserChat[viewid]:runAction(cc.Sequence:create( 
						cc.DelayTime:create(2), 
						cc.CallFunc:create(function() 
							self.m_UserChatView[viewid].node:setVisible(false) 
							self.m_UserChatView[viewid].bg:setVisible(false) 
							self.m_UserChatView[viewid].bg:setContentSize(cc.size(72,52)) 
							self.m_UserChat[viewid]:removeFromParent() 
							self.m_UserChat[viewid]=nil 
						end) 
				)) 
	end 
end 
 
--显示表情 
function GameViewLayer:ShowUserExpression(viewid,index) 
	self.m_chatLayer:showGameChat(false) 
	--取消上次 
	if self.m_UserChat[viewid] then 
		self.m_UserChat[viewid]:stopAllActions() 
		self.m_UserChat[viewid]:removeFromParent() 
		self.m_UserChat[viewid] = nil 
	end 
	local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame( string.format("e(%d).png", index)) 
	if frame then 
		self.m_UserChat[viewid] = cc.Sprite:createWithSpriteFrame(frame) 
			:addTo(self._csbNode) 
		self.m_UserChat[viewid]:setLocalZOrder(3) 
		if viewid <= 3 then 
			self.m_UserChat[viewid]:move(ptChat[viewid].x,ptChat[viewid].y+5) 
		else 
			self.m_UserChat[viewid]:move(ptChat[viewid].x,ptChat[viewid].y+5) 
			--self.m_UserChat[viewid]:move(ptChat[viewid].x - 45 , ptChat[viewid].y + 5) 
		end 
		self.m_UserChatView[viewid].node:setVisible(true) 
		self.m_UserChatView[viewid].bg:setVisible(true) 
			:setContentSize(90,80) 
		self.m_UserChat[viewid]:runAction(cc.Sequence:create( 
						cc.DelayTime:create(3), 
						cc.CallFunc:create(function() 
							self.m_UserChatView[viewid].node:setVisible(false) 
							self.m_UserChatView[viewid].bg:setVisible(false) 
							self.m_UserChat[viewid]:removeFromParent() 
							self.m_UserChat[viewid]=nil 
						end) 
				)) 
	end 
end 
 
return GameViewLayer