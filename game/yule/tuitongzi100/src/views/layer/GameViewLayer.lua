local ClipText = appdf.req(appdf.EXTERNAL_SRC .. "ClipText")
local HeadSprite = appdf.req(appdf.EXTERNAL_SRC.."HeadSprite")
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local PopupInfoHead = appdf.req(appdf.EXTERNAL_SRC .. "PopupInfoHead")

local Game_CMD = appdf.req(appdf.GAME_SRC.."yule.tuitongzi100.src.models.CMD_Game")
local GameLogic = appdf.req(appdf.GAME_SRC.."yule.tuitongzi100.src.models.GameLogic")
local publicFunc = appdf.req(appdf.GAME_SRC.."yule.tuitongzi100.src.models.publicFunc")
local publicFunc = appdf.req(appdf.GAME_SRC.."yule.tuitongzi100.src.models.publicFunc")
local BankLayer = appdf.req(appdf.GAME_SRC.."yule.tuitongzi100.src.views.layer.BankLayer")
local TrendList = appdf.req(appdf.GAME_SRC.."yule.tuitongzi100.src.views.layer.TrendList")
local HelpLayer = appdf.req(appdf.GAME_SRC.."yule.tuitongzi100.src.views.layer.HelpLayer")
local CardSprite = appdf.req(appdf.GAME_SRC.."yule.tuitongzi100.src.views.layer.CardSprite")
local BankerList = appdf.req(appdf.GAME_SRC.."yule.tuitongzi100.src.views.layer.BankerList")
local GameEndLayer = appdf.req(appdf.GAME_SRC.."yule.tuitongzi100.src.views.layer.GameEndLayer")
local SettingLayer = appdf.req(appdf.GAME_SRC.."yule.tuitongzi100.src.views.layer.SettingLayer")
local UserListLayer = appdf.req(appdf.GAME_SRC.."yule.tuitongzi100.src.views.layer.UserListLayer")

local GameViewLayer = class("GameViewLayer",function(scene)
        local gameViewLayer = display.newLayer()
    return gameViewLayer
end)

local TAG_START             = 100
local enumTable = 
{
    "HEAD_BANKER",  --庄家头像
    "HEAD_MYSELF",  --自己头像
    "BT_MENU",		--菜单按钮
    "BT_SET",       --设置
    "BT_HELP",      --帮助
    "BT_BANK",      --银行
    "BT_QUIT",      --退出
    "BT_APPLY",     --申请上庄
    "BT_APPLYCANCEL", --申请下庄
    "BT_BANKERLIST",  --庄家列表
    "BT_TRENDLIST",   --走势
    "BT_USERLIST",  --用户列表
    "BT_JETTONAREA_0",  --下注区域
    "BT_JETTONAREA_1",
    "BT_JETTONAREA_2",
    "BT_JETTONSCORE_0", --下注按钮
    "BT_JETTONSCORE_1",
    "BT_JETTONSCORE_2",
    "BT_JETTONSCORE_3",
    "BT_JETTONSCORE_4",
}

--申请上庄列表的状态
local GameState =
{
    "FREE",
    "JETTON",
    "END",
}

local enumLayer = {
    "ZORDER_GOLD",
    "ZORDER_JETTONSCORE",
    "ZORDER_SELFINFO", --头像界面
    "ZORDER_HEADINFO", --头像信息
    "ZORDER_BANK", --头像界面
    "ZORDER_CARD", -- 牌层
    "ZORDER_ANIMATE",
    "ZORDER_POINT", --结局点数
    "ZORDER_SIEVE",
    "ZORDER_ALLWIN", --通杀通赔
    "ZORDER_SURFACE",  --新建的界面
}

--层级关系处理
local ZORDER_LAYER = ExternalFun.declarEnumWithTable(0, enumLayer)

local TAG_ENUM = ExternalFun.declarEnumWithTable(TAG_START, enumTable)
local GAME_STATE = ExternalFun.declarEnumWithTable(200, GameState)

--自己头像位置
local selfheadpoint = cc.p(68, 68)
--庄家头像位置
local bankerheadpoint = cc.p(927, 695)
--蛊位置 
sievePointOld = {cc.p(667, 375), cc.p(-993, 604), cc.p(-595, 512)}
sievePointNew = {cc.p(667, 375), cc.p(0, 0) , cc.p(0, -278)}
--色子位置
sieveFirstPoint = cc.p(117, 139)
sieveSecondPoint = cc.p(217, 139)

local MaxTimes = 4   ---最大赔率

--下注数值
GameViewLayer.m_BTJettonScore = {1, 5, 10, 50, 100}

--下注值对应游戏币个数(此处只可为偶数)
GameViewLayer.m_JettonGoldBaseNum = {2, 4, 6, 8, 10}

--玩家列表按钮位置
local btnUserlistPoint = cc.p(1287, 230)

function GameViewLayer:ctor(scene)
	--注册node事件
    ExternalFun.registerNodeEvent(self, true)	

	self._scene = scene

    --初始化
    self:paramInit()

	--加载资源
	self:loadResource()

    ExternalFun.playBackgroudAudio("BACK_GROUND.mp3")
end

function GameViewLayer:paramInit()
    --自己的金贝
    self.my_gold = 0

    --庄家的金贝
    self.banker_gold = 0

    --庄家的名字
    self.banker_name = ""

    --自己限制最大下注金币
    self.lUserMaxScore = 0

    --区域下注分数限制
    self.lAreaLimitScore = 0

    --申请庄家限制
    self.lApplyBankerCondition = 0

    --全局下注
    self.lAllJettonScore = {0, 0, 0, 0}

    --自己各个区域下注分数
    self.lUserJettonScore = {0, 0, 0, 0}

    --自己下注总分
    self.myAllJettonScore = 0

    --桌面扑克
    self.cbTableCardArray = {}

    --庄家椅子号
    self.wBankerUser = yl.INVALID_CHAIR

    --庄家分数
    self.wBankerScore = 0

    --下注区域管理
    self.m_JettonArea = {}

    --下注按钮管理
    self.m_JettonBtn = {}

    --玩家列表
    self.userList = nil

    --选中筹码
    self.m_nJettonSelect = 0

    --游戏状态
    self.gameState = Game_CMD.GS_SCENE_FREE

    --系统能否做庄
    self.m_bEnableSysBanker = true

    --桌面牌动画管理节点
    self._cardUI = nil

    --桌面动画管理节点
    self._animateUI = nil

    --游戏币显示层
    self._goldUI = nil

    --游戏币列表
    self.goldList = {{}, {}, {}}

    --手牌从天门开始
    self.handCard = {}

    --游戏记录
    self.gameRecord = {}

    --是否练习场
    self.m_bGenreEducate = false

    --色子点数
    self.sievePoint = 0

    --银行层
    self.bankerLayer = nil

    --区域分数的位置
    self.areaScorePosition = {}

    --是否断线重连
    self.isReLink = false
end


