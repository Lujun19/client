--
-- Author: David
-- Date: 2017-3-16
--
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local PopupInfoHead = appdf.req(appdf.EXTERNAL_SRC .. "PopupInfoHead")
local ClipText = appdf.req(appdf.EXTERNAL_SRC .. "ClipText")
local AnimationMgr = appdf.req(appdf.EXTERNAL_SRC .. "AnimationMgr")

local cmd = appdf.req(appdf.GAME_SRC.."yule.oxsixx.src.models.CMD_Game")

local popPosition = {cc.p(400, 320), cc.p(140, 400), cc.p(195, 100), cc.p(800, 400),cc.p(580, 320),cc.p(695, 320)}

local popAnchor = {cc.p(0.0, 1.0), cc.p(0, 0),cc.p(0, 0),cc.p(1.0, 0.0),cc.p(1.0, 1.0),cc.p(0.0, 1.0)} 

local posChatView = {cc.p(60, -120), cc.p(60, 120), cc.p(60, 120), cc.p(-60, 120),cc.p(60, -120),cc.p(60, -120)}
local posText = {cc.p(150, 80), cc.p(-150, 75), cc.p(150, 90), cc.p(-110, -136),}

local PlayerInfo = class("PlayerInfo", cc.Node)

function PlayerInfo:ctor(userItem, viewId)
    ExternalFun.registerNodeEvent(self)
    self.m_nViewId = viewId
    self.m_userItem = userItem
    self.m_bNormalState = (self.m_userItem.cbUserStatus ~= yl.US_OFFLINE)

    self.m_clipScore = nil
    self.m_clipNick = nil
    self._nMultiple = 0

    -- 加载csb资源
    self.csbNode = ExternalFun.loadCSB("game/GameRoleItem.csb",self)

    -- 用户头像
    local head = PopupInfoHead:createNormal(userItem, 84)
    head:enableInfoPop(true, popPosition[viewId], popAnchor[viewId])
    --head:enableHeadFrame(true, {_framefile = "land_headframe.png", _zorder = -1, _scaleRate = 0.75, _posPer = cc.p(0.5, 0.63)})
    self.m_popHead = head
    --获取头像NODE
    local nodeFace = self.csbNode:getChildByName("Node_face")
    nodeFace:addChild(head)

    -- 头像点击
    local btn = self.csbNode:getChildByName("btn")
    btn:addTouchEventListener(function( ref, tType)
        if tType == ccui.TouchEventType.ended then
            self.m_popHead:onTouchHead()
        end
    end)

    --游戏币框
    self.csbNode:getChildByName("Text_coin"):setVisible(false)
    -- self.scoreBg = self.csbNode:getChildByName("Node_mycion")
    -- self.scoreBg:setVisible(true)

    
    -- if viewId == cmd.MY_VIEWID then

    -- else
    --     self.scoreBg = self.csbNode:getChildByName("Node_othercoin")
    --     self.scoreBg:setVisible(true)
    --     self.csbNode:getChildByName("Node_mycion"):setVisible(false)
    -- end

    -- 昵称
    if nil == self.m_clipNick then            
        self.m_clipNick = ClipText:createClipText(cc.size(110, 20), self.m_userItem.szNickName)
        self.m_clipNick:setAnchorPoint(cc.p(0.5, 0.5))
        self.m_clipNick:setPosition(0, 52)
        self.csbNode:addChild(self.m_clipNick)
    else
        self.m_clipNick:setString(self.m_userItem.szNickName)
    end

    self.m_nodeInfo1 = self.csbNode:getChildByName("Node_playerInfo1")
    self.m_nodeInfo2 = self.csbNode:getChildByName("Node_playerInfo2")


    local spBanker = self.m_nodeInfo1:getChildByName("Sprite_banker")
    spBanker:setLocalZOrder(1)

    local lScore = self.m_userItem.lScore or 0
    -- 积分场
    if GlobalUserItem.bPrivateRoom and PriRoom and 1 == PriRoom:getInstance().m_tabPriData.cbIsGoldOrGameScore then
        lScore = lScore - PriRoom:getInstance().m_tabPriData.lIniScore
    end

    -- 游戏币
    local labScore = self.csbNode:getChildByName("Text_coin")
    if nil ~= labScore then
                -- 游戏币
        if nil == self.m_clipScore then
            self.m_clipScore = ClipText:createClipText(cc.size(100, 20), self:getScoreString(lScore) .. "")
            self.m_clipScore:setAnchorPoint(cc.p(0.5, 0.5))
            self.m_clipScore:setTextColor(cc.YELLOW)
            self.m_clipScore:setPosition(labScore:getPosition())
            self.csbNode:addChild(self.m_clipScore)
        else
            self.m_clipScore:setString(self:getScoreString(lScore))
        end
    end

    -- 聊天气泡
    self.m_spChatBg = self.csbNode:getChildByName("voice_animBg")
    self.m_spChatBg:setVisible(false)

    -- 聊天内容
    if nil == self.m_labChat then
        self.m_labChat = cc.LabelTTF:create(str, "fonts/round_body.ttf", 20, cc.size(150,0), cc.TEXT_ALIGNMENT_CENTER)
        self.m_labChat:setColor(cc.c3b(102,132,130)) 
        self.m_spChatBg:addChild(self.m_labChat)
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

        --语音动画
    if nil == self.m_spVoice then
        self.m_spVoice = display.newSprite("#blank.png")
        self.m_spVoice:setAnchorPoint(cc.p(0.5, 0.5))
        self.m_spVoice:runAction(self.m_actVoiceAni)
        self.m_spVoice:setRotation(180)
        self.m_spVoice:addTo(self.m_spChatBg)
        -- if cmd.TOP_VIEWID == self.m_nViewId then
        --     self.m_spVoice:setPosition(self.m_spChatBg:getContentSize().width * 0.5, self.m_spChatBg:getContentSize().height * 0.5 +3)
        -- else
            self.m_spVoice:setPosition(self.m_spChatBg:getContentSize().width * 0.5, self.m_spChatBg:getContentSize().height * 0.5 +15)
        --end
      
    end

    local sprBanker = self.m_nodeInfo1:getChildByName("Sprite_banker")
    local sprhouseholder = self.m_nodeInfo1:getChildByName("Sprite_householder")
    local callInScoreBg = self.m_nodeInfo2:getChildByName("Sprite_coinBg")
    local textmulNum = self.m_nodeInfo2:getChildByName("Sprite_mulNum")  
    local spriteMul = self.m_nodeInfo2:getChildByName("Sprite_mul")  

    self._bankerWait = self.csbNode:getChildByName("banker_waitIcon")
    self._spriteMul = spriteMul
    self._multipleNum = textmulNum

    self._callingIcon = self.csbNode:getChildByName("banker_calling_icon")
    self._callingIcon:setVisible(false)

    if viewId == 1 or viewId == 5 or viewId == 6 then
        self._callingIcon:setPosition(cc.p(115,45))
    end

    if viewId == 4 then  --右手边的位置
        callInScoreBg:setPosition(cc.p(-105,23))
        textmulNum:setPosition(cc.p(-115,45))
        spriteMul:setPosition(cc.p(-75,45))
        sprhouseholder:setPosition(cc.p(80,40))
        sprBanker:setPosition(cc.p(80,-40))
    else
        callInScoreBg:setPosition(cc.p(105,23))
        textmulNum:setPosition(cc.p(85,45))
        spriteMul:setPosition(cc.p(130,45))
        sprhouseholder:setPosition(cc.p(-80,40))
        sprBanker:setPosition(cc.p(-80,-40))
    end

    self:updateStatus()
