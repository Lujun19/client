--
-- Author: garry
-- Date: 2017-2-23
--
local GameModel = appdf.req(appdf.CLIENT_SRC.."gamemodel.GameModel")
local GameLayer = class("GameLayer", GameModel)

local module_pre = "game.yule.duobao.src";
require("cocos.init")
local ExternalFun =  appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local cmd = module_pre .. ".models.cmd_game"
local game_cmd = appdf.HEADER_SRC .. "CMD_GameServer"

local DuobaoLayer  = module_pre..".views.layer.DuobaoLayer"
local JiesuanLayer  = module_pre..".views.layer.JiesuanLayer"

local GameViewLayer = appdf.req(module_pre .. ".views.layer.GameViewLayer")
local QueryDialog   = require("app.views.layer.other.QueryDialog")
local g_var = ExternalFun.req_var
local GameFrame = appdf.req(module_pre .. ".models.GameFrame")

function GameLayer:ctor( frameEngine,scene )
    ExternalFun.registerNodeEvent(self)
    

    self.rankNum = g_var(cmd).GEM_FIRST
    self.gameTable = {}
    self.gemTopTable = {}
    self.gemBottomTable = {}

    self._dataModle = GameFrame:create()    
    GameLayer.super.ctor(self,frameEngine,scene)
    self._roomRule = self._gameFrame._dwServerRule

   

    
end

--创建场景
function GameLayer:CreateView()
     self._gameView = GameViewLayer:create(self)
     self:addChild(self._gameView)
     return self._gameView
end



function GameLayer:getParentNode( )
    return self._scene
end

function GameLayer:sendNetData( cmddata )
    return self:getFrame():sendSocketData(cmddata)
end

function GameLayer:getDataMgr( )
    return self._dataModle
end

function GameLayer:getFrame( )
    return self._gameFrame
end

function GameLayer:onExit()
    print("gameLayer onExit()...................................")
    self:KillGameClock()
    self:dismissPopWait()
    self._gameView:onExit()
end

--退出桌子
function GameLayer:onExitTable(flag)
    self:KillGameClock()
    self:showPopWait()

    local MeItem = self:GetMeUserItem()
    if MeItem and MeItem.cbUserStatus > yl.US_FREE then
        self:runAction(cc.Sequence:create(
            cc.DelayTime:create(0.3),
            cc.CallFunc:create(
                function ()   
                    self._gameFrame:StandUp(1)
                end
                ),
            cc.DelayTime:create(10),
            cc.CallFunc:create(
                function ()
                    --强制离开游戏(针对长时间收不到服务器消息的情况)
                    print("delay leave")
                    self:onExitRoom(flag)
                end
                )
            )
        )
        return
    end

   self:onExitRoom(flag)
end

--离开房间
function GameLayer:onExitRoom(flag)

    --local dataBuffer = CCmd_Data:create(4)
    --dataBuffer:pushint(flag == nil and false or flag)
    --self:SendData(g_var(cmd).SUB_C_EXIT,dataBuffer)

    print("onExitRoom")
    
    self:getFrame():onCloseSocket()

    self._scene:onKeyBack()   
    
end


function GameLayer:OnEventGameClockInfo(chair,clocktime,clockID)
    if nil ~= self._gameView  and self._gameView.UpdataClockTime then
        self._gameView:UpdataClockTime(chair,clocktime)
    end
end

-- 设置计时器
function GameLayer:SetGameClock(chair,id,time)

    if time < 0 then
       return
    end

    self:KillGameClock()

    GameLayer.super.SetGameClock(self,chair,id,time)

     if nil ~= self._gameView  and self._gameView.setClockView then
        self._gameView:setClockView(chair,time)
     end
end

function GameLayer:OnResetGameEngine()
    print("OnResetGameEngine")
    self._gameView.againFlag = true
    GameLayer.super.OnResetGameEngine(self)
end




--------------------------------------------------------------------------------------------------------------------------
--场景消息
function GameLayer:onEventGameScene(cbGameStatus,dataBuffer)

    print("111the buffer len is ========================= >"..dataBuffer:getlen())
    print("场景数据:" .. cbGameStatus)
    if self._gameView.againFlag then
        self._gameView.againFlag = false
        self.m_cbGameStatus = cbGameStatus
        if cbGameStatus == g_var(cmd).GS_GAME_FREE  then                        --空闲状态
            self:onEventGameSceneFree(dataBuffer);
        elseif cbGameStatus == g_var(cmd).GS_GAME_STATUS then                 
            self:onEventGameSceneStatus(dataBuffer);
        end
        
    end
    
    self:dismissPopWait()
    self:SendUserReady()
end

function GameLayer:onEventGameSceneFree(buffer)    --空闲 

    local cmd_table = ExternalFun.read_netdata(g_var(cmd).CMD_S_STATUS, buffer)
    dump(cmd_table, "the status data is ================== >    ", 6)

    self:initGameSceneData(cmd_table)
    self._gameView.firstRank = true

    
