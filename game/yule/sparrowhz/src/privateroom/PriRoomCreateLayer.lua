--
-- Author: David
-- Date: 2017-8-11 14:07:02
--
-- 包含(创建界面、aa制付款提示界面)
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")

-- 斗地主私人房创建界面
local CreateLayerModel = appdf.req(PriRoom.MODULE.PLAZAMODULE .."models.CreateLayerModel")
local PriRoomCreateLayer = class("PriRoomCreateLayer", CreateLayerModel)

-- 广东麻将AA制提示界面
local TransitionLayer = appdf.req(appdf.EXTERNAL_SRC .. "TransitionLayer")
local PriRoomAAPayLayer = class("PriRoomAAPayLayer", TransitionLayer)
PriRoomCreateLayer.PriRoomAAPayLayer = PriRoomAAPayLayer

local TAG_START             = 100
local enumTable = 
{
    "BTN_CLOSE",            -- 关闭按钮
    "TAG_MASK",             -- 遮罩
    "BTN_HELP",             -- 帮助
    "BTN_CHARGE",           -- 充值
    "BTN_MYROOM",           -- 自己房间
    "BTN_CREATE1",           -- 加入房间
    "BTN_CREATE2",           -- 加入房间
    "BTN_ENTERGAME",        -- 进入游戏
    "CBT_ONE_PAY",          -- 一人支付
    "CBT_AA_PAY",           -- AA

    -- 密码配置
    "CBT_NEEDPASSWD",       -- 需要密码
    "CBT_NOPASSWD",         -- 不需要密码

    --下拉
    "CBT_DOWN1",         
    "CBT_DOWN2",
    "CBT_DOWN3",

    --码数
    "CBT_MANUM",            -- 0马
}
local TAG_ENUM = ExternalFun.declarEnumWithTable(TAG_START, enumTable)
local CBT_BEGIN = 400
local CBT_RULEBEGIN = 10      -- 玩法
local CBT_PLAYER = 20     -- 人数
local CBT_MABEGIN = 30        -- 马数


