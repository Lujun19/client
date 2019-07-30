local EarnLayer = class("EarnLayer", cc.BaseLayer)

local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local ClipText = appdf.req(appdf.EXTERNAL_SRC .. "ClipText")
local MultiPlatform = appdf.req(appdf.EXTERNAL_SRC .. "MultiPlatform")
function EarnLayer:ctor(pageindex)
	self.super.ctor(self)

	self._pageDefaultIndex = pageindex or 0
    -- 加载csb资源
	local csbPath = "Earn/EarnLayer3.csb"
    local rootLayer, csbNode = appdf.loadRootCSB(csbPath,self)
	self._csbNode = csbNode
	-- 加载csb动画
	self._csbNodeAni = appdf.loadTimeLine(csbPath)
	self._csbNode:stopAllActions()
	self._csbNode:runAction(self._csbNodeAni)

	self:attach("M2V_ShowToast", function (e, msg)
		showToast(self, msg, 2)
	end)
end

--初始化主界面
function EarnLayer:initUI()
	--返回按钮
	self._return = ExternalFun.seekWigetByName(self._csbNode,"Button_return")
    self._return:setPressedActionEnabled(true)
    self._return:addClickEventListener(handler(self, self.onButtonClickedEvent))



    --携带金币
    self._txtScore = ExternalFun.seekWigetByName(self._csbNode,"atlas_coin")
	local str = string.formatNumberTThousands(GlobalUserItem.lUserScore)
	if string.len(str) > 11 then
		str = string.sub(str, 1, 11) .. "..."
	end
	if (GlobalUserItem.lUserScore < 10000) then
		self._txtScore:setString(str)
	elseif (GlobalUserItem.lUserScore >= 10000 and GlobalUserItem.lUserScore < 100000000) then
		self._txtScore:setString(str .. "万")
	elseif (GlobalUserItem.lUserScore >= 100000000) then
		self._txtScore:setString(str .. "亿")
	end

	--注册UI监听事件
	self:attach("M2V_Update_UserScore", function (e, score)
		local str = string.formatNumberTThousands(score)  --MXM更新大厅银行金币
		if string.len(str) > 11 then
			str = string.sub(str, 1, 11) .. "..."
		end

		if (score < 10000) then
			self._txtScore:setString(str)
		elseif (score >= 10000 and score < 100000000) then
			self._txtScore:setString(str .. "万")
		elseif (score >= 100000000) then
			self._txtScore:setString(str .. "亿")
		end
	end)


    --银行金币
    self._txtInsure = ExternalFun.seekWigetByName(self._csbNode,"atlas_bankscore")

    str = string.formatNumberTThousands(GlobalUserItem.lUserInsure)  --MXM更新大厅银行金币
	if string.len(str) > 11 then
		str = string.sub(str, 1, 11) .. "..."
	end

	if (GlobalUserItem.lUserInsure < 10000) then
		self._txtInsure:setString(str)
	elseif (GlobalUserItem.lUserInsure >= 10000 and GlobalUserItem.lUserInsure < 100000000) then
		self._txtInsure:setString(str .. "万")
	elseif (GlobalUserItem.lUserInsure >= 100000000) then
		self._txtInsure:setString(str .. "亿")
	end

	--银行金币
	--注册UI监听事件
	self:attach("M2V_Update_InsureScore", function (e, score)
		local str = string.formatNumberTThousands(score)  --MXM更新大厅银行金币
		if string.len(str) > 11 then
			str = string.sub(str, 1, 11) .. "..."
		end

		if (score < 10000) then
			self._txtInsure:setString(str)
		elseif (score >= 10000 and score < 100000000) then
			self._txtInsure:setString(str .. "万")
		elseif (score >= 100000000) then
			self._txtInsure:setString(str .. "亿")
		end
	end)


	local appConfigProxy = AppFacade:getInstance():retrieveProxy("AppConfigProxy")

	--左侧单选按钮组
    self._radioLeftMenuButtonGroup = ccui.RadioButtonGroup:create()
    self._radioLeftMenuButtonGroup:setAllowedNoSelection(false)
    self:addChild(self._radioLeftMenuButtonGroup)
	--分享
	local rto_container_1 = ExternalFun.seekWigetByName(self._csbNode,"radio_container_1")
	local rto_container_1_size = rto_container_1:getContentSize()
	self.m_rto1 = ccui.RadioButton:create("btn_earn_share_0.png","btn_earn_share_0.png","btn_earn_share_1.png","btn_earn_share_0.png","btn_earn_share_0.png", ccui.TextureResType.plistType)
	self.m_rto1:addEventListener(handler(self, self.onSelectedEvent))
	self.m_rto1:setPosition(rto_container_1_size.width / 2, rto_container_1_size.height / 2)
	self.m_rto1:setName("rto_earn_1")
	rto_container_1:addChild(self.m_rto1)
	self._radioLeftMenuButtonGroup:addRadioButton(self.m_rto1)

	--我的佣金
	local rto_container_2 = ExternalFun.seekWigetByName(self._csbNode,"radio_container_2")
	local rto_container_2_size = rto_container_2:getContentSize()
	self.m_rto2 = ccui.RadioButton:create("btn_earn_my_detail_0.png","btn_earn_my_detail_0.png","btn_earn_my_detail_1.png","btn_earn_my_detail_0.png","btn_earn_my_detail_0.png", ccui.TextureResType.plistType)
	self.m_rto2:addEventListener(handler(self, self.onSelectedEvent))
	self.m_rto2:setPosition(rto_container_2_size.width / 2, rto_container_2_size.height / 2)
	self.m_rto2:setName("rto_earn_2")
	rto_container_2:addChild(self.m_rto2)
	self._radioLeftMenuButtonGroup:addRadioButton(self.m_rto2)

	--说明
	local rto_container_3 = ExternalFun.seekWigetByName(self._csbNode,"radio_container_3")
	local rto_container_3_size = rto_container_3:getContentSize()
	self.m_rto3 = ccui.RadioButton:create("btn_earn_intro_0.png","btn_earn_intro_0.png","btn_earn_intro_1.png","btn_earn_intro_0.png","btn_earn_intro_0.png", ccui.TextureResType.plistType)
	self.m_rto3:addEventListener(handler(self, self.onSelectedEvent))
	self.m_rto3:setPosition(rto_container_3_size.width / 2, rto_container_3_size.height / 2)
	self.m_rto3:setName("rto_earn_3")
	rto_container_3:addChild(self.m_rto3)
	self._radioLeftMenuButtonGroup:addRadioButton(self.m_rto3)

	--提现详情
	local rto_container_4 = ExternalFun.seekWigetByName(self._csbNode,"radio_container_4")
	local rto_container_4_size = rto_container_4:getContentSize()
	self.m_rto4 = ccui.RadioButton:create("btn_earn_take_detail_0.png","btn_earn_take_detail_0.png","btn_earn_take_detail_1.png","btn_earn_take_detail_0.png","btn_earn_take_detail_0.png", ccui.TextureResType.plistType)
	self.m_rto4:addEventListener(handler(self, self.onSelectedEvent))
	self.m_rto4:setPosition(rto_container_4_size.width / 2, rto_container_4_size.height / 2)
	self.m_rto4:setName("rto_earn_4")
	rto_container_4:addChild(self.m_rto4)
	self._radioLeftMenuButtonGroup:addRadioButton(self.m_rto4)

	--VIP详情
	local rto_container_5 = ExternalFun.seekWigetByName(self._csbNode,"radio_container_5")
	local rto_container_5_size = rto_container_5:getContentSize()
	self.m_rto5 = ccui.RadioButton:create("btn_earn_vip_detail_0.png","btn_earn_vip_detail_0.png","btn_earn_vip_detail_1.png","btn_earn_vip_detail_0.png","btn_earn_vip_detail_0.png", ccui.TextureResType.plistType)
	self.m_rto5:addEventListener(handler(self, self.onSelectedEvent))
	self.m_rto5:setPosition(rto_container_5_size.width / 2, rto_container_5_size.height / 2)
	self.m_rto5:setName("rto_earn_5")
	-- rto_container_5:addChild(self.m_rto5)
	-- self._radioLeftMenuButtonGroup:addRadioButton(self.m_rto5)

	--代理详情
	local rto_container_6 = ExternalFun.seekWigetByName(self._csbNode,"radio_container_6")
	local rto_container_6_size = rto_container_6:getContentSize()
	self.m_rto6 = ccui.RadioButton:create("btn_earn_agent_detail_0.png","btn_earn_agent_detail_0.png","btn_earn_agent_detail_1.png","btn_earn_agent_detail_0.png","btn_earn_agent_detail_0.png", ccui.TextureResType.plistType)
	self.m_rto6:addEventListener(handler(self, self.onSelectedEvent))
	self.m_rto6:setPosition(rto_container_6_size.width / 2, rto_container_6_size.height / 2)
	self.m_rto6:setName("rto_earn_6")
	-- rto_container_6:addChild(self.m_rto6)
	-- self._radioLeftMenuButtonGroup:addRadioButton(self.m_rto6)
	self:initLayout1UI()
	self:initLayout2UI()
	self:initLayout3UI()
	self:initLayout4UI()






