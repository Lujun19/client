--
-- Author: Tang
-- Date: 2016-12-08 15:41:53
--
local cmd = {}

--游戏标识
cmd.KIND_ID                 = 49

--游戏人数
cmd.GAME_PLAYER            = 4

--游戏版本
cmd.VERSION  			= appdf.VersionValue(6,7,0,1)

-- 语音动画
cmd.VOICE_ANIMATION_KEY = "voice_ani_key"


--常量数据
cmd.ME_VIEW_CHAIR					=1									--自己视图
cmd.HAND_CARD_COUNT					=13									--扑克数目
cmd.DISPATCH_COUNT					=52	 								--派发数目
cmd.MAX_CARD_COUNT					=52									--最大扑克
cmd.SET_CHIP_COUNT					=4									--下注档次

--游戏状态
cmd.GS_WK_FREE				    	=0									--等待开始
cmd.GS_WK_CALL_BANKER				=100								--叫庄状态
cmd.GS_WK_SETCHIP					=101								--设置下注(选牌)
cmd.GS_WK_PLAYING			    	=102								--游戏进行

cmd.Clock_free						= 1									--准备倒计时
cmd.Clock_status					= 2									--游戏选牌
cmd.Clock_end						= 3

--分段类型
cmd.enSegFront = 0														--前墩类型
cmd.enSegMid   = 1														--中墩类型
cmd.enSegBack  = 2														--后墩类型
cmd.enSegErr   = 3														--错误类型


cmd.InvalidIndex = 255													--无特殊牌型		

--服务器命令结构
cmd.SUB_S_SHOW_CARD					= 203									--玩家摊牌
cmd.SUB_S_GAME_END					= 204									--游戏结束
cmd.SUB_S_COMPARE_CARD				= 205									--比较扑克
cmd.SUB_S_GAME_START				= 206									--游戏开始
cmd.SUB_S_PLAYER_EXIT				= 210									--用户强退
cmd.SUB_S_TRUSTEE					= 214									--托管消息
cmd.SUB_S_SEND_CARD_EX				= 215									--全部发牌
cmd.SUB_S_MOBILE_PUTCARD			= 219									--手机托管牌

--发送扑克
cmd.CMD_S_SendCard = 
{
	{k="wCurrentUser",t="word"},							--当前玩家
	{k="wBanker",t="word"},									--庄家玩家
	{k="bCardData",t="byte",l={cmd.HAND_CARD_COUNT}},		--手上扑克
	{k="cbPlayCount",t="byte"},								--游戏人数
	{k="bGameStatus",t="bool",l={cmd.GAME_PLAYER}},			--游戏状态
	{k="lChipArray",t="score",l={cmd.GAME_PLAYER}}			--玩家下注
}


--玩家摊牌
cmd.CMD_S_ShowCard = 
{
	{k="wCurrentUser",t="word"},							--当前玩家
	{k="bCanSeeShowCard",t="bool"},							--能否看牌
	{k="bFrontCard",t="byte",l={3}},						--前墩扑克
	{k="bMidCard",t="byte",l={5}},							--中墩扑克
	{k="bBackCard",t="byte",l={5}},							--后墩扑克
}

--开始比牌
cmd.CMD_S_CompareCard = 
{
	{k="wBanker",t="word"},										--庄家玩家
	{k="bSegmentCard1",t="byte",l={5,5,5}},							--分段扑克
	{k="bSegmentCard2",t="byte",l={5,5,5}},
	{k="bSegmentCard3",t="byte",l={5,5,5}},
	{k="bSegmentCard4",t="byte",l={5,5,5}},
	{k="lScoreTimes",t="score",l={3,3,3,3}},							--分段倍数
	{k="bSpecialType",t="byte",l={cmd.GAME_PLAYER}},					--特殊牌型
	{k="cbPlayCount",t="byte"},											--游戏人数
}

--用户托管
cmd.CMD_S_Trustee = 
{
	{k="wChairID",t="word"},												--托管用户				
	{k="bTrustee",t="bool"}				 									--是否托管
}

--游戏结束
cmd.CMD_S_GameEnd = 
{
	{k="lGameTax",t="score"},												--游戏税收
	{k="lGameScore",t="score",l={cmd.GAME_PLAYER}},							--游戏积分
	{k="lScoreTimes",t="score",l={cmd.GAME_PLAYER}},						--输赢倍数
	{k="lCompareResult",t="score",l={3,3,3,3}},								--比牌结果
	{k="bEndMode",t="byte"},												--结束方式
	{k="bDragonInfo",t="bool",l={cmd.GAME_PLAYER}},							--乌龙信息
	{k="bWinInfo",t="byte",l={cmd.GAME_PLAYER}},							--胜负信息(0负 1平 2胜)				
}

