
local GameViewLayer = {}
--GameViewLayer.RES_PATH 				= device.writablePath.."game/yule/shuihuzhuan/res/"
GameViewLayer.RES_PATH              = "game/xiuxian/shuiguolaba/res/"
GameViewLayer.RES_GAME2             ="game/xiuxian/shuiguolaba/res/game2/"
--	游戏一
local Game1ViewLayer = class("Game1ViewLayer",function(scene)
		local gameViewLayer =  display.newLayer()
    return gameViewLayer
end)
GameViewLayer[1] = Game1ViewLayer

--	游戏二  翻牌
local Game2ViewLayer = class("Game2ViewLayer",function(scene)
		local gameViewLayer =  display.newLayer()
    return gameViewLayer
end)
GameViewLayer[2] = Game2ViewLayer

local module_pre = "game.xiuxian.shuiguolaba.src"
local ExternalFun = require(appdf.EXTERNAL_SRC .. "ExternalFun")
local HeadSprite = require(appdf.EXTERNAL_SRC .. "HeadSprite")
local g_var = ExternalFun.req_var
local ClipText = appdf.EXTERNAL_SRC .. "ClipText"

local cmd = module_pre .. ".models.CMD_Game"

local QueryDialog   = require("client.src.app.views.layer.other.QueryDialog")

local GameItem = appdf.req(module_pre .. ".views.layer.GameItem")

local PRELOAD = require(module_pre..".views.layer.PreLoading") 

local SettingLayer = appdf.req(module_pre .. ".views.layer.SettingLayer")
local HelpLayer = appdf.req(module_pre .. ".views.layer.HelpLayer")


if device.platform ~= "windows" then
    GameViewLayer.RES_PATH  = device.writablePath.. "game/xiuxian/shuiguolaba/res/"
end


local enGameLayer = 
{
	"TAG_SETTING_MENU",			--设置
	"TAG_QUIT_MENU",			--退出
    "TAG_RECORD_MENU",          --中奖记录
    "TAG_REFRESH_MENU",         --刷新游戏
	"TAG_START_MENU",			--开始按钮
	"TAG_HELP_MENU",			--游戏帮助
    "TAG_RECORD_MENU",			--中奖打开
	"TAG_MAXADD_BTN",			--最大下注
	"TAG_MINADD_BTN",			--最小下注
    "TAG_MAXADDX_BTN",			--最大y压线
    "TAG_ADD1_BTN",			    --增加压线
	"TAG_SUB1_BTN",			    --减少压线
	"TAG_ADD_BTN",				--加注
	"TAG_SUB_BTN",				--减注
	"TAG_AUTO_START_BTN",		--自动游戏
	"TAG_GAME2_BTN",			--开始游戏2
	"TAG_HIDEUP_BTN",			--隐藏上部菜单
	"TAG_SHOWUP_BTN",			--显示上部菜单
    "TAG_RECORD_END",           --中奖记录关闭
    "TAG_HEAD",                 --头像
    "TAG_AWARDS",               --超级倍数的弹框
}
local TAG_ENUM = ExternalFun.declarEnumWithTable(GameViewLayer.TAG_START, enGameLayer);



function Game1ViewLayer:ctor(scene)
	--注册node事件
	ExternalFun.registerNodeEvent(self,true)
	self._scene = scene
    --添加路径
    self:addPath()

    --预加载资源
	PRELOAD.loadTextures()

	-- --初始化csb界面
	 self:initCsbRes();

     --初始化全局变量
      self.m_bStart = true     --开始开关按钮

    --播放背景音乐
    ExternalFun.playBackgroudAudio("beijingyinyue.mp3")

end



function Game1ViewLayer:onExit()

    PRELOAD.unloadTextures()
    PRELOAD.removeAllActions()

    PRELOAD.resetData()

    self:StopLoading(true)

    --播放大厅背景音乐
    ExternalFun.playPlazzBackgroudAudio()

    --重置搜索路径
    local oldPaths = cc.FileUtils:getInstance():getSearchPaths();
    -- print("@@@@@@@@@@@@游戏中搜索路径@@@@@@@@@@@@@@")
    -- dump(oldPaths)

    cc.FileUtils:getInstance():setSearchPaths(self._searchPath);
    local searchpath = cc.FileUtils:getInstance():getSearchPaths()
    -- print("@@@@@@@@@@@@退出搜索路径@@@@@@@@@@@@@@")
    -- dump(searchpath)
    if self.schedulerID ~= nil then 
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedulerID)
        self.schedulerID = nil
    end

end

function Game1ViewLayer:StopLoading( bRemove )
    PRELOAD.StopAnim(bRemove)
end

function Game1ViewLayer:addPath( )
    --搜索路径
    if device.platform == "ios" then
        cc.FileUtils:getInstance():addSearchPath("game/xiuxian/shuiguolaba/res/")
    end

    if device.platform == "android" then
        cc.FileUtils:getInstance():addSearchPath("game/xiuxian/shuiguolaba/res/")
        cc.SpriteFrameCache:getInstance():addSpriteFrames(GameViewLayer.RES_PATH.."game1/game/game.plist")
        cc.SpriteFrameCache:getInstance():addSpriteFrames(GameViewLayer.RES_PATH.."game1/game/record.plist")
        cc.SpriteFrameCache:getInstance():addSpriteFrames(GameViewLayer.RES_PATH.."game2/game2.plist")
        cc.SpriteFrameCache:getInstance():addSpriteFrames(GameViewLayer.RES_PATH.."game2/game2.plist")
    end

    if device.platform == "windows" then
       -- cc.FileUtils:getInstance():addSearchPath("game/yule/shuiguolaba/res/")
    end

    self._searchPath = cc.FileUtils:getInstance():getSearchPaths()
 --  声音
    cc.FileUtils:getInstance():addSearchPath(GameViewLayer.RES_PATH)
	cc.FileUtils:getInstance():addSearchPath(GameViewLayer.RES_PATH .. "game1/");
	cc.FileUtils:getInstance():addSearchPath(GameViewLayer.RES_PATH .. "game2/");

    cc.FileUtils:getInstance():addSearchPath(device.writablePath.. "game/xiuxian/shuiguolaba/res/common/");


	cc.FileUtils:getInstance():addSearchPath(GameViewLayer.RES_PATH .. "common/");
	cc.FileUtils:getInstance():addSearchPath(GameViewLayer.RES_PATH .. "setting/");
    cc.FileUtils:getInstance():addSearchPath(GameViewLayer.RES_PATH .. "sound_res/"); --  声音
end

---------------------------------------------------------------------------------------
--界面初始化
function Game1ViewLayer:initCsbRes(  )
	local rootLayer, csbNode = ExternalFun.loadRootCSB(GameViewLayer.RES_PATH .."game1/GameLayer.csb", self);
    self._csbNode = csbNode
    self.rootLayer = rootLayer
	--初始化按钮
	self:initUI(self._csbNode)

end

--初始化按钮
function Game1ViewLayer:initUI( csbNode )
	--按钮回调方法
    local function btnEvent( sender, eventType )
        if eventType == ccui.TouchEventType.began then
            ExternalFun.popupTouchFilter(1, false)
           self:StartButtonClickedEvent(sender:getTag(), sender)
        elseif eventType == ccui.TouchEventType.canceled then
            ExternalFun.dismissTouchFilter()
        elseif eventType == ccui.TouchEventType.ended then
            ExternalFun.dismissTouchFilter()

            self:onButtonClickedEvent(sender:getTag(), sender)
        end
    end

    self.Button_info = csbNode:getChildByName("info")