end

function EarnLayer:loadWeb(url, webContent)
	local targetPlatform = cc.Application:getInstance():getTargetPlatform()
	LogAsset:getInstance():logData("url="..url)
	if (nil ~= self._webView) then
		self._webView:removeFromParent()
	end

    if (cc.PLATFORM_OS_IPHONE == targetPlatform) or (cc.PLATFORM_OS_IPAD == targetPlatform) or (cc.PLATFORM_OS_ANDROID == targetPlatform) then
        --介绍页面
		self:showPopWait()
        self._webView = ccexp.WebView:create()
		self._webView:setName("EarnMoneyWebView")
		self._webView:setContentSize(webContent:getContentSize())
        self._webView:setPosition(cc.p(webContent:getContentSize().width / 2, webContent:getContentSize().height / 2))
        self._webView:setScalesPageToFit(true)

        self._webView:loadURL(url)
        --self._webView:setJavascriptInterfaceScheme("http")

        self._webView:setOnDidFailLoading(function ( sender, url )
            self:dismissPopWait()
            print("open " .. url .. " fail")
        end)
        self._webView:setOnShouldStartLoading(function(sender, url)
            print("onWebViewShouldStartLoading, url is ", url)
            return true
        end)
        self._webView:setOnDidFinishLoading(function(sender, url)
            self:dismissPopWait()
        end)
