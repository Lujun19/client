--
-- Author: zhong
-- Date: 2016-12-17 14:07:02
--
-- 十三水私人房创建界面
local CreateLayerModel = appdf.req(PriRoom.MODULE.PLAZAMODULE .."models.CreateLayerModel")

local PriRoomCreateLayer = class("PriRoomCreateLayer", CreateLayerModel)
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local Shop = appdf.req(appdf.CLIENT_SRC.."plaza.views.layer.plaza.ShopLayer")

local BTN_HELP = 1
local BTN_CHARGE = 2
local BTN_MYROOM = 3
local BTN_CREATE = 4
local BTN_HIGH = 5 --高级配置
local CELL_BEGIN = 100  --底分选择
local PLAYER_BEGIN = 200 --人数选择
local CBT_BEGIN = 300   --局数选择

function PriRoomCreateLayer:ctor( scene )
    PriRoomCreateLayer.super.ctor(self, scene)
    -- 加载csb资源
    local rootLayer, csbNode = ExternalFun.loadRootCSB("room/PrivateRoomCreateLayer.csb", self )
    self.m_csbNode = csbNode

    self._playindex = 0 --玩法
    --self._gamemode = 1 --游戏牌型
    self._sendmode = 1 --发牌模式
    self._cardmode = 1 --扑克玩法
    self._bankmode = 1 --庄家玩法

    local function btncallback(ref, tType)
        if tType == ccui.TouchEventType.ended then
            self:onButtonClickedEvent(ref:getTag(),ref)
        end
    end
    -- 帮助按钮
    local btn = csbNode:getChildByName("btn_help")
    btn:setTag(BTN_HELP)
    btn:addTouchEventListener(btncallback)

    --高级选项
    btn = csbNode:getChildByName("btn_high_config")
    btn:setTag(BTN_HIGH)
    btn:addTouchEventListener(btncallback)

    -- 充值按钮
    btn = csbNode:getChildByName("btn_cardcharge")
    btn:setTag(BTN_CHARGE)
    btn:addTouchEventListener(btncallback)    

    -- 房卡数
    self.m_txtCardNum = csbNode:getChildByName("txt_cardnum")
    self.m_txtCardNum:setString(GlobalUserItem.lRoomCard .. "")

    -- 我的房间
    btn = csbNode:getChildByName("btn_myroom")
    btn:setTag(BTN_MYROOM)
    btn:addTouchEventListener(btncallback)

    -- -- 底分选择
    -- local tabCount = {10, 20, 30, 40, 50}
    -- local function celllistener(ref, tType)
    --     if tType == ccui.TouchEventType.ended then
    --         local tag = ref:getTag()
    --         for k,v in pairs(self.m_celllist) do
    --             local checkbox = v:getChildByName("im_check")
    --             if k ~= tag then
    --                 checkbox:loadTexture("room/bt_pri_check_1.png")
    --             else
    --                 checkbox:loadTexture("room/bt_pri_check_0.png")
    --             end
    --         end
    --         self.m_nSelectScore = tabCount[tag - CELL_BEGIN]
    --     end
    -- end

    -- self.m_celllist = {}
    -- for i=1,#tabCount do
    --     local checkbox = csbNode:getChildByName("bt_cell_"..i)
    --     if checkbox ~= nil then
    --         self.m_celllist[i+CELL_BEGIN] = checkbox
    --         checkbox:setTag(i+CELL_BEGIN)
    --         checkbox:addTouchEventListener(celllistener)

    --         local cellnum = checkbox:getChildByName("txt_des")
    --         cellnum:setString(""..tabCount[i])
    --     end
    -- end
    -- self.m_nSelectScore = tabCount[1]

    --人数选择
    local playernumCount = {"2","3","4","5","6","2-6"}
    local function playernumlistener(ref, tType)
        if tType == ccui.TouchEventType.ended then
            local tag = ref:getTag()
            for k,v in pairs(self.m_playernumlist) do
                local checkbox = v:getChildByName("im_check")
                if k ~= tag then
                    checkbox:loadTexture("room/bt_pri_check_1.png")
                else
                    checkbox:loadTexture("room/bt_pri_check_0.png")
                end
            end
            if tag == PLAYER_BEGIN + 6 then
                self.m_nPlayerNum = 0
            else
                self.m_nPlayerNum = tonumber(playernumCount[tag - PLAYER_BEGIN])
            end
        end
    end

    self.m_playernumlist = {}
    for i=1,#playernumCount do
        local checkbox = csbNode:getChildByName("bt_player_num_"..i)
        if checkbox ~= nil then
            self.m_playernumlist[i+PLAYER_BEGIN] = checkbox
            checkbox:setTag(i+PLAYER_BEGIN)
            checkbox:addTouchEventListener(playernumlistener)

            local cellnum = checkbox:getChildByName("txt_des")
            cellnum:setString(playernumCount[i].."人")
        end
    end
    self.m_nPlayerNum = playernumCount[1]

    local function cbtlistener(ref, tType)
        if tType == ccui.TouchEventType.ended then
            self:onSelectedEvent(ref:getTag(),ref)
        end
    end
    self.m_tabCheckBox = {}
    -- 玩法选项
    for i = 1, #PriRoom:getInstance().m_tabFeeConfigList do
        local config = PriRoom:getInstance().m_tabFeeConfigList[i]
        local checkbx = csbNode:getChildByName("bt_game_count_" .. i)
        if nil ~= checkbx then
            checkbx:setVisible(true)
            checkbx:setTag(CBT_BEGIN + i)
            checkbx:addTouchEventListener(cbtlistener)
            self.m_tabCheckBox[CBT_BEGIN + i] = checkbx

            local txtcount = checkbx:getChildByName("txt_des")
            if nil ~= txtcount then
                txtcount:setString(config.dwDrawCountLimit .. "局")
            end
        end
    end

    dump(PriRoom:getInstance().m_tabFeeConfigList)

    -- 选择的玩法    
    self.m_nSelectIdx = CBT_BEGIN + 1
    dump(PriRoom:getInstance().m_tabFeeConfigList, "feeconfiglist", 5)
    if #PriRoom:getInstance().m_tabFeeConfigList == 0 then
        return
    end
    self.m_tabSelectConfig = PriRoom:getInstance().m_tabFeeConfigList[self.m_nSelectIdx - CBT_BEGIN] 

    self.m_bLow = false
    -- 创建费用
    self.m_txtFee = csbNode:getChildByName("txt_fee")
    self.m_txtFee:setString("")
    if GlobalUserItem.lRoomCard < self.m_tabSelectConfig.lFeeScore then
        self.m_bLow = true
    end
    local feeType = "房卡"
    if nil ~= self.m_tabSelectConfig then        
        if PriRoom:getInstance().m_tabRoomOption.cbCardOrBean == 0 then
            feeType = "游戏豆"
            self.m_bLow = false
            if GlobalUserItem.dUserBeans < self.m_tabSelectConfig.lFeeScore then
                self.m_bLow = true
            end
        end
        self.m_txtFee:setString(self.m_tabSelectConfig.lFeeScore .. feeType)
    end

    -- 提示
    self.m_spTips = csbNode:getChildByName("priland_sp_card_tips")
    self.m_spTips:setVisible(self.m_bLow)
    dump(PriRoom:getInstance().m_tabRoomOption, "option")

    if PriRoom:getInstance().m_tabRoomOption.cbCardOrBean == 0 then
        local frame = cc.Director:getInstance():getTextureCache():addImage("room/txt_nobean_tips.png")
        if nil ~= frame then
            self.m_spTips:setTexture(frame)
        end
    end

    -- 创建按钮
    btn = csbNode:getChildByName("btn_createroom")
    btn:setTag(BTN_CREATE)
    btn:addTouchEventListener(btncallback)
