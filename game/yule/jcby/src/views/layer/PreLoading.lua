--
-- Author: Tang
-- Date: 2016-08-09 10:31:32
-- 预加载资源
local PreLoading = {}
local module_pre = "game.yule.jcby.src"	
local cmd = module_pre .. ".models.CMD_LKPYGame"
local ExternalFun = require(appdf.EXTERNAL_SRC.."ExternalFun")
local g_var = ExternalFun.req_var
local Game_CMD = appdf.req(module_pre .. ".models.CMD_LKPYGame")

--------------------------------------------------------------------------------------------------------鱼阵

PreLoading.scene_kind_2_small_fish_stop_index_ = {}
PreLoading.scene_kind_2_small_fish_stop_count_ = 0

PreLoading.scene_kind_2_big_fish_stop_index_ = 0
PreLoading.scene_kind_2_big_fish_stop_count_ = 0

local winsize = cc.Director:getInstance():getVisibleSize()

local kResolutionWidth = 1366
local kResolutionHeight = 768

local m_WScale = winsize.width / 1136 / 100                    --宽度比例
local m_HScale = winsize.height / 640 / 100                    --高度比例

PreLoading.bLoadingFinish = false
PreLoading.loadingPer = 10
PreLoading.bFishData = false
PreLoading.bEnd = false
function PreLoading.resetData()
	PreLoading.bLoadingFinish = false
	PreLoading.loadingPer = 10
	PreLoading.bFishData = false
	PreLoading.bEnd = true
end

function PreLoading.StopAnim(bRemove)

	local scene = cc.Director:getInstance():getRunningScene()
	local layer = scene:getChildByTag(2000) 

	if not layer  then
		return
	end

	if not bRemove then
		if nil ~= PreLoading.fish then
			PreLoading.fish:stopAllActions()
		end
	else
	
		layer:stopAllActions()
		layer:removeFromParent(true)
	end
end

function PreLoading.setEnded(is)
	PreLoading.bEnd = is
	if false == is then
		PreLoading.resetData()
	end
	PreLoading.bEnd = false
	--print("setEnded bEnd ".. tostring(PreLoading.bEnd))
end


