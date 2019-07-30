--
-- Author: Tang
-- Date: 2016-08-09 10:45:28
--鱼

local Fish = class("Fish",function(fishData,target)
	local fish =  display.newSprite()
          fish:setScale(1.2)
	return fish
end)

local FISHTAG = 
{
	TAG_GUAN = 10
}

local module_pre = "game.yule.xlkpy.src"			
local ExternalFun = require(appdf.EXTERNAL_SRC.."ExternalFun")
local cmd = module_pre..".models.CMD_LKPYGame"
local g_var = ExternalFun.req_var
local scheduler = cc.Director:getInstance():getScheduler()
local Game_CMD = appdf.req(module_pre .. ".models.CMD_LKPYGame")

--限制条件1
function Fish:switchY(num)
    if num == 1 or num == 4 or num == 10 or num == 20 or num == 33 then
        self.mY = 1
    elseif num == 34 then
        self.disAngle=175
    end
end

--限制条件2
function Fish:switchX(num)
    if num == 1 or num == 4 or num == 10 or num == 20 or num == 33 then
        self.mX=1
    end
end

function Fish:switchA(num)
    if num == 2 or num == 9 or num == 16 or num >= 25 and num <= 29 or num == 32 or num == 35 or num >= 45 and num <= 48 then
        return true
    else
        return false
    end
end

function Fish:ctor(fishData,target)
	self.m_bezierArry = {}

	self.m_data = fishData 
--    --dyj1
    self.fish_kind = self.m_data.fish_kind
    self.fish_id = self.m_data.fish_id
--    --dyj2
    self.bReal = true
    self.lockType = 1
    self.follow = 0
    --dyj1
    self.Xpos = 0
    self.Ypos = 0
    self.mX=1
    self.mY=1
    self.Rolation = 0
    self.Speed=0
	self.m_pathIndex = self.m_data.cmd_version     --轨迹路线的指引数
    self.MoveTime = 0          --通过增加MoveTime与轨迹路线的第5个值来进行判断是否转到下一条路线
    self.CurrPathindex = 1     --相当于一个计数
    self.nType=1
    --self.bomType=0
    self.ActiveTime = 0
    self.disAngle =0
    self.ifdie=false

    --self.fmove = nil
    --self.ftable = {}
    self.offsetX = 0
    self.offsetY = 0

    self.score=0
    self.fortieth = 0

    --dyj2
	self.m_schedule = nil
    self._scene = target 
    --dyj1
    self.m_producttime = currentTime()
    self.m_CreatDelayTime = 0
    self.stopindex=0
    self.stoptime=0
    self.index=1
    self.indexsum=0
    self.fscene={}
    self.fishnum=1
    --dyj2

	--self.m_nQucikClickNum = 0
	--self.m_fTouchInterval = 0
	self:setTag(Game_CMD.Tag_Fish)
	self._dataModel = target._dataModel
	self.m_scoreLabel = nil
	---[[
--	if self.m_data.nFishType-1 == Game_CMD.FishType_LvQianNianGui then
--		self.m_scoreLabel = cc.Label:createWithCharMap("game_res/sword_score.png",26,31,string.byte("0"))
--    	self.m_scoreLabel:setString("300")
--    	self.m_scoreLabel:setAnchorPoint(0.5,0.5)
--    	self.m_scoreLabel:setRotation(90)
--    	self:addChild(self.m_scoreLabel)
--	end
	--]]
	--self:initWithType(self.m_data,target)
	 --注册事件
    ExternalFun.registerTouchEvent(self,true)
end

function Fish:getT()
    return self.fishnum
end