function GameViewLayer:loadResource()
    cc.Director:getInstance():getTextureCache():addImage("game/no/headframeno.png")
    cc.Director:getInstance():getTextureCache():addImage("game/no/jettontimeno.png")
    local rootLayer, csbNode = ExternalFun.loadRootCSB("game/gameLayer.csb", self)

    self.csbNode = csbNode

	local function btnEvent( sender, eventType )
        if eventType == ccui.TouchEventType.ended then
            self:onButtonClickedEvent(sender:getTag(), sender)
        end
    end

    --设置
    local menuList = csbNode:getChildByName("Image_List")
    btn = menuList:getChildByName("Button_Setting")
    btn:setTag(TAG_ENUM.BT_SET)
    btn:addTouchEventListener(btnEvent)

    --帮助
    btn = menuList:getChildByName("Button_Help")
    btn:setTag(TAG_ENUM.BT_HELP)
    btn:addTouchEventListener(btnEvent)

    --菜单
    btn = csbNode:getChildByName("Button_Menu")
    btn:setTag(TAG_ENUM.BT_MENU)
    btn:addTouchEventListener(btnEvent)

    --银行
    btn = csbNode:getChildByName("Button_bank")
    btn:setTag(TAG_ENUM.BT_BANK)
    btn:addTouchEventListener(btnEvent)

    --退出
    btn = csbNode:getChildByName("Button_Exit")
    btn:setTag(TAG_ENUM.BT_QUIT)
    btn:addTouchEventListener(btnEvent)

    --申请上庄
    self.btnApply = csbNode:getChildByName("Button_Apply")
    self.btnApply:setTag(TAG_ENUM.BT_APPLY)
    self.btnApply:addTouchEventListener(btnEvent)

    --申请下庄
    self.btnApplyCancel = csbNode:getChildByName("Button_Cancel")
    self.btnApplyCancel:setTag(TAG_ENUM.BT_APPLYCANCEL)
    self.btnApplyCancel:addTouchEventListener(btnEvent)

    --庄家列表
    btn = csbNode:getChildByName("Button_ApplyList")
    btn:setTag(TAG_ENUM.BT_BANKERLIST)
    btn:addTouchEventListener(btnEvent)

    --玩家列表
    btn = csbNode:getChildByName("bt_userlist")
    btn:setTag(TAG_ENUM.BT_USERLIST)
    btn:addTouchEventListener(btnEvent)

    --走势
    btn = csbNode:getChildByName("Button_Trend")
    btn:setTag(TAG_ENUM.BT_TRENDLIST)
    btn:addTouchEventListener(btnEvent)

    --下注区域
    for i=1,3 do
        local str = string.format("bt_area_%d", i-1)
        btn = csbNode:getChildByName(str)
        btn:setTag(TAG_ENUM.BT_JETTONAREA_0+i-1)
        btn:addTouchEventListener(btnEvent)
        self.m_JettonArea[i] = btn
    end

    --下注筹码
    for i=1,5 do
        local str = string.format("bt_jetton_%d", i-1)
        btn = csbNode:getChildByName(str)
        btn:setTag(TAG_ENUM.BT_JETTONSCORE_0+i-1)
        btn:addTouchEventListener(btnEvent)
        self.m_JettonBtn[i] = btn
    end

    --判断申请上(下)庄是否可见
    if self:isMeInBankList() then
        self.btnApply:setVisible(false)
        self.btnApplyCancel:setVisible(true)
    else
        self.btnApply:setVisible(true)
        self.btnApplyCancel:setVisible(false)
    end

    --下注区域分数节点
    self._NodeJettonScore = self.csbNode:getChildByName("Node_JettonScore"):setZOrder(ZORDER_LAYER.ZORDER_JETTONSCORE)

    --创建游戏币管理界面
    self._goldUI = cc.Node:create():addTo(self.csbNode):setZOrder(ZORDER_LAYER.ZORDER_GOLD)

    --创建牌管理界面
    self._cardUI = cc.Node:create():addTo(self.csbNode, ZORDER_LAYER.ZORDER_CARD)

    --创建动画管理节点
    self._animateUI = cc.Node:create():addTo(self.csbNode, ZORDER_LAYER.ZORDER_ANIMATE)

    --色子节点
    self.Node_Sieve = self.csbNode:getChildByName("Node_Sieve"):setZOrder(ZORDER_LAYER.ZORDER_SIEVE)
    self.Node_Sieve:setScale(0.4)
    self.Node_Sieve:getChildByName("Sprite_sieve"):setPosition(sievePointOld[2])
    self.Node_Sieve:getChildByName("Sprite_sievebottom"):setPosition(sievePointOld[3])
    self.Node_Sieve:setVisible(true)

    self:createSievePoint(1, 2)
    self.csbNode:getChildByName("Node_Card"):setVisible(false)
    
    --设置下注数值
    for i=1, 5 do
        self.csbNode:getChildByName("Node_jetton"):getChildByName(string.format("AtlasLabel_%d", i)):setString(GameViewLayer.m_BTJettonScore[i])
    end

    self.csbNode:getChildByName("Node_Point"):setZOrder(ZORDER_LAYER.ZORDER_POINT)
    self:setSelfInfo()

    --保存下注区域分数的显示位置
    for i=1, 3 do
        local tmp = self._NodeJettonScore:getChildByName(string.format("Atl_allgold_%d", i))
        self.areaScorePosition[i] = cc.p(tmp:getPosition())
    end

    --  重新设计层级关系
    self.csbNode:getChildByName("btn_selfinfo"):setZOrder(ZORDER_LAYER.ZORDER_SELFINFO)
    self.csbNode:getChildByName("Node_nostr"):setZOrder(ZORDER_LAYER.ZORDER_SELFINFO)
    self.csbNode:getChildByName("Button_bank"):setZOrder(ZORDER_LAYER.ZORDER_BANK)
end

--设置自己信息
function GameViewLayer:setSelfInfo()
    local node = self.csbNode:getChildByName("Node_nostr")
    local temp = PopupInfoHead:createClipHead(self:getMeUserItem(), 105,"public/Sprite_head2.png")
    temp:setPosition(selfheadpoint)
    temp:setZOrder(ZORDER_LAYER.ZORDER_HEADINFO)
    temp:setTag(TAG_ENUM.HEAD_MYSELF)
    self.csbNode:addChild(temp)
    temp:enableInfoPop(true, cc.p(100, 100))

    local temp = self.csbNode:getChildByName("btn_selfinfo"):getChildByName("Text_name")
    local pselfname = ClipText:createClipText(cc.size(145, 26), self:getMeUserItem().szNickName)
    pselfname:setAnchorPoint(temp:getAnchorPoint())
    pselfname:setPosition(temp:getPosition())
    pselfname:setName(temp:getName())
    temp:removeFromParent()
    self:addChild(pselfname)

    self.my_gold  = self:getMeUserItem().lScore

    if self.my_gold >= 100000000 then
        node:getChildByName("yi_1"):setVisible(true)
        node:getChildByName("nostr_1"):setVisible(false)
    elseif self.my_gold >= 10000 then
        node:getChildByName("nostr_1"):setVisible(true)
        node:getChildByName("yi_1"):setVisible(false)
    else
        node:getChildByName("nostr_1"):setVisible(false)
        node:getChildByName("yi_1"):setVisible(false)
    end
    self.csbNode:getChildByName("btn_selfinfo"):getChildByName("Atla_gold"):setString(ExternalFun.formatScoreText(self.my_gold))
end

function GameViewLayer:upDateSelfInfo()
    local node = self.csbNode:getChildByName("Node_nostr")
    if self.my_gold >= 100000000 then
        node:getChildByName("yi_1"):setVisible(true)
        node:getChildByName("nostr_1"):setVisible(false)
    elseif self.my_gold >= 10000 then
        node:getChildByName("nostr_1"):setVisible(true)
        node:getChildByName("yi_1"):setVisible(false)
    else
        node:getChildByName("nostr_1"):setVisible(false)
        node:getChildByName("yi_1"):setVisible(false)
    end
    self.csbNode:getChildByName("btn_selfinfo"):getChildByName("Atla_gold"):setString(ExternalFun.formatScoreText(self.my_gold))
end

--设置庄家信息
function GameViewLayer:setBankInfo()
    local node = self.csbNode:getChildByName("Node_nostr")
    if self.wBankerUser == yl.INVALID_CHAIR then
        if self.m_bEnableSysBanker then
            self.banker_name = "系统坐庄"
            self.banker_gold = 2000000000
        else
            self.banker_name = "无人坐庄"
            --knight
            self.banker_gold = 0
        end
    else
        local userItem = self:getDataMgr():getChairUserList()[self.wBankerUser+1]
        if userItem ~= nil then
            self.banker_name = userItem.szNickName
            self.banker_gold = userItem.lScore
        end
    end

    if self.banker_gold >= 100000000 then
        node:getChildByName("yi_2"):setVisible(true)
        node:getChildByName("nostr_2"):setVisible(false)
    elseif self.banker_gold >= 10000 then
        node:getChildByName("nostr_2"):setVisible(true)
        node:getChildByName("yi_2"):setVisible(false)
    else
        node:getChildByName("nostr_2"):setVisible(false)
        node:getChildByName("yi_2"):setVisible(false)
    end

    local bankBg = self.csbNode:getChildByName("bankbg")
    bankBg:getChildByName("txt_bankname"):setString(self.banker_name)
    bankBg:getChildByName("Atla_gold"):setString(ExternalFun.formatScoreText(self.banker_gold))
