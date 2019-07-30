local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local Trend = class("Trend", cc.Layer)

local publicFunc = appdf.req(appdf.GAME_SRC.."yule.tuitongzi100.src.models.publicFunc")

function Trend:ctor(TrendList)
	local rootLayer, csbNode = ExternalFun.loadRootCSB("trendframe/trendLayer.csb", self)
    self.csbNode = csbNode

    --遮罩层
	self.csbNode:getChildByName("Panel_1"):addClickEventListener(function (sender) ExternalFun.playClickEffect() self:removeFromParent() end)
	self.csbNode:getChildByName("Button_trend"):addClickEventListener(function (sender) ExternalFun.playClickEffect() self:removeFromParent() end)

    self.TrendList = TrendList
    self:initResourse()
end

function Trend:getPoint(num)
	if num == 0 then
		return "零点"
	elseif num == 1 then
		return "一点"
	elseif num == 2 then
		return "二点"
	elseif num == 3 then
		return "三点"
	elseif num == 4 then
		return "四点"
	elseif num == 5 then
		return "五点"
	elseif num == 6 then
		return "六点"
	elseif num == 7 then
		return "七点"
	elseif num == 8 then
		return "八点"
	elseif num == 9 then
		return "九点"
	end
end

function Trend:initResourse()
	local listView = self.csbNode:getChildByName("TrendList")
	local startX = 40
	local startY = 10
	local width = 78
	local num = #self.TrendList

	if num > 20 then
		num = 20
	end

	i = num
	repeat 
		local layout = ccui.Layout:create()
		layout:setContentSize(cc.size(310, 45))

		local score = ""

		--庄家
		if self.TrendList[i].bPointBanker == 32 then
			score = "二八"
		elseif self.TrendList[i].bPointBanker == 64 then
			score = "豹子"
		else
			score = self:getPoint(self.TrendList[i].bPointBanker)
		end
		scoreText = ccui.Text:create(score, "Arial", 26):setPosition(cc.p(startX, startY)):addTo(layout)

		--天门
		if self.TrendList[i].bPointTianMen == 32 then
			score = "二八"
		elseif self.TrendList[i].bPointTianMen == 64 then
			score = "豹子"
		else
			score = self:getPoint(self.TrendList[i].bPointTianMen)
		end
		scoreText = ccui.Text:create(score, "Arial", 26):setPosition(cc.p(startX+width, startY)):addTo(layout)

		--中门
		if self.TrendList[i].bPointZhongMen == 32 then
			score = "二八"
		elseif self.TrendList[i].bPointZhongMen == 64 then
			score = "豹子"
		else
			score = self:getPoint(self.TrendList[i].bPointZhongMen)
		end
		scoreText = ccui.Text:create(score, "Arial", 26):setPosition(cc.p(startX+width*2, startY)):addTo(layout)

		--地门
		if self.TrendList[i].bPointDiMen == 32 then
				score = "二八"
		elseif self.TrendList[i].bPointDiMen == 64 then
			score = "豹子"
		else
			score = self:getPoint(self.TrendList[i].bPointDiMen)
		end
		scoreText = ccui.Text:create(score, "Arial", 26):setPosition(cc.p(startX+width*3, startY)):addTo(layout)
  
		listView:pushBackCustomItem(layout)

		i = i-1
	until i == 0 or i == num-20
end













	
return Trend