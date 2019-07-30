local cmd = {}

--[[
******
* 结构体描述
* {k = "key", t = "type", s = len, l = {}}
* k 表示字段名,对应C++结构体变量名
* t 表示字段类型,对应C++结构体变量类型
* s 针对string变量特有,描述长度
* l 针对数组特有,描述数组长度,以table形式,一维数组表示为{N},N表示数组长度,多维数组表示为{N,N},N表示数组长度
* d 针对table类型,即该字段为一个table类型
* ptr 针对数组,此时s必须为实际长度

** egg
* 取数据的时候,针对一维数组,假如有字段描述为 {k = "a", t = "byte", l = {3}}
* 则表示为 变量a为一个byte型数组,长度为3
* 取第一个值的方式为 a[1][1],第二个值a[1][2],依此类推

* 取数据的时候,针对二维数组,假如有字段描述为 {k = "a", t = "byte", l = {3,3}}
* 则表示为 变量a为一个byte型二维数组,长度都为3
* 则取第一个数组的第一个数据的方式为 a[1][1], 取第二个数组的第一个数据的方式为 a[2][1]
******
]]

cmd.RES_PATH 						= "game/yule/redninebattle/res/"

--游戏版本
cmd.VERSION 					= appdf.VersionValue(6,7,0,1)
--游戏标识
cmd.KIND_ID						= 109
	 
--游戏人数
cmd.GAME_PLAYER					= 100

--房间名长度
cmd.SERVER_LEN					= 32

--游戏记录长度
cmd.RECORD_LEN					= 3

--开牌记录长度
cmd.CARDRECORD_LEN					= 8

--占座索引
cmd.SEAT_LEFT1_INDEX            = 0                                 --左一
cmd.SEAT_LEFT2_INDEX            = 1                                 --左二
cmd.SEAT_LEFT3_INDEX            = 2                                 --左三
cmd.SEAT_RIGHT1_INDEX           = 3                                 --右一
cmd.SEAT_RIGHT2_INDEX           = 4                                 --右二
cmd.SEAT_RIGHT3_INDEX           = 5                                 --右三
cmd.MAX_OCCUPY_SEAT_COUNT       = 4                                 --最大占位个数
cmd.SEAT_INVALID_INDEX          = 7                                 --无效索引

--空闲状态
cmd.GAME_SCENE_FREE				= 0
--下注状态
cmd.GAME_SCENE_JETTON			= 100
--游戏结束
cmd.GAME_SCENE_END				= 101



--区域索引
cmd.ID_SHUN_MEN					= 1									--顺门
cmd.ID_JIAO_L					= 2									--左边角
cmd.ID_QIAO						= 3									--桥
cmd.ID_DUI_MEN					= 4									--对门
cmd.ID_DAO_MEN					= 5									--倒门
cmd.ID_JIAO_R					= 6									--右边角

--玩家索引
cmd.HJ_BANKER_INDEX             = 0                                 --庄家索引
cmd.HJ_SHUN_MEN_INDEX			= 1									--顺门索引
cmd.HJ_DUI_MEN_INDEX			= 2									--对门索引
cmd.HJ_DAO_MEN_INDEX			= 3									--倒门索引
cmd.HJ_MAX_INDEX				= 3									--最大索引

cmd.AREA_COUNT					= 6									--区域数目
cmd.CONTROL_AREA				= 3                                 --受控区域

cmd.HJ_MAX_CARD					= 2									--最大牌数
cmd.HJ_MAX_CARDGROUP			= 4									--牌组数量

--服务器命令结构
cmd.SUB_S_GAME_FREE				= 99								--游戏空闲
cmd.SUB_S_GAME_START			= 100								--游戏开始							
cmd.SUB_S_PLACE_JETTON			= 101								--用户下注	
cmd.SUB_S_GAME_END				= 102								--游戏结束	
cmd.SUB_S_APPLY_BANKER			= 103								--申请庄家	
cmd.SUB_S_CHANGE_BANKER			= 104								--切换庄家
cmd.SUB_S_CHANGE_USER_SCORE		= 105								--更新积分			
cmd.SUB_S_SEND_RECORD			= 106								--游戏记录
cmd.SUB_S_PLACE_JETTON_FAIL		= 107								--下注失败
cmd.SUB_S_CANCEL_BANKER			= 108								--取消申请
cmd.SUB_S_CHEAT					= 109								--作弊信息

