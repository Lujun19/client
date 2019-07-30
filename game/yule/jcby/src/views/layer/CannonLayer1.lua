--
-- Author: Tang
-- Date: 2016-08-09 10:31:00
--炮台
local CannonLayer = class("CannonLayer", cc.Layer)

local module_pre = "game.yule.jcby.src"			
local ExternalFun = require(appdf.EXTERNAL_SRC.."ExternalFun")
local cmd = module_pre..".models.CMD_LKPYGame"
local Cannon = module_pre..".views.layer.Cannon1"
local g_var = ExternalFun.req_var
local CannonSprite = require(module_pre..".views.layer.Cannon1")
local Game_CMD = appdf.req(module_pre .. ".models.CMD_LKPYGame")
local CHANGE_MULTIPLE_INTERVAL =  0.1
CannonLayer.enum = 
{

	Tag_userNick =1, 	

	Tag_userScore=2,

	Tag_userIngot=3,

	Tag_GameScore = 10,
	Tag_Buttom = 70 ,
	Tag_Lable = 100,
	Tag_Cannon = 200,

}

local TAG =  CannonLayer.enum
function CannonLayer:ctor(viewParent)
	
	self.parent = viewParent
	self._dataModel = self.parent._dataModel

	self._gameFrame  = self.parent._gameFrame
	
	--自己信息
	self.m_pUserItem = self._gameFrame:GetMeUserItem()
    self.m_nTableID  = self.m_pUserItem.wTableID
    self.m_nChairID  = self.m_pUserItem.wChairID
    self.m_dwUserID  = self.m_pUserItem.dwUserID

    self.m_cannonList = {} --炮台列表

    self._userList    = {}

    self.rootNode = nil
    self.m_bulletSpeed = 0.5

    self.m_userScore = 0	--用户分数 
    self.m_myCannon = nil
--炮台位置
    self.m_pCannonPos = 
    {
    	cc.p(382,710),
	    --cc.p(667,710),
	    cc.p(897,710),
	    cc.p(382,110),
	    --cc.p(667,110),
	    cc.p(897,110),
	    --cc.p(54,369),
	    --cc.p(1280,369)
	}

--gun位置
	self.m_GunPlatformPos =
	{
		cc.p(382,700),
		--cc.p(667,700),
		cc.p(897,700),
		cc.p(382,55),
		--cc.p(667,55),
		cc.p(897,55),
		--cc.p(45,369),
		--cc.p(1290,369)
	}

	self.m_LablePos =
	{
		cc.p(382,738),
		--cc.p(667,738),
		cc.p(897,738),
		cc.p(382,11),
		--cc.p(667,11),
		cc.p(897,11),
		--cc.p(14,369),
		--cc.p(1320,369)
	}
--用户信息背景
	self.m_NickPos = cc.p(115,86)
	self.m_ScorePos = cc.p(115,54)
	self.m_IngotPos = cc.p(115,25)

	self.myPos = 0			--视图位置
    self.SecondTime = 0

	self:init()

    self.m_bullet_limit_count = 20
    self.m_bullet_cur_count = 0

	 --注册事件
    ExternalFun.registerTouchEvent(self,false)
end

