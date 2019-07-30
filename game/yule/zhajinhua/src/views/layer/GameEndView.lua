local GameEndView =  class("GameEndView",function(config)
        local gameEndView =  display.newLayer(cc.c4b(0, 0, 0, 125))
    return gameEndView
end)

local HeadSprite = appdf.req(appdf.EXTERNAL_SRC .. "HeadSprite")
local cmd = appdf.req(appdf.GAME_SRC.."yule.zhajinhua.src.models.CMD_Game")

--GameEndView.BT_CLOSE = 1
GameEndView.BT_GAME_CONTINUE = 2
GameEndView.BT_CHANGE_TABLE = 3


function GameEndView:ctor(config)
	local this = self
	--按钮回调
	local  btcallback = function(ref, type)
        if type == ccui.TouchEventType.ended then
			this:OnButtonClickedEvent(ref:getTag(),ref)
        end
    end

    self.m_config = config

	--liuyang
--[[    self._endViewBg = display.newSprite("#game_end_bg.png")
        :move(667,400)
        :addTo(self)--]]
		
	self._endViewBg =  display.newSprite(cmd.RES.."game_end_bg.png")
	:move(667,400)
	:addTo(self)

    -- ccui.Button:create("bt_end_close_0.png","bt_end_close_1.png","",ccui.TextureResType.plistType)
    --     :setTag(GameEndView.BT_CLOSE)
    --     :move(667 + 450 -41,400+305-41)
    --     :addTo(self)
    --     :addTouchEventListener(btcallback)

    local btnChangeChair = ccui.Button:create("bt_gameend_table_0.png","bt_gameend_table_1.png","",ccui.TextureResType.plistType)
    btnChangeChair:setTag(GameEndView.BT_CHANGE_TABLE)
    btnChangeChair:move(667-185,95+75)
    btnChangeChair:setVisible(not GlobalUserItem.isAntiCheat())
    btnChangeChair:addTo(self)
    btnChangeChair:addTouchEventListener(btcallback)
    if GlobalUserItem.bPrivateRoom then --私有房不支持换桌
        -- 设置倒计时
        btnChangeChair:setVisible(false)
    end  

    local btnGoOn = ccui.Button:create("bt_gameend_continue_0.png","bt_gameend_continue_1.png","",ccui.TextureResType.plistType)
    btnGoOn:setTag(GameEndView.BT_GAME_CONTINUE)
    btnGoOn:move(667+185,95+75)
    btnGoOn:addTo(self)
    btnGoOn:addTouchEventListener(btcallback)
    if GlobalUserItem.bPrivateRoom then
        -- 设置倒计时
        btnGoOn:move(667, 95+75)
    end 

    local startx = 217
    local starty = 400 - 305

    self.m_UserScore = {}
    self.m_UserName = {}
    self.m_UserHead = {}
    self.m_UserResult = {}
    self.m_UserCard = {}
    self.m_CardType = {}

	--liuyang
    local ptHead = {cc.p(324,538),cc.p(495,538),cc.p(666,538),cc.p(839,538),cc.p(1010,538),cc.p(1181,538),cc.p(153,538)}
    local ptName = {cc.p(324,458),cc.p(495,458),cc.p(666,458),cc.p(839,458),cc.p(1010,458),cc.p(1181,458),cc.p(153,458)}
    local ptFlag = {cc.p(324,413),cc.p(495,413),cc.p(666,413),cc.p(839,413),cc.p(1010,413),cc.p(1181,413),cc.p(153,413)}
    local ptCard = {cc.p(294,331),cc.p(465,331),cc.p(636,331),cc.p(809,331),cc.p(980,331),cc.p(1151,331),cc.p(123,331)}
    local ptType = {cc.p(324,331),cc.p(495,331),cc.p(666,331),cc.p(839,331),cc.p(1010,331),cc.p(1181,331),cc.p(153,331)}
    local ptScore = {cc.p(324,264),cc.p(495,264),cc.p(666,264),cc.p(839,264),cc.p(1010,264),cc.p(1181,264),cc.p(153,264)}
	
    for i = 1 , 7 do
        self.m_UserHead[i] = HeadSprite:createNormal({}, 118)
            :move(ptHead[i])
            :addTo(self)

        self.m_UserName[i] = cc.Label:createWithTTF("游戏玩家", "base/fonts/round_body.ttf", 24)
            :move(ptName[i])
            :addTo(self)

        self.m_UserScore[i] = cc.Label:createWithTTF("+9999999", "base/fonts/round_body.ttf", 24)
            :move(ptScore[i])
            :addTo(self)

        self.m_UserResult[i] = display.newSprite("#game_end_flagwin.png")
            :move(ptFlag[i])
            :addTo(self)

        self.m_UserCard[i] = {}
        for j = 1 , 3 do
            self.m_UserCard[i][j] = display.newSprite("#card_back.png")
                :move(ptCard[i].x + (j-1)*30,ptCard[i].y)
                :setScale(0.7)
                :addTo(self)
        end

        self.m_CardType[i] = display.newSprite("#card_type_0.png")
            :move(ptType[i])
            :setScale(0.7)
            :addTo(self)
    end
 
