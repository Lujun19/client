local GameLogic = {}
--同样的牌型，庄家获胜
--牌库数目
GameLogic.TOTAL_COUNT				= 40

--动作标志
GameLogic.WIK_NULL					= 0x00                 --没有任何动作

--牌型
GameLogic.CARD_TYPE =
{	
	PAIR_CARD       = 3,                                   --对子
	SPECIAL_CARD    = 2,                                   --特殊牌型2+8
	POINT_CARD      = 1						               --普通牌型
}                

--赢家
GameLogic.WINER = 
{
	PLAYER_NULL     =  0,                                  --平     
	PLAYER_ONE      =  1,                      			   --玩家1获胜  玩家1为庄家
	PLAYER_TWO      =  2                                   --玩家2获胜
}

GameLogic.LocalCardData = 
{
	0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09,  --筒
	0x10												       --白板
}

GameLogic.TotalCardData = 
{
	0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, --筒
	0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09,
	0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09,
	0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09,
	0x10, 0x10, 0x10, 0x10                                --白板
}

function GameLogic.SwitchToCardIndex(card)
	local index = 0
	for i=1, #GameLogic.LocalCardData do
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
	assert(index >=1 and index <= 10, "The card index is error!")
	return GameLogic.LocalCardData[index]
end

--计算点数
function GameLogic.GetCardPoint(tab)
	local point = 0
	assert(#tab<=2, "The num of card is error")
	for i=1, #tab do
		point = GameLogic.SwitchToCardIndex(tab[i]) + point
	end
	point = point%10
	return point
end

--判断牌型以及点数
function GameLogic.GetCardType(tab)
	assert(#tab<=2, "The num of card is error")
	local index1 = GameLogic.SwitchToCardIndex(tab[1])
	local index2 = GameLogic.SwitchToCardIndex(tab[2])

	if index1 == index2 then
		return GameLogic.CARD_TYPE.PAIR_CARD, index1%10
	end

	if (index1 == 2 and index2 == 8) or (index1 == 8 and index2 == 2) then
		return GameLogic.CARD_TYPE.SPECIAL_CARD, 0
	end
	return GameLogic.CARD_TYPE.POINT_CARD, GameLogic.GetCardPoint(tab)
end

--判断大小,玩家谁获胜
function GameLogic.GetWinner(tab1, tab2)
	--对子比大小
	local function JudgePair(tab1, tab2) 
		local index1 = GameLogic.SwitchToCardIndex(tab1[1])
		local index2 = GameLogic.SwitchToCardIndex(tab2[1])
		if index1 >= index2 then
			return GameLogic.WINER.PLAYER_ONE
		elseif index1 < index2 then
			return GameLogic.WINER.PLAYER_TWO
		end
	end
	--普通牌型比大小
	local function JudgePoint(tab1, tab2)
		local function Max (tmp)
			if tmp[1] >= tmp[2] then
				return tmp[1]
			else
				return tmp[2]
			end
		end

		local point1 = GameLogic.GetCardPoint(tab1)
		local point2 = GameLogic.GetCardPoint(tab2)
		if point1 > point2 then
			return GameLogic.WINER.PLAYER_ONE
		elseif point1 == point2 then
			if Max(tab1) >= Max(tab2) then
				return GameLogic.WINER.PLAYER_ONE
			else
				return GameLogic.WINER.PLAYER_TWO
			end
		else
			return GameLogic.WINER.PLAYER_TWO
		end
	end

	assert(#tab1==2, "The num of card is error")
	assert(#tab2==2, "The num of card is error")
	local cardType1, point1 = GameLogic.GetCardType(tab1)
	local cardType2, point2 = GameLogic.GetCardType(tab2)

	if cardType1 > cardType2 then
		return GameLogic.WINER.PLAYER_ONE
	elseif cardType1 < cardType2 then
		return GameLogic.WINER.PLAYER_TWO
	else

		if cardType1 == GameLogic.CARD_TYPE.SPECIAL_CARD then
			return GameLogic.WINER.PLAYER_ONE
		elseif cardType1 == GameLogic.CARD_TYPE.PAIR_CARD then
			return JudgePair(tab1, tab2)
		elseif cardType1 == GameLogic.CARD_TYPE.POINT_CARD then
			return JudgePoint(tab1, tab2)
		end
	end
end

return GameLogic	