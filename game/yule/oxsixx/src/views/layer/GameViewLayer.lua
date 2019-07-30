local GameViewLayer = class("GameViewLayer", function(scene)
    local gameViewLayer = display.newLayer()
    return gameViewLayer
end )

require("client/src/plaza/models/yl")
local cmd = appdf.req(appdf.GAME_SRC .. "yule.oxsixx.src.models.CMD_Game")
local SetLayer = appdf.req(appdf.GAME_SRC .. "yule.oxsixx.src.views.layer.SetLayer")
local CardSprite = appdf.req(appdf.GAME_SRC .. "yule.oxsixx.src.views.layer.CardSprite")
local PlayerInfo = appdf.req(appdf.GAME_SRC .. "yule.oxsixx.src.views.layer.PlayerInfo")
-- local PopupInfoHead = appdf.req("client.src.external.PopupInfoHead")
local GameChatLayer = appdf.req(appdf.CLIENT_SRC .. "plaza.views.layer.game.GameChatLayer")
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local AnimationMgr = appdf.req(appdf.EXTERNAL_SRC .. "AnimationMgr")
local GameLogic = appdf.req(appdf.GAME_SRC .. "yule.oxsixx.src.models.GameLogic")

-- GameViewLayer.BT_SWITCH 			= 12
-- GameViewLayer.BT_SET 				= 13
-- GameViewLayer.BT_CHAT 				= 14
-- GameViewLayer.BT_HOWPLAY 			= 15
-- GameViewLayer.BT_EXIT 				= 16
-- GameViewLayer.BT_SOUND 				= 15
-- GameViewLayer.BT_TAKEBACK 			= 16

GameViewLayer.TAG_START = 100
local enumTable =
{
    "BT_START",-- 开始
    "BT_SWITCH",-- 菜单
    "BT_HELP",-- 帮助
    "BT_SET",-- 设置
    "BT_CHAT",-- 聊天
    "BT_EXIT",-- 退出
    "BT_CONFIRM",-- 确认按钮
    "BT_CHIP1",-- 下注按钮
    "BT_CHIP2",-- 下注按钮
    "BT_CHIP3",-- 下注按钮
    "BT_CHIP4",-- 下注按钮
    "NUM_CHIP",-- 下注数字
    "BT_MUL1",-- 倍数按钮
    "BT_MUL2",-- 倍数按钮
    "BT_MUL3",-- 倍数按钮
    "BT_MUL4",-- 倍数按钮
    "NUM_MUL",-- 倍数数字
    "BT_CALLBANKER",-- 叫庄
    "BT_CANCEL",-- 不叫庄
}
local TAG_ENUM = ExternalFun.declarEnumWithTable(GameViewLayer.TAG_START, enumTable);
GameViewLayer.TopZorder = 30
GameViewLayer.MenuZorder = 20
GameViewLayer.ZORDER_CHAT = 20


GameViewLayer.FRAME = 1
GameViewLayer.NICKNAME = 2
GameViewLayer.SCORE = 3
GameViewLayer.FACE = 7

GameViewLayer.TIMENUM = 1
GameViewLayer.CHIPNUM = 1
GameViewLayer.SCORENUM = 1

-- 牌间距
GameViewLayer.CARDSPACING = 35

-- GameViewLayer.VIEWID_CENTER 		= 5

GameViewLayer.RES_PATH = "game/yule/oxsixx/res/"


-- local pointCard = {cc.p(667, 617), cc.p(298, 402), cc.p(667, 110), cc.p(1028, 402)}
-- local pointClock = {cc.p(1017, 640), cc.p(88, 560), cc.p(157, 255), cc.p(1238, 560)}
-- local pointOpenCard = {cc.p(437, 625), cc.p(288, 285), cc.p(917, 115), cc.p(1038, 285)}
-- local pointTableScore = {cc.p(667, 505), cc.p(491, 410), cc.p(667, 342), cc.p(835, 410)}
-- local pointBankerFlag = {cc.p(948, 714), cc.p(159, 499), cc.p(228, 204), cc.p(1168, 495)}

local pointChat = { cc.p(767, 690), cc.p(160, 525), cc.p(230, 250), cc.p(1173, 525) }
local pointUserInfo = { cc.p(400, 655), cc.p(140, 400), cc.p(195, 100), cc.p(1180, 400), cc.p(985, 655), cc.p(695, 655) }
local anchorPoint = { cc.p(1, 1), cc.p(0, 0.5), cc.p(0, 0), cc.p(1, 0.5) }

local AnimationRes =
{
    { name = "victory", file = GameViewLayer.RES_PATH .. "animation/victory_", nCount = 19, fInterval = 0.13, nLoops = 1 },
    -- 	{name = "lose", file = GameViewLayer.RES_PATH.."animation_lose/lose_", nCount = 17, fInterval = 0.1, nLoops = 1},
    -- 	{name = "start", file = GameViewLayer.RES_PATH.."animation_start/start_", nCount = 11, fInterval = 0.15, nLoops = 1},
}

function GameViewLayer:getParentNode()
    return self._scene
end

function GameViewLayer:onInitData()
    self.bCardOut = { false, false, false, false, false }
    self.lUserMaxScore = { 0, 0, 0, 0 }
    self.cbCombineCard = { }
    self.chatDetails = { }
    self.bCanMoveCard = false
    self.cbGender = { }
    self.bBtnInOutside = false
    self.bSpecialType = false
    -- 特殊牌型标识
    self.cbSpecialCardType = 0
    -- 特殊牌型代码
    self.bIsShowMenu = false
    -- 是否显示菜单

    -- 用户头像
    self.m_tabUserHead = { }

    self.goldlist = { }
    -- 金币列表

    -- 房卡需要
    self.m_UserItem = { }
end

function GameViewLayer:onResetView()
    -- self.nodeLeaveCard:removeAllChildren()
    -- self.spriteBankerFlag:setVisible(false)
    self.spriteCalculate:setVisible(false)
    self._scene:stopAllActions()

    for i = 1, cmd.GAME_PLAYER do
        self.flag_openCard[i]:setVisible(false)
        for j = 1, cmd.MAX_CARDCOUNT do
            local pcard = self.nodeCard[i][j]
            pcard:setVisible(false)
            self:setCardTextureRect(i, j)
        end

        if self.m_tabUserHead[i] then
            self.m_tabUserHead[i]:showCallInScore("", false)
            self.m_tabUserHead[i]:hiddenMultiple()
            self.m_tabUserHead[i]:setCallingBankerStatus(false)
        end
    end

    self.bCardOut = { false, false, false, false, false }
    self.bBtnMoving = false
    self.labCardType:setString("")
    for i = 1, 3 do
        self.labAtCardPrompt[i]:setString("")
    end

    local nodeCard = self._csbNode:getChildByName("Node_Card")
    for i = 1, cmd.MAX_CARDCOUNT do
        local panelCard = nodeCard:getChildByName(string.format("Node_%d", i))
        local card = self.nodeCard[cmd.MY_VIEWID][i]
        card:setPosition(118 *(i - 1), panelCard:getContentSize().height / 2)
    end

    self.nodeChip:removeAllChildren()
    self.nodeCall:removeAllChildren()
    self.btMul = { }
    self.btConfirm:setVisible(false)
    -- 隐藏确定

    -- 移除庄家按钮
    self:setBankerUser()

    self.cbCombineCard = { }
    -- 组合扑克
    self.bSpecialType = false
    -- 特殊牌型标识
    self.cbSpecialCardType = 0
    -- 特殊牌型代码

    self._scene.bAddScore = false
    self._scene.m_lMaxTurnScore = 0

    for viewId = 1, cmd.GAME_PLAYER do
        if viewId ~= cmd.MY_VIEWID then
            self:stopCardAni(viewId)
        end
    end
end


function GameViewLayer:onExit()
    print("GameViewLayer onExit")
    self:gameDataReset()

    cc.Director:getInstance():getTextureCache():removeTextureForKey("game/card.png")

    -- cc.SpriteFrameCache:getInstance():removeSpriteFramesFromFile("gameScene_oxnew.plist")
    -- cc.Director:getInstance():getTextureCache():removeTextureForKey("gameScene_oxnew.png")
    cc.Director:getInstance():getTextureCache():removeUnusedTextures()
    cc.SpriteFrameCache:getInstance():removeUnusedSpriteFrames()

    AnimationMgr.removeCachedAnimation(cmd.VOICE_ANIMATION_KEY)
    for i = 1, #AnimationRes do
        cc.AnimationCache:getInstance():removeAnimation(AnimationRes[i].name)
    end

    -- 重置搜索路径
    local oldPaths = cc.FileUtils:getInstance():getSearchPaths();

    local newPaths = { };
    for k, v in pairs(oldPaths) do
        if tostring(v) ~= tostring(self._searchPath1) and tostring(v) ~= tostring(self._searchPath2) then
            table.insert(newPaths, v);
        end
    end
    cc.FileUtils:getInstance():setSearchPaths(newPaths);
end

function GameViewLayer:gameDataInit()
    -- 搜索路径
    local gameList = self:getParentNode():getParentNode():getApp()._gameList;
    local gameInfo = { };
    for k, v in pairs(gameList) do
        if tonumber(v._KindID) == tonumber(cmd.KIND_ID) then
            gameInfo = v;
            break;
        end
    end

    if nil ~= gameInfo._Module then
        self._searchPath = device.writablePath .. "game/" .. gameInfo._Module .. "/res/";
        cc.FileUtils:getInstance():addSearchPath(self._searchPath);
    end