function PreLoading.loadTextures()
    
        cc.Director:getInstance():getTextureCache():removeUnusedTextures()
    cc.SpriteFrameCache:getInstance():removeUnusedSpriteFrames()
    local function loadFishTrace()
        local kHScale = winsize.width / kResolutionWidth
        local kVScale = winsize.height / kResolutionHeight
        local kStopExcursion = 180 * kVScale
        PreLoading.fishTrace1_1 = appdf.req(module_pre .. ".models.fishTrace1_1")        -- 41
        PreLoading.fishTrace1_2 = appdf.req(module_pre .. ".models.fishTrace1_2")        -- 45   86
        PreLoading.fishTrace1_3 = appdf.req(module_pre .. ".models.fishTrace1_3")        -- 41   127
        PreLoading.fishTrace1_4 = appdf.req(module_pre .. ".models.fishTrace1_4")        -- 42   169
        PreLoading.fishTrace1_5 = appdf.req(module_pre .. ".models.fishTrace1_5")        -- 41   210

        PreLoading.fishTrace2_1 = appdf.req(module_pre .. ".models.fishTrace2_1")        -- 190
        PreLoading.fishTrace2_2 = appdf.req(module_pre .. ".models.fishTrace2_2")        -- 24

        PreLoading.fishTrace3_1 = appdf.req(module_pre .. ".models.fishTrace3_1")        -- 41
        PreLoading.fishTrace3_2 = appdf.req(module_pre .. ".models.fishTrace3_2")        -- 41   82
        PreLoading.fishTrace3_3 = appdf.req(module_pre .. ".models.fishTrace3_3")        -- 40   122
        PreLoading.fishTrace3_4 = appdf.req(module_pre .. ".models.fishTrace3_4")        -- 39   161
        PreLoading.fishTrace3_5 = appdf.req(module_pre .. ".models.fishTrace3_5")        -- 41   202
        PreLoading.fishTrace3_6 = appdf.req(module_pre .. ".models.fishTrace3_6")        -- 40   242

        PreLoading.fishTrace4_1 = appdf.req(module_pre .. ".models.fishTrace4_1")        -- 31
        PreLoading.fishTrace4_2 = appdf.req(module_pre .. ".models.fishTrace4_2")        -- 33   64

        PreLoading.fishTrace5_1 = appdf.req(module_pre .. ".models.fishTrace5_1")        -- 51
        PreLoading.fishTrace5_2 = appdf.req(module_pre .. ".models.fishTrace5_2")        -- 51   102
        PreLoading.fishTrace5_3 = appdf.req(module_pre .. ".models.fishTrace5_3")        -- 51   153
        PreLoading.fishTrace5_4 = appdf.req(module_pre .. ".models.fishTrace5_4")        -- 40   193
        PreLoading.fishTrace5_5 = appdf.req(module_pre .. ".models.fishTrace5_5")        -- 43   236

        local big_stop_count = 0
        --两百条小鱼
        for i = 1, 200 do
            local fishTrace = {}
            if i <= 190 then
                fishTrace = PreLoading.fishTrace2_1[i]
            elseif i > 190 and i <= 214 then 
                fishTrace = PreLoading.fishTrace2_2[i - 190]
            end
            --每条鱼所有的点
            for j = 1, #fishTrace do
            
                --每个点
                local pos = fishTrace[j]
                if i <= 100 then
                    if pos[2] * m_HScale >= kStopExcursion then
                        PreLoading.scene_kind_2_small_fish_stop_index_[i] = j
                        if big_stop_count == 0 then
                            big_stop_count = j
                        elseif big_stop_count < j then
                            big_stop_count = j
                        end
                        break
                    end
                else
                    if pos[2] * m_HScale < winsize.height - kStopExcursion then
                        PreLoading.scene_kind_2_small_fish_stop_index_[i] = j
                        if big_stop_count == 0 then
                            big_stop_count = j
                        elseif big_stop_count < j then
                            big_stop_count = j
                        end
                        break
                    end
                end
            end
        end
        PreLoading.scene_kind_2_small_fish_stop_count_ = 1580      --2009
        PreLoading.scene_kind_2_big_fish_stop_index_ = 0
        PreLoading.scene_kind_2_big_fish_stop_count_= big_stop_count + 1


        PreLoading.bLoadingFinish = true

        --通知
		local event = cc.EventCustom:new(Game_CMD.Event_LoadingFinish)
		cc.Director:getInstance():getEventDispatcher():dispatchEvent(event)
		--print(tostring(PreLoading.bFishData))
		if PreLoading.bFishData then
				
			local scene = cc.Director:getInstance():getRunningScene()
			local layer = scene:getChildByTag(2000) 

			if not layer  then
				return
			end

			PreLoading.loadingPer = 100
			PreLoading.updatePercent(PreLoading.loadingPer)
			local callfunc = cc.CallFunc:create(function()
				PreLoading.loadingBar:stopAllActions()
				PreLoading.loadingBar = nil
		
				layer:stopAllActions()
				layer:removeFromParent(true)
			end)
			layer:stopAllActions()
			layer:runAction(cc.Sequence:create(cc.DelayTime:create(2.2),callfunc))
		end
        PreLoading.Finish()
        --print("资源加载完成")
    end

	local m_nImageOffset = 0

	local totalSource = 12       

	local plists = {"whater.plist",                  -- √
                    "fish_ignot.plist",  -- √
					"fish_dead.plist",               -- √
					"watch.plist",                   -- √
					"fish_move1.plist",              -- √
					"fish_move2.plist",              -- √
					"lock_fish.plist",               -- √
					"bomb.plist",                    -- 不一样
					"bullet_guns_coins.plist",       -- √
					"image.plist",                   -- √
                    "wave.plist",        --波浪
                    "pao.plist",        --
				   }

	local function imageLoaded(texture)
   		if true == PreLoading.bEnd then
			return
		end
   		--print("Image loaded:..."..texture:getPath())
        m_nImageOffset = m_nImageOffset + 1
        PreLoading.loadingPer = 11 + m_nImageOffset * 2 * 3
        PreLoading.updatePercent(PreLoading.loadingPer)

        if m_nImageOffset == totalSource then

        	--加载PLIST
        	for i=1,#plists do
        		cc.SpriteFrameCache:getInstance():addSpriteFrames("game_res/"..plists[i])
        	end

        	PreLoading.readAniams()

            --开始加载鱼阵路径
            loadFishTrace()

        end
    end

    local function 	loadImages()
        cc.Director:getInstance():getTextureCache():addImageAsync("game_res/whater.png", imageLoaded)
        ----cc.Director:getInstance():getTextureCache():addImageAsync("game_res/bullet.png",imageLoaded)
		cc.Director:getInstance():getTextureCache():addImageAsync("game_res/fish_ignot.png", imageLoaded)
		cc.Director:getInstance():getTextureCache():addImageAsync("game_res/fish_dead.png", imageLoaded)
		cc.Director:getInstance():getTextureCache():addImageAsync("game_res/watch.png", imageLoaded)
		cc.Director:getInstance():getTextureCache():addImageAsync("game_res/fish_move1.png", imageLoaded)
		cc.Director:getInstance():getTextureCache():addImageAsync("game_res/fish_move2.png", imageLoaded)
		cc.Director:getInstance():getTextureCache():addImageAsync("game_res/lock_fish.png", imageLoaded)
		cc.Director:getInstance():getTextureCache():addImageAsync("game_res/bomb.png", imageLoaded)
		cc.Director:getInstance():getTextureCache():addImageAsync("game_res/bullet_guns_coins.png", imageLoaded)
		cc.Director:getInstance():getTextureCache():addImageAsync("game_res/image.png", imageLoaded)
        cc.Director:getInstance():getTextureCache():addImageAsync("game_res/wave.png", imageLoaded)
        cc.Director:getInstance():getTextureCache():addImageAsync("game_res/pao.png", imageLoaded)
    end


    local function createSchedule( )
    	local function update( dt )
			PreLoading.updatePercent(PreLoading.loadingPer)
		end

		local scheduler = cc.Director:getInstance():getScheduler()
		PreLoading.m_scheduleUpdate = scheduler:scheduleScriptFunc(update, 0, false)
    end

	loadImages()

	--进度条
    --print("1---------------dyj3")
	PreLoading.GameLoadingView()
    --print("1---------------dyj4")

	--createSchedule()

	--PreLoading.addEvent()

