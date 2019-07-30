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
--游戏版本
cmd.VERSION =  appdf.VersionValue(7,0,1)
--游戏标识
cmd.KIND_ID = 143
--游戏人数
cmd.GAME_PLAYER = 200
--游戏名字
cmd.GAME_NAME = "百人推筒子"

--房间名长度
cmd.SERVER_LEN      = 32
--游戏记录长度
cmd.RECORD_LEN  = 4

cmd.GAME_STATUS_PLAY = 100
--游戏状态定义
cmd.GS_SCENE_FREE   = 0                                 --空闲状态
cmd.GS_PLACE_JETTON = cmd.GAME_STATUS_PLAY 				--下注状态
cmd.GS_GAME_END 	= cmd.GAME_STATUS_PLAY+1 			--结束状态

--区域索引
cmd.ID_TIAN_MEN     = 1								    --天门
cmd.ID_ZHONG_MEN    = 2 								--中门
cmd.ID_DI_MEN       = 3 								--地门


--玩家索引
cmd.BANKER_INDEX 	 = 0 								--庄家索引
cmd.TIAN_MEN_INDEX   = 1 								--天门索引
cmd.ZHONG_MEN_INDEX  = 2 								--中门索引
cmd.DI_MEN_INDEX     = 3 								--地门索引
cmd.MAX_INDEX 		 = 3 								--最大索引

--knight
--cmd.AREA_COUNT      = 3 								--区域数目
cmd.AREA_COUNT      = 6 								--区域数目
cmd.MAX_CARD 		= 2 
cmd.MAX_CARDGROUP   = 4 
cmd.CONTROL_AREA    = 3 								--受控区域

--赔率
cmd.RATE_TWO_PAIR 	= 4 								--对子
cmd.RATE_TWO_EIGHT  = 3 								--2+8
cmd.RATE_POINT 		= 2 								--8点或者9点
cmd.RATE_NULL 		= 1 								--普通牌型

--记录信息
cmd.tagServerGameRecord = {
	{k = "bPointBanker", t = "byte"},						    --庄家点数
	{k = "bPointTianMen", t = "byte"},						    --天门点数
	{k = "bPointZhongMen", t = "byte"},						    --中门点数
	{k = "bPointDiMen", t = "byte"},							--地门点数
}

cmd.MAX_PATH = 260

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
cmd.SUB_S_CANCEL_CAN            = 109                               --取消申请 
cmd.SUB_S_SELECT_CARD_MODE      = 110                               --发牌模式
cmd.SUB_S_RE_DISPATCH_CARD      = 111                               --重新发牌
cmd.SUB_S_CATCH_BANKER          = 112                               --玩家抢庄
cmd.SUB_S_AMDIN_COMMAND		    = 113								--管理员命令
cmd.SUB_S_UPDATE_STORAGE		= 114								--更新库存
cmd.SUB_S_ADMIN_STORAGE_INFO	= 115								--库存管理
cmd.SUB_S_SCORE_INFO            = 116								--积分事件

--控制服务端信息
cmd.CMD_S_ADMIN_STORAGE_INFO =
{
	{k = "lCurrentStorage", t = "score"},						    --当前库存
	{k = "lCurrentDeduct", t = "score"},						    --当前衰减
	{k = "lMaxStorage", t = "score", l = {2}},						--库存上限
	{k = "nStorageMul", t = "dword", l = {2}},						--系统输分概率
	{k = "lUserTotalScore", t = "score", l = {cmd.GAME_PLAYER}},	--玩家总输赢
}

cmd.CMD_C_FreshStorage =
{
	{k = "lStorageStart", t = "score"},						     	--库存数值
	{k = "lStorageDudect", t = "dword"},						    --库存衰减
}

--请求回复
cmd.CMD_S_CommandResult =
{	
		{k = "cbAckType", t = "byte"},						     	--回复类型
	ACK_SET_WIN_AREA = 1,
	ACK_PRINT_SYN    = 2,
	ACK_RESET_CONTROL = 3,
		{k = "cbResult", t = "byte"},						    
	CR_ACCEPT = 2,                        							--接受
	CR_REFUSAL  = 3,                     							--拒绝
		{k = "cbExtendData", t = "byte", l = {20}},					--附加数据
}

