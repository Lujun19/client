--
-- Author: zhong
-- Date: 2016-07-29 12:01:42
--

--[[
* 通用扩展
]]
local ExternalFun2 = {}

--枚举声明
function ExternalFun2.declarEnum( ENSTART, ... )
	local enStart = 1;
	if nil ~= ENSTART then
		enStart = ENSTART;
	end

	local args = {...};
	local enum = {};
	for i=1,#args do
		enum[args[i]] = enStart;
		enStart = enStart + 1;
	end

	return enum;
end

function ExternalFun2.declarEnumWithTable( ENSTART, keyTable )
	local enStart = 1;
	if nil ~= ENSTART then
		enStart = ENSTART;
	end

	local args = keyTable;
	local enum = {};
	for i=1,#args do
		enum[args[i]] = enStart;
		enStart = enStart + 1;
	end

	return enum;
end

function ExternalFun2.SAFE_RELEASE( var )
	if nil ~= var then
		var:release();
	end
end

function ExternalFun2.SAFE_RETAIN( var )
	if nil ~= var then
		var:retain();
	end
end

function ExternalFun2.enableBtn( btn, bEnable, bHide )
	if nil == btn then
		return
	end
	if nil == bEnable then
		bEnable = false;
	end
	if nil == bHide then
		bHide = false;
	end

	btn:setEnabled(bEnable);
	if bEnable then
		btn:setVisible(true);
		btn:setOpacity(255);
	else
		if bHide then
			btn:setVisible(false);
		else
			btn:setOpacity(125);
		end
	end
end

--格式化长整形
function ExternalFun2.formatScore( llScore )
	local str = string.formatNumberThousands(llScore);
	if string.len(str) >= 4 then
		str = string.sub(str, 1, -4);
		str = (string.gsub(str, ",", ""))
		return str;
	else
		return ""
	end
end

--无小数点 NumberThousands
function ExternalFun2.numberThousands( llScore )
	local str = string.formatNumberThousands(llScore);
	if string.len(str) >= 4 then
		return string.sub(str, 1, -4)
	else
		return ""
	end
end

local debug_mode = nil
--读取网络消息
function ExternalFun2.read_datahelper( param )
	if debug_mode then
		print("read: " .. param.strkey .. " helper");
	end

	if nil ~= param.lentable then
		local lentable = param.lentable;
		local depth = #lentable;

		if debug_mode then
			print("depth ==> ", depth);
		end

		local tmpT = {};
		for i=1,depth do
			local entryLen = lentable[i];
			if debug_mode then
				print("entryLen ==> ", entryLen);
			end

			local entryTable = {};
			for i=1,entryLen do
				local entry = param.fun();
				if debug_mode then
					if type(entry) == "boolean" then
						print("value ==> ", (entry and "true" or "false"))
					else
						print("value ==> ", entry);
					end
				end

				table.insert(entryTable, entry);
			end
			table.insert(tmpT, entryTable);
		end

		return tmpT;
	else
		if debug_mode then
			local value = param.fun();
			if type(value) == "boolean" then
				print("value ==> ", (value and "true" or "false"))
			else
				print("value ==> ", value);
			end
			return value;
		else
			return param.fun();
		end
	end
end

function ExternalFun2.readTableHelper( param )
	local templateTable = param.dTable or {}
	local strkey = param.strkey or "default"
	if nil ~= param.lentable then
		local lentable = param.lentable;
		local depth = #lentable;

		if debug_mode then
			print("depth ==> ", depth);
		end

		local tmpT = {};
		for i=1,depth do
			local entryLen = lentable[i];
			if debug_mode then
				print("entryLen ==> ", entryLen);
			end

			local entryTable = {};
			for i=1,entryLen do
				local entry = ExternalFun2.read_netdata(templateTable, param.buffer)
				if debug_mode then
					dump(entry, strkey .. " ==> " .. i)
				end

				table.insert(entryTable, entry);
			end
			table.insert(tmpT, entryTable);
		end

		return tmpT
	else
		if debug_mode then
			local value = ExternalFun2.read_netdata(templateTable, param.buffer)
			dump(value,strkey )
			return value
		else
			return ExternalFun2.read_netdata(templateTable, param.buffer)
		end
	end
end

