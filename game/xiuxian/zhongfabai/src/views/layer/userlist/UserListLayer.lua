--
-- Author: zhong
-- Date: 2016-07-07 18:09:11
--
--玩家列表
local module_pre = "game.xiuxian.zhongfabai.src"

local ExternalFun = require(appdf.EXTERNAL_SRC .. "ExternalFun")
local g_var = ExternalFun.req_var;
local UserItem = module_pre .. ".views.layer.userlist.UserItem"
local PopupInfoHead = appdf.EXTERNAL_SRC .. "PopupInfoHead"

local UserListLayer = class("UserListLayer", cc.Layer)
--UserListLayer.__index = UserListLayer
UserListLayer.BT_CLOSE = 1
UserListLayer.BT_LAST = 2
UserListLayer.BT_NEXT = 3

function UserListLayer:ctor(viewparent)
	--注册事件
	local function onLayoutEvent( event )
		if event == "exit" then
			self:onExit();
        elseif event == "enterTransitionFinish" then
        	self:onEnterTransitionFinish();
        end
	end
	self:registerScriptHandler(onLayoutEvent)
	
	self.m_parent = viewparent
	
	--用户列表
	self.m_userlist = {}

	--加载csb资源
	local csbNode = ExternalFun.loadCSB("game/UserListLayer.csb", self)

	local sp_bg = csbNode:getChildByName("sp_userlist_bg")
	self.m_spBg = sp_bg
	local content = sp_bg:getChildByName("content")

	--用户列表
