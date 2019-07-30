--
-- Author: Tang
-- Date: 2016-08-09 14:50:01
--
local GameFrame = class("GameFrame")

local MATERIAL_DEFAULT = cc.PhysicsMaterial(0.1, 0.5, 0.5)
local winsize = cc.Director:getInstance():getVisibleSize()
local SCREENWIDTH = winsize.width
local SCREENHEIGTH = winsize.height
local res_path = "game/yule/jcby/res/"

function GameFrame:ctor()
 	
 	self.m_autoshoot = false    --自动射击
 	self.m_autolock = false 	--自动锁定
    --self.m_speed = false    --加速
 	self.m_reversal = false
 	self.m_fishIndex = 2147483647
 	self._bFishInView	    = false
 	self.m_InViewTag = {}
 	self._exchangeSceneing	= false

 	self.m_getFishScore = 0     --捕鱼收获
 	
 	self.m_waitList = {}  --等待鱼列表
 	self.m_fishList = {}  --鱼列表
 	self.m_fishKingList = {} --记录鱼王
 	self.m_fishCreateList = {} --创建鱼

 	self.m_fishArray = {}	--场景中鱼

 	self.m_bodyList = {}  --物体刚体数据

 	self.m_secene = {}	--场景数据
    self.m_nMultiple = {100,200,300,400,500,600,700,800,900,1000}           --房间倍数 {1,10,100,500,1000,5000}

    self.m_sinList = {}
    self.m_cosList = {}


   	self:readyBodyPlist("game_res/fish_bodies.plist")
   	self:readyBodyPlist("game_res/bullet_bodies.plist")

   	self.m_enterTime = 0	--进入时间 

    self:initTrigonomentirc()

    self.m_bBoxTime = false --自己的宝箱是否存在
	
	self.m_lScoreCopy = 0 --自己的分数拷贝 用于同步

end


--解析刚体数据 plist
function GameFrame:readyBodyPlist( param )
	
    local Path = res_path .. param --cc.FileUtils:getInstance():fullPathForFilename(param)
    local datalist = cc.FileUtils:getInstance():getValueMapFromFile(Path) 
    local bodies = datalist["bodies"]
  
  --解析数据
 	 for k,v in pairs(bodies) do
    	if  k ~= nil then
    		local bodyName = k
    		local sub = bodies[bodyName]
    		local fixtures = sub["fixtures"]
    		local polygonsarr = fixtures[1]
    		local polygons = polygonsarr["polygons"]
    		
    		local points = {}
    		for i=1,#polygons do
    		  	table.insert(points, polygons[i])
    		end

    		table.insert(self.m_bodyList,{k = bodyName,p = points})

    	   
    	end
    end
end

--dyj1  (保留)
function GameFrame:getBodyByType(param)

    local type =nil
    if param < 10 then
	   type = string.format("fishMove_00%d_01",param)    --self.m_data.nFishType
    else
	   type = string.format("fishMove_0%d_01",param)    --self.m_data.nFishType
    end

	return self:getBodyByName(type)
end
--dyj2

--dyj1 (保留)
function GameFrame:getBodyByName( param )
	
	if #self.m_bodyList ~= 0 then
		for i=1,#self.m_bodyList do
			local sublist = self.m_bodyList[i]
			local k = sublist.k
	
			if k == param then
				local points = sublist.p
				local physicsBody = cc.PhysicsBody:create(PHYSICS_INFINITY, PHYSICS_INFINITY)
				for s=1,#points do
					local onePoint = points[s]
					local resultPoints = {}
					for t=1,#onePoint do
						local vector = onePoint[t]
						--去掉大括号
						local result = string.sub(vector, 2, -2)
						local len = string.len(result)
						local dindex = string.find(result,",")

						local subx = string.sub(result,1,dindex-1)
						local x = tonumber(subx)
						local suby = string.sub(result,dindex+1,len)
						local y = tonumber(suby)
		
						local p = cc.p(x,y)
						table.insert(resultPoints, p)
					end
				

					local center = cc.PhysicsShape:getPolyonCenter(resultPoints)
				    local shape = cc.PhysicsShapePolygon:create(resultPoints,cc.PHYSICSBODY_MATERIAL_DEFAULT,cc.p(-center.x, -center.y))
				    physicsBody:addShape(shape)
					physicsBody:setGravityEnable(false)
					return physicsBody

				end
			 break
			end
		end

	end