-- 创建界面
function PriRoomCreateLayer:ctor( scene,param,level )
    PriRoomCreateLayer.super.ctor(self, scene, param, level)
    -- 加载csb资源
    local rootLayer, csbNode = ExternalFun.loadRootCSB("privateRoom/RoomCardLayer.csb", self )
    self.m_csbNode = csbNode

    local function btncallback(ref, tType)
        if tType == ccui.TouchEventType.ended then
            self:onButtonClickedEvent(ref:getTag(),ref)
        end
    end

    -- 遮罩
   -- local mask = csbNode:getChildByName("panel_mask")
   -- mask:setTag(TAG_ENUM.TAG_MASK)
    --mask:addTouchEventListener( btncallback )

    -- 底板
    local spbg = csbNode:getChildByName("Sprite_3")
    self.m_spBg = spbg

    self.downBg = self.m_csbNode:getChildByName("downBg")

    -- 帮助按钮
   -- local btn = spbg:getChildByName("bt_help")
   -- btn:setTag(TAG_ENUM.BTN_HELP)
   -- btn:addTouchEventListener(btncallback)  

    -- 关闭
    btn = spbg:getChildByName("Button_4")
    btn:setTag(TAG_ENUM.BTN_CLOSE)
    btn:addTouchEventListener(btncallback)

    local cbtlistener = function (sender,eventType)
        self:onRuleSelectedEvent(sender:getTag(),sender)
    end
  
    self.m_tabRuleCheckBox = {}

    -- 码数选项
    for i = 1, 6 do
        local checkbx = self.downBg:getChildByName("down1"):getChildByName("check".. i)

        if nil ~= checkbx then
            checkbx:setVisible(true)
            checkbx:setTag(CBT_MABEGIN + i)
            checkbx:addEventListener(cbtlistener)
            checkbx:setSelected(false)
            self.m_tabRuleCheckBox[CBT_MABEGIN + i] = checkbx
        end
    end

    -- 选择的马数    
    self.m_nSelectMaIdx = CBT_MABEGIN + 2
    self.m_tabRuleCheckBox[self.m_nSelectMaIdx]:setSelected(true)


  --人数
    for i=2,4 do
        local checkbx = self.downBg:getChildByName("down3"):getChildByName("check".. (i-1))
        if nil ~= checkbx then
            checkbx:setVisible(true)
            checkbx:setTag(CBT_PLAYER + i)
            checkbx:addEventListener(cbtlistener)
            checkbx:setSelected(false)
            self.m_tabRuleCheckBox[CBT_PLAYER + i] = checkbx
        end

    end
    self.m_nSelectPlayerIdx = CBT_PLAYER + 2
    self.m_tabRuleCheckBox[self.m_nSelectPlayerIdx]:setSelected(true)


    -- 支付选择
    self.m_nSelectPayMode = self._cmd_pri.define.tabPayMode.ONE_PAY
    self.m_nPayModeIdx = TAG_ENUM.CBT_ONE_PAY
    local paymodelistener = function (sender,eventType)
        self:onPayModeSelectedEvent(sender:getTag(),sender)
    end
    self.m_tabPayModeBox = {}
    -- 一人付
    checkbx = spbg:getChildByName("cbx_zhifu1")
    checkbx:setTag(TAG_ENUM.CBT_ONE_PAY)
    checkbx:addEventListener(paymodelistener)
    checkbx.nPayMode = self._cmd_pri.define.tabPayMode.ONE_PAY
    checkbx:setSelected(true)
    self.m_tabPayModeBox[TAG_ENUM.CBT_ONE_PAY] = checkbx
    -- AA付
    checkbx = spbg:getChildByName("cbx_zhifu2")
    checkbx:setTag(TAG_ENUM.CBT_AA_PAY)
    checkbx:addEventListener(paymodelistener)
    checkbx.nPayMode = self._cmd_pri.define.tabPayMode.AA_PAY
    self.m_tabPayModeBox[TAG_ENUM.CBT_AA_PAY] = checkbx
    
    -- 是否密码
    self.m_nSelectPasswd = self._cmd_pri.define.tabPasswdMode.NO_PASSWD
    self.m_nPasswdModeIdx = TAG_ENUM.CBT_NOPASSWD
    local passwdmodelistener = function (sender,eventType)
        self:onPasswdModeSelectedEvent(sender:getTag(),sender)
    end
    self.m_tabPasswdModeBox = {}
    -- 需要密码
    checkbx = spbg:getChildByName("cbx_mima2")
    checkbx:setTag(TAG_ENUM.CBT_NEEDPASSWD)
    checkbx:addEventListener(passwdmodelistener)
    checkbx:setSelected(false)
    checkbx.nPasswdMode = self._cmd_pri.define.tabPasswdMode.SET_PASSWD
    self.m_tabPasswdModeBox[TAG_ENUM.CBT_NEEDPASSWD] = checkbx
    -- 不需要密码
    checkbx = spbg:getChildByName("cbx_mima1")
    checkbx:setTag(TAG_ENUM.CBT_NOPASSWD)
    checkbx:addEventListener(passwdmodelistener)
    checkbx.nPasswdMode = self._cmd_pri.define.tabPasswdMode.NO_PASSWD
    checkbx:setSelected(true)
    self.m_tabPasswdModeBox[TAG_ENUM.CBT_NOPASSWD] = checkbx

    -- 创建按钮
    btn = spbg:getChildByName("bt_createRoom1")
    btn:setTag(TAG_ENUM.BTN_CREATE1)
    btn:addTouchEventListener(btncallback)

    btn = spbg:getChildByName("bt_createRoom2")
    btn:setTag(TAG_ENUM.BTN_CREATE2)
    btn:addTouchEventListener(btncallback)

    btn = spbg:getChildByName("btn_dropdown_1")
    btn:setTag(TAG_ENUM.CBT_DOWN1)
    btn:addTouchEventListener(btncallback)

    btn = spbg:getChildByName("btn_dropdown_2")
    btn:setTag(TAG_ENUM.CBT_DOWN2)
    btn:addTouchEventListener(btncallback)

    btn = spbg:getChildByName("btn_dropdown_3")
    btn:setTag(TAG_ENUM.CBT_DOWN3)
    btn:addTouchEventListener(btncallback)


    
         self.downBg:setTouchEnabled(false)
         self.downBg:addClickEventListener(function() 
                self.downBg:setTouchEnabled(false)
                self.downBg:setVisible(false)

                for i=1,3 do
                    local arrow = spbg:getChildByName("btn_dropdown_"..i):getChildByName("arrow")
                    arrow:setTexture("privateRoom/btn_down1.png")
                end

            end)


    -- 注册事件监听
    self:registerEventListenr()
    -- 加载动画
    self:scaleTransitionIn(spbg)