--[[        self._webView:setOnJSCallback(function ( sender, url )
            if url == "http://param:close" then
                self._scene:dismissPopWait()
                self:removeFromParent()
            else
                self._scene:queryUserScoreInfo(function(ok)
                    if ok then
                        self._webView:reload()
                    end
                end)
            end
        end)
--]]
        webContent:addChild(self._webView)
	else
		webContent:setBackGroundColorType(ccui.LayoutBackGroundColorType.solid)
		webContent:setBackGroundColor(cc.c3b(255, 0, 255))
    end
end


--初始化存款界面
function EarnLayer:initLayout1UI()
    --游戏币存
    self._layout_1 = ExternalFun.seekWigetByName(self._csbNode,"layout_1")


	--local ostime = os.time()
	--local url = BaseConfig.WEB_HTTP_URL .. "/Mobile/MarketCount.aspx?userid=" .. GlobalUserItem.dwUserID .. "&signature=" .. GlobalUserItem:getSignature(ostime) .. "&time=" ..ostime
	--self:loadWeb(url, self._layout_1)
	local qrcode_bg = ExternalFun.seekWigetByName(self._layout_1, "Image_2")
	local bgsize = qrcode_bg:getContentSize()
	local shareurl = GlobalUserItem.getShareUrl()
	self._qrcode = QrNode:createQrNode(shareurl, bgsize.width - 20, 5, 1)
	self._qrcode:setPosition(bgsize.width*0.5 , bgsize.height*0.5 )
    qrcode_bg:addChild(self._qrcode)

	local save_qrcode = ExternalFun.seekWigetByName(self._layout_1, "Button_2")
    save_qrcode:setPressedActionEnabled(true)
	save_qrcode:addClickEventListener(handler(self, self.onButtonClickedEvent))
	if (BaseConfig.AGENT_IDENTIFICATION == "yunding_dl9") then
		save_qrcode:setVisible(false)
	end

	local text_share_url = ExternalFun.seekWigetByName(self._layout_1, "Text_2")
	text_share_url:setString(shareurl)

	self.earn_takerecored = ExternalFun.seekWigetByName(self._layout_1,"earn_takerecored")
	self.earn_takerecored:setPressedActionEnabled(true)
  self.earn_takerecored:addClickEventListener(handler(self, self.onButtonClickedEvent))



	self.layout_Show_Pic = ExternalFun.seekWigetByName(self._csbNode, "layout_Show_Pic")
	self.layout_Show_Pic_close = ExternalFun.seekWigetByName(self.layout_Show_Pic,"layout_Show_Pic_close")
	self.layout_Show_Pic_close:setPressedActionEnabled(true)
  self.layout_Show_Pic_close:addClickEventListener(handler(self, self.onButtonClickedEvent))

	local qrcode_bg2 = ExternalFun.seekWigetByName(self.layout_Show_Pic, "Image_2")
	local bgsize = qrcode_bg2:getContentSize()
	local shareurl = GlobalUserItem.getShareUrl()
	self._qrcode2 = QrNode:createQrNode(shareurl, bgsize.width - 20, 5, 1)
	self._qrcode2:setPosition(bgsize.width*0.5 , bgsize.height*0.5 )
    qrcode_bg2:addChild(self._qrcode2)