end
--dyj2

--[[
@function  convertCoordinateSystem

@param type : 0 左下角坐标系转换到左上角坐标系 
			  1 左上角坐标系转换到左下角坐标系
			  2 爆炸动画坐标系

@return cc.p
]]
function GameFrame:convertCoordinateSystem( point,type,bconvert )

 local WIN32_W = 1280
 local WIN32_H = 800
 local scalex = yl.WIDTH/WIN32_W
 local scaley = yl.HEIGHT/WIN32_H

 local point1 = point 
 if type ==0 then
 	point1.x = point.x/scalex
 	point1.y = WIN32_H - point1.y/scaley
 	if bconvert  then
 	   point1.x = WIN32_W - point1.x
 	   point1.y = WIN32_H - point1.y
 	end
 elseif type == 1 then
 	
    point1.x = point.x*scalex
    point1.y = yl.HEIGHT - point.y*scaley

    if bconvert then
    	point1.x = yl.WIDTH - point1.x
    	point1.y = yl.HEIGHT - point1.y
    end

 else
 	point1.x = point1.x/scalex

 	if bconvert then
 		point1.x = WIN32_W - point1.x
 		point1.y = WIN32_H - point1.y/scaley
 	end

 end

  return point1
   
end

function GameFrame:getAngleByTwoPoint( param,param1 )

   if type(param) ~= "table" or type(param1) ~= "table" then
   	print("传入参数有误")
   	return
   end

	local point = cc.p(param.x-param1.x,param.y-param1.y)
	local angle = 90 - math.deg(math.atan2(point.y, point.x))
   -- print("angle is ========>"..angle)
    return angle

end


function GameFrame:getNetColor( param )

	if type(param) ~= "number" then
		return
	end

	if param == 0 or param > 5 then
		param = 1
	end

	local switch = 
	{
		[1] = function( )
			return  cc.WHITE
		end,

		[2] = function( )
			return  cc.BLUE
		end,

		[3] = function( )
			return cc.GREEN
		end,

		[4] = function( )
			return cc.c3b(255, 0, 255)
		end,

		[5] = function( )
			return cc.RED
		end,

		[6] = function( )
			return cc.YELLOW
		end
	}

	local f = switch[param]
	return f()

end


--自动锁定搜寻大鱼
function GameFrame:selectMaxFish( )

    if self.m_fishList[self.m_fishIndex] ~= nil and self.m_fishList[self.m_fishIndex].fish_id == self.m_fishIndex then
        return self.m_fishIndex
    end

    self.m_fishIndex = 2147483647

	local fishlist = {}
	local fishtype = 2

	local rect = cc.rect(0,0,yl.WIDTH,yl.HEIGHT)


	for k,fish in pairs(self.m_fishList) do
        if fish.m_data ~= nil then
		    if fish.fish_kind > fishtype then
			    if cc.rectContainsPoint( rect, cc.p(fish:getPositionX(),fish:getPositionY()) ) then
				    fishtype = fish.fish_kind
				    fishlist = {}
				    table.insert(fishlist,fish)
			    end
		    end
		    if fish.fish_kind == fishtype then
			    table.insert(fishlist,fish)
		    end
        end
	end

    local distant = 1000
	for i=1,#fishlist do        --返回距离最近的锁定鱼
		local distant1 =  cc.pGetDistance(cc.p(fishlist[i]:getPositionX(),fishlist[i]:getPositionY()), cc.p(yl.WIDTH/2,yl.HEIGHT/2))
		if distant1 < distant then
			distant = distant1
			self.m_fishIndex = fishlist[i].m_data.fish_id
		end
	end

	fishlist = {}

	return self.m_fishIndex

end

function GameFrame:initTrigonomentirc( )
	for i=1,360 do
		local sin = math.sin(3.14 / 180 * i)
		local cos = math.cos(3.14 / 180 * i)
		table.insert(self.m_sinList, sin)
		table.insert(self.m_cosList, cos)
	end
end

function GameFrame:playEffect( file )
	if not GlobalUserItem.bLKFishSound then
		return
	end
	
	AudioEngine.playEffect(file)
end

return GameFrame