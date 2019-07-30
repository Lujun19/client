local cmd = {}
cmd.VERSION 					= appdf.VersionValue(6,7,0,1)--游戏版本
cmd.KIND_ID						= 409	--游戏标识
cmd.GAME_PLAYER					= 5     --游戏人数
cmd.SERVER_LEN					= 32    --房间名长度
cmd.RECORD_LEN					= 5     --游戏记录长度
cmd.MY_VIEWID					= 3     --视图位置
cmd.GAME_SCENE_FREE             = 0     --状态定义
cmd.GAME_SCENE_PLAY             = 100   --等待开始
--命令定义
cmd.SUB_S_GAME_START            = 100     -- 游戏开始          
cmd.SUB_S_ADD_SCORE             = 101     -- 用户加注
cmd.SUB_S_GIVE_UP               = 102     -- 用户放弃      
cmd.SUB_S_SEND_CARD             = 103     -- 发送扑克             
cmd.SUB_S_GAME_END              = 104     -- 游戏结束             
cmd.SUB_S_GET_WINNER            = 105                
cmd.SUB_S_TRUE_END              = 106     -- 获取信息           
cmd.SUB_S_LOOKCARD              = 110     --服务端返回客户端的看牌消息 结构体里包含玩家看牌情况
--结束消息--****************定时器标识******************--
cmd.IDI_START_GAME              = 200     -- 开始定时器
cmd.IDI_USER_ADD_SCORE          = 201     -- 加注定时器
cmd.IDI_USER_COMPARE_CARD       = 202     -- 选比牌用户定时器
cmd.IDI_DISABLE                 = 203     -- 过滤定时器
--*****************时间标识*****************--
cmd.TIME_START_GAME             = 30      -- 开始定时器
cmd.TIME_USER_ADD_SCORE         = 30      -- 加注定时器
cmd.TIME_USER_COMPARE_CARD      = 30      -- 比牌定时器

cmd.ZHU_MA = {1,5,10,20}
--空闲状态
cmd.CMD_S_SatatusFree   ={    
     {k="lCellScore",t="int"},                             -- 基础积分                           
     {k="lTurnScore",t="score",l={cmd.GAME_PLAYER}},       -- 积分信息      
     {k="lCollectScore",t="score",l={cmd.GAME_PLAYER}},    -- 积分信息     
     {k="lRobotScoreMin",t="score"},                       -- 积分低于取款                    
     {k="lRobotScoreMax",t="score"},                       -- 积分高于存款               
     {k="lRobotBankTake",t="score",l={2}},                 -- 取款额度                
     {k="lRobotBankSave",t="score"},                       -- 存款额度                   
     {k="lAddScore1",t="score"},
     {k="lAddScore2",t="score"},
     {k="lAddScore3",t="score"},
     {k="lAddScore4",t="score"}
}
--游戏状态
cmd.CMD_S_SatatusPlay   =
{    
    {k="lCellScore",    t="int"},                                     -- 基础积分                         
    {k="lServiceCharge",t="int"},                                     -- 服务费                       
    {k="lDrawMaxScore", t="score"},                                   -- 最大下注                      
    {k="lTurnMaxScore", t="score"},                                   -- 最大下注                      
    {k="lTurnLessScore",t="score"},                                   -- 最小下注                   
    {k="lUserScore",    t="score",l={cmd.GAME_PLAYER}},               -- 用户下注   
    {k="lTableScore",   t="score",l={cmd.GAME_PLAYER}},               -- 桌面下注    
    {k="cbShowHand",    t="byte"},                                    -- 梭哈标志                         
    {k="wCurrentUser",  t="word"},                                    -- 当前玩家                      
    {k="cbPlayStatus",  t="byte",l={cmd.GAME_PLAYER}},                -- 游戏状态      
    {k="cbCardCount",   t="byte",l={cmd.GAME_PLAYER}},                -- 扑克数目     
    {k="cbHandCardData",t="byte",l={cmd.GAME_PLAYER,cmd.GAME_PLAYER}},-- 桌面扑克 
    {k="lTurnScore",    t="score",l={cmd.GAME_PLAYER}},               -- 积分信息       
    {k="lCollectScore", t="score",l={cmd.GAME_PLAYER}},               -- 积分信息 
    {k="lRobotScoreMin",t="score"},                                   -- 积分低于取款                    
    {k="lRobotScoreMax",t="score"},                                   -- 积分高于存款                     
    {k="lRobotBankTake",t="score",l={2}},                             -- 取款额度             
    {k="lRobotBankSave",t="score"},                                   -- 存款额度                     
    {k="lAddScore1",    t="score"},
    {k="lAddScore2",    t="score"},
    {k="lAddScore3",    t="score"},
    {k="lAddScore4",    t="score"}
}
--游戏开始
cmd.CMD_S_GAMEStart =
{    
{k="lCellScore",t="int"},                                          --单位下注                          
{k="lServiceCharge",t="int"},                                      --服务费                    
{k="lDrawMaxScore",t="score"},                                     --最大下注                     
{k="lTurnMaxScore",t="score"},                                     --最大下注                      
{k="lTurnLessScore",t="score"},                                    --最小下注                   
{k="lAddScore1",t="score"},
{k="lAddScore2",t="score"},
{k="lAddScore3",t="score"},
{k="lAddScore4",t="score"}, 
{k="wCurrentUser",t="word"},                                       --当前玩家                       
{k="cbObscureCard",t="byte"},                                      --底牌扑克                   
{k="cbCardData",t="byte",l={cmd.GAME_PLAYER}},                     --用户扑克    
{k="cbHandCardData",t="byte",l={cmd.GAME_PLAYER,cmd.GAME_PLAYER}}, --用户扑克
{k="lStorageMin",t="score"},
{k="lStorageMax",t="score"},
{k="lCurrentStorage",t="score"}

}
--用户放弃
cmd.CMD_S_GiveUp    =
{    {k="wGiveUpUser",t="word"},                         --放弃用户    
     {k="wCurrentUser",t="word"},                        --当前用户    
     {k="lDrawMaxScore",t="score"},                      --最大下注    
     {k="lTurnMaxScore",t="score"}                       --最大下注
}--用户下注