--[[
******
* 结构体描述
* {k = "key", t = "type", s = len, l = {}}
* k 表示字段名,对应C++结构体变量名
* t 表示字段类型,对应C++结构体变量类型
* s 针对string变量特有,描述长度
* l 针对数组特有,描述数组长度,以table形式,一维数组表示为{N},N表示数组长度,多维数组表示为{N,N},N表示数组长度
* d 针对table类型,即该字段为一个table类型,d表示该字段需要读取的table数据
* ptr 针对数组,此时s必须为实际长度

** egg
* 取数据的时候,针对一维数组,假如有字段描述为 {k = "a", t = "byte", l = {3}}
* 则表示为 变量a为一个byte型数组,长度为3
* 取第一个值的方式为 a[1][1],第二个值a[1][2],依此类推

* 取数据的时候,针对二维数组,假如有字段描述为 {k = "a", t = "byte", l = {3,3}}
* 则表示为 变量a为一个byte型二维数组,长度都为3
* 则取第一个数组的第一个数据的方式为 a[1][1], 取第二个数组的第一个数据的方式为 a[2][1]
******
]]
--读取网络消息
function ExternalFun2.read_netdata( keyTable, dataBuffer )
	if type(keyTable) ~= "table" then
		return {}
	end
	local cmd_table = {};

	--辅助读取int64
    local int64 = Integer64.new();
	for k,v in pairs(keyTable) do
		local keys = v;

		------
		--读取数据
		--类型
		local keyType = string.lower(keys["t"]);
		--键
		local key = keys["k"];
		--长度
		local lenT = keys["l"];
		local keyFun = nil;
		if "byte" == keyType then
			keyFun = function() return dataBuffer:readbyte(); end
		elseif "int" == keyType then
			keyFun = function() return dataBuffer:readint(); end
		elseif "word" == keyType then
			keyFun = function() return  dataBuffer:readword(); end
		elseif "dword" == keyType then
			keyFun = function() return  dataBuffer:readdword(); end
		elseif "score" == keyType then
			keyFun = function() return  dataBuffer:readscore(int64):getvalue(); end
		elseif "string" == keyType then
			if nil ~= keys["s"] then
				keyFun = function() return  dataBuffer:readstring(keys["s"]); end
			else
				keyFun = function() return  dataBuffer:readstring(); end
			end
		elseif "bool" == keyType then
			keyFun = function() return  dataBuffer:readbool(); end
		elseif "table" == keyType then
			cmd_table[key] = ExternalFun2.readTableHelper({dTable = keys["d"], lentable = lenT, buffer = dataBuffer, strkey = key})
		elseif "double" == keyType then
			keyFun = function() return  dataBuffer:readdouble(); end
		elseif "float" == keyType then
			keyFun = function() return  dataBuffer:readfloat(); end
		elseif "short" == keyType then
			keyFun = function() return  dataBuffer:readshort(); end
		else
			print("read_netdata error: key ==> type==>", key, keyType);
			error("read_netdata error: key ==> type==>", key, keyType)
		end
		if nil ~= keyFun then
			cmd_table[key] = ExternalFun2.read_datahelper({strkey = key, lentable = lenT, fun = keyFun});
		end
	end
	return cmd_table;
end

--创建网络消息包
function ExternalFun2.create_netdata( keyTable )
	if type(keyTable) ~= "table" then
		print("create auto len")
		return CCmd_Data:create()
	end
	local len = 0;
	for i=1,#keyTable do
		local keys = keyTable[i];
		local keyType = string.lower(keys["t"]);

		--todo 数组长度计算
		local keyLen = 0;
		if "byte" == keyType or "bool" == keyType then
			keyLen = 1;
		elseif "score" == keyType or "double" == keyType then
			keyLen = 8;
		elseif "word" == keyType or "short" == keyType then
			keyLen = 2;
		elseif "dword" == keyType or "int" == keyType or "float" == keyType then
			keyLen = 4;
		elseif "string" == keyType then
			keyLen = keys["s"];
		elseif "tchar" == keyType then
			keyLen = keys["s"] * 2
		elseif "ptr" == keyType then
			keyLen = keys["s"]
		else
			print("error keytype ==> ", keyType);
		end

		len = len + keyLen;
	end
	print("net len ==> ", len)
	return CCmd_Data:create(len);
end

--导入包
function ExternalFun2.req_var( module_name )
	if (nil ~= module_name) and ("string" == type(module_name)) then
		return require(module_name);
	end
end