function Fish:schedulerUpdate()

    
	local function updateFish(dt)

		self.m_ydtime = self.m_ydtime + dt * 1000
        --dyj1
		local bezier =  self.m_data.nBezierCount -- table
        local bezier = {}
        local tbp =  bezier[self.m_pathIndex]
        local tbp={
             Time= self.m_ydtime/3
            }

        --dyj2

		while self.m_ydtime > tbp.Time  do
			self.m_ydtime = self.m_ydtime - tbp.Time
			self.m_pathIndex = self.m_pathIndex + 1
		end

		if self.m_data.nBezierCount <= self.m_pathIndex-1 then 
            --dyj1
			if self.m_data.wHitChair == self._scene.m_nChairID then
				self._dataModel.m_bBoxTime = false
			end
             self._dataModel.m_bBoxTime = false
			self._dataModel.m_fishList[self.m_data.fish_id] = nil
			self._dataModel.m_InViewTag[self.m_data.fish_id] = nil            
--			self._dataModel.m_fishList[self.m_data.fish_id+2] = nil
--			self._dataModel.m_InViewTag[self.m_data.fish_id+2] = nil

            --dyj2
			self:unScheduleFish()
			self:removeFromParent()
			
			--print("******************fish removeFromParent********************")
			return
		end

		--路径百分比
		local percent = self.m_ydtime/tbp.Time

		local point = self:PointOnCubicBezier(self.m_pathIndex,percent)

        --dyj1
--		if self.m_data.fRotateAngle then
--			local bzierpoint = bezier[1]
--			local beginVec2 = cc.p(bzierpoint.BeginPoint.x,bzierpoint.BeginPoint.y)
--			point = self:RotatePoint(beginVec2,self.m_data.fRotateAngle,point)
--		end
--			local bzierpoint = bezier
            local bzierpoint={
                       BeginPoint={x=1,y=1}
                  }
			local beginVec2 = cc.p(bzierpoint.BeginPoint.x,bzierpoint.BeginPoint.y)
			point = self:RotatePoint(beginVec2,15,point)
            --self.m_data.PointOffSet.x    self.m_data.PointOffSet.y
		point = cc.p(point.x+5,point.y+5)
		point = cc.p(point.x+math.random(0,50),point.y+math.random(0,50))
        --dyj2
		local m_oldPoint = cc.p(self:getPositionX(),self:getPositionY())
		self:setConvertPoint(point)


		if cc.rectContainsPoint( cc.rect(0,0,yl.WIDTH, yl.HEIGHT), point ) then
			if self.m_data.nFishType ~= Game_CMD.FishType.FishType_YuanBao then
				self._dataModel._bFishInView = true
                --dyj1
                --print("1---------------dyj5")
				self._dataModel.m_InViewTag[self.m_data.fish_id] = 1
--				self._dataModel.m_InViewTag[self.m_data.fish_id+2] = 1
                --print("1---------------dyj6")
                --dyj2
			end
			
		else
		    self._dataModel._bFishInView = false
		    self._dataModel.m_InViewTag[self.m_data.fish_id] = nil
		end

		local nowPos = cc.p(self:getPositionX(),self:getPositionY())
		local angle = self._dataModel:getAngleByTwoPoint(nowPos,m_oldPoint)
		self:setRotation(angle)

		local pos = cc.p(self:getPositionX(),self:getPositionY())

		if pos.x < m_oldPoint.x and not self._dataModel.m_reversal  then
			self:setFlippedX(true)

		elseif pos.x < m_oldPoint.x and self._dataModel.m_reversal  then
			self:setFlippedX(false)

		elseif pos.x > m_oldPoint.x and self._dataModel.m_reversal then
			self:setFlippedX(true)
		else
			self:setFlippedX(false)
		end

		if self.m_data.nFishType == Game_CMD.FishType_LvQianNianGui then
			if nil ~= self.m_scoreLabel then
				local bFlippedX = self:isFlippedX()
				local fAngle = self:getRotation()
				if((fAngle < 0 or fAngle < 270 ) and true == not bFlippedX) then
                	self.m_scoreLabel:setRotation(270);
           		else
                	self.m_scoreLabel:setRotation(90);
				end
			self.m_scoreLabel:setPosition(cc.p(self:getContentSize().width/2,self:getContentSize().height/2))
			end
		end
	end

	--定时器
	if nil == self.m_schedule then
    --dyj1(暂时废弃)
		--self.m_schedule = scheduler:scheduleScriptFunc(updateFish,2, false)
    --dyj2
	end

