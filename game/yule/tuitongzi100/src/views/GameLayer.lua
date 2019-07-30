local GameModel = appdf.req(appdf.CLIENT_SRC.."gamemodel.GameModel")
local GameLayer = class("GameLayer", GameModel)

local Game_CMD = appdf.req(appdf.GAME_SRC.."yule.tuitongzi100.src.models.CMD_Game")
local GameServer_CMD = appdf.req(appdf.HEADER_SRC.."CMD_GameServer")
local GameViewLayer = appdf.req(appdf.GAME_SRC.."yule.tuitongzi100.src.views.layer.GameViewLayer")
local GameFrame = appdf.req(appdf.GAME_SRC.."yule.tuitongzi100.src.models.GameFrame")
local ExternalFun =  appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")

function GameLayer:ctor(frameEngine, scene)	
	self._dataModle = GameFrame:create()
	--游戏是否处于空闲状态
	GameLayer.super.ctor(self, frameEngine, scene)
	GameLayer.super.OnInitGameEngine(self)
end

--获取gamekind
function GameLayer:getGameKind()
    return Game_CMD.KIND_ID
end

--创建场景
function GameLayer:CreateView()
    return GameViewLayer:create(self)
        :addTo(self)
end

--网络处理
--------------------------
--场景消息
function GameLayer:onEventGameScene(cbGameStatus, dataBuffer)
	print("场景消息================================")
	if cbGameStatus == Game_CMD.GS_SCENE_FREE then
		self:onGameSceneFree( dataBuffer )
	elseif cbGameStatus == Game_CMD.GS_PLACE_JETTON or cbGameStatus == Game_CMD.GS_GAME_END then
		self:onGameScenePlaying( dataBuffer,cbGameStatus)
	end
	self:dismissPopWait()
end

--游戏数据
function GameLayer:onEventGameMessage(sub, dataBuffer)
	if sub == Game_CMD.SUB_S_GAME_FREE then              --99
		--游戏空闲
		self:onGameMessageFree(dataBuffer)
	elseif sub == Game_CMD.SUB_S_GAME_START then         --100
		--游戏开始
		self:onGameMessageStart(dataBuffer)
	elseif sub == Game_CMD.SUB_S_GAME_END then              --102
		--游戏结束
		self:onGameMessageEnd(dataBuffer) 
	elseif sub == Game_CMD.SUB_S_PLACE_JETTON then         --101
		--用户下注
		self:onGameMessagePlaceJetton(dataBuffer)
	elseif sub == Game_CMD.SUB_S_APPLY_BANKER then         --103
	--申请庄家 
		self:onGameMessageApplyBanker(dataBuffer)
	elseif sub == Game_CMD.SUB_S_CHANGE_BANKER then        --104
	--切换庄家 
		self:onGameMessageChageBanker(dataBuffer)
	elseif sub == Game_CMD.SUB_S_CHANGE_USER_SCORE then     --105
	--更新积分
		self:onGameMessageChangeUserScore(dataBuffer) 
	elseif sub == Game_CMD.SUB_S_SEND_RECORD then           --106
	--游戏记录 
		self:onGameMessageSendRecord(dataBuffer)
	elseif sub == Game_CMD.SUB_S_PLACE_JETTON_FAIL then     --107
	--下注失败
 		self:onGameMessagePlaceJettonFail(dataBuffer)
	elseif sub == Game_CMD.SUB_S_CANCEL_BANKER then         --108
	--取消申请 
		self:onGameMessageCancelBanker(dataBuffer) 
	elseif sub == Game_CMD.SUB_S_CANCEL_CAN then            --109
	--取消申请 
	elseif sub == Game_CMD.SUB_S_SELECT_CARD_MODE then           --110
	--发牌模式 
	elseif sub == Game_CMD.SUB_S_RE_DISPATCH_CARD then          --111
	--重新发牌 
	elseif sub == Game_CMD.SUB_S_CATCH_BANKER then            --112
	--玩家抢庄 

	elseif sub == Game_CMD.SUB_S_AMDIN_COMMAND then           --113 
	--管理员命令 
	elseif sub == Game_CMD.SUB_S_UPDATE_STORAGE then          --114
	--更新库存，机器人金贝 
	elseif sub == Game_CMD.SUB_S_ADMIN_STORAGE_INFO then         --115
	--库存管理 
	elseif sub == Game_CMD.SUB_S_SCORE_INFO then              --116
	--积分事件 
	end
end

function GameLayer:onGameSceneFree(dataBuffer)
	local cmd_table = ExternalFun.read_netdata(Game_CMD.CMD_S_StatusFree, dataBuffer) 
	self._gameView:onGameSceneFree(cmd_table)
	self:SetGameClock(self:GetMeChairID(), 1, cmd_table.cbTimeLeave)
end

