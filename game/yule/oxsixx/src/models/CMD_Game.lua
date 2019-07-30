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


local cmd =  {}
cmd.RES_PATH                    =   "game/yule/oxsixx/res/"

--游戏版本
cmd.VERSION 					= appdf.VersionValue(6,7,0,1)
--游戏标识
cmd.KIND_ID						= 50  --多配置牛牛
	
--游戏人数
cmd.GAME_PLAYER					= 6

--视图位置
cmd.MY_VIEWID					= 3

cmd.MAX_CARDCOUNT               = 5   --牌数

cmd.MAX_CONFIG                  = 5                                   --最大配置个数

--******************         游戏状态             ************--
--等待开始
cmd.GS_TK_FREE					= 0
--叫庄状态
cmd.GS_TK_CALL					= 100
--下注状态
cmd.GS_TK_SCORE					= 101
--游戏进行
cmd.GS_TK_PLAYING				= 102


--*********************      服务器命令结构       ************--
--游戏开始
cmd.SUB_S_GAME_START            = 100
--加注结果
cmd.SUB_S_ADD_SCORE             = 101
--用户强退
cmd.SUB_S_PLAYER_EXIT           = 102
--发牌消息
cmd.SUB_S_SEND_CARD             = 103
--游戏结束
cmd.SUB_S_GAME_END              = 104
--用户摊牌
cmd.SUB_S_OPEN_CARD             = 105
--用户叫庄
cmd.SUB_S_CALL_BANKER           = 106
cmd.SUB_S_CALL_BANKERINFO       = 107
--刷新控制服务端
cmd.SUB_S_ADMIN_STORAGE_INFO    = 112        
--游戏记录                         
cmd.SUB_S_RECORD                = 113                                 

--**********************    客户端命令结构        ************--
--用户叫庄
cmd.SUB_C_CALL_BANKER			= 1
--用户加注
cmd.SUB_C_ADD_SCORE				= 2
--用户摊牌
cmd.SUB_C_OPEN_CARD				= 3
--更新库存
cmd.SUB_C_STORAGE				= 6
--设置上限
cmd.SUB_C_STORAGEMAXMUL			= 7
--请求查询用户
cmd.SUB_C_REQUEST_QUERY_USER	= 8
--用户控制
cmd.SUB_C_USER_CONTROL			= 9

--********************       定时器标识         ***************--
--无效定时器
cmd.IDI_NULLITY					= 200
--开始定时器
cmd.IDI_START_GAME				= 201
--叫庄定时器
cmd.IDI_CALL_BANKER				= 202
--加注定时器
cmd.IDI_TIME_USER_ADD_SCORE		= 1
--摊牌定时器
cmd.IDI_TIME_OPEN_CARD			= 2
--摊牌定时器
cmd.IDI_TIME_NULLITY			= 3
--延时定时器
cmd.IDI_DELAY_TIME				= 4

--*******************        时间标识         *****************--
--叫庄定时器
cmd.TIME_USER_CALL_BANKER		= 20
--开始定时器
cmd.TIME_USER_START_GAME		= 20
--加注定时器
cmd.TIME_USER_ADD_SCORE			= 20
--摊牌定时器
cmd.TIME_USER_OPEN_CARD			= 10


-------------------------------------------


cmd.VOICE_ANIMATION_KEY = "voice_ani_key"

--游戏牌型
cmd.CARDTYPE_CONFIG =
{
    CT_CLASSIC = 22,                       --经典模式
    CT_ADDTIMES = 23,                      --疯狂加倍
    CT_INVALID = 255,                      --无效
}

--发牌模式
cmd.SENDCARDTYPE_CONFIG = 
{
    ST_SENDFOUR = 32,                      --发四等五
    ST_BETFIRST = 33,                      --下注发牌
    ST_INVALID = 255,                      --无效
}

--扑克玩法
cmd.KING_CONFIG = 
{
    GT_HAVEKING = 42,                      --有大小王
    GT_NOKING = 43,                        --无大小王
    GT_INVALID = 255,                      --无效
}

--庄家玩法
cmd.BANERGAMETYPE_CONFIG = 
{
    BGT_DESPOT = 52,                       --霸王庄
    BGT_ROB = 53,                          --倍数抢庄
    BGT_NIUNIU = 54,                       --牛牛上庄
    BGT_NONIUNIU = 55,                     --无牛下庄
    BGT_INVALID = 255,                     --无效
}

