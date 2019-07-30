local cmd={}


cmd.GAME_STATUS_FREE=0 --?
cmd.GAME_STATUS_PLAY=100 --?

cmd.KIND_ID				=		123									--游戏 I D
cmd.GAME_PLAYER			=		100									--游戏人数
cmd.GAME_NAME			=		"飞禽走兽"					--游戏名字

--状态定义
cmd.GS_PLACE_JETTON	=			cmd.GAME_STATUS_PLAY					--下注状态
cmd.GS_GAME_END		=			cmd.GAME_STATUS_PLAY+1					--结束状态

cmd.VERSION_SERVER	=		    "7.0.1"				--程序版本
cmd.VERSION_CLIENT	=			"7.0.1"			--程序版本

--燕子X6	鸽子X8	孔雀X8	老鹰X12	狮子X12	熊猫X8	猴子X8	兔子X6 鲨鱼24 飞禽2 走兽2

--下注按钮索引  --鲨鱼按钮发送9还是12还是both ？
cmd.ID_TU_ZI			=		1									--兔子
cmd.ID_YAN_ZI			=		2									--燕子
cmd.ID_GE_ZI			=		3									--鸽子
cmd.ID_KONG_QUE			=		4									--孔雀
cmd.ID_LAO_YING			=		5									--老鹰
cmd.ID_SHI_ZI			=		6									--狮子
cmd.ID_XIONG_MAO		=		7									--熊猫
cmd.ID_HOU_ZI			=		8									--猴子
cmd.ID_SHA_YU			=		9									--鲨鱼      --银鲨
cmd.ID_FEI_QIN			=		10									--飞禽		--通赔
cmd.ID_ZOU_SHOU			=		11									--走兽		--通杀
cmd.ID_GLOD_SHA			=		12									--金鲨		--金鲨


--燕子 --鸽子 --孔雀 --老鹰 --狮子 --熊猫 --猴子 --兔子 --鲨鱼 --飞禽 --走兽

cmd.AREA_YAN_ZI           =         0
cmd.AREA_GE_ZI             =      1
cmd.AREA_KONG_QUE           =         2
cmd.AREA_LAO_YING            =        3
cmd.AREA_SHI_ZI               =     4
cmd.AREA_XIONG_MAO             =      5
cmd.AREA_HOU_ZI                 =   6
cmd.AREA_TU_ZI                   = 7
cmd.AREA_SHA_YU                   = 8
cmd.AREA_FEI_QIN                   = 9
cmd.AREA_ZOU_SHOU                   = 10

--me added----------
--结算种类索引
cmd.JS_YAN_ZI           	=         0
cmd.JS_GE_ZI             	=      	  1
cmd.JS_KONG_QUE           	=         2
cmd.JS_LAO_YING           	=         3
cmd.JS_SHI_ZI               =     	  4
cmd.JS_XIONG_MAO            =         5
cmd.JS_HOU_ZI               =         6
cmd.JS_TU_ZI                =         7
cmd.JS_YIN_SHA              =		  8
cmd.JS_TONG_PEI				=		  9
cmd.JS_TONG_SHA				=		  10
cmd.JS_JIN_SHA				=		  11

cmd.RECORD_COUNT_MAX=65
------

cmd.AREA_COUNT					=12									--区域数目
cmd.AREA_ALL					=12									--动物种类
cmd.ANIMAL_COUNT                =28                                  --动物个数


--------------------------------------------------------------------------
--服务器命令结构

cmd.SUB_S_GAME_FREE			=	299									--游戏空闲
cmd.SUB_S_GAME_START		=	300									--游戏开始
cmd.SUB_S_PLACE_JETTON		=	301									--用户下注
cmd.SUB_S_GAME_END			=	302									--游戏结束
cmd.SUB_S_APPLY_BANKER		=	303									--申请庄家
cmd.SUB_S_CHANGE_BANKER		=	304									--切换庄家
cmd.SUB_S_CHANGE_USER_SCORE	=	305									--更新积分
cmd.SUB_S_SEND_RECORD		=	306									--游戏记录
cmd.SUB_S_PLACE_JETTON_FAIL	=	307									--下注失败
cmd.SUB_S_CANCEL_BANKER		=	308									--取消申请
cmd.SUB_S_CEAN_JETTON		=	309									--清楚下注
cmd.SUB_S_CONTINU_JETTON	=	310									--继续下注
cmd.SUB_S_ADMIN_COMMDN_EXT	=	318									--系统控制
cmd.SUB_S_UPDATE_STORAGE_EXT =   319									--更新库存