end

--刷新庄家信息
function GameViewLayer:upDateBankInfo()
    self:setBankInfo()
end

--切换庄家
function GameViewLayer:changeBanker(dataBuffer)
    --自己是庄家，先下庄
    if self:isMeChair(self.wBankerUser) then
        self:changeApplyState(false)
    end

    self.wBankerUser = dataBuffer.wBankerUser
    self.banker_gold = dataBuffer.lBankerScore
    
    --切换后自己是庄家
    if self:isMeChair(self.wBankerUser) then
        self:changeApplyState(true)
        self:setJettonEnable(false)
    else
        self:setJettonEnable(true)
    end
    self:setBankInfo()
end

function GameViewLayer:onButtonClickedEvent(tag, ref)
	ExternalFun.playClickEffect()
    
    if tag == TAG_ENUM.HEAD_BANKER then
        --庄家头像
    elseif tag == TAG_ENUM.HEAD_MYSELF then
        --自己头像
    elseif tag == TAG_ENUM.BT_SET then
        --设置按钮
        ExternalFun.playClickEffect()
        SettingLayer:create():setPosition(display.cx, display.cy):addTo(self.csbNode):setZOrder(ZORDER_LAYER.ZORDER_SURFACE)
    elseif tag == TAG_ENUM.BT_HELP then
        --帮助按钮
        ExternalFun.playClickEffect()
        HelpLayer:create():setPosition(display.cx, display.cy):addTo(self.csbNode):setZOrder(ZORDER_LAYER.ZORDER_SURFACE)
    elseif tag == TAG_ENUM.BT_MENU then
        --菜单按钮
        ExternalFun.playClickEffect()
        self:changeMenuList()
    elseif tag == TAG_ENUM.BT_BANK then
        --银行
        ExternalFun.playClickEffect()
        if self.m_bGenreEducate then
            showToast(self, "练习模式, 不能使用银行", 1.5)
            return
        end
--knight
        --if 0 == GlobalUserItem.tabAccountInfo.cbInsureEnabled then
        if 0 == GlobalUserItem.cbInsureEnabled then
            showToast(self, "初次使用，请先开通银行！", 1)
            return 
        end

        --空闲状态才能存款
        if self.gameState ~= Game_CMD.GS_SCENE_FREE then
            showToast(self, "只有空闲状态可以进行银行操作", 1)
        else
            self.bankerLayer = BankLayer:create(self):addTo(self):setPosition(cc.p(display.cx, display.cy))
        end
    elseif tag == TAG_ENUM.BT_QUIT then
        --退出
        ExternalFun.playClickEffect()
        self._scene:onQueryExitGame()
    elseif tag == TAG_ENUM.BT_APPLY then
        --申请上庄
        ExternalFun.playClickEffect()
       self:sendApplyBanker()
   elseif tag == TAG_ENUM.BT_APPLYCANCEL then
        --申请下庄
        ExternalFun.playClickEffect()
        self:sendCancelApply()
    elseif tag == TAG_ENUM.BT_BANKERLIST then
        --庄家列表
        ExternalFun.playClickEffect()
        self:showBankerList()
    elseif tag == TAG_ENUM.BT_USERLIST  then
        ExternalFun.playClickEffect()
        self:showUserList()
    elseif tag == TAG_ENUM.BT_TRENDLIST then
        --趋势
        ExternalFun.playClickEffect()
        self:showPlayerTend()
    elseif TAG_ENUM.BT_JETTONAREA_0 <= tag and tag <= TAG_ENUM.BT_JETTONAREA_2 then
        --下注区域
        self:onJettonAreaClicked(ref:getTag() - TAG_ENUM.BT_JETTONAREA_0+1, ref)
    elseif TAG_ENUM.BT_JETTONSCORE_0 <= tag and tag <= TAG_ENUM.BT_JETTONSCORE_4 then
        --下注按钮
        ExternalFun.playClickEffect()
        self:onJettonButtonClicked(ref:getTag()-TAG_ENUM.BT_JETTONSCORE_0+1, ref)
    end
end

--申请庄家列表
function GameViewLayer:showBankerList()
    local bankerList = self:getParentNode():getDataMgr():getApplyBankerUserList()
    if next(bankerList) == nil then showToast(self, "目前没有玩家申请庄家", 1) end
        --显示庄家列表信息
    self:getDataMgr():removeApplyUser(self.wBankerUser) 
    BankerList:create(bankerList):addTo(self.csbNode):setPosition(cc.p(display.cx, display.cy)):setZOrder(ZORDER_LAYER.ZORDER_SURFACE)
end

--玩家列表
function GameViewLayer:showUserList()
    local userList = self:getParentNode():getDataMgr():getUserList()
    if next(userList) == nil then  showToast(self, "目前没有玩家", 1) end
        --显示玩家列表信息
    UserListLayer:create(userList):addTo(self.csbNode):setPosition(cc.p(display.cx, display.cy)):setZOrder(ZORDER_LAYER.ZORDER_SURFACE)
end

--显示玩家趋势信息
function GameViewLayer:showPlayerTend()
--直接从场景中取得数据进行创建
    if next(self.gameRecord) == nil then
        showToast(self, "目前没有对局信息！",1)
        return
    end

    TrendList:create(self.gameRecord):addTo(self.csbNode):setPosition(cc.p(display.cx, display.cy)):setZOrder(ZORDER_LAYER.ZORDER_SURFACE)
end

--单击菜单按钮
function GameViewLayer:changeMenuList()
    local list = self.csbNode:getChildByName("Image_List")
    if list:isVisible() then
        list:setVisible(false)
    else
        list:setVisible(true)
    end
end

--下注响应
function GameViewLayer:onJettonButtonClicked(tag, ref)
    local function changeBtnState()
        for i=1, #self.m_JettonBtn do
            if i==tag then
                self.m_JettonBtn[i]:loadTextureNormal("game/jetton1.png")
            else
                self.m_JettonBtn[i]:loadTextureNormal("game/jetton0.png")
            end
        end
    end
   self.m_nJettonSelect = tag
   changeBtnState()
end

--下注区域
function GameViewLayer:onJettonAreaClicked(tag, ref)
    --非下注状态
    if self.gameState ~= Game_CMD.GS_PLACE_JETTON or self.m_nJettonSelect == 0 then
        return 
    end

    if self:isMeChair(self.wBankerUser) == true then
        return 
    end

    if not self.m_bEnableSysBanker and self.wBankerUser == yl.INVALID_CHAIR then
        showToast(self,"无人坐庄，不能下注",1) 
        self:setJettonEnable(false)
        return
    end

    local jettonScore = GameViewLayer.m_BTJettonScore[self.m_nJettonSelect]

    local selfScore = (self.myAllJettonScore + jettonScore) * MaxTimes
    if selfScore > self.my_gold or self.lUserMaxScore < (self.myAllJettonScore + jettonScore) then
        showToast(self, "已超过个人最大下注值", 1)
        self:setJettonEnable(false)
        return 
    end

    local areaScore = self.lAllJettonScore[tag] + jettonScore
    if areaScore > self.lAreaLimitScore then
        showToast(self,"已超过该区域最大下注值",1)
        self:setJettonEnable(false)
        return
    end

    if self.wBankerUser ~= yl.INVALID_CHAIR then
        local allscore = jettonScore
        for k,v in pairs(self.lAllJettonScore) do
            allscore = allscore + v
        end 
        allscore = allscore*MaxTimes
        if allscore > self.banker_gold then
            showToast(self,"总下注已超过庄家下注上限",1)
            self:setJettonEnable(false)
            return
        end
    end
    self.myAllJettonScore = self.myAllJettonScore + jettonScore
    self:updateJettonList(self.lUserMaxScore)

    local userself = self:getMeUserItem()
    self:getParentNode():SendPlaceJetton(jettonScore, tag)
