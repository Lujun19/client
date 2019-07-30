
local ExternalFun = require(appdf.EXTERNAL_SRC .. "ExternalFun")
local cmd  = {}

cmd.RES_PATH = "game/yule/jcby/res/"

--游戏版本
cmd.VERSION       = appdf.VersionValue(6,7,0,1)         --(6,6,0,3)
--游戏标识
cmd.KIND_ID       = 408         --511
--游戏人数
cmd.GAME_PLAYER       = 4         --8
--房间名长度
cmd.SERVER_LEN      = 32

cmd.INT_MAX = 2147483647

cmd.Event_LoadingFish  = "Event_LoadingFinish"
cmd.Event_FishCreate   = "Event_FishCreate"
cmd.SCREENWIDTH = 1152.0
cmd.SCREENHEIGTH = 720.0
cmd.FISHMOVEBILI = 0.8

--音效
cmd.Small_0  = "sound_res/small_0.wav"
cmd.Small_1  = "sound_res/small_1.wav"
cmd.Small_2  = "sound_res/small_2.wav"
cmd.Small_3  = "sound_res/small_3.wav"
cmd.Small_4  = "sound_res/small_4.wav"
cmd.Small_5  = "sound_res/small_5.wav"
cmd.Big_7    = "sound_res/big_7.wav"
cmd.Big_8    = "sound_res/big_8.wav"
cmd.Big_9    = "sound_res/big_9.wav"
cmd.Big_10   = "sound_res/big_10.wav"
cmd.Big_11   = "sound_res/big_11.wav"
cmd.Big_12   = "sound_res/big_12.wav"
cmd.Big_13   = "sound_res/big_13.wav"
cmd.Big_14   = "sound_res/big_14.wav"
cmd.Big_15   = "sound_res/big_15.wav"
cmd.Big_16   = "sound_res/big_16.wav"
cmd.Beauty_0 = "sound_res/beauty_0.wav"
cmd.Beauty_1 = "sound_res/beauty_1.wav"
cmd.Beauty_2 = "sound_res/beauty_2.wav"
cmd.Beauty_3 = "sound_res/beauty_3.wav"

cmd.Load_Back      = "sound_res/LOAD_BACK.mp3"
cmd.Music_Back_1   = "sound_res/MUSIC_BACK_01.mp3"
cmd.Music_Back_2   = "sound_res/MUSIC_BACK_02.mp3"
cmd.Music_Back_3   = "sound_res/MUSIC_BACK_03.mp3"
cmd.Change_Scene   = "sound_res/CHANGE_SCENE.wav"
cmd.CoinAnimation  = "sound_res/CoinAnimation.wav"
cmd.Coinfly        = "sound_res/coinfly.mp3"
cmd.Fish_Special   = "sound_res/fish_special.wav"
cmd.Special_Shoot  = "sound_res/special_shoot.wav"
cmd.Combo          = "sound_res/combo.wav"
cmd.Shell_8        = "sound_res/SHELL_8.wav"
cmd.Small_Begin    = "sound_res/SMALL_BEGIN.wav"
cmd.SmashFail      = "sound_res/SmashFail.wav"

cmd.CoinLightMove  = "sound_res/CoinLightMove.wav"
cmd.Prop_armour_piercing = "sound_res/PROP_ARMOUR_PIERCING.wav"

cmd.SWITCHING_RUN      = "sound_res/SWITCHING_RUN.wav"
cmd.bingo      = "sound_res/bingo.mp3"

--鱼索引
-- 正常鱼
cmd.FishType_XiaoHuangCiYu      = 0               -- 小黄刺鱼
cmd.FishType_XiaoCaoYu      = 1               -- 小草鱼
cmd.FishType_ReDaiHuangYu     = 2               -- 热带黄鱼
cmd.FishType_DaYanJinYu       = 3               -- 大眼金鱼
cmd.FishType_ReDaiZiYu      = 4               -- 热带紫鱼
cmd.FishType_XiaoChouYu       = 5               -- 小丑鱼
cmd.FishType_HeTun      = 6               -- 河豚
cmd.FishType_ShiTouYu       = 7               -- 狮头鱼
cmd.FishType_DengLongYu       = 8               -- 灯笼鱼
cmd.FishType_WuGui        = 9               -- 乌龟
cmd.FishType_ShengXianYu        = 10              -- 神仙鱼
cmd.FishType_HuDieYu        = 11              -- 蝴蝶鱼
cmd.FishType_LingDangYu       = 12              -- 铃铛鱼
cmd.FishType_JianYu         = 13              -- 剑鱼
cmd.FishType_MoGuiYu        = 14              -- 魔鬼鱼
cmd.FishType_DaBaiSha       = 15              -- 大白鲨
cmd.FishType_DaJinSha       = 16              -- 大金鲨
cmd.FishType_JuXingHuangJinSha        = 17              -- 巨型黄金鲨