cmd.SUB_S_AMDIN_COMMAND     	= 110                 				--管理员命令-Ma
cmd.SUB_S_UPDATE_STORAGE     	= 111                 				--更新库存-Ma
cmd.SUB_S_SEND_USER_BET_INFO    = 112								--发送下注

cmd.SUB_S_ADVANCE_OPENCARD		= 113								--提前开牌-Ma
cmd.SUB_S_SUPERROB_BANKER		= 114								--超级抢庄-Ma
cmd.SUB_S_CURSUPERROB_LEAVE		= 115								--超级抢庄玩家离开-Ma

cmd.SUB_S_OCCUPYSEAT            = 116								--占位
cmd.SUB_S_OCCUPYSEAT_FAIL       = 117								--占位失败
cmd.SUB_S_UPDATE_OCCUPYSEAT     = 118								--更新占位
cmd.SUB_S_PEIZHI_USER			= 119								--配置玩家-Ma
cmd.SUB_S_DelPeizhi				= 120								--删除配置-Ma
cmd.SUB_S_UPALLLOSEWIN			= 121								--更新玩家输赢-Ma
cmd.SUB_S_SEND_CARDRECORD		= 122								--开牌记录-Ma

--超级抢庄配置

--超级抢庄
cmd.SUPERBANKER_VIPTYPE = 0;
cmd.SUPERBANKER_CONSUMETYPE = 1;

--会员
cmd.VIP1_INDEX = 1;
cmd.VIP2_INDEX = 2;
cmd.VIP3_INDEX = 3;
cmd.VIP4_INDEX = 4;
cmd.VIP5_INDEX = 5;
cmd.VIP_INVALID = 6;

--机器人配置-Ma
cmd.tagCustomAndroid = 
{
    --坐庄
    --是否做庄
    {k = "nEnableRobotBanker", t = "bool"},
    --坐庄次数
    {k = "lRobotBankerCountMin", t = "score"},
    --坐庄次数
    {k = "lRobotBankerCountMax", t = "score"},
    --列表人数
    {k = "lRobotListMinCount", t = "score"},
    --列表人数
    {k = "lRobotListMaxCount", t = "score"},
    --最多申请个数
    {k = "lRobotApplyBanker", t = "score"},
    --空盘重申
    {k = "lRobotWaitBanker", t = "score"},
    
    --下注
    --下注筹码个数
    {k = "lRobotMinBetTime", t = "score"},
    --下注筹码个数
    {k = "lRobotMaxBetTime", t = "score"},
    --下注筹码金额
    {k = "lRobotMinJetton", t = "double"},
    --下注筹码金额
    {k = "lRobotMaxJetton", t = "double"},
    --下注机器人数
    {k = "lRobotBetMinCount", t = "score"},
    --下注机器人数
    {k = "lRobotBetMaxCount", t = "score"},
    --区域限制
    {k = "lRobotAreaLimit", t = "double"},
    
    --存取款
    --金币下限
    {k = "lRobotScoreMin", t = "double"},
    --金币上限
    {k = "lRobotScoreMax", t = "double"},
    --取款最小值(非庄)
    {k = "lRobotBankGetMin", t = "double"},
    --取款最大值(非庄)
    {k = "lRobotBankGetMax", t = "double"},
    --取款最小值(坐庄)
    {k = "lRobotBankGetBankerMin", t = "double"},
    --取款最大值(坐庄)
    {k = "lRobotBankGetBankerMax", t = "double"},
    --存款百分比
    {k = "lRobotBankStoMul", t = "score"},
    
--    --区域几率
--    {k = "nAreaChance", t = "int", l = {cmd.AREA_MAX}},
}

--配置结构
cmd.SUPERBANKERCONFIG = 
{
    --抢庄类型
    {k = "superbankerType", t = "int"},
    --vip索引
    {k = "enVipIndex", t = "int"},
    --抢庄消耗
    {k = "lSuperBankerConsume", t = "double"},
}

--当前庄家类型
cmd.ORDINARY_BANKER = 0;    --普通玩家
cmd.SUPERROB_BANKER = 1;    --超级抢庄玩家
cmd.INVALID_SYSBANKER = 2;  --无效类型(系统庄家)
------