end

function PlayerInfo:onExit()
    self.m_actTip:release()
    self.m_actTip = nil
    self.m_actVoiceAni:release()
    self.m_actVoiceAni = nil
end

function PlayerInfo:reSet()
    self.m_popHead:setVisible(true)
end

function PlayerInfo:setBankerWaitStatus( isShow,isNormal,viewIndex)
   self._bankerWait:setVisible(isShow)
   if isShow == true then
       if isNormal then
            self._bankerWait:setPosition(0.0,-89)
       else
            if viewIndex then
               assert(viewIndex>0 and viewIndex<=6)
               if viewIndex == 1 or viewIndex == 5 or viewIndex == 6 then
                   self._bankerWait:setPosition(0.0,-169)
               elseif viewIndex == 2 then
                   self._bankerWait:setPosition(150,-90)  
               elseif viewIndex == 4 then
                   self._bankerWait:setPosition(-170,-90)    
               end
            end
       end
   end
   
end
--庄家
function PlayerInfo:showBank( isBanker)
    --庄家图标
    self.m_nodeInfo1:getChildByName("Sprite_banker"):setVisible(isBanker)

    print("Visible(isBanker)",self.m_nodeInfo1:getChildByName("Sprite_banker"):isVisible())
end
--房主图标
function PlayerInfo:showRoomHolder( isRoomHolder )
    self.m_nodeInfo1:getChildByName("Sprite_householder"):setVisible(isRoomHolder)