-- 特殊鱼
cmd.FishType_JinJing        = 18              -- 金鲸
cmd.FishType_JinLong        = 19              -- 金龙
cmd.FishType_QiE            = 20              -- 企鹅
cmd.FishType_LiKui          = 21              -- 李逵
cmd.FishType_ZhongYiTang    = 22              -- 忠义堂
cmd.FishType_ShuiHuZhuan    = 23              -- 水浒传
cmd.FishType_QuanPingZhadan = 24              -- 全屏炸弹

cmd.FishType_BaoXiang       = 25              -- 宝箱

cmd.FishType_ShanHu         = 26              -- 珊瑚

cmd.FishType_YuanBao        = 27              -- 元宝
cmd.FishType_HuoShan        = 28              -- 火山

-- 鱼索引
cmd.FishType_General_Max        = 22              -- 普通鱼最大
cmd.FishType_Normal_Max        = 25              -- 正常鱼最大
cmd.FishType_Max        = 27              -- 最大数量
cmd.FishType_Small_Max        = 9              -- 小鱼最大索引
cmd.FishType_Moderate_Max        = 15              -- 中鱼索
cmd.FishType_Moderate_Big_Max        = 18              -- 中大鱼索
cmd.FishType_Big_Max        = 25              -- 大鱼索引
cmd.FishType_Invalid        = -1              -- 无效鱼


cmd.FISH_KING_MAX       = 7               -- 最大灯笼鱼
cmd.FISH_NORMAL_MAX       = 18              -- 正常鱼索引
cmd.FISH_ALL_COUNT        = 20              -- 鱼最大数

-- 特殊鱼
cmd.SPECIAL_FISH_BOMB     = 0               -- 炸弹鱼
cmd.SPECIAL_FISH_CRAB     = 1               -- 螃蟹
cmd.SPECIAL_FISH_MAX      = 2               -- 最大数量

-- 倍数索引
cmd.MULTIPLE_MAX_INDEX			= 6	

cmd.S_TOP_LEFT					= 0								-- 服务器位置
cmd.S_TOP_CENTER				= 1								-- 服务器位置
cmd.S_TOP_RIGHT					= 2								-- 服务器位置
cmd.S_BOTTOM_LEFT				= 3								-- 服务器位置
cmd.S_BOTTOM_CENTER				= 4								-- 服务器位置
cmd.S_BOTTOM_RIGHT				= 5								-- 服务器位置

cmd.C_TOP_LEFT					= 0								-- 视图位置
cmd.C_TOP_CENTER				= 1								-- 视图位置
cmd.C_TOP_RIGHT					= 2								-- 视图位置
cmd.C_BOTTOM_LEFT				= 3								-- 视图位置
cmd.C_BOTTOM_CENTER				= 4								-- 视图位置
cmd.C_BOTTOM_RIGHT				= 5								-- 视图位置

-- 相对窗口
cmd.DEFAULE_WIDTH				= 1280						    -- 客户端相对宽
cmd.DEFAULE_HEIGHT				= 800							-- 客户端相对高	
cmd.OBLIGATE_LENGTH				= 300							-- 预留宽度

cmd.CAPTION_TOP_SIZE			= 25							-- 标题大小
cmd.CAPTION_BOTTOM_SIZE			= 40							-- 标题大小

-- 炮弹
cmd.BULLET_ONE				= 0								-- 一号炮
cmd.BULLET_TWO				= 1								-- 二号炮
cmd.BULLET_THREE			= 2								-- 三号炮
cmd.BULLET_FOUR				= 3								-- 四号炮
cmd.BULLET_FIVE				= 4								-- 五号炮
cmd.BULLET_SIX				= 5								-- 六号炮
cmd.BULLET_SEVEN			= 6								-- 七号炮
cmd.BULLET_EIGHT			= 7								-- 八号炮
cmd.BULLET_MAX				= 8								-- 最大炮种类


-- 最大路径
cmd.BEZIER_POINT_MAX			= 8

--千炮消耗
cmd.QIAN_PAO_BULLET				= 1
--游戏玩家
cmd.PlayChair_Max 				= 6
cmd.PlayChair_Invalid			= 0xffff
cmd.PlayName_Len				  = 32
cmd.QianPao_Bullet     		= 1
cmd.Multiple_Max  				= 6

cmd.Tag_Fish              = 10
cmd.Tag_Bullet            = 11
cmd.Tag_Laser             = 12

cmd.Fish_MOVE_TYPE_NUM    = 25
cmd.Fish_DEAD_TYPE_NUM    = 25

--dyj1
cmd.BomNormal=0
cmd.BomSameTye=1        --同类
cmd.BomThreeTye=2       --大三
cmd.BomForuTye=3        --大四
cmd.BomSnakHead=4       --蛇头
cmd.BomSnakBody=5       --蛇身
cmd.BomSnakTail=6       --蛇尾
--dyj2

--枚举
----------------------------------------------------------------------------------------------
cmd.TAG_START 					= 1

local enumScoreType =
{
	"EST_Cold",				--游戏币
    "EST_YuanBao",          --元宝
	"EST_Laser",			--激光
	"EST_Speed",			--加速
	"EST_Gift",				--赠送
	"EST_NULL"
}

