--
-- Author: tom
-- Date: 2017-02-27 17:26:42
--
local SetLayer = class("SetLayer", function(scene)
	local setLayer = display.newLayer()
	return setLayer
end)

local cmd = appdf.req(appdf.GAME_SRC.."yule.zhajinhua.src.models.CMD_Game")
local ExternalFun = require(appdf.EXTERNAL_SRC .. "ExternalFun")

local TAG_BT_MUSICON = 1
local TAG_BT_MUSICOFF = 2
local TAG_BT_EFFECTON = 3
local TAG_BT_EFFECTOFF = 4
local TAG_BT_EXIT = 5

function SetLayer:onInitData()
end

function SetLayer:onResetData()
end

local this
function SetLayer:ctor(scene)
	this = self
	self._scene = scene
	self:onInitData()

	self.colorLayer = cc.LayerColor:create(cc.c4b(0, 0, 0, 125))
		:setContentSize(display.width, display.height)
		:addTo(self)
	self.colorLayer:setTouchEnabled(false)
	self.colorLayer:registerScriptTouchHandler(function(eventType, x, y)
		return this:onTouch(eventType, x, y)
	end)

	local funCallback = function(ref)
		this:onButtonCallback(ref:getTag(), ref)
	end

	--UI
	self.sp_layerBg = display.newSprite("#sp_setLayerBg_zjh.png")
		:move(display.center)
		:addTo(self)

	self.btMusicOn = ccui.Button:create("bt_on_zjh_0.png","bt_on_zjh_1.png","bt_on_zjh_0.png",ccui.TextureResType.plistType)
		:setTag(TAG_BT_MUSICON)
		:move(728, 433)
		:addTo(self)
	self.btMusicOn:addClickEventListener(funCallback)

	self.btMusicOff = ccui.Button:create("bt_off_zjh_0.png","bt_off_zjh_1.png","bt_off_zjh_0.png",ccui.TextureResType.plistType)
		:setTag(TAG_BT_MUSICOFF)
		:move(728, 433)
		:addTo(self)
	self.btMusicOff:addClickEventListener(funCallback)

	self.btEffectOn = ccui.Button:create("bt_on_zjh_0.png","bt_on_zjh_1.png","bt_on_zjh_0.png",ccui.TextureResType.plistType)
		:setTag(TAG_BT_EFFECTON)
		:move(728, 295)
		:addTo(self)
	self.btEffectOn:addClickEventListener(funCallback)

	self.btEffectOff = ccui.Button:create("bt_off_zjh_0.png","bt_off_zjh_1.png","bt_off_zjh_0.png",ccui.TextureResType.plistType)
		:setTag(TAG_BT_EFFECTOFF)
		:move(728, 295)
		:addTo(self)
	self.btEffectOff:addClickEventListener(funCallback)

	--声音
	self.btMusicOn:setVisible(GlobalUserItem.bVoiceAble)
	self.btMusicOff:setVisible(not GlobalUserItem.bVoiceAble)
	self.btEffectOn:setVisible(GlobalUserItem.bSoundAble)
	self.btEffectOff:setVisible(not GlobalUserItem.bSoundAble)
	if GlobalUserItem.bVoiceAble then
		--AudioEngine.playMusic("sound_res/BACK_MUSIC.wav", true)
		ExternalFun.playBackgroudAudio("BACK_MUSIC.mp3")
	end
	--版本号
	local versionProxy = AppFacade:getInstance():retrieveProxy("VersionProxy")
	local nVersion = versionProxy:getResVersion(cmd.KIND_ID) or "0"
	local strVersion = "游戏版本："..BaseConfig.BASE_C_VERSION.."."..nVersion
	cc.Label:create()
		:move(925, 225)
		:setString(strVersion)
		:setAnchorPoint(cc.p(1, 0.5))
		:setTextColor(cc.c3b(0, 0, 0))
		:setSystemFontSize(20)
		:addTo(self)

	self:setVisible(false)
end

function SetLayer:onButtonCallback(tag, ref)
	if tag == TAG_BT_MUSICON then
		print("音乐状态本开")
		GlobalUserItem.setVoiceAble(false)
		self.btMusicOn:setVisible(false)
		self.btMusicOff:setVisible(true)
		ExternalFun.playSoundEffect("GAME_CLICK.wav")
	elseif tag == TAG_BT_MUSICOFF then
		print("音乐状态本关")
		GlobalUserItem.setVoiceAble(true)
		self.btMusicOn:setVisible(true)
		self.btMusicOff:setVisible(false)
		--AudioEngine.playMusic("sound_res/BACK_MUSIC.wav", true)
		ExternalFun.playSoundEffect("GAME_CLICK.wav")
		ExternalFun.playBackgroudAudio("BACK_MUSIC.mp3")
		
	elseif tag == TAG_BT_EFFECTON then
		print("音效状态本开")
		ExternalFun.playSoundEffect("GAME_CLICK.wav")
		GlobalUserItem.setSoundAble(false)
		self.btEffectOn:setVisible(false)
		self.btEffectOff:setVisible(true)
	elseif tag == TAG_BT_EFFECTOFF then
		print("音效状态本关")
		GlobalUserItem.setSoundAble(true)
		self.btEffectOn:setVisible(true)
		self.btEffectOff:setVisible(false)
		ExternalFun.playSoundEffect("GAME_CLICK.wav")
	elseif tag == TAG_BT_EXIT then
		print("离开")
		self:hideLayer()
		ExternalFun.playSoundEffect("GAME_CLICK.wav")
	end
end

function SetLayer:onTouch(eventType, x, y)
	if eventType == "began" then
		return true
	end

	local pos = cc.p(x, y)
    local rectLayerBg = self.sp_layerBg:getBoundingBox()
    if not cc.rectContainsPoint(rectLayerBg, pos) then
    	self:hideLayer()
    end

    return true
end

function SetLayer:showLayer()
	self.colorLayer:setTouchEnabled(true)
	self:setVisible(true)
end

function SetLayer:hideLayer()
	self.colorLayer:setTouchEnabled(false)
	self:setVisible(false)
	self:onResetData()
end

return SetLayer