function CannonLayer:init()
	
	--加载csb资源
	local csbNode = ExternalFun.loadCSB("game_res/Cannon.csb", self)
    self.rootNode = csbNode

	for i=1,4 do
		local btnSub = self.rootNode:getChildByName(string.format("Button_Sub_%d", i))
		btnSub:setVisible(false)
		local btnAdd = self.rootNode:getChildByName(string.format("Button_Add_%d", i))
		btnAdd:setVisible(false)
	end

	--初始化自己炮台
	local myCannon = g_var(Cannon):create(self)

	myCannon:initWithUser(self.m_pUserItem)
	myCannon:setPosition(self.m_pCannonPos[myCannon.m_pos + 1])
	self:removeChildByTag(TAG.Tag_Cannon + myCannon.m_pos + 1)
	myCannon:setTag(TAG.Tag_Cannon + myCannon.m_pos + 1)
	self.mypos = myCannon.m_pos + 1
	self:initCannon()
	self:addChild(myCannon, -1)

	--位置提示
	local tipsImage = ccui.ImageView:create("game_res/pos_tips.png")
	tipsImage:setAnchorPoint(cc.p(0.5,0.0))
	tipsImage:setPosition(cc.p(myCannon:getPositionX(),150))
	self:addChild(tipsImage)

	local arrow = ccui.ImageView:create("game_res/pos_arrow.png")
	arrow:setAnchorPoint(cc.p(0.5,0.5))
	arrow:setPosition(cc.p(tipsImage:getContentSize().width/2,-10))
	tipsImage:addChild(arrow)
	local caonnonX = myCannon:getPositionX()

	local jumpUpX = caonnonX
	local jumpUpY = 210

	local jumpDownX = caonnonX
	local jumpDownY = 180
	
	if 6 == self.m_nChairID then
		jumpUpX = 230
		jumpUpY = 371

		jumpDownX = 200
		jumpDownY = 371
		arrow:setPosition(cc.p(-30,tipsImage:getContentSize().height/2))
		arrow:setRotation(90)
	elseif 7 == self.m_nChairID then
		jumpUpX = 1104
		jumpUpY = 371

		jumpDownX = 1134
		jumpDownY = 371
		arrow:setPosition(cc.p(170,tipsImage:getContentSize().height/2))
		arrow:setRotation(270)
	end
	--print(string.format("jumpUpX %d jumpUpY %d jumpDownX %d jumpDownY %d", jumpUpX,jumpUpY,jumpDownX,jumpDownY))
	--跳跃动画
	local jumpUP = cc.MoveTo:create(0.4,cc.p(jumpUpX,jumpUpY))
	local jumpDown =  cc.MoveTo:create(0.4,cc.p(jumpDownX,jumpDownY))
	tipsImage:runAction(cc.Repeat:create(cc.Sequence:create(jumpUP,jumpDown), 20))

	tipsImage:runAction(cc.Sequence:create(cc.DelayTime:create(9),cc.CallFunc:create(function (  )
		tipsImage:removeFromParent(true)
	end)))

    
    CannonSprite:setCurrentBulletScore(self.parent.bMinConnonMultiple)

	local pos = self.m_nChairID
	pos = CannonSprite.getPos(self._dataModel.m_reversal,pos)
	self:showCannonByChair(pos+1)
	self:initUserInfo(pos+1,self.m_pUserItem)
	
	local cannonInfo ={d=self.m_dwUserID,c=pos+1, cid = self.m_nChairID}
	table.insert(self.m_cannonList,cannonInfo)

	local tMultipleValue = 0.1 
	self:updateMultiple(tMultipleValue, pos + 1)

    --control button
    local btnControl = self.rootNode:getChildByName("Btn_Control")
	btnControl:setVisible(true)

    btnControl:addTouchEventListener(function( sender , eventType )
            if self.parent._gameView.m_bIsGameCheatUser then
                self.parent._gameView.m_controlLayer:setVisible(true)
            end
        end)
end	