--下注配置
cmd.BETTYPE_CONFIG = 
{
    BT_FREE_ = 62,                          --自由配置额度
    BT_PENCENT_ = 63,                       --百分比配置额度
    BT_INVALID_ = 255,                      --无效
}
-------------------------------------------

--预留机器人存款取款
cmd.tagCustomAndroid = 
{             
    { k = "lRobotScoreMin",t = "score"},    
    { k = "lRobotScoreMax",t = "score"},                       
    { k = "lRobotBankGet",t = "score"},                      
    { k = "lRobotBankGetBanker",t = "score"},                          
    { k = "lRobotBankStoMul",t = "score"},                            
}

--游戏状态
cmd.CMD_S_StatusFree = 
{
    { k = "lCellScore",t = "score"},                                    --基础积分
    { k = "lRoomStorageStart",t = "score"},                              --房间起始库存
    { k = "lRoomStorageCurrent",t = "score"},                            --房间当前库存

    --历史积分
    { k = "lTurnScore",t = "score",l = {cmd.GAME_PLAYER}},              --积分信息
    { k = "lCollectScore",t = "score",l = {cmd.GAME_PLAYER}},            --积分信息
    { k = "CustomAndroid",t = "table",d=cmd.tagCustomAndroid},           --机器人配置

    { k = "bIsAllowAvertCheat",t = "bool"},                             --反作弊标志

    { k = "ctConfig",t = "int"},                                       --游戏牌型
    { k = "stConfig",t = "int"},                                       --发牌模式
    { k = "bgtConfig",t = "int"},                                      --庄家玩法
    { k = "btConfig",t = "int"},                                       --下注配置

};

--叫庄
cmd.CMD_S_StatusCall = 
{
    { k = "cbDynamicJoin",t = "byte"},                                      --用户状态
     { k = "cbPlayStatus",t = "byte",l = {cmd.GAME_PLAYER}},                 --用户状态

    { k = "lRoomStorageStart",t = "score"},                                 --房间起始库存
    { k = "lRoomStorageCurrent",t = "score"},                               --房间当前库存

    --历史积分
    { k = "lTurnScore",t = "score",l = {cmd.GAME_PLAYER}},                  --积分信息
    { k = "lCollectScore",t = "score",l = {cmd.GAME_PLAYER}},               --积分信息
    { k = "CustomAndroid",t = "table",d=cmd.tagCustomAndroid},               --机器人配置

    { k = "bIsAllowAvertCheat",t = "bool"},                                 --反作弊标志

    { k = "cbCallBankerStatus",t = "byte",l = {cmd.GAME_PLAYER}},              --叫庄状态
    { k = "cbCallBankerTimes",t = "byte",l = {cmd.GAME_PLAYER}},               --叫庄倍数

    { k = "ctConfig",t = "int"},                                       --游戏牌型
    { k = "stConfig",t = "int"},                                       --发牌模式
    { k = "bgtConfig",t = "int"},                                       --庄家玩法
    { k = "btConfig",t = "int"},                                       --下注配置

};

--叫分
cmd.CMD_S_StatusScore = 
{
    --下注信息
    { k = "cbPlayStatus",t = "byte",l = {cmd.GAME_PLAYER}},                 --用户状态
    { k = "cbDynamicJoin",t = "byte"},                                      --用户状态
    { k = "lTurnMaxScore",t = "score"},                                     --用户状态
    { k = "lTableScore",t = "score",l = {cmd.GAME_PLAYER}},                 --下注数目
    { k = "wBankerUser",t = "word"},                                        --庄家用户

    { k = "lRoomStorageStart",t = "score"},                                 --房间起始库存
    { k = "lRoomStorageCurrent",t = "score"},                               --房间当前库存

    --历史积分
    { k = "lTurnScore",t = "score",l = {cmd.GAME_PLAYER}},                  --积分信息
    { k = "lCollectScore",t = "score",l = {cmd.GAME_PLAYER}},               --积分信息
    { k = "CustomAndroid",t = "table",d=cmd.tagCustomAndroid},               --机器人配置

    { k = "bIsAllowAvertCheat",t = "bool"},                             --反作弊标志

    { k = "cbCardData",t = "byte",l = {cmd.MAX_CARDCOUNT,cmd.MAX_CARDCOUNT,cmd.MAX_CARDCOUNT,cmd.MAX_CARDCOUNT,cmd.MAX_CARDCOUNT,cmd.MAX_CARDCOUNT}},                 --用户扑克

    { k = "ctConfig",t = "int"},                                       --游戏牌型
    { k = "stConfig",t = "int"},                                       --发牌模式
    { k = "bgtConfig",t = "int"},                                      --庄家玩法
    { k = "btConfig",t = "int"},                                       --下注配置
   
    { k = "lFreeConfig",t = "int",l = {cmd.MAX_CONFIG}},                --自由配置额度(无效值0)
    { k = "lPercentConfig",t = "int",l = {cmd.MAX_CONFIG}},             --百分比配置额度(无效值0)

};

