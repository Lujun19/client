--
-- Author: zhouweixiang
-- Date: 2017-04-08 17:02:00
--
local GameLogic = {}

--扑克类型
GameLogic.CT_INVALID						= 0								--错误类型
GameLogic.CT_SINGLE							= 1								--单牌类型
GameLogic.CT_ONE_DOUBLE						= 2								--只有一对
GameLogic.CT_TWO_DOUBLE						= 3								--两对牌型
GameLogic.CT_THREE							= 4								--三张牌型
GameLogic.CT_FIVE_MIXED_FLUSH_NO_A			= 5								--普通顺子
GameLogic.CT_FIVE_MIXED_FLUSH_FIRST_A		= 6								--A前顺子
GameLogic.CT_FIVE_MIXED_FLUSH_BACK_A		= 7								--A后顺子
GameLogic.CT_FIVE_FLUSH						= 8								--同花
GameLogic.CT_FIVE_THREE_DEOUBLE				= 9								--三条一对
GameLogic.CT_FIVE_FOUR_ONE					= 10							--四带一张
GameLogic.CT_FIVE_STRAIGHT_FLUSH_NO_A		= 11							--同花顺牌
GameLogic.CT_FIVE_STRAIGHT_FLUSH_FIRST_A	= 12							--A前同花顺
GameLogic.CT_FIVE_STRAIGHT_FLUSH_BACK_A		= 13							--A后同花顺
--特殊类型
GameLogic.CT_EX_INVALID						= 14								--非特殊牌
GameLogic.CT_EX_SANTONGHUA					= 15								--三同花
GameLogic.CT_EX_SANSHUNZI					= 16								--三顺子
GameLogic.CT_EX_LIUDUIBAN					= 17								--六对半
GameLogic.CT_EX_SITAOSANTIAO				= 19								--四套三条
GameLogic.CT_EX_SANFENGTIANXIA				= 24								--三分天下
GameLogic.CT_EX_SANTONGHUASHUN				= 25								--三同花顺
GameLogic.CT_EX_YITIAOLONG					= 27								--一条龙
GameLogic.CT_EX_ZHIZUNQINGLONG				= 28								--至尊清龙

--排序类型
GameLogic.enDescend = 0						--降序类型
GameLogic.enAscend = 1						--升序类型

--比牌结果
GameLogic.enCRLess = 0     	--First > Next
GameLogic.enCREqual = 1		--First == Next
GameLogic.enCRGreater = 2	--First < Next
GameLogic.enCRError = 3		--error

--索引变量
local cbIndexCount = 4

--手牌数目
local HAND_CARD_COUNT = 13

--分析结构
function GameLogic.getAnalyseData(  )
    return
    {
        bOneCount = 0,								--单张数目
		bTwoCount = 0,								--两张数目 
		bThreeCount = 0,							--三张数目
		bFourCount = 0,								--四张数目
		bOneFirst = {0,0,0,0,0,0,0,0,0,0,0,0,0},	--单牌位置
		bTwoFirst = {0,0,0,0,0,0,0,0,0,0,0,0,0},	--对牌位置
		bThreeFirst = {0,0,0,0,0,0,0,0,0,0,0,0,0},	--三条位置
		bFourFirst = {0,0,0,0,0,0,0,0,0,0,0,0,0},	--四张位置
		bSameColor = false							--是否同花
    }
end

--分析结构
function GameLogic.getAnalyseResult( )
    return
    {
        cbBlockCount = {0, 0, 0, 0},							--同牌数目
		cbCardData = {{0,0,0,0,0,0,0,0,0,0,0,0,0},
					  {0,0,0,0,0,0,0,0,0,0,0,0,0},
					  {0,0,0,0,0,0,0,0,0,0,0,0,0},
					  {0,0,0,0,0,0,0,0,0,0,0,0,0}} --扑克列表 
    }
end

--分布信息
function GameLogic.getDistributing()
	return
	{
		cbCardCount = 0,	--扑克数目
		cbDistributing = {{0,0,0,0,0},
						  {0,0,0,0,0},
						  {0,0,0,0,0},
						  {0,0,0,0,0},
						  {0,0,0,0,0},
						  {0,0,0,0,0},
						  {0,0,0,0,0},
						  {0,0,0,0,0},
						  {0,0,0,0,0},
						  {0,0,0,0,0},
						  {0,0,0,0,0},
						  {0,0,0,0,0},
						  {0,0,0,0,0}}	--分布信息
	}
end

--搜索结果
function GameLogic.getSearchCardResult()
	return
	{
		cbSearchCount = 0,	--结果数目
		cbCardCount = {0,0,0,0,0,0,0,0,0,0,0,0,0},	--扑克数目
		cbResultCard = {{0,0,0,0,0,0,0,0,0,0,0,0,0},
					  	{0,0,0,0,0,0,0,0,0,0,0,0,0},
					  	{0,0,0,0,0,0,0,0,0,0,0,0,0},
					  	{0,0,0,0,0,0,0,0,0,0,0,0,0},
					  	{0,0,0,0,0,0,0,0,0,0,0,0,0},
					  	{0,0,0,0,0,0,0,0,0,0,0,0,0},
					  	{0,0,0,0,0,0,0,0,0,0,0,0,0},
					  	{0,0,0,0,0,0,0,0,0,0,0,0,0},
					  	{0,0,0,0,0,0,0,0,0,0,0,0,0},
					  	{0,0,0,0,0,0,0,0,0,0,0,0,0},
					  	{0,0,0,0,0,0,0,0,0,0,0,0,0},
					  	{0,0,0,0,0,0,0,0,0,0,0,0,0},
					  	{0,0,0,0,0,0,0,0,0,0,0,0,0}}	--扑克列表	
	}
end

-- 获取牌值(1-15)
function GameLogic.GetCardValue(cbCardData)
    return yl.POKER_VALUE[cbCardData]
end

-- 获取花色(0-4)
function GameLogic.GetCardColor(cbCardData)
    return yl.CARD_COLOR[cbCardData]
end

--获取逻辑数值
function GameLogic:GetCardLogicValue(cbCardData)
	local bCardValue = GameLogic.GetCardValue(cbCardData)
	return bCardValue == 1 and (bCardValue + 13) or bCardValue
end

--逻辑值排序
function GameLogic:SortCardList( cbCardData, cbCardCount, cbSortType)
	if cbCardCount == 0 or cbCardCount > 13 then
		return
	end

	local cbSortValue = {}
	for i=1,cbCardCount do
        local value = self:GetCardLogicValue(cbCardData[i])
        table.insert(cbSortValue, i, value)
    end
	
	--排序操作
	if GameLogic.enDescend == cbSortType then
		local bSorted = true
		local cbLast = cbCardCount - 1
		repeat
			bSorted = true
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
	elseif GameLogic.enAscend == cbSortType then
		local bSorted = true
		local cbLast = cbCardCount - 1
		repeat
			bSorted = true
			for i=1,cbLast do
				if (cbSortValue[i] > cbSortValue[i+1])
					or ((cbSortValue[i] == cbSortValue[i + 1]) and (cbCardData[i] > cbCardData[i + 1])) then
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
end