function GameLayer:onGameScenePlaying(dataBuffer, cbGameStatus)
	local cmd_table = ExternalFun.read_netdata(Game_CMD.CMD_S_StatusPlay, dataBuffer) 
	self._gameView:onGameScenePlaying(cmd_table, cbGameStatus)
	self:SetGameClock(self:GetMeChairID(), 1, cmd_table.cbTimeLeave)
end

--游戏空闲
function GameLayer:onGameMessageFree(dataBuffer)
	local cmd_table = ExternalFun.read_netdata(Game_CMD.CMD_S_GameFree, dataBuffer)
	self._gameView:onGameFree(cmd_table)
	--空闲倒计时 
	self:SetGameClock(self:GetMeChairID(), 1, cmd_table.cbTimeLeave)
end

--游戏开始
function GameLayer:onGameMessageStart(dataBuffer)
	local cmd_table = ExternalFun.read_netdata(Game_CMD.CMD_S_GameStart, dataBuffer)
	self._gameView:onGameStart(cmd_table)
	--游戏开始倒计时
	self:SetGameClock(self:GetMeChairID(), 1, cmd_table.cbTimeLeave)
end

--游戏结束
function GameLayer:onGameMessageEnd(dataBuffer)
	local cmd_table = ExternalFun.read_netdata(Game_CMD.CMD_S_GameEnd, dataBuffer)
	self._gameView:onGameEnd(cmd_table)
	self:SetGameClock(self:GetMeChairID(), 1, cmd_table.cbTimeLeave)
end

--游戏记录
function GameLayer:onGameMessageSendRecord(dataBuffer)
	local record = {}
	local len = dataBuffer:getlen()
	local recordcount = math.floor(len/Game_CMD.RECORD_LEN)

	if (len - recordcount * Game_CMD.RECORD_LEN) ~= 0 then return end

	for i=1, recordcount do
		if nil == dataBuffer then
			break
		end

		local temp = {}
		temp.bPointBanker = dataBuffer:readbyte()
		temp.bPointTianMen = dataBuffer:readbyte()
		temp.bPointZhongMen = dataBuffer:readbyte()
		temp.bPointDiMen = dataBuffer:readbyte()
		table.insert(record, temp)
	end

	local cmd_table = ExternalFun.read_netdata(Game_CMD.tagServerGameRecord, dataBuffer)
	self._gameView:onGameSendRecord(record)
end
---------------------------------------------------------------
--网络处理
--申请上庄
function GameLayer:sendApplyBanker()
	local cmddata = CCmd_Data.create(0)
	self:SendData(Game_CMD.SUB_C_APPLY_BANKER, cmddata)
end

--申请下庄
function GameLayer:sendCancelApply()
    local cmddata = CCmd_Data:create(0)
    self:SendData(Game_CMD.SUB_C_CANCEL_BANKER, cmddata)
end

--申请上庄
function GameLayer:onGameMessageApplyBanker(dataBuffer)
	local cmd_table = ExternalFun.read_netdata(Game_CMD.CMD_S_ApplyBanker,dataBuffer)
    self._dataModle:addApplyUser(cmd_table.wApplyUser, false) 
    self._gameView:onApplyBanker(cmd_table)
end

--申请下庄
function GameLayer:onGameMessageCancelBanker(dataBuffer)
	local cmd_table = ExternalFun.read_netdata(Game_CMD.CMD_S_CancelBanker,dataBuffer)
	--从申请列表移除
    self._dataModle:removeApplyUser(cmd_table.wCancelUser)
    
    self._gameView:onGetCancelBanker(cmd_table)
end

--发送下注
function GameLayer:SendPlaceJetton( jettonScore, jettonArea )
	-- body
	local cmddata = ExternalFun.create_netdata(Game_CMD.CMD_C_PlaceJetton)
	cmddata:pushbyte(jettonArea)
	cmddata:pushscore(jettonScore)
	self:SendData(Game_CMD.SUB_C_PLACE_JETTON, cmddata)
end

--用户下注
function GameLayer:onGameMessagePlaceJetton(dataBuffer)
	local cmd_table = ExternalFun.read_netdata(Game_CMD.CMD_S_PlaceJetton, dataBuffer)
            print("------------dddddddddddddddddd----------------"..cmd_table.lJettonScore)
	self._gameView:onPlaceJetton(cmd_table)
end

--下注失败
function GameLayer:onGameMessagePlaceJettonFail()
	-- local cmd_table = ExternalFun.read_netdata(Game_CMD.CMD_S_PlaceJettonFail, dataBuffer)
	-- self._gameView:onPlaceJettonFail(cmd_table)
end

--切换庄家
function GameLayer:onGameMessageChageBanker(dataBuffer)
	local cmd_table = ExternalFun.read_netdata(Game_CMD.CMD_S_ChangeBanker,dataBuffer)
	self._gameView:changeBanker(cmd_table)
end

