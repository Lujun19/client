local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")

local BankLayer = class("BankLayer", cc.Layer)

function BankLayer:ctor(parent)
    self.editNum = nil
    --加载csb资源
    self.csbNode = ExternalFun.loadCSB("bank/bankLayer.csb", self)
    
    --遮罩层
    self.csbNode:getChildByName("Panel_1"):addClickEventListener(function (sender) ExternalFun.playClickEffect() parent:removeBankerLayer() end)

    --关闭按钮
    local btn = self.csbNode:getChildByName("close_btn"):addClickEventListener(function (sender) ExternalFun.playClickEffect() parent:removeBankerLayer() end)

    --取款按钮
    btn = self.csbNode:getChildByName("out_btn"):addClickEventListener(function(sender) ExternalFun.playClickEffect()
                                                                        local szScore = string.gsub(self.editboxNum:getText(),"([^0-9])","")
                                                                        local szPass = self.editboxPw:getText()

                                                                        if #szScore < 1 then 
                                                                            showToast(self,"请输入操作金额！",2)
                                                                            return
                                                                        end

                                                                        local lOperateScore = tonumber(szScore)
                                                                        if lOperateScore<1 then
                                                                            showToast(self,"请输入正确金额！",2)
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

                                                                        parent:showPopWait()  
                                                                        parent:getParentNode():sendTakeScore(szScore,szPass) 
                                                                    end)


    --取款金额
    local tmp = self.csbNode:getChildByName("count_temp")
    local editbox = ccui.EditBox:create(tmp:getContentSize(),"bank/input.png")
        :setPosition(tmp:getPosition())
        :setFontName("fonts/round_body.ttf")
        :setPlaceholderFontName("fonts/round_body.ttf")
        :setFontSize(24)
        :setPlaceholderFontSize(24)
        :setMaxLength(32)
        :setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE)
        :setPlaceHolder("请输入取款金额")
    self:addChild(editbox)
    self.editboxNum = editbox

    --取款密码
    tmp = self.csbNode:getChildByName("passwd_temp")
    editbox = ccui.EditBox:create(tmp:getContentSize(), "bank/input.png")
        :setPosition(tmp:getPosition())
        :setFontName("fonts/round_body.ttf")
        :setPlaceholderFontName("fonts/round_body.ttf")
        :setFontSize(24)
        :setPlaceholderFontSize(24)
        :setMaxLength(32)
        :setInputFlag(cc.EDITBOX_INPUT_FLAG_PASSWORD)
        :setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE)
        :setPlaceHolder("请输入取款密码")
    self:addChild(editbox)
    self.editboxPw = editbox
    ------

    local myScore = ExternalFun.numberThousands(GlobalUserItem.tabAccountInfo.lUserScore)
    --当前游戏币
    if string.len(myScore) > 19 then
        myScore = string.sub(myScore, 1, 19)
    end
    self.csbNode:getChildByName("cur_gold"):setString(myScore)

    --银行游戏币
    local bankScore = ExternalFun.numberThousands(GlobalUserItem.tabAccountInfo.lUserInsure)
    if string.len(bankScore) > 19 then
        bankScore = string.sub(bankScore, 1, 19)
    end
    self.csbNode:getChildByName("bank_gold"):setString(bankScore)
end

function BankLayer:refreshBankScore()
    --携带游戏币
    local str = ExternalFun.numberThousands(GlobalUserItem.tabAccountInfo.lUserScore)
    if string.len(str) > 19 then
        str = string.sub(str, 1, 19)
    end
    self.csbNode:getChildByName("cur_gold"):setString(str)

    --银行存款
    str = ExternalFun.numberThousands(GlobalUserItem.tabAccountInfo.lUserInsure)
    if string.len(str) > 19 then
        str = string.sub(str, 1, 19)
    end
    self.csbNode:getChildByName("bank_gold"):setString(ExternalFun.numberThousands(GlobalUserItem.tabAccountInfo.lUserInsure))

    self.editboxNum:setText("")
    self.editboxPw:setText("")
end

function BankLayer:refreshBankRate(rate)
    local str = "温馨提示：取款将扣除"..rate.."%的手续费"
    self.csbNode:getChildByName("Text_notice"):setString(str)
end 

return BankLayer	