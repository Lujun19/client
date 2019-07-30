--
-- Author: Tang
-- Date: 2016-10-11 17:22:24
--

--[[

	游戏交互层
]]

local GameViewLayer = class("GameViewLayer",function(scene)
		local gameViewLayer =  display.newLayer()
    return gameViewLayer
end)
local module_pre = "game.yule.luxurycar.src"

--external
--
local ExternalFun = require(appdf.EXTERNAL_SRC .. "ExternalFun")
local g_var = ExternalFun.req_var
local ClipText = appdf.EXTERNAL_SRC .. "ClipText"
local PopupInfoHead = appdf.EXTERNAL_SRC .. "PopupInfoHead"
--
local  BankerList = module_pre..".views.layer.BankerList"
local  UserList = module_pre..".views.layer.UserList"
local  Chat = module_pre..".views.layer.Chat"
local cmd = module_pre .. ".models.CMD_Game"
local game_cmd = appdf.HEADER_SRC .. "CMD_GameServer"
local QueryDialog   = require("app.views.layer.other.QueryDialog")
GameViewLayer.RES_PATH 				= "game/yule/luxurycar/res/"
local scheduler = cc.Director:getInstance():getScheduler()
local ControlLayer = module_pre..".views.layer.ControlLayer"
local AnimationRes = 
{
	{name = "TimeAnimation", file = GameViewLayer.RES_PATH.."game_res/lightStar/lightStar_", nCount = 46, fInterval = 0.05, nLoops = 10},
}
local appConfigProxy = AppFacade:getInstance():retrieveProxy("AppConfigProxy")
local TAG_ZORDER = 
{	
	CLOCK_ZORDER = 10,
	BANK_ZORDER	 = 30,
	CONTROL_ZORDER = 31
}

local TAG_ENUM = 
{
	TAG_USERNICK = 1,
	TAG_USERSCORE = 2
}


--申请庄家
GameViewLayer.unApply = 0	--未申请
GameViewLayer.applyed = 1	--已申请

function GameViewLayer:ctor(scene)

	self._scene = scene
	self.oneCircle	= 16		--一圈16个豪车
	self.index = 2				--豪车索引	
 	self.time = 0.08			--转动时间间隔
 	self.count = 0				--转动次数
 	self.endindex = -1			--停止位置
 	self.JettonIndex = -1
 	self.bContinueRecord = true  
 	self.bAnimate		 = false

 	self._bank = nil             --银行
 	self._bankerView= nil        --上庄列表
 	self._UserView = nil         --玩家列表
 	self._ChatView = nil         --聊天
	self.strAnimate = nil		 --动画
	self.m_rankTopNode = {}
	self.m_rankHead = {}
	self.m_rankTopUser = {}
 	self.m_eApplyStatus = GameViewLayer.unApply
	self._lBankerScore = 0
	self._lUserScore = 0
	self.m_schedulerupdata = nil
		--控制层
	self.m_controlLayer = nil
	self.m_bIsGameCheatUser = false
	self.m_UserPerformance = 0;
	self:gameDataInit()

	--初始化csb界面
	self:initCsbRes()

	self:initTableJettons({0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0})

	self:showMyselfInfo()

	self:initTableview()
	
	
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
	

	
	 --注册事件
 	 ExternalFun.registerTouchEvent(self,true)
	
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
function GameViewLayer:restData()
	self.index = 2			
 	self.time = 0.08
 	self.count = 0
 	self.endindex = -1
 	self.bAnimate = true
 	self:SetJettonIndex(-1)
 	self:initTableJettons({0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0})
 	if self:GetJettonRecord() == 0 then
 		self.bContinueRecord = true
 	else
 		self.bContinueRecord = false
 	end

end
function GameViewLayer:setTimePer()
	local percent = self._scene.m_cbLeftTime / 20

	self.time = self.time * percent
end

function GameViewLayer:gameDataInit(  )
	--搜索路径
	--appConfigProxy._gameList[1]
    local gameList = appConfigProxy._gameList;
    local gameInfo = {};
    for k,v in pairs(gameList) do
        if tonumber(v._KindID) == tonumber(g_var(cmd).KIND_ID) then
            gameInfo = v;
            break;
        end
    end

    --播放背景音乐
	AudioEngine.playMusic(cc.FileUtils:getInstance():fullPathForFilename("sound_res/BACK_GROUND_DRAW.wav"),true)

	if not GlobalUserItem.bVoiceAble then
		
		AudioEngine.setMusicVolume(0)
		AudioEngine.pauseMusic() -- 暂停音乐
	end

    --加载资源
	self:loadRes()

end

function GameViewLayer:getParentNode( )
	return self._scene;
end

function GameViewLayer:getDataMgr( )
	return self:getParentNode():getDataMgr()
end

function GameViewLayer:showPopWait( )
	self:getParentNode():showPopWait()
end

function GameViewLayer:loadRes()

end
--更新用户显示
function GameViewLayer:OnUpdateUserStatus(viewId)
	
end
function GameViewLayer:initTableview()
	local bankerBG =  self._rootNode:getChildByName("zhuang_listBG")
	self._bankerView = g_var(BankerList):create(self._scene._dataModle)
	self._bankerView:setContentSize(cc.size(260, 310))
	self._bankerView:setAnchorPoint(cc.p(0.0,0.0))
	self._bankerView:setPosition(cc.p(10, 21))
	bankerBG:addChild(self._bankerView)


end
function GameViewLayer:showMyselfInfo()

	local useritem = self._scene:GetMeUserItem()

	--玩家头像
	local head = g_var(PopupInfoHead):createClipHead(useritem, 83)
	head:setPosition(49,46)
	self:addChild(head)
	head:enableInfoPop(true)

	--玩家昵称
	local nick =  g_var(ClipText):createClipText(cc.size(300, 30),useritem.szNickName,"base/res/fonts/round_body.ttf", 30);
	nick:setAnchorPoint(cc.p(0.0,0.5))
	nick:setPosition(120, 70)
	self:addChild(nick)

--[[	local nickName = ClipText:createClipText(cc.size(150,30), useritem.szNickName, "base/res/fonts/round_body.ttf", 30)
	nickName:setTextColor(cc.c4b(41,82,146,255));
	nickName:setAnchorPoint(cc.p(0,0.5))
	nickName:setPosition(cc.p(200,yPos + 20))
	self:addChild(nickName)--]]


	--用户游戏币
	self.m_scoreUser = 0
	
	if nil ~= useritem then
		self.m_scoreUser = useritem.lScore;
	end	

	local str = ExternalFun.numberThousands(0)
	if string.len(str) > 11 then
		str = string.sub(str,1,11) .. "...";
	end

	local coin =  cc.Label:createWithTTF(str, "base/res/fonts/round_body.ttf", 30)
	--coin:setTextColor(cc.c3b(71,255,255))
	coin:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
	coin:setTag(TAG_ENUM.TAG_USERSCORE)
	coin:setAnchorPoint(cc.p(0.0,0.5))
	coin:setPosition(180, 28)
	self:addChild(coin)
	
	

	
end

function GameViewLayer:updateScore(score)   --更新分数
	self.m_scoreUser = score
	local str = ExternalFun.numberThousands(self.m_scoreUser);
	if string.len(str) > 11 then
		str = string.sub(str,1,11) .. "...";
	end

	local userScore = self:getChildByTag(TAG_ENUM.TAG_USERSCORE)
	userScore:setString(str)
end

---------------------------------------------------------------------------------------
--界面初始化
function GameViewLayer:initCsbRes()
	local rootLayer, csbNode = ExternalFun.loadRootCSB("game_res/Game.csb",self)
	self._rootNode = csbNode
	self:resetRollCarPos()

	self:setClockTypeIsVisible(false)
	self:initButtons()
	
end

function GameViewLayer:initButtons()  --初始化按钮
	
	--银行
	local function callfunc(ref,eventType)
        if eventType == ccui.TouchEventType.ended then
       		self:btnBankEvent(ref, eventType)
        end
    end

   --银行
	local btn =  self._rootNode:getChildByName("btn_bank")
	btn:addTouchEventListener(callfunc)

	btn = self._rootNode:getChildByName("btn_add")
	btn:addTouchEventListener(callfunc)


--上庄列表
	local banker = self._rootNode:getChildByName("btn_zhuang")
	banker:addTouchEventListener(function (ref,eventType)
            if eventType == ccui.TouchEventType.ended then
           		self:BankerEvent(ref, eventType)
            end
        end)

	self:InitBankerInfo()

	local str = ""
	for i=1,6 do
		str = string.format("totle_bet_%d", i)
		self.m_rankTopNode[i] = self._rootNode:getChildByName(str)
		self.m_rankTopNode[i]:setTag(i)
		--self.m_rankTopNode[i]:setVisible(false)
	end
	
--玩家列表
--[[  local userlist = self._rootNode:getChildByName("btn_userlist")
  userlist:addTouchEventListener(function (ref,eventType)
            if eventType == ccui.TouchEventType.ended then
           		self:UserListEvent(ref, eventType)
            end
        end)--]]
		
