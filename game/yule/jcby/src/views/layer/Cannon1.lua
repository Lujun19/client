--
-- Author: Tang
-- Date: 2016-08-09 10:27:07
--炮
local Cannon = class("Cannon", cc.Sprite)
local module_pre = "game.yule.jcby.src"			
local ExternalFun = require(appdf.EXTERNAL_SRC.."ExternalFun")
local cmd = module_pre..".models.CMD_LKPYGame"
--local Bullet = module_pre..".views.layer.Bullet"
local Bullet = require(module_pre..".views.layer.Bullet1")
local QueryDialog = appdf.req("app.views.layer.other.QueryDialog")
local g_var = ExternalFun.req_var
local scheduler = cc.Director:getInstance():getScheduler()
local Game_CMD = appdf.req(module_pre .. ".models.CMD_LKPYGame")
Cannon.Tag = 
{

	Tag_Award = 10,
	Tag_Light = 20,
	Tag_Type  = 30,
	Tag_lock  = 3000

}

local sinf = math.sin
local cosf = math.cos
local rad = math.rad
function Cannon.getPos(bReversal,chairId)
	local pos = chairId
	if bReversal then 
		if pos == 0 then
			pos = 2
        elseif pos == 1 then
            pos = 3
        elseif pos == 2 then
            pos = 0
        elseif pos == 3 then
            pos = 1
		end
	end
	return pos
end

local TagEnum = Cannon.Tag

function Cannon:ctor(viewParent)
	

	self.m_pos = 0    --炮台位置
	self.m_fort = nil
	self.m_nickName = nil
	self.m_score = nil
	self.m_multiple = nil
	self.m_isShoot = false
	self.m_canShoot = true
	self.m_autoShoot = false
	self.m_typeTime = 0
	self.orignalAngle = 0
	self.m_fishIndex = Game_CMD.INT_MAX
	self.m_index  = 0 --子弹索引
	self.m_ChairID  = yl.INVALID_CHAIR
	self.m_autoShootSchedule = nil
	self.m_otherShootSchedule = nil
	self.m_typeSchedule = nil

	self.m_targetPoint = cc.p(0,0)
	self.m_cannonPoint = cc.p(0,0)
	self.m_firelist = {}
    self.m_bullet= {}
    self.power=0               --能量
    self.fangle=0
    self.ifno = true
    self.fireSpeed = 0.24
    self.m_otherLock = false
	--self.m_nCurrentBulletScore = 1000
	self.m_nMutipleIndex = 0
    
	self.m_Type = Game_CMD.CannonType.Normal_Cannon--Game_CMD.CannonType.Laser_Cannon
	self.parent = viewParent

	self._dataModel = self.parent._dataModel
	self.frameEngine = self.parent._gameFrame 
    self.fPos = cc.p(0,0)
	self.m_laserPos = cc.p(0,0)

	self.m_laserConvertPos = cc.p(0,0)

	self.m_laserBeginConvertPos = cc.p(0,0)
    self.m_other = false
    self.bubbleList = {}
    

--获取自己信息
	self.m_pUserItem = self.frameEngine:GetMeUserItem()
  	self.m_nTableID  = self.m_pUserItem.wTableID
  	self.m_nChairID  = self.m_pUserItem.wChairID	

--其他玩家信息
  	self.m_pOtherUserItem = nil

 	self.m_goldList = {} -- 游戏币动画
 	self.m_goldIndex = 1 -- 游戏币动画
 	--游戏币横幅红绿切换
 	self.m_nBannerColor = 0
  	--注册事件
    ExternalFun.registerTouchEvent(self,false)
end

function Cannon:setCurrentBulletScore(value)
    self.m_nCurrentBulletScore = value
end

function Cannon:onExit( )
    self:unLock1Schedule()
    self:unLock2Schedule()
	self:unAutoSchedule()
	self:unTypeSchedule()
	self:unOtherSchedule()
end


function Cannon:setCannonMuitle(multiple)
	self.m_nMutipleIndex = multiple
end

function Cannon:initWithUser(userItem)
	
	self.m_ChairID = userItem.wChairID
	if self.m_ChairID ~= self.m_nChairID then
		self.m_pOtherUserItem = userItem
        self.m_other = true
	end

	self:setContentSize(100,100)
	self:removeChildByTag(1000)
	self.m_fort = cc.Sprite:createWithSpriteFrameName("pao_1_1.png")
	self.m_fort:setTag(1000)

    if self.m_nChairID<2 then
	    if self.m_ChairID ~= self.m_nChairID and self.m_ChairID>=2 then
	       self.m_fort:setPosition(50,50)
        else
           self.m_fort:setPosition(50,-5)
        end
    else
	    if self.m_ChairID ~= self.m_nChairID and self.m_ChairID<2 then
	       self.m_fort:setPosition(50,50)
        else
           self.m_fort:setPosition(50,-5)
        end
    end
    self.m_fort:setAnchorPoint(0.5, 0.2)
	self:addChild(self.m_fort,1)
	self.m_pos = userItem.wChairID

	--self.m_nChairID = userItem.wChairID

	local nMyNum = 0

	if self.m_nChairID >2 then
		nMyNum = 1
	end

	local nPlayerNum = 0

	if userItem.wChairID > 2 then
		nPlayerNum = 1
	end
	self.m_pos = Cannon.getPos(self._dataModel.m_reversal,self.m_pos)
	--[[
	if self._dataModel.m_reversal  then 
		if self.m_pos <= 5 then
			self.m_pos = 5 - self.m_pos
		else
			if self.m_pos == 6 then
				self.m_pos = 7
			elseif self.m_pos == 7 then
				self.m_pos = 6
			end	
		end
	end
	--]]
	
	if self.m_pos < 2 then
		self.m_fort:setRotation(180)
	end

	 
    self.fPos = cc.p(self.m_fort:getPositionX(), self.m_fort:getPositionY())


    for i = 1, 30 do
        local bubble = display.newSprite("bubble_res/lockBubble.png")
        self:addChild(bubble, 1000)
        bubble:setName("bubble_" .. i)
        bubble:setPosition(2000, 2000)
    end
    local bubble = display.newSprite(string.format("bubble_res/lock_bubble_%d.png", self.m_ChairID + 1))
    self:addChild(bubble, 1000)
    bubble:setName("big_bubble")
    bubble:setPosition(2000, 2000)
    
    self:lockBubble1()
    self:lockBubble2()
