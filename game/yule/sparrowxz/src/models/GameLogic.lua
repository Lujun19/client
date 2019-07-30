local GameLogic = {}

--牌库数目
GameLogic.FULL_COUNT				= 108

--动作标志
GameLogic.WIK_NULL					= 0x00						--没有类型--0
GameLogic.WIK_LEFT					= 0x01						--左吃类型--1
GameLogic.WIK_CENTER				= 0x02						--中吃类型--2
GameLogic.WIK_RIGHT					= 0x04						--右吃类型--4
GameLogic.WIK_PENG					= 0x08						--碰牌类型--8
GameLogic.WIK_GANG					= 0x10						--杠牌类型--16
GameLogic.WIK_LISTEN				= 0x20						--听牌类型--32
GameLogic.WIK_CHI_HU				= 0x40						--吃胡类型--64

-- 杠：分为“明杠“，”暗杠“，”补杠“，明杠和补杠为“刮风”，暗杠为“下雨”。
-- 明杠：其他玩家打出一张牌，手牌中存在三张跟这张牌一样的牌时，可以选择杠，选择“杠“后，玩家从牌库中抓一牌（牌堆末尾拿牌），并需要从手牌中打出一张牌，随后轮到下家出牌。
-- 暗杠：轮到玩家自己回合出牌时，手牌中存在四张一样的牌，可以选择杠，选择“杠”后，玩家从牌库中抓一张牌（牌堆末尾拿牌），并需要从手牌中打出一张牌，随后轮到下家出牌。
-- 补杠：轮到玩家自己回合出牌时，手牌中存在一张牌且正好自己碰过这张牌时，可以选择杠，选择“杠“后，玩家从牌库中抓一牌（牌堆末尾拿牌），并需要从手牌中打出一张牌，随后轮到下家出牌。

--显示类型
GameLogic.SHOW_NULL					= 0							--无操作
GameLogic.SHOW_PENG					= 1 						--碰
GameLogic.SHOW_MING_GANG			= 2							--明杠
GameLogic.SHOW_AN_GANG				= 3							--暗杠
GameLogic.SHOW_BU_GANG              = 4							--补杠
 
GameLogic.LocalCardData = 
{
	0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09,
	0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 0x18, 0x19,
	0x21, 0x22, 0x23, 0x24, 0x25, 0x26, 0x27, 0x28, 0x29
}

GameLogic.TotalCardData = 
{
	0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, --万
	0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09,
	0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09,
	0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09,
	0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 0x18, 0x19, --索
	0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 0x18, 0x19,
	0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 0x18, 0x19,
	0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 0x18, 0x19,
	0x21, 0x22, 0x23, 0x24, 0x25, 0x26, 0x27, 0x28, 0x29, --筒
	0x21, 0x22, 0x23, 0x24, 0x25, 0x26, 0x27, 0x28, 0x29,
	0x21, 0x22, 0x23, 0x24, 0x25, 0x26, 0x27, 0x28, 0x29,
	0x21, 0x22, 0x23, 0x24, 0x25, 0x26, 0x27, 0x28, 0x29,
}


function GameLogic.SwitchToCardIndex(card)
	local index = 0
	for i = 1, #GameLogic.LocalCardData do
		if GameLogic.LocalCardData[i] == card then
			index = i
			break
		end
	end
	local strError = string.format("The card %d is error!", card)
	assert(index ~= 0, strError)
	return index
end

function GameLogic.SwitchToCardData(index)
	assert(index >= 1 and index <= 27, "The card index is error!")
	return GameLogic.LocalCardData[index]
end

function GameLogic.DataToCardIndex(cbCardData)
	assert(type(cbCardData) == "table")
	--初始化
	local cbCardIndex = {}
	for i = 1, 27 do
		cbCardIndex[i] = 0
	end
	--累加
	for i = 1, #cbCardData do
		local bCardExist = false
		for j = 1, 27 do
			if cbCardData[i] == GameLogic.LocalCardData[j] then
				cbCardIndex[j] = cbCardIndex[j] + 1
				bCardExist = true
				break
			end
		end
		if not bCardExist then
			print("index:",i,"card:",cbCardData[i],"not exist")
		end
		assert(bCardExist, "This card is not exist!")
	end

	return cbCardIndex
end