end

function Fish:unScheduleFish()
	if nil ~= self.m_schedule then
	    scheduler:unscheduleScriptEntry(self.m_schedule)
	    self.m_schedule = nil
	end
end

function Fish:onEnter()
	local time = currentTime()
	self.m_ydtime = time - self.m_producttime
	--self:schedulerUpdate()
end

function Fish:onExit( )
	--print("fish onExit()...........................")
	self._dataModel.m_InViewTag[self.m_data.fish_id] = nil
	self:unScheduleFish()
end

function Fish:onTouchBegan(touch, event)
	--print("fish touch began")

	local point = touch:getLocation()
	point = self:convertToNodeSpace(point)

	local rect = self:getBoundingBox()
	rect = cc.rect(0,0,rect.width,rect.height) 

	return cc.rectContainsPoint( rect, point )  


end

function Fish:onTouchEnded(touch, event )
	--切换成当前锁定目标
    if self.fish_kind > 10 then
	    self._dataModel.m_fishIndex	= self.m_data.fish_id
    end
end


function Fish:initWithType( param,target)
	self:initBezierConfig(param)
end

function Fish:initBezierConfig( param )
	
	if type(param) ~= "table" then
		--print("传入参数类型有误, the param should be a type of table")
		return
	end

	if not param.nFishState then --按原路径返回
		
        --dyj1
		local beziers =  param.nBezierCount -- table
		local beziers =  {} -- table
		local tmp = {} 
		for i=1,#beziers-1 do
			tmp[i] = beziers[i]
		end

		for i=1,#tmp do
			local config = tmp[i]
			table.insert(beziers,#tmp+2,config)
		end
		tmp = {}
		self.m_data.nBezierCount = beziers
        --dyj2
	end

	for i=1,param.nBezierCount do
        --dyj1
		local bezier =  param.nBezierCount -- table
        local bezier =  {} -- table
		local tbp =  bezier
        local tbp={
                   KeyOne={x=10,y=10},
                   KeyTwo={x=10,y=20},
                   BeginPoint={x=20,y=10},
                   EndPoint={x=20,y=20}
                   }
	    --dyj2
		local bconfig = 
		{
			dAx = 0,
			dBx = 0,
			dCx = 0,
			dAy = 0,
			dBy = 0,
			dCy = 0
		}
	
		bconfig.dCx = 3.0 * (tbp.KeyOne.x - tbp.BeginPoint.x)
		bconfig.dBx = 3.0 * (tbp.KeyTwo.x - tbp.KeyOne.x) - bconfig.dCx
		bconfig.dAx = tbp.EndPoint.x - tbp.BeginPoint.x - bconfig.dCx - bconfig.dBx

		bconfig.dCy = 3.0 * (tbp.KeyOne.y - tbp.BeginPoint.y)
		bconfig.dBy = 3.0 * (tbp.KeyTwo.y - tbp.KeyOne.y) - bconfig.dCy
		bconfig.dAy = tbp.EndPoint.y - tbp.BeginPoint.y - bconfig.dCy - bconfig.dBy
		table.insert(self.m_bezierArry, bconfig)
	end
end

function Fish:PointOnCubicBezier(pathIndex,t)

	local bconfig = 
		{
			dAx = 0,
			dBx = 0,
			dCx = 0,
			dAy = 0,
			dBy = 0,
			dCy = 0
		}

    local result = {}
	local tSquard = 0
	local tCubed = 0
	local param = self.m_data
	bconfig = self.m_bezierArry[pathIndex]

    --dyj1
	local bezier =  param.nBezierCount -- table
	local bezier =  {} -- table
	local tbp =  bezier[pathIndex]
            local tbp={
                   BeginPoint={x=10,y=10}
                   }
    --dyj2

	tSquard = t*t
	tCubed = tSquard*t
	result.x = (bconfig.dAx * tCubed) + (bconfig.dBx * tSquard) + (bconfig.dCx * t) + tbp.BeginPoint.x
	result.y = (bconfig.dAy * tCubed) + (bconfig.dBy * tSquard) + (bconfig.dCy * t) + tbp.BeginPoint.y

	return result
end

function Fish:RotatePoint(pcircle,dradian,ptsome)

	local tmp = {}
	ptsome.x = ptsome.x - pcircle.x
	ptsome.y = ptsome.y - pcircle.y

	tmp.x = ptsome.x * math.cos(dradian) - ptsome.y * math.sin(dradian) + pcircle.x
	tmp.y = ptsome.x * math.sin(dradian) + ptsome.y * math.cos(dradian) + pcircle.y

	return tmp
end

function Fish:initAnim1()
	local namestr 
	local aniName
	namestr = string.format("fishMove_%03d_01.png", self.m_data.fish_kind+1)
	aniName = string.format("animation_fish_move%d", self.m_data.fish_kind+1)

    self.m_data.fish_kind = self.m_data.fish_kind + 1
	self:initWithSpriteFrameName(namestr)
    self:initPhysicsBody()

	local animation = cc.AnimationCache:getInstance():getAnimation(aniName)
	if nil ~= animation then
	   	local action = cc.RepeatForever:create(cc.Animate:create(animation))
	   	self:runAction(action)
	   		--渐变出现
	   	self:setOpacity(0)
	   	self:runAction(cc.FadeTo:create(0.2,255))
	end
end

function Fish:setindex(sum)
   self.indexsum = sum
end

function Fish:setscene(sce)
   self.fscene = sce
end

function  Fish:setConvertPoint1( point,angle)
     	
	 self:setPosition(point)
     self.Xpos=point.x
     self.Ypos=point.y
     if angle~=nil then
        self:setRotation(angle)
     end
end

--dyj1 (更改)
function Fish:initAnim()
	local namestr 
	local aniName
    self.m_data.fish_kind = self.m_data.fish_kind + 1               
    if self.m_data.fish_kind == 41 then                             --宝箱
        self.m_data.fish_kind = 25
    elseif self.m_data.fish_kind > 30 and self.m_data.fish_kind <= 40 then --鱼王
        self.m_data.fish_kind = self.m_data.fish_kind - 30      
        self.lockType = 2
    elseif self.m_data.fish_kind == 25 then                          --大三元
        self.m_data.fish_kind = 4
        self.lockType = 3
    elseif self.m_data.fish_kind == 26 then                          --大三元
        self.m_data.fish_kind = 5
        self.lockType = 3
    elseif self.m_data.fish_kind == 27 then                          --大三元
        self.m_data.fish_kind = 7
        self.lockType = 3
    elseif self.m_data.fish_kind == 28 then                          --大四喜
        self.m_data.fish_kind = 6
        self.lockType = 3
    elseif self.m_data.fish_kind == 29 then                          --大四喜
        self.m_data.fish_kind = 8
        self.lockType = 3
    elseif self.m_data.fish_kind == 30 then                          --大四喜
        self.m_data.fish_kind = 10
        self.lockType = 3
    end

    if self.m_data.fish_kind < 10 then
	    namestr = string.format("fishMove_00%d_01.png",self.m_data.fish_kind)    --self.m_data.nFishType
    else
        namestr = string.format("fishMove_0%d_01.png",self.m_data.fish_kind)
    end
    if self.m_data.fish_kind == Game_CMD.FishType_JinLong or self.m_data.fish_kind == Game_CMD.FishType_LiKui or self.m_data.fish_kind == Game_CMD.FishType_JinJing or self.m_data.fish_kind == Game_CMD.FishType_QiE then
                                                                                                                    
        local tips = "tips/tips_" .. self.m_data.fish_kind .. ".png"
        local tips_score = "tips/tips_score_" .. self.m_data.fish_kind .. ".png"
        self._scene._gameView:Showtips1(tips, tips_score)

    end
	
    aniName = string.format("animation_fish_move%d",self.m_data.fish_kind)    --self.m_data.nFishType

    --dyj2
	self:initWithSpriteFrameName(namestr)
    self:initPhysicsBody()
    self.nType=self.m_data.fish_kind
    if self.m_data.fish_kind==21 then
       self.m_pathIndex=15
    end
    self.mY=-1
    self.mX=-1
    self.disAngle=0
   -- self.bomType=self.m_data.m_fudaifishtype
    --限制条件7
    if self.m_pathIndex<36 then
       if self.m_pathIndex~=1 and self.m_pathIndex~=4 and self.m_pathIndex~=10 and self.m_pathIndex~=20 and self.m_pathIndex~=33 and self.m_pathIndex~=34 then
          self.disAngle=180
       end
    end
    --self.m_CreatDelayTime = self.m_data.unCreateTime

    
    self:switchY(self.m_pathIndex)
    self:switchX(self.m_pathIndex)

    self.ActiveTime = currentTime()
    if self.m_pathIndex == 48 and self.nType < 10 then                              --限制条件8
        self.Xpos=Game_CMD.PathIndex[self.m_pathIndex][1][1] - 180 * math.cos(math.rad(12*self.fortieth))
        self.Ypos=Game_CMD.PathIndex[self.m_pathIndex][1][2] + 180 * math.sin(math.rad(12*self.fortieth))
        self.fortieth = self.fortieth +1
        if self.fortieth >29 then
            self.fortieth = 0
        end
    else
        self.Xpos=Game_CMD.PathIndex[self.m_pathIndex][1][1]
        self.Ypos=Game_CMD.PathIndex[self.m_pathIndex][1][2] 
    end

    self.Rolation=Game_CMD.PathIndex[self.m_pathIndex][1][3]
    self.Speed=Game_CMD.PathIndex[self.m_pathIndex][1][4]*1.6

    --限制条件3
    if self.Xpos<1000 and self.Xpos>0 and self.m_pathIndex ~= 10 then
       self:setRotation(self.Rolation+180)
    else
       local fAngle = false
       local angle = 180
       
        local fswitchA = self:switchA(self.m_pathIndex)
        if fswitchA then
            fAngle = fswitchA
        end

        if fAngle then
           self:setRotation(self.Rolation + angle)
        else
           self:setRotation(self.Rolation)
        end

    end

    self:setPosition(cc.p(self.Xpos,self.Ypos))

	local animation = cc.AnimationCache:getInstance():getAnimation(aniName)
	if nil ~= animation then
	   	local action = cc.RepeatForever:create(cc.Animate:create(animation))
	   	self:runAction(action)
	   		--渐变出现
	   	self:setOpacity(0)
	   	self:runAction(cc.FadeTo:create(0.2,255))
	end

    if self.lockType == 2 then
        self.sp = display.newSprite("#fish_king.png")
        self.sp:setScale(0.8)
        self:addChild(self.sp, -1)
        self.sp:setPosition(cc.p(self:getContentSize().width / 2, self:getContentSize().height / 2))
        self.sp:runAction(cc.RepeatForever:create(cc.RotateBy:create(8.5,360)))
    elseif self.lockType == 3 then
        self.sp = display.newSprite("#fish_bomb_02.png")
        self.sp:setScale(0.8)
        self:addChild(self.sp, -1)
        self.sp:setPosition(cc.p(self:getContentSize().width / 2, self:getContentSize().height / 2))
        self.sp:runAction(cc.RepeatForever:create(cc.RotateBy:create(8.5,360)))
    end
end

function Fish:setForty(count)
   self.fortieth = count
end

--dyj2

--死亡处理  (更改)
function Fish:deadDeal()
	
	--self:setColor(cc.WHITE)
	self:stopAllActions()
	self:unScheduleFish()
	self:getPhysicsBody():setCategoryBitmask(8)
	local aniName 
    
	aniName = string.format("animation_fish_dead%d",self.m_data.fish_kind)

	local ani = cc.AnimationCache:getInstance():getAnimation(aniName)
	local parent = self:getParent()
	local praticle = nil
	local praticleDelayAction = cc.DelayTime:create(0.5)
	local praticleFadeOutAction = cc.FadeOut:create(1)
	local praticleCall = cc.CallFunc:create(function()
					praticle:removeFromParent(true)
				end)

	local fishPos = cc.p(self:getPositionX(),self:getPositionY())
	--红色瓶子
--	if self.m_data.fish_kind == Game_CMD.FishType_PiaoLiuPing then
--        praticle = cc.ParticleSystemQuad:create("game_res/iceRed3.plist")
--        praticle:setPosition(fishPos)
--        praticle:setPositionType(cc.POSITION_TYPE_GROUPED)
--        self:getParent():addChild(praticle,3)
--        praticle:runAction(cc.Sequence:create(praticleDelayAction,praticleFadeOutAction,praticleCall))
--        praticle:setAutoRemoveOnFinish(true)
--	end
    --[[
	if  self.m_data.fish_kind == Game_CMD.FishState.FishState_Killer  then
        praticle = cc.ParticleSystemQuad:create("game_res/ice3.plist")
        praticle:setPosition(fishPos)
        praticle:setPositionType(cc.POSITION_TYPE_GROUPED)
        self:getParent():addChild(praticle,3)
        praticle:runAction(cc.Sequence:create(praticleDelayAction,praticleFadeOutAction,praticleCall))
        praticle:setAutoRemoveOnFinish(true)
	end
    --]]
	if (self.m_data.fish_kind >=  Game_CMD.FishType.FishType_JianYu and self.m_data.fish_kind <=  Game_CMD.FishType.FishType_LiKui) or self.m_data.fish_kind ==  Game_CMD.FishType.FishType_BaoZhaFeiBiao then
		
		local radius = 360
		local nBomb = 1
		if self.m_data.fish_kind >=  Game_CMD.FishType.FishType_JianYu and self.m_data.fish_kind <=  Game_CMD.FishType.FishType_DaJinSha then
			nBomb = 1
		elseif self.m_data.fish_kind >  Game_CMD.FishType.FishType_DaJinSha and self.m_data.fish_kind <=  Game_CMD.FishType.FishType_LiKui then
			nBomb = 6
		elseif self.m_data.fish_kind ==  Game_CMD.FishType.FishType_BaoZhaFeiBiao then
			nBomb = 8
			radius = 580
			
		end

		local pos = cc.p(self:getPositionX(),self:getPositionY())

		for i=1,nBomb do
			local boomAnim = cc.AnimationCache:getInstance():getAnimation("BombAnim")
			local bomb = cc.Sprite:createWithSpriteFrameName("boom00.png")
			bomb:setPosition(pos.x,pos.y)
			bomb:runAction(cc.Animate:create(boomAnim))
			parent:addChild(bomb,40)

			if boomAnim then
				local action = nil
				if nBomb == 1 then
					action = cc.DelayTime:create(0.8)
				else
					local purPos = cc.p(0,0)
					purPos.x = pos.x + self._dataModel.m_cosList[360/nBomb*i]
					purPos.y = pos.y + self._dataModel.m_sinList[360/nBomb*i]
					purPos = self._dataModel:convertCoordinateSystem(purPos, 2, self._dataModel.m_reversal)
					action = cc.MoveTo:create(0.8,purPos)

				end
				local call = cc.CallFunc:create(function()
					bomb:removeFromParent(true)
				end)
				bomb:runAction(cc.Sequence:create(action,call))
			end
		end
	end

	if nil ~= ani then

		local times = 4
		if self.m_data.fish_kind == Game_CMD.FishType.FishType_YuanBao then
			times = 1
		end
		local repeats = cc.Repeat:create(cc.Animate:create(ani),times)
		local call = cc.CallFunc:create(function()	

			--self._dataModel.m_fishList[self.m_data.fish_id] = nil
		   	self:unScheduleFish()
  	       	--self:removeFromParent()
   		end)
		local action = cc.Sequence:create(repeats,call)
		self:runAction(action)

        self.speed=0

	end
end

--dyj1 (保留)
--设置物理属性
function Fish:initPhysicsBody()
	local fishtype = self.m_data.fish_kind
--    if fishtype ==23 then
--       self:setPhysicsBody(cc.PhysicsBody:createBox(self:getContentSize()))
--    else
	    local body = self._dataModel:getBodyByType(fishtype)

	    if body == nil then
		    --print("body is nil.......")
		    return
	    end

	    self:setPhysicsBody(body)
--    end

--设置刚体属性
    self:getPhysicsBody():setCategoryBitmask(1)
    self:getPhysicsBody():setCollisionBitmask(0)
    self:getPhysicsBody():setContactTestBitmask(2)
    self:getPhysicsBody():setGravityEnable(false)
end

function Fish:setPhy(ifno)
    if ifno then
        self:getPhysicsBody():setCategoryBitmask(3)
        self:getPhysicsBody():setContactTestBitmask(4)
    else
        self:getPhysicsBody():setCategoryBitmask(1)
        self:getPhysicsBody():setContactTestBitmask(2)
    end

end

--dyj2

--dyj1(暂时废弃)
function Fish:initWithState()
	
	local fishstate = self.m_data.nFishState
	if  fishstate ~= Game_CMD.FishState.FishState_Normal then
		local contentsize = self:getContentSize()

		if fishstate == Game_CMD.FishState.FishState_King  and self.m_data.nFishType ~= Game_CMD.FishType_TuLongDao then
			local guan = cc.Sprite:createWithSpriteFrameName("fish_king.png")
			guan:setPosition(cc.p(contentsize.width/2,contentsize.height/2))
			self:addChild(guan, -1)
			guan:runAction(cc.RepeatForever:create(cc.RotateBy:create(8.5,360)))

		elseif fishstate == Game_CMD.FishState.FishState_Killer then
			local guan = cc.Sprite:createWithSpriteFrameName("fish_bomb_01.png")
			guan:setPosition(cc.p(contentsize.width/2,contentsize.height/2))
			self:addChild(guan, -1)
			--guan:runAction(cc.RepeatForever:create(cc.RotateBy:create(8.5,360)))
		
		elseif fishstate == Game_CMD.FishState.FishState_Aquatic then
			local guan = cc.Sprite:createWithSpriteFrameName("fishMove_026_01.png")
			local  anr  = guan:getAnchorPoint()
			guan:setPosition(cc.p(contentsize.width/2,contentsize.height/2))
			self:addChild(guan, 3)
			local anim = cc.AnimationCache:getInstance():getAnimation("animation_fish_move26")
			local action1 = cc.Repeat:create(cc.Animate:create(anim), 999999)
--			local action2 = cc.Repeat:create(cc.RotateBy:create(8.5,360), 999999)
			guan:runAction(action1)
--			guan:runAction(action2)
			--[[--]]
		end
	end
end
--dyj2

--转换坐标
function  Fish:setConvertPoint( point,angle)
     	

	 self:setPosition(point)
     if angle~=nil then
        self:setRotation(angle)
     end
end


--鱼停留
function Fish:Stay(time)
	self:unScheduleFish()
	local call = cc.CallFunc:create(function()	
		self:schedulerUpdate()
	end)
	local delay = cc.DelayTime:create(time/1000)

	self:runAction(cc.Sequence:create(delay,call))


end

function Fish:setScore(lScore)
	if nil ~= self.m_scoreLabel then
		self.m_scoreLabel:setString(string.format("%d", lScore))
	end
end

return Fish