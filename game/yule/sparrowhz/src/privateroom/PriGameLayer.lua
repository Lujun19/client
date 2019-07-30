--
-- Author: tang
-- Date: 2017-01-08 16:29:57
--
require("client.src.plaza.models.yl")
-- 私人房游戏顶层
local PrivateLayerModel = appdf.req(PriRoom.MODULE.PLAZAMODULE .."models.PrivateLayerModel")
local PriGameLayer = class("PriGameLayer", PrivateLayerModel)
-- local PriGameLayer = class("PriGameLayer", function(scene)
--     local layer = display.newLayer()
--     return layer
-- end)
local DismissLayer = appdf.req(appdf.GAME_SRC.."yule.sparrowhz.src.privateroom.DismissLayer")
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local PopupInfoHead = appdf.req(appdf.EXTERNAL_SRC .. "PopupInfoHead")
local ClipText = appdf.req(appdf.EXTERNAL_SRC .. "ClipText")
local MultiPlatform = appdf.req(appdf.EXTERNAL_SRC .. "MultiPlatform")
local QueryDialog = appdf.req("app.views.layer.other.QueryDialog")

--local RES_PATH = "client/src/privatemode/game/yule/sparrowhz/res/"
local BTN_DISMISS = 101
local BTN_INVITE = 102
local BTN_SHARE = 103
local BTN_QUIT = 104
local BTN_ZANLI = 105
local BTN_INFO = 106

--local posRoomHost = {cc.p(1055, 677), cc.p(39, 509), cc.p(72, 231), cc.p(1286, 480)}

function PriGameLayer:ctor( gameLayer )
    PriGameLayer.super.ctor(self, gameLayer)
    -- 加载csb资源
    --cc.FileUtils:getInstance():addSearchPath(device.writablePath..RES_PATH)
    local rootLayer, csbNode = ExternalFun.loadRootCSB("privateRoom/RoomGameLayer.csb", self )
    self.m_rootLayer = rootLayer
    self.m_csbNode = csbNode

    --
    local image_bg = csbNode--csbNode:getChildByName("sp_roomInfoBg")

    -- 房间ID
    self.m_atlasRoomID = image_bg:getChildByName("AtlasLabel_1")
    self.m_atlasRoomID:setString("房号：1008611")
    --名称(改作扎码数量了)
    --local cbMaCount = self._gameLayer:getMaCount()
    --self.m_textRoomName = image_bg:getChildByName("Text_roomName"):setString("0个扎码")
    -- 局数
    self.m_atlasCount = image_bg:getChildByName("Button_1"):getChildByName("AtlasLabel_2")
    self.m_atlasCount:setString("1 / 5 局")
    --剩余
    --self.m_textRemain = image_bg:getChildByName("Text_innings"):setString("剩 4 局")

    local function btncallback(ref, tType)
        if tType == ccui.TouchEventType.ended then
            self:onButtonClickedEvent(ref:getTag(),ref)
        end
    end
    -- 解散按钮
   -- local btn = csbNode:getChildByName("bt_dismiss")
   -- btn:setTag(BTN_DISMISS)
   -- btn:addTouchEventListener(btncallback)

    -- 暂离按钮
    --local btn = csbNode:getChildByName("bt_zanli")
    --btn:setTag(BTN_ZANLI)
    --btn:addTouchEventListener(btncallback)

    -- 邀请按钮
    self.m_btnInvite = csbNode:getChildByName("bt_invite")
    self.m_btnInvite:setTag(BTN_INVITE)
    --self.m_btnInvite:setVisible(false)
    self.m_btnInvite:addTouchEventListener(btncallback)

        --详情按钮
    local btn = csbNode:getChildByName("Button_1")
    btn:setTag(BTN_INFO)
    btn:addTouchEventListener(btncallback)

    --self.sp_roomHost = csbNode:getChildByName("sp_roomHost"):setVisible(false)
    self._dismissLayer = DismissLayer:create(self):addTo(self._gameLayer._gameView, 8)
end