--删除扑克
function GameLogic.RemoveCard(cbCardData, cbRemoveCard)
	assert(type(cbCardData) == "table" and type(cbRemoveCard) == "table")
	local cbCardCount, cbRemoveCount = #cbCardData, #cbRemoveCard
	assert(cbRemoveCount <= cbCardCount)

	--置零扑克
	for i = 1, cbRemoveCount do
		for j = 1, cbCardCount do
			if cbRemoveCard[i] == cbCardData[j] then
				cbCardData[j] = 0
				break
			end
		end
	end
	--清理扑克
	local resultData = {}
	local cbCardPos = 1
	for i = 1, cbCardCount do
		if cbCardData[i] ~= 0 then
			resultData[cbCardPos] = cbCardData[i]
			cbCardPos = cbCardPos + 1
		end
	end

	return resultData
end

--混乱扑克
function GameLogic.RandCardList(cbCardData)
	assert(type(cbCardData) == "table")
	--混乱准备
	local cbCardCount = #cbCardData
	local cbCardTemp = clone(cbCardData)
	local cbCardBuffer = {}
	--开始
	local cbRandCount, cbPosition = 0, 0
	while cbRandCount < cbCardCount do
		cbPosition = math.random(cbCardCount - cbRandCount)
		cbCardBuffer[cbRandCount + 1] = cbCardTemp[cbPosition]
		cbCardTemp[cbPosition] = cbCardTemp[cbCardCount - cbRandCount]
		cbRandCount = cbRandCount + 1
	end
	return cbCardBuffer
end