--	--最小押注 ----等于重置  --要增加压线变成一
	local Button_Min = self.Button_info:getChildByName("Button_Min");
	Button_Min:setTag(TAG_ENUM.TAG_MINADD_BTN);
	Button_Min:addTouchEventListener(btnEvent);
    Button_Min:setPressedActionEnabled(true)
	--最大押注
	local Button_Max = self.Button_info:getChildByName("Button_Max");
	Button_Max:setTag(TAG_ENUM.TAG_MAXADD_BTN);
	Button_Max:addTouchEventListener(btnEvent);
    Button_Max:setPressedActionEnabled(true)
    --最大押线 --全线
	local Button_Lin = self.Button_info:getChildByName("Button_Quanxian");
	Button_Lin:setTag(TAG_ENUM.TAG_MAXADDX_BTN);
	Button_Lin:addTouchEventListener(btnEvent);
    Button_Lin:setPressedActionEnabled(true)
	--减少 单注
	local Button_Sub = self.Button_info:getChildByName("Button_Sub");
	Button_Sub:setTag(TAG_ENUM.TAG_SUB_BTN);
	Button_Sub:addTouchEventListener(btnEvent);
	--增加 单注
	local Button_Add = self.Button_info:getChildByName("Button_Add");
	Button_Add:setTag(TAG_ENUM.TAG_ADD_BTN);
	Button_Add:addTouchEventListener(btnEvent);
    --减少 压线
	local Button_Sub1 = self.Button_info:getChildByName("Button_Sub1");
	Button_Sub1:setTag(TAG_ENUM.TAG_SUB1_BTN);
	Button_Sub1:addTouchEventListener(btnEvent);
	--增加 压线
	local Button_Add1 = self.Button_info:getChildByName("Button_Add1");
	Button_Add1:setTag(TAG_ENUM.TAG_ADD1_BTN);
	Button_Add1:addTouchEventListener(btnEvent);

	--自动开始
	local Button_Auto = self.Button_info:getChildByName("Button_Auto");
	Button_Auto:setTag(TAG_ENUM.TAG_AUTO_START_BTN);
	Button_Auto:addTouchEventListener(btnEvent);
	--开始
	local Button_Start = csbNode:getChildByName("Button_Start");
	self.Button_Start = Button_Start
	Button_Start:setTag(TAG_ENUM.TAG_START_MENU);
	Button_Start:addTouchEventListener(btnEvent);

	local Button_tuns = csbNode:getChildByName("Button_tuns");
    Button_tuns:setTag(103);
	Button_tuns:addTouchEventListener(btnEvent);

    --停止自动按钮
	local Button_Stop = csbNode:getChildByName("Button_Stop");
	self.Button_Stop = Button_Stop
	Button_Stop:setTag(102);
	Button_Stop:addTouchEventListener(btnEvent);

	--游戏币
	self.m_textScore = self.Button_info:getChildByName("Text_score");
	local score = math.floor(self._scene:GetMeUserItem().lScore)
	self.m_textScore:setString(score)     --self._scene:GetMeUserItem().lScore

	--压线
	self.m_textYaxian = self.Button_info:getChildByName("Text_yaxian");
	--压分
	self.m_textYafen = self.Button_info:getChildByName("Text_yafen");
    --总压分
	self.m_textAllyafen = self.Button_info:getChildByName("Text_allyafen");



    ---------------------奖池和游戏-------------------------------
    self.interface = csbNode:getChildByName("interface");

    self.Panel_games = self.interface:getChildByName("Panel_games")
    --奖池 奖金
    self.m_bonus = self.interface:getChildByName("Text_bonus")
    self.m_bonus :setString(0)

--	--得到分数
	self.m_textGetScore =  self.interface:getChildByName("Text_getscore");
	self.m_textGetScore:setString(0)

	------------------大厅按钮-------------------------------
	--菜单  
	self.m_nodeMenu = csbNode:getChildByName("btn_layout");
	self.m_imgMenu = self.m_nodeMenu:getChildByName("Image_Menu");
	--菜单按钮
	local Button_Menu = self.m_nodeMenu:getChildByName("Button_Menu");
	self.Button_Menu = Button_Menu
	Button_Menu:setTag(100);
	Button_Menu:addTouchEventListener(btnEvent);
	--菜单返回
	local Button_Menuback = self.m_imgMenu:getChildByName("Button_Menuback");
	Button_Menuback:setTag(101);
	Button_Menuback:addTouchEventListener(btnEvent);
	--返回
	local Button_back = self.m_imgMenu:getChildByName("Button_back");
	Button_back:setTag(TAG_ENUM.TAG_QUIT_MENU);
	Button_back:addTouchEventListener(btnEvent);
    --帮助
	local Button_Help = self.m_nodeMenu:getChildByName("Button_Help");
	Button_Help:setTag(TAG_ENUM.TAG_HELP_MENU);
	Button_Help:addTouchEventListener(btnEvent);
    --设置
	local Button_Set = self.m_imgMenu:getChildByName("Button_Set");
	Button_Set:setTag(TAG_ENUM.TAG_SETTING_MENU);
	Button_Set:addTouchEventListener(btnEvent);
    --中奖记录  --新加
	local Button_Record = self.m_nodeMenu:getChildByName("Button_Record");
	Button_Record:setTag(TAG_ENUM.TAG_RECORD_MENU);
	Button_Record:addTouchEventListener(btnEvent);
    Button_Record:setVisible(false)

    --布告 提示文字
    self._notifyText = self._csbNode:getChildByName("Text_notice")

    self.m_tabInfoTips = {}
	self._tipIndex = 1
	self.m_nNotifyId = 0
    	-- 系统公告列表
	self.m_tabSystemNotice = {}
	self._sysIndex = 1
	-- 公告是否运行
	self.m_bNotifyRunning = false

    ---------------------------------玩家头像-------------------------------
    self.useplayer = csbNode:getChildByName("Users_Game")
    self.nodePlayer = {}

    for i = 1, 5 do
      --玩家
      self.nodePlayer[i] = self.useplayer:getChildByName("User_"..i)
      local head_bg =self.nodePlayer[i]:getChildByName("Head_bg")
      head_bg:setZOrder(10)
    end

    --------------------中奖记录 -------------------
    self.record = csbNode:getChildByName("Record")
    self.record:setLocalZOrder(9999999)
 --   self.record :setVisible(true)
    self.recordTip = cc.Label:createWithTTF("暂无记录","fonts/round_body.ttf",48)
    self.recordTip:setPosition(cc.p(670,300))
    self.recordTip:setVisible(false)
    self.recordTip:addTo(self.record)
    local btn_record = self.record:getChildByName("Button_record")
    btn_record:setTag(TAG_ENUM.TAG_RECORD_END);
    btn_record:addTouchEventListener(btnEvent);
    btn_record:setVisible(false)
    self.record_user = self.record:getChildByName("Users_1")

    self.listview_charm = self.record:getChildByName("ListView_2")

    -----------------压中大奖-------- 100倍 和200倍
    self.awards = csbNode:getChildByName("Panel_awards")
    self.awards:setZOrder(5)
    self.awards:setVisible(false)

    self.awards_score = self.awards:getChildByName("awards_score")
    self.awards_score:setString(0)
    local Button_awards = self.awards:getChildByName("Button_awards")
    Button_awards:setTag(TAG_ENUM.TAG_AWARDS);
    Button_awards:addTouchEventListener(btnEvent);

    -----------------------初进房间线段显示-----

    self.image_Line = csbNode:getChildByName("Panel_line")
    self.image_Line:setVisible(true)
    for i=1,15 do

        local posx = math.ceil(i/3)   --==  Math.ceil()方法执行的是向上取整计算，它返回的是大于或等于函数参数，并且与之最接近的整数。
        local posy = (i-1)%3 + 1

        local nodeStr = string.format("Image_fruit_%d_0",i)
        local node1 = self.Panel_games:getChildByName(nodeStr)
        node1:loadTexture("game1/game/mask.png")
    end

end

function Game1ViewLayer:setBtnEnabled(btnEnabled)
    --最小押注 ----等于重置  --要增加压线变成一
	local Button_Min = self.Button_info:getChildByName("Button_Min")
	Button_Min:setEnabled(btnEnabled)
	--最大押注
	local Button_Max = self.Button_info:getChildByName("Button_Max")
	Button_Max:setEnabled(btnEnabled)

    --最大押线 --全线
	local Button_Lin = self.Button_info:getChildByName("Button_Quanxian")
	Button_Lin:setEnabled(btnEnabled)

	--减少 单注
	local Button_Sub = self.Button_info:getChildByName("Button_Sub")
	Button_Sub:setEnabled(btnEnabled)
	--增加 单注
	local Button_Add = self.Button_info:getChildByName("Button_Add")
	Button_Add:setEnabled(btnEnabled)
    --减少 压线
	local Button_Sub1 = self.Button_info:getChildByName("Button_Sub1")
	Button_Sub1:setEnabled(btnEnabled)
	--增加 压线
	local Button_Add1 = self.Button_info:getChildByName("Button_Add1")
	Button_Add1:setEnabled(btnEnabled)
end

