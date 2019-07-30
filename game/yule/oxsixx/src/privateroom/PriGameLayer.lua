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
    self.m_btnInvite:addTouchEventListener(btncallback)

    --几人场
    local numplayer = image_bg:getChildByName("num_player_num")
    local numStr = PriRoom:getInstance():getChairCount()
    if PriRoom:getInstance():getChairCount() == 0 then
        numStr = "2-6"
    end
    numplayer:setString(numStr.."人")


end

function PriGameLayer:onButtonClickedEvent( tag, sender )
    if BTN_DISMISS == tag then              -- 请求解散游戏
        PriRoom:getInstance():queryDismissRoom()
    elseif BTN_INVITE == tag then
        PriRoom:getInstance():queryRoomPasswd(
            PriRoom:getInstance().m_tabPriData.szServerID, 
            function(cmd_table)
                -- 第三方分享
                local scene = PriRoom:getInstance():getPlazaScene()
                
                if nil == scene then
                    return
                end
                local dwRoomDwd = cmd_table.szPassWord or 0
            print("获取分享信息===》",dwRoomDwd,cmd_table.dwRoomDwd)
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
                                local szRoomID = self.m_atlasRoomID:getString()
                                local drawCount = PriRoom:getInstance().m_tabPriData.dwDrawCountLimit or 0

                                local shareTxt = "局数:" .. drawCount .. "局。新六人牛牛精彩刺激, 一起来玩吧!"
                                local url = yl.PRIVATE_SHARE_URL .. "?g=" .. GlobalUserItem.dwGameID .. "&r=" .. szRoomID .. "&k=50&a=1" .. "&p=" .. passwd
                                print("获取分享信息===》", szRoomID,shareTxt,  url,GlobalUserItem.dwGameID)
                                MultiPlatform:getInstance():shareToTarget(
                                    target, 
                                    sharecall, 
                                    "【约战房间: " .. szRoomID .. " 】", 
                                    shareTxt, 
                                    url, 
                                    "")
                            end
                        end, 3)
                    end
                end
                
                if 0 ~= dwRoomDwd then
                    --local query = QueryDialog:create("约战密码为 " .. dwRoomDwd .. " 是否邀请好友游戏?", function(ok)
                        --if ok then
                            _shareFun(dwRoomDwd)
                        --end
                    --end)
                    --:setCanTouchOutside(false)
                    --:addTo(self)
                else
                    _shareFun( dwRoomDwd )
                end
            end
        )
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
    -- if PriRoom:getInstance().m_tabPriData.lCellScore == nil then
    --     return
    -- end

    --self.m_cellnum:setString(""..PriRoom:getInstance().m_tabPriData.lCellScore)

    dump(PriRoom:getInstance().m_tabPriData, "约战数据", 10)

    -- 局数
    local strcount = PriRoom:getInstance().m_tabPriData.dwPlayCount .. " / " .. PriRoom:getInstance().m_tabPriData.dwDrawCountLimit
    self.m_atlasCount:setString(strcount)

    self:onRefreshInviteBtn()

    --叫庄模式
    --local modevalue = self._gameLayer:getBankerMode()
    --self.m_bankerMode:loadTexture(self.m_tabBankerMode[modevalue+1])

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
    createtime:setVisible(true)
    --print("时间")
    local time = os.date("%Y-%m-%d %H:%M",os.time())
    --print("time")
    createtime:setString(time)

    local chairCount = self._gameLayer:getChairCount() or 2

    --房间类型
    local cardType = {"经典模式","疯狂加倍"}
    local sendType = {"发四等五","下注发牌"}
    local bankerType = {"霸王庄","倍数抢庄","牛牛上庄","无牛下庄"}
    local atlas_config = csbNode:getChildByName("Atlas_config")
    local config = self._gameLayer:getPrivateRoomConfig()
    local configStr = string.format("%d人,%d局,", chairCount,PriRoom:getInstance().m_tabPriData.dwDrawCountLimit)
    configStr = configStr..cardType[config.cardType-22+1]..","..sendType[config.sendCardType-32+1]..","..bankerType[config.bankGameType-52+1]

    atlas_config:setString(configStr)


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

    local gameRecord = self._gameLayer:getDetailScore()
    dump(gameRecord)

    for i = 1, chairCount do
        local useritem = self._gameLayer:getUserInfoByChairID(i - 1)

        if nil ~= useritem then

            local itembg = ExternalFun.loadCSB("game/endcell.csb")
            itembg:setPosition(300+(math.mod(i-1,3))*360, 460 - math.floor(i/4)*180)
            csbNode:addChild(itembg)

            --头像
            local head = PopupInfoHead:createClipHead(useritem, 95)
            head:setAnchorPoint(cc.p(0.5,0.5))
            head:setPosition(cc.p(-80, 20))
            itembg:addChild(head)

            --昵称
            local tempnick = itembg:getChildByName("txt_nickname")
            local nick =  ClipText:createClipText(cc.size(140, 26),useritem.szNickName,"fonts/round_body.ttf",22);
            nick:setAnchorPoint(cc.p(0.5, 0.5))
            nick:setPosition(cc.p(tempnick:getPositionX(), tempnick:getPositionY()))
            nick:setColor(tempnick:getColor())
            itembg:addChild(nick)
            tempnick:removeFromParent()

            --玩家ID
            local gameID = itembg:getChildByName("txt_gameID")
            gameID:setString("ID:"..useritem.dwGameID)

            --换item背景图
            print("self._gameLayer:GetMeUserItem().dwGameID == useritem.dwGameID",self._gameLayer:GetMeUserItem().dwGameID, useritem.dwGameID)
            if self._gameLayer:GetMeUserItem().dwGameID == useritem.dwGameID then
                local itemHeadBg = itembg:getChildByName("im_pri_head_bg") 
                local tempSpr = display.newSprite(self._gameLayer._gameView.RES_PATH .. "privateroom/game/im_end_info_frame1.png")
                print(self._gameLayer._gameView.RES_PATH .. "privateroom/game/im_end_info_frame1.png")
                --self:addChild(tempSpr)
                print("tempSpr:getSpriteFrame()",tempSpr:getSpriteFrame())
                itemHeadBg:setSpriteFrame(tempSpr:getSpriteFrame())
            end

            --输赢详细
            local winicon = itembg:getChildByName("Sprite_flag_win")
            winicon:setLocalZOrder(1)
            local score = scoreList[i]
            local file =  "" 
            winicon:setVisible(false)
            local scoreTTF = itembg:getChildByName("Atlas_endscore")
            if score > 0  then
                file = "+"
            end
            if i == maxindex then
                winicon:setVisible(true)
                local animationPool = cc.Animation:create()
                for i=1,2 do
                    local str = string.format(self._gameLayer._gameView.RES_PATH .. "privateroom/game/Sprite_head%d.png",i)
                    print("str")
                    animationPool:addSpriteFrameWithFile(str)
                end
                animationPool:setDelayPerUnit(0.5)
                local animatePool = cc.Animate:create(animationPool)
                local itemHeadBg = itembg:getChildByName("Sprite_head") 
                itemHeadBg:runAction(cc.RepeatForever:create(animatePool))
            end
            local scorestr = file..string.format("%d", score)
            scoreTTF:setString(scorestr)


            local winnum = itembg:getChildByName("Text_winnum")
            winnum:setString(gameRecord.wincount[i])
            local losenum = itembg:getChildByName("Text_losenum")
            losenum:setString(gameRecord.losecount[i])
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
            csbNode:setVisible(true)
        end)))
end

function PriGameLayer:onExit()
    cc.SpriteFrameCache:getInstance():removeSpriteFramesFromFile("game/land_game.plist")
    cc.Director:getInstance():getTextureCache():removeTextureForKey("game/land_game.png")
end

return PriGameLayer