cmd.tagCustomAndroid =
{
	--坐庄
	{k = "nEnableRobotBanker", t = "bool"},						    --是否坐庄
	{k = "lRobotBankerCountMin", t = "score"},						--坐庄次数
	{k = "lRobotBankerCountMax", t = "score"},						--坐庄次数
	{k = "lRobotListMinCount", t = "score"},						--列表人数
	{k = "lRobotListMaxCount", t = "score"},						--列表人数
	{k = "lRobotApplyBanker", t = "score"},							--最多申请个数
	{k = "lRobotWaitBanker", t = "score"},							--空盘重申

	--下注
	{k = "lRobotMinBetTime", t = "score"},						    --下注筹码个数
	{k = "lRobotMaxBetTime", t = "score"},						    --下注筹码个数
	{k = "lRobotMinJetton", t = "score"},							--下注筹码金额
	{k = "lRobotMaxJetton", t = "score"},							--下注筹码金额
	{k = "lRobotBetMinCount", t = "score"},							--下注机器人数
	{k = "lRobotBetMaxCount", t = "score"},							--下注机器人数
	{k = "lRobotAreaLimit", t = "score"},							--区域限制

	--存取款
	{k = "lRobotScoreMin", t = "score"},						    --金币下限
	{k = "lRobotScoreMax", t = "score"},						    --金币上限
	{k = "lRobotBankGetMin", t = "score"},							--取款最小值(非庄)
	{k = "lRobotBankGetMax", t = "score"},							--取款最大值(非庄)
	{k = "lRobotBankGetBankerMin", t = "score"},					--取款最小值(坐庄)
	{k = "lRobotBankGetBankerMax", t = "score"},					--取款最大值(坐庄)
	{k = "lRobotBankStoMul", t = "score"},							--存款百分比
}

--机器人信息
cmd.tagRobotInfo =
{
	{k = "nChip", t = "dword", l = {7}},						    --筹码定义
	{k = "nAreaChance", t = "dword", l = {cmd.AREA_COUNT}},			--区域几率
	{k = "szCfgFileName", t = "word", l = {cmd.MAX_PATH}},			--配置文件
	{k = "nMaxTime", t = "dword"},									--最大赔率
}

--失败结构
cmd.CMD_S_PlaceJettonFail =
{
	{k = "wPlaceUser", t = "word"},						     		--下注玩家
	{k = "lJettonArea", t = "byte"},						    	--下注区域
	{k = "lPlaceScore", t = "score"},								--当前下注
}

--更新积分
cmd.CMD_S_ChangeUserScore =
{
	{k = "wChairID", t = "word"},						    		--椅子号码
	--{k = "lScore", t = "score"},						    		--玩家积分
    {k = "lScore", t = "double"},						    		--玩家积分
	--庄家信息
	{k = "wCurrentBankerChairID", t = "word"},						--当前庄家
	{k = "cbBankerTime", t = "byte"},								--庄家局数
	--{k = "lCurrentBankerScore", t = "score"},						--庄家分数
    {k = "lCurrentBankerScore", t = "double"},						--庄家分数
}

--申请庄家
cmd.CMD_S_ApplyBanker =
{
	{k = "wApplyUser", t = "word"},						     		--申请玩家
	--{k = "bAndroid", t = "bool"},						     		--是否机器人
}

--取消申请
cmd.CMD_S_CancelBanker =
{
	{k = "wCancelUser", t = "word"},						     	--取消玩家
	--{k = "bAndroid", t = "bool"},						    		--是否机器人
}

--切换庄家
cmd.CMD_S_ChangeBanker =
{
	{k = "wBankerUser", t = "word"},						     	--当庄玩家
	{k = "lBankerScore", t = "score"},						     	--庄家金币
	--{k = "bAndroid", t = "bool"},						    		--是否机器人
}

cmd.CMD_S_CatchBanker =
{
	{k = "wCatchUser", t = "word"},		 							--	抢庄玩家			 
}

--是否成功取消申请
cmd.CMD_S_bCanCancelBanker =
{
	{k = "wChariID", t = "word"},						 
	{k = "blCancel", t = "bool"},						   
}