end

--背景闪光
function PlayerInfo:showFlashBg( isShow )
    local headFlashBg = self.csbNode:getChildByName("head_flashbg")
    if isShow then
        --闪烁动画
        headFlashBg:runAction(cc.RepeatForever:create(cc.Blink:create(0.8,2)))
    else
        headFlashBg:stopAllActions()
        headFlashBg:setVisible(false)
    end
end

function PlayerInfo:textChat( str )
    print("玩家头像上聊天信息", self.m_spChatBg, str)
    self.m_spChatBg:setVisible(true)
    self.m_spVoice:setVisible(false)

    self.m_labChat:setString(str)

    self:changeChatPos()
    self.m_labChat:setVisible(true)
    -- 尺寸调整
    local labSize = self.m_labChat:getContentSize()
    if labSize.height >= 40 then
        self.m_spChatBg:setContentSize(170, labSize.height + 54)
    else
        self.m_spChatBg:setContentSize(170, 74)
    end

    self.m_labChat:setPosition(self.m_spChatBg:getContentSize().width * 0.5, self.m_spChatBg:getContentSize().height * 0.5 +7)

    if 1 == self.m_nViewId or 5 == self.m_nViewId or 6 == self.m_nViewId then
        self.m_labChat:setScaleY(-1)
    elseif 4 == self.m_nViewId then
        self.m_labChat:setScaleX(-1)
    else
        self.m_labChat:setScale(1)
    end
    self.m_spChatBg:runAction(cc.Sequence:create(cc.DelayTime:create(3.0), cc.Hide:create()))
end

function PlayerInfo:browChat( idx )
    if nil ~= self.m_labChat then
        self.m_labChat:setVisible(false)
    end
    self:changeChatPos()

    self.m_spChatBg:setContentSize(170, 40)
    local str = string.format("e(%d).png", idx)
    local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame(str)
    if nil ~= frame then
        --
    end
end

function PlayerInfo:onUserVoiceStart()
    if nil ~= self.m_labChat then
        self.m_labChat:setVisible(false)
    end
    self:changeChatPos()  
    self.m_spChatBg:setContentSize(170, 74) 
    self.m_spChatBg:stopAllActions()
    self.m_spChatBg:setVisible(true)
    if nil ~= self.m_spVoice then
        self.m_spVoice:setVisible(true)
    end
end

function PlayerInfo:onUserVoiceEnded()
    self.m_spChatBg:setVisible(false)
    if nil ~= self.m_spVoice then
        self.m_spVoice:setVisible(false)
    end
