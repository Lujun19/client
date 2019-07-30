--
-- Author: Garry
-- Date: 2017-08-10 15:30:04
--
-- 包含录像处理, 单局结算详情界面

-- 游戏录像处理
local VideoReplayModel = appdf.req(GameVideo.MODULE.PLAZAMODULE .."VideoReplayModel")
local GameVideoReplay = class("GameVideoReplay", VideoReplayModel)
local ExternalFun =  appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")

local module_pre = "game.yule.sparrowhz.src"
local cmd = appdf.req(module_pre .. ".models.CMD_Game")
local GameLogic = appdf.req(module_pre .. ".models.GameLogic")
--local GameResultLayer = appdf.req(module_pre .. ".views.layer.ResultLayer")
local ResultLayer = appdf.req(appdf.GAME_SRC.."yule.sparrowhz.src.views.layer.ResultLayer")

local VideoResultLayer = appdf.req(module_pre .. ".gamevideo.GameVideoResultLayer")


function GameVideoReplay:ctor( scene )
    GameVideoReplay.super.ctor(self)
end

-- 回放邀请信息
function GameVideoReplay:getShareMessage( tabParam )
    local playbackcode = tabParam.dwPlayBackCode or 0
    local url = GlobalUserItem.szWXSpreaderURL or yl.HTTP_URL
    return 
    {
        title = "回放码:" .. playbackcode,
        content = "红中麻将牌局回放,红中麻将游戏精彩刺激，一起来玩吧！",
        url = url,
        imagepath = "",
        isImage = "false",
    }
end

-- 获取单局结算界面
function GameVideoReplay:getSingleGameSettlement( tabParam )
    -- todo
    return nil
end

-- 开始回放
function GameVideoReplay:onStartReplay(gameLayer)
    -- 隐藏设置
end

-- 消息读取
function GameVideoReplay:onReadMessage( pBuffer )
    local datalen = pBuffer:getlen()
    local curlen = pBuffer:getcurlen()
    if curlen < datalen then
        local sub = pBuffer:readword()
        if 100 == sub then
            print("ggggggggggggg")
            -- 发牌消息
            local t = --发送扑克/游戏开始
            {
                 {k = "szNickName", t = "string", s = 32},                   --用户昵称
                {k = "wChairID", t = "word"},                               --椅子ID
                {k = "lScore", t = "score"},                                --用户分数(游戏币)
                {k = "lCellScore", t = "int"},                              --底分

                {k = "wBankerUser", t = "word"},                            --庄家
                {k = "wSiceCount", t = "word"},                             --骰子点数
                {k = "cbPlayerCount", t = "byte"},                            --玩家人数
                {k = "cbMagicIndex", t = "byte"},                            --鬼牌索引
                {k = "cbUserAction", t = "byte"},                            --用户动作
                

                {k = "cbCardData", t = "byte", l = {cmd.MAX_COUNT}},        --麻将列表
                {k = "cbMaCount", t = "byte"},
                {k = "IRoomCardInitialScore", t = "score",l={cmd.GAME_PLAYER}}   
            }
            local cmdtable = {}
            cmdtable.msgsub = 100
            cmdtable.startinfo = {}

            local tmp1 = ExternalFun.read_netdata(t, pBuffer)
            table.insert(cmdtable.startinfo, tmp1)
            dump(tmp1,"uuuuuuuuuuuuuuu1")
            for i=2,tmp1.cbPlayerCount do
                local tmp2 = ExternalFun.read_netdata(t, pBuffer)
                    table.insert(cmdtable.startinfo, tmp2)
                    dump(tmp2,"uuuuuuuuuuuuuuu2")
            end

            return cmdtable
        elseif 101 == sub then
            -- 用户出牌
            local cmdtable = ExternalFun.read_netdata(cmd.CMD_S_OutCard, pBuffer)
            cmdtable.msgsub = 101
            return cmdtable
        elseif 102 == sub then
            -- 用户发牌
            local cmdtable = ExternalFun.read_netdata(cmd.CMD_S_SendCard, pBuffer)
            cmdtable.msgsub = 102
            return cmdtable
        elseif 103 == sub then
            -- 操作命令
            local cmdtable = ExternalFun.read_netdata(cmd.CMD_S_OperateNotify, pBuffer)
            cmdtable.msgsub = 103
            return cmdtable
        elseif 104 == sub then
            -- 操作结果
            local cmdtable = ExternalFun.read_netdata(cmd.CMD_S_OperateResult, pBuffer)
            cmdtable.msgsub = 104
            return cmdtable
        elseif 108 == sub then
            -- 游戏结果
            local cmdtable = ExternalFun.read_netdata(cmd.CMD_S_GameConclude, pBuffer)
            cmdtable.msgsub = 108
            dump(cmdtable,"pppppppppppppppppppp")
            return cmdtable
        --elseif 110 == sub then
           -- local cmdtable = ExternalFun.read_netdata(cmd.CMD_S_Hu_Data, pBuffer)
            --cmdtable.msgsub = 110
            --return cmdtable
        elseif 111 == sub then
            -- 游戏记录
            local cmdtable = ExternalFun.read_netdata(cmd.CMD_S_Record, pBuffer)
            cmdtable.msgsub = 111
            return cmdtable
        end
    end
    return nil