end

------
-- 继承/覆盖
------
-- 刷新界面
function PriRoomCreateLayer:onRefreshInfo()
    -- 房卡数更新
    --self.m_txtCardNum:setString(GlobalUserItem.tabAccountInfo.lDiamond .. "")
end

function PriRoomCreateLayer:onRefreshFeeList()
    PriRoom:getInstance():dismissPopWait()
    local cbtlistener = function (sender,eventType)
        self:onSelectedEvent(sender:getTag(),sender)
    end
   self.m_tabCheckBox = {}
    -- 局数
    for i = 1, #PriRoom:getInstance().m_tabFeeConfigList do
        local config = PriRoom:getInstance().m_tabFeeConfigList[i]
        local checkbx = self.downBg:getChildByName("down2"):getChildByName("check".. i)
        if nil ~= checkbx then
            checkbx:setVisible(true)
            checkbx:setTouchEnabled(true)
            checkbx:setTag(CBT_BEGIN + i)
            checkbx:addEventListener(cbtlistener)
            checkbx:setSelected(false)
            self.m_tabCheckBox[CBT_BEGIN + i] = checkbx
        end

        local txtcount = checkbx:getChildByName("txt")
        if nil ~= txtcount then
            txtcount:setString(config.dwDrawCountLimit .. "局")
        end
    end
    
    -- 选择的局数    
    self.m_nSelectIdx = CBT_BEGIN + 1
    if nil ~= PriRoom:getInstance().m_tabFeeConfigList[self.m_nSelectIdx - CBT_BEGIN] then
        self.m_tabSelectConfig = PriRoom:getInstance().m_tabFeeConfigList[self.m_nSelectIdx - CBT_BEGIN]
        self.m_tabCheckBox[self.m_nSelectIdx]:setSelected(true)

        self.m_bLow = false
        -- 创建费用
        self.m_txtFee = self.m_spBg:getChildByName("txt_fee")
        self.m_txtFee:setString("")
        -- 更新费用
        self:updateCreateFee()

    end
local txt = self.m_spBg:getChildByName("btn_dropdown_2"):getChildByName("txt")
           txt:setString(self.m_tabSelectConfig.dwDrawCountLimit.."局")
       -- 免费判断
    if  PriRoom:getInstance().m_bLimitTimeFree then
        local wStart = PriRoom:getInstance().m_tabRoomOption.wBeginFeeTime or 0
        local wEnd = PriRoom:getInstance().m_tabRoomOption.wEndFeeTime or 0
        -- 免费时间
        local szfree = string.format("( 限时免费: %02d:00-%02d:00 )", wStart,wEnd)
        self.m_spBg:getChildByName("Text_freetime"):setString(szfree)

        -- 消耗隐藏
        self.m_spBg:getChildByName("Text_xiaohao"):setVisible(false)
        -- 费用隐藏
        self.m_txtFee:setVisible(false)
        -- 钻石隐藏
        self.m_spBg:getChildByName("zuan"):setVisible(false)
    end
end