end
function GameViewLayer:gameDataReset()

    -- 播放大厅背景音乐
    self.m_bMusic = false
    AudioEngine.stopMusic()
    ExternalFun.playPlazzBackgroudAudio()

    self:unLoadRes()

    -- 重置搜索路径
    local oldPaths = cc.FileUtils:getInstance():getSearchPaths()
    local newPaths = { };
    for k, v in pairs(oldPaths) do
        if tostring(v) ~= tostring(self._searchPath) then
            table.insert(newPaths, v);
        end
    end
    cc.FileUtils:getInstance():setSearchPaths(newPaths)
end

local this
function GameViewLayer:ctor(scene)
    this = self
    self._scene = scene

    self.m_tabUserItem = { }

    self:gameDataInit()

    self:onInitData()
    self:preloadUI()

    -- 牌节点
    self.nodeCard = { }
    -- 牌的类型
    self.cardType = { }
    -- --准备标志
    self.flag_ready = { }
    -- 摊牌标志
    self.flag_openCard = { }

    -- 导入资源
    self:loadRes()
    -- 初始化csb界面
    self:initCsbRes()
    -- 四个玩家
    self.nodePlayer = { }

    self:initUserInfo()

    local mgr = self._scene._scene:getApp():getVersionMgr()
    local verstr = mgr:getResVersion(cmd.KIND_ID) or "0"
    verstr = "游戏版本:" .. appdf.BASE_C_VERSION .. "." .. verstr
    self._setLayer = SetLayer:create(verstr)
    self:addChild(self._setLayer)
    self._setLayer:setLocalZOrder(30)
    self._setLayer:setVisible(false)

    -- 节点事件
    local function onNodeEvent(event)
        if event == "exit" then
            self:onExit()
        end
    end
    self:registerScriptHandler(onNodeEvent)

    -- self.nodeLeaveCard = cc.Node:create():addTo(self)

    -- 播放背景音乐
    if GlobalUserItem.bVoiceAble == true then
        AudioEngine.playMusic("sound_res/backMusic.mp3", true)
    end

    -- 房卡需要
    -- 语音按钮 gameviewlayer -> gamelayer -> clientscene
    self._scene._scene:createVoiceBtn(cc.p(1250, 200), 0, self)

    -- 语音动画
    AnimationMgr.loadAnimationFromFrame("record_play_ani_%d.png", 1, 3, cmd.VOICE_ANIMATION_KEY)


    -- 聊天，调用本地资源，不用通用
    local tabconfig = { }
    tabconfig.csbfile = cmd.RES_PATH .. "chat/GameChatLayer.csb"
    -- 图片要加入缓存
    local sprbg = cc.Sprite:create(cmd.RES_PATH .. "chat/chat_cell.png")
    if sprbg then
        cc.SpriteFrameCache:getInstance():addSpriteFrame(sprbg:getSpriteFrame(), "chat_cell.png")
        tabconfig.szItemFrameName = "chat_cell.png"
    end
    self._chatLayer = GameChatLayer:create(self._scene._gameFrame, tabconfig):addTo(self, GameViewLayer.ZORDER_CHAT)
    -- 聊天框


    -- local  btcallback = function(ref, type)
    --        if type == ccui.TouchEventType.ended then
    --         	this:onButtonClickedEvent(ref:getTag(),ref)
    --        end
    --    end

    -- 点击事件
    self:setTouchEnabled(true)
    self:registerScriptTouchHandler( function(eventType, x, y)
        return self:onEventTouchCallback(eventType, x, y)
    end )

    -- 玩家头像
    -- self.m_bNormalState = {}
end

-- 加载资源
function GameViewLayer:loadRes()
    cc.Director:getInstance():getTextureCache():addImage("game/card.png")
    -- 语音动画
    AnimationMgr.loadAnimationFromFrame("record_play_ani_%d.png", 1, 3, cmd.VOICE_ANIMATION_KEY)

end

-- 移除资源
function GameViewLayer:unLoadRes()
    -- 卡牌
    cc.Director:getInstance():getTextureCache():removeTextureForKey("game/card.png")
    -- 语音动画
    AnimationMgr.removeCachedAnimation(cmd.VOICE_ANIMATION_KEY)

    cc.Director:getInstance():getTextureCache():removeUnusedTextures()
    cc.SpriteFrameCache:getInstance():removeUnusedSpriteFrames()

end

-- 加载csb
function GameViewLayer:initCsbRes()

    local rootLayer, csbNode = ExternalFun.loadRootCSB("game/GameScene.csb", self)
    self._csbNode = csbNode


    self:initMenus()
    self:initButtonEvent()
    -- self:gameClean()

    -- self:showUserInfo(self._scene:GetMeUserItem())

    -- 卡牌
    local nodeCard = self._csbNode:getChildByName("Node_Card")
    for i = 1, cmd.GAME_PLAYER do
        local panelCard = nodeCard:getChildByName(string.format("Node_%d", i))
        local cardState = panelCard:getChildByName("Sprite_state")
        cardState:setLocalZOrder(9)
        self.flag_openCard[i] = cardState
        -- 牌类型
        self.nodeCard[i] = { }
        for j = 1, cmd.MAX_CARDCOUNT do
            local pcard = CardSprite:createCard()
            pcard:setVisible(false)
            pcard:setTag(j)
            panelCard:addChild(pcard)
            pcard:setLocalZOrder(j)
            table.insert(self.nodeCard[i], pcard)
            self:setCardTextureRect(i, j)
            if i == cmd.MY_VIEWID then
                pcard:setPosition(118 *(j - 1), panelCard:getContentSize().height / 2)
            else
                pcard:setPosition(28 *(j - 1), panelCard:getContentSize().height / 2)
                pcard:setScale(0.8)
            end

        end
    end


    for i = 1, cmd.GAME_PLAYER do
        -- 准备标识
        self.flag_ready[i] = self._csbNode:getChildByName("ready_" .. i)
        self.flag_ready[i]:setVisible(false)
    end

    -- 倒计时
    self._clockTimeBg = self._csbNode:getChildByName("Sprite_clockBg")
    self._clockTime = self._clockTimeBg:getChildByName("num_clock")
    self._clockTime:setString("30")
    self:setClockVisible(false)
    self:setClockBgVisible(false)

    -- 计分器
    self.spriteCalculate = self._csbNode:getChildByName("FileNode_calculate")
    self.spriteCalculate:setVisible(false)

    -- 牌值
    self.labAtCardPrompt = { }
    for i = 1, 3 do
        self.labAtCardPrompt[i] = self.spriteCalculate:getChildByName(string.format("Text_num%d", i))
    end
    self.labCardType = self.spriteCalculate:getChildByName("Text_num4")

end

function GameViewLayer:initMenus()
    local _menusMask = ccui.ImageView:create()
    _menusMask:setContentSize(cc.size(yl.WIDTH, yl.HEIGHT))
    _menusMask:setScale9Enabled(true)
    _menusMask:setPosition(yl.WIDTH / 2, yl.HEIGHT / 2)
    _menusMask:setTouchEnabled(true)
    self:addChild(_menusMask, GameViewLayer.MenuZorder)
    _menusMask:addTouchEventListener( function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            _menusMask:setVisible(false)
        end
    end )

    self._menu = _menusMask
    self._menu:setVisible(false)
    local layer, node = ExternalFun.loadRootCSB("game/Menus.csb", _menusMask)
    self.nodeMenu = node:getChildByName("menu")

end

function GameViewLayer:initButtonEvent()

    local btcallback = function(ref, type)
        if type == ccui.TouchEventType.ended then
            this:onButtonClickedEvent(ref:getTag(), ref)
        end
    end

    -- 四个下注的筹码按钮
    self.nodeChip = self._csbNode:getChildByName("Node_score")
    self.nodeCallMul = self._csbNode:getChildByName("Node_callMul")
    self.btChip = { }
    self.btMul = { }

    -- 叫庄按钮
    self.nodeCall = self._csbNode:getChildByName("Node_call")

    -- 不庄按钮
    self.btCancel = self.nodeCall:getChildByName("Button_nocall")
    assert(nil ~= self.btCancel)
    self.btCancel:setTag(TAG_ENUM.BT_CANCEL)

    -- 菜单按钮
    self.btSwitch = self._csbNode:getChildByName("Button_switch")
    :setTag(TAG_ENUM.BT_SWITCH)
    self.btSwitch:addTouchEventListener(btcallback)

    -- 开始
    self.btStart = self._csbNode:getChildByName("Button_start")
    :setTag(TAG_ENUM.BT_START)
    self.btStart:addTouchEventListener(btcallback)
    self.btStart:setVisible(false)

    -- 帮助
    local btn = self.nodeMenu:getChildByName("Button_help")
    btn:addTouchEventListener(btcallback)
    btn:setTag(TAG_ENUM.BT_HELP)
    -- 设置
    local btn = self.nodeMenu:getChildByName("Button_set")
    btn:addTouchEventListener(btcallback)
    btn:setTag(TAG_ENUM.BT_SET)
    -- 退出
    local btn = self.nodeMenu:getChildByName("Button_leave")
    btn:addTouchEventListener(btcallback)
    btn:setTag(TAG_ENUM.BT_EXIT)
    -- 聊天
    local btn = self.nodeMenu:getChildByName("Button_chat")
    btn:addTouchEventListener(btcallback)
    btn:setTag(TAG_ENUM.BT_CHAT)

    -- 确认按钮
    self.btConfirm = self._csbNode:getChildByName("Button_confirm")
    self.btConfirm:addTouchEventListener(btcallback)
    self.btConfirm:setTag(TAG_ENUM.BT_CONFIRM)
    self.btConfirm:setVisible(false)

    self.btConfirm.text = self.btConfirm:getChildByName("text")
    assert(self.btConfirm.text)
end