----布告流动
function Game1ViewLayer:onNotify(msg)

    self._notifyText:stopAllActions()
    if  msg or not msg.str or #msg.str == 0 then 
        self._notifyText:setString("")
		self.m_bNotifyRunning = false
		self._tipIndex = 1
		self._sysIndex = 1
        return
    end

	self.m_bNotifyRunning = true
	local msgcolor =  cc.c4b(255,255,255,255)--msg.color or
	self._notifyText:setVisible(false)
	self._notifyText:setString(msg.str)
	self._notifyText:setTextColor(msgcolor)

	if true == msg.autoremove then
		msg.showcount = msg.showcount or 0
		msg.showcount = msg.showcount - 1
		if msg.showcount <= 0 then
			self:removeNoticeById(msg.id)
		end
	end
	
	local tmpWidth = self._notifyText:getContentSize().width
	self._notifyText:runAction(
			cc.Sequence:create(
				cc.CallFunc:create(	function()
					self._notifyText:move(yl.WIDTH-500,0)
					self._notifyText:setVisible(true)
				end),
				cc.MoveTo:create(16 + (tmpWidth / 172),cc.p(0-tmpWidth,0)),
				cc.CallFunc:create(	function()
					local tipsSize = 0
					local tips = {}
					local index = 1
					if 0 ~= #self.m_tabInfoTips then
						-- 喇叭等
						local tmp = self._tipIndex + 1
						if tmp > #self.m_tabInfoTips then
							tmp = 1
						end
						self._tipIndex = tmp
						self:onChangeNotify(self.m_tabInfoTips[self._tipIndex])
					else
						-- 系统公告
						local tmp = self._sysIndex + 1
						if tmp > #self.m_tabSystemNotice then
							tmp = 1
						end
						self._sysIndex = tmp
						self:onChangeNotify(self.m_tabSystemNotice[self._sysIndex])
					end				
				end)
			)
	)

end

function Game1ViewLayer:removeNoticeById(id)
	if nil == id then
		return
	end

	local idx = nil
	for k,v in pairs(self.m_tabInfoTips) do
		if nil ~= v.id and v.id == id then
			idx = k
			break
		end
	end

	if nil ~= idx then
		table.remove(self.m_tabInfoTips, idx)
	end
end


--  用户头像更新
function Game1ViewLayer:OnUpdateUser(viewId,userItem)

	if not viewId or viewId == yl.INVALID_CHAIR then
		print("OnUpdateUser viewId is nil")
		return
	end


 	local head = self.nodePlayer[viewId]:getChildByTag(TAG_ENUM.TAG_HEAD)
	if not userItem then

	else
		self.nodePlayer[viewId]:setVisible(true)
        if not head then
            head = HeadSprite:createNormal(userItem,85)
            head:move(50,100)
            head:setZOrder(1)
            head:setTag(TAG_ENUM.TAG_HEAD)
            head:addTo(self.nodePlayer[viewId])
        else
            head:updateHead(userItem)
        end
        self.nodePlayer[viewId]:getChildByName("Money"):setVisible(true)
        self.nodePlayer[viewId]:getChildByName("Name"):setVisible(true)
        self.nodePlayer[viewId]:getChildByName("Name"):setString(userItem.szNickName)
        self.nodePlayer[viewId]:getChildByName("Money"):setString(userItem.lScore)
	end
end

--主游戏动画开始     --转盘的动画
function Game1ViewLayer:game1Begin()
    print("############  game1Begin  ##############")
    self.image_Line:setVisible(false)
    --self:setBtnEnabled(false)

   self.m_bStart = true     --开始开关按钮
    for i=1,15 do

        local posx = math.ceil(i/3)   --==  Math.ceil()方法执行的是向上取整计算，它返回的是大于或等于函数参数，并且与之最接近的整数。
        local posy = (i-1)%3 + 1

        local nodeStr = string.format("Image_fruit_%d_0",i)
        local nodeStr1 = string.format("Image_fruit_%d",i)
        local node = self.Panel_games:getChildByName(nodeStr)
        local node1 = self.Panel_games:getChildByName(nodeStr1)
        node1:setVisible(false) 
        local posx1 = node:getPositionX()
        if node ~= nil then
        	local nType = tonumber(self._scene.m_cbItemInfo[posy][posx])+1
        	if nType < 0 or nType > 11 then
        		nType = 0
        	end
			local pItem =  GameItem:create()   --动画
			if pItem then
                pItem:created(nType , i)
				local pItemLast = node:getChildByTag(1)
				if pItemLast then
					pItemLast:stopAllItemAction()
					pItemLast:removeFromParent()
					pItemLast = nil
				end
				node:addChild(pItem,0,1)
				pItem:setAnchorPoint(0.5,0.5)
				pItem:setContentSize(cc.size(105,90))
				--pItem:setPosition(0,0)
				node:runAction(
					cc.Sequence:create(
						cc.CallFunc:create(function (  )
                        local times = 0
                        if i <= 3       then
                           times = 3
                        elseif i <= 6  then 
                            times = 6
                        elseif i <= 9 then 
                            times = 9
                        elseif i <= 12 then 
                            times = 12  
                        else  
                            times = 15

                        end
                           if self._scene.m_bIsAuto == true then
							pItem:beginMove(0)   --旋转   --所有的转动动画都在GameItem 里面
                            else
                            pItem:beginMove(1)
                            end
							if i == 15 then
								self._scene:setGameMode(2) --表达GAME_STATE_MOVING
							end
						end)
						)
					)

			end
        end
    end

--    ExternalFun.playSoundEffect("gundong.mp3")
    self:runAction(
    	cc.Sequence:create(
    		--cc.DelayTime:create(0.5),
    		cc.CallFunc:create(function (  )
    			if self._scene:getGameMode() == 2 then --表达GAME_STATE_MOVING
                 print("############  ********************************************************* ##############")

    				self:game1GetLineResult()  
    			end
    		end)
    		)
    	)
end

--]]
--手动停止滚动
function Game1ViewLayer:game1End(  )
    self._scene:setGameMode(3)
    for i=1,15 do
        local nodeStr = string.format("Image_fruit_%d_0",i)
        --nodeStr:setVisible(false)
        local posx = math.ceil(i/3)
        local posy = (i-1)%3 + 1
        local nodeStr = string.format("Image_fruit_%d_0",i)
        local node = self.Panel_games:getChildByName(nodeStr)

        if node  then
        	local pItem = node:getChildByTag(1)
        	if pItem then
        		--pItem:stopAllItemAction()
               pItem:beginJump() 
        	end
        end
    end
--    self:stopAllActions()
    self:game1Result()


end
--游戏1结果
function Game1ViewLayer:game1Result()

	self._scene:setGameMode(3) --GAME_STATE_RESULT
	self.m_textGetScore:setString(self._scene.m_lGetCoins)


    if self._scene.m_bEnterGame3 == true then     --设置小玛丽状态
    	self._scene.m_cbGameStatus = g_var(cmd).GAME_FANPAI
    end
    local fTime = 0.1
    if self._scene.m_lGetCoins > 0 then
    	fTime = 2
    end

    --即将进入小玛丽
    if g_var(cmd).GAME_FANPAI == self._scene.m_cbGameStatus then
        self.m_bStart = true
    	self:runAction(
    		cc.Sequence:create(
            
    			cc.CallFunc:create(function (  )
    				if self.m_textTip then
    					self.m_textTip:setString("即将进入小玛丽")
    				end
    			end),
    			--cc.DelayTime:create(fTime),
    			cc.CallFunc:create(function (  )
    				self._scene.m_bIsItemMove = false
    				--游戏模式
    				self._scene:setGameMode(5) --GAME_STATE_END
    				--即将进入小玛丽
                    print("即将进入小玛丽")
    				self._scene:onEnterGame2()

    			end)
    			)
    		)
    elseif self._scene.m_bIsAuto == true  then     --自动游戏中，
    			self:runAction(
    				cc.Sequence:create(
    				--	cc.DelayTime:create(fTime),
    					cc.CallFunc:create(function ( )
    						self._scene.m_bIsItemMove = false

    					end),
    					cc.CallFunc:create(function()
                            print("自动游戏中，将有3秒时间让玩家选择是否进入比倍后")
                            --断线重连后
                            if self._scene.m_bReConnect1 == true then
                                local useritem = self._scene:GetMeUserItem()
                                if useritem.cbUserStatus ~= yl.US_READY then 
                                    print("---框架准备 断线重连后")
                                    self._scene:SendUserReady()
                                end
                                --发送准备消息
                                self._scene:sendReadyMsg()

                                self._scene.m_cbGameStatus = g_var(cmd).SHZ_GAME_SCENE_FREE
                                self._scene:setGameMode(1)
                                self._scene.m_bReConnect1 = false
                                print(" ---断线重连 over")

                                return
                            end
                            --if self._scene.m_bIsAuto == true then
                                self._scene:setGameMode(5) --GAME_STATE_END
                                self.m_bStart = true     --开始开关按钮
                                    --结束游戏1消息
                                self._scene:sendEndGame1Msg()


    					end)
    					)
    				)
    	else
    		self:runAction(
    			cc.Sequence:create(
    				cc.CallFunc:create(function (  )
    					self._scene.m_bIsItemMove = false
    					self._scene:setGameMode(5)
---					    if self._scene.m_lGetCoins <= 0 then
                            --结束游戏1消息
                            self.m_bStart = true     --开始开关按钮
                            self._scene:sendEndGame1Msg()
--					    end

    				end),
                    --cc.DelayTime:create(1),
                    cc.CallFunc:create(function (  )
                        --断线重连后
                        if self._scene.m_bReConnect1 == true then
                            local useritem = self._scene:GetMeUserItem()
                            if useritem.cbUserStatus ~= yl.US_READY then 
                                print(" ---框架准备 断线重连后")
                                self._scene:SendUserReady()
                            end
                            --发送准备消息
                            self._scene:sendReadyMsg()

                            self._scene.m_cbGameStatus = g_var(cmd).SHZ_GAME_SCENE_FREE
                            self._scene:setGameMode(1)
                            self._scene.m_bReConnect1 = false
                            print(" ---断线重连 over")
                            return
                        end
                        if self._scene.m_bIsAuto == true and self._scene.m_lGetCoins > 0 then
                            --发送消息
                            self._scene:setGameMode(5) --GAME_STATE_END

                        end
                    
                    end)
    				)
    			)
    end