function PriRoomCreateLayer:onLoginPriRoomFinish()
    local meUser = PriRoom:getInstance():getMeUserItem()
    if nil == meUser then
        return false
    end
    -- 发送创建桌子
    if ((meUser.cbUserStatus == yl.US_FREE 
        or meUser.cbUserStatus == yl.US_NULL 
        or meUser.cbUserStatus == yl.US_PLAYING
        or meUser.cbUserStatus == yl.US_SIT)) then
        if PriRoom:getInstance().m_nLoginAction == PriRoom.L_ACTION.ACT_CREATEROOM then
            print("gggggggggggggggggggggg")
            -- 创建登陆
            local buffer = ExternalFun.create_netdata(124) --CCmd_Data:create(188)
            buffer:setcmdinfo(self._cmd_pri_game.MDM_GR_PERSONAL_TABLE,self._cmd_pri_game.SUB_GR_CREATE_TABLE)
            buffer:pushscore(1)
            buffer:pushdword(self.m_tabSelectConfig.dwDrawCountLimit)
            buffer:pushdword(self.m_tabSelectConfig.dwDrawTimeLimit)
            buffer:pushword(4)
            buffer:pushdword(0)
            -- 密码设置
            buffer:pushbyte(self.m_nSelectPasswd)
            -- 支付方式
            buffer:pushbyte(self.m_nSelectPayMode)

            --游戏额外规则
            buffer:pushbyte(1)

            buffer:pushbyte(self.m_nSelectPlayerIdx -CBT_PLAYER)
            buffer:pushbyte(4)

            buffer:pushbyte(self.m_nSelectMaIdx -CBT_MABEGIN)
          

            for i = 1, 96 do
                buffer:pushbyte(0)
            end
            buffer:pushbyte(self.m_tabSelectConfig.cbGameMode)
            PriRoom:getInstance():getNetFrame():sendGameServerMsg(buffer)
            return true
        end        
    end
    return false
end

function PriRoomCreateLayer:getInviteShareMsg( roomDetailInfo )
    local dwRoomID = roomDetailInfo.dwRoomID or "" 
    local turnCount = roomDetailInfo.dwPlayTurnCount or 0
    local passwd = roomDetailInfo.dwRoomDwd or 0

    local shareTxt = "局数:" .. turnCount .. "局。红中麻将精彩刺激, 一起来玩吧!"
    local url = yl.PRIVATE_SHARE_URL ..  "?g=" .. GlobalUserItem.tabAccountInfo.dwGameID .. "&r=" .. dwRoomID .. "&k=389&a=1" .. "&p=" .. passwd
    
    return {title = "【约战房间: " .. dwRoomID .. "】", content = shareTxt, friendContent = "", url = url}
end

function PriRoomCreateLayer:getCopyShareMsg(roomDetailInfo)
    local dwRoomID = roomDetailInfo.dwRoomID or ""
    return {content = "红中麻将, 房号[" .. dwRoomID .. "],您的好友喊你打牌了!"}
end

function PriRoomCreateLayer:onExit()
    --cc.SpriteFrameCache:getInstance():removeSpriteFramesFromFile("room/land_room.plist")
    --cc.Director:getInstance():getTextureCache():removeTextureForKey("room/land_room.png")
end

function PriRoomCreateLayer:animationRemove()
    self:scaleTransitionOut(self.m_spBg)
end

function PriRoomCreateLayer:onTransitionOutFinish()
    self:removeFromParent()
end

function PriRoomCreateLayer:onOtherShowEvent()
    if self:isVisible() then
        self:setVisible(false)
    end
end

function PriRoomCreateLayer:onOtherHideEvent()
    if not self:isVisible() then
        self:setVisible(true)
    end
end
------
-- 继承/覆盖
------

function PriRoomCreateLayer:onButtonClickedEvent( tag, sender)
    if TAG_ENUM.TAG_MASK == tag or TAG_ENUM.BTN_CLOSE == tag then
        self:scaleTransitionOut(self.m_spBg)
    elseif TAG_ENUM.BTN_HELP == tag then
        --self._scene:popHelpLayer2(200, 1)
    elseif TAG_ENUM.BTN_CREATE1 == tag or TAG_ENUM.BTN_CREATE2 == tag then 
        if self.m_bLow and not PriRoom:getInstance().m_bLimitTimeFree then
            local QueryDialog = appdf.req("app.views.layer.other.QueryDialog")
            local query = QueryDialog:create("您的钻石数量不足，是否前往商城充值！", function(ok)
                if ok == true then
                    if nil ~= self._scene and nil ~= self._scene.popShopLayer then
                        self._scene:popShopLayer()
                    end
                end
                query = nil
            end):setCanTouchOutside(false)
                :addTo(self._scene)
            return
        end
        if nil == self.m_tabSelectConfig or table.nums(self.m_tabSelectConfig) == 0 then
            showToast(self, "未选择玩法配置!", 2)
            return
        end
        -- 是否代开
        PriRoom:getInstance().m_bCreateForOther = (TAG_ENUM.BTN_CREATE1 == tag)

        PriRoom:getInstance():showPopWait()
        PriRoom:getInstance():getNetFrame():onCreateRoom()

    elseif TAG_ENUM.CBT_DOWN1 == tag then
        
        self:updateDownBg(1)
    elseif TAG_ENUM.CBT_DOWN2 == tag then
        
        self:updateDownBg(2)
    elseif TAG_ENUM.CBT_DOWN3 == tag then
        
        self:updateDownBg(3)
    end