--聊天
    local chat = self._rootNode:getChildByName("btn_chat")
    chat:addTouchEventListener(function (ref,eventType)
            if eventType == ccui.TouchEventType.ended then
           		self:ChatEvent(ref, eventType)
            end
        end)

	--下注筹码
	local addview = self._rootNode:getChildByName("Panel_roll")
	for i=1,g_var(cmd).JETTON_COUNT do
		local btn = self._rootNode:getChildByName(string.format("bet_%d", i))
		btn:setTag(100+i)
		btn:setEnabled(false)
		btn:addTouchEventListener(function (ref,eventType)
            if eventType == ccui.TouchEventType.ended then
           		self:JettonEvent(ref, eventType)
            end
        end)
	end

	--游戏记录
	local record = self._rootNode:getChildByName("btn_record")
	record:addTouchEventListener(function (ref,eventType)
            if eventType == ccui.TouchEventType.ended then
           		self:ShowRecord()
            end
        end)
		
	--游戏记录
	local record = self._rootNode:getChildByName("btnSetting")
	record:addTouchEventListener(function (ref,eventType)
            if eventType == ccui.TouchEventType.ended then
           		self:ShowSetting()
            end
        end)
		
	--续压按钮
	local continueBtn =  self._rootNode:getChildByName("btn_continue")
	continueBtn:setEnabled(false)
	continueBtn:addTouchEventListener(function (ref,eventType)
            if eventType == ccui.TouchEventType.ended then
           		self:ContinueEvent(ref, eventType)
            end
        end)

	--申请庄家
	local bankerBG =  self._rootNode:getChildByName("zhuang_listBG")
	bankerBG:setVisible(false)
	local applyBtn = bankerBG:getChildByName("btn_apply")
	applyBtn:addTouchEventListener(function (ref,eventType)
            if eventType == ccui.TouchEventType.ended then
           		self:ApplyEvent(ref, eventType)
            end
        end)

	local bankerBG =  self._rootNode:getChildByName("zhuang_listBG")
	bankerBG:setVisible(false)
	local btclose = bankerBG:getChildByName("zhuangclose")
	btclose:addTouchEventListener(function (ref,eventType)
            if eventType == ccui.TouchEventType.ended then
           		--关闭上庄列表界面
				local bankerView = self._rootNode:getChildByName("zhuang_listBG")
				bankerView:setVisible(false)
            end
        end)
		
	--控制按钮
	local btncontrol = self._rootNode:getChildByName("Button_control");
	btncontrol:addTouchEventListener(function (ref,eventType)
		if eventType == ccui.TouchEventType.ended then
			if self.m_bIsGameCheatUser == false then
				return
			else
				if nil ~= self.m_controlLayer then
					self.m_controlLayer:setVisible(true)
				end
			end
		end
	end)
		

	--下注区域
	for i=1,g_var(cmd).AREA_COUNT do
		local btn = addview:getChildByName(string.format("bet_area_%d", i))
		btn:setTag(200+i)
		btn:addTouchEventListener(function (ref,eventType)
            if eventType == ccui.TouchEventType.ended then
            	if self:GetJettonIndexInvalid() then
--[[            		local circle = addview:getChildByName(string.format("circle_%d",i))
           			circle:runAction(cc.Blink:create(0.2, 1))--]]

           			self:PlaceJettonEvent(ref,eventType)
           		else
           				if self.m_cbGameStatus == g_var(cmd).GS_PLACE_JETTON then
           					local runScene = cc.Director:getInstance():getRunningScene()
							showToast(runScene, "请选择目标筹码", 1)	
           				end
            	end
            end
        end)
	end


    --开始动画
    self._csbGameStart = cc.CSLoader:createNode("game_res/GameStarEnd.csb")
	:addTo(self, 1)
	local TxtStarEndAnimate  = self._csbGameStart:getChildByName("GameStarEnd")
	local TxtStarEndAnimatebg = TxtStarEndAnimate:getChildByName("TxtStarEndAnimate")
	self.TxtStarEndAnimatebg_2 = TxtStarEndAnimatebg:getChildByName("txtStar_7")
	--sele.TxtStarEndAnimatebg_2:setTexture("game_res/image/GameStar_End/txtStop.png")

    self._csbstart = ExternalFun.loadTimeLine("game_res/GameStarEnd.csb")
    self._csbGameStart:runAction(self._csbstart)
    self._csbGameStart:move(display.width/2, display.height/2)
    self._csbGameStart:setVisible(false)
	
	--转盘背景
    self._csbBetBg = cc.CSLoader:createNode("game_res/BetBg.csb")
	:addTo(self, 1)
    self._csbBetBgLine = ExternalFun.loadTimeLine("game_res/BetBg.csb")
    self._csbBetBg:runAction(self._csbBetBgLine)
    self._csbBetBg:move(655,400)
    --self._csbBetBg:setVisible(false)
	
	self._csbBetBg:setVisible(true)
    self._csbBetBgLine:play("BetBgAnimate", true)

	
    --开奖结束动画
    self._csbBigCar = cc.CSLoader:createNode("game_res/BigCar.csb")
	:addTo(self, 1)
	
	local BigCarAnimate = self._csbBigCar:getChildByName("BigCarAnimate")
	local carName = BigCarAnimate:getChildByName("carName")
	self.carNameBC = carName:getChildByName("Sprite_14")
	
    self._csbbBigCarAnimate = ExternalFun.loadTimeLine("game_res/BigCar.csb")
    self._csbBigCar:runAction(self._csbbBigCarAnimate)
    self._csbBigCar:move(display.width/2, display.height/2)
    self._csbBigCar:setVisible(false)
	
	

	
	    --开奖结束动画
    self._csbSmallCar = cc.CSLoader:createNode("game_res/SmallCar.csb")
	:addTo(self, 1)
	
	local SmallBigCarAnimate = self._csbSmallCar:getChildByName("BigCarAnimate")
	local SmallcarName = SmallBigCarAnimate:getChildByName("carName")
	self.SmallcarNameBC = SmallcarName:getChildByName("nameBC_26")
	
    self._csbSmallCarAnimate = ExternalFun.loadTimeLine("game_res/SmallCar.csb")
    self._csbSmallCar:runAction(self._csbSmallCarAnimate)
    self._csbSmallCar:move(display.width/2, display.height/2)
    self._csbSmallCar:setVisible(false)
	
	
	
	--庄家输赢
	self.BankerWinScoreTTF = cc.Label:createWithTTF("0", "base/res/fonts/round_body.ttf", 35)
	self.BankerWinScoreTTF:setTag(1)
	self.BankerWinScoreTTF:setTextColor(cc.c3b(230,252,193))
	self.BankerWinScoreTTF:setAnchorPoint(cc.p(0.0,0.0))
	self.BankerWinScoreTTF:setPosition(800,600)
	self:addChild(self.BankerWinScoreTTF,10)
	self.BankerWinScoreTTF:setVisible(false)	
	--玩家输赢
	self.UserWinScoreTTF = cc.Label:createWithTTF("0", "base/res/fonts/round_body.ttf", 35)
	self.UserWinScoreTTF:setTag(2)
	self.UserWinScoreTTF:setTextColor(cc.c3b(230,252,193))
	self.UserWinScoreTTF:setAnchorPoint(cc.p(0.0,1.0))
	self.UserWinScoreTTF:setPosition(800,588)
	self:addChild(self.UserWinScoreTTF,10)
	self.UserWinScoreTTF:setVisible(false)	
		
	--返回按钮
	local menu = self._rootNode:getChildByName("menu_R")
	menu:setVisible(false)
	self.back = menu:getChildByName("btn_back")
	self.back:addTouchEventListener(function (ref,eventType)
            if eventType == ccui.TouchEventType.ended then
           		self._scene:onExitTable()
            end
        end)

	--控制层
	self.m_controlLayer = g_var(ControlLayer):create(self)
	self:addChild(self.m_controlLayer, TAG_ZORDER.CONTROL_ZORDER)
	self.m_controlLayer:setVisible(false)
	
	
	--用户列表
	self:getDataMgr():initUserList(self:getParentNode():getUserList())
	self:UpControlList()
	
	
	local userlistbg = self._rootNode:getChildByName("userlistbg")

	self._UserView = g_var(UserList):create(self._scene._dataModle)
	userlistbg:addChild(self._UserView)
	self._UserView:reloadData()
	
	
	local node = self._rootNode:getChildByName("User_Performance")
	local label = node:getChildByTag(2)
	if nil == label then
		label =  cc.Label:createWithTTF(string.formatNumberFhousands(self.m_UserPerformance), "base/res/fonts/round_body.ttf", 25)
		label:setAnchorPoint(cc.p(0.0,0.5))
		label:setTag(2)
		label:setTextColor(cc.c3b(0,255,42))
		label:setPosition(2, node:getContentSize().height/2)
		node:addChild(label)
	else
		label:setString(string.formatNumberFhousands(self.m_UserPerformance))
	end
		
	

	
	--音效
	local function Voice(bvoice,voiceBtn)
		if bvoice then
			voiceBtn:loadTextureNormal("game_res/anniu5.png")
		else
			voiceBtn:loadTextureNormal("game_res/anniu6.png")
		end
	end	
	

	
	local bvoice = 	GlobalUserItem.bVoiceAble
	local voiceBtn = menu:getChildByName("btn_sound")
	Voice(bvoice,voiceBtn)

	voiceBtn:addTouchEventListener(function (ref,eventType)
            if eventType == ccui.TouchEventType.ended then
           		GlobalUserItem.bVoiceAble = not GlobalUserItem.bVoiceAble
           		local bvoice = 	GlobalUserItem.bVoiceAble

           		if GlobalUserItem.bVoiceAble then
           			AudioEngine.resumeMusic()
					AudioEngine.setMusicVolume(1.0)		
				else
					AudioEngine.setMusicVolume(0)
					AudioEngine.pauseMusic() -- 暂停音乐
				end

           		Voice(bvoice,voiceBtn)
            end
        end)

