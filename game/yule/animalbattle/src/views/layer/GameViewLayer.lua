local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local module_pre = "game.yule.animalbattle.src"
local cmd = appdf.req(module_pre .. ".models.CMD_Game")
local ZhuanPanAni=appdf.req(module_pre .. ".views.ZhuanPanAni")
local MenuLayer=appdf.req(module_pre..".views.layer.MenuLayer")
local PlayerlistLayer=appdf.req(module_pre .. ".views.layer.PlayerlistLayer")


local DEBUG=1
if DEBUG==1 then
	dbg_assert=assert
	dbg_print=print
else
	dbg_assert=function() end
	dbg_print=function() end
end

local GameViewLayer = class("GameViewLayer",function(scene)
        return display.newLayer()
end)

function GameViewLayer:ctor(scene)
	self._scene = scene

	self.m_tabPlayerList={}
	self.turnTableRecords={}

	self.noteNumBtns={}
	self.betBtns={}

	self.csbNode=ExternalFun.loadCSB("MainScene.csb",self)
	for i=1,5 do --5个赌注大小按钮
    	self.noteNumBtns[i]=appdf.getNodeByName(self.csbNode,"betnum"..i)
    	--self.noteNumBtns[i].m_noteNum=math.pow(10,i+1)
        self.noteNumBtns[i].m_noteNum=math.pow(10,i-1)
    	self.noteNumBtns[i]:addClickEventListener(function(sender) self._scene:OnNoteSwitch(sender) end)
    end

    self.betBtnPoses={}
    for i=1,11 do --11个动物下注按钮 --betBtns[i]对应
    	local btn=appdf.getNodeByName(self.csbNode,"Button_"..(i))
		btn.m_kind=i
		self.betBtns[i]=btn
		btn:addClickEventListener(function(sender) self._scene:OnPlaceJetton(sender) end)
		self.betBtnPoses[i]=cc.p( btn:getPosition() )
    end


    self.backBtn=appdf.getNodeByName(self.csbNode,"backbtn")
    self.setBtn=appdf.getNodeByName(self.csbNode,"setbtn")
    self.clearBtn=appdf.getNodeByName(self.csbNode,"clearbtn")
    self.continueBtn=appdf.getNodeByName(self.csbNode,"continuebtn")

    self.backBtn:addClickEventListener(function() self._scene:onKeyBack() end)
    local x,y=self.setBtn:getPosition()
    self.setBtn:addClickEventListener(function() self:addChild(MenuLayer:create(self,x,y),100) end)
    self.clearBtn:addClickEventListener(function() self._scene:OnCleanJetton() end)
    self.continueBtn:addClickEventListener(function() self._scene:OnLastPlaceJetton() end)

    self.timeTextImg=ccui.ImageView:create()

    local countBg=appdf.getNodeByName(self.csbNode,"countbg")
    self.timeTextImg:setPosition(100,30)
    countBg:addChild(self.timeTextImg)

    self.recordbg=appdf.getNodeByName(self.csbNode,"recordbg")
 
    self.storagebg=appdf.getNodeByName(self.csbNode,"storagebg")



    self.recordView=nil

    self:initZhuanpan()

    self.storageLabelAtlas=cc.LabelAtlas:create("", "storage.png", 28, 38, string.byte("0")) 
    			:setAnchorPoint(0,0.5)
    			:move(613,612)
    			:addTo(self)
    			:setScaleX(0.91)

    self.brightRects={} --闪烁亮框

    for i=1,3 do
    	self.brightRects[i]=cc.Sprite:create("WinFrame"..i..".png")
    	self.brightRects[i]:addTo(self)
    		:setVisible(false)
    		:setScale(1.2,1.2)
    	self.brightRects[i].m_bVisible=false
    end
	 self.brightRects[1]:setScale(1.3,1.3) --普通动物	
	 self.brightRects[2]:setScale(1.3,1.3)  --鲨鱼
	 self.brightRects[3]:setScale(1.15,1.15)  --飞禽或走兽

	 self:updateTotalScore(0)
	 self:updateCurrentScore(0)

	--self.bAllowOpeningAni=false

   --self.storageLabelAtlas:setVisible(false)
   --	self:testPlayerlistLayer()
   --self:testRecord()
   -- self.testShowJieSuan=nil
   -- if self.testShowJieSuan==1 then
  	-- 	self:showJieSuanView(8,10,155)
   -- end

   --注册node事件
   ExternalFun.registerNodeEvent(self)

