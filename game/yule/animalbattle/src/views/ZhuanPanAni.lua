	local module_pre = "game.yule.animalbattle.src"
	local cmd = appdf.req(module_pre .. ".models.CMD_Game")

	local ZhuanPanAni=class("ZhuanPanAni",cc.Layer)

	ZhuanPanAni.tabZhuanpanPos={
		cc.p(403,690),cc.p(488,702),cc.p(575,704),cc.p(662,702),cc.p(751,706),cc.p(838,700),cc.p(922,690),
		cc.p(1009,673),cc.p(1091,639),cc.p(1160,591),cc.p(1205,518),cc.p(1165,438),cc.p(1093,391),cc.p(1014,359),
		cc.p(928,345),cc.p(842,330),cc.p(757,330),cc.p(668,328),cc.p(580,329),cc.p(494,336),cc.p(409,345),
		cc.p(321,360),cc.p(245,396),cc.p(168,437),cc.p(127,515),cc.p(173,587),cc.p(241,640),cc.p(322,672)
	}

	function ZhuanPanAni:ctor(scene,begIndex,endIndex,duration,totalSec) --从最左边的第一个兔子开始为位置索引开始处，顺时针递增
		scene:addChild(self)
		self.scene,self.begIndex,self.endIndex=scene,begIndex,endIndex
		self.duration=duration
		local deltaT=cc.Director:getInstance():getAnimationInterval()
		--local frameRate=1/deltaT
		duration=duration or 10
		self.frames=math.floor(duration/deltaT) --持续帧数		
		self.totalSec=totalSec
	end

	function ZhuanPanAni.zhuanpanPosToKind(index) --从最左边的第一个兔子开始为位置索引开始处，顺时针索引递增
		local tab={								--服务端发来的转盘停止位置索引[1,28]
		cmd.JS_TU_ZI, cmd.JS_TU_ZI, cmd.JS_TU_ZI, cmd.JS_JIN_SHA, cmd.JS_YAN_ZI, cmd.JS_YAN_ZI, cmd.JS_YAN_ZI,
		cmd.JS_GE_ZI, cmd.JS_GE_ZI, cmd.JS_GE_ZI, cmd.JS_TONG_SHA, cmd.JS_KONG_QUE, cmd.JS_KONG_QUE, cmd.JS_KONG_QUE,
		cmd.JS_LAO_YING, cmd.JS_LAO_YING, cmd.JS_LAO_YING, cmd.JS_YIN_SHA, cmd.JS_SHI_ZI, cmd.JS_SHI_ZI, cmd.JS_SHI_ZI,
		cmd.JS_XIONG_MAO, cmd.JS_XIONG_MAO, cmd.JS_XIONG_MAO, cmd.JS_TONG_PEI, cmd.JS_HOU_ZI, cmd.JS_HOU_ZI, cmd.JS_HOU_ZI 
		}              
		dbg_assert(#tab==28)              
		return tab[index]
	end

	function ZhuanPanAni:moveAStep(node)
		node.m_index=node.m_index+1
		if node.m_index>28 then
			node.m_index=1
		end
		--print(node.m_index)
		node:setPosition(self.tabZhuanpanPos[node.m_index])
	end

	function ZhuanPanAni:animationForFirstOpening() --第一次进入为开奖状态，乱闪
		local bright=cc.Sprite:create("brightcircle.png")
		bright:addTo(self)
		bright:scheduleUpdate(function() bright:setPosition(self.tabZhuanpanPos[math.random(28)]) end)
	end

	function ZhuanPanAni:ZhuanPan(callback)
		self.callback=callback
		local begTime=os.time()
		self.startTime=begTime
		local endIndex=self.endIndex
		local begIndex=self.begIndex

		if self.frames==0 then
			return 
		end

		local scene=self.scene
		local bright=cc.Sprite:create("brightcircle.png")
		
		self:addChild(bright)
		bright.m_index=self.begIndex
		bright:setPosition( self.tabZhuanpanPos[bright.m_index] )
		self.bright=bright
		local perimeter=28 --总共28个格子
		 --表示每隔everyNFrame[speedKind]帧移动一次
		self.everyNFrame={9,8,7,6,5,4,3,2,1} --只需要设置这里以更改跑马灯动画
		
		--除最慢外，每种速度跑的steps数 varSpeedSteps=40/everyNFrame[speedKind]
		self.fastest=#self.everyNFrame --speedKind
		self.slowest=1			   --speedKind

		local t=self.frames/(2*#self.everyNFrame-1)
		self.varSpeedSteps={}
		for i=1,#self.everyNFrame-1 do
			self.varSpeedSteps[i]=math.max( 1, math.floor(t/self.everyNFrame[i]) )
		end

		--计算除最快速度外的总步数
		local steps=0
		for i=1,#self.everyNFrame-1 do
			steps=steps+2*(self.varSpeedSteps[i])
		end
		-- print("steps= ",steps)
		local fastestSteps=(perimeter+endIndex-(begIndex+steps)%perimeter)%perimeter
		if fastestSteps==0 then
			fastestSteps=perimeter
		end
		self.varSpeedSteps[#self.everyNFrame]=fastestSteps
		
		local function 	brightDelayRemoveSelf(t)
			print("t: ",t)
			self.bright:runAction(cc.Sequence:create(
			cc.Blink:create(math.max(0,t),math.max(1,t)),
			cc.CallFunc:create(function() self.bright:removeSelf() end)
			))
		end
		self.brightDelayRemoveSelf=brightDelayRemoveSelf
		
		self.speedKind=self.slowest 
		self.frameN=0
		self.changeSpeed=1
		self.changeSpeedN=0 --每移动一次加1，当changeSpeedN>=varSpeedSteps[speedKind]，speedKind变化
		self.stepsRunned=0 -- for debug
		self.followRects={}
		local function moveBrightRect(dt)

			self.frameN=self.frameN+1
			if self.frameN>=self.everyNFrame[self.speedKind] then
				self.frameN=0
				self:moveAStep(self.bright)
				for k,circle in ipairs(self.followRects) do
					self:moveAStep(circle)
				end
				self.stepsRunned=self.stepsRunned+1
				self.changeSpeedN=self.changeSpeedN+1
				if self.changeSpeedN>=self.varSpeedSteps[self.speedKind] then
					self.changeSpeedN=0
					if self.speedKind==self.fastest then
						self.changeSpeed=-self.changeSpeed
					end
					if self.changeSpeed>0 then
						local followRect
						followRect=display.newSprite("brightcircle.png")
						followRect:addTo(self)
						local lastFollow=self.followRects[#self.followRects] or self.bright
						followRect.m_index= lastFollow.m_index-1<=0 and 28 or (lastFollow.m_index-1)
						followRect:setPosition(self.tabZhuanpanPos[followRect.m_index]) --aw/2==36,ah/2==36
						table.insert(self.followRects,followRect)
					else
						local rect=self.followRects[#self.followRects]
						if nil~=rect then rect:removeSelf() end
						self.followRects[#self.followRects]=nil
					end
		
					self.speedKind=self.speedKind+self.changeSpeed
					if self.speedKind<=self.slowest-1 then

						self:unscheduleUpdate()
						self.bUnscheduleUpdate=true
						local usedSec=os.time()-begTime
						local restSec=math.max(0.1,self.totalSec-usedSec)

						print("restSec: ",restSec)
						print("usedSec",usedSec)
			
						dbg_assert(self.bright.m_index==self.endIndex)

						self:runAction(
							cc.CallFunc:create(function() 
								brightDelayRemoveSelf(self.restSec)
								if self.callback then self.callback(math.max(0,self.restSec)) end
							end)
						)
					end
				end
			end
		end
		self.moveBrightRect=moveBrightRect

		self:scheduleUpdate(
			function()
				local t=os.time()
				if self.lastUpdateTime==nil then
					self.lastUpdateTime=t
					self.restSec=self.totalSec
					moveBrightRect()
					return
				end
				local elapsed=t-self.lastUpdateTime
				--print("elapsed: ",elapsed)
				if self.lastUpdateTime==nil or (t-self.startTime<self.duration and elapsed<=1) then 
					self.lastUpdateTime=t
					self.restSec=self.totalSec-(t-self.startTime)
					moveBrightRect()
					return
				end
				self.restSec=self.totalSec-(t-self.startTime)
				self.lastUpdateTime=t
				--print("elapsed: ",elapsed)
				--print("t-self.startTime: ",t-self.startTime)
				if t-self.startTime>=self.totalSec then --从后台返回来
					self:unscheduleUpdate()
					self.bright:removeSelf()
					for k,v in pairs(self.followRects) do
						v:removeSelf()
					end
				elseif t-self.startTime>=self.duration then
					self:unscheduleUpdate()
					self.bright:setPosition(self.tabZhuanpanPos[self.endIndex])
					for k,v in pairs(self.followRects) do
						v:removeSelf()
					end
					self.restSec=self.totalSec-(t-self.startTime)
					self:runAction(
							cc.CallFunc:create(function() 
								self.brightDelayRemoveSelf(self.restSec)
								if self.callback then self.callback(self.restSec) end
							end))
				elseif t-self.startTime<self.duration then  --2改成准确数字
					self:resumeZhuanPan(elapsed)
				end
			end
			)
	end

	function ZhuanPanAni:resumeZhuanPan(timeElapsed) --timeElapsed表示在后台的时间
		self:stopAllActions()
		-- if self.bUnscheduleUpdate~=true then self.bright:stopAllActions() end
		local animationInterval=cc.Director:getInstance():getAnimationInterval()
		local passedFrames=timeElapsed/animationInterval
		for i=1,passedFrames do --在后台有passedFrames帧(=在后台的时间/animationInterval)没有调用moveBrightRect，这里一次性完成
			if self.bUnscheduleUpdate==true then
				return
			end
			self.moveBrightRect()
		end

		if self.bUnscheduleUpdate~=true then
			self:scheduleUpdate(self.moveBrightRect)
		end
	end

return ZhuanPanAni