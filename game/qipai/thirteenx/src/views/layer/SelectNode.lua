--
-- Author: Tang
-- Date: 2016-12-08 15:41:53
--
local SelectNode = class("SelectNode", function(scene,cbCardData)
     return cc.Node:new()
end)
local module_pre = "game.qipai.thirteenx.src"
local CardButton = appdf.req(module_pre..".views.layer.CardButton")
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local GameLogic = appdf.req(module_pre..".models.GameLogic")
local cmd = appdf.req(module_pre..".models.cmd_game")
local Click_Area = 3
local Front = 1  --前墩
local Middle = 2 --中墩
local Tail = 3 --尾墩

local TAG = 
{
  SELECT_AREA = 0, --3
  CARD_TYPEBTN= 4

}

local SpecialTypeDes = { 
  [GameLogic.CT_EX_SANTONGHUA] = "三同花",             
  [GameLogic.CT_EX_SANSHUNZI] = "三顺子",           
  [GameLogic.CT_EX_LIUDUIBAN] = "六对半",               
  [GameLogic.CT_EX_SITAOSANTIAO] = "四套三条",                
  [GameLogic.CT_EX_SANFENGTIANXIA] = "三分天下",                
  [GameLogic.CT_EX_SANTONGHUASHUN] = "三同花顺",                
  [GameLogic.CT_EX_YITIAOLONG] = "一条龙",               
  [GameLogic.CT_EX_ZHIZUNQINGLONG] = "至尊清龙",            
}

function SelectNode:ctor(scene,cbCardData)
    self._scene = scene
    self._cardData = clone(cbCardData)   --扑克数据
    --加载csb资源
    local csbNode = ExternalFun.loadCSB("game_res/SelectCard.csb", self)
    csbNode:setPosition(yl.WIDTH/2, yl.HEIGHT/2)
    self._csbNode = csbNode

    self._CurTypeIndex = 1        --当前选择推荐类型
    
    self._specialDatas = {}     --特殊牌型组牌
    self._specialType = 0
    self._specialNode = nil
    self._selectedDatas = {}                  --所选扑克
    self._cardList = {}         --扑克牌列表
    self._selectCardIndex = 0   --第一次选中扑克
    self:initNode()
    ExternalFun.registerNodeEvent(self)

    self._scene:switchTypeBtn(self)

end

function SelectNode:initNode(contentSize)
    --推广
    self._mobilePutCard = self._scene:getParentNode()._cbautoCard
    self:initTypeSelect()
    self:initHandPoker()
    self:initEvent()
    
end

--初始化手牌
function SelectNode:initHandPoker()
  local cardlayout = self._csbNode:getChildByName("card_layout")
  local cardtest = self._mobilePutCard.cbMobilePutCard[1]
  --local cardtest = {60,38,36,1,8,7,4,2,42,10,53,37,21}
  for i=1,#self._cardData do
    local handCard = CardButton:create(cardtest[i])
    handCard:setTag(i)
    handCard:setPosition(self:getPosByTag(i))
    handCard:setLocalZOrder(i)
    handCard:addTouchEventListener(handler(self,self.onEvent))
    cardlayout:addChild(handCard)
    table.insert(self._cardList, handCard) 
  end
end