end

--dyj1  (废弃)
function PreLoading.addEvent()

   --通知监听
  local function eventListener(event)
  	cc.Director:getInstance():getEventDispatcher():removeCustomEventListeners(Game_CMD.Event_FishCreate)
	PreLoading.Finish()
  end

  local listener = cc.EventListenerCustom:create(Game_CMD.Event_FishCreate,eventListener)
  cc.Director:getInstance():getEventDispatcher():addEventListenerWithFixedPriority(listener, 1)

end
--dyj2

function PreLoading.Finish()

	PreLoading.bFishData = true

	if  PreLoading.bLoadingFinish then
		PreLoading.loadingPer = 100
		PreLoading.updatePercent(PreLoading.loadingPer)

		local scene = cc.Director:getInstance():getRunningScene()
		local layer = scene:getChildByTag(2000) 

		if nil ~= layer then
			local callfunc = cc.CallFunc:create(function()
				PreLoading.loadingBar:stopAllActions()
				PreLoading.loadingBar = nil
				PreLoading.fish:stopAllActions()
				PreLoading.fish = nil
				layer:stopAllActions()
				layer:removeFromParent(true)

			end)

			layer:stopAllActions()
			layer:runAction(cc.Sequence:create(cc.DelayTime:create(2.2),callfunc))
		end
	end
end

