local GameLogic = {}

--扑克类型
GameLogic.HJ_CT_ERROR     = 0						--错误类型
GameLogic.HJ_CT_POINT		= 1						--点数类型
GameLogic.HJ_CT_SPECIAL_11 = 2						--地杠
GameLogic.HJ_CT_SPECIAL_10 = 3						--天杠
GameLogic.HJ_CT_SPECIAL_9 = 4						--天王
GameLogic.HJ_CT_SPECIAL_8 = 5						--杂九>杂八>杂七>杂五
GameLogic.HJ_CT_SPECIAL_7 = 6						--双梅>双长三>双斧头>双高脚--OK
GameLogic.HJ_CT_SPECIAL_6 = 7						--双板凳>双红头>双零零--OK
GameLogic.HJ_CT_SPECIAL_5 = 8						--对合--双鹅
GameLogic.HJ_CT_SPECIAL_4 = 9						--对人--双人
GameLogic.HJ_CT_SPECIAL_3 = 10						--皇帝--至尊
GameLogic.HJ_CT_SPECIAL_2 = 11						--对地--双地
GameLogic.HJ_CT_SPECIAL_1 = 12						--对天--双天

--排序类型
GameLogic.HJ_ST_VALUE = 1							--数值排序
GameLogic.HJ_ST_LOGIC = 2							--逻辑排序

-- 获取牌值(1-15)
function GameLogic.GetCardValue(nCardData)
    return yl.POKER_VALUE[nCardData]
end

-- 获取花色(0-4)
function GameLogic.GetCardColor(nCardData)
    return yl.CARD_COLOR[nCardData]
end

--获得牌的逻辑值
function GameLogic:GetCardLogicValue( cbCardData )	
	local cbCardValue = self.GetCardValue(cbCardData)
	local cbCardColor = self.GetCardColor(cbCardData)

	if 12 == cbCardValue and (0 == cbCardColor or 2 == cbCardColor) then
		return 8
	end
	if 2 == cbCardValue and (0 == cbCardColor or 2 == cbCardColor) then
		return 7
	end
	if 8 == cbCardValue and (0 == cbCardColor or 2 == cbCardColor) then
		return 6
	end
	if 4 == cbCardValue and (0 == cbCardColor or 2 == cbCardColor) then
		return 5
	end
	if (1 == cbCardColor or 3 == cbCardColor) and (10 == cbCardValue or 6 == cbCardValue or 4 == cbCardValue) then
		return 4
	end
	if (0 == cbCardColor or 2 == cbCardColor) and (10 == cbCardValue or 6 == cbCardValue or 7 == cbCardValue) then
		return 3
	end
	if 11 == cbCardValue and (1 == cbCardColor or 3 == cbCardColor) then
		return 3
	end 
	if (1 == cbCardColor or 3 == cbCardColor) and (7 == cbCardValue or 8 == cbCardValue) then
		return 2
	end
	if (0 == cbCardColor or 2 == cbCardColor) and (5 == cbCardValue or 9 == cbCardValue) then
		return 2
	end
	if 3 == cbCardColor and (1 == cbCardValue or 3 == cbCardValue) then
		return 1
	end
	return 0
end

--获取牌点
function GameLogic:GetCardListPip( cbCardData )
	local cbCount = #cbCardData
	local cbPipCount = 0
	local cbCardValue = 0
	for i=1,cbCount do
		cbCardValue = self.GetCardValue(cbCardData[i])
		local addvalue = cbCardValue == 1 and 6 or cbCardValue
		cbPipCount = cbPipCount + addvalue
	end
	return math.mod(cbPipCount, 10)
end

--逻辑值排序
function GameLogic:SortCardList( cbCardData, cbCardCount, cbSortType)
	if cbCardCount == 0 then
		return
	end
	local cbSortValue = {}
	if cbSortType == self.HJ_ST_VALUE then
		for i=1,cbCardCount do
        	local value = self.GetCardValue(cbCardData[i])
        	table.insert(cbSortValue, i, value)
    	end
    else
    	for i=1,cbCardCount do
        	local value = self:GetCardLogicValue(cbCardData[i])
        	table.insert(cbSortValue, i, value)
    	end
	end
	
	--排序操作
	local bSorted = true
	local cbLast = cbCardCount - 1
	repeat
		bSorted = true;
		for i=1,cbLast do
			if (cbSortValue[i] < cbSortValue[i+1])
				or ((cbSortValue[i] == cbSortValue[i + 1]) and (cbCardData[i] < cbCardData[i + 1])) then
				--设置标志
				bSorted = false

				--扑克数据
				cbCardData[i], cbCardData[i + 1] = cbCardData[i + 1], cbCardData[i]			

				--排序权位
				cbSortValue[i], cbSortValue[i + 1] = cbSortValue[i + 1], cbSortValue[i]
			end
		end
		cbLast = cbLast - 1
	until bSorted ~= false
end