end

function GameEndView:OnButtonClickedEvent(tag,ref)
    self:setVisible(false)
    if tag == GameEndView.BT_GAME_CONTINUE then
        if  self:getParent()._scene.m_bNoScore then
            local QueryDialog = appdf.req("app.views.layer.other.QueryDialog")
            local msg = self:getParent()._scene.m_szScoreMsg or "你的金币不足，无法继续游戏"
            local query = QueryDialog:create(msg, function(ok)
                if ok == true then
                    self:getParent()._scene:onExitTable()
                end
            query = nil
            end, 32, QueryDialog.QUERY_SURE):setCanTouchOutside(false)
            :addTo(self:getParent()._scene)
        else
            self:getParent()._scene:onStartGame(true)
        end
    elseif tag == GameEndView.BT_CHANGE_TABLE then
        self:getParent()._scene:onChangeDesk()
    --elseif tag == GameEndView.BT_CLOSE then
        --self:setVisible(false)
    end

end

function GameEndView:ReSetData()

    for i = 1 , 7 do
        self.m_UserHead[i]:setVisible(false)
        self.m_UserName[i]:setVisible(false)
        self.m_UserScore[i]:setVisible(false)
        self.m_UserResult[i]:setVisible(false)
        for j = 1 , 3 do
            self.m_UserCard[i][j]:setVisible(false)
        end
        self.m_CardType[i]:setVisible(false)
    end
end

function GameEndView:SetUserScore(viewid , score)
    self.m_UserScore[viewid]:setVisible(true)
    local szScore = (score > 0 and "+" or "")..score
    self.m_UserScore[viewid]:setColor((score>0) and cc.c4b(250,250,0,255) or cc.c4b(88,255,88,255))
    self.m_UserScore[viewid]:setString(string.EllipsisByConfig(szScore,125, self.m_config))
end

function GameEndView:SetUserInfo(viewid,useritem)
    self.m_UserHead[viewid]:setVisible(true)
    self.m_UserHead[viewid]:updateHead(useritem)

    self.m_UserName[viewid]:setVisible(true)
    if useritem and useritem.szNickName then
        self.m_UserName[viewid]:setString(string.EllipsisByConfig(useritem.szNickName,125, self.m_config))
    else
        self.m_UserName[viewid]:setString("游戏玩家")
    end
end

GameEndView.RES_CARD_TYPE = {"card_type_0.png","card_type_1.png","card_type_2.png","card_type_3.png","card_type_4.png","card_type_5.png"}

function GameEndView:SetUserCard(viewid,cardData,cardtype,isbreak)
    for i = 1, 3 do
        local spCard = self.m_UserCard[viewid][i]
        if not cardData or not cardData[i] or cardData[i] == 0 or cardData[i] == 0xff  then
            spCard:setSpriteFrame(not isbreak and "card_back.png" or"card_break.png")
        else
            local strCard = string.format("card_player_%02d.png",cardData[i])
            spCard:setSpriteFrame(strCard)
        end
        spCard:setVisible(true)
    end

    if cardtype and cardtype >= 1 and cardtype <= 6 then 
        self.m_CardType[viewid]:setSpriteFrame(GameEndView.RES_CARD_TYPE[cardtype])
        self.m_CardType[viewid]:setVisible(true)
    else
        self.m_CardType[viewid]:setVisible(false)
    end

end

function GameEndView:SetWinFlag(viewid,score)
    self.m_UserResult[viewid]:setVisible(true)
    if 0 == score then
        self.m_UserResult[viewid]:setVisible(true)
    end
    self.m_UserResult[viewid]:setSpriteFrame(score < 0 and "game_end_flaglose.png" or "game_end_flagwin.png")
end

function GameEndView:GetMyBoundingBox()
    return self._endViewBg:getBoundingBox()
end

return GameEndView