--    text_share_url_size = text_share_url:getContentSize()


--        self.edit_1 = ccui.EditBox:create(text_share_url_size, ccui.Scale9Sprite:create("public/text_field_space.png"))
--		:move(text_share_url_size.width / 2, text_share_url_size.height / 2)
--		:setFontName("base/fonts/round_body.ttf")
--		:setPlaceholderFontName("base/fonts/round_body.ttf")
--		:setFontSize(32)
--		:setPlaceholderFontSize(32)
--		:setMaxLength(13)
--		:setAnchorPoint(cc.p(0.5, 0.5))
--		:setFontColor(cc.c4b(255,255,255,255))
--		:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE)
--		:setPlaceHolder("请输入分享地址...")
--		:addTo(text_share_url)

	local copy_share_url = ExternalFun.seekWigetByName(self._layout_1, "Button_3")
    copy_share_url:setPressedActionEnabled(true)
	copy_share_url:addClickEventListener(handler(self, self.onButtonClickedEvent))



	local wechatBtn = ExternalFun.seekWigetByName(self._layout_1,"Button_btn_wechat")
	wechatBtn:setPressedActionEnabled(true)
	wechatBtn:addClickEventListener(handler(self, self.onButtonClickedEvent))

	wechatBtn2 = ExternalFun.seekWigetByName(self._layout_1,"Button_btn_cir")
	wechatBtn2:setPressedActionEnabled(true)
	wechatBtn2:addClickEventListener(handler(self, self.onButtonClickedEvent))


    --二维码生成

local bg = self._csbNode:getChildByName("bg")
	local layout_agent = bg:getChildByName("layout_1")
    self:Webview()
    self:attach("M2V_QueryAgentResult_User", function (e, agentlist)
        local listView = layout_agent:getChildByName("ListView_1");
		listView:removeAllItems()
		listView:removeAllItems()
        local itemLayoutTemplate = layout_agent:getChildByName("AgentRechargeItemLayout")
        local itemLayoutTemplateChildrens = itemLayoutTemplate:getChildren()
        local itemLayout = nil
		for i=1,#agentlist do
			local itemInfo = agentlist[i]
            local index = (i - 1) % #itemLayoutTemplateChildrens;
            	local item = {}
			    item.gameid = agentlist[i]["gameid"]
            if (index == 0) then
                itemLayout = itemLayoutTemplate:clone()
               listView:pushBackCustomItem(itemLayout)
            end
            local qrcode_bg = itemLayout:getChildByName(string.format("agent_item_%d", index))
            local bgsize = qrcode_bg:getContentSize()
        	local shareurl = GlobalUserItem.getShareUrl_New(item.gameid)
	        self._qrcode = QrNode:createQrNode(shareurl, bgsize.width - 20, 5, 1)
	        self._qrcode:setPosition(bgsize.width*0.5 , bgsize.height*0.5 )
            qrcode_bg:addChild(self._qrcode)
		    qrcode_bg :setVisible(true)
			    :addTouchEventListener(function(ref, type)
                    if type == ccui.TouchEventType.ended then
                        self:onAgentButtonClickedEvent(ref, itemInfo)
                          local text_share_url = ExternalFun.seekWigetByName(self._layout_1, "Text_2")
                     text_share_url:setString("")
	                text_share_url:setString(shareurl)
        	        end

                end)
		end
	end)
