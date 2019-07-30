--
-- Author: zhong
-- Date: 2016-12-29 11:13:57
--
-- 私人房游戏顶层
local PrivateLayerModel = appdf.req(PriRoom.MODULE.PLAZAMODULE .."models.PrivateLayerModel")
local PriGameLayer = class("PriGameLayer", PrivateLayerModel)
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local PopupInfoHead = appdf.req(appdf.EXTERNAL_SRC .. "PopupInfoHead")
local ClipText = appdf.req(appdf.EXTERNAL_SRC .. "ClipText")
local MultiPlatform = appdf.req(appdf.EXTERNAL_SRC .. "MultiPlatform")

local BTN_DISMISS = 101
local BTN_INVITE = 102
local BTN_SHARE = 103
local BTN_QUIT = 104
local BTN_ZANLI = 105
function PriGameLayer:ctor( gameLayer )
    PriGameLayer.super.ctor(self, gameLayer)
    -- 加载csb资源
    local rootLayer, csbNode = ExternalFun.loadRootCSB("game/PrivateGameLayer.csb", self )
    self.m_rootLayer = rootLayer

    --
    local image_bg = csbNode:getChildByName("Image_bg")

    -- 房间ID
    self.m_atlasRoomID = image_bg:getChildByName("num_roomID")
    self.m_atlasRoomID:setString("000000")

    -- 局数
    self.m_atlasCount = image_bg:getChildByName("num_game_count")
    self.m_atlasCount:setString("0/0")

    local function btncallback(ref, tType)
        if tType == ccui.TouchEventType.ended then
            self:onButtonClickedEvent(ref:getTag(),ref)
        end
    end
    -- 解散按钮
    local btn = image_bg:getChildByName("bt_dismiss")
    btn:setTag(BTN_DISMISS)
    btn:addTouchEventListener(btncallback)

    -- 暂离按钮
    btn = image_bg:getChildByName("bt_zanli")
    btn:setTag(BTN_ZANLI)
    btn:addTouchEventListener(btncallback)

    -- 邀请按钮
    self.m_btnInvite = csbNode:getChildByName("bt_invite")
    self.m_btnInvite:setTag(BTN_INVITE)
    self.m_btnInvite:setPosition(self.m_btnInvite:getPositionX(),self.m_btnInvite:getPositionY() - 150)
    self.m_btnInvite:addTouchEventListener(btncallback)

    --几人场
    local numplayer = image_bg:getChildByName("num_player_num")
    numplayer:setString(PriRoom:getInstance():getChairCount().."人场")

    --叫庄模式
    self.m_bankerMode = image_bg:getChildByName("num_play_type")

    --打枪
    self.m_gunnum = image_bg:getChildByName("num_gun")

    --倍数
    self.m_cellnum = image_bg:getChildByName("num_cell")
    
    self.m_tabBankerMode = {}
    self.m_tabBankerMode[1] =  "game/im_play_mode_0.png"
    self.m_tabBankerMode[2] =  "game/im_play_mode_1.png"
end

