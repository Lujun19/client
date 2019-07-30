local cmd={}
--------------------------------------------------------------------------
--公共宏定义

cmd.KIND_ID			=			302									--游戏 I D
cmd.GAME_NAME		=			"血战麻将"				--游戏名字

--组件属性
cmd.GAME_PLAYER		=			4									--游戏人数
cmd.VERSION_SERVER	=			"7.0.1"				--程序版本
cmd.VERSION_CLIENT	=			"7.0.1"				--程序版本

cmd.GAME_STATUS_FREE=           0
cmd.GAME_STATUS_PLAY=			100

cmd.MY_VIEWID					= 1
cmd.RIGHT_VIEWID				= 2
cmd.LEFT_VIEWID					= 3
cmd.TOP_VIEWID					= 4

cmd.RES_PATH 				= "game/yule/sparrowxz/res/"

--游戏状态
cmd.GS_MJ_FREE		=			cmd.GAME_STATUS_FREE					--空闲状态
cmd.GS_MJ_CHANGECARD=			cmd.GAME_STATUS_PLAY                  	--换三张状态
cmd.GS_MJ_CALL		=			cmd.GAME_STATUS_PLAY+1					--选缺状态
cmd.GS_MJ_PLAY		=			cmd.GAME_STATUS_PLAY+2					--游戏状态