--加载界面根节点，设置缩放达到适配
function ExternalFun2.loadRootCSB( csbFile, parent )
	local rootlayer = ccui.Layout:create()
		:setContentSize(1335,750) --这个是资源设计尺寸
		:setScale(yl.WIDTH / 1335);
	if nil ~= parent then
		parent:addChild(rootlayer);
	end

	local csbnode = cc.CSLoader:createNode(csbFile);
	rootlayer:addChild(csbnode);

	return rootlayer, csbnode;
end

--加载csb资源
function ExternalFun2.loadCSB( csbFile, parent )

	local csbnode = cc.CSLoader:createNode(csbFile);
	if nil ~= parent then
		parent:addChild(csbnode);
	end
	return csbnode;
end

--加载 帧动画
function ExternalFun2.loadTimeLine( csbFile )

	return cc.CSLoader:createTimeline(csbFile);
end

--注册node事件
function ExternalFun2.registerNodeEvent( node )
	if nil == node then
		return
	end
	local function onNodeEvent( event )
		if event == "enter" and nil ~= node.onEnter then
			node:onEnter()
		elseif event == "enterTransitionFinish"
			and nil ~= node.onEnterTransitionFinish then
			node:onEnterTransitionFinish()
		elseif event == "exitTransitionStart"
			and nil ~= node.onExitTransitionStart then
			node:onExitTransitionStart()
		elseif event == "exit" and nil ~= node.onExit then
			node:onExit()
		elseif event == "cleanup" and nil ~= node.onCleanup then
			node:onCleanup()
		end
	end

	node:registerScriptHandler(onNodeEvent)
end

--注册touch事件
function ExternalFun2.registerTouchEvent( node, bSwallow )
	if nil == node then
		return false
	end
	local function onNodeEvent( event )
		if event == "enter" and nil ~= node.onEnter then
			node:onEnter()
		elseif event == "enterTransitionFinish" then
			--注册触摸
			local function onTouchBegan( touch, event )
				if nil == node.onTouchBegan then
					return false
				end
				return node:onTouchBegan(touch, event)
			end

			local function onTouchMoved(touch, event)
				if nil ~= node.onTouchMoved then
					node:onTouchMoved(touch, event)
				end
			end

			local function onTouchEnded( touch, event )
				if nil ~= node.onTouchEnded then
					node:onTouchEnded(touch, event)
				end
			end

			local listener = cc.EventListenerTouchOneByOne:create()
			bSwallow = bSwallow or false
			listener:setSwallowTouches(bSwallow)
			node._listener = listener
		    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
		    listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
		    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
		    local eventDispatcher = node:getEventDispatcher()
		    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, node)

			if nil ~= node.onEnterTransitionFinish then
				node:onEnterTransitionFinish()
			end
		elseif event == "exitTransitionStart"
			and nil ~= node.onExitTransitionStart then
			node:onExitTransitionStart()
		elseif event == "exit" then
			if nil ~= node._listener then
				local eventDispatcher = node:getEventDispatcher()
				eventDispatcher:removeEventListener(node._listener)
			end

			if nil ~= node.onExit then
				node:onExit()
			end
		elseif event == "cleanup" and nil ~= node.onCleanup then
			node:onCleanup()
		end
	end
	node:registerScriptHandler(onNodeEvent)
	return true
end

local filterLexicon = {}
--加载屏蔽词库
function ExternalFun2.loadLexicon( )
	local startTime = os.clock()
	local str = cc.FileUtils:getInstance():getStringFromFile("public/badwords.txt")

	if "{" ~= string.sub(str, 1, 1) or "}" ~= string.sub(str, -1, -1) then
		print("[WARN] load lexicon error!!!")
		return
	end
	str = "return" .. str
	local fuc = loadstring(str)

	if nil ~= fuc and type(fuc) == "function" then
		filterLexicon = fuc()
	end
	local endTime = os.clock()
	print("load time ==> " .. endTime - startTime)
end
ExternalFun2.loadLexicon( )

--判断是否包含过滤词
function ExternalFun2.isContainBadWords( str )
	local startTime = os.clock()

	print("origin ==> " .. str)
	--特殊字符过滤
	str = string.gsub(str, "[%w '|/?·`,;.~!@#$%^&*()-_。，、+]", "")
	print("gsub ==> " .. str)
	--是否直接为敏感字符
	local res = filterLexicon[str]
	--是否包含
	for k,v in pairs(filterLexicon)	do
		local b,e = string.find(str, k)
		if nil ~= b or nil ~= e then
			res = true
			break
		end
	end

	local endTime = os.clock()
	print("excute time ==> " .. endTime - startTime)

	return res ~= nil
