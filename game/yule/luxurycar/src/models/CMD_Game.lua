--
-- Author: Tang
-- Date: 2016-10-11 17:21:32

--豪车俱乐部
--
local ExternalFun = require(appdf.EXTERNAL_SRC .. "ExternalFun")
local cmd  = {}

--游戏版本
cmd.VERSION  			= appdf.VersionValue(6,7,0,1)
--游戏标识
cmd.KIND_ID				= 388
--游戏人数
cmd.GAME_PLAYER   		= 200
--房间名长度
cmd.SERVER_LEN			= 32

--状态定义
cmd.GS_GAME_FREE		= 0
cmd.GS_PLACE_JETTON     = 100   --下注状态
cmd.GS_GAME_END			= 101   --结束状态
cmd.GS_MOVECARD_END		= 102	--结束状态


--区域索引
cmd.ID_BENTLEY         	= 1		--宾利
cmd.ID_BMW				= 2		--宝马
cmd.ID_BENCHI			= 3		--奔驰
cmd.ID_PORSCHE			= 4		--保时捷
cmd.ID_FALALI			= 5		--法拉利	
cmd.ID_LUGU				= 6		--路虎
cmd.ID_MAIBAHE			= 7		--迈巴赫
cmd.ID_BUJIADI			= 8		--布加迪

cmd.AREA_MASERATI       = 0
cmd.AREA_FERRARI		= 1
cmd.AREA_LAMBORGHINI	= 2
cmd.AREA_PORSCHE		= 3
cmd.AREA_LANDROVER		= 4
cmd.AREA_BMW			= 5
cmd.AREA_JAGUAR			= 6
cmd.AREA_BENZ			= 7


cmd.AREA_COUNT		    = 8
cmd.AREA_ALL			= 8
cmd.JETTON_COUNT		= 7
cmd.ANIMAL_COUNT        = 16

cmd.RATE_TWO_PAIR		= 12

cmd.CLOCK_FREE			= 1
cmd.CLOCK_ADDGOLD		= 2
cmd.CLOCK_AWARD			= 3

cmd.RECORD_MAX			= 12

--记录信息
cmd.tagServerGameRecord = 
{
	{k = "cbCarIndex",t = "byte"}
}

------------------------------------------------------------------------------------------------
--服务器命令结构

cmd.SUB_S_GAME_FREE					=99										--游戏空闲
cmd.SUB_S_GAME_START				=100									--游戏开始
cmd.SUB_S_PLACE_JETTON				=101									--用户下注
cmd.SUB_S_GAME_END					=102									--游戏结束
cmd.SUB_S_APPLY_BANKER				=103									--申请庄家
cmd.SUB_S_CHANGE_BANKER				=104									--切换庄家
cmd.SUB_S_CHANGE_USER_SCORE			=105									--更新积分
cmd.SUB_S_SEND_RECORD				=106									--游戏记录
cmd.SUB_S_PLACE_JETTON_FAIL			=107									--下注失败
cmd.SUB_S_CANCEL_BANKER				=108									--取消申请
cmd.SUB_S_ADMIN_COMMDN				=110									--系统控制
cmd.SUB_S_WAIT_BANKER				=111									--等待上庄
cmd.SUB_S_ROBOT_BANKER          	=112                                	 --机器人
cmd.SUB_S_PEIZHI_USER			 	= 119									--配置玩家
cmd.SUB_S_DelPeizhi				 	= 120									--删除配置
cmd.SUB_S_UPALLLOSEWIN				= 121									--更新玩家输赢
cmd.SUB_S_BET_INFO				= 122								--下注信息
--失败结构
cmd.CMD_S_PlaceJettonFail	=
{
	{k="wPlaceUser",t="word"}, 			--下注玩家
	{k="cbJettonArea",t="byte"},			--下注区域
	{k="lPlaceScore",t="score"}			--当前下注						
};

--更新积分
cmd.CMD_S_ChangeUserScore	=
{

	{k="wChairID",t="word"},				--椅子号码
	{k="lScore",t="double"},				--玩家积分
	{k="wCurrentBankerChairID",t="word"},	--当前庄家
	{k="cbBankerTime",t="byte"},			--庄家局数
	{k="lCurrentBankerScore",t="double"}	--庄家分数		
};

--申请庄家
cmd.CMD_S_ApplyBanker =
{
	{k="wApplyUser",t="word"}		--申请玩家					
};

--取消申请
cmd.CMD_S_CancelBanker =
{
	{k="wCancelUser",t="word"}		--取消玩家					
};