function GameViewLayer:initUserInfo()
    local nodeName =
    {
        "FileNode_1",
        "FileNode_2",
        "FileNode_3",
        "FileNode_4",
        "FileNode_5",
        "FileNode_6",
    }

    local faceNode = self._csbNode:getChildByName("Node_User")
    print("faceNode", faceNode)
    self.nodePlayer = { }
    for i = 1, cmd.GAME_PLAYER do
        self.nodePlayer[i] = faceNode:getChildByName(nodeName[i])
        self.nodePlayer[i]:setLocalZOrder(1)
        self.nodePlayer[i]:setVisible(true)
    end
end


-- 更新用户显示
function GameViewLayer:OnUpdateUser(viewId, userItem)
    if not viewId or viewId == yl.INVALID_CHAIR then
        print("OnUpdateUser viewId is nil")
        return
    end


    if nil == userItem then
        return
    end

    self.m_UserItem[viewId] = userItem

    local bReady = userItem.cbUserStatus == yl.US_READY
    print("更新用户显示 viewId bReady", viewId, bReady)
    self:setReadyVisible(viewId, bReady)

    if viewId == cmd.MY_VIEWID then 
        self.m_userlScore = userItem.lScore
        print("----------------ddddddddddddddddd-------------------"..self.m_userlScore)
    end
    print("self.m_tabUserHead[viewId]", self.m_tabUserHead[viewId])
    if nil == self.m_tabUserHead[viewId] then

        local playerInfo = PlayerInfo:create(userItem, viewId)
        self.m_tabUserHead[viewId] = playerInfo

        self.m_tabUserHead[viewId]:updateStatus()

        self.nodePlayer[viewId]:addChild(playerInfo)
        self.nodePlayer[viewId]:setVisible(true)
    else
        self.m_tabUserHead[viewId].m_userItem = userItem
        self.m_tabUserHead[viewId]:updateStatus()
    end

    -- 判断房主
    if PriRoom and GlobalUserItem.bPrivateRoom then
        if userItem.dwUserID == PriRoom:getInstance().m_tabPriData.dwTableOwnerUserID then
            self.m_tabUserHead[viewId]:showRoomHolder(true)
        else
            self.m_tabUserHead[viewId]:showRoomHolder(false)
        end
    end
end

-- ****************************      计时器        *****************************--
function GameViewLayer:OnUpdataClockView(viewId, time)
    -- print("计时器,viewId,time",viewId,time)
    if not viewId or viewId == yl.INVALID_CHAIR or not time then
        self._clockTime:setString("")
        self:setClockVisible(false)
    else
        self:setClockVisible(true)
        self._clockTime:setString(time)
    end
end

-- function GameViewLayer:setClockPosition(viewId)
-- 	if viewId then
-- 		self._clockTimeBg:move(pointClock[viewId])
-- 	else
-- 		self._clockTimeBg:move(display.cx, display.cy + 50)
-- 	end
--     self._clockTime:setVisible(true)
-- end

-- **************************      点击事件        ****************************--
-- 点击事件
function GameViewLayer:onEventTouchCallback(eventType, x, y)
    if eventType == "began" then
        print("btgin eventType,x,y", eventType, x, y)
        -- if self.bBtnInOutside then
        -- 	self:onButtonSwitchAnimate()
        -- 	return false
        -- end
    elseif eventType == "ended" then
        print("begin eventType,x,y", eventType, x, y)
        -- 用于触发手牌
        if self.bCanMoveCard ~= true then
            return false
        end
        local nodeCard = self._csbNode:getChildByName("Node_Card")
        local panelCard = nodeCard:getChildByName(string.format("Node_%d", cmd.MY_VIEWID))
        -- local size1 = self.nodeCard[cmd.MY_VIEWID][1]:getTextureRect()   --getContentSize()
        -- local pos1 = cc.p(self.nodeCard[cmd.MY_VIEWID][1]:getPositionX(),self.nodeCard[cmd.MY_VIEWID][1]:getPositionY())
        -- pos1 = panelCard:convertToWorldSpace(pos1)
        for i = 1, 5 do
            local card = self.nodeCard[cmd.MY_VIEWID][i]
            local pos2 = cc.p(card:getPositionX(), card:getPositionY())
            local pos2World = panelCard:convertToWorldSpace(pos2)
            local size2 = card:getTextureRect()
            -- getContentSize()
            local rect = card:getTextureRect()
            local pos = cc.p(pos2World.x - size2.width / 2, pos2World.y - size2.height / 2)
            rect.x = pos.x
            -- x1 - size1.width/2 + x2 - size2.width/2
            rect.y = pos.y
            -- y1 - size1.height/2 + y2 - size2.height/2
            -- dump(rect,"点击事件",5)
            if cc.rectContainsPoint(rect, cc.p(x, y)) then
                if false == self.bCardOut[i] then
                    -- 检测是否有三个牌了
                    local selcetNum = 0
                    for j = 1, #self.bCardOut do
                        if true == self.bCardOut[j] then
                            selcetNum = selcetNum + 1
                        end
                    end
                    if selcetNum >= 3 then
                        print("已经有三张牌弹出")
                        card:runAction(cc.Sequence:create(cc.MoveBy:create(0.1, cc.p(0, 10)), cc.MoveBy:create(0.1, cc.p(0, -10))))
                        return
                    else
                        card:runAction(cc.MoveTo:create(0.2, cc.p(pos2.x, pos2.y + 20)))
                    end
                    -- card:move(pos2.x, pos2.y + 30)
                    -- self.cardFrame[i]:setSelected(true)
                elseif true == self.bCardOut[i] then
                    -- card:move(pos2.x, pos2.y - 30)
                    card:runAction(cc.MoveTo:create(0.25, cc.p(pos2.x, pos2.y - 20)))
                    -- self.cardFrame[i]:setSelected(false)
                end
                self.bCardOut[i] = not self.bCardOut[i]
                self:updateCardPrompt()
                return true
            end
        end
    end
    return true
end

-- 按钮点击事件
function GameViewLayer:onButtonClickedEvent(tag, ref)
    if tag == TAG_ENUM.BT_START then
        -- 开始
        self.btStart:setVisible(false)
        self._scene:onStartGame()
    elseif tag == TAG_ENUM.BT_SWITCH then
        -- 菜单
        self:onButtonSwitchAnimate()
    elseif tag == TAG_ENUM.BT_CHAT then
        self._menu:setVisible(false)
        self._chatLayer:showGameChat(true)
    elseif tag == TAG_ENUM.BT_SET then
        print("设置")
        self._menu:setVisible(false)
        self._setLayer:showLayer(true)
    elseif tag == TAG_ENUM.BT_HELP then
        print("玩法")
        self._menu:setVisible(false)
        self._scene._scene:popHelpLayer2(cmd.KIND_ID, 0, yl.ZORDER.Z_HELP_WEBVIEW)
    elseif tag == TAG_ENUM.BT_EXIT then
        self._menu:setVisible(false)
        self._scene:onQueryExitGame()
    elseif tag == TAG_ENUM.BT_CONFIRM then
        self:onButtonConfirm(cmd.MY_VIEWID)
        self._scene:onOpenCard(self.cbCombineCard)
        dump(self.cbCombineCard, "the orignal cards")
    elseif tag == TAG_ENUM.BT_PROMPT then
        self:promptOx()
    elseif tag == TAG_ENUM.BT_CALLBANKER then
        for i = 1, #self.btMul do
            self.btMul[i]:setVisible(false)
        end
        self:showCallBankerMul()
    elseif tag == TAG_ENUM.BT_CANCEL then
        for i = 1, #self.btMul do
            self.btMul[i]:setVisible(false)
        end
        self._scene:onBanker(false, 0)
    elseif tag - TAG_ENUM.BT_CHIP1 == 0 or tag - TAG_ENUM.BT_CHIP1 == 1 or tag - TAG_ENUM.BT_CHIP1 == 2 or tag - TAG_ENUM.BT_CHIP1 == 3 or tag - TAG_ENUM.BT_CHIP1 == 4 then
        self.nodeChip:removeAllChildren()
        local index = tag - TAG_ENUM.BT_CHIP1 + 1
        dump(self.lUserJettonScore, "lUserJettonScore")
        print("index", index)
        print("score is .....", self.lUserJettonScore[index])

        if self.lUserJettonScore[index] > self._scene.m_lMaxTurnScore then
            self.lUserJettonScore[index] = self._scene.m_lMaxTurnScore
        end
        self:getParentNode():onAddScore(self.lUserJettonScore[index])
    elseif tag - TAG_ENUM.BT_MUL1 == 0 or tag - TAG_ENUM.BT_MUL1 == 1 or tag - TAG_ENUM.BT_MUL1 == 2 or tag - TAG_ENUM.BT_MUL1 == 3 or tag - TAG_ENUM.BT_MUL1 == 4 then
        for i = 1, #self.btMul do
            self.btMul[i]:setVisible(false)
        end
        local index = tag - TAG_ENUM.BT_MUL1 + 1

        print("index", index)
        self._scene:onBanker(true, index)

    else
        print("tag", tag)
        showToast(self, "功能尚未开放！", 1)
    end
end

-- 自己开牌视图
function GameViewLayer:onButtonConfirm(viewid)
    self.bCanMoveCard = false
    -- 牌是否可以移动
    self.btConfirm:setVisible(false)
    -- 隐藏确定框
    self.spriteCalculate:setVisible(false)
    -- 隐藏计算框
    local nodeCard = self._csbNode:getChildByName("Node_Card")
    local panelCard = nodeCard:getChildByName(string.format("Node_%d", viewid))

    -- 牌回复位置
    for i = 1, cmd.MAX_CARDCOUNT do
        local card = self.nodeCard[cmd.MY_VIEWID][i]
        card:setPosition(118 *(i - 1), panelCard:getContentSize().height / 2)
    end