end



--utf8字符串分割为单个字符
function ExternalFun2.utf8StringSplit( str )
	local strTable = {}
	for uchar in string.gfind(str, "[%z\1-\127\194-\244][\128-\191]*") do
		strTable[#strTable+1] = uchar
	end
	return strTable
end

function ExternalFun2.StringToTable(s)
    local tb = {}

    --[[
    UTF8的编码规则：
    1. 字符的第一个字节范围： 0x00—0x7F(0-127),或者 0xC2—0xF4(194-244); UTF8 是兼容 ascii 的，所以 0~127 就和 ascii 完全一致
    2. 0xC0, 0xC1,0xF5—0xFF(192, 193 和 245-255)不会出现在UTF8编码中
    3. 0x80—0xBF(128-191)只会出现在第二个及随后的编码中(针对多字节编码，如汉字)
    ]]
    for utfChar in string.gmatch(s, "[%z\1-\127\194-\244][\128-\191]*") do
        table.insert(tb, utfChar)
    end

    return tb
end

function ExternalFun2.replaceAll(src, regex, replacement)
	return string.gsub(src, regex, replacement)
end

function ExternalFun2.dateChange( time, dayChange )
	if string.len(time)==10 and string.match(time,"%d%d%d%d%-%d%d%-%d%d") then
		local year=string.sub(time,0,4);--年份
		local month=string.sub(time,6,7);--月
		local day=string.sub(time,9,10);--日
		local time=os.time({year=year, month=month, day=day})+dayChange*86400 --一天86400秒
		return (os.date('%Y',time).."-"..os.date('%m',time).."-"..os.date('%d',time))
	else
	  return "1970-00-00"
  end
-- //	return true,(os.date('%Y',time).."-"..os.date('%m',time).."-"..os.date('%d',time))
end

function ExternalFun2.getDateStr( time, str )
	local year=string.sub(time,0,4);--年份
 	local month=string.sub(time,6,7);--月
 	local day=string.sub(time,9,10);--日
	 if str == "Y" then
			return year;
	 elseif str == "m" then
		return month;
	 else
		 	return day;
	 end

end

function ExternalFun2.cleanZero(s)
	-- 如果传入的是空串则继续返回空串
    if"" == s then
        return ""
    end

    -- 字符串中存在多个'零'在一起的时候只读出一个'零'，并省略多余的单位

    local regex1 = {"零仟", "零佰", "零拾"}
    local regex2 = {"零亿", "零万", "零元"}
    local regex3 = {"亿", "万", "元"}
    local regex4 = {"零角", "零分"}

    -- 第一轮转换把 "零仟", 零佰","零拾"等字符串替换成一个"零"
    for i = 1, 3 do
        s = ExternalFun2.replaceAll(s, regex1[i], "零")
    end

    -- 第二轮转换考虑 "零亿","零万","零元"等情况
    -- "亿","万","元"这些单位有些情况是不能省的，需要保留下来
    for i = 1, 3 do
        -- 当第一轮转换过后有可能有很多个零叠在一起
        -- 要把很多个重复的零变成一个零
        s = ExternalFun2.replaceAll(s, "零零零", "零")
        s = ExternalFun2.replaceAll(s, "零零", "零")
        s = ExternalFun2.replaceAll(s, regex2[i], regex3[i])
    end

    -- 第三轮转换把"零角","零分"字符串省略
    for i = 1, 2 do
        s = ExternalFun2.replaceAll(s, regex4[i], "")
    end

    -- 当"万"到"亿"之间全部是"零"的时候，忽略"亿万"单位，只保留一个"亿"
    s = ExternalFun2.replaceAll(s, "亿万", "亿")

    --去掉单位
    s = ExternalFun2.replaceAll(s, "元", "")
    return s
end

--人民币阿拉伯数字转大写
function ExternalFun2.numberTransiform(strCount)
	local big_num = {"零","壹","贰","叁","肆","伍","陆","柒","捌","玖"}
	local big_mt = {__index = function() return "" end }
	setmetatable(big_num,big_mt)
	local unit = {"元", "拾", "佰", "仟", "万",
                  --拾万位到千万位
                  "拾", "佰", "仟",
                  --亿万位到万亿位
                  "亿", "拾", "佰", "仟", "万",}
    local unit_mt = {__index = function() return "" end }
    setmetatable(unit,unit_mt)
    local tmp_str = ""
    local len = string.len(strCount)
    for i = 1, len do
    	tmp_str = tmp_str .. big_num[string.byte(strCount, i) - 47] .. unit[len - i + 1]
    end
    return ExternalFun2.cleanZero(tmp_str)
end


function ExternalFun2.encodePostString( params )
    local str = "";
		for key, value in pairs(params) do
				str = str .. "" .. key .. "=" .. value .. "&";
		end
		return str;
end

--播放音效 (根据性别不同播放不同的音效)
function ExternalFun2.playSoundEffect( path, useritem )
	local sound_path = path
	if nil == useritem then
		sound_path = "sound_res/" .. path
	else
		-- 0:女/1:男
		local gender = useritem.cbGender
		sound_path = string.format("sound_res/%d/%s", gender,path)
	end
	if GlobalUserItem.bSoundAble then
		AudioEngine.playEffect(sound_path,false)
	end
end

function ExternalFun2.playClickEffect( )
	if GlobalUserItem.bSoundAble then
		AudioEngine.playEffect(cc.FileUtils:getInstance():fullPathForFilename("sound/Click.wav"),false)
	end
end

--播放背景音乐
function ExternalFun2.playBackgroudAudio( bgfile )
	local strfile = bgfile
	if nil == bgfile then
		strfile = "backgroud.wav"
	end
	strfile = "sound_res/" .. strfile
	if GlobalUserItem.bVoiceAble then
		AudioEngine.playMusic(strfile,true)
	end
end

--播放大厅背景音乐
function ExternalFun2.playPlazzBackgroudAudio( )
	if GlobalUserItem.bVoiceAble then
		AudioEngine.playMusic(cc.FileUtils:getInstance():fullPathForFilename("sound/backgroud01.mp3"),true)
	end
end

function ExternalFun2.lua_string_split(szFullString, szSeparator)
	local nFindStartIndex = 1
	local nSplitIndex = 1
	local nSplitArray = {}
	while true do
		 local nFindLastIndex = string.find(szFullString, szSeparator, nFindStartIndex)
		 if not nFindLastIndex then
			nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, string.len(szFullString))
			break
		 end
		 nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, nFindLastIndex - 1)
		 nFindStartIndex = nFindLastIndex + string.len(szSeparator)
		 nSplitIndex = nSplitIndex + 1
	end
	return nSplitArray