end

function Cannon:setFishIndex(index)
	self.m_fishIndex = index
end

function Cannon:setMultiple(multiple)

	--dump(self._dataModel.m_secene.nMultipleIndex, "xxxxis ===========================", 6)
	--print("mutiple is =========================="..multiple)
    if multiple == nil then
       return
    end

	self.m_nMutipleIndex = self.parent.parent.CurrShoot[1][self.m_ChairID+1]        -- multiple / self.parent.parent.CellShoot

	local nMultipleValue = self.parent.parent.CurrShoot[1][self.m_ChairID+1]

	self.m_nCurrentBulletScore = nMultipleValue

	local nNum = 1
	local bulletNum = 1
    if nMultipleValue / self.parent._dataModel.m_secene.MaxShoot >= 0 and nMultipleValue / self.parent._dataModel.m_secene.MaxShoot <= 0.1 then
        bulletNum = 1
    elseif nMultipleValue / self.parent._dataModel.m_secene.MaxShoot > 0.1 and nMultipleValue / self.parent._dataModel.m_secene.MaxShoot <= 0.3  then
        bulletNum = 2
    elseif nMultipleValue / self.parent._dataModel.m_secene.MaxShoot > 0.3 and nMultipleValue / self.parent._dataModel.m_secene.MaxShoot <= 0.5  then
        bulletNum = 3
    elseif nMultipleValue / self.parent._dataModel.m_secene.MaxShoot > 0.5 and nMultipleValue / self.parent._dataModel.m_secene.MaxShoot <= 0.7  then
        bulletNum = 4
	elseif nMultipleValue / self.parent._dataModel.m_secene.MaxShoot > 0.7 and nMultipleValue / self.parent._dataModel.m_secene.MaxShoot <= 0.9  then
        bulletNum = 5
    elseif nMultipleValue / self.parent._dataModel.m_secene.MaxShoot > 0.9 and nMultipleValue / self.parent._dataModel.m_secene.MaxShoot <= 1  then
        bulletNum = 6
    end    
	local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame(string.format("pao_%d_%d.png", bulletNum,nNum))
	--print("--------- setMultiple --------------")
	self.m_fort:setSpriteFrame(frame)

	self.parent:updateMultiple(nMultipleValue,self.m_pos+1)

end
--自动射击
function Cannon:setCanAutoShoot(b)
	self.m_canAutoShoot = b
end

--自动射击
function Cannon:setAutoShoot(b)
	self.m_autoShoot = b
    self.parent.parent.m_autoShoot = b
	if self.m_cannonPoint.x == 0 and self.m_cannonPoint.y == 0 then 
		self.m_cannonPoint = self:convertToWorldSpace(cc.p(self.m_fort:getPositionX(),self.m_fort:getPositionY()))
	end

	if self.m_Type >= Game_CMD.CannonType.Laser_Cannon then
		return
	end

	if self.m_autoShoot then

        local time =  self.fireSpeed

		if self.m_Type == Game_CMD.CannonType.Special_Cannon then
			time = time / 1.5
		end

		self:autoSchedule(time)

	else
		self:unAutoSchedule()	
	end
end

function Cannon:typeTimeUpdate( dt )

	self.m_typeTime = self.m_typeTime - dt

	--print("self.m_typeTime is ======================== "..self.m_typeTime)
	local tmp = self:getChildByTag(TagEnum.Tag_Type)
	if nil ~= tmp then
		local timeshow = tmp:getChildByTag(1)
		timeshow:setString(string.format("%d",self.m_typeTime))
	end

	if self.m_typeTime <= 0 then
		self:removeTypeTag()
		self:unTypeSchedule()
		--print("------------------ typeTimeUpdate -------------------")
		if	self.m_Type ~= Game_CMD.CannonType.Laser_Cannon then
			self:setCannonType(Game_CMD.CannonType.Normal_Cannon, 0)
		end
	end
end


--自己开火
function Cannon:shoot( vec , isbegin )
	print("self.m_canShoot =======================", self.m_canShoot, isbegin, self.m_isShoot )
	if not self.m_canShoot then
		self.m_isShoot = isbegin
		return
	end
	if self.m_cannonPoint.x == 0 and self.m_cannonPoint.y == 0 then
		
		self.m_cannonPoint = self:convertToWorldSpace(cc.p(self.m_fort:getPositionX(),self.m_fort:getPositionY()))
	end

	self.m_laserPos.x = vec.x
	self.m_laserPos.y = vec.y

	local angle = self._dataModel:getAngleByTwoPoint(vec, self.m_cannonPoint)

	self.m_targetPoint = vec

	if angle < 90  then 

		if not self._dataModel.m_autolock then
			self.m_fort:setRotation(angle)
		end
	end

	if self.m_Type == Game_CMD.CannonType.Laser_Shooting then
		return
	end

	if self.m_Type == Game_CMD.CannonType.Laser_Cannon  then
		self:shootLaser()
		return
	end

	if self.m_canAutoShoot then
		return
	end
	
	if not self.m_isShoot and isbegin then
		self.m_isShoot = true
        local time = self.fireSpeed

		if self.m_Type == Game_CMD.CannonType.Special_Cannon then
			time = time / 1.5
		end
		print("1---------------dyj1")
		self.m_canTempShoot = true
		self:autoUpdate(1)
        print("1---------------dyj2")
		self:autoSchedule(time)
	end

	if not isbegin then
		self.m_isShoot = false
		print("22222222222222222222---------------dyj1")
		self.m_canTempShoot = false
		self:unAutoSchedule()
		print("22222222222222222222---------------dyj2")
	end

end