end

--游戏连线结果
function Game1ViewLayer:game1GetLineResult()   --转动1.5秒后自动结算  下面有做
	print("游戏连线结果")
    self._scene:setGameMode(3)  --GAME_STATE_RESUL
    print("self._scene.m_lBetScore")
    dump(self._scene.m_lBetScore)
    dump(self._scene.m_bYafenIndex)
    local a = self._scene.m_lBetScore[self._scene.m_bYafenIndex]
    if a == 0 then
        a =  1
    end
    if self._scene.m_lGetCoins /a   >= 50  then
    self.m_textGetScore:runAction(
    cc.Sequence:create(
 --  cc.DelayTime:create(1),
    cc.CallFunc:create(function ( )
        self.m_textGetScore:setString(self._scene.m_lGetCoins)
    end)
    ) )
   else
     self.m_textGetScore:setString(self._scene.m_lGetCoins)
   end
    --中奖的线的数量
    local m_winNum = 0
    --保存中间线数量的数组
    self.sprLine1 ={}
    --画中奖线
    --中奖线路径
    local pathLine = 
    {
    	"prizeLine/01.png",
    	"prizeLine/02.png",
    	"prizeLine/03.png",
    	"prizeLine/04.png",
    	"prizeLine/05.png",
    	"prizeLine/06.png",
    	"prizeLine/07.png",
    	"prizeLine/08.png",
    	"prizeLine/09.png",
	}
	--绘制中奖线   --做个 中奖就撒金币 在这里同时开始
	if self._scene.m_lGetCoins > 0 then

        if self._scene.m_lGetCoins / self._scene.m_lBetScore[self._scene.m_bYafenIndex]  >= 100  then
            fTime = 3
            ExternalFun.playSoundEffect("chaojidajiang.mp3")
            self.awards:setVisible(true)
            self.awards:getChildByName("Image_100"):setVisible(false) --100
            self.awards:getChildByName("Image_200"):setVisible(true) --200
            self.awards_score:setString(self._scene.m_lGetCoins)
            self:runAction(
    	    		cc.Sequence:create(
    	    			--cc.DelayTime:create(2),
    	    			cc.CallFunc:create(function ( )
    	    			 self.awards:setVisible(false)
    	    			end)
                     )
                   )
        elseif self._scene.m_lGetCoins / self._scene.m_lBetScore[self._scene.m_bYafenIndex]  >= 50  then
            fTime = 3
            ExternalFun.playSoundEffect("chaojidajiang.mp3")
            self.awards:setVisible(true)
            self.awards:getChildByName("Image_100"):setVisible(true) --100
            self.awards:getChildByName("Image_200"):setVisible(false) --200
            self.awards_score:setString(self._scene.m_lGetCoins)
            self:runAction(
        			cc.Sequence:create(
        				--cc.DelayTime:create(2),
        				cc.CallFunc:create(function ( )
        				 self.awards:setVisible(false)
        				end)
                     )
                   )
      end
		--每条线间隔
		--local delayTime = 3
          --音效
        ExternalFun.playSoundEffect("lb_gold_effect.wav")
        self:ShowParticle()          --------------撒金币
		for lineIndex=1,#self._scene.m_UserActionYaxian do
			local pActionOneYaXian = self._scene.m_UserActionYaxian[lineIndex]
            m_winNum = m_winNum + 1
			if pActionOneYaXian then
            -------------------绘制完全的线
            if self._scene.m_bIsAuto == false  then
 --           if  m_winNum > 1 then
                local sprLine1 = display.newSprite(pathLine[pActionOneYaXian.nZhongJiangXian])
				self:removeChildByTag(lineIndex)
				self._csbNode:addChild(sprLine1,0,lineIndex)
                if pActionOneYaXian.nZhongJiangXian == 1 then
                sprLine1:setPosition(667,430)
                elseif pActionOneYaXian.nZhongJiangXian == 2 then
                sprLine1:setPosition(667,557)
                elseif pActionOneYaXian.nZhongJiangXian == 3 then
                sprLine1:setPosition(667,304)
                elseif pActionOneYaXian.nZhongJiangXian == 4 then
                sprLine1:setPosition(667,456)
                elseif pActionOneYaXian.nZhongJiangXian == 5 then
                sprLine1:setPosition(667,405)
                else
				sprLine1:setPosition(667,430)
                end
--                sprLine1:runAction(
--					cc.Sequence:create(
--						cc.DelayTime:create(2),
----                        cc.Hide:create(),
--                        cc.CallFunc:create(function (  )
--							 self:game1Result()
--						end)
--					 )
--				 )
                  self:game1Result()  --结算
                  self.sprLine1[lineIndex] =  sprLine1
                  self:upWinelves(pActionOneYaXian)
  --           end
             else
                 ---------------------------
				self:runAction(
					cc.Sequence:create(
					--	cc.DelayTime:create( delayTime*(lineIndex - 1)),
						cc.CallFunc:create(function ()

                    --    	 self:game1Result()
							--如果是最后一个，进入结算界面
							if lineIndex == #self._scene.m_UserActionYaxian then
								self:runAction(
									cc.Sequence:create(
									--	cc.DelayTime:create(0.5),
										cc.CallFunc:create(function (  )
										 self:game1Result()
										end)
										)
									)
					    	end
							local sprLine = display.newSprite(pathLine[pActionOneYaXian.nZhongJiangXian])
							self:removeChildByTag(lineIndex)
							self._csbNode:addChild(sprLine,0,lineIndex)
                            if pActionOneYaXian.nZhongJiangXian == 1 then
                            sprLine:setPosition(667,430)
                            elseif pActionOneYaXian.nZhongJiangXian == 2 then
                            sprLine:setPosition(667,557)
                            elseif pActionOneYaXian.nZhongJiangXian == 3 then
                            sprLine:setPosition(667,304)
                            elseif pActionOneYaXian.nZhongJiangXian == 4 then
                            sprLine:setPosition(667,456)
                            elseif pActionOneYaXian.nZhongJiangXian == 5 then
                            sprLine:setPosition(667,405)
                            else
				            sprLine:setPosition(667,430)
                            end
                            sprLine:setScaleX(1.0)
							sprLine:runAction(
								cc.Sequence:create(
								--	cc.DelayTime:create(1),
									cc.Hide:create()
									)
								)
                                 
                           self:ShowParticle()          --------------撒金币
                           self:upWinelves(pActionOneYaXian)
						end)
						)
					)
                 end  --判断手自动的线动画
			end    
  
		end
        if self._scene.m_lYaxian == 9 and self._scene.m_bYafenIndex == 9 and  self._scene._BonusNum == 5 then
            ExternalFun.playSoundEffect("chaojidajiang.mp3")
            self.awards:setVisible(true)
            self.awards:getChildByName("Image_100"):setVisible(false) --100
            self.awards:getChildByName("Image_200"):setVisible(true) --200
            self.awards_score:setString(self._scene.m_lGetCoins)
            self:runAction(
    	    		cc.Sequence:create(
    	    		--	cc.DelayTime:create(1),
    	    			cc.CallFunc:create(function ( )
    	    			 self.awards:setVisible(false)
    	    			end)
                     )
                   )
           self:ShowParticle()          --------------撒金币
           self:game1Result()
        end
	else
		self:game1Result()
	end