--分析扑克
function GameLogic:AnalyseCard(bCardDataList, bCardCount)
	if bCardCount ~= 3 and bCardCount ~= 5 then
		return
	end

	local bCardData = clone(bCardDataList)
	GameLogic:SortCardList(bCardData, bCardCount, GameLogic.enDescend)

	local bSameCount 		= 1
	local bCardValueTemp   = 0
	local bSameColorCount  = 1
	local bFirstCardIndex  = 1

	local bLogicValue = GameLogic:GetCardLogicValue(bCardData[1])
	local bCardColor = GameLogic.GetCardColor(bCardData[1]) 

	local AnalyseData = GameLogic.getAnalyseData()
	for i=2,bCardCount do
		bCardValueTemp = GameLogic:GetCardLogicValue(bCardData[i])
		if bCardValueTemp == bLogicValue then
			bSameCount = bSameCount + 1
		end

		--保存结果
		if bCardValueTemp ~= bLogicValue or i == bCardCount or bCardData[i] == 0 then
			--两张
			if bSameCount == 2 then
				AnalyseData.bTwoCount = AnalyseData.bTwoCount + 1 
				AnalyseData.bTwoFirst[AnalyseData.bTwoCount] = bFirstCardIndex
			elseif bSameCount == 3 then
				AnalyseData.bThreeCount = AnalyseData.bThreeCount + 1
				AnalyseData.bThreeFirst[AnalyseData.bThreeCount] = bFirstCardIndex
			elseif bSameCount == 4 then
				AnalyseData.bFourCount = AnalyseData.bFourCount + 1
				AnalyseData.bFourFirst[AnalyseData.bFourCount] = bFirstCardIndex
			end
		end

		--设置变量
		if bCardValueTemp ~= bLogicValue then
			if bSameCount == 1 then
				if i ~= bCardCount then
					AnalyseData.bOneCount = AnalyseData.bOneCount + 1 
					AnalyseData.bOneFirst[AnalyseData.bOneCount] = bFirstCardIndex
				else
					AnalyseData.bOneCount = AnalyseData.bOneCount + 1 
					AnalyseData.bOneFirst[AnalyseData.bOneCount] = bFirstCardIndex
					AnalyseData.bOneCount = AnalyseData.bOneCount + 1 
					AnalyseData.bOneFirst[AnalyseData.bOneCount] = i
				end
			else
				if i == bCardCount then
					AnalyseData.bOneCount = AnalyseData.bOneCount + 1 
					AnalyseData.bOneFirst[AnalyseData.bOneCount] = i
				end
			end

			bSameCount = 1
			bLogicValue = bCardValueTemp
			bFirstCardIndex = i
		end
		if GameLogic.GetCardColor(bCardData[i]) ~= bCardColor then
			bSameColorCount = 1
		else
			bSameColorCount = bSameColorCount + 1
		end
	end

	AnalyseData.bSameColor = bSameColorCount == 5 and true or false

	return  AnalyseData
end

--分析扑克
function GameLogic:AnalysebCardData(cbCardData, cbCardCount)
	local i = 1
	local AnalyseResult = GameLogic.getAnalyseResult()
	while i <= cbCardCount do
		local cbSameCount = 1
		local cbLogicValue = GameLogic:GetCardLogicValue(cbCardData[i])

		for j=i+1, cbCardCount do
			if GameLogic:GetCardLogicValue(cbCardData[j]) ~= cbLogicValue then
				break
			end
			cbSameCount = cbSameCount + 1
		end
		AnalyseResult.cbBlockCount[cbSameCount] = AnalyseResult.cbBlockCount[cbSameCount] + 1
		local cbIndex = AnalyseResult.cbBlockCount[cbSameCount]-1

		for j=1, cbSameCount do
			AnalyseResult.cbCardData[cbSameCount][cbIndex*cbSameCount+j] = cbCardData[i+j-1]
		end
		i = i + cbSameCount
	end
	return AnalyseResult
end

--分析分布
function GameLogic:AnalysebDistributing(cbCardData, cbCardCount)
	local Distributing = GameLogic.getDistributing()
	for i=1,cbCardCount do
		if cbCardData[i] ~= 0 then
			local cbCardColor = GameLogic.GetCardColor(cbCardData[i])
			local cbCardValue = GameLogic.GetCardValue(cbCardData[i])

			--分布信息1
			Distributing.cbCardCount = Distributing.cbCardCount + 1
			Distributing.cbDistributing[cbCardValue][cbIndexCount+1] = Distributing.cbDistributing[cbCardValue][cbIndexCount+1] + 1
			Distributing.cbDistributing[cbCardValue][cbCardColor+1] = Distributing.cbDistributing[cbCardValue][cbCardColor+1] + 1
		end
	end
	return Distributing
end

--获取类型
function GameLogic:GetCardType(bCardData, bCardCount)
	if bCardCount ~= 3 and bCardCount ~= 5 then
		return GameLogic.CT_INVALID
	end

	local bMaxCardData = 0

	local AnalyseData = GameLogic:AnalyseCard(bCardData, bCardCount)
	GameLogic:SortCardList(bCardData, bCardCount, GameLogic.enDescend)

	local AnalyseResult = GameLogic:AnalysebCardData(bCardData, bCardCount)
	--三条类型
	if bCardCount == 3 then
		--单牌类型
		if 3 == AnalyseData.bOneCount then
			bMaxCardData = GameLogic:GetCardLogicValue(AnalyseResult.cbCardData[1][1])
			return GameLogic.CT_SINGLE, bMaxCardData
		--对带一张
		elseif 1 == AnalyseData.bTwoCount and 1 == AnalyseData.bOneCount then
			bMaxCardData = GameLogic:GetCardLogicValue(AnalyseResult.cbCardData[2][1])
			return GameLogic.CT_ONE_DOUBLE, bMaxCardData
		--三张牌型
		elseif 1 == AnalyseData.bThreeCount then
			bMaxCardData = GameLogic:GetCardLogicValue(AnalyseResult.cbCardData[3][1])
			return GameLogic.CT_THREE, bMaxCardData
		end

		return GameLogic.CT_INVALID, bMaxCardData

	--五张牌型
	elseif bCardCount == 5 then
		local bFlushNoA = false
		local bFlushFirstA = false
		local bFlushBackA = false

		--A连在后
		if 14 == GameLogic:GetCardLogicValue(bCardData[1]) and 10 == GameLogic:GetCardLogicValue(bCardData[5]) then
			bFlushBackA = true
		else
			bFlushNoA = true
		end
		for i=1,4 do
			if 1 ~= GameLogic:GetCardLogicValue(bCardData[i]) - GameLogic:GetCardLogicValue(bCardData[i+1]) then
				bFlushBackA = false
				bFlushNoA = false
			end
		end

		--A连在前
		if false == bFlushBackA and false == bFlushNoA and 14 == GameLogic:GetCardLogicValue(bCardData[1]) then
			bFlushFirstA = true
			for i=2,4 do
				if 1 ~= GameLogic:GetCardLogicValue(bCardData[i]) - GameLogic:GetCardLogicValue(bCardData[i+1]) then
					bFlushFirstA = false
				end
			end
			if 2 ~= GameLogic:GetCardLogicValue(bCardData[5]) then
				bFlushFirstA = false
			end
		end
		--同花五牌
		if false == bFlushBackA and false == bFlushNoA and false == bFlushFirstA then
			if true == AnalyseData.bSameColor then
				bMaxCardData = GameLogic:GetCardLogicValue(AnalyseResult.cbCardData[1][1])
				return GameLogic.CT_FIVE_FLUSH, bMaxCardData
			end
		elseif true == bFlushNoA then
			bMaxCardData = GameLogic:GetCardLogicValue(AnalyseResult.cbCardData[1][1])
			--杂顺类型
			if false == AnalyseData.bSameColor then
				return GameLogic.CT_FIVE_MIXED_FLUSH_NO_A, bMaxCardData
			--同花顺类型
			else
				return GameLogic.CT_FIVE_STRAIGHT_FLUSH_NO_A, bMaxCardData
			end
		elseif true == bFlushFirstA then
			bMaxCardData = GameLogic:GetCardLogicValue(AnalyseResult.cbCardData[1][1])
			--杂顺类型
			if false == AnalyseData.bSameColor then
				return GameLogic.CT_FIVE_MIXED_FLUSH_FIRST_A, bMaxCardData
			--同花顺类型
			else
				return GameLogic.CT_FIVE_STRAIGHT_FLUSH_FIRST_A, bMaxCardData
			end
		elseif true == bFlushBackA then
			bMaxCardData = GameLogic:GetCardLogicValue(AnalyseResult.cbCardData[1][1])
			--杂顺类型
			if false == AnalyseData.bSameColor then
				return GameLogic.CT_FIVE_MIXED_FLUSH_BACK_A, bMaxCardData
			--同花顺类型
			else
				return GameLogic.CT_FIVE_STRAIGHT_FLUSH_BACK_A, bMaxCardData
			end
		end

		--四带单张
		if 1 == AnalyseData.bFourCount and 1 == AnalyseData.bOneCount then
			bMaxCardData = GameLogic:GetCardLogicValue(AnalyseResult.cbCardData[4][1])
			return GameLogic.CT_FIVE_FOUR_ONE, bMaxCardData 
		end

		--三条一对
		if 1 == AnalyseData.bThreeCount and 1 == AnalyseData.bTwoCount then
			bMaxCardData = GameLogic:GetCardLogicValue(AnalyseResult.cbCardData[3][1])
			return GameLogic.CT_FIVE_THREE_DEOUBLE, bMaxCardData
		end

		--三条带单 
		if 1 == AnalyseData.bThreeCount and 2 == AnalyseData.bOneCount then
			bMaxCardData = GameLogic:GetCardLogicValue(AnalyseResult.cbCardData[3][1])
			return GameLogic.CT_THREE, bMaxCardData
		end

		--两对牌型
		if 2 == AnalyseData.bTwoCount and 1 == AnalyseData.bOneCount then
			bMaxCardData = GameLogic:GetCardLogicValue(AnalyseResult.cbCardData[2][1])
			return GameLogic.CT_TWO_DOUBLE, bMaxCardData
		end

		--只有一对
		if 1 == AnalyseData.bTwoCount and 3 == AnalyseData.bOneCount then
			bMaxCardData = GameLogic:GetCardLogicValue(AnalyseResult.cbCardData[2][1])
			return GameLogic.CT_ONE_DOUBLE, bMaxCardData
		end

		--单牌类型
		if 5 == AnalyseData.bOneCount and false == AnalyseData.bSameColor then
			bMaxCardData = GameLogic:GetCardLogicValue(AnalyseResult.cbCardData[1][1])
			return GameLogic.CT_SINGLE, bMaxCardData
		end

		return GameLogic.CT_INVALID, bMaxCardData
	end