end

--中文长度计算(同步pc,中文长度为2)
function ExternalFun2.stringLen(szText)
	local len = 0
	local i = 1
	while true do
		local cur = string.sub(szText,i,i)
		local byte = string.byte(cur)
		if byte == nil then
			break
		end
		if byte > 128 then
			i = i + 3
			len = len + 2
		else
			i = i + 1
			len = len + 1
		end
	end
	return len
end

--webview 可见设置(已知在4s设备上设置可见会引发bug)
function ExternalFun2.visibleWebView(webview, visible)
	if nil == webview then
		return
	end

	local target = cc.Application:getInstance():getTargetPlatform()
	if target == cc.PLATFORM_OS_IPHONE or target == cc.PLATFORM_OS_IPAD then
		local size = cc.Director:getInstance():getOpenGLView():getFrameSize()
		local con = math.max(size.width, size.height)
		if con ~= 960 then
	        webview:setVisible(visible)
	        return true
	    end
	else
		webview:setVisible(visible)
		return true
	end
	return false
end

-- 过滤emoji表情
-- 编码为 226 的emoji字符,不确定是否是某个中文字符
-- [%z\48-\57\64-\126\226-\233][\128-\191] 正则匹配式去除了226
function ExternalFun2.filterEmoji(str)
	local newstr = ""
	print(string.byte(str))
	for unchar in string.gfind(str, "[%z\25-\57\64-\126\227-\240][\128-\191]*") do
		newstr = newstr .. unchar
	end
	print(newstr)
	return newstr
end