end

--申请上庄
function GameViewLayer:sendApplyBanker()
    if nil == self._scene then
        return 
    end
    self._scene:sendApplyBanker()
end

function GameViewLayer:onApplyBanker( cmd_table )
    if self:isMeChair(cmd_table.wApplyUser) == true then
        --上庄成功
        self:changeApplyState(true)
    end
end

--申请下庄
function GameViewLayer:sendCancelApply()
     if nil == self._scene then
        return 
    end
    self._scene:sendCancelApply()
end

function GameViewLayer:onGetCancelBanker( cmd_table )
    if self:isMeChair(cmd_table.wCancelUser) == true then
        --下庄成功
        self:changeApplyState(false)
    end
end

--上(下)庄按钮切换
function GameViewLayer:changeApplyState(bool)
    if bool then
        --申请上庄成功
        self.btnApply:setVisible(false)
        self.btnApplyCancel:setVisible(true)
    else
        --申请下庄成功
        self.btnApply:setVisible(true)
        self.btnApplyCancel:setVisible(false)
    end
end

--更新积分
function GameViewLayer:refreshScore(cmd_table)
    if isMeChair(cmd_table.wChairID) then
        self.my_gold = cmd_table.lScore
    end

    self.wBankerUser = cmd_table.wCurrentBankerChairID
    self.banker_gold = cmd_table.lCurrentBankerScore

    self:upDateSelfInfo()
    self:upDateBankInfo()
end

--更新限制分数             
function GameViewLayer:updateLimitScore()
    local nodeLimit = self.csbNode:getChildByName("Node_limit")
    nodeLimit:getChildByName("Text_banklimit"):setString("上庄条件："..ExternalFun.formatScoreText(self.lApplyBankerCondition))
    nodeLimit:getChildByName("Text_selflimit"):setString("区域限制："..ExternalFun.formatScoreText(self.lAreaLimitScore))
    print("----------------------------updateLimitScore----self.lAreaLimitScore--------------"..(self.lAreaLimitScore))
    nodeLimit:getChildByName("Text_arealimit"):setString("个人限制："..ExternalFun.formatScoreText(self.lUserMaxScore))
    print("----------------------------updateLimitScore------------------"..self.lUserMaxScore)
end
----------------------------
function GameViewLayer:isMeChair( wchair )
    local useritem = self:getDataMgr():getChairUserList()[wchair + 1]
    if nil == useritem then
        return false
    else 
        --knight
        --return useritem.dwUserID == GlobalUserItem.tabAccountInfo.dwUserID
        return useritem.dwUserID == GlobalUserItem.dwUserID
    end
end

--获取数据
function GameViewLayer:getMeUserItem()
    return self:getParentNode():GetMeUserItem()
end

function GameViewLayer:getDataMgr( )
    return self:getParentNode():getDataMgr()
end

function GameViewLayer:getParentNode()
    return self._scene
end

--判断自己是否在庄家列表中
function GameViewLayer:isMeInBankList()
    local userItem = self:getMeUserItem()
    if userItem then
        return self:getDataMgr():isMeInBankList(userItem)
    end
    return nil
end
------------------------------------------------------
--场景数据
function GameViewLayer:onGameSceneFree(cmd_table)
    self.gameState = Game_CMD.GS_SCENE_FREE
    self.lUserMaxScore = cmd_table.lUserMaxScore
    print("----------------------------onGameSceneFree------------------"..cmd_table.lUserMaxScore)
    self.cbTimeLeave = cmd_table.cbTimeLeave
    self.lAreaLimitScore = cmd_table.lAreaLimitScore
    self.lApplyBankerCondition = cmd_table.lApplyBankerCondition
    self.m_bEnableSysBanker = cmd_table.bEnableSysBanker
    self.m_bGenreEducate = cmd_table.bGenreEducate
    self.wBankerUser = cmd_table.wBankerUser
    self:putCardBack()
    self:changeGameStateImg()
    self:reFreshGameStatus(true)

     --系统坐庄
--    if self.m_bEnableSysBanker then
--        self.banker_gold = cmd_table.lStartStorage
--    end
    self:setBankInfo()
    self:updateLimitScore()
end

function GameViewLayer:onGameScenePlaying( cmd_table, cbGameStatus )
    self:resetGameData()
    self.isReLink = true
    self.lAllJettonScore = cmd_table.lAllJettonScore[1]
    self.lUserJettonScore = cmd_table.lUserJettonScore[1]

    --self.m_bGenreEducate = cmd_table.bGenreEducate
    self.cbTimeLeave = cmd_table.cbTimeLeave
    self.cbTableCardArray = cmd_table.cbTableCardArray
    self.banker_gold = cmd_table.lBankerScore
    self.lApplyBankerCondition = cmd_table.lApplyBankerCondition
    self.wBankerUser = cmd_table.wBankerUser
    self.wBankerScore = cmd_table.wBankerScore
    self.lAreaLimitScore = cmd_table.lAreaLimitScore
    self.lUserMaxScore = cmd_table.lUserMaxScore

    self.m_bEnableSysBanker = cmd_table.bEnableSysBanker
    self.gameState = cbGameStatus

--     --系统坐庄
--    if self.m_bEnableSysBanker then
--        self.banker_gold = cmd_table.lStartStorage
--    end

    self:upDateSelfInfo()
    self:setBankInfo()
    self:changeGameStateImg()

    for i=1, #self.lUserJettonScore do
        self.myAllJettonScore = self.myAllJettonScore + self.lUserJettonScore[i]
    end

    self:putCardBack()

    --非空闲状态设置上下庄按钮状态
    if cbGameStatus ~= Game_CMD.GS_SCENE_FREE then
        self:reFreshGameStatus(false)
    else
        self:reFreshGameStatus(true)
    end

    --非结束状态
    if cbGameStatus ~= Game_CMD.GS_GAME_END then
        self:stopGameAllActions()

        --点数清空
        for i=1, 4 do
            self.csbNode:getChildByName("Node_Point"):getChildByName(string.format("win_type_%d", i)):setTexture("")
        end
    end

    self:putCardBack()

    --结束状态
    if cbGameStatus == Game_CMD.GS_GAME_END then
        self._cardUI:removeAllChildren()
        --knight
        --self:reFreshGameUI(cmd_table)
    end

    self:updateLimitScore()
end

---------------------------
--游戏数据
--游戏空闲
function GameViewLayer:onGameFree( cmd_table )
    self.gameState = Game_CMD.GS_SCENE_FREE
    self.cbTimeLeave = cmd_table.cbTimeLeave
    self.lUserJettonScore = {0,0,0,0}
    self:resetGameData()
    self:reFreshGameStatus(true)
    self:setJettonEnable(true)
    self:updateJettonList(self.lUserMaxScore)
    self:changeGameStateImg()

    --摆放牌的背面
    self:putCardBack()
end

--游戏开始，开始下注
function GameViewLayer:onGameStart(cmd_table)
    self.gameState = Game_CMD.GS_PLACE_JETTON
    self.wBankerUser = cmd_table.wBankerUser
    -- self.banker_gold = cmd_table.lBankerScore            
    self.lUserMaxScore = cmd_table.lUserMaxScore

    self.cbTableHaveSendCount = cmd_table.cbTableHaveSendCount
    self.cbTimeLeave = cmd_table.cbTimeLeave
    self:reFreshGameStatus(false)
    self:changeGameStateImg()

    --自己是庄家，下注不可用
    if self:isMeChair(self.wBankerUser) then
        self:setJettonEnable(false)
    else
        self:updateJettonList(self.lUserMaxScore)
    end
    ------------------
    self:updateLimitScore()
end

--用户下注
function GameViewLayer:onPlaceJetton(cmd_table)
    if self:isMeChair(cmd_table.wChairID) then
        local jettonScore = self.lUserJettonScore[cmd_table.cbJettonArea]
        self.lUserJettonScore[cmd_table.cbJettonArea] = jettonScore + cmd_table.lJettonScore
        self.my_gold = self.my_gold - cmd_table.lJettonScore
        self:upDateSelfInfo()
        print("--------------------------llllllpppp")
    end

    local allJettonScore = self.lAllJettonScore[cmd_table.cbJettonArea]
    self.lAllJettonScore[cmd_table.cbJettonArea] = allJettonScore + cmd_table.lJettonScore 

    self:upDateUserJetton(cmd_table)
    self:updateAreaScore()