--其他玩家开火
function Cannon:othershoot( firedata )
	
	table.insert(self.m_firelist,firedata)
	self:setMultiple(self.m_nMutipleIndex)
	self.m_nCurrentBulletScore = firedata.bullet_mulriple
	--dyj1
	--local time = self._dataModel.m_secene.nBulletCoolingTime/1000
        local time = self.fireSpeed
    --dyj2
	if self.m_Type == Game_CMD.CannonType.Special_Cannon then
		time = time/1.5
	end

	self:otherSchedule(time)
end

--发射激光
function Cannon:shootLaser()

    self._dataModel:playEffect(Game_CMD.Prop_armour_piercing)

	self.m_Type = Game_CMD.CannonType.Laser_Shooting
	--print("---------------------shootLaser self.m_laserConvertPos------------",self.m_laserConvertPos.x,self.m_laserConvertPos.y)
	--print("---------------------shootLaser self.m_laserBeginConvertPos self.m_laserConvertPos------------",self.m_laserBeginConvertPos.x,self.m_laserBeginConvertPos.y)
	if self.m_laserBeginConvertPos.x ==0 and self.m_laserBeginConvertPos.y == 0 then
		self.m_laserBeginConvertPos.x = self.m_cannonPoint.x
		self.m_laserBeginConvertPos.y = self.m_cannonPoint.y
	end
	--self.m_laserConvertPos	= self._dataModel:convertCoordinateSystem(cc.p(self.m_laserPos.x,self.m_laserPos.y), 1, self._dataModel.m_reversal)
	local angle = self._dataModel:getAngleByTwoPoint(self.m_laserConvertPos, self.m_laserBeginConvertPos)
	if  self.m_ChairID == self.m_nChairID then
		angle = self._dataModel:getAngleByTwoPoint(self.m_laserPos, self.m_cannonPoint)
    else
        angle = self.fangle
	end
	
	--print("angle is ",angle)
	if self.m_pos < 2 then
		--print(" self.m_pos < 3 angle" , angle)
		self.m_fort:setRotation(angle)
	end

	--print("angle is ",angle)
	self.m_fort:setRotation(angle)
	local anim = cc.Animate:create(cc.AnimationCache:getInstance():getAnimation("FortLightAnim"))
	self.m_fort:runAction(anim)
	self:removeChildByTag(TagEnum.Tag_Light)

	local node = cc.Node:create()
	node:setAnchorPoint(0.5,0.5)
	node:setContentSize(cc.size(10, 10))
	--local angle = self.m_fort:getRotation()
	local moveDir = cc.pForAngle(math.rad(90-angle))
	cc.pMul(moveDir,50)
	node:setPosition(cc.pAdd(self:convertToWorldSpace(cc.p(self.m_fort:getPositionX(),self.m_fort:getPositionY())),moveDir))  --self.m_cannonPoint
	self.parent:addChild(node)

	local light = cc.Sprite:createWithSpriteFrameName("light.png")
	light:setPosition(node:getContentSize().width/2,0)
	light:setScale(0.5,1.0)
	node:addChild(light)

	local callFunc = cc.CallFunc:create(function ()
		light:removeFromParent(true)
	end)

	local action = cc.Sequence:create(cc.ScaleTo:create(1,1,1),cc.ScaleTo:create(1,0.5,1),callFunc)
	light:runAction(action)


	for i=1,4 do
		local fortLight = cc.Sprite:createWithSpriteFrameName(string.format("fortlight_%d.png",i-1))
		fortLight:setPosition(node:getContentSize().width/2,fortLight:getContentSize().height*0.6+(i-1)*fortLight:getContentSize().height*1.2-5*(i-1))
		fortLight:setScale(0.1,1.2)

        fortLight:setTag(Game_CMD.Tag_Laser)
        fortLight:setPhysicsBody(cc.PhysicsBody:createBox(fortLight:getContentSize()))
        fortLight:getPhysicsBody():setCategoryBitmask(2)
        fortLight:getPhysicsBody():setCollisionBitmask(0)
        fortLight:getPhysicsBody():setContactTestBitmask(1)
        fortLight:getPhysicsBody():setGravityEnable(false)

		fortLight:runAction(cc.Sequence:create(cc.ScaleTo:create(0.5,1.0,1.2),cc.ScaleTo:create(2,0,1.2)))
		node:addChild(fortLight)

	end
	node:setRotation(self.m_fort:getRotation())

	callFunc = cc.CallFunc:create(function()

		if nil ~= self.setCannonType then
			node:removeFromParent(true)

			self:setCannonType(Game_CMD.CannonType.Normal_Cannon,0)
			self.m_Type = Game_CMD.CannonType.Normal_Cannon

			if self.m_autoShoot --[[or self.m_isShoot]] then
		        --dyj1
		       -- local time = self._dataModel.m_secene.nBulletCoolingTime/1000
                local time = 0.1
                --dyj2
				if self.m_Type == Game_CMD.CannonType.Special_Cannon then
					time = time / 1.5
				end

				self:autoUpdate(0)
				self:autoSchedule(time)

			elseif 0 ~= #self.m_firelist then
		        --dyj1
		        -- local time = self._dataModel.m_secene.nBulletCoolingTime/1200
                local time = self.fireSpeed
                --dyj2
				if self.m_Type == Game_CMD.CannonType.Special_Cannon then
					time = time / 1.5
				end
				self:otherSchedule(time)
					
			end
		end
		
	end)

	node:runAction(cc.Sequence:create(cc.DelayTime:create(2.3),callFunc))

	if  self.m_ChairID == self.m_nChairID then 
		----print("----------------- zhudong ji guang --------------------")
		local tmp =  cc.p(self.m_cannonPoint.x,self.m_cannonPoint.y)
		
		local  beginPos = self._dataModel:convertCoordinateSystem(tmp, 0, self._dataModel.m_reversal)
		--local  endPos	= self._dataModel:convertCoordinateSystem(cc.p(node:getPositionX(),node:getPositionY()), 0, self._dataModel.m_reversal)
		self.m_laserConvertPos	= self._dataModel:convertCoordinateSystem(cc.p(self.m_laserPos.x,self.m_laserPos.y), 0, self._dataModel.m_reversal)

		local unLossTime = currentTime() - self._dataModel.m_enterTime

        local cmddata = CCmd_Data:create(4)
        cmddata:setcmdinfo(yl.MDM_GF_GAME, Game_CMD.SUB_C_LASER)
        cmddata:pushfloat(self.m_fort:getRotation())

        self.power = 0

		if not self.frameEngine:sendSocketData(cmddata) then
			self.frameEngine._callBack(-1,"发送激光消息失败")
		end
	end
