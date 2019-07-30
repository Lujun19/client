local publicFunc = class("publicFunc")

--创建下注分数标签
function publicFunc:createScoreLabel(score)
	local layout = ccui.Layout:create()
	local textScore =  cc.LabelAtlas:create(score,"game/no/headframeno.png",18,28,string.byte("."))
					 :setAnchorPoint(0,0.5)
					 :addTo(layout)
	self.img = cc.Sprite:create("game/no/nostr.png")
					:setAnchorPoint(0,0.5)

	self.img1 = cc.Sprite:create("game/yi.png")
					:setAnchorPoint(0, 0.5)

	--数字与万之间的间隙
	local gap = 2

	local width = 0
	local height = textScore:getContentSize().height

	if score >= 100000000 then
		score = string.format("%0.2f",score/100000000)
		width = textScore:getContentSize().width + self.img:getContentSize().width + gap
		textScore:setString(score)
		self:removeNode(self.img)
		self.img1:addTo(layout)
		self.img1:setPosition(cc.p(textScore:getContentSize().width + gap, height/2))
	elseif score >= 10000 then
		score = string.format("%0.2f",score/10000)
		width = textScore:getContentSize().width + self.img:getContentSize().width + gap
		textScore:setString(score)
		self:removeNode(self.img1)
		self.img:addTo(layout)
		self.img:setPosition(cc.p(textScore:getContentSize().width + gap, height/2))
	else
		width = textScore:getContentSize().width
	end

	layout:setContentSize(cc.size(width,height))
	textScore:setPosition(cc.p(0, height/2))
	return layout
end

function publicFunc:removeNode(node)
	if node then
		node:removeFromParent()
	end
end

return publicFunc