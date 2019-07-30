local cmd = cmd or {}

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
cmd.VERSION 					= appdf.VersionValue(6,7,0,1)
--游戏标识
cmd.KIND_ID						= 406
	
--游戏人数
cmd.GAME_PLAYER					= 1

--数目定义
cmd.ITEM_COUNT 					= 9		        --图标数量
cmd.ITEM_X_COUNT				= 5				--图标横坐标数量
cmd.ITEM_Y_COUNT				= 3				--图标纵坐标数量
cmd.YAXIANNUM					= 1				--压线数字

--序列帧个数
cmd.ACT_DAGU_NUM				= 29			--打鼓
cmd.ACT_QIZHIWAIT_NUM			= 43			--旗帜等待时
cmd.ACT_QIZHI_NUM 				= 53			--旗帜滚动时
cmd.ACT_TITLE_NUM				= 10			--水浒传




--进入模式
cmd.GM_NULL						= 0				--结束
cmd.GM_SHUO_MING				= 1				--说明
cmd.GM_ONE						= 2				--开奖
cmd.GM_TWO						= 3				--比倍
cmd.GM_TWO_WAIT					= 4				--等待比倍
cmd.GM_THREE					= 5				--小游戏


--状态定义
cmd.SHZ_GAME_SCENE_FREE			= 0			--等待开始
cmd.SHZ_GAME_SCENE_ONE			= 101		--水浒传开始
cmd.SHZ_GAME_SCENE_TWO			= 102		--比大小开始
cmd.SHZ_GAME_SCENE_THREE		= 103		--小游戏开始

cmd.GAME_FANPAI                 = 105       --翻牌游戏

cmd.Event_LoadingFinish  = "Event_LoadingFinish"

--空闲状态
cmd.SHZ_CMD_S_StatusFree = 
{
	--游戏属性
	{k="lCellScore",t="int"},				--基础积分
	--下注值	
	{k="cbBetCount",t="byte"},				--下注数量 --押分
	{k="lBetScore",t="score",l={9}},	    --下注大小 --押分
    {k="cbBetLine",t="byte"},				--下注数量 --压线
     -- 奖金
    {k="bonus",t="score"}
}

--开始开牌
cmd.SHZ_CMD_S_StatusTwo = 
{
	--游戏属性
	{k="lCellScore",t="int"},
	{k="cbTwoMode",t="score"},
	{k="lBet",t="score"},
	{k="lOneGameScore",t="score"},
	{k="lTwoGameScore",t="score"},
	{k="cbItemInfo",t="byte",l={cmd.ITEM_X_COUNT,cmd.ITEM_X_COUNT,cmd.ITEM_X_COUNT}},
	--下注值  --押分
	{k="cbBetCount",t="byte"},
	{k="lBetScore",t="score",l={9}},
    --下注值  --压线
	{k="cbBetLine",t="byte"},
     -- 奖金
    {k="bonus",t="score"}
}

--游戏状态
cmd.SHZ_CMD_S_StatusPlay = 
{
	--下注值  --押分
	{k="cbBetCount",t="byte"},
	{k="lBetScore",t="score",l={9}},
    --下注值  --压线
	{k="cbBetLine",t="byte"},
    -- 奖金
    {k="bonus",t="score"}
}



--命令定义
cmd.SUB_S_GAME_START				= 100		--压线开始
cmd.SUB_S_GAME_CONCLUDE				= 101		--压线结束
cmd.SUB_S_TWO_START					= 103		--比倍开始
cmd.SUB_S_GAME_RECORD			    = 104		--中奖记录

cmd.SUB_S_THREE_START				= 105		--翻牌开始
cmd.SUB_S_THREE_KAI_JIANG			= 106       --翻牌结果    
                                                                                               
cmd.SUB_S_THREE_END					= 107		--小玛丽结束 
cmd.SUB_S_SET_BASESCORE				= 108		--设置基数
cmd.SUB_S_AMDIN_COMMAND				= 109		--系统控制
cmd.SUB_S_ADMIN_STORAGE_INFO		= 110		--刷新控制服务器
cmd.SUB_S_REQUEST_QUERY_RESULT		= 111		--查询用户结果
cmd.SUB_S_USER_CONTROL				= 112		--用户控制
cmd.SUB_S_USER_CONTROL_COMPLETE		= 113		--用户控制完成
cmd.SUB_S_OPERATION_RECORD			= 114		--操作记录
cmd.SUB_S_UPDATE_ROOM_STORAGE		= 115		--更新房间库存
cmd.SUB_S_UPDATE_ROOM_ROOMUSERLIST	= 116		--更新房间用户列表

-- 时间定义
cmd.SYSTEMTIME = 
{
    {t = "word", k = "wYear"},
    {t = "word", k = "wMonth"},
    {t = "word", k = "wDayOfWeek"},
    {t = "word", k = "wDay"},
    {t = "word", k = "wHour"},
    {t = "word", k = "wMinute"},
    {t = "word", k = "wSecond"},
    {t = "word", k = "wMilliseconds"},
}

--中奖记录
cmd.SHZ_S_RECORD = 
{
     {k="number",t="byte"},    --中奖次数 
     {k="bouns",t="score",l={10}},    --获得奖金
     {k = "time",t="table", d=cmd.SYSTEMTIME, l = {10}},     --获奖时间
     {k ="name",t="string", s = yl.LEN_NICKNAME,l = {10}},				--用户昵称      --用户昵称
 
}