end

--制造子弹
function Cannon:productBullet( isSelf,fishIndex, netColor,fire)
    cc.SpriteFrameCache:getInstance():addSpriteFrames("game_res/bullet_guns_coins.plist")
    cc.Director:getInstance():getTextureCache():addImage("game_res/bullet_guns_coins.png")
    if (isSelf and self.parent.m_bullet_cur_count >= self.parent.m_bullet_limit_count) or self.parent.parent.m_fishTotalCount <= 0 then
        return
    end
    if isSelf then
        self.parent.m_bullet_cur_count = self.parent.m_bullet_cur_count + 1
    end

    local angle = self.m_fort:getRotation()

    local bullet0=nil
    if fire ~= nil then
        
	    bullet0 = Bullet:create(angle,fire.chair_id,fire.bullet_mulriple,self.m_nMutipleIndex,self.m_Type,self, self.parent._dataModel.m_secene.MaxShoot, fire.wBulletSpeed)
        bullet0:initWithAngle(angle,fire.chair_id,fire.bullet_mulriple,self.m_Type)
	    bullet0:setType(fire.bullet_kind)
	    bullet0:setIndex(fire.bullet_id)
	    bullet0:setIsSelf(isSelf)
	    bullet0:setFishIndex(fishIndex)
        bullet0:initPhysicsBody()
	    bullet0:setTag(Game_CMD.Tag_Bullet)
        bullet0:setName(Game_CMD.BULLET)
        self.parent.parent.m_cannonLayer:addChild(bullet0) 
        self:setFishIndex(fishIndex)
    else
    	self.m_index = self.m_index + 1

	    bullet0 = Bullet:create(angle,self.m_ChairID,self.m_nCurrentBulletScore,self.m_nMutipleIndex,self.m_Type,self, self.parent._dataModel.m_secene.MaxShoot, self.parent.m_bulletSpeed)
        bullet0:initWithAngle(angle,self.m_ChairID,self.m_nCurrentBulletScore,self.m_Type)

	    bullet0:setType(self.m_Type)
	    bullet0:setIndex(self.m_index)
	    bullet0:setIsSelf(isSelf)
	    bullet0:setFishIndex(fishIndex)
        bullet0:initPhysicsBody()

	    bullet0:setTag(Game_CMD.Tag_Bullet)
        bullet0:setName(Game_CMD.BULLET)
        self.parent.parent.m_cannonLayer:addChild(bullet0) 
        self:setFishIndex(fishIndex)
    end
    local bulletNum = 1 --math.floor(self.m_nMutipleIndex/4) + 1
	if self.m_nMutipleIndex / self.parent._dataModel.m_secene.MaxShoot >= 0 and self.m_nMutipleIndex / self.parent._dataModel.m_secene.MaxShoot <= 0.1 then
        bulletNum = 1
    elseif self.m_nMutipleIndex / self.parent._dataModel.m_secene.MaxShoot > 0.1 and self.m_nMutipleIndex / self.parent._dataModel.m_secene.MaxShoot <= 0.3  then
        bulletNum = 2
    elseif self.m_nMutipleIndex / self.parent._dataModel.m_secene.MaxShoot > 0.3 and self.m_nMutipleIndex / self.parent._dataModel.m_secene.MaxShoot <= 0.5  then
        bulletNum = 3
    elseif self.m_nMutipleIndex / self.parent._dataModel.m_secene.MaxShoot > 0.5 and self.m_nMutipleIndex / self.parent._dataModel.m_secene.MaxShoot <= 0.7  then
        bulletNum = 4
	elseif self.m_nMutipleIndex / self.parent._dataModel.m_secene.MaxShoot > 0.7 and self.m_nMutipleIndex / self.parent._dataModel.m_secene.MaxShoot <= 0.9  then
        bulletNum = 5
    elseif self.m_nMutipleIndex / self.parent._dataModel.m_secene.MaxShoot > 0.9 and self.m_nMutipleIndex / self.parent._dataModel.m_secene.MaxShoot <= 1  then
        bulletNum = 6
    end    
    local anim = cc.Animate:create(cc.AnimationCache:getInstance():getAnimation("pao" .. bulletNum .."Anim"))
	self.m_fort:runAction(anim)
	angle = math.rad(90-angle)
	local movedir = cc.pForAngle(angle)
	movedir = cc.p(movedir.x * 55 , movedir.y * 55)
	local offset = cc.p(25 * math.sin(angle),5 * math.cos(angle))
	local moveBy = cc.MoveBy:create(0.065,cc.p(-movedir.x*0.3,-movedir.y * 0.3))
	self.m_fort:runAction(cc.Sequence:create(moveBy,moveBy:reverse()))
    local pos = cc.p(self.m_cannonPoint.x  +movedir.x,self.m_cannonPoint.y+movedir.y)   
    pos=cc.p(pos.x,pos.y -offset.y/2)
	bullet0:setPosition(pos)
    bullet0.movedir = movedir
    table.insert(self.parent.parent.bullet,bullet0)

	if isSelf then

		self.parent.parent:setSecondCount(60)

		local cmddata = CCmd_Data:create(29)

   		cmddata:setcmdinfo(yl.MDM_GF_GAME, Game_CMD.SUB_C_FIRE)
    	cmddata:pushint(self.m_index)
        cmddata:pushint(self.m_Type)
    	cmddata:pushbyte(1)
        local final_angle =(math.deg(math.pi/2 -angle))/57.32
        if self.m_nChairID < 2 then
            final_angle = final_angle-180 
        end
        cmddata:pushfloat(final_angle)
    	cmddata:pushfloat(self.m_nCurrentBulletScore)
        cmddata:pushint(fishIndex)
        cmddata:pushdword(currentTime())
        cmddata:pushfloat(self.parent.m_bulletSpeed)

  		local pos = cc.p(movedir.x * 25 , movedir.y * 25)
  		pos = cc.p(self.m_cannonPoint.x + pos.x , self.m_cannonPoint.y + pos.y)
  		pos = self._dataModel:convertCoordinateSystem(pos, 0, self._dataModel.m_reversal)

  		self._dataModel:playEffect(Game_CMD.Shell_8)

   		 --发送失败
		if not self.frameEngine  or not self.frameEngine:sendSocketData(cmddata) then
			self.frameEngine._callBack(-1,"发送开火息失败")
        else
            self.parent.parent.BulletSum = self.parent.parent.BulletSum + self.m_nCurrentBulletScore
            self.parent.parent.ScoreCount = self.parent.parent.ScoreCount - self.m_nCurrentBulletScore
            self:updateUpScore(self.parent.parent.ScoreCount)
		end
	end