function PreLoading.GameLoadingView()
	
	local scene = cc.Director:getInstance():getRunningScene()
	local layer = display.newLayer()
	layer:setTag(2000)
	scene:addChild(layer,30)

	local loadingBG = ccui.ImageView:create("loading/bg.jpg")
	loadingBG:setTag(1)
	loadingBG:setTouchEnabled(true)
    loadingBG:setVisible(true)
	loadingBG:setPosition(cc.p(yl.WIDTH/2,yl.HEIGHT/2))
	layer:addChild(loadingBG)

	---[[
	local loadingBarBG = ccui.ImageView:create("loading/loadingBG.png")
	loadingBarBG:setVisible(false)
	loadingBarBG:setTag(2)
	loadingBarBG:setPosition(cc.p(yl.WIDTH/2,yl.HEIGHT/2-300))
	layer:addChild(loadingBarBG)
	--]]

	local loading_text = ccui.ImageView:create("loading/loading_text.png")
	loading_text:setTag(4)
	loading_text:setPosition(cc.p(yl.WIDTH/2,yl.HEIGHT/2 - 205))
	layer:addChild(loading_text)

	PreLoading.loadingBar = cc.ProgressTimer:create(cc.Sprite:create("loading/loading_cell.png"))
	PreLoading.loadingBar:setType(cc.PROGRESS_TIMER_TYPE_BAR)
	PreLoading.loadingBar:setMidpoint(cc.p(0.0,0.5))
	PreLoading.loadingBar:setBarChangeRate(cc.p(1,0))
    PreLoading.loadingBar:setPosition(cc.p(layer:getContentSize().width/2,111))
    PreLoading.loadingBar:runAction(cc.ProgressTo:create(0.2,20))
    layer:addChild(PreLoading.loadingBar)

	local frames = {}
   	local actionTime = 0.1
	for i=1,9 do
		local frameName
		frameName = string.format("loading/loading_".."%d.png", i)
		local frame = cc.SpriteFrame:create(frameName,cc.rect(0,0,258,97))
		table.insert(frames, frame)
	end

	local  animation =cc.Animation:createWithSpriteFrames(frames,actionTime)

    PreLoading.fish = cc.Sprite:create("loading/loading_1.png")
    PreLoading.fish:setAnchorPoint(cc.p(1.0,0.5))
    PreLoading.fish:setPosition(cc.p(170,PreLoading.loadingBar:getContentSize().height/2))
    PreLoading.loadingBar:addChild(PreLoading.fish)

    PreLoading.fish:stopAllActions()
    local action = cc.RepeatForever:create(cc.Animate:create(animation))
	PreLoading.fish:runAction(action)

	local move = cc.MoveTo:create(0.2,cc.p(980*(20/100),PreLoading.loadingBar:getContentSize().height/2))
	move:setTag(1)
    PreLoading.fish:runAction(move)
end

function PreLoading.updatePercent(percent )
	if true == PreLoading.bEnd then
		return
	end
	if nil ~= PreLoading.loadingBar then

		local dt = 1.0
		if percent == 100 then
			dt = 2.0
		end

		PreLoading.loadingBar:runAction(cc.ProgressTo:create(dt,percent))
		cc.Director:getInstance():getActionManager():removeActionByTag(1, PreLoading.fish)
		local move =  cc.MoveTo:create(dt,cc.p(1060*(percent/100),PreLoading.loadingBar:getContentSize().height/2))
		move:setTag(1)
		PreLoading.fish:runAction(move)
	end

	if PreLoading.bLoadingFinish then
		if nil ~= PreLoading.m_scheduleUpdate then
    		local scheduler = cc.Director:getInstance():getScheduler()
			scheduler:unscheduleScriptEntry(PreLoading.m_scheduleUpdate)
			PreLoading.m_scheduleUpdate = nil
		end
	end
end


function PreLoading.unloadTextures( )
	
	cc.SpriteFrameCache:getInstance():removeSpriteFramesFromFile("game_res/whater.plist")
    cc.Director:getInstance():getTextureCache():removeTextureForKey("game_res/whater.png")
	
--	cc.SpriteFrameCache:getInstance():removeSpriteFramesFromFile("game_res/bullet.plist")
--    cc.Director:getInstance():getTextureCache():removeTextureForKey("game_res/bullet.png")
	
    cc.SpriteFrameCache:getInstance():removeSpriteFramesFromFile("game_res/fish_ignot.plist")
    cc.Director:getInstance():getTextureCache():removeTextureForKey("game_res/fish_ignot.png")
	
	cc.SpriteFrameCache:getInstance():removeSpriteFramesFromFile("game_res/fish_dead.plist")
	cc.Director:getInstance():getTextureCache():removeTextureForKey("game_res/fish_dead.png")
	
	cc.SpriteFrameCache:getInstance():removeSpriteFramesFromFile("game_res/watch.plist")
	cc.Director:getInstance():getTextureCache():removeTextureForKey("game_res/watch.png")
	
	cc.SpriteFrameCache:getInstance():removeSpriteFramesFromFile("game_res/fish_move1.plist")
	cc.Director:getInstance():getTextureCache():removeTextureForKey("game_res/fish_move1.png")
	
	cc.SpriteFrameCache:getInstance():removeSpriteFramesFromFile("game_res/fish_move2.plist")
	cc.Director:getInstance():getTextureCache():removeTextureForKey("game_res/fish_move2.png")
	
	cc.SpriteFrameCache:getInstance():removeSpriteFramesFromFile("game_res/lock_fish.plist")
	cc.Director:getInstance():getTextureCache():removeTextureForKey("game_res/lock_fish.png")

	cc.SpriteFrameCache:getInstance():removeSpriteFramesFromFile("game_res/bomb.plist")
	cc.Director:getInstance():getTextureCache():removeTextureForKey("game_res/bomb.png")
	
	cc.SpriteFrameCache:getInstance():removeSpriteFramesFromFile("game_res/bullet_guns_coins.plist")
	cc.Director:getInstance():getTextureCache():removeTextureForKey("game_res/bullet_guns_coins.png")
	
	cc.SpriteFrameCache:getInstance():removeSpriteFramesFromFile("game_res/image.plist")
	cc.Director:getInstance():getTextureCache():removeTextureForKey("game_res/image.png")

	cc.SpriteFrameCache:getInstance():removeSpriteFramesFromFile("game_res/wave.plist")
	cc.Director:getInstance():getTextureCache():removeTextureForKey("game_res/wave.png")

	cc.SpriteFrameCache:getInstance():removeSpriteFramesFromFile("game_res/pao.plist")
	cc.Director:getInstance():getTextureCache():removeTextureForKey("game_res/pao.png")

    cc.Director:getInstance():getTextureCache():removeUnusedTextures()
    cc.SpriteFrameCache:getInstance():removeUnusedSpriteFrames()