end

-- 约战总结算
function GameVideoReplay:onGetPrivateEndMessage( videoDetailInfo, userList )
    local cmdtable = {}
    cmdtable.msgsub = 2000
    
    local scorelist = {}
    for k,v in pairs(userList) do
        scorelist[v.wChairID + 1] = v.dwTotalScore
    end
    cmdtable.lScore = {}
    cmdtable.lScore[1] = scorelist

    return cmdtable
end

-- 消息处理
function GameVideoReplay:onHandleMessage( gameLayer, msgTable, bForward, bBackward )
    bForward = bForward or false
    bBackward = bBackward or false
    local sub = msgTable.msgsub
    if nil == gameLayer or nil == gameLayer._gameView then
        return nil, false, true, "回放处理异常 CODE" .. GameVideo.ERRORCODE.CODE_VIEW_ERROR
    end
    if 100 == sub then
        -- 开始
        print("回放 开始")
        return self:onGetVideoStart(gameLayer, msgTable, bForward, bBackward)
    elseif 101 == sub then
        -- 出牌
        --print("回放 出牌")
        return self:onGetVideoOutcard(gameLayer, msgTable, bForward, bBackward)
    elseif 102 == sub then
        -- 抓牌
        --print("回放 发牌")
        return self:onGetVideoSendCard(gameLayer, msgTable, bForward, bBackward)
    elseif 103 == sub then
        -- 操作提示
        print("回放 提示")
        return self:onGetVideoOperate(gameLayer, msgTable, bForward, bBackward)
    elseif 104 == sub then
        -- 操作结果
        --print("回放 操作")
        return self:onGetVideoOperateResult(gameLayer, msgTable, bForward, bBackward)
    elseif 111 == sub then
        -- 牌局统计
        --print("回放 统计")
        return self:onGetVideoGameRecord(gameLayer, msgTable, bForward, bBackward)
    elseif 108 == sub then
        -- 游戏结束
        --print("回放 结果")
        return self:onGetVideoGameConclude(gameLayer, msgTable, bForward, bBackward)
    elseif 2000 == sub then
        -- 总结算
        --print("回放 总结算")
        return self:onGetPrivateRoundEnd(gameLayer, msgTable, bForward, bBackward)
    end
    return 10
end

-- 回放场景
function GameVideoReplay:onGetVideoScene(gameLayer, msgTable, bForward, bBackward)
    return 5, true
end

-- 游戏开始
function GameVideoReplay:onGetVideoStart(gameLayer, msgTable, bForward, bBackward)
    -- 界面重置
    gameLayer:OnResetGameEngine()
    gameLayer._gameView.bIsVideo = true
    gameLayer.cbTimeOutCard = 0
    gameLayer.cbTimeOperateCard = 0
    gameLayer.cbTimeStartGame = 0

    gameLayer._gameView:removeChildByTag(9898, true)
        