-- 判断是否包含emoji
-- 编码为 226 的emoji字符,不确定是否是某个中文字符
function ExternalFun2.isContainEmoji(str)
	if nil ~= containEmoji then
		return containEmoji(str)
	end
	local origincount = string.utf8len(str)
	print("origin " .. origincount)
	local count = 0
	for unchar in string.gfind(str, "[%z\25-\57\64-\126\227-\240][\128-\191]*") do
		--[[print(string.len(unchar))
		print(string.byte(unchar))]]
		if string.len(unchar) < 4 then
			count = count + 1
		end
	end
	print("newcount " .. count)
	return count ~= origincount
end

local TouchFilter = class("TouchFilter", function(showTime, autohide, msg)
		return display.newLayer(cc.c4b(0, 0, 0, 0))
	end)
function TouchFilter:ctor(showTime, autohide, msg)
	ExternalFun2.registerTouchEvent(self, true)
	showTime = showTime or 2
	self.m_msgTime = showTime
	if autohide then
		self:runAction(cc.Sequence:create(cc.DelayTime:create(showTime), cc.RemoveSelf:create(true)))
	end
	self.m_filterMsg = msg
end

function TouchFilter:onTouchBegan(touch, event)
	return self:isVisible()
end

function TouchFilter:onTouchEnded(touch, event)
	print("TouchFilter:onTouchEnded")
	if type(self.m_filterMsg) == "string" and "" ~= self.m_filterMsg then
		showToast(self, self.m_filterMsg, self.m_msgTime)
	end
end

local TOUCH_FILTER_NAME = "__touch_filter_node_name__"
--触摸过滤
function ExternalFun2.popupTouchFilter( showTime, autohide, msg, parent )
	local filter = TouchFilter:create(showTime, autohide, msg)
	local runScene = parent or cc.Director:getInstance():getRunningScene()
	if nil ~= runScene then
		local lastfilter = runScene:getChildByName(TOUCH_FILTER_NAME)
		if nil ~= lastfilter then
			lastfilter:stopAllActions()
			lastfilter:removeFromParent()
		end
		if nil ~= filter then
			filter:setName(TOUCH_FILTER_NAME)
			runScene:addChild(filter, yl.ZORDER.Z_FILTER_LAYER)
		end
	end
end

function ExternalFun2.dismissTouchFilter()
	local runScene = cc.Director:getInstance():getRunningScene()
	if nil ~= runScene then
		local filter = runScene:getChildByName(TOUCH_FILTER_NAME)
		if nil ~= filter then
			filter:stopAllActions()
			filter:removeFromParent()
		end
	end
end

-- eg: 10000 转 1.0万
function ExternalFun2.formatScoreText(score)
	local scorestr = ExternalFun2.formatScore(score)
	if score < 10000 then
		return scorestr
	end

	if score < 100000000 then
		scorestr = string.format("%.2f万", score / 10000)
		return scorestr
	end
	scorestr = string.format("%.2f亿", score / 100000000)
	return scorestr
end

-- 随机ip地址
local external_ip_long =
{
	  { 607649792, 608174079 }, -- 36.56.0.0-36.63.255.255
    { 1038614528, 1039007743 }, -- 61.232.0.0-61.237.255.255
    { 1783627776, 1784676351 }, -- 106.80.0.0-106.95.255.255
    { 2035023872, 2035154943 }, -- 121.76.0.0-121.77.255.255
    { 2078801920, 2079064063 }, -- 123.232.0.0-123.235.255.255
    { -1950089216, -1948778497 }, -- 139.196.0.0-139.215.255.255
    { -1425539072, -1425014785 }, -- 171.8.0.0-171.15.255.255
    { -1236271104, -1235419137 }, -- 182.80.0.0-182.92.255.255
    { -770113536, -768606209 }, -- 210.25.0.0-210.47.255.255
    { -569376768, -564133889 }, -- 222.16.0.0-222.95.255.255
}
function ExternalFun2.random_longip()
	local rand_key = math.random(1, 10)
	local bengin_long = external_ip_long[rand_key][1] or 0
	local end_long = external_ip_long[rand_key][2] or 0
	return math.random(bengin_long, end_long)
end

function ExternalFun2.long2ip( value )
	if not value then
		return {p=0,m=0,s=0,b=0}
	end
	if nil == bit then
		print("not support bit module")
		return {p=0,m=0,s=0,b=0}
	end
	local tmp
	if type(value) ~= "number" then
		tmp = tonumber(value)
	else
		tmp = value
	end
	return
	{
		p = bit.rshift(bit.band(tmp,0xFF000000),24),
		m = bit.rshift(bit.band(tmp,0x00FF0000),16),
		s = bit.rshift(bit.band(tmp,0x0000FF00),8),
		b = bit.band(tmp,0x000000FF)
	}