end

--判断特殊牌型，必须为13张
function GameLogic:GetSpecialType(bHandCardData, bCardCount)
	if bCardCount ~= HAND_CARD_COUNT then
		return GameLogic.CT_EX_INVALID
	end

	local bCardData = clone(bHandCardData)
	GameLogic:SortCardList(bCardData, bCardCount, GameLogic.enDescend)

	--变量定义
	local bSameCount = 1
	local bCardValueTemp = 0
	local bFirstCardIndex = 1	--记录下标

	local bLogicValue = GameLogic:GetCardLogicValue(bCardData[1])
	local bCardColor = GameLogic.GetCardColor(bCardData[1])

	--扑克分析
	local AnalyseData = GameLogic.getAnalyseData()
	for i=2,bCardCount do
		bCardValueTemp = GameLogic:GetCardLogicValue(bCardData[i])
		if bCardValueTemp == bLogicValue then
			bSameCount = bSameCount + 1
		end

		--保存结果
		if bCardValueTemp ~= bLogicValue or i == bCardCount then
			--两张
			if bSameCount == 2 then
				AnalyseData.bTwoCount = AnalyseData.bTwoCount + 1 
				AnalyseData.bTwoFirst[AnalyseData.bTwoCount] = bFirstCardIndex
			elseif bSameCount == 3 then
				AnalyseData.bThreeCount = AnalyseData.bThreeCount + 1
				AnalyseData.bThreeFirst[AnalyseData.bThreeCount] = bFirstCardIndex
			elseif bSameCount == 4 then
				AnalyseData.bFourCount = AnalyseData.bFourCount + 1
				AnalyseData.bFourFirst[AnalyseData.bFourCount] = bFirstCardIndex
			end
		end

		--设置变量
		if bCardValueTemp ~= bLogicValue then
			if bSameCount == 1 then
				if i ~= bCardCount then
					AnalyseData.bOneCount = AnalyseData.bOneCount + 1 
					AnalyseData.bOneFirst[AnalyseData.bOneCount] = bFirstCardIndex
				else
					AnalyseData.bOneCount = AnalyseData.bOneCount + 1 
					AnalyseData.bOneFirst[AnalyseData.bOneCount] = bFirstCardIndex
					AnalyseData.bOneCount = AnalyseData.bOneCount + 1 
					AnalyseData.bOneFirst[AnalyseData.bOneCount] = i
				end
			else
				if i == bCardCount then
					AnalyseData.bOneCount = AnalyseData.bOneCount + 1 
					AnalyseData.bOneFirst[AnalyseData.bOneCount] = i
				end
			end

			bSameCount = 1
			bLogicValue = bCardValueTemp
			bFirstCardIndex = i
		end
	end

	local cbLineCardData = {{0,0,0,0,0},
							{0,0,0,0,0},
							{0,0,0,0,0}}

	--至尊青龙
	if GameLogic:IsStraightDragon(bCardData, bCardCount) == true then
		for i=1,3 do
			cbLineCardData[1][i] = bCardData[14-i]
		end
		for i=1,5 do
			cbLineCardData[2][i] = bCardData[11-i]
			cbLineCardData[3][i] = bCardData[6-i]
		end
		return GameLogic.CT_EX_ZHIZUNQINGLONG, cbLineCardData
	end

	--一条龙
	if GameLogic:IsLinkCard(bCardData, bCardCount) == true then
		for i=1,3 do
			cbLineCardData[1][i] = bCardData[14-i]
		end
		for i=1,5 do
			cbLineCardData[2][i] = bCardData[11-i]
			cbLineCardData[3][i] = bCardData[6-i]
		end
		return GameLogic.CT_EX_YITIAOLONG, cbLineCardData
	end
	while true do
		--三同花顺
		local cbSameCardCount = {0, 0, 0, 0}
		local cbSameCardData = {{0,0,0,0,0,0,0,0,0,0,0,0,0},
					  			{0,0,0,0,0,0,0,0,0,0,0,0,0},
					  			{0,0,0,0,0,0,0,0,0,0,0,0,0},
					  			{0,0,0,0,0,0,0,0,0,0,0,0,0}}
		--统计花色			  			
		for i=1,bCardCount do
			--获取花色
			local cbCardColor = GameLogic.GetCardColor(bCardData[i])
			--原牌数目
			local cbCount = cbSameCardCount[cbCardColor+1]
			--追加扑克
			cbSameCardData[cbCardColor+1][cbCount+1] = bCardData[i]
			cbSameCardCount[cbCardColor+1] = cbSameCardCount[cbCardColor+1] + 1
		end

		--三同花顺
		local bCondition = true
		for i=1,4 do
			if math.mod(cbSameCardCount[i], 5) ~= 0 and math.mod(cbSameCardCount[i], 5) ~= 3 then
				bCondition = false
				break
			end
		end

		if bCondition == false then
			break
		end

		--判断顺子
		for i=1,4 do
			if cbSameCardCount[i] ==3 then
				if GameLogic:IsLinkCard(cbSameCardData[i], cbSameCardCount[i]) == false then
					bCondition = false
					break
				else
					for cbindex=1, cbSameCardCount[i] do
						cbLineCardData[1][cbindex] = cbSameCardData[i][cbindex]
					end
				end
			elseif cbSameCardCount[i] == 5 then
				if GameLogic:IsLinkCard(cbSameCardData[i], cbSameCardCount[i]) == false then
					bCondition = false
					break
				else
					--降序排序，先放后墩
					if cbLineCardData[3][1] == 0 then
						for cbindex=1, cbSameCardCount[i] do
							cbLineCardData[3][cbindex] = cbSameCardData[i][cbindex]
						end
					else
						for cbindex=1, cbSameCardCount[i] do
							cbLineCardData[2][cbindex] = cbSameCardData[i][cbindex]
						end
					end
				end
			elseif cbSameCardCount[i]==8 or cbSameCardCount[i]==10 then
				local setvalue, setLinkData = GameLogic:SetLinkCard(cbSameCardData[i], cbSameCardCount[i])
				if setvalue == false then
					bCondition = false
					break
				else
					cbLineCardData = clone(setLinkData)
				end
			end
		end
		if bCondition == true then
			--防止乌龙
			if GameLogic:CompareCard(cbLineCardData[2], cbLineCardData[3], 5, 5, true) ~= GameLogic.enCRGreater then
				local cbCardTemp = clone(cbLineCardData[2])
				cbLineCardData[2] = clone(cbLineCardData[3])
				cbLineCardData[3] = clone(cbCardTemp)
			end
			return GameLogic.CT_EX_SANTONGHUASHUN, cbLineCardData
		end
		break
	end
	--三分天下
	if AnalyseData.bFourCount == 3 and AnalyseData.bOneCount == 1 then
		--填充后墩
		for i=1,4 do
			cbLineCardData[3][i] = bCardData[AnalyseData.bFourFirst[1]+i-1]
		end
		cbLineCardData[3][5] = bCardData[AnalyseData.bOneFirst[1]]
		--填充中墩
		for i=1,4 do
			cbLineCardData[2][i] = bCardData[AnalyseData.bFourFirst[2]+i-1]
		end
		cbLineCardData[2][5] = bCardData[AnalyseData.bFourFirst[3]+3]
		--填充前墩
		for i=1,3 do
			cbLineCardData[1][i] = bCardData[AnalyseData.bFourFirst[3]+i-1]
		end
		return GameLogic.CT_EX_SANFENGTIANXIA, cbLineCardData
	end

	--四套三条
	if AnalyseData.bThreeCount == 4 and AnalyseData.bOneCount == 1 then
		--填充后墩
		for i=1,3 do
			cbLineCardData[3][i] = bCardData[AnalyseData.bThreeFirst[1]+i-1]
		end
		for i=1,2 do
			cbLineCardData[3][3+i] = bCardData[AnalyseData.bOneFirst[3]+i-1]
		end
		
		--填充中墩
		for i=1,3 do
			cbLineCardData[2][i] = bCardData[AnalyseData.bThreeFirst[2]+i-1]
		end
		cbLineCardData[2][4] = bCardData[AnalyseData.bOneFirst[3]+2]
		cbLineCardData[2][5] = bCardData[AnalyseData.bOneFirst[1]]

		--填充前墩
		for i=1,3 do
			cbLineCardData[1][i] = bCardData[AnalyseData.bThreeFirst[4]+i-1]
		end
		return GameLogic.CT_EX_SITAOSANTIAO, cbLineCardData
	end

	--六对半
	if AnalyseData.bTwoCount == 6 and AnalyseData.bOneCount == 1 then
		--填充后墩
		for i=1,2 do
			cbLineCardData[3][i] = bCardData[AnalyseData.bTwoFirst[1]+i-1]
			cbLineCardData[3][i+2] = bCardData[AnalyseData.bTwoFirst[2]+i-1]
		end
		cbLineCardData[3][5] = bCardData[AnalyseData.bOneFirst[1]]
		--填充中墩
		for i=1,2 do
			cbLineCardData[2][i] = bCardData[AnalyseData.bTwoFirst[3]+i-1]
			cbLineCardData[2][i+2] = bCardData[AnalyseData.bTwoFirst[4]+i-1]
		end
		cbLineCardData[2][5] = bCardData[AnalyseData.bTwoFirst[6]]
		--填充前墩
		for i=1,2 do
			cbLineCardData[1][i] = bCardData[AnalyseData.bTwoFirst[5]+i-1]
		end
		cbLineCardData[1][3] = bCardData[AnalyseData.bTwoFirst[6]+1]
		return GameLogic.CT_EX_LIUDUIBAN,  cbLineCardData
	end

	--三顺子
	local setvalue, setLinkData = GameLogic:SetLinkCard(bCardData, bCardCount)
	if setvalue == true then
		cbLineCardData = clone(setLinkData)
		if GameLogic:CompareCard(cbLineCardData[2], cbLineCardData[3], 5, 5, true) ~= GameLogic.enCRGreater then
			local cbCardTemp = clone(cbLineCardData[2])
			cbLineCardData[2] = clone(cbLineCardData[3])
			cbLineCardData[3] = clone(cbCardTemp)
		end
		return GameLogic.CT_EX_SANSHUNZI, cbLineCardData
	end

	--三同花
	while true do
		local cbSameCardCount = {0, 0, 0, 0}
		local cbSameCardData = {{0,0,0,0,0,0,0,0,0,0,0,0,0},
					  			{0,0,0,0,0,0,0,0,0,0,0,0,0},
					  			{0,0,0,0,0,0,0,0,0,0,0,0,0},
					  			{0,0,0,0,0,0,0,0,0,0,0,0,0}}
		--统计花色			  			
		for i=1,bCardCount do
			--获取花色
			local cbCardColor = GameLogic.GetCardColor(bCardData[i])
			--原牌数目
			local cbCount = cbSameCardCount[cbCardColor+1]
			--追加扑克
			cbSameCardData[cbCardColor+1][cbCount+1] = bCardData[i]
			cbSameCardCount[cbCardColor+1] = cbSameCardCount[cbCardColor+1] + 1
		end

		--三同花
		local bCondition = true
		for i=1,4 do
			if math.mod(cbSameCardCount[i], 5) ~= 0 and math.mod(cbSameCardCount[i], 5) ~= 3 then
				bCondition = false
				break
			end
		end

		if bCondition == true then
			for i=1,4 do
				if cbSameCardCount[i] == 3 then
					for cbindex=1, cbSameCardCount[i] do
						cbLineCardData[1][cbindex] = cbSameCardData[i][cbindex]
					end
				elseif cbSameCardCount[i] == 5 then
					--降序排序，先放后墩
					if cbLineCardData[3][1] == 0 then
						for cbindex=1, cbSameCardCount[i] do
							cbLineCardData[3][cbindex] = cbSameCardData[i][cbindex]
						end
					else
						for cbindex=1, cbSameCardCount[i] do
							cbLineCardData[2][cbindex] = cbSameCardData[i][cbindex]
						end
					end
				elseif cbSameCardCount[i] == 8 then
					for cbindex=1, 5 do
						cbLineCardData[2][cbindex] = cbSameCardData[i][cbindex]
					end
					for cbindex=1, 3 do
						cbLineCardData[1][cbindex] = cbSameCardData[i][cbindex+5]
					end
				elseif cbSameCardCount[i] == 10 then
					for cbindex=1, 5 do
						cbLineCardData[3][cbindex] = cbSameCardData[i][cbindex]
						cbLineCardData[2][cbindex] = cbSameCardData[i][cbindex+5]
					end
				end
			end
			--防止乌龙
			if GameLogic:CompareCard(cbLineCardData[2], cbLineCardData[3], 5, 5, true) ~= GameLogic.enCRGreater then
				local cbCardTemp = clone(cbLineCardData[2])
				cbLineCardData[2] = clone(cbLineCardData[3])
				cbLineCardData[3] = clone(cbCardTemp)
			end
			return GameLogic.CT_EX_SANTONGHUA, cbLineCardData 
		end
		break
	end
	return GameLogic.CT_EX_INVALID