------
--占位配置
cmd.OCCUPYSEAT_VIPTYPE = 0          --会员占位
cmd.OCCUPYSEAT_CONSUMETYPE = 1      --消耗游戏币占位
cmd.OCCUPYSEAT_FREETYPE = 2         --免费占位

--记录信息
cmd.tagServerGameRecord = 
{	
	{k = "bWinShunMen", t = "bool"},		--顺门胜利
	{k = "bWinDuiMen", t = "bool"},			--对门胜利
	{k = "bWinDaoMen", t = "bool"},			--倒门胜利
}

--记录开牌信息
cmd.tagServerCardRecord = 
{	
	{k = "m_card1", t = "byte"},				--牌值1
	{k = "m_card2", t = "byte"},				--牌值2
	{k = "m_card3", t = "byte"},				--牌值3
	{k = "m_card4", t = "byte"},				--牌值4
	{k = "m_card5", t = "byte"},				--牌值5
	{k = "m_card6", t = "byte"},				--牌值6
	{k = "m_card7", t = "byte"},				--牌值7
	{k = "m_card8", t = "byte"},				--牌值8
}

--占位配置结构
cmd.OCCUPYSEATCONFIG = 
{
    --占位类型
    {k = "occupyseatType", t = "int"},
    --vip索引
    {k = "enVipIndex", t = "int"},
    --占位消耗
    {k = "lOccupySeatConsume", t = "double"},
    --免费占位游戏币上限
    {k = "lOccupySeatFree", t = "double"},
    --强制站立条件
    {k = "lForceStandUpCondition", t = "double"},
}

--超级抢庄
cmd.CMD_S_SuperRobBanker = 
{
    {k = "bSucceed", t = "bool"},
    {k = "wApplySuperRobUser", t = "word"},     		--申请玩家
    {k = "wCurSuperRobBankerUser", t = "word"},			--当前玩家
}

--超级抢庄玩家离开
cmd.CMD_S_CurSuperRobLeave = 
{
    {k = "wCurSuperRobBankerUser", t = "word"},
}

--下注失败
cmd.CMD_S_PlaceJettonFail =
{
	{k = "wPlaceUser", t = "word"},						--下注玩家
	{k = "lJettonArea", t = "byte"},					--下注区域
	{k = "lPlaceScore", t = "score"},					--当前下注
}

--更新积分
cmd.CMD_S_ChangeUserScore =
{
	{k = "wChairID", t = "word"},						--椅子号码
	{k = "lScore", t = "double"},						--玩家积分
	{k = "wCurrentBankerChairID", t = "word"},			--当前庄家
	{k = "cbBankerTime", t = "byte"},					--庄家局数
	{k = "lCurrentBankerScore", t = "double"},			--庄家分数
}

--申请庄家
cmd.CMD_S_ApplyBanker =
{
	{k = "wApplyUser", t = "word"},						--申请玩家
}

--取消申请
cmd.CMD_S_CancelBanker =
{
	{k = "wCancelUser", t = "word"},					--取消玩家
}

--切换庄家
cmd.CMD_S_ChangeBanker =
{
	{k = "wBankerUser", t = "word"},					--当庄玩家
	{k = "lBankerScore", t = "double"},					--庄家游戏币
}

--游戏状态
cmd.CMD_S_StatusFree =
{
	--全局信息
	{k = "cbTimeLeave", t = "byte"},								--剩余时间

	--玩家信息
	{k = "lUserMaxScore", t = "double"},								--玩家游戏币

	--庄家信息
	{k = "wBankerUser", t = "word"},								--当前庄家
	{k = "cbBankerTime", t = "word"},								--庄家局数
	{k = "lBankerWinScore", t = "double"},							--庄家成绩
	{k = "lBankerScore", t = "double"},								--庄家分数
	{k = "nEndGameMul", t = "int"},									--提前开牌百分比
	{k = "bEnableSysbanker", t = "bool"},							--系统坐庄
    {k = "cbCardRecordCount", t = "word"},						    --开牌轮数
	
	--控制信息
	{k = "lApplyBankerCondition", t = "double"},						--申请条件	
	{k = "lAreaLimitScore", t = "double"},							--区域限制
	
	--作弊控制--MXM
    {k = "cbArea", t = "byte", l = {6}}, 
	{k = "cbControlTimes", t = "byte"},	
	{k = "bIsGameCheatUser", t = "bool"},							--控制权限
	
	--房间信息
	{k = "szGameRoomName", t = "string", s = cmd.SERVER_LEN},		--房间名称
	{k = "bGenreEducate", t = "bool"},								--练习模式
	--抢庄配置
    {k = "superbankerConfig", t = "table", d = cmd.SUPERBANKERCONFIG}, 
    {k = "wCurSuperRobBankerUser", t = "word"},
    --庄家类型
    {k = "typeCurrentBanker", t = "int"},

    --占位配置
    {k = "occupyseatConfig", t = "table", d = cmd.OCCUPYSEATCONFIG},
    --占位椅子id MAX_OCCUPY_SEAT_COUNT
    {k = "wOccupySeatChairID", t = "word", l = {cmd.MAX_OCCUPY_SEAT_COUNT}},
	{k = "lBottomPourImpose", t = "double"},							--下注限制-Ma
	{k = "CustomAndroid", t = "table", d = cmd.tagCustomAndroid},  --机器人配置-Ma
}