end


--[[
@function : readAnimation
@file : 资源文件
@key  : 动作 key
@num  : 幀数
@time : float time 
@formatBit 

]]
function PreLoading.readAnimation(file, key, num, time,formatBit)
	local frames = {}
   	local actionTime = time
	for i=1,num do

		local frameName
		if formatBit == 1 then
			frameName = string.format(file.."%d.png", i-1)
		elseif formatBit == 2 then
		 	frameName = string.format(file.."%2d.png", i-1)
		end
		local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame(frameName) 
		
		table.insert(frames, frame)
	end

	local  animation =cc.Animation:createWithSpriteFrames(frames,actionTime)
   	cc.AnimationCache:getInstance():addAnimation(animation, key)
end

function PreLoading.readAniByFileName( file,width,height,rownum,linenum,savename)
	local frames = {}
	for i=1,rownum do
		for j=1,linenum do
			
			local frame = cc.SpriteFrame:create(file,cc.rect(width*(j-1),height*(i-1),width,height))
			table.insert(frames, frame)
		end
		
	end
	local  animation =cc.Animation:createWithSpriteFrames(frames,0.03)
   	cc.AnimationCache:getInstance():addAnimation(animation, savename)
end

function PreLoading.removeAllActions()

	--鱼游动动画
	for i=1,Game_CMD.Fish_MOVE_TYPE_NUM do
		
		local key = string.format("animation_fish_move%d", i)
		cc.AnimationCache:getInstance():removeAnimation(key)

	end

	--鱼死亡动画
	for i=1,Game_CMD.Fish_DEAD_TYPE_NUM do
		local key = string.format("animation_fish_dead%d", i)
		cc.AnimationCache:getInstance():removeAnimation(key)
	end	


    
    cc.AnimationCache:getInstance():removeAnimation("WaterAnim")
    cc.AnimationCache:getInstance():removeAnimation("BombAnim")
    cc.AnimationCache:getInstance():removeAnimation("GoldAnim")
    cc.AnimationCache:getInstance():removeAnimation("watchAnim")
    cc.AnimationCache:getInstance():removeAnimation("waveAnim")
    cc.AnimationCache:getInstance():removeAnimation("rewardCircleAnim")
    cc.AnimationCache:getInstance():removeAnimation("pao1Anim")
    cc.AnimationCache:getInstance():removeAnimation("pao2Anim")
    cc.AnimationCache:getInstance():removeAnimation("pao3Anim")
    cc.AnimationCache:getInstance():removeAnimation("pao4Anim")
    cc.AnimationCache:getInstance():removeAnimation("pao5Anim")
    cc.AnimationCache:getInstance():removeAnimation("pao6Anim")
    --元宝鱼游戏币翻滚动画
    cc.AnimationCache:getInstance():removeAnimation("fish_ignot_coin")

    --cc.AnimationCache:getInstance():removeAnimation("FortAnim")
    --cc.AnimationCache:getInstance():removeAnimation("FortLightAnim")
    --cc.AnimationCache:getInstance():removeAnimation("SilverAnim")
    --cc.AnimationCache:getInstance():removeAnimation("CopperAnim")
    --dyj1
   -- cc.AnimationCache:getInstance():removeAnimation("BombDartsAnim")
   -- cc.AnimationCache:getInstance():removeAnimation("BlueIceAnim")
   --dyj2
    --cc.AnimationCache:getInstance():removeAnimation("BulletAnim")
    --cc.AnimationCache:getInstance():removeAnimation("LightAnim")
    --cc.AnimationCache:getInstance():removeAnimation("FishBall")
    --cc.AnimationCache:getInstance():removeAnimation("FishLight")