end


--是否顺子  
function GameLogic:IsLinkCard(cbCardData, cbCardCount)
	if cbCardCount <= 0 then
		return false
	end

	local bRet = true
	local cbCardBuffer = clone(cbCardData)
	GameLogic:SortCardList(cbCardBuffer, cbCardCount, GameLogic.enDescend)

	local cbFirstCard = GameLogic:GetCardLogicValue(cbCardBuffer[1])
	for i=2,cbCardCount do
		local cbNextCard = GameLogic:GetCardLogicValue(cbCardBuffer[i])
		if cbFirstCard ~= cbNextCard + i - 1 then
			bRet = false
			break
		end
	end

	--A前顺子单独处理
	if bRet == false and cbFirstCard == 14 then
		if GameLogic:GetCardLogicValue(cbCardBuffer[cbCardCount]) ~= 2 then
			return bRet
		else
			cbFirstCard = GameLogic:GetCardLogicValue(cbCardBuffer[2])
			for i=3,cbCardCount do
				local cbNextCard = GameLogic:GetCardLogicValue(cbCardBuffer[i])
				if cbFirstCard ~= cbNextCard + i - 2 then
					return false
				end
			end
			return true
		end
	end
	return bRet
end

--是否同花
function GameLogic:IsSameColorCard(cbCardData, cbCardCount)
	if cbCardCount <= 0 then
		return false
	end
	local bRet = true
	local cbFirstCardColor = GameLogic.GetCardColor(cbCardData[1])
	for i=2,cbCardCount do
		local cbNextCardColor = GameLogic.GetCardColor(cbCardData[i])
		if cbFirstCardColor ~= cbNextCardColor then
			return false
		end
	end

	return bRet
end

--是否同花顺
function GameLogic:IsStraightDragon(cbCardData, cbCardCount)
	if cbCardCount <= 0 or cbCardCount > 13 then
		return false
	end
	local bshun = GameLogic:IsLinkCard(cbCardData, cbCardCount)
	local bcolor = GameLogic:IsSameColorCard(cbCardData, cbCardCount)
	if bshun == true and bcolor == true then
		return true
	end
	return false
end

--获取对数
function GameLogic:GetDoubleCount(cbFrontCard, cbMidCard, cbBackCard)
	local AnalyseFront = GameLogic:AnalyseCard(cbFrontCard, 3)
	local AnalyseMid = GameLogic:AnalyseCard(cbMidCard, 5)
	local AnalyseBack = GameLogic:AnalyseCard(cbBackCard, 5)

	if AnalyseFront.bTwoCount == 1 and AnalyseMid.bTwoCount == 2 and AnalyseBack.bTwoCount == 2 then
		local value1 = GameLogic:GetCardLogicValue(cbFrontCard[AnalyseFront.bOneFirst[1]]) == GameLogic:GetCardLogicValue(cbMidCard[AnalyseMid.bOneFirst[1]]) and true or false
		local value2 = GameLogic:GetCardLogicValue(cbMidCard[AnalyseMid.bOneFirst[1]]) == GameLogic:GetCardLogicValue(cbBackCard[AnalyseBack.bOneFirst[1]]) and true or false
		local value3 = GameLogic:GetCardLogicValue(cbFrontCard[AnalyseFront.bOneFirst[1]]) == GameLogic:GetCardLogicValue(cbBackCard[AnalyseBack.bOneFirst[1]]) and true or false
		if  value1 == true or value2 == true or value3 == true then
			return 6
		end
	end

	return AnalyseFront.bTwoCount + AnalyseMid.bTwoCount + AnalyseBack.bTwoCount