--常量定义
cmd.MAX_WEAVE		=			4									--最大组合
cmd.MAX_INDEX		=			34									--最大索引 --9种万+9种筒+9种索+7种字牌(东、南、西、北、中、发、白）
cmd.MAX_COUNT		=			14									--最大数目
cmd.MAX_REPERTORY	=			108									--最大库存

--********************       定时器标识         ***************--
cmd.IDI_START_GAME				= 201						--开始定时器
cmd.IDI_CHANGE_CARD             = 202                       --换三张定时器
cmd.IDI_CALL_CARD               = 203						--选缺定时器
cmd.IDI_OUT_CARD				= 204						--出牌定时器
cmd.IDI_OPERATE_CARD			= 205						--操作定时器

--扑克定义
cmd.HEAP_FULL_COUNT	=			26									--堆立全牌

cmd.MAX_RIGHT_COUNT	=			1									--最大权位D{t="word",k="个数

--换三张
cmd.CLOCKWISE_CHANGE		=	0									--顺时针换牌
cmd.ANTI_CLOCKWISE_CHANGE	=	1									--逆时针换牌
cmd.OPPOSITE_CHANGE			=	2									--对家换牌
cmd.MAX_CHANGE_TYPE			=	3									--换三张方式个数
cmd.MAX_CHANGE_CARDCOUNT	=	3									--换三张牌张数

--对局流水清单
cmd.MAX_CHART_COUNT =           40
--------------------------------------------------------------------------

cmd.CHARTTYPE=
{
	INVALID_CHARTTYPE = 0,
	GUAFENG_TYPE = 22,
	BEIGUAFENG_TYPE = 23,
	XIAYU_TYPE = 24,
	BEIXIAYU_TYPE = 25,
	DIANPAO_TYPE = 26,
	BEIDIANPAO_TYPE = 27,
	ZIMO_TYPE = 28,
	BEIZIMO_TYPE = 29,
	HUJIAOZHUANYI_TYPE = 30,
	TUISHUI_TYPE = 31,
	CHAHUAZHU_TYPE = 32,
	CHADAJIAO_TYPE = 33,
}

cmd.CHARTTYPESTR=
{
"刮风","被刮风","下雨","被下雨","点炮","被点炮","自摸","被自摸","呼叫转移","退税","查花猪","查大叫"
}

--对局流水清单
cmd.tagChart=
{
	{t="int",k="charttype"},	 --清单类型
	{t="score",k="lTimes"},	     --倍数
	{t="score",k="lScore"},	     --得分
	{t="bool",k="bEffectChairID",l={cmd.GAME_PLAYER} } --作用的椅子ID，false为无作用
}

--组合子项
cmd.CMD_WeaveItem=  --明杠和补杠的cbPublicCard为true，暗杠的cbPublicCard为false。明杠的wProvideUser为其他玩家，补杠的wProvideUser为自己
{
	{t="byte",k="cbWeaveKind"},						--组合类型
	{t="byte",k="cbCenterCard"},						--中心扑克
	{t="byte",k="cbPublicCard"},						--公开标志
	{t="word",k="wProvideUser"},						--供应用户
}

--------------------------------------------------------------------------
--服务器命令结构

cmd.SUB_S_GAME_START	=		100									--游戏开始
cmd.SUB_S_CALL_CARD		=		101									--缺门命令
cmd.SUB_S_BANKER_INFO	=		102									--庄家信息
cmd.SUB_S_OUT_CARD		=		103									--出牌命令
cmd.SUB_S_SEND_CARD		=		104									--发送扑克
cmd.SUB_S_OPERATE_NOTIFY=		105									--操作提示
cmd.SUB_S_OPERATE_RESULT=		106									--操作命令
cmd.SUB_S_GAME_END		=		107									--游戏结束
cmd.SUB_S_TRUSTEE		=		108									--用户托管
cmd.SUB_S_CHI_HU		=		109									--用户吃胡
cmd.SUB_S_GANG_SCORE	=		110									--杠牌得分
cmd.SUB_S_WAIT_OPERATE	=		111									--等待操作
cmd.SUB_S_RECORD		=		112									--记录
cmd.SUB_S_CHANGE_CARD_RESULT=   113									--换三张结果

cmd.SUB_S_ASK_HANDCARD      = 114

cmd.CMD_S_Askhandcard=
{
	{t="byte",k="cbCardData",l={cmd.MAX_COUNT}}
}

--游戏状态
cmd.CMD_S_StatusFree=
{
	{t="score",k="lCellScore"},							--基础金币
	{t="word",k="wBankerUser"},						--庄家用户
	{t="bool",k="bTrustee",l={cmd.GAME_PLAYER}},				--是否托管
	{t="bool",k="bCheatMode"},							--防作弊标识

	--历史积分
	{t="score",k="lTurnScore",l={cmd.GAME_PLAYER}},			--积分信息
	{t="score",k="lCollectScore",l={cmd.GAME_PLAYER}},			--积分信息

	--时间信息
	{t="byte",k="cbTimeOutCard"},					--出牌时间
	{t="byte",k="cbTimeOperateCard"},				--操作时间
	{t="byte",k="cbTimeStartGame"},					--开始时间
	{t="byte",k="cbTimeWaitEnd"},					--结算等待
	{t="bool",k="bHuanSanZhang"},
	{t="bool",k="bHuJiaoZhuanYi"},
}

cmd.CMD_S_StatusChangeCard=
{
	--游戏变量
	{t="score",k="lCellScore"},							--基础金币
	{t="word",k="wBankerUser"},						--庄家用户
	{t="bool",k="bTrustee",l={cmd.GAME_PLAYER}},				--是否托管

	--扑克数据
	{t="byte",k="cbCardCount"},						--扑克数目
	{t="byte",k="cbCardData",l={cmd.MAX_COUNT}},				--扑克列表
	{t="byte",k="cbSendCardData"},						--发送扑克

	--堆立信息
	{t="word",k="wHeapHand"},							--堆立头部
	{t="word",k="wHeapTail"},							--堆立尾部
	{t="byte",k="cbHeapCardInfo",l={2,2,2,2}},		--堆牌信息

	{t="bool",k="bChangeCard",l={cmd.GAME_PLAYER}},			--换三张标识
	{t="byte",k="cbChangeCardDataBefore",l={cmd.MAX_CHANGE_CARDCOUNT,cmd.MAX_CHANGE_CARDCOUNT,cmd.MAX_CHANGE_CARDCOUNT,cmd.MAX_CHANGE_CARDCOUNT}},	--若bChangeCard为true，则cbChangeCardDataBefore为选择换三张的牌

	--历史积分
	{t="score",k="lTurnScore",l={cmd.GAME_PLAYER}},			--积分信息
	{t="score",k="lCollectScore",l={cmd.GAME_PLAYER}},			--积分信息

	--时间信息
	{t="byte",k="cbTimeOutCard"},						--出牌时间
	{t="byte",k="cbTimeOperateCard"},					--操作时间
	{t="byte",k="cbTimeStartGame"},					--开始时间
	{t="byte",k="cbTimeWaitEnd"},						--结算等待
	{t="bool",k="bHuanSanZhang"},
	{t="bool",k="bHuJiaoZhuanYi"},
}

--叫缺状态
cmd.CMD_S_StatusCall=
{
	--游戏变量
	{t="score",k="lCellScore"},							--基础金币
	{t="word",k="wBankerUser"},						--庄家用户
	{t="bool",k="bTrustee",l={cmd.GAME_PLAYER}},				--是否托管

	--缺门信息
	{t="bool",k="bCallCard",l={cmd.GAME_PLAYER}},				--缺门状态
	{t="byte",k="cbCallCard",l={cmd.GAME_PLAYER}},			--缺门数据

	--扑克数据
	{t="byte",k="cbCardCount"},						--扑克数目
	{t="byte",k="cbCardData",l={cmd.MAX_COUNT}},				--扑克列表
	{t="byte",k="cbSendCardData"},						--发送扑克

	--堆立信息
	{t="word",k="wHeapHand"},							--堆立头部
	{t="word",k="wHeapTail"},							--堆立尾部
	{t="byte",k="cbHeapCardInfo",l={2,2,2,2}},		--堆牌信息

	--历史积分
	{t="score",k="lTurnScore",l={cmd.GAME_PLAYER}},			--积分信息
	{t="score",k="lCollectScore",l={cmd.GAME_PLAYER}},			--积分信息
	--时间信息
	{t="byte",k="cbTimeOutCard"},					--出牌时间
	{t="byte",k="cbTimeOperateCard"},				--操作时间
	{t="byte",k="cbTimeStartGame"},					--开始时间
	{t="byte",k="cbTimeWaitEnd"},					--结算等待
	{t="bool",k="bHuanSanZhang"},
	{t="bool",k="bHuJiaoZhuanYi"},
}

--
-- //游戏变量
-- 	LONGLONG						lCellScore;							//单元积分
-- 	WORD							wBankerUser;						//庄家用户
-- 	WORD							wCurrentUser;						//当前用户
--
-- 	//状态变量
-- 	BYTE							cbActionCard;						//动作扑克
-- 	BYTE							cbActionMask;						//动作掩码
-- 	BYTE							cbLeftCardCount;					//剩余数目
-- 	bool							bTrustee[GAME_PLAYER];				//是否托管
-- 	WORD							wWinOrder[GAME_PLAYER];				//胡牌顺序
-- 	BYTE							cbCallCard[GAME_PLAYER];			//缺门信息
--
-- 	//出牌信息
-- 	WORD							wOutCardUser;						//出牌用户
-- 	BYTE							cbOutCardData;						//出牌扑克
-- 	BYTE							cbDiscardCount[GAME_PLAYER];		//丢弃数目
-- 	BYTE							cbDiscardCard[GAME_PLAYER][60];		//丢弃记录
--
-- 	//扑克数据
-- 	BYTE							cbCardCount;						//扑克数目
-- 	BYTE							cbCardData[MAX_COUNT];				//扑克列表
-- 	BYTE							cbSendCardData;						//发送扑克
--
-- 	//组合扑克
-- 	BYTE							cbWeaveCount[GAME_PLAYER];			//组合数目
-- 	CMD_WeaveItem					WeaveItemArray[GAME_PLAYER][MAX_WEAVE];//组合扑克
--
-- 	//堆立信息
-- 	WORD							wHeapHand;							//堆立头部
-- 	WORD							wHeapTail;							//堆立尾部
-- 	BYTE							cbHeapCardInfo[GAME_PLAYER][2];		//堆牌信息
--
-- 	//历史积分
-- 	LONGLONG						lTurnScore[GAME_PLAYER];			//积分信息
-- 	LONGLONG						lCollectScore[GAME_PLAYER];			//积分信息
--
--     //--时间信息
--     BYTE                            cbTimeOutCard;                      //--出牌时间
--     BYTE                            cbTimeOperateCard;                  //--操作时间
--     BYTE                            cbTimeStartGame;                    //--开始时间
--     BYTE                            cbTimeWaitEnd;                      //--结算等待
--     struct tagChart                 tagHistoryChart[GAME_PLAYER][MAX_CHART_COUNT];
--     bool                            bHuanSanZhang;
--     bool                            bHuJiaoZhuanYi;
--游戏状态
cmd.CMD_S_StatusPlay=
{
	--游戏变量
	{t="score",k="lCellScore"},							--单元积分
	{t="word",k="wBankerUser"},						--庄家用户
	{t="word",k="wCurrentUser"},						--当前用户

	--状态变量
	{t="byte",k="cbActionCard"},						--动作扑克
	{t="byte",k="cbActionMask"},						--动作掩码
	{t="byte",k="cbLeftCardCount"},					--剩余数目
	{t="bool",k="bTrustee",l={cmd.GAME_PLAYER}},				--是否托管
	{t="word",k="wWinOrder",l={cmd.GAME_PLAYER}},				--胡牌顺序
	{t="byte",k="cbCallCard",l={cmd.GAME_PLAYER}},			--缺门信息

	--出牌信息
	{t="word",k="wOutCardUser"},						--出牌用户
	{t="byte",k="cbOutCardData"},						--出牌扑克
	{t="byte",k="cbDiscardCount",l={cmd.GAME_PLAYER}},		--丢弃数目
	{t="byte",k="cbDiscardCard",l={60,60,60,60}},		--丢弃记录

	--扑克数据
	{t="byte",k="cbCardCount"},						--扑克数目
	{t="byte",k="cbCardData",l={cmd.MAX_COUNT}},				--扑克列表
	-- {t="byte",k="cbChiHuCardArray",l={cmd.GAME_PLAYER}},  --0表示未胡牌
	{t="byte",k="cbSendCardData"},						--发送扑克

	--组合扑克
	{t="byte",k="cbWeaveCount",l={cmd.GAME_PLAYER}},			--组合数目
	{t="table",k="WeaveItemArray",d=cmd.CMD_WeaveItem,l={cmd.MAX_WEAVE,cmd.MAX_WEAVE,cmd.MAX_WEAVE,cmd.MAX_WEAVE}}, --组合扑克

	--堆立信息
	{t="word",k="wHeapHand"},							--堆立头部
	{t="word",k="wHeapTail"},							--堆立尾部
	{t="byte",k="cbHeapCardInfo",l={2,2,2,2}},		--堆牌信息

	--历史积分
	{t="score",k="lTurnScore",l={cmd.GAME_PLAYER}},			--积分信息
	{t="score",k="lCollectScore",l={cmd.GAME_PLAYER}},			--积分信息

	--时间信息
	{t="byte",k="cbTimeOutCard"},					--出牌时间
	{t="byte",k="cbTimeOperateCard"},				--操作时间
	{t="byte",k="cbTimeStartGame"},					--开始时间
	{t="byte",k="cbTimeWaitEnd"},					--结算等待

	{t="table",k="tagHistoryChart",d=cmd.tagChart,l={cmd.MAX_CHART_COUNT,cmd.MAX_CHART_COUNT,cmd.MAX_CHART_COUNT,cmd.MAX_CHART_COUNT}},
	{t="bool",k="bHuanSanZhang"},
	{t="bool",k="bHuJiaoZhuanYi"},
}

--游戏开始
cmd.CMD_S_GameStart=
{
	{t="int",k="lSiceCount"},							--骰子点数
	{t="word",k="wBankerUser"},						--庄家用户
	{t="word",k="wCurrentUser"},						--当前用户
	{t="byte",k="cbUserAction"},						--用户动作
	{t="byte",k="cbCardData",l={cmd.MAX_COUNT*cmd.GAME_PLAYER}},	--扑克列表
	{t="word",k="wHeapHand"},							--堆立牌头
	{t="word",k="wHeapTail"},							--堆立牌尾
	{t="byte",k="cbHeapCardInfo",l={2,2,2,2}},		--堆立信息
	{t="byte",k="cbLeftCardCount"},					--剩余扑克
	{t="byte",k="cbSendCardData"},
	{t="bool",k="bHuanSanZhang"}
}

-- cmd.CMD_S_ChangeCardResult=
-- {
-- 	{t="byte",k="cbChangeType"},						--0顺时针 1逆时针 2对家
-- 	{t="byte",k="cbChangeCardResult",l={cmd.MAX_CHANGE_CARDCOUNT}},	--换三张扑克
-- 	{t="byte",k="cbUserAction"},						--用户动作
-- 	{t="byte",k="cbSendCardData"}
-- }

cmd.CMD_S_ChangeCardResult=
{
	{t="byte",k="cbChangeType"},						--0顺时针 1逆时针 2对家
	{t="byte",k="cbChangeCardResult",l={cmd.MAX_CHANGE_CARDCOUNT}},	--换三张扑克
	{t="byte",k="cbSendCardData"}
}

--缺门命令
cmd.CMD_S_CallCard=
{
	{t="word",k="wCallUser"},							--叫牌用户
}

cmd.CMD_S_BankerInfo=  --都选完缺后发送此消息
{
	{t="word",k="wBankerUser"},						--庄家玩家
	{t="word",k="wCurrentUser"},						--当前玩家
	{t="byte",k="cbCallCard",l={cmd.GAME_PLAYER}},			--缺门索引
	{t="byte",k="cbUserAction"}
}

--出牌命令
cmd.CMD_S_OutCard=
{
	{t="word",k="wOutCardUser"},						--出牌用户
	{t="byte",k="cbOutCardData"},						--出牌扑克
}

--发送扑克
cmd.CMD_S_SendCard=
{
	{t="byte",k="cbCardData"},							--扑克数据
	{t="byte",k="cbActionMask"},						--动作掩码
	{t="word",k="wCurrentUser"},						--当前用户
	{t="bool",k="bTail"},								--末尾发牌
}


--操作提示
cmd.CMD_S_OperateNotify=
{
	{t="word",k="wResumeUser"},						--还原用户
	{t="byte",k="cbActionMask"},						--动作掩码
	{t="byte",k="cbActionCard"},						--动作扑克
}

--操作命令
cmd.CMD_S_OperateResult=
{
	{t="word",k="wOperateUser"},						--操作用户
	{t="word",k="wProvideUser"},						--供应用户
	{t="byte",k="cbOperateCode"},						--操作代码
	{t="byte",k="cbOperateCard"},						--操作扑克
	{t="table",k="tagHistoryChart",d=cmd.tagChart,l={cmd.MAX_CHART_COUNT,cmd.MAX_CHART_COUNT,cmd.MAX_CHART_COUNT,cmd.MAX_CHART_COUNT}}
}
--游戏结束
cmd.CMD_S_GameEnd=
{
	--扑克变量
	{t="byte",k="cbCardCount",l={cmd.GAME_PLAYER}},			--扑克数目
	{t="byte",k="cbCardData",l={cmd.MAX_COUNT,cmd.MAX_COUNT,cmd.MAX_COUNT,cmd.MAX_COUNT}},	--扑克数据

	--结束信息
	{t="word",k="wProvideUser",l={cmd.GAME_PLAYER}},			--供应用户
	{t="dword",k="dwChiHuRight",l={cmd.GAME_PLAYER}},			--胡牌类型

	--积分信息
	{t="score",k="lGameScore",l={cmd.GAME_PLAYER}},			--游戏积分
	{t="int",k="lGameTax",l={cmd.GAME_PLAYER}},				--游戏税收

	{t="word",k="wWinOrder",l={cmd.GAME_PLAYER}},				--胡牌排名

	{t="score",k="lGangScore",l={cmd.GAME_PLAYER}},			--详细得分
	{t="score",k="lHuaZhuScore",l={cmd.GAME_PLAYER,cmd.GAME_PLAYER,cmd.GAME_PLAYER,cmd.GAME_PLAYER}},--花猪得分
	{t="score",k="lChaJiaoScore",l={cmd.GAME_PLAYER,cmd.GAME_PLAYER,cmd.GAME_PLAYER,cmd.GAME_PLAYER}},--查收得分
	{t="score",k="lLostHuaZhuScore",l={cmd.GAME_PLAYER,cmd.GAME_PLAYER,cmd.GAME_PLAYER,cmd.GAME_PLAYER}},--花猪得分
	{t="score",k="lLostChaJiaoScore",l={cmd.GAME_PLAYER,cmd.GAME_PLAYER,cmd.GAME_PLAYER,cmd.GAME_PLAYER}},--查收得分
	{t="word",k="wLeftUser"},							--逃跑用户
	{t="table",k="tagHistoryChart",d=cmd.tagChart,l={cmd.MAX_CHART_COUNT,cmd.MAX_CHART_COUNT,cmd.MAX_CHART_COUNT,cmd.MAX_CHART_COUNT}} --对局流水
}

cmd.CMD_S_RECORD=
{
		--明杠和补杠为“刮风”，暗杠为“下雨
	{t="int",k="nCount"},                                               --约战局数
	{t="byte",k="cbGuaFeng",l={cmd.GAME_PLAYER}}	,						--刮风次数
	{t="byte",k="cbXiaYu",l={cmd.GAME_PLAYER}}	,						--下雨次数

	{t="byte",k="cbFangPao",l={cmd.GAME_PLAYER}},							--放炮次数
	{t="byte",k="cbZiMo",l={cmd.GAME_PLAYER}}	,						--自摸次数

	{t="score",k="lAllScore",l={cmd.GAME_PLAYER}}	,						--总结算分
	{t="score",k="lDetailScore",l={cmd.MAX_RECORD_COUNT,cmd.MAX_RECORD_COUNT,cmd.MAX_RECORD_COUNT,cmd.MAX_RECORD_COUNT}}
}

--用户托管
cmd.CMD_S_Trustee=
{
	{t="bool",k="bTrustee"},							--是否托管
	{t="word",k="wChairID"},							--托管用户
}

--吃胡消息
cmd.CMD_S_ChiHu=
{
	{t="word",k="wChiHuUser"},							--吃胡用户
	{t="word",k="wProviderUser"},						--提供用户
	{t="byte",k="cbChiHuCard"},						--胡牌数据
	{t="byte",k="cbCardCount"},						--扑克数目
	{t="score",k="lGameScore"},							--游戏分数
	{t="byte",k="cbWinOrder"},							--胡牌顺序
	{t="table",k="tagHistoryChart",d=cmd.tagChart,l={cmd.MAX_CHART_COUNT,cmd.MAX_CHART_COUNT,cmd.MAX_CHART_COUNT,cmd.MAX_CHART_COUNT}} --对局流水
}

--杠牌分数
cmd.CMD_S_GangScore=
{
	{t="word",k="wChairId"},							--杠牌用户
	{t="byte",k="cbXiaYu"},							--刮风下雨
	{t="score",k="lGangScore",l={cmd.GAME_PLAYER}},			--杠牌分数
}

--------------------------------------------------------------------------
--客户端命令结构

cmd.SUB_C_CALL_CARD		=		1									--用户缺门
cmd.SUB_C_OUT_CARD		=		2									--出牌命令
cmd.SUB_C_OPERATE_CARD	=		3									--操作扑克
cmd.SUB_C_TRUSTEE		=		4									--用户托管
cmd.SUB_C_CHANGE_CARD	=		5									--换三张
cmd.SUB_C_ASK_HANDCARD  =       11

cmd.CMD_C_ChangeCard=
{
	{t="byte",k="cbChangeCardData",l={cmd.MAX_CHANGE_CARDCOUNT}}	--换三张扑克
}

--用户缺门
cmd.CMD_C_CallCard=
{
	{t="byte",k="cbCallCard"},							--缺门索引
}

--出牌命令
cmd.CMD_C_OutCard=
{
	{t="byte",k="cbCardData"},							--扑克数据
}

--操作命令
cmd.CMD_C_OperateCard=
{
	{t="byte",k="cbOperateCode"},						--操作代码
	{t="byte",k="cbOperateCard"},						--操作扑克
}

--用户托管
cmd.CMD_C_Trustee=
{
	{t="bool",k="bTrustee"},							--是否托管
}
--------------------------------------------------------------------------

return cmd