end

function PreLoading.readAniams()

    --25种
	local fishFrameMoveNum =
	{
		6,8,12,
    	12,12,13,
    	12,10,12,
    	8,12,6,
    	12,10,12,
    	12,12,9,
        16,20,15,
    	12,8,1,
    	12
	}
    --22 + 3种
	local fishFrameDeadNum =
	{
		2,2,2,
    	3,3,3,
    	6,3,2,
    	6,4,3,
    	3,3,3,
    	3,3,3,
        8,20,9,
        0,0,0,
    	25
	}

	--鱼游动动画
	for i=1,Game_CMD.Fish_MOVE_TYPE_NUM do
		
		local frames = {}
		local actionTime = 0.09
		if i == Game_CMD.FishType_JinLong + 1  then
			actionTime = 0.2
		end

		local num = fishFrameMoveNum[i]
    	for j=1,num do
	        local frameName =string.format("fishMove_%03d_%02d.png",i,j)  
            
	      -- print("frameName is =========================================================="..frameName)
	        local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame(frameName) 

	        table.insert(frames, frame)
    	end

    	local  animation =cc.Animation:createWithSpriteFrames(frames,actionTime)

		local key = string.format("animation_fish_move%d", i)
		cc.AnimationCache:getInstance():addAnimation(animation, key)
	end

	--鱼死亡动画
	for i=1,Game_CMD.Fish_DEAD_TYPE_NUM do
        if fishFrameDeadNum[i] ~= 0 then
		    local frames = {}
		    local actionTime = 0.05
		    local num = fishFrameDeadNum[i]
		    if 0 ~= num then
			    for j=1,num do
	        	    local frameName =string.format("fishDead_%03d_%d.png",i,j)  
	        	    local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame(frameName) 
	        	    table.insert(frames, frame)
    		    end

    		    local  animation =cc.Animation:createWithSpriteFrames(frames,actionTime)
			    local key = string.format("animation_fish_dead%d", i)
		    --print("key is =============================================="..key)
			    cc.AnimationCache:getInstance():addAnimation(animation, key)
		    end
        end
	end	
	
    PreLoading.readAnimation("water_","WaterAnim",12,0.12,1)
    PreLoading.readAnimation("gold_coin_", "GoldAnim", 12, 0.08,1);
    PreLoading.readAnimation("boom", "BombAnim", 32,0.03,2);
    PreLoading.readAnimation("watch_", "watchAnim", 24, 0.08,1);
    PreLoading.readAnimation("wave_", "waveAnim", 2, 0.4,1)
    PreLoading.readAnimation("Reward_Box_", "rewardCircleAnim", 24, 0.08,1);
    PreLoading.readAnimation("pao_1_", "pao1Anim", 5, 0.08,1);
    PreLoading.readAnimation("pao_2_", "pao2Anim", 5, 0.08,1);
    PreLoading.readAnimation("pao_3_", "pao3Anim", 5, 0.08,1);
    PreLoading.readAnimation("pao_4_", "pao4Anim", 5, 0.08,1);
    PreLoading.readAnimation("pao_5_", "pao5Anim", 5, 0.08,1);
    PreLoading.readAnimation("pao_6_", "pao6Anim", 5, 0.08,1);
    --PreLoading.readAnimation("fort_","FortAnim",6,0.02,1)
    --PreLoading.readAnimation("fort_light_", "FortLightAnim", 6, 0.02,1);
    --PreLoading.readAnimation("silver_coin_", "SilverAnim", 12, 0.05,1);
    --PreLoading.readAnimation("copper_coin_", "CopperAnim", 10, 0.05,1);
    --PreLoading.readAnimation("bullet_", "BulletAnim", 10,1);
    --PreLoading.readAnimation("light_", "LightAnim", 16, 0.05,1);
    --PreLoading.readAniByFileName("game_res/fish_bomb_ball.png", 70, 70, 2, 5, "FishBall")
    --PreLoading.readAniByFileName("game_res/fish_bomb_light.png", 40, 256, 1, 6, "FishLight")
end

return PreLoading