end
function EarnLayer:Webview()
      local url = BaseConfig.WEB_HTTP_URL .. "/WS/Account.ashx"
    AppFacade:getInstance():sendNotification(GAME_COMMAMD.PUSH_VIEW, {ctor = {"操作中..."}, canrepeat = false}, VIEW_LIST.POPWAIT_LAYER)
    appdf.onHttpJsionTable(url ,"GET","action=getchild&gameid=" .. GlobalUserItem.dwGameID,function(jstable,jsdata)
		--dump(jstable, "jstable", 7)
		AppFacade:getInstance():sendNotification(GAME_COMMAMD.POP_VIEW, {Name = VIEW_LIST.POPWAIT_LAYER})
		local errmsg = ""
        printf("modify load finished\n************************************************************")
			local code = jstable["code"]
			if tonumber(code) == 1 then
				local msg = jstable["msg"]
				errmsg = ""
		        errmsg = msg
			local list = jstable["msg"]
			            local agentRechargeList = {}
							for i=1,#list do
								local item = {}
								item.gameid = msg[i]["gameid"]
                             	table.insert(agentRechargeList, item)
							end
							self:emit("M2V_QueryAgentResult_User", agentRechargeList)
			end

		if type(errmsg) == "string" and "" ~= errmsg then
        end
    end)
end

   --按键监听
function EarnLayer:onAgentButtonClickedEvent(sender, itemInfo)

end

--初始化取款界面
function EarnLayer:initLayout2UI()
    self._layout_2 = ExternalFun.seekWigetByName(self._csbNode,"layout_2")
end

--初始化存取款记录界面
function EarnLayer:initLayout3UI()
	--游戏币取
    self._layout_3 = ExternalFun.seekWigetByName(self._csbNode,"layout_3")
end

--初始化存取款记录界面
function EarnLayer:initLayout4UI()
	--游戏币取
    self._layout_4 = ExternalFun.seekWigetByName(self._csbNode,"layout_4")
end

--初始化存取款记录界面
function EarnLayer:initLayout5UI()
	--游戏币取
    self._layout_5 = ExternalFun.seekWigetByName(self._csbNode,"layout_5")
end

--初始化存取款记录界面
function EarnLayer:initLayout6UI()
	--游戏币取
    self._layout_6 = ExternalFun.seekWigetByName(self._csbNode,"layout_6")
end

function EarnLayer:onWillViewEnter()
	self:initUI()
	self._csbNodeAni:setAnimationEndCallFunc("openAni", function ()
        self:enterViewFinished()
				AppFacade:getInstance():sendNotification(GAME_COMMAMD.PLAY_ONE_EFFECT, {}, "sound/zhuanjin.mp3")
			self._csbNodeAni:play("show_layout_1", false)
	end)


	self._csbNodeAni:play("openAni", false)




end

function EarnLayer:onWillViewExit()
	if (nil ~= self._webView) then
		self._webView:removeFromParent()
	end

	self._csbNodeAni:setAnimationEndCallFunc("closeAni", function ()
		self:exitViewFinished()
	end)
	self._csbNodeAni:play("closeAni", false)
end

function EarnLayer:onEnterTransitionFinish( )

end

function EarnLayer:onExit()

end