end

function PlayerInfo:changeChatPos()
    print("聊天气泡位置", posChatView[self.m_nViewId].x, posChatView[self.m_nViewId].y)
    self.m_spChatBg:setPosition(posChatView[self.m_nViewId])
    if 1 == self.m_nViewId or 5 == self.m_nViewId or 6 == self.m_nViewId then
        self.m_spChatBg:setScaleY(-1)
    elseif 4 == self.m_nViewId then
        self.m_spChatBg:setScaleX(-1)
    else
        self.m_spChatBg:setScale(1)
    end
end

function PlayerInfo:updateStatus()
    if self.m_userItem.cbUserStatus == yl.US_OFFLINE then
        self.m_bNormalState = false
        if nil ~= convertToGraySprite then
            -- 灰度图
            if nil ~= self.m_popHead and nil ~= self.m_popHead.m_head and nil ~= self.m_popHead.m_head.m_spRender then
                convertToGraySprite(self.m_popHead.m_head.m_spRender)
            end
        end        
    else
        if not self.m_bNormalState then
            self.m_bNormalState = true
            -- 普通图
            if nil ~= convertToNormalSprite then
                -- 灰度图
                if nil ~= self.m_popHead and nil ~= self.m_popHead.m_head and nil ~= self.m_popHead.m_head.m_spRender then
                    convertToNormalSprite(self.m_popHead.m_head.m_spRender)
                end
            end
        end
    end

    if nil ~= self.m_clipScore then
        local lScore = self.m_userItem.lScore or 0
        
        -- 积分场
        if GlobalUserItem.bPrivateRoom and PriRoom and 1 == PriRoom:getInstance().m_tabPriData.cbIsGoldOrGameScore then
            lScore = lScore - PriRoom:getInstance().m_tabPriData.lIniScore
        end
        self.m_clipScore:setString(self:getScoreString(lScore))
    end
    if nil ~= self.m_clipNick then
        self.m_clipNick:setString(self.m_userItem.szNickName)
    end
    self.m_popHead:updateHead(self.m_userItem)

end

--显示玩家下注分数
function PlayerInfo:showCallInScore(score,isVisible,isAni)
    local callInScoreBg = self.m_nodeInfo2:getChildByName("Sprite_coinBg")
    callInScoreBg:setVisible(isVisible)
    local callInScore =  callInScoreBg:getChildByName("Text_callIn")
    callInScore:setString(self:getScoreString(score))

end

function PlayerInfo:hiddenMultiple()
    self._spriteMul:setVisible(false)
    self._multipleNum:setVisible(false)
end

function PlayerInfo:setMultiple( multiple )

    self._nMultiple = multiple

    self:setCallingBankerStatus(false)
    if 0 ~= multiple then
       self._spriteMul:setVisible(true)
    end
    self._multipleNum:setVisible(true)
    print("multiple is =============",multiple)
    local multipleFrame = cc.Sprite:create("game/"..string.format("Sprite_mul%d.png", multiple))
    self._multipleNum:setSpriteFrame(multipleFrame:getSpriteFrame())
end

function PlayerInfo:getMultiple()
    return self._nMultiple
end

function PlayerInfo:setCallingBankerStatus(isCalling)
    if isCalling == true then
       self:hiddenMultiple()
    end
   
    self._callingIcon:setVisible(isCalling)

end
--转换分数
function PlayerInfo:getScoreString( score )
    if type(score) ~= "number" then
        return ""
    end
    local strScore = ""
    if score < 100000 then
        strScore = strScore..score
    elseif score < 100000000 then
        --print("分数转换1", score/10000)
        strScore = strScore..string.format("%.2f", score/10000).."万"
    else
        --print("分数转换2", score/100000000)
        strScore = strScore..string.format("%.2f", score/100000000).."亿"
    end
    --print("分数转换", score, strScore)
    return strScore
end

return PlayerInfo