print("回放椅子数", gameLayer._gameFrame:GetChairCount())
    if bBackward then
        print("快退处理 索引==>" .. GameVideo:getInstance().m_nMessageIdx)
        local msg = GameVideo:getInstance().m_tabStepVideoMessage[GameVideo:getInstance().m_nMessageIdx]
        if not self:backwardCheck(msg, msgTable) then
            return nil, true, "回放处理异常 CODE" .. GameVideo.ERRORCODE.CODE_CACHE_ERROR
        end
    else
        -- 存储数据
        local msg = {}
        msg.msgsub = msgTable.msgsub

        -- 更新
        self:cacheUserCards(msg, gameLayer)

        GameVideo:getInstance().m_tabStepVideoMessage[GameVideo:getInstance().m_nMessageIdx] = msg
    end
    local msg = {}
    msg.msgsub = msgTable.msgsub

    local userCard = {}
    local cbCardCount = {0, 0, 0, 0}
    local wViewBankerUser = nil
    for k,v in pairs(msgTable.startinfo) do
            --print("发牌椅子 ==> ", v.wChairID)
            -- 视图转换
            local viewId = gameLayer:SwitchViewChairID(v.wChairID)
            print("转换视图 ==> "..viewId..","..v.wChairID)

            -- 发牌
            gameLayer.wBankerUser = v.wBankerUser
            wViewBankerUser = gameLayer:SwitchViewChairID(gameLayer.wBankerUser)

            userCard[viewId] = {}
            for i=1,cmd.MAX_COUNT do
                if v.cbCardData[1][i] ~= 0 then
                    table.insert(userCard[viewId], v.cbCardData[1][i])
                    table.insert(gameLayer.cbHandCardData[viewId], v.cbCardData[1][i])
                end
            end

          

            for i = 1, cmd.GAME_PLAYER do
                local wViewChairId = gameLayer:SwitchViewChairID(i -1)
                cbCardCount[wViewChairId] = 13
                if wViewChairId == wViewBankerUser then
                    cbCardCount[wViewChairId] = cbCardCount[wViewChairId] + 1
                end

            end

            if v.wChairID == gameLayer:GetMeChairID() then

                gameLayer.lCellScore = v.lCellScore
                --历史积分

                --规则
                gameLayer.cbPlayerCount = v.cbPlayerCount or 4
                gameLayer.cbMaCount = v.cbMaCount
                             
                gameLayer._gameView._cardLayer.nRemainCardNum = 112
                gameLayer._gameView:setRemainCardNum(112)

                --设置信息
                --gameLayer._gameView:onshowRule( gameLayer.lCellScore, gameLayer.cbMaCount, gameLayer.cbMagicMode, gameLayer.bQiangGangHu, gameLayer.bHuQiDui, gameLayer.bHaveZiCard ,gameLayer.bNoMagicDouble, gameLayer.cbMagicMode)
                --设置牌数
                --gameLayer._gameView:setRemainCardNum(gameLayer._gameView._cardLayer.nRemainCardNum)
            end
        
            if msgTable.bIsPrivateRoom and PriRoom:getInstance():isCurrentGameOpenPri(GlobalUserItem.nCurGameKind) then
                if 1 == msgTable.nGameRound then
                    PriRoom:getInstance().m_tabPriData.lIniScore = v.lScore
                end
                print("==========================================》》》》", PriRoom:getInstance().m_tabPriData.lIniScore)
            end

            -- 用户游戏币(分数)
            --gameLayer._gameView.m_tabUserHead[viewId].m_userItem.lScore = v.lScore
            gameLayer._gameView.m_sparrowUserItem[viewId].lScore = v.lScore
            gameLayer._gameView:updateUserScore(viewId,v.lScore)

    end

    local res = 
    {
        cmd.RES_PATH.."game/font_small/card_back.png",
        cmd.RES_PATH.."game/font_small_side/card_back.png",
        cmd.RES_PATH.."game/font_big/card_back.png",
        cmd.RES_PATH.."game/font_small_side/card_back.png"
    }

    for i = 1, cmd.GAME_PLAYER do
        for j = 1, cmd.MAX_COUNT do
               local card = gameLayer._gameView._cardLayer.nodeHandDownCard[i]:getChildByTag(j)
               card:setTexture(res[i])
               card:removeAllChildren()
        end
    end

    msg.userHandCards = userCard

    --dump(userCard,"==================>1")
    --dump(cbCardCount,"==================>2")
    gameLayer._gameView:gameStart(userCard, cbCardCount)
    gameLayer._gameView:setBanker(gameLayer:SwitchViewChairID(gameLayer.wBankerUser))
   
    gameLayer:SetGameClock(gameLayer.wBankerUser, cmd.IDI_OUT_CARD, 0)

    print("缓存 索引==>" .. GameVideo:getInstance().m_nMessageIdx)
    GameVideo:getInstance().m_tabStepVideoMessage[GameVideo:getInstance().m_nMessageIdx] = msg

    -- 约战房刷新信息
    if msgTable.bIsPrivateRoom and PriRoom:getInstance():isCurrentGameOpenPri(GlobalUserItem.nCurGameKind) then
        print("回放约战房")
        PriRoom:getInstance().m_tabPriData.dwPlayCount = msgTable.nGameRound
        gameLayer._gameView._priView:onRefreshInfo()
    end

    
    --gameLayer._gameView._cardLayer.nRemainCardNum = 112- 13 *4 -1

    -- 隐藏准备
    gameLayer._gameView.btStart:setVisible(false)

    return 70, true
end



-- 回放出牌