--初始类型选择
function SelectNode:initTypeSelect()
  self._typelist = self._csbNode:getChildByName("type_ListView")
  self._CurTypeIndex = 1
  -- self._mobilePutCard.cbMobilePutCard = {}
  -- self._mobilePutCard.cbMobilePutCount = 2
  -- self._mobilePutCard.cbMobilePutCard[1] = {60,38,36,1,8,7,4,2,42,10,53,37,21}
  -- self._mobilePutCard.cbMobilePutCard[2] = {60,36,4,42,38,53,37,21,1,10,8,7,2}
  for i=1, self._mobilePutCard.cbMobilePutCount do
    local csbnode = ExternalFun.loadCSB("game_res/CardTypeNode.csb")
    local pbutton = csbnode:getChildByName("bt_card_type")
    pbutton:retain()
    pbutton:removeFromParent()
    pbutton:setTag(i)
    pbutton:addTouchEventListener(handler(self, self.autoputSelectEvent))
    self._typelist:pushBackCustomItem(pbutton)
    pbutton:release()

    local front = {self._mobilePutCard.cbMobilePutCard[i][1], self._mobilePutCard.cbMobilePutCard[i][2], self._mobilePutCard.cbMobilePutCard[i][3]}
    local middle = {self._mobilePutCard.cbMobilePutCard[i][4], self._mobilePutCard.cbMobilePutCard[i][5],
      self._mobilePutCard.cbMobilePutCard[i][6],self._mobilePutCard.cbMobilePutCard[i][7],self._mobilePutCard.cbMobilePutCard[i][8]}
    local tail = {self._mobilePutCard.cbMobilePutCard[i][9], self._mobilePutCard.cbMobilePutCard[i][10],
      self._mobilePutCard.cbMobilePutCard[i][11],self._mobilePutCard.cbMobilePutCard[i][12],self._mobilePutCard.cbMobilePutCard[i][13]}
    local fronttype = GameLogic:GetCardType(front, 3)
    local middletype = GameLogic:GetCardType(middle, 5)
    local tailtype = GameLogic:GetCardType(tail, 5)

    if middletype >= GameLogic.CT_FIVE_MIXED_FLUSH_NO_A and middletype <= GameLogic.CT_FIVE_MIXED_FLUSH_BACK_A then
      middletype = GameLogic.CT_FIVE_MIXED_FLUSH_NO_A
    elseif middletype >= GameLogic.CT_FIVE_STRAIGHT_FLUSH_NO_A and middletype <= GameLogic.CT_FIVE_STRAIGHT_FLUSH_BACK_A then
      middletype = GameLogic.CT_FIVE_STRAIGHT_FLUSH_NO_A
    end

    if tailtype >= GameLogic.CT_FIVE_MIXED_FLUSH_NO_A and tailtype <= GameLogic.CT_FIVE_MIXED_FLUSH_BACK_A then
      tailtype = GameLogic.CT_FIVE_MIXED_FLUSH_NO_A
    elseif tailtype >= GameLogic.CT_FIVE_STRAIGHT_FLUSH_NO_A and tailtype <= GameLogic.CT_FIVE_STRAIGHT_FLUSH_BACK_A then
      tailtype = GameLogic.CT_FIVE_STRAIGHT_FLUSH_NO_A
    end

    local imfront = pbutton:getChildByName("im_type_0")
    local immiddle = pbutton:getChildByName("im_type_1")
    local imtail = pbutton:getChildByName("im_type_2")
    local imnum = pbutton:getChildByName("im_num")

    imnum:loadTexture(string.format("game_res/selectCard/im_num_%d_0.png",i))
    imfront:loadTexture(string.format("game_res/CardType/txt_cardtype_%d.png",fronttype))
    immiddle:loadTexture(string.format("game_res/CardType/txt_cardtype_%d.png",middletype))
    imtail:loadTexture(string.format("game_res/CardType/txt_cardtype_%d.png",tailtype))
    --三条
    if fronttype == GameLogic.CT_THREE then
      imfront:loadTexture(string.format("game_res/CardType/txt_cardtype_%d_0.png",fronttype))
    end

    if i == self._CurTypeIndex then
      pbutton:loadTextureNormal("game_res/selectCard/im_select_frame_1.png")
      local num = pbutton:getChildByName("im_num")
      num:loadTexture(string.format("game_res/selectCard/im_num_%d_1.png",i))
    end
  end
end

--通过tag值获取位置
function SelectNode:getPosByTag(tag)
  if tag < 4 then
    return cc.p(54+(tag-1)*72, 330)
  elseif tag < 9 then
    return cc.p(54+(tag-4)*72, 196)
  elseif tag < 14 then
     return cc.p(54+(tag-9)*72, 64)
  end
end

--获取牌
function SelectNode:getCardByTag(tag)
  for k,v in pairs(self._cardList) do
    if v:getTag() == tag then
      return v
    end
  end
  return nil