--库存控制
cmd.RQ_REFRESH_STORAGE	=	1
cmd.RQ_SET_STORAGE		=	2


--更新库存
cmd.CMD_C_UpdateStorage=
{
	{t="byte",k="cbReqType"},						--请求类型
	{t="score",k="lStorageDeduct"},					--库存衰减
	{t="score",k="lStorageCurrent"},				--当前库存
	{t="score",k="lCurrentBonus"},					--当前彩金池
	{t="score",k="lStorageMax1"},					--库存上限1
	{t="score",k="lStorageMul1"},					--系统输分概率1
	{t="score",k="lStorageMax2"},					--库存上限2
	{t="score",k="lStorageMul2"},					--系统输分概率2
}
--清楚下注
cmd.CMD_S_CeanJetton=
{
	{t="score",k="lAllCPlaceScore",l={cmd.AREA_COUNT+1}},		--当前下注
	{t="word",k="wChairID"},							--用户位置
}

cmd.CMD_S_ContiueJetton=
{
	{t="score",k="lAllJettonScore",l={cmd.AREA_COUNT+1}},		--全体总注
	{t="score",k="lUserJettonScore",l={cmd.AREA_COUNT+1}},		--个人总注
	{t="score",k="lUserStartScore",l={cmd.GAME_PLAYER}},		--起始分数

	{t="word",k="wChairID"},							--用户位置
	{t="byte",k="cbAndroid"},							--机器人
}
--失败结构
cmd.CMD_S_PlaceJettonFail=
{
	{t="word",k="wPlaceUser"},							--下注玩家
	{t="byte",k="lJettonArea"},						--下注区域
	{t="score",k="lPlaceScore"},						--当前下注
}

--更新积分
cmd.CMD_S_ChangeUserScore=
{
	{t="word",k="wChairID"},							--椅子号码
	{t="double",k="lScore"},								--玩家积分

	--庄家信息
	{t="word",k="wCurrentBankerChairID"},				--当前庄家
	{t="byte",k="cbBankerTime"},						--庄家局数
	{t="double",k="lCurrentBankerScore"},				--庄家分数
}


--记录信息
cmd.tagServerGameRecord=
{
	{t="byte",k="bWinMen",l={cmd.AREA_COUNT} }	--最近AREA_COUNT次转盘结果记录
}

--申请庄家
cmd.CMD_S_ApplyBanker=
{
	{t="word",k="wApplyUser"},							--申请玩家
}

--取消申请
cmd.CMD_S_CancelBanker=
{
	{t="string",k="szCancelUser",s=32},					--取消玩家
}

--切换庄家
cmd.CMD_S_ChangeBanker=
{
	{t="word",k="wBankerUser"},						--当庄玩家
	{t="score",k="lBankerScore"},						--庄家金币
}

--游戏状态
cmd.CMD_S_StatusFree=
{
	{t="score",k="lStorageStart"},						--库存数值
	{t="score",k="lBonus"},								--彩金池

	--全局信息
	{t="byte",k="cbTimeLeave"},						--剩余时间

	--玩家信息
	{t="score",k="lUserMaxScore"},						--玩家金币
	{t="int",k="nAnimalPercent",l={cmd.AREA_ALL}},			--开中比例
	--庄家信息
	{t="word",k="wBankerUser"},						--当前庄家
	{t="word",k="cbBankerTime"},						--庄家局数
	{t="score",k="lBankerWinScore"},					--庄家成绩
	{t="score",k="lBankerScore"},						--庄家分数
	{t="bool",k="bEnableSysBanker"},					--系统做庄

	--控制信息
	{t="score",k="lApplyBankerCondition"},				--申请条件
	{t="score",k="lAreaLimitScore"},					--区域限制
	
	{t="string",k="szGameRoomName",s=32},					--房间名称 
	{t="int",k="tagCustomAndroid",l={41}},			--useless

}
--下注信息
cmd.tagUserBet=
{
	{t="string",k="szNickName",s=32},						--用户昵称
	{t="word",k="dwUserGameID"},						--用户ID
	{t="score",k="lUserStartScore"},					--用户金币
	{t="score",k="lUserWinLost"},						--用户金币
	{t="score",k="lUserBet",l={cmd.AREA_COUNT}},				--用户下注
}

