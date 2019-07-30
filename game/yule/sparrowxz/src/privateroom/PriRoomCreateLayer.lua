
--
-- 斗地主私人房创建界面
local CreateLayerModel = appdf.req(PriRoom.MODULE.PLAZAMODULE .."models.CreateLayerModel")

local PriRoomCreateLayer = class("PriRoomCreateLayer", CreateLayerModel)
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local Shop = appdf.req(appdf.CLIENT_SRC.."plaza.views.layer.plaza.ShopLayer")

local BTN_HELP          = 1
local BTN_CHARGE        = 2
local BTN_MYROOM        = 3
local BTN_CREATE        = 4
local CBT_BEGIN         = 300 --局数
local CBT_CONFIG_BEGIN  = 310  --玩法
local CBT_FANXING_BEGIN   = 330  --番型

function PriRoomCreateLayer:ctor(roomParam, roomFeeParam)
    -- PriRoomCreateLayer.super.ctor(self)

    -- local gameInfo = MyApp:getInstance():getGameInfo(302)
    -- if nil ~= gameInfo then
    --     local modulestr = string.gsub(gameInfo._KindName, "%.", "/")
    --     self._searchPath = device.writablePath.."game/" .. modulestr .. "/res/privateroom/"
    --     cc.FileUtils:getInstance():addSearchPath(self._searchPath)
    -- end

    -- -- 加载csb资源
    -- local rootLayer, csbNode = ExternalFun.loadRootCSB("room/PrivateRoomCreateLayer.csb", self )
    -- self.m_csbNode = csbNode

    -- local function btncallback(ref, tType)
    --     if tType == ccui.TouchEventType.ended then
    --         self:onButtonClickedEvent(ref:getTag(),ref)
    --     end
    -- end
    -- -- 帮助按钮
    -- local btn = csbNode:getChildByName("btn_help")
    -- btn:setTag(BTN_HELP)
    -- btn:addTouchEventListener(btncallback)

    -- -- 充值按钮
    -- btn = csbNode:getChildByName("btn_cardcharge")
    -- btn:setTag(BTN_CHARGE)
    -- btn:addTouchEventListener(btncallback)    

    -- -- 房卡数
    -- self.m_txtCardNum = csbNode:getChildByName("txt_cardnum")
    -- self.m_txtCardNum:setString(GlobalUserItem.lRoomCard .. "")

    -- -- 我的房间
    -- btn = csbNode:getChildByName("btn_myroom")
    -- btn:setTag(BTN_MYROOM)
    -- btn:addTouchEventListener(btncallback)

   
    -- local cbtlistener = function (sender,eventType)
    --     self:onSelectedEvent(sender:getTag(),sender)
    -- end
    -- self.m_tabCheckBox = {}
    -- -- 局数选项
    -- print("局数列表个数", #PriRoom:getInstance().m_tabFeeConfigList)
    -- for i = 1, #PriRoom:getInstance().m_tabFeeConfigList do
    --     local config = PriRoom:getInstance().m_tabFeeConfigList[i]
    --     local checkbx = csbNode:getChildByName("check_" .. i.."_5")
    --     if nil ~= checkbx then
    --         checkbx:setVisible(true)
    --         checkbx:setTag(CBT_BEGIN + i)
    --         checkbx:addEventListener(cbtlistener)
    --         checkbx:setSelected(false)
    --         self.m_tabCheckBox[CBT_BEGIN + i] = checkbx
    --     end

    --     local txtcount = csbNode:getChildByName("count_" .. i.."_5")
    --     if nil ~= txtcount then
    --         txtcount:setString(config.dwDrawCountLimit .. "局")
    --     end
    -- end
    -- -- 选择的玩法    
    -- self.m_nSelectIdx = CBT_BEGIN + 1
    -- self.m_tabSelectConfig = PriRoom:getInstance().m_tabFeeConfigList[self.m_nSelectIdx - CBT_BEGIN]
    -- self.m_tabCheckBox[self.m_nSelectIdx]:setSelected(true)

    -- -- 玩法选项
    -- for i = 1, 2 do
    --     local checkbx = csbNode:getChildByName("check_" .. i)
    --     if nil ~= checkbx then
    --         checkbx:setVisible(true)
    --         checkbx:setTag(CBT_CONFIG_BEGIN + i)
    --         checkbx:addEventListener(cbtlistener)
    --         checkbx:setSelected(false)
    --         self.m_tabCheckBox[CBT_CONFIG_BEGIN + i] = checkbx
    --     end
    -- end
    -- -- 选择的玩法(可以多选)    
    -- self.m_nSelectConfigIdx = {0, 0}
    -- self.m_nSelectConfigIdx[1] = CBT_CONFIG_BEGIN + 1  
    -- self.m_tabCheckBox[self.m_nSelectConfigIdx[1]]:setSelected(true)

    --  -- 番型选项
    -- for i = 1, 4 do
    --     local checkbx = csbNode:getChildByName("check_" .."1_".. i)
    --     if nil ~= checkbx then
    --         checkbx:setVisible(true)
    --         checkbx:setTag(CBT_FANXING_BEGIN + i)
    --         checkbx:addEventListener(cbtlistener)
    --         checkbx:setSelected(false)
    --         self.m_tabCheckBox[CBT_FANXING_BEGIN + i] = checkbx
    --     end
    -- end

    -- -- 选择的番型        --可多选
    -- self.m_nSelectFanIdx = {0,0,0,0}
    -- self.m_nSelectFanIdx[1] = CBT_FANXING_BEGIN + 1  
    -- self.m_tabCheckBox[self.m_nSelectFanIdx[1]]:setSelected(true)

    -- self.m_bLow = false
    -- -- 创建费用
    -- self.m_txtFee = csbNode:getChildByName("txt_fee")
    -- self.m_txtFee:setString("")
    -- if GlobalUserItem.lRoomCard < self.m_tabSelectConfig.lFeeScore then
    --     self.m_bLow = true
    -- end
    -- local feeType = "房卡"
    -- if nil ~= self.m_tabSelectConfig then        
    --     if PriRoom:getInstance().m_tabRoomOption.cbCardOrBean == 0 then
    --         feeType = "游戏豆"
    --         self.m_bLow = false
    --         if GlobalUserItem.dUserBeans < self.m_tabSelectConfig.lFeeScore then
    --             self.m_bLow = true
    --         end
    --     end
    --     self.m_txtFee:setString(self.m_tabSelectConfig.lFeeScore .. feeType)
    -- end

    -- -- 提示
    -- self.m_spTips = csbNode:getChildByName("priland_sp_card_tips")
    -- self.m_spTips:setVisible(self.m_bLow)
    -- if PriRoom:getInstance().m_tabRoomOption.cbCardOrBean == 0 then
    --     local frame = cc.Sprite:create("room/priland_sp_card_tips_bean.png")
    --     if nil ~= frame then
    --         self.m_spTips:setSpriteFrame(frame:getSpriteFrame())
    --     end
    -- end

    -- -- 创建按钮
    -- btn = csbNode:getChildByName("btn_createroom")
    -- btn:setTag(BTN_CREATE)
    -- btn:addTouchEventListener(btncallback)

        PriRoomCreateLayer.super.ctor(self)
    
        --房间详细参数
        local detailParams = 
        {
            {
                name = "游戏玩法",
                height = 80,
                options =  
                {
                    { name = "换三张", value = 1 },
                    { name = "呼叫转移", value = 2 },
                }
            },
            {
                name = "选择番型",
                height = 80,
                options = 
                {
                    { name = "自摸加倍", value = 1 },
                    { name = "天地胡", value = 2 },
                    { name = "海底捞月", value = 3 },
                    { name = "门清*2", value = 4 },
                }
            },
            {
                name = "房间局数",
                height = 80,
                options = 
                {
                }
            },
            {
                name = "创建费用",
            }
        }
    
        --填充房间局数
        for i = 1, #roomFeeParam do
            
            local drawCount = roomFeeParam[i].dwDrawCountLimit
            local feeScore = roomFeeParam[i].lFeeScore
    
            detailParams[3].options[i] = { name = drawCount, value = drawCount, fee = feeScore}
        end
        
        --创建详细参数视图
        self:createDetailParamView(roomParam, roomFeeParam, detailParams)
end


--获取创建桌子数据
function PriRoomCreateLayer:getCreateTableData()

    local wfa = self:getDetailParamValue(1)
    local fantype = self:getDetailParamValue(2)
    local drawCount = self:getDetailParamValue(3)

    self.m_nSelectConfigIdx = {0,0}
    self.m_nSelectConfigIdx[wfa] = 1

    self.m_nSelectFanIdx = {0,0,0,0}
    self.m_nSelectFanIdx[fantype] = 1

    -- 创建登陆
    local buffer = CCmd_Data:create(188)
    buffer:setcmdinfo(self._cmd_pri_game.MDM_GR_PERSONAL_TABLE,self._cmd_pri_game.SUB_GR_CREATE_TABLE)
    buffer:pushscore(1)
    buffer:pushdword(drawCount)
    buffer:pushdword(0)
    buffer:pushword(4)
    buffer:pushdword(0)
    buffer:pushstring("", yl.LEN_PASSWORD)

    --游戏额外规则
    buffer:pushbyte(1) --支持额外规则
    buffer:pushbyte(4) --当前房间人数
    buffer:pushbyte(4) --允许的最大人数
    for i=1,2 do
        buffer:pushbyte(self.m_nSelectConfigIdx[i]==0 and 0 or 1)
    end
    for i=1,4 do
        buffer:pushbyte(self.m_nSelectFanIdx[i]==0 and 0 or 1)
    end

    return buffer
end

function PriRoomCreateLayer:onLoginPriRoomFinish()
    local meUser = PriRoom:getInstance():getMeUserItem()
    if nil == meUser then
        return false
    end
    -- 发送创建桌子
    if ((meUser.cbUserStatus == yl.US_FREE or meUser.cbUserStatus == yl.US_NULL or meUser.cbUserStatus == yl.US_PLAYING)) then
        if PriRoom:getInstance().m_nLoginAction == PriRoom.L_ACTION.ACT_CREATEROOM then
            PriRoom:getInstance():getNetFrame():sendGameServerMsg(self:getCreateTableData())
            return true
        end        
    end
    return false
end

-- function PriRoomCreateLayer:onLoginPriRoomFinish()
--     local meUser = PriRoom:getInstance():getMeUserItem()
--     if nil == meUser then
--         return false
--     end
--     -- 发送创建桌子
--     if ((meUser.cbUserStatus == yl.US_FREE or meUser.cbUserStatus == yl.US_NULL or meUser.cbUserStatus == yl.US_PLAYING)) then
--         if PriRoom:getInstance().m_nLoginAction == PriRoom.L_ACTION.ACT_CREATEROOM then
--             -- 创建登陆
--             local buffer = CCmd_Data:create(188)
--             buffer:setcmdinfo(self._cmd_pri_game.MDM_GR_PERSONAL_TABLE,self._cmd_pri_game.SUB_GR_CREATE_TABLE)
--             buffer:pushscore(1)
--             buffer:pushdword(self.m_tabSelectConfig.dwDrawCountLimit)
--             buffer:pushdword(self.m_tabSelectConfig.dwDrawTimeLimit)
--             buffer:pushword(4)
--             buffer:pushdword(0)
--             buffer:pushstring("", yl.LEN_PASSWORD)

--             --游戏额外规则
--             buffer:pushbyte(1) --支持额外规则
--             buffer:pushbyte(4) --当前房间人数
--             buffer:pushbyte(4) --允许的最大人数
--             for i=1,2 do
--                 buffer:pushbyte(self.m_nSelectConfigIdx[i]==0 and 0 or 1)
--             end
--             for i=1,4 do
--                 buffer:pushbyte(self.m_nSelectFanIdx[i]==0 and 0 or 1)
--             end
--             PriRoom:getInstance():getNetFrame():sendGameServerMsg(buffer)
--             return true
--         end        
--     end
--     return false
-- end

function PriRoomCreateLayer:getInviteShareMsg( roomDetailInfo )
    local shareTxt = "血战麻将约战 房间ID:" .. roomDetailInfo.szRoomID .. " 局数:" .. roomDetailInfo.dwPlayTurnCount
    local friendC = "血战麻将房间ID:" .. roomDetailInfo.szRoomID .. " 局数:" .. roomDetailInfo.dwPlayTurnCount
    return {title = "血战麻将约战", content = shareTxt .. " 血战麻将精彩刺激, 一起来玩吧! ", friendContent = friendC}
end

return PriRoomCreateLayer