cmd.SupplyType =  ExternalFun.declarEnumWithTable(0,enumScoreType)

--房间类型
local enumRoomType = 
{
	"ERT_Unknown",						--无效
	"ERT_QianPao",						--千炮
	"ERT_Moni"							--模拟
}

cmd.RoomType = ExternalFun.declarEnumWithTable(0,enumRoomType)

local enumCannonType = 
{
  "Normal_Cannon", --正常炮
  "Bignet_Cannon",--网变大
  "Special_Cannon",--加速炮
  "Laser_Cannon",--激光炮
  "Laser_Shooting"--激光发射中
}
cmd.CannonType = ExternalFun.declarEnumWithTable(0,enumCannonType)

--道具类型
local enumPropObjectType =
{
	"POT_NULL",										-- 无效
	"POT_ATTACK",									-- 攻击
	"POT_DEFENSE",									-- 防御
	"POT_BULLET",									-- 子弹
}

cmd.PropObjectType = ExternalFun.declarEnumWithTable(0,enumPropObjectType)

--鱼类型
cmd.FishType = 
{
    FishType_XiaoHuangCiYu = 0,               -- 小黄刺鱼
    FishType_XiaoCaoYu = 1,                 --小草鱼
    FishType_ReDaiHuangYu = 2,                --热带黄鱼
    FishType_DaYanJinYu = 3 ,                 -- 大眼金鱼
    FishType_ReDaiZiYu = 4,                 -- 热带紫鱼
    FishType_XiaoChouYu = 5,                  -- 小丑鱼
    FishType_HeTun = 6,                   -- 河豚
    FishType_ShiTouYu = 7,                  -- 狮头鱼
    FishType_DengLongYu = 8,                  -- 灯笼鱼
    FishType_WuGui = 9,                   -- 乌龟
    FishType_ShengXianYu = 10,                  -- 神仙鱼
    FishType_HuDieYu = 11,                    -- 蝴蝶鱼
    FishType_LingDangYu = 12,                 -- 铃铛鱼
    FishType_JianYu = 13,                   -- 剑鱼
    FishType_MoGuiYu = 14 ,                   -- 魔鬼鱼
    FishType_DaBaiSha = 15 ,                  -- 大白鲨
    FishType_DaJinSha = 16,                 -- 大金鲨
    FishType_ShuangTouQiEn = 17,                -- 双头企鹅
    FishType_JuXingHuangJinSha = 18,              -- 巨型黄金鲨
    FishType_JinLong = 19 ,                   -- 金龙
    FishType_LiKui = 20,                    -- 李逵
    FishType_ShuiHuZhuan = 21,                  -- 水浒传
    FishType_ZhongYiTang = 22,                  -- 忠义堂
    FishType_BaoZhaFeiBiao = 23,                -- 爆炸飞镖
    FishType_BaoXiang = 26,                 -- 宝箱
    FishType_YuanBao = 27,                    -- 元宝鱼
    FishType_General_Max = 21,                  -- 普通鱼最大
    FishType_Normal_Max= 24,                  -- 正常鱼最大
    FishType_Max = 26,                      -- 最大数量
    FishType_Small_Max = 9,                 -- 小鱼最大索引
    FishType_Moderate_Max = 15,               -- 中鱼索
    FishType_Moderate_Big_Max = 18,             -- 中大鱼索
    FishType_Big_Max = 24,                    --大鱼索引
    FishType_Invalid  = -1                  --无效鱼
}
    
