--
-- Author: Tang
-- Date: 2016-12-08 15:41:53
--
local GameViewLayer = class("GameViewLayer",function(scene)
		local gameViewLayer =  display.newLayer()
    return gameViewLayer
end)
local module_pre = "game.qipai.thirteenx.src"
local RES_PATH = "game/qipai/thirteenx/res/"

local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local ClipText = appdf.req(appdf.EXTERNAL_SRC .. "ClipText")
local PopupInfoHead = appdf.req(appdf.EXTERNAL_SRC .. "PopupInfoHead")
local CardSprite = appdf.req(module_pre..".views.layer.CardSprite")
local SelectNode = appdf.req(module_pre..".views.layer.SelectNode")
local PokerNormal = appdf.req(module_pre..".views.layer.PokerNormal")
local GameLogic = appdf.req(module_pre..".models.GameLogic")
local cmd = appdf.req(module_pre..".models.cmd_game")
local GameChatLayer = appdf.req(appdf.CLIENT_SRC.."plaza.views.layer.game.GameChatLayer")
local AnimationMgr = appdf.req(appdf.EXTERNAL_SRC .. "AnimationMgr")
require(module_pre..".views.layer.PokerUtils")
require(module_pre..".views.layer.Adaptive")
local QueryDialog   = appdf.req("app.views.layer.other.QueryDialog")
GameViewLayer.Enum =
{
   COLOR_BTN       = 1,
   COLOR_SELECT_OK = 6,
   READY_BTN       = 7,
   CLOCK           = 8,
   MENU            = 9,   --菜单
   MENU_CHAT       = 10,  --聊天
   MENU_HELP       = 11,  --帮助
   MENU_SET        = 12,  --设置
   MENU_TRUSTTEE   = 13,  --托管
   MENU_QUIT       = 14,  --退出
   PLAYER_CARD     = 100,
   SET_VIEW        = 200,
   CHAT_VIEW       = 1001, --聊天
   SWITCH_BTN      = 15
}

local TAG = GameViewLayer.Enum
GameViewLayer.TopZorder = 30
GameViewLayer.MenuZorder = 20
GameViewLayer.SelectZorder = 21
GameViewLayer.TipsZorder = 35

local seatpos = {cc.p(100,90),cc.p(800,350),cc.p(420,220),cc.p(160,350)}
local scorecell = {100, 1000, 10000, 100000}
local goldnum = {12, 13, 15, 15, 15 }

--飞出多少金币
function GameViewLayer:getgoldnum(score)
  local cellvalue = 1
  for i=1,4 do
    if score > scorecell[i] then
      cellvalue = i + 1
    end
  end
  return goldnum[cellvalue]
end


function GameViewLayer:priGameLayerZorder()
    return GameViewLayer.MenuZorder
end

function GameViewLayer:ctor(scene)

  self._scene = scene
  self._userList = {}
  self._bMenu = false
  self._bTrustTee = false

  self._bSound = GlobalUserItem.bSoundAble
  self._bMusic = GlobalUserItem.bVoiceAble

  --是否发牌完成
  self._bComSend = false
  --是否获取推荐数据
  self._bGetTypeData = false
  --牌组
  self._CardList = {{},{},{},{}}

  --金币数
  self._goldlist = {}
  --头像位置
  self._seatposlist = {}

  self:gameDataInit()
  --导入资源
  self:loadRes()
  --初始化csb界面
  self:initCsbRes()

  --注册事件
  --注册node事件
  ExternalFun.registerNodeEvent(self)

  ExternalFun.playBackgroudAudio("music_game.mp3")

end

function GameViewLayer:onExit()
  self:gameDataReset()
  self.m_actTip:release()
  self.m_actTip = nil
  self.m_actVoiceAni:release()
  self.m_actVoiceAni = nil
end

function GameViewLayer:resetData()
    self._bTrustTee = false
end

function GameViewLayer:loadRes( )
  cc.Director:getInstance():getTextureCache():addImage("game_res/card_b.png")
  -- 语音动画
  AnimationMgr.loadAnimationFromFrame("record_play_ani_%d.png", 1, 3, cmd.VOICE_ANIMATION_KEY)

  --手枪动画初始化
  self:initGame()
end

function GameViewLayer:unLoadRes()
  cc.Director:getInstance():getTextureCache():removeTextureForKey("game_res/card_b.png")
  AnimationMgr.removeCachedAnimation(cmd.VOICE_ANIMATION_KEY)
   --移除动画缓存
  cc.AnimationCache:getInstance():removeAnimation("gun_anim")

  cc.AnimationCache:getInstance():removeAnimation("TrustTee")

  cc.Director:getInstance():getTextureCache():removeUnusedTextures()
  cc.SpriteFrameCache:getInstance():removeUnusedSpriteFrames()

end
function GameViewLayer:gameDataInit(  )

    --搜索路径
    -- local gameList = self:getParentNode():getParentNode():getApp()._gameList;
    -- local gameInfo = {};
    -- for k,v in pairs(gameList) do
    --     if tonumber(v._KindID) == tonumber(cmd.KIND_ID) then
    --         gameInfo = v;
    --         break;
    --     end
    -- end
		--
    -- if nil ~= gameInfo._Module then
    -- 	self._searchPath = device.writablePath.."game/" .. gameInfo._Module .. "/res/";
    --   cc.FileUtils:getInstance():addSearchPath(self._searchPath);
    -- end

		self._searchPath = device.writablePath.."game/qipai/thirteenx/res/";
		cc.FileUtils:getInstance():addSearchPath(self._searchPath);
end

function GameViewLayer:OnUpdateUserStatus(viewId)
	-- local roleItem = self.m_tabUserHead[viewId]
	-- if nil ~= roleItem then
	-- 	roleItem:removeFromParent()
	-- 	self.m_tabUserHead[viewId] = nil
	-- end
	-- self.m_tab_head_info[viewId]:setVisible(false)
	-- self.m_tabReadySp[viewId]:setVisible(false)
	-- self.m_tabStateSp[viewId]:setSpriteFrame("blank.png")
end

function GameViewLayer:gameDataReset()

  --播放大厅背景音乐
  self.m_bMusic = false
  AudioEngine.stopMusic()
  ExternalFun.playPlazzBackgroudAudio()

  self:unLoadRes()

  --重置搜索路径
  local oldPaths = cc.FileUtils:getInstance():getSearchPaths()
  local newPaths = {};
  for k,v in pairs(oldPaths) do
    if tostring(v) ~= tostring(self._searchPath) then
      table.insert(newPaths, v);
    end
  end
  cc.FileUtils:getInstance():setSearchPaths(newPaths)
end

function GameViewLayer:initCsbRes()
    local _meusbt = ccui.Button:create()
    _meusbt:setScale9Enabled(true)
    _meusbt:setContentSize(yl.WIDTH, yl.HEIGHT)
    _meusbt:setPosition(yl.WIDTH/2, yl.HEIGHT/2)
    _meusbt:addTouchEventListener(function(sender,eventType)
      if eventType == ccui.TouchEventType.ended then
        if self._bMenu == true then
          self._bMenu = false
          self._menus:stopAllActions()
          self._menus:runAction(cc.MoveTo:create(0.2, cc.p(1233, 1065)))
        end
      end
    end)
    self:addChild(_meusbt)

    local rootLayer, csbNode = ExternalFun.loadRootCSB("game_res/Game.csb",self)
    self._rootNode = csbNode
    local selfHeadBg=self._rootNode:getChildByName(string.format("user_%d",1))
    selfHeadBg:setPosition(100,selfHeadBg:getPositionY())

    self.b_check=false
    local mypanel=self._rootNode:getChildByName(string.format("Panel_card_1"))
    local checkfun=function(sender,eventType)
      if eventType == ccui.TouchEventType.ended then
            AudioEngine.playEffect(cc.FileUtils:getInstance():fullPathForFilename("sound_res/select.mp3"), false)
          --if b_check then
            print(self.b_check)
          --else
            for j=1,cmd.HAND_CARD_COUNT do
            card = self._CardList[1][j]
            card:showCardBack(self.b_check)
            card:updateSprite()
            end
          --end
          self.b_check=not self.b_check
      end
    end
    self.checkCard=ccui.Button:create("","")
    self.checkCard:setPosition(mypanel:getPositionX()+200,mypanel:getPositionY()+100)
    self.checkCard:addTouchEventListener(checkfun)
    self.checkCard:setScale9Enabled(true)
    self.checkCard:setContentSize(cc.size(300, 350))
    self.checkCard:hide()
    self:addChild( self.checkCard)
    local checkLable= cc.Label:createWithTTF("点击查看", "fonts/round_body.ttf", 25)
        :enableShadow(cc.c4b(0,0,0,128),cc.size(2,-2))
        :enableOutline(cc.c3b(255,255,255),2)
        :setTextColor(cc.c3b(79,79,79))
        :move(self.checkCard:getContentSize().width/2-15,70)
        :addTo(self.checkCard)
        :setAnchorPoint(0.5,0.5)

    self:initButtonEvent()
    self:gameClean()

    self:showUserInfo(self._scene:GetMeUserItem())

    for i=1,cmd.GAME_PLAYER do
      local panelCard = self._rootNode:getChildByName(string.format("Panel_card_%d",i))
      for j=1, cmd.HAND_CARD_COUNT do
        local pcard = CardSprite:createCard()
        pcard:setVisible(false)
        panelCard:addChild(pcard)
        pcard:setLocalZOrder(j)
        table.insert(self._CardList[i], pcard)
        pcard:setPosition(45+18*(j-1), panelCard:getContentSize().height/2)
      end

      local lightbg = self._rootNode:getChildByName(string.format("im_headbg_light_%d",i))
      if i==1 then lightbg:setPosition(100,lightbg:getPositionY()) end
      lightbg:setVisible(false)
      local posx, posy = lightbg:getPosition()
      table.insert(self._seatposlist, cc.p(posx, posy))
    end

    --倒计时
    self._clockTime = csbNode:getChildByName("time_clock")
    self._clockTime:setPosition(self._clockTime:getPositionX(), self._clockTime:getPositionY() + 50)
    self._clockTime:setString("30")
    self:setClockVisible(false)

    self.currentType=1