end

function GameViewLayer:initTableJettons(table0,table1) --初始化下注区域筹码数目
	local addview = self._rootNode:getChildByName("Panel_roll")
	for i=1,g_var(cmd).AREA_COUNT do
		local jettonNode0 = addview:getChildByName(string.format("Node_%d_1", i))
		local jettonNode1 = addview:getChildByName(string.format("Node_%d_2", i))

		if nil == jettonNode0:getChildByTag(1) then
			local num = cc.Label:createWithTTF(string.format("%d",table0[i]), "base/res/fonts/round_body.ttf", 30)
			num:setAnchorPoint(cc.p(0.5,0.5))
			num:setTag(1)
			num:setPosition(cc.p(jettonNode0:getContentSize().width/2,jettonNode0:getContentSize().height/2))
			jettonNode0:addChild(num)
		else
			local num = jettonNode0:getChildByTag(1)
			num:setString(string.format("%d",table0[i]))

		end

		if nil == jettonNode1:getChildByTag(1) then
			local num = cc.Label:createWithTTF(string.format("%d",table1[i]), "base/res/fonts/round_body.ttf", 30)
			num:setAnchorPoint(cc.p(0.5,0.5))
			num:setTextColor(cc.c3b(255,254,143))
			num:setTag(1)
			num:setPosition(cc.p(jettonNode1:getContentSize().width/2,jettonNode1:getContentSize().height/2))
			jettonNode1:addChild(num)
		else
			local num = jettonNode1:getChildByTag(1)
			num:setString(string.format("%d",table1[i]))
		end
	end
end

--校准位置
function GameViewLayer:resetRollCarPos()

--[[	local RollPanel = self._rootNode:getChildByName("Panel_roll")
	--转盘半径
 	local radius = 295
 	local center = cc.p(RollPanel:getContentSize().width/2,RollPanel:getContentSize().height/2)--]]


--获取转盘上的车
--[[	for i=1,self.oneCircle do
		 local radian = math.rad(22.5*(i-1))
		 local x = radius * math.sin(radian);
   		 local y = radius * math.cos(radian);
 		local car = RollPanel:getChildByName(string.format("car_index_%d",i))
 		car:setPosition(center.x + x, center.y + y)
 	end--]]


end

--启动转动动画
function GameViewLayer:rollAction()
	local RollPanel = self._rootNode:getChildByName("Panel_roll")
	if nil == RollPanel then
		print("RollPanel is nil .....")
	end

 	self.points = {}
 	for i=1,self.oneCircle do
 		local car = RollPanel:getChildByName(string.format("car_index_%d",i))
 		local pos = cc.p(car:getPositionX(),car:getPositionY())
 		table.insert(self.points, pos)
 	end
 	
 	self.count = 0
 	self:setTimePer()
 	self:RunCircleAction()

end

--初始化菜单按钮
function GameViewLayer:InitMenu()
	
end

function GameViewLayer:onResetView()

	self:gameDataReset()
end

function GameViewLayer:onExit()
	self:onResetView()
	if nil ~= self.m_schedulerupdata then
		print("stop dispatch")
		scheduler:unscheduleScriptEntry(self.m_schedulerupdata)
		self.m_schedulerupdata = nil
	end
end


function GameViewLayer:gameDataReset(  )
	--资源释放

	--播放大厅背景音乐
	ExternalFun.playPlazzBackgroudAudio()

	--重置搜索路径
	local oldPaths = cc.FileUtils:getInstance():getSearchPaths();
	local newPaths = {};
	for k,v in pairs(oldPaths) do
		if tostring(v) ~= tostring(self._searchPath) then
			table.insert(newPaths, v);
		end
	end
	cc.FileUtils:getInstance():setSearchPaths(newPaths);

end
----------------------------------------------------------------------------------------
--庄家信息
function GameViewLayer:InitBankerInfo()
	--昵称
	--local bankerBG =  self._rootNode:getChildByName("zhuang_listBG")

--[[	local info = {"昵称:","成绩:","筹码:","当前庄数:"}

	for i=1,4 do
		local node = self._rootNode:getChildByName(string.format("Node_%d", i))
		local lb =  cc.Label:createWithTTF(info[i], "base/res/fonts/round_body.ttf", 20)
		lb:setAnchorPoint(cc.p(1.0,0.5))
		lb:setTextColor(cc.c3b(36,236,255))
		lb:setPosition(node:getContentSize().width + 60, node:getContentSize().height/2)
		node:addChild(lb)
	end--]]
end

--更新庄家信息
function GameViewLayer:ShowBankerInfo(info)
	if type(info) ~= "table"  then
		print("the error param")
		return
	end

	local bankerBG =  self._rootNode:getChildByName("BankerInfo")
	local colors = {cc.c3b(255,255,255),cc.c3b(0,255,42),cc.c3b(255,204,0),cc.c3b(0,255,210)}

	--昵称、成绩、筹码、当前庄数
	for i=1,4 do
		local node = bankerBG:getChildByName(string.format("Node_%d_1", i))
		local label = node:getChildByTag(2)
		if nil == label then
			if 1 == i then
				label =  g_var(ClipText):createClipText(cc.size(160, 20),info[i])
			else
				label =  cc.Label:createWithTTF(info[i], "base/res/fonts/round_body.ttf", 25)
			end
			
			label:setAnchorPoint(cc.p(0.0,0.5))
			label:setTag(2)
			label:setTextColor(colors[i])
			label:setPosition(2, node:getContentSize().height/2)
			node:addChild(label)
		else
			label:setString(info[i])
		end
	end

	--玩家头像
		local headBG = ccui.ImageView:create("game_res/head_frame.png")
		headBG:setAnchorPoint(cc.p(0.0,1.0))
		headBG:setScale(0.6)
		headBG:setPosition(cc.p(45,bankerBG:getContentSize().height))
		bankerBG:addChild(headBG)

		local  useritem = info[5]
		if nil == useritem then
			local head = g_var(PopupInfoHead):createClipHead(nil, 115)
			head:setPosition(cc.p(headBG:getContentSize().width/2 + 2,headBG:getContentSize().height/2))
			head:setTag(1)
			headBG:addChild(head)
			
			local headBG_1 = ccui.ImageView:create("game_res/head_frame.png")
			headBG_1:setAnchorPoint(cc.p(0.0,1.0))
			headBG_1:setScale(0.6)
			headBG_1:setPosition(cc.p(45,bankerBG:getContentSize().height))
			bankerBG:addChild(headBG_1)
		
			return
		end

		local head = g_var(PopupInfoHead):createClipHead(useritem, 115)
		head:setPosition(cc.p(headBG:getContentSize().width/2 + 2,headBG:getContentSize().height/2))
		head:setTag(1)
		headBG:addChild(head)
		
		local headBG_1 = ccui.ImageView:create("game_res/head_frame.png")
		headBG_1:setAnchorPoint(cc.p(0.0,1.0))
		headBG_1:setScale(0.6)
		headBG_1:setPosition(cc.p(45,self:getContentSize().height))
		headBG:addChild(headBG_1)
		
end
----------------------------------------------------------------------------------------

--游戏记录
function GameViewLayer:addRcord( cbCarIndex )
	if #self._scene.m_RecordList < g_var(cmd).RECORD_MAX then --少于8条记录
		
		table.insert(self._scene.m_RecordList, cbCarIndex)
	else
		--删除第一条记录
		table.remove(self._scene.m_RecordList,1)

		table.insert(self._scene.m_RecordList, cbCarIndex)

	end

	local record = self._rootNode:getChildByName("record_cell")
	if record:isVisible() then
		--刷新记录
		for i=1,#self._scene.m_RecordList do
			local cell = record:getChildByName(string.format("cell_%d", i))
			cell:loadTexture("game_res/"..string.format("cell_%d", self._scene.m_RecordList[i]))
		end
	end
end
function GameViewLayer:ShowSetting()
	local menu_R = self._rootNode:getChildByName("menu_R")
	if menu_R:isVisible() then
		menu_R:setVisible(false)
		menu_R:move(menu_R:getPositionX(), menu_R:getPositionY() + menu_R:getContentSize().height)
		return
	end
	menu_R:setVisible(true)
 	menu_R:move(menu_R:getPositionX(), menu_R:getPositionY() - menu_R:getContentSize().height)

	
end