local enumFishState = 
{
	"FishState_Normal",		-- 普通鱼
    "FishState_King",		-- 鱼王
    "FishState_Killer",		-- 杀手鱼
    "FishState_Aquatic",	-- 水草鱼
}
cmd.FishState = ExternalFun.declarEnumWithTable(0,enumFishState)
-----------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------
--服务器命令结构

    cmd.SUB_S_OVER                      = 106    	-- 结算106
    cmd.SUB_S_DELAY_BEGIN               = 107		-- 延迟107
    cmd.SUB_S_DELAY	                    = 108		-- 延迟108
    cmd.SUB_S_BEGIN_LASER               = 109		-- 准备激光109
    cmd.SUB_S_LASER	                    = 75		-- 激光110
    cmd.SUB_S_BANK_TAKE		            = 11        --111					-- 银行取款111
    cmd.SUB_S_SPEECH		            = 112		-- 语音消息112
    cmd.SUB_S_SYSTEM		            = 113		-- 系统消息113
    cmd.SUB_S_SUPPLY_TIP	            = 115		-- 补给提示115
    cmd.SUB_S_SUPPLY		            = 116		-- 补给消息116
    cmd.SUB_S_AWARD_TIP		            = 117		-- 分数提示117
    cmd.SUB_S_CONTROL		            = 118		-- 控制消息118
    cmd.SUB_S_UPDATE_GAME	            = 119		-- 更新游戏119
    cmd.SUB_S_STAY_FISH		            = 61		-- 停留鱼120
    cmd.SUB_S_UPDATE_FISH_SCORE         = 121       -- 停留鱼120

    cmd.SUB_S_FISH_CREATE	            = 100		-- 初始化数据
    cmd.SUB_S_TRACE_POINT               = 101       --鱼62
    cmd.SUB_S_MULTIPLE		            = 102       --上分消息
    cmd.SUB_S_FIRE		                = 103		-- 开火63
    cmd.SUB_S_NOFISH		            = 104		-- 返还分数
    cmd.SUB_S_FISH_CATCH  	            = 105		-- 捕获鱼103
    cmd.SUB_S_BULLET_ION_TIMEOUT        = 106       --子弹变身时间到了
    cmd.SUB_S_LOCK_TIMEOUT              = 107       --锁定时间到
    cmd.SUB_S_CATCH_SWEEP_FISH          = 108       --抓到BOSS和炸弹时
    cmd.SUB_S_CATCH_SWEEP_FISH_RESULT   = 109       --抓到BOSOS和炸弹的结果
    cmd.SUB_S_EXCHANGE_SCENE            = 111		-- 转换场景105
    cmd.SUB_S_NoFire                    = 128       --不允许开枪
    cmd.SUB_S_TimeUp                    = 129       --60s时间到了被T
    cmd.SUB_S_Zongfen                   = 131       --更新总分
    cmd.SUB_S_ControlCfg                = 132
-----------------------------------------------------------------------------------------------

cmd.FishMoveData =   --61
{
	{k="ActiveTime",t="int"},
	{k="FishType",t="int"},
	{k="bomtype",t="int"},
	{k="PathIndex",t="int"},
	{k="Xpos",t="float"},
	{k="Ypos",t="float"},
	{k="Rolation",t="float"},
	{k="Speed",t="float"},
	{k="MoveTime",t="int"},
	{k="CurrPathindex",t="int"},
	{k="FishId",t="int"},
	{k="RandScore",t="int"}
}

--顶点
cmd.CDoulbePoint = 
{
	{k="x",t="double"},
	{k="y",t="double"}
}

cmd.ShortPoint = 
{
	{k="x",t="short"},
	{k="y",t="short"}
}

cmd.tagBezierPoint = 
{
 {k="BeginPoint",t="table",d=cmd.CDoulbePoint},
 {k="EndPoint",t="table",d=cmd.CDoulbePoint},
 {k="KeyOne",t="table",d=cmd.CDoulbePoint},
 {k="KeyTwo",t="table",d=cmd.CDoulbePoint},
 {k="Time",t="dword"}
}

--鱼创建
cmd.CMD_S_FishCreate = 
{
  {k="nFishKey",t="int"},
  {k="nFishType",t="int"},
  {k="nBezierCount",t="int"},
  {k="m_fudaifishtype",t="int"},
  {k="m_BuildTime",t="int"},
  {k="unCreateTime",t="int"},
  {k="nFishState",t="int"}
}

--dyj1(Fc++)
cmd.CMD_S_FishMissed = 
{
    {k="chair_id",t="word"},
    {k="bullet_mul",t="float"}
}
cmd.FPoint = 
{
    {k="x",t="float"},
    {k="y",t="float"}
}
cmd.CMD_S_FishTrace = 
{
  {k="init_pos",t="table",d=cmd.FPoint,l={5}},
  {k="init_count",t="int"},
  {k="cmd_version",t="byte"},
  {k="fish_kind",t="int"},
  {k="fish_id",t="int"},
  {k="trace_type",t="int"}
}
cmd.CMD_S_SwitchScene =
{
  {k="scene_kind",t="int"},
  {k="fish_count",t="int"},
  {k="fish_kind",t="int",l={300}},
  {k="fish_id",t="int",l={300}}
}
--dyj2
--管理申请结果
cmd.CMD_S_CONTROL=
{ 
	{k="total_return_rate_",t="double"},--double					 total_return_rate_;						//返还百分比
	{k="revenue_score",t="double"},--SCORE					 revenue_score;								//游戏抽水
    {k="zhengtigailv",t="double"},--double                       zhengtigailv;								//整体概率
    {k="stock_score0",t="double"}, --LONGLONG				 stock_score[2];
    {k="stock_score1",t="double"}, 
    {k="hard",t="double"},--double                 hard;					// 困难
	{k="easy",t="double"},--double                 easy;					//简单
 }


--鱼创建完成
cmd.CMD_S_FishFinish = 
{
	{k="nOffSetTime",t="dword"}
}

--捕获鱼
cmd.CMD_S_CatchFish = 
{
    {k="wChairID",t="int"},         --玩家椅子
    {k="dwFishID",t="int"},         --鱼群标识
    {k="FishKindscore",t="int"},	--鱼群种类
    {k="lFishScore",t="int"},       --鱼群得分
    {k="m_canSuperPao",t="bool"},   --超级炮
    {k="dwUserScore",t="int"},
    {k="m_IsBaoJi",t="bool"}        --是否爆机
}