end

function Cannon:fastDeal(  )
	self.m_canShoot = false
	self:runAction(cc.Sequence:create(cc.DelayTime:create(5.0),cc.CallFunc:create(function(	)
		self.m_canShoot = true
	end)))
end

function Cannon:setCannonType( cannontype,times)	
    
	if cannontype == Game_CMD.CannonType.Special_Cannon then
        if self.m_ChairID == self.parent.m_nChairID then
            self.parent:disableAddSub(false)
        end
		local bulletNum = 1 --math.floor(self.m_nMutipleIndex/4) + 1
		if self.m_nMutipleIndex / self.parent._dataModel.m_secene.MaxShoot >= 0 and self.m_nMutipleIndex / self.parent._dataModel.m_secene.MaxShoot <= 0.1 then
	        bulletNum = 1
	    elseif self.m_nMutipleIndex / self.parent._dataModel.m_secene.MaxShoot > 0.1 and self.m_nMutipleIndex / self.parent._dataModel.m_secene.MaxShoot <= 0.3  then
	        bulletNum = 2
	    elseif self.m_nMutipleIndex / self.parent._dataModel.m_secene.MaxShoot > 0.3 and self.m_nMutipleIndex / self.parent._dataModel.m_secene.MaxShoot <= 0.5  then
	        bulletNum = 3
	    elseif self.m_nMutipleIndex / self.parent._dataModel.m_secene.MaxShoot > 0.5 and self.m_nMutipleIndex / self.parent._dataModel.m_secene.MaxShoot <= 0.7  then
	        bulletNum = 4
		elseif self.m_nMutipleIndex / self.parent._dataModel.m_secene.MaxShoot > 0.7 and self.m_nMutipleIndex / self.parent._dataModel.m_secene.MaxShoot <= 0.9  then
	        bulletNum = 5
	    elseif self.m_nMutipleIndex / self.parent._dataModel.m_secene.MaxShoot > 0.9 and self.m_nMutipleIndex / self.parent._dataModel.m_secene.MaxShoot <= 1  then
	        bulletNum = 6
	    end    

		local str = string.format("pao_%d_1.png", bulletNum)
		self.m_fort:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(str))

		self.m_Type = Game_CMD.CannonType.Special_Cannon

		if self.m_autoShoot or self.m_isShoot then
			self:unAutoSchedule()
		    --dyj1
		    --local time = self._dataModel.m_secene.nBulletCoolingTime/1000
            local time = self.fireSpeed / 1.5
            --dyj2
			self:autoSchedule(time)
		end


		if #self.m_firelist > 0 then 
			self:unOtherSchedule()
		    --dyj1
		    --local time = self._dataModel.m_secene.nBulletCoolingTime/2400
            local time = self.fireSpeed / 1.5
            --dyj2
			self:otherSchedule(time)
		end

		local Type = cc.Sprite:create("game_res/im_icon_0.png")
		Type:setTag(TagEnum.Tag_Type)
		Type:setPosition(-16,-40)
		self:removeTypeTag()
		self:addChild(Type)

		local pos = nil
		if self.m_pos < 2 then
			pos = cc.p(110,-45)
		else
			pos = cc.p(110,150)
		end

		Type:setPosition(pos.x,pos.y)

        --[[
		self.m_typeTime = times
		self:typeTimeSchedule(1.0)

		local timeShow = cc.LabelAtlas:create(string.format("%d", times),"game_res/lockNum.png",13,18,string.byte("0"))
		timeShow:setAnchorPoint(0.5,0.5)
		timeShow:setPosition(Type:getContentSize().width/2, 27)
		timeShow:setTag(1)
		Type:addChild(timeShow)
        --]]
		Type:runAction(cc.RepeatForever:create(CirCleBy:create(1.0,cc.p(pos.x,pos.y),10)))


	elseif cannontype == Game_CMD.CannonType.Laser_Cannon then
        if self.m_ChairID == self.parent.m_nChairID then
            self.parent:disableAddSub(false)
        end
    --[[
		--print("------------ setCannonType Laser_Cannon ---------------")
		if self.m_Type == Game_CMD.CannonType.Laser_Cannon  then
			--print("------------ = Laser_Cannon ---------------")
			--if self.m_ChairID == self.m_nChairID then
				self:unAutoSchedule()
				self.m_fort:setSpriteFrame("fort_light_0.png")
				self.m_typeTime = times
			--end

			return
		end
		print("------------  not = Laser_Cannon -------------------")
		self._dataModel:playEffect(Game_CMD.Small_Begin)

		self.m_Type = Game_CMD.CannonType.Laser_Cannon

		self:unAutoSchedule()

		self.m_fort:setSpriteFrame("fort_light_0.png")

		local light = cc.Sprite:createWithSpriteFrameName("light_0.png")
		light:setTag(TagEnum.Tag_Light)

		if self.m_cannonPoint.x == 0 and self.m_cannonPoint.y == 0 then 
			self.m_cannonPoint = self:convertToWorldSpace(cc.p(self.m_fort:getPositionX(),self.m_fort:getPositionY()))
		end
		light:setPosition(self.m_fort:getPositionX(),self:getPositionY())
		if self.m_pos == 6 then
			light:setPosition(self.m_fort:getPositionX(),self.m_fort:getPositionY())
		elseif self.m_pos == 7 then
			light:setPosition(self.m_fort:getPositionX(),self.m_fort:getPositionY())
		end
		self:addChild(light)

		local animate = cc.Animate:create(cc.AnimationCache:getInstance():getAnimation("LightAnim"))
		local action = cc.RepeatForever:create(cc.Sequence:create(animate,animate:reverse()))
		light:runAction(action)
        --]]
	elseif cannontype == Game_CMD.CannonType.Normal_Cannon then
        if self.m_ChairID == self.parent.m_nChairID then
            self.parent:disableAddSub(true)
        end
		--print("------------  Normal_Cannon -------------------")
        self:removeTypeTag()
		self.m_Type = Game_CMD.CannonType.Normal_Cannon
		--local nBulletNum = math.floor(self.m_nMutipleIndex/4) + 1

        local bulletNum = 1 --math.floor(self.m_nMutipleIndex/4) + 1

        if self.m_nMutipleIndex / self.parent._dataModel.m_secene.MaxShoot >= 0 and self.m_nMutipleIndex / self.parent._dataModel.m_secene.MaxShoot <= 0.1 then
	        bulletNum = 1
	    elseif self.m_nMutipleIndex / self.parent._dataModel.m_secene.MaxShoot > 0.1 and self.m_nMutipleIndex / self.parent._dataModel.m_secene.MaxShoot <= 0.3  then
	        bulletNum = 2
	    elseif self.m_nMutipleIndex / self.parent._dataModel.m_secene.MaxShoot > 0.3 and self.m_nMutipleIndex / self.parent._dataModel.m_secene.MaxShoot <= 0.5  then
	        bulletNum = 3
	    elseif self.m_nMutipleIndex / self.parent._dataModel.m_secene.MaxShoot > 0.5 and self.m_nMutipleIndex / self.parent._dataModel.m_secene.MaxShoot <= 0.7  then
	        bulletNum = 4
		elseif self.m_nMutipleIndex / self.parent._dataModel.m_secene.MaxShoot > 0.7 and self.m_nMutipleIndex / self.parent._dataModel.m_secene.MaxShoot <= 0.9  then
	        bulletNum = 5
	    elseif self.m_nMutipleIndex / self.parent._dataModel.m_secene.MaxShoot > 0.9 and self.m_nMutipleIndex / self.parent._dataModel.m_secene.MaxShoot <= 1  then
	        bulletNum = 6
	    end   

		local str = string.format("pao_%d_1.png", bulletNum)
		self.m_fort:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(str))

        if self.m_autoShoot or self.m_isShoot then
			self:unAutoSchedule()
            local time = self.fireSpeed
			self:autoSchedule(time)
		end

		if 0 ~= #self.m_firelist then
			self:unOtherSchedule()
            local time = self.fireSpeed
			self:otherSchedule(time)
		end
	end