end

--下注失败
function GameViewLayer:onPlaceJettonFail(cmd_table)
    if self:isMeChair(cmd_table.wPlaceUser) == true then
        self.myAllJettonScore = self.myAllJettonScore - cmd_table.lPlaceScore 
    end
end

--游戏结束
function GameViewLayer:onGameEnd( cmd_table )
    self.gameState = Game_CMD.GS_GAME_END
    self.cbTimeLeave = cmd_table.cbTimeLeave
    self.cbTableCardArray = cmd_table.cbTableCardArray

    --庄家金币变更
    self.banker_gold = self.banker_gold + cmd_table.lBankerScore

    --执行发牌动画
    -- self:sendCardAnimate( point )
    self:sieveAnimate( cmd_table )
    self:reFreshGameStatus(false)

    --添加游戏记录
    self:saveGameRecord()
    self:changeGameStateImg()

    --更新庄家金币
    self:upDateBankInfo()
end

--添加游戏记录
function GameViewLayer:saveGameRecord()
    local function getPoint(tab)
        local cardType, point = GameLogic.GetCardType(tab)

        if cardType == GameLogic.CARD_TYPE.PAIR_CARD then
            return 64
        elseif cardType == GameLogic.CARD_TYPE.SPECIAL_CARD then
            return 32
        elseif cardType == GameLogic.CARD_TYPE.POINT_CARD then
            return point
        end
    end
    
    local temp = {}

    temp.bPointBanker  =  getPoint(self.cbTableCardArray[1])
    temp.bPointTianMen  =  getPoint(self.cbTableCardArray[2])
    temp.bPointZhongMen  =  getPoint(self.cbTableCardArray[3])
    temp.bPointDiMen  =  getPoint(self.cbTableCardArray[4])
    table.insert(self.gameRecord, temp)
end

--游戏记录(趋势)
function GameViewLayer:onGameSendRecord(cmd_table)
    if next(cmd_table) == nil then return end
    self.gameRecord = cmd_table
end

--更新用户下注金币显示
function GameViewLayer:upDateUserJetton(cmd_table)
    -- body
    local function getGoldNum(score)
        local goldNum = 1
        for i=1, 5 do
            if score >= GameViewLayer.m_BTJettonScore[i] then
                goldNum = i
            end
        end
        return GameViewLayer.m_JettonGoldBaseNum[goldNum]
    end
    if self.gameState ~= Game_CMD.GS_PLACE_JETTON then
        return
    end

    local goldNum = getGoldNum(cmd_table.lJettonScore)
    local beginPos = cc.p(btnUserlistPoint)
    local offsettime = 0.1

    if self:isMeChair(cmd_table.wChairID) then
        beginPos = selfheadpoint
    else
       offsettime = 0.1
       beginPos = cc.p(self.csbNode:getChildByName("bt_userlist"):getPosition())
    end

    ExternalFun.playSoundEffect("bm_clips.mp3") 
    for i=1, goldNum do
        local img = cc.Sprite:create("public/gold.png"):addTo(self._goldUI)
        img:setPosition(beginPos)
        
        local randnum = math.random()*offsettime
        local moveAction = self:getMoveAction(beginPos, self:getRandPos(self.m_JettonArea[cmd_table.cbJettonArea]), 0, 0)
        img:runAction(moveAction)
        table.insert(self.goldList[cmd_table.cbJettonArea], img)
    end
end

--更新区域下注分数显示
function GameViewLayer:updateAreaScore()
    for i=1, 3 do
         local txt_score  = self._NodeJettonScore:getChildByName(string.format("Atl_selfgold_%d", i))
         local txt_score1 = self._NodeJettonScore:getChildByName(string.format("Atl_allgold_%d", i))

         if self.lUserJettonScore[i] > 0 then
            txt_score:setString(self.lUserJettonScore[i])
        else
            if self.lAllJettonScore[i] > 0 then
                txt_score:setString("0")
            else
                txt_score:setString("")
            end
        end

        if self.lAllJettonScore[i] > 0 then
            if txt_score:getString() == "" then
                txt_score1:setString(self.lAllJettonScore[i])
            else
                txt_score1:setString("/"..self.lAllJettonScore[i])
            end
        else
            txt_score1:setString("")
        end
    end
end

--清空上局，开始下局
function GameViewLayer:resetGameData()
    --申请上下庄按钮是否可见
    if self:isMeInBankList() then
        self:changeApplyState(true)
    else
        self:changeApplyState(false)
    end
    self._cardUI:removeAllChildren()
    self._goldUI:removeAllChildren()
    self.lAllJettonScore = {0, 0, 0, 0}
    self.lUserJettonScore = {0, 0, 0, 0}
    self.myAllJettonScore = 0
    -- self.gameRecord = {}

    self.goldList = {{}, {}, {}}

    --点数清空
    for i=1, 4 do
        self.csbNode:getChildByName("Node_Point"):getChildByName(string.format("win_type_%d", i)):setTexture("")
    end

    self._animateUI:removeAllChildren()

    --区域下注分数更新
    self:updateAreaScore()
    self:removeGameEnd()

    --下注按钮清空
    self:cleanJettonBtn()
end

--下注按钮清空
function GameViewLayer:cleanJettonBtn()
    self.m_nJettonSelect = 0
    for i=1, #self.m_JettonBtn do
        self.m_JettonBtn[i]:loadTextureNormal("game/jetton0.png")
    end
end

function GameViewLayer:stopGameAllActions()
    -- 暂停动画
    local obj = self.csbNode:getChildByName("Node_Sieve")
    if nil ~= obj then
        obj:stopAllActions()
        local obj1 = obj:getChildByName("Sprite_sieve")
        obj1:stopAllActions()
        local obj2 = obj:getChildByName("Sprite_sievebottom")
        obj2:stopAllActions()
    end

    --还原位置
    self.Node_Sieve:getChildByName("Sprite_sieve"):setPosition(sievePointOld[2])
    self.Node_Sieve:getChildByName("Sprite_sieve"):setScale(1)
    self.Node_Sieve:getChildByName("Sprite_sievebottom"):setPosition(sievePointOld[3])
    self.Node_Sieve:getChildByName("Sprite_sievebottom"):setScale(1)
    self.Node_Sieve:setVisible(true)
    self:createSievePoint(1, 2)
end

function GameViewLayer:cleanGameData()
    self:stopAllActions()
    self:stopGameAllActions()
    self._cardUI:removeAllChildren()
    self._goldUI:removeAllChildren()
    self:removeGameEnd()
    self:putCardBack()

    --点数清空
    for i=1, 4 do
        self.csbNode:getChildByName("Node_Point"):getChildByName(string.format("win_type_%d", i)):setTexture("")
    end
end

--切换游戏状态图片
function GameViewLayer:changeGameStateImg()
    if self.gameState == Game_CMD.GS_SCENE_FREE then
        self.csbNode:getChildByName("Image_state"):loadTexture("game/free.png")
    elseif self.gameState == Game_CMD.GS_PLACE_JETTON then
        self.csbNode:getChildByName("Image_state"):loadTexture("game/jetton.png")
    elseif self.gameState == Game_CMD.GS_GAME_END then
        self.csbNode:getChildByName("Image_state"):loadTexture("game/showcard.png")
    end
end

--设置下注按钮以及下注区域是否可以点击
function GameViewLayer:setJettonEnable( bool )
    -- body
    for k,v in pairs(self.m_JettonBtn) do
        v:setEnabled(bool)
    end
    for k,v  in pairs(self.m_JettonArea) do
        v:setEnabled(bool)
    end
end