function PriGameLayer:onButtonClickedEvent( tag, sender )
    if BTN_DISMISS == tag then              -- 请求解散游戏
        PriRoom:getInstance():queryDismissRoom()
    elseif BTN_INVITE == tag then
        PriRoom:getInstance():getPlazaScene():popTargetShare(function(target, bMyFriend)
            bMyFriend = bMyFriend or false
            local function sharecall( isok )
                if type(isok) == "string" and isok == "true" then
                    showToast(self, "分享成功", 2)
                end
                GlobalUserItem.bAutoConnect = true
            end
            local sharetitle = "【约战房间：" .. self.m_atlasRoomID:getString() .. "】"
            local shareTxt = "局数:" .. PriRoom:getInstance().m_tabPriData.dwDrawCountLimit .. "局，"
            local friendC = "【约战房间：" .. self.m_atlasRoomID:getString() .. "】" .. " 局数:" .. PriRoom:getInstance().m_tabPriData.dwDrawCountLimit.. "局,十三水游戏精彩刺激, 一起来玩吧! "
            local url = GlobalUserItem.szWXSpreaderURL or yl.HTTP_URL
            if bMyFriend then
                PriRoom:getInstance():getTagLayer(PriRoom.LAYTAG.LAYER_FRIENDLIST, function( frienddata )
                    local serverid = tonumber(PriRoom:getInstance().m_tabPriData.szServerID) or 0                    
                    PriRoom:getInstance():priInviteFriend(frienddata, GlobalUserItem.nCurGameKind, serverid, yl.INVALID_TABLE, friendC)
                end)
            elseif nil ~= target then
                GlobalUserItem.bAutoConnect = false
                MultiPlatform:getInstance():shareToTarget(target, sharecall, sharetitle, shareTxt .. " 十三水游戏精彩刺激, 一起来玩吧! ", url, "")
            end
        end)
    elseif BTN_SHARE == tag then
        PriRoom:getInstance():getPlazaScene():popTargetShare(function(target, bMyFriend)
            bMyFriend = bMyFriend or false
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
            if bMyFriend then
                imagename = "grade_share_" .. os.time() .. ".jpg"
            end
            ExternalFun.popupTouchFilter(0, false)
            captureScreenWithArea(area, imagename, function(ok, savepath)
                ExternalFun.dismissTouchFilter()
                if ok then
                    if bMyFriend then
                        PriRoom:getInstance():getTagLayer(PriRoom.LAYTAG.LAYER_FRIENDLIST, function( frienddata )
                            PriRoom:getInstance():imageShareToFriend(frienddata, savepath, "分享我的约战房战绩")
                        end)
                    elseif nil ~= target then
                        GlobalUserItem.bAutoConnect = false
                        MultiPlatform:getInstance():shareToTarget(target, sharecall, "我的约战房战绩", "分享我的约战房战绩", url, savepath, "true")
                    end            
                end
            end)
        end)
    elseif BTN_QUIT == tag then
        GlobalUserItem.bWaitQuit = false
        self._gameLayer:onExitRoom()
    elseif BTN_ZANLI == tag then
        PriRoom:getInstance():tempLeaveGame()
        self._gameLayer:onExitRoom()
    end
end

------
-- 继承/覆盖
------
-- 刷新界面
function PriGameLayer:onRefreshInfo()
    -- 房间ID
    self.m_atlasRoomID:setString(PriRoom:getInstance().m_tabPriData.szServerID or "000000")

    --倍数
    if PriRoom:getInstance().m_tabPriData.lCellScore == nil then
        return
    end

    self.m_cellnum:setString(""..PriRoom:getInstance().m_tabPriData.lCellScore)

    dump(PriRoom:getInstance().m_tabPriData, "约战数据", 10)

    -- 局数
    local strcount = PriRoom:getInstance().m_tabPriData.dwPlayCount .. " / " .. PriRoom:getInstance().m_tabPriData.dwDrawCountLimit
    self.m_atlasCount:setString(strcount)

    self:onRefreshInviteBtn()

    --叫庄模式
    local modevalue = self._gameLayer:getBankerMode()
    self.m_bankerMode:loadTexture(self.m_tabBankerMode[modevalue+1])

    --打枪
    self.m_gunnum:setString("/"..self._gameLayer:getGunNum())
end