end

function GameViewLayer:switchTypeBtn(obj)
    local switchTypeBtn=ccui.Button:create(self.currentType==1 and "game_res/automatic.png" or "game_res/manual.png",self.currentType==1 and "" or "")
    local pos=self.currentType==1 and cc.p(yl.WIDTH-90, 65) or cc.p(150,yl.HEIGHT-65)
    switchTypeBtn:setPosition(pos)
    switchTypeBtn:setTag(TAG.SWITCH_BTN)
    switchTypeBtn:addTo(obj)
    --switchTypeBtn:hide()
    switchTypeBtn:addTouchEventListener(handler(self, self.onEvent))
end

function GameViewLayer:initGame()

  --托管动画
  local frames = {}
  for j=1,2 do
    local frame = cc.SpriteFrame:create("game_res/".."ico_robot"..string.format("_%d.png", j-1),cc.rect(0,0,39,45))
    table.insert(frames, frame)
  end
  local animation =cc.Animation:createWithSpriteFrames(frames,0.2)
  cc.AnimationCache:getInstance():addAnimation(animation, "TrustTee")


  --开枪动画
  local function getAnimation()
    local frames = {}
    for j=1,2 do
      local frame = cc.SpriteFrame:create("game_res/gun/"..string.format("im_gun_0.png", j),cc.rect(0,0,389,271))
      table.insert(frames, frame)
    end

    --停留在第一帧
    local index = 1
    local frame = cc.SpriteFrame:create("game_res/gun/"..string.format("im_gun_%d.png", index),cc.rect(0,0,389,271))
    table.insert(frames, frame)

    local animation =cc.Animation:createWithSpriteFrames(frames,0.1)
    cc.AnimationCache:getInstance():addAnimation(animation, "gun_anim")
  end

  -- 聊天动画
  local sc = cc.ScaleTo:create(0.1, 1.0, 1.0)
  local show = cc.Show:create()
  local spa = cc.Spawn:create(sc, show)
  self.m_actTip = cc.Sequence:create(spa, cc.DelayTime:create(2.0), cc.ScaleTo:create(0.1, 0.00001, 1.0), cc.Hide:create())
  self.m_actTip:retain()

  -- 语音动画
  local param = AnimationMgr.getAnimationParam()
  param.m_fDelay = 0.1
  param.m_strName = cmd.VOICE_ANIMATION_KEY
  local animate = AnimationMgr.getAnimate(param)
  self.m_actVoiceAni = cc.RepeatForever:create(animate)
  self.m_actVoiceAni:retain()

  --动画缓存
  getAnimation()
end

function GameViewLayer:getParentNode()
  return self._scene
end

function GameViewLayer:getDataMgr( )
  return self:getParentNode():getDataMgr()
end

function GameViewLayer:showPopWait( )
  self:getParentNode():showPopWait()
end

function GameViewLayer:showReadyBtn(isShow)
  local btn = self._rootNode:getChildByName("btn_ready")
  btn:setVisible(isShow)
end

--初始化按钮
function GameViewLayer:initButtonEvent()
  --准备
  local btn = self._rootNode:getChildByName("btn_ready")
  btn:setTag(TAG.READY_BTN)
  btn:setPosition(btn:getPositionX(), btn:getPositionY() + 50)
  btn:addTouchEventListener(handler(self, self.onEvent))

  --游戏菜单项
  btn = self._rootNode:getChildByName("bt_menu")
  btn:setTag(TAG.MENU)
  btn:addTouchEventListener(handler(self, self.onEvent))

  --菜单栏
  self._menus = self._rootNode:getChildByName("bt_menu_bg")
  self._menus:setPositionY(1065)

  --聊天
  btn = self._menus:getChildByName("bt_chat")
  btn:setTag(TAG.MENU_CHAT)
  btn:addTouchEventListener(handler(self, self.onEvent))

  --帮助
  btn = self._menus:getChildByName("bt_help")
  btn:setTag(TAG.MENU_HELP)
  btn:addTouchEventListener(handler(self, self.onEvent))

  --托管
  btn = self._menus:getChildByName("bt_robot")
  btn:setTag(TAG.MENU_TRUSTTEE)
  btn:addTouchEventListener(handler(self, self.onEvent))
  if PriRoom and GlobalUserItem.bPrivateRoom then
    btn:setEnabled(false)
  end

  --设置
  btn = self._menus:getChildByName("bt_set")
  btn:setTag(TAG.MENU_SET)
  btn:addTouchEventListener(handler(self, self.onEvent))

  --退出
  btn = self._menus:getChildByName("bt_quit")
  btn:setTag(TAG.MENU_QUIT)
  btn:addTouchEventListener(handler(self, self.onEvent))

  --语音
  btn = self._rootNode:getChildByName("bt_yuyin")
  btn:setVisible(true)
  btn:addTouchEventListener(function(sender,eventType)
    if eventType == ccui.TouchEventType.began then
      self:getParentNode():getParentNode():startVoiceRecord()
    elseif eventType == ccui.TouchEventType.ended
      or eventType == ccui.TouchEventType.canceled then
      self:getParentNode():getParentNode():stopVoiceRecord()
    end
  end)

  --取消托管
  local cancelrobot = self._rootNode:getChildByName("btn_cancel_robot")
  cancelrobot:setVisible(false)
  cancelrobot:addTouchEventListener(function(sender,eventType)
      if eventType == ccui.TouchEventType.ended then
        self:canceltrusTee()
      end
    end)
end

--用户信息
function GameViewLayer:showUserInfo( useritem )

  local viewPos = self._scene:getUserIndex(useritem.wChairID)
  print("the viewPos is:"..viewPos..",the chairID is ================= >"..useritem.wChairID)
  --玩家头像
  local anr = {cc.p(0.0,0.0),cc.p(1.0,0.0),cc.p(1.0,1.0),cc.p(0.0,0.0)}

  local headBG = self._rootNode:getChildByName(string.format("user_%d",viewPos))
  headBG:setVisible(true)
  local head = PopupInfoHead:createNormal(useritem, 100)
  headBG:removeChildByTag(1)
  head:setTag(1)
  head:setAnchorPoint(cc.p(0.5,0.5))
  head:setPosition(cc.p(headBG:getContentSize().width/2,headBG:getContentSize().height/2))
  headBG:addChild(head)
  head:enableInfoPop(true,seatpos[viewPos] , anr[viewPos])
  if useritem.cbUserStatus == yl.US_OFFLINE then
    if nil ~= convertToGraySprite then
      -- 灰度图
      if nil ~= head and nil ~= head.m_head and nil ~= head.m_head.m_spRender then
        convertToGraySprite(head.m_head.m_spRender)
      end
    end
  end

  local posRecord = {user=useritem,pos=viewPos}
  for i=1,#self._userList do
    local posRecord = self._userList[i]
    if posRecord.pos == viewPos then
        table.remove(self._userList,i)
      break
    end
  end

  table.insert(self._userList,posRecord)
  local pnick = headBG:getChildByName("txt_name")

  --昵称
  local nick =  ClipText:createClipText(pnick:getContentSize(),useritem.szNickName,"fonts/round_body.ttf",18)
  headBG:removeChildByTag(2)
  nick:setTag(2)
  nick:setColor(cc.c3b(255, 255, 237))
  nick:setAnchorPoint(cc.p(0.5, 0.5))
  nick:setPosition(pnick:getPosition())
  headBG:addChild(nick)
  pnick:setVisible(false)

  --分数
  local scoreNode = headBG:getChildByName("txt_score")
  assert(scoreNode)

  local _scoreUser = 0
  if nil ~= useritem then
     _scoreUser = useritem.lScore
  end

  local str = ExternalFun.formatScoreText(_scoreUser)
  scoreNode:setString(str)

  --结算分数
  --local endscore = headBG:getChildByName("txt_end_score")
  --endscore:setVisible(false)

  --房主标识
  if PriRoom and GlobalUserItem.bPrivateRoom then
    local fanzhuicon = headBG:getChildByName("icon_fangzhu")
    if PriRoom:getInstance().m_tabPriData.dwTableOwnerUserID == useritem.dwUserID then
      self:showFangzhuIcon(self:getParentNode():getUserIndex(useritem.wChairID))
    end

    --积分场分数显示
    if PriRoom:getInstance().m_tabPriData.lIniScore ~= nil and
        PriRoom:getInstance().m_tabPriData.cbIsGoldOrGameScore == 1 then
      dump(PriRoom:getInstance().m_tabPriData, "约战房信息", 10)
     _scoreUser = _scoreUser - PriRoom:getInstance().m_tabPriData.lIniScore
     if scoreNode then
      scoreNode:setString(string.format("%d", _scoreUser))
     end
    end
  end