end

--高级配置
function PriRoomCreateLayer:highConfigInit()
    local csbNode = ExternalFun.loadCSB("room/HighConfigLayer.csb", self)

    local function closecallback(sender, tType)
        if tType == ccui.TouchEventType.ended then
           csbNode:removeFromParent()
        end
    end
    local btnclose = csbNode:getChildByName("bt_close")
    btnclose:setVisible(false)
    btnclose:addTouchEventListener(closecallback)

    local bglayout = csbNode:getChildByName("layout_bg")
    bglayout:addTouchEventListener(closecallback)

    local btnensure = csbNode:getChildByName("bt_ensure")
    btnensure:addTouchEventListener(closecallback)

    --游戏牌型
    local function playlistener(ref, tType)
        if tType == ccui.TouchEventType.ended then
            local tag = ref:getTag()
            for k,v in pairs(self.m_playlist) do
                local checkbox = v:getChildByName("im_check")
                if k ~= tag then
                    checkbox:loadTexture("room/bt_pri_check_1.png")
                else
                    checkbox:loadTexture("room/bt_pri_check_0.png")
                end
            end
            self._playindex = tag-1
        end
    end

    self.m_playlist = {}
    for i=1,2 do
        local checkbox = csbNode:getChildByName("bt_game_"..i)
        if checkbox ~= nil then
            self.m_playlist[i] = checkbox
            checkbox:setTag(i)
            checkbox:addTouchEventListener(playlistener)
            if i == self._playindex+1 then
                playlistener(checkbox, ccui.TouchEventType.ended)
            end
        end
    end
    --发牌模式
    local function sendlistener(ref, tType)
        if tType == ccui.TouchEventType.ended then
            local tag = ref:getTag()
            for k,v in pairs(self.m_sendlist) do
                local checkbox = v:getChildByName("im_check")
                if k ~= tag then
                    checkbox:loadTexture("room/bt_pri_check_1.png")
                else
                    checkbox:loadTexture("room/bt_pri_check_0.png")
                end
            end
            self._sendmode = tag
        end
    end

    self.m_sendlist = {}
    for i=1,2 do
        local checkbox = csbNode:getChildByName("bt_send_"..i)
        if checkbox ~= nil then
            self.m_sendlist[i] = checkbox
            checkbox:setTag(i)
            checkbox:addTouchEventListener(sendlistener)
            if i == self._sendmode then
                sendlistener(checkbox, ccui.TouchEventType.ended)
            end
        end
    end
    --扑克玩法
    local function cardlistener(ref, tType)
        if tType == ccui.TouchEventType.ended then
            local tag = ref:getTag()
            for k,v in pairs(self.m_cardlist) do
                local checkbox = v:getChildByName("im_check")
                if k ~= tag then
                    checkbox:loadTexture("room/bt_pri_check_1.png")
                else
                    checkbox:loadTexture("room/bt_pri_check_0.png")
                end
            end
            self._cardmode = tag
        end
    end
    self.m_cardlist = {}
    for i=1,2 do
        local checkbox = csbNode:getChildByName("bt_card_"..i)
        if checkbox ~= nil then
            self.m_cardlist[i] = checkbox
            checkbox:setTag(i)
            checkbox:addTouchEventListener(cardlistener)
            if i == self._cardmode then
                cardlistener(checkbox, ccui.TouchEventType.ended)
            end
        end
    end
    --庄家玩法
    local function banklistener(ref, tType)
        if tType == ccui.TouchEventType.ended then
            local tag = ref:getTag()
            for k,v in pairs(self.m_banklist) do
                local checkbox = v:getChildByName("im_check")
                if k ~= tag then
                    checkbox:loadTexture("room/bt_pri_check_1.png")
                else
                    checkbox:loadTexture("room/bt_pri_check_0.png")
                end
            end
            self._bankmode = tag
        end
    end
    self.m_banklist = {}
    for i=1,4 do
        local checkbox = csbNode:getChildByName("bt_bank_"..i)
        if checkbox ~= nil then
            self.m_banklist[i] = checkbox
            checkbox:setTag(i)
            checkbox:addTouchEventListener(banklistener)
            if i == self._bankmode then
                banklistener(checkbox, ccui.TouchEventType.ended)
            end
        end
    end