function CannonLayer:showPos()
	--位置提示
	local tipsImage = ccui.ImageView:create("game_res/pos_tips.png")
	tipsImage:setAnchorPoint(cc.p(0.5,0.0))
	tipsImage:setPosition(cc.p(self.m_myCannon:getPositionX(),150))
	self:addChild(tipsImage)

	local arrow = ccui.ImageView:create("game_res/pos_arrow.png")
	arrow:setAnchorPoint(cc.p(0.5,1.0))
	arrow:setPosition(cc.p(tipsImage:getContentSize().width/2,3))
	tipsImage:addChild(arrow)

	local jumpUpX = self.m_myCannon:getPositionX()
	local jumpUpY = 210

	local jumpDownX = self.m_myCannon:getPositionX()
	local jumpDownY = 180
	--print(string.format("jumpUpX %d jumpUpY %d jumpDownX %d jumpDownY %d", jumpUpX,jumpUpY,jumpDownX,jumpDownY))
	if 6 == self.m_nChairID then
		jumpUpX = 210
		jumpUpX = self.m_myCannon:getPositionY()

		jumpDownX = 180
		jumpDownY = self.m_myCannon:getPositionY()
	end
	--跳跃动画
	local jumpUP = cc.MoveTo:create(0.4,cc.p(jumpUpX,jumpUpY))
	local jumpDown =  cc.MoveTo:create(0.4,cc.p(jumpDownX,jumpDownY))
	tipsImage:runAction(cc.Repeat:create(cc.Sequence:create(jumpUP,jumpDown), 20))

	tipsImage:runAction(cc.Sequence:create(cc.DelayTime:create(5),cc.CallFunc:create(function (  )
		tipsImage:removeFromParent(true)
	end)))
end


function CannonLayer:initCannon()

	local mypos = self.m_nChairID

	mypos = CannonSprite.getPos(self._dataModel.m_reversal,mypos)

	for i=1,4 do
		if i~= mypos+1 then
			self:HiddenCannonByChair(i)
		end
	end
end


function CannonLayer:initUserInfo(viewpos,userItem)

	local infoBG = self.rootNode:getChildByName(string.format("im_info_bg_%d", viewpos))

	if infoBG == nil then
		return
	end
	print("---------------initUserInfo---------------------------",userItem.wChairID, userItem.lScore, userItem.lIngot)
	local nick =  cc.Label:createWithTTF(userItem.dwGameID, "base/fonts/round_body.ttf", 18)
    local scoreIcon = cc.Sprite:create("game_res/19.png")
    local ingotIcon = cc.Sprite:create("game_res/20.png")
	local scoreNum = cc.Label:createWithCharMap("game_res/scoreNum.png",13,18,string.byte("."))
	local ingotNum = cc.Label:createWithCharMap("game_res/scoreNum.png",13,18,string.byte("."))
	--用户昵称
	local nickPosX = self.m_NickPos.x
	local nickPosY = self.m_NickPos.y

	local scoreX = self.m_ScorePos.x
	local scoreY = self.m_ScorePos.y

	local ingotX = self.m_IngotPos.x
	local ingotY = self.m_IngotPos.y

    local scoreIconX = scoreX
    local ingotIconX = ingotX

	--if userItem.wChairID >= 6 then
		--nickPosX = self.m_NickPos.x
		--nickPosY = self.m_IngotPos.y
		--scoreX = self.m_ScorePos.x
		--scoreY = self.m_ScorePos.y
		--ingotX = self.m_IngotPos.x
	 	--ingotY = self.m_NickPos.y
        --scoreIconX = scoreX + 72
        --ingotIconX = ingotX + 42
		--nick:setRotation(180)
		--scoreNum:setRotation(180)
		--ingotNum:setRotation(180)
        --scoreIcon:setRotation(180)
		--ingotIcon:setRotation(180)

        --ingotX = self.m_IngotPos.x - 13
	--end

	if viewpos < 3  then
		--nick:setRotation(180)
		--scoreNum:setRotation(180)
		--ingotNum:setRotation(180)
        --scoreIcon:setRotation(180)
		--ingotIcon:setRotation(180)

		nickPosX = self.m_NickPos.x - 40 
		scoreX = self.m_ScorePos.x - 40
		ingotX = self.m_IngotPos.x - 40

        scoreIconX = scoreX + 72
        ingotIconX = ingotX + 42

        ingotX = self.m_IngotPos.x - 53
	end

    if viewpos >=3 then
        scoreIconX = scoreX - 72
        ingotIconX = ingotX - 42

        ingotX = ingotX + 13
    end

	nick:setTextColor(cc.WHITE)
	nick:setAnchorPoint(0.5,0.5)
	nick:setTag(TAG.Tag_userNick)
	nick:setPosition(nickPosX, nickPosY)
	infoBG:removeChildByTag(TAG.Tag_userNick)
	infoBG:addChild(nick)

	--用户分数
	scoreNum:setString(0)
	ingotNum:setString(userItem.lIngot*0.01)

    --dyj1
    if self._dataModel.m_secene.fish_score ~= nil then
       scoreNum:setString(string.format("%d", self._dataModel.m_secene.fish_score[1][userItem.wChairID+1]))        
    end
    
	scoreNum:setAnchorPoint(0.5,0.5)
	scoreNum:setTag(TAG.Tag_userScore)
	scoreNum:setPosition(scoreX, scoreY)
	infoBG:removeChildByTag(TAG.Tag_userScore)
	infoBG:addChild(scoreNum)

	ingotNum:setAnchorPoint(0.5,0.5)
	ingotNum:setTag(TAG.Tag_userIngot)
	ingotNum:setPosition(ingotX, ingotY)
	infoBG:removeChildByTag(TAG.Tag_userIngot)
	infoBG:addChild(ingotNum)

    
    scoreIcon:setPosition(scoreIconX, scoreY)
    infoBG:addChild(scoreIcon)
	
    ingotIcon:setPosition(ingotIconX, ingotY)
    infoBG:addChild(ingotIcon)