function GameViewLayer:ShowRecord()
	local record = self._rootNode:getChildByName("record_cell")

	if record:isVisible() then
		record:setVisible(false)
		return
	end

	record:setVisible(true)

	dump(self._scene.m_RecordList, "self._scene.m_RecordList is ===================>", 6)
	
		--游戏记录
	local recordbtn = self._rootNode:getChildByName("btn_record")
		--刷新记录
	for i=1,3 do
		local recordcell = recordbtn:getChildByName(string.format("record_%d",i))
		recordcell:setVisible(false)
	end
	
	--刷新记录
	for i=1,12 do
		local cell = record:getChildByName(string.format("cell_%d",i))
		cell:setVisible(false)
	end
	local nIndex = 12;
	local recordnIndex = 3;
	--刷新记录
	for i=#self._scene.m_RecordList,1,-1 do
		if nIndex <= 0 then
			return
		end
		local viewIndex = 0
		local list = self._scene.m_RecordList[i]

		if list == 1 then 
		--宾利
			viewIndex = 0 
		elseif list == 2 or list == 12 or list == 16 then
			--宝马
			viewIndex = 1
			
		elseif list == 3 or list == 6 or list == 15 then
			--奔驰
			viewIndex = 2
		
		elseif list == 4 or list == 7 or list == 10 then
			--保时捷
			viewIndex = 3
			
		elseif list == 5 then
			--法拉利
			viewIndex = 4
			
		elseif list == 9 then
			--迈巴赫
			viewIndex = 6
			
		elseif list == 8 or list == 11 or list == 14 then
			--路虎
			viewIndex = 5
		
		elseif list == 13 then
			--布加迪
			viewIndex = 7
					
		end

		local cell = record:getChildByName(string.format("cell_%d",nIndex))
		cell:loadTexture("game_res/"..string.format("record_%d.png",viewIndex))
		cell:setVisible(true)
		nIndex = nIndex -1
		
		if recordnIndex > 0 then
			local recordcell = recordbtn:getChildByName(string.format("record_%d",recordnIndex))
			recordcell:loadTexture("game_res/"..string.format("record_%d.png",viewIndex))
			recordcell:setVisible(true)
			recordnIndex = recordnIndex -1
		end
	end

end

--更新区域筹码
function GameViewLayer:UpdateAreaJetton()
	
	local table = self:ConvertToViewAreaIndex(self._scene.m_lAllJettonScore)
	self:initTableJettons(table,self._scene.m_lCurrentAddscore)

end

--转换成视图索引
function GameViewLayer:ConvertToViewAreaIndex(param)
	if type(param) ~= "table"  or #param ~= g_var(cmd).AREA_COUNT then
		return
	end

	local table = {0,0,0,0,0,0,0,0}
	

	table[1] = param[g_var(cmd).ID_BENTLEY]
	table[2] = param[g_var(cmd).ID_BMW]
	table[3] = param[g_var(cmd).ID_BENCHI]
	table[4] = param[g_var(cmd).ID_PORSCHE]
	table[5] = param[g_var(cmd).ID_FALALI]
	table[6] = param[g_var(cmd).ID_LUGU]
	table[7] = param[g_var(cmd).ID_MAIBAHE]
	table[8] = param[g_var(cmd).ID_BUJIADI]

	return table

end

--重置下注
function GameViewLayer:CleanAllBet()
	
	local addview = self._rootNode:getChildByName("Panel_roll")
	for i=1,g_var(cmd).AREA_COUNT do
		local jettonNode0 = addview:getChildByName(string.format("Node_%d_1", i))
		local jettonNode1 = addview:getChildByName(string.format("Node_%d_2", i))

		if nil ~= jettonNode0:getChildByTag(1) then
			local num = jettonNode0:getChildByTag(1)
			num:setString("0")
		end

		if nil ~= jettonNode1:getChildByTag(1) then
			local num = jettonNode1:getChildByTag(1)
			num:setString("0")
		end

	end
end

-------------------------------------------------------------------------------------------
--玩家列表
function GameViewLayer:UserListEvent( ref,eventType )
	if self._UserView == nil then
		self._UserView = g_var(UserList):create(self._scene._dataModle)
		self:addChild(self._UserView,30)
		self._UserView:reloadData()
	else
		self._UserView:setVisible(true)
		self._UserView:reloadData()
	end
end
--按钮事件
function GameViewLayer:BankerEvent(ref,eventType)
	--打开上庄列表界面
	local bankerView = self._rootNode:getChildByName("zhuang_listBG")
	bankerView:setVisible(true)

	--隐藏聊天
	local chatView = self._rootNode:getChildByName("chat_BG")
	chatView:setVisible(false)
end

function GameViewLayer:ChatEvent(ref,eventType)
	--隐藏上庄列表界面
	local bankerView = self._rootNode:getChildByName("zhuang_listBG")
	bankerView:setVisible(false)

	--打开聊天
	local chatView = self._rootNode:getChildByName("chat_BG")
	chatView:setVisible(true)

	if not self._ChatView then 
		self._ChatView = g_var(Chat):create(chatView,self._scene._dataModle,self._scene._gameFrame)
		chatView:addChild(self._ChatView)

	end
end
--------------------------------------------------------------------------------------------

--银行操作成功
function GameViewLayer:onBankSuccess( )
     self._scene:dismissPopWait()

    local bank_success = self._scene.bank_success
    if nil == bank_success then
        return
    end
    GlobalUserItem.lUserScore = bank_success.lUserScore
    GlobalUserItem.lUserInsure = bank_success.lUserInsure

    self:refreshScore()

    showToast(cc.Director:getInstance():getRunningScene(), bank_success.szDescribrString, 2)
end

--银行操作失败
function GameViewLayer:onBankFailure( )

     self._scene:dismissPopWait()
    local bank_fail = self._scene.bank_fail
    if nil == bank_fail then
        return
    end

    showToast(cc.Director:getInstance():getRunningScene(), bank_fail.szDescribeString, 2)
end


  --刷新金币
function GameViewLayer:refreshScore( )
    --携带游戏币
    local str = ExternalFun.numberThousands(GlobalUserItem.lUserScore)
    if string.len(str) > 19 then
        str = string.sub(str, 1, 19)
    end
    self.textCurrent:setString(str)

    --银行存款
    str = ExternalFun.numberThousands(GlobalUserItem.lUserInsure)
    if string.len(str) > 19 then
        str = string.sub(str, 1, 19)
    end
    
    self.textBank:setString(ExternalFun.numberThousands(GlobalUserItem.lUserInsure))
end


--银行
function GameViewLayer:btnBankEvent(ref,eventType)
	if eventType == ccui.TouchEventType.ended then
		if 0 ==GlobalUserItem.cbInsureEnabled then --判断是否已经开通银行
			showToast(cc.Director:getInstance():getRunningScene(), "请开通银行", 2)
			return
		end

		 --申请取款
        local function sendTakeScore( lScore,szPassword )
            local cmddata = ExternalFun.create_netdata(g_var(game_cmd).CMD_GR_C_TakeScoreRequest)
            cmddata:setcmdinfo(g_var(game_cmd).MDM_GR_INSURE, g_var(game_cmd).SUB_GR_TAKE_SCORE_REQUEST)
            cmddata:pushbyte(g_var(game_cmd).SUB_GR_TAKE_SCORE_REQUEST)
            cmddata:pushscore(lScore)
            cmddata:pushstring(md5(szPassword),yl.LEN_PASSWORD)

            self._scene:sendNetData(cmddata)
        end

       	 local function onTakeScore( )
                --参数判断
                local szScore = string.gsub( self.m_editNumber:getText(),"([^0-9])","")
                local szPass =   self.m_editPasswd:getText()

                if #szScore < 1 then 
                    showToast(cc.Director:getInstance():getRunningScene(),"请输入操作金额！",2)
                    return
                end

                local lOperateScore = tonumber(szScore)
                if lOperateScore<1 then
                    showToast(cc.Director:getInstance():getRunningScene(),"请输入正确金额！",2)
                    return
                end

                if #szPass < 1 then 
                    showToast(cc.Director:getInstance():getRunningScene(),"请输入银行密码！",2)
                    return
                end
                if #szPass <6 then
                    showToast(cc.Director:getInstance():getRunningScene(),"密码必须大于6个字符，请重新输入！",2)
                    return
                end

                self:showPopWait()
                sendTakeScore(lOperateScore,szPass)
                
         end

		if nil ==  self._bank then

			self._bank = ccui.ImageView:create()
			self._bank:setContentSize(cc.size(yl.WIDTH, yl.HEIGHT))
	        self._bank:setScale9Enabled(true)
	        self._bank:setPosition(yl.WIDTH/2, yl.HEIGHT)
	        self._bank:setTouchEnabled(true)
	        self:addChild(self._bank,TAG_ZORDER.BANK_ZORDER)

	        self._bank:addTouchEventListener(function (sender,eventType)
            if eventType == ccui.TouchEventType.ended then
                 self._bank:runAction(cc.MoveTo:create(0.2,cc.p(yl.WIDTH/2, yl.HEIGHT*1.5)))
             
            end
        end)

	        --加载CSB
	        local csbnode = cc.CSLoader:createNode("game_res/Bank.csb");
	        csbnode:setPosition(self._bank:getContentSize().width/2	, self._bank:getContentSize().height/2)

		    self._bank:addChild(csbnode);


		--当前游戏币
			 local curNode = csbnode:getChildByName("Node_Current") 
			 self.textCurrent = cc.Label:createWithTTF("0", "base/res/fonts/round_body.ttf", 20)
			 self.textCurrent:setTextColor(cc.YELLOW)
			 self.textCurrent:setAnchorPoint(cc.p(0.0,0.5))
			 self.textCurrent:setPosition(-15, curNode:getContentSize().height/2)
			 curNode:addChild(self.textCurrent)

		--银行游戏币
			local bankNode = csbnode:getChildByName("Node_2")
			self.textBank = cc.Label:createWithTTF("0", "base/res/fonts/round_body.ttf", 20)	
			self.textBank:setTextColor(cc.YELLOW)
			self.textBank:setAnchorPoint(cc.p(0.0,0.5))
			self.textBank:setPosition(-15, bankNode:getContentSize().height/2)
			bankNode:addChild(self.textBank)

			self:refreshScore()

			--取款金额
		    local editbox = ccui.EditBox:create(cc.size(246, 44),"bank_res/dikuang26.png")
		        :setPosition(cc.p(28.5,0))
		        :setFontName("base/res/fonts/round_body.ttf")
		        :setPlaceholderFontName("base/res/fonts/round_body.ttf")
		        :setFontSize(24)
		        :setPlaceholderFontSize(24)
		        :setMaxLength(32)
		        :setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE)
		        :setPlaceHolder("请输入取款金额")
		    csbnode:addChild(editbox)
		    self.m_editNumber = editbox
		  

		    --取款密码
		    editbox = ccui.EditBox:create(cc.size(246, 44),"bank_res/dikuang26.png")
		        :setPosition(cc.p(28.5,-62))
		        :setFontName("base/res/fonts/round_body.ttf")
		        :setPlaceholderFontName("base/res/fonts/round_body.ttf")
		        :setFontSize(24)
		        :setPlaceholderFontSize(24)
		        :setMaxLength(32)
		        :setInputFlag(cc.EDITBOX_INPUT_FLAG_PASSWORD)
		        :setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE)
		        :setPlaceHolder("请输入取款密码")
		    csbnode:addChild(editbox)
		    self.m_editPasswd = editbox

        --取款按钮
	        local btnTake = csbnode:getChildByName("btn_take")
	        btnTake:addTouchEventListener(function( sender , envetType )
	            if envetType == ccui.TouchEventType.ended then
	                onTakeScore()
	            end
	        end)


		    --关闭按钮
			local btnClose = csbnode:getChildByName("btn_close")
        	btnClose:addTouchEventListener(function( sender , eventType )
            if eventType == ccui.TouchEventType.ended then
                self._bank:runAction(cc.MoveTo:create(0.2,cc.p(yl.WIDTH/2, yl.HEIGHT*1.5)))
            end
       	 end)

		end
		
		self._bank:runAction(cc.MoveTo:create(0.2,cc.p(yl.WIDTH/2, yl.HEIGHT/2)))
	end
