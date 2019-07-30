local GameFrame = class("GameFrame")

function GameFrame:ctor()
	--以座椅号管理
    self.m_tableChairUserList = {}
	--编号管理
	self.m_tableList = {}
	--以uid管理
	self.m_tableUidUserList = {}
	--上庄用户列表
	self.m_tableApplyList = {}
end
-------------------
--游戏玩家管理

--初始化用户列表
function GameFrame:initUserList( userList )
	--以座椅号管理
    self.m_tableChairUserList = {}
    --以uid管理
    self.m_tableUidUserList = {}
    self.m_tableList = {}

    for k,v in pairs(userList) do
        self.m_tableChairUserList[v.wChairID + 1] = v;
        self.m_tableUidUserList[v.dwUserID] = v;
        table.insert(self.m_tableList, v)
    end
end

--增加用户
function GameFrame:addUser( userItem )
	if nil == userItem then
        return
    end

    self.m_tableChairUserList[userItem.wChairID + 1] = userItem;
    self.m_tableUidUserList[userItem.dwUserID] = userItem;

    local user = self:isUserInList(userItem)
    if nil == user then
        table.insert(self.m_tableList, userItem)
    end 

    print("after add:" .. #self.m_tableList)
end

--删除用户
function GameFrame:removeUser( useritem )
    if nil == useritem then
        return
    end

    local deleteidx = nil
    for k,v in pairs(self.m_tableList) do
        if v.dwUserID == useritem.dwUserID then
            deleteidx = k
            break
        end
    end

    if nil ~= deleteidx then
        table.remove(self.m_tableList,deleteidx)
        table.remove(self.m_tableChairUserList,useritem.wChairID + 1)
   		table.remove(self.m_tableUidUserList,useritem.dwUserID)
    end

    print("after remove:" .. #self.m_tableList)
end

function GameFrame:isUserInList( useritem )
    local user = nil
    for k,v in pairs(self.m_tableList) do
        if v.dwUserID == useritem.dwUserID then
            user = useritem
            break
        end
    end
    return user
end

function GameFrame:isMeInBankList( useritem )
    local user = nil
    for k,v in pairs(self.m_tableApplyList) do
        if v.dwUserID == useritem.dwUserID then
            user = useritem
            break
        end
    end
    return user
end

function GameFrame:removeAllUser()
	--以座椅号管理
    self.m_tableChairUserList = {}
    --以uid管理
    self.m_tableUidUserList = {}
    --编号管理
    self.m_tableList = {}
    --上庄用户
    self.m_tableApplyList = {}
end

---------------------
--庄家管理
--添加庄家申请用户
function GameFrame:addApplyUser(wchair, bRob)
	local useritem = self.m_tableChairUserList[wchair + 1]
    if nil == useritem then
        return
    end
    --申请数超额时的处理
	if #self.m_tableApplyList > yl.MAX_INT then
        self.m_tableApplyList = {}
    end
    table.insert(self.m_tableApplyList, useritem)
end

--移除庄家申请用户
function GameFrame:removeApplyUser(wchair)
	local removeIdx = nil
    for k,v in pairs(self.m_tableApplyList) do
        if v.wChairID == wchair then
            removeIdx = k
            break
        end
    end

    if nil ~= removeIdx then
        table.remove(self.m_tableApplyList,removeIdx)
    end
end

--获取申请庄家列表
function GameFrame:getApplyBankerUserList()
    return self.m_tableApplyList
end

function GameFrame:getChairUserList()
	return self.m_tableChairUserList
end

function GameFrame:getUidUserList()
	return self.m_tableUidUserList
end	

function GameFrame:getUserList()
    table.sort(self.m_tableList, function (a, b) return a.lScore > b.lScore end)
	return self.m_tableList
end

function GameFrame:updateUser( useritem )
    if nil == useritem then
        return
    end

    local user = self:isUserInList(useritem)
    if nil == user then
        table.insert(self.m_tableList, useritem)
    else
        user = useritem
    end

    self.m_tableChairUserList[useritem.wChairID + 1] = useritem;
    self.m_tableUidUserList[useritem.dwUserID] = useritem;
end


return GameFrame