end

--补给
function Cannon:ShowSupply( data )
	
	local pos = {}
	local box = cc.Sprite:createWithSpriteFrameName("fishDead_026_1.png")
	if self.m_pos < 2 then
		pos = cc.p(-30,20)
	elseif self.m_pos < 4 then
		pos = cc.p(-40,self:getPositionY() - 30) 
	end

	box:setPosition(pos.x, pos.y)
	self:addChild(box,1)

	local nSupplyType = data.nSupplyType

	local action = cc.Animate:create(cc.AnimationCache:getInstance():getAnimation("animation_fish_dead26"))

	local call = cc.CallFunc:create(function ()
		if nSupplyType ~= Game_CMD.SupplyType.EST_NULL then
			local gold = cc.Sprite:create("game_res/im_box_gold.png")
			gold:setPosition(box:getContentSize().width/2,box:getContentSize().height/2)
			box:addChild(gold)

			local typeStr = string.format("game_res/im_supply_%d.png", nSupplyType)
			local title = cc.Sprite:create(typeStr)
			if nil ~= title  then
				title:setPosition(box:getContentSize().width/2,100)
				box:addChild(title)
			end
		end
	end)

	box:runAction(cc.Sequence:create(action,call))


	call = cc.CallFunc:create(function()
		box:removeFromParent(true)
	end)

	local delay = cc.DelayTime:create(4)
	box:runAction(cc.Sequence:create(delay,call))

	if nSupplyType == Game_CMD.SupplyType.EST_Laser then        
		self:setCannonType(Game_CMD.CannonType.Laser_Cannon, data.lSupplyCount)
		if self.m_ChairID == self.m_nChairID then

			local ptPos = cc.p(0,0)
			ptPos.x = math.random(200) + 200
			ptPos.y = math.random(200) + 200
		end

	elseif nSupplyType == Game_CMD.SupplyType.EST_Speed then

		self:setCannonType(Game_CMD.CannonType.Special_Cannon, data.lSupplyCount)
	elseif nSupplyType == Game_CMD.SupplyType.EST_Gift then
		--[[
		self._dataModel.m_secene.lPlayCurScore[1][self.m_ChairID + 1] = self._dataModel.m_secene.lPlayCurScore[1][self.m_ChairID + 1] + data.lSupplyCount
		local cannonPos = Cannon.getPos(self._dataModel.m_reversal,self.m_ChairID)

		self.parent:updateUserScore( self._dataModel.m_secene.lPlayCurScore[1][self.m_ChairID + 1],cannonPos+1 )
	 	--]]
	end
end