end
---------------------------------------------------------------------------------------------

--加注
function GameViewLayer:JettonEvent( ref ,eventType )
	if eventType == ccui.TouchEventType.ended then
		local btn = ref
		local index = btn:getTag() - 100 
		self:SetJettonIndex(index)
	end
end

--续压
function GameViewLayer:ContinueEvent( ref,eventType )
	self.bContinueRecord = true

	for i=1,#self._scene.m_lContinueRecord do  
		if self._scene.m_lContinueRecord[i] > 0 then
			--发送加注 i是逻辑索引
			self._scene:sendUserBet(i,self._scene.m_lContinueRecord[i])

			--视图索引
			local areaIndex = self:GetViewAreaIndex(i)

			self._scene.m_lCurrentAddscore[areaIndex] = self._scene.m_lCurrentAddscore[areaIndex] + self._scene.m_lContinueRecord[i]
			self._scene.m_lAllJettonScore[i] = self._scene.m_lAllJettonScore[i] + self._scene.m_lContinueRecord[i]
		end
	end

	--刷新桌面坐标
	self:UpdateAreaJetton()

	--刷新操作按钮
	self:updateControl(g_var(cmd).Jettons)
	self:updateControl(g_var(cmd).Continue)
end

--申请庄家
function GameViewLayer:ApplyEvent( ref,eventType )

	local userItem = self._scene:GetMeUserItem()
	if self.m_eApplyStatus == GameViewLayer.unApply then 
		--发送申请
		local cmddata = ExternalFun.create_netdata(g_var(cmd).CMD_S_ApplyBanker)
	    cmddata:pushword(userItem.wChairID)

   		self._scene:SendData(g_var(cmd).SUB_C_APPLY_BANKER, cmddata)

	elseif self.m_eApplyStatus == GameViewLayer.applyed then
		
		--发送取消
		local cmddata = ExternalFun.create_netdata(g_var(cmd).CMD_S_ApplyBanker)
	    cmddata:pushword(userItem.wChairID)

   		self._scene:SendData(g_var(cmd).SUB_C_CANCEL_BANKER, cmddata)
	end
end

function GameViewLayer:PlaceJettonEvent( ref,eventType )

	local btn = ref
	local areaIndex = btn:getTag() - 200	--转换成视图索引
	local userItem = self._scene:GetMeUserItem()

	local logicAreaIndex = self:GetLogicAreaIndex(areaIndex)	--逻辑索引
	
	if self:GetTotalCurrentPlaceJetton() + self._scene.BetArray[self.JettonIndex] > self._scene.m_lUserMaxScore  then
		return
	end

	if self._scene.BetArray[self.JettonIndex] > userItem.lScore*self._scene.m_nMultiple  then
		return
	end

	self._scene.m_lCurrentAddscore[areaIndex] = self._scene.m_lCurrentAddscore[areaIndex] + self._scene.BetArray[self.JettonIndex]
	self._scene.m_lAllJettonScore[logicAreaIndex] = self._scene.m_lAllJettonScore[logicAreaIndex] + self._scene.BetArray[self.JettonIndex]

	--发送加注
	self._scene:sendUserBet(logicAreaIndex,self._scene.BetArray[self.JettonIndex])

	--刷新桌面坐标
	self:UpdateAreaJetton()

	--刷新操作按钮
	self:updateControl(g_var(cmd).Jettons)
	self:updateControl(g_var(cmd).Continue)

	self:playEffect("sound_res/ADD_GOLD.wav")

end
-------------------------------------------------------------------------------------------------------------------------------------

function GameViewLayer:SetJettonIndex( index )	--筹码索引

	local addview = self._rootNode:getChildByName("Panel_roll")
	self.JettonIndex = index

	if index <= 0 or index > g_var(cmd).JETTON_COUNT then
	
		local lightCircle = addview:getChildByTag(200)
		if nil ~= lightCircle then
			lightCircle:setVisible(false)
		end
		return
	end

	--选择的目标筹码
	local jetton = self._rootNode:getChildByName(string.format("bet_%d", index))
	if not addview:getChildByTag(200) then  --光圈
		local lightCircle = ccui.ImageView:create("game_res/tubiao35.png")
		lightCircle:setAnchorPoint(cc.p(0.5,0.5))
		lightCircle:setPosition(cc.p(jetton:getPositionX(),jetton:getPositionY()))
		lightCircle:setTag(200)
		addview:addChild(lightCircle)
	else
		local lightCircle = addview:getChildByTag(200)
		lightCircle:setVisible(true)
		lightCircle:setPosition(cc.p(jetton:getPositionX(),jetton:getPositionY()))

	end
end

function GameViewLayer:GetJettonIndexInvalid() --获取索引
	if self.JettonIndex <= 0 or self.JettonIndex > g_var(cmd).JETTON_COUNT then
		return false
	end

	return true
end

function GameViewLayer:SetClockType(timetype) --设置倒计时

	local RollPanel = self._rootNode:getChildByName("Panel_roll")
	local typeImage = self._rootNode:getChildByName("time_type")
	typeImage:setVisible(true)
	if timetype == g_var(cmd).CLOCK_FREE then
		typeImage:loadTexture("game_res/tubiao42.png")
	elseif timetype == g_var(cmd).CLOCK_ADDGOLD then
		typeImage:loadTexture("game_res/tubiao41.png")
	else
		typeImage:loadTexture("game_res/tubiao40.png")
	end
end

function GameViewLayer:SetApplyStatus( status )

	if self.m_eApplyStatus == status then
		return
	end

	self.m_eApplyStatus = status

	self:SetApplyTexture()
end

function GameViewLayer:SetApplyTexture()

	local bankerBG =  self._rootNode:getChildByName("zhuang_listBG")
	local applyBtn = bankerBG:getChildByName("btn_apply")

	if self.m_eApplyStatus == GameViewLayer.unApply then 
		applyBtn:loadTextureNormal("game_res/anniu9.png")
	elseif self.m_eApplyStatus == GameViewLayer.applyed then
		applyBtn:loadTextureNormal("game_res/anniu11.png")
		
	end
end

function GameViewLayer:setClockTypeIsVisible(visible) --倒计时类型

	local RollPanel = self._rootNode:getChildByName("Panel_roll")
	local typeImage = self._rootNode:getChildByName("time_type")
	typeImage:setVisible(true)
end

