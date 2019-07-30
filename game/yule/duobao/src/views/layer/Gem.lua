--
-- Author: garry
-- Date: 2017-2-23
--
local Gem = class("Gem",function(type,px,py)
	local gem =  display.newSprite()
	return gem
end)


function Gem:ctor(type,px,py)
	--print("gem type ======"..type)
	self._type = type
	self._flag =false
	self._isDestroy = false
	self._px = px
	self._py = py
	self:addAnimation("anim_gem_"..type.."_",11,0.1,true)

end

function Gem:showDestroy()
	self:stopAllActions()
	self:addAnimation("anim_boom_",8,0.1,false)
end

function Gem:addAnimation( path,num,actionTime,repeatFlag)

    local frames = {}
    for i=0,num do
      local frameName  = string.format(path.."%d.png", i)
      --local spriteN = cc.Sprite:create(frameName)

      --local frame = cc.SpriteFrame:create(frameName,cc.rect(0,0,spriteN:getContentSize().width,spriteN:getContentSize().height))
      local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame(frameName)
      table.insert(frames, frame)
    end

    local  animation =cc.Animation:createWithSpriteFrames(frames,actionTime)

    --local sprite = cc.Sprite:create(path.."0.png")
    self:setTexture(path.."0.png")

    local action = cc.RepeatForever:create(cc.Animate:create(animation))
    if repeatFlag then
        self:runAction(action)
    else
        self:runAction(cc.Sequence:create(cc.Animate:create(animation),cc.CallFunc:create(function ()
          self:setVisible(false)
          end)))
    end

    return sprite
end

return Gem