--自己开火
function Cannon:autoUpdate(dt)

	if not self.m_canShoot or self.m_Type == Game_CMD.CannonType.Laser_Cannon  then
		return
	end

	if self._dataModel._exchangeSceneing  then 	--切换场景中不能发炮
		return false
	end


	self:setFishIndex(self._dataModel.m_fishIndex)

    --dyj1
    local score = self.parent.parent.ScoreCount
    --dyj2
	local nNum = Game_CMD.MULTIPLE_MAX_INDEX

    --dyj1
    local curScore = self.parent.parent.CurrShoot[1][self.m_nChairID+1]
    --dyj2
	
	if score < self.parent.parent.CurrShoot[1][self.m_nChairID+1] then
		self:unAutoSchedule()
		self.m_autoShoot = false
        self.parent.parent.m_autoShoot = false
	 
	    AppFacade:getInstance():sendNotification(GAME_COMMAMD.PUSH_VIEW, {ctor = {"上分不足,请充值",function(ok)
				if ok == true then
					ExternalFun.playClickEffect()
				end
	    end}, canrepeat = false}, VIEW_LIST.QUERY_DIALOG_LAYER)
   

    	self._dataModel.m_autoShoot = false
    	local shoot = self.parent.parent._gameView:getChildByTag(self.parent.parent._gameView.m_TAG.tag_autoshoot)
    	self.parent.parent._gameView:setAutoShoot(self._dataModel.m_autoShoot,shoot)


    	self._dataModel.m_autolock = false
    	local lock = self.parent.parent._gameView:getChildByTag(self.parent.parent._gameView.m_TAG.tag_autolock)
    	self.parent.parent._gameView:setAutoLock(self._dataModel.m_autolock,lock)
    	return
	end

	if self.m_autoShoot and self._dataModel.m_autolock then
		
		if self.m_fishIndex == Game_CMD.INT_MAX then
			 self:removeLockTag()
			 return
		end
		if self._dataModel.m_autolock then
			local fish = self._dataModel.m_fishList[self.m_fishIndex]
	        
			if fish == nil then
				self:removeLockTag()
			    return
			end

			local fishData = fish.m_data
			local frameName = string.format("%d_%d.png", fishData.fish_kind, fish.lockType)
			local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame(frameName)

			if nil ~= frame then
				local sp = self:getChildByTag(TagEnum.Tag_lock)
				if nil == sp then
					local myNum = self.m_nChairID/3
					local playerNum = self.m_ChairID/3
					local pos = cc.p(-40,145)
					if myNum ~= playerNum then
						pos = cc.p(-30,-30)
					end
				 
					sp = cc.Sprite:createWithSpriteFrame(frame)
					self:removeLockTag()
					sp:setTag(TagEnum.Tag_lock)
					sp:setPosition(pos.x,pos.y)
					self:addChild(sp)

					sp:runAction(cc.RepeatForever:create(CirCleBy:create(1.0,cc.p(pos.x,pos.y),10)))
				else
					sp:setSpriteFrame(frame)
				end
			else
				self:removeLockTag()					
			end

			local pos = cc.p(fish:getPositionX(),fish:getPositionY())
			if self._dataModel.m_reversal then
				pos = cc.p(yl.WIDTH-pos.x,yl.HEIGHT-pos.y)
			end

			local angle = self._dataModel:getAngleByTwoPoint(pos, self.m_cannonPoint)
			self.m_fort:setRotation(angle - self:getRotation())
		end
		if self.m_canAutoShoot or self.m_canTempShoot then
			self:productBullet(true,self.m_fishIndex,self._dataModel:getNetColor(1))
		end
	else
		local angle = self._dataModel:getAngleByTwoPoint(self.m_targetPoint, self.m_cannonPoint)
		self.m_fort:setRotation(angle - self:getRotation())
		self:productBullet(true,Game_CMD.INT_MAX,self._dataModel:getNetColor(1))
	end
end

function Cannon:lockBubble1(dt)

	local function update(dt)
		local fish = self._dataModel.m_fishList[self.m_fishIndex]

        if (fish ~= nil and not self.m_other and self.m_autoShoot) or (fish ~= nil and self.m_otherLock and self.m_other) then
            local fishPos = cc.p(fish:getPositionX(), fish:getPositionY())
            if self._dataModel.m_reversal then
                fishPos = cc.p(yl.WIDTH - fishPos.x , yl.HEIGHT - fishPos.y)
            end
            if cc.rectContainsPoint(cc.rect(0, 0, yl.WIDTH, yl.HEIGHT), fishPos)  then
                local mePos = cc.p(self:getPositionX(), self:getPositionY())
                local angle = self.m_fort:getRotation()
            
                local distance = cc.pGetDistance(fishPos, mePos)
                local num = math.floor(distance / 50)
                for i = 1, num do
                    self.bubbleList[i] = cc.p(50 * i * sinf(rad(angle)) + self.fPos.x, 50 * i * cosf(rad(angle)) + self.fPos.y)
                end
                self.bubbleList[num + 1] = cc.p(distance * sinf(rad(angle)) + self.fPos.x, distance * cosf(rad(angle)) + self.fPos.y)
                for i = #self.bubbleList, num + 2, -1 do
                    table.remove(self.bubbleList, i)
                end
            end
        else
            for i = #self.bubbleList, 1, -1 do
                table.remove(self.bubbleList, i)
            end
        end
	end

	if nil == self.m_lockShootSchedule1 then
		self.m_lockShootSchedule1 = scheduler:scheduleScriptFunc(update,0, false)
	end

end

function Cannon:unLock1Schedule()
	if nil ~= self.m_lockShootSchedule1 then
		scheduler:unscheduleScriptEntry(self.m_lockShootSchedule1)
		self.m_lockShootSchedule1 = nil
	end
end