end

function PriRoomCreateLayer:updateDownBg(index)
        for i=1,3 do
                if index == i then
                    self.downBg:getChildByName("down"..i):setVisible(true)
                else
                    self.downBg:getChildByName("down"..i):setVisible(false)
                end
        end
        local arrow = self.m_spBg:getChildByName("btn_dropdown_"..index):getChildByName("arrow")
                    arrow:setTexture("privateRoom/btn_up1.png")

        self.downBg:setTouchEnabled(true)
        self.downBg:setVisible(true)
end




function PriRoomCreateLayer:onRuleSelectedEvent(tag, sender)
  


    if tag > CBT_PLAYER and tag < CBT_MABEGIN then --人数
        
            self.m_tabRuleCheckBox[self.m_nSelectPlayerIdx]:setSelected(false)

            self.m_nSelectPlayerIdx = tag
            self.m_tabRuleCheckBox[self.m_nSelectPlayerIdx]:setSelected(true)

           local txt = self.m_spBg:getChildByName("btn_dropdown_3"):getChildByName("txt")
           txt:setString((self.m_nSelectPlayerIdx -CBT_PLAYER) .."人")

    end

    if tag > CBT_MABEGIN then --码数
        if self.m_nSelectMaIdx == tag then
            sender:setSelected(true)
            return
        end
        self.m_nSelectMaIdx = tag
        for k,v in pairs(self.m_tabRuleCheckBox) do
            if k ~= tag  and  k > CBT_MABEGIN  then
                v:setSelected(false)
            end
        end

        local txt = self.m_spBg:getChildByName("btn_dropdown_1"):getChildByName("txt")
        local str = ""

        if self.m_nSelectMaIdx - CBT_MABEGIN == 1 then
            str = "一码全中"
        else
            str = (self.m_nSelectMaIdx - CBT_MABEGIN).."个扎码"
        end
           txt:setString(str)
    end
end

function PriRoomCreateLayer:onPayModeSelectedEvent( tag, sender )
    if self.m_nPayModeIdx == tag then
        sender:setSelected(true)
        return
    end
    self.m_nPayModeIdx = tag
    for k,v in pairs(self.m_tabPayModeBox) do
        if k ~= tag then
            v:setSelected(false)
        end
    end
    if nil ~= sender.nPayMode then
        self.m_nSelectPayMode = sender.nPayMode
    end
    -- 更新费用
    self:updateCreateFee()
end

function PriRoomCreateLayer:onPasswdModeSelectedEvent( tag, sender )
    if self.m_nPasswdModeIdx == tag then
        sender:setSelected(true)
        return
    end
    self.m_nPasswdModeIdx = tag
    for k,v in pairs(self.m_tabPasswdModeBox) do
        if k ~= tag then
            v:setSelected(false)
        end
    end
    if nil ~= sender.nPasswdMode then
        self.m_nSelectPasswd = sender.nPasswdMode
    end
end

function PriRoomCreateLayer:onSelectedEvent(tag, sender)
    if self.m_nSelectIdx == tag then
        sender:setSelected(true)
        return
    end
    self.m_nSelectIdx = tag
    for k,v in pairs(self.m_tabCheckBox) do
        if k ~= tag then
            v:setSelected(false)
        end
    end

    
    self.m_tabSelectConfig = PriRoom:getInstance().m_tabFeeConfigList[tag - CBT_BEGIN]

    local txt = self.m_spBg:getChildByName("btn_dropdown_2"):getChildByName("txt")
           txt:setString(self.m_tabSelectConfig.dwDrawCountLimit.."局")

    if nil == self.m_tabSelectConfig then
        return
    end

    -- 更新费用
    self:updateCreateFee()
end