end


--中奖精灵动画
function Game1ViewLayer:upWinelves(pActionOneYaXian)
   local pActionOneYaXian = pActionOneYaXian
 --设置每个精灵状态    --这里做   放大缩小动画   连带着线 以前进行放大缩小
	for i=1,15 do
	       local posx = math.ceil(i/3)
	       local posy = (i-1)%3 + 1
	       local nodeStr = string.format("Image_fruit_%d_0",i)
           local node = self.Panel_games:getChildByName(nodeStr)
	       if node then
	       	local pItem = node:getChildByTag(1)
	       	if pItem then
	       		--判断是否中奖的
	       		local isOnLine = false
	       		for j=1,g_var(cmd).ITEM_X_COUNT do
	       			local pos = {}
	       			pos.x = pActionOneYaXian.ptXian[j].x
	       			pos.y = pActionOneYaXian.ptXian[j].y
	       			if pos.x == posy and pos.y == posx then
	       				isOnLine = true
                          ---------中奖的图片进行循环播放 放大缩小-------------
                        node:runAction(cc.Repeat:create(cc.Sequence:create(cc.ScaleTo:create(0.15,1.1),
                        --cc.DelayTime:create(0.1),
                        cc.ScaleTo:create(0.15,1.0)),5))
                   --   sprLine:runAction(cc.RepeatForever:create(cc.Sequence:create(cc.ScaleTo:create(0.05,1.0),cc.DelayTime:create(0.1),cc.ScaleTo:create(0.05,0.8))))
                  --    sprLine:runAction(cc.Blink:create(0.8,10))    --闪烁动画
	       			end
	       		end
	       	end

	       end
	end
end

function Game1ViewLayer:StartButtonClickedEvent(tag,ref)
        if tag == TAG_ENUM.TAG_START_MENU  then
            ExternalFun.playSoundEffect("state.wav")
            local scheduler = cc.Director:getInstance():getScheduler()
            --self.schedulerID = nil
            self.time = 0
            if self.schedulerID ~= nil then 
            	 cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedulerID)
            	 self.schedulerID = nil
            end
            self.schedulerID = scheduler:scheduleScriptFunc(function()
            print("按压中~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
            	self.time = self.time + 1
            end
            ,1,false) 
        end
end

 local g_time = 0
function Game1ViewLayer:onButtonClickedEvent(tag,ref)
print( self._scene)
	if tag == TAG_ENUM.TAG_QUIT_MENU then  			--退出
        self._scene.m_bIsLeave = true
        self._scene:onExitTable()
        ExternalFun.playClickEffect()

	elseif tag == TAG_ENUM.TAG_START_MENU  and  self.m_bStart == true   then  --开始开关按钮 then    		--开始游戏
		local getendtime = os.time()
		if self.time > 2 then
			 self._scene:onAutoStart()
             self.Button_Stop:setVisible(true)   
      	else
		if g_time == 0 then 
			g_time = getendtime
		else
			if(getendtime - g_time)< 2 then 
			print('快速点击')
				return
			end
		end
		 g_time =  getendtime
		 self._scene:onGameStart()
		 print('开始游戏')
		end
		if self.schedulerID ~= nil then 
            cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedulerID)
            self.schedulerID = nil
        end
		--self.Button_Stop:setVisible(true)
        --self:setBtnEnabled(false)
     --ExternalFun.playSoundEffect("state.wav")
    elseif tag == 102  then                       --停止自动按钮
        self.Button_Stop:setVisible(false)
        self._scene.m_bIsAuto = false
    elseif tag == 100  then                       --菜单
        self.m_imgMenu:setVisible(true)
        self.Button_Menu:setVisible(false)
    elseif tag == 101  then                       --菜单返回
        self.m_imgMenu:setVisible(false)
        self.Button_Menu:setVisible(true)
	elseif tag == TAG_ENUM.TAG_SETTING_MENU  then    --	设置   
		self:onSetLayer()
        ExternalFun.playClickEffect("click.wav")
	elseif tag == TAG_ENUM.TAG_HELP_MENU  then    	--游戏帮助 
        self:onHelpLayer()
    elseif tag == 103  then    	--游戏帮助 
        return
    elseif tag == TAG_ENUM.TAG_RECORD_MENU then      --中奖记录打开 ----------------------
        self._scene:sendRecord()
        ExternalFun.playClickEffect()               --声音
    elseif tag ==TAG_ENUM.TAG_RECORD_END then           --中奖记录关闭
        self.record:setVisible(false)
        self.listview_charm:removeAllChildren()
	elseif tag == TAG_ENUM.TAG_MAXADD_BTN  then    --	最大加注
		self._scene:onAddMaxScore()
		--self._scene:onAddMaxThread()
        --ExternalFun.playSoundEffect("zengjiaxian.wav")
        --声音
        ExternalFun.playSoundEffect("zengjiafen.wav")
   elseif tag == TAG_ENUM.TAG_MAXADDX_BTN then     --最大压线
   	    self._scene:onAddThread()
        --self._scene:onAddMaxThread()
        --ExternalFun.playSoundEffect("zengjiaxian.wav")
	elseif tag == TAG_ENUM.TAG_MINADD_BTN  then    --	最小减注  --改为重置
		self._scene:onAddScore()
		--self._scene:onAddMinScore()
        --声音
        ExternalFun.playSoundEffect("zengjiafen.wav")
	elseif tag == TAG_ENUM.TAG_ADD_BTN  then    --	加注
		self._scene:onAddScore()
        --声音
        ExternalFun.playSoundEffect("zengjiafen.wav")
	elseif tag == TAG_ENUM.TAG_SUB_BTN  then    --	减注
		self._scene:onSubScore()
        --声音
        ExternalFun.playSoundEffect("jianshaofen.wav")
    elseif tag == TAG_ENUM.TAG_ADD1_BTN  then    --	加线
		self._scene:onAddThread()
        --声音
        ExternalFun.playSoundEffect("zengjiaxian.wav")
	elseif tag == TAG_ENUM.TAG_SUB1_BTN  then    --	减线
		self._scene:onSubThread()
        --声音
        ExternalFun.playSoundEffect("jianshaoxian.wav")
	elseif tag == TAG_ENUM.TAG_AUTO_START_BTN  then   --自动游戏
		self._scene:onAutoStart()   --自动游戏
--        ExternalFun.playClickEffect()  --声音
        ExternalFun.playSoundEffect("state.wav")
    elseif tag == TAG_ENUM.TAG_AWARDS then
        self.awards:setVisible(false)
	end
end

--隐藏上部菜单
function Game1ViewLayer:onHideTopMenu()
    if self.m_nodeMenu:getPositionX() == -667 then
        return
    end
	local actMove = cc.MoveTo:create(0.5,cc.p(-667,703.5))
	local Sequence = cc.Sequence:create(
		actMove,
		cc.CallFunc:create(function (  )
			local Button_Show = self._csbNode:getChildByName("Button_Show")
			if Button_Show then
				Button_Show:setVisible(true)
			end
		end)
		)
	self.m_nodeMenu:runAction(Sequence)
end

--显示上部菜单
function Game1ViewLayer:onShowTopMenu()
    if self.m_nodeMenu:getPositionX() == 667 then
        return
    end
	local actMove = cc.MoveTo:create(0.5,cc.p(667,703.5))
	local spawn = cc.Spawn:create(
		cc.CallFunc:create(function (  )
			local Button_Show = self._csbNode:getChildByName("Button_Show")
			if Button_Show then
				Button_Show:setVisible(false)
			end
		end),
		actMove
		)
	self.m_nodeMenu:runAction(spawn)
end
--声音设置界面
function Game1ViewLayer:onSetLayer(  )
--    self:onHideTopMenu()
--    local mgr = self._scene._scene:getApp():getVersionMgr()
--    local verstr = mgr:getResVersion(g_var(cmd).KIND_ID) or "0"
--    verstr = "游戏版本:" .. appdf.BASE_C_VERSION .. "." .. verstr
	local set = SettingLayer:create()
    self._csbNode:addChild(set)
    set:setLocalZOrder(9)
end
--帮助层
function Game1ViewLayer:onHelpLayer()
--    self:onHideTopMenu()
     ExternalFun.playSoundEffect("click.wav")
    local help = HelpLayer:create()
    self._csbNode:addChild(help)
    help:setLocalZOrder(9)