end

--设置顺子
function GameLogic:SetLinkCard(cbCardData, cbCardCount)
	if math.mod(cbCardCount, 5) ~= 0 and math.mod(cbCardCount, 5) ~= 3 then
		return false
	end
	print("SetLinkCard")
	local cbLineCardData = {{0,0,0,0,0},
							{0,0,0,0,0},
							{0,0,0,0,0}}
	local cbLineCardResult5,LineCardResult = GameLogic:SearchLineCardType(cbCardData, cbCardCount, 5)
	if cbLineCardResult5 < 1 then
		return false
	end

	for i=1,cbLineCardResult5 do 
		local cbTempCount = cbCardCount
		local value,cbTempCardData = GameLogic:RemoveCard(LineCardResult.cbResultCard[i], LineCardResult.cbCardCount[i], cbCardData, cbCardCount)
		if value == false then
			return false
		end
		cbTempCount = cbCardCount - LineCardResult.cbCardCount[i]
		if cbTempCount == 8 then
			while true do
				local setResult, LineData = GameLogic:SetLinkCard(cbTempCardData, cbTempCount)
				if setResult == false then
					break
				end
				for cbindex=1,5 do
					cbLineCardData[1][cbindex] = LineData[1][cbindex]
					cbLineCardData[2][cbindex] = LineData[2][cbindex]
					cbLineCardData[3][cbindex] = LineCardResult.cbResultCard[i][cbindex]
				end
				return true, cbLineCardData
			end
		end

		if GameLogic:IsLinkCard(cbTempCardData, cbTempCount) == true then
			--八张牌，放前中墩
			if cbTempCount == 3 then
				for cbindex=1,3 do
					cbLineCardData[1][cbindex] = cbTempCardData[cbindex]
				end
				for cbindex=1,LineCardResult.cbCardCount[i] do
					cbLineCardData[2][cbindex] = LineCardResult.cbResultCard[i][cbindex]
				end
			--十张，放中后墩
			else
				for cbindex=1,3 do
					cbLineCardData[2][cbindex] = cbTempCardData[cbindex]
				end
				for cbindex=1,LineCardResult.cbCardCount[i] do
					cbLineCardData[3][cbindex] = LineCardResult.cbResultCard[i][cbindex]
				end
			end
			return true, cbLineCardData 
		end
	end
	return false
end

--删除数据
function GameLogic:RemoveCard(removeData,removeCount,cbCardData,cbCardCount)
	assert(removeCount <= cbCardCount)
	local cbDeleteCount = 0
	local cbTempCardData = {}

	--拷贝数据
	cbTempCardData = clone(cbCardData)

	--置零数据
	for i=1,removeCount do
		for j=1,cbCardCount do
			if removeData[i] == cbTempCardData[j] then 
				cbDeleteCount = cbDeleteCount + 1
				cbTempCardData[j] = 0
				break
			end
		end
	end

	if cbDeleteCount ~= removeCount then
		return false
	end
	
	local cbTemp = {}
	local cbcount = 1
	for k,v in pairs(cbTempCardData) do
		if v ~= 0 then
			cbTemp[cbcount] = v
			cbcount = cbcount + 1
		end
	end

	return true,cbTemp
end

--同牌搜索
function GameLogic:SearchSameCard(cbHandCardData, cbHandCardCount, cbSameCardCount)
	local cbResultCount = 0
	local cbCardData = clone(cbHandCardData)
	GameLogic:SortCardList(cbCardData, cbHandCardCount, GameLogic.enAscend)

	local AnalyseResult = GameLogic:AnalysebCardData(cbCardData, cbHandCardCount)
	local pSearchCardResult = GameLogic.getSearchCardResult()

	local cbBlockIndex = cbSameCardCount
	while cbBlockIndex < #AnalyseResult.cbBlockCount + 1 do 
		for i=1, AnalyseResult.cbBlockCount[cbBlockIndex] do
			local cbIndex = (AnalyseResult.cbBlockCount[cbBlockIndex]-i)*(cbBlockIndex)
			for count=1,cbSameCardCount do
				pSearchCardResult.cbResultCard[cbResultCount+1][count] = AnalyseResult.cbCardData[cbBlockIndex][cbIndex+count]
			end
			pSearchCardResult.cbCardCount[cbResultCount + 1] = cbSameCardCount
			cbResultCount = cbResultCount + 1
		end
		cbBlockIndex = cbBlockIndex + 1
	end

	pSearchCardResult.cbSearchCount = cbResultCount
	return cbResultCount, pSearchCardResult
end

--搜索带牌(三带一，四带一等)
function GameLogic:SearchTakeCardType(cbHandCardData, cbHandCardCount, cbSameCount, cbTakeCardCount)
	local cbResultCount = 0
	if cbSameCount ~= 3 and cbSameCount ~= 4 then
		return cbResultCount
	end
	if cbTakeCardCount ~= 2 and cbTakeCardCount ~= 1 then
		return cbResultCount
	end
	if cbHandCardCount < cbSameCount+cbTakeCardCount then
		return cbResultCount
	end

	local pSearchCardResult = GameLogic.getSearchCardResult()
	local cbSameCardResultCount, SameCardResult = GameLogic:SearchSameCard(cbHandCardData, cbHandCardCount, cbSameCount)
	if cbSameCardResultCount > 0 then
		local cbTakeCardResultCount, TakeCardResult = GameLogic:SearchSameCard(cbHandCardData, cbHandCardCount, cbTakeCardCount)
		--可以组成带牌
		if cbTakeCardResultCount > 0 then
			for i=1,cbSameCardResultCount do
				for j=1,cbTakeCardResultCount do
					--搜索三条：AAA
					--搜索一对：AA 33 66 99
					--忽略组合 AAAAA
					--保留组合 AAA33，AAA66，AAA99
					while true do
						local cbLogicValueSame = GameLogic:GetCardLogicValue(SameCardResult.cbResultCard[i][1])
						local cbLogicvalueTake = GameLogic:GetCardLogicValue(TakeCardResult.cbResultCard[j][1])
						if cbLogicValueSame == cbLogicvalueTake then
							break
						end
						--复制扑克
						pSearchCardResult.cbCardCount[cbResultCount+1] = cbSameCount + cbTakeCardCount
						for same=1,cbSameCount do
							pSearchCardResult.cbResultCard[cbResultCount+1][same] = SameCardResult.cbResultCard[i][same]
						end
						for take=1,cbTakeCardCount do
							pSearchCardResult.cbResultCard[cbResultCount+1][take+cbSameCount] = TakeCardResult.cbResultCard[j][take]
						end
						cbResultCount = cbResultCount + 1
						break
					end
				end
			end
		end
	end
	pSearchCardResult.cbSearchCount = cbResultCount
	return cbResultCount, pSearchCardResult
end

--搜索同花
function GameLogic:SearchSameColorType(cbHandCardData, cbHandCardCount, cbSameCount)
	local cbResultCount = 0
	local cbCardData = clone(cbHandCardData)
	GameLogic:SortCardList(cbCardData, cbHandCardCount, GameLogic.enAscend)

	local cbSameCardCount = {0, 0, 0, 0}
	local cbSameCardData = {{0,0,0,0,0,0,0,0,0,0,0,0,0},
					  		{0,0,0,0,0,0,0,0,0,0,0,0,0},
					  		{0,0,0,0,0,0,0,0,0,0,0,0,0},
					  		{0,0,0,0,0,0,0,0,0,0,0,0,0}}

	for i=1,cbHandCardCount do
		--获取花色
		local cbCardColor = GameLogic.GetCardColor(cbCardData[i])
		--原牌数目
		local cbCount = cbSameCardCount[cbCardColor+1]
		--追加扑克
		cbSameCardData[cbCardColor+1][cbCount+1] = cbCardData[i]
		cbSameCardCount[cbCardColor+1] = cbSameCardCount[cbCardColor+1] + 1
	end
	local pSearchCardResult = GameLogic.getSearchCardResult()
	--判断是否满cbSameCount
	for i=1,4 do
		if cbSameCardCount[i] >= cbSameCount then
			for j=1,math.mod(cbSameCardCount[i], cbSameCount)+1 do
				pSearchCardResult.cbCardCount[cbResultCount+1] = cbSameCount
				for same=1,cbSameCount do
					pSearchCardResult.cbResultCard[cbResultCount+1][same] = cbSameCardData[i][j+same-1]
				end
				cbResultCount = cbResultCount + 1
			end
		end
	end
	pSearchCardResult.cbSearchCount = cbResultCount
	return cbResultCount, pSearchCardResult