cmd.CMD_S_BulletIonTimeout = 
{
    {k="chair_id",t="word"}
}

--dyj1(FC++)
cmd.CMD_S_CaptureFish =
{
    {k="wChairID",t="word"},         --玩家椅子
    {k="dwFishID",t="int"},          --鱼群标识
    {k="FishKind",t="int"},     --鱼群种类
    {k="bullet_ion",t="bool"},       --变身子弹
    {k="lFishScore",t="double"},      --鱼群得分
    {k="fish_caijin_score",t="double"},
    {k="app",t="int"},
}
--dyj2

--开火
cmd.CMD_S_Fire = 
{
  {k="wChairID",t="int"},						-- 玩家位置
  {k="fAngle",t="float"},                       -- 角度
  {k="nBulletKey",t="int"},						-- 子弹关键值
  {k="byShootCount",t="bool"},                  --
  {k="nBulletScore",t="int"},					-- 玩家分数
  {k="dwZidanID",t="int"},
  {k="PowerPer",t="float"},
  {k="sBullet",t="double"},                       --子弹花费
}

--dyj1(FC++)
cmd.CMD_S_UserFire = 
{
  {k="bullet_kind",t="int"},
  {k="bullet_id",t="int"},
  {k="chair_id",t="word"},
  {k="android_chairid",t="word"},
  {k="angle",t="float"},
  {k="bullet_mulriple",t="float"},             --炮台倍率
  {k="lock_fishid",t="int"},
  {k="fish_score",t="double"},
  {k="wBulletSpeed",t="float"},                  --子弹速度
}
--dyj2

--dyj1(FC++)
cmd.CMD_S_ExchangeFishScore = 
{
  {k="chair_id",t="word"},
  {k="swap_fish_score",t="double"},       --上分间隔
  {k="exchange_fish_score",t="double"}
}
--dyj2
cmd.CMD_S_BulletLimitCount = 
{
    {k="bullet_limit_count",t="int"}    --子弹限制数
}
--dyj1(FC++)
cmd.CMD_S_GameConfig = 
{
  {k="exchange_ratio_userscore",t="int"},
  {k="exchange_ratio_fishscore",t="int"},
  {k="exchange_count",t="int"},                -- 上分间隔
  {k="min_bullet_multiple",t="float"},
  {k="max_bullet_multiple",t="float"},
  {k="bomb_range_width",t="int"},
  {k="bomb_range_height",t="int"},
  {k="bomb_stock",t="int"},
  {k="super_bomb_stock",t="int"},

  {k="fish_multiple",t="int",l={41}},
  {k="fish_speed",t="int",l={41}},
  {k="fish_bounding_box_width",t="int",l={41}},
  {k="fish_bounding_box_height",t="int",l={41}},
  {k="fish_hit_radius",t="int",l={41}},

  {k="bullet_speed",t="int",l={8}},
  {k="net_radius",t="int",l={8}},

  {k="RobotScoreMin",t="int"},
  {k="RobotScoreMax",t="int"},
  {k="RobotBankGet",t="int"},
  {k="RobotBankGetBanker",t="int"},
  {k="RobotBankStoMul",t="int"},
  {k="bIsGameCheatUser",t="bool"}
}
--dyj2

--补给信息
cmd.CMD_S_Supply = 
{
  {k="wChairID",t="word"},
  {k="lSupplyCount",t="double"},
  {k="nSupplyType",t="int"}
}

cmd.CMD_S_Multiple = 
{

  {k="wChairID",t="int"},
  {k="nMultipleIndex",t="int"}
}

cmd.CMD_S_BeginLaser = 
{
  {k="wChairID",t="word"},
  {k="ptPos",t="table",d=cmd.ShortPoint}
}

--激光
cmd.CMD_S_Laser = 
{
	{k="wChairID",t="int"},
    {k="IsAndroid",t="bool"},
    {k="fAngle",t="float"}
}

--转换场景
cmd.CMD_S_ChangeSecene =
{
    {k="cbBackIndex",t="int"},
    {k="RmoveID",t="int"}
}

cmd.CMD_S_StayFish = 
{
 {k="nFishKey",t="int"},
 {k="nStayStart",t="int"},
 {k="nStayTime",t="int"}
}
cmd.CMD_S_SupplyTip = 
{
  {k="wChairID",t="word"}
}

cmd.CMD_S_AwardTip = 
{

  {k="wTableID",t="word"},
  {k="wChairID",t="word"},
  {k="szPlayName",t="string",s=32},
  {k="nFishType",t="byte"},
  {k="nFishMultiple",t="int"},
  {k="lFishScore",t="double"},
  {k="nScoreType",t="int"}
}

cmd.CMD_S_UpdateGame = 
{
  {k="nMultipleValue",t="int",l={cmd.Multiple_Max}},
  {k="nFishMultiple",t="int",l={2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2}},
  {k="nBulletVelocity",t="int"},
  {k="nBulletCoolingTime",t="int"},
  {k="nMaxTipCount",t="int"},-- 消息限制
}

