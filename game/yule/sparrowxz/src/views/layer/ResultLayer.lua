local cmd = appdf.req(appdf.GAME_SRC.."yule.sparrowxz.src.models.CMD_Game")
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC.."ExternalFun")
local CardLayer = appdf.req(appdf.GAME_SRC.."yule.sparrowxz.src.views.layer.CardLayer")
local PopupInfoHead = appdf.req("client.src.external.PopupInfoHead")
local GameLogic = appdf.req(appdf.GAME_SRC.."yule.sparrowxz.src.models.GameLogic")
local ClipText = appdf.req(appdf.EXTERNAL_SRC .. "ClipText")
local PlayerInfo = appdf.req(appdf.GAME_SRC.."yule.sparrowxz.src.views.layer.PlayerInfo")

local ResultLayer = class("ResultLayer", function(scene)
	local resultLayer = cc.CSLoader:createNode(cmd.RES_PATH.."gameEnd/GameEnd.csb")
	return resultLayer
end)


function ResultLayer:ctor(scene,tabUserItem,tabHupaiInfo,tagCharts,leftUserViewId)
	--assert(scene)
	self._scene=scene
	self.m_tabPlayer={}
	for i=1,cmd.GAME_PLAYER do
		self.m_tabPlayer[i]=self:getChildByName("FileNode_"..i)
	end

	self:initPlayerInfo(tabUserItem,tabHupaiInfo,leftUserViewId)
	self:initMyDetails(tagCharts)
	local btnExit = self:getChildByName("Button_exit")
	btnExit:addClickEventListener(function(ref)
		print("退出")
		self._scene:onButtonClickedEvent(self._scene.BT_EXIT)
	end)

	local btContinue = self:getChildByName("Button_ready")
	btContinue:addClickEventListener(function(ref)
		self._scene:removeExitedUsers()
		self._scene:onButtonClickedEvent(self._scene.BT_START)
		self:removeSelf()
	end)

	ExternalFun.registerTouchEvent(self,true)
end

function ResultLayer:onTouchBegan()
	return true
end

function ResultLayer:initPlayerInfo(tabUserItem,tabHupaiInfo,leftUserViewId)
	for i=1,cmd.GAME_PLAYER do
		local node=self.m_tabPlayer[i]
		local head=PopupInfoHead:createNormal(tabUserItem[i], 76)
		--创建裁剪
	    local strClip = "game/head_mask.png"
	    clipSp = cc.Sprite:create(strClip)
	    local clip = cc.ClippingNode:create()
	        --裁剪
	    local headbg=node:getChildByName("playerNode")
	    local sz=headbg:getContentSize()
	    clip:setStencil(clipSp)
	    clip:setAlphaThreshold(0.01)
	    clip:addChild(head)
	    clip:addTo(headbg)
	    clip:setPosition(sz.width/2,sz.height/2)

		local clipText=ClipText:createClipText({width=130,height=30},tabUserItem[i].szNickName)
		clipText:setTextFontSize(24)
		clipText:setAnchorPoint(cc.p(0,0.5))
	    clipText:addTo(node:getChildByName("name"))
	    if leftUserViewId==i then
	    	node:getChildByName("bHupai"):setString(tabHupaiInfo[i].bHu==true and "已离开" or "逃跑")
	    else
			node:getChildByName("bHupai"):setString(tabHupaiInfo[i].bHu==true and "胡牌" or "未胡牌")
		end
		print("tabHupaiInfo[i].gameScore:",tabHupaiInfo[i].gameScore)
		local scorestr=tabHupaiInfo[i].gameScore
		if scorestr==nil then scorestr="0" 
		elseif scorestr>=0 then scorestr="+"..tabHupaiInfo[i].gameScore 
		else node:getChildByName("coinnum"):setTextColor(cc.c4b(0x58,0x6e,0xbe,0xff)) end
		node:getChildByName("coinnum"):setString( scorestr)
	end
end

function ResultLayer:initMyDetails(tagCharts)

	--local tagChart={charttype=cmd.CHARTTYPE.HUJIAOZHUANYI_TYPE,lTimes=200,lScore=20000,bEffectChairID={true,true,true,true}}
	--tagCharts={tagChart,tagChart,tagChart,tagChart,tagChart,tagChart,tagChart,tagChart,tagChart,tagChart}


	local temp={}
	for i=1,#tagCharts do
		print("self.myTagCharts"..i..".charttype:", tagCharts[i].charttype)
		local tagChart=tagCharts[i]
		if tagChart and tagChart.lScore~=0 and tagChart.charttype~=cmd.CHARTTYPE.INVALID_CHARTTYPE then
			table.insert(temp,tagChart)
		end
	end
	tagCharts=temp

	local function numberOfCellsInTableView()
		local n=1
		for k,tagChart in pairs(tagCharts) do
			if tagChart.charttype~=cmd.CHARTTYPE.INVALID_CHARTTYPE then
				n=n+1
			end
		end
		return n
	end

	local function cellSizeForTable(view,idx) 
    	return 560,30
	end

	local function tableCellAtIndex(view, idx) --idx从0开始
		local tagChart=tagCharts[idx+1]
     	local cell=view:dequeueCell()
    	if nil==cell then
    		cell=cc.TableViewCell:create()
    	end
    	if cell:getChildByTag(1)==nil then
    		cc.CSLoader:createNode("gameEnd/Node_end_list.csb")
    			:addTo(cell)
    			:setTag(1)
    			:setPosition(-25,-15)
    	end
    	if tagChart==nil or tagChart.charttype==cmd.CHARTTYPE.INVALID_CHARTTYPE then cell:removeAllChildren() return cell end
    	local node=cell:getChildByTag(1)
    	node:getChildByName("kind"):setString(cmd.CHARTTYPESTR[tagChart.charttype-21])
    	node:getChildByName("times"):setString(tagChart.lTimes.."倍")
    	local score=tagChart.lScore
    	if score>=0 then 
    		score="+"..score 
    		node:getChildByName("score"):setTextColor(cc.c4b(0xc0,0x4d,0x45,0xff))
    	else
    		node:getChildByName("score"):setTextColor(cc.c4b(0x58,0x6e,0xbe,0xff))
    	end
    	node:getChildByName("score"):setString(score)

    	local strs={}
    	local objs={"","下家","上家","对家"}
    	for i=1,cmd.GAME_PLAYER do
    		if tagChart.bEffectChairID[i]==true then
    			local viewid=self._scene._scene:SwitchViewChairID(i-1)
   				if viewid~=cmd.MY_VIEWID then table.insert(strs,objs[viewid]) end
   			end
    	end
    	node:getChildByName("obj"):setString(table.concat(strs, "、"))
    	return cell
     end

    local tableView=cc.TableView:create(cc.size(560,132))
	tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setPosition(cc.p(0,0))
    tableView:setDelegate()
    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)  
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    tableView:setVerticalFillOrder(0)
    tableView:reloadData()
    tableView:addTo(self:getChildByName("mydetailbg"))
end

return ResultLayer