end

--删除用户
function GameViewLayer:deleteUserInfo(useritem)
  if useritem == self._scene:GetMeUserItem() then
    return
  end

  local userinfo = self._scene:getUserInfoByUserID(useritem.dwUserID)
  if userinfo ~= nil then
    local pos = self._scene:getUserIndex(userinfo.wChairID)
    local headBG = self._rootNode:getChildByName(string.format("user_%d",pos))
    headBG:removeChildByTag(1)
    headBG:removeChildByTag(2)
    headBG:setVisible(false)
    table.remove(self._userList,i)

    --隐藏准备按钮
    --self:showReady(i,false)
    local readyIcon = self._rootNode:getChildByName(string.format("txt_ready_%d", pos))
    if readyIcon then
      readyIcon:setVisible(false)
    end
    --隐藏牌
    local panel = self._rootNode:getChildByName(string.format("Panel_card_%d", pos))
    if panel == nil then
      return
    end
    --清除扑克牌
    if self._CardList[pos] ~= nil then
      for k,v in pairs(self._CardList[pos]) do
        v:setVisible(false)
      end
    end
    local tips = panel:getChildByName("im_tips")
    tips:setVisible(false)
    local special = panel:getChildByName("im_special")
    special:setVisible(false)
  end

  -- for i=1,#self._userList do
  --     local posRecord = self._userList[i]
  --     if posRecord.user == useritem then
  --         local headBG = self._rootNode:getChildByName(string.format("user_%d",posRecord.pos))
  --         headBG:removeChildByTag(1)
  --         headBG:removeChildByTag(2)
  --         headBG:setVisible(false)
  --         table.remove(self._userList,i)

  --         --隐藏准备按钮
  --         --self:showReady(i,false)
  --         local readyIcon = self._rootNode:getChildByName(string.format("txt_ready_%d", posRecord.pos))
  --         if readyIcon then
  --           readyIcon:setVisible(false)
  --         end
  --         --隐藏牌
  --         local panel = self._rootNode:getChildByName(string.format("Panel_card_%d", posRecord.pos))
  --         if panel == nil then
  --           break
  --         end
  --         --清除扑克牌
  --         if self._CardList[posRecord.pos] ~= nil then
  --           for k,v in pairs(self._CardList[posRecord.pos]) do
  --             v:setVisible(false)
  --           end
  --         end
  --         local tips = panel:getChildByName("im_tips")
  --         tips:setVisible(false)
  --         local special = panel:getChildByName("im_special")
  --         special:setVisible(false)
  --       break
  --     end
  -- end
end

--获取用户
function GameViewLayer:getuseritemByindex(userindex)
  for k,v in pairs(self._userList) do
    if v.pos == userindex then
      return v.user
    end
  end
  return nil
end

--刷新分数
function GameViewLayer:reFreshScore(useritem)

   local viewPos = self._scene:getUserIndex(useritem.wChairID)
   local headBG = self._rootNode:getChildByName(string.format("user_%d", viewPos))
   local scoreNode = headBG:getChildByName("txt_score")

   local _scoreUser = 0
    if nil ~= useritem then
      _scoreUser = useritem.lScore
    end

   local str = ExternalFun.formatScoreText(_scoreUser)
   if scoreNode then
      scoreNode:setString(str)
   end

   if PriRoom and GlobalUserItem.bPrivateRoom then
    if PriRoom:getInstance().m_tabPriData.lIniScore ~= nil and PriRoom:getInstance().m_tabPriData.cbIsGoldOrGameScore == 1 then
      _scoreUser = _scoreUser - PriRoom:getInstance().m_tabPriData.lIniScore
      if scoreNode then
        scoreNode:setString(string.format("%d", _scoreUser))
      end
    end
   end

end

--刷新分数
function GameViewLayer:updateScore(item)
   self:reFreshScore(item)
end

--倒计时结束处理
function GameViewLayer:LogicTimeZero()

  if self._scene.m_cbGameStatus == cmd.GS_WK_FREE then
    self._scene:onExitTable()
  else
    --if nil ~= self._selectNode then
    if PriRoom and GlobalUserItem.bPrivateRoom then

      else
        if nil ~= self._selectNode then
          self._selectNode:logicTimeZero()
      else
        if nil ~= self._PokerNormal then
          self._PokerNormal:logicTimeZero()
        end
      end
    end
  end
end

--游戏清除
function GameViewLayer:gameClean()
   for i=1,cmd.GAME_PLAYER do
      local panel = self._rootNode:getChildByName(string.format("Panel_card_%d", i))
      --清除扑克牌
      if self._CardList[i] ~= nil then
        for k,v in pairs(self._CardList[i]) do
          v:setVisible(false)
          v:showCardBack(true)
          v:retain()
          v:removeFromParent()
        end
      end

      local userbg = self._rootNode:getChildByName(string.format("user_%d", i))
      local txtscore = userbg:getChildByName("txt_end_score")
      txtscore:setVisible(false)

      local lightbg = self._rootNode:getChildByName(string.format("im_headbg_light_%d", i))
      lightbg:stopAllActions()
      lightbg:setVisible(false)

      local tips = panel:getChildByName("im_tips")
      tips:setLocalZOrder(20)
      tips:setVisible(false)
      tips:retain()
      tips:removeFromParent()

      local special = panel:getChildByName("im_special")
      special:setLocalZOrder(20)
      special:setVisible(false)
      special:retain()
      special:removeFromParent()

      panel:removeAllChildren()
      if self._CardList[i] ~= nil then
        for k,v in pairs(self._CardList[i]) do
          panel:addChild(v)
          v:release()
        end
      end
      panel:addChild(tips)
      panel:addChild(special)
      tips:release()
      special:release()

      --枪孔
      for j=1,3 do
        local hole = self._rootNode:getChildByName(string.format("hole_%d_%d", i, j-1))
        hole:setVisible(false)
      end

      --手枪
      local gun = self._rootNode:getChildByName("gun_"..string.format("%d",i))
      gun:setVisible(false)
   end

   --结算分数
   for i=1,4 do
     local cell = self._rootNode:getChildByName("im_end_cell_"..string.format("%d",i-1))
     cell:setVisible(false)
   end

   --金币移除
   for k,v in pairs(self._goldlist) do
     v:removeFromParent()
   end
   self._goldlist = {}

   if self._selectNode ~= nil  then
      self._selectNode:removeFromParent()
      self._selectNode = nil
   end
   if self._PokerNormal then
      self._PokerNormal:removeFromParent()
      self._PokerNormal = nil
   end
      self.b_check=false
      self.checkCard:hide()
   self:stopAllActions()
end

function GameViewLayer:trustTeeDeal(userIndex,bTrustee)
  local headBG = self._rootNode:getChildByName(string.format("user_%d",userIndex))
  if not headBG then
    return
  end
  headBG:removeChildByTag(10)

  if userIndex == 1 and bTrustee == false then
    self._bTrustTee = false
    local cancelrobot = self._rootNode:getChildByName("btn_cancel_robot")
    cancelrobot:setVisible(false)
  end

  if not bTrustee then
     return
  end

  local Icon = cc.Sprite:create("game_res/ico_robot_0.png")
  Icon:setTag(10)
  Icon:setAnchorPoint(cc.p(1.0,0.0))
  Icon:setPosition(cc.p(124,2))
  headBG:addChild(Icon,20)

  local animation = cc.AnimationCache:getInstance():getAnimation("TrustTee")
  local action = cc.Animate:create(animation)
  Icon:runAction(cc.RepeatForever:create(action))
end

function GameViewLayer:onEvent(sender,eventType)
  local tag = sender:getTag()

  if eventType == ccui.TouchEventType.ended  then
    if tag == TAG.READY_BTN then
        self:onStartReady(sender)
    elseif tag == TAG.MENU then   --游戏菜单
      self._bMenu = not self._bMenu
      self:showMenu()
      -- local cardtest = {25,39,23,45,12,43,26,41,61,60,59,58,53}
      -- local a, b = GameLogic:GetSpecialType(cardtest, 13)
      -- dump(b, "测试类型", 10)
      -- local dispatchInfo = {}
      -- dispatchInfo.playerIndex = {}
      -- dispatchInfo.playerCount = 4
      -- dispatchInfo.cardCount   = cmd.HAND_CARD_COUNT
      -- table.insert(dispatchInfo.playerIndex, 1)
      -- table.insert(dispatchInfo.playerIndex, 2)
      -- table.insert(dispatchInfo.playerIndex, 3)
      -- table.insert(dispatchInfo.playerIndex, 4)
      -- self:dispatchCard(dispatchInfo,true,true)
    elseif tag == TAG.MENU_HELP then     --帮助
      self._bMenu = false
      self:showMenu()
      self._scene:getParentNode():popHelpLayer2(cmd.KIND_ID, 0, 5)
    elseif tag == TAG.MENU_CHAT then     --聊天
      self._bMenu = false
      self:showMenu()
      self:showChat()
    elseif tag == TAG.MENU_SET then      --设置
      self._bMenu = false
      self:showMenu()
      self:showSet()
    elseif tag == TAG.MENU_TRUSTTEE then --托管
      self._bMenu = false
      self:showMenu()
      self:trustTee()
    elseif tag == TAG.MENU_QUIT then     --退出
      self._bMenu = false
      self:showMenu()
      self:backRoom()
    elseif tag== TAG.SWITCH_BTN then
        if self.currentType == 0 then
           self.currentType=1
        else
           self.currentType=0
        end
      self:ChooseCardType()
      print(self.currentType)
    end
  end