--游戏开始
cmd.SHZ_CMD_S_GameStart = 
{
	--下注信息
	{k="lScore",t="score"},--游戏积分
	{k="cbItemInfo",t="byte",l={cmd.ITEM_X_COUNT,cmd.ITEM_X_COUNT,cmd.ITEM_X_COUNT}},--开奖信息
	{k="cbGameMode",t="byte"},--游戏模式
	{k="cbbonus",t="score"} --奖池
}






----------断线重连游戏-------------
cmd.CMD_S_SmallSt = 
{
   {k="lCellScore",t="int"},
   {k="cbSmallMode",t="byte"},
   {k="lBet",t="score"},
   {k="lBetCount",t="score"},
   {k="lOneGameScore",t="score"},
   {k="lSmallGameScore",t="score"},
   {k="cbItemInfo",t="byte",l={cmd.ITEM_X_COUNT,cmd.ITEM_X_COUNT,cmd.ITEM_X_COUNT}},
   {k="lBetScore",t="score",l={9}},
   {k="cbCustoms",t="byte"},
   {k="wUseTime",t="wode"},
   {k="cbBonus",t="score"}
}
--小游戏每关结算分数
cmd.CMD_C_SmallStarts =
{
	{k="Isover",t="bool"},              		--//是否结束
	{k="cbCustoms",t="byte"},					--//关卡
	{k="SmallSorce",t="score"}					--//水果分数
};
--小游戏开始
cmd.CMD_S_SmallStart =
{
    {k="cbGameMode",t="byte"},                                   --模式
	{k="SamllGameFruitData",t="dword",l = {5,5,5,5} }           		--//数据 
};

--游戏结束
cmd.SHZ_CMD_S_OneGameConclude = 
{
	--积分变量
	{k="lCellScore",t="score"},--单元积分
	{k="lGameScore",t="score"},--游戏积分
	{k="cbItemInfo",t="byte",l={cmd.ITEM_X_COUNT,cmd.ITEM_X_COUNT,cmd.ITEM_X_COUNT}},--开奖信息
	{k="cbGameMode",t="byte"}--游戏模式
}

--命令定义

cmd.SHZ_SUB_C_THREE_START 	= 1		--小游戏进行 翻牌
cmd.SHZ_SUB_C_CHECKPOINT 	= 2		--小游戏关卡 和游戏
cmd.SHZ_SUB_C_THREE_END		= 5		--小游戏 翻牌结束
cmd.SHZ_SUB_C_CHECK_BONUS   = 4     --查询中奖记录
cmd.SHZ_SUB_C_ONE_START		= 6     --水浒传开始
cmd.SHZ_SUB_C_ONE_END		= 7		--水浒传结束


cmd.SHZ_SUB_C_UPDATE_TABLE_STORAGE	= 28	--更新桌子库存
cmd.SHZ_SUB_C_MODIFY_ROOM_CONFIG	= 29	--修改房间配置
cmd.SHZ_SUB_C_REQUEST_QUERY_USER	= 30	--请求查询用户
cmd.SHZ_SUB_C_USER_CONTROL			= 31	--用户控制

--请求更新命令
cmd.SHZ_SUB_C_REQUEST_UPDATE_ROOMUSERLIST	= 32	--请求更新房间用户列表
cmd.SHZ_SUB_C_REQUEST_UPDATE_ROOMSTORAGE	= 33	--请求更新房间库存

cmd.SHZ_SUB_C_SINGLEMODE_CONFIRM			= 35	--
cmd.SHZ_SUB_C_BATCHMODE_CONFIRM				= 36

--用户叫分
cmd.SHZ_CMD_C_OneStart =
{
	{k="lBet",t="score"},
}
--比倍模式
cmd.SHZ_CMD_C_TwoMode =
{
	{k="cbOpenMode",t="byte"}
}
--比倍开始
cmd.SHZ_CMD_C_TwoStart =
{
	{k="cbOpenArea",t="byte"}
}
--更新本桌库存
cmd.SHZ_CMD_C_UpdateStorageTable =
{
	{k="lStorageTable",t="score"}
}

cmd.SHZ_CMD_C_ModifyRoomConfig =
{
	{k="lStorageDeductRoom",t="score"},			--全局库存衰弱
	{k="lMaxStorageRoom",t="score",l={2}},		--全局库存上限
	{k="wStorageMulRoom",t="word",l={2}},		--全局赢分概率
	{k="wGameTwo",t="word"},					--比倍概率
	{k="wGameTwoDeduct",t="word"},				--比倍概率
	{k="wGameThree",t="word"},					--小玛丽概率
	{k="wGameThreeDeduct",t="word"}				--
}

cmd.SHZ_CMD_C_RequestQusry_User =
{
	{k="dwGameID",t="word"}						--查询用户GAMEID
}

cmd.SHZ_CMD_C_UserControl =
{
	{k="dwGameID",t="word"},					--GAMEID
	{k="userControlInfo",t="word"}				--用户控制信息
}

cmd.SHZ_CMD_C_SingleMode =
{
	{k="wTableId",t="word"},
	{k="lTableStorage",t="score"}
}

cmd.SHZ_CMD_C_BatchMode =
{
	{k="lBatchModifyStorage",t="score"},
	{k="wBatchTableCount",t="score"},			--批量修改桌子张数
	{k="bBatchTableFlag",t="bool",l={512}}		--true为修改的标志
}


return cmd