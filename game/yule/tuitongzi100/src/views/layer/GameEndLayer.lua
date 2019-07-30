local GameLogic = appdf.req(appdf.GAME_SRC.."yule.tuitongzi100.src.models.GameLogic")
local CardSprite = appdf.req(appdf.GAME_SRC.."yule.tuitongzi100.src.views.layer.CardSprite")
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")

local GameEnd = class("GameEnd", cc.Layer)

function GameEnd:ctor(cmd_table, parent)
	local cardArray = cmd_table.cbTableCardArray
	local bankerScore = cmd_table.lBankerScore
	local myScore = cmd_table.lUserScore

	if next(cardArray) == nil then return end
	
	local rootLayer, csbNode = ExternalFun.loadRootCSB("result/gameEnd.csb", self)
    self.csbNode = csbNode

    --显示输赢分数
    self:winScore(bankerScore, myScore)

    self.csbNode:getChildByName("Button_confirm"):addClickEventListener(function (sender)
    		parent:removeGameEnd()
    	end)
	self:showResult(cardArray, bankerScore, myScore)

	--结束声音
	if myScore >= 0 then 
		ExternalFun.playSoundEffect("END_WIN.wav")  
	else
		ExternalFun.playSoundEffect("END_LOST.wav")
	end

	--添加时间标签
	-- self:showTime(parent, cmd_table)
end

--移除定时器
function GameEnd:removeTimer()
	if self.timer then
		cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.timer)
	end
end

function GameEnd:showTime(parent, cmd_table)
	self.time = cmd_table.cbTimeLeave
	function upDate()
		self.time = 5
		self.csbNode:getChildByName("AtlasLabel_time"):setString(self.time)
		if self.time == 0 then
			self:removeTimer()
			parent:removeGameEnd()
		end
	end
	self.timer = cc.Director:getInstance():getScheduler():scheduleScriptFunc(upDate, 1, false)
end

function GameEnd:winScore(bankerScore, myScore)
	local text = ""
	if bankerScore >= 0 then
		cc.LabelAtlas:create(bankerScore,"game/no/winno.png",16,21,string.byte("+")):addTo(self):setPosition(cc.p(-195, 202))
	else
		cc.LabelAtlas:create(bankerScore,"game/no/failno.png",16,21,string.byte("+")):addTo(self):setPosition(cc.p(-195, 202))
	end

	if myScore >= 0 then
		cc.LabelAtlas:create(myScore,"game/no/winno.png",16,21,string.byte("+")):addTo(self):setPosition(cc.p(168, 202))
	else
		cc.LabelAtlas:create(myScore,"game/no/failno.png",16,21,string.byte("+")):addTo(self):setPosition(cc.p(168, 202))
	end
end

function GameEnd:showResult(cardArray, bankerScore, myScore)
	local startX = -92
	local startY = 138
	local heightGap = 107

	--两张麻将之间的宽度
	local gap = 62

	if myScore >= 0 then 
		self.csbNode:getChildByName("successnotice"):setVisible(true)
	else
		self.csbNode:getChildByName("failednotice"):setVisible(true)
	end

	for i=1, #cardArray do
		for j=1, #cardArray[i] do
			local mj1 = CardSprite:createCard(cardArray[i][j]):addTo(self)
				  mj1:setScale(0.65)
				  mj1:setPosition(cc.p(startX+(j-1)*gap, startY-(i-1)*heightGap))
		end

		local pointImg = CardSprite:createPoint(cardArray[i])
			  pointImg:setScale(0.85)
			  pointImg:setPosition(cc.p(99, startY-(i-1)*heightGap))
			  pointImg:addTo(self)

		if i==1 then
			if bankerScore>=0 then
				local winImg = cc.Sprite:create("result/win.png"):addTo(self)
					winImg:setPosition(cc.p(248, startY))
			else
				local failedImg = cc.Sprite:create("result/failed.png"):addTo(self)
					failedImg:setPosition(cc.p(248, startY))
			end
		else
			local winer = GameLogic.GetWinner(cardArray[1], cardArray[i])
			if winer == GameLogic.WINER.PLAYER_ONE then
               	local failedImg = cc.Sprite:create("result/failed.png"):addTo(self)
				failedImg:setPosition(cc.p(248, startY-(i-1)*heightGap))
            else
               local winImg = cc.Sprite:create("result/win.png"):addTo(self)
					winImg:setPosition(cc.p(248, startY-(i-1)*heightGap))
            end
		end
	end
end

return GameEnd