--按键监听
function EarnLayer:onButtonClickedEvent(sender)
	ExternalFun.playClickEffect()

	local senderName = sender:getName()

	if (senderName == "Button_return") then
		AppFacade:getInstance():sendNotification(GAME_COMMAMD.POP_VIEW, {Name = VIEW_LIST.EARN_LAYER})


 elseif (senderName == "layout_Show_Pic_close") then

	  self.layout_Show_Pic:setVisible(false);

	elseif (senderName == "earn_takerecored") then
		-- AppFacade:getInstance():sendNotification(GAME_COMMAMD.POP_VIEW, {Name = VIEW_LIST.EARN_LAYER})



		AppFacade:getInstance():sendNotification(GAME_COMMAMD.PUSH_VIEW, {}, VIEW_LIST.DUIHUAN_LAYER)




 elseif senderName == "Button_3" then

		 -- AppFacade:getInstance():sendNotification(GAME_COMMAMD.PUSH_VIEW, {}, VIEW_LIST.DUIHUAN_LAYER)

		 self.layout_Show_Pic:setVisible(true);

	elseif senderName == "Button_btn_wechat" then
				local function sharecall( isok )
						if type(isok) == "string" and isok == "true" then
								showToast(self, "分享完成", 1)
						end
				end
				local url = GlobalUserItem.getShareUrl()
				MultiPlatform:getInstance():shareToTarget(yl.ThirdParty.WECHAT, sharecall, GlobalUserItem.szWXShareTitle, GlobalUserItem.szWXShareContent, url)
	elseif senderName == "Button_btn_cir" then
		local function sharecall( isok )
						if type(isok) == "string" and isok == "true" then
								showToast(self, "分享完成", 1)
						end
				end
				local url = GlobalUserItem.getShareUrl()
				MultiPlatform:getInstance():shareToTarget(yl.ThirdParty.WECHAT_CIRCLE, sharecall, GlobalUserItem.szWXShareTitle, GlobalUserItem.szWXShareContent, url)
	elseif senderName == "Button_btn_cir" then
		local function sharecall( isok )
						if type(isok) == "string" and isok == "true" then
								showToast(self, "分享完成", 1)
						end
				end
				local url = GlobalUserItem.getShareUrl()
				MultiPlatform:getInstance():shareToTarget(yl.ThirdParty.SMS, sharecall, yl.SocialShare.title, url)




	elseif (senderName == "Button_2") or (senderName == "Button_1")  then
		local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame("img_qrcode_bg_mask.png")
		if nil == frame then
			return
		end

		local imgSize = frame:getOriginalSize()

		local save_file_name = "qrcode.png"
		local save_file_path = cc.FileUtils:getInstance():getWritablePath()

		local function viewcallback(view, state)
			if (state == "enter") then
				local renderTexture = cc.RenderTexture:create(imgSize.width, imgSize.height)
				renderTexture:beginWithClear(0,0,0,0)

				local backGroundNode = cc.Sprite:createWithSpriteFrame(frame)

				backGroundNode:setPosition(cc.p(imgSize.width / 2, imgSize.height / 2))

				if backGroundNode then
					backGroundNode:visit()
				end
--				if (senderName == "Button_1") then
--                local target_url = ""
--                target_url = BaseConfig.WEB_HTTP_URL
--		        local url =  self.edit_1:getText()--ExternalFun.seekWigetByName(self._layout_1, "Text_2"):getString()
--                local shareurl = "http://" .. GlobalUserItem.dwGameID .. "." .. target_url .. "/?t=" .. os.time()
--                else
				local shareurl = GlobalUserItem.getShareUrl()