--游戏状态
cmd.CMD_S_StatusPlay = 
{
        --下注信息
    { k = "cbPlayStatus",t = "byte",l = {cmd.GAME_PLAYER}},                 --用户状态
    { k = "cbDynamicJoin",t = "byte"},                                      --用户状态
    { k = "lTurnMaxScore",t = "score"},                                     --用户状态
    { k = "lTableScore",t = "score",l = {cmd.GAME_PLAYER}},                 --下注数目
    { k = "wBankerUser",t = "word"},                                        --庄家用户

    { k = "lRoomStorageStart",t = "score"},                                 --房间起始库存
    { k = "lRoomStorageCurrent",t = "score"},                               --房间当前库存

    --扑克信息
    --桌面扑克
    { k = "cbHandCardData",t = "byte",l = {cmd.MAX_CARDCOUNT,cmd.MAX_CARDCOUNT,cmd.MAX_CARDCOUNT,cmd.MAX_CARDCOUNT,cmd.MAX_CARDCOUNT,cmd.MAX_CARDCOUNT}},
    { k = "bOpenCard",t = "bool",l = {cmd.GAME_PLAYER}}, --开牌标识 
    { k = "bSpecialCard",t = "bool",l = {cmd.GAME_PLAYER}},--特殊牌型 
    { k = "cbOriginalCardType",t="byte",l = {cmd.GAME_PLAYER}}, --玩家初始牌型               
    { k = "cbCombineCardType",t="byte",l = {cmd.GAME_PLAYER} },--玩家组合牌型
    --历史积分
    { k = "lTurnScore",t = "score",l = {cmd.GAME_PLAYER}},              --积分信息
    { k = "lCollectScore",t = "score",l = {cmd.GAME_PLAYER}},            --积分信息
    { k = "CustomAndroid",t = "table",d=cmd.tagCustomAndroid},           --机器人配置

    { k = "bIsAllowAvertCheat",t = "bool"},                             --反作弊标志

    { k = "ctConfig",t = "int"},                                       --游戏牌型
    { k = "stConfig",t = "int"},                                       --发牌模式
    { k = "bgtConfig",t = "int"},                                       --庄家玩法
    { k = "btConfig",t = "int"},                                       --下注配置
   
    { k = "lFreeConfig",t = "int",l = {cmd.MAX_CONFIG}},                --自由配置额度(无效值0)
    { k = "lPercentConfig",t = "int",l = {cmd.MAX_CONFIG}},             --百分比配置额度(无效值0)

}

--叫庄
cmd.CMD_S_CallBanker = 
{
    { k = "wCallBanker",t = "word"},                                    --叫庄用户
    { k = "bBanker",t = "bool"},                                        --叫庄标志
    { k = "bFirstTimes",t = "bool"},                                    --首次叫庄标志(若bFirstTimes为true则bBanker和cbBankerTimes没意义)
    { k = "cbBankerTimes",t = "byte"},                                  --叫庄倍数(若用户不叫庄，赋值0)               
}

