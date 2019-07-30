--
-- Author: zhong
-- Date: 2016-11-11 09:59:23
--
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local ClipText = appdf.req(appdf.EXTERNAL_SRC .. "ClipText")

local module_pre = "game.qipai.landnoshuffle.src"
local cmd = appdf.req(module_pre .. ".models.CMD_Game")

local GameResultLayer = class("GameResultLayer", cc.Layer)
local PopupInfoHead = appdf.req(appdf.EXTERNAL_SRC .. "PopupInfoHead")

local BT_CONTINUE = 101
local BT_QUIT = 102
local BT_CLOSE = 103
local BT_CHANGE_TABLE = 104

function GameResultLayer.getTagSettle()
    return 
    {
        -- 用户名
        m_userName = "",
        -- 文本颜色
        nameColor = cc.c4b(255,255,255,255),
        -- 计算金币
        m_settleCoin = "",
        -- 文本颜色
        coinColor = cc.c4b(255,255,255,255),       
        -- 特殊标志
        m_cbFlag = cmd.kFlagDefault,
		-- 头像
		m_popHead = "",
		-- 身份
		m_identity = ""
    }
end

function GameResultLayer.getTagGameResult()
    return
    {
        -- 结果
        enResult = cmd.kDefault,
		m_lCellScore = 0,
        -- 结算
        settles = 
        {
            GameResultLayer.getTagSettle(),
            GameResultLayer.getTagSettle(),
            GameResultLayer.getTagSettle(),
        } 
    }
end

function GameResultLayer:ctor( parent )
    --注册node事件
    ExternalFun.registerTouchEvent(self, true)

    --加载csb资源
    local csbNode = ExternalFun.loadCSB("game/GameSettleLayer.csb", self)
	
    local bg = csbNode:getChildByName("bg")
    self.m_spBg = bg
	self.m_parent = parent

    -- 结算精灵
--    self.m_spResultSp = bg:getChildByName("spResult")

    local function btnEvent( sender, eventType )
        if eventType == ccui.TouchEventType.ended then
            self:onBtnClick(sender:getTag(), sender)
        end
    end
    -- 继续按钮
    local btn = bg:getChildByName("btnContinue")
    btn:setTag(BT_CONTINUE)
    btn:addTouchEventListener(btnEvent)

    -- 关闭按钮
    btn = bg:getChildByName("btnClose")
    btn:setTag(BT_CLOSE)
    btn:addTouchEventListener(btnEvent)

    -- 换桌按钮
    btn = bg:getChildByName("btn_change_table")
    btn:setTag(BT_CHANGE_TABLE)
    btn:addTouchEventListener(btnEvent)

	self.m_spTimer = csbNode:getChildByName("bg_clock")
	self.m_atlasTimer = self.m_spTimer:getChildByName("atlas_time")
	
	self.m_timeAnimation = ExternalFun.loadTimeLine( "game/GameSettleLayer.csb")
	ExternalFun.SAFE_RETAIN(self.m_timeAnimation)
	csbNode:runAction(self.m_timeAnimation)
 --[[   local str = ""
    self.m_tabClipNickName = {}
    self.m_tabTextCoin = {}
--    self.m_tabFlag = {}

    -- 用户信息
    local csbGroup = bg:getChildByName("u_group")
    for i = 1, 3 do
--        local idx = i - 1
        str = "user_info_" .. i
        local user_info = csbGroup:getChildByName(str)
		local tmp_nick_text = user_info:getChildByName("tmp_nick_text")
        self.m_tabClipNickName[i] = ClipText:createClipText(tmp_nick_text:getContentSize(), "", nil, 30)
        self.m_tabClipNickName[i]:setPosition(tmp_nick_text:getPosition())
        self.m_tabClipNickName[i]:setAnchorPoint(tmp_nick_text:getAnchorPoint())
        csbGroup:addChild(self.m_tabClipNickName[i])
        tmp_nick_text:removeFromParent()

        self.m_tabTextCoin[i] = user_info:getChildByName("tmp_coin")

        str = "flag" .. idx 
--        self.m_tabFlag[i] = csbGroup:getChildByName(str)
    end--]]

    self:hideGameResult()
end

function GameResultLayer:updateClock( clockId, cbTime)
	self.m_atlasTimer:setString( string.format("%02d", cbTime ))
	if cbTime <= 2 then
		self.m_timeAnimation:play("clock_animation_2_4", true)
	elseif cbTime <= 5 then
		self.m_timeAnimation:play("clock_animation_2_3", true)
	elseif cbTime > 5 then
		self.m_timeAnimation:play("clock_normal_2_2" , true)
	end