--                end
				local qrRenderNode = QrNode:createQrNode(shareurl, 300, 5, 1)
				--qrRenderNode:setPosition(cc.p(1069, 354))
                qrRenderNode:setPosition(cc.p(1069, 354))

				if qrRenderNode then
					qrRenderNode:visit()
				end

				renderTexture:endToLua()

				--由于引擎异步渲染 Lua没有绑定C++ Lam表达式 导致手动绑定 造成bin文件不对应 在某些旧版本bin 并不支持该接口
				local saveRet = renderTexture:saveToFile(save_file_name, cc.IMAGE_FORMAT_PNG, true, function (obj1, path)
					AppFacade:getInstance():sendNotification(GAME_COMMAMD.POP_VIEW, {Name = VIEW_LIST.ROATEWAIT_LAYER})
					local ret, msg = MultiPlatform:getInstance():saveImgToSystemGallery(save_file_path .. save_file_name, save_file_name)
					if true == true then
						--界面回调
						--local delayAction = cc.DelayTime:create(0.5)
						local callAction_1 = cc.CallFunc:create(function ()
							--处理动画
							local image_qr = ExternalFun.seekWigetByName(self._csbNode, "qr_bg_1")
							image_qr:loadTexture(save_file_path .. save_file_name)

							local qr_ani_node = ExternalFun.seekWigetByName(self._csbNode, "qr_ani_node")

							if (qr_ani_node) then
								local act = qr_ani_node:getActionByTag(qr_ani_node:getTag())
								act:setAnimationEndCallFunc("save_action", function ()
									--移除缓存
									cc.Director:getInstance():getTextureCache():removeTextureForKey(save_file_path .. save_file_name)
								end)
								act:play("save_action", false)
							end
						end)
						local callAction_2 = cc.CallFunc:create(function ()
							showToast(self, "您的代理推广精美广告图已保存到您手机相册！", 1)
						end)
						local seqAction = cc.Sequence:create(callAction_1, callAction_2)
						self:runAction(seqAction)
					else
						showToast(self, msg, 2)
					end
				end)
			end
		end

        local function viewcallback_0(view, state)
			if (state == "enter") then
				local renderTexture = cc.RenderTexture:create(imgSize.width, imgSize.height)
				renderTexture:beginWithClear(0,0,0,0)

				local backGroundNode = cc.Sprite:createWithSpriteFrame(frame)

				backGroundNode:setPosition(cc.p(imgSize.width / 2, imgSize.height / 2))

				if backGroundNode then
					backGroundNode:visit()
				end
--				if (senderName == "Button_1") then
                local target_url = ""
                target_url = BaseConfig.WEB_HTTP_URL
		        local shareurl =  ExternalFun.seekWigetByName(self._layout_1, "Text_2"):getString()
				local qrRenderNode = QrNode:createQrNode(shareurl, 300, 5, 1)
                qrRenderNode:setPosition(cc.p(1069, 354))

				if qrRenderNode then
					qrRenderNode:visit()
				end

				renderTexture:endToLua()

				--由于引擎异步渲染 Lua没有绑定C++ Lam表达式 导致手动绑定 造成bin文件不对应 在某些旧版本bin 并不支持该接口
				local saveRet = renderTexture:saveToFile(save_file_name, cc.IMAGE_FORMAT_PNG, true, function (obj1, path)
					AppFacade:getInstance():sendNotification(GAME_COMMAMD.POP_VIEW, {Name = VIEW_LIST.ROATEWAIT_LAYER})
					local ret, msg = MultiPlatform:getInstance():saveImgToSystemGallery(save_file_path .. save_file_name, save_file_name)
					if true == true then
						--界面回调
						--local delayAction = cc.DelayTime:create(0.5)
						local callAction_1 = cc.CallFunc:create(function ()
							--处理动画
							local image_qr = ExternalFun.seekWigetByName(self._csbNode, "qr_bg_1")
							image_qr:loadTexture(save_file_path .. save_file_name)

							local qr_ani_node = ExternalFun.seekWigetByName(self._csbNode, "qr_ani_node")

							if (qr_ani_node) then
								local act = qr_ani_node:getActionByTag(qr_ani_node:getTag())
								act:setAnimationEndCallFunc("save_action", function ()
									--移除缓存
									cc.Director:getInstance():getTextureCache():removeTextureForKey(save_file_path .. save_file_name)
								end)
								act:play("save_action", false)
							end
						end)
						local callAction_2 = cc.CallFunc:create(function ()
							showToast(self, "您的代理推广精美广告图已保存到您手机相册！", 1)
						end)
						local seqAction = cc.Sequence:create(callAction_1, callAction_2)
						self:runAction(seqAction)
					else
						showToast(self, msg, 2)
					end
				end)
			end
		end
		if (senderName == "Button_1") then
		AppFacade:getInstance():sendNotification(GAME_COMMAMD.PUSH_VIEW, {ctor = {"精美宣传图生成中，请稍后..."}, viewcallback = viewcallback_0, canrepeat = false}, VIEW_LIST.ROATEWAIT_LAYER)
		else
        AppFacade:getInstance():sendNotification(GAME_COMMAMD.PUSH_VIEW, {ctor = {"精美宣传图生成中，请稍后..."}, viewcallback = viewcallback, canrepeat = false}, VIEW_LIST.ROATEWAIT_LAYER)
        end
	--elseif (senderName == "Button_1") then
		--local url =  self.edit_1:getText()--ExternalFun.seekWigetByName(self._layout_1, "Text_2"):getString()
		--local shareContent = string.format(GlobalUserItem.szEarnShareContent, url)
		--AppFacade:getInstance():sendNotification(GAME_COMMAMD.PUSH_VIEW, {ctor = {shareContent}}, VIEW_LIST.SELECT_LINK_LAYER)
	end