--更新下注按钮是否可以点击
--score:可以下注最大金额
function GameViewLayer:updateJettonList(score)
    local judgeindex = 0
    for i=1, 5 do
        local judgescore = GameViewLayer.m_BTJettonScore[i]*MaxTimes

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
        else
            self.m_nJettonSelect = judgeindex
        end
    end
end

--刷新用户分数
function GameViewLayer:onGetUserScore( useritem )
    --自己
    --knight
    --if useritem.dwUserID == GlobalUserItem.tabAccountInfo.dwUserID then
    if useritem.dwUserID == GlobalUserItem.dwUserID then
        self.my_gold = useritem.lScore
        self:upDateSelfInfo()

    end

    --庄家
    if self.wBankerUser == useritem.wChairID then
        --庄家游戏币
        self.banker_gold = useritem.lScore
        self:upDateBankInfo()
    end
end

--断线重连刷新界面
function GameViewLayer:reFreshGameUI(cmd_table)
    local temp = {}
    temp.cbTableCardArray = cmd_table.cbTableCardArray
    temp.lBankerScore = cmd_table.lEndBankerScore
    temp.lUserScore = cmd_table.lEndUserScore
    self:showGameEndResult(temp, self)
end

--游戏结算
function GameViewLayer:showGameEndResult(cmd_table)
    --显示点数以及牌值, 从天门开始
    local card = {}
    for i=2, #cmd_table.cbTableCardArray do
        table.insert(card, cmd_table.cbTableCardArray[i])
    end
    table.insert(card, cmd_table.cbTableCardArray[1])

    -- --扑克节点
    -- if self._cardUI then
    --     self._cardUI:removeAllChildren()
    -- end

    if self.isReLink then
        local node = CardSprite:showGameEndUI(card):addTo(self._cardUI)
    end

    for i=1, #card do
        local cardType, point = GameLogic.GetCardType(card[i])
        local img = self.csbNode:getChildByName("Node_Point"):getChildByName(string.format("win_type_%d", i))

        if cardType == GameLogic.CARD_TYPE.PAIR_CARD then
            img:setTexture(string.format("point/pair.png", point))
        elseif cardType == GameLogic.CARD_TYPE.SPECIAL_CARD then
            img:setTexture(string.format("point/28.png"))
        elseif cardType == GameLogic.CARD_TYPE.POINT_CARD then
            img:setTexture(string.format("point/point_%d.png", point))
        end
    end

    --显示结算，自己没有下注就不显示
    self:removeGameEnd()

    if self.myAllJettonScore == 0 and not self:isMeChair(self.wBankerUser) then
    else
        self.gameOver = GameEndLayer:create(cmd_table, self)
        self.gameOver:setPosition(display.cx, display.cy)
        self.gameOver:addTo(self)
    end
end

--移除结算界面
function GameViewLayer:removeGameEnd()
    if self.gameOver then
        self.gameOver:removeFromParent()
        self.gameOver = nil
    end
end

--移除银行
function GameViewLayer:removeBankerLayer()
    if self.bankerLayer then
        self.bankerLayer:removeFromParent()
        self.bankerLayer = nil
    end
end

--测试金币动画
function GameViewLayer:test()
    for i=1, 10 do
        local img = cc.Sprite:create("public/gold.png"):addTo(self)
        local x,y = self.csbNode:getChildByName("btn_selfinfo"):getPosition()
        local beginPos = cc.p(x, y)
        local moveAction = self:getMoveAction(beginPos, self:getRandPos(self.m_JettonArea[1]), 0, 0)
            img:runAction(moveAction)
    end
end