function GameViewLayer:SetEndView(visible)
	--local RollPanel = self._rootNode:getChildByName("Panel_roll")
	--local endview = RollPanel:getChildByName("endView")
	--endview:setVisible(visible)
	


	--获取车名
	--local cartype = endview:getChildByName("Car_Type")
	if visible == true then
		local bBig = false;
		if self.endindex == 1 then 
			--宾利
			self.carNameBC:setTexture("game_res/image/BigCar/nameBl.png")
			bBig = true
		elseif self.endindex == 2 or self.endindex == 12 or self.endindex == 16 then
			--宝马
			self.SmallcarNameBC:setTexture("game_res/image/SmallCar/name/nameBM.png")
		elseif self.endindex == 3 or self.endindex == 6 or self.endindex == 15 then
			--奔驰
			self.SmallcarNameBC:setTexture("game_res/image/SmallCar/name/nameBC.png")
		elseif self.endindex == 4 or self.endindex == 7 or self.endindex == 10 then
			--保时捷
			self.SmallcarNameBC:setTexture("game_res/image/SmallCar/name/nameBSJ.png")
		elseif self.endindex == 5 then
			--法拉利
			self.carNameBC:setTexture("game_res/image/BigCar/nameFll.png")
			bBig = true
		elseif self.endindex == 9 then
			--迈巴赫
			self.carNameBC:setTexture("game_res/image/BigCar/nameMbh.png")
			bBig = true
		elseif self.endindex == 8 or self.endindex == 11 or self.endindex == 14 then
			--路虎
			self.SmallcarNameBC:setTexture("game_res/image/SmallCar/name/nameLH.png")
		elseif self.endindex == 13 then
			--布加迪
			self.carNameBC:setTexture("game_res/image/BigCar/nameBjd.png")
			bBig = true		
		end
		if bBig == true then
			self._csbBigCar:setVisible(true)
			self._csbbBigCarAnimate:play("BigCarAnimate", false)
			function callBack()
				self.BankerWinScoreTTF:setVisible(false)	
				--玩家输赢
				self.UserWinScoreTTF:setVisible(false)	
			end
			self._csbbBigCarAnimate:setLastFrameCallFunc(callBack)
		else
				    --开奖结束动画
			self._csbSmallCar:setVisible(true)
			self._csbSmallCarAnimate:play("BigCarAnimate", false)
			
			function callBack()
				self.BankerWinScoreTTF:setVisible(false)	
				--玩家输赢
				self.UserWinScoreTTF:setVisible(false)	
			end
			self._csbSmallCarAnimate:setLastFrameCallFunc(callBack)
			
		end 
		local lBankerScore = self._lBankerScore
		local lUserScore = self._lUserScore;
		self:runAction(cc.Sequence:create(cc.DelayTime:create(0.5),
        cc.CallFunc:create(function()
			self:SetEndInfo(lBankerScore,lUserScore)
        end)))
		
	end

end

function GameViewLayer:SetEndInfo(lBankerScore,lUserScore)
--[[	local RollPanel = self._rootNode:getChildByName("Panel_roll")
	local endview = RollPanel:getChildByName("endView")
	local infoBG = endview:getChildByName("end_detail")
	if nil ~= infoBG then
		infoBG:removeChildByTag(1)
		infoBG:removeChildByTag(2)--]]
		self.m_UserPerformance = self.m_UserPerformance + lUserScore
		local node = self._rootNode:getChildByName("User_Performance")
		local label = node:getChildByTag(2)
		if nil == label then
			label =  cc.Label:createWithTTF(string.formatNumberFhousands(self.m_UserPerformance), "base/res/fonts/round_body.ttf", 25)
			label:setAnchorPoint(cc.p(0.0,0.5))
			label:setTag(2)
			label:setTextColor(cc.c3b(0,255,42))
			label:setPosition(2, node:getContentSize().height/2)
			node:addChild(label)
		else
			label:setString(string.formatNumberFhousands(self.m_UserPerformance))
		end
		self:ShowBankerInfo(self._scene.info)
		
		lBankerScore = lBankerScore * self._scene.m_nMultiple
		lUserScore = lUserScore * self._scene.m_nMultiple
		local lUserScore_2 = 0
		local lBankerScore_2 = 0;
		
		local lBankerScore_3 = 0
		local lUserScore_3 = 0
		if lBankerScore < 0 then
			lBankerScore_3 = lBankerScore * (-1)
		else
			lBankerScore_3 = lBankerScore
		end
		if lUserScore < 0 then
			lUserScore_3 = lUserScore * (-1)
		else
			lUserScore_3 = lUserScore
		end
		function upuserdata(dt)
			if self.m_schedulerupdata ~= nil then
				lBankerScore_2 = lBankerScore_2 +lBankerScore_3/10
				local str 
				if lBankerScore >= 0 then
					str ="庄家: ".."+"..string.formatNumberFhousands(lBankerScore_2)
				else
					str ="庄家: ".."-"..string.formatNumberFhousands(lBankerScore_2)
				end
				lUserScore_2 = lUserScore_2 + lUserScore_3/10 
				local str1 
				if lUserScore >= 0 then
					str1 ="本家: ".."+"..string.formatNumberFhousands(lUserScore_2)
				else
					str1 ="本家: ".."-"..string.formatNumberFhousands(lUserScore_2)
				end


				self.BankerWinScoreTTF:setString(str)
				self.BankerWinScoreTTF:setVisible(true)	
				--玩家输赢
				self.UserWinScoreTTF:setString(str1)
				self.UserWinScoreTTF:setVisible(true)	
				
				if lUserScore_2 >= lUserScore_3 or  lBankerScore_2 >= lBankerScore_3 then
					if nil ~= self.m_schedulerupdata then
						
						if lBankerScore >= 0 then
							str ="庄家: ".."+"..string.formatNumberFhousands(lBankerScore)
						else
							str ="庄家: ".."-"..string.formatNumberFhousands(lBankerScore_3)
						end

						if lUserScore >= 0 then
							str1 ="本家: ".."+"..string.formatNumberFhousands(lUserScore)
						else
							str1 ="本家: ".."-"..string.formatNumberFhousands(lUserScore_3)
						end
						
						self.BankerWinScoreTTF:setString(str)
						self.UserWinScoreTTF:setString(str1)
						print("stop dispatch")
						scheduler:unscheduleScriptEntry(self.m_schedulerupdata)
						self.m_schedulerupdata = nil
					end
				end
			end

		end
		if nil == self.m_schedulerupdata then
			self.m_schedulerupdata = scheduler:scheduleScriptFunc(upuserdata, 0.1, false)
		end
	
	

	--end
end


function GameViewLayer:GetLogicAreaIndex( cbArea )
	local logicIndex = -1


	if cbArea == 1 then
		--宾利
		logicIndex = g_var(cmd).ID_BENTLEY
	elseif cbArea == 2 then
		--宝马  
		logicIndex = g_var(cmd).ID_BMW
	elseif cbArea == 3 then
		--奔驰
		logicIndex = g_var(cmd).ID_BENCHI
	elseif cbArea == 4 then
		--保时捷
		logicIndex = g_var(cmd).ID_PORSCHE	
	elseif cbArea == 5 then
		--法拉利
		logicIndex = g_var(cmd).ID_FALALI
	elseif cbArea == 6 then
		--路虎
		logicIndex = g_var(cmd).ID_LUGU
	elseif cbArea == 7 then
		--迈巴赫
		logicIndex = g_var(cmd).ID_MAIBAHE
	elseif cbArea == 8 then
		--布加迪
		logicIndex = g_var(cmd).ID_BUJIADI
	end

	return logicIndex
end


function GameViewLayer:GetViewAreaIndex( logicIndex )
	
	if logicIndex == 1 then
		--宾利
		logicIndex = g_var(cmd).ID_BENTLEY
	elseif logicIndex == 2 then
		--宝马  
		logicIndex = g_var(cmd).ID_BMW
	elseif logicIndex == 3 then
		--奔驰
		logicIndex = g_var(cmd).ID_BENCHI
	elseif logicIndex == 4 then
		--保时捷
		logicIndex = g_var(cmd).ID_PORSCHE	
	elseif logicIndex == 5 then
		--法拉利
		logicIndex = g_var(cmd).ID_FALALI
	elseif logicIndex == 6 then
		--路虎
		logicIndex = g_var(cmd).ID_LUGU
	elseif logicIndex == 7 then
		--迈巴赫
		logicIndex = g_var(cmd).ID_MAIBAHE
	elseif logicIndex == 8 then
		--布加迪
		logicIndex = g_var(cmd).ID_BUJIADI
	end

	return logicIndex
	
end


function GameViewLayer:GetTotalCurrentPlaceJetton()
	local cur = 0
	for i=1,#self._scene.m_lCurrentAddscore do
		cur = cur + self._scene.m_lCurrentAddscore[i]
	end
	return cur
end

function GameViewLayer:GetAllPlaceJetton()
	local total = 0
	for i=1,#self._scene.m_lAllJettonScore do
		total = total + self._scene.m_lAllJettonScore[i]
	end
	return total
end

function GameViewLayer:GetJettonRecord()
	local record = 0
	for i=1,#self._scene.m_lContinueRecord do
		record = record + self._scene.m_lContinueRecord[i]
	end
	return record
end
----------------------------------------------------------------------------------------------------------------------------------------
function GameViewLayer:TouchUserInfo()  --点击用户头像显示信息
	
end

--------------------------------------------------------------

--------------------------------------------------------------
--倒计时
function GameViewLayer:createClockView(time,viewtype)
	if nil ~= self.m_pClock then
		self.m_pClock:removeFromParent()
		self.m_pClock = nil
	end

	local RollPanel = self._rootNode:getChildByName("Panel_roll")
	--if viewtype == 0 then --转盘界面
		self.m_pClock = cc.LabelAtlas:create(string.format("%d",time),"game_res/shuzi3.png",32,44,string.byte("0"))
		self.m_pClock:setAnchorPoint(0.5,0.5)
		self.m_pClock:setPosition(927.25,684.75)
		RollPanel:addChild(self.m_pClock, TAG_ZORDER.CLOCK_ZORDER)
	--end
end