function Cannon:lockBubble2(dt)

	local function update(dt)
		
        
        for i = #self.bubbleList, 1, -1 do
            if self.bubbleList[i] ~= nil then
                if i == #self.bubbleList then
                    local bubble = self:getChildByName("big_bubble")
                    bubble:setPosition(self.bubbleList[i])
                else
                    local bubble = self:getChildByName("bubble_" .. i)
                    bubble:setPosition(self.bubbleList[i])
                end
            end
        end
        for i = 30, #self.bubbleList, -1 do
            if i > 0 then
                local bubble = self:getChildByName("bubble_" .. i)
                bubble:setPosition(cc.p(2000, 2000))
            end
        end
        if 0 == #self.bubbleList then
            local bubble = self:getChildByName("big_bubble")
            bubble:setPosition(cc.p(2000, 2000))
        end
	end

	if nil == self.m_lockShootSchedule2 then
		self.m_lockShootSchedule2 = scheduler:scheduleScriptFunc(update,0, false)
	end

end

function Cannon:unLock2Schedule()
	if nil ~= self.m_lockShootSchedule2 then
		scheduler:unscheduleScriptEntry(self.m_lockShootSchedule2)
		self.m_lockShootSchedule2 = nil
	end
end

function Cannon:autoSchedule(dt)

	local function updateAuto(dt)
		self:autoUpdate(dt)
	end

	if nil == self.m_autoShootSchedule then
		self.m_autoShootSchedule = scheduler:scheduleScriptFunc(updateAuto,dt, false)
	end

end

function Cannon:unAutoSchedule()
	if nil ~= self.m_autoShootSchedule then
		scheduler:unscheduleScriptEntry(self.m_autoShootSchedule)
		self.m_autoShootSchedule = nil
	end
end

--其他玩家开火
function Cannon:otherUpdate(dt)
	
	if 0 == #self.m_firelist then
		self:unOtherSchedule()
		self.m_isShoot = false
		return
	end

	if not self.m_canShoot then
		return
	end
	if self.m_Type == Game_CMD.CannonType.Laser_Cannon  then
		self:shootLaser()
        return
	end

	local fire = self.m_firelist[1]
	table.remove(self.m_firelist,1)

	if self.m_cannonPoint.x == 0 and self.m_cannonPoint.y == 0 then 
		self.m_cannonPoint = self:convertToWorldSpace(cc.p(self.m_fort:getPositionX(),self.m_fort:getPositionY()))
	end
    local angle = fire.angle
    if fire.chair_id <2 then
       angle = angle+180 
    end
	angle = angle*57.32
    local ifchange=false
    if self.m_nChairID>1 then
       if fire.chair_id>1 then            --4,5,6同边位置
          ifchange=true
       else
          ifchange=false
       end
    else
       if fire.chair_id<2 then            --1,2,3同边位置
          ifchange=true
       else
          ifchange=false
       end
    end
    if ifchange then
        self.m_fort:setRotation(angle)
    else
	    self.m_fort:setRotation(180 + angle)
    end
	
    if fire.lock_fishid ~= Game_CMD.INT_MAX then
        self.m_otherLock = true
        local fish = self._dataModel.m_fishList[self.m_fishIndex]

        if nil ~= fish then
            local fishPos = cc.p(fish:getPositionX(), fish:getPositionY())
            if self._dataModel.m_reversal then
		        fishPos = cc.p(yl.WIDTH - fishPos.x, yl.HEIGHT - fishPos.y)
	        end
            if cc.rectContainsPoint(cc.rect(0, 0, yl.WIDTH, yl.HEIGHT), fishPos) then
                local angle1 = self._dataModel:getAngleByTwoPoint(fishPos, cc.p(self:getPositionX(), self:getPositionY()))
                self.m_fort:setRotation(angle1)
            end
        end
    else
        self.m_otherLock = false
    end
    self:productBullet(false, fire.lock_fishid, cc.WHITE,fire)
end

function Cannon:updateScore(score)

	self.parent:updateUserScore(score,self.m_pos+1)	
end
--dyj1(FC++)
function Cannon:updateUpScore(score)
	self.parent:updateUpScore(score,self.m_pos+1)
end
--dyj2

function Cannon:otherSchedule(dt)

	local function updateOther(dt)
		self:otherUpdate(dt)
	end

	if nil == self.m_otherShootSchedule then
		self.m_otherShootSchedule = scheduler:scheduleScriptFunc(updateOther, dt, false)
	end

end

function Cannon:unOtherSchedule()
	if nil ~= self.m_otherShootSchedule then
		scheduler:unscheduleScriptEntry(self.m_otherShootSchedule)
		self.m_otherShootSchedule = nil
	end
end

function Cannon:typeTimeSchedule( dt )

	local function  update( dt  )
		self:typeTimeUpdate(dt)
	end

	if nil == self.m_typeSchedule then
		self.m_typeSchedule = scheduler:scheduleScriptFunc(update, dt, false)
	end
	
end

function Cannon:unTypeSchedule()
	if nil ~= self.m_typeSchedule then

		self:removeChildByTag(TagEnum.Tag_Light)
		scheduler:unscheduleScriptEntry(self.m_typeSchedule)
		self.m_typeSchedule = nil
	end
end


function Cannon:removeLockTag()

	self:removeChildByTag(TagEnum.Tag_lock)
end


function Cannon:removeTypeTag()
	
	self:removeChildByTag(TagEnum.Tag_Type)

end

function Cannon:moveAllBannerAndGolds(pNode)
	local moveX = 39
	local moveY = 0

	if self.m_pos == 6 then
		moveX = 0
		moveY = -39
	elseif self.m_pos == 7 then
		moveX = 0
		moveY = 39
	end	

	for i = 1,#self.m_goldList do
        local tNode = self.m_goldList[i]
		if tNode.index == pNode.index then
			table.remove(self.m_goldList,i)
			tNode:removeFromParent(true)
            break
		end
	end
		
        --[[	
	local listCount = #self.m_goldList
	if listCount >=1 then
		local tNode = self.m_goldList[1]
		if tNode.index == pNode.index then
			table.remove(self.m_goldList,1)
			tNode:removeFromParent(true)
		end

		for i = 1,#self.m_goldList do
			local node = self.m_goldList[i]
			node:runAction(cc.Sequence:create(cc.MoveBy:create(0.35,cc.p(moveX,moveY)),cc.CallFunc:create(function()
			self:moveAllBannerAndGolds(node)
	end)))
		end
	end
    ]]
end

return Cannon