end    

------
-- 继承/覆盖
------
-- 刷新界面
function PriRoomCreateLayer:onRefreshInfo()
    -- 房卡数更新
    self.m_txtCardNum:setString(GlobalUserItem.lRoomCard .. "")
end

function PriRoomCreateLayer:onLoginPriRoomFinish()
    local meUser = PriRoom:getInstance():getMeUserItem()
    if nil == meUser then
        return false
    end
    -- 发送创建桌子
    if ((meUser.cbUserStatus == yl.US_FREE or meUser.cbUserStatus == yl.US_NULL or meUser.cbUserStatus == yl.US_PLAYING or meUser.cbUserStatus == yl.US_SIT)) then
        if PriRoom:getInstance().m_nLoginAction == PriRoom.L_ACTION.ACT_CREATEROOM then
            -- 创建登陆
            local buffer = CCmd_Data:create(188)
            buffer:setcmdinfo(self._cmd_pri_game.MDM_GR_PERSONAL_TABLE,self._cmd_pri_game.SUB_GR_CREATE_TABLE)
            buffer:pushscore(self.m_nSelectScore)
            buffer:pushdword(self.m_tabSelectConfig.dwDrawCountLimit)
            buffer:pushdword(self.m_tabSelectConfig.dwDrawTimeLimit)
            buffer:pushint(self.m_tabSelectConfig.lIniScore)
            buffer:pushint(self.m_tabSelectConfig.nExOne)
            buffer:pushword(3)
            buffer:pushdword(0)
            buffer:pushstring("", yl.LEN_PASSWORD)

            --额外配置
            buffer:pushbyte(1)
            buffer:pushbyte(self.m_nPlayerNum) --参与人数
            print("self.m_nPlayerNum ============",self.m_nPlayerNum)
            buffer:pushbyte(6) --最大人数

            buffer:pushbyte(self._playindex+22) --游戏牌型
            buffer:pushbyte(self._sendmode+31)  --发牌模式
            buffer:pushbyte(self._cardmode+41)  --扑克玩法
            buffer:pushbyte(self._bankmode+51)  --庄家玩法
            print("self.m_nPlayerNum",self.m_nPlayerNum)
            print("self._playindex+22",self._playindex+22)
            print("self._sendmode+31",self._sendmode+31)
            print("self._cardmode+41",self._cardmode+41)
            print("self._bankmode+51",self._bankmode+51)
            --error("message",0)

            for i = 1, 96 do
                buffer:pushbyte(0)
            end
            PriRoom:getInstance():getNetFrame():sendGameServerMsg(buffer)
            return true
        end        
    end
    return false