function GameViewLayer:UpdataClockTime(clockTime)
	
	if nil ~= self.m_pClock then
		self.m_pClock:setString(string.format("%d",clockTime))
		
		if self.m_controlLayer ~= nil then
			self.m_controlLayer:showLeftTime(string.format("%d",clockTime))
		end
	
		if self.m_cbGameStatus == g_var(cmd).GS_PLACE_JETTON and  clockTime <=  5 then
			if self.strAnimate == nil then
				local Animate = "TimeAnimation"
				self.strAnimate = display.newSprite()
					:move(cc.p(927.25, 684.75))
					:addTo(self, 3)
				self.strAnimate:runAction(cc.Sequence:create(
					cc.Spawn:create(
						self:getAnimate(Animate)
					),
					cc.CallFunc:create(function(ref)
						ref:removeFromParent()
					end)
				))
			end
		else 
			if self.strAnimate ~= nil then
				self.strAnimate:stopAllActions()
				self.strAnimate:removeFromParent()
				self.strAnimate = nil
			end

		end
	end
	
	if clockTime == 0 then
		self:LogicTimeZero()
		if self.strAnimate ~= nil then
			self.strAnimate:stopAllActions()
			self.strAnimate:removeFromParent()
			self.strAnimate = nil
		end
	end
end

function GameViewLayer:LogicTimeZero()  --倒计时0处理

	local RollPanel = self._rootNode:getChildByName("Panel_roll")
	local typeImage = self._rootNode:getChildByName("time_type")
	typeImage:setVisible(false)

	if nil ~= self.m_pClock then
		self._scene:KillGameClock()
		self.m_pClock:removeFromParent()
		self.m_pClock = nil
	end

	if self.m_cbGameStatus == g_var(cmd).GAME_SCENE_FREE then
		self:removeAction()
		self:restData()
		self:RollDisAppear()
		self:AddViewSlipToShow()
	elseif self.m_cbGameStatus ==  g_var(cmd).GS_PLACE_JETTON then
		self:AddViewSlipToHidden()
		--self:RollApear()
	end
end

--------------------------------------------------------------

function GameViewLayer:GetJettons()		--下注筹码
	local btns = {}
	for i=1,g_var(cmd).JETTON_COUNT do
		local btn = self._rootNode:getChildByName(string.format("bet_%d", i))
		table.insert(btns, btn)
	end

	return btns

end

function GameViewLayer:updateControl(ButtonType)  --更新按钮状态

	local userItem = self._scene:GetMeUserItem()

	if ButtonType == g_var(cmd).Apply then         --申请庄家按钮

		local bankerBG =  self._rootNode:getChildByName("zhuang_listBG")
		local applyBtn = bankerBG:getChildByName("btn_apply")

		if userItem.lScore * self._scene.m_nMultiple < self._scene.m_lApplyBankerCondition  then
			applyBtn:setEnabled(false)

		else
			if self.m_cbGameStatus ~= g_var(cmd).GAME_SCENE_FREE and userItem.wChairID == self._scene.m_wBankerUser then
				applyBtn:setEnabled(false)
				return
			end

			applyBtn:setEnabled(true)

		end

	elseif ButtonType == g_var(cmd).Jettons then   --加注按钮
		local totalCurrentAddScore = 0
		for i=1,#self._scene.m_lCurrentAddscore do
			totalCurrentAddScore = totalCurrentAddScore + self._scene.m_lCurrentAddscore[i]
		end

		local btns = self:GetJettons()

		for i=1,#btns do
			if self.m_cbGameStatus == g_var(cmd).GS_PLACE_JETTON then
				local nn = self._scene.BetArray[i]
				local mm = self._scene.m_lUserMaxScore
				local mmm = self._scene.m_nMultiple
				local lll = self._scene.bEnableSysBanker
				if self._scene.BetArray[i] > self._scene.m_lUserMaxScore-totalCurrentAddScore or self._scene.BetArray[i] > userItem.lScore*self._scene.m_nMultiple or not self._scene.bEnableSysBanker then
					btns[i]:setEnabled(false)
					if self.JettonIndex == i then 
						self:SetJettonIndex(-1)
					end
				else
					btns[i]:setEnabled(true)
				end
			else
				btns[i]:setEnabled(false)
				if self.JettonIndex == i then 
					self:SetJettonIndex(-1)
				end
			end
			local userItem = self._scene:GetMeUserItem()

			if self._scene.m_wBankerUser == userItem.wChairID then
				btns[i]:setEnabled(false)
			end
		end

	elseif ButtonType == g_var(cmd).Continue then  --续压按钮

		--dump(self._scene.m_lContinueRecord, "self._scene.m_lContinueRecord is =========>	", 6)
		local addview = self._rootNode:getChildByName("Panel_roll")
		local ContinueBtn = self._rootNode:getChildByName("btn_continue")

		if self.bContinueRecord then --每局续压只能一次
			ContinueBtn:setEnabled(false)
			return
		end

		if self.m_cbGameStatus ~= g_var(cmd).GS_PLACE_JETTON  or self:GetJettonRecord() == 0 then 

			ContinueBtn:setEnabled(false)
		else
			ContinueBtn:setEnabled(true)
		end
	end	
end

------------------------------------------------------------------------------------------------------------
--动画

function GameViewLayer:RollApear() --转盘出现
	local RollPanel = self._rootNode:getChildByName("Panel_roll")
	local callfunc = cc.CallFunc:create(function()
		self:rollAction()
	end)

	if not self.bAnimate then 
		--RollPanel:setPosition(cc.p(667,385))
		self:rollAction()
		return
	end
	
	RollPanel:runAction(cc.Sequence:create(cc.MoveTo:create(0.2,cc.p(668.94,375.98)),callfunc))
end

function GameViewLayer:RollDisAppear() --转盘弹出
--[[	local RollPanel = self._rootNode:getChildByName("Panel_roll")
	if not self.bAnimate then 
		--RollPanel:setPosition(cc.p(667,980))
		return
	end--]]
	--RollPanel:runAction(cc.MoveTo:create(0.2,cc.p(667,980)))
end

--加注界面弹出
function GameViewLayer:AddViewSlipToShow() --下注界面

end

--加注界面隐藏
function GameViewLayer:AddViewSlipToHidden()

end


function GameViewLayer:RunCircleAction()	--转动动画
	
	local RollPanel = self._rootNode:getChildByName("Panel_roll")

 	--光圈默认位置
 	if nil == self.firstRoll then

	 	self.firstRoll = cc.Sprite:create("game_res/tubiao37.png")
	 	self.firstRoll:setPosition(self.points[1].x, self.points[1].y)
	 	self.firstRoll:setTag(1)
	 	RollPanel:addChild(self.firstRoll)

	 	self.secondRoll = cc.Sprite:create("game_res/tubiao38.png")
	 	self.secondRoll:setPosition(self.points[16].x, self.points[16].y)
	 	self.secondRoll:setTag(2)
	 	RollPanel:addChild(self.secondRoll)

	 	self.thirdRoll = cc.Sprite:create("game_res/tubiao39.png")
	 	self.thirdRoll:setPosition(self.points[15].x, self.points[15].y)
	 	self.thirdRoll:setTag(3)
	 	RollPanel:addChild(self.thirdRoll)

 	end
 	
 	local delay = cc.DelayTime:create(self.time)
 	local call = cc.CallFunc:create(function()
 		if self.firstRoll == nil then
 			return
 		end

 		self.firstRoll:setPosition(cc.p(self.points[self.index].x,self.points[self.index].y))
 		local index = self.oneCircle-math.mod(self.oneCircle-self.index + 1,self.oneCircle)

 		if nil ~= self.secondRoll then
 			self.secondRoll:setPosition(cc.p(self.points[index].x,self.points[index].y))
 		end

 		if nil ~= self.thirdRoll then
 			index = self.oneCircle-math.mod(self.oneCircle-index+1,self.oneCircle)
 			self.thirdRoll:setPosition(cc.p(self.points[index].x,self.points[index].y))
 		end
 		
 		local car = RollPanel:getChildByName(string.format("car_index_%d",self.index))
 		car:runAction(cc.Sequence:create(cc.ScaleTo:create(0.1,1.2),cc.ScaleTo:create(0.1,1.0)))
 		self.index = math.mod(self.index,self.oneCircle) + 1
 		self.count = self.count + 1
 		if self.count == self.oneCircle * 4 - math.mod(self.endindex,self.oneCircle) then 	--转6圈
 			self.secondRoll:removeFromParent()
 			self.thirdRoll:removeFromParent()

 			self.secondRoll = nil
 			self.thirdRoll = nil
 			--变速
 			self.time = self.time * 1.1		
 		elseif self.count >= self.oneCircle*5 - math.mod(self.endindex,self.oneCircle) then --第10圈
 			self.time = self.time * 1.05 --变速
 			if self.index  == self.endindex + 1 then

 				self:EndBreath(car)
 				self:SetEndView(true)
				
	
 				--移除倒计时
--[[ 				if nil ~= self.m_pClock then
 					self._scene:KillGameClock()
 					self.m_pClock:removeFromParent()
 					self.m_pClock = nil
 				end--]]

 				--隐藏时间类型
 				--self:setClockTypeIsVisible(false)
 				return
 			end
 		end
 		self:RunCircleAction()
 	end)

 	self:runAction(cc.Sequence:create(delay,call))
end

--目标位置
function GameViewLayer:EndBreath(car)
	local callfunc = cc.CallFunc:create(function()
		self:EndBreath(car)
	end)

	car:runAction(cc.Sequence:create(cc.ScaleTo:create(0.4,1.2),cc.ScaleTo:create(0.4,1.0),callfunc))