cmd.CMD_S_CallBankerInfo = 
{

    { k = "cbCallBankerStatus",t = "byte",l = {cmd.GAME_PLAYER}},              --叫庄状态
    { k = "cbCallBankerTimes",t = "byte",l = {cmd.GAME_PLAYER}},               --叫庄倍数

}
--游戏开始
cmd.CMD_S_GameStart = 
{
    { k = "wBankerUser",t = "word"},                                        --庄家用户
    { k = "cbPlayerStatus",t = "byte",l = {cmd.GAME_PLAYER}},               --玩家状态
    { k = "lTurnMaxScore",t = "score"},                                     --玩家状态

    { k = "cbCardData",t = "byte",l = {cmd.MAX_CARDCOUNT,cmd.MAX_CARDCOUNT,cmd.MAX_CARDCOUNT,cmd.MAX_CARDCOUNT,cmd.MAX_CARDCOUNT,cmd.MAX_CARDCOUNT}},                 --用户扑克

    { k = "stConfig",t = "int"},                                        --发牌模式
    { k = "bgtConfig",t = "int"},                                       --庄家玩法
    { k = "btConfig",t = "int"},                                        --下注配置
   
    { k = "lFreeConfig",t = "int",l = {cmd.MAX_CONFIG}},                --自由配置额度(无效值0)
    { k = "lPercentConfig",t = "int",l = {cmd.MAX_CONFIG}},             --百分比配置额度(无效值0)
}


--用户下注
cmd.CMD_S_AddScore = 
{
    { k = "wAddScoreUser",t = "word"},                                  --加注用户
    { k = "lAddScoreCount",t = "score"},                                --玩家状态
}

--游戏结束
cmd.CMD_S_GameEnd = 
{
    { k = "lGameTax",t = "score",l = {cmd.GAME_PLAYER}},                  --游戏税收
    { k = "lGameScore",t = "score",l = {cmd.GAME_PLAYER}},                --游戏得分
    { k = "cbCardData",t = "byte",l = {cmd.MAX_CARDCOUNT,cmd.MAX_CARDCOUNT,cmd.MAX_CARDCOUNT,cmd.MAX_CARDCOUNT,cmd.MAX_CARDCOUNT,cmd.MAX_CARDCOUNT}},
    { k = "cbCardType",t = "byte",l = {cmd.GAME_PLAYER}},                 --玩家牌型
    { k = "cbDelayOverGame",t = "byte"},                                  --
}

--发牌数据包
cmd.CMD_S_SendCard = 
{
    --(发全部5张牌，如果发牌模式是发四等五，则前面四张和CMD_S_GameStart消息一样)
    { k = "cbCardData",t = "byte",l = {cmd.MAX_CARDCOUNT,cmd.MAX_CARDCOUNT,cmd.MAX_CARDCOUNT,cmd.MAX_CARDCOUNT,cmd.MAX_CARDCOUNT,cmd.MAX_CARDCOUNT}},
    { k = "bSpecialCard",t = "bool",l = {cmd.GAME_PLAYER}},--特殊牌型 
    { k = "cbOriginalCardType",t="byte",l = {cmd.GAME_PLAYER}} --玩家初始牌型                                 
}

--用户退出
cmd.CMD_S_PlayerExit = 
{
    { k = "wPlayerID",t = "word"},                                          --退出用户
};

--用户摊牌
cmd.CMD_S_Open_Card = 
{
    { k = "wOpenChairID",t = "word"},                                       --摊牌用户
    { k = "bOpenCard",t = "byte"},                                          --摊牌标志
};

--游戏记录
cmd.CMD_S_RECORD = 
{
    { k = "nCount",t = "int"},                                       --盘数
    { k = "lUserWinCount",t = "score",l = {cmd.GAME_PLAYER}},        --玩家胜利次数
    { k = "lUserLostCount",t = "score",l = {cmd.GAME_PLAYER}},        --玩家失败次数
}

---------------------客户端命令结构-------------------------

--用户叫庄
cmd.CMD_C_CallBanker = 
{
    { k = "bBanker",t = "bool"},                                            --叫庄标志
    { k = "cbBankerTimes",t = "byte"},                                      --叫庄倍数(若用户不叫庄，赋值0)
};

--用户加注
cmd.CMD_C_AddScore = 
{
    { k = "lScore",t = "score"},                                             --加注数目
};

cmd.CMD_C_UpdateStorage = 
{
    { k = "lRoomStorageCurrent",t = "score"},                                --库存数值
    { k = "lRoomStorageDeduct",t = "score"},                                 --库存数值
};

cmd.CMD_C_ModifyStorage = 
{
    { k = "lMaxRoomStorage",t = "score",l = {2}},                            --库存上限
    { k = "wRoomStorageMul",t = "word",l = {2}},                             --赢分概率
};

return cmd