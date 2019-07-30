local cmd = appdf.req(appdf.GAME_SRC.."yule.sparrowxz.src.models.CMD_Game")


require("client/src/plaza/models/yl")
local PopupInfoHead = appdf.req("client.src.external.PopupInfoHead")
local ExternalFun = require(appdf.EXTERNAL_SRC .. "ExternalFun")
local GameLogic = appdf.req(appdf.GAME_SRC.."yule.sparrowxz.src.models.GameLogic")
local CardLayer = appdf.req(appdf.GAME_SRC.."yule.sparrowxz.src.views.layer.CardLayer")
local ResultLayer = appdf.req(appdf.GAME_SRC.."yule.sparrowxz.src.views.layer.ResultLayer")
local GameChatLayer = appdf.req(appdf.CLIENT_SRC.."plaza.views.layer.game.GameChatLayer")
local PlayerInfo = appdf.req(appdf.GAME_SRC.."yule.sparrowxz.src.views.layer.PlayerInfo")
local SettingLayer = appdf.req(appdf.GAME_SRC .. "yule.sparrowxz.src.views.layer.SettingLayer")
local ClipText = appdf.req(appdf.EXTERNAL_SRC .. "ClipText")

local AnimationMgr = appdf.req(appdf.EXTERNAL_SRC .. "AnimationMgr")

local anchorPointHead = {cc.p(1, 1), cc.p(0, 0.5), cc.p(0, 0), cc.p(1, 0.5)}
local posHead = {cc.p(577, 295), cc.p(165, 332), cc.p(166, 257), cc.p(724, 273)}
local posReady = {cc.p(-333, 0), cc.p(135, 0), cc.p(516, -80), cc.p(-134, 0)}
local posPlate = {cc.p(667, 589), cc.p(237, 464), cc.p(667, 174), cc.p(1093, 455)}
local posChat = {cc.p(873, 660), cc.p(229, 558), cc.p(270, 285), cc.p(1095, 528)}


local VOICE_BTN_NAME = "__voice_record_button__"  --语音按钮名字，可以获取语音按钮，控制显示与否


local GameViewLayer = class("GameViewLayer",function(scene)
	local gameViewLayer =  cc.CSLoader:createNode("game/GameScene.csb")
    return gameViewLayer
end)

GameViewLayer.BT_MENU				= 10 				--按钮开关按钮
GameViewLayer.BT_CHAT 				= 11				--聊天按钮
GameViewLayer.BT_SET 				= 12				--设置
GameViewLayer.CBX_SOUNDOFF 			= 13				--声音开关
GameViewLayer.BT_EXIT	 			= 14			--退出按钮
GameViewLayer.BT_TRUSTEE 			= 15				--托管按钮
GameViewLayer.BT_HOWPLAY 			= 16				--玩法按钮

GameViewLayer.BT_START 				= 20				--开始按钮
GameViewLayer.NODE_INFO_TAG			= 100				--信息界面

GameViewLayer.BT_CHI				= 30				--游戏操作按钮吃
GameViewLayer.BT_GANG 				= 31				--游戏操作按钮杠
GameViewLayer.BT_PENG				= 32				--游戏操作按钮碰
GameViewLayer.BT_HU 				= 33				--游戏操作按钮胡
GameViewLayer.BT_GUO				= 34				--游戏操作按钮过
GameViewLayer.BT_TING				= 35				--游戏操作按钮听

GameViewLayer.ZORDER_OUTCARD = 40
GameViewLayer.ZORDER_LIUSHUI=50
GameViewLayer.ZORDER_RESULT = 110
GameViewLayer.ZORDER_HUSIGN= 45
GameViewLayer.ZORDER_ACTION = 70
GameViewLayer.ZORDER_CHAT = 80
GameViewLayer.ZORDER_SETTING = 90
GameViewLayer.ZORDER_INFO = 100


function GameViewLayer:onInitData()

	self.cbActionCard = 0
	self.cbOutCardTemp = 0
	self.bListenBtnEnabled = false
	self.chatDetails = {}
	self.cbAppearCardIndex = {}
	self.bChoosingHu = false
	self.m_bNormalState = {}
	self.m_nAllCard = 108
	self.m_nLeftCard = self.m_nAllCard
	-- 用户头像
    self.m_tabUserHead = {}

	--房卡需要
	self.m_UserItem = {}

	self.bEnd=false

	self.husigns={}

	-- 语音动画
    AnimationMgr.loadAnimationFromFrame("record_play_ani_%d.png", 1, 3, cmd.VOICE_ANIMATION_KEY)

end

function GameViewLayer:onResetData()

	self.bEnd=false
	self.bChoosingHu = false
	self.cbOutCardTemp = 0
	self.cbAppearCardIndex = {}
	self:onUpdataLeftCard(self.m_nAllCard)

	self.TrustShadow:setVisible(false)

	self:ShowGameBtn(GameLogic.WIK_NULL)

	for i=2,cmd.GAME_PLAYER do
		self.callingCardSp[i]:setVisible(false)
	end

	for i=1,3 do
		self.callCardBtns[i]:stopAllActions()
	end
	self.callCardBar:setVisible(false)

	self:setShowChangeTypeSps(false)

	for i=1,cmd.GAME_PLAYER do
		if nil ~=  self.m_tabUserHead[i] then
			self.m_tabUserHead[i]:showBank(false)
			self.m_tabUserHead[i]:setShowCallCardKind(false)
		end
	end
	self.changeCardBg:setVisible(false)

	if self.operateResultSp and not tolua.isnull(self.operateResultSp) then
		self.operateResultSp:removeSelf()
	end

	for i=1,cmd.GAME_PLAYER do
		if self.husigns[i] then
			self.husigns[i]:removeSelf()
			self.husigns[i]=nil
		end
	end

	self:stopAllActions()
	self:showOutCard(nil, nil, false)
	self._cardLayer:onResetData()
end

function GameViewLayer:setShowCallCard(bShow)
	for i=1,cmd.GAME_PLAYER do
		if nil ~=  self.m_tabUserHead[i] then
			self.m_tabUserHead[i]:setShowCallCardKind(bShow)
		end
	end