end

function EarnLayer:onSelectedEvent(sender,eventType)
	local senderName = sender:getName()
	if (ccui.RadioButtonEventType.selected == eventType) then
		ExternalFun.playClickEffect()

		if (senderName == "rto_earn_1") then
			self._csbNodeAni:play("show_layout_1", false)

			if (nil ~= self._webView) then
				self._webView:removeFromParent()
				self._webView = nil
			end
		elseif (senderName == "rto_earn_2") then
			self._csbNodeAni:play("show_layout_2", false)

			local ostime = os.time()
			local url = BaseConfig.WEB_HTTP_URL .. "/Mobile/Spread/Info.html?userid=" .. GlobalUserItem.dwUserID .. "&signature=" .. GlobalUserItem:getSignature(ostime) .. "&time=" ..ostime
			LogAsset:getInstance():logData(cjson.encode("rto_earn_2url"),true)
			LogAsset:getInstance():logData(cjson.encode(url),true)

			self:loadWeb(url, self._layout_2:getChildByName("content"))
		elseif (senderName =="rto_earn_3") then
			self._csbNodeAni:play("show_layout_3", false)

			local ostime = os.time()
			local url = BaseConfig.WEB_HTTP_URL .. "/Mobile/Spread/Describe.html"

			LogAsset:getInstance():logData(cjson.encode("rto_earn_3url"),true)
			LogAsset:getInstance():logData(cjson.encode(url),true)

			-- self:loadWeb(url, self._layout_3)
			self:loadWeb(url, self._layout_3:getChildByName("content"))
		elseif (senderName =="rto_earn_4") then
			self._csbNodeAni:play("show_layout_4", false)

			local ostime = os.time()
			local url = BaseConfig.WEB_HTTP_URL .. "/Mobile/Spread/Withdrawals.html?userid=" .. GlobalUserItem.dwUserID .. "&signature=" .. GlobalUserItem:getSignature(ostime) .. "&time=" ..ostime


			LogAsset:getInstance():logData(cjson.encode("rto_earn_4url"),true)
			LogAsset:getInstance():logData(cjson.encode(url),true)

			-- self:loadWeb(url, self._layout_4)
			self:loadWeb(url, self._layout_4:getChildByName("content"))
		elseif (senderName =="rto_earn_5") then
			self._csbNodeAni:play("show_layout_5", false)

			local ostime = os.time()
			local url = BaseConfig.WEB_HTTP_URL .. "/Mobile/Spread/LowerMember.html?userid=" .. GlobalUserItem.dwUserID .. "&signature=" .. GlobalUserItem:getSignature(ostime) .. "&time=" ..ostime


			self:loadWeb(url, self._layout_5)
		elseif (senderName =="rto_earn_6") then
			self._csbNodeAni:play("show_layout_6", false)

			local ostime = os.time()
			local url = BaseConfig.WEB_HTTP_URL .. "/Mobile/Spread/LowerAgent.html?userid=" .. GlobalUserItem.dwUserID .. "&signature=" .. GlobalUserItem:getSignature(ostime) .. "&time=" ..ostime


			self:loadWeb(url, self._layout_6)
		else
			assert(false, "undefine radio event")
		end
	end
end

function EarnLayer:showPopWait()
	AppFacade:getInstance():sendNotification(GAME_COMMAMD.PUSH_VIEW, {ctor = {"请稍候！"}, canrepeat = false}, VIEW_LIST.POPWAIT_LAYER)
end

--关闭等待
function EarnLayer:dismissPopWait()
	AppFacade:getInstance():sendNotification(GAME_COMMAMD.POP_VIEW, {Name = VIEW_LIST.POPWAIT_LAYER})
end

return EarnLayer
