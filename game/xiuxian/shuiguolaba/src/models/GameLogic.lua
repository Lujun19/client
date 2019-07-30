local GameLogic = GameLogic or {}

--数目定义
GameLogic.ITEM_COUNT 				= 9		        --图标数量
GameLogic.ITEM_X_COUNT				= 5				--图标横坐标数量
GameLogic.ITEM_Y_COUNT				= 3				--图标纵坐标数量
GameLogic.YAXIANNUM					= 1				--压线数字

--逻辑类型
GameLogic.CT_FUTOU					= 0				--香蕉
GameLogic.CT_YINGQIANG				= 1				--西瓜
GameLogic.CT_DADAO					= 2				--芒果
GameLogic.CT_LU						= 3				--葡萄
GameLogic.CT_LIN					= 4				--菠萝
GameLogic.CT_SONG					= 5				--铃铛
GameLogic.CT_TITIANXINGDAO			= 6				--樱桃
GameLogic.CT_ZHONGYITANG			= 7				--酒吧
GameLogic.CT_BONUS			        = 8			    --SCATTER  --连续五个 获得奖池奖金
GameLogic.CT_SCATTER			    = 9		        --BONUS	  --连续三列 免费摇奖
GameLogic.CT_SHUIHUZHUAN		    = 10	        --珍珠 --可以代替任何水果 除了 9 和10 
--可能中奖的位置线
GameLogic.m_ptXian = {}