--用户退出
cmd.CMD_S_PlayerExit = 
{
	{k="wPlayerID",t="word"},												--退出用户
	{k="lScore",t="score",l={cmd.GAME_PLAYER}}								--分数
}

--空闲状态
cmd.CMD_S_StatusFree = 
{	
	--游戏属性
	{k="lBaseScore",t="int"},												--基础积分
	{k="bGameStatus",t="byte",l={cmd.GAME_PLAYER}},							--游戏状态
	{k="bHaveBanker",t="byte"},												--霸王庄模式(0通比，1霸王庄)
	{k="nAllWinTimes",t="int"},												--打枪额外番数

	--历史成绩
	{k="lTurnScore",t="score",l={cmd.GAME_PLAYER}},							--积分信息
	{k="lCollectScore",t="score",l={cmd.GAME_PLAYER}},						--积分信息
		
	--时间定义
	{k="cbTimeStartGame",t="byte"},											--开始时间
	{k="cbTimeCallBanker",t="byte"},										--叫庄时间
	{k="cbTimeSetChip",t="byte"},											--下注时间
	{k="cbTimeRangeCard",t="byte"},											--理牌时间
	{k="cbTimeShowCard",t="byte"},											--开牌时间
	{k="wServerID",t="word"}												--房间标识
}

--游戏状态
cmd.CMD_S_StatusPlay = 
{	
	{k="lChip",t="score",l={cmd.GAME_PLAYER}},								--下注大小
	{k="bHandCardData",t="byte",l={cmd.HAND_CARD_COUNT}},					--扑克数据
	{k="bSegmentCard1",t="byte",l={5,5,5}},									--分段扑克
	{k="bSegmentCard2",t="byte",l={5,5,5}},
	{k="bSegmentCard3",t="byte",l={5,5,5}},
	{k="bSegmentCard4",t="byte",l={5,5,5}},										

	{k="bFinishSegment",t="bool",l={cmd.GAME_PLAYER}},						--完成分段
	{k="wBanker",t="word"},													--庄家玩家
	{k="bGameStatus",t="bool",l={cmd.GAME_PLAYER}},							--游戏状态
	{k="lScoreTimes",t="score",l={3,3,3,3}},								--分段倍数
	{k="bSpecialType",t="byte",l={cmd.GAME_PLAYER}},						--特殊牌型
	{k="cbPlayCount",t="byte"},												--游戏人数
	{k="bHaveBanker",t="byte"},												--霸王庄模式
	{k="nAllWinTimes",t="int"},												--打枪额外番数
							
	--历史成绩		
	{k="lTurnScore",t="score",l={cmd.GAME_PLAYER}},							--积分信息
	{k="lCollectScore",t="score",l={cmd.GAME_PLAYER}},						--积分信息
		
	--时间定义
	{k="cbTimeStartGame",t="byte"},											--开始时间
	{k="cbTimeCallBanker",t="byte"},										--叫庄时间
	{k="cbTimeSetChip",t="byte"},											--下注时间
	{k="cbTimeRangeCard",t="byte"},											--理牌时间
	{k="cbTimeShowCard",t="byte"},											--开牌时间
	{k="wServerID",t="word"}												--房间标识
}

--作弊扑克
cmd.CMD_S_CheatCard = 
{
	{k="wCardUser",t="word",l={cmd.GAME_PLAYER}},							--作弊玩家
	{k="cbUserCount",t="byte"},												--作弊数量
	{k="cbCardData",t="byte",l={13,13,13,13}},								--扑克列表
	{k="cbCardCount",t="byte",l={cmd.GAME_PLAYER}},							--扑克数量		
}

--手机设置牌
cmd.CMD_S_MobilePutCard = 
{
	--{k="cbMobilePutCard",t="byte",l={13}}
	{k="cbMobilePutCount",t="byte"},									--托管数目
	{k="cbMobilePutCard",t="byte",l={13, 13, 13, 13}},					--手机设置牌
}

--------------------------------------------------------------------------
--客户端命令结构
cmd.SUB_C_SHOWCARD						=304								--玩家摊牌
cmd.SUB_C_COMPLETE_COMPARE				=306								--完成比较(buyongl)
cmd.SUB_C_SHUFFLE_FINISH				=307								--洗牌结束(buyongl)
cmd.SUB_C_TRUSTEE						=310								--托管消息			


--分段信息
cmd.CMD_C_ShowCard = 
{
	{k="bFrontCard",t="byte",l={3}},									--前墩扑克
	{k="bMidCard",t="byte",l={5}},										--中墩扑克
	{k="bBackCard",t="byte",l={5}},										--后墩扑克
	{k="cbSpecialCardType",t="byte"}									--特殊牌型
}

--设置托管
cmd.CMD_C_Trustee = 
{
	{k="bTrustee",t="bool"}												--是否托管
}

return cmd