end

function GameViewLayer:animationForFirstOpening(duration)
	  self.firstOpeningAni=ZhuanPanAni:create(self,0,0,duration)
  	  self.firstOpeningAni:animationForFirstOpening()
end

-- function GameViewLayer:stopGameOverAnimations()
-- 	self:removeFirstOpeningAni()
-- 	self.oldStatus=self.m_cbGameStatus
-- 	self.statusTimeLeft= self.cbTimeLive
-- 	self.backgroundTime=os.time()
-- 	--self:stopAllActions()
-- 	if self.jsLayer and not tolua.isnull(self.jsLayer) then
-- 		self.jsLayer:removeSelf()
-- 	end
-- 	for k,brightRect in pairs(self.brightRects) do
-- 		if brightRect and not tolua.isnull(brightRect) then
-- 			brightRect:stopAllActions()
-- 			brightRect:setVisible(false)
-- 		end
-- 	end
-- end

-- --需和GameOver一致
-- ----  转两次
--    -- 转盘  js     空闲   二次转盘   js2
-- 	--1-10, 11-13, 14-15, 16-25    ,26-28

-- --转一次
-- 	--转盘,js
-- 	--1-12,13-17 
-- function GameViewLayer:resumeGameOverAnimations()
-- 	if nil==self.backgroundTime then return end
-- 	local curTime=os.time()
-- 	local timeElapsed=curTime-self.backgroundTime
-- 	if self.oldStatus~=cmd.GS_GAME_END or timeElapsed>=self.statusTimeLeft-3 then--开奖状态剩余时间<=3时不再显示动画
-- 		return
-- 	end
-- 	-- if nil==self.turnTableTarget then
-- 	-- 	self:animationforFirstAnimation() 
-- 	-- 	return
-- 	-- end

-- 	local bTurnTwoTime=0 --temp delete
-- 	local timeLeft=self.statusTimeLeft - timeElapsed 
-- 	if bTurnTwoTime==1 then
-- 		-- local elapsed=30-timeLeft
-- 		-- if elapsed<10 then   --zhuanpan
-- 		-- 	self.zhuanPanAni:resumeZhuanPan(timeElapsed)
-- 		-- 	调度第二次转盘
-- 		-- elseif elapsed<13 then --js
-- 		-- 	self:showJieSuanView()
-- 		-- 	调度第二次转盘
-- 		-- elseif elapsed<15 then
-- 		-- 	--空闲
-- 		-- elseif elapsed<25 then --zhuanpan2
-- 		-- 	self.zhuanPanAni=zhuanPanAni:create(...)
-- 		-- elseif elapsed<28 --js2
-- 		-- 	self:showJieSuanView()
-- 		-- end
-- 	else
		
-- 		 local elapsed=20-timeLeft
-- 		 if elapsed<12 then   --zhuanpan
-- 		 	self.zhuanPanAni:resumeZhuanPan(timeElapsed)
-- 		 elseif elapsed<17 then
-- 		 	self:showJieSuanView(self.resultKind1,17-elapsed,self.shaYuAddMulti)
-- 		 end
-- 	end
-- end

function GameViewLayer:testPlayerlistLayer()
	local playerlist={}
	for i=1,3 do 
		playerlist[i]={}
		playerlist[i].szNickName="玩家"..i.."号"
		playerlist[i].wFaceID=100+i
		playerlist[i].lScore=i*i*i*i+10000
	end
	self:addChild(PlayerlistLayer:create(playerlist),10000)
end

function GameViewLayer:testRecord()
	-- self.turnTableRecords={0,1,2,3,4,5,6,7,8,9}--,10,11,0,1,2,3,4,5,6,7,8,9,10,11,5,6,7}
	local i=0
	while i<69 do
		i=i+1
		self:AddTurnTableRecord(i%12)
		self:updateShowTurnTableRecord()
	end
