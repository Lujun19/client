
PokerUtils = { }

PokerUtils.varietyC = 0
-- 百变牌型（ 先用着有空在优化 ）
function PokerUtils.happydoggyGroupCards(cardsArr)
    local tGroup = PokerUtils.tGroup
    local t3Group = { PokerUtils.santiao, PokerUtils.yiduiThree, PokerUtils.wulongThree }
    local cArr, existArr, cNameArr = { }, { }, { }
    for i = 1, #tGroup - 1 do
        -- print("第三墩：",i)
        local ccArr = PokerUtils.copy(cardsArr)
        local cards_1 = tGroup[i](ccArr)
        -- print("---------------------------------")
        for l = 1, #cards_1 do
            local breakFor = false
            for n = 1, #tGroup do
                -- print("第二墩：",n)
                local sArr = PokerUtils.delCards(ccArr, cards_1[l], l, n)
                local cards_2 = tGroup[n](sArr)
                if #cards_2 > 0 then
                    if n < i then
                        breakFor = true
                        break
                    end
                    -- print("---------------------------------",#sArr)
                    for j = 1, #cards_2 do
                        local cflag = true
                        if i == n then
                            cflag = PokerUtils.isMessireFive(11 - i, cards_1[l], cards_2[j])
                            cflag = cflag == false
                        end
                        if cflag then
                            if i == 1 and n == 3 and cards_1[l][1].value == 8 then
                                break
                            end
                            local sArr = PokerUtils.delCards(sArr, cards_2[j], i, n, 3)
                            -- local sArr3 = PokerUtils.copy(sArr)
                            for k = n < 8 and 1 or n < 10 and 2 or 3, 3 do
                                -- print("第一墩：",k)
                                local cards_3 = t3Group[k](sArr)
                                -- print("---------------------------------")
                                local cflag = false
                                if #cards_3 > 0 then
                                    cards_3 = cards_3[1]
                                    cflag = true
                                    if n == 7 and k == 1 or n == 9 and k == 2 or n == 10 and k == 3 then
                                        cflag = PokerUtils.isMessireThree(n, cards_2, cards_3, j)
                                    end
                                end
                                if cflag then
                                    if not existArr['a' .. i .. 'b' .. n .. "c" .. k] then
                                        local sArr = PokerUtils.delCards(sArr, cards_3)
                                        local group3 = { cards_1[l][1], cards_1[l][2], cards_1[l][3], cards_1[l][4], cards_1[l][5] }
                                        local group2 = { cards_2[j][1], cards_2[j][2], cards_2[j][3], cards_2[j][4], cards_2[j][5] }
                                        local group1 = { cards_3[1], cards_3[2], cards_3[3] }


                                        -- local arr = {cards_1[l][1],cards_1[l][2],cards_1[l][3],cards_1[l][4],cards_1[l][5],
                                        -- 			cards_2[j][1],cards_2[j][2],cards_2[j][3],cards_2[j][4],cards_2[j][5],
                                        -- 			cards_3[1],cards_3[2],cards_3[3]}
                                        table.sort(group3, PokerUtils.sortDescent)
                                        table.sort(group2, PokerUtils.sortDescent)
                                        table.sort(group1, PokerUtils.sortDescent)

                                        local arr = {
                                            group3[1],group3[2],group3[3],group3[4],group3[5],
                                            group2[1],group2[2],group2[3],group2[4],group2[5],
                                            group1[1],group1[2],group1[3]
                                        }


                                        if #sArr == 3 then
                                            for i = 14, 16 do
                                                table.insert(arr, sArr[i - 13])
                                            end
                                        end
                                        table.insert(cArr, arr)
                                        table.insert(cNameArr, { i, n, k })
                                        existArr['a' .. i .. 'b' .. n .. "c" .. k] = true
                                        if #cArr > 5 then
                                            return cArr, cNameArr
                                        end
                                    end
                                    break
                                end
                            end
                        end
                    end
                end
            end
            if breakFor then
                break
            end

        end
    end
    return cArr, cNameArr
end



-- 第二墩 与 第一墩 是否相公
function PokerUtils.isMessireThree(i, a, b, j)
    if i == 7 then
        if a[j][3].value < b[3].value then
            return false
        end
    elseif i > 8 then
        if i == 9 then
            if a[j][1].value == b[1].value then
                if a[j][3].value < b[3].value then
                    return false
                end
            elseif a[j][1].value < b[1].value then
                return false
            end
        else
            if a[j][1].value == b[1].value then
                if a[j][2].value == b[2].value then
                    if a[j][3].value < b[3].value then
                        return false
                    end
                elseif a[j][2].value < b[2].value then
                    return false
                end
            elseif a[j][1].value < b[1].value then
                return false
            end
        end
    end
    return true
end

-- 第三墩 与 第二墩 是否相公
function PokerUtils.isMessireFive(i, a, b)
    local v, s = { }, { }
    for n = 1, 5 do
        table.insert(v, a[n].value)
        table.insert(s, b[n].value)
    end
    table.sort(v, function(x, y) return x > y end)
    table.sort(s, function(x, y) return x > y end)
    if i == 10 or i == 8 then
        return v[3] < s[3]
    elseif i == 7 then
        if v[3] == s[3] then
            if v[1] == v[3] and s[1] == s[3] then
                return v[4] < s[4]
            elseif v[1] == v[3] and s[3] == s[5] then
                return v[4] < s[1]
            elseif v[3] == v[5] and s[1] == s[3] then
                return v[1] < s[4]
            elseif v[3] == v[5] and s[3] == s[5] then
                return v[1] < s[1]
            end
        end
        return v[3] < s[3]
    elseif i == 9 or i == 6 or i == 5 or i == 1 then
        if v[1] == s[1] then
            if v[2] == s[2] then
                if v[3] == s[3] then
                    if v[4] == s[4] then
                        return v[5] < s[5]
                    end
                    return v[4] < s[4]
                end
                return v[3] < s[3]
            end
            return v[2] < s[2]
        end
        return v[1] < s[1]
    elseif i > 1 and i < 5 then
        local dz_1, dz_2, wl_1, wl_2 = { }, { }, { }, { }
        for i = 1, 5 do
            if i < 5 and v[i] == v[i + 1] or #dz_1 > 0 and v[i] == dz_1[#dz_1] then
                table.insert(dz_1, v[i])
            else
                table.insert(wl_1, v[i])
            end
            if i < 5 and s[i] == s[i + 1] or #dz_2 > 0 and s[i] == dz_2[#dz_2] then
                table.insert(dz_2, s[i])
            else
                table.insert(wl_2, s[i])
            end
        end
        if dz_1[1] == dz_2[1] then
            if i == 4 then
                if wl_1[1] == wl_2[1] then
                    return wl_1[2] < wl_2[2]
                end
                return wl_1[1] < wl_2[1]
            elseif i == 3 then
                if dz_1[3] == dz_2[3] then
                    return wl_1[1] < wl_2[1]
                end
                return dz_1[3] < dz_2[3]
            elseif i == 2 then
                if wl_1[1] == wl_2[1] then
                    if wl_1[2] == wl_2[2] then
                        return wl_1[3] < wl_2[3]
                    end
                    return wl_1[2] < wl_2[2]
                end
                return wl_1[1] < wl_2[1]
            end
            if #dz_1 == 0 or #dz_2 == 0 then
                -- dump(dz_1)
                -- dump(dz_2)
                -- dump(wl_1)
                -- dump(wl_2)
            end
        elseif #dz_1 > 0 and #dz_2 > 0 then
            return dz_1[1] < dz_2[1]
        end
    end
    return true
end



-- 单张扑克解码
function PokerUtils.singleCardsDecode(nub)
    -- 1-4type|||1-13value
--    if nub >= 1 and nub <= 13 then
--        return { type = 1, value = nub == 1 and 13 or nub - 1 }
--    elseif nub >= 17 and nub <= 29 then
--        return { type = 2, value = nub == 17 and 13 or nub - 16 - 1 }
--    elseif nub >= 33 and nub <= 45 then
--        return { type = 3, value = nub == 33 and 13 or nub - 32 - 1 }
--    elseif nub >= 49 and nub <= 61 then
--        return { type = 4, value = nub == 49 and 13 or nub - 48 - 1 }
--    end
    return { type = yl.CARD_COLOR[nub]+1, value = (yl.POKER_VALUE[nub]==1 and 13 or (yl.POKER_VALUE[nub]-1))}
--    return nil
end

-- 单张扑克编码
function PokerUtils.singleCardsEncode(o)
--    local code
--    if o.type == 1 then
--        code = o.value == 13 and 1 or o.value + 1
--    elseif o.type == 2 then
--        code = o.value == 13 and 17 or o.value + 16 + 1
--    elseif o.type == 3 then
--        code = o.value == 13 and 33 or o.value + 32 + 1
--    elseif o.type == 4 then
--        code = o.value == 13 and 49 or o.value + 48 + 1
--    end
--dump(yl.POKER_VALUE)
--dump(yl.CARD_COLOR)
    for k,v in pairs(yl.POKER_VALUE) do
      for m,n in pairs(yl.CARD_COLOR) do
--         print(o.type,n,o.value,v,k)
         if o.type-1==n and (o.value==13 and 1 or (o.value+1))==v and k==m then
           print(k,m)
           return m
         end
     end
    end
--    return nil
end
-- 扑克解码
function PokerUtils.cardsDecode(cArr)
    local arr = { }
    for i = 1, #cArr do
        local c = cArr[i]
        table.insert(arr, PokerUtils.singleCardsDecode(c))
    end
    return arr
end
-- 扑克编码
function PokerUtils.cardsEncode(cArr)
    local hArr = { }, { }
    for i = 1, #cArr do
        local c = cArr[i]
        -- 	local suit = c.type == 5 and c.suit or c.type
        -- 	table.insert(arr,suit*16+c.value+1)
        -- 	if PokerUtils.varietyC > 0 and c.type == 5 then
        -- 		table.insert(hArr,14-i)
        -- 	end
        local code = PokerUtils.singleCardsEncode(c)
        table.insert(hArr, code)
    end
    return hArr
end

-- 扑克比牌 排序 第一墩
function PokerUtils.cSort_1(a, b)
    if a[2] == b[2] then
        local v, s = { }, { }
        for i = 11, 13 do
            table.insert(v, a[1][i].value)
            table.insert(s, b[1][i].value)
        end
        table.sort(v, function(x, y) return x > y end)
        table.sort(s, function(x, y) return x > y end)
        if a[2] == 1 then
            if v[1] == s[1] then
                if v[2] == s[2] then
                    return v[3] < s[3]
                end
                return v[2] < s[2]
            end
            return v[1] < s[1]
        elseif a[2] == 2 then
            if v[2] == s[2] then
                if v[1] == v[2] and s[1] == s[2] then
                    return v[3] < s[3]
                elseif v[1] == v[2] and s[2] == s[3] then
                    return v[3] < s[1]
                elseif v[2] == v[3] and s[1] == s[2] then
                    return v[1] < s[3]
                elseif v[2] == v[3] and s[2] == s[3] then
                    return v[1] < s[1]
                end
            end
            return v[2] < s[2]
        elseif a[2] == 4 then
            return v[2] < s[2]
        end
    end
    return a[2] < b[2]
end
-- 扑克比牌 排序 第二墩 与 第三墩
function PokerUtils.cSort_2(i)
    return function(a, b)
        local t1, t2 = a[i], b[i]
        if t1 == t2 then
            local vArr, sArr, c = { }, { }, 1
            if i == 3 then
                c = 9
            end
            for i = c, c + 4 do
                table.insert(vArr, a[1][i])
                table.insert(sArr, b[1][i])
            end
            return PokerUtils.isMessireFive(t1, vArr, sArr)
        end
        return t1 < t2
    end
end


-- 获取普通组合牌型
function PokerUtils.getGroupCards(cArr)
    local wlArr, dzArr, stArr, tzArr, sArr, wtArr, sz_n = { }, { }, { }, { }, { }, { }, 1

    local cardsArr, vArr = PokerUtils.getVariety(cArr, 0)
    local i, szArr = #cardsArr, { }

    local tempA = false

    while i > 0 do
        local cards = cardsArr[i]
        --        -- 顺子组合判断
        if sz_n > 1 then
            --            print(sArr[sz_n - 1].value, sz_n)
            if sArr[sz_n - 1].value == cards.value then
                sz_n = sz_n - 1
            elseif sArr[sz_n - 1].value + 1 ~= cards.value then
                --                print(cardsArr[1].value == 13 and sArr[1].value == 1)
                if #sArr > 3 then
                    --                print("#sArr>3",cardsArr[1].value == 13 and sArr[1].value == 1)
                    --                  print(sArr[1].value)
                    if cardsArr[1].value == 13 and sArr[1].value == 1 then
                        -- 有2345 并且有A

                        --                    for k,v in pairs(sArr) do
                        --                      print(v.type,v.value)
                        --                    end
                        table.insert(szArr, sArr)
                        tempA = true
                        --                  elseif cardsArr[1].value == 13 and sArr[1].value == 1 then

                    elseif #sArr > 4 then

                        if cardsArr[1].value == 13 and sArr[#sArr - 1].value == 12 then
                            -- JQKA
                            tempA = false
                        end

                        table.insert(szArr, sArr)
                    end
                    for k, v in pairs(sArr) do

                    end


                end
                sz_n = 1
                sArr = { }
            end
        end

        if i < #cardsArr and cards.value == cardsArr[i + 1].value then

        elseif i > 1 and cards.value == cardsArr[i - 1].value then
            -- 三条组合判断
            if i > 2 and cards.value == cardsArr[i - 2].value then
                -- 五同组合判断
                if i > 4 and cards.value == cardsArr[i - 4].value then
                    table.insert(wtArr, { cards, cardsArr[i - 1], cardsArr[i - 2], cardsArr[i - 3], cardsArr[i - 4] })
                    -- 四条组合判断
                elseif i > 3 and cards.value == cardsArr[i - 3].value then
                    table.insert(tzArr, { cards, cardsArr[i - 1], cardsArr[i - 2], cardsArr[i - 3] })
                else
                    -- 三条组合保存
                    table.insert(stArr, { cards, cardsArr[i - 1], cardsArr[i - 2] })
                end
            else
                -- 对子组合保存
                table.insert(dzArr, { cards, cardsArr[i - 1] })
            end
        else
            table.insert(wlArr, cards)
        end
        -- 顺子组合保存
        sArr[sz_n] = cards
        sz_n = sz_n + 1
        i = i - 1
    end

    --    if tempA then table.insert(sArr, cardsArr[1]) end
    if #sArr > 4 then
        if cardsArr[1].value == 13 and sArr[#sArr - 1].value == 12 then
            -- JQKA
            tempA = false
        end
        table.insert(szArr, sArr)
    end

    for k, v in pairs(szArr) do
        --      print(k,v)
        --      for m,n in pairs(v) do
        --      print(n.value,n.type)
        --      end

        if v[1].value == 1 and tempA then

            table.insert(v, cardsArr[1])
        end
    end

    --      szArr=PokerUtils.findShunzi(cArr)
    return { wlArr, dzArr, stArr, tzArr, szArr, vArr, cardsArr, wtArr }
    -- wlArr乌龙，dzArr对子，stArr三条，tzArr四条，szArr顺子，vArr百变，cardsArr，wtArr五同，
end


-- 扑克copy
function PokerUtils.copy(cArr)
    if not cArr then return { } end
    local arr = { }
    for i = 1, #cArr do
        arr[i] = cArr[i]
    end
    return arr
end
-- 扑克删除
function PokerUtils.delCards(a1, b1, e, f, n)
    --[[
	local arr,cardsArr = {},{}
	for i=1,#b do
		arr[b[i].value] = true
	end
	for i=1,#a do
		if not arr[a[i].value] then
			table.insert(cardsArr,a[i])
		end
	end]]
    --
    local a = PokerUtils.copy(a1)
    local b = PokerUtils.copy(b1)
    if n == 3 then
        -- print(#a,#b)
        -- dump(a)
        -- dump(b)
    end
    for i = #a, 1, -1 do
        if #b == 0 then break end
        for l = 1, #b do
            if b[l].type < 5 and a[i].value == b[l].value and a[i].type == b[l].type then

                if e == 1 and f == 3 and n == 3 then
                    -- dump(b)
                    -- dump(a[i])
                end
                table.remove(b, l)
                table.remove(a, i)
                break
            end
        end
    end
    if #b > 0 then
        for i = #a, 1, -1 do
            if #b == 0 then break end
            for l = 1, #b do
                if b[l].type == 5 and a[i].value == PokerUtils.varietyC then
                    table.remove(b, l)
                    table.remove(a, i)
                    break
                end
            end
        end
        -- print(".................",#a,#b)
    elseif n == 3 then
        -- print("=======================",#a,#b)
    end
    -- print(#a,#b)
    return a
end





-- 获取百变扑克
function PokerUtils.getVariety(cards, varietyC)
    table.sort(cards, PokerUtils.sortRise)
    if PokerUtils.varietyC == 0 then

        return cards, { }
    end
    local cArr, vArr = { }, { }
    varietyC = PokerUtils.varietyC
    for i = 1, #cards do
        if cards[i].value == varietyC then
            table.insert(vArr, cards[i])
        else
            table.insert(cArr, cards[i])
        end
    end
    return cArr, vArr
end  
-- 乌龙 （三张）
function PokerUtils.wulongThree(cards)
    if #cards < 3 then return { } end
    local cArr = PokerUtils.getGroupCards(cards)
    local wlArr, cardsArr = cArr[1], { }
    for i = #wlArr, 3, -1 do
        table.insert(cardsArr, { wlArr[i], wlArr[i - 1], wlArr[i - 2] })
    end
    return cardsArr
end
-- 一对 （三张）
function PokerUtils.yiduiThree(cards)
    if #cards < 3 then return { } end
    local cArr = PokerUtils.getGroupCards(cards)
    local wlArr, dzArr, vArr, cardsArr = cArr[1], cArr[2], cArr[6], { }
    if #dzArr > 0 and #wlArr > 0 then
        local i = #dzArr
        while i > 0 do
            table.insert(cardsArr, { dzArr[i][1], dzArr[i][2], wlArr[1] })
            i = i - 1
        end
    elseif #vArr > 0 and #wlArr > 1 then
        local i = #wlArr
        while i > 1 do
            table.insert(cardsArr, { wlArr[i], { type = 5, value = wlArr[i].value, suit = wlArr[i].type == 4 and 3 or 4 }, wlArr[1] })
            i = i - 1
        end
    end
    return cardsArr
end
-- 三条
function PokerUtils.santiao(cards)
    if #cards < 3 then return { } end
    local cArr = PokerUtils.getGroupCards(cards)
    local wlArr, stArr, vArr, cardsArr = cArr[1], cArr[3], cArr[6], { }
    if #stArr > 0 then
        local i = #stArr
        while i > 0 do
            table.insert(cardsArr, stArr[i])
            i = i - 1
        end
    elseif #vArr > 0 then
        local dzArr = cArr[2]
        if #dzArr > 0 then
            local i = #dzArr
            while i > 0 do
                table.insert(cardsArr, { dzArr[i][1], dzArr[i][2], { type = 5, value = dzArr[i][1].value, suit = dzArr[i][1].value == 4 and 3 or 4 } })
                i = i - 1
            end
        elseif #vArr > 1 and #wlArr > 0 then
            local i = #wlArr
            while i > 0 do
                table.insert(cardsArr, { wlArr[i], { type = 5, value = wlArr[i].value, suit = 4 }, { type = 5, value = wlArr[i].value, suit = 3 } })
                i = i - 1
            end
        elseif #vArr >= 3 then
            local cArr, hpArr = PokerUtils.getVariety(RoomController.mCards, PokerUtils.varietyC)
            if #hpArr > 2 then
                table.insert(cardsArr, { hpArr[1], hpArr[2], hpArr[3] })
            end
        end
    end
    return cardsArr
end

-- 乌龙（五张）
function PokerUtils.wulongFive(cards)
    if #cards < 5 then return { } end
    local cArr = PokerUtils.getGroupCards(cards)
    local wlArr, cardsArr = cArr[1], { }
    if #wlArr > 4 then
        for i = #wlArr, 5, -1 do
            local arr, cflag = { wlArr[i], wlArr[4], wlArr[3], wlArr[2], wlArr[1] }, false
            for l = 2, #arr do
                if arr[l].type ~= arr[l - 1].type then
                    cflag = true
                    break
                end
            end
            if cflag then
                cflag = false
                for l = 2, #arr do
                    if arr[l].value ~= arr[l - 1].value + 1 then
                        cflag = true
                        break
                    end
                end
                if cflag and arr[1].value == 13 and arr[2].value == 4 and arr[3].value == 3 and arr[4].value == 2 and arr[5].value == 1 then
                    cflag = false
                end
                if cflag then
                    table.insert(cardsArr, arr)
                end
            end
        end
    end
    return cardsArr
end

function PokerUtils.yiduiFiveNew(cards)
    if #cards < 2 then return { } end
    local cArr = PokerUtils.getGroupCards(cards)
    local dzArr = { }
    for i = 1, #cArr[2] do
        for j = 1, #cArr[2][i] do
            table.insert(dzArr, cArr[2][i][j])
        end
    end
    --    if #dzArr>0 then
    --      table.sort(dzArr,PokerUtils.sortRise)
    --      for k,v in pairs(dzArr)
    --    end

    return dzArr
end
-- 一对（五张）
function PokerUtils.yiduiFive(cards)
    if #cards < 5 then return { } end
    local cArr = PokerUtils.getGroupCards(cards)
    -- wlArr乌龙，dzArr对子，stArr三条，tzArr四条，szArr顺子，vArr百变，cardsArr，wtArr五同，
    local wlArr, dzArr, vArr, cardsArr = cArr[1], cArr[2], cArr[6], { }
    if #dzArr > 0 then
        if #wlArr > 2 then
            for i = #dzArr, 1, -1 do
                table.insert(cardsArr, { dzArr[i][1], dzArr[i][2], wlArr[3], wlArr[2], wlArr[1] })
            end
        elseif #dzArr > 3 then
            for i = #dzArr, 4, -1 do
                table.insert(cardsArr, { dzArr[i][1], dzArr[i][2], dzArr[3][1], dzArr[2][1], dzArr[1][1] })
            end
        end
    elseif #vArr > 0 and #wlArr > 3 then
        local i = #wlArr
        while i > 3 do
            table.insert(cardsArr, { wlArr[i], { type = 5, value = wlArr[i].value, suit = 4 }, wlArr[i - 1], wlArr[i - 2], wlArr[i - 3] })
            i = i - 1
        end
    end
    return cardsArr
end
-- 两对
function PokerUtils.liangdui(cards)
    -- wlArr乌龙，dzArr对子，stArr三条，tzArr四条，szArr顺子，vArr百变，cardsArr，wtArr五同，
    if #cards < 5 then return { } end
    local cArr = PokerUtils.getGroupCards(cards)
    local wlArr, dzArr, vArr, cardsArr = cArr[1], cArr[2], cArr[6], { }
    if #dzArr > 1 and #wlArr > 0 or #dzArr > 2 then
        local i = #dzArr
        for l = #dzArr, #wlArr == 0 and 3 or 2, -1 do
            table.insert(cardsArr, { dzArr[l][1], dzArr[l][2], dzArr[1][1], dzArr[1][2], #wlArr > 0 and wlArr[1] or dzArr[2][1] })

            --[[
			if i == l or i < 2 then
				break
			else
				table.insert(cardsArr,{dzArr[i][1],dzArr[i][2],dzArr[i-1][1],dzArr[i-1][2],wlArr[1]})
				i = i - 1
			end]]
            --
        end

        -- dump(cardsArr)
    end
    return cardsArr
end

function PokerUtils.santiaoFiveNew(cards)
    if #cards < 3 then return { } end
    local cArr = PokerUtils.getGroupCards(cards)
    local stArr = { }
    for i = 1, #cArr[3] do
        for j = 1, #cArr[3][i] do
            table.insert(stArr, cArr[3][i][j])
        end
    end

    return stArr
end

-- 三条（五张）
function PokerUtils.santiaoFive(cards)
    if #cards < 5 then return { } end
    local cArr = PokerUtils.getGroupCards(cards)
    local wlArr, dzArr, stArr, vArr, cardsArr = cArr[1], cArr[2], cArr[3], cArr[6], { }
    -- wlArr乌龙，dzArr对子，stArr三条，tzArr四条，szArr顺子，vArr百变，cardsArr，wtArr五同，
    if #stArr > 0 then
        if #wlArr > 1 then
            for i = #stArr, 1, -1 do
                table.insert(cardsArr, { stArr[i][1], stArr[i][2], stArr[i][3], wlArr[2], wlArr[1] })
            end
        elseif #dzArr > 1 then
            for i = #stArr, 1, -1 do
                table.insert(cardsArr, { stArr[i][1], stArr[i][2], stArr[i][3], dzArr[2][1], dzArr[1][1] })
            end
        elseif #stArr > 2 then
            for i = #stArr, 3, -1 do
                table.insert(cardsArr, { stArr[i][1], stArr[i][2], stArr[i][3], stArr[2][1], stArr[1][1] })
            end
        end
    elseif #vArr > 0 and #dzArr > 0 and #wlArr > 1 then
        local i = #dzArr
        while i > 0 do
            table.insert(cardsArr, { dzArr[i][1], dzArr[i][2], { type = 5, value = dzArr[i][1].value, suit = dzArr[i][1].value == 4 and 3 or 4 }, wlArr[2], wlArr[1] })
            i = i - 1
        end
    elseif #vArr > 1 and #wlArr > 2 then
        local i = #wlArr
        while i > 2 do
            table.insert(cardsArr, { wlArr[i], { type = 5, value = wlArr[i].value, suit = 4 }, { type = 5, value = wlArr[i].value, suit = 3 }, wlArr[i - 1], wlArr[i - 2] })
            i = i - 1
        end
    end
    return cardsArr
end

-- 获取百变顺子
function PokerUtils.getHappydoggyShunzi(cardsArr, c)
    if #cardsArr + c < 5 then return { } end
    local cArr = { }
    for i = 1, #cardsArr do
        cArr[i] = cardsArr[i].value
    end
    table.sort(cArr, function(a, b) return a > b end)
    local a, b, o, maxC, minC = { }, { }, { }, cArr[1], cArr[#cArr]
    for i = 1, #cArr do o[cArr[i]] = true end
    if maxC == 13 and #cArr > 1 and cArr[2] < 5 then
        maxC =(cArr[2] == 4) and cArr[2] or 4
        minC = minC == 1 and minC or 1
        a = { cArr[1] }
    else
        if maxC - minC > 4 then return { } end
        local maxStep = 4 -(maxC - minC)
        if maxStep > c then return { } end
        while maxStep > 0 do
            if maxC + 1 < 14 then
                maxC = maxC + 1
            elseif minC - 1 > 0 then
                minC = minC - 1
            else
                return { }
            end
            maxStep = maxStep - 1
            if maxC == 5 and minC - maxStep == 1 then
                maxC = 4
                a = { 13 }
                c = c - 1
                b[13] = true
                for l = minC - 1, 1, -1 do
                    c = c - 1
                    b[l] = true
                    minC = minC - 1
                end
                break
            end
        end
    end
    for i = maxC, minC, -1 do
        if o[i] or b[i] then
            table.insert(a, i)
        elseif c > 0 then
            table.insert(a, i)
            b[i] = true
            c = c - 1
            o[i] = true
        else
            break
        end
    end
    if #a < 5 then return { } end
    if a[1] == 13 and a[2] == 4 and a[3] == 3 and a[4] == 2 and a[5] == 1 or
        a[1] == a[2] + 1 and a[2] == a[3] + 1 and a[3] == a[4] + 1 and a[4] == a[5] + 1 then
        return a, b
    else
        return { }, { }
    end
end

-- 获取最少花色
function PokerUtils.getMinSuit(cards)
    local suitArr = { { type = 1, value = 0 }, { type = 2, value = 0 }, { type = 3, value = 0 }, { type = 4, value = 0 } }
    for i = 1, #cards do
        local suit = cards[i].type
        suitArr[suit].value = suitArr[suit].value + 1
    end
    table.sort(suitArr, PokerUtils.sortRise)
    local arr, n = { }, 1
    for i = 1, 8 do
        if n > 4 then n = 1 end
        if suitArr[n].value ~= 2 then
            suitArr[n].value = suitArr[n].value + 1
            table.insert(arr, suitArr[n].type)
        end
        n = n + 1
    end
    return arr
end

function PokerUtils.shunziNew(cards)
    if #cards < 5 then return { } end
    local szArr = { }
    local cArr = PokerUtils.getGroupCards(cards)
    for j = 1, #cArr[5] do
        for k = 1, #cArr[5][j] do
            table.insert(szArr, cArr[5][j][k])
        end
    end
    return szArr
end

-- 顺子
function PokerUtils.shunzi(cards)
    if #cards < 5 then return { } end
    local cArr = PokerUtils.getGroupCards(cards)
    local wlArr, dzArr, szArr, vArr, cardsArr = cArr[1], cArr[2], cArr[5], cArr[6], { }
    local szCards, vCards = { }, { }
    for i = #cArr[7], 1, -1 do
        local o = cArr[7][i]
        if i > 1 and o.value == cArr[7][i - 1].value or
            #szCards > 0 and szCards[#szCards].value == cArr[7][i].value then
        else
            table.insert(szCards, o)
            vCards[o.value] = i
        end
    end
    if vCards[13] and vCards[4] and vCards[3] and vCards[2] and vCards[1] then
        table.insert(szArr, { cArr[7][vCards[1]], cArr[7][vCards[2]], cArr[7][vCards[3]], cArr[7][vCards[4]], cArr[7][vCards[13]] })
    end
    if #szArr > 0 then
        local i = #szArr
        while i > 0 do
            local l = #szArr[i]
            while l > 4 do
                local sArr, cflag = { szArr[i][l], szArr[i][l - 1], szArr[i][l - 2], szArr[i][l - 3], szArr[i][l - 4] }, false
                for n = 2, #sArr do
                    if sArr[n].type ~= sArr[n - 1].type then
                        cflag = true
                        break
                    end
                end
                if cflag then
                    table.insert(cardsArr, { szArr[i][l], szArr[i][l - 1], szArr[i][l - 2], szArr[i][l - 3], szArr[i][l - 4] })
                end
                l = l - 1
            end
            i = i - 1
        end
    elseif #vArr > 0 then
        local szArr = { }
        for i = #cArr[7], 1, -1 do
            if i > 1 and cArr[7][i].value == cArr[7][i - 1].value or
                #szArr > 0 and szArr[#szArr].value == cArr[7][i].value then

            else
                table.insert(szArr, cArr[7][i])
            end
        end
        for i = 4, 1, -1 do
            if i + #vArr < 5 then break end
            for l = 1, #szCards - i + 1 do
                local arr, suitArr = { }, { }
                for n = l, l + i - 1 do
                    suitArr[szCards[n].value] = szCards[n].type
                    table.insert(arr, szCards[n])
                end
                local a, b = PokerUtils.getHappydoggyShunzi(arr, #vArr)
                if #a == 5 then
                    local minSuitArr = PokerUtils.getMinSuit(arr)
                    local arr, c = { }, 1
                    for n = 1, 5 do
                        if b[a[n]] then
                            local suit = minSuitArr[c] and minSuitArr[c] or 4
                            table.insert(arr, { type = 5, suit = suit, value = a[n] })
                            c = c + 1
                        else
                            table.insert(arr, { type = suitArr[a[n]], value = a[n] })
                        end
                    end
                    table.insert(cardsArr, arr)
                end
            end
        end
    end
    return cardsArr
end



-- 获取花色
function PokerUtils.getSuit(cards)
    local arr = { { }, { }, { }, { }, { } }
    for i = 1, #cards do
        local suit = cards[i].type
        table.insert(arr[suit], cards[i])
    end
    return arr
end

function PokerUtils.tonghuaNew(cards)
    if #cards < 5 then return { } end
    local suitArr = PokerUtils.getSuit(cards)
    local thArr = { }
    for i = 1, #suitArr do
        if #suitArr[i] >= 5 then
            for j = 1, #suitArr[i] do
                table.insert(thArr, suitArr[i][j])
            end
        end
    end
    return thArr
end

-- 同花
function PokerUtils.tonghua(cards)
    if #cards < 5 then return { } end
    local cArr = PokerUtils.getGroupCards(cards)
    local suitArr = PokerUtils.getSuit(cArr[7])
    local cardsArr = { }
    for i = 4, 1, -1 do
        local sArr = suitArr[i]
        if #sArr > 4 then
            for l = 1, #sArr - 4 do
                local arr = { sArr[l], sArr[l + 1], sArr[l + 2], sArr[l + 3], sArr[l + 4] }
                local a, b = PokerUtils.getHappydoggyShunzi(arr, 0)
                if #a ~= 5 then
                    table.insert(cardsArr, { sArr[l], sArr[l + 1], sArr[l + 2], sArr[l + 3], sArr[l + 4] })
                end
            end
        end
    end
    local vArr = cArr[6]
    if #vArr > 0 and #vArr < 3 then
        for i = 4, 1, -1 do
            local sArr = suitArr[i]
            if #sArr < 5 and #sArr + #vArr > 4 then
                local suit = sArr[1].type
                for l = 1, #vArr do
                    for n = 1, #sArr -(4 - l) do
                        if l == 1 then
                            table.insert(cardsArr, { sArr[n], { type = 5, value = sArr[n].value, suit = suit }, sArr[n + 1], sArr[n + 2], sArr[n + 3] })
                        elseif l == 2 then
                            table.insert(cardsArr, { sArr[n], { type = 5, value = sArr[n].value, suit = suit }, sArr[n + 1], { type = 5, value = sArr[n + 1].value, suit = suit }, sArr[n + 2] })
                        end
                    end
                end
            end
        end
    end
    return cardsArr
end

function PokerUtils.huluNew(cards)
    if #cards < 5 then return { } end
    local dzArr = PokerUtils.yiduiFiveNew(cards)
    local stArr = PokerUtils.santiaoFiveNew(cards)
    local hlArr = { }
    if #dzArr > 0 and #stArr > 0 then
        hlArr = dzArr
        for i = 1, #stArr do

            table.insert(hlArr, stArr[i])
        end
    end

    return hlArr
end
-- 葫芦
function PokerUtils.hulu(cards)
    if #cards < 5 then return { } end
    local cArr = PokerUtils.getGroupCards(cards)
    local dzArr, stArr, vArr = cArr[2], cArr[3], cArr[6]
    local cardsArr = { }
    if #stArr > 0 then
        if #dzArr > 0 then
            for i = #stArr, 1, -1 do
                table.insert(cardsArr, { stArr[i][1], stArr[i][2], stArr[i][3], dzArr[1][1], dzArr[1][2] })
            end
        else
            for i = #stArr, 1, -1 do
                for l = 1, #stArr do
                    if l >= i then break end
                    table.insert(cardsArr, { stArr[i][1], stArr[i][2], stArr[i][3], stArr[l][1], stArr[l][2] })
                end
            end
        end
    end
    if #vArr > 0 and #dzArr > 1 then
        for i = #dzArr, 2, -1 do
            table.insert(cardsArr, { dzArr[i][1], dzArr[i][2], { type = 5, value = dzArr[i][1].value, suit = dzArr[i][1].type == 4 and 3 or 4 }, dzArr[1][1], dzArr[1][2] })
        end
    end
    return cardsArr
end
function PokerUtils.tiezhiNew(cards)
    if #cards < 4 then return { } end
    local cArr = PokerUtils.getGroupCards(cards)
    -- wlArr乌龙，dzArr对子，stArr三条，tzArr四条，szArr顺子，vArr百变，cardsArr，wtArr五同，
    local stArr = { }
    for i = 1, #cArr[4] do
        for j = 1, #cArr[4][i] do
            table.insert(stArr, cArr[4][i][j])
        end
    end
    return stArr
end


-- 铁支
function PokerUtils.tiezhi(cards)
    if #cards < 5 then return { } end
    local cArr = PokerUtils.getGroupCards(cards)
    local wlArr, tzArr, vArr = cArr[1], cArr[4], cArr[6]
    local cardsArr = { }
    if #tzArr then
        if #wlArr > 0 then
            for i = #tzArr, 1, -1 do
                table.insert(cardsArr, { tzArr[i][1], tzArr[i][2], tzArr[i][3], tzArr[i][4], wlArr[1] })
            end
        elseif #cArr[2] > 0 then
            for i = #tzArr, 1, -1 do
                table.insert(cardsArr, { tzArr[i][1], tzArr[i][2], tzArr[i][3], tzArr[i][4], cArr[2][1][1] })
            end
        elseif #cArr[3] > 0 then
            for i = #tzArr, 1, -1 do
                table.insert(cardsArr, { tzArr[i][1], tzArr[i][2], tzArr[i][3], tzArr[i][4], cArr[3][1][1] })
            end
        elseif #tzArr > 1 then
            for i = #tzArr, 2, -1 do
                table.insert(cardsArr, { tzArr[i][1], tzArr[i][2], tzArr[i][3], tzArr[i][4], tzArr[1][1] })
            end
        end
    end
    if #vArr > 0 then
        for i = 3, 2, -1 do
            if i + #vArr < 4 then break end
            local arr, tzArr = cArr[i], { }
            if #arr > 0 then
                for l = #arr, 1, -1 do
                    local suitArr = PokerUtils.getMinSuit(arr[l])
                    if i == 3 then
                        table.insert(tzArr, { arr[l][1], arr[l][2], arr[l][3], { type = 5, value = arr[l][1].value, suit = suitArr[1] } })
                    else
                        table.insert(tzArr, { arr[l][1], arr[l][2], { type = 5, value = arr[l][1].value, suit = suitArr[1] }, { type = 5, value = arr[l][1].value, suit = suitArr[2] } })
                    end
                end
            end
            for l = 1, #tzArr -(#wlArr > 0 and 0 or 1) do
                table.insert(cardsArr, { tzArr[l][1], tzArr[l][2], tzArr[l][3], tzArr[l][4], #wlArr > 0 and wlArr[1] or tzArr[#tzArr][1] })
            end
        end
        if #cardsArr < 1 and #wlArr > 1 and #vArr > 2 then
            for l = #wlArr, 2, -1 do
                table.insert(cardsArr, { wlArr[l], { type = 5, value = wlArr[l].value, suit = 4 }, { type = 5, value = wlArr[l].value, suit = 3 }, { type = 5, value = wlArr[l].value, suit = 2 }, wlArr[1] })
            end
        end
    end
    return cardsArr
end


-- 删除相同点数
function PokerUtils.delCountSame(cArr)
    local arr, cardsArr = { }, { }
    for i = 1, #cArr do
        if not arr[cArr[i].value] then
            arr[cArr[i].value] = true
            table.insert(cardsArr, cArr[i])
        end
    end
    table.sort(cardsArr, PokerUtils.sortDescent)
    return cardsArr
end

-- 同花顺
function PokerUtils.tonghuashunNew(cards)
    if #cards < 5 then return { } end
    local suitArr = PokerUtils.getSuit(cards)
    local thsArr = { }
    for i = 1, 4 do
        local cArr = PokerUtils.getGroupCards(suitArr[i])
        if next(cArr[5]) ~= nil then
            for j = 1, #cArr[5] do
                for k = 1, #cArr[5][j] do
                    table.insert(thsArr, cArr[5][j][k])
                end
            end
        end
    end
    print("tonghuashun...." .. #thsArr)
    return thsArr
end
-- 同花顺
function PokerUtils.tonghuashun(cards)
    if #cards < 5 then return { } end
    local cArr = PokerUtils.getGroupCards(cards)
    local suitArr = PokerUtils.getSuit(cArr[7])
    -- wlArr乌龙，dzArr对子，stArr三条，tzArr四条，szArr顺子，vArr百变，cardsArr，wtArr五同，
    local cardsArr, thsArr, vArr = { }, { }, cArr[6]
    for i = 4, 1, -1 do
        local sArr = PokerUtils.delCountSame(suitArr[i])
        if #sArr > 4 then
            table.sort(sArr, PokerUtils.sortRise)
            if sArr[1].value == 13 and sArr[1].value == 12 and sArr[1].value == 11 and sArr[1].value == 10 and sArr[1].value == 9 then
                table.insert(cardsArr, { sArr[1], sArr[2], sArr[3], sArr[4], sArr[5] })
            end
            if sArr[1].value == 13 and sArr[#sArr - 3].value == 4 and sArr[#sArr - 2].value == 3 and sArr[#sArr - 1].value == 2 and sArr[#sArr].value == 1 then
                table.insert(cardsArr, { sArr[1], sArr[#sArr - 3], sArr[#sArr - 2], sArr[#sArr - 1], sArr[#sArr] })
            end
            for l = 1, #sArr - 4 do
                if sArr[l].value == sArr[l + 1].value + 1 and sArr[l + 1].value == sArr[l + 2].value + 1 and sArr[l + 2].value == sArr[l + 3].value + 1 and
                    sArr[l + 3].value == sArr[l + 4].value + 1 then
                    table.insert(cardsArr, { sArr[l], sArr[l + 1], sArr[l + 2], sArr[l + 3], sArr[l + 4] })
                end
            end
            table.insert(thsArr, sArr)
        else
            table.insert(thsArr, sArr)
        end
    end
    if #vArr > 0 then
        for i = 4, 2, -1 do
            for l = 1, #thsArr do
                local sArr = thsArr[l]
                if #sArr + #vArr > 4 then
                    for n = 1, #sArr - i + 1 do
                        local arr = { }
                        for k = n, n + i - 1 do
                            table.insert(arr, sArr[k])
                        end
                        local suit = arr[1].type
                        local a, b = PokerUtils.getHappydoggyShunzi(arr, #vArr)
                        if #a == 5 then
                            local arr, c = { }, 1
                            for j = 1, 5 do
                                if b[a[j]] then
                                    table.insert(arr, { type = 5, value = a[j], suit = suit })
                                    c = c + 1
                                else
                                    table.insert(arr, { type = suit, value = a[j] })
                                end
                            end
                            table.insert(cardsArr, arr)
                        end
                    end
                end
            end
        end
    end
    return cardsArr
end


-- 五同
function PokerUtils.wutong(cards)
    if #cards < 5 then return { } end
    local cArr = PokerUtils.getGroupCards(cards)
    local wlArr, dzArr, stArr, tzArr, wtArr, vArr = cArr[1], cArr[2], cArr[3], cArr[4], cArr[8], cArr[6]
    local cardsArr = { }
    if #wtArr > 0 then
        for i = #wtArr, 1, -1 do
            table.insert(cardsArr, wtArr[i])
        end
    end
    if #vArr > 0 then
        if #vArr > 1 then
            for i = #stArr, 1, -1 do
                local suitArr = PokerUtils.getMinSuit(stArr[i])
                table.insert(cardsArr, { stArr[i][1], stArr[i][2], stArr[i][3], { type = 5, value = stArr[i][1].value, suit = suitArr[1] }, { type = 5, value = stArr[i][1].value, suit = suitArr[2] } })
            end
        end
        if #vArr > 2 then
            for i = #dzArr, 1, -1 do
                local suitArr = PokerUtils.getMinSuit(dzArr[i])
                local arr = { dzArr[i][1], dzArr[i][2] }
                for l = 1, 3 do
                    table.insert(arr, { type = 5, value = dzArr[i][1].value, suit = suitArr[l] })
                end
                table.insert(cardsArr, arr)
            end
        end
        if #vArr > 3 then
            for i = #wlArr, 1, -1 do
                local suitArr = PokerUtils.getMinSuit( { wlArr[i] })
                local arr = { wlArr[i] }
                for l = 1, 4 do
                    table.insert(arr, { type = 5, value = wlArr[i].value, suit = suitArr[l] })
                end
                table.insert(cardsArr, arr)
            end
        end
        for i = #tzArr, 1, -1 do
            local suitArr = PokerUtils.getMinSuit(tzArr[i])
            table.insert(cardsArr, { tzArr[i][1], tzArr[i][2], tzArr[i][3], tzArr[i][4], { type = 5, value = tzArr[i][1].value, suit = suitArr[1] } })
        end
        if #vArr >= 5 then
            local cArr, hpArr = PokerUtils.getVariety(RoomController.mCards, PokerUtils.varietyC)
            if #hpArr > 4 then
                table.insert(cardsArr, { hpArr[1], hpArr[2], hpArr[3], hpArr[4], hpArr[5] })
            end
        end
    end
    return cardsArr
end




PokerUtils.tGroup = {
    [1] = PokerUtils.wutong,
    [2] = PokerUtils.tonghuashun,
    [3] = PokerUtils.tiezhi,
    [4] = PokerUtils.hulu,
    [5] = PokerUtils.tonghua,
    [6] = PokerUtils.shunzi,
    [7] = PokerUtils.santiaoFive,
    [8] = PokerUtils.liangdui,
    [9] = PokerUtils.yiduiFive,
    [10] = PokerUtils.wulongFive
}



-- 牌型从小到大
function PokerUtils.sortRise(a, b)
    if a.value == b.value then
        return a.type < b.type
    end
    return a.value > b.value
end

-- 牌型花色排序从小到大
function PokerUtils.sortSuitRise(a, b)
    if a.type == b.type then
        return a.value > b.value
    end
    return a.type < b.type
end

-- 牌型从大到小
function PokerUtils.sortDescent(a, b)
--    local x=a.value==1 and 13 or a.value-1
--    local y=b.value==1 and 13 or b.value-1
    if a.value == b.value then
        return a.type < b.type
    end
    
    return a.value < b.value
end

-- 1三同花,2三顺子，3六对半,4五对三条，5四套三条，6凑一色，7全小，8全大，9三分天下，10三同花顺，11十二皇族，12一条龙13 青龙
function PokerUtils.specialType(arr)
    --    table.sort(arr,PokerUtils.sortSuitRise)
    local spArr = PokerUtils.getGroupCards(arr)
    local wlArr, dzArr, stArr, tzArr, szArr, wtArr = spArr[1], spArr[2], spArr[3], spArr[4], spArr[5], spArr[8]
    -- wlArr乌龙，dzArr对子，stArr三条，tzArr四条，szArr顺子，vArr百变，cardsArr，wtArr五同，


    return 0
end