end

function GameLayer:onEventGameSceneStatus(buffer)  

print("the buffer len is  =============== >Play")

   local cmd_table = ExternalFun.read_netdata(g_var(cmd).CMD_S_STATUS, buffer)
    dump(cmd_table, "the status data is ================== >    ", 6)

   self:initGameSceneData(cmd_table)
    
end


function GameLayer:initGameSceneData(cmd_table)

    self._gameView.gameData.cellScore = cmd_table.nCellScore
    self._gameView.gameData.lineGold = cmd_table.nLineNumber
    self._gameView.gameData.lineNumber = cmd_table.nLineCount
    self._gameView.gameData.zuanNumber = cmd_table.nAiguilleCount
    self._gameView.gameData.rankNumber = cmd_table.nLevelsNumber
    self._gameView.gameData.boomCount = cmd_table.nBoomCount
    self._gameView.gameData.isIndiana = cmd_table.bPlayIndiana
    self._gameView.gameData.indianaIndex = cmd_table.nIndianaIndex
    self._gameView.gameData.indianaScore = cmd_table.lIndianaScore
    
    self._gameView.gameData.kuncunNumber = cmd_table.lStorageStart
    self._gameView.gameData.centreGem = cmd_table.nGemCentreIndex
    self._gameView.gameData.bottomGem = cmd_table.nGemBottomIndex
    self._gameView.gameData.exchange = cmd_table.nExchange and cmd_table.nExchange or 1  --通用的没有此数据，客户定制的有
    print("fffffffffffffffff,"..self._gameView.gameData.exchange)

    self._gameView.gameData.playScore = cmd_table.lPlayScore

    self._gameView.gameData.playWinScore = cmd_table.lPlayWinLose

    self._gameView.gameData.showWinScore = cmd_table.lPlayShowWinLose
    self._gameView.gameData.maxLineCount = cmd_table.nMaxLineCount
    self._gameView.gameData.lineTimes = cmd_table.lLineTimes

    self.rankNum = self._gameView.gameData.rankNumber +3


   -- local str = "nCellScore = "..cmd_table.nCellScore..",nLineNumber="..cmd_table.nLineNumber..",nLineCount="..cmd_table.nLineCount..
          --  ",nAiguilleCount = "..cmd_table.nAiguilleCount..",nLevelsNumber="..cmd_table.nLevelsNumber..",nBoomCount="..cmd_table.nBoomCount..
          --  ",nIndianaIndex = "..cmd_table.nIndianaIndex..",lPlayScore = "..cmd_table.lPlayScore..",cmd_table.lPlayWinLose = "..cmd_table.lPlayWinLose..
          --  ",lPlayShowWinLose = "..cmd_table.lPlayShowWinLose..",lStorageStart = "..cmd_table.lStorageStart..",nExchange = "..cmd_table.nExchange
    --dump(cmd_table, "the free data is ============ >", 6)


    --print("PlaygameData = "..str)
         self._gameView:updateView()
         self._gameView:updatePosition()
         self._gameView:updateZuantou()

    if not self._gameView.gameData.isIndiana and 4==self._gameView.gameData.rankNumber then
          local duobaoLayer = g_var(DuobaoLayer):create(self)
            duobaoLayer:initData(self._gameView.gameData.indianaScore[1],cmd_table.nIndianaIndex)
            self._gameView:addChild(duobaoLayer)

    end

    --[[
        local jiesuan = g_var(JiesuanLayer):create(self)

        jiesuan:initData(1,1)

        self:addChild(jiesuan)]]
end