function PriRoomCreateLayer:updateCreateFee()
    self.m_bLow = false
    if GlobalUserItem.tabAccountInfo.lDiamond < self.m_tabSelectConfig.lFeeScore then
        self.m_bLow = true
    end
    local fee = 0
    if self.m_nSelectPayMode == self._cmd_pri.define.tabPayMode.AA_PAY then
        -- AA付
        fee = self.m_tabSelectConfig.wAAPayFee or 0
    else
        -- 一人付
        fee = self.m_tabSelectConfig.lFeeScore or 0
    end
    self.m_txtFee:setString( "x" .. fee )
end

-- AA制界面
function PriRoomAAPayLayer:ctor( scene, param, level )
    PriRoomAAPayLayer.super.ctor( self, scene, param, level )

    -- 加载csb资源
    local rootLayer, csbNode = ExternalFun.loadRootCSB("privateRoom/PrivateRoomAAPayLayer.csb", self)
    local touchFunC = function(ref, tType)
        if tType == ccui.TouchEventType.ended then
            self:onButtonClickedEvent(ref:getTag(), ref)            
        end
    end

    -- 遮罩
    --local mask = csbNode:getChildByName("panel_mask")
    --mask:setTag(TAG_ENUM.TAG_MASK)
    --mask:addTouchEventListener( touchFunC )

    -- 底板
    local spbg = csbNode:getChildByName("Sprite_1")
    self.m_spBg = spbg

    -- 关闭
    local btn = spbg:getChildByName("Button_1")
    btn:setTag(TAG_ENUM.BTN_CLOSE)
    btn:addTouchEventListener( touchFunC )
    btn:setPressedActionEnabled(true)

    -- 进入
    btn = spbg:getChildByName("Button_2")
    btn:setTag(TAG_ENUM.BTN_ENTERGAME)
    btn:addTouchEventListener( touchFunC )
    btn:setPressedActionEnabled(true)

    -- 房间id
   -- local roomid = self._param.szRoomId or ""
    --spbg:getChildByName("txt_roomid"):setString(roomid)

       -- 房间id
    local roomid = self._param.dwRoomId or 0
    spbg:getChildByName("txt_roomid"):setString(string.format("%06d", roomid))

    -- 消耗钻石
    local consume = self._param.lDiamondFee or 0
    spbg:getChildByName("txt_consume"):setString("x"..consume)

 
    local buffer = self._param.buffer
    if nil ~= buffer and nil ~= buffer.readbyte then
        -- 读前两个规则
        --local playerNum = buffer:readbyte()

        spbg:getChildByName("Text_5"):setString(buffer:readbyte().."人")

        buffer:readbyte()
        local maNum = buffer:readbyte()
        local str = maNum.."个码"
        if maNum == 1 then
            str = "一码全中"
        end
        spbg:getChildByName("Text_5_0"):setString(str)


    end

    -- 局数
    local ncount = self._param.dwDrawCountLimit or 0
    spbg:getChildByName("Text_5_1"):setString(ncount .. "局")

    self:scaleTransitionIn(spbg)
end

function PriRoomAAPayLayer:onButtonClickedEvent( tag,sender )
    if tag == TAG_ENUM.TAG_MASK or tag == TAG_ENUM.BTN_CLOSE then
        -- 断开
        PriRoom:getInstance():closeGameSocket()

        self:scaleTransitionOut(self.m_spBg)
    elseif tag == TAG_ENUM.BTN_ENTERGAME then
        print("self userid ", GlobalUserItem.tabAccountInfo.dwUserID ~= self._param.dwRommerID)
        -- 判断是否密码, 且非房主
        if self._param.bRoomPwd and GlobalUserItem.tabAccountInfo.dwUserID ~= self._param.dwRommerID then
            PriRoom:getInstance():passwdInput()
        else
            PriRoom:getInstance().m_nLoginAction = PriRoom.L_ACTION.ACT_SEARCHROOM
            PriRoom:getInstance():showPopWait()
            PriRoom:getInstance():getNetFrame():sendEnterPrivateGame()
        end
    end
end

function PriRoomAAPayLayer:animationRemove()
    self:scaleTransitionOut(self.m_spBg)
end

function PriRoomAAPayLayer:onTransitionInBegin()
    self:sendShowEvent()
end

function PriRoomAAPayLayer:onTransitionOutBegin()
    self:sendHideEvent()
end

function PriRoomAAPayLayer:onTransitionOutFinish()
    self:removeFromParent()
end

return PriRoomCreateLayer