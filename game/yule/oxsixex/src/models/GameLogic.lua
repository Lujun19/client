local GameLogic = {}


--**************    扑克类型    ******************--
--混合牌型
GameLogic.OX_VALUEO				= 0
--三条牌型
GameLogic.OX_THREE_SAME			= 102
--四条牌型
GameLogic.OX_FOUR_SAME			= 103
--天王牌型
GameLogic.OX_FOURKING			= 104
--天王牌型
GameLogic.OX_FIVEKING			= 105


--最大手牌数目
GameLogic.MAX_CARDCOUNT			= 5
--牌库数目
GameLogic.FULL_COUNT			= 52
--正常手牌数目
GameLogic.NORMAL_COUNT			= 5

--取模
function GameLogic:mod(a,b)
    return a - math.floor(a/b)*b
end
--获得牌的数值（1 -- 13）
function GameLogic:getCardValue(cbCardData)
    return self:mod(cbCardData, 16)
end

--获得牌的颜色（0 -- 4）
function GameLogic:getCardColor(cbCardData)
    return math.floor(cbCardData/16)
end
--获得牌的逻辑值
function GameLogic:getCardLogicValue(cbCardData)
	local cbCardValue = self:getCardValue(cbCardData)

	if cbCardValue > 10 then
		cbCardValue = 10
	end

	return cbCardValue
end
--拷贝表
function GameLogic:copyTab(st)
    local tab = {}
    for k, v in pairs(st) do
        if type(v) ~= "table" then
            tab[k] = v
        else
            tab[k] = self:copyTab(v)
        end
    end
    return tab
 end
--获取牛牛
function GameLogic:getOxCard(cbCardData)
	local bTemp = {}
	local bTempData = self:copyTab(cbCardData)
	local bSum = 0
	for i = 1, 5 do
		bTemp[i] = self:getCardLogicValue(cbCardData[i])
		bSum = bSum + bTemp[i]
	end

	for i = 1, 5 - 1 do
		for j = i + 1, 5 do
			if self:mod(bSum - bTemp[i] - bTemp[j], 10) == 0 then
				local bCount = 1
				for k = 1, 5 do
					if k ~= i and k ~= j then
						cbCardData[bCount] = bTempData[k]
						bCount = bCount + 1
					end
				end
				cbCardData[4] = bTempData[i]
				cbCardData[5] = bTempData[j]
				return true
			end
		end
	end

	return false
end
--获取类型
function GameLogic:getCardType(cbCardData)
	local bKingCount = 0
	local bTenCount = 0
	for i = 1, 5 do
		if self:getCardValue(cbCardData[i]) > 10 then
			bKingCount = bKingCount + 1
		elseif self:getCardValue(cbCardData[i]) == 10 then
			bTenCount = bTenCount + 1
		end
	end
	if bKingCount == 5 then
		return GameLogic.OX_FIVEKING
	elseif bKingCount == 4 and bTenCount == 1 then
		return GameLogic.OX_FOURKING
	end

	local bTemp = {}
	local bSum = 0
	for i = 1, 5 do
		bTemp[i] = self:getCardLogicValue(cbCardData[i])
		bSum = bSum + bTemp[i]
	end

	for i = 1, 4 do
		for j = i + 1, 5 do
			if self:mod(bSum - bTemp[i] - bTemp[j], 10) == 0 then
				return bTemp[i] + bTemp[j] > 10 and bTemp[i] + bTemp[j] - 10 or bTemp[i] + bTemp[j]
			end
		end
	end

	return GameLogic.OX_VALUEO
end

function GameLogic:GetCardLogicValueToInt(bCardData)
    --扑克属性
	local bCardValue = self:getCardValue(bCardData)
	local bCardColor = self:getCardColor(bCardData)
	local index = bCardValue - 1 + bCardColor * 13
	--转换数值
	return index
end

--对比扑克
function GameLogic:CompareCard(cbFirstData,cbNextData, cbCardCount,FirstOX, NextOX)

	--点数判断
	if(FirstOX ~= NextOX) then
		if FirstOX > NextOX then
			return true
		else
			return false
		end
	end
 --比较牛大小
  if FirstOX == 1  then
    --获取点数
    local cbNextType = self:getCardType(cbNextData)
    local cbFirstType = self:getCardType(cbFirstData)

    --点数判断
    if(cbFirstType ~= cbNextType) then
		if (cbFirstType>cbNextType) then
			return true
		else
			return false
		end
	end
  end

  --排序大小
  local bFirstTemp  = {}
  local bNextTemp = {}
  for i = 1, cbCardCount do
	bFirstTemp[i] = cbFirstData[i]
	bNextTemp[i] = cbNextData[i]
  end

  self:SortCardList(bFirstTemp,cbCardCount)
  self:SortCardList(bNextTemp,cbCardCount)

  --比较数值
  local cbNextMaxValue  = self:getCardValue(bNextTemp[1])
  local cbFirstMaxValue = self:getCardValue(bFirstTemp[1])

	if cbFirstMaxValue~=cbNextMaxValue then
	  if cbFirstMaxValue > cbNextMaxValue then
		return true
	else 
		return false
  end
	end
  local bNextCardColor  = self:getCardValue(bNextTemp[1])
  local bFirstCardColor = self:getCardValue(bFirstTemp[1])
  --比较颜色
  if bFirstCardColor > bNextCardColor then
		return true
	else 
		return false
  end

 return false
end
--排列扑克
function GameLogic:SortCardList(cbCardData, cbCardCount)
  --转换数值
    local cbLogicValue = {}
    for i=1,cbCardCount do
		local carddata = cbCardData[i]
		cbLogicValue[i]=self:getCardValue(carddata)
    end

  --排序操作
    local bSorted=false
    local cbTempData=cbCardCount-1
    local bLast=cbCardCount-1
	while bSorted == false do
		bSorted=true
		for i=1 , bLast do
			if((cbLogicValue[i]<cbLogicValue[i+1])or
			 ((cbLogicValue[i]==cbLogicValue[i+1])and(cbCardData[i]<cbCardData[i+1]))) then
				--交换位置
				cbTempData=cbCardData[i];
				cbCardData[i]=cbCardData[i+1];
				cbCardData[i+1]=cbTempData;
				cbTempData=cbLogicValue[i];
				cbLogicValue[i]=cbLogicValue[i+1];
				cbLogicValue[i+1]=cbTempData;
				bSorted=false;
			end
		end
		bLast = bLast - 1
	end

    return;
end
--扑克排序
function GameLogic:SortCardList(cbCardData, cbCardCount, cbSortType)
    local cbSortValue = {}
    for i=1,cbCardCount do
        local value = self:getCardValue(cbCardData[i])
        table.insert(cbSortValue, i, value)
    end
    if cbSortType == 0 then --大小排序
        for i=1,cbCardCount-1 do
            for j=1,cbCardCount-1 do
                if (cbSortValue[j] < cbSortValue[j+1]) or (cbSortValue[j] == cbSortValue[j+1] and cbCardData[j] < cbCardData[j+1]) then
                    local temp = cbSortValue[j]
                    cbSortValue[j] = cbSortValue[j+1]
                    cbSortValue[j+1] = temp
                    local temp2 = cbCardData[j]
                    cbCardData[j] = cbCardData[j+1]
                    cbCardData[j+1] = temp2
                end
            end
        end
    end
    return cbCardData
end
return GameLogic