--游戏状态
cmd.CMD_S_StatusPlay =
{
	--全局下注
	{k = "lAllJettonScore", t = "double", l = {cmd.AREA_COUNT+1}},	--全体总注
	--玩家下注
	{k = "lUserJettonScore", t = "double", l = {cmd.AREA_COUNT+1}},	--个人总注

	--玩家积分
	{k = "lUserMaxScore", t = "double"},								--最大下注

	--控制信息
	{k = "lApplyBankerCondition", t = "double"},						--申请条件	
	{k = "lAreaLimitScore", t = "double"},							--区域限制
    
	--作弊控制
    {k = "cbArea", t = "byte", l = {6}}, 
	{k = "cbControlTimes", t = "byte"},	
	{k = "bIsGameCheatUser", t = "bool"},
	
	--扑克信息
	{k = "cbTableCardArray", t = "byte", l = {2, 2, 2, 2}},				--桌面扑克

	--庄家信息
	{k = "wBankerUser", t = "word"},								--当前庄家
	{k = "cbBankerTime", t = "word"},								--庄家局数
	{k = "lBankerWinScore", t = "double"},							--庄家成绩
	{k = "lBankerScore", t = "double"},								--庄家分数
	{k = "nEndGameMul", t = "int"},									--提前开牌百分比
	{k = "bEnableSysbanker", t = "bool"},							--系统坐庄
    {k = "cbCardRecordCount", t = "word"},							--开牌轮数
	
	--结束信息
	{k = "lEndBankerScore", t = "double"},							--庄家成绩
	{k = "lEndUserScore", t = "double"},								--玩家成绩
	{k = "lEndUserReturnScore", t = "double"},						--返回积分
	{k = "lEndRevenue", t = "double"},								--游戏税收

	--全局信息
	{k = "cbTimeLeave", t = "byte"},								--剩余时间
	{k = "cbGameStatus", t = "byte"},								--游戏状态

	--房间信息
	{k = "szGameRoomName", t = "string", s = cmd.SERVER_LEN},		--房间名称
	{k = "bGenreEducate", t = "bool"},								--练习模式
	--抢庄配置
    {k = "superbankerConfig", t = "table", d = cmd.SUPERBANKERCONFIG}, 
    {k = "wCurSuperRobBankerUser", t = "word"},
    --庄家类型
    {k = "typeCurrentBanker", t = "int"},

    --占位配置
    {k = "occupyseatConfig", t = "table", d = cmd.OCCUPYSEATCONFIG},
    --占位椅子id MAX_OCCUPY_SEAT_COUNT
    {k = "wOccupySeatChairID", t = "word", l = {cmd.MAX_OCCUPY_SEAT_COUNT}},
    --占位玩家成绩
    {k = "lOccupySeatUserWinScore", t = "double", l = {cmd.MAX_OCCUPY_SEAT_COUNT}},
	{k = "lBottomPourImpose", t = "double"},							--下注限制-Ma
	{k = "CustomAndroid", t = "table", d = cmd.tagCustomAndroid},  --机器人配置-Ma
}

--游戏空闲
cmd.CMD_S_GameFree =
{
	{k = "cbTimeLeave", t = "byte"},								--剩余时间
	{k = "wBankerUser", t = "word"},								--当前庄家
	{k = "cbBankerTime", t = "int"},								--做庄次数
	{k = "nListUserCount", t = "score"},							--列表人数
	{k = "lStorageStart", t = "double"},							--库存数值
	{k = "nCardRecordCount", t = "int"},							--开牌轮数
	{k = "cbControl", t = "byte"},									--控制是否还有效
}