--结算飞金币
function GameViewLayer:showGoldFly(cmd_table)
    local goldBanker = {}
    if next(self.goldList) == nil then return end
    local function getWiner()
        local winer = {0, 0, 0, 0}
        for i=2, 4 do
            local tmp = GameLogic.GetWinner(self.cbTableCardArray[1], self.cbTableCardArray[i])
            if tmp == GameLogic.WINER.PLAYER_TWO then
                winer[i-1] = 1
                winer[4] = winer[4] - 1
            else
                winer[4] = winer[4] + 1
            end
        end
        return winer
    end

    local winer = getWiner()

    if winer[4] == 3 then
        ExternalFun.playSoundEffect("collect_coin.mp3") 
        for i=1, 3 do
        --通杀
            for j=1, #self.goldList[i] do
                beginpos = cc.p(self.goldList[i][j]:getPosition())
                local moveAction = self:getMoveAction(beginpos, bankerheadpoint, 0, 0)
                self.goldList[i][j]:runAction(cc.Sequence:create(cc.DelayTime:create(1), moveAction,
                                            cc.FadeOut:create(0.1)
                                            ))
            end
        end
    elseif winer[4] == -3 then
        ExternalFun.playSoundEffect("collect_coin.mp3") 
        --通赔
        for i=1, 3 do
            if self.lUserJettonScore[i] > 0 then
                --自己下注的区域
                for j=1, #self.goldList[i]/2 do
                    beginpos = cc.p(self.goldList[i][j]:getPosition())
                    endpos = selfheadpoint
                    local moveAction = self:getMoveAction(beginpos, endpos, 0, 0)
                    self.goldList[i][j]:runAction(cc.Sequence:create(cc.DelayTime:create(1), moveAction, 
                                                    cc.FadeOut:create(0.1)
                                                    ))
                end

                for j=(#self.goldList[i]/2+1), #self.goldList[i] do
                    beginpos = cc.p(self.goldList[i][j]:getPosition())
                    endpos = btnUserlistPoint
                    local moveAction = self:getMoveAction(beginpos, endpos, 0, 0)
                    self.goldList[i][j]:runAction(cc.Sequence:create(cc.DelayTime:create(1), moveAction,
                                                    cc.FadeOut:create(0.1)
                                                    ))
                end
            else
                for j=1, #self.goldList[i] do
                    beginpos = cc.p(self.goldList[i][j]:getPosition())
                    endpos = btnUserlistPoint
                    local moveAction = self:getMoveAction(beginpos, endpos, 0, 0)
                    self.goldList[i][j]:runAction(cc.Sequence:create(cc.DelayTime:create(1), moveAction,
                                                    cc.FadeOut:create(0.1)
                                                ))
                end
            end
        end
    else
        --庄家有输有赢
        ExternalFun.playSoundEffect("collect_coin.mp3") 
        for i=1, 3 do
        --先飞向庄家
            if winer[i] == 0 then
                for j=1, #self.goldList[i] do
                    local beginpos = cc.p(self.goldList[i][j]:getPosition())
                    local moveAction = self:getMoveAction(beginpos, bankerheadpoint, 0, 0)
                    self.goldList[i][j]:runAction(cc.Sequence:create(cc.DelayTime:create(1), moveAction, cc.FadeOut:create(0.01)))
                end
                self.goldList[i] = {}
            end
        end

        --在飞向赢家
        for i=1, 3 do
            if winer[i] > 0 then
                if #self.goldList[i] == 0 then break end
                for j=1, 10 do
                    local img = cc.Sprite:create("public/gold.png"):addTo(self._goldUI):setPosition(bankerheadpoint)
                    local beginpos = bankerheadpoint
                    local endpos = self:getRandPos(self.m_JettonArea[i])
                    local moveAction = self:getMoveAction(beginpos, endpos, 0, 0)
                    img:runAction(cc.Sequence:create(cc.DelayTime:create(2), moveAction))
                    table.insert(self.goldList[i], img)
                end
            end
        end

        --飞出界面
        for i=1, 3 do
            if self.lUserJettonScore[i] > 0 then
                --自己下注的区域
                ExternalFun.playSoundEffect("coins_fly_in.wav")
                for j=1, #self.goldList[i]/2 do
                    beginpos = cc.p(self.goldList[i][j]:getPosition())
                    endpos = selfheadpoint
                    local moveAction = self:getMoveAction(beginpos, endpos, 0, 0)
                    self.goldList[i][j]:runAction(cc.Sequence:create(cc.DelayTime:create(3), moveAction,
                                                    cc.FadeOut:create(0.1)
                                                 ))
                end

                for j=(#self.goldList[i]/2+1), #self.goldList[i] do
                    beginpos = cc.p(self.goldList[i][j]:getPosition())
                    endpos = btnUserlistPoint
                    local moveAction = self:getMoveAction(beginpos, endpos, 0, 0)
                    self.goldList[i][j]:runAction(cc.Sequence:create(cc.DelayTime:create(3), moveAction,
                                                    cc.FadeOut:create(0.1)
                                                 ))
                end
            else
                --自己没有下注
                ExternalFun.playSoundEffect("coins_fly_in.wav")
                for j=1, #self.goldList[i] do
                    beginpos = cc.p(self.goldList[i][j]:getPosition())
                    endpos = btnUserlistPoint
                    local moveAction = self:getMoveAction(beginpos, endpos, 0, 0)
                    self.goldList[i][j]:runAction(cc.Sequence:create(cc.DelayTime:create(3), moveAction, 
                                                    cc.FadeOut:create(0.1)
                                                ))
                end
            end
        end
    end
end

--获取随机显示位置
function GameViewLayer:getRandPos(nodeArea)
    local beginpos = cc.p(nodeArea:getPositionX()-80, nodeArea:getPositionY()-80)
    
    local offsetx = math.random()
    local offsety = math.random()

    return cc.p(beginpos.x + offsetx*180, beginpos.y + offsety*110)
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

--创建色子点数
function GameViewLayer:createSievePoint(point1, point2)
    local node = self.Node_Sieve:getChildByName("Sprite_sievebottom")
    node:removeAllChildren()
    local img1 = cc.Sprite:create(string.format("sieve/sieve_%d.png", point1))
    img1:setPosition(sieveFirstPoint)
    img1:addTo(node)
    local img2 = cc.Sprite:create(string.format("sieve/sieve_%d.png", point2))
    img2:setPosition(sieveSecondPoint)
    img2:addTo(node)
end

--执行色子动画
function GameViewLayer:sieveAnimate( cmd_table )
    --色子点数
    local point1 = cmd_table.bcFirstCard
    local point2 = cmd_table.bcNextCard
    self.sievePoint = point1 +  point2
    local dely = 0
    local moveTime = 1
    local obj = self.csbNode:getChildByName("Node_Sieve")
    local obj1 = obj:getChildByName("Sprite_sieve")
    local obj2 = obj:getChildByName("Sprite_sievebottom")
    --每个动作间隔时间
    local times = 0.05 

    --摇摆动画执行次数
    local counts = 7 
    local action1 = cc.RotateTo:create( times, 45)  
    local action2 = cc.RotateTo:create( times, -45)  
    local action0 = cc.RotateTo:create( times , 0)
    local sequence = cc.Sequence:create(cc.Sequence:create(action1, action0, action2, action0))
    local repeatForever = cc.Repeat:create(sequence, counts)
    dely = times * 4 * counts 
            
    obj:runAction(cc.Sequence:create(cc.DelayTime:create(moveTime), cc.Spawn:create(repeatForever, cc.CallFunc:create(function() 
                                                                                                                        ExternalFun.playSoundEffect("throwshaizi.mp3")
                                                                                                                    end))))
    --开始移动动画
    local pos1 = cc.p(200, 200)
    local pos2 = cc.p(300, 200)
    local time2 = dely - moveTime
    local delyTime = cc.DelayTime:create(dely)
    obj1:runAction(cc.Sequence:create(cc.Spawn:create(cc.MoveTo:create(moveTime,sievePointNew[2]), cc.ScaleTo:create(moveTime, 2.5)), delyTime, cc.Spawn:create(cc.ScaleTo:create(moveTime, 1), cc.MoveTo:create(moveTime,sievePointOld[2]))))
    obj2:runAction(cc.Sequence:create(cc.Spawn:create(cc.MoveTo:create(moveTime,sievePointNew[3]), cc.ScaleTo:create(moveTime, 2.5)), delyTime, cc.Spawn:create(cc.ScaleTo:create(moveTime, 1), cc.CallFunc:create(function () self:createSievePoint(point1, point2) end), cc.MoveTo:create(moveTime,sievePointOld[3])), 
                                     cc.DelayTime:create(2), 
                                     cc.CallFunc:create(function() self:sendCardAnimate(point) end),
                                     --从发牌开始，延迟10秒执行飞金币和游戏结算界面显示
                                     cc.DelayTime:create(11), cc.CallFunc:create(function () self:showGoldFly(cmd_table) end), 
                                     -- cc.CallFunc:create(function () self:upDateBankInfo() end),
                                     cc.DelayTime:create(3),
                                     cc.CallFunc:create(function()
                                                            self:showGameEndResult(cmd_table) 
                                                        end),
                                     -- --5秒后移除结算
                                     cc.DelayTime:create(5), 
                                     cc.CallFunc:create(function () self:removeGameEnd() end)
                                     ))
end

--翻牌动画
function GameViewLayer:reserveCardAnimate(cardDataTable)
    local card1 = cc.Sprite:create("game/mj_0.png"):addTo(self)
    card1:setPosition(cc.p(display.cx, display.cy))
    local animation = cc.Animation:create()
    animation:addSpriteFrameWithFileName("game/mj_0.png")
    animation:addSpriteFrameWithFileName("game/mj_1.png")
    animation:addSpriteFrameWithFileName("game/mj_2.png")
   
    animation:setDelayPerUnit(1)
    animation:setRestoreOriginalFrame(true)
    card1:runAction(cc.RepeatForever:create(cc.Animate:create(animation)))
end

--胜利后下注区域框动画
function GameViewLayer:areaFrameAnimate(areaIndex)
    local x, y = self.m_JettonArea[areaIndex]:getPosition()
    local pos = cc.p(x, y)
    local frame1 = cc.Sprite:create("animate/framebig1.png"):addTo(self._animateUI)
    frame1:setPosition(pos)
    local animation = cc.Animation:create()
    animation:addSpriteFrameWithFileName("animate/framebig1.png")
    animation:addSpriteFrameWithFileName("animate/framebig2.png")
    animation:setDelayPerUnit(0.5)
    animation:setRestoreOriginalFrame(true)
    frame1:runAction(cc.Sequence:create(cc.Animate:create(animation), cc.CallFunc:create(function() frame1:removeSelf() end)))
end

--庄家胜利后下注区域框动画
function GameViewLayer:bankerFrameAnimate( ... )
    -- body
    local x, y = self.csbNode:getChildByName("bt_area_3"):getPosition()
    local pos = cc.p(x, y)
    local frame2 = cc.Sprite:create("animate/framesmall1.png"):addTo(self._animateUI)
    frame2:setPosition(pos)
    local animation = cc.Animation:create()
    animation:addSpriteFrameWithFileName("animate/framesmall1.png")
    animation:addSpriteFrameWithFileName("animate/framesmall2.png")
    animation:setDelayPerUnit(0.5)
    animation:setRestoreOriginalFrame(true)
    frame2:runAction(cc.RepeatForever:create(cc.Animate:create(animation)))
end

--胜利动画
function GameViewLayer:winAnimate()
    local win = cc.Sprite:create("animate/win/1.png"):addTo(self._animateUI)
    win:setPosition(cc.p(display.cx, display.cy))
    local animation = cc.Animation:create()
    for i=1, 2 do
        animation:addSpriteFrameWithFileName("animate/win/"..string.format("%d.png",i))
    end
    animation:setDelayPerUnit(0.4)
    animation:setRestoreOriginalFrame(false)
    win:runAction(cc.Sequence:create(cc.Animate:create(animation), cc.CallFunc:create(function() win:removeSelf() end)))
end

--失败动画
function GameViewLayer:failAnimate()
    local win = cc.Sprite:create("animate/failed/1.png"):addTo(self._animateUI)
    win:setPosition(cc.p(display.cx, display.cy))
    local animation = cc.Animation:create()
    for i=1, 2 do
        animation:addSpriteFrameWithFileName("animate/failed/"..string.format("%d.png",i))
    end
    animation:setDelayPerUnit(0.4)
    animation:setRestoreOriginalFrame(false)
    win:runAction(cc.Sequence:create(cc.Animate:create(animation), cc.CallFunc:create(function() win:removeSelf() end)))
end

--创建文字测试
function GameViewLayer:createlabel( ... )
    -- body
    local label = cc.LabelAtlas:create("31.12","game/no/headframeno.png",18,28,string.byte(".")):addTo(self):setPosition(display.cx, display.cy+200)
    local label = cc.LabelAtlas:create("12345","game/no/jettontimeno.png",34,52,string.byte("0")):addTo(self):setPosition(display.cx, display.cy+100)
    local label = cc.LabelAtlas:create("+89.78","game/no/winno.png",16,21,string.byte("+")):addTo(self):setPosition(display.cx, display.cy)
    local label = cc.LabelAtlas:create("-6632.1","game/no/failno.png",16,21,string.byte("+")):addTo(self):setPosition(display.cx, display.cy-100)
end

function GameViewLayer:OnUpdataClockView(chair, time)
    local selfchair = self:getParent():GetMeChairID()
    if chair == self:getParentNode():SwitchViewChairID(selfchair) then
        self.csbNode:getChildByName("Atl_time"):setString(string.format("%02d", time))

        --  if self.gameState ~= Game_CMD.GS_GAME_END then
        --     return
        -- end

        -- if time == self.cbTimeLeave then
        -- --     --发牌处理
        --     -- self:sendCardAnimate()
        -- elseif time == self.cbTimeLeave-15  then
        -- --     self:sendCardAnimate()
        -- -- elseif time == self.cbTimeLeave-10 then
        -- --     --游戏币处理
        -- end
    else
        if self.gameState ~= Game_CMD.GS_GAME_END then
            return
        end
    end

    if self.gameState == Game_CMD.GS_PLACE_JETTON then
        if time == self.cbTimeLeave then
            ExternalFun.playSoundEffect("bet_start.mp3")
        elseif time == 3 or time == 2 or time == 1 then
            ExternalFun.playSoundEffect("TIME_WARIMG.wav")

            if time == 1 then
                ExternalFun.playSoundEffect("bet_end.mp3")
            end
        end
    end
end

--发牌动画
function GameViewLayer:sendCardAnimate()
    --色子点数
    assert(self.sievePoint>=2 and self.sievePoint<=12, "色子点数错误")
    local startPos = CardSprite:getSendCardPos(self.sievePoint)
    if not startPos then
        return 
    end
    CardSprite:sendCard(self._cardUI, startPos, self)
end

--摆放界面中的八张牌
function GameViewLayer:putCardBack() 
     -- body
    self._cardUI:removeAllChildren()
    CardSprite:createBack(self._cardUI)
end 

--游戏是否空闲，判定是否可以申请取消上庄
function GameViewLayer:reFreshGameStatus(isFree)
    --是庄家，申请不可见
    if self:isMeChair(self.wBankerUser) then
        self.btnApply:setVisible(false)
        self.btnApplyCancel:setVisible(true)
    end

    --申请下庄是否可以点击
    if isFree then
        self.btnApplyCancel:setEnabled(true)
    else
        if self:isMeChair(self.wBankerUser) then
            self.btnApplyCancel:setEnabled(false)
        else
            self.btnApplyCancel:setEnabled(true)
        end
    end
end

function GameViewLayer:showPopWait( )
    self:getParentNode():showPopWait()
end

--显示手牌牌值
function GameViewLayer:showCardValue(imgSprite, cardTag)
    if next(self.cbTableCardArray) == nil then return end
    self.handCard = {}
    --对手牌进行整理，庄家放在最后，翻牌从天门开始
    if next(self.handCard) == nil then
        for i=2, 4 do
            table.insert(self.handCard, self.cbTableCardArray[i][1])
            table.insert(self.handCard, self.cbTableCardArray[i][2])
        end
        table.insert(self.handCard, self.cbTableCardArray[1][1])
        table.insert(self.handCard, self.cbTableCardArray[1][2])
    end

    ExternalFun.playSoundEffect("pai_flip.mp3") 
    local index = GameLogic.SwitchToCardIndex(self.handCard[cardTag])
    local img = cc.Sprite:create(string.format("card/font%d.png",index))
    img:setPosition(cc.p(39.55, 64.9))
    img:setScale(0.9)
    img:addTo(imgSprite)

    if cardTag == 2 or cardTag == 4 or cardTag == 6 or cardTag == 8 then
        local temp = {}
        table.insert(temp, self.handCard[cardTag-1])
        table.insert(temp, self.handCard[cardTag])
        self:showGameEndPoint(temp, cardTag/2)
    end
end

--显示点数以及胜利动画,从天门开始显示
function GameViewLayer:showGameEndPoint(tab, areaIndex)
    local function showAnimate()
        --最后一个存放庄家
        local winer = {0, 0, 0, 0}
       
        for i=2, 4 do
            local tmp = GameLogic.GetWinner(self.cbTableCardArray[1], self.cbTableCardArray[i])
            if tmp == GameLogic.WINER.PLAYER_ONE then
                winer[4] = winer[4] + 1
            else
                winer[4] = winer[4] - 1
                winer[i-1] = 1
            end
        end

        --玩家获胜
        for i=1, 3 do
            if winer[i] > 0 then
                self:areaFrameAnimate(i)
            end
        end

         --通赔通杀
        if winer[4] == 3 then
            ExternalFun.playSoundEffect("tongsha.mp3")
            local aniNode = cc.CSLoader:createNode("winandfail/tongsha.csb"):addTo(self.csbNode)
            aniNode:setPosition(display.cx,display.cy)
            aniNode:setZOrder(ZORDER_LAYER.ZORDER_ALLWIN)

            local ani = cc.CSLoader:createTimeline("winandfail/tongsha.csb")
            ani:gotoFrameAndPlay(0,false)
            aniNode:runAction(ani)
            --庄家胜利不显示动画
            -- self:bankerFrameAnimate()
        elseif winer[4] == -3 then
            ExternalFun.playSoundEffect("tongpei.mp3")
            local aniNode = cc.CSLoader:createNode("winandfail/tongpei.csb"):addTo(self.csbNode)
            aniNode:setPosition(display.cx,display.cy)
            aniNode:setZOrder(ZORDER_LAYER.ZORDER_ALLWIN)

            local ani = cc.CSLoader:createTimeline("winandfail/tongpei.csb")
            ani:gotoFrameAndPlay(0,false)
            aniNode:runAction(ani)
        end
    end

    if next(self.cbTableCardArray) == nil then return end

    local img = self.csbNode:getChildByName("Node_Point"):getChildByName(string.format("win_type_%d", areaIndex))
    if not img then return end
    local cardType, point = GameLogic.GetCardType(tab)
    if cardType == GameLogic.CARD_TYPE.PAIR_CARD then
        ExternalFun.playSoundEffect("pai_10.mp3")
        img:setTexture(string.format("point/pair.png", point))
    elseif cardType == GameLogic.CARD_TYPE.SPECIAL_CARD then
        ExternalFun.playSoundEffect("pai_11.mp3")
        img:setTexture(string.format("point/28.png"))
    elseif cardType == GameLogic.CARD_TYPE.POINT_CARD then
        ExternalFun.playSoundEffect(string.format("pai_%d.mp3", point))
        img:setTexture(string.format("point/point_%d.png", point))
    end

    --显示胜利动画
    if areaIndex == 4 then
        showAnimate()
    end
end

--银行操作成功
function GameViewLayer:onBankSuccess( )
    local bank_success = self:getParentNode().bank_success
    if nil == bank_success then
        return
    end
    --knight
    --GlobalUserItem.tabAccountInfo.lUserScore = bank_success.lUserScore
    --GlobalUserItem.tabAccountInfo.lUserInsure = bank_success.lUserInsure

    GlobalUserItem.lUserScore = bank_success.lUserScore
    GlobalUserItem.lUserInsure = bank_success.lUserInsure

    if self.bankerLayer then
        self.bankerLayer:refreshBankScore()
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
    if self.bankerLayer then
        self.bankerLayer:refreshBankRate(bankinfo.wRevenueTake)
    end
end

return GameViewLayer