end

function GameViewLayer:getPlayerList()
	--return self.m_tabPlayerList
	return self._scene:getPlayerList()
end

function GameViewLayer:AddTurnTableRecord(betResultId)
	local len=#self.turnTableRecords
	if len >10*cmd.RECORD_COUNT_MAX then   --10可以换成任意大于1的数字
		for i=1,cmd.RECORD_COUNT_MAX-1 do	                    --删除old记录，只保留最近的cmd.RECORD_COUNT_MAX-1个
			self.turnTableRecords[i]=self.turnTableRecords[i+1+len-cmd.RECORD_COUNT_MAX]
		end
		for i=cmd.RECORD_COUNT_MAX,len do
			self.turnTableRecords[cmd.RECORD_COUNT_MAX]=nil
		end
	end
	table.insert(self.turnTableRecords,betResultId)
end

function GameViewLayer:updateShowTurnTableRecord()

	local recordTable=self.turnTableRecords
	local len=#recordTable

	local w,h=68,52
	local cellW=49

	local function scrollViewDidScroll(view)
		local limit=(12-len)*cellW
		if len>12 and view:getContentOffset().x<limit then --view:runAction实现拖拉反弹
			view:setContentOffset(cc.p(limit,0))
		elseif len<=12 and view:getContentOffset().x<0 then
			view:setContentOffset(cc.p(0,0))
		end
	end 

	local function numberOfCellsInTableView()
		return cmd.RECORD_COUNT_MAX 
	end

	local function cellSizeForTable(view,idx) 
    	return cellW,h
	end

	local function tableCellAtIndex(view, idx) --idx从0开始

		local betResId                 --设定recordTable排在后面的（即tableView最顶部的）为最近的的历史记录
		if len<=cmd.RECORD_COUNT_MAX then
			betResId=recordTable[1+idx] 
		else 
			betResId=recordTable[len-cmd.RECORD_COUNT_MAX+1+idx]
		end

		--recordTable保存bet结果ID
    	local cell=view:dequeueCell()
    	
    	local posIndex={4,0,1,2,6,7,5,3,10,8,9,11}--第i种动物在记录合集图中的位置序号
    	if nil==cell then
    		cell=cc.TableViewCell:create()
    	end

    	if nil==betResId then
    		cell:removeAllChildren()
    	else
    		local sp=cell:getChildByTag(betResId)
    		if nil==sp or tolua.isnull(sp) then
    			cell:removeAllChildren()
    			cc.Sprite:create("aniatlas1.png",cc.rect(posIndex[1+betResId]*w,0,w,h))
	        		:setAnchorPoint(cc.p(0,0))
	        		:setPosition(0,0)
	        		:setTag(betResId)
	        		:addTo(cell)
	        end
	    end
    	
    	return cell
	end

	if self.recordView then 
		self.recordView:removeSelf()
	end
	local tableView=cc.TableView:create(cc.size(50*12,h))
	tableView:setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL)
    tableView:setPosition(cc.p(37,26))
    tableView:setDelegate()
    appdf.getNodeByName(self.csbNode,"recordbg"):addChild(tableView)
    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)  
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    tableView:registerScriptHandler(scrollViewDidScroll,cc.SCROLLVIEW_SCRIPT_SCROLL)
    self.recordView=tableView
    tableView:reloadData()
    if #recordTable>12 then
    	local n=math.min(#recordTable,cmd.RECORD_COUNT_MAX)-12
    	tableView:setContentOffset(cc.p(-n*cellW,0))
    end
end


function GameViewLayer:initZhuanpan()
	for i=1,28 do
		local kind=ZhuanPanAni.zhuanpanPosToKind(i)
		local kindToIndex={8,4,7,3,6,5,2,0,1,11,10,9} --在动物合集图上的位置索引
		local circle=cc.Sprite:create("di.png")
		circle:setPosition(ZhuanPanAni.tabZhuanpanPos[i])
		local ani=cc.Sprite:create("aniatlas2.png",cc.rect(kindToIndex[kind+1]*84,0,84,75))
		ani:setPosition(circle:getContentSize().width/2,circle:getContentSize().height/2)
		self:addChild(circle)
		circle:addChild(ani)
	end
end

function GameViewLayer:brightRectBlink(index,showtime,pos)
	self.brightRects[index]:setVisible(true)
			:setPosition(pos)
	self.brightRects[index].m_bVisible=true
	self.brightRects[index]:runAction(cc.Sequence:create(
			cc.Blink:create(showtime,math.ceil(showtime)),
			cc.CallFunc:create(function() self.brightRects[index]:setVisible(false) self.brightRects[index].m_bVisible=false end)))
end

function  GameViewLayer:showJieSuanView(resultKind,showtime,shaYuAddMulti)
	print("resultKind: ",resultKind)
	if resultKind<0 or resultKind>11 or showtime<=0 then return end
	if resultKind~=  cmd.JS_YIN_SHA then 
  		ExternalFun.playSoundEffect( "ANIMAL_SOUND_"..(resultKind)..".wav")
  	end

  	local resultKindToBetBtn={2,3,4,5,6,7,8,1,9,-1,-1,9} 
  	local brightRectPos=self.betBtnPoses[ resultKindToBetBtn[resultKind+1] ]

	local jsLayer=display.newLayer(cc.c4b(60,60,67,100))
	self.jsLayer=jsLayer
	jsLayer:addTo(self)
	if resultKind==cmd.JS_TONG_SHA or resultKind==cmd.JS_TONG_PEI then
		local scaleAct=cc.ScaleBy:create(showtime/3,3)
		local rotateAct=cc.RotateBy:create(showtime/6,20)

		local sp=cc.Sprite:create("js"..resultKind..".png")
		:addTo(jsLayer)
		:setPosition(display.center)
		
		if resultKind==cmd.JS_TONG_SHA then
			sp:runAction(cc.Sequence:create(rotateAct,rotateAct:reverse(),scaleAct,scaleAct:reverse() ))
		end
	elseif resultKind==cmd.JS_JIN_SHA or resultKind==cmd.JS_YIN_SHA then
		
		self:brightRectBlink(2,showtime,brightRectPos)

		if resultKind==cmd.JS_JIN_SHA then
			display.newSprite("jssharklight.png")
				:addTo(jsLayer)
				:setPosition(display.center)
				:runAction(cc.RotateBy:create(showtime,360))
		else
			local emitter1 = cc.ParticleSystemQuad:create("Flower1.plist")
			--local emitter2 = cc.ParticleSystemQuad:create("Flower1.plist")
			jsLayer:addChild(emitter1,10)
			--jsLayer:addChild(emitter2,10)
			emitter1:setPosition(yl.WIDTH/2,yl.HEIGHT/2)--:setScale(1.3,1.1)
			--emitter2:setPosition(yl.WIDTH/2+230,yl.HEIGHT/2)--:setScale(1.3,1.1)
		end
		local shark=display.newSprite("js"..resultKind..".png")
			:addTo(jsLayer)
			:setPosition(display.center)
		if resultKind==cmd.JS_YIN_SHA then
			local x,y=shark:getPosition()
			local sz=shark:getContentSize()
			cc.LabelAtlas:create(shaYuAddMulti,"jssharkdigits.png",37,54,string.byte("0"))
				:setAnchorPoint(0.5,0.5)
				:addTo(shark)
				:setPosition(571,64)
			cc.LabelAtlas:create(24+shaYuAddMulti,"jssharkdigits.png",37,54,string.byte("0"))
				:setAnchorPoint(0.5,0.5)
				:addTo(shark)
				:setPosition(746,64)
		end
	else

		self:brightRectBlink(1,showtime,brightRectPos)
		if resultKind<=3 then 
			self:brightRectBlink(3,showtime,self.betBtnPoses[cmd.ID_FEI_QIN])
		else
			self:brightRectBlink(3,showtime,self.betBtnPoses[cmd.ID_ZOU_SHOU])
		end

		local light=display.newSprite("jslight.png")
		light:addTo(jsLayer)
		light:setPosition(display.center)
		light:runAction(cc.RotateBy:create(showtime,360))
		--local kindToIndex={}  --种类在图集中的位置索引，一致，故省略
		local w,h=297,176
		cc.Sprite:create("jsaniatlas.png",cc.rect( w*resultKind,0,w,h))
			:addTo(jsLayer)
			:setPosition(yl.WIDTH/2,yl.HEIGHT/2+50)

		cc.Sprite:create("jsnum"..resultKind..".png")
			:addTo(jsLayer)
			:setPosition(display.center.x,300)
	end

	jsLayer:runAction(
		cc.Sequence:create(
			cc.DelayTime:create(showtime),
			cc.CallFunc:create(function() 
				--if self.testShowJieSuan==1 then self:showJieSuanView(resultKind+1,showtime,shaYuAddMulti) end--for test temp delete
					jsLayer:removeSelf() 
					end)
		))
end

function GameViewLayer:enableBetBtns(bEnable) 
	for i=1,11 do
		self.betBtns[i]:setEnabled(bEnable)
	end
end

function GameViewLayer:enableAllBtns(bEnable)
	for i=1,5 do
		self.noteNumBtns[i]:setEnabled(bEnable)
	end
	for i=1,11 do
		self.betBtns[i]:setEnabled(bEnable)
	end
	self.clearBtn:setEnabled(bEnable)
	self.continueBtn:setEnabled(bEnable)
end

function GameViewLayer:enable_NoteNum_Clear_ContinueBtn(bEnable)
	for i=1,5 do
		self.noteNumBtns[i]:setEnabled(bEnable)
	end
	self.clearBtn:setEnabled(bEnable)
	self.continueBtn:setEnabled(bEnable)
end

function GameViewLayer:disableNoteNumBtns(startIndex)
	for i=startIndex,5 do
		self.noteNumBtns[i]:setEnabled(false)
	end
end

function GameViewLayer:enableNoteNumBtns(endIndex)
	for i=1,endIndex do
		self.noteNumBtns[i]:setEnabled(true)
	end
end

local leftAligned=0
local centerAligned=1
local rightAligned=2

local storageDigitKind=1
local countDigitKind=2
local totalbetDigitKind=3
local mybetDigitKind=4
local totalscoreDigitKind=5
local assetDigitKind=6
local curscoreDigitKind=7
local digitSpriteConfig={ --数字图片配置  --彩金池靠右对齐，其余居中对齐  --dis表示数字间间距
	{name="storagenum",filepath="storage.png",w=50,h=40 ,dis=5,align=leftAligned}, --彩金池 --pos为中心距离
	{name="countnum",filepath="countnum.png",w=31,h=40,dis=5,align=centerAligned}, --倒计时 --以下pos为最右距离
	{name="totalbetnum",filepath="allbetnum.png",w=12,h=16,dis=0,align=centerAligned},  --总下注
	{name="mybetnum",filepath="mebetnum.png",w=12,h=16,dis=0,align=centerAligned},  --自己下注
	{name="scorenum",filepath="score.png",w=17,h=20,dis=0,align=centerAligned},   --总得分 ,可能为负数
	{name="assetnum",filepath="score.png",w=17,h=20,dis=0,align=centerAligned},	--玩家资产
	{name="curscorenum",filepath="score.png",w=17,h=20,dis=0,align=centerAligned},
}



function GameViewLayer:updateNumberPic(kind,bg,pos,number)--左对齐则pos为左边界位置，中心对齐则pos为中心位置
	dbg_assert(bg)
	dbg_assert(not tolua.isnull(bg))
	print("updateNumberPic kind: ",kind)

	local numbersNode=bg:getChildByName(digitSpriteConfig[kind].name)
	if numbersNode and not tolua.isnull(numbersNode) then
		numbersNode:removeSelf()
	end

	if nil==number then return end
	
	local function getDigits(number)
		dbg_assert(number)
		local sign=number>=0 and 1 or -1
		if number<0 then number=-number end
		local digits={}
		if number==0 then
			digits[1]=0
			return digits
		end
		while number~=0 do
			local residue=number%10
			number=math.floor(number/10)
			table.insert(digits,residue)
		end
		if sign<0 then table.insert(digits,'-') end  --else table.insert(digits,'+') 
		return digits
	end

	local function newDigitSp(filepath,digit,w,h) --digit单个数字0-9
		if digit=='+' then 
			digit=10 
		elseif digit=='-' then 
			digit=11 
		end
		return cc.Sprite:create( filepath,cc.rect(w*digit,0,w,h) )
	end

	local digits=getDigits(number) --将number的每个位上数字存入table
	dbg_assert(#digits>0)

	local dsc=digitSpriteConfig[kind]
	local node=cc.Node:create() --对于一个size为0的node，setAnchorPoint(,)会对其子节点的显示有影响吗?
	node:addTo(bg):setName(digitSpriteConfig[kind].name)
	
	print("number: ",number)
	for i=1,#digits do
		print(i,digits[i])
		local sp= newDigitSp(dsc.filepath,digits[i],dsc.w,dsc.h)
		print("digits[i]: ",digits[i])
		print("number: ",number)
		sp:addTo(node)
		sp:setAnchorPoint(0,0)
		sp:setPosition( (dsc.dis+dsc.w)*(#digits-i),0 )
	end

	local totalWidth= (#digits) * (dsc.dis+dsc.w)
	if dsc.align==centerAligned then
		node:setPosition(pos.x-totalWidth/2,pos.y)
	elseif dsc.align==rightAligned then
		node:setPosition( pos.x-totalWidth,pos.y)
	elseif dsc.align==leftAligned then
		node:setPosition(pos)
	end
end



function GameViewLayer:updateTotalBets(tabBets)
	print("updateTotalBets")
	for i=1,cmd.AREA_COUNT-1 do
		print(i..":  "..(tabBets[i] or 0))
		if tabBets[i]==0 then
			self:updateTotalBet(i,nil)
		else
			self:updateTotalBet(i,tabBets[i])
		end
	end
end

function GameViewLayer:updateMyBets(tabBets)
	for i=1,cmd.AREA_COUNT-1 do
		if tabBets[i]==0 then
			self:updateMyBet(i,nil)
		else
			self:updateMyBet(i,tabBets[i])
		end
	end
end

function GameViewLayer:updateTotalBet(kind,num)
	print("kind: ",kind)
	local bg=self.betBtns[kind]
	local sz=bg:getContentSize()
	local x=sz.width/2
	if kind-1==cmd.AREA_FEI_QIN or kind-1==cmd.AREA_ZOU_SHOU then
		x=x-50
	end
	self:updateNumberPic( totalbetDigitKind,bg,cc.p(x,20),num )
end

function GameViewLayer:updateMyBet(kind,num)
	local bg=self.betBtns[kind]
	local sz=bg:getContentSize()
	local x=sz.width/2
	if kind-1==cmd.AREA_FEI_QIN or kind-1==cmd.AREA_ZOU_SHOU then
		x=x-50
	end
	self:updateNumberPic( mybetDigitKind,bg,cc.p(x,40),num )
end

function GameViewLayer:playBackgroundMusic()
	if self.m_cbGameStatus==cmd.GS_GAME_END then
		 ExternalFun.playBackgroudAudio( "GAME_START.wav" )
	else
		 ExternalFun.playBackgroudAudio("GAME_FREE.wav")
	end
end

function GameViewLayer:updateCurrentScore(score)
	self:updateNumberPic( curscoreDigitKind,appdf.getNodeByName(self.csbNode,"curscorebg"),cc.p(185,17),score )
end

function GameViewLayer:updateTotalScore(score)
	self:updateNumberPic( totalscoreDigitKind,appdf.getNodeByName(self.csbNode,"totalscore"),cc.p(185,17),score )
end

function GameViewLayer:updateAsset(assetNum)
	self:updateNumberPic( assetDigitKind,appdf.getNodeByName(self.csbNode,"asset"),cc.p(185,17),assetNum )
end

function GameViewLayer:updateCountDown(clockTime)
	self:updateNumberPic( countDigitKind,appdf.getNodeByName(self.csbNode,"countbg"),cc.p(230,10),clockTime)
end

function GameViewLayer:updateStorage(num) --彩金池
	--self:updateNumberPic( storageDigitKind,appdf.getNodeByName(self.csbNode,"storagebg"),cc.p(100,10),num)
    self.storageLabelAtlas:setString(num)
end

function GameViewLayer:enableBtns(bEnable)
	for i=1,5 do
		self.noteNumBtns[i]:setEnabled(bEnable)
	end
	self.clearBtn:setEnabled(bEnable)
	self.continueBtn:setEnabled(bEnable)
end

function GameViewLayer:SetGameStatus(gameStatus) --设置显示得分
	self.m_cbGameStatus=gameStatus
end

function GameViewLayer:updateTimeTextImg() --休闲时间、下注时间、开奖时间 图片

	if self.m_cbGameStatus==cmd.GAME_STATUS_FREE then
		self.timeTextImg:loadTexture("xiuxianshijian.png",0)   --LOCAL = 0,PLIST = 1
	elseif self.m_cbGameStatus==cmd.GS_PLACE_JETTON then
		self.timeTextImg:loadTexture("xiazhushijian.png",0)
	elseif self.m_cbGameStatus==cmd.GS_GAME_END	then
		self.timeTextImg:loadTexture("kaijiangshijian.png",0)
	else 
		dbg_assert(false)
	end
end

function  GameViewLayer:removeFirstOpeningAni( )
	if self.firstOpeningAni and not tolua.isnull(self.firstOpeningAni) then
		self.firstOpeningAni:removeSelf()
		self.firstOpeningAni=nil
	end
end

local function printn(n,...)
	local i=0
	while i<n do
		i=i+1
		print(...)
	end
end

function GameViewLayer:OnUpdataClockView(clockViewChair,clockTime)

	local t=os.time()

	self.cbTimeLive=clockTime
	self:updateCountDown(clockTime)
	if self.m_cbGameStatus==cmd.GS_PLACE_JETTON and clockTime<5 then
		ExternalFun.playSoundEffect( "TIME_WARIMG.wav")
	end

	if (self.m_cbGameStatus~=cmd.GS_GAME_END or (clockTime>0 and clockTime<=3)) then
		if self.jsLayer and not tolua.isnull(self.jsLayer) then
			if self.testShowJieSuan~=1 then self.jsLayer:removeSelf() end
		end

		if self.zhuanPanAni and not tolua.isnull(self.zhuanPanAni) then
			self.zhuanPanAni:removeSelf()
			--printn(100000,"clockTime: ",clockTime,"  m_cbGameStatus: ",self.m_cbGameStatus)
		end
		for i=1,#self.brightRects do
			if true==self.brightRects[i].m_bVisible then
				--printn(100,i.." clockTime: ",clockTime,"  m_cbGameStatus: ",self.m_cbGameStatus)
				self.brightRects[i]:stopAllActions()
				self.brightRects[i]:setVisible(false)
				self.brightRects[i].m_bVisible=false
			end
		end
	end

	local dt
	dt=self.lastupdataT==nil and 0 or t-self.lastupdataT
	if dt<=1 
	  or (self._lastStatus==cmd.GS_PLACE_JETTON and self.m_cbGameStatus==cmd.GS_PLACE_JETTON and dt<self._lastTimeLive) 
	  or (self._lastStatus==cmd.GS_GAME_END and self.m_cbGameStatus==cmd.GS_GAME_END and dt<self._lastTimeLive)
	then
		--donothing
	else
		print("dt: ",dt)
		self._scene:clearBets()
	end

	if self._lastStatus==cmd.GS_GAME_END  and dt>=self._lastTimeLive then --and self._lastTimeLive>0
		self:updateCurrentScore(0)
	end

	if self.bTurnTwoTime==1 and self._lastStatus==cmd.GS_GAME_END and self.m_cbGameStatus==cmd.GS_GAME_END and self._lastTimeLive-dt>3 and self._lastTimeLive-dt<13 then
		self.bTurnTwoTime=0
		self.showAnims(self,2)
	end

	self.lastupdataT=t
	self._lastStatus=self.m_cbGameStatus
	self._lastTimeLive=clockTime
end

function GameViewLayer:GameOver( nTurnTableTarget, curGameScore,cumulativeScore ,shaYuAddMulti) --转盘结束后更新记录 self.tabRecords
 	self.nTurnTableTarget=nTurnTableTarget
 	self.resultKind1= ZhuanPanAni.zhuanpanPosToKind(nTurnTableTarget[1])
 	self.shaYuAddMulti=shaYuAddMulti
 --bTurnTwoTime为1时，开奖时间为30秒	                   
 	local totalSec=20-3
	self.bTurnTwoTime=0
	if nTurnTableTarget[2]>=1 and nTurnTableTarget[2]<=28  then self.bTurnTwoTime=1 end
	local deltaT=2 --连续两次开奖动画间隔时间
	local dur=12 --转盘时间
	local durations={dur,0}
	if self.bTurnTwoTime==1 then
		totalSec=(30-2-deltaT)/2  --=13
		durations[1]=dur-2
		durations[2]=dur-2
	end

	local function showAnims(self,i)
		if self.m_cbGameStatus~=cmd.GS_GAME_END then return end
		self:AddTurnTableRecord(ZhuanPanAni.zhuanpanPosToKind(nTurnTableTarget[i]))
		local zhuanPanAni=ZhuanPanAni:create(self,1,nTurnTableTarget[i],durations[i],totalSec)
		self.zhuanPanAni=zhuanPanAni
		local resultKind=ZhuanPanAni.zhuanpanPosToKind(nTurnTableTarget[i])
		local function callback(resttime)
			if self.m_cbGameStatus~=cmd.GS_GAME_END then return end
			self:showJieSuanView(resultKind,resttime,shaYuAddMulti)
			self:updateShowTurnTableRecord()
			self:updateCurrentScore(curGameScore)
			self:updateTotalScore(cumulativeScore)
			self:updateAsset(GlobalUserItem.lUserScore)
		end
		zhuanPanAni:ZhuanPan(callback)
	end
	
	showAnims(self,1)
	
	-- if bTurnTwoTime==1 then  --放到updataClockView了，后台切换
	-- 	self:runAction(
	-- 		cc.Sequence:create(cc.DelayTime:create(totalSec+deltaT),
	-- 			cc.CallFunc:create(function() showAnims(self,2) end))
	-- 		)
	-- end
	self.showAnims=showAnims
end


function GameViewLayer:onExit()
	
	for i=8,11 do
		cc.Director:getInstance():getTextureCache():removeTextureForKey("js"..i..".png")
	end
	cc.Director:getInstance():getTextureCache():removeTextureForKey("background.png")
	cc.Director:getInstance():getTextureCache():removeUnusedTextures()
    cc.SpriteFrameCache:getInstance():removeUnusedSpriteFrames()

    --播放大厅背景音乐
    ExternalFun.playPlazzBackgroudAudio()

end

--银行操作成功
function GameViewLayer:onBankSuccess( )
	if self._bankLayer and not tolua.isnull(self._bankLayer) then
		self._bankLayer:onBankSuccess()
	end
end

function GameViewLayer:onBankFailure( )
	if self._bankLayer and not tolua.isnull(self._bankLayer) then
		self._bankLayer:onBankFailure()
	end
end

function GameViewLayer:onGetBankInfo(bankinfo)
	if self._bankLayer and not tolua.isnull(self._bankLayer) then
		self._bankLayer:onGetBankInfo(bankinfo)
	end
end

function GameViewLayer:OnUpdateUser(viewId, userItem, bLeave)
    local myViewId=self._scene:SwitchViewChairID(self._scene:GetMeChairID()) 
    if viewId==myViewId then
    	return 
    end
	if bLeave then
		self.m_tabPlayerList[viewId]=nil
		print(viewId.." leave")
	else
		if userItem then
			print("viewId", viewId)
			self.m_tabPlayerList[viewId]=userItem
		end
	end
end

return GameViewLayer