function GameVideoReplay:onGetVideoOutcard(gameLayer, msgTable, bForward, bBackward)
    if bBackward then
        print("快退处理")
        local msg = GameVideo:getInstance().m_tabStepVideoMessage[GameVideo:getInstance().m_nMessageIdx]
        if not self:backwardCheck(msg, msgTable) then
            return nil, true, "回放处理异常 CODE" .. GameVideo.ERRORCODE.CODE_CACHE_ERROR
        end
        
        -- 更新玩家牌
        self:backwardUpdateUserCards(msg, gameLayer)

    else
        -- 存储数据
        local msg = {}
        msg.msgsub = msgTable.msgsub
        -- 三个玩家牌
        self:cacheUserCards(msg, gameLayer, bForward)

        GameVideo:getInstance().m_tabStepVideoMessage[GameVideo:getInstance().m_nMessageIdx] = msg
    end

    local wViewId = gameLayer:SwitchViewChairID(msgTable.wOutCardUser)

        --gameLayer._gameView._cardLayer:outCardVedio(wViewId, msgTable.cbOutCardData, true)
        --gameLayer:playCardDataSound(msgTable.wOutCardUser, msgTable.cbOutCardData)
        

        gameLayer._gameView:gameOutCard(wViewId, msgTable.cbOutCardData)

        gameLayer:PlaySound(cmd.RES_PATH.."sound/OUT_CARD.wav")
        gameLayer:playCardDataSound(wViewId, msgTable.cbOutCardData)

 
    --存储界面数据
    table.insert(gameLayer.cbOutCardData[wViewId], msgTable.cbOutCardData)
    for i=1,#gameLayer.cbHandCardData[wViewId] do
        if gameLayer.cbHandCardData[wViewId][i] == msgTable.cbOutCardData then
            table.remove(gameLayer.cbHandCardData[wViewId], i)
            break
        end
    end

    -- 隐藏准备
    gameLayer._gameView.btStart:setVisible(false)

    return 10, true
end

-- 回放发牌
function GameVideoReplay:onGetVideoSendCard(gameLayer, msgTable, bForward, bBackward)
    if bBackward then
        print("快退处理")
        local msg = GameVideo:getInstance().m_tabStepVideoMessage[GameVideo:getInstance().m_nMessageIdx]
        if not self:backwardCheck(msg, msgTable) then
            return nil, true, "回放处理异常 CODE" .. GameVideo.ERRORCODE.CODE_CACHE_ERROR
        end
        
        -- 更新玩家牌
        self:backwardUpdateUserCards(msg, gameLayer)

    else
        -- 存储数据
        local msg = {}
        msg.msgsub = msgTable.msgsub
        -- 三个玩家牌
        self:cacheUserCards(msg, gameLayer, bForward)

        GameVideo:getInstance().m_tabStepVideoMessage[GameVideo:getInstance().m_nMessageIdx] = msg
    end
    
    -- 视图转换
    local viewId = gameLayer:SwitchViewChairID(msgTable.wCurrentUser)
    
        gameLayer._gameView:gameSendCard(viewId, msgTable.cbCardData)
    
        gameLayer:SetGameClock(msgTable.wCurrentUser, cmd.IDI_OUT_CARD, 0)

    table.insert(gameLayer.cbHandCardData[viewId], msgTable.cbCardData)
    --gameLayer._gameView._cardLayer.nRemainCardNum = gameLayer._gameView._cardLayer.nRemainCardNum -1

    --print("转换视图 ==> ", viewId)
    -- 隐藏准备
    gameLayer._gameView.btStart:setVisible(false)

    return 10, true
end


function GameVideoReplay:onGetVideoOperate(gameLayer, msgTable, bForward, bBackward)
    if bBackward then
        print("快退处理")
        local msg = GameVideo:getInstance().m_tabStepVideoMessage[GameVideo:getInstance().m_nMessageIdx]
        if not self:backwardCheck(msg, msgTable) then
            return nil, true, "回放处理异常 CODE" .. GameVideo.ERRORCODE.CODE_CACHE_ERROR
        end
        
        -- 更新玩家牌
        self:backwardUpdateUserCards(msg, gameLayer)
    else
        -- 存储数据
        local msg = {}
        msg.msgsub = msgTable.msgsub
        -- 三个玩家牌
        self:cacheUserCards(msg, gameLayer, bForward)

        GameVideo:getInstance().m_tabStepVideoMessage[GameVideo:getInstance().m_nMessageIdx] = msg
    end
    return 5, true
end