end

--搜索顺子
function GameLogic:SearchLineCardType(cbHandCardData, cbHandCardCount, cbLineCount)
	local pSearchCardResult = GameLogic.getSearchCardResult()

	--定义变量
	local cbResultCount = 0
	local cbBlockCount = 1

	--长度过长
	if cbLineCount > 14 then
		return cbResultCount
	end

	--长度判断
	if cbHandCardCount < cbLineCount then
		return cbResultCount
	end

	local cbCardData = clone(cbHandCardData)
	local cbCardCount = cbHandCardCount
	--排列顺序
	self:SortCardList(cbCardData, cbCardCount, GameLogic.enDescend)

	--分析扑克
	local Distributing = GameLogic:AnalysebDistributing(cbCardData, cbCardCount)
	--搜索顺子 
	local cbTempLinkCount = 0
	for cbValueIndex=1,13 do
		--继续判断
		while true do
			if Distributing.cbDistributing[cbValueIndex][cbIndexCount+1] < cbBlockCount then 
				if cbTempLinkCount < cbLineCount then
					cbTempLinkCount = 0
					break
				else
					cbValueIndex = cbValueIndex - 1
				end
			else
				cbTempLinkCount = cbTempLinkCount + 1
				if cbLineCount == 0 then
					break
				end
			end

			if cbTempLinkCount >= cbLineCount then
				--复制扑克
				local cbCount = 0
				for cbIndex=cbValueIndex+1-cbTempLinkCount,cbValueIndex do
					local cbTmpCount = 0
					for cbColorIndex=1,4 do
						for cbColorCount=1,Distributing.cbDistributing[cbIndex][5-cbColorIndex] do
							cbCount = cbCount + 1
							pSearchCardResult.cbResultCard[cbResultCount+1][cbCount] = GameLogic:MackCardData(cbIndex, 5-cbColorIndex)
							if pSearchCardResult.cbResultCard[cbResultCount+1][cbCount] < 0 then

							end
							cbTmpCount = cbTmpCount + 1
							if cbTmpCount == cbBlockCount then
								break
							end
						end
						if cbTmpCount == cbBlockCount then
							break
						end
					end
				end
				pSearchCardResult.cbCardCount[cbResultCount+1] = cbCount
				cbResultCount = cbResultCount + 1
				cbTempLinkCount = cbTempLinkCount - 1 
			end
			break
		end
	end

	--特殊顺子
	local cbValueIndex = 14
	if cbTempLinkCount >= cbLineCount - 1 then
		if Distributing.cbDistributing[1][cbIndexCount + 1] >= cbBlockCount or cbTempLinkCount >= cbLineCount then
			--复制扑克
			local cbCount = 0
			local cbTmpCount = 0
			for cbIndex=cbValueIndex-cbTempLinkCount,cbValueIndex-1 do
				cbTmpCount = 0
				for cbColorIndex=1,4 do
					for cbColorCount=1,Distributing.cbDistributing[cbIndex][5-cbColorIndex] do
						cbCount = cbCount + 1
						pSearchCardResult.cbResultCard[cbResultCount+1][cbCount] = GameLogic:MackCardData(cbIndex, 5-cbColorIndex)
						cbTmpCount = cbTmpCount + 1
						if cbTmpCount == cbBlockCount then
							break
						end
					end
					if cbTmpCount == cbBlockCount then
						break
					end
				end
			end
			--复制A
			if Distributing.cbDistributing[1][cbIndexCount+1] >= cbBlockCount then
				cbTmpCount = 0
				for cbColorIndex=1,4 do
					for cbColorCount=1,Distributing.cbDistributing[1][5-cbColorIndex] do
						cbCount = cbCount + 1
						pSearchCardResult.cbResultCard[cbResultCount+1][cbCount] = GameLogic:MackCardData(1, 5-cbColorIndex)
						cbTmpCount = cbTmpCount + 1
						if cbTmpCount == cbBlockCount then
							break
						end
					end
					if cbTmpCount == cbBlockCount then
						break
					end
				end
			end
			pSearchCardResult.cbCardCount[cbResultCount+1] = cbCount
			cbResultCount = cbResultCount + 1
		end
	end

	pSearchCardResult.cbSearchCount = cbResultCount
	return cbResultCount, pSearchCardResult
end

--搜索同花顺
function GameLogic:SearchSameColorLineType(cbHandCardData, cbHandCardCount, cbLineCount)
	local cbResultCount = 0
	if cbHandCardCount < cbLineCount then
		return cbResultCount
	end

	--搜索同花
	local cbCardData = clone(cbHandCardData)
	GameLogic:SortCardList(cbCardData, cbHandCardCount, GameLogic.enAscend)

	local cbSameCardCount = {0, 0, 0, 0}
	local cbSameCardData = {{0,0,0,0,0,0,0,0,0,0,0,0,0},
					  		{0,0,0,0,0,0,0,0,0,0,0,0,0},
					  		{0,0,0,0,0,0,0,0,0,0,0,0,0},
					  		{0,0,0,0,0,0,0,0,0,0,0,0,0}}

	for i=1,cbHandCardCount do
		--获取花色
		local cbCardColor = GameLogic.GetCardColor(cbCardData[i])
		--原牌数目
		local cbCount = cbSameCardCount[cbCardColor+1]
		--追加扑克
		cbSameCardData[cbCardColor+1][cbCount+1] = cbCardData[i]
		cbSameCardCount[cbCardColor+1] = cbSameCardCount[cbCardColor+1] + 1
	end

	local pSearchCardResult = GameLogic.getSearchCardResult()
	for i=1,4 do
		if cbSameCardCount[i] >= cbLineCount then
			local cbLineResultCount, tagTempResult = GameLogic:SearchLineCardType(cbSameCardData[i], cbSameCardCount[i], cbLineCount)
			if cbLineResultCount > 0 then
				for i=1,cbLineResultCount do
					pSearchCardResult.cbCardCount[cbResultCount+1] = cbLineCount
					pSearchCardResult.cbResultCard[cbResultCount+1] = clone(tagTempResult.cbResultCard[i])
					cbResultCount = cbResultCount + 1
				end
			end
		end
	end
	pSearchCardResult.cbSearchCount = cbResultCount
	return cbResultCount, pSearchCardResult
end