end

function PriRoomCreateLayer:getInviteShareMsg( roomDetailInfo )
    local shareTxt =" 局数:" .. PriRoom:getInstance().m_tabPriData.dwDrawCountLimit .. "局"
    local friendC = " 局数:" .. PriRoom:getInstance().m_tabPriData.dwDrawCountLimit .. "局"
    return {title = "【约战房间:" .. roomDetailInfo.szRoomID .."】", content = shareTxt .. " 新六人牛牛游戏精彩刺激, 一起来玩吧! ", friendContent = friendC}
end

function PriRoomCreateLayer:onExit()
    cc.SpriteFrameCache:getInstance():removeSpriteFramesFromFile("room/land_room.plist")
    cc.Director:getInstance():getTextureCache():removeTextureForKey("room/land_room.png")
end

------
-- 继承/覆盖
------

function PriRoomCreateLayer:onButtonClickedEvent( tag, sender)
    if BTN_HELP == tag then
        self._scene:popHelpLayer2(7, 1)
        --self._scene:popHelpLayer(yl.HTTP_URL .. "/Mobile/Introduce.aspx?kindid=200&typeid=1")
    elseif BTN_HIGH == tag then
        self:highConfigInit()
    elseif BTN_CHARGE == tag then
        local feeType = "房卡"
        if PriRoom:getInstance().m_tabRoomOption.cbCardOrBean == 0 then
            feeType = "游戏豆"
        end
        if feeType == "游戏豆" then
            self._scene:onChangeShowMode(yl.SCENE_SHOP, Shop.CBT_BEAN)
        else
            self._scene:onChangeShowMode(yl.SCENE_SHOP, Shop.CBT_PROPERTY)
        end
    elseif BTN_MYROOM == tag then
        self._scene:onChangeShowMode(PriRoom.LAYTAG.LAYER_MYROOMRECORD)
    elseif BTN_CREATE == tag then 
        if self.m_bLow then
            local feeType = "房卡"
            if PriRoom:getInstance().m_tabRoomOption.cbCardOrBean == 0 then
                feeType = "游戏豆"
            end

            local QueryDialog = appdf.req("app.views.layer.other.QueryDialog")
            local query = QueryDialog:create("您的" .. feeType .. "数量不足，是否前往商城充值！", function(ok)
                if ok == true then
                    if feeType == "游戏豆" then
                        self._scene:onChangeShowMode(yl.SCENE_SHOP, Shop.CBT_BEAN)
                    else
                        self._scene:onChangeShowMode(yl.SCENE_SHOP, Shop.CBT_PROPERTY)
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
        PriRoom:getInstance():showPopWait()
        PriRoom:getInstance():getNetFrame():onCreateRoom()
    end
end

function PriRoomCreateLayer:onSelectedEvent(tag, sender)
    if self.m_nSelectIdx == tag then
        return
    end
    self.m_nSelectIdx = tag
    for k,v in pairs(self.m_tabCheckBox) do
        local checkbox = v:getChildByName("im_check")
        if k ~= tag then
            checkbox:loadTexture("room/bt_pri_check_1.png")
        else 
            checkbox:loadTexture("room/bt_pri_check_0.png")
        end
    end
    self.m_tabSelectConfig = PriRoom:getInstance().m_tabFeeConfigList[tag - CBT_BEGIN]
    if nil == self.m_tabSelectConfig then
        return
    end

    self.m_bLow = false
    if GlobalUserItem.lRoomCard < self.m_tabSelectConfig.lFeeScore then
        self.m_bLow = true
    end
    local feeType = "房卡"
    if PriRoom:getInstance().m_tabRoomOption.cbCardOrBean == 0 then
        feeType = "游戏豆"
        self.m_bLow = false
        if GlobalUserItem.dUserBeans < self.m_tabSelectConfig.lFeeScore then
            self.m_bLow = true
        end
    end
    self.m_txtFee:setString(self.m_tabSelectConfig.lFeeScore .. feeType)
    self.m_spTips:setVisible(self.m_bLow)
    if self.m_bLow then
        local frame = nil
        if PriRoom:getInstance().m_tabRoomOption.cbCardOrBean == 0 then
            frame = cc.Director:getInstance():getTextureCache():addImage("room/txt_nobean_tips.png")   
        else
            frame = cc.Director:getInstance():getTextureCache():addImage("room/txt_nocard_tips.png")   
        end
        if nil ~= frame then
            self.m_spTips:setTexture(frame)
        end
    end
end

return PriRoomCreateLayer