---------------------------------------------------------------------------------------游戏消息
function GameLayer:onEventGameMessage(sub,dataBuffer)  

    if  nil == self._gameView then
        return
    end 

    if sub == g_var(cmd).SUB_S_GEM then 
        
        self:OnSubGetGem(dataBuffer)

    elseif sub == g_var(cmd).SUB_S_LEVEL_CHANGE then

        self:OnSubLevelChange(dataBuffer)

    elseif sub == g_var(cmd).SUB_S_INDIANA then

      local cmd_table = ExternalFun.read_netdata(g_var(cmd).CMD_S_INDIANA, dataBuffer)

        local duobaoLayer = g_var(DuobaoLayer):create(self)
        duobaoLayer:initData(cmd_table.lIndianaScores[1],cmd_table.nIndianaIndex)
        self:addChild(duobaoLayer)


    elseif sub == g_var(cmd).SUB_S_GAME_OVER then
      local cmd_table = ExternalFun.read_netdata(g_var(cmd).CMD_S_GAMEOVER, dataBuffer)

      local jiesuan = g_var(JiesuanLayer):create(self)

        jiesuan:initData(cmd_table.lPlayScores,cmd_table.lOverScores)

      

       -- jiesuan:initData(1,2)
        --print("lPlayScores. = "..cmd_table.lPlayScores..",lOverScores = "..cmd_table.lOverScores)

        --print("playScore. = "..self._gameView.gameData.playScore..",showWinScore = "..self._gameView.gameData.showWinScore)

        self._gameView.gameData.playScore = cmd_table.lPlayScores

        self._gameView.gameData.showWinScore = cmd_table.lOverScores

        self._gameView:updateScore()

        self:addChild(jiesuan)

        self:SendUserReady()


    elseif sub == g_var(cmd).SUB_S_BET_FAIL then
        print("SUB_S_BET_FAIL==============================>")
      local cmd_table = ExternalFun.read_netdata(g_var(cmd).CMD_S_BETFAIL, dataBuffer)

        
        self._gameView:onGameMessageBetFail(cmd_table)

    elseif sub == g_var(cmd).SUB_S_WIN_INFO then
        print("SUB_S_WIN_INFO==============================>")
        local cmd_table = ExternalFun.read_netdata(g_var(cmd).CMD_S_WININFO, dataBuffer)
        --dump(cmd_table, "6666666666666666", 6)
        --error("000000",0)
        self._gameView:addGongGao(clone(cmd_table),1)

    elseif sub == g_var(cmd).SUB_S_STORAGE then
      --print("SUB_S_STORAGE==============================>")

      local cmd_table = ExternalFun.read_netdata(g_var(cmd).CMD_S_STORAGE, dataBuffer)

        self._gameView:onGameMessageUpdateStorage(cmd_table.lStorageStart*self._gameView.gameData.exchange)

    elseif sub == g_var(cmd).SUB_S_CONTROL then

    elseif sub == g_var(cmd).SUB_S_CAI_JING_INFO then
      print("SUB_S_CAI_JING_INFO==============================>")
        local cmd_table = ExternalFun.read_netdata(g_var(cmd).CMD_S_CANJIN, dataBuffer)

        self._gameView:addGongGao(clone(cmd_table),2)

    else
        print("unknow gamemessage sub is ==>"..sub)
    end
end

function GameLayer:OnSubGetGem( dataBuffer )
    
     local cmd_table = ExternalFun.read_netdata(g_var(cmd).CMD_S_GEM, dataBuffer)

     print("cmd_table.nGemABeginX = "..cmd_table.nGemABeginX)
     print("cmd_table.nGemAEndX = "..cmd_table.nGemAEndX)
     print("cmd_table.nGemABeginY = "..cmd_table.nGemABeginY)
     print("cmd_table.nGemAEndY = "..cmd_table.nGemAEndY)

     self._gameView.gemGetFlag = false
     self.gemTopTable = {}
     self.gemBottomTable = {}
      
      for i=1,g_var(cmd).GEM_MAX do
        if i >= cmd_table.nGemABeginX +1  and i <= cmd_table.nGemAEndX+1  then
            self.gemTopTable[i-cmd_table.nGemABeginX] = cmd_table.nGemCentreIndex[1][i]
        end
        
        if i >= cmd_table.nGemABeginY +1  and i <= cmd_table.nGemAEndY+1  then     
            --self.gemBottomTable[i-cmd_table.nGemABeginX] = {}
            
              for j=1,g_var(cmd).GEM_MAX  do
                  if j >= cmd_table.nGemABeginX +1 and j <= cmd_table.nGemAEndX+1  then
                    
                    self.gemBottomTable[j-cmd_table.nGemABeginX+(i-1)*self.rankNum]= cmd_table.nGemBottomIndex[j][i]   
                    --self.gemBottomTable[1][1] = cmd_table.nGemBottomIndex[i][j] 
                  end
                  
              end
              
         end
         
         local str11 = ""
         for n = 1,g_var(cmd).GEM_MAX  do
                str11 = str11..","..cmd_table.nGemBottomIndex[i][n]
         end
         print("kkkkkkkkk = "..str11)
      end


     local str1 = ""
      local str2 = ""
     for i=1,#self.gemTopTable do
        str1 = str1..","..self.gemTopTable[i]
        str2 = str2..","..cmd_table.nGemCentreIndex[1][cmd_table.nGemABeginX +i]
     end
     print("nGemCentreIndex = "..str1)
     print("cmd_table.nGemCentreIndex= "..str2)


     local str2 = ""

     for i=1,#self.gemBottomTable do

         str2 = str2 ..","..self.gemBottomTable[i]
        
        
     end
     print("nGemBottomIndex = "..str2)
     if not self._gameView.showLevelFlag then
        self._gameView:updateGem()
     end
end

function GameLayer:OnSubLevelChange(dataBuffer)
  print("pppppppppppppppppppppppp")
    local cmd_table = ExternalFun.read_netdata(g_var(cmd).CMD_S_LEVEL_CHANGE, dataBuffer)
    self.rankNum = cmd_table.nGemLevelsNumber +3
    self._gameView:updateLevel()

end






return GameLayer