function PriGameLayer:onRefreshInviteBtn()
    if self._gameLayer.m_cbGameStatus ~= 0 then --空闲场景
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
    self._gameLayer.m_bPriEnd = true
    self:removeChildByName("private_end_layer")

    local csbNode = ExternalFun.loadCSB("game/PrivateGameEnd.csb", self.m_rootLayer)
    csbNode:setVisible(false)
    csbNode:setName("private_end_layer")
    local function btncallback(ref, tType)
        if tType == ccui.TouchEventType.ended then
            self:onButtonClickedEvent(ref:getTag(),ref)
        end
    end

    ---房间ID
    local roomID = csbNode:getChildByName("Atlas_roomID")
    roomID:setString(PriRoom:getInstance().m_tabPriData.szServerID or "000000")
    --创建时间
    local createtime = csbNode:getChildByName("Text_create_time")
    local temptime = csbNode:getChildByName("im_end_time_bg")
    temptime:setVisible(false)
    createtime:setVisible(false)

    local endbg = csbNode:getChildByName("im_end_frame")

    local bgsize = {cc.size(688, 510), cc.size(999, 510), cc.size(1303, 510)}

    local chairCount = PriRoom:getInstance():getChairCount()
    endbg:loadTexture(string.format("game/im_end_frame_%d.png", chairCount))
    endbg:setContentSize(bgsize[chairCount-1])
    --endbg:setTexture(cc.Director:getInstance():getTextureCache():addImage(string.format("game/im_end_frame_%d.png", chairCount)))
    -- 玩家成绩
    local scoreList = cmd_table.lScore[1]
    --获取最大成绩
    local maxindex = 1
    local maxscore = scoreList[1]
    for i=2,chairCount do
        if scoreList[i] > maxscore then
            maxscore = scoreList[i]
            maxindex = i
        end
    end
    for i = 1, chairCount do
        local useritem = self._gameLayer:getUserInfoByChairID(i - 1)

        if nil ~= useritem then

            local itembg = ExternalFun.loadCSB("game/endcell.csb")
            itembg:setPosition(192+(i-1)*292, endbg:getContentSize().height/2)
            endbg:addChild(itembg)
            --头像
            local head = PopupInfoHead:createNormal(useritem, 102)
            head:setAnchorPoint(cc.p(0.5,0.5))
            head:setPosition(cc.p(4, 100))
            itembg:addChild(head)

            --昵称
            local tempnick = itembg:getChildByName("txt_nickname")
            local nick =  ClipText:createClipText(cc.size(140, 26),useritem.szNickName,"fonts/round_body.ttf",22);
            nick:setAnchorPoint(cc.p(0, 0.5))
            nick:setPosition(cc.p(tempnick:getPositionX(), tempnick:getPositionY()))
            nick:setColor(tempnick:getColor())
            itembg:addChild(nick)
            tempnick:removeFromParent()

            --玩家ID
            local gameID = itembg:getChildByName("txt_gameID")
            gameID:setString(""..useritem.dwGameID)

            --输赢详细
            local winicon = itembg:getChildByName("txt_win_3")
            local score = scoreList[i]
            local file =  "/" 
            winicon:setVisible(false)
            local scoreTTF = itembg:getChildByName("Atlas_endscore")
            scoreTTF:setProperty(str, "game/num_end_win.png", 25, 33, "/")
            if score < 0  then
                score = math.abs(score)
                scoreTTF:setProperty(str, "game/num_end_failed.png", 25, 33, "/")
            end
            if i == maxindex then
                winicon:setVisible(true)
            end
            
            local scorestr = file..string.format("%d", score)
            scoreTTF:setString(scorestr)

            --庄家标识
            local bankerIcon = itembg:getChildByName("im_icon_banker")
            bankerIcon:setVisible(false)
            if self._gameLayer._wBankerUser == i-1 then
                bankerIcon:setVisible(true)
                bankerIcon:setLocalZOrder(5)
            end

            --房主标识
            local fangzhuicon = itembg:getChildByName("im_icon_fangzhu")
            fangzhuicon:setVisible(false)
            if PriRoom:getInstance().m_tabPriData.dwTableOwnerUserID == useritem.dwUserID then
                fangzhuicon:setVisible(true)
                fangzhuicon:setLocalZOrder(5)
            end
        end
    end 

    -- 分享按钮
    btn = csbNode:getChildByName("bt_share")
    btn:setTag(BTN_SHARE)
    btn:setVisible(true)
    btn:addTouchEventListener(btncallback)

    -- 退出按钮
    btn = csbNode:getChildByName("bt_qiut")
    btn:setTag(BTN_QUIT)
    btn:addTouchEventListener(btncallback)

    csbNode:runAction(cc.Sequence:create(cc.DelayTime:create(4.0),
        cc.CallFunc:create(function()
            self._gameLayer._gameView:priGameEnd()
            csbNode:setVisible(true)
        end)))
end

function PriGameLayer:onExit()
    cc.SpriteFrameCache:getInstance():removeSpriteFramesFromFile("game/land_game.plist")
    cc.Director:getInstance():getTextureCache():removeTextureForKey("game/land_game.png")
end

return PriGameLayer