--银行
cmd.CMD_S_BankTake = 
{
  {k="wChairID",t="word"},
  {k="lPlayScore",t="double"},
}

--场景信息
cmd.GameScene = 
{
    {k="game_version",t="dword"},
    {k="fish_score",t="double",l={cmd.GAME_PLAYER}},
    {k="exchange_fish_score",t="double",l={cmd.GAME_PLAYER}},
    {k="MinShoot",t="float"},
    {k="MaxShoot",t="float"},
    {k="isYuZhen",t="bool"}
}

--更新总分
cmd.CMD_S_UpdateAllScore =
{
    {k="wChairID",t="word"},         --玩家椅子
    {k="dwFishID",t="int"},          --鱼群标识
    {k="FishKind",t="int"},          --鱼群种类
    {k="bullet_ion",t="bool"},       --变身子弹
    {k="lFishScore",t="double"},      --鱼群得分
    {k="fish_caijin_score",t="double"},
    {k="app",t="int"},              --宝箱获奖类型
}

--抓到BOSS和炸弹时
cmd.CMD_S_CatchSweepFish = 
{
    {k="wChairID",t="word"},        
    {k="dwFishID",t="int"},         
    {k="bullet_mul",t="float"},          
}

--抓到BOSOS和炸弹的结果
cmd.CMD_S_CatchSweepFishResult = 
{
    {k="wChairID",t="word"},    
    {k="dwFishID",t="int"},         
    {k="fish_score",t="double"},    
    {k="catch_fish_count",t="int"},         
    {k="catch_fish_id",t="int",l = {300}}, 
}


cmd.FishScore={2,2,3,4,5,6,7,8,9,10,12,15,18,20,25,30,35,40,120,320,40,20,150,0,180,100}

--dyj1(Fc++)
cmd.FishSpeed = {5,5,5,5,5,5,5,5,5,5,4,4,4,4,4,3,3,3,2,1,2,3,3,3,4,4,4,4,4,4,5,5,5,5,5,5,5,5,5,5}
cmd.FishCount = { 10, 10, 8, 8, 7, 6, 6, 6, 6, 6, 4, 4, 4, 3, 3, 3, 2, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 }
--dyj2

cmd.CMD_S_UpdateFishScore =
{
  {k="nFishKey",t="int"},
  {k="nFishScore",t="int"},
}
----------------------------------------------------------------------------------------------
--客户端命令结构

cmd.SUB_C_BEGIN_LASER       = 104              -- 准备激光
cmd.SUB_C_LASER             = 68              -- 激光105
cmd.SUB_C_SPEECH            = 106              -- 语音消息
cmd.SUB_C_MULTIPLE          = 64              -- 倍数消息
cmd.SUB_C_CONTROL           = 108              -- 控制消息
cmd.SUB_C_LOCKFISH          = 65                 --锁定鱼

cmd.SUB_C_ADDORDOWNSCORE    = 101               --上下分
cmd.SUB_C_FIRE              = 102              --开火62
cmd.SUB_C_CATCH_FISH        = 103              --捕鱼信息101
cmd.SUB_C_CATCH_SWEEP_FISH  = 104               --鱼王全死
cmd.SUB_C_GetSControl       = 156               --获得当前控制数据
cmd.SUB_C_ControlCfg        = 157               --设置当前控制数据    

--鱼王全死
cmd.CMD_C_CatchSweepFish  = 
{
    {k="wChairID",t="word"},
    {k="dwFishID",t="int"},
    {k="catch_fish_count",t="int"},
    {k="catch_fish_id",t="int",l = {300}},
}