end
--中奖记录层
function Game1ViewLayer:onRecord()
--    self:removeChildByName("RewardRecord")
--    self.record=self.record1:clone()
--    self.record:setName("RewardRecord")
--    self.record:addTo(self)
    self.record:setVisible(true)
    local cbCount =  self._scene._num
     if cbCount > 10 then
        cbCount=10
     end
     if cbCount <= 0 then 
        print("暂时无人获得奖金")
        --showToast(self,"暂无记录",3)  --系统提示框 层  显示的内容 时间
        self.recordTip:setVisible(true)
     end


      for i =1, cbCount do
       local panel_cell = self.record_user:clone()

       local record_name = panel_cell:getChildByName("Text_Name")   
       local record_time = panel_cell:getChildByName("Text_Time")
       local record_amount = panel_cell:getChildByName("Text_Amount")

       record_name:setString(self._scene._Name[i])
       record_time:setString(self._scene.strTime[i])
       record_amount:setString(self._scene._Bonus[i])


       panel_cell:setVisible(true)
       --self.record_user:setVisible(true)
       self.listview_charm:pushBackCustomItem(panel_cell)
     end
end

--自动游戏
function Game1ViewLayer:setAutoStart( bisShow )
	--显示勾
   local Button_Auto = self.Button_info:getChildByName("Button_Auto_0");
	if Button_Auto then
		Button_Auto:setVisible(bisShow)
	end
end


--   -- 拉杆动画
function Game1ViewLayer:updateStartButtonState( bIsStart)

    local Button_Start = self.Button_info:getChildByName("Image_Start");   --开始的按钮
      Button_Start:runAction(cc.Sequence:create(cc.MoveTo:create(0.1,cc.p(1100,312)),cc.DelayTime:create(0),cc.MoveTo:create(0.1,cc.p(1100,434)) )) --时间和坐标  点击移动下去--再设回来

end
--飘扬旗帜

--压中线的音乐
function Game1ViewLayer:Game1ZhongxianAudio( bIndex )
    local soundPath = 
    {
        "winsound.mp3",
        "winsound.mp3",
        "winsound.mp3",
        "luzhisheng.mp3",
        "lincong.mp3",
        "songjiang.mp3",
        "titianxingdao.mp3",
        "zhongyitang.mp3",
        "shuihuchuan3.mp3"
    }
    ExternalFun.playSoundEffect(soundPath[bIndex])
end

--中奖之后撒金币
function Game1ViewLayer:ShowParticle()

    local praticle = cc.ParticleSystemQuad:create(GameViewLayer.RES_PATH.."game1/particle/jingbi_1.plist") --矩阵粒子
    praticle:setPosition(577,650)
    praticle:setPositionType(cc.POSITION_TYPE_FREE) --模式设置 自由模式 不会随粒子节点移动而移动   cc.POSITION_TYPE_GROUPED 粒子随发射器移动而移动
    self:addChild(praticle, 10)
    praticle:setAutoRemoveOnFinish(true)
end

-- ---------------------------------------------------------------------------------------
------						游戏2 翻牌
------------------------------------------------------------------------------------

function Game2ViewLayer:ctor(scene)
	--注册node事件
	ExternalFun.registerNodeEvent(self,true)
	self._scene = scene
    --播放背景音乐
    ExternalFun.playBackgroudAudio("xiaoyouxibeijing.mp3")

    self.m_cbLeftTime = 0     --倒计时时间
    self.time = 0.05
    self:initCsbRes();
  -------倒计时------
    self._scene:SetGameClock(0,0,62)

end

--界面初始化
function Game2ViewLayer:initCsbRes(  )
    local rootLayer, csbNode = ExternalFun.loadRootCSB(GameViewLayer.RES_PATH .. "game2/Game2Layer.csb", self)
    self._csbNode = csbNode
    self.rootLayer = rootLayer
	--初始化按钮
	self:initUI(self._csbNode)
     print(self._scene)
end

function Game2ViewLayer:initUI( csbNode )

   ----进入游戏的界面
   local Loading = csbNode:getChildByName("Image_Loading")
         Loading:setVisible(true)
   self:runAction(
		cc.Sequence:create(
		--cc.DelayTime:create(2),
		cc.CallFunc:create(function()
        Loading:setVisible(false)
		end)
	 )
   )

       --退出游戏界面和赢取分数
    self.Cearing = csbNode:getChildByName("Image_win")
    self.Cearing:setVisible(false)
    self.Allscore = csbNode:getChildByName("Text_win")
    self.Allscore:setVisible(false)

    local function btnEvent( sender, eventType )   --添加按钮点击回调
     if eventType == ccui.TouchEventType.ended then
            ExternalFun.dismissTouchFilter()
            self:onButtonClickedEvent(sender:getTag(), sender)
      end
    end


    self.Button_k1 = csbNode:getChildByName("Button_K1")
    self.Button_k1:setEnabled(true)
    self.Button_k2 = csbNode:getChildByName("Button_K2")
    self.Button_k2:setEnabled(true)
    self.Button_k3 = csbNode:getChildByName("Button_K3")
    self.Button_k3:setEnabled(true)
    self.Button_k4 = csbNode:getChildByName("Button_K4")
    self.Button_k4:setEnabled(true)



    ------再添加20个图片 直接切换图片纹理  如果是炸弹 播放一个炸弹的动画、

    self.image_k1 = {}
    self.image_k2 = {}
    self.image_k3 = {}
    self.image_k4 = {}
 
    for i = 1, 5 do
    self.image_k1[i] = self.Button_k1:getChildByName("Image_" .. i)
    local frameName1 = string.format(GameViewLayer.RES_GAME2 .."image_1%d.png",1)  --
    self.image_k1[i]:loadTexture(frameName1)  -- 
    end

    for i = 1, 5 do
    self.image_k2[i] = self.Button_k2:getChildByName("Image_" .. i)
    end

    for i = 1, 5 do
    self.image_k3[i] = self.Button_k3:getChildByName("Image_" ..i)
    end

    for i = 1, 5 do
    self.image_k4[i] = self.Button_k4:getChildByName("Image_"..i)
    end

    -------------------------------------------------------

   self.Button_1 = self.Button_k1:getChildByName("Button_1")
   self.Button_1:setTag(1)
   self.Button_1:addTouchEventListener(btnEvent);
   self.Button_2 = self.Button_k1:getChildByName("Button_2")
   self.Button_2:setTag(2)
   self.Button_2:addTouchEventListener(btnEvent);
   self.Button_3 = self.Button_k1:getChildByName("Button_3")
   self.Button_3:setTag(3)
   self.Button_3:addTouchEventListener(btnEvent);
   self.Button_4 = self.Button_k1:getChildByName("Button_4")
   self.Button_4:setTag(4)
   self.Button_4:addTouchEventListener(btnEvent);
   self.Button_5 = self.Button_k1:getChildByName("Button_5")
   self.Button_5:setTag(5)
   self.Button_5:addTouchEventListener(btnEvent);
   self.Button_6 = self.Button_k2:getChildByName("Button_1")
   self.Button_6:setTag(6)
   self.Button_6:addTouchEventListener(btnEvent);
   self.Button_7 = self.Button_k2:getChildByName("Button_2")
   self.Button_7:setTag(7)
   self.Button_7:addTouchEventListener(btnEvent);
   self.Button_8 = self.Button_k2:getChildByName("Button_3")
   self.Button_8:setTag(8)
   self.Button_8:addTouchEventListener(btnEvent);
   self.Button_9 = self.Button_k2:getChildByName("Button_4")
   self.Button_9:setTag(9)
   self.Button_9:addTouchEventListener(btnEvent);
   self.Button_10 = self.Button_k2:getChildByName("Button_5")
   self.Button_10:setTag(10)
   self.Button_10:addTouchEventListener(btnEvent);
   self.Button_11 = self.Button_k3:getChildByName("Button_1")
   self.Button_11:setTag(11)
   self.Button_11:addTouchEventListener(btnEvent);
   self.Button_12 = self.Button_k3:getChildByName("Button_2")
   self.Button_12:setTag(12)
   self.Button_12:addTouchEventListener(btnEvent);
   self.Button_13 = self.Button_k3:getChildByName("Button_3")
   self.Button_13:setTag(13)
   self.Button_13:addTouchEventListener(btnEvent);
   self.Button_14 = self.Button_k3:getChildByName("Button_4")
   self.Button_14:setTag(14)
   self.Button_14:addTouchEventListener(btnEvent);
   self.Button_15 = self.Button_k3:getChildByName("Button_5")
   self.Button_15:setTag(15)
   self.Button_15:addTouchEventListener(btnEvent);
   self.Button_16 = self.Button_k4:getChildByName("Button_1")
   self.Button_16:setTag(16)
   self.Button_16:addTouchEventListener(btnEvent);
   self.Button_17 = self.Button_k4:getChildByName("Button_2")
   self.Button_17:setTag(17)
   self.Button_17:addTouchEventListener(btnEvent);
   self.Button_18 = self.Button_k4:getChildByName("Button_3")
   self.Button_18:setTag(18)
   self.Button_18:addTouchEventListener(btnEvent); 
   self.Button_19 = self.Button_k4:getChildByName("Button_4")
   self.Button_19:setTag(19)
   self.Button_19:addTouchEventListener(btnEvent); 
   self.Button_20 = self.Button_k4:getChildByName("Button_5")
   self.Button_20:setTag(20)
   self.Button_20:addTouchEventListener(btnEvent);

   
   for i = 6, 20 do
   self["Button_"..i]:setEnabled(false)
   end