end

function string.getConfig(fontfile,fontsize)
    local config = {}
    local tmpEN = cc.LabelTTF:create("A", fontfile, fontsize)
    local tmpCN = cc.LabelTTF:create("网", fontfile, fontsize)
    local tmpen = cc.LabelTTF:create("a", fontfile, fontsize)
    local tmpNu = cc.LabelTTF:create("2", fontfile, fontsize)
    config.upperEnSize = tmpEN:getContentSize().width
    config.cnSize = tmpCN:getContentSize().width
    config.lowerEnSize = tmpen:getContentSize().width
    config.numSize = tmpNu:getContentSize().width
    return config
end

function string.EllipsisByConfig(szText, maxWidth,config)
    if not config then
        return szText
    end
    --当前计算宽度
    local width = 0
    --截断结果
    local szResult = "..."
    --完成判断
    local bOK = false

    local i = 1

    local endwidth = 3*config.numSize

    while true do
        local cur = string.sub(szText,i,i)
        local byte = string.byte(cur)
        if byte == nil then
            break
        end
        if byte > 128 then
            if width <= maxWidth - endwidth then
                width = width + config.cnSize
                i = i + 3
            else
                bOK = true
                break
            end
        elseif  byte ~= 32 then
            if width <= maxWidth - endwidth then
                if string.byte('A') <= byte and byte <= string.byte('Z') then
                    width = width + config.upperEnSize
                elseif string.byte('a') <= byte and byte <= string.byte('z') then
                    width = width + config.lowerEnSize
                else
                    width = width + config.numSize
                end
                i = i + 1
            else
                bOK = true
                break
            end
        else
            i = i + 1
        end
    end

    if i ~= 1 then
        szResult = string.sub(szText, 1, i-1)
        if(bOK) then
            szResult = szResult.."..."
        end
    end
    return szResult
end

function string.split(s, p)

    local rt= {}
    string.gsub(s, '[^'..p..']+', function(w) table.insert(rt, w) end )
    return rt

end

--依据宽度截断字符
function string.stringEllipsis(szText, sizeE,sizeCN,maxWidth)
    --当前计算宽度
    local width = 0
    --截断结果
    local szResult = "..."
    --完成判断
    local bOK = false

    local i = 1

    while true do
        local cur = string.sub(szText,i,i)
        local byte = string.byte(cur)
        if byte == nil then
            break
        end
        if byte > 128 then
            if width <= maxWidth - 3*sizeE then
                width = width + sizeCN
                i = i + 3
            else
                bOK = true
                break
            end
        elseif  byte ~= 32 then
            if width <= maxWidth - 3*sizeE then
                width = width +sizeE
                i = i + 1
            else
                bOK = true
                break
            end
        else
            i = i + 1
        end
    end

    if i ~= 1 then
        szResult = string.sub(szText, 1, i-1)
        if(bOK) then
            szResult = szResult.."..."
        end
    end
    return szResult
end

-- 获取余数
function math.mod(a, b)
    return a - math.floor(a/b)*b
end

function string.formatNumberThousands(num,dot,flag)

    local formatted
    if not dot then
        formatted = string.format("%0.2f",tonumber(num))
    else
        formatted = tonumber(num)
    end
    local sp
    if not flag then
        sp = ","
    else
        sp = flag
    end
    local k
    while true do
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1'..sp..'%2')
        if k == 0 then break end
    end
    return formatted
end

-- 下标组合
local tabCombinations = {}
-- param[num]
-- param[need]
function ExternalFun2.idx_combine( num, need, bSort )
	if type(num) ~= "number" or type(need) ~= "number" then
		print("param invalid")
		return {}
	end
	bSort = bSort or false
	local key = string.format("%d_combine_%d_bsort_%s", num, need, tostring(bSort))
	if nil ~= tabCombinations[key] then
		return tabCombinations[key]
	end

	-- 排序下标
	local key_idx = {}
	if bSort then
		for i = 1, num do
			key_idx[i] = num - i + 1
		end
	end
	local combs = {}
    local comb = {}
    local function _combine( m, k )
    	for i = m, k, -1 do
    		comb[k] = i
    		if k > 1 then
    			_combine(i - 1, k - 1)
    		else
    			local tmp = {}
    			if bSort then
    				for k, v in pairs(comb) do
	    				table.insert(tmp, 1, key_idx[v])
	    			end
    			else
    				tmp = clone(comb)
    			end
    			table.insert(combs, tmp)
    		end
    	end
    end
    _combine( num, need )

    if 0 ~= #combs then
    	tabCombinations[key] = combs
    end
    return combs