--游戏状态
cmd.CMD_S_StatusFree =
{
	--全局信息
	{k = "cbTimeLeave", t = "byte"},						        --剩余时间
	--玩家信息
	{k = "lUserMaxScore", t = "score"},						     	--玩家金币
	--庄家信息
	{k = "wBankerUser", t = "word"},								--当前庄家
	{k = "cbBankerTime", t = "word"},								--庄家局数
	{k = "lBankerWinScore", t = "score"},							--庄家成绩
	{k = "lBankerScore", t = "score"},								--庄家分数
	{k = "bEnableSysBanker", t = "bool"},							--系统做庄

	{k = "cbTableHavaSendCardArray", t = "byte", l = {10, 10, 10, 10}},					--桌面扑克
	{k = "cbTableHavaSendCount", t = "byte", l = {4}},									--桌面扑克
	{k = "cbLeftCardCount", t = "byte"},							--扑克数目
	--控制信息
	{k = "lApplyBankerCondition", t = "score"},						--申请条件
	{k = "lAreaLimitScore", t = "score"},							--区域限制
	--房间信息
	{k = "szGameRoomName", t = "word", l = {cmd.SERVER_LEN}},		--房间名称
--	{k = "lStartStorage", t = "score"},								--初始库存
--	{k = "CustomAndroid", t = "table", d = cmd.tagCustomAndroid},   --机器人配置     
--	{k = "bGenreEducate", t = "bool"},								--是否练习场
}

--游戏状态
cmd.CMD_S_StatusPlay =
{
	--全局下注
	{k = "lAllJettonScore", t = "score", l = {cmd.AREA_COUNT+1}},   					--全体总注
	--玩家下注
	{k = "lUserJettonScore", t = "score", l = {cmd.AREA_COUNT+1}},						--个人总注
	
	{k = "cbTableHavaSendCardArray", t = "byte", l = {10, 10, 10, 10}},					--桌面扑克
	{k = "cbTableHavaSendCount", t = "byte", l = {4}},									--桌面扑克
	{k = "cbLeftCardCount", t = "byte"},							--扑克数目

	--玩家积分
	{k = "lUserMaxScore", t = "score"},								--最大下注

	--控制信息
	{k = "lApplyBankerCondition", t = "score"},						--申请条件
	{k = "lAreaLimitScore", t = "score"},							--区域限制

	--扑克信息
	{k = "cbTableCardArray", t = "byte", l = {2,2,2,2}},			--桌面扑克

	--庄家信息
	{k = "wBankerUser", t = "word"},								--当前庄家
	{k = "cbBankerTime", t = "word"},								--庄家局数
	{k = "lBankerWinScore", t = "score"},							--庄家赢分
	{k = "lBankerScore", t = "score"},								--庄家分数
	{k = "bEnableSysBanker", t = "bool"},							--系统做庄

	--结束信息
	{k = "lEndBankerScore", t = "score"},							--庄家成绩
	{k = "lEndUserScore", t = "score"},								--玩家成绩
	{k = "lEndUserReturnScore", t = "score"},						--返回积分
	{k = "lEndRevenue", t = "score"},								--游戏税收

	--全局信息
	{k = "cbTimeLeave", t = "byte"},								--剩余时间
	{k = "cbGameStatus", t = "byte"},								--游戏状态

	--房间信息
	{k = "szGameRoomName", t = "word", l = {cmd.SERVER_LEN}},	    --房间名称
--	{k = "lStartStorage", t = "score"},								--初始库存
--	{k = "CustomAndroid", t = "table", d = cmd.tagCustomAndroid},  --机器人配置        
--	{k = "bGenreEducate", t = "bool"},								--是否练习场
}

--游戏开始
cmd.CMD_S_GameStart =
{
	{k = "wBankerUser", t = "word"},								--庄家位置			 
	{k = "lBankerScore", t = "score"},								--庄家金币	
	{k = "lUserMaxScore", t = "score"},								--我的金币			 
	{k = "cbTableHavaSendCardArray", t = "byte", l = {10,10,10,10}},--桌面扑克    
	{k = "cbTableHavaSendCount", t = "byte", l = {4}},				--桌面扑克			 
	{k = "cbLeftCardCount", t = "byte"},							--扑克数目

	{k = "cbTimeLeave", t = "byte"},								--剩余时间			 
	{k = "bContiueCard", t = "bool"},								--继续发牌
	{k = "nChipRobotCount", t = "dword"},							--人数上限			 
	{k = "nAndriodCount", t = "dword"},								--机器人申请个数			   
}

--游戏空闲
cmd.CMD_S_GameFree =
{
	{k = "cbTimeLeave", t = "byte"},								--剩余时间			 
	--{k = "lStorageStart", t = "score"},								--库存数值				   
}

--用户下注
cmd.CMD_S_PlaceJetton =
{
	{k = "wChairID", t = "word"},									--用户位置			 
	{k = "cbJettonArea", t = "byte"},								--筹码区域	
	{k = "lJettonScore", t = "score"},								--加注数目			 
	{k = "bIsAndroid", t = "bool"},									--是否机器人
	--{k = "bAndroid", t = "bool"},									--机器标识			 
}