--游戏开始
cmd.CMD_S_GameStart =
{
	{k = "wBankerUser", t = "word"},								--庄家位置
	{k = "lBankerScore", t = "double"},								--庄家游戏币
	{k = "lUserMaxScore", t = "double"},								--我的游戏币
	{k = "cbTimeLeave", t = "byte"},								--剩余时间
	{k = "bContinueCard", t = "bool"},								--继续发牌
	{k = "nChipRobotCount", t = "int"},								--人数上限(下注机器人)
	{k = "nAndroidApplyCount", t = "int"},							--机器人列表人数
	{k = "lBottomPourImpose", t = "double"},							--下注限制
}

--用户下注
cmd.CMD_S_PlaceJetton =
{
	{k = "wChairID", t = "word"},						--用户位置
	{k = "cbJettonArea", t = "byte"},					--筹码区域
	{k = "lJettonScore", t = "double"},					--加注数目	
	{k = "bIsAndroid", t = "bool"},						--是否机器人
	{k = "bAndroid", t = "bool"},						--机器标识	
	{k = "lAreaAllJetton", t = "double"},				--区域总下注	
	{k = "lAllJetton", t = "double"},					--总下注
}

--游戏结束
cmd.CMD_S_GameEnd =
{
	--下局信息
	{k = "cbTimeLeave", t = "byte"},						--剩余时间
	--扑克信息
	{k = "cbTableCardArray", t = "byte", l = {2, 2, 2, 2}},	--桌面扑克	
	{k = "cbLeftCardCount", t = "byte"},					--扑克数目
	{k = "bcFirstCard", t = "byte"},
	{k = "bcNextCard", t = "byte"},
	
	--庄家信息
	{k = "wBankerUser", t = "word"},					--当前庄家
	{k = "lBankerScore", t = "double"},					--庄家成绩
	{k = "lBankerTotallScore", t = "double"},			--庄家总成绩
	{k = "nBankerTime", t = "int"},						--坐庄次数
    {k = "nCardRecordCount", t = "int"},				--开牌轮数
	
	--玩家成绩
	{k = "lUserScore", t = "double"},					--玩家成绩
	{k = "lUserReturnScore", t = "double"},				--返回积分

	--全局信息
	{k = "lRevenue", t = "double"},						--游戏税收

	--占位玩家成绩
    {k = "lOccupySeatUserWinScore", t = "double", l = {cmd.MAX_OCCUPY_SEAT_COUNT}},
}

--游戏作弊
cmd.CMD_S_Cheat = 
{
	{k = "cbTableCardArray", t = "byte", l = {2, 2, 2, 2}},	--桌面扑克	
}

--占位
cmd.CMD_S_OccupySeat = 
{
    --申请占位玩家id
    {k = "wOccupySeatChairID", t = "word"},
    --占位索引
    {k = "cbOccupySeatIndex", t = "byte"},
    --占位椅子id
    {k = "tabWOccupySeatChairID", t = "word", l = {cmd.MAX_OCCUPY_SEAT_COUNT}},
}

--占位失败
cmd.CMD_S_OccupySeat_Fail = 
{
    --已申请占位玩家ID
    {k = "wAlreadyOccupySeatChairID", t = "word"},
    --已占位索引
    {k = "cbAlreadyOccupySeatIndex", t = "byte"},
    --占位椅子id
    {k = "tabWOccupySeatChairID", t = "word", l = {cmd.MAX_OCCUPY_SEAT_COUNT}},
}

--更新占位
cmd.CMD_S_UpdateOccupySeat = 
{
    --占位椅子id
    {k = "tabWOccupySeatChairID", t = "word", l = {cmd.MAX_OCCUPY_SEAT_COUNT}},
    --申请退出占位玩家
    {k = "wQuitOccupySeatChairID", t = "word"},
}

cmd.CMD_S_peizhiVec = 
{	
	{k = "szNickName", t = "string", s = cmd.SERVER_LEN},					--玩家昵称
    {k = "dwGameID", t = "dword"},
	{k = "lscore", t = "double"},						
}
cmd.CMD_S_DelPeizhi =
{
	{k = "dwGameID", t = "dword"},
};