--比较扑克
function GameLogic:CompareCard(bInFirstList, bInNextList, bFirstCount, bNextCount, bComperWithOther)
	if bFirstCount ~= 3 and bFirstCount ~= 5 then
		return GameLogic.enCRError 
	end
	bComperWithOther = true
	if bFirstCount ~= bNextCount then
		bComperWithOther = false
	end

	local bFirstList = clone(bInFirstList)
	local bNextList = clone(bInNextList)
	--排序牌组
	GameLogic:SortCardList(bFirstList, bFirstCount, GameLogic.enDescend)
	GameLogic:SortCardList(bNextList, bNextCount, GameLogic.enDescend)
	--分析牌组
	local FirstAnalyseData = GameLogic:AnalyseCard(bFirstList, bFirstCount)
	local NextAnalyseData = GameLogic:AnalyseCard(bNextList, bNextCount)

	if bFirstCount ~= FirstAnalyseData.bOneCount+FirstAnalyseData.bTwoCount*2+FirstAnalyseData.bThreeCount*3+FirstAnalyseData.bFourCount*4 then
		return GameLogic.enCRError
	end
	if bNextCount ~= NextAnalyseData.bOneCount+NextAnalyseData.bTwoCount*2+NextAnalyseData.bThreeCount*3+NextAnalyseData.bFourCount*4 then
		return GameLogic.enCRError
	end

	local cbNextType = GameLogic:GetCardType(bNextList, bNextCount)  
	local cbFirstType = GameLogic:GetCardType(bFirstList, bFirstCount)
	if cbNextType == GameLogic.CT_INVALID or cbFirstType == GameLogic.CT_INVALID then
		return GameLogic.enCRError
	end

	--同段比较
	if true == bComperWithOther then
		if cbNextType == cbFirstType then
			if cbFirstType == GameLogic.CT_SINGLE then 	--单牌类型
				if bFirstList[1] == bNextList[1] then
					return GameLogic.enCRError
				end
				for i=1,bFirstCount do
					if GameLogic:GetCardLogicValue(bNextList[i]) > GameLogic:GetCardLogicValue(bFirstList[i]) then
						return GameLogic.enCRGreater
					elseif GameLogic:GetCardLogicValue(bNextList[i]) < GameLogic:GetCardLogicValue(bFirstList[i]) then
						return GameLogic.enCRLess
					end
				end
				return GameLogic.enCREqual
			elseif cbFirstType == GameLogic.CT_ONE_DOUBLE then 	--对带一张
				local nextTwoValue = GameLogic:GetCardLogicValue(bNextList[NextAnalyseData.bTwoFirst[1]])
				local firstTwoValue = GameLogic:GetCardLogicValue(bFirstList[FirstAnalyseData.bTwoFirst[1]])
				if nextTwoValue == firstTwoValue then
					local nextOneValue = GameLogic:GetCardLogicValue(bNextList[NextAnalyseData.bOneFirst[1]])
					local firstOneValue = GameLogic:GetCardLogicValue(bFirstList[FirstAnalyseData.bOneFirst[1]])
					if nextOneValue > firstOneValue then
						return GameLogic.enCRGreater
					elseif nextOneValue < firstOneValue then
						return GameLogic.enCRLess
					else
						return GameLogic.enCREqual
					end
				elseif nextTwoValue > firstTwoValue then
					return GameLogic.enCRGreater
				else
					return GameLogic.enCRLess
				end
			elseif cbFirstType == GameLogic.CT_TWO_DOUBLE then 	--两对牌型
				if bNextList[NextAnalyseData.bTwoFirst[1]] == bFirstList[FirstAnalyseData.bTwoFirst[1]] then
					return GameLogic.enCRError
				end
				local nextTwoValue = GameLogic:GetCardLogicValue(bNextList[NextAnalyseData.bTwoFirst[1]])
				local firstTwoValue = GameLogic:GetCardLogicValue(bFirstList[FirstAnalyseData.bTwoFirst[1]])
				if nextTwoValue == firstTwoValue then
					local nextTwoValue1 = GameLogic:GetCardLogicValue(bNextList[NextAnalyseData.bTwoFirst[2]])
					local firstTwoValue1 = GameLogic:GetCardLogicValue(bFirstList[FirstAnalyseData.bTwoFirst[2]])
					if nextTwoValue1 == firstTwoValue1 then
						local nextOneValue = GameLogic:GetCardLogicValue(bNextList[NextAnalyseData.bOneFirst[1]])
						local firstOneValue = GameLogic:GetCardLogicValue(bFirstList[FirstAnalyseData.bOneFirst[1]])
						if nextOneValue > firstOneValue then
							return GameLogic.enCRGreater
						elseif nextOneValue < firstOneValue then
							return GameLogic.enCRLess
						else
							return GameLogic.enCREqual
						end
					elseif nextTwoValue1 > firstTwoValue1 then
						return GameLogic.enCRGreater
					else
						return GameLogic.enCRLess
					end	
				elseif nextTwoValue > firstTwoValue then
					return GameLogic.enCRGreater
				else
					return GameLogic.enCRLess
				end
			elseif cbFirstType == GameLogic.CT_THREE then 	--三张牌型
				local nextThreeValue = GameLogic:GetCardLogicValue(bNextList[NextAnalyseData.bThreeFirst[1]])
				local firstThreeValue = GameLogic:GetCardLogicValue(bFirstList[FirstAnalyseData.bThreeFirst[1]])
				if nextThreeValue > firstThreeValue then
					return GameLogic.enCRGreater
				elseif nextThreeValue < firstThreeValue then
					return GameLogic.enCRLess
				else
					return GameLogic.enCREqual
				end
			elseif cbFirstType == GameLogic.CT_FIVE_THREE_DEOUBLE then 	--三条一对
				local nextThreeValue = GameLogic:GetCardLogicValue(bNextList[NextAnalyseData.bThreeFirst[1]])
				local firstThreeValue = GameLogic:GetCardLogicValue(bFirstList[FirstAnalyseData.bThreeFirst[1]])
				if nextThreeValue == firstThreeValue then
					local nextTwoValue = GameLogic:GetCardLogicValue(bNextList[NextAnalyseData.bTwoFirst[1]])
					local firstTwoValue = GameLogic:GetCardLogicValue(bFirstList[FirstAnalyseData.bTwoFirst[1]])
					if nextTwoValue > firstTwoValue then
						return GameLogic.enCRGreater
					elseif nextTwoValue < firstTwoValue then
						return GameLogic.enCRLess
					else
						return GameLogic.enCREqual
					end
				elseif nextThreeValue > firstThreeValue then
					return GameLogic.enCRGreater
				else
					return GameLogic.enCRLess
				end
			elseif cbFirstType == GameLogic.CT_FIVE_MIXED_FLUSH_FIRST_A or 
				cbFirstType == GameLogic.CT_FIVE_MIXED_FLUSH_BACK_A then --A在前顺子，A在后顺子
				return GameLogic.enCREqual
			elseif cbFirstType == GameLogic.CT_FIVE_MIXED_FLUSH_NO_A or 
				cbFirstType == GameLogic.CT_FIVE_FLUSH then 	--没A杂顺，同花五牌
				for i=1,5 do
					if GameLogic:GetCardLogicValue(bNextList[i]) > GameLogic:GetCardLogicValue(bFirstList[i]) then
						return GameLogic.enCRGreater
					elseif GameLogic:GetCardLogicValue(bNextList[i]) < GameLogic:GetCardLogicValue(bFirstList[i]) then
						return GameLogic.enCRLess
					end
				end

				for i=1,5 do
					if GameLogic.GetCardColor(bNextList[i]) > GameLogic.GetCardColor(bFirstList[i]) then
						return GameLogic.enCRGreater
					elseif GameLogic.GetCardColor(bNextList[i]) < GameLogic.GetCardColor(bFirstList[i]) then
						return GameLogic.enCRLess
					end
				end
			elseif cbFirstType == GameLogic.CT_FIVE_FOUR_ONE then 	--四带一张
				if GameLogic:GetCardLogicValue(bNextList[NextAnalyseData.bFourFirst[1]]) > GameLogic:GetCardLogicValue(bFirstList[FirstAnalyseData.bFourFirst[1]]) then
					return GameLogic.enCRGreater
				else
					return GameLogic.enCRLess
				end
			elseif cbFirstType == GameLogic.CT_FIVE_STRAIGHT_FLUSH_FIRST_A or 
				cbFirstType == GameLogic.CT_FIVE_STRAIGHT_FLUSH_BACK_A then --A在前同花顺，A在后同花顺
				return GameLogic.enCREqual
			elseif cbFirstType == GameLogic.CT_FIVE_STRAIGHT_FLUSH_NO_A then 	--同花顺牌
				for i=1,5 do
					if GameLogic:GetCardLogicValue(bNextList[i]) > GameLogic:GetCardLogicValue(bFirstList[i]) then
						return GameLogic.enCRGreater
					elseif GameLogic:GetCardLogicValue(bNextList[i]) < GameLogic:GetCardLogicValue(bFirstList[i]) then
						return GameLogic.enCRLess
					end
				end

				for i=1,5 do
					if GameLogic.GetCardColor(bNextList[i]) > GameLogic.GetCardColor(bFirstList[i]) then
						return GameLogic.enCRGreater
					elseif GameLogic.GetCardColor(bNextList[i]) < GameLogic.GetCardColor(bFirstList[i]) then
						return GameLogic.enCRLess
					end
				end
			else
				return GameLogic.enCRError	
			end
		else
			if cbNextType > cbFirstType then
				return GameLogic.enCRGreater
			else
				return GameLogic.enCRLess
			end
		end
	--不同段比较
	else
		if cbFirstType ~= GameLogic.CT_SINGLE and cbFirstType ~= GameLogic.CT_ONE_DOUBLE and cbFirstType ~= GameLogic.CT_THREE then
			return GameLogic.enCRError
		end
		if cbFirstType == cbNextType then
			if cbFirstType == GameLogic.CT_SINGLE then --单牌类型
				if bFirstList[1] == bNextList[1] then
					return GameLogic.enCRError
				end
				for i=1,bFirstCount do
					if GameLogic:GetCardLogicValue(bNextList[i]) > GameLogic:GetCardLogicValue(bFirstList[i]) then
						return GameLogic.enCRGreater
					elseif GameLogic:GetCardLogicValue(bNextList[i]) < GameLogic:GetCardLogicValue(bFirstList[i]) then
						return GameLogic.enCRLess
					end
				end
				if bNextCount > bFirstCount then
					return GameLogic.enCRGreater
				else
					return GameLogic.enCRLess
				end
			elseif cbFirstType == GameLogic.CT_ONE_DOUBLE then 	--对带一张
				local nextTwoValue = GameLogic:GetCardLogicValue(bNextList[NextAnalyseData.bTwoFirst[1]])
				local firstTwoValue = GameLogic:GetCardLogicValue(bFirstList[FirstAnalyseData.bTwoFirst[1]])
				if nextTwoValue == firstTwoValue then
					local nextOneValue = GameLogic:GetCardLogicValue(bNextList[NextAnalyseData.bOneFirst[1]])
					local firstOneValue = GameLogic:GetCardLogicValue(bFirstList[FirstAnalyseData.bOneFirst[1]])
					if nextOneValue > firstOneValue then
						return GameLogic.enCRGreater
					elseif nextOneValue < firstOneValue then
						return GameLogic.enCRLess
					else
						if bNextCount > bFirstCount then
							return GameLogic.enCRGreater
						else
							return GameLogic.enCRLess
						end
					end
				elseif nextTwoValue > firstTwoValue then
					return GameLogic.enCRGreater
				else
					return GameLogic.enCRLess
				end
			elseif cbFirstType == GameLogic.CT_THREE then 	--三张牌型
				local nextThreeValue = GameLogic:GetCardLogicValue(bNextList[NextAnalyseData.bThreeFirst[1]])
				local firstThreeValue = GameLogic:GetCardLogicValue(bFirstList[FirstAnalyseData.bThreeFirst[1]])
				if nextThreeValue > firstThreeValue then
					return GameLogic.enCRGreater
				elseif nextThreeValue < firstThreeValue then
					return GameLogic.enCRLess
				else
					if bNextCount > bFirstCount then
						return GameLogic.enCRGreater
					else
						return GameLogic.enCRLess
					end
				end
			else
				return GameLogic.enCRError
			end
		else
			if cbNextType > cbFirstType then
				return GameLogic.enCRGreater
			else
				return GameLogic.enCRLess
			end
		end
	end