end

--显示菜单栏
function GameViewLayer:showMenu()
  if self._menus == nil then
    return
  end
  local btpull = self._rootNode:getChildByName("bt_menu")
    if self._bMenu == true then
        self._menus:stopAllActions()
        self._menus:runAction(cc.MoveTo:create(0.2, cc.p(1233, 402)))
    else
        self._menus:stopAllActions()
        self._menus:runAction(cc.MoveTo:create(0.2, cc.p(1233, 1065)))
    end
end

--聊天界面
function GameViewLayer:showChat()
  --聊天，调用本地资源，不用通用
  local tabconfig = {}
  tabconfig.csbfile = RES_PATH.."chat_res/GameChatLayer.csb"
  --图片要加入缓存
  local sprbg = cc.Sprite:create(RES_PATH.."chat_res/im_bg_2.png")
  if sprbg then
    cc.SpriteFrameCache:getInstance():addSpriteFrame(sprbg:getSpriteFrame(), "im_bg_2.png")
    tabconfig.szItemFrameName = "im_bg_2.png"
  end
    self._chatLayer = GameChatLayer:create(self._scene._gameFrame, tabconfig):addTo(self, GameViewLayer.TopZorder)  --聊天框
    self._chatLayer:showGameChat(true)
    self._chatLayer:setTag(TAG.CHAT_VIEW)
end

--设置界面
function GameViewLayer:showSet()
  self:removeChildByTag(TAG.SET_VIEW)

  local Mask = ccui.ImageView:create()
  Mask:setTag(TAG.SET_VIEW)
  Mask:setContentSize(cc.size(yl.WIDTH, yl.HEIGHT))
  Mask:setScale9Enabled(true)
  Mask:setPosition(yl.WIDTH/2, yl.HEIGHT/2)
  Mask:setTouchEnabled(true)
  self:addChild(Mask,GameViewLayer.TopZorder)

  Mask:addTouchEventListener(function(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        Mask:removeFromParent()
    end
  end)

 --加载CSB
  local setNode = cc.CSLoader:createNode("game_res/Set.csb");
  setNode:setPosition(yl.WIDTH/2, yl.HEIGHT/2)
  Mask:addChild(setNode)

  -- 版本号
  -- local mgr = self._scene:getParentNode():getApp():getVersionMgr()
  -- local verstr = mgr:getResVersion(7) or "0"
  -- verstr = "游戏版本:" .. appdf.BASE_C_VERSION .. "." .. verstr
  -- local txt_ver = setNode:getChildByName("txt_version")
  -- txt_ver:setString(verstr)

  --音效按钮
  local btn = setNode:getChildByName("btn_sound")
  if self._bSound  then
      btn:loadTextureNormal("game_res/set/BT_on.png")
  else
      btn:loadTextureNormal("game_res/set/BT_off.png")
  end

  btn:addTouchEventListener(function(sender,eventType)
    if eventType == ccui.TouchEventType.ended  then
        self._bSound = not self._bSound
        if self._bSound  then
          sender:loadTextureNormal("game_res/set/BT_on.png")
        else
            sender:loadTextureNormal("game_res/set/BT_off.png")
        end
        local effect = not GlobalUserItem.bSoundAble
        GlobalUserItem.setSoundAble(effect)
    end
  end)

  btn = setNode:getChildByName("btn_music")
  if self._bMusic  then
      btn:loadTextureNormal("game_res/set/BT_on.png")
  else
      btn:loadTextureNormal("game_res/set/BT_off.png")
  end
  btn:addTouchEventListener(function(sender,eventType)
    if eventType == ccui.TouchEventType.ended  then
       self._bMusic = not self._bMusic
       if self._bMusic  then
          sender:loadTextureNormal("game_res/set/BT_on.png")
       else
           sender:loadTextureNormal("game_res/set/BT_off.png")
       end
       local music = not GlobalUserItem.bVoiceAble
       GlobalUserItem.setVoiceAble(music)
      if GlobalUserItem.bVoiceAble == true then
        ExternalFun.playBackgroudAudio("music_game.mp3")
      end
    end
  end)
end

--托管
function GameViewLayer:trustTee()
  self._bTrustTee = not self._bTrustTee
  if true == self._bTrustTee then
    local useritem = self._scene:GetMeUserItem()

    if useritem.cbUserStatus == yl.US_SIT  then
      local btn = self._rootNode:getChildByTag(TAG.READY_BTN)
      self:onStartReady(btn)
    end

    self:trustTeeDeal(1,true)
    self._scene:sendRobot(1)
    local cancelrobot = self._rootNode:getChildByName("btn_cancel_robot")
    cancelrobot:setVisible(true)
  else
    self:trustTeeDeal(1,false)
    self._scene:sendRobot(0)
  end
end

--取消托管
function GameViewLayer:canceltrusTee()
  self._bTrustTee = false
  local cancelrobot = self._rootNode:getChildByName("btn_cancel_robot")
  cancelrobot:setVisible(false)
  self:trustTeeDeal(1,false)
  self._scene:sendRobot(0)
end

--返回
function GameViewLayer:backRoom()
    self:getParentNode():onQueryExitGame()
end

--准备事件
function GameViewLayer:onStartReady(sender)
    self:gameClean()

    sender:setVisible(false)
    self._scene:SendUserReady()
    self:setClockVisible(false)
    self._scene:KillGameClock()

    --显示准备状态
    local item = self._scene:GetMeUserItem()
    self:showReady(item.wChairID, true)
end

--显示准备
function GameViewLayer:showReady(wChairID,isShow)

  local  viewPos = self._scene:getUserIndex(wChairID)
  local readyIcon = self._rootNode:getChildByName(string.format("txt_ready_%d", viewPos))
  if readyIcon then
    readyIcon:setVisible(isShow)
  end
end

function GameViewLayer:setClockVisible( visible )
  self._clockTime:setVisible(visible)
end

--刷新倒计时
function GameViewLayer:UpdataClockTime(clockID,time)
  if time < 0 then
    return
  end

  if nil ~= self._scene._clockTimeLeave then
      self._scene._clockTimeLeave = self._scene._clockTimeLeave - 1
  end

  if clockID == cmd.Clock_end then
      self:setClockVisible(self._rootNode:getChildByName("btn_ready"):isVisible())
      self._clockTime:setString(string.format("%d",time))
  elseif cmd.Clock_status == clockID  then
    if self._selectNode and self._selectNode.UpdataClockTime then
      self._selectNode:UpdataClockTime(clockID, time)
    elseif self._PokerNormal and self._PokerNormal.UpdataClockTime then
      self._PokerNormal:UpdataClockTime(clockID, time)
    end
  elseif cmd.Clock_free == clockID then
    self:setClockVisible(true)
    self._clockTime:setString(string.format("%d",time))
  end

  if time == 0 then
      self._scene:KillGameClock()
      self:LogicTimeZero()

      self._scene._clockTimeLeave = 0
      self:setClockVisible(false)
      return
  end
end

--收到数据
function GameViewLayer:mobilePutCard()
  self._bGetTypeData = true
  if self._bComSend == true then
    self:popSlectcardView()
  end
end

function GameViewLayer:ChooseCardType()
    local param=self._scene.s_dispatchInfo
    local action=self._scene.s_action
    local pop=self._scene.s_pop
    if self.currentType == 0 then
       self:mobilePutCard()
       self:popSlectcardView()
        if self._PokerNormal then
           self._PokerNormal:removeFromParent()
           self._PokerNormal = nil
        end
    else
        if self._selectNode then
           self._selectNode:removeFromParent()
           self._selectNode = nil
        end
        self:manualCard(param, action, pop)
    end
end

function GameViewLayer:manualCard(param,action,pop)
    if self._PokerNormal then
       self._PokerNormal:removeFromParent()
       self._PokerNormal = nil
    end
    local PokerNormal = PokerNormal:create(self)
    self:addChild(PokerNormal, self.TopZorder)
    self._PokerNormal = PokerNormal
    PokerNormal:PokerContrastInit(PokerUtils.cardsDecode(self._scene._cbHandCard),self._scene._cbHandCard)

    --托管状态
    if self._bTrustTee then
    local sequence = cc.Sequence:create(cc.DelayTime:create(1.0),cc.CallFunc:create(function()
       PokerNormal:logicTimeZero()
    end))

    self:runAction(sequence)
  end
end

--游戏开始发牌
function GameViewLayer:dispatchCard(param,action,pop)
  self._bComSend = false;
  if action == true then
      ExternalFun.playSoundEffect("start.mp3")
      local beginNode = ExternalFun.loadCSB("beginAction.csb", self)
      beginNode:setPosition(yl.WIDTH/2, yl.HEIGHT/2)
      local beginAction = ExternalFun.loadTimeLine("beginAction.csb")
      beginAction:gotoFrameAndPlay(0, false)
      beginNode:runAction(beginAction)
      beginNode:runAction(cc.Sequence:create(cc.DelayTime:create(1), cc.CallFunc:create(function()
        beginNode:removeFromParent()
        end)))
  end

  local function sendCard(param, action, pop)
    local dispatchInfo = param
    local sendTotalRound = dispatchInfo.cardCount
    local nPlayerNum = #dispatchInfo.playerIndex

    for i=1,nPlayerNum do
      local viewIndex = dispatchInfo.playerIndex[i]
      print("发牌动画")
      if viewIndex ~= cmd.ME_VIEW_CHAIR then
        if pop == true or self._scene.m_bjoinGame == false then
          local statuscallfunc = cc.CallFunc:create(function()
          self:showSelectStatus(viewIndex,cmd.GS_WK_SETCHIP - cmd.GS_WK_CALL_BANKER)    --显示选牌中
          self:showSelectAction(viewIndex)
          print("显示选牌中")
          end)
          local delaytime = 0.1
          if action then
            delaytime = 0.4
          end
          self:runAction(cc.Sequence:create(cc.DelayTime:create(delaytime),statuscallfunc))
        end

      end
      --派发扑克
      local panelCard = self._rootNode:getChildByName(string.format("Panel_card_%d",viewIndex))

      for i=1,sendTotalRound do
        local card  = self._CardList[viewIndex][i]
        if nil ~= card then
          card:stopAllActions()
          card:setVisible(viewIndex~=cmd.ME_VIEW_CHAIR)
          card:setPosition(45, panelCard:getContentSize().height/2)
          card:setRotation(0)
          if action then
            card:runAction(cc.MoveTo:create(0.3,cc.p(45+18*(i-1),panelCard:getContentSize().height/2)))
          else
            card:setPosition(45+18*(i-1), panelCard:getContentSize().height/2)
          end
        end

      end
    end

    --弹出选牌界面
    if pop then
      local callfunc = cc.CallFunc:create(function()
      ExternalFun.playSoundEffect("start_poker.mp3")
      local time  = (self._scene.m_tTimeShowCard == 0) and 60 or self._scene.m_tTimeShowCard
      if GlobalUserItem.bPrivateRoom == true and PriRoom then

      else
       self._scene:SetGameClock(self._scene:GetMeUserItem().wChairID,cmd.Clock_status, time)
      end
        if self.currentType==0 then
           self._bComSend = true
          if self._bGetTypeData == true then
             self:popSlectcardView()
          end
        else
          self:manualCard(param,action,pop)
        end
      end)
      self:runAction(cc.Sequence:create(cc.DelayTime:create(1.5),callfunc))
    end
  end
  local waittime = action == true and 1 or 0
  print("发牌等待时间", waittime)
  self:runAction(cc.Sequence:create(cc.DelayTime:create(waittime), cc.CallFunc:create(function()
      sendCard(param, action, pop)
    end)))
end

--选牌操作界面
function GameViewLayer:popSlectcardView()

  if self._selectNode then
    self._selectNode:removeFromParent()
    self._selectNode = nil
  end
  --ExternalFun.playSoundEffect("start_poker.mp3")

  local selectNode = SelectNode:create(self, self._scene._cbHandCard)
  self:addChild(selectNode, self.TopZorder)
  self._selectNode = selectNode

  --选牌倒计时
  --local time  = (self._scene.m_tTimeShowCard == 0) and 60 or self._scene.m_tTimeShowCard
  --self._scene:SetGameClock(self._scene:GetMeUserItem().wChairID,cmd.Clock_status, time)

  --托管状态
  if self._bTrustTee then
    local sequence = cc.Sequence:create(cc.DelayTime:create(1.0),cc.CallFunc:create(function()
       selectNode:logicTimeZero()
    end))

    self:runAction(sequence)
  end
end

--选牌状态提示
function GameViewLayer:showSelectStatus(userindex,status)
  if cmd.ME_VIEW_CHAIR == userindex then
    return
  end

  local tips = self._rootNode:getChildByName(string.format("Panel_card_%d",userindex ))

  --当前状态
  local statusIcon = tips:getChildByName("im_tips")
  if nil ~= statusIcon then
    statusIcon:setVisible(true)
  end
end

--特殊牌型标识显示
function GameViewLayer:showSpecialIcon(userindex,value)
  local tips = self._rootNode:getChildByName(string.format("Panel_card_%d",userindex ))

  --当前状态
  local statusIcon = tips:getChildByName("im_special")
  if nil ~= statusIcon then
    statusIcon:setVisible(value)
  end
end

--配置完成
function GameViewLayer:showSelectedCard( userIndex,pokerData )

    local panel = self._rootNode:getChildByName(string.format("Panel_card_%d", userIndex))
    panel:show()
    --配牌中提示
    local tips = panel:getChildByName("im_tips")
    if nil ~= tips then
      tips:setVisible(false)
    end

    --设置小扑克
    local posIndex = 1
    local data = pokerData or {0xffff,0xffff,0xffff,0xffff,0xffff,0xffff,0xffff,0xffff,0xffff,0xffff,0xffff,0xffff,0xffff}
    for i=1,cmd.HAND_CARD_COUNT do
      local card = self._CardList[userIndex][i]
      if nil ~= card then
        card:stopAllActions()
        card:setCardValue(data[i])
      end
    end

    local anglelist = {-30, -15, 0, 15, 30}
    local offsety = {-10, -5, 0, -5, -10}
    local beginy = panel:getContentSize().height/2 - 60
    if userIndex == cmd.ME_VIEW_CHAIR then
      --self.b_check=false
      self.checkCard:show()
      beginy = panel:getContentSize().height/2
    end
    for j=1,3 do
      card = self._CardList[userIndex][j]
      card:show()
      card:runAction(cc.MoveTo:create(0.17, cc.p(panel:getContentSize().width/2-35+j*35, beginy+120+offsety[j+1])))
      card:runAction(cc.RotateBy:create(0.17, anglelist[j+1]))
    end

    for j=1,5 do
      card = self._CardList[userIndex][j+3]
      card:show()
      card:runAction(cc.MoveTo:create(0.17, cc.p(panel:getContentSize().width/2-70+j*35, beginy+60+offsety[j])))
      card:runAction(cc.RotateBy:create(0.17, anglelist[j]))
    end

    for j=1,5 do
      card = self._CardList[userIndex][j+8]
      card:show()
      card:runAction(cc.MoveTo:create(0.17, cc.p(panel:getContentSize().width/2-70+j*35, beginy+offsety[j])))
      card:runAction(cc.RotateBy:create(0.17, anglelist[j]))
    end
end

--设置牌数据
function GameViewLayer:setSelectCardData(userIndex)
  local cardlist = {}
  for k,v in pairs(self._scene._sortedCard[userIndex].Front) do
    table.insert(cardlist, v)
  end
  for k,v in pairs(self._scene._sortedCard[userIndex].Mid) do
    table.insert(cardlist, v)
  end
  for k,v in pairs(self._scene._sortedCard[userIndex].Tail) do
    table.insert(cardlist, v)
  end

  for i=1,cmd.HAND_CARD_COUNT do
    local card = self._CardList[userIndex][i]
    card:setCardValue(cardlist[i])
  end
end

--其他玩家选牌中动画显示
function GameViewLayer:showSelectAction(userIndex)
  if userIndex == cmd.ME_VIEW_CHAIR then
    return
  end

  for i=1,cmd.HAND_CARD_COUNT do
    local action = cc.Sequence:create(cc.MoveBy:create(0.1, cc.p(0,20)), cc.MoveBy:create(0.1, cc.p(0, -20)))
    local repaction = cc.RepeatForever:create(cc.Sequence:create(cc.DelayTime:create(i*0.05), action, cc.DelayTime:create((cmd.HAND_CARD_COUNT-i)*0.05 )))
    local card = self._CardList[userIndex][i]
    if nil ~= card then
      card:stopAllActions()
      card:runAction(repaction)
    end
  end
end

--选牌完成
function GameViewLayer:finishSelect( param, value )
  assert(table.nums(param)==13)

    if self._PokerNormal then
       self._PokerNormal:removeFromParent()
       self._PokerNormal = nil
    end
    if self._selectNode then
       self._selectNode:removeFromParent()
       self._selectNode = nil
    end
   dump(param)

  --发送分段数据
  local dataBuffer = CCmd_Data:create(14)
  for k,v in pairs(param) do
    dataBuffer:pushbyte(v)
  end
  --是否有特殊牌型
  if nil ~= value then
    dataBuffer:pushbyte(value)
  else
    dataBuffer:pushbyte(0)
  end

  dataBuffer:resetread()
  local test = ExternalFun.read_netdata(cmd.CMD_C_ShowCard, dataBuffer)

 self._scene:SendData(cmd.SUB_C_SHOWCARD,dataBuffer)

  --玩家摊牌数据
 local cardInfo = {}
 cardInfo.Front = {param[1], param[2], param[3]}
 cardInfo.Mid   = {param[4], param[5], param[6], param[7], param[8]}
 cardInfo.Tail  = {param[9], param[10], param[11], param[12], param[13]}
 self._scene._sortedCard[cmd.ME_VIEW_CHAIR] = cardInfo

 --设置扑克数据
 self:showSelectedCard(cmd.ME_VIEW_CHAIR, param)

--删除倒计时
 self._scene:KillGameClock()
end

--更新为最终位置
function GameViewLayer:updateComparePos(userIndex)
    local panel = self._rootNode:getChildByName(string.format("Panel_card_%d", userIndex))
    local anglelist = {-30, -15, 0, 15, 30}
    local offsety = {-10, -5, 0, -5, -10}
    local beginy = panel:getContentSize().height/2 - 60
    if userIndex == cmd.ME_VIEW_CHAIR then
      beginy = panel:getContentSize().height/2
    end

    for j=1,3 do
      card = self._CardList[userIndex][j]
      card:stopAllActions();
      card:setPosition(cc.p(panel:getContentSize().width/2-35+j*35, beginy+120+offsety[j+1]))
      card:setRotation(anglelist[j+1])
    end

    for j=1,5 do
      card = self._CardList[userIndex][j+3]
      card:stopAllActions();
      card:setPosition(cc.p(panel:getContentSize().width/2-70+j*35, beginy+60+offsety[j]))
      card:setRotation(anglelist[j])
    end

    for j=1,5 do
      card = self._CardList[userIndex][j+8]
      card:stopAllActions();
      card:setPosition(cc.p(panel:getContentSize().width/2-70+j*35, beginy+offsety[j]))
      card:setRotation(anglelist[j])
    end
end

function GameViewLayer:compareCard(users)
  local action = cc.Sequence:create({
    cc.DelayTime:create(0.17),
    cc.CallFunc:create(function()
        self:compareCardAnim(users);
    end)
  });
  self:runAction(action)
end

--开始比牌
function GameViewLayer:compareCardAnim(users)
  if self._selectNode ~= nil then
     self._selectNode:removeFromParent()
     self._selectNode = nil
  end
    if self._PokerNormal then
       self._PokerNormal:removeFromParent()
       self._PokerNormal = nil
    end

    self.checkCard:hide()
    for j=1,cmd.HAND_CARD_COUNT do
    card = self._CardList[1][j]
    card:showCardBack(not b_check)
    card:updateSprite()
    end

    if self._CardList[1] ~= nil then
      for k,v in pairs(self._CardList[1]) do
        v:setVisible(true)
      end
    end

  self._bComSend = false
  self._bGetTypeData = false

  for i=1,cmd.GAME_PLAYER do
    self:updateComparePos(i);
    --选牌提示
    local tips = self._rootNode:getChildByName(string.format("Panel_card_%d",i ))
    local imtips = tips:getChildByName("im_tips")
    if imtips then
      imtips:setVisible(false)
    end

    --特殊牌型显示
    if self._scene._bSpecialType[i] ~= 0 then
      self:showSpecialIcon(i, true)
    end
  end

  --翻牌动作数据
  local function getActionData(actiontype, userindex, actionindex)
    local table = {}
    table.actiontype = actiontype or 0 --0显示牌类型，1显示分数
    table.userindex = userindex or 0 --用户顺序
    table.actionindex = actionindex or 0 --0显示头墩，1显示中墩，2显示尾墩
    return table
  end

  --插入头墩顺序
  --index 0显示头墩，1显示中墩，2显示尾墩
  local function insertshowlist(actionlist, userlist, index)
    for i=1,#userlist do
      local action = getActionData(0, userlist[i], index)
      table.insert(actionlist, action)
    end
    if self._scene.m_bjoinGame == true then
      local score = getActionData(1, 1, index)
      table.insert(actionlist, score)
    end
  end

  --同墩大小排序
  --index 0比较头墩，1比较中墩，2比较尾墩
  local function comparelist(userlist, index)
    local userorder = clone(userlist)
    if #userlist == 1 then
      return userorder
    end
    local cardlist = {}
    for k,v in pairs(userlist) do
      if index == 0 then
        table.insert(cardlist, self._scene._sortedCard[v].Front)
      elseif index == 1 then
        table.insert(cardlist, self._scene._sortedCard[v].Mid)
      elseif index == 2 then
        table.insert(cardlist, self._scene._sortedCard[v].Tail)
      end
    end

    for i=1,#users do
      for j=i+1,#users do
        local value = GameLogic:CompareCard(cardlist[i], cardlist[j], #cardlist[i], #cardlist[j], true)
        if value == GameLogic.enCRLess then
          cardlist[i],cardlist[j] = cardlist[j],cardlist[i]
          userorder[i],userorder[j] = userorder[j],userorder[i]
        end
      end
    end
    return userorder
  end

  --墩位对比
  local actionlist = {}
  for i=1,3 do
    local userorder = comparelist(users, i-1)
    insertshowlist(actionlist, userorder, i-1)
  end

  --userindex 玩家位置
  --cardindex 牌墩
  local function showCardType(userindex, cardindex)
    local cardlist = {}
    local beginpos = 1
    local midpos = 2
    local length = 2
    if cardindex == 0 then
      cardlist = self._scene._sortedCard[userindex].Front
    elseif cardindex == 1 then
      beginpos = 4
      length = 4
      midpos = 6
      cardlist = self._scene._sortedCard[userindex].Mid
    elseif cardindex == 2 then
      beginpos = 9
      midpos = 11
      length = 4
      cardlist = self._scene._sortedCard[userindex].Tail
    end

    local panellayout = self._rootNode:getChildByName(string.format("Panel_card_%d",userindex))
    for i=beginpos,beginpos+length do
      local pcard = self._CardList[userindex][i]
      if nil ~= pcard then
        pcard:stopAllActions()
        pcard:setLocalZOrder(i+13)
        pcard:showCardBack(false)
        pcard:updateSprite()
        pcard:runAction(cc.Sequence:create(cc.ScaleTo:create(0.2, 1.2), cc.DelayTime:create(0.2),cc.ScaleTo:create(0.2, 1.0), cc.CallFunc:create(function()
          pcard:setLocalZOrder(i)
          end)))

        if i == midpos then
          local typebg = cc.Sprite:create("game_res/im_cardtype_bg.png")
          typebg:setPosition(pcard:getPositionX(), pcard:getPositionY()-55)
          typebg:setLocalZOrder(30)
          panellayout:addChild(typebg)

          local cardType = GameLogic:GetCardType(cardlist,#cardlist)
          if cardType >= GameLogic.CT_FIVE_MIXED_FLUSH_NO_A and cardType <= GameLogic.CT_FIVE_MIXED_FLUSH_BACK_A then
            cardType = GameLogic.CT_FIVE_MIXED_FLUSH_NO_A
          elseif cardType >= GameLogic.CT_FIVE_STRAIGHT_FLUSH_NO_A and cardType <= GameLogic.CT_FIVE_STRAIGHT_FLUSH_BACK_A then
            cardType = GameLogic.CT_FIVE_STRAIGHT_FLUSH_NO_A
          end
          assert(cardType ~= GameLogic.CT_INVALID)
          local icon = ccui.ImageView:create(string.format("game_res/CardType/txt_cardtype_show_%d.png",cardType))
          icon:setPosition(typebg:getContentSize().width/2, typebg:getContentSize().height/2)
          typebg:addChild(icon)

          ExternalFun.playSoundEffect("common"..cardType..".mp3")

          typebg:runAction(cc.Sequence:create(cc.DelayTime:create(0.6), cc.CallFunc:create(function()
              typebg:removeFromParent()
            end)))
        end
      end
    end
  end

  --显示分数
  local function showUserDunScore(cardindex)
    local cellbg = self._rootNode:getChildByName(string.format("im_end_cell_%d",cardindex))
    cellbg:setPositionX(yl.WIDTH + 127)
    cellbg:runAction(cc.MoveTo:create(0.37, cc.p(937, cellbg:getPositionY())))
    cellbg:setVisible(true)

    local txtscore = cellbg:getChildByName("txt_score")
    local score = self._scene._scoreTimes[1][cardindex+1]
    txtscore:setProperty(str, "game_res/gameOver/num_0.png", 22, 36, "/")
    if score < 0 then
      score = math.abs(score)
      txtscore:setProperty(str, "game_res/gameOver/num_1.png", 22, 36, "/")
    end
    txtscore:setString(string.format("/%d", score))


    if cardindex == 2 then
      local endscore = 0
      for i=1,cardindex+1 do
        endscore = endscore + self._scene._scoreTimes[1][i]
      end

      local allcellbg = self._rootNode:getChildByName("im_end_cell_3")
      allcellbg:setPositionX(yl.WIDTH + 127)
      allcellbg:runAction(cc.Sequence:create(cc.DelayTime:create(0.17), cc.MoveTo:create(0.37, cc.p(937, allcellbg:getPositionY()))))
      allcellbg:setVisible(true)
      local txtendscore = allcellbg:getChildByName("txt_score")
      txtendscore:setProperty(str, "game_res/gameOver/num_0.png", 22, 36, "/")
      if endscore < 0 then
        endscore = math.abs(endscore)
        txtendscore:setProperty(str, "game_res/gameOver/num_1.png", 22, 36, "/")
      end
      txtendscore:setString(string.format("/%d", endscore))
    end
  end

  local waittime = 1

  local function cardcompareshow(actionlist)
    local temptime = 0
    for k,v in pairs(actionlist) do
      if v.actiontype == 0 then
        self:runAction(cc.Sequence:create(cc.DelayTime:create(temptime), cc.CallFunc:create(function()
          showCardType(v.userindex, v.actionindex)
          end)))
        temptime = temptime + 0.6
      elseif v.actiontype == 1 then
        self:runAction(cc.Sequence:create(cc.DelayTime:create(temptime), cc.CallFunc:create(function()
          showUserDunScore(v.actionindex)
          end)))
        temptime = temptime + 0.4
      end
    end
  end

  --统计比牌等待时间
  for k,v in pairs(actionlist) do
    if v.actiontype == 0 then
      waittime = waittime + 0.6
    elseif v.actiontype == 1 then
      waittime = waittime + 0.4
    end
  end

  --显示开始比牌动画
  local compareNode = ExternalFun.loadCSB("compared.csb", self)
  compareNode:setPosition(yl.WIDTH/2, yl.HEIGHT/2)
  local compareAction = ExternalFun.loadTimeLine("compared.csb")
  compareAction:gotoFrameAndPlay(0, false)
  compareNode:runAction(compareAction)
  compareNode:runAction(cc.Sequence:create(cc.DelayTime:create(1), cc.CallFunc:create(function()
    compareNode:removeFromParent()
    end)))
  ExternalFun.playSoundEffect("start_compare.mp3")


  self:runAction(cc.Sequence:create(cc.DelayTime:create(1), cc.CallFunc:create(function()
      cardcompareshow(actionlist)
    end)))

  --显示打枪
  local function gunBeginShow()
    local gunNode = ExternalFun.loadCSB("gunAction.csb", self)
    gunNode:setPosition(yl.WIDTH/2, yl.HEIGHT/2)
    local gunAction = ExternalFun.loadTimeLine("gunAction.csb")
    gunAction:gotoFrameAndPlay(0, false)
    gunNode:runAction(gunAction)
    gunNode:runAction(cc.Sequence:create(cc.DelayTime:create(1.2), cc.CallFunc:create(function()
      gunNode:removeFromParent()
      end)))
  end

  --显示全垒打
  local function dataiallShow()
    local dataiallNode = ExternalFun.loadCSB("HomeRun.csb", self)
    dataiallNode:setPosition(yl.WIDTH/2, yl.HEIGHT/2)
    local dataiallAction = ExternalFun.loadTimeLine("HomeRun.csb")
    dataiallAction:gotoFrameAndPlay(0, false)
    dataiallNode:runAction(dataiallAction)
    dataiallNode:runAction(cc.Sequence:create(cc.DelayTime:create(1.2), cc.CallFunc:create(function()
      dataiallNode:removeFromParent()
      end)))
  end

  local gunlist, bdetaiall = self:getGunAcitionList(users)

  --要显示打枪
  --if self:getParentNode()._cbGun == true then
  if #gunlist ~= 0 then
    self:runAction(cc.Sequence:create(cc.DelayTime:create(waittime), cc.CallFunc:create(function()
        gunBeginShow()
        ExternalFun.playSoundEffect("daqiang1.mp3")
      end)))
    waittime = waittime + 1.4
    for k,v in pairs(gunlist) do
      self:runAction(cc.Sequence:create(cc.DelayTime:create(waittime), cc.CallFunc:create(function()
        self:gunActionShow(v)
      end)))
      waittime = waittime + 0.8
    end

    if bdetaiall == true then
      self:runAction(cc.Sequence:create(cc.DelayTime:create(waittime), cc.CallFunc:create(function()
        dataiallShow()
        ExternalFun.playSoundEffect("special1.mp3")
      end)))
      waittime = waittime + 1.4
    end
  end

  --判断是否特殊牌型显示
  local specialtype, specialIndex = self:checkSpecialData(self._scene._bSpecialType)
  if specialtype ~= 0 then
    self:runAction(cc.Sequence:create(cc.DelayTime:create(waittime), cc.CallFunc:create(function()
        self:specialActionShow(specialtype, specialIndex)
      end)))

    waittime = waittime + 2.7
    end

    self:runAction(cc.Sequence:create(cc.DelayTime:create(waittime), cc.CallFunc:create(function()
        for i=1,cmd.GAME_PLAYER do
          self:trustTeeDeal(i,false)
        end
        if self._scene.m_bjoinGame == true then
          self._scene:sendCompleteCompare()
        end
      end)))
end

--获取打枪动作列表
function GameViewLayer:getGunAcitionList(userlist)

  --打枪数据结构
  --gunindex 打枪
  --holeindex 被打枪
  local function getActionData(gunindex, holeindex)
      local table = {}
      table.gunindex = gunindex
      table.holeindex = holeindex
      return table
  end

  --打枪动作队列
  local gundatalist = {}
  local bAllDetai = false  --全垒打

  local scoretime = self._scene._scoreTimes
  for k,v in pairs(userlist) do
    local winnum = 0
    --通比模式
    if self._scene._wBankerUser == yl.INVALID_CHAIR then
      for jk,jv in pairs(userlist) do
        if v ~= jv then
          if scoretime[v][1]>scoretime[jv][1] and scoretime[v][2]>scoretime[jv][2] and scoretime[v][3]>scoretime[jv][3] then
          --if true then
            table.insert(gundatalist, getActionData(v, jv))
            winnum = winnum + 1
          end
        end
      end
    --霸王庄模式
    else
      local userIndex = self._scene:getUserIndex(self._scene._wBankerUser)
      --庄家
      if v == userIndex then
        for jk,jv in pairs(userlist) do
          if v ~= jv then
            if scoretime[v][1]>scoretime[jv][1] and scoretime[v][2]>scoretime[jv][2] and scoretime[v][3]>scoretime[jv][3] then
            --if true then
              table.insert(gundatalist, getActionData(v, jv))
              winnum = winnum + 1
            end
          end
        end
      else
        if scoretime[v][1]>scoretime[userIndex][1] and scoretime[v][2]>scoretime[userIndex][2] and scoretime[v][3]>scoretime[userIndex][3] then
          table.insert(gundatalist, getActionData(v, userIndex))
        end
      end
    end
    if winnum == cmd.GAME_PLAYER-1 then
      bAllDetai = true
    end
  end
  return gundatalist, bAllDetai
end

--打枪动作显示
function GameViewLayer:gunActionShow(actiondata)
    ExternalFun.playSoundEffect("bullets.mp3")
    local gunnode = self._rootNode:getChildByName(string.format("gun_%d", actiondata.gunindex))
    local holelist = {}
    for i=1,3 do
      table.insert(holelist, self._rootNode:getChildByName(string.format("hole_%d_%d", actiondata.holeindex, i-1)))
    end
    if gunnode ~= nil then
      local animation = cc.AnimationCache:getInstance():getAnimation("gun_anim")
      local action = cc.Repeat:create(cc.Animate:create(animation), 3)
      gunnode:setVisible(true)
      gunnode:runAction(cc.Sequence:create(action, cc.DelayTime:create(0.3), cc.CallFunc:create(function()
          gunnode:setVisible(false)
        end)))
      for i=1,3 do
        local hole = holelist[i]
        hole:runAction(cc.Sequence:create(cc.DelayTime:create(0.2*i), cc.CallFunc:create(function()
            hole:setVisible(true)
            ExternalFun.playSoundEffect("daqiang3.mp3")
          end), cc.DelayTime:create(0.7-0.2*i), cc.CallFunc:create(function()
            hole:setVisible(false)
          end)))
      end
    end
end

--特殊牌型效果显示
function GameViewLayer:specialActionShow(specialtype, specialIndex)
  local specialNode = ExternalFun.loadCSB("Special_poker.csb", self)
  specialNode:setPosition(yl.WIDTH/2, yl.HEIGHT/2)
  local specialAction = ExternalFun.loadTimeLine("Special_poker.csb")
  specialAction:gotoFrameAndPlay(0, false)
  specialNode:runAction(specialAction)
  specialNode:runAction(cc.Sequence:create(cc.DelayTime:create(2.4), cc.CallFunc:create(function()
    specialNode:removeFromParent()
    end)))
  ExternalFun.playSoundEffect("special"..specialtype..".mp3")


  local txtspecial = specialNode:getChildByName("santonghua_5")
  txtspecial:setTexture(cc.Director:getInstance():getTextureCache():addImage(string.format("Special_poker/txt_cardtype_%d.png", specialtype)))

  local cardlist = {}
  for k,v in pairs(self._scene._sortedCard[specialIndex].Tail) do
    table.insert(cardlist, v)
  end
  for k,v in pairs(self._scene._sortedCard[specialIndex].Mid) do
    table.insert(cardlist, v)
  end
  for k,v in pairs(self._scene._sortedCard[specialIndex].Front) do
    table.insert(cardlist, v)
  end

  local cardbg = specialNode:getChildByName("Column_4")
  for i=1,#cardlist do
    local pcard = CardSprite:createCard(cardlist[i])
    pcard:setPosition(206+i*41, cardbg:getContentSize().height/2)
    cardbg:addChild(pcard)
    pcard:showCardBack(false)
    pcard:updateSprite()
  end

  local puser = self:getuseritemByindex(specialIndex)
  if puser ~= nil then
    local head = PopupInfoHead:createNormal(puser, 100)
    head:setAnchorPoint(cc.p(0.5,0.5))
    head:setPosition(cc.p(88,95))
    cardbg:addChild(head)

    --昵称
    local nick =  ClipText:createClipText(cc.size(110,30),puser.szNickName,"fonts/round_body.ttf",22)
    nick:setColor(cc.c3b(255, 255, 237))
    nick:setAnchorPoint(cc.p(0.5, 0.5))
    nick:setPosition(cc.p(90, 22))
    cardbg:addChild(nick)
  end

  --牌处理
  for i=1,cmd.GAME_PLAYER do
    if self._scene._bSpecialType[i] ~= 0 then
      self:showSpecialIcon(i, false)
      for k,v in pairs(self._CardList[i]) do
        v:showCardBack(false)
        v:updateSprite()
      end
    end
  end
end

--获取是否有特殊牌型
function GameViewLayer:checkSpecialData(bSpecialType)
  dump(bSpecialType, "特殊牌型查询", 10)
  local specialtype = 0
  local specialIndex = 0
  for i=1,cmd.GAME_PLAYER do
    local temptype = bSpecialType[i]
    if temptype ~= 0 then
      if temptype > specialtype then
        specialtype = temptype
        specialIndex = i
      end
    end
  end
  return specialtype, specialIndex
end

--游戏结算
function GameViewLayer:showEndScore(endScore, bshow)
  local showdelaytime = bshow==0 and 4 or 0.5
  self:runAction(cc.Sequence:create(cc.DelayTime:create(showdelaytime), cc.CallFunc:create(function()
      -- self:gameClean()
      -- self:resetData()
      self:setClockVisible(true)
      self:showReadyBtn(true)
      if GlobalUserItem.bPrivateRoom == true and PriRoom then
          self:setClockVisible(false)
          if PriRoom:getInstance().m_tabPriData.dwPlayCount == PriRoom:getInstance().m_tabPriData.dwDrawCountLimit then
            self:showReadyBtn(false)
          end
      end
    end)))

  --非正常结算
  if bshow ~= 0 then
    return
  end

  local function getRandPos()
    local beginpos = cc.p(yl.WIDTH/2, yl.HEIGHT/2)
    local offsetx = math.random()
    local offsety = math.random()

    return cc.p(beginpos.x + offsetx*120, beginpos.y + offsety*120)
  end

  local function getMoveAction(endpos ,inorout)
    local action = cc.MoveTo:create(0.27, endpos)
    if inorout == 0 then
      return cc.EaseOut:create(action, 1)
    else
      return cc.EaseIn:create(action, 1)
    end
  end

  if self._scene.m_bjoinGame == true then
    --自己总输赢
    local allscorecell = self._rootNode:getChildByName("im_end_cell_3")
    local txtscore = allscorecell:getChildByName("txt_score")
    local score = self._scene._selfscoreEnd
    txtscore:setProperty(str, "game_res/gameOver/num_0.png", 22, 36, "/")
    if score == 0 then
      ExternalFun.playSoundEffect("no_award.mp3")
    elseif score > 0 then
      ExternalFun.playSoundEffect("win.mp3")

    elseif score < 0 then
      ExternalFun.playSoundEffect("lose.mp3")
      score = math.abs(score)
      txtscore:setProperty(str, "game_res/gameOver/num_1.png", 22, 36, "/")
    end
    txtscore:setString(string.format("/%d", score))
  end

  --赢的玩家列表
  local winlist = {}
  for i=1,cmd.GAME_PLAYER do
    if self._scene._bUserGameStatus[i] == true then
      local userIndex = self._scene:getUserIndex(i-1)
      --分数效果显示
      local userbg = self._rootNode:getChildByName(string.format("user_%d", userIndex))
      local txtscore = userbg:getChildByName("txt_end_score")
      txtscore:setVisible(true)
      txtscore:setScale(0.1)
      txtscore:setPositionY(172)
      txtscore:runAction(cc.ScaleTo:create(0.37, 1))
      txtscore:runAction(cc.MoveTo:create(0.37, cc.p(50, 212)))
      txtscore:setProperty(str, "game_res/num_add.png", 30, 39, "/")
      local endscore = self._scene._scoreEnd[i]
       --输了
      if self._scene._scoreEnd[i] < 0 then
        txtscore:setProperty(str, "game_res/num_plus.png", 30, 39, "/")
        endscore = math.abs(endscore)
        ExternalFun.playSoundEffect("coinCollide.wav")
        local goldnum = self:getgoldnum(self._scene._scoreEnd[i])
        local pos = self._seatposlist[userIndex]
        for i=1,goldnum do
          local pgold = cc.Sprite:create("game_res/im_fly_gold.png")
          pgold:setPosition(cc.p(pos.x, pos.y))
          pgold:setVisible(false)
          pgold:runAction(cc.Sequence:create(cc.DelayTime:create(math.random()*0.3), cc.CallFunc:create(function()
              pgold:setVisible(true)
              pgold:runAction(getMoveAction(getRandPos(), 0))
            end)))
          table.insert(self._goldlist, pgold)
          self:addChild(pgold, 10)
        end
      elseif self._scene._scoreEnd[i] > 0 then
         table.insert(winlist, userIndex)
      end
      txtscore:setString(string.format("/%d", endscore))
    end
  end

  self:runAction(cc.Sequence:create(cc.DelayTime:create(0.8), cc.CallFunc:create(function()
      local goldnum = #self._goldlist
      local usernum = #winlist
      local cellnum = math.floor(goldnum/usernum)
      print("cellnum-----",cellnum)
      local addnum = 0
      for i=1,usernum do
        ExternalFun.playSoundEffect("coinCollide.wav")
        local movenum = cellnum
        if usernum == i then
          movenum = goldnum - addnum
        end
        local userindex = winlist[i]
        for j=addnum+1,movenum+addnum do
          local pgold = self._goldlist[j]
          local pos = self._seatposlist[userindex]
          if nil ~= pgold and nil ~= pos then
            local pos = self._seatposlist[userindex]
            pgold:runAction(cc.Sequence:create(cc.DelayTime:create(math.random()*0.3), getMoveAction(pos, 1), cc.CallFunc:create(function()
                pgold:setVisible(false)
              end)))
          end
        end
        local lightbg = self._rootNode:getChildByName(string.format("im_headbg_light_%d", userindex))
        lightbg:setVisible(true)
        lightbg:runAction(cc.RepeatForever:create(cc.Blink:create(1, 2)))
        addnum = addnum + movenum
      end
    end)))
end

--显示庄家标识
function GameViewLayer:showBankerIcon(viewId)
  for i=1,cmd.GAME_PLAYER do
    local userbg = self._rootNode:getChildByName(string.format("user_%d",i))
    if nil ~= userbg then
      local bankericon = userbg:getChildByName("icon_banker")
      bankericon:setLocalZOrder(5)
      bankericon:setVisible(false)
      if i == viewId then
        bankericon:setVisible(true)
      end
    end
  end
end

--显示房主
function GameViewLayer:showFangzhuIcon(viewId)
  for i=1,cmd.GAME_PLAYER do
    local userbg = self._rootNode:getChildByName(string.format("user_%d",i))
    if nil ~= userbg then
      local fangzhuicon = userbg:getChildByName("icon_fangzhu")
      fangzhuicon:setVisible(false)
      if i == viewId then
        fangzhuicon:setVisible(true)
      end
    end
  end
end

--显示聊天
function GameViewLayer:onUserChat(chatdata, viewId)
  self:removeChildByTag(TAG.CHAT_VIEW)
  self._chatLayer = nil
  local chatbg = self._rootNode:getChildByName(string.format("im_chat_%d",viewId))
  if nil ~= chatbg then
    chatbg:removeAllChildren()
    chatbg:stopAllActions()

    local _labChat = cc.LabelTTF:create(chatdata.szChatString, "fonts/round_body.ttf", 20, cc.size(150,0), cc.TEXT_ALIGNMENT_CENTER)
    chatbg:addChild(_labChat)

    local labSize = _labChat:getContentSize()
    if labSize.height >= 40 then
        chatbg:setContentSize(180, labSize.height + 50)
    else
        chatbg:setContentSize(180, 50)
    end
    _labChat:setPosition(chatbg:getContentSize().width * 0.5, chatbg:getContentSize().height * 0.5+10)
    chatbg:runAction(self.m_actTip)
  end
end

--开始语音聊天
function GameViewLayer:onUserVoiceStart(viewId)
  local chatbg = self._rootNode:getChildByName(string.format("im_chat_%d",viewId))
  if nil ~= chatbg then
    chatbg:removeAllChildren()
    chatbg:stopAllActions()

    chatbg:setContentSize(120, 50)
    chatbg:setVisible(true)
    chatbg:setScale(1)

    local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame("record_play_ani_1.png")
    if nil ~= frame then
      local vioceanim = cc.Sprite:createWithSpriteFrame(frame)
      vioceanim:runAction(self.m_actVoiceAni)
      vioceanim:setPosition(chatbg:getContentSize().width * 0.5, chatbg:getContentSize().height * 0.5+5)
      if viewId == 1 or viewId == 4 then
        vioceanim:setRotation(180)
      end
      chatbg:addChild(vioceanim)
    end
  end
end

--结束语音聊天
function GameViewLayer:onUserVoiceEnded(viewId)
  local chatbg = self._rootNode:getChildByName(string.format("im_chat_%d",viewId))
  if nil ~= chatbg then
    chatbg:removeAllChildren()
    chatbg:stopAllActions()
    chatbg:setVisible(false)
  end
end

--获取玩家人数
function GameViewLayer:getUserNum()
  if self._rootNode == nil then
    return 0
  end

  local num = 0
  for i=1,cmd.GAME_PLAYER do
    local headBG = self._rootNode:getChildByName(string.format("user_%d",i))
    if headBG ~= nil then
      if headBG:isVisible() == true then
        num = num + 1
      end
    end
  end

  return num
end

function GameViewLayer:priGameEnd()
    self:showReadyBtn(false)
    if self._selectNode ~= nil then
       self._selectNode:removeFromParent()
       self._selectNode = nil
    end
    if self._PokerNormal then
       self._PokerNormal:removeFromParent()
       self._PokerNormal = nil
    end
end

return GameViewLayer