--排序
function GameLogic.SortCardList(cbCardData,sendcard,callcard) 
	assert(sendcard~=0)
	print("sendcard,callcard:",sendcard,callcard)
	local str=table.concat(cbCardData,",")
	print("before sort ",#cbCardData,str)

	 for i=#cbCardData,1,-1 do
	 	if cbCardData[i]<1 or cbCardData[i]>41 then
	 		table.remove(cbCardData,i)
	 	end
	 end

	 str=table.concat(cbCardData,",")
	 print("after remove:",#cbCardData,str)

	--校验
	assert(type(cbCardData) == "table")
	if #cbCardData==0 then return cbCardData end
	table.sort(cbCardData, function(a, b) 
				local kindA=math.ceil(a/16)
				local kindB=math.ceil(b/16)
				if kindA==callcard and kindB~=callcard then
					return false
				elseif kindA~=callcard and kindB==callcard then 
					return true
				else
					return a < b 
				end
			end)
	
	local index=-1
	for i=1,#cbCardData do
		if cbCardData[i]==sendcard then
			index=i 
			break
		end
	end
	if index~=-1 then
		table.remove(cbCardData,index)
		table.insert(cbCardData,sendcard)
	end

	str=table.concat(cbCardData,",")
	print("after sort: ",#cbCardData,str)
	return cbCardData
end

function GameLogic.callCardHint(cbCardData)--选缺
	local str=table.concat(cbCardData,",")
	print("GameLogic.callCardHint:",str)
	print("#cbCardData:",#cbCardData)
	assert(#cbCardData==13 or #cbCardData==14)
	local tabCard={{},{},{}}
	for k,v in ipairs(cbCardData) do
		local kind=math.ceil(v/16)
		table.insert(tabCard[kind],v)
	end
	
	local t={1,2,3}
	table.sort(t,function(a,b) return #tabCard[a]<#tabCard[b] end)
	local a,b=t[1],t[2]
	if #tabCard[a]==#tabCard[b] then --如果最少牌数的花色有两种
		GameLogic.SortCardList(tabCard[a])--若cbCardData已排序，则此处可略
		GameLogic.SortCardList(tabCard[b])
		local tabA=GameLogic.analysisCard(tabCard[a])
		local tabB=GameLogic.analysisCard(tabCard[b])
		return GameLogic.getValueOfCards(tabA)<GameLogic.getValueOfCards(tabB) and a or b
	else 
		return t[1]
	end
end

function GameLogic.getValueOfCards(tab) --tab为GameLogic.analysisCard返回的值
	local value={10,11,12,12,13,14}
	local div={1,2,2,3,3,4}
	local totalValue=0
	for i=1,6 do
		local n=#tab[i]   
		totalValue=totalValue+value[i]*n
	end
	return totalValue
end

function GameLogic.canChiHu(cbCardData,callCardKind)
	local tabCard={{},{},{}}
	for k,v in ipairs(cbCardData) do
		local kind=math.ceil(v/16)
		if callCardKind==kind then return false end
		table.insert(tabCard[kind],v)
	end
	local div={1,2,2,3,3,4}
	local tabNum={0,0,0,0,0,0}
	for i=1,3 do
		if #tabCard[i]>0 then
			local ret=GameLogic.analysisCard(tabCard[i])
		end
		for j=1,6 do
			tabNum[j]=tabNum[j]+#ret[j]/div[j]
		end
	end
	if tabNum[1]+tabNum[2]+tabNum[6]==0 and tabNum[3]==1 then
		return true
	end
	return false
end

function GameLogic.analysisCard(tab)--tab一种花色且有序  
--1:单个 2:两连续 3:两同 4:三连续 5:三同 6:四同
	local ret={}
	for i=1,6 do
		ret[i]={}
	end
	local i=1
	while i<=#tab do
		local index=-1
		local j=i
		if tab[i+1]==nil or tab[i+1]-tab[i]>1 then
			index=1
			j=i+1
		elseif tab[i+2]==nil or tab[i+2]-tab[i+1]>1 then
			index=3-(tab[i+1]-tab[i])
			j=i+2
		elseif tab[i+3]==tab[i] then
			index=6
			j=i+4
		else
			if tab[i+2]==tab[i] then
				index=5
				j=i+3
			elseif tab[i+2]-tab[i]==2 then
				index=4
				j=i+3
			elseif tab[i+1]==tab[i] then
				index=3
				j=i+2
			elseif tab[i+1]==tab[i+2] then
				table.insert(ret[1],tab[i])
				index=3
				j=i+3
				i=i+1 
			end
		end
		for k=i,j-1 do
			assert(index>0)
			table.insert(ret[index],tab[k])
		end
		i=j
	end

	for i=1,#tab do
		print("tab"..i,tab[i])
	end

	local temp={}
	for i=1,6 do
		for j=1,#ret[i] do
			print("retij:",i,j,ret[i][j])
			table.insert(temp,ret[i][j])
		end
	end
	assert(#temp==#tab)
	table.sort(temp,function(a,b) return a<b end) 
	table.sort(tab,function(a,b) return a<b end)
	for i=1,#tab do
		print(tab[i],temp[i])
		assert(tab[i]==temp[i])
	end
	return ret
end

function GameLogic.changeCardHint(cbCardData) --返回值为索引，非牌值  换三张 --3张必须同一种花色的做法 
	assert(#cbCardData==13 or #cbCardData==14)
	local tabCard={{},{},{}}
	local strs={}
	local ks={"万","条","筒"}
	for k,v in ipairs(cbCardData) do
		local kind=math.ceil(v/16)
		table.insert(tabCard[kind],v)
		table.insert(strs, (v%16)..ks[kind])
	end
	print("before hint cards:",table.concat(strs,","))
	local tabs={}
	local values={}
	for i=1,3 do
		if #tabCard[i]>=3 then
			GameLogic.SortCardList(tabCard[i])--若cbCardData已排序，则此处可略
			tabs[i]=GameLogic.analysisCard(tabCard[i])
			values[i]=GameLogic.getValueOfCards(tabs[i])
		else
			values[i]=1000000 --使得该花色不被选中
		end
	end

	-- for i=1,3 do
	-- 	for j=1,6 do
	-- 		for k=1,#tabs[i][j] do
	-- 			print(i,j,k,tabs[i][j])
	-- 		end
	-- 	end
	-- end
	
	local temp=values[1]<values[2] and 1 or 2
	local index=values[3]<values[temp] and 3 or temp
	local cards=tabs[index]
	local threeCards={}
	for i=1,6 do
		local bExit=false
		for j=1,#cards[i] do
			table.insert(threeCards,cards[i][j])
			if #threeCards>=3 then bExit=true break end
		end
		if bExit==true then break end
	end

	print(GlobalUserItem.szNickName ,"threeCards",threeCards[1],threeCards[2],threeCards[3])
	local ret={}
	local choosed={}
	for i=1,#threeCards do
		local found=false
		for j=1,#cbCardData do
			if choosed[j]~=true and cbCardData[j]==threeCards[i] then
				table.insert(ret,j)
				choosed[j]=true
				found=true
				break
			end
		end
		print("card"..i,threeCards[i])
		if false==found then
			for j=1,#cbCardData do
				print("card"..j,cbCardData[j])
			end
		end
		assert(found==true)
	end
	print("#ret:",#ret)
	assert(#ret==3)
	return ret
end

return GameLogic