--游戏状态
cmd.CMD_S_StatusPlay=  --StatusEnd也是用这个结构体
{
	--全局下注
	{t="score",k="lAllJettonScore",l={cmd.AREA_COUNT+1}},		--全体总注

	--玩家下注
	{t="score",k="lUserJettonScore",l={cmd.AREA_COUNT+1}},		--个人总注

	--玩家积分
	{t="score",k="lUserMaxScore"},						--最大下注							
	{t="int",k="nAnimalPercent",l={cmd.AREA_ALL}},			--开中比例
	--控制信息
	{t="score",k="lApplyBankerCondition"},				--申请条件
	{t="score",k="lAreaLimitScore"},					--区域限制

	--扑克信息
	{t="byte",k="cbTableCardArray",l={2}},				--桌面扑克

	--庄家信息
	{t="word",k="wBankerUser"},						--当前庄家
	{t="word",k="cbBankerTime"},						--庄家局数
	{t="score",k="lBankerWinScore"},					--庄家赢分
	{t="score",k="lBankerScore"},						--庄家分数
	{t="bool",k="bEnableSysBanker"},					--系统做庄


	--结束信息
	{t="score",k="lEndBankerScore"},					--庄家成绩
	{t="score",k="lEndUserScore"},						--玩家成绩
	{t="score",k="lEndUserReturnScore"},				--返回积分
	{t="score",k="lEndRevenue"},						--游戏税收
	
	--全局信息
	{t="byte",k="cbTimeLeave"},						--剩余时间
	{t="byte",k="cbGameStatus"},						--游戏状态
	{t="string",k="szGameRoomName",s=32},					--房间名称 

	{t="score",k="lStorageStart"},						--库存数值
	{t="score",k="lBonus"},								--彩金池
	{t="int",k="tagCustomAndroid",l={41}},			--useless

}

--游戏空闲
cmd.CMD_S_GameFree=
{
	{t="byte",k="cbTimeLeave"},						--剩余时间
	{t="score",k="lStorageControl"},					--库存数值
	{t="score",k="lStorageStart"},						--彩池数值
	{t="score",k="lBonus"},								--彩金池
}

--游戏开始
cmd.CMD_S_GameStart=
{
	{t="word",k="wBankerUser"},						--庄家位置
	{t="score",k="lBankerScore"},						--庄家金币
	{t="score",k="lUserMaxScore"},						--我的金币
	{t="byte",k="cbTimeLeave"},						--剩余时间	
	{t="bool",k="bContiueCard"},						--继续发牌
	{t="int",k="nChipRobotCount"},					--人数上限 (下注机器人)
	{t="score",k="lStorageStart"},						--库存数值
	{t="score",k="lBonus"},								--彩金池
}

--用户下注
cmd.CMD_S_PlaceJetton=
{
	{t="word",k="wChairID"},							--用户位置
	{t="byte",k="cbJettonArea"},						--筹码区域
	{t="score",k="lJettonScore"},						--加注数目
	{t="byte",k="cbAndroid"},							--机器人
	{t="score",k="lUserStartScore",l={cmd.GAME_PLAYER}},				--起始分数
	--玩家下注
	{t="score",k="lUserJettonScore",l={cmd.AREA_COUNT+1}},		--个人总注
}