end

function CannonLayer:updateMultiple( mutiple,cannonPos )
	local gunPlatformButtom = self:getChildByTag(TAG.Tag_Buttom+cannonPos)
	local labelMutiple = self:getChildByTag(TAG.Tag_Lable+cannonPos)
	if nil ~= labelMutiple then
		labelMutiple:setString(string.format("%.2f", mutiple))
	end
	
end

--dyj1(FC++)
function CannonLayer:updateUpScore( score,cannonpos )
	local infoBG = self.rootNode:getChildByName(string.format("im_info_bg_%d", cannonpos))
	if infoBG == nil then
		return
	end
	local scoreLB = infoBG:getChildByTag(TAG.Tag_userScore)
	if score >= 0 and nil ~= scoreLB then
		scoreLB:setString(string.format("%.2f", score))
	end
end

--dyj2
function CannonLayer:updateUserScore( score,cannonpos )
	
	local infoBG = self.rootNode:getChildByName(string.format("im_info_bg_%d", cannonpos))
	if infoBG == nil then
		return
	end
	local mypos = self.m_nChairID

	mypos = CannonSprite.getPos(self._dataModel.m_reversal,mypos)

	if mypos == cannonpos - 1 then
		self.parent._gameView:updateUserScore(score)
	end
end


function CannonLayer:HiddenCannonByChair( chair )
	--print("隐藏隐藏.........."..chair)

    local cannonPos = CannonSprite.getPos(self._dataModel.m_reversal, chair - 1)
    local cannon = self:getCannoByPos(cannonPos + 1)

    if cannon ~= nil then
        for i = #cannon.m_goldList, 1, -1 do
            cannon.m_goldList[i]:removeFromParent()
            table.remove(cannon.m_goldList, i)
        end
    end

	local infoBG = self.rootNode:getChildByName(string.format("im_info_bg_%d", chair))
	infoBG:setVisible(false)

	local gunPlatformCenter = self.rootNode:getChildByName(string.format("gunPlatformCenter_%d", chair))
	gunPlatformCenter:setVisible(false)
    gunPlatformCenter:removeChildByTag(100)
	self:removeChildByTag(TAG.Tag_Buttom + chair)

    self:removeChildByTag(TAG.Tag_Lable+chair)
end