--申请取款
function GameLayer:sendTakeScore(lScore, szPassword )
    local cmddata = ExternalFun.create_netdata(GameServer_CMD.CMD_GR_C_TakeScoreRequest)
    cmddata:setcmdinfo(GameServer_CMD.MDM_GR_INSURE, GameServer_CMD.SUB_GR_TAKE_SCORE_REQUEST)
    cmddata:pushbyte(GameServer_CMD.SUB_GR_TAKE_SCORE_REQUEST)
    cmddata:pushscore(lScore)
    cmddata:pushstring(md5(szPassword),yl.LEN_PASSWORD)
    cmddata:pushstring(GlobalUserItem.szDynamicPass,yl.LEN_PASSWORD)
    self:sendNetData(cmddata)
end

--银行消息
function GameLayer:onSocketInsureEvent( sub,dataBuffer )
    self:dismissPopWait()
    if sub == GameServer_CMD.SUB_GR_USER_INSURE_SUCCESS then
        local cmd_table = ExternalFun.read_netdata(GameServer_CMD.CMD_GR_S_UserInsureSuccess, dataBuffer)
        self.bank_success = cmd_table

        self._gameView:onBankSuccess()
    elseif sub == GameServer_CMD.SUB_GR_USER_INSURE_FAILURE then
        local cmd_table = ExternalFun.read_netdata(GameServer_CMD.CMD_GR_S_UserInsureFailure, dataBuffer)
        self.bank_fail = cmd_table

        self._gameView:onBankFailure()
    elseif sub == GameServer_CMD.SUB_GR_USER_INSURE_INFO then --银行资料
        local cmdtable = ExternalFun.read_netdata(GameServer_CMD.CMD_GR_S_UserInsureInfo, dataBuffer)
        dump(cmdtable, "cmdtable", 6)

        self._gameView:onGetBankInfo(cmdtable)
    else
        print("unknow gamemessage sub is ==>"..sub)
    end
end

--更新积分
function GameLayer:onGameMessageChangeUserScore( dataBuffer )
    local cmd_table = ExternalFun.read_netdata(Game_CMD.CMD_S_ChangeUserScore,dataBuffer)
	self._gameView:refreshScore(cmd_table)
end
---------------------------------------------------------
function GameLayer:getDataMgr()
	return self._dataModle
end

-- 重置框架
function GameLayer:OnResetGameEngine()
    -- self.m_bOnGame = false
    -- self._gameView.m_enApplyState = self._gameView._apply_state.kCancelState
    self._dataModle:removeAllUser()
    self._dataModle:initUserList(self:getUserList())
    -- self._gameView:refreshApplyList()
    -- self._gameView:refreshUserList()
    -- self._gameView:refreshApplyBtnState()
    self._gameView:cleanGameData()
end

function GameLayer:getUserList(  )
    return self._gameFrame._UserList
end

----------用户消息
--用户进入
function GameLayer:onEventUserEnter(wTableID, wChairID, useritem)
	--缓存用户
	print("用户进入===========================")
	self._dataModle:addUser(useritem)
	-- self._gameView:refreshUserList()
	-- self._gameView:onGetUserScore(useritem)
end

--用户状态
function GameLayer:onEventUserStatus(useritem, newstatus, oldstatus)
	print("用户状态============================")
	if newstatus == yl.US_FREE or newstatus == yl.US_NULL then
		self._dataModle:removeUser(useritem)
	else
		self._dataModle:updateUser(useritem)
	end
end

--用户分数
function GameLayer:onEventUserScore(useritem)
	self._dataModle:updateUser(useritem)

	self._gameView:onGetUserScore(useritem)
end

function GameLayer:sendNetData( cmddata )
    return self._gameFrame:sendSocketData(cmddata)
end



----继承函数
function GameLayer:onExit()
    print("------------------GameLayer:onExit-------------------")
	self:dismissPopWait()
	self:KillGameClock()
	GameLayer.super.onExit(self)
end

--退出桌子
function GameLayer:onExitTable()
    print("------------------GameLayer:onExitTable-------------------")
	local MeItem = self:GetMeUserItem()
	if MeItem and MeItem.cbUserStatus > yl.US_FREE then
		self:showPopWait()
		self:runAction(cc.Sequence:create(
			cc.DelayTime:create(2),
			cc.CallFunc:create(
				function ()
					self._gameFrame:StandUp(1)
				end
				),
			cc.DelayTime:create(10),
			cc.CallFunc:create(
				function ()
					self:onExitRoom()
				end
				)
			)
		)
		return
	end
     print("------------------GameLayer:iiiiiiiiiiiiiiiiiiiiiiii-------------------")
	self:onExitRoom()
end

--离开房间
function GameLayer:onExitRoom()
    print("------------------GameLayer:onExitRoom-------------------")
	self._gameFrame:onCloseSocket()
	self:KillGameClock()
	self._scene:onKeyBack()
end

return GameLayer