end

function GameViewLayer:onButtonSwitchAnimate()
    self._menu:setVisible(true)
end

-- 叫庄
function GameViewLayer:gameCallBanker(callBankerViewId, bFirstTimes)
    if callBankerViewId == cmd.MY_VIEWID then
        if self._scene.cbDynamicJoin == 0 then
            print("self.btCallBanker", self.btCallBanker)
            self:showCallBankerMul()
        end
    end

    for i = 1, cmd.GAME_PLAYER do
        local viewid = self._scene:SwitchViewChairID(i - 1)
        if self.m_tabUserHead[viewid] then
            self.m_tabUserHead[viewid]:hiddenMultiple()
            self.m_tabUserHead[viewid]:showFlashBg(false)
            if viewid ~= cmd.MY_VIEWID then
                self.m_tabUserHead[viewid]:setCallingBankerStatus(true)
            end
        end
    end

    -- 背景闪烁
    self.m_tabUserHead[callBankerViewId]:showFlashBg(true)

    if bFirstTimes then

    end
end
function GameViewLayer:setCallMultiple(callBankerViewId, multiple)
    if self.m_tabUserHead[callBankerViewId] ~= nil then
        self.m_tabUserHead[callBankerViewId]:setMultiple(multiple)
    end
end

function GameViewLayer:setBankerMultiple(BankerViewId)
    for i = 1, cmd.GAME_PLAYER do
        local viewid = self._scene:SwitchViewChairID(i - 1)
        if self.m_tabUserHead[viewid] then
            if viewid ~= BankerViewId then
                self:runAction(cc.Sequence:create(cc.DelayTime:create(1.0),
                cc.CallFunc:create( function()
                    self.m_tabUserHead[viewid]:hiddenMultiple()
                end )))
            else

                if self.m_tabUserHead[viewid]:getMultiple() == 0 then
                    self:setCallMultiple(viewid, 1)
                end

            end
            self.m_tabUserHead[viewid]:setCallingBankerStatus(false)
        end
    end
end

function GameViewLayer:setBankerWaitIcon(ViewId, isShow, isNoraml)
    if self.m_tabUserHead[ViewId] then
        print("ViewId is ", ViewId)
        self.m_tabUserHead[ViewId]:setBankerWaitStatus(isShow, isNoraml, ViewId)
    end

end

-- 显示叫庄倍数
function GameViewLayer:showCallBankerMul(visiable)

    if self._scene.cbDynamicJoin == 1 then
        return
    end

    if visiable == 0 then
        self.nodeCall:removeAllChildren()
        self.btMul = { }
        return
    end

    local btcallback = function(ref, type)
        if type == ccui.TouchEventType.ended then
            this:onButtonClickedEvent(ref:getTag(), ref)
            if ref:getTag() ~= 118 then
                print("the tag ", ref:getTag())
                self:playEffect("rober_bank_", GlobalUserItem.cbGender)
            end
        end
    end
    self.nodeCallMul:removeAllChildren()
    -- 配置下注积分的数目
    local tabStr = { "1 倍", "2 倍", "3 倍", "4 倍", "5 倍", "不 叫" }
    for i = 1, 6 do
        -- 按钮
        if self.btMul[i] == nil then
            self.btMul[i] = ccui.Button:create("common/btn_yellow.png")
            :move(260 + 170 *(i - 1), 210)
            :setTag(TAG_ENUM.BT_MUL1 + i - 1)
            :setVisible(true)
            :addTo(self.nodeCall)
            self.btMul[i]:addTouchEventListener(btcallback)
            self.btMul[i]:setScaleX(0.8)
            -- 倍数
            if i < 6 then
                if (self.m_userlScore >=(self._scene.lCellScore * 5 * 4 * 4 * i)) then
                    self.btMul[i]:setEnabled(true)
                else
                    self.btMul[i]:setEnabled(false)
                end
            end
            local label = display.newSprite(GameViewLayer.RES_PATH .. string.format("game/Sprite_btnMul%d.png", i))
            :setTag(TAG_ENUM.NUM_MUL)
            :addTo(self.btMul[i])
            :move(cc.p(self.btMul[i]:getContentSize().width / 2, self.btMul[i]:getContentSize().height / 2))
            if i == 6 then
                self.btMul[i]:setTag(TAG_ENUM.BT_CANCEL)
            end
        end
        self.btMul[i]:setVisible(true)
        self.btMul[i]:move(260 + 170 *(i - 1), 210)
        -- 动画
        self.btMul[i]:runAction(cc.Sequence:create(
        cc.DelayTime:create(0.1 *(i - 1)),
        cc.MoveBy:create(0.1, cc.p(0, 25)),
        cc.MoveBy:create(0.1, cc.p(0, -15))
        ))
    end
end

-- 游戏开始
function GameViewLayer:showChipBtn(bankerViewId)
    -- dump(self.btChip)
    if bankerViewId ~= cmd.MY_VIEWID then
        if self._scene.cbDynamicJoin == 0 then
            for i = 1, #self.btChip do
                self.btChip[i]:setVisible(true)
            end
        end
    end
end

function GameViewLayer:resetEffect()
    -- 停止闪烁
    for i = 1, cmd.GAME_PLAYER do
        local viewid = self._scene:SwitchViewChairID(i - 1)
        if self.m_tabUserHead[viewid] then
            self.m_tabUserHead[viewid]:showFlashBg(false)
        end
    end
end

function GameViewLayer:setCombineCard(data)
    self.cbCombineCard = clone(data)
end

function GameViewLayer:setSpecialInfo(bSpecial, cardType)


    -- 还有一种无牛的情况 扑克也不可操作
    if not GameLogic:getOxCard(self.cbCombineCard) and not bSpecial then
        self.bSpecialType = true
        self.cbSpecialCardType = 0
        self.bCanMoveCard = false

        return
    end

    self.bSpecialType = bSpecial
    self.bCanMoveCard = not bSpecial
    if cardType then
        self.cbSpecialCardType = cardType
    end
end

function GameViewLayer:gameAddScore(viewId, score)

    self.m_tabUserHead[viewId]:showCallInScore(score, true)
    -- self.nodePlayer[viewId]:setVisible(true)

    -- 自己下注, 隐藏下注信息
    -- if viewId == cmd.MY_VIEWID then
    -- 	for i = 1, #self.btChip do
    --      self.btChip[i]:setVisible(false)
    --  end
    -- end
end

-- 发牌
function GameViewLayer:gameSendCard(firstViewId, sendCount)

    print("开始发牌")
    if sendCount == 0 then
        print("发牌数为0")
        return
    end

    -- 开始发牌
    local wViewChairId = firstViewId
    -- 首先发牌的玩家
    local delayTime = 0.12
    -- 等待时间
    local actionList = { }
    local playerCount = 0
    -- 游戏人数
    for i = 1, cmd.GAME_PLAYER do
        if self:getParentNode():isPlayerPlaying(wViewChairId) then
            playerCount = playerCount + 1
            local function callbackWithArgsSendCard(viewid, count)
                local ret = function()
                    self:sendCardAnimate(viewid, count)
                    if self._scene:getPlayNum() == playerCount then
                        self._scene:sendCardFinish()
                    end
                end
                return ret
            end
            table.insert(actionList, cc.DelayTime:create(delayTime *(playerCount - 1)))
            table.insert(actionList, cc.CallFunc:create(callbackWithArgsSendCard(wViewChairId, sendCount)))
        end
        wViewChairId = wViewChairId + 1
        if wViewChairId > 6 then
            wViewChairId = 1
        end
    end
    self:runAction(cc.Sequence:create(actionList))
end

-- parm viewId 发送到哪一个位置
-- parm count 发送的数量
function GameViewLayer:sendCardAnimate(viewId, sendCount)
    print("viewId,sendCount", viewId, sendCount)
    local nodeCard = self._csbNode:getChildByName("Node_Card")
    local panelCard = nodeCard:getChildByName(string.format("Node_%d", viewId))
    self.animateCard = self._csbNode:getChildByName("Node_AniCard")
    for i = 1, sendCount do
        -- 用于发牌动作的牌
        local card = CardSprite:createCard()
        card:setScale(0.8)
        card:setVisible(true)
        self.animateCard:addChild(card)
        card:setLocalZOrder(i)
        card:setTag(i)
        -- 开始位置
        local beginpos = cc.p(card:getPositionX(), card:getPositionY())
        -- 结束位置
        local endpos = cc.p(0, 0)
        local spawn = nil
        local moveTime = 0.3
        -- 获取目标地点相对于玩家手牌的相对位置
        local index = i
        -- 牌的索引
        -- 特殊处理4号位的玩家
        if viewId == 4 then
            if sendCount == 1 then
                index = 1
            elseif sendCount == 4 then
                index = i + 1
            end
        else
            if sendCount == 1 then
                index = 5
            end
        end
        if viewId == cmd.MY_VIEWID then
            local posWorld = panelCard:convertToWorldSpace(cc.p(118 *(index - 1), panelCard:getContentSize().height / 2))
            endpos = self.animateCard:convertToNodeSpace(posWorld)
            spawn = cc.Spawn:create(self:getMoveActionEx(moveTime, beginpos, endpos), cc.ScaleTo:create(moveTime, 1))
        else
            local posWorld = panelCard:convertToWorldSpace(cc.p(28 *(index - 1), panelCard:getContentSize().height / 2))
            endpos = self.animateCard:convertToNodeSpace(posWorld)
            spawn = cc.Spawn:create(self:getMoveActionEx(moveTime, beginpos, endpos), cc.ScaleTo:create(moveTime, 0.5))
        end
        card:runAction(cc.Sequence:create(
        cc.DelayTime:create((i - 1) * 0.02),
        spawn,
        cc.CallFunc:create( function()
            card:removeFromParent()
            if viewId == cmd.MY_VIEWID then
                self:openCardAnimate(viewId, index)
            end
            if viewId ~= cmd.MY_VIEWID and(sendCount == cmd.MAX_CARDCOUNT or sendCount == 1) then
                self:setOpenCardVisible(viewId, true, false)
                self:puttingCardAni(viewId)
            end
            print("viewId,index", viewId, index)
            self.nodeCard[viewId][index]:setVisible(true)
        end )
        ))
    end