function CannonLayer:showCannonByChair( chair , wChairID)
	local infoBG = self.rootNode:getChildByName(string.format("im_info_bg_%d", chair))
	if infoBG == nil then
		return
	end

	infoBG:setVisible(true) --玩家信息

	local gunPlatformCenter = self.rootNode:getChildByName(string.format("gunPlatformCenter_%d", chair))
	gunPlatformCenter:setVisible(true)
    --dyj1
    if chair == CannonSprite.getPos(self._dataModel.m_reversal,self.m_nChairID)+1 then
       
        local btnSub = self.rootNode:getChildByName(string.format("Button_Sub_%d", chair))
		btnSub:setVisible(true)
		local btnAdd = self.rootNode:getChildByName(string.format("Button_Add_%d", chair))
		btnAdd:setVisible(true)

        btnAdd:addTouchEventListener(function( sender , eventType )
                local currTime = currentTime()
                local aaa  = currTime - self.SecondTime
                if eventType == ccui.TouchEventType.ended and aaa > 50 then
                    if not self.parent._gameView.m_bCanChangeMultple then
                        return 
                    end
                    local cannonPos = self.m_nChairID
                    cannonPos = CannonSprite.getPos(self._dataModel.m_reversal,cannonPos)
                    local cannon = self.parent.m_cannonLayer:getCannoByPos(cannonPos + 1)
                    self._dataModel:playEffect(Game_CMD.SWITCHING_RUN)
                    local curMultiple = self.parent.CurrShoot[1][self.m_nChairID+1]
                    curMultiple  = curMultiple + self._dataModel.m_secene.MinShoot
                    if curMultiple > self._dataModel.m_secene.MaxShoot then
                        curMultiple = self._dataModel.m_secene.MinShoot
                    end
 
                    self.parent._gameView.m_bCanChangeMultple = false

                    self.parent._gameView:changeMultipleSchedule(CHANGE_MULTIPLE_INTERVAL)
                    self.parent.CurrShoot[1][self.m_nChairID+1] = curMultiple

                    cannon:setMultiple(self.parent.CurrShoot[1][self.m_nChairID+1])
                    local tMultipleValue = self.parent.CurrShoot[1][self.m_nChairID+1]
                    local  labelMutiple = self:getChildByTag(TAG.Tag_Lable+chair)
                    if labelMutiple then
					    labelMutiple:setString(string.format("%.2f",tMultipleValue))
                    end
                end
        end)

        btnSub:addTouchEventListener(function( sender , eventType )
                local currTime = currentTime()
                local aaa  = currTime - self.SecondTime
                if eventType == ccui.TouchEventType.ended and aaa > 50 then
                    if not self.parent._gameView.m_bCanChangeMultple then
                        return 
                    end
                    local cannonPos = self.m_nChairID
                    cannonPos = CannonSprite.getPos(self._dataModel.m_reversal,cannonPos)
                    local cannon = self.parent.m_cannonLayer:getCannoByPos(cannonPos + 1)
                    self._dataModel:playEffect(Game_CMD.SWITCHING_RUN)
                    local curMultiple = self.parent.CurrShoot[1][self.m_nChairID+1]
                    curMultiple  = curMultiple - self._dataModel.m_secene.MinShoot
                    if curMultiple < self._dataModel.m_secene.MinShoot then
                        curMultiple = self._dataModel.m_secene.MaxShoot
                    end
                    
                    self.parent._gameView.m_bCanChangeMultple = false
                    self.parent._gameView:changeMultipleSchedule(CHANGE_MULTIPLE_INTERVAL)
                    self.parent.CurrShoot[1][self.m_nChairID+1] = curMultiple

                    cannon:setMultiple(self.parent.CurrShoot[1][self.m_nChairID+1])
					local tMultipleValue = self.parent.CurrShoot[1][self.m_nChairID+1]
                    local  labelMutiple = self:getChildByTag(TAG.Tag_Lable+chair)
                    if labelMutiple then
					    labelMutiple:setString(string.format("%.2f",tMultipleValue))
                    end
                end
        end)
       
    end
    
	local gunPlatformButtom = cc.Sprite:create("game_res/gunPlatformButtom.png")
	gunPlatformButtom:setPosition(self.m_GunPlatformPos[chair].x, self.m_GunPlatformPos[chair].y)
	gunPlatformButtom:setTag(TAG.Tag_Buttom+chair)
	self:removeChildByTag(TAG.Tag_Buttom+chair)
	self:addChild(gunPlatformButtom,-10)

	--倍数
	local labelMutiple = cc.LabelAtlas:_create(tostring(self._dataModel.m_secene.MinShoot),"game_res/mutipleNum.png",12,16,string.byte("."))
	labelMutiple:setTag(TAG.Tag_Lable+chair)
	labelMutiple:setAnchorPoint(0.5,0.5)
	labelMutiple:setPosition(self.m_LablePos[chair].x, self.m_LablePos[chair].y)
	if nil ~= wChairID and self.parent.CurrShoot~=nil then
		local tMultipleValue = self.parent.CurrShoot[1][wChairID+1]
		labelMutiple:setString(string.format("%.2f",tMultipleValue))
	end
	self:removeChildByTag(TAG.Tag_Lable+chair)
	self:addChild(labelMutiple,1000)
	--print("chair id",chair)
    if chair <=2 then
        labelMutiple:setRotation(180)
	--elseif chair == 8 then
	--	labelMutiple:setRotation(270)
	end
	self.labelMutiple = labelMutiple