--切换庄家
cmd.CMD_S_ChangeBanker = 
{	
	{k="wBankerUser",t="word"},		--当庄玩家
	{k="lBankerScore",t="double"}	--庄家金币				
};
--机器人配置
cmd.tagCustomAndroid = 
{
    --坐庄
    --是否做庄
    {k = "nEnableRobotBanker", t = "bool"},
    --坐庄次数
    {k = "lRobotBankerCountMin", t = "double"},
    --列表人数
    {k = "lRobotListMinCount", t = "double"},
    --列表人数
    {k = "lRobotListMaxCount", t = "double"},
    --最多申请个数
    {k = "lRobotApplyBanker", t = "double"},
    --空盘重申
    {k = "lRobotWaitBanker", t = "double"},
    
    --下注
    --下注筹码个数
    {k = "lRobotMinBetTime", t = "double"},
    --下注筹码个数
    {k = "lRobotMaxBetTime", t = "double"},
    --下注筹码金额
    {k = "lRobotMinJetton", t = "double"},
    --下注筹码金额
    {k = "lRobotMaxJetton", t = "double"},
    --下注机器人数
    {k = "lRobotBetMinCount", t = "double"},
    --下注机器人数
    {k = "lRobotBetMaxCount", t = "double"},
    --区域限制
    {k = "lRobotAreaLimit", t = "double"},
    
    --存取款
    --机器人取款条件，机器人的分数小于该值时执行取款
    {k = "lRobotGetCondition", t = "double"},
    --机器人存款条件
    {k = "lRobotSaveCondition", t = "double"},
    --取款最小值
    {k = "lRobotGetMin", t = "double"},
    --取款最大值
    {k = "lRobotGetMax", t = "double"},
    --存款百分比
    {k = "lRobotBankStoMul", t = "double"},
}
--游戏状态
cmd.CMD_S_StatusFree = 
{
	--全局信息
	{k="cbTimeLeave",t="byte"},		--剩余时间
	--玩家信息
	{k="lUserMaxScore",t="double"},	--玩家金币			
	--庄家信息
	{k="wBankerUser",t="word"},		--当前庄家
	{k="cbBankerTime",t="word"},	--庄家局数
	{k="lBankerWinScore",t="double"},--庄家成绩
	{k="lBankerScore",t="double"},	--庄家分数
	{k="bEnableSysBanker",t="bool"},--系统做庄
	--控制信息
	{k="lApplyBankerCondition",t="double"}, --申请条件
	{k="lAreaLimitScore",t="double"},	   --区域限制
		--作弊控制
    {k = "cbArea", t = "byte", l = {8}}, 
	{k = "cbControlTimes", t = "byte"},	
	{k = "bIsGameCheatUser", t = "bool"},
	{k="szGameRoomName",t="string",s=32},
	{k="szRoomTotalName",t="string",s=256},
	{k="nMultiple",t="int"},
    {k="lStorageStart",t="double"},	--库存	
    {k="CheckImage",t="int"},
    {k = "CustomAndroid", t = "table", d = cmd.tagCustomAndroid}  --机器人配置
};

--游戏状态
cmd.CMD_S_StatusPlay =
{
	--全局下注
	{k="lAllJettonScore",t="double",l={cmd.AREA_COUNT+1}}, 			--全体总注
	{k="lUserJettonScore",t="double",l={cmd.AREA_COUNT+1}},			--个人总注

	--玩家积分
	{k="lUserMaxScore",t="double"},									--最大下注
												
	--控制信息
	{k="lApplyBankerCondition",t="double"},							--申请条件
	{k="lAreaLimitScore",t="double"},								--区域限制
	
	{k="cbStopIndex",t="byte"},										--开奖位置
			
			
	--下注数 AREA_MAX						
    {k = "lAllBet", t = "double", l = {cmd.AREA_COUNT}},	--总下注		
    {k = "lPlayBet", t = "double", l = {cmd.AREA_COUNT}},	--玩家下注
	
	
	--庄家信息
	{k="wBankerUser",t="word"},										--当前庄家
	{k="cbBankerTime",t="word"},									--庄家局数
	{k="lBankerWinScore",t="double"},								--庄家赢分
	{k="lBankerScore",t="double"},									--庄家分数
	{k="bEnableSysBanker",t="bool"},								--系统做庄
	

	--结束信息
	{k="lEndBankerScore",t="double"},								--庄家成绩
	{k="lEndUserScore",t="double"},									--玩家成绩
	{k="lEndUserReturnScore",t="double"},							--返回积分
	{k="lEndRevenue",t="double"},									--游戏税收
	{k="lStorageStart",t="double"},											
	
	--全局信息
	{k="cbTimeLeave",t="byte"},										--剩余时间
	{k="cbGameStatus",t="byte"},										--游戏状态
    {k="CheckImage",t="int"},
		--作弊控制
    {k = "cbArea", t = "byte", l = {8}}, 
	{k = "cbControlTimes", t = "byte"},	
	{k = "bIsGameCheatUser", t = "bool"},
	{k="szGameRoomName",t="string",s=32},
	{k="szRoomTotalName",t="string",s=256},
	{k="nMultiple",t="int"},
    {k = "CustomAndroid", t = "table", d = cmd.tagCustomAndroid}  --机器人配置				
};

--游戏空闲
cmd.CMD_S_GameFree = 
{
	{k="cbTimeLeave",t="byte"},										--剩余时间
	{k="nListUserCount",t="double"},
    {k="lStorageStart",t="double"},
	{k = "cbControl", t = "byte"},	
};