end

function GameViewLayer:removeExitedUsers() --收到gameEnd后离开的玩家
	for viewId=1,cmd.GAME_PLAYER do
		if viewId~=cmd.MY_VIEWID and self.m_UserItem[viewId].bExit==true  then
			self.m_tabUserHead[viewId] = nil  --退出依然保存信息
			self.nodePlayer[viewId]:removeAllChildren()
			self.m_UserItem[viewId] = nil
		elseif self.m_UserItem[viewId].bExit==true then
			self.m_UserItem[viewId].bExit=false
		end
	end
end

function GameViewLayer:onExit()
	print("GameViewLayer onExit")
	cc.SpriteFrameCache:getInstance():removeSpriteFramesFromFile("gameScene.plist")
	cc.Director:getInstance():getTextureCache():removeTextureForKey("gameScene.png")
    cc.Director:getInstance():getTextureCache():removeUnusedTextures()
    cc.SpriteFrameCache:getInstance():removeUnusedSpriteFrames()

    self.m_UserItem = {}
    AnimationMgr.removeCachedAnimation(cmd.VOICE_ANIMATION_KEY)
end

function GameViewLayer:getParentNode()
    return self._scene
end

function GameViewLayer:ctor(scene)
	self.name="sparrowxz_gameViewlayer"
	self._scene = scene
	local nodeOpBar = self:getChildByName("FileNode_Op")

	 self:onInitData()
	-- --self:preloadUI()
	self:initButtons()
	self:initUserInfo()
	self._cardLayer = CardLayer:create(self):addTo(self:getChildByName("Node_MaJong"))					--牌图层
    self._chatLayer = GameChatLayer:create(self._scene._gameFrame):addTo(self, GameViewLayer.ZORDER_CHAT)	--聊天框

 --    --左上角游戏信息
 --    --local CsbgameInfoNode = self:getChildByName("FileNode_info")

    --播放背景音乐
    if GlobalUserItem.bVoiceAble == true then
        AudioEngine.playMusic("sound/backgroud.mp3", true)
	end

    -- self.gameInfoNode = cc.CSLoader:createNode("game/NodeInfo.csb"):addTo(self, GameViewLayer.ZORDER_INFO)
    -- self.gameInfoNode:setPosition(cc.p(0, 750))

    -- --剩余牌数
    -- self.cellScoreNode=self.gameInfoNode:getChildByName("AtlasLabel_cellscore")
    -- assert(self.labelCardLeft)
    -- assert(self.cellScoreNode)
    --指针
    self.userPoint = self:getChildByName("sp_clock")
    self.userPoint:setVisible(false)

    --倒计时
    self.labelClock = self.userPoint:getChildByName("AsLab_time")

    --出牌界面
    self.sprOutCardBg = cc.Sprite:create("game/outCardBg.png"):addTo(self, GameViewLayer.ZORDER_OUTCARD)
    self.sprOutCardBg:setVisible(false)
    self.sprMajong = cc.CSLoader:createNode("card/Node_majong_my_downnormal.csb"):addTo(self.sprOutCardBg)
    self.sprMajong:setPosition(self.sprOutCardBg:getContentSize().width/2, self.sprOutCardBg:getContentSize().height/2)

 --    --准备按钮
 --   	local btnReady = ccui.Button:create("common/btn_start1.png", "common/btn_start2.png",
	-- 	"common/btn_start1.png")
	-- btnReady:addTo(self.sprNoWin)
	-- btnReady:setPosition(ccp(249, 80))

	-- --按钮回调
	-- local btnReadyCallback = function(ref, eventType)
	-- 	if eventType == ccui.TouchEventType.ended then
	-- 		-- 准备
	-- 		self._scene:sendGameStart()
	-- 		self:showNoWin(false)
	-- 		self:onResetData()
	-- 	end
	-- end

	-- btnReady:addTouchEventListener(btnReadyCallback)

	--准备状态
	local posACtion =
	{
		cc.p(667, 230),
		cc.p(1085, 420),
		cc.p(260, 420),
		cc.p(667, 575)
	}
	self.readySpr = {}
	for i=1,cmd.GAME_PLAYER do
		local sprPath = nil
		if i == cmd.MY_VIEWID or i == cmd.TOP_VIEWID then
			sprPath = "game/Ready_1.png"
		else
			sprPath = "game/Ready_2.png"
		end
		local sprReady = ccui.ImageView:create(sprPath)
		sprReady:addTo(self)
		sprReady:setVisible(false)
		sprReady:setPosition(posACtion[i])
		table.insert(self.readySpr,sprReady)
	end

	-- --节点事件
	-- local function onNodeEvent(event)
	-- 	if event == "exit" then
	-- 		self:onExit()
	-- 	end
	-- end
	-- self:registerScriptHandler(onNodeEvent)


	--托管覆盖层
	self.TrustShadow = ccui.ImageView:create("game/btn_trustShadow.png")
	self.TrustShadow:addTo(self)
	self.TrustShadow:setTouchEnabled(true)
	self.TrustShadow:setPosition(cc.p(667, 100))
	self.TrustShadow:setVisible(false)
	--取消托管按钮
	local btnExitTrust = ccui.Button:create("game/btn_trustCancel1.png", "game/btn_trustCancel2.png",
		"game/btn_trustCancel1.png")
	btnExitTrust:addTo(self.TrustShadow)
	btnExitTrust:setPosition(ccp(1175, 62))
	--按钮回调
	local btnCallback = function(ref, eventType)
		if eventType == ccui.TouchEventType.ended then
			-- 取消托管
			assert(self._scene.m_bTrustee==true)
			self._scene:sendUserTrustee()
			self.TrustShadow:setVisible(false)
		end
	end
	btnExitTrust:addTouchEventListener(btnCallback)

	-- --玩家出牌
	-- self.spOutCardBg = cc.Sprite:create("game/outCardBg.png")
	-- self.spOutCardBg:addTo(self)
	-- self.spOutCardBg:setVisible(false)

	--玩家胡牌提示
	self.nodeTips = cc.Node:create()
	self.nodeTips:addTo(self, GameViewLayer.ZORDER_ACTION)
	self.nodeTips:setPosition(cc.p(667, 215))

	self.callCardBtns={}
	self.callCardBar=self:getChildByName("FileNode_CallCard")
	for i=1,3 do
		self.callCardBtns[i]=self.callCardBar:getChildByName("Button_"..i)
		self.callCardBtns[i]:addClickEventListener(function()
			self._scene:sendCallCard(i)
			self.callCardBar:setVisible(false)
			self._cardLayer:setCallcardKind(i)
			end)
	end
	self.callCardBar:setVisible(false)

	self.liushuiBtn=self:getChildByName("btn_liushui")
	self.liushuiBtn:addClickEventListener(function() self:showDuiJuLiuShui(self._scene:getMyTagCharts()) end)

	self.callingCardSp={}
	for i=2,4 do
		self.callingCardSp[i]=self:getChildByName("callingcard"..i)
	end

	self.changeCardBg=self:getChildByName("tipBg")
	self.changeCardBtn=self.changeCardBg:getChildByName("btn_changcardok")
	self.changeCardBtn:addClickEventListener(function()
		local cards=self._cardLayer:getChangeCards()
		if #cards~=3 then
			print(" #(self._cardLayer:getChangeCards()):", #(self._cardLayer:getChangeCards()))
			showToast(self,"请选择三张相同花色的牌",1)
		elseif  math.ceil(cards[1]/16)~=math.ceil(cards[2]/16)
			or math.ceil(cards[1]/16)~=math.ceil(cards[3]/16) then
			showToast(self,"请选择三张相同花色的牌",1)
		else
			self._scene:sendChangeCard(cards)
			local t=self._cardLayer.cbCardData[cmd.MY_VIEWID]
			print("#t:",#t)
			assert(#t==10 or #t==11)
			-- self._cardLayer:sortHandCard(cmd.MY_VIEWID)
			t=self._cardLayer.cbCardData[cmd.MY_VIEWID]
			assert(#t==10 or #t==11)
			for i=1,#t do
				print(i..":",t[i])
			end
			self:showChangCardHint(false)
			t=self._cardLayer.cbCardData[cmd.MY_VIEWID]
			assert(#t==10 or #t==11)
			for i=1,#t do
				print(i..":",t[i])
			end
		end
	 end)

	self.leftcardAtlas=self:getChildByName("leftcardNum")
	self.leftcardAtlas:setScale(0.7,0.7)

	self.changeTypeSps={}
	for i=1,4 do
		self.changeTypeSps[i]=self:getChildByName("change_"..i)
	end

	self:getChildByName("Text_playrule"):setPositionY(160+self:getChildByName("Text_playrule"):getPositionY())

	self.debugBtn=self:getChildByName("debugBtn")
	self.debugBtn:addClickEventListener( function() self._scene:sendAskHandCard() end)
	self.debugBtn:setVisible(false)

end

function GameViewLayer:preloadUI()
    print("欢迎来到召唤师峡谷！")
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
			local strFile = "Animate_sice_"..strColor..string.format("/sice_%d.png", index)
			local spFrame = cc.SpriteFrame:create(strFile, cc.rect(133*(j - 1), 0, 133, 207))
			animation:addSpriteFrame(spFrame)
		end

		local strName = "sice_"..strColor..string.format("_%d", index)
		animationCache:addAnimation(animation, strName)
	end
end

function GameViewLayer:setShowChangeTypeSps(bShow,kind)
	--showToast(self,"setShowChangeTypeSps",3)
	for i=1,4 do
		self.changeTypeSps[i]:setVisible(bShow)
	end
	if bShow then
		for i=1,4 do
			self.changeTypeSps[i]:runAction(cc.FadeTo:create(2,0))
		end
	else
		for i=1,4 do
			self.changeTypeSps[i]:stopAllActions()
			self.changeTypeSps[i]:setOpacity(255)
		end
	end
	if kind then
		print("kind:",kind)
		assert(kind==1 or kind==2)
		for i=1,4 do
			self.changeTypeSps[i]:setTexture("game/change"..kind..".png")
		end
	end
end

function GameViewLayer:removeMyChangeCards()
	self._cardLayer:removeHandCardsByIndex(cmd.MY_VIEWID,self._cardLayer:getChangeCardsIndex())
	self._cardLayer:sortHandCard(cmd.MY_VIEWID)
end

function GameViewLayer:exchangeCard(cards,bMeBanker)
	assert(#cards==3)
	self._cardLayer:exchangeCard(cards,bMeBanker)
end

function GameViewLayer:setShowCallCardBar(bShow)
	self.callCardBar:setVisible(bShow)
end

function GameViewLayer:showCallCardHint()
	local kind=self._cardLayer:getCallCardHint()
	for i=2,4 do
		self.callingCardSp[i]:setVisible(true)
	end
	self.callCardBar:setVisible(true)
	local fadeAct=cc.FadeOut:create(1)
	local repAct=cc.Repeat:create(cc.Sequence:create(fadeAct,fadeAct:reverse()),20)
	self.callCardBtns[kind]:setOpacity(255)
	self.callCardBtns[kind]:runAction(repAct)
end

function GameViewLayer:setShowCallingCard(viewid,bShow)
	self.callingCardSp[viewid]:setVisible(bShow)
end

function GameViewLayer:calledCard(viewId,callCardKind)
	assert(self.callingCardSp)
	print("viewId:",viewId)
	if callCardKind==nil and viewId~=cmd.MY_VIEWID then --收到CMD_S_CallCard
		self.callingCardSp[viewId]:setVisible(false)--隐藏“选缺中”
	else --收到bankerinfo
		if viewId~=cmd.MY_VIEWID then
			self.callingCardSp[viewId]:setVisible(false)
		end
		self.m_tabUserHead[viewId]:showCallCard(callCardKind)
		--end
	end
end

--初始化玩家信息
function GameViewLayer:initUserInfo()
	local nodeName =
	{
		"FileNode_3",
		"FileNode_4",
		"FileNode_2",
		"FileNode_1",
	}

	local faceNode = self:getChildByName("Node_User")
	self.nodePlayer = {}
	for i = 1, cmd.GAME_PLAYER do
		self.nodePlayer[i] = faceNode:getChildByName(nodeName[i])
		self.nodePlayer[i]:setLocalZOrder(1)
		self.nodePlayer[i]:setVisible(true)
	end
	self.nodePlayer[4]:setPositionY(self.nodePlayer[4]:getPositionY()+15) --temp
	self.nodePlayer[1]:setPositionY(self.nodePlayer[1]:getPositionY()-15)
end

--更新玩家准备状态
function GameViewLayer:showUserState(viewid, isReady)
	print("更新用户状态", viewid, isReady, #self.readySpr)
	local spr = self.readySpr[viewid]
	if nil ~= spr then
		spr:setVisible( isReady)
	end
end

--初始化界面上button
function GameViewLayer:initButtons()
	--按钮回调
	local btnCallback = function(ref, eventType)
		if eventType == ccui.TouchEventType.ended then
			self:onButtonClickedEvent(ref:getTag(), ref)
		elseif eventType == ccui.TouchEventType.began and ref:getTag() == GameViewLayer.BT_VOICE then
			--self:onButtonClickedEvent(GameViewLayer.BT_VOICEOPEN, ref)
		end
	end

	--桌子操作按钮屏蔽层
	--按钮背景
	local menuBg = self:getChildByName("sp_tableBtBg")
	local function callbackShield(ref)
		local pos = ref:getTouchEndPosition()
        local rectBg = menuBg:getBoundingBox()
        if not cc.rectContainsPoint(rectBg, pos)then
        	self:showMenu(false)
        end
	end
	self.layoutShield = self:getChildByName("Image_Touch")
		:setTouchEnabled(false)
	self.layoutShield:addClickEventListener(callbackShield)

	--右上角按钮控制开关
	local btnMenu = self:getChildByName("bt_menu")
	btnMenu:addTouchEventListener(btnCallback)
	btnMenu:setTag(GameViewLayer.BT_MENU)

	local btSet = menuBg:getChildByName("bt_set")
	btSet:addTouchEventListener(btnCallback)
	btSet:setTag(GameViewLayer.CBX_SOUNDOFF)
	--btSet:setScale(1.5)

	local btChat = menuBg:getChildByName("bt_chat")	--聊天
	btChat:setTag(GameViewLayer.BT_CHAT)
	btChat:addTouchEventListener(btnCallback)
	--btChat:setScale(1.5)

	local btExit = menuBg:getChildByName("bt_exit")	--退出
	btExit:addTouchEventListener(btnCallback)
	btExit:setTag(GameViewLayer.BT_EXIT)
	--btExit:setScale(1.5)

	local btTrustee = menuBg:getChildByName("bt_trustee")	--托管
	btTrustee:addTouchEventListener(btnCallback)
	btTrustee:setTag(GameViewLayer.BT_TRUSTEE)
	if GlobalUserItem.bPrivateRoom then
		btTrustee:setEnabled(false)
		--btTrustee:setColor(cc.c3b(158, 112, 8))
	end
	self.btTrustee=btTrustee

	local btHowPlay = menuBg:getChildByName("bt_help")	--玩法
	btHowPlay:addTouchEventListener(btnCallback)
	btHowPlay:setTag(GameViewLayer.BT_HOWPLAY)

	--开始
	self.btStart = self:getChildByName("bt_start")
		:setVisible(false)
	self.btStart:setPositionX(yl.WIDTH/2)
	self.btStart:addTouchEventListener(btnCallback)
	self.btStart:setTag(GameViewLayer.BT_START)

	-- 语音按钮 gameviewlayer -> gamelayer -> clientscene
    --self:getParentNode():getParentNode():createVoiceBtn(cc.p(1268, 212), 0, self)
	local btnVoice = ccui.Button:create("game/btn_voice1.png", "game/btn_voice2.png",
		"game/btn_voice2.png")
		:move(1268, 212)
		:addTo(self)
	btnVoice:setName(VOICE_BTN_NAME)
	btnVoice:addTouchEventListener(function(ref, eventType)
 		if eventType == ccui.TouchEventType.began then
 			self._scene:getParentNode():startVoiceRecord()
        elseif eventType == ccui.TouchEventType.ended
        	or eventType == ccui.TouchEventType.canceled then
        	self._scene:getParentNode():stopVoiceRecord()
        end
	end)

	--游戏操作按钮
	--获取操作按钮node
	local nodeOpBar = self:getChildByName("FileNode_Op")
	--广东麻将只有4个，不同游戏自行添加
	local btGang = nodeOpBar:getChildByName("Button_gang") 	--杠
	btGang:setEnabled(false)
	btGang:addTouchEventListener(btnCallback)
	btGang:setTag(GameViewLayer.BT_GANG)

	local btPeng = nodeOpBar:getChildByName("Button_pen") 	--碰
	btPeng:setEnabled(false)
	btPeng:addTouchEventListener(btnCallback)
	btPeng:setTag(GameViewLayer.BT_PENG)

	local btHu = nodeOpBar:getChildByName("Button_hu") 	--胡
	btHu:setEnabled(false)
	btHu:addTouchEventListener(btnCallback)
	btHu:setTag(GameViewLayer.BT_HU)

	local btGuo = nodeOpBar:getChildByName("Button_guo") 	--过
	btGuo:setEnabled(false)
	btGuo:addTouchEventListener(btnCallback)
	btGuo:setTag(GameViewLayer.BT_GUO)

end

function GameViewLayer:setBtnTrustEnabled(bEnabled)
	self.btTrustee:setEnabled(bEnabled)
end

function GameViewLayer:setShowStartBtn(bShow)
	self.btStart:setVisible(bShow)
end

--按钮控制（下拉菜单下拉，隐藏语音按钮）
function GameViewLayer:showMenu(bVisible)
	--按钮背景
	local menuBg = self:getChildByName("sp_tableBtBg")
	if menuBg:isVisible() == bVisible then
		return false
	end

	local btnMenu = self:getChildByName("bt_menu")
	self.layoutShield:setTouchEnabled(bVisible)
	menuBg:setVisible(bVisible)

	--显示菜单按钮时，隐藏录音按钮
	local btnVoice = self:getChildByName(VOICE_BTN_NAME)
	btnVoice:setVisible(not bVisible)

	return true
end



function GameViewLayer:showGameResult(tabHupaiInfo)
	self._resultLayer=ResultLayer:create(self,self.m_UserItem,tabHupaiInfo,self._scene:getMyTagCharts(),self._scene.leftUserViewId)
	self._resultLayer:addTo(self,GameViewLayer.ZORDER_RESULT)
end


function GameViewLayer:OnUpdateUserStatus(viewId)

end

--更新用户显示
function GameViewLayer:OnUpdateUser(viewId, userItem)
	if not viewId or viewId == yl.INVALID_CHAIR then
		--assert(false)
		return
	end

	if nil == userItem then
        return
    end
    self.m_UserItem[viewId] = userItem

	if nil == self.m_tabUserHead[viewId] then
        local playerInfo = PlayerInfo:create(userItem, viewId)
        self.m_tabUserHead[viewId] = playerInfo
        self.nodePlayer[viewId]:addChild(playerInfo)
    else  --断线or上线
        self.m_tabUserHead[viewId].m_userItem = userItem
        self.m_tabUserHead[viewId]:updateStatus()
    end
    if PriRoom and GlobalUserItem.bPrivateRoom then
		if userItem.dwUserID == PriRoom:getInstance().m_tabPriData.dwTableOwnerUserID then
			self.m_tabUserHead[viewId]:showRoomHolder(true)
		else
			self.m_tabUserHead[viewId]:showRoomHolder(false)
		end
	end

end

--玩家退出，移除头像信息
function GameViewLayer:OnUpdateUserExit(viewId)
	print("移除用户", viewId)
	if nil ~= self.m_tabUserHead[viewId] and self._scene.bEnd~=true then
		self.m_tabUserHead[viewId] = nil  --退出依然保存信息
		self.nodePlayer[viewId]:removeAllChildren()
		self.m_UserItem[viewId] = nil
	elseif self._scene.bEnd==true then
		self.m_UserItem[viewId].bExit=true
	end
end

-- 文本聊天
function GameViewLayer:onUserChat(chatdata, viewId)
    local playerItem = self.m_tabUserHead[viewId]
    print("获取当前显示聊天的玩家头像", playerItem, viewId, chatdata.szChatString)
    if nil ~= playerItem then
        playerItem:textChat(chatdata.szChatString)
        self._chatLayer:showGameChat(false)
    end
end

-- 表情聊天
function GameViewLayer:onUserExpression(chatdata, viewId)
    local playerItem = self.m_tabUserHead[viewId]
    if nil ~= playerItem then
        playerItem:browChat(chatdata.wItemIndex)
        self._chatLayer:showGameChat(false)
    end
end

--显示语音
function GameViewLayer:ShowUserVoice(viewid, isPlay)
	--取消文字，表情
	local playerItem = self.m_tabUserHead[viewid]
    if nil ~= playerItem then
    	if isPlay then
    		playerItem:onUserVoiceStart()
    	else
    		playerItem:onUserVoiceEnded()
    	end
    end
end

--按键事件
function GameViewLayer:onButtonClickedEvent(tag, ref)
	if tag>=GameViewLayer.BT_GANG then
		self._scene.file:write("GameViewLayer.cbActionCard: ",self.cbActionCard,"\n")
	end
	if tag == GameViewLayer.BT_START then
		print("麻将开始！")
		self.btStart:setVisible(false)
		if self.liushuiLayer and not tolua.isnull(self.liushuiLayer) then
			self.liushuiLayer:removeSelf()
		end
		self._scene:sendGameStart()
	elseif tag == GameViewLayer.BT_MENU then
		print("按钮开关")
		local menuBg = self:getChildByName("sp_tableBtBg")
		self:showMenu(not menuBg:isVisible())
	elseif tag == GameViewLayer.BT_CHAT then
		print("聊天！")
		self._chatLayer:showGameChat(true)
		self:showMenu(false)
	elseif tag == GameViewLayer.CBX_SOUNDOFF then
		print("设置开关！")
		local set = SettingLayer:create( self )
        self:addChild(set, GameViewLayer.ZORDER_SETTING)
	elseif tag == GameViewLayer.BT_HOWPLAY then
		print("玩法！")
		self._scene._scene:popHelpLayer2(391, 0)
        --self._scene._scene:popHelpLayer(yl.HTTP_URL .. "/Mobile/Introduce.aspx?kindid=391&typeid=0")
	elseif tag == GameViewLayer.BT_EXIT then
		print("退出！")
		self._scene:onQueryExitGame()
	elseif tag == GameViewLayer.BT_TRUSTEE then
		print("托管")
		self._scene:sendUserTrustee()
		self:ShowGameBtn(GameLogic.WIK_NULL)
	elseif tag == GameViewLayer.BT_PENG then
		print("碰！")

		--发送碰牌
		local cbOperateCard = self.cbActionCard
		self._scene:sendOperateCard(GameLogic.WIK_PENG, cbOperateCard)

		self:ShowGameBtn(GameLogic.WIK_NULL)
	elseif tag == GameViewLayer.BT_GANG then
		print("杠！")
		local cbOperateCard =self.cbActionCard
		self._scene:sendOperateCard(GameLogic.WIK_GANG, cbOperateCard)

		self:ShowGameBtn(GameLogic.WIK_NULL)
	elseif tag == GameViewLayer.BT_HU then
		print("胡！")

		local cbOperateCard = self.cbActionCard
		self._scene:sendOperateCard(GameLogic.WIK_CHI_HU, cbOperateCard)

		self:ShowGameBtn(GameLogic.WIK_NULL)
	elseif tag == GameViewLayer.BT_GUO then
		print("过！")
		if not self._cardLayer.bChoosingOutCard then
			self._scene:sendOperateCard(GameLogic.WIK_NULL, 0)
		end

		self:ShowGameBtn(GameLogic.WIK_NULL)
	else
		print("default")
	end
end

function GameViewLayer:disableOpereteBtn()
	local OpNode = self:getChildByName("FileNode_Op")
	local btGang = OpNode:getChildByName("Button_gang") 	--杠
	local btPeng = OpNode:getChildByName("Button_pen") 	--碰
	local btHu = OpNode:getChildByName("Button_hu") 	--胡
	btGang:setEnabled(false)
	btPeng:setEnabled(false)
	if OpNode:isVisible() and not btHu:isEnabled() then
		OpNode:setVisible(false)
	end
end

--更新操作按钮状态
function GameViewLayer:ShowGameBtn(cbActionMask,cbActionCard)
	--assert(cbActionCard~=0)
	--self.cbActionCard=cbActionCard or self.cbActionCard
	--获取node
	local OpNode = self:getChildByName("FileNode_Op")
	local btGang = OpNode:getChildByName("Button_gang") 	--杠
	local btPeng = OpNode:getChildByName("Button_pen") 	--碰
	local btHu = OpNode:getChildByName("Button_hu") 	--胡
	local btGuo = OpNode:getChildByName("Button_guo") 	--过

	OpNode:setVisible(true)
	if cbActionMask == GameLogic.WIK_NULL or cbActionCard==nil or math.ceil(cbActionCard/16)==self._cardLayer.callcardKind then
		OpNode:setVisible(false)
		btGang:setEnabled(false)
		btPeng:setEnabled(false)
		btHu:setEnabled(false)
		btGuo:setEnabled(false)
		self.cbActionCard=GameLogic.WIK_NULL
		return
	end

	self.cbActionCard=cbActionCard
	--通过动作码，判断操作按钮状态
	if bit:_and(cbActionMask, GameLogic.WIK_GANG) ~= GameLogic.WIK_NULL then
		btGang:setEnabled(true)
	end

	if bit:_and(cbActionMask, GameLogic.WIK_PENG) ~= GameLogic.WIK_NULL then
		btPeng:setEnabled(true)
	end

	if bit:_and(cbActionMask, GameLogic.WIK_CHI_HU) ~= GameLogic.WIK_NULL then
		--showToast(self,"show 吃胡提示",3)
		btHu:setEnabled(true)
	end
	btGuo:setEnabled(true)
end

--玩家指向刷新
function GameViewLayer:OnUpdataClockPointView(viewId)
	local viewImage =
	{
		"game/point2.png",
		"game/point3.png",
		"game/point1.png",
		"game/point4.png",
		"game/point5.png",
	}
	--print("指针文件路径", viewImage[viewId])
	if not viewId or viewId == yl.INVALID_CHAIR then
	    self.userPoint:setVisible(false)
	else
		--通过ID设置纹理
		local sprPoint = cc.Sprite:create(viewImage[viewId])
		if nil ~=  sprPoint then
			self.userPoint:setSpriteFrame(sprPoint:getSpriteFrame())
			self.userPoint:setVisible(true)
		end
	end
end

function  GameViewLayer:setShowLabelClock(bShow)
	self.labelClock:setVisible(bShow)
end

 --设置转盘时间
 function GameViewLayer:OnUpdataClockTime(time)
 	if 10 > time then
 		self.labelClock:setString(string.format("0%d", time))
 	else
 		self.labelClock:setString(string.format("%d", time))
 	end
 end

--刷新剩余牌数
function GameViewLayer:onUpdataLeftCard( numCard )
	if numCard<0 then self.m_nLeftCard=self.m_nLeftCard+numCard
	else self.m_nLeftCard= numCard end
	 self.leftcardAtlas:setString(string.format("%d",self.m_nLeftCard))
end


--显示规则信息
function GameViewLayer:SetCellScore( cellScore)
	-- --底注
	-- local labelCellScore = self.gameInfoNode:getChildByName("AtlasLabel_cellscore")
	-- labelCellScore:setString(string.format("%d", cellScore))
end

function GameViewLayer:SetBankerUser(bankerViewId)
	if self.m_tabUserHead[bankerViewId] then
		self.m_tabUserHead[bankerViewId]:showBank(true)
	end
end

--显示出牌
function GameViewLayer:showOutCard(viewid, value, isShow)
	if not isShow then
		self.sprOutCardBg:setVisible(false)
		return
	end

	if nil == value then  --无效值
		return
	end

	local posOurCard =
	{
		cc.p(667, 230),
		cc.p(1085, 420),
		cc.p(260, 420),
		cc.p(667, 575)
	}
	print("玩家出牌， 位置，卡牌数值", viewid, value)
	self.sprOutCardBg:setVisible(isShow)
	self.sprOutCardBg:setPosition(posOurCard[viewid])
	--获取数值
	local cardIndex = GameLogic.SwitchToCardIndex(value)
	local sprPath = "card/my_normal/tile_me_"
	if cardIndex < 10 then
		sprPath = sprPath..string.format("0%d", cardIndex)..".png"
	else
		sprPath = sprPath..string.format("%d", cardIndex)..".png"
	end
	local spriteValue = display.newSprite(sprPath)
	--获取精灵
	local sprCard = self.sprMajong:getChildByName("card_value")
	if nil ~= sprCard then
		sprCard:setSpriteFrame(spriteValue:getSpriteFrame())
	end
end

--用户操作动画
function GameViewLayer:showOperateAction(viewId, charttype)
	-- body
	local posACtion =
	{
		cc.p(667, 230),
		cc.p(1085, 420),
		cc.p(260, 420),
		cc.p(667, 575)
	}
	local strPath=string.format("game/op%d.png",charttype)

	local spr = cc.Sprite:create(strPath)
	if spr==nil then return end
	spr:addTo(self, GameViewLayer.ZORDER_ACTION)
	spr:setPosition(posACtion[viewId])
	if charttype~=64 then
		spr:runAction(cc.Sequence:create(cc.FadeTo:create(1.5,0),cc.RemoveSelf:create()))
	else
		LogAsset:getInstance():logData("husignB", true)
		spr:runAction(cc.Sequence:create(cc.FadeTo:create(1.5,0),self:showHuSign(viewId),cc.RemoveSelf:create()))
	end
	self.operateResultSp=spr
end

function GameViewLayer:showHuSign(viewId)
	local posACtion =
	{
		cc.p(667, 130),
		cc.p(1185, 420),
		cc.p(200, 420),
		cc.p(667, 655)
	}
	local strPath=string.format("game/husign.png",charttype)

	local spr = cc.Sprite:create(strPath)
	if spr==nil then return end
	spr:addTo(self, GameViewLayer.ZORDER_HUSIGN)
	spr:setPosition(posACtion[viewId])
	self.husigns[viewId]=spr
end

--显示荒庄
function GameViewLayer:showNoWin( isShow )
	self.sprNoWin:setVisible(isShow)
end

--开始
function GameViewLayer:gameStart(startViewId, cbCardData, cbCardCount, cbUserAction)

	for i=1,cmd.GAME_PLAYER do
		self:showUserState(i, false)
	end
	assert(self.m_nLeftCard==108)
	self:OnUpdataClockPointView(5)
	self.labelClock:setVisible(false)

	--每次发四张,第四次一张
	local viewid = startViewId
	local tableView = {1, 2, 4, 3} --对面索引为3
	local cardIndex = 1 --读取自己卡牌的索引
	local actionList = {}

	local function callbackWithArgs(viewid, myCardDate, cardCount)
          local ret = function ()
          	self._cardLayer:sendCardToPlayer(viewid, myCardDate, cardCount)
          	self.m_nLeftCard=self.m_nLeftCard-cardCount
          	self:onUpdataLeftCard(self.m_nLeftCard)
          end
          return ret
    end

	for i=1,4 do
		local cardCount = (i == 4 and 1 or 4)
		for k=1,cmd.GAME_PLAYER do

			if 5 == viewid then
				viewid = 1
			end
			local myCardDate = {}
			if viewid == cmd.MY_VIEWID  then
				for j=1,cardCount do
					print("开始发牌,我的卡牌", cardIndex, cbCardData[cardIndex])
					myCardDate[j] = cbCardData[cardIndex]
					cardIndex = cardIndex +1
				end
			end

	        local callFun = cc.CallFunc:create(callbackWithArgs(tableView[viewid], myCardDate, cardCount))
	        table.insert(actionList, cc.DelayTime:create(0.5))
	        table.insert(actionList, callFun)
		    --如果是我要发卡牌信息过去
			viewid = viewid +1
		end
	end
	--发完手牌给庄家发牌
	local myCardDate = {}
	if startViewId == cmd.MY_VIEWID then
		myCardDate[1] = cbCardData[14]
	end

	local callFun = cc.CallFunc:create(callbackWithArgs(startViewId, myCardDate, 1))
	table.insert(actionList, cc.DelayTime:create(0.5))
    table.insert(actionList, callFun)
    table.insert(actionList, cc.DelayTime:create(0.5))

  	if self._scene.bHuanSanZhang==true then
  		table.insert(actionList,cc.CallFunc:create(function()
  			self._scene:SetGameClock(cmd.MY_VIEWID,cmd.IDI_CHANGE_CARD,5)
  			self:OnUpdataClockTime(5)
  			self.labelClock:setVisible(true)
  			self:showChangCardHint(true)
  		end))
  	else
    	--弹出选缺提示
   	 	table.insert(actionList,cc.CallFunc:create(function()
   	 		self._scene:SetGameClock(cmd.MY_VIEWID,cmd.IDI_CALL_CARD,5)
   	 		self:OnUpdataClockTime(5)
   	 		self.labelClock:setVisible(true)
   	 		self:showCallCardHint()
   	 	end))
	end
	self:runAction(cc.Sequence:create(actionList))
end

function GameViewLayer:showPlayRule(bHuanSanZhang,bHuJiaoZhuanYi)
	local str=""
	if bHuanSanZhang==true then str="换三张 " end
	if bHuJiaoZhuanYi==true then str=str.."呼叫转移" end
	if str~="" then str="本局玩法："..str end
	self:getChildByName("Text_playrule"):setString(str)
end

--用户出牌
function GameViewLayer:gameOutCard(viewId, card)

	print("用户出牌", viewId, card)
	self:showOutCard(viewId, card, true) --展示出牌
	if viewId ~= cmd.MY_VIEWID then
		self._cardLayer:outCard(viewId, card)
	elseif self._scene.m_bTrustee then
		self._cardLayer:outCardTrustee(card)
	--else
		--assert(false) --调试，自己不主动出牌时不应该执行到这里。 如果服务端发送sendcard到托管玩家，客户端在服务端给托管玩家发送outcard之前取消了托管。导致outcard消息到达时已经非托管状态
	end

	self.cbOutCardTemp = card
	self.cbOutUserTemp = viewId
	--self._cardLayer:discard(viewId, card)
end

function GameViewLayer:showGangScore(scores) --分数飘字
	local function formatScore(score) --+(-)替换成. ,替换成/          ./0的string.byte()值依次递增1
		local str=""
		if score==0 then return ".0" end
		if score<0 then score=-score end
		while score>0 do
			if score>=1000 then
				local r=score%1000
				if r<10 then r="00"..r elseif r<100 then r="0"..r end
				str="/"..r..str
				score=math.floor(score/1000)
			else
				str=score..str
				break
			end
		end
		str="."..str
		return str
	end

	local tabcorePos={cc.p(660,200),cc.p(990,475),cc.p(300,475),cc.p(660,570)}
	for i=1,cmd.GAME_PLAYER do
		local filepath="game/winscore_digits.png"
		if scores[i]<0 then filepath="game/lostscore_digits.png" end
		if scores[i]~=0 then
			local scoreLabel=cc.LabelAtlas:create(formatScore(scores[i]),filepath,46,88,string.byte('.')):addTo(self,1000)
			scoreLabel:setAnchorPoint(cc.p(0.5,0.5))
			scoreLabel:setPosition(tabcorePos[self._scene:SwitchViewChairID(i-1)])
			local moveAct=cc.MoveBy:create(2,cc.p(5,50)) --JumpBy
			local removeAct=cc.CallFunc:create(function() scoreLabel:removeSelf() end)
			scoreLabel:runAction(cc.Sequence:create(moveAct,removeAct))
		end
	end
end

function GameViewLayer:setCallCardKind(viewid,callCardKind)--都选完缺了
	if callCardKind~=nil then --头像上显示选缺种类
		self:calledCard(viewid,callCardKind)
	end
end

function GameViewLayer:showChangCardHint(bShow)
	if false== bShow then
		self.changeCardBg:setVisible(false)
		self._cardLayer:finishChangeCard()
	else
		self.changeCardBg:setVisible(true)
		self._cardLayer:startChangeCard()
	end
end


function GameViewLayer:getMyHandCards()
	return self._cardLayer.cbCardData[cmd.MY_VIEWID]
end

function GameViewLayer:showDuiJuLiuShui(tagCharts)

	--local tagChart={charttype=cmd.CHARTTYPE.HUJIAOZHUANYI_TYPE,lTimes=200,lScore=0,bEffectChairID={true,true,true,true}}
	--local tagChart2={charttype=cmd.CHARTTYPE.HUJIAOZHUANYI_TYPE,lTimes=200,lScore=20000,bEffectChairID={true,true,true,true}}
	--tagCharts={tagChart,tagChart,tagChart,tagChart,tagChart,tagChart,tagChart2,tagChart,tagChart,tagChart,tagChart2}

	print("me:",GlobalUserItem.szNickName)
	print("#self.myTagCharts:",#tagCharts)

	local temp={}
	for i=1,#tagCharts do
		print("self.myTagCharts"..i..".charttype:", tagCharts[i].charttype)
		local tagChart=tagCharts[i]
		if tagChart and tagChart.lScore~=0 and tagChart.charttype~=cmd.CHARTTYPE.INVALID_CHARTTYPE then
			table.insert(temp,tagChart)
		end
	end
	tagCharts=temp

	--assert(false)


	local liushuiLayer=cc.CSLoader:createNode("game/Layer_liushui.csb")
	liushuiLayer.onTouchBegan=function(node,touch, event)  return true end
	liushuiLayer.onTouchEnded=function(node,touch, event)
    	local pos = touch:getLocation()
    	local m_spBg = node:getChildByName("bg")
   		 pos = m_spBg:convertToNodeSpace(pos)
    	local rec = cc.rect(0, 0, m_spBg:getContentSize().width, m_spBg:getContentSize().height)
    	if false == cc.rectContainsPoint(rec, pos) then
        	node:removeFromParent()
    	end
	end

	ExternalFun.registerTouchEvent(liushuiLayer, true)
	self:addChild(liushuiLayer,self.ZORDER_LIUSHUI)

	if tagCharts==nil or #tagCharts==0 then return end

	local totalScore=0
	for i=1,#tagCharts do
		totalScore=totalScore+tagCharts[i].lScore
	end
	if totalScore>=0 then
    	totalScore="+"..totalScore
    end

    liushuiLayer:getChildByName("curScore"):setString(totalScore)

    self.liushuiLayer=liushuiLayer

	local function numberOfCellsInTableView()
		local n=0
		for k,tagChart in pairs(tagCharts) do
			if tagChart.charttype~=cmd.CHARTTYPE.INVALID_CHARTTYPE  then
				n=n+1
			end
		end
		return n
	end

	local function cellSizeForTable(view,idx)
    	return 600,56
	end

	local function tableCellAtIndex(view, idx) --idx从0开始
		local tagChart=tagCharts[idx+1]
     	local cell=view:dequeueCell()
    	if nil==cell then
    		cell=cc.TableViewCell:create()
    	end
    	if cell:getChildByTag(1)==nil and tagChart~=nil then
    		cc.CSLoader:createNode("game/Node_liushui_list.csb")
    			:addTo(cell)
    			:setTag(1)
    			:setPosition(9,5)
    	end
    	if tagChart==nil or tagChart.charttype==cmd.CHARTTYPE.INVALID_CHARTTYPE  then cell:removeAllChildren() return cell end
    	print("tagChart.charttype:",tagChart.charttype)
    	local node=cell:getChildByTag(1)
    	node:getChildByName("kind"):setString(cmd.CHARTTYPESTR[tagChart.charttype-21])
    	node:getChildByName("times"):setString(tagChart.lTimes.."倍")
    	local score=tagChart.lScore
    	if score>=0 then
    		score="+"..score
    		node:getChildByName("score"):setTextColor(cc.c4b(0xc0,0x4d,0x45,0xff))
    	else
    		node:getChildByName("score"):setTextColor(cc.c4b(0x58,0x6e,0xbe,0xff))
    	end
    	node:getChildByName("score"):setString(score)
    	local strs={}
    	local objs={"","下家","上家","对家"}
    	local t=tagChart
    	print("tagChart.charttype:",tagChart.charttype)
    	print(t.charttype,t.lTimes,t.lScore,t.bEffectChairID[1],t.bEffectChairID[2],t.bEffectChairID[3],t.bEffectChairID[4])

    	print("对局流水：")
    	for i=1,cmd.GAME_PLAYER do
    		if tagChart.bEffectChairID[i]==true then
    			local viewid=self._scene:SwitchViewChairID(i-1)
    			print("effect viewID: ",viewid)
   				if viewid~=cmd.MY_VIEWID then table.insert(strs,objs[viewid]) end
   			end
    	end
    	node:getChildByName("obj"):setString(table.concat(strs, "、"))
    	return cell
     end

    local tableView=cc.TableView:create(cc.size(600,350))
	tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setPosition(cc.p(30,26))
    tableView:setDelegate()
    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    tableView:reloadData()
    tableView:setVerticalFillOrder(0)
    tableView:addTo(liushuiLayer:getChildByName("bg"))
end

function GameViewLayer:setTrustee(bTrustee)
	self.TrustShadow:setVisible(bTrustee)
end
--用户抓牌
function GameViewLayer:gameSendCard(viewId, card,bTrustee)
	if viewId==cmd.MY_VIEWID then
		print("MY_VIEWID GameViewLayer:gameSendCard:",card)
	end
	--发牌
	if viewId == cmd.MY_VIEWID then
		self._cardLayer:setMyCardTouchEnabled(true)
	end
	self._cardLayer:sendCardToPlayer(viewId, {card}, 1,bTrustee)
end

return GameViewLayer