end

function CannonLayer:disableAddSub(isShow)
    local cannonPos = self.m_nChairID
    cannonPos = CannonSprite.getPos(self._dataModel.m_reversal,cannonPos)+1
    local btnSub = self.rootNode:getChildByName(string.format("Button_Sub_%d", cannonPos))
	btnSub:setVisible(isShow)
	local btnAdd = self.rootNode:getChildByName(string.format("Button_Add_%d", cannonPos))
	btnAdd:setVisible(isShow)
end

function CannonLayer:getCannon(pos)
	
	local cannon = self:getChildByTag(pos + TAG.Tag_Cannon)
	return cannon 

end


function CannonLayer:getCannoByPos( pos )

	local cannon = self:getChildByTag(TAG.Tag_Cannon + pos)
	return  cannon

end


function CannonLayer:getUserIDByCannon(viewid)

	local userid = 0
	if #self.m_cannonList > 0 then
		for i=1,#self.m_cannonList do
			local cannonInfo = self.m_cannonList[i]
			if cannonInfo.c == viewid then
				userid = cannonInfo.d
				break
			end
		end
 	end
	
	 return userid
end

function CannonLayer:onEnter( )
	
end


function CannonLayer:onEnterTransitionFinish(  )

  
end

function CannonLayer:onExit( )

	self.m_cannonList = nil
end

function CannonLayer:onTouchBegan(touch, event)

	if self._dataModel._exchangeSceneing  then 	--切换场景中不能发炮
		return false
	end

	local cannon = self:getCannon(self.mypos)

	if nil ~= cannon then
		local pos = touch:getLocation()

		cannon:shoot(pos, true)

		self.parent:setSecondCount(60)
		
	end

	return true
end

function CannonLayer:onTouchMoved(touch, event)
	
	local cannon = self:getCannon(self.mypos)

	if nil ~= cannon then
		local pos = touch:getLocation()

		cannon:shoot(cc.p(pos.x,pos.y), true)
		self.parent:setSecondCount(60)

	end
end

function CannonLayer:onTouchEnded(touch, event )
	
	local cannon = self:getCannon(self.mypos)

	if nil ~= cannon then
		local pos = touch:getLocation()

		cannon:shoot(cc.p(pos.x,pos.y), false)
		self.parent:setSecondCount(60)
	end