end

-- 摆牌动画
function GameViewLayer:puttingCardAni(viewId)
    for i = 1, cmd.MAX_CARDCOUNT do
        local action = cc.Sequence:create(cc.MoveBy:create(0.1, cc.p(0, 10)), cc.MoveBy:create(0.1, cc.p(0, -10)))
        local repaction = cc.RepeatForever:create(cc.Sequence:create(cc.DelayTime:create(i * 0.05), action, cc.DelayTime:create((cmd.MAX_CARDCOUNT - i) * 0.05)))
        local card = self.nodeCard[viewId][i]
        if nil ~= card then
            card:stopAllActions()
            card:runAction(repaction)
        end
    end
end

-- 停止卡牌摆牌运动
function GameViewLayer:stopCardAni(wViewChairId)
    if wViewChairId ~= cmd.MY_VIEWID then
        local nodeCard = self._csbNode:getChildByName("Node_Card")
        local panelCard = nodeCard:getChildByName(string.format("Node_%d", wViewChairId))
        for i = 1, cmd.MAX_CARDCOUNT do
            self.nodeCard[wViewChairId][i]:stopAllActions()
            self.nodeCard[wViewChairId][i]:setPosition(28 *(i - 1), panelCard:getContentSize().height / 2)

        end
    end
end



-- 获取移动动画
-- inorout,0表示加速飞出,1表示加速飞入
-- isreverse,0表示不反转,1表示反转
function GameViewLayer:getMoveActionEx(time, startPoint, endPoint, height, angle)
    -- 把角度转换为弧度
    angle = angle or 90
    height = height or 50
    local radian = angle * 3.14159 / 180.0
    -- 第一个控制点为抛物线左半弧的中点
    local q1x = startPoint.x +(endPoint.x - startPoint.x) / 4.0;
    local q1 = cc.p(q1x, height + startPoint.y + math.cos(radian) * q1x);
    -- 第二个控制点为整个抛物线的中点
    local q2x = startPoint.x +(endPoint.x - startPoint.x) / 2.0;
    local q2 = cc.p(q2x, height + startPoint.y + math.cos(radian) * q2x);
    -- 曲线配置
    local bezier = {
        q1,
        q2,
        endPoint
    }
    -- 使用EaseInOut让曲线运动有一个由慢到快的变化，显得更自然
    local beaction = cc.BezierTo:create(time, bezier)
    -- if inorout == 0 then
    local easeoutaction = cc.EaseOut:create(beaction, 1)
    return easeoutaction
    -- else
    -- return cc.EaseIn:create(beaction, 1)
    -- end
end

-- 获取移动动画
-- inorout,0表示加速飞出,1表示加速飞入
-- isreverse,0表示不反转,1表示反转
-- function GameViewLayer:getMoveAction(time,beginpos, endpos, inorout, isreverse)
--     local offsety = (endpos.y - beginpos.y)*0.7
--     local controlpos = cc.p(beginpos.x, beginpos.y+offsety)
--     if isreverse == 1 then
--         offsety = (beginpos.y - endpos.y)*0.7
--         controlpos = cc.p(endpos.x, endpos.y+offsety)
--     end
--     local bezier = {
--         controlpos,
--         endpos,
--         endpos
--     }
--     local beaction = cc.BezierTo:create(time, bezier)
--     if inorout == 0 then
--         return cc.EaseOut:create(beaction, 1)
--     else
--         return cc.EaseIn:create(beaction, 1)
--     end
-- end

-- 开牌动画 --viewid 玩家视图位置  index 
function GameViewLayer:openCardAnimate(viewid, index)
    local scaleMul = viewid == cmd.MY_VIEWID and 1 or 0.8
    if index then
        -- 单张牌
        local card = self.nodeCard[viewid][index]
        card:runAction(cc.Sequence:create(
        cc.ScaleTo:create(0.15, 0.1, scaleMul),
        cc.CallFunc:create( function()
            self._scene:openOneCard(viewid, index)
        end ),
        cc.ScaleTo:create(0.15, scaleMul, scaleMul)
        ))
    else
        -- 五张牌
        for i = 1, cmd.MAX_CARDCOUNT do
            local card = self.nodeCard[viewid][i]
            card:runAction(cc.Sequence:create(
            cc.DelayTime:create(i * 0.05),
            cc.ScaleTo:create(0.15, 0.1, scaleMul),
            cc.CallFunc:create( function()
                self._scene:openOneCard(viewid, i, true)
            end ),
            cc.ScaleTo:create(0.15, scaleMul, scaleMul)
            ))
        end
    end
end
function GameViewLayer:resetCardByType(cards, cardType)
    -- dump(cards, "the card data =====")
    -- dump(cardType, "the card type =====")
    for i = 1, cmd.GAME_PLAYER do
        for idx = 1, cmd.MAX_CARDCOUNT do
            if cards[i] and cardType[i] and(cards[i][idx] ~= 0) and(cardType[i] >= 0) then
                local viewId = self._scene:SwitchViewChairID(i - 1)
                local card = self.nodeCard[viewId][idx]
                assert(card)
                local nodeCard = self._csbNode:getChildByName("Node_Card")
                local panelCard = nodeCard:getChildByName(string.format("Node_%d", viewId))
                local posX =(viewId == cmd.MY_VIEWID) and 118 *(idx - 1) or 28 *(idx - 1)
                if (cardType[i] > 0 and idx > 3) then
                    posX = posX +((viewId == cmd.MY_VIEWID) and 40 or 25)
                end

                card:setPosition(posX, panelCard:getContentSize().height / 2)
            end
        end
    end
end

-- 开牌
function GameViewLayer:gameOpenCard(wViewChairId, cbOx)

    -- 开牌动画
    -- self:openCardAnimate(wViewChairId)
    -- 牌型
    if cbOx >= 10 then
        self._scene:PlaySound(GameViewLayer.RES_PATH .. "sound/GAME_OXOX.wav")
        cbOx = 10
    end

    -- 隐藏摊牌图标
    self:setOpenCardVisible(wViewChairId, false)
    -- 声音
    if bEnded and wViewChairId == cmd.MY_VIEWID then
        local strGender = "GIRL"
        if self.cbGender[wViewChairId] == 1 then
            strGender = "BOY"
        end
        local strSound = GameViewLayer.RES_PATH .. "sound/" .. strGender .. "/ox_" .. cbOx .. ".MP3"
        self._scene:PlaySound(strSound)
    end
end