cmd.CMD_S_AddScore  =
{    {k="wCurrentUser",t="word"},                        --当前用户    
     {k="wAddScoreUser",t="word"},                       --加注用户    
     {k="lTurnLessScore",t="score"},                     --最少加注    
     {k="lUserScoreCount",t="score"},                    --加注数目
}
--发送扑克
cmd.CMD_S_SendScore  =
{     
      {k="wCurrentUser",t="word"},                                                       -- 当前用户    
      {k="wStartChairID",t="word"},                                                      -- 开始用户    
      {k="lTurnMaxScore",t="score"},                                                     -- 最大下注
      {k="cbSendCardCount",t="byte"},                                                    -- 发牌数目    
      {k="cbCardData",t="byte",l={cmd.GAME_PLAYER,cmd.GAME_PLAYER,cmd.GAME_PLAYER}}      -- 发牌数目
}
--游戏结束
cmd.CMD_S_GameEnd    =
{    
     {k="cbCardData",t="byte",l={cmd.GAME_PLAYER}},      --用户扑克
     {k="lGameScore",t="score",l={cmd.GAME_PLAYER}}      --游戏积分
                         
}--获取赢家

cmd.CMD_S_GetWinner =
{    
   {k="wOrderCount",t="word"},                         --玩家数    
   {k="wChairOrder",t="word",l={GAME_PLAYER}}          --玩家名次
}

cmd.SUB_C_GIVE_UP               = 1                     --用户放弃
cmd.SUB_C_ADD_SCORE             = 2                     --用户加注
cmd.SUB_C_GET_WINNER            = 3                     --获取信息
cmd.SUB_C_ADD_SCORE_TIME        = 4                     --完成动画--用户加注
cmd.SUB_C_LOOK_CARD             = 7                     --查看看牌情况

cmd.CMD_S_LookCard=
{ 
  {k="bLook",t="bool",l={cmd.GAME_PLAYER}}              
}

cmd.CMD_C_AddScore  =
{
    {k="lScore",t="score"}
}

cmd.RES_PATH 					= 	"game/yule/twohkstylefive/res/"

return cmd