--获取类型
function GameLogic:GetCardType( cbCardData, cbCardCount)
	if cbCardCount ~= 2 then
		return self.HJ_CT_ERROR
	end
	
	local cbSortValue = clone(cbCardData)
	self:SortCardList(cbCardData, cbCardCount, self.HJ_ST_LOGIC)
	
    --获取点数
    local cbFirstCardValue = self.GetCardValue(cbSortValue[1])
    local cbSecondCardValue = self.GetCardValue(cbSortValue[2])
    
    --获取花色
    local cbFistCardColor = self.GetCardColor(cbSortValue[1])
    local cbSecondCardColor = self.GetCardColor(cbSortValue[2])

    --特殊类型
	--一对Q 双天
    if 12 == cbFirstCardValue and cbFirstCardValue == cbSecondCardValue then
    	return self.HJ_CT_SPECIAL_1
    end
	--一对2  双地
    if (2 == (cbFistCardColor+cbSecondCardColor)) and cbFirstCardValue == cbSecondCardValue and 2 == cbFirstCardValue then
    	return self.HJ_CT_SPECIAL_2
    end
	--黑桃3+黑桃a 皇帝
    if (6 == (cbFistCardColor+cbSecondCardColor)) and ((1 == cbFirstCardValue and 3 == cbSecondCardValue) or (3==cbFirstCardValue and 1==cbSecondCardValue)) then
    	return self.HJ_CT_SPECIAL_3
    end
	--对子
    if cbFirstCardValue==cbSecondCardValue then
    	if 2 == (cbFistCardColor+cbSecondCardColor) then
    		if 8 == cbFirstCardValue then
    			return self.HJ_CT_SPECIAL_4
    		elseif 4 == cbFirstCardValue then
    			return self.HJ_CT_SPECIAL_5
    		elseif 10 == cbFirstCardValue or 6 == cbFirstCardValue then
    			return self.HJ_CT_SPECIAL_6
    		elseif 7 == cbFirstCardValue then
    			return self.HJ_CT_SPECIAL_7
    		elseif 9 == cbFirstCardValue or 5 == cbFirstCardValue then
    			return self.HJ_CT_SPECIAL_8	
    		end
    	elseif 4 == (cbFistCardColor+cbSecondCardColor) then
    		if 4 == cbFirstCardValue then
    			return self.HJ_CT_SPECIAL_6
    		elseif 6 == cbFirstCardValue or 10 == cbFirstCardValue or 11 == cbFirstCardValue then
    			return self.HJ_CT_SPECIAL_7
    		elseif 7 == cbFirstCardValue or 8 == cbFirstCardValue then
    			return self.HJ_CT_SPECIAL_8
    		end
    	end
    end
	--天王
    if 12 == cbFirstCardValue and 9 == cbSecondCardValue or 9 == cbFirstCardValue and 12 == cbSecondCardValue then
    	return self.HJ_CT_SPECIAL_9
    end
	--天杠
    if 12 == cbFirstCardValue and 8 == cbSecondCardValue or 8 == cbFirstCardValue and 12 == cbSecondCardValue then
    	return self.HJ_CT_SPECIAL_10
    end
	--地杠
    if 2 == cbFirstCardValue and 8 == cbSecondCardValue or 8 == cbFirstCardValue and 2 == cbSecondCardValue then
    	return self.HJ_CT_SPECIAL_11
    end

    return self.HJ_CT_POINT
end

-- first > next  返回 -1
-- first < next  返回 1
-- first == next 返回 0
function GameLogic:CompareCard(cbFirstCardData, cbNextCardData)
	local cbFirstCount = #cbFirstCardData
	if cbFirstCount ~= 2 then
		return 0
	end
	local cbNextCount = #cbNextCardData
	if cbNextCount ~= 2 then
		return 0
	end

	--获取牌型
	local cbFirstCardType = self:GetCardType(cbFirstCardData, cbFirstCount)
	local cbNextCardType = self:GetCardType(cbNextCardData, cbNextCount)

	--牌型比较
	if cbFirstCardType ~= cbNextCardType then
		if cbNextCardType > cbFirstCardType then
			return 1
		else
			return -1
		end
	end

	--特殊牌型判断
	if cbFirstCardType ~= self.HJ_CT_POINT and cbFirstCardType == cbNextCardType then
		return 0
	end

	--获取点数
	local cbFirstPip = self:GetCardListPip(cbFirstCardData)
	local cbNextPip = self:GetCardListPip(cbNextCardData)

	if cbFirstPip ~= cbNextPip then
		if cbNextPip > cbFirstPip then
			return 1
		else
			return -1
		end
	end

	if cbFirstPip == 0 and cbNextPip == 0 then
		return -1
	end

	local cbFirstCardDataTmp, cbNextCardDataTmp = {}
	cbFirstCardDataTmp = clone(cbFirstCardData)
	cbNextCardDataTmp = clone(cbNextCardData)
	self:SortCardList(cbFirstCardDataTmp, cbFirstCount, self.HJ_ST_LOGIC)
	self:SortCardList(cbNextCardDataTmp, cbNextCount, self.HJ_ST_LOGIC)

	--相等判断
	local cbFirstLogicValue = self:GetCardLogicValue(cbFirstCardDataTmp[1])
	local cbNextLogicValue = self:GetCardLogicValue(cbNextCardDataTmp[1])
	if cbNextLogicValue > cbFirstLogicValue then
		return 1
	else
		return -1
	end

	return -1
end
return GameLogic