-- 回放操作结果
function GameVideoReplay:onGetVideoOperateResult(gameLayer, msgTable, bForward, bBackward)
    local bNoDelay = (bBackward or bForward)
    if bBackward then
        print("快退处理")
        local msg = GameVideo:getInstance().m_tabStepVideoMessage[GameVideo:getInstance().m_nMessageIdx]
        if not self:backwardCheck(msg, msgTable) then
            return nil, true, "回放处理异常 CODE" .. GameVideo.ERRORCODE.CODE_CACHE_ERROR
        end
        
        -- 更新玩家牌
        self:backwardUpdateUserCards(msg, gameLayer)

    else
        -- 存储数据
        local msg = {}
        msg.msgsub = msgTable.msgsub
        -- 三个玩家牌
        self:cacheUserCards(msg, gameLayer, bForward)

        GameVideo:getInstance().m_tabStepVideoMessage[GameVideo:getInstance().m_nMessageIdx] = msg
    end



   local wOperateViewId = gameLayer:SwitchViewChairID(msgTable.wOperateUser)
    local wProvideViewId = gameLayer:SwitchViewChairID(msgTable.wProvideUser)

   local tagAvtiveCard = {}
    tagAvtiveCard.cbType = GameLogic.SHOW_NULL


    if msgTable.cbOperateCode < GameLogic.WIK_LISTEN  and  msgTable.cbOperateCode > GameLogic.WIK_NULL then       --并非听牌
        local nShowStatus = GameLogic.SHOW_NULL
        local data1 = msgTable.cbOperateCard[1][1]
        local data2 = msgTable.cbOperateCard[1][2]
        local data3 = msgTable.cbOperateCard[1][3]
        local cbOperateData = {}
        local cbRemoveData = {}
        if msgTable.cbOperateCode == GameLogic.WIK_GANG then
            cbOperateData = {data1, data1, data1, data1}
            cbRemoveData = {data1, data1, data1}

            tagAvtiveCard.cbCardValue = clone(cbOperateData)
            --检查杠的类型
            local cbCardCount = gameLayer._gameView._cardLayer.cbCardCount[wOperateViewId]
            if math.mod(cbCardCount - 2, 3) == 0 then
                if gameLayer._gameView._cardLayer:checkBumpOrBridgeCard(wOperateViewId, data1) then
                    nShowStatus = GameLogic.SHOW_MING_GANG
                else
                    nShowStatus = GameLogic.SHOW_AN_GANG
                end
            else
                nShowStatus = GameLogic.SHOW_FANG_GANG
            end
        elseif msgTable.cbOperateCode == GameLogic.WIK_PENG then
            cbOperateData = {data1, data1, data1}
            cbRemoveData = {data1, data1}
            nShowStatus = GameLogic.SHOW_PENG

            tagAvtiveCard.cbCardValue = clone(cbOperateData)
        
        end

        tagAvtiveCard.cbType = nShowStatus

        local bAnGang = nShowStatus == GameLogic.SHOW_AN_GANG
        gameLayer._gameView._cardLayer:bumpOrBridgeCard(wOperateViewId, cbOperateData, nShowStatus)

        if nShowStatus == GameLogic.SHOW_AN_GANG then
            gameLayer._gameView._cardLayer:removeHandCard(wOperateViewId, cbOperateData, false)
        elseif nShowStatus == GameLogic.SHOW_MING_GANG then
            gameLayer._gameView._cardLayer:removeHandCard(wOperateViewId, {data1}, false)
        else
            gameLayer._gameView._cardLayer:removeHandCard(wOperateViewId, cbRemoveData, false)
            --self._gameView._cardLayer:recycleDiscard(self:SwitchViewChairID(cmd_data.wProvideUser))
            --print("提供者不正常？", cmd_data.wProvideUser, self:GetMeChairID())
        end
        gameLayer:PlaySound(cmd.RES_PATH.."sound/PACK_CARD.wav")
        gameLayer:playCardOperateSound(wOperateViewId, false, msgTable.cbOperateCode)
        gameLayer._gameView:showOperateFlag(wOperateViewId, msgTable.cbOperateCode)

        gameLayer._gameView.cbOutCardTemp = 0 --不把牌丢入弃牌堆
    end