end

--找出所有牌型
function GameLogic:sortAllCarsType(cbCardData,cbCardCount)

	local SortResult = {}
	local SortRecord = {}

	if cbCardCount == 0  then
		return
	end

	-- 一对
	SortResult.bTwoCount = false
	SortResult.cbTwoList = {}

	--两对
	SortResult.bTwoDouleCount = false
	SortResult.cbTwoDoubleList = {}

	--三条 
	SortResult.bThreeCount = false
	SortResult.cbThreeList = {}

	--顺子
	SortResult.bLineCount = false
	SortResult.cbLineList = {}

	--同花
	SortResult.bSameColorCount = false
	SortResult.cbSameColorList = {}

	--葫芦
	SortResult.bThreeDouleCount = false
	SortResult.cbThreeDouleList = {}

	--铁支
	SortResult.bFourOneCount  = false
	SortResult.cbFourOneList = {}

	--同花顺(五毒) 
	SortResult.bFiveFlushCount = false
	SortResult.cbFiveFlushList = {}

	local SearchCardCount,SearchCardResult = GameLogic:SearchSameCard(cbCardData, cbCardCount, 2)
	--一对
	if SearchCardCount > 0 then
		SortResult.bTwoCount = true
		for i=1,SearchCardCount do
			local two = {}
			for j=1,SearchCardResult.cbCardCount[i] do
				table.insert(two, SearchCardResult.cbResultCard[i][j])
			end
			table.insert(SortResult.cbTwoList, two)
		end
	end

	--两对
	if SearchCardCount > 1 then
		SortResult.bTwoDouleCount = true
		for i=1, SearchCardCount-1 do
			for j=i+1, SearchCardCount do
				local double = {}
				table.insert(double, SearchCardResult.cbResultCard[i][1])
				table.insert(double, SearchCardResult.cbResultCard[i][2])
				table.insert(double, SearchCardResult.cbResultCard[j][1])
				table.insert(double, SearchCardResult.cbResultCard[j][2])
				table.insert(SortResult.cbTwoDoubleList, double)
			end
		end
	end

	--三条
	SearchCardCount,SearchCardResult = GameLogic:SearchSameCard(cbCardData, cbCardCount, 5)
	
	if SearchCardCount > 0 then
		SortResult.bThreeCount =  true
		for i=1, SearchCardCount do
			local three = {}
			for j=1,SearchCardResult.cbCardCount[i] do
				table.insert(three, SearchCardResult.cbResultCard[i][j])
			end
			table.insert(SortResult.cbTwoList, three)
		end
	end

	--顺子
	SearchCardCount,SearchCardResult = GameLogic:SearchLineCardType(cbCardData, cbCardCount, 5)
	if SearchCardCount > 0 then
		SortResult.bLineCount =  true
		for i=1, SearchCardCount do
			local line = {}
			for j=1,SearchCardResult.cbCardCount[i] do
				table.insert(line, SearchCardResult.cbResultCard[i][j])
			end
			table.insert(SortResult.cbLineList, line)
		end
	end

	--同花
	SearchCardCount,SearchCardResult = GameLogic:SearchSameColorType(cbCardData, cbCardCount, 5)
	if SearchCardCount > 0 then
		SortResult.bSameColorCount =  true
		for i=1, SearchCardCount do
			local samecolor = {}
			for j=1,SearchCardResult.cbCardCount[i] do
				table.insert(samecolor, SearchCardResult.cbResultCard[i][j])
			end
			table.insert(SortResult.cbSameColorList, samecolor)
		end
	end

	--葫芦
	SearchCardCount,SearchCardResult = GameLogic:SearchTakeCardType(cbCardData, cbCardCount, 3, 2)
	if SearchCardCount > 0 then
		SortResult.bThreeDouleCount =  true
		for i=1, SearchCardCount do
			local threedouble = {}
			for j=1,SearchCardResult.cbCardCount[i] do
				table.insert(threedouble, SearchCardResult.cbResultCard[i][j])
			end
			table.insert(SortResult.cbThreeDouleList, threedouble)
		end
	end
	
	--铁支
	SearchCardCount,SearchCardResult = GameLogic:SearchTakeCardType(cbCardData, cbCardCount, 4, 1)
	if SearchCardCount > 0 then
		SortResult.bFourOneCount = true
		for i=1, SearchCardCount do
			local fourone = {}
			for j=1,SearchCardResult.cbCardCount[i] do
				table.insert(fourone, SearchCardResult.cbResultCard[i][j])
			end
			table.insert(SortResult.cbFourOneList, fourone)
		end
	end

 	--同花顺
 	SearchCardCount,SearchCardResult = GameLogic:SearchSameColorLineType(cbCardData, cbCardCount, 5)
 	if SearchCardCount > 0 then
 		SortResult.bFiveFlushCount = true
		for i=1, SearchCardCount do
			local fiveflush = {}
			for j=1,SearchCardResult.cbCardCount[i] do
				table.insert(fiveflush, SearchCardResult.cbResultCard[i][j])
			end
			table.insert(SortResult.cbFiveFlushList, fiveflush)
		end
 	end

	table.insert(SortRecord,{bTag=SortResult.bTwoCount,list=SortResult.cbTwoList})
	table.insert(SortRecord,{bTag=SortResult.bTwoDouleCount,list=SortResult.cbTwoDoubleList})
	table.insert(SortRecord,{bTag=SortResult.bThreeCount,list=SortResult.cbThreeList})
	table.insert(SortRecord,{bTag=SortResult.bLineCount,list=SortResult.cbLineList})
	table.insert(SortRecord,{bTag=SortResult.bSameColorCount,list=SortResult.cbSameColorList})
	table.insert(SortRecord,{bTag=SortResult.bThreeDouleCount,list=SortResult.cbThreeDouleList})
	table.insert(SortRecord,{bTag=SortResult.bFourOneCount,list=SortResult.cbFourOneList})
	table.insert(SortRecord,{bTag=SortResult.bFiveFlushCount,list=SortResult.cbFiveFlushList})

	return SortResult,SortRecord

end

function GameLogic:MackCardData(cbValueIndex, cbColorIndex)
	return cbValueIndex + (cbColorIndex-1)*16
end

return GameLogic