--游戏开始
cmd.CMD_S_GameStart = 
{
	{k="wBankerUser",t="word"},										--庄家位置
	{k="lBankerScore",t="double"},									--庄家金币
	{k="lUserMaxScore",t="double"},										
	{k="cbTimeLeave",t="byte"},										--剩余时间	
	{k="bContiueCard",t="bool"},									--继续发牌
	{k="nChipRobotCount",t="int"},									--人数上限 (下注机器人)
	{k="nAndriodCount",t="int"}										--机器人人数
			
};

--用户下注
cmd.CMD_S_PlaceJetton = 
{

	{k="wChairID",t="word"},										--用户位置
	{k="cbJettonArea",t="byte"},									--筹码区域
	{k="lJettonScore",t="double"},									--加注数目
	{k="cbAndroid",t="byte"},										--机器人
	{k="bAndroid",t="bool"},									--机器人	
	{k = "lAreaAllJetton", t = "double"},				--区域总下注	
	{k = "lAllJetton", t = "double"},					--总下注					
};

--游戏结束
cmd.CMD_S_GameEnd = 
{
	--庄家信息
	{k="lStorageStart",t="double"},									
	--下局信息
	{k="cbTimeLeave",t="byte"},										--剩余时间				

	--停止位置
	{k="cbStopIndex",t="byte"},										--桌面扑克
    	--停止位置
	{k="cbLeftCardCount",t="byte"},										--桌面扑克
    {k="bcFirstCard",t="byte"},										--桌面扑克
	--庄家信息
	{k="lBankerScore",t="double"},									--庄家成绩
	{k="lBankerTotallScore",t="double"},								--庄家成绩
	{k="nBankerTime",t="int"},										--做庄次数
	--玩家成绩
	{k="lUserScore",t="double"},										--玩家成绩
	{k="lUserReturnScore",t="double"},								--返回积分				
    	
     {k="lUserScoreTotal",t="double",l = {cmd.GAME_PLAYER}},						--返回积分			
	--全局信息
	{k="lRevenue",t="double"},										--游戏税收
	{k="storageStart",t="double"}									--游戏税收			
};
cmd.CMD_S_UpAlllosewin = 
{
	{k = "dwGameID", t = "dword"},
	{k = "lTotalScore", t = "double"},						--总输赢分
	{k = "lTdTotalScore", t = "double"},						--今日输赢分
	{k = "lscore", t = "double"},					
}
--下注信息
cmd.CMD_S_StatusBetInfo = 
{
	{k = "lPlayerBet", t = "double", l = {cmd.AREA_COUNT}},		--真人每个区域总下注
	{k = "lAndroidBet", t = "double", l = {cmd.AREA_COUNT}},		--机器人每个区域总下注
	{k = "lPlayerAreaBet", t = "double", l = {cmd.AREA_COUNT}},	--真人每个人每个区域下注
	{k = "dwGameID", t = "dword"},								--玩家id
	{k = "lPlayerTotleBet", t = "double"},						--每个人总下注
}
cmd.CMD_S_peizhiVec = 
{
    {k = "dwGameID", t = "dword"},
	{k = "lscore", t = "double"},						
}
cmd.CMD_S_DelPeizhi =
{
	{k = "dwGameID", t = "dword"},
};
---------------------------------------------------------------------------------------------------------------
--客户端命令结构

cmd.SUB_C_PLACE_JETTON				=1									--用户下注
cmd.SUB_C_APPLY_BANKER				=2									--申请庄家
cmd.SUB_C_CANCEL_BANKER				=3									--取消申请
cmd.SUB_C_CLEAR_JETTON		    	=4									--清除下注
--管理员命令
cmd.SUB_C_AMDIN_COMMAND				= 6
cmd.SUB_C_PEIZHI_USER				= 10								--配置玩家               
cmd.SUB_C_DelPeizhi			    	= 11								--散删除配置
cmd.SUB_C_ANDROIDXIAZHUANG	    	= 12								--机器人下庄    
--用户下注
cmd.CMD_C_PlaceJetton = 
{
	{k="cbJettonArea",t="byte"}, 		--筹码区域
	{k="lJettonScore",t="double"},		--加注数目	
};
cmd.CMD_C_peizhiVec=
{
	 {k = "dwGameID", t = "dword"},
}
cmd.CMD_C_DelPeizhi=
{
	  {k = "dwGameID", t = "dword"},
};
cmd.C_CA_UPDATE	= 1
cmd.C_CA_SET=	2
cmd.C_CA_CANCELS	=	3
cmd.CMD_C_AdminReq = 
{
	{k = "cbReqType", t = "byte"},	
	{k = "cbControlArea", t = "byte"},			 --附加数据		
	{k = "cbControlTimes", t = "byte"},			--控制次数
}
------------------------------------------------------------------------------------------------------------------
--按钮类型
cmd.Apply 		= 1		--申请
cmd.Jettons 	= 2		--下注
cmd.Continue 	= 3		--续压

------------------------------------------------------------------------------------------------------------------



return cmd