end

--用户进入
function CannonLayer:onEventUserEnter( wTableID,wChairID,useritem )
    --print("add user " .. useritem.wChairID .. "; nick " .. useritem.szNickName)

    if wTableID ~= self.m_nTableID or wChairID == self.m_nChairID then
    	return
    end

    local pos = wChairID
    pos = CannonSprite.getPos(self._dataModel.m_reversal,pos)
    --print(string.format("-----------------------------onEventUserEnter wChairID %d pos %d score %d---------------------", wChairID,pos,useritem.lScore))
    if pos + 1 == self.m_pos then  --过滤自己
 		return
 	end


    self:showCannonByChair(pos + 1,wChairID)

 	self:removeChildByTag(TAG.Tag_Cannon + pos + 1)

 	if #self.m_cannonList > 0 then
 		for i=1,#self.m_cannonList do
 			local cannonInfo = self.m_cannonList[i]
 			if cannonInfo.d == useritem.dwUserID then
 				table.remove(self.m_cannonList,i)
 				break
 			end
 		end
 	end


 	if #self._userList > 0 then
 		for i=1,#self._userList do
 			local Item = self._userList[i]
 			if Item.dwUserID == useritem.dwUserID then
 				table.remove(self._userList,i)
 				break
 			end
 		end
 	end

    local Cannon = g_var(Cannon):create(self)
	Cannon:initWithUser(useritem)
	Cannon:setPosition(self.m_pCannonPos[Cannon.m_pos + 1])
	Cannon:setTag(TAG.Tag_Cannon + Cannon.m_pos + 1)
	self:addChild(Cannon, -1)
	self:initUserInfo(pos + 1,useritem)

	local cannonInfo ={d=useritem.dwUserID,c=pos+1,cid = useritem.wChairID}
	table.insert(self.m_cannonList,cannonInfo)

	table.insert(self._userList, useritem)
end

--用户状态
function CannonLayer:onEventUserStatus(useritem,newstatus,oldstatus)

        if oldstatus.cbUserStatus == yl.US_FREE then
  		    if newstatus.wTableID ~= self.m_nTableID  then
  			    --print("不是本桌用户....")
  			    return
		    end
        end
        if newstatus.cbUserStatus == yl.US_FREE or  newstatus.cbUserStatus == yl.US_NULL then
                
        		if useritem.wChairID ==  self.m_nChairID then
        			self.parent.m_bLeaveGame = true
        			PRELOAD.setEnded(true)
        		end

          	    if #self.m_cannonList > 0 then
          	    	for i=1,#self.m_cannonList do

	          	    	local cannonInfo = self.m_cannonList[i]
	          	    	if cannonInfo.d == useritem.dwUserID then
	          	    		--print("用户离开"..cannonInfo.c)
	          	    		self:HiddenCannonByChair(cannonInfo.c)
                            self.parent._dataModel.m_secene.fish_score[1][cannonInfo.cid + 1] = 0
	          	    		table.remove(self.m_cannonList,i)

		          	    	if #self._userList > 0 then
						 		for i=1,#self._userList do
						 			local Item = self._userList[i]
						 			if Item.dwUserID == useritem.dwUserID then
						 				table.remove(self._userList,i)
						 				break
						 			end
						 		end
						 	end


	          	    	    local cannon = self:getChildByTag(TAG.Tag_Cannon + cannonInfo.c)
				          	if nil ~= cannon then
				          		--print("用户离开 nil ~= cannon")
				          		cannon:removeChildByTag(1000)
					          	cannon:removeTypeTag()
				          	    cannon:removeLockTag()
				          	    cannon:removeFromParent(true)
				          	end

	          	    	 
	          	    		break
	          	    	end
          	   		 end
          	    end 
        else
        	self._gameFrame:QueryUserInfo( self.m_nTableID,useritem.wChairID)
        end

end

return CannonLayer