function PriGameLayer:onButtonClickedEvent( tag, sender )
    local cbMaCount = self._gameLayer:getMaCount()
    local strMa = ""
    if cbMaCount == 1 then
        strMa = "一码全中"
    else
        strMa = "扎码"..cbMaCount.."只"
    end

    if BTN_DISMISS == tag then              -- 请求解散游戏
        PriRoom:getInstance():queryDismissRoom()
    elseif BTN_INVITE == tag then
        self.m_btnInvite:setEnabled(false)
        self:runAction(cc.Sequence:create(cc.DelayTime:create(0.3),cc.CallFunc:create(function ( ... )
            self.m_btnInvite:setEnabled(true)
        end)))

      PriRoom:getInstance():queryRoomPasswd(
            PriRoom:getInstance().m_tabPriData.dwPersonalRoomID,
            function(cmd_table)
                -- 第三方分享
                local scene = PriRoom:getInstance():getPlazaScene()
                if nil == scene then
                    return
                end
                local dwRoomDwd = cmd_table.dwRoomDwd or 0

                local function _shareFun( dwRoomDwd )
                    if nil ~= scene.popTargetShare then
                        scene:popTargetShare(function(target)
                            if nil ~= target then
                                local function sharecall( isok )
                                    if type(isok) == "string" and isok == "true" then
                                        showToast(self, "分享成功", 2)
                                    end
                                end
                                local passwd = dwRoomDwd
                                local dwRoomID = PriRoom:getInstance().m_tabPriData.dwPersonalRoomID
                                local drawCount = PriRoom:getInstance().m_tabPriData.dwDrawCountLimit or 0

                                local shareTxt = "局数:" .. drawCount .. "局。红中麻将精彩刺激, 一起来玩吧!"
                                local url = yl.PRIVATE_SHARE_URL .. "?g=" .. GlobalUserItem.tabAccountInfo.dwGameID .. "&r=" .. dwRoomID .. "&k=389&a=1" .. "&p=" .. passwd

                                MultiPlatform:getInstance():shareToTarget(
                                    target,
                                    sharecall,
                                    string.format("【约战房间: %06d】", dwRoomID),
                                    shareTxt,
                                    url,
                                    "")
                            end
                        end, 3)
                    end
                end

                if 0 ~= dwRoomDwd then
                    local query = QueryDialog:create("约战密码为 " .. dwRoomDwd .. " 是否邀请好友游戏?", function(ok)
                        if ok then
                            _shareFun(dwRoomDwd)
                        end
                    end)
                    :setCanTouchOutside(false)
                    :addTo(self)
                else
                    _shareFun( dwRoomDwd )
                end
            end
        )
    elseif BTN_SHARE == tag then
        PriRoom:getInstance():getPlazaScene():popTargetShare(function(target, bMyFriend)
            local function sharecall( isok )
                if type(isok) == "string" and isok == "true" then
                    showToast(self, "分享成功", 2)
                end
                GlobalUserItem.bAutoConnect = true
            end
            local url = GlobalUserItem.szWXSpreaderURL or yl.HTTP_URL
            -- 截图分享
            local framesize = cc.Director:getInstance():getOpenGLView():getFrameSize()
            local area = cc.rect(0, 0, framesize.width, framesize.height)
            local imagename = "grade_share.jpg"
            ExternalFun.popupTouchFilter(0, false)
            captureScreenWithArea(area, imagename, function(ok, savepath)
                ExternalFun.dismissTouchFilter()
                if ok then
                    if nil ~= target then
                        GlobalUserItem.bAutoConnect = false
                        MultiPlatform:getInstance():shareToTarget(target, sharecall, "我的约战房战绩", "分享我的约战房战绩", url, savepath, "true")
                    end
                end
            end)
        end, 3)
    elseif BTN_QUIT == tag then
        --self.layoutShield:removeFromParent()
        self.m_rootLayer:removeAllChildren()
        GlobalUserItem.bWaitQuit = false
        self._gameLayer:onExitRoom()
    elseif BTN_ZANLI == tag then
        PriRoom:getInstance():tempLeaveGame()
        self._gameLayer:onExitRoom()
    elseif BTN_INFO == tag then
        self._gameLayer._gameView:showRoomInfo(true)
    end