--[[	local m_tableView = cc.TableView:create(content:getContentSize())
	m_tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
	m_tableView:setPosition(content:getPosition())
	m_tableView:setDelegate()
	m_tableView:registerScriptHandler(self.cellSizeForTable, cc.TABLECELL_SIZE_FOR_INDEX)
	m_tableView:registerScriptHandler(handler(self, self.tableCellAtIndex), cc.TABLECELL_SIZE_AT_INDEX)
	m_tableView:registerScriptHandler(handler(self, self.numberOfCellsInTableView), cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
	sp_bg:addChild(m_tableView)
	self.m_tableView = m_tableView;
	content:removeFromParent()--]]

	--按钮
	local function btnEvent( sender, eventType )
		if eventType == ccui.TouchEventType.ended then
			self:onButtonClickedEvent(sender:getTag(), sender);
		end
	end
	local btn = sp_bg:getChildByName("close_btn")
	btn:setTag(UserListLayer.BT_CLOSE)
	btn:addTouchEventListener(btnEvent);

	--content:removeFromParent()
	
	--在线人数
	self.m_playerNumText = sp_bg:getChildByName("Text_playernum")
	self.m_playerNumText:setString("")
	--翻页按钮
	self.m_btLast = sp_bg:getChildByName("Button_last")
	self.m_btLast:setTag(UserListLayer.BT_LAST)
	self.m_btLast:addTouchEventListener(btnEvent);
	
	self.m_btNext = sp_bg:getChildByName("Button_next")
	self.m_btNext:setTag(UserListLayer.BT_NEXT)
	self.m_btNext:addTouchEventListener(btnEvent);
	--当前页码
	self.m_currentPageText = sp_bg:getChildByName("Text_current_page")
	self.m_currentPageText:setString("")
	self.m_currentPage = 1
	--总页数
	self.m_totlePageText = sp_bg:getChildByName("Text_totle_page")
	self.m_totlePageText:setString("")
	self.m_totlePage = 1
	--玩家信息
	self.m_playerInfoNode = {}
	local str = ""
	for i=1,15 do
		str = string.format("Node_playerInfo_%d",i)
		self.m_playerInfoNode[i] = sp_bg:getChildByName(str)
		self.m_playerInfoNode[i]:setVisible(false)
		self.m_playerInfoNode[i]:getChildByName("Sprite_coin"):setVisible(false)
	end
	--玩家头像
	self.m_playerHead = {}
	--座位玩家
	self.m_rankUser = {}
	--玩家列表(重新排序后)
	self.m_rankUserList = {}
end

function UserListLayer:refreshList( userlist,rankUser )
	self:setVisible(true)
	self.m_userlist = userlist
	--self.m_tableView:reloadData()
	local sitCount = 0
	for i=1, 8 do
		self.m_rankUser[i] = rankUser[i]
		if rankUser[i] ~= nil and rankUser[i] ~= yl.INVALID_CHAIR then
			sitCount = sitCount + 1
		end
	end
	local num = #self.m_userlist
	local otherCount = num-sitCount
	if otherCount<0 then
		otherCount = 0
	end
	self.m_playerNumText:setString(otherCount)

	self.m_totlePage = math.ceil(otherCount/15)
	if self.m_totlePage <= 0 then
		self.m_totlePage = 1
	end
	self.m_totlePageText:setString("/"..self.m_totlePage)
	self.m_currentPageText:setString(self.m_currentPage)
	
	--不显示座位玩家，对玩家列表重新排序
	self.m_rankUserList = {}
	local nCount = 1
	for i = 1, num do
		if userlist[i] ~= nil then
			local isExist = false
			for j = 1, 8 do
				if rankUser[j] ~= nil and userlist[i].wChairID == rankUser[j] then	
					isExist = true
					break
				end
			end	
			if not isExist then
				self.m_rankUserList[nCount] = userlist[i]
				nCount = nCount + 1					
			end
		end
	end

	self.m_btLast:setEnabled(true)
	self.m_btNext:setEnabled(true)
	if self.m_totlePage == 1 then
		self.m_btLast:setEnabled(false)
		self.m_btNext:setEnabled(false)
	elseif self.m_currentPage == 1 then
		self.m_btLast:setEnabled(false)
	elseif self.m_currentPage == self.m_totlePage then
		self.m_btNext:setEnabled(false)
	else
		self.m_btLast:setEnabled(true)
		self.m_btNext:setEnabled(true)
	end
	
	local mgr = nil
	if self.m_parent ~= nil then
		mgr = self.m_parent:getDataMgr()
	end
		
	for i=1, 15 do
		--移除头像
		if nil ~= self.m_playerHead[i] then
			self.m_playerHead[i]:removeFromParent()
			self.m_playerHead[i] = nil
		end
		
		local item = nil
		local index = (self.m_currentPage-1)*15+i
		local chair = nil
		if self.m_rankUserList[index] ~= nil then
			chair = self.m_rankUserList[index].wChairID
			item = mgr:getChairUserList()[chair + 1]
			if chair == yl.INVALID_CHAIR then
				item = self.m_rankUserList[index]
			end
		end
		
		--item = self.m_rankUserList[index]

		if item ~= nil then
			self.m_playerInfoNode[i]:setVisible(true)
			
			local tmp = self.m_playerInfoNode[i]:getChildByName("player_head")
			local head = g_var(PopupInfoHead):createNormal(item, 50)
			if head ~= nil then
				head:setPosition(tmp:getPositionX(),tmp:getPositionY())
				self.m_playerInfoNode[i]:addChild(head)	
			end
			self.m_playerHead[i] = head
			
			local nickName = self.m_playerInfoNode[i]:getChildByName("Text_name")
			--local lScore = self.m_playerInfoNode[i]:getChildByName("Text_score")
			local szAddress = self.m_playerInfoNode[i]:getChildByName("Text_score")
			nickName:setString("ID:"..item.dwGameID)
			local strAddress = item.szAdressLocation
--[[			if string.len(strAddress) > 21 then
				strAddress = string.sub(strAddress,1,21)..".."
			end--]]
			szAddress:setString(strAddress)
		else
			self.m_playerInfoNode[i]:setVisible(false)
		end
	end
end

--tableview
function UserListLayer.cellSizeForTable( view, idx )
	return g_var(UserItem).getSize()
end

function UserListLayer:numberOfCellsInTableView( view )
	if nil == self.m_userlist then
		return 0
	else
		return #self.m_userlist
	end
end

function UserListLayer:tableCellAtIndex( view, idx )
	local cell = view:dequeueCell()
	
	if nil == self.m_userlist then
		return cell
	end

	local useritem = self.m_userlist[idx+1]
	local item = nil

	if nil == cell then
		cell = cc.TableViewCell:new()
		item = g_var(UserItem):create()
		item:setPosition(view:getViewSize().width * 0.5, 0)
		item:setName("user_item_view")
		cell:addChild(item)
	else
		item = cell:getChildByName("user_item_view")
	end

	if nil ~= useritem and nil ~= item then
		item:refresh(useritem, false, idx / #self.m_userlist)
	end

	return cell
end
--

function UserListLayer:onButtonClickedEvent( tag, sender )
	ExternalFun.playClickEffect()
	if UserListLayer.BT_CLOSE == tag then
		self:setVisible(false)
		self.m_currentPage =1
	elseif UserListLayer.BT_LAST == tag then
		self:onButtonLast()
	elseif UserListLayer.BT_NEXT == tag then
		self:onButtonNext()
	end
end
function UserListLayer:onButtonLast()
	self.m_currentPage = self.m_currentPage - 1
	self.m_currentPageText:setString(self.m_currentPage)
	self.m_btNext:setEnabled(true)
	if self.m_currentPage == 1 then
		self.m_btLast:setEnabled(false)
	end

	local mgr = nil
	if self.m_parent ~= nil then
		mgr = self.m_parent:getDataMgr()
	end
		
	for i=1, 15 do
		--移除头像
		if nil ~= self.m_playerHead[i] then
			self.m_playerHead[i]:removeFromParent()
			self.m_playerHead[i] = nil
		end
		
		local item = nil
		local index = (self.m_currentPage-1)*15+i
		local chair = nil
		if self.m_rankUserList[index] ~= nil then
			chair = self.m_rankUserList[index].wChairID
			item = mgr:getChairUserList()[chair + 1]
			if chair == yl.INVALID_CHAIR then
				item = self.m_rankUserList[index]
			end
		end
		
		--item = self.m_rankUserList[index]
		
		if item ~= nil then
			self.m_playerInfoNode[i]:setVisible(true)
			
			local tmp = self.m_playerInfoNode[i]:getChildByName("player_head")
			local head = g_var(PopupInfoHead):createNormal(item, 50)
			if head ~= nil then
				head:setPosition(tmp:getPositionX(),tmp:getPositionY())
				self.m_playerInfoNode[i]:addChild(head)
			end
			self.m_playerHead[i] = head
			
			local nickName = self.m_playerInfoNode[i]:getChildByName("Text_name")
			--local lScore = self.m_playerInfoNode[i]:getChildByName("Text_score")
			local szAddress = self.m_playerInfoNode[i]:getChildByName("Text_score")
			nickName:setString("ID:"..item.dwGameID)
			local strAddress = item.szAdressLocation
--[[			if string.len(strAddress) > 21 then
				strAddress = string.sub(strAddress,1,21)..".."
			end--]]
			szAddress:setString(strAddress)
		else
			self.m_playerInfoNode[i]:setVisible(false)
		end
	end
end
function UserListLayer:onButtonNext()
	self.m_currentPage = self.m_currentPage + 1
	self.m_currentPageText:setString(self.m_currentPage)
	self.m_btLast:setEnabled(true)
	if self.m_currentPage == self.m_totlePage then
		self.m_btNext:setEnabled(false)
	end

	local mgr = nil
	if self.m_parent ~= nil then
		mgr = self.m_parent:getDataMgr()
	end
		
	for i=1, 15 do
		--移除头像
		if nil ~= self.m_playerHead[i] then
			self.m_playerHead[i]:removeFromParent()
			self.m_playerHead[i] = nil
		end
		
		local item = nil
		local index = (self.m_currentPage-1)*15+i
		local chair = nil
		if self.m_rankUserList[index] ~= nil then
			chair = self.m_rankUserList[index].wChairID
			item = mgr:getChairUserList()[chair + 1]
			if chair == yl.INVALID_CHAIR then
				item = self.m_rankUserList[index]
			end
		end
		
		--item = self.m_rankUserList[index]

		if item ~= nil then
			self.m_playerInfoNode[i]:setVisible(true)
			
			local tmp = self.m_playerInfoNode[i]:getChildByName("player_head")
			local head = g_var(PopupInfoHead):createNormal(item, 50)
			if head ~= nil then
				head:setPosition(tmp:getPositionX(),tmp:getPositionY())
				self.m_playerInfoNode[i]:addChild(head)
			end
			self.m_playerHead[i] = head
			
			local nickName = self.m_playerInfoNode[i]:getChildByName("Text_name")
			--local lScore = self.m_playerInfoNode[i]:getChildByName("Text_score")
			local szAddress = self.m_playerInfoNode[i]:getChildByName("Text_score")
			nickName:setString("ID:"..item.dwGameID)
			local strAddress = item.szAdressLocation
--[[			if string.len(strAddress) > 21 then
				strAddress = string.sub(strAddress,1,21)..".."
			end--]]
			szAddress:setString(strAddress)
		else
			self.m_playerInfoNode[i]:setVisible(false)
		end
	end
		
end

function UserListLayer:onExit()
	local eventDispatcher = self:getEventDispatcher()
	eventDispatcher:removeEventListener(self.listener)
end

function UserListLayer:onEnterTransitionFinish()
	self:registerTouch()
end

function UserListLayer:registerTouch()
	local function onTouchBegan( touch, event )
		return self:isVisible()
	end

	local function onTouchEnded( touch, event )
		local pos = touch:getLocation();
		local m_spBg = self.m_spBg
        pos = m_spBg:convertToNodeSpace(pos)
        local rec = cc.rect(0, 0, m_spBg:getContentSize().width, m_spBg:getContentSize().height)
        if false == cc.rectContainsPoint(rec, pos) then
            self:setVisible(false)
			self.m_currentPage =1
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

return UserListLayer