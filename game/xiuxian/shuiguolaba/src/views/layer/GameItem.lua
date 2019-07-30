local ExternalFun = require(appdf.EXTERNAL_SRC .. "ExternalFun")

local cmd = "game.xiuxian.shuiguolaba.src.models.CMD_Game"

local emItemState = 
{
	"STATE_NORMAL",		--正常
	"STATE_SELECT",		--中奖
	"STATE_GREY"		--变灰
}
local ITEM_STATE = ExternalFun.declarEnumWithTable(0, emItemState);

local GameItem = class("GameItem",cc.ClippingRectangleNode)

GameItem.GAME_IMG_TAG = 100

function GameItem:ctor(  )

end
--初始化
function GameItem:created( nType ,number )

	self.m_bIsEnd = false
	self.m_nType = -1
	self.m_pSprite = nil

    self.number = number
	self:initNotice()
	self:setItemType(nType)
end

function GameItem:initNotice(  )
	self:setClippingRegion(cc.rect(0,0,200,380))
	self:setClippingEnabled(true)

end

function GameItem:setItemType( nType )
	self.m_nType = nType
   
end

function GameItem:getItemType( )
	return self.m_nType
end

function GameItem:beginMove( deyTime )
	if self.m_pSprite == nil then
        local fraeSprite = string.format("common_MoveImg.png")
		self.m_pSprite = cc.Sprite:create(fraeSprite)
	end
	self:addChild(self.m_pSprite)
    print"---------------------------------------------------------------------------------------------------------------------------------------"
	self.m_pSprite:setPosition(cc.p(90,285))
      if self.number ==3 or self.number==6 or self.number==9 or self.number ==12 or self.number==15 then
    local actMove = cc.RepeatForever:create(
    	cc.Sequence:create(
    		cc.MoveBy:create(0.6,cc.p(0,-1350)),
            cc.MoveTo:create(0.01,cc.p(90,285))
    		)
    	)
      actMove:setTag(GameItem.GAME_IMG_TAG)
    self.m_pSprite:runAction(actMove)
    else
    self.m_pSprite:setVisible(false)
    end

	self.m_pSprite:runAction(
		cc.Sequence:create(
			cc.DelayTime:create(deyTime),
			cc.CallFunc:create(function (  )
				self:beginJump()
			end)
			)
		)
end



---最后定型的图片 
function GameItem:beginJump(  )   
	if self.m_bIsEnd == true then
		return
	end
	local strPath = 
	{
-------------------正常大小---------------------------
		"jump_xiangjiao_0%d.png",
        "jump_xigua_0%d.png",
        "jump_mangguo_0%d.png",
        "jump_putao_0%d.png",
        "jump_boluo_0%d.png",
        "jump_lingdang_0%d.png",
        "jump_yingtao_0%d.png",
        "jump_bar_0%d.png",
        "jump_juzi_0%d.png",
        "jump_scatter_0%d.png",
        "jump_wild_0%d.png",
	}
    	local strPath1 = 
	{
-------------------放大过的----------------------
		"jump_xiangjiao_11.png",
        "jump_xigua_11.png",
        "jump_mangguo_11.png",
        "jump_putao_11.png",
        "jump_boluo_11.png",
        "jump_lingdang_11.png",
        "jump_yingtao_11.png",
        "jump_bar_11.png",
        "jump_juzi_11.png",
        "jump_scatter_11.png",
        "jump_wild_11.png",
	}
        local posy = (self.number-1)%3 + 1

	    if self.m_pSprite ~= nil then
         self.m_pSprite:setVisible(true)
		self.m_pSprite:stopAction(self.m_pSprite:getActionByTag(GameItem.GAME_IMG_TAG))
        local spriteFirstFrame 
        if posy == 2 then  
        spriteFirstFrame = cc.SpriteFrameCache:getInstance():getSpriteFrame(string.format(strPath1[self.m_nType], 1))  
		self.m_pSprite:setSpriteFrame(spriteFirstFrame)
        else
		spriteFirstFrame = cc.SpriteFrameCache:getInstance():getSpriteFrame(string.format(strPath[self.m_nType], 1))  
		self.m_pSprite:setSpriteFrame(spriteFirstFrame)
        end
		local animation =cc.Animation:create()  --可以用这一个
		for i=1,5 do
		    local frameName =string.format(strPath[self.m_nType],i)  

		    --print("frameName =%s",frameName)
		    local spriteFrame = cc.SpriteFrameCache:getInstance():getSpriteFrame(frameName)
		   animation:addSpriteFrame(spriteFrame)
		end  
	   --	animation:setDelayPerUnit(0.05)          --设置两个帧播放时间                   
	   	animation:setRestoreOriginalFrame(true)    --动画执行后还原初始状态    

	   	local action =cc.Animate:create(animation)   

	   	local seq = cc.Sequence:create(
	   		action,
	   		cc.CallFunc:create(function (  )
	   			self.m_bIsEnd = true
	   		end)
	   		)
	self.m_pSprite:runAction(seq)
	self.m_pSprite:setAnchorPoint(0.5,0.5)

    if posy == 1 then
	    self.m_pSprite:setPosition(cc.p(self.m_pSprite:getContentSize().width/2+50,self.m_pSprite:getContentSize().height/2+290))
    elseif posy == 2 then
        if self.number ==2 or self.number == 5 then
             self.m_pSprite:setPosition(cc.p(self.m_pSprite:getContentSize().width/2+35,self.m_pSprite:getContentSize().height/2+165))
        else
             self.m_pSprite:setPosition(cc.p(self.m_pSprite:getContentSize().width/2+45,self.m_pSprite:getContentSize().height/2+165))
        end
    else
        self.m_pSprite:setPosition(cc.p(self.m_pSprite:getContentSize().width/2+50,self.m_pSprite:getContentSize().height/2+55))
    end
   end
end

function GameItem:stopAllItemAction(  )
	self.m_bIsEnd = true
	if self.m_pSprite ~= nil then
		self.m_pSprite:stopAllActions()
	else
		print("不存在这个GameItem")
	end
--	self:setState() --正常
	self:stopAllActions()
end


function GameItem:setState(  )  
	self.m_bIsEnd = true
	local strPath = 
	{
       "jump_xiangjiao_0%d.png",
        "jump_xigua_0%d.png",
        "jump_mangguo_0%d.png",
        "jump_putao_0%d.png",
        "jump_boluo_0%d.png",
        "jump_lingdang_0%d.png",
        "jump_yingtao_0%d.png",
        "jump_bar_0%d.png",
        "jump_juzi_0%d.png",
        "jump_scatter_0%d.png",
        "jump_wild_0%d.png",
    --------------------------------
	}

--	--序列帧数目   
--        for  index = 1, 3 do
--	    if self.m_pSprite ~= nil then
--           self.m_pSprite:setVisible(fslse)
--        end
--        local nodeStr = string.format("Image_%d",index)   
--        local node = nodePanal:getChildByName(nodeStr)

--        local m_Sprite =  cc.Sprite:create()
--		local spriteFirstFrame = cc.SpriteFrameCache:getInstance():getSpriteFrame(string.format(strPath[self.m_nType[index]], 1))  
--        if m_Sprite then
--		    m_Sprite:setSpriteFrame(spriteFirstFrame)
--        else
--        	m_Sprite = cc.Sprite:create()
--			m_Sprite:setSpriteFrame(spriteFrame)
--        end
--	   m_Sprite:setAnchorPoint(0.5,0.5)
--	   m_Sprite:setPosition(cc.p(m_Sprite:getContentSize().width/2+60,m_Sprite:getContentSize().height/2+135))
--    end

end

return GameItem