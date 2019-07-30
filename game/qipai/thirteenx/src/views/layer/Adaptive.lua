function Adaptive(target)
	local o = {}
	o.w = function(w)	--更改固定宽缩放
		local selfW = target:getContentSize().width
		local csw = w / selfW
		target:setScaleX(csw)
		target.width = w
		target.sw = csw
		return o
	end
	o.h = function(h)	--更改固定高缩放
		local selfH = target:getContentSize().height
		local csh = h / selfH
		target:setScaleY(csh)
		target.height = h
		target.sh = csh
		return o
	end
	o.followSw = function(w,cw,ch)	--跟随宽度缩放图片大小
		local cw = (cw ~= nil and cw) or target:getContentSize().width
		local ch = (ch ~= nil and ch) or target:getContentSize().height
		local csw = w/cw
		target:setScale(csw)
		target.sw = csw
		target.width = cw*csw
		target.height = ch*csw
		return o
	end
	o.followSh = function(h,cw,ch)	--跟随高度缩放图片大小
		local cw = (cw ~= nil and cw) or target:getContentSize().width
		local ch = (ch ~= nil and ch) or target:getContentSize().height
		local csh = h/ch
		target:setScale(csh)
		target.sh = csh
		target.width = cw*csh
		target.height = ch*csh
		return o
	end
	o.position = function(x,y)--更改图片位置
		target.width = (type(target.width) == "nil" and target:getContentSize().width) or target.width
		target.height = (type(target.height) == "nil" and target:getContentSize().height) or target.height
		local cx = x + target.width / 2
		local cy = y - target.height / 2
		target:setPosition(cx,cy)
		target.x = cx
		target.y = cy
		target.py = y
		target.px = x
		return o
	end
	o.font = function(name,fontArray,x,y)--图片文本
		local textBox = display.newNode():addTo(target)
		local textX = 0
		for i = 1 , #fontArray do
			local textSprite = display.newSprite("#"..name..fontArray[i]..".png"):addTo(textBox)
			--textSprite:setPositionX(textX)
			--textSprite:setColor(ccc3(255,255,255))
			textX = textX + textSprite:getContentSize().width + 2
			textSprite:setPositionX(textX)
		end
		textBox:setPositionX(x)
		textBox.width = textX
		o.textBox = textBox
		return o
	end
	return o
end