--游戏结束
cmd.CMD_S_GameEnd=
{
	--下局信息
	{t="byte",k="cbTimeLeave"},						--剩余时间

	--扑克信息
	{t="byte",k="cbTableCardArray",l={2}},		--转盘结果 可能转一次或两次，cbTableCardArray[1]为0？ 表示只转一次
	{t="byte",k="cbShaYuAddMulti"},					--附加倍率
	--庄家信息
	{t="score",k="lBankerScore"},						--庄家成绩
	{t="score",k="lBankerTotallScore"},					--庄家成绩
	{t="int",k="nBankerTime"},						--做庄次数

	--玩家成绩
	{t="score",k="lUserScore"},							--玩家成绩
	{t="score",k="lUserReturnScore"},					--返回积分

	--全局信息
	{t="score",k="lRevenue"},							--游戏税收
	{t="int",k="nAnimalPercent",l={cmd.AREA_ALL}},			--开中比例  --传给客户端这个数据干啥？

	{t="score",k="lStorageStart"},						--库存数值
	{t="score",k="lLastJetton",l={cmd.AREA_COUNT+1}},			--上局下注
}

--------------------------------------------------------------------------
--客户端命令结构

cmd.SUB_C_PLACE_JETTON		=	201									--用户下注
--cmd.SUB_C_APPLY_BANKER		=	202									--申请庄家
--cmd.SUB_C_CANCEL_BANKER		=	203									--取消申请
--cmd.SUB_C_ADMIN_COMMDN_EXT	=	204									--系统控制
cmd.SUB_C_CLEAN_JETTON		=	205									--清零命令
cmd.SUB_C_CONTINUE_JETTON	=	206									--继续下注
--cmd.SUB_C_UPDATE_STORAGE_EXT =   207									--更新库存

--用户下注
cmd.CMD_C_PlaceJetton=
{
	{t="byte",k="cbJettonArea"},	 				    --筹码区域
	{t="score",k="lJettonScore"},						--加注数目
}

cmd.CMD_C_CleanMeJetton=
{
	{t="word",k="wChairID"},							--用户位置
}

cmd.CMD_C_ContinueJetton=
{
	{t="word",k="wChairID"},							--用户位置
	{t="score",k="lLastAllJettonPlace",l={cmd.AREA_COUNT+1}},	--全部筹码
	{t="score",k="lLastAllJettonArea",l={cmd.AREA_COUNT+1}},	--区域筹码

	{t="byte",k="cbJettonArea"},						--筹码区域
	{t="score",k="lJettonScore"},						--加注数目
	{t="byte",k="cbAndroid"},							--机器人
}
--------------------------------------------------------------------------

--控制区域信息
cmd.tagControlInfo=
{
	{t="byte",k="cbControlArea1"},						--控制区域
	{t="byte",k="cbControlArea2"},						--控制区域
}

--更新库存
cmd.CMD_S_UpdateStorage=
{
	{t="byte",k="cbReqType"},						--请求类型
	{t="score",k="lStorageStart"},					--起始库存
	{t="score",k="lStorageDeduct"},					--库存衰减
	{t="score",k="lStorageCurrent"},				--当前库存
	{t="score",k="lCurrentBonus"},					--当前彩金池
	{t="score",k="lStorageMax1"},					--库存上限1
	{t="score",k="lStorageMul1"},					--系统输分概率1
	{t="score",k="lStorageMax2"},					--库存上限2
	{t="score",k="lStorageMul2"},					--系统输分概率2
}

--服务器控制返回
cmd. S_CR_FAILURE			=	20		--失败
cmd. S_CR_SET_SUCCESS		=	21		--设置成功
cmd. S_CR_CANCEL_SUCCESS	=	22		--取消成功

cmd.CMD_S_ControlReturns=
{
	{t="byte",k="cbReturnsType"},				--回复类型
	{t="byte",k="cbControlArea"},				--控制区域
	{t="byte",k="cbControlTimes"},			--控制次数
}

--申请类型
cmd. C_CA_SET		=			17		--设置
cmd. C_CA_CANCELS	=			18		--取消

cmd.CMD_C_ControlApplication=
{
	{t="byte",k="cbControlAppType"},			--申请类型
	{t="byte",k="cbControlArea"},				--控制区域
	{t="byte",k="cbControlTimes"},			--控制次数
}

return cmd
--------------------------------------------------------------------------

