local module_pre = "game.yule.animalbattle.src"

local PopupLayer=appdf.req(module_pre .. ".views.layer.PopupLayer")
local ExternalFun =  appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")

local PlayerlistLayer=class("PlayerlistLayer",PopupLayer)

function PlayerlistLayer:ctor(playerlist)
	PlayerlistLayer.super.ctor(self)
	self.csbNode=ExternalFun.loadCSB("PlayerlistLayer.csb",self)
	self.bg=appdf.getNodeByName(self.csbNode,"bg")
	self.cellBase=appdf.getNodeByName(self.csbNode,"playernode")
	
	self.cellBase:setPosition(70,25)
	
	self:showPlayerList(playerlist)
	self.cellBase:removeSelf()
	self.cellBase:retain()
	self.closeBtn=appdf.getNodeByName(self.csbNode,"closebtn")
	self.closeBtn:addClickEventListener(function() self:removeSelf() end)
end

function PlayerlistLayer:showPlayerList(mplayerlist)
	local playerlist={}
	for k,v in pairs(mplayerlist) do
		table.insert(playerlist,v)
	end

	local function sortFunc(user1,user2) --按VIP等级从大到小、金币数从大到小
		local vip1=user1.cbMemberOrder or 0
		local vip2=user2.cbMemberOrder or 0
		local coin1=user1.lScore or 0
		local coin2=user2.lScore or  0
		if vip1~=vip2 then
			return vip1>vip2
		end
		return coin1>coin2
	end

	table.sort(playerlist,sortFunc)

	local len= #playerlist

	local function numberOfCellsInTableView()
		return len --DefPlayerlistRows
	end

	local function cellSizeForTable(table,idx) 
    	return 800,70
	end

	local function tableCellAtIndex(table, idx) --idx从0开始
		print("idx "..idx)
    	local cell=table:dequeueCell()
    	local playerNode
    	if nil==cell then
    		cell=cc.TableViewCell:create()
    		playerNode=self.cellBase:clone()
    		cc.LabelAtlas:create("", "coindigits.png", 17, 22, string.byte("0")) 
    			:setAnchorPoint(0.5,0.5)
    			:move(468,0)
    			:addTo(playerNode)
    			:setName("coinnum")
    		cell:addChild(playerNode)
    		playerNode:setName("playerNode")

    	end
    	
    	if nil==playerNode then
    		playerNode=cell:getChildByName("playerNode")
    	end
    	playerInfo=playerlist[idx+1]
		local usrName=playerInfo.szNickName
		local headId=playerInfo.wFaceID
		local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame("Avatar"..headId..".png")
		if frame then
			appdf.getNodeByName(playerNode,"head"):loadTexture("Avatar"..headId..".png",1) --1表示TextureResType::plist
    	end

    	local vip=playerInfo.cbMemberOrder or 0
    	local vipsp=playerNode:getChildByName("vipsp")
    	if vipsp~=nil then vipsp:removeSelf() end
    	if vip>=1 and vip<=5 then
			cc.Sprite:create("atlas_vipnumber.png",cc.rect(28*vip,0,28,26))
				:setName("vipsp")
				:addTo(playerNode)
				:setPosition(300,-5)
    	end

    	appdf.getNodeByName(playerNode,"usrname"):setString(usrName)
    	appdf.getNodeByName(playerNode,"coinnum"):setString(playerInfo.lScore.."")
        
    	return cell
	end

	local tableView=cc.TableView:create(cc.size(800,400))
	tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
	tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setPosition(cc.p(0,80))
    tableView:setDelegate()
    self.bg:addChild(tableView)
    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)  
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    self.recordView=tableView
    tableView:reloadData()
end

function PlayerlistLayer:onExit()
	self.cellBase:release()
	PlayerlistLayer.super.onExit(self)
end

return PlayerlistLayer