--游戏结束
cmd.CMD_S_GameEnd =
{   --下局信息
	{k = "cbTimeLeave", t = "byte"},								--剩余时间	
	--	扑克信息	 
	{k = "cbTableCardArray", t = "byte", l = {2,2,2,2}},			--桌面扑克	
	{k = "cbTableHavaSendCardArray", t = "byte", l = {10,10,10,10}},--桌面扑克		 
	{k = "cbTableHavaSendCount", t = "byte", l = {4}},				--桌面扑克
	{k = "cbLeftCardCount", t = "byte"},							--扑克数目	

	{k = "bcFirstCard", t = "byte"},	
	{k = "bcNextCard", t = "byte"},	

	--庄家信息		 
	{k = "lBankerScore", t = "score"},								--庄家成绩
	{k = "lBankerTotallScore", t = "score"},						--庄家成绩			 
	{k = "nBankerTime", t = "dword"},								--做庄次数	

	--玩家成绩
	{k = "lUserScore", t = "score"},								--玩家成绩
	{k = "lUserReturnScore", t = "score"},							--返回积分

	--全局信息
	{k = "lRevenue", t = "score"},									--游戏税收
	--{k = "lServerFees", t = "score"},								--游戏服务费	
}

--发牌模式
cmd.CMD_S_SelectCardMode =
{
	{k = "cbPutCardMode", t = "byte"},								--摆牌模式			 
	{k = "cbSendCardMode", t = "byte"},								--发牌模式	
}

--更新库存
cmd.CMD_S_UpdateStorage =
{
	{k = "lStorage", t = "score"},									--新库存值			 
	{k = "lStorageDeduct", t = "score"},							--库存衰减	
}

--客户端命令结构
cmd.SUB_C_PLACE_JETTON = 1 											--用户下注
cmd.SUB_C_APPLY_BANKER = 2 											--申请上庄
cmd.SUB_C_CANCEL_BANKER = 3 										--取消申请
cmd.SUB_C_CONTINUE_CARD = 4 										--继续发牌
cmd.SUB_C_CATCH_BANKER = 5 											--申请抢庄
cmd.SUB_C_SELECT_CARD_MODE = 6 										--发牌模式
cmd.SUB_C_REDISPATCH_CARD = 7 										--重新洗牌
cmd.SUB_C_AMDIN_COMMAND = 8 										--管理员命令
cmd.SUB_C_UPDATE_STORAGE = 9										--更新库存
cmd.SUB_C_STORAGEINFO = 10 											--库存信息

--用户下注
cmd.CMD_C_PlaceJetton = 
{
	{k = "cbJettonArea", t = "byte"},								--筹码区域			 
	{k = "lJettonScore", t = "score"},								--加注数目
}

--发牌模式
cmd.CMD_C_SelectCardMode = 
{
	{k = "cbPutCardMode", t = "byte"},								--摆牌模式			 
	{k = "cbSendCardMode", t = "byte"},								--发牌模式
}

--更新库存
cmd.CMD_C_SelectCardMode = 
{
	{k = "cbReqType", t = "byte"},									--请求类型			 
	{k = "lStorage", t = "score"},									--新库存值
	{k = "lStorageDeduct", t = "score"},							--库存衰减
}

--更新库存上限
cmd.CMD_C_RefreshStorage = 
{
	{k = "lMaxStorage", t = "score", l = {2}},				 
	{k = "nMulStorage", t = "dword", l = {2}},
}

cmd.RQ_REFRESH_STORAGE = 1 
cmd.RQ_SET_STORAGE = 2 

cmd.CMD_C_AdminReq = 
{   
	{k = "cbReqType", t = "byte"},	
	RQ_SET_WIN_AREA = 1, 
	RQ_RESET_CONTROL = 2,
	RQ_PRINT_SYN = 3,
	{k = "cbExtendData", t = "byte", l = {20}},  					--附加数据
} 

cmd.tagAdminReq = 
{   
	
		{k = "m_cbExcuteTimes", t = "byte"},						--执行次数		 
		{k = "m_cbControlStyle", t = "byte"},  						--控制方式
	CS_BANKER_LOSE = 1, 
	CS_BANKER_WIN = 2, 
	CS_BET_AREA = 3,
		{k = "m_bWinArea", t = "bool", l = {3}},  					--赢家区域
} 

--控制区域信息
cmd.tagControlInfo = 
{   
	{k = "cbControlArea", t = "byte", l = {cmd.MAX_INDEX}},			--控制区域		 
} 

return cmd