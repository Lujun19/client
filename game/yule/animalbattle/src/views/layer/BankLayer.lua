
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local module_pre = "game.yule.animalbattle.src"
local PopupLayer=appdf.req(module_pre..".views.layer.PopupLayer")

local BankLayer=class("BankLayer",PopupLayer)

function BankLayer:ctor(parentNode)

	self._parentNode=parentNode

	BankLayer.super.ctor(self)
	self.csbNode=ExternalFun.loadCSB("BankLayer.csb",self)
	
	appdf.getNodeByName(self.csbNode,"Button_1"):addClickEventListener(function() self:removeSelf() end)

	self.withdrawBtn=appdf.getNodeByName(self.csbNode,"Button_2")
	self.bg=appdf.getNodeByName(self.csbNode,"bg")
	self.withdrawBtn:addClickEventListener(function() self:onTakeScore() end)

	self.curCoinLabel=cc.LabelAtlas:create(GlobalUserItem.lUserScore.."", "bankdigits.png", 16, 21, string.byte("0")) 
    		:setAnchorPoint(0.5,0.5)
    		:move(505,409)
    		:addTo(self.bg)

    self.insureLabel=cc.LabelAtlas:create(GlobalUserItem.lUserInsure.."", "bankdigits.png", 16, 21, string.byte("0")) 
    		:setAnchorPoint(0.5,0.5)
    		:move(502,371)
    		:addTo(self.bg)

	local editHanlder = function(event,editbox)
		self:onEditEvent(event,editbox)
	end

	--金额输入
	self.edit_Score = ccui.EditBox:create(cc.size(289,45), ccui.Scale9Sprite:create("bankshadow.png"))
		:move(500,297)
		:setFontName("fonts/round_body.ttf")
		:setPlaceholderFontName("fonts/round_body.ttf")
		:setFontSize(24)
		:setPlaceholderFontSize(24)
		:setMaxLength(13)
		:setFontColor(cc.c4b(217,217,207,255))
		:setInputMode(cc.EDITBOX_INPUT_MODE_NUMERIC)
		:setPlaceHolder("输入取款金额")
		:addTo(self.bg)
	self.edit_Score:registerScriptEditBoxHandler(editHanlder)

	--密码输入	
	self.edit_Password = ccui.EditBox:create(cc.size(289,45), ccui.Scale9Sprite:create("bankshadow.png"))
		:move(500,237)
		:setFontName("fonts/round_body.ttf")
		:setPlaceholderFontName("fonts/round_body.ttf")
		:setFontSize(24)
		:setPlaceholderFontSize(24)
		:setMaxLength(32)
		:setFontColor(cc.c4b(195,199,239,255))
		:setInputFlag(cc.EDITBOX_INPUT_FLAG_PASSWORD)
		:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE)
		:setPlaceHolder("输入取款密码")
		:addTo(self.bg)

	self._parentNode:getParent():sendRequestBankInfo()
end

--输入框监听
function BankLayer:onEditEvent(event,editbox)

end


--取款
function BankLayer:onTakeScore()

    --参数判断
    local szScore = string.gsub(self.edit_Score:getText(),"([^0-9])","")
    local szPass = self.edit_Password:getText()

    if #szScore < 1 then 
        showToast(self,"请输入操作金额！",2)
        return
    end

    local lOperateScore = tonumber(szScore)
    if lOperateScore<1 then
        showToast(self,"请输入正确金额！",2)
        return
    end

    if lOperateScore > GlobalUserItem.lUserInsure then
        showToast(self,"您银行游戏币的数目余额不足,请重新输入游戏币数量！",2)
        return
    end

    if #szPass < 1 then 
        showToast(self,"请输入银行密码！",2)
        return
    end
    if #szPass <6 then
        showToast(self,"密码必须大于6个字符，请重新输入！",2)
        return
    end

    self._parentNode:getParent():sendTakeScore(szScore,szPass)
end

--刷新银行游戏币
function BankLayer:refreshBankScore( )
    --携带游戏币
    local str = ""..GlobalUserItem.lUserScore
    if string.len(str) > 19 then
        str = string.sub(str, 1, 19)
    end
    self.curCoinLabel:setString(str)

    --银行存款
    str = GlobalUserItem.lUserInsure..""
    if string.len(str) > 19 then
        str = string.sub(str, 1, 19)
    end
    self.insureLabel:setString(str)

    self.edit_Score:setText("")
    self.edit_Password:setText("")
end
------

--银行操作成功
function BankLayer:onBankSuccess( )
    local bank_success = self._parentNode:getParent().bank_success
    if nil == bank_success then
        return
    end

    self:refreshBankScore()

    showToast(self, bank_success.szDescribrString, 2)
end

--银行操作失败
function BankLayer:onBankFailure( )
    local bank_fail = self._parentNode:getParent().bank_fail
    if nil == bank_fail then
        return
    end

    showToast(self, bank_fail.szDescribeString, 2)
end

--银行资料
function BankLayer:onGetBankInfo(bankinfo)
    bankinfo.wRevenueTake = bankinfo.wRevenueTake or 10
    local str = "温馨提示:取款将扣除" .. bankinfo.wRevenueTake .. "‰的手续费"
    if self.m_textTips==nil or tolua.isnull(self.m_textTips) then
    	self.m_textTips=ccui.Text:create(str,"fonts/round_body.ttf",26)
    					:addTo(self.bg)
    					:setPosition(cc.p(300,177))
                        :setTextColor(cc.c4b(226,92,33,255))
    else
    	self.m_textTips:setString(str)
    end
end

return BankLayer