-----------------------------------------------------------------------------------------------[48][5][7] 
cmd.PathIndex= {
--出来的轨迹(依次为出来的坐标X,坐标Y,角度,移动速度,移动时间,正反时间角度切换)
{{-100,260,10000,2.05,95,0.00,1},{-200,300,100,2,100,0.01,1},{-200,300,50,2,20,-0.02,1},{-200,300,130,2,100,0.01,0},{-200,300,70,2,1000,0,1}},         --1o
{{1300,260,95,2.05,200,0.00,1},{-200,300,150,2,500,0.01,0},{-200,300,100,2,20,-0.01,1},{-200,300,130,2,10000,0.01,0},{-200,300,70,2,1000,0,1}},        --2o
{{620,-100,130,2.0,200,0.00,1},{-200,300,270,2,100,0.01,0},{-200,300,300,2,20,-0.01,0},{-200,300,350,2,10000,0.01,0},{-200,300,70,2,1000,0,1}},        --3o
{{-100,200,90,2.0,300000,0.00,1},{-200,300,270,2,100,0.01,0},{-200,300,300,2,20,-0.01,0},{-200,300,350,2,10000,0.01,0},{-200,300,70,2,1000,0,1}},      --4o  左下直线右行
{{560,920,-18,2.3,28000,0.00,1},{-200,300,275,2,110,0.001,1},{-200,300,360,2,1000,0.00,0},{-200,300,320,2,10000,0.01,1},{-200,300,70,2,1000,0,1}},     --5o  中上右斜直行
{{850,920,350,2.1,300,0.00,1},{-200,300,120,2,200,0.001,0},{-200,300,30,2,10,0.00,1},{-200,300,310,2,10000,0.01,1},{-200,300,70,2,1000,0,1}},          --6o   倒S
{{1350,280,280,2,50,0.00,1},{-200,300,100,2,100,0.01,1},{-200,300,50,2,20,-0.02,1},{-200,300,130,2,100,0.01,0},{-200,300,70,2,1000,0,1}},              --7o
{{500,-100,180,2.2,95000,0.00,1},{-200,300,100,2,100,0.01,0},{-200,300,100,2,20,-0.01,1},{-200,300,130,2,10000,0.01,0},{-200,300,70,2,1000,0,1}},      --8o    偏左直线上行
{{-100,350,260,2,100,0.00,0},{-200,300,260,2,100,0.01,0},{-200,300,310,2,20,-0.02,0},{-200,300,230,2,100,0.01,1},{-200,300,290,2,1000,0,0}},            --9o
{{600,920,185,2.3,28000,0.00,1},{-200,300,275,2,110,0.001,1},{-200,300,360,2,1000,0.00,0},{-200,300,320,2,10000,0.01,1},{-200,300,70,2,1000,0,1}},     --10o   中上左斜直行
{{600,920,25,2.1,280,0.00,1},{-200,300,275,2,120,0.001,1},{-200,300,360,2,1000,0.00,0},{-200,300,320,2,10000,0.01,1},{-200,300,70,2,1000,0,1}},        --11o
{{1550,180,290,2.1,50,0.00,1},{-200,300,110,2,130,0.02,1},{-200,300,50,2,80,-0.03,1},{-200,300,130,2,120,0.01,0},{-200,300,80,2,1000,0,1}},            --12o
{{300,-100,220,2.1,300,0.00,1},{-200,300,130,2,10000,0.01,1},{-200,300,100,2,20,-0.01,1},{-200,300,130,2,10000,0.01,0},{-200,300,70,2,1000,0,1}},      --13o
{{750,-100,215,2,300000,0.00,1},{-200,280,275,2,11000,0.001,1},{-200,300,360,2,1000,0.00,0},{-200,300,320,2,10000,0.01,1},{-200,300,70,2,1000,0,1}},   --14o   偏右右斜直行
{{1,-100,240,2.2,95000,0.00,1},{-200,300,100,2,100,0.01,0},{-200,300,100,2,20,-0.01,1},{-200,300,130,2,10000,0.01,0},{-200,300,70,2,1000,0,1}},        --15o   偏左右斜直行000
{{1352,150,100,2.3,95000,0.00,1},{-200,300,100,2,100,0.01,0},{-200,300,100,2,20,-0.01,1},{-200,300,130,2,10000,0.01,0},{-200,300,70,2,1000,0,1}},      --16o   右下斜直行
{{300,-100,220,2.2,95000,0.00,1},{-200,300,100,2,100,0.01,0},{-200,300,100,2,20,-0.01,1},{-200,300,130,2,10000,0.01,0},{-200,300,70,2,1000,0,1}},      --17o   类似15
{{10,300,260,2.6,95000,0.00,1},{-200,300,100,2,100,0.01,0},{-200,300,100,2,20,-0.01,1},{-200,300,130,2,10000,0.01,0},{-200,300,70,2,1000,0,1}},        --18o  
{{450,920,330,2.3,300,0.00,1},{-200,280,275,2,11000,0.001,1},{-200,300,360,2,1000,0.00,0},{-200,300,320,2,10000,0.01,1},{-200,300,70,2,1000,0,1}},     --19o
{{1300,420,285,2,300,0.00,1},{-200,300,95,2,270,0.00,1},{-200,300,65,2,20000,-0.00,1},{-200,300,130,2,100,0.01,0},{-200,300,70,2,1000,0,1}},           --20o
{{1,650,300,2.6,95000,0.00,1},{-200,300,100,2,100,0.01,0},{-200,300,100,2,20,-0.01,1},{-200,300,130,2,10000,0.01,0},{-200,300,70,2,1000,0,1}},         --21o  000
{{950,-100,180,2.1,300000,0.00,1},{-200,280,275,2,11000,0.001,1},{-200,300,360,2,1000,0.00,0},{-200,300,320,2,10000,0.01,1},{-200,300,70,2,1000,0,1}}, --22o  
{{850,920,345,2,200,0.00,1},{-200,300,70,2,20,0.01,0},{-200,300,140,2,30,0,0},{-200,300,280,2,420,0.01,1},{-200,300,110,2,1000,0,0}},                  --23o
{{550,920,350,2.1,280,0.00,1},{-200,300,260,2.1,10000,0.01,1},{-200,300,250,2,100,-0.01,1},{-200,300,250,2,100000,0.00,0},{-200,300,320,2,10000,0.01,1}},   --24o
{{1350,650,60,2.6,95000,0.00,1},{-200,300,100,2,100,0.01,0},{-200,300,100,2,20,-0.01,1},{-200,300,130,2,10000,0.01,0},{-200,300,70,2,1000,0,1}},       --25o  
{{1000,-200,150,1.9,300000,0.00,1},{-200,280,275,2,11000,0.001,1},{-200,300,360,2,1000,0.00,0},{-200,300,320,2,10000,0.01,1},{-200,300,70,2,1000,0,1}}, --26o  
{{1350,550,45,2.1,95000,0.00,1},{-200,300,100,2,100,0.01,0},{-200,300,100,2,20,-0.01,1},{-200,300,130,2,10000,0.01,0},{-200,300,70,2,1000,0,1}},       --27o   
{{-100,250,260,2,100,0.00,0},{-200,300,260,2,100,0.01,0},{-200,300,310,2,20,-0.02,0},{-200,300,230,2,100,0.01,1},{-200,300,290,2,1000,0,0}},          --28o
{{1300,560,80,2.5,95000,0.00,1},{-200,300,100,2,100,0.01,0},{-200,300,100,2,20,-0.01,1},{-200,300,130,2,10000,0.01,0},{-200,300,70,2,1000,0,1}},       --29o   
{{800,-100,190,2.3,180,0,1},{-200,280,120,2,50,0,1},{-200,300,35,2,300,0.00,1},{-200,300,130,2,100000,0.001,1},{-200,300,70,2,1000,0,1}},              --30o
{{600,920,30,2.3,28000,0.00,1},{-200,300,275,2,110,0.001,1},{-200,300,360,2,1000,0.00,0},{-200,300,320,2,10000,0.01,1},{-200,300,70,2,1000,0,1}},      --31o   
{{1100,-200,140,2.2,250,0.00,1},{-200,280,90,2,80,-0.001,1},{-200,300,270,2,100000,0.01,0},{-200,300,320,2,10000,0.01,1},{-200,300,170,2,1000,0,1}},     --32o
{{0,-200,125,1.9,300000,0.00,1},{-200,280,275,2,11000,0.001,1},{-200,300,360,2,1000,0.00,0},{-200,300,320,2,10000,0.01,1},{-200,300,70,2,1000,0,1}},   --33o  
{{950,920,30,2.1,400,0.00,1},{-200,300,320,2,1000,0.001,0},{-200,300,311,2,1000,0.00,0},{-200,300,320,2,10000,0.01,1},{-200,300,70,2,1000,0,1}},       --34o
{{1352,600,80,2,300,0.00,1},{-200,300,120,2,50,0.01,0},{-200,300,90,2,50,-0.005,1},{-200,300,270,2,1000,0.01,1},{-200,300,70,2,1000,0,1}},             --35o
--左边圈35-38
{{950,cmd.SCREENHEIGTH/2,0,2,0,0,0},{-200,200,100000,0,4000000,0,1}},                     --36o
{{900,cmd.SCREENHEIGTH/2,0,3,0,0,0},{-200,200,100000,2,4000000,0,1}},                     --37o
{{850,cmd.SCREENHEIGTH/2,0,4,0,0,0},{-200,200,100000,2,4000000,0,1}},                     --38o
{{800,cmd.SCREENHEIGTH/2,0,5,0,0,0},{-200,200,100000,2,4000000,0,1}},                     --39o
--右边圈39-42
{{600,cmd.SCREENHEIGTH/2,0,5,0,0,1},{-200,200,100000,0,4000000,0,0}},                     --40o
{{550,cmd.SCREENHEIGTH/2,0,4,0,0,1},{-200,200,100000,2,4000000,0,0}},                     --41o
{{500,cmd.SCREENHEIGTH/2,0,3,0,0,1},{-200,200,100000,2,4000000,0,0}},                     --42o
{{450,cmd.SCREENHEIGTH/2,0,2,0,0,1},{-200,200,100000,2,4000000,0,0}},                     --43o
--左右圈大鱼43，44
{{1020,cmd.SCREENHEIGTH/2,0,0,0,0,1},{-200,200,100000,2,4000000,0,1}},                    --44o
{{380,cmd.SCREENHEIGTH/2,0,0,0,0,0},{-200,200,100000,2,4000000,0,0}},                     --45o
--横排出现的鱼45，46，47
{{1350,cmd.SCREENHEIGTH/2-150,90,2,4000000,0,1},{-200,200,100000,2,4000000,0,0}},         --46o
{{1350,cmd.SCREENHEIGTH/2+150,90,2,4000000,0,1},{-200,200,100000,2,4000000,0,0}},         --47o
{{1350,cmd.SCREENHEIGTH/2,90,2,4000000,0,1},{-200,200,100000,2,4000000,0,0}},             --48o

}

-----------------------------------------------------------------------------------------------

--print("********************************************************load cmd");
return cmd