-- 游戏结束
function GameViewLayer:gameEnd(lScore, lCardType)
    -- 移除
    self.nodeChip:removeAllChildren()
    self.nodeCall:removeAllChildren()
    self.btMul = { }
    self.btConfirm:setVisible(false)

    local bankerViewId = self._scene:SwitchViewChairID(self._scene.wBankerUser)

    local index = self._scene:GetMeChairID() + 1
    local bMeWin = lScore[index] > 0
    if bMeWin then
        self:playEffect("gameWin.mp3")
        local animate = self:getAnimate("victory", true)
        local spVictioy = display.newSprite(GameViewLayer.RES_PATH .. "animation/victory_1.png")
        spVictioy:setPosition(cc.p(display.width / 2, display.height / 2 + 50))
        self:addChild(spVictioy, 11)
        spVictioy:runAction(animate)
    else
        self:playEffect("gameLose.mp3")
    end

    self.btStart:setVisible(true)
    -- 隐藏牌信息
    self.spriteCalculate:setVisible(false)

    local action = { }
    -- 动画表
    local loseList = { }
    -- 输家
    local winList = { }
    -- 赢家
    self.goldList = { }
    -- 金币
    for i = 1, cmd.GAME_PLAYER do

        -- 类型
        local viewid = self._scene:SwitchViewChairID(i - 1)
        -- 分数
        self:runWinLoseAnimate(viewid, lScore[i])
        dump(self._scene.cbPlayStatus, "play status")
        dump(self._scene.cbCardData, "the card data is ")

        if (self._scene.cbCardData and #self._scene.cbCardData > 0 and self._scene.cbPlayStatus and self._scene.cbPlayStatus[i] > 0) then

            if self._scene.cbCardData[i][1] ~= 0 and lCardType[i] then
                print("lCardType[i]", lCardType[i])

                if lCardType[i] >= 0 and lCardType[i] <= 10 then
                    print("lCardType[i]", lCardType[i])
                    local sprFlag = cc.Sprite:create(GameViewLayer.RES_PATH .. string.format("game/ox_%d.png", lCardType[i]))
                    self.flag_openCard[viewid]:setSpriteFrame(sprFlag:getSpriteFrame())
                    self.flag_openCard[viewid]:setVisible(true)
                    if viewid == cmd.MY_VIEWID then
                        local soundFile = "niu_" .. string.format("%d_", lCardType[i])
                        self:playEffect(soundFile, GlobalUserItem.cbGender)
                    end

                elseif lCardType[i] > 10 then
                    -- 特殊牌型
                    print("type value is =====", lCardType[i])
                    local soundFile
                    local cardType = "game/ox_0.png"
                    if self._scene.m_tabPrivateRoomConfig.cardType == cmd.CARDTYPE_CONFIG.CT_CLASSIC then
                        -- 经典模式
                        if lCardType[i] == GameLogic.CT_CLASSIC_OX_VALUE_FOURFLOWER then
                            -- 四花牛
                            cardType = "ox_11.png"
                        elseif lCardType[i] == GameLogic.CT_CLASSIC_OX_VALUE_FIVEFLOWER then
                            -- 五花牛
                            cardType = "ox_12.png"
                            soundFile = "niu_wuhua_"
                        elseif lCardType[i] == GameLogic.CT_CLASSIC_OX_VALUE_SHUNZI then
                            -- 顺子
                            cardType = "ox_13.png"
                        elseif lCardType[i] == GameLogic.CT_CLASSIC_OX_VALUE_SAMEFLOWER then
                            -- 同花
                            cardType = "ox_14.png"
                        elseif lCardType[i] == GameLogic.CT_CLASSIC_OX_VALUE_HULU then
                            -- 葫芦
                            cardType = "ox_15.png"
                        elseif lCardType[i] == GameLogic.CT_CLASSIC_OX_VALUE_BOMB then
                            -- 炸弹
                            cardType = "ox_16.png"
                            soundFile = "niu_sizha_"
                        elseif lCardType[i] == GameLogic.CT_CLASSIC_OX_VALUE_TONGHUASHUN then
                            -- 同花顺
                            cardType = "ox_17.png"
                        elseif lCardType[i] == GameLogic.CT_CLASSIC_OX_VALUE_FIVESNIUNIU then
                            -- 五小牛	
                            cardType = "ox_18.png"
                            soundFile = "niu_5_s_"
                        end
                    elseif self._scene.m_tabPrivateRoomConfig.cardType == cmd.CARDTYPE_CONFIG.CT_ADDTIMES then
                        -- 疯狂加倍

                        if lCardType[i] == GameLogic.CT_ADDTIMES_OX_VALUE_SHUNZI then
                            -- 顺子
                            cardType = "ox_13.png"
                        elseif lCardType[i] == GameLogic.CT_ADDTIMES_OX_VALUE_SAMEFLOWER then
                            -- 同花
                            cardType = "ox_14.png"
                        elseif lCardType[i] == GameLogic.CT_ADDTIMES_OX_VALUE_HULU then
                            -- 葫芦
                            cardType = "ox_15.png"
                        elseif lCardType[i] == GameLogic.CT_ADDTIMES_OX_VALUE_FOURFLOWER then
                            -- 四花牛
                            cardType = "ox_11.png"
                        elseif lCardType[i] == GameLogic.CT_ADDTIMES_OX_VALUE_FIVEFLOWER then
                            -- 五花牛
                            cardType = "ox_12.png"
                            soundFile = "niu_wuhua_"
                        elseif lCardType[i] == GameLogic.CT_ADDTIMES_OX_VALUE_FIVESNIUNIU then
                            -- 五小牛
                            cardType = "ox_18.png"
                            soundFile = "niu_5_s_"
                        elseif lCardType[i] == GameLogic.CT_ADDTIMES_OX_VALUE_BOMB then
                            -- 炸弹
                            cardType = "ox_16.png"
                            soundFile = "niu_sizha_"
                        elseif lCardType[i] == GameLogic.CT_ADDTIMES_OX_VALUE_TONGHUASHUN then
                            -- 同花顺
                            cardType = "ox_17.png"
                        end
                    end

                    assert(cardType ~= nil)
                    local sprFlag = cc.Sprite:create(GameViewLayer.RES_PATH .. "game/" .. cardType)
                    assert(sprFlag)
                    self.flag_openCard[viewid]:setSpriteFrame(sprFlag:getSpriteFrame())
                    self.flag_openCard[viewid]:setVisible(true)

                    if soundFile and(viewid == cmd.MY_VIEWID) then
                        self:playEffect(soundFile, GlobalUserItem.cbGender)
                    end
                end
            end
        end

        -- 赢输列表
        local viewid = self._scene:SwitchViewChairID(i - 1)
        if lScore[i] ~= 0 and viewid ~= bankerViewId then

            if lScore[i] < 0 then
                table.insert(loseList, viewid)
            elseif lScore[i] > 0 then
                table.insert(winList, viewid)
            end
        end
    end

    -- 随机位置
    local function getRandPos(pos)

        if nil == pos then
            return nil
        end

        local beginpos = pos
        -- cc.p(x,y)
        local offsetx = math.random()
        local offsety = math.random()

        return cc.p(beginpos.x + offsetx * 20, beginpos.y + offsety * 40)
    end
    local bankerViewId = self._scene:SwitchViewChairID(self._scene.wBankerUser)

    -- local faceNode = self._csbNode:getChildByName("Node_User")
    -- local bankerNode = faceNode:getChildByName(string.format("FileNode_%d",bankerViewId))
    -- local bankerPosX,bankerPosY =  bankerNode:getPosition()
    print("bankerViewId", bankerViewId)
    dump(pointUserInfo[bankerViewId])
    local bankerPos = getRandPos(pointUserInfo[bankerViewId]) or cc.p(0, 0)

    local actionTime = 0.5
    -- 金币动画
    for i = 1, #loseList do
        local viewid = loseList[i]
        local chairid = self._scene:SwitchChairID(viewid)
        local goldnum = self:getgoldnum(lScore[chairid])
        -- local loseNode = faceNode:getChildByName(string.format("FileNode_%d",viewid))
        -- local losePosX,losePosY =  loseNode:getPosition()
        local loseBeginpos = getRandPos(pointUserInfo[viewid])
        for i = 1, goldnum do
            local pgold = cc.Sprite:create("game/im_fly_gold.png")
            pgold:setPosition(loseBeginpos)
            pgold:setVisible(false)
            pgold:runAction(cc.Sequence:create(cc.DelayTime:create(math.random() * 0.3), cc.CallFunc:create( function()
                pgold:setVisible(true)
                pgold:runAction(cc.Sequence:create(
                self:getMoveActionEx(actionTime, loseBeginpos, bankerPos),
                cc.CallFunc:create( function()
                    pgold:removeFromParent()
                end )
                ))
            end )))
            table.insert(self.goldlist, pgold)
            self:addChild(pgold, 10)
        end
    end

    -- 延迟时间
    local winDelayTime = #loseList > 0 and 1.5 or 0
    for i = 1, #winList do
        local viewid = winList[i]
        local chairid = self._scene:SwitchChairID(viewid)
        local goldnum = self:getgoldnum(lScore[chairid])
        -- local winNode = faceNode:getChildByName(string.format("FileNode_%d",viewid))
        -- local winPosX,winPosY =  winNode:getPosition()
        local winEndPos = getRandPos(pointUserInfo[viewid])
        for i = 1, goldnum do
            local pgold = cc.Sprite:create("game/im_fly_gold.png")
            pgold:setPosition(bankerPos)
            pgold:setVisible(false)
            pgold:runAction(cc.Sequence:create(cc.DelayTime:create(math.random() * 0.3 + winDelayTime), cc.CallFunc:create( function()
                pgold:setVisible(true)
                -- local action = self:getMoveAction()
                pgold:runAction(cc.Sequence:create(
                self:getMoveActionEx(actionTime, bankerPos, winEndPos),
                cc.CallFunc:create( function()
                    pgold:removeFromParent()
                end )
                ))
            end )))
            table.insert(self.goldlist, pgold)
            self:addChild(pgold, 10)
        end
    end

end

function GameViewLayer:showRoomRule(config)
    local roomRuleInfoStr = ""
    local roomRuleInfoTTF = self._csbNode:getChildByName("Text_info")
    assert(roomRuleInfoTTF)
    --[[if not (PriRoom and GlobalUserItem.bPrivateRoom ) then
    	roomRuleInfoTTF:setString("经典模式")
    	roomRuleInfoTTF:setVisible(true)
    	return
    end]]

    -- 房间类型
    local cardType = { "经典模式", "疯狂加倍" }
    local sendType = { "发四等五", "下注发牌" }
    local bankerType = { "霸王庄", "倍数抢庄", "牛牛上庄", "无牛下庄" }
    dump(config, "config is =========")


    roomRuleInfoStr = roomRuleInfoStr .. cardType[config.cardType - 22 + 1] .. "," .. sendType[config.sendCardType - 32 + 1] .. "," .. bankerType[config.bankGameType - 52 + 1]
    roomRuleInfoTTF:setString(roomRuleInfoStr)
    print("config str is =============", roomRuleInfoStr)
    roomRuleInfoTTF:setVisible(true)

end

-- 计算器动画
-- 1.是否显示 2.是否有动画 
function GameViewLayer:showCalculate(isShow, isAni)
    if self._scene.cbDynamicJoin == 1 then
        return
    end


    self.nodeChip:removeAllChildren()

    print("bSpecialType is ===", self.bSpecialType)
    if self.bSpecialType then
        -- 特殊牌型 只显示牌型按钮
        self.btConfirm:setVisible(true)
        if self._scene.m_tabPrivateRoomConfig.cardType == cmd.CARDTYPE_CONFIG.CT_CLASSIC then
            -- 经典模式
            self.btConfirm.text:setString(GameLogic.CT_OX_CLASSIC_LIST[self.cbSpecialCardType + 1])
        elseif self._scene.m_tabPrivateRoomConfig.cardType == cmd.CARDTYPE_CONFIG.CT_ADDTIMES then
            -- 疯狂加倍
            self.btConfirm.text:setString(GameLogic.CT_OX_ADDTIME_LIST[self.cbSpecialCardType + 1])
        end

        return
    end

    isAni = isAni or false
    local moveTime = 1
    local moveDistanceY = 50
    local spriteCalculatePos = cc.p(667, 230)
    if isShow then
        -- 是否显示
        if isAni == true then
            -- 动画
            self.spriteCalculate:setVisible(isShow)
            self.spriteCalculate:setPosition(cc.p(spriteCalculatePos.x, spriteCalculatePos.y - moveDistanceY))
            local moveAction = cc.EaseBackInOut:create(cc.MoveBy:create(moveTime, cc.p(0, moveDistanceY)))
            local spawn = cc.Spawn:create(cc.FadeIn:create(moveTime), moveAction)
            self.spriteCalculate:runAction(cc.Sequence:create(
            spawn,
            cc.CallFunc:create( function()
                self.spriteCalculate:setVisible(isShow)
                -- self.btConfirm:setVisible(isShow)
            end )
            ))
        else
            self.spriteCalculate:setPosition(spriteCalculatePos)
            self.spriteCalculate:setVisible(isShow)
            -- self.btConfirm:setVisible(isShow)
        end
    else
        if isAni == true then
            -- 动画
            self.spriteCalculate:setPosition(spriteCalculatePos)
            local moveAction = cc.EaseBackIn:create(cc.MoveBy:create(moveTime, cc.p(0, - moveDistanceY)))
            local spawn = cc.Spawn:create(cc.FadeIn:create(moveTime), moveAction)
            self.spriteCalculate:runAction(cc.Sequence:create(
            spawn,
            cc.CallFunc:create( function()
                self.spriteCalculate:setVisible(isShow)
                -- self.btConfirm:setVisible(isShow)
            end )
            ))
        else
            self.spriteCalculate:setVisible(isShow)
            -- self.btConfirm:setVisible(isShow)
        end
    end
end

-- 游戏状态
function GameViewLayer:gameScenePlaying()
    print("cbDynamicJoin is =========" .. self._scene.cbDynamicJoin)
    if self._scene.cbDynamicJoin == 0 then
        print(" self.bSpecialType is ====", self.bSpecialType)

        if self.bSpecialType == true then
            self.btConfirm:setVisible(true)
            if self._scene.m_tabPrivateRoomConfig.cardType == cmd.CARDTYPE_CONFIG.CT_CLASSIC then
                -- 经典模式
                self.btConfirm.text:setString(GameLogic.CT_OX_CLASSIC_LIST[self.cbSpecialCardType + 1])
            elseif self._scene.m_tabPrivateRoomConfig.cardType == cmd.CARDTYPE_CONFIG.CT_ADDTIMES then
                -- 疯狂加倍
                self.btConfirm.text:setString(GameLogic.CT_OX_ADDTIME_LIST[self.cbSpecialCardType + 1])
            end

            return
        end

        self:runAction(cc.Sequence:create(cc.DelayTime:create(1.0), cc.CallFunc:create( function()
            self.spriteCalculate:setVisible(true)
            self.bCanMoveCard = true
        end )))



    end
end

-- 设置底分
function GameViewLayer:setCellScore(cellscore)
    if not cellscore then
        self.txt_CellScore:setString("底注：")
    else
        self.txt_CellScore:setString("底注：" .. cellscore)
    end
end

-- 设置纹理
function GameViewLayer:setCardTextureRect(viewId, tag, cardValue, cardColor)
    -- print("viewId, tag, cardValue, cardColor",viewId, tag, cardValue, cardColor)
    if viewId < 1 or viewId > 6 or tag < 1 or tag > 5 then
        print("card texture rect error!")
        return
    end
    if cardValue == nil or cardColor == nil then
        -- 背面牌
        -- print("背面牌")
        local card = self.nodeCard[viewId][tag]
        local rectCard = card:getTextureRect()
        rectCard.x = rectCard.width * 2
        rectCard.y = rectCard.height * 4
        card:setTextureRect(rectCard)
    else
        -- 特殊处理大小王
        local tempCardValue = cardValue
        if cardValue == 14 then
            -- 小王
            tempCardValue = 2
        elseif cardValue == 15 then
            -- 大王
            tempCardValue = 1
        end
        local card = self.nodeCard[viewId][tag]
        local rectCard = card:getTextureRect()
        rectCard.x = rectCard.width *(tempCardValue - 1)
        rectCard.y = rectCard.height * cardColor
        card:setTextureRect(rectCard)
    end

end

-- function GameViewLayer:setNickname(viewId, strName)
-- 	local name = string.EllipsisByConfig(strName, 156, self.nicknameConfig)
-- 	local labelNickname = self.nodePlayer[viewId]:getChildByTag(GameViewLayer.NICKNAME)
-- 	labelNickname:setString(name)
-- end

function GameViewLayer:updateScore(viewId)
    if self.m_tabUserHead[viewId] then
        self.m_tabUserHead[viewId]:updateStatus()
    end
end

function GameViewLayer:setTableID(id)
    if not id or id == yl.INVALID_TABLE then
        self.txt_TableID:setString("桌号：")
    else
        self.txt_TableID:setString("桌号：" ..(id + 1))
    end
end


function GameViewLayer:setUserScore(wViewChairId, lScore)
    self.nodePlayer[wViewChairId]:getChildByTag(GameViewLayer.SCORE):setString(lScore)
end

function GameViewLayer:setReadyVisible(wViewChairId, isVisible)
    self.flag_ready[wViewChairId]:setVisible(isVisible)
    if true == isVisible then
        self.flag_openCard[wViewChairId]:setVisible(false)
    end
end

function GameViewLayer:OnUpdateUserExit(viewId)
    print("移除用户", viewId)
    if nil ~= self.m_tabUserHead[viewId] then
        self.m_tabUserHead[viewId]:removeFromParent()
        self.m_tabUserHead[viewId] = nil
    end
end

-- 开牌标识
function GameViewLayer:setOpenCardVisible(wViewChairId, isVisible, isOver)
    if not self.flag_openCard[wViewChairId] then
        return
    end

    self.flag_openCard[wViewChairId]:setVisible(isVisible)
    if isOver then
        local sprFlag = cc.Sprite:create(GameViewLayer.RES_PATH .. "game/Sprite_complete.png")
        self.flag_openCard[wViewChairId]:setSpriteFrame(sprFlag:getSpriteFrame())
    else
        if wViewChairId == cmd.MY_VIEWID then
            self.flag_openCard[wViewChairId]:setVisible(false)
            print("摊牌标识是自己")
            return
        end
        local sprFlag = cc.Sprite:create(GameViewLayer.RES_PATH .. "game/Sprite_puting.png")
        self.flag_openCard[wViewChairId]:setSpriteFrame(sprFlag:getSpriteFrame())
    end
end


-- 百分比
-- function GameViewLayer:setScorePencentJetton(tabJetton)
-- 	for i = 1, #self.btChip do
-- 		self.lUserJettonScore[i] = math.max(tabJetton[i], 1)
-- 		self.btChip[i]:getChildByTag(TAG_ENUM.NUM_CHIP):setString(tabJetton[i])
-- 		--lTurnMaxScore = math.floor(lTurnMaxScore/2)
-- 	end
-- end

-- 积分按钮
function GameViewLayer:setScoreJetton(tabJetton)
    if self._scene.cbDynamicJoin == 1 then
        return
    end


    self.lUserJettonScore = clone(tabJetton)
    dump(self.lUserJettonScore, "lUserJettonScore is ")
    local btcallback = function(ref, type)
        if type == ccui.TouchEventType.ended then
            this:onButtonClickedEvent(ref:getTag(), ref)
        end
    end

    self:showCallBankerMul(0)

    -- 配置下注积分的数目
    local tabFirstPos = { 670, 575, 475, 370, 280 }
    for i = 1, #tabJetton do
        print("下注分数tabJetton[i]", tabJetton[i])
        if tabJetton[i] ~= 0 then
            self.btChip[i] = ccui.Button:create("common/btn_yellow.png")
            :move(tabFirstPos[#tabJetton] + 200 *(i - 1), 210)
            :setTag(TAG_ENUM.BT_CHIP1 + i - 1)
            :setVisible(false)
            :addTo(self.nodeChip)
            self.btChip[i]:addTouchEventListener(btcallback)

            local label = cc.LabelTTF:create(tabJetton[i], "fonts/round_body.ttf", 36, cc.size(150, 0), cc.TEXT_ALIGNMENT_CENTER)
            :setTag(TAG_ENUM.NUM_CHIP)
            :addTo(self.btChip[i])
            :move(cc.p(self.btChip[i]:getContentSize().width / 2, self.btChip[i]:getContentSize().height / 2))
            label:setColor(cc.c3b(128, 66, 6))

            self.btChip[i]:runAction(cc.Sequence:create(
            cc.DelayTime:create(0.1 *(i - 1)),
            cc.MoveBy:create(0.1, cc.p(0, 25)),
            cc.MoveBy:create(0.1, cc.p(0, -15))
            ))
        end
        if self.btChip[i] ~= nil then
            self.btChip[i]:move(tabFirstPos[#tabJetton] + 200 *(i - 1), 210)
        end
    end
end

function GameViewLayer:setBankerUser(wViewChairId, isAni)
    print("wViewChairId,isAni", wViewChairId, isAni)
    for i = 1, cmd.GAME_PLAYER do
        local viewid = self._scene:SwitchViewChairID(i - 1)
        if self.m_tabUserHead[viewid] then
            self.m_tabUserHead[viewid]:showBank(false)
        end
    end
    -- 庄家提示
    if wViewChairId ~= nil then
        self.m_tabUserHead[wViewChairId]:showBank(true)
    end
end

function GameViewLayer:setUserTableScore(wViewChairId, lScore)
    if lScore == 0 then
        return
    end
    self.m_tabUserHead[wViewChairId]:showCallInScore(lScore, true)
end

-- 检查牌类型
function GameViewLayer:updateCardPrompt()
    -- 弹出牌显示，统计和
    local nSumTotal = 0
    local nSumOut = 0
    local nCount = 1
    local bJoker = false
    -- 大小王百搭标识
    -- dump(self._scene.cbCardData)
    self.cbCombineCard = { }
    local normalCard = { }
    for i = 1, 5 do
        local nCardValue = self._scene:getMeCardLogicValue(i)
        nSumTotal = nSumTotal + nCardValue
        if self.bCardOut[i] then
            -- 选中的卡牌
            if nCount <= 3 then
                local temp = nCardValue
                if temp == GameLogic.KingValue then
                    temp = 10
                    nCardValue = temp
                    bJoker = true
                    self.labAtCardPrompt[nCount]:setString("王")
                else
                    self.labAtCardPrompt[nCount]:setString(temp)
                end

            end
            nCount = nCount + 1
            nSumOut = nSumOut + nCardValue
            table.insert(self.cbCombineCard, self._scene:getMeCardValue(i))
        else
            table.insert(normalCard, i)
        end

    end

    for i = nCount, 3 do
        self.labAtCardPrompt[i]:setString("")
        self.btConfirm:setVisible(false)
        self:setCombineCard(self._scene:getMeCardValue())
    end

    -- 判断是否构成牛
    if nCount == 1 then
        self.labCardType:setString("")
        self.btConfirm:setVisible(false)
        self:setCombineCard(self._scene:getMeCardValue())
    elseif nCount == 3 then
        -- 弹出两张牌
        self.labCardType:setString("")
        self.btConfirm:setVisible(false)
        self:setCombineCard(self._scene:getMeCardValue())
    elseif nCount == 4 then
        -- 弹出三张牌
        if true == bJoker then
            nSumOut = nSumOut - 10
            local mod = math.mod(nSumOut, 10)
            nSumOut = nSumOut - mod
            nSumOut = nSumOut + 10
        end
        self.labCardType:setString(nSumOut)

        for i = 1, #normalCard do
            local index = normalCard[i]
            table.insert(self.cbCombineCard, self._scene:getMeCardValue(index))
        end
        self.btConfirm:setVisible(true)
        local ox_type = GameLogic:getCardType(self.cbCombineCard)
        self.btConfirm.text:setString(GameLogic.CT_OX_CLASSIC_LIST[ox_type + 1])
        normalCard = { }
    else
        self.labCardType:setString("")
        self.btConfirm:setVisible(false)
        self:setCombineCard(self._scene:getMeCardValue())
    end
end

function GameViewLayer:preloadUI()
    for i = 1, #AnimationRes do
        local animation = cc.Animation:create()
        animation:setDelayPerUnit(AnimationRes[i].fInterval)
        animation:setLoops(AnimationRes[i].nLoops)

        for j = 1, AnimationRes[i].nCount do
            local strFile = AnimationRes[i].file .. string.format("%d.png", j)
            animation:addSpriteFrameWithFile(strFile)
        end

        cc.AnimationCache:getInstance():addAnimation(animation, AnimationRes[i].name)
    end
end

function GameViewLayer:getAnimate(name, bEndRemove)
    print("name", name)
    local animation = cc.AnimationCache:getInstance():getAnimation(name)
    print("animation", animation)
    local animate = cc.Animate:create(animation)

    if bEndRemove then
        animate = cc.Sequence:create(animate, cc.CallFunc:create( function(ref)
            ref:removeFromParent()
        end ))
    end

    return animate
end

function GameViewLayer:promptOx()
    -- 首先将牌复位
    for i = 1, 5 do
        if self.bCardOut[i] == true then
            local card = self.nodeCard[cmd.MY_VIEWID][i]
            local x, y = card:getPosition()
            y = y - 30
            card:move(x, y)
            self.bCardOut[i] = false
        end
    end
    -- 将牛牌弹出
    local index = self._scene:GetMeChairID() + 1
    local cbDataTemp = self:copyTab(self._scene.cbCardData[index])
    if self._scene:getOxCard(cbDataTemp) then
        for i = 1, 5 do
            for j = 1, 3 do
                if self._scene.cbCardData[index][i] == cbDataTemp[j] then
                    local card = self.nodeCard[cmd.MY_VIEWID][i]
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

-- 显示语音
function GameViewLayer:ShowUserVoice(viewid, isPlay)
    -- 取消文字，表情
    local playerItem = self.m_tabUserHead[viewid]
    dump(self.m_tabUserHead, "显示语音")
    print("显示语音,playerItem", playerItem)
    if nil ~= playerItem then
        if isPlay then
            playerItem:onUserVoiceStart()
        else
            playerItem:onUserVoiceEnded()
        end
    end
end

-- 拷贝表
function GameViewLayer:copyTab(st)
    local tab = { }
    for k, v in pairs(st) do
        if type(v) ~= "table" then
            tab[k] = v
        else
            tab[k] = self:copyTab(v)
        end
    end
    return tab
end

-- 取模
function GameViewLayer:mod(a, b)
    return a - math.floor(a / b) * b
end

-- 运行输赢动画
function GameViewLayer:runWinLoseAnimate(viewid, score)

    if not self.m_tabUserHead[viewid] then
        return
    end

    local strNum
    if score >= 0 then
        strNum = GameViewLayer.RES_PATH .. "game/num_win.png"
    else
        score = - score
        strNum = GameViewLayer.RES_PATH .. "game/num_lose.png"
    end

    -- 加减
    local labAtNum = cc.LabelAtlas:_create(string.format("/" .. score), strNum, 30, 38, string.byte("/"))
    -- 数字
    :setAnchorPoint(cc.p(0.5, 0.5))
    :addTo(self.m_tabUserHead[viewid])
    :move(0, 0)
    -- local sizeNum = labAtNum:getContentSize()
    -- labAtNum:move(cc.p(0,0))

    -- 底部动画
    local nTime = 0.5
    labAtNum:runAction(cc.Sequence:create(
    cc.Spawn:create(
    cc.MoveBy:create(nTime, cc.p(0, 75)),
    cc.FadeIn:create(nTime)
    ),
    cc.DelayTime:create(2),
    cc.CallFunc:create( function(ref)
        ref:removeFromParent()
    end )
    ))

end

local scorecell = { 100, 1000, 10000, 100000, 1000000 }
local goldnum = { 12, 13, 15, 15, 15, 18 }

-- 飞出多少金币
function GameViewLayer:getgoldnum(score)
    local cellvalue = 1
    score = math.abs(score)
    for i = 1, 5 do
        if score > scorecell[i] then
            cellvalue = i + 1
        end
    end
    return goldnum[cellvalue]
end


function GameViewLayer:setClockVisible(visible)
    self._clockTime:setVisible(visible)
end

function GameViewLayer:setClockBgVisible(visible)
    if not visible then
        self._scene:KillGameClock()
    end
    self._clockTimeBg:setVisible(visible)
end

function GameViewLayer:logicClockInfo(chair, time, clockId)
    -- body
    if clockId == cmd.IDI_NULLITY then
        if time <= 5 then
            if self._scene.cbDynamicJoin == 0 then
                self:playEffect("GAME_WARN.WAV")
            end
        end
    elseif clockId == cmd.IDI_START_GAME then
        if time <= 0 then
            if self._scene.cbDynamicJoin == 0 then
                self._scene._gameFrame:setEnterAntiCheatRoom(false)
                -- 退出防作弊
            end
            self._scene:KillGameClock()
            self:setClockBgVisible(false)
        elseif time <= 5 then
            self:playEffect("GAME_WARN.WAV")
        end
    elseif clockId == cmd.IDI_CALL_BANKER then
        if time < 1 then
            if self._scene.cbDynamicJoin == 0 then
                -- 非私人房处理叫庄
                if not GlobalUserItem.bPrivateRoom then
                    self:onButtonClickedEvent(TAG_ENUM.BT_CANCEL)
                    print("-----------------不叫庄----------------")
                end
            end

            self._scene:KillGameClock()
            self:setClockBgVisible(false)
        end
    elseif clockId == cmd.IDI_TIME_USER_ADD_SCORE then
        if time < 1 then
            if self._scene.cbDynamicJoin == 0 then
                if not GlobalUserItem.bPrivateRoom then
                    if self._scene.wBankerUser ~= self._scene._MyChairID then
                        self:onButtonClickedEvent(TAG_ENUM.BT_CHIP1)
                    end
                end
            end

            self._scene:KillGameClock()
            self:setClockBgVisible(false)
        elseif time <= 5 then
            if self._scene.cbDynamicJoin == 0 then
                self:playEffect("GAME_WARN.WAV")
            end
        end
    elseif clockId == cmd.IDI_TIME_OPEN_CARD then
        if time < 1 then
            if self._scene.cbDynamicJoin == 0 then
                -- 非私人房处理摊牌
                if not GlobalUserItem.bPrivateRoom then
                    self:setCombineCard(self._scene:getMeCardValue())
                    self:onButtonClickedEvent(self.btConfirm:getTag())
                    -- error("open card",0)
                end
            end

            self._scene:KillGameClock()
            self:setClockBgVisible(false)
        end
    end
end

function GameViewLayer:playEffect(file, sex)
    if not GlobalUserItem.bSoundAble then
        return
    end

    if nil ~= sex then
        assert((sex == 0) or(sex == 1))
        if (sex > 1) or(sex < 0) then
            return
        end
        local extra =(sex == 0) and "w.mp3" or "m.mp3"
        file = "sound_res/" .. file .. extra
    else
        file = "sound_res/" .. file
    end

    print("the file is =================================", file)

    AudioEngine.playEffect(file)
end

return GameViewLayer