GameLogic.m_ptXian[1] = {{x=2,y=1},{x=2,y=2},{x=2,y=3},{x=2,y=4},{x=2,y=5}} --第二条直线
GameLogic.m_ptXian[2] = {{x=1,y=1},{x=1,y=2},{x=1,y=3},{x=1,y=4},{x=1,y=5}}	--第一条直线
GameLogic.m_ptXian[3] = {{x=3,y=1},{x=3,y=2},{x=3,y=3},{x=3,y=4},{x=3,y=5}}	--第三条直线
GameLogic.m_ptXian[4] = {{x=1,y=1},{x=2,y=2},{x=3,y=3},{x=2,y=4},{x=1,y=5}}	--	大v字
GameLogic.m_ptXian[5] = {{x=3,y=1},{x=2,y=2},{x=1,y=3},{x=2,y=4},{x=3,y=5}}	--  倒大v字  
GameLogic.m_ptXian[6] = {{x=1,y=1},{x=1,y=2},{x=2,y=3},{x=3,y=4},{x=3,y=5}}	--  
GameLogic.m_ptXian[7] = {{x=3,y=1},{x=3,y=2},{x=2,y=3},{x=1,y=4},{x=1,y=5}}
GameLogic.m_ptXian[8] = {{x=2,y=1},{x=1,y=2},{x=2,y=3},{x=3,y=4},{x=2,y=5}}
GameLogic.m_ptXian[9] = {{x=2,y=1},{x=3,y=2},{x=2,y=3},{x=1,y=4},{x=2,y=5}}
----------------------------------------------------------
--取得中奖分数
function GameLogic:GetZhongJiangTime( cbIndex ,cbItemInfo )
	local ptXian = GameLogic.m_ptXian[cbIndex]
	local item_x_count = GameLogic.ITEM_X_COUNT

	local nTime = 0
	local bLeftLink = true

	local nLeftBaseLindCount = 0
	local cbLeftFirstIndex = 1


	for i=1,item_x_count do
		--左
		if cbItemInfo[ptXian[i].x][ptXian[i].y] ~= GameLogic.CT_SHUIHUZHUAN and  bLeftLink == true then
			cbLeftFirstIndex = i
			bLeftLink = false
		end
	end

	bLeftLink = true

	for i=1,item_x_count do
		--左到右基本奖
		if cbItemInfo[ptXian[cbLeftFirstIndex].x][ptXian[cbLeftFirstIndex].y] == cbItemInfo[ptXian[i].x][ptXian[i].y] or cbItemInfo[ptXian[i].x][ptXian[i].y] == GameLogic.CT_SHUIHUZHUAN and bLeftLink == true then
			nLeftBaseLindCount = nLeftBaseLindCount + 1
		else
			bLeftLink = false
		end
	end


	if nLeftBaseLindCount == 5 then
		local itemType  = cbItemInfo[ptXian[cbLeftFirstIndex].x][ptXian[cbLeftFirstIndex].y] 
		if itemType == GameLogic.CT_FUTOU then
			nTime = nTime + 75
		elseif itemType == GameLogic.CT_YINGQIANG then
			nTime = nTime + 85
		elseif itemType == GameLogic.CT_DADAO then
			nTime = nTime + 250
		elseif itemType == GameLogic.CT_LU then
			nTime = nTime + 400
		elseif itemType == GameLogic.CT_LIN then
			nTime = nTime + 550
		elseif itemType == GameLogic.CT_SONG then
			nTime = nTime + 650
		elseif itemType == GameLogic.CT_TITIANXINGDAO then
			nTime = nTime + 800
		elseif itemType == GameLogic.CT_ZHONGYITANG then
			nTime = nTime + 1250
		elseif itemType == GameLogic.CT_SHUIHUZHUAN then
			nTime = nTime + 1000
        elseif itemType == GameLogic.CT_BONUS then
            nTime = nTime + 400
        elseif itemType ==GameLogic.CT_SCATTER then
            nTime = nTime + 1750
		end

	elseif nLeftBaseLindCount == 3 or nLeftBaseLindCount == 4 then
		local itemType  = cbItemInfo[ptXian[cbLeftFirstIndex].x][ptXian[cbLeftFirstIndex].y] 
		if itemType == GameLogic.CT_FUTOU then
			nTime = nTime + (nLeftBaseLindCount == 3 and 3 or 10)
		elseif  itemType == GameLogic.CT_YINGQIANG then
			nTime = nTime + (nLeftBaseLindCount == 3 and 3 or 10)
		elseif  itemType == GameLogic.CT_DADAO then
			nTime = nTime + (nLeftBaseLindCount == 3 and 15 or 40)
		elseif  itemType == GameLogic.CT_LU then
			nTime = nTime + (nLeftBaseLindCount == 3 and 25 or 50)
		elseif  itemType == GameLogic.CT_LIN then
			nTime = nTime + (nLeftBaseLindCount == 3 and 30 or 70)
		elseif  itemType == GameLogic.CT_SONG then
			nTime = nTime + (nLeftBaseLindCount == 3 and 35 or 80)
		elseif  itemType == GameLogic.CT_TITIANXINGDAO then
			nTime = nTime + (nLeftBaseLindCount == 3 and 45 or 100)
		elseif  itemType == GameLogic.CT_ZHONGYITANG then
			nTime = nTime + (nLeftBaseLindCount == 3 and 75 or 175)
		elseif  itemType == GameLogic.CT_SHUIHUZHUAN then
			nTime = nTime + (nLeftBaseLindCount == 3 and 0 or 0)
        elseif itemType == GameLogic.CT_BONUS then
            nTime = nTime +(nLeftBaseLindCount == 3 and 25 or 50)
        elseif itemType ==GameLogic.CT_SCATTER then
            nTime =nTime +(nLeftBaseLindCount == 3 and 100 or 200)
		end
    elseif  nLeftBaseLindCount == 2 then
       local itemType  = cbItemInfo[ptXian[cbLeftFirstIndex].x][ptXian[cbLeftFirstIndex].y] 
       if itemType == GameLogic.CT_FUTOU then
	       nTime = nTime + 1
       else
           nTime =  0
       end
	end
	return nTime
end
--全部中奖信息
function GameLogic:GetAllZhongJiangInfo( cbItemInfo ,ptZhongJiang)

	local cbZhongJiangCount = 0
	for i=1,GameLogic.ITEM_COUNT do
		cbZhongJiangCount = cbZhongJiangCount + self:GetZhongJiangXian(cbItemInfo,GameLogic.m_ptXian[i],ptZhongJiang[i])
	end

	return cbZhongJiangCount
end
--单条中奖信息
function GameLogic:getZhongJiangInfo( cbIndex ,cbItemInfo)--,cbZhongJiang)
	local cbZhongJiang = {}
	return self:GetZhongJiangXian(cbItemInfo,GameLogic.m_ptXian[cbIndex],cbZhongJiang)
end

