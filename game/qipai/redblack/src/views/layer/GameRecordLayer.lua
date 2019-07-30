--
--
--游戏记录界面
local module_pre = "game.qipai.redblack.src";
local ExternalFun = require(appdf.EXTERNAL_SRC .. "ExternalFun")
local g_var = ExternalFun.req_var;
local cmd = require(module_pre .. ".models.CMD_Game")

local GameRecordLayer = class("GameRecordLayer", cc.Layer)

GameRecordLayer.BT_CLOSE = 1

function GameRecordLayer:ctor(viewparent)
	--注册事件
	local function onLayoutEvent( event )
		if event == "exit" then
			self:onExit();
        elseif event == "enterTransitionFinish" then
        	self:onEnterTransitionFinish();
        end
	end
	self:registerScriptHandler(onLayoutEvent);

	self.m_parent = viewparent


	--加载csb资源
	local csbNode = ExternalFun.loadCSB("record/GameRecord.csb", self)

	--统计数据
    self.m_textzhongwin = csbNode:getChildByName("zhongwin_text")
    self.m_textpingwin = csbNode:getChildByName("pingwin_text")
    self.m_textbaiwin = csbNode:getChildByName("baiwin_text")  
    self.m_textbaozi = csbNode:getChildByName("baozi_text")
    self.m_texttiangang = csbNode:getChildByName("tiangang_text")
	self.m_textzhongwin:setString("")
	self.m_textpingwin:setString("")
	self.m_textbaiwin:setString("")
	self.m_textbaozi:setString("")
	self.m_texttiangang:setString("")
	
	local function btnEvent( sender, eventType )
		if eventType == ccui.TouchEventType.ended then
			self:onButtonClickedEvent(sender:getTag(), sender);
		end
	end	
	--关闭按钮
	local  btn = csbNode:getChildByName("Button_close")
	btn:setTag(GameRecordLayer.BT_CLOSE);
	btn:addTouchEventListener(btnEvent);
	--记录列表
	self.m_recordListView = csbNode:getChildByName("ListView")
	self.m_recordItem = csbNode:getChildByName("ListItem")
	--背景图片
	self.m_spBg = csbNode:getChildByName("Image_bg")
	
	
end

function GameRecordLayer:onEnterTransitionFinish()
	self:registerTouch()
end

function GameRecordLayer:onExit()
	local eventDispatcher = self:getEventDispatcher()
	eventDispatcher:removeEventListener(self.listener)
end
function GameRecordLayer:onButtonClickedEvent( tag, sender )
	
	if GameRecordLayer.BT_CLOSE == tag then
		self:setVisible(false)
	end
end
function GameRecordLayer:registerTouch(  )
	local function onTouchBegan( touch, event )
		return self:isVisible()
	end

	local function onTouchEnded( touch, event )
		local pos = touch:getLocation();
		local m_spBg = self.m_spBg
        pos = m_spBg:convertToNodeSpace(pos)
        local rec = cc.rect(0, 0, m_spBg:getContentSize().width, m_spBg:getContentSize().height)
        if false == cc.rectContainsPoint(rec, pos) then
            self:showLayer(false)
        end        
	end

	local listener = cc.EventListenerTouchOneByOne:create();
	listener:setSwallowTouches(true)
	self.listener = listener;
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN );
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED );
    local eventDispatcher = self:getEventDispatcher();
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self);
end

function GameRecordLayer:showLayer( var )
	self:setVisible(var)
end


function GameRecordLayer:refreshRecordList(  )
	if nil == self.m_parent then
		return
	end
	self.m_recordListView:removeAllChildren()
	
	local mgr = self.m_parent:getDataMgr()

	--统计数据
	local vec = mgr:getRecords()
	local nTotal = #vec
	local zhongwinCount = 0
	local baiwinCount = 0
	local pingwinCount = 0
	local baoziCount = 0
	local tiangangCount = 0

	for i = 1,nTotal do
		local rec = vec[i]
		if cmd.AREA_ZHONG == rec.m_cbGameResult then
			zhongwinCount = zhongwinCount+1
		elseif cmd.AREA_BAI == rec.m_cbGameResult then
			baiwinCount = baiwinCount+1
		end
		local zhonePoint = rec.m_pServerRecord.cbPlayerCount
		local baiPoint = rec.m_pServerRecord.cbBankerCount

		if zhonePoint == 10 or baiPoint == 10 then
			baoziCount = baoziCount+1
		end
		if zhonePoint == 11 or baiPoint == 11 then
			tiangangCount = tiangangCount+1
		end
			
	end
	self.m_textzhongwin:setString(zhongwinCount)
	self.m_textbaiwin:setString(baiwinCount)
	self.m_textpingwin:setString(pingwinCount)
	self.m_textbaozi:setString(baoziCount)
	self.m_texttiangang:setString(tiangangCount)
	
	--插入记录
	local str1 = ""
	local str2 = ""
	local str3 = ""
	local str4 = ""
	local nCount = 1
	
	for i=nTotal,1,-1 do
		local newRec = vec[i]
		
		if cmd.AREA_ZHONG == newRec.m_cbGameResult then
			str1 = "record/dragon_charts_wan_red.png"
			str2 = "record/dragon_charts_wan_gray.png"
			str3 = "font/dragon_wan_win_fnt.fnt"
			str4 = "font/dragon_wan_lose_fnt.fnt"
		elseif cmd.AREA_BAI == newRec.m_cbGameResult then
			str1 = "record/dragon_charts_wan_gray.png"
			str2 = "record/dragon_charts_wan_red.png"
			str3 = "font/dragon_wan_lose_fnt.fnt"
			str4 = "font/dragon_wan_win_fnt.fnt"
		end
		local zhonePoint = newRec.m_pServerRecord.cbPlayerCount
		local baiPoint = newRec.m_pServerRecord.cbBankerCount
		
		local item = self.m_recordItem:clone()
		
		if item ~= nil then
			item:getChildByName("Sprite_zhong"):loadTexture(str1)
			item:getChildByName("Sprite_bai"):loadTexture(str2)
	
			local zhongPointFnt = item:getChildByName("Sprite_zhong"):getChildByName("record_FontLabel")
			local baiPointFnt = item:getChildByName("Sprite_bai"):getChildByName("record_FontLabel")
			
			zhongPointFnt:setFntFile(str3)
			baiPointFnt:setFntFile(str4)
			
			if zhonePoint<10 then
				zhongPointFnt:setString(zhonePoint)
			elseif zhonePoint == 10 then
				zhongPointFnt:setString("豹")
			elseif zhonePoint == 11 then
				zhongPointFnt:setString("杠")
			end
			if baiPoint<10 then
				baiPointFnt:setString(baiPoint)
			elseif baiPoint == 10 then
				baiPointFnt:setString("豹")
			elseif baiPoint == 11 then
				baiPointFnt:setString("杠")
			end
			
			local recordIndex = item:getChildByName("Text_num")
			recordIndex:setString(nCount)
		end
					
		self.m_recordListView:pushBackCustomItem(item)
		
		nCount = nCount+1
	end
	
end

return GameRecordLayer