--牌存储数据处理
    table.insert(gameLayer.cbActivityCardData[wOperateViewId], tagAvtiveCard)
    local cbCardData = clone(tagAvtiveCard.cbCardValue)
    local removeNum = #cbCardData
    if nShowStatus == GameLogic.SHOW_MING_GANG then
        removeNum = 1
    elseif nShowStatus == GameLogic.SHOW_FANG_GANG then
        removeNum = 3
    end

   
        if GameLogic.SHOW_FANG_GANG  or GameLogic.SHOW_PENG then
            --if tagAvtiveCard.cbCardValue[1] == cbCardData[i] and wOperateViewId ~= wProvideViewId then
                --table.remove(cbCardData, i)
                table.remove(gameLayer.cbOutCardData[wProvideViewId], #gameLayer.cbOutCardData[wProvideViewId])
               -- break
           -- end
        end


    --删除手牌
    for i=1,removeNum do
        for j = #gameLayer.cbHandCardData[wOperateViewId], 1, -1 do
            if gameLayer.cbHandCardData[wOperateViewId][j] == cbCardData[1] then
                table.remove(gameLayer.cbHandCardData[wOperateViewId], j)
                break
            end
        end
    end

    -- 隐藏准备
    gameLayer._gameView.btStart:setVisible(false)

    return 20, false
end

-- 回放数据记录
function GameVideoReplay:onGetVideoGameRecord(gameLayer, msgTable, bForward, bBackward)
    local bNoDelay = (bBackward or bForward)
    if bBackward then
        print("快退处理")
        local msg = GameVideo:getInstance().m_tabStepVideoMessage[GameVideo:getInstance().m_nMessageIdx]
        if not self:backwardCheck(msg, msgTable) then
            return nil, true, "回放处理异常 CODE" .. GameVideo.ERRORCODE.CODE_CACHE_ERROR
        end
    else
        -- 存储数据
        local msg = {}
        msg.msgsub = msgTable.msgsub

        GameVideo:getInstance().m_tabStepVideoMessage[GameVideo:getInstance().m_nMessageIdx] = msg
    end

    gameLayer.m_userRecord = {}
    local nInningsCount = msgTable.nCount
    for i = 1, cmd.GAME_PLAYER do
        gameLayer.m_userRecord[i] = {}
        gameLayer.m_userRecord[i].cbHuCount = msgTable.cbHuCount[1][i]
        gameLayer.m_userRecord[i].cbMingGang = msgTable.cbMingGang[1][i]
        gameLayer.m_userRecord[i].cbAnGang = msgTable.cbAnGang[1][i]
        gameLayer.m_userRecord[i].cbMaCount = msgTable.cbMaCount[1][i]
    end

end

-- 回放结算
function GameVideoReplay:onGetVideoGameConclude(gameLayer, msgTable, bForward, bBackward)
    if bBackward then
        print("快退处理")
        local msg = GameVideo:getInstance().m_tabStepVideoMessage[GameVideo:getInstance().m_nMessageIdx]
        if not self:backwardCheck(msg, msgTable) then
            return nil, true, "回放处理异常 CODE" .. GameVideo.ERRORCODE.CODE_CACHE_ERROR
        end
        
        -- 更新玩家牌
        self:backwardUpdateUserCards(msg, gameLayer)

    else
        -- 存储数据
        local msg = {}
        msg.msgsub = msgTable.msgsub

        -- 三个玩家牌
        self:cacheUserCards(msg, gameLayer, bForward)

        GameVideo:getInstance().m_tabStepVideoMessage[GameVideo:getInstance().m_nMessageIdx] = msg
    end


   -- local jsonStr = cjson.encode(msgTable)
    --LogAsset:getInstance():logData(jsonStr, true)

   local bMeWin = nil   --nil：没人赢，false：有人赢但我没赢，true：我赢
    
    --提示胡牌标记
    for i = 1, gameLayer.chairCount do
        local wViewChairId = gameLayer:SwitchViewChairID(i - 1)
        if msgTable.cbChiHuKind[1][i] >= GameLogic.WIK_CHI_HU then
            bMeWin = false
            gameLayer:playCardOperateSound(wViewChairId, false, GameLogic.WIK_CHI_HU)
            gameLayer._gameView:showOperateFlag(wViewChairId, GameLogic.WIK_CHI_HU)
            if wViewChairId == cmd.MY_VIEWID then
                bMeWin = true
            end
        end
    end
    --显示结算图层
    local resultList = {}
    local cbBpBgData = gameLayer._gameView._cardLayer:getBpBgCardData()
    for i = 1, gameLayer.chairCount do
        local wViewChairId = gameLayer:SwitchViewChairID(i - 1)
        local lScore = msgTable.lGameScore[1][i]
        local user = gameLayer:getUserInfoByChairID(i-1)
        if user then
            local result = {}
            result.userItem = user
            result.lScore = lScore
            result.cbChHuKind = msgTable.cbChiHuKind[1][i]
            result.cbCardData = {}
            --手牌
            --dump(msgTable.cbHandCardData,"hhhhhhhhhhhhhhhhhhhhhhhhhhhh")
            for j = 1, msgTable.cbCardCount[1][i] do
                result.cbCardData[j] = msgTable.cbHandCardData[i][j]
            end
            --碰杠牌
            result.cbBpBgCardData = cbBpBgData[wViewChairId]
            --奖码
            result.cbAwardCard = {}
            for j = 1, msgTable.cbMaCount[1][i] do
                result.cbAwardCard[j] = msgTable.cbMaData[1][j]
            end
            --插入
            table.insert(resultList, result)
            
        end
    end
    --全部奖码
    local meIndex = gameLayer:GetMeChairID() + 1
    local cbAwardCardTotal = {}
    for i = 1, 7 do
        local value = msgTable.cbMaData[1][i]
        if value and value > 0 then
            table.insert(cbAwardCardTotal, value)
        end
    end
    

    local cbRemainCard = {}

    if msgTable.cbLeftCardData then       
          for i=1,#msgTable.cbLeftCardData[1]  do
            if msgTable.cbLeftCardData[1][i] == 0 then
                break
            end
        cbRemainCard[i] = msgTable.cbLeftCardData[1][i]
          end
    end
 
    --显示结算框
    gameLayer:runAction(cc.Sequence:create(cc.DelayTime:create(1), cc.CallFunc:create(function(ref)
        local resultLayer = ResultLayer:create(gameLayer._gameView):addTo(gameLayer._gameView,15)

        resultLayer:setTag(9898)
        resultLayer:showLayer(resultList, cbAwardCardTotal, cbRemainCard, gameLayer.wBankerUser, msgTable.cbProvideCard)
    end)))
    --播放音效
    if bMeWin then
        gameLayer:PlaySound(cmd.RES_PATH.."sound/ZIMO_WIN.wav")
    else
        gameLayer:PlaySound(cmd.RES_PATH.."sound/ZIMO_LOSE.wav")
    end


      gameLayer._gameView:gameConclude()


    return 60, false
end

function GameVideoReplay:onGetPrivateRoundEnd( gameLayer, msgTable, bForward, bBackward )

    
    gameLayer._gameView:removeChildByTag(9898)

    local scorelist = msgTable.lScore[1]
    gameLayer._gameView._priView:onPriGameEnd(msgTable)

    return 40, false
end

-- 回退数据检查
function GameVideoReplay:backwardCheck( msg, msgTab )
    if type(msg) ~= "table" then
        print("回退消息包异常")
        return false, "回退消息包异常"
    end
    -- 消息不一致
    if msg.msgsub ~= msgTab.msgsub then
        print("回退消息包异常, 消息不一致")
        return false, "回退消息包异常"
    end

    return true
end

-- 回退更新牌
function GameVideoReplay:backwardUpdateUserCards( msg, gameLayer )
    gameLayer:stopAllActions()
    gameLayer._gameView:stopAllActions()
    gameLayer:OnResetGameEngine()

    gameLayer._gameView:removeChildByTag(9898,true)

    -- 更新玩家牌
    local userHandCards = clone(msg.userHandCards)
    --手牌排序
    for i=1,cmd.GAME_PLAYER do
        local viewid = gameLayer:SwitchViewChairID(i - 1)
        if #userHandCards[viewid] > 1 then
            GameLogic.SortCardList(userHandCards[viewid])
        end
    end

    local userOutCards = clone(msg.userOutCards)
    local userActivityCards = clone(msg.userActivityCards)

    gameLayer.cbHandCardData = userHandCards
    gameLayer.cbOutCardData = userOutCards
    gameLayer.cbActivityCardData = userActivityCards
    gameLayer._gameView._cardLayer.nRemainCardNum = msg.leftCard 

    gameLayer._gameView:updateCardsNode(userHandCards, userOutCards, userActivityCards,msg.leftCard)
end

-- 存储玩家牌
function GameVideoReplay:cacheUserCards(msg, gameLayer, isForward)
    -- 三个玩家牌
    local userHandCards = {}
    local userOutCards = {}
    local userActivityCards = {}

    userHandCards = clone(gameLayer.cbHandCardData)
    --[[
    --手牌排序
    for i=1,cmd.GAME_PLAYER do
        local viewid = gameLayer:SwitchViewChairID(i - 1)
        if #userHandCards[viewid] > 0 then
            table.sort(userHandCards[viewid], function (a, b)
                    if gameLayer._gameView._cardLayer:isMagicCard(a) and gameLayer._gameView._cardLayer:isMagicCard(b) then
                        return a < b
                    elseif gameLayer._gameView._cardLayer:isMagicCard(a) then
                        return true
                    elseif gameLayer._gameView._cardLayer:isMagicCard(b) then
                        return false
                    else
                        return a < b
                    end
            end)
        end
    end
    ]]

    userOutCards = clone(gameLayer.cbOutCardData)
    userActivityCards = clone(gameLayer.cbActivityCardData)

    msg.userHandCards = userHandCards
    msg.userOutCards = userOutCards
    msg.userActivityCards = userActivityCards
    msg.leftCard = gameLayer._gameView._cardLayer.nRemainCardNum


    if isForward then
        gameLayer:stopAllActions()
        --gameLayer._gameView:onResetData()
        gameLayer._gameView:stopAllActions()

        gameLayer._gameView:updateCardsNode(userHandCards, userOutCards, userActivityCards,  msg.leftCard)
    end
end

-- 获取玩家结算界面
function GameVideoReplay:getVideoResultView( cmdlist )
    local msgTab = nil
    for k,v in pairs(cmdlist) do
        if v.msgsub == 108 then --找到总结算
            msgTab = v
            break
        end
    end
    if type(msgTab) ~= "table" then
        print("结算消息包异常")
        return false, "结算消息包异常"
    end

    local jsonStr = cjson.encode(msgTab)
    LogAsset:getInstance():logData(jsonStr, true)

    --用户列表
    local tabListInfo = GameVideo:getInstance():getVideoListInfo()
    if 0 == #tabListInfo then
        unGetInfoFun()
        return true
    end
    local iteminfo = tabListInfo[1]
    if 0 == #iteminfo then
        unGetInfoFun()
        return true
    end
    -- local userinfo = iteminfo[1]
    -- if nil == userinfo.szPersonalGUID or "" == userinfo.szPersonalGUID then
    --     unGetInfoFun()
    --     return true
    -- end
    dump(iteminfo, "玩家信息", 10)

    local resultList = {}
    for i = 1, 4 do
        local result = {}
        --玩家头像
        if 0 < #iteminfo then
            for j=1,#iteminfo do
                local Iteminfo = iteminfo[j]
                if Iteminfo.wChairID == i -1 then
                    result.userItem = Iteminfo
                    break
                end
            end
        end

        local lScore = msgTab.lGameScore[1][i]
       -- local lHuScore = msgTab.lHuScore[1][i]
      
        result.lScore = lScore
        --result.lHuScore = lHuScore
        --result.lGangScore = msgTab.lGangScore[1][i]
        --result.lMaScore = msgTab.lMaScore[1][i]
        --result.cbChHuKind = msgTab.cbChiHuKind[1][i]
        --胡牌类型
        result.dwChiHuRight = {}
        --for j=1,cmd.MAX_RIGHT_COUNT do
            result.dwChiHuRight[1] = msgTab.dwChiHuRight[i][1]
        --end

        --设置癞子
        --result.cbMagicData = msgTab.cbMagicIndex[1]

        result.cbCardData = {}
        --手牌
        for j = 1, msgTab.cbCardCount[1][i] do
            result.cbCardData[j] = msgTab.cbHandCardData[i][j]
        end
        --如果是我自摸
        if HuChair == i -1 and 0 ~= msgTab.cbSendCardData then
            table.insert(result.cbCardData, msgTab.cbSendCardData)
        end

             --先设置碰杠出的牌
             dump(msgTab.cbWeaveItemCount[1],"hhhhhhhhhhhhhhhhhhhhh1=============")
        if msgTab.cbWeaveItemCount[1][i] > 0 then
            local tabActiveCardData = {}
            for j = 1, msgTab.cbWeaveItemCount[1][i] do
                local cbOperateData = {} --此处为tagAvtiveCard
                cbOperateData.cbCardValue = msgTab.WeaveItemArray[i][j].cbCardData[1]
                dump(cbOperateData.cbCardValue, "操作的牌")
                local nShowStatus = GameLogic.SHOW_NULL
                local cbParam = msgTab.WeaveItemArray[i][j].cbParam
                if cbParam == GameLogic.WIK_GANERAL then
                    if cbOperateData[1] == cbOperateData[2] then    --碰
                        nShowStatus = GameLogic.SHOW_CHI
                    else                                            --吃
                        nShowStatus = GameLogic.WIK_LEFT
                    end
                    cbOperateData.cbCardNum = 3
                    table.remove(cbOperateData.cbCardValue, 4)--去掉末尾0
                elseif cbParam == GameLogic.WIK_MING_GANG then
                    nShowStatus = GameLogic.SHOW_MING_GANG
                    cbOperateData.cbCardNum = 4
                elseif cbParam == GameLogic.WIK_FANG_GANG then
                    nShowStatus = GameLogic.SHOW_FANG_GANG
                    cbOperateData.cbCardNum = 4
                elseif cbParam == GameLogic.WIK_AN_GANG then
                    nShowStatus = GameLogic.SHOW_AN_GANG
                    cbOperateData.cbCardNum = 4
                end
                cbOperateData.cbType = nShowStatus
                -- local wProvideViewId = self:SwitchViewChairID(cmd_data.WeaveItemArray[i][j].wProvideUser)
                -- cbOperateData.wProvideViewId = wProvideViewId

                --排序
                table.sort(cbOperateData.cbCardValue, function (a, b)
                    return a < b
                end)
                table.insert(tabActiveCardData, cbOperateData)
            end
            result.cbActiveCardData = tabActiveCardData
        end

        --插入
        table.insert(resultList, result)
    end

    local ResultLayer =  VideoResultLayer:create(self)
    if nil ~= ResultLayer then
        print("显示结算框", ResultLayer)
        --dump(resultList, "结算信息", 8)
        ResultLayer:showLayer(resultList, msgTab.cbProvideCard)
        return ResultLayer
    end

    return nil
end

return GameVideoReplay