end

function GameResultLayer:onTouchBegan(touch, event)
    return self:isVisible()
end

function GameResultLayer:onTouchEnded(touch, event)
    local pos = touch:getLocation() 
    local m_spBg = self.m_spBg
    pos = m_spBg:convertToNodeSpace(pos)
    local rec = cc.rect(0, 0, m_spBg:getContentSize().width, m_spBg:getContentSize().height)
    if false == cc.rectContainsPoint(rec, pos) then
        self:hideGameResult()
    end
end

function GameResultLayer:onBtnClick(tag, sender)
    if BT_CONTINUE == tag then
        self:hideGameResult()
       -- self.m_parent:onClickReady()
        self.m_parent:changeTable()
    elseif BT_QUIT == tag then
        self.m_parent:getParentNode():onQueryExitGame()
    elseif BT_CLOSE == tag then
        self:hideGameResult()
	elseif BT_CHANGE_TABLE == tag then
		self:hideGameResult()
		self.m_parent:changeTable()
    end
end

function GameResultLayer:hideGameResult()
    self:reSet()
    self:setVisible(false)
end

function GameResultLayer:showGameResult( rs )
    self:setVisible(true)

	local settle_node = self.m_spBg
    -- 更新图片
	local title_png = "title_win.png"
	if rs.enResult == cmd.kLanderLose or rs.enResult == cmd.kFarmerLose then
		title_png = "title_lost.png"
	end
    local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame(title_png)
    if nil ~= frame then
		local title_node = settle_node:getChildByName("title")
       title_node:setSpriteFrame(frame)
--       titleNode:setVisible(true)
    end
	-- 总倍数
	local multiple_node = settle_node:getChildByName("multiple")
	-- 总倍数
	local m_all_multiple = multiple_node:getChildByName("all_multiple"):getChildByName("all_multiple_num")
	m_all_multiple:setString(rs.m_all_multiple)
	-- 特殊提示
	if rs.bSpecialTip then
		local result_not_enough = settle_node:getChildByName("result_not_enough")
		result_not_enough:setVisible(true)
	end
	-- 叫地主
	local multiple_1 =  multiple_node:getChildByName("multiple_1"):getChildByName("multiple_num")
	multiple_1:setString(rs.m_bank_multiple)
	local index = 2
	-- 炸弹
	if rs.m_bomb_multiple then
		local multiple_sprite = multiple_node:getChildByName("multiple_" .. index)
		local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame("zhadan.png")
		multiple_sprite:setSpriteFrame(frame)
		multiple_sprite:setVisible(true)
		multiple_sprite:getChildByName("multiple_num"):setString(rs.m_bomb_multiple)
		index = index+1
	end
	-- 火箭
	if rs.m_rocket_multiple then
		local multiple_sprite = multiple_node:getChildByName("multiple_" .. index)
		local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame("huojian.png")
		multiple_sprite:setSpriteFrame(frame)
		multiple_sprite:setVisible(true)
		multiple_sprite:getChildByName("multiple_num"):setString(rs.m_rocket_multiple)
		index = index+1
	end
	-- 春天
	if rs.m_chuntian_multiple then
		local multiple_sprite = multiple_node:getChildByName("multiple_" .. index)
		local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame("chuntian.png")
		multiple_sprite:setSpriteFrame(frame)
		multiple_sprite:setVisible(true)
		multiple_sprite:getChildByName("multiple_num"):setString(rs.m_chuntian_multiple)
		index = index+1
	end
	-- 反春天
	if rs.m_fanchuntian_multiple then
		local multiple_sprite = multiple_node:getChildByName("multiple_" .. index)
		local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame("fanchuntian.png")
		multiple_sprite:setSpriteFrame(frame)
		multiple_sprite:setVisible(true)
		multiple_sprite:getChildByName("multiple_num"):setString(rs.m_fanchuntian_multiple)
		index = index+1
	end
	-- 底注
	local dizhu_atlas = settle_node:getChildByName("dizhu"):getChildByName("dizhu_atlas")
	dizhu_atlas:setString(string.formatNumberFhousands(rs.m_lCellScore))
	local u_group = settle_node:getChildByName("u_group")
    -- 更新文本
    for i = 1, 3 do
        local settle = rs.settles[i]
		local user_info = u_group:getChildByName("user_info_" .. i)
        -- ID
		local nick_text = user_info:getChildByName("nick_text")
        nick_text:setString(settle.m_userItem.dwGameID)
		
		-- 用户头像
		local head = PopupInfoHead:createNormalCircle(settle.m_userItem, 73,("Circleframe.png"))
		-- 第二个参数表示弹出的坐标，第三个表示弹出的角度