--20 个文本  --每个牌下面的分
    self.text_score1 = {}
    self.text_score2 = {}
    self.text_score3 = {}
    self.text_score4 = {}

      for i = 1, 5 do
       self.text_score1[i] =  self.Button_k1:getChildByName("AtlasLabel_"..i)
      end

      for i = 1, 5 do
       self.text_score2[i] =  self.Button_k2:getChildByName("AtlasLabel_"..i)
      end

      for i = 1, 5 do
       self.text_score3[i] =  self.Button_k3:getChildByName("AtlasLabel_"..i)
      end

      for i = 1, 5 do
       self.text_score4[i] =  self.Button_k4:getChildByName("AtlasLabel_"..i)
      end
-----20个 亮色的文本
      self.text_score01 = {}
      self.text_score02 = {}
      self.text_score03 = {}
      self.text_score04 = {}

      for i = 1, 5 do
       self.text_score01[i] =  self.Button_k1:getChildByName("AtlasLabel_0"..i)
      end

      for i = 1, 5 do
       self.text_score02[i] =  self.Button_k2:getChildByName("AtlasLabel_0"..i)
      end

      for i = 1, 5 do
       self.text_score03[i] =  self.Button_k3:getChildByName("AtlasLabel_0"..i)
      end

      for i = 1, 5 do
       self.text_score04[i] =  self.Button_k4:getChildByName("AtlasLabel_"..i)
      end

	--得到分数
	self.m_textGetScore = csbNode:getChildByName("Text_Score")
    self.m_textGetScore:setString(0)

    ---返回按钮
    local Button_colse = csbNode:getChildByName("Button_Colse")
    Button_colse:setTag(21)
    Button_colse:addTouchEventListener(btnEvent);

  ----倒计时 时间显示
    self.Text_Clock = csbNode:getChildByName("Text_Clock")
    self.Text_Clock:setString(0)
end

function Game2ViewLayer:onButtonClickedEvent(tag,ref)

    self.button_num = 0              --记录点击的是那个位置的
    self.NumScore = 0
  print(self._scene)
    if tag ==21 then   --退出
      print("退出小游戏")
      self._scene:sendThreeEnd()  --发送结束
      self:backOneGame()   --切换到主游戏
    elseif tag == 1  then 
      print("翻牌")
      self.button_num = 1
      self.NumScore =self._scene.data[1][1]
      self:onShowCard(1)
    elseif tag == 2 then 
      self.button_num = 2
      self.NumScore= self._scene.data[1][2]
      self:onShowCard(1)
    elseif tag == 3 then 
      self.button_num = 3
      self.NumScore =self._scene.data[1][3]
      self:onShowCard(1)
    elseif tag == 4 then 
      self.button_num = 4
      self.NumScore =self._scene.data[1][4]
      self:onShowCard(1)
    elseif tag == 5 then 
      self.button_num = 5
      self.NumScore =self._scene.data[1][5]
      self:onShowCard(1)
    elseif tag == 6 then 
      self.button_num = 1
      self.NumScore =self._scene.data[2][1]
      self:onShowCard(2)
    elseif tag == 7 then 
      self.button_num = 2
      self.NumScore =self._scene.data[2][2]
      self:onShowCard(2)
    elseif tag == 8 then 
      self.button_num = 3
      self.NumScore =self._scene.data[2][3]
      self:onShowCard(2)
    elseif tag == 9 then 
      self.button_num = 4
      self.NumScore =self._scene.data[2][4]
      self:onShowCard(2)
    elseif tag == 10 then 
      self.button_num = 5
      self.NumScore=self._scene.data[2][5]
      self:onShowCard(2)
    elseif tag == 11 then 
      self.button_num = 1
      self.NumScore =self._scene.data[3][1]
      self:onShowCard(3)
    elseif tag == 12 then 
      self.button_num = 2
      self.NumScore =self._scene.data[3][2]
      self:onShowCard(3)             
    elseif tag == 13 then    
      self.button_num = 3        
      self.NumScore =self._scene.data[3][3]
      self:onShowCard(3)             
    elseif tag == 14 then 
      self.button_num = 4          
      self.NumScore =self._scene.data[3][4]
      self:onShowCard(3)             
    elseif tag == 15 then 
      self.button_num = 5           
      self.NumScore =self._scene.data[3][5]
      self:onShowCard(3)
    elseif tag == 16 then 
      self.button_num = 1
      self.NumScore =self._scene.data[4][1]
      self:onShowCard(4)
    elseif tag == 17 then 
      self.button_num = 2
      self.NumScore =self._scene.data[4][2]
      self:onShowCard(4)
    elseif tag == 18 then 
      self.button_num = 3
      self.NumScore =self._scene.data[4][3]
      self:onShowCard(4)
    elseif tag == 19 then 
      self.button_num = 4
      self.NumScore =self._scene.data[4][4]
      self:onShowCard(4)
    elseif tag == 20 then 
      self.button_num = 5
      self.NumScore =self._scene.data[4][5]
      self:onShowCard(4)
    end

end