--全盘中奖
function GameLogic:GetQuanPanJiangTime( cbItemInfo )
	local nTime = 0
	local bSingle = true
	local ptFirstIndex = {x=0xFF,y=0xFF}

	for i=1,GameLogic.ITEM_Y_COUNT do
		for j=1,GameLogic.ITEM_X_COUNT do
			if ptFirstIndex.x == 0xFF then
				ptFirstIndex.x = i
				ptFirstIndex.y = j
			elseif cbItemInfo[ptFirstIndex.x][ptFirstIndex.y] ~= cbItemInfo[i][j] then
				print("cbItemInfo[ptFirstIndex.x][ptFirstIndex.y]",cbItemInfo[ptFirstIndex.x][ptFirstIndex.y])
				if cbItemInfo[ptFirstIndex.x][ptFirstIndex.y]/3 ~= cbItemInfo[i][j]/3 or cbItemInfo[ptFirstIndex.x][ptFirstIndex.y] >= GameLogic.CT_TITIANXINGDAO or cbItemInfo[i][j] >= GameLogic.CT_TITIANXINGDAO then
					return 0
				end
				bSingle = false
			end
		end
	end

	if not bSingle then
		local tempType = math.floor(cbItemInfo[ptFirstIndex.x][ptFirstIndex.y]/3)
		if  tempType == 0  then
			nTime = 15
		elseif tempType == 1 then
			nTime = 50
		else
			return 0
		end
	else
		local tempType = cbItemInfo[ptFirstIndex.x][ptFirstIndex.y]
		if tempType == GameLogic.CT_FUTOU then
			nTime = 50
		elseif tempType == GameLogic.CT_YINGQIANG then
			nTime = 100
		elseif tempType == GameLogic.CT_DADAO then
			nTime = 150
		elseif tempType == GameLogic.CT_LU then
			nTime = 250
		elseif tempType == GameLogic.CT_LIN then
			nTime = 400
		elseif tempType == GameLogic.CT_SONG then
			nTime = 500
		elseif tempType == GameLogic.CT_TITIANXINGDAO then
			nTime = 1000
		elseif tempType == GameLogic.CT_ZHONGYITANG then
			nTime = 2500
        elseif tempType == GameLogic.CT_BONUS then 
            nTime = 3500
        elseif tempType == GameLogic.CT_SCATTER then 
            nTime = 4500
		elseif tempType == GameLogic.CT_SHUIHUZHUAN then
			nTime = 5000
		else
			return 0
		end
	end
	return nTime
end
--单线中奖
function GameLogic:GetZhongJiangXian( cbItemInfo,ptXian,ptZhongJiang )

	local item_x_count = GameLogic.ITEM_X_COUNT

	local nTime = 0
	local bLeftLink = true
	local nLeftBaseLinkCount = 0

	local cbLeftFirstIndex = 1

	for i=1,GameLogic.ITEM_X_COUNT do
		ptZhongJiang[i] = {}
		ptZhongJiang[i].x = 0xFF
		ptZhongJiang[i].y = 0xFF
		--左
		if cbItemInfo[ptXian[i].x][ptXian[i].y] ~= GameLogic.CT_SHUIHUZHUAN and  bLeftLink == true then
			cbLeftFirstIndex = i
			bLeftLink = false
			--print("左")
		end
	end

	bLeftLink = true

	--中奖线
	for i=1,item_x_count do
		--从左到右基本奖
		if (cbItemInfo[ptXian[cbLeftFirstIndex].x][ptXian[cbLeftFirstIndex].y] == cbItemInfo[ptXian[i].x][ptXian[i].y]  or  cbItemInfo[ptXian[i].x][ptXian[i].y] == GameLogic.CT_SHUIHUZHUAN ) and bLeftLink == true  then
			--print("左加1")
			nLeftBaseLinkCount = nLeftBaseLinkCount+1
		else
			bLeftLink = false
		end
	end

	local nLinkCount = 0
	if nLeftBaseLinkCount >= 2 and cbItemInfo[ptXian[cbLeftFirstIndex].x][ptXian[cbLeftFirstIndex].y] == 0 then
		for i=1,nLeftBaseLinkCount do
			ptZhongJiang[i].x = ptXian[i].x
			ptZhongJiang[i].y = ptXian[i].y
		end
		nLinkCount = nLinkCount + nLeftBaseLinkCount
    elseif nLeftBaseLinkCount >= 3  then
    	for i=1,nLeftBaseLinkCount do
		   ptZhongJiang[i].x = ptXian[i].x
		   ptZhongJiang[i].y = ptXian[i].y
		end
		nLinkCount = nLinkCount + nLeftBaseLinkCount
	end
	return math.min(5,nLinkCount)
end

-----------------------------------------------------------------------------------

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


return GameLogic