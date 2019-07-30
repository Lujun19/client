--
-- Author: Garry
-- Date: 2017-2-28
--
local cmd = {}

cmd.KIND_ID 				= 503
cmd.GAME_PLAER 			= 1

--状态定义
cmd.GS_GAME_FREE			= 0
cmd.GS_GAME_STATUS	    	= 100   
cmd.GS_GAME_END        	    = 101

--关卡
cmd.GEM_FIRST = 4
cmd.GEM_SECOND =5
cmd.GEM_THIRD = 6
cmd.GEM_MAX = 7

--宝石定义
cmd.GEMINDEX_BAIYU = 0        --
cmd.GEMINDEX_BIYU = 1
cmd.GEMINDEX_HEIYU  = 2
cmd.GEMINDEX_MANAO = 3
cmd.GEMINDEX_HUPO = 4

cmd.GEMINDEX_ZUMULV = 5
cmd.GEMINDEX_MAOYANSHI = 6
cmd.GEMINDEX_ZISHUIJING = 7
cmd.GEMINDEX_FEICUI = 8
cmd.GEMINDEX_ZHENZHU = 9

cmd.GEMINDEX_HONGBAOSHI = 10
cmd.GEMINDEX_LVBAOSHI = 11
cmd.GEMINDEX_HUANGBAOSHI = 12
cmd.GEMINDEX_LANBAOSHI  = 13
cmd.GEMINDEX_ZUANSHI = 14

cmd.GEMINDEX_ZUANTOU = 15

cmd.GEMINDEX_MAX = 16

--宝石间距
cmd.GEM_DISTANCE = 65

--游戏状态
cmd.CMD_S_STATUS = 
{
	{k="nCellScore",t="int"}, 							--单位积分
	{k="nLineNumber",t="int"}, 							--单线数量
	{k="nLineCount",t="int"}, 							--线数量
	{k="nMaxLineCount",t="int"}, 							--最大线数
	{k="lLineTimes",t="score"}, 							--单线分数倍数
	{k="nAiguilleCount",t="int"}, 							--出现钻头数量
	{k="nLevelsNumber",t="int"}, 						--关卡数
	{k="nBoomCount",t="int"}, 							--上一次的爆炸数量
	{k="bPlayIndiana",t="bool"}, 						--用户是否夺宝
	{k="nIndianaIndex",t="int"}, 							--夺宝索引
	{k="lIndianaScore",t="score",l = {5}}, 					--夺宝分数
	{k="lPlayScore",t="score"}, 							--玩家积分
	{k="lPlayWinLose",t="score"}, 						--玩家输赢分
	{k="lPlayShowWinLose",t="score"}, 					--玩家显示输赢分
	{k="lStorageStart",t="score"}, 						--库存
	{k="nGemCentreIndex",t="int",l={cmd.GEM_MAX }},			--中部宝石索引
	{k="nGemBottomIndex",t="int",l={7,7,7 ,7,7,7,7}},	                      --底部宝石索引
	--{k="nExchange",t="int"}						--兑换比例

}




--服务器命令结构
cmd.SUB_S_GEM  = 101                                 --发送宝石
cmd.SUB_S_LEVEL_CHANGE = 102                --关卡变换
cmd.SUB_S_INDIANA  = 103                           --开始夺宝
cmd.SUB_S_GAME_OVER = 104                     --游戏结束
cmd.SUB_S_BET_FAIL = 105                          --下注失败
cmd.SUB_S_STORAGE = 106                          --库存
cmd.SUB_S_WIN_INFO = 107                          --中奖信息
cmd.SUB_S_CONTROL = 108                           --控制消息
cmd.SUB_S_CAI_JING_INFO = 109		  --彩金

--游戏状态
cmd.CMD_S_GEM= 
{
	{k="nGemABeginX",t="int"}, 									--宝石开始区域
	{k="nGemAEndX",t="int"},									--宝石结束区域
	{k="nGemABeginY",t="int"},									--宝石开始区域
	{k="nGemAEndY",t="int"},									--宝石结束区域
	{k="nGemCentreIndex",t="int",l={cmd.GEM_MAX }},				--中部宝石索引
	{k="nGemBottomIndex",t="int",l={7,7,7 ,7,7,7,7}}	--底部宝石索引
}

--关卡变换
cmd.CMD_S_LEVEL_CHANGE=
{
	{k="nGemLevelsNumber",t="int"}                             --关卡数
}

--开始夺宝
cmd.CMD_S_INDIANA = 
{
	{k="lIndianaScores",t="score",l={5}},                        --夺宝分数
	{k="nIndianaIndex",t="int"}                                       --结束索引

}


--游戏结束
cmd.CMD_S_GAMEOVER = 
{
	{k="bOverIndiana",t="bool"},                                --结束状态
	{k="lOverScores",t="score"},			--结束分数
	{k="lPlayScores",t="score"}				--玩家分数

}

--下注失败
cmd.CMD_S_BETFAIL= 
{
	{k="lPlayScore",t="score"},				     --玩家积分
	{k="lPlayShowWinLose",t="score"}                           --玩家显示输赢分
}


--库存累计
cmd.CMD_S_STORAGE = 
{
	{k="lStorageStart",t="score"}                                     --库存
}


--公告信息
cmd.CMD_S_WININFO = 
{
	{k="wPlayName",t="string",s=33},				--用户名字
	--{k="wPlayName",t="word",l={33}},
	{k="nGemIndex",t="int"},					--宝石索引
	{k="nGemCount",t="int"},					--宝石数量
	{k="lGemScore",t="score"}					--宝石分数
}


--结构信息
cmd.CMD_S_CONTROL = 
{
	{k="nMessageID",t="int"},
	{k="nMessageSize",t="int"},
	{k="cbMessageInfo",t="byte",l={64}}
}

--彩金
cmd.CMD_S_CANJIN= 
{
	{k="nUserID",t="int"},					--宝石索引
	{k="wPlayName",t="string",s=33},				--用户名字	
	{k="nLineCount",t="int"},					--宝石数量
	{k="lGemScore",t="score"}					--宝石分数

}


--客户端命令结构
cmd.SUB_C_GEM = 101					--申请宝石
cmd.SUB_C_LINE_COUNT = 102				--线数改变
cmd.SUB_C_LINE_NUMBER = 103				--线值改变
cmd.SUB_C_INDIANA = 104				--开始夺宝
cmd.SUB_C_EXIT =105					--退出游戏
cmd.SUB_C_CONTROL = 106 				--控制消息


--申请宝石
cmd.CMD_C_GEM = 
{
	{k="nDebits",t="int"} 					--申请宝石	

}

--线数改变
cmd.CMD_C_LINECOUNT = 
{
	{k="nLineCount",t="int"} 				--线数量
}

--线值改变
cmd.CMD_C_LINENUMBER = 
{
	{k="nLineNumber",t="int"} 				--单线值
}

--退出游戏
cmd.CMD_C_EXIT = 
{
	{k="nSave",t="int"} 					--是否保存
}


--结构信息
cmd.CMD_C_CONTROL = 
{
	{k="nMessageID",t="int"} ,
	{k="nMessageSize",t="int"} ,
	{k="cbMessageInfo",t="byte",l={64}} 
}



return cmd