function Game2ViewLayer:onShowCard(index)

    local rand = math.random(1,8)
   --1 是显示亮的  0 是显示暗的   00 10  是炸弹
   
    self._scene.m_lGetCoins3 =  self._scene.m_lGetCoins3 + self.NumScore

    self._scene.m_CardScore = self.NumScore  --没关的分数
    if index == 1 then
    self._scene.m_card = 1   --所在关卡
    self._scene:sendReadyMsg2()  --发送关卡数据
       for i =1 , 5 do                --显示下面分数文本
          self.text_score1[i]:setVisible(true)
          self.text_score1[self.button_num]:setVisible(false) 
          self.text_score01[self.button_num]:setVisible(true) 
          self.text_score1[i]:setString(self._scene.data[1][i])
          self.text_score01[i]:setString(self._scene.data[1][i])
          local frameName1 = string.format(GameViewLayer.RES_GAME2 .."image_1%d.png",1)  --
          local frameName0 = string.format(GameViewLayer.RES_GAME2 .."image_0%d.png",rand)
          if self._scene.data[1][i] == 0 then
          frameName0 = string.format(GameViewLayer.RES_GAME2 .."image_0%d.png",0)
          end

          self.image_k2[i]:loadTexture(frameName1)  -- 点击下层变量
          self.image_k1[i]:loadTexture(frameName0)   -- 本层变暗  
       end
     
 --      self:onTurnover(1)   --翻牌显示动画
       if  self.NumScore == 0 then 
           print("炸弹 退出游戏")
           ExternalFun.playSoundEffect("xiaoyouxizhadan.wav")
           self.image_k1[self.button_num]:loadTexture(GameViewLayer.RES_GAME2 .."image_10.png")  --本层点击的还是亮的  炸弹
           --结束界面显示 两秒后切换
           self.Cearing:setVisible(true)
           self.Allscore:setVisible(true)
           self.Allscore:setString(self._scene.m_lGetCoins3)
    	      self:runAction(
		          cc.Sequence:create(
			    --  cc.DelayTime:create(2),
			      cc.CallFunc:create(function()
                  self:backOneGame()  --结束游戏
                  self._scene:sendThreeEnd()  --发送结束
			    end)
			    )
		    )
       else
        local frameName1 = string.format(GameViewLayer.RES_GAME2 .."image_1%d.png",rand)      
        self.image_k1[self.button_num]:loadTexture(frameName1)  --本层点击的还是亮的  
          print("加分 进入下一关")
          for i = 1,10 do
             if i>5 then
               self["Button_"..i]:setEnabled(true)
             else
               self["Button_"..i]:setEnabled(false)
             end
          end

          self.m_textGetScore:setString(self._scene.m_lGetCoins3)
       end
    end
    if index == 2 then
     self._scene.m_card = 2   --所在关卡
     self._scene:sendReadyMsg2()  --发送关卡数据
       for i = 1 , 5 do                --显示下面分数文本
          self.text_score2[i]:setVisible(true)
          self.text_score2[self.button_num]:setVisible(false) 
          self.text_score02[self.button_num]:setVisible(true) 
          self.text_score2[i]:setString(self._scene.data[2][i])
          self.text_score02[i]:setString(self._scene.data[2][i])
          local frameName1 = string.format(GameViewLayer.RES_GAME2 .."image_1%d.png",1)  --
          local frameName0 = string.format(GameViewLayer.RES_GAME2 .."image_0%d.png",rand)
          if self._scene.data[2][i] == 0 then
          frameName0 = string.format(GameViewLayer.RES_GAME2 .."image_0%d.png",0)
          end
          self.image_k3[i]:loadTexture(frameName1)
          self.image_k2[i]:loadTexture(frameName0)
       end
       if  self.NumScore == 0 then 
           print("炸弹 退出游戏")
           ExternalFun.playSoundEffect("xiaoyouxizhadan.wav")
           self.image_k2[self.button_num]:loadTexture(GameViewLayer.RES_GAME2 .."image_10")  --本层点击的还是亮的  炸弹
                  --结束界面显示 两秒后切换
           self.Cearing:setVisible(true)
           self.Allscore:setVisible(true)
           self.Allscore:setString(self._scene.m_lGetCoins3)
    	       self:runAction(
		          cc.Sequence:create(
			   --   cc.DelayTime:create(2),
			      cc.CallFunc:create(function()
                  self:backOneGame()
                  self._scene:sendThreeEnd()  --发送结束
			      end)
			     )
		       )
       else
          print("加分 进入下一关")
          local frameName1 = string.format(GameViewLayer.RES_GAME2 .."image_1%d.png",rand)
         self.image_k2[self.button_num]:loadTexture(frameName1)  --本层点击的还是亮的  炸弹

         for i = 6,15 do
             if i>10 then
               self["Button_"..i]:setEnabled(true)
             else
               self["Button_"..i]:setEnabled(false)
             end
        end
         self.m_textGetScore:setString(self._scene.m_lGetCoins3)
       end
    end
    if index == 3 then
     self._scene.m_card = 3   --所在关卡
     self._scene:sendReadyMsg2()  --发送关卡数据
       for i = 1 , 5 do                --显示下面分数文本
          self.text_score3[i]:setVisible(true)
          self.text_score3[self.button_num]:setVisible(false) 
          self.text_score03[self.button_num]:setVisible(true) 
          self.text_score3[i]:setString(self._scene.data[3][i])
          self.text_score03[i]:setString(self._scene.data[3][i])
          local frameName1 = string.format(GameViewLayer.RES_GAME2 .."image_1%d.png",1)  --
          local frameName0 = string.format(GameViewLayer.RES_GAME2 .."image_0%d.png",rand)
          if self._scene.data[3][i] == 0 then
          frameName0 = string.format(GameViewLayer.RES_GAME2 .."image_0%d.png",0)
          end
          self.image_k4[i]:loadTexture(frameName1)
          self.image_k3[i]:loadTexture(frameName0)
       end
       if  self.NumScore == 0 then 
           print("炸弹 退出游戏")
           ExternalFun.playSoundEffect("xiaoyouxizhadan.wav")
           self.image_k3[self.button_num]:loadTexture(GameViewLayer.RES_GAME2 .."image_10")  --本层点击的还是亮的  炸弹
           --结束界面显示 两秒后切换
           self.Cearing:setVisible(true)
           self.Allscore:setVisible(true)
           self.Allscore:setString(self._scene.m_lGetCoins3)
           self:runAction(
	          cc.Sequence:create(
	        --  cc.DelayTime:create(2),
	          cc.CallFunc:create(function()
              self:backOneGame()
              self._scene:sendThreeEnd()  --发送结束
	        end)
	        )
		  )

       else
          print("加分 进入下一关")  --先进入翻牌动画 一秒  1.5秒进入下一关    
          local frameName1 = string.format(GameViewLayer.RES_GAME2 .."image_1%d.png",rand)    
         self.image_k3[self.button_num]:loadTexture(frameName1)  --本层点击的还是亮的 

          for i = 11,20 do
             if i>15 then
               self["Button_"..i]:setEnabled(true)
             else
               self["Button_"..i]:setEnabled(false)
             end
         end
         self.m_textGetScore:setString(self._scene.m_lGetCoins3)
       
       end
    end
    if index == 4 then
     self._scene.m_card = 4   --所在关卡
     self._scene:sendReadyMsg2()  --发送关卡数据
       for i = 1 , 5 do                --显示下面分数文本
          self.text_score4[i]:setVisible(true)
          self.text_score4[self.button_num]:setVisible(false) 
          self.text_score04[self.button_num]:setVisible(true) 
          self.text_score4[i]:setString(self._scene.data[4][i])
          self.text_score04[i]:setString(self._scene.data[4][i])
          local frameName0 = string.format(GameViewLayer.RES_GAME2 .."image_0%d.png",rand)
          if self._scene.data[4][i] == 0 then
          frameName0 = string.format(GameViewLayer.RES_GAME2 .."image_0%d.png",0)
          end
         self.image_k4[i]:loadTexture(frameName0)
       end
       if  self.NumScore == 0 then 
          print("炸弹 退出游戏")
          ExternalFun.playSoundEffect("xiaoyouxizhadan.wav")
          self.image_k4[self.button_num]:loadTexture(GameViewLayer.RES_GAME2 .."image_10")  --本层点击的还是亮的 
           --结束界面显示 两秒后切换
          self.Cearing:setVisible(true)
          self.Allscore:setVisible(true)
          self.Allscore:setString(self._scene.m_lGetCoins3)
    	  self:runAction(
		      cc.Sequence:create(
		 --  cc.DelayTime:create(2),
		   cc.CallFunc:create(function()
              self:backOneGame()
              self._scene:sendThreeEnd()  --发送结束
		   end)
		   )
	   )
       else
          print("加分 最后一关 ，退出游戏")
          local frameName1 = string.format(GameViewLayer.RES_GAME2 .."image_1%d.png",rand)
          self.image_k4[self.button_num]:loadTexture(frameName1)  --本层点击的还是亮的 

         for i = 16,20 do
           self["Button_"..i]:setEnabled(false)
         end
           self.m_textGetScore:setString(self._scene.m_lGetCoins3)  --显示分数
           self.Cearing:setVisible(true)
           self.Allscore:setVisible(true)
           self.Allscore:setString(self._scene.m_lGetCoins3)
           self:runAction(
	           cc.Sequence:create(
	        --   cc.DelayTime:create(2),
	           cc.CallFunc:create(function()
               self:backOneGame()
               self._scene:sendThreeEnd()  --发送结束
	         end)
	         )
		   )
       end
    end

end


--计时器刷新
function Game2ViewLayer:OnUpdataClockView(viewId, time,chairID)

		self.Text_Clock:setString(time)
        if time <= 0 then
        self._scene:sendThreeEnd()  --发送结束
        self:backOneGame()
        end
end

function Game2ViewLayer:backOneGame()
 
	--切换回第一个游戏
	local gameview = self._scene._gameView
	gameview:setPosition(0,0)
	gameview:setVisible(true)
    --播放主游戏背景音乐
    ExternalFun.playBackgroudAudio("beijingyinyue.mp3")

	self._scene:setGameMode(0) --GAME_STATE_WAITTING
    self._scene.m_lCoins = self._scene.m_lCoins + self._scene.m_lGetCoins3

    gameview.m_textScore:setString(self._scene.m_lCoins)     --self._scene:GetMeUserItem().lScore
	self:removeFromParent()  --从父节点移除

	if gameview._scene.m_bIsAuto == true  then
		gameview:runAction(
			cc.Sequence:create(
		--		cc.DelayTime:create(1),
				cc.CallFunc:create(function( )
                    gameview._scene:onGameStart()
                    gameview._scene.m_cbGameStatus = g_var(cmd).SHZ_GAME_SCENE_FREE
                    --gameview._scene:setGameMode(4) --GAME_STATE.GAME_STATE_WAITTING_GAME2
				end)
				)
			)
	end

end

return GameViewLayer