end

--停止动作
function GameViewLayer:removeAction()
	local RollPanel = self._rootNode:getChildByName("Panel_roll")
	local car = RollPanel:getChildByName(string.format("car_index_%d",self.index-1))
	if nil ~= car then
		car:stopAllActions()
	end

	if nil ~= self.firstRoll then
		self.firstRoll:removeFromParent()
		self.firstRoll = nil
	end

	if nil ~= self.secondRoll then
		self.secondRoll:removeFromParent()
		self.secondRoll = nil
	end

	if nil ~= self.thirdRoll then
		self.thirdRoll:removeFromParent()
		self.thirdRoll = nil
	end
end

-----------------------------------------------------------------------------------------------------------------

--用户聊天
function GameViewLayer:userChat(nick, chatstr)
	if not self._ChatView or not  self._ChatView.onUserChat then
		return
	end
    self._ChatView:onUserChat(nick,chatstr)
end

--用户表情
function GameViewLayer:userExpression(nick, index)
    if not self._ChatView or not self._ChatView.onUserExpression  then
		return
	end

    self._ChatView:onUserExpression(nick,index)
end


----------------------------------------------------------------------------------------------------------------------
function GameViewLayer:onTouchBegan(touch, event)
	print("luxurycar onTouchBegan...")
	local record = self._rootNode:getChildByName("record_cell")

	if record:isVisible() then
		record:setVisible(false)
	end
	
	local menu_R = self._rootNode:getChildByName("menu_R")
	if menu_R:isVisible() then
		menu_R:setVisible(false)
		menu_R:move(menu_R:getPositionX(), menu_R:getPositionY() + menu_R:getContentSize().height)
		return true
	end
	local bankerBG =  self._rootNode:getChildByName("zhuang_listBG")
	if bankerBG:isVisible() then
		bankerBG:setVisible(false)
	end
	return true

end

function GameViewLayer:onTouchMoved(touch, event)

	print("luxurycar onTouchMoved...")

end

function GameViewLayer:onTouchEnded(touch, event )

	print("luxurycar onTouchEnded...")
end
-----------------------------------------------------------------------------------------------------------------------

function GameViewLayer:playEffect( file )
	if not GlobalUserItem.bVoiceAble then
		return
	end

	AudioEngine.playEffect(file)
end
--更新排名座位玩家
function GameViewLayer:updateRankSitUser()
	
	local userList = self:getDataMgr():getUserList()
	local lRankScore = {}
	local chairid = {}
	
	local ncount = 1
	for i = 1, #userList do
		if userList[i] ~= nil and userList[i].wChairID ~= yl.INVALID_CHAIR then
			chairid[ncount] = userList[i].wChairID
			
			local userItem =  self:getDataMgr():getUserByChair(self:getDataMgr():getUserList(),chairid[ncount])
			lRankScore[ncount] = userItem.lScore
			--lRankScore[ncount] = self:getDataMgr():getUserList()[chairid[ncount]].lScore
			ncount = ncount + 1
		end
	end
	--排序操作
	--table.sort(userList, function(a,b) return a.lScore >= b.lScore end)
	
	--排序操作
	local bSorted = true;
	local cbLast = (ncount-1) - 1;
	repeat
		bSorted = true;
		for i=1,cbLast do
			if lRankScore[i] < lRankScore[i+1] then
				--设置标志
				bSorted = false;
				--排序权位
				lRankScore[i], lRankScore[i + 1] = lRankScore[i + 1], lRankScore[i];
				chairid[i],chairid[i + 1] = chairid[i + 1], chairid[i];
			end
		end
		cbLast = cbLast - 1;
	until bSorted ~= false
	
	for i=1, 6 do
		--清除头像
		if nil ~= self.m_rankHead[i] then
			self.m_rankHead[i]:removeFromParent()
			self.m_rankHead[i] = nil
		end

		local item = nil
		local chair = chairid[i]
		if chair ~= nil and chair ~= yl.INVALID_CHAIR then
			--item = self:getDataMgr():getUserList()[chair]
			item =  self:getDataMgr():getUserByChair(self:getDataMgr():getUserList(),chair)
		end

		if item ~= nil then
			self.m_rankTopUser[i] = item.wChairID
			self.m_rankTopNode[i]:setVisible(true)
			
			local tmp = self.m_rankTopNode[i]:getChildByName("head_frame")
			local head = g_var(PopupInfoHead):createNormal(item, 90)
			if head ~= nil then
				head:setPosition(tmp:getPositionX(),tmp:getPositionY())
				self.m_rankTopNode[i]:addChild(head)
				
				local size = cc.Director:getInstance():getWinSize()
				local pos = cc.p(self.m_rankTopNode[i]:getPositionX(),self.m_rankTopNode[i]:getPositionY())
				local anchor = cc.p(1, 0)
				--if i>3 then
					--zanchor = cc.p(1, 0)
					pos = cc.p(self.m_rankTopNode[i]:getPositionX()-400,self.m_rankTopNode[i]:getPositionY())
				--end

				head:enableInfoPop(true,pos,anchor)
			end
			self.m_rankHead[i] = head
			
--[[			local sp_rank = self.m_rankTopNode[i]:getChildByName("Sprite_rank")
			sp_rank:setLocalZOrder(2)
			
			local nickName = self.m_rankTopNode[i]:getChildByName("Text_name")
			local szAddress = self.m_rankTopNode[i]:getChildByName("Text_score")
			local strName = item.dwGameID
			nickName:setString("ID:"..strName)
			local strAddress = item.szAdressLocation
			szAddress:setString(strAddress)	--]]		
		else
			--self.m_rankTopNode[i]:setVisible(false)
		end
	end
end
function GameViewLayer:UpControlList(  )
	
	local userList = self:getDataMgr():getUserList()

	for i = 1, #userList do
		if userList[i] ~= nil and userList[i].wChairID ~= yl.INVALID_CHAIR then
			self.m_controlLayer:setPlayerEnter(userList[i].dwGameID,userList[i].bAndroid)
		end
	end
	
	for k,v in pairs(self:getDataMgr():getUserList()) do
		self.m_controlLayer:setPlayerEnter(v.dwGameID,v.bAndroid)
    end	
end

function GameViewLayer:OnUpBetInfo(cmd_table)
	
	
	 --界面下注信息
    local lScore = 0;
    local ll = 0;
    for i=1,g_var(cmd).AREA_COUNT do

		--真人区域总下注
		ll = cmd_table.lPlayerBet[1][i]
		self:showPlayerBet(i,ll,false)
		
		--机器人区域总下注
		ll = cmd_table.lAndroidBet[1][i]
		self:showPlayerBet(i,ll,true)
    end
	--每个玩家每个区域的下注
	local betScore = 0;
	local gameid = 0;
	local totleBet = 0;  
	--for i=1,g_var(cmd).GAME_PLAYER do
		for j=1,g_var(cmd).AREA_COUNT do		
			betScore = cmd_table.lPlayerAreaBet[1][j]
			
			if betScore == nil then
				local mmm = 0 
				return
			end
			gameid = cmd_table.dwGameID
			totleBet = cmd_table.lPlayerTotleBet
			self:showPlayerAreaBet(j,betScore,gameid,totleBet)
		end
	--end
end

--断线重连更新玩家总下注(控制端)
function GameViewLayer:showPlayerBet( cbArea, llScore,cbAndroid )
	self.m_controlLayer:showAreaTotalBet(cbArea, llScore,cbAndroid)	
end
--断线重连更新玩家每个区域下注(控制端)
function GameViewLayer:showPlayerAreaBet( cbArea, llScore,dwGameID,totleBet )
	self.m_controlLayer:showPlayerAreaBet(cbArea, llScore,dwGameID,totleBet)	
end
function GameViewLayer:setPlayerEnter(dwGameID,bAndroid)
	self.m_controlLayer:setPlayerEnter(dwGameID,bAndroid)
end
function GameViewLayer:removeuserAreaBet(dwGameID)
	self.m_controlLayer:removeuserAreaBet(dwGameID)
end
function GameViewLayer:executecontrol(cmddata)
	self:getParentNode():executecontrol(cmddata)
end
function GameViewLayer:ControlAddPeizhi(cmddata)
	self:getParentNode():ControlAddPeizhi(cmddata)
end
function GameViewLayer:OnAdmincontorlpeizhi(cmd_table)
	self.m_controlLayer:OnAddpeizhi(cmd_table.dwGameID,cmd_table.lscore)
end
function GameViewLayer:ControlDelPeizhi(cmddata)
	self:getParentNode():ControlDelPeizhi(cmddata)
end
function GameViewLayer:OnDelPeizhi(cmd_table)
	self.m_controlLayer:OnDelPeizhi(cmd_table.dwGameID)
end

function GameViewLayer:androidxiazhuang()
	self:getParentNode():androidxiazhuang()
end
function GameViewLayer:ControlAddPeizhi(cmddata)
	self:getParentNode():ControlAddPeizhi(cmddata)
end
function GameViewLayer:OnUpAlllosewin(cmd_table)
	self.m_controlLayer:setPlayerAlljettion(cmd_table.dwGameID,cmd_table.lTdTotalScore,cmd_table.lTotalScore)
	self.m_controlLayer:UppeizhiLIst(cmd_table.dwGameID,cmd_table.lscore)
end

return GameViewLayer