--		head:enableInfoPop(true, popPosition[viewId], popAnchor[viewId])
		local x,y = user_info:getChildByName("head_bg"):getPosition()
		head:setPosition(cc.p(x,y))     -- 位置校正
--		head:enableHeadFrame(true, {_framefile = "Circleframe.png", _zorder = -1, _scaleRate = 0.75, _posPer = cc.p(0.5, 0.63)})
		user_info:addChild(head)
		local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame("head_frame.png")
		if nil ~= frame then
			local sprite = cc.Sprite:createWithSpriteFrame(frame)
			sprite:setPosition(x,y)
			sprite:setScale(0.86)
			user_info:addChild(sprite)
		end
        -- 金币
		local coinChange = "add"
		local changeFrame = ""
		if settle.m_settleCoin > 0 then
			changeFrame = cc.SpriteFrameCache:getInstance():getSpriteFrame("light_plus.png")
		else
			changeFrame = cc.SpriteFrameCache:getInstance():getSpriteFrame("gray_minus.png")
			coinChange = "reduce"
		end
		user_info:getChildByName("change"):setSpriteFrame(changeFrame)
		local tmp_coin = user_info:getChildByName("tmp_coin")
		local resultStr = "game/result_" .. coinChange .. ".png"
		local coin =  cc.LabelAtlas:_create("12", "game/result_" .. coinChange .. ".png", 25, 33, string.byte('.'))
		coin:setPosition(tmp_coin:getPosition())
		coin:setAnchorPoint(tmp_coin:getAnchorPoint())
        coin:setString(string.formatNumberFhousands(math.abs(settle.m_settleCoin)))
		coin:setTag(i)
		user_info:addChild(coin)
		
		-- 头像
		--[[local head_bg = user_info:getChildByName("head_bg")
		local m_popHead = settle.m_popHead
        m_popHead:setPosition(head_bg:getPosition())
		user_info:addChild(m_popHead)--]]
		
		-- 身份
		local identity_mask = user_info:getChildByName("identity_mask")
		local m_identity = settle.m_identity
		local identityFrame = cc.SpriteFrameCache:getInstance():getSpriteFrame(m_identity .. "_logo.png")
		identity_mask:setSpriteFrame(identityFrame)
		-- 加倍标记
		local jiabeiSprite = user_info:getChildByName("jiabei")
		local isMultiple = settle.isMultiple
		if isMultiple then
			local multipleFrame = cc.SpriteFrameCache:getInstance():getSpriteFrame("jiabei.png")
			jiabeiSprite:setSpriteFrame(multipleFrame)
			jiabeiSprite:setVisible(true)
		else
			jiabeiSprite:setVisible(false)
		end
--[[        -- 标志
        if cmd.kFlagChunTian == settle.m_cbFlag then
            self.m_tabFlag[i]:setString("春天*2")
        elseif cmd.kFlagFanChunTian == settle.m_cbFlag then
            self.m_tabFlag[i]:setString("反春天*2")
        else
            self.m_tabFlag[i]:setString("")
        end--]]
    end
end

function GameResultLayer:reSet()
--    self.m_spResultSp:setVisible(false)
--[[    for i = 1, 3 do
        -- 昵称
        self.m_tabClipNickName[i]:setString("")
        self.m_tabClipNickName[i]:setTextColor(cc.c4b(255,255,255,255))

        -- 金币
        self.m_tabTextCoin[i]:setString("")
        self.m_tabTextCoin[i]:setColor(cc.c4b(255,255,255,255))

        self.m_tabFlag[i]:setString("")
    end--]]
	local settle_node = self.m_spBg
	local multiple_node = settle_node:getChildByName("multiple")
	for i = 2,4 do
		local multiple_sprite = multiple_node:getChildByName("multiple_" .. i)
		multiple_sprite:setVisible(false)
	end
	local u_group = settle_node:getChildByName("u_group")
	for i=1,3 do
		local user_info = u_group:getChildByName("user_info_" .. i)
		user_info:removeChildByTag(i)
	end
	local result_not_enough = settle_node:getChildByName("result_not_enough")
	result_not_enough:setVisible(false)
end

return GameResultLayer