end

function SelectNode:getCardbyCardValue(value)
  for k,v in pairs(self._cardList) do
    if v:getCardData() == value then
      return v
    end
  end
  return nil
end

--初始化事件
function SelectNode:initEvent()

    local sureBtn = self._csbNode:getChildByName("select_sure")
    sureBtn:addTouchEventListener(function(sender,eventType)
        if eventType == ccui.TouchEventType.ended then
          self:selectCardFinish()
        end
      end)
    --非托管模式
    if self._scene._bTrustTee == false then
    --if true then
      --local test = {44,11,58,42,10,25,8,38,22,6,36,4,3}
      --local typevalue, linedata = GameLogic:GetSpecialType(test, #test)
      local  typevalue, linedata = GameLogic:GetSpecialType(self._cardData, #self._cardData)
      --特殊牌型
      if typevalue > GameLogic.CT_EX_INVALID then
        self._specialDatas = clone(linedata)
        self._specialType = typevalue
        print("self._specialType", self._specialType)
        dump(self._specialDatas, "获取特殊牌型", 10)
        self._specialNode = cc.CSLoader:createNode("game_res/SelectTips.csb")
        self._specialNode:setPosition(0, 0)
        self:addChild(self._specialNode, 10) 

        local _specialbg = self._specialNode:getChildByName("im_bg")

        local tipstr = "你的牌型符合【"..SpecialTypeDes[typevalue].."】,你是否要打出此牌型？"
        local _labtips = cc.LabelTTF:create(tipstr, "fonts/round_body.ttf", 28, cc.size(450,0), cc.TEXT_ALIGNMENT_CENTER)
        _labtips:setPosition(_specialbg:getContentSize().width/2, _specialbg:getContentSize().height/2)  
        _labtips:setColor(cc.c3b(255, 245, 248))      
        _specialbg:addChild(_labtips)

        local btensure = _specialbg:getChildByName("bt_ensure")
        btensure:addTouchEventListener(handler(self,self.specialSelect))

        local btcancel = _specialbg:getChildByName("bt_cancel") 
        btcancel:addTouchEventListener(function(sender,eventType)
          if eventType == ccui.TouchEventType.ended then
            self:removeSpecialNode()
          end
        end)
      end
    end
end

--移除特殊牌型提示层
function SelectNode:removeSpecialNode()
  if nil ~= self._specialNode then
    self._specialNode:removeFromParent()
    self._specialNode = nil
  end
end

--初始化事件
function SelectNode:onEvent(sender,eventType)
  if eventType == ccui.TouchEventType.ended then 
      local tag = sender:getTag()
      if self._selectCardIndex == tag then
        return
      end
      if self._selectCardIndex == 0 then
        self._selectCardIndex = tag
        return
      end
      local oldcard = self:getCardByTag(self._selectCardIndex)
      if oldcard == nil then
        return
      end
      ExternalFun.playSoundEffect("select.mp3")
      --if self:isValid(self._selectCardIndex, tag) == true then
      if true then
        self:cardMove(sender, self._selectCardIndex)
        self:cardMove(oldcard, tag)
        local oldbutton = self._typelist:getChildByTag(self._CurTypeIndex)
        if oldbutton ~= nil then
          oldbutton:loadTextureNormal("game_res/selectCard/im_select_frame_0.png")
          local num = oldbutton:getChildByName("im_num")
          num:loadTexture(string.format("game_res/selectCard/im_num_%d_0.png",self._CurTypeIndex))
        end
        self._CurTypeIndex = 0
      end
      self._selectCardIndex = 0
  end
end

function SelectNode:specialSelect(sender,eventType)
  if eventType == ccui.TouchEventType.ended then
    self._selectedDatas = {}
    for i=1, 3 do
      table.insert(self._selectedDatas, self._specialDatas[1][i])
    end
    for k,v in pairs(self._specialDatas[2]) do
      table.insert(self._selectedDatas, v)
    end
    for k,v in pairs(self._specialDatas[3]) do
      table.insert(self._selectedDatas, v)
    end

    dump(self._selectedDatas, "特殊牌型", 10)
    if nil ~= self._specialNode then
      self._specialNode:removeFromParent()
      self._specialNode = nil
    end
    self._scene:finishSelect(self._selectedDatas, self._specialType)
  end
end

function SelectNode:autoputSelectEvent(sender, eventType)
  if eventType == ccui.TouchEventType.ended then
    local tag = sender:getTag()
    print("推荐选牌", tag)
    if tag == self._CurTypeIndex then
      return
    end
    ExternalFun.playSoundEffect("select.mp3")
    sender:loadTextureNormal("game_res/selectCard/im_select_frame_1.png")
    local num = sender:getChildByName("im_num")
    num:loadTexture(string.format("game_res/selectCard/im_num_%d_1.png",tag))

    local oldbutton = self._typelist:getChildByTag(self._CurTypeIndex)
    if oldbutton ~= nil then
      oldbutton:loadTextureNormal("game_res/selectCard/im_select_frame_0.png")
      local num = oldbutton:getChildByName("im_num")
      num:loadTexture(string.format("game_res/selectCard/im_num_%d_0.png",self._CurTypeIndex))
    end

    self._CurTypeIndex = tag

    --牌位置交换
    for i=1,cmd.HAND_CARD_COUNT do
      local pcard = self:getCardbyCardValue(self._mobilePutCard.cbMobilePutCard[tag][i])
      self:cardMove(pcard, i)
    end

    self._selectCardIndex = 0
  end
end

--牌移动
function SelectNode:cardMove(pcard, tag)
  pcard:stopAllActions()
  local pos = self:getPosByTag(tag)
  local sequaction = cc.Sequence:create(cc.MoveTo:create(0.27, pos), cc.CallFunc:create(function()
      pcard:setTag(tag)
      pcard:setLocalZOrder(tag)
    end))
  pcard:runAction(sequaction)
end

--判断移动后牌型是否符合要求
function SelectNode:isValid()
  table.sort(self._cardList,function(a,b) return a:getTag()<b:getTag() end)
  local sortdata = {}
  for k,v in pairs(self._cardList) do
    table.insert(sortdata, v:getCardData())
  end
  local front = {sortdata[1], sortdata[2], sortdata[3]}
  local middle = {sortdata[4], sortdata[5], sortdata[6], sortdata[7], sortdata[8]}
  local tail = {sortdata[9], sortdata[10], sortdata[11], sortdata[12], sortdata[13]}
  local result = false
  local compareend = GameLogic:CompareCard(middle,tail,5,5, true)
  local comparefront = GameLogic:CompareCard(front, middle, 3, 5, false)
  if compareend == GameLogic.enCRGreater and comparefront == GameLogic.enCRGreater then
    result = true
  elseif compareend ~= GameLogic.enCRGreater then
    showToast(cc.Director:getInstance():getRunningScene(),"牌型:中墩必须小于尾墩,请重新选择",1.2)
  else
    showToast(cc.Director:getInstance():getRunningScene(),"牌型:头墩必须小于中墩,请重新选择",1.2)
  end
  return result
end

--选牌结束
function SelectNode:selectCardFinish()
  if self:isValid() == false then
    return
  end

  local sortdata = {}
  for k,v in pairs(self._cardList) do
    table.insert(sortdata, v:getCardData())
  end
  local sureBtn = self._csbNode:getChildByName("select_sure")
  sureBtn:setEnabled(false)

  self._selectedDatas = clone(sortdata)

  self._scene:finishSelect(self._selectedDatas)
end

--选牌时间结束
function SelectNode:logicTimeZero()
  if self._specialType == 0 then
    self:selectCardFinish()
  else
    self:specialSelect(nil, ccui.TouchEventType.ended)
  end
end

function SelectNode:UpdataClockTime(clockID,time)
  local time0 = self._csbNode:getChildByName("txt_time_0")
  local time1 = self._csbNode:getChildByName("txt_time_1")

  local str = string.format("%02d", time)
  time0:setString(string.sub(str,1,1))
  time1:setString(string.sub(str,2))
end

return SelectNode