end

------
-- 继承/覆盖
------
-- 刷新界面
function PriGameLayer:onRefreshInfo()
    -- 房间ID
    self.m_atlasRoomID:setString(string.format("%06d", PriRoom:getInstance().m_tabPriData.dwPersonalRoomID))
    --扎码数量
    local strMa = ""
    local cbMaCount = self._gameLayer:getMaCount()
    if cbMaCount == 1 then
        strMa = "一码全中"
    else
        strMa = cbMaCount.."个扎码"
    end
    --self.m_textRoomName:setString(strMa)
    -- 局数
    local dwPlayCount = PriRoom:getInstance().m_tabPriData.dwPlayCount
    print("局数：", dwPlayCount)
    local dwDrawCountLimit = PriRoom:getInstance().m_tabPriData.dwDrawCountLimit
    local strcount = dwPlayCount .. " / " .. dwDrawCountLimit.." 局"
    self.m_atlasCount:setString(strcount)
    --剩余
   -- self.m_textRemain:setString("剩 "..(dwDrawCountLimit - dwPlayCount).." 局")
    self:onRefreshInviteBtn()
    --房主
    self._gameLayer:updateRoomHost()
    --if wRoomHostViewId ~= 0 then
        --self.sp_roomHost:move(posRoomHost[wRoomHostViewId]):setVisible(true)
    --end
end

function PriGameLayer:onRefreshInviteBtn()
    print("invite .. ")
    print(self._gameLayer.m_cbGameStatus)
    if self._gameLayer.m_cbGameStatus ~= 0 then --不是空闲场景
        self.m_btnInvite:setVisible(false)
        return
    end
    -- 邀请按钮
    if nil ~= self._gameLayer.onGetSitUserNum then
        local chairCount = PriRoom:getInstance():getChairCount()
        if self._gameLayer:onGetSitUserNum() == chairCount then
            self.m_btnInvite:setVisible(false)
            return
        end
    end

    self.m_btnInvite:setVisible(true)
end

-- 私人房游戏结束
function PriGameLayer:onPriGameEnd( cmd_table )
    self:removeChildByName("private_end_layer")
    self._gameLayer.isPriOver = true

    --房卡结算屏蔽层
    self.layoutShield = ccui.Layout:create()
        :setContentSize(cc.size(display.width, display.height))
        :setTouchEnabled(true)
        :addTo(self.m_rootLayer, 1)
    --加载房卡结算
    local csbNode = ExternalFun.loadCSB("privateRoom/RoomResultLayer.csb", self.m_rootLayer)
    csbNode:setVisible(false)
    csbNode:setLocalZOrder(1)
    csbNode:setName("private_end_layer")

    local function btncallback(ref, tType)
        if tType == ccui.TouchEventType.ended then
            self:onButtonClickedEvent(ref:getTag(),ref)
        end
    end

    local fangjianid = csbNode:getChildByName("Text_19")
    fangjianid:setString(""..PriRoom:getInstance().m_tabPriData.dwPersonalRoomID or "000000")

    --大赢家
    local scoreList = cmd_table.lScore[1]
    local nRoomHostIndex = 1
    local scoreListTemp = clone(scoreList)
    table.sort(scoreListTemp)
    local scoreMax = scoreListTemp[#scoreListTemp]
    --全部成绩
    local jsonStr = cjson.encode(scoreList)
    local tabUserRecord = self._gameLayer:getDetailScore()
    dump(tabUserRecord,"tabUserRecord=============>")
    for i = 1, 4 do

        local userItem = self._gameLayer:getUserInfoByChairID(i - 1)
        local nodeUser = csbNode:getChildByName("FileNode_"..i)
        nodeUser:setVisible(false)
        assert(nodeUser, "The UI have problem!")
        if userItem and i<=self._gameLayer.chairCount then
            --头像
            local head = PopupInfoHead:createClipHead(userItem, 95,"privateRoom/head_mask.png")
            head:setPosition(8.7, 10)         --初始位置
            --head:enableHeadFrame(true)
            nodeUser:addChild(head,100)
            --昵称
            local textNickname = nodeUser:getChildByName("Text_account")
            local strNickname = string.EllipsisByConfig(userItem.szNickName, 190,
                                                        string.getConfig("fonts/round_body.ttf", 21))
            textNickname:setString(strNickname)
            --玩家ID
            local textUserId = nodeUser:getChildByName("Text_id")
            textUserId:setString("" .. userItem.dwGameID)
            --胡牌次数
            local textHuNum = nodeUser:getChildByName("Text_huNum")
            textHuNum:setString(tabUserRecord[i].cbHuCount)
            --公杠次数
            local textGongGangNum = nodeUser:getChildByName("AtlasLabel_2")
            textGongGangNum:setString(tabUserRecord[i].cbMingGang)
            --暗杠次数
            local textAnGangNum = nodeUser:getChildByName("AtlasLabel_3")
            textAnGangNum:setString(tabUserRecord[i].cbAnGang)
            --中码个数
            local textMaNum = nodeUser:getChildByName("AtlasLabel_4")
            textMaNum:setString(tabUserRecord[i].cbMaCount)
            --总成绩
            --local textGradeTotal = nodeUser:getChildByName("Text_gradeTotal")
            local textGradeTotalNum = nodeUser:getChildByName("AtlasLabel_5")
            --local path = scoreList[i] >= 0 and "privateRoom/winscore.png" or "privateRoom/losescore.png"

            textGradeTotalNum:setString("/"..scoreList[i])

            if scoreList[i] < 0 then
                textGradeTotalNum:setVisible(false)
                textGradeTotalNum = cc.Label:createWithCharMap("privateRoom/losescore.png", 17, 21, 47)
                textGradeTotalNum:setPosition(10.8,-224)
                textGradeTotalNum:setAnchorPoint(cc.p(0,0.5))
                textGradeTotalNum:setString("/"..scoreList[i])
                nodeUser:addChild(textGradeTotalNum)
             end

            --房主标志
            if userItem.dwUserID == PriRoom:getInstance().m_tabPriData.dwTableOwnerUserID then
                local spRoomHost = display.newSprite("#sp_roomHost_1.png")
                    :move(-72, 10)
                    :addTo(nodeUser)
                -- local x = textNickname:getContentSize().width/2 + spRoomHost:getContentSize().width/2
                -- spRoomHost:setPositionX(x)
            end
            --大赢家标志
            if scoreList[i] == scoreMax and scoreList[i] > 0 then
                display.newSprite("#sp_bigWinner.png")
                    :move(90, -121)
                    :addTo(nodeUser)
                --放大效果
                --textGradeTotal:setFontSize(textGradeTotal:getFontSize() + 1)
                --textGradeTotalNum:setFontSize(textGradeTotalNum:getFontSize() + 1)
            end



            nodeUser:setVisible(true)
        end
    end

    -- 分享按钮
    local btn = csbNode:getChildByName("bt_share")
    btn:setTag(BTN_SHARE)
    btn:addTouchEventListener(btncallback)

    -- 退出按钮
    local btn = csbNode:getChildByName("bt_leaveRoom")
    btn:setTag(BTN_QUIT)
    btn:addTouchEventListener(btncallback)

    --self:setButtonEnabled(false)
    csbNode:runAction(cc.Sequence:create(cc.DelayTime:create(3),
        cc.CallFunc:create(function()
            csbNode:setVisible(true)
        end)))

    self:setLocalZOrder(yl.MAX_INT - 1)
end

function PriGameLayer:setButtonEnabled(bEnabled)
    --self.m_csbNode:getChildByTag(BTN_DISMISS):setEnabled(bEnabled)
    --self.m_csbNode:getChildByTag(BTN_ZANLI):setEnabled(bEnabled)
    --self.m_csbNode:getChildByTag(BTN_INVITE):setEnabled(bEnabled)
end


function PriGameLayer:onLeaveGame()
    --"房卡切换后台"`
    self._dismissLayer:onLeaveGame()
end

function PriGameLayer:onExit()
    self._dismissLayer:onExit()
end

return PriGameLayer