end

-- 获取文件名
function ExternalFun2.getFileName(filename)
	if nil == filename then
		return ""
	end
    return string.match(string.gsub(filename, "\\", "/"), ".+/([^/]*%.%w+)$")
end

-- 获取扩展名
function ExternalFun2.getExtension(filename)
    return filename:match(".+%.(%w+)$")
end

-- 排序规则
function ExternalFun2.sortRule( a, b )
	if type(a) ~= "number" or type(b) ~= "number" then
		print("sort param invalid ", a, b)
		return false
	end
	return a < b
end


--base64编码
function ExternalFun2.base64FromBytes(source_bytes)
    local b64chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
    local s64 = ''
    local index = 0

    while index < #source_bytes do
        local bytes_num = 0
        local buf = 0

        for byte_cnt=1,3 do
            buf = (buf * 256)
            if index < #source_bytes then
                index = index + 1
                buf = buf + source_bytes[index]
                bytes_num = bytes_num + 1
            end
        end

        for group_cnt=1,(bytes_num+1) do
            local b64char = math.fmod(math.floor(buf/262144), 64) + 1
            s64 = s64 .. string.sub(b64chars, b64char, b64char)
            buf = buf * 64
        end

        for fill_cnt=1,(3-bytes_num) do
            s64 = s64 .. '='
        end
    end

    return s64
end

--base64解码
function ExternalFun2.stringFromBase64(str64)
    local b64chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
    local temp={}
    for i=1,64 do
        temp[string.sub(b64chars,i,i)] = i
    end
    temp['=']=0
    local str=""
    for i=1,#str64,4 do
        if i>#str64 then
            break
        end
        local data = 0
        local str_count=0
        for j=0,3 do
            local str1=string.sub(str64,i+j,i+j)
            if not temp[str1] then
                return
            end
            if temp[str1] < 1 then
                data = data * 64
            else
                data = data * 64 + temp[str1]-1
                str_count = str_count + 1
            end
        end
        for j=16,0,-8 do
            if str_count > 0 then
                str=str..string.char(math.floor(data/math.pow(2,j)))
                data=math.mod(data,math.pow(2,j))
                str_count = str_count - 1
            end
        end
    end

    local last = tonumber(string.byte(str, string.len(str), string.len(str)))
    if last == 0 then
        str = string.sub(str, 1, string.len(str) - 1)
    end
    return str
end


--检查手机号
function ExternalFun2.isPhoneNumber(var)

    local b = tonumber(var) -- b="number"
    if (b==nil) then
        print("is not number")
        return false
    end


    if(#var ~= 11) then
        return false;
    else
        return (string.match(var,"[1][3,4,5,7,8]%d%d%d%d%d%d%d%d%d") == var)
    end



--    local array =
--        {
--            "133","153","180","189", --电信
--            "130","131","132","145", --联通
--            "155","156","185","186",
--            "134","135","136","137", --移动
--            "138","139","147","150",
--            "151","152","157","158",
--            "159","182","187","188"
--        }

--    for i = 1, #array do
--        if(array[i] == string.sub(var,0,3)) then
--            return true;
--        end


--    end
    return false;
end

function ExternalFun2.urlSafeBase64(strBase64)

    strBase64 = string.gsub(strBase64, "+", "-")
    strBase64 = string.gsub(strBase64, "/", "_")
    --strBase64 = string.gsub(strBase64, "=", "")

    return strBase64
end


--异或加密字符串(返回base64字符串)
function ExternalFun2.xorEncrypt(str, key)

    local dataBytes = {}
    local keyBytes = {}

    for i = 1, #key do
        keyBytes[i] = string.byte(key,i,i)
    end

    --异或运算
    for i = 1, #str do
        dataBytes[i] = bit:_xor(string.byte(str,i,i), keyBytes[(i - 1) % #key + 1])
    end

    local strBase64 = ExternalFun2.base64FromBytes(dataBytes)

    return strBase64
end

return ExternalFun2