cmd.CMD_S_UpAlllosewin = 
{
	{k = "dwGameID", t = "dword"},
	{k = "lTotalScore", t = "double"},						--总输赢分
	{k = "lTdTotalScore", t = "double"},						--今日输赢分
	{k = "lscore", t = "double"},							--玩家金币
}

cmd.ACK_SET_WIN_AREA   	= 1
cmd.ACK_PRINT_SYN     	= 2
cmd.ACK_RESET_CONTROL 	= 3

cmd.CR_ACCEPT  			= 2      --接受
cmd.CR_REFUSAL 			= 3      --拒绝

cmd.CMD_S_CommandResult = 
{
	{k = "cbAckType", t = "byte"},
	{k = "cbResult", t = "byte"},  
	{k = "cbExtendData", t = "byte", l = {20}},			 --附加数据		
}

------客户端命令结构----
cmd.SUB_C_PLACE_JETTON			= 1						--用户下注
cmd.SUB_C_APPLY_BANKER			= 2						--申请庄家
cmd.SUB_C_CANCEL_BANKER			= 3						--取消申请
cmd.SUB_C_CONTINUE_CARD			= 4						--继续发牌
cmd.SUB_C_AMDIN_COMMAND     	= 5                 	--管理员命令
cmd.SUB_C_UPDATE_STORAGE        = 6                 	--更新库存

cmd.SUB_C_SUPERROB_BANKER		= 7						--超级抢庄
cmd.SUB_C_OCCUPYSEAT			= 8						--占位
cmd.SUB_C_QUIT_OCCUPYSEAT		= 9						--退出占位
cmd.SUB_C_PEIZHI_USER			= 10					--配置玩家-Ma
cmd.SUB_C_DelPeizhi			    = 11					--散删除配置-Ma
cmd.SUB_C_ANDROIDXIAZHUANG	    = 12					--机器人下庄-Ma

--下注
cmd.CMD_C_PlaceJetton = 
{
	{k = "cbJettonArea", t = "byte"},					--筹码区域
	{k = "lJettonScore", t = "double"},					--加注数目
}

--占位
cmd.CMD_C_OccupySeat = 
{
    --占位玩家
    {k = "wOccupySeatChairID", t = "word"},
    --占位索引
    {k = "cbOccupySeatIndex", t = "byte"},
}

cmd.CS_BANKER_LOSE = 1
cmd.CS_BANKER_WIN = 2
cmd.CS_BET_AREA = 3

cmd.tagAdminReq = 
{
	{k = "cbExcuteTimes", t = "byte"},						--执行次数
	{k = "cbControlStyle", t = "byte"},						--控制方式
	{k = "bWinArea", t = "byte", l = {3}},
}

cmd.RQ_SET_WIN_AREA	= 1
cmd.RQ_RESET_CONTROL=	2
cmd.RQ_PRINT_SYN	=	3

cmd.CMD_C_AdminReq = 
{
	{k = "cbReqType", t = "byte"},	
    --{k = "cbExtendData", t = "byte", l = {20}},		 --附加数据
	{k = "AdminReq", t = "table", d = cmd.tagAdminReq},  
	{k = "cbExtendData", t = "byte", l = {15}},			 --附加数据		
}
cmd.CMD_C_peizhiVec=
{
	 {k = "dwGameID", t = "dword"},
}
cmd.CMD_C_DelPeizhi=
{
	  {k = "dwGameID", t = "dword"},
};
---GameDefine

--申请列表
function cmd.getEmptyApplyInfo(  )
    return
    {
        --用户信息
        m_userItem = {},
        --是否当前庄家
        m_bCurrent = false,
        --编号
        m_llIdx = 0,
        --是否超级抢庄
        m_bRob = false
    }
end

--获取空路单记录
function cmd.getEmptyGameRecord()
	return
	{
		bWinShunMen = false,		--顺门胜利
		bWinDuiMen = false,			--对门胜利
		bWinDaoMen = false			--倒门胜利
	}
end

--开牌记录列表
function cmd.getEmptyCardRecord()
    return
    {
        --开牌信息
		--牌1
		m_card1 = 0,
		--牌2
		m_card2 = 0,
		--牌3
		m_card3 = 0,
		--牌4
		m_card4 = 0,
		--牌5
		m_card5 = 0,
		--牌6
		m_card6 = 0,
		--牌7
		m_card7 = 0,
		--牌8
		m_card8 = 0
    }
end

return cmd 