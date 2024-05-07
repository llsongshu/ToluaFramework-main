TableUtil = {}

function TableUtil.TableLength(T)
    local count = 0
    if T ~= nil then
        for _ in pairs(T) do count = count+1 end
    end
    return count
end

function TableUtil.GetMaxKey(T)
    if T ~= nil then
        local maxKey = nil;
        local i = 1;
        for k,v in pairs(T) do
            if i == 1 then
                maxKey = k;
            else
                if k > maxKey then maxKey = k;end
            end
            i = i + 1;
        end
        return maxKey;
    end
end

function TableUtil.MaxOf(T)
    if T ~= nil then
        return math.max(unpack(T))
    end
end

function TableUtil.MinOf(T)
    if T ~= nil then
        return math.min(unpack(T))
    end
end

function TableUtil.keys( t )
    local keys = {};
    for k, _ in next, t do
        table.insert( keys, k );
    end
    return keys;
end

local function equalex(tb1 ,tb2)
    if #TableUtil.keys(tb1) ~= #TableUtil.keys(tb2) then return false end
    for k1, v1 in next, tb1 do
        if not TableUtil.Equal(v1, tb2[k1]) then return false end
    end
    return true
end

function TableUtil.Equal(tb1, tb2)
    local kd1, kd2 = type(tb1), type(tb2)
    if kd1 ~= kd2 then return false end
    if kd1 == 'table' then return equalex(tb1, tb2) end
    return tb1 == tb2
end

function TableUtil.IndexOf(t, v)
    for i = 1, table.maxn( t ) do
        if t[i] == v then
            return i;
        end
    end
    return -1;
end

function TableUtil.FindKey(tb, value)
    for k, v in next, tb do
        if v == value then return k end
    end
end

function TableUtil.Find(tb, value)
    for k, v in next, tb do
        if k == value then return v end
    end
end

local tmp = {}
function TableUtil.Clear(T)

    if T ~= nil then

        for k, v in pairs(T) do	table.insert(tmp, k) end

        for _, v in ipairs(tmp) do	T[v] = nil	end

        for i = #tmp, 1 , -1 do	tmp[i] = nil end
    end

end

--插入排序(安全排序)
--[[ 
	@source     : 要排序的表(必须为数组结构,原本必须有序)
	@little2big : 是否从小到大排序
	@item       : 新加入的元素
	@keyStr     : 用于排序的key字符串,可以为方法名(为nil则用表里的元素比较大小)
	@startIndex : 开始插入的索引,不会与该索引之前的元素进行比较大小
]]
function TableUtil.InsertSort(source, item, little2big, keyStr, startIndex)
    local insertIndex = TableUtil.GetInsertIndex(source, item, little2big, keyStr, startIndex);
    table.insert(source, insertIndex, item);
end

-- 获取要插入的索引
--[[ 
	@source     : 要排序的表(必须为数组结构,原本必须有序)
	@little2big : 是否从小到大排序
	@item       : 新加入的元素
	@keyStr     : 用于排序的key字符串,可以为方法名(为nil则用表里的元素比较大小)
	@startIndex : 开始插入的索引,不会与该索引之前的元素进行比较大小
]]
function TableUtil.GetInsertIndex(source, item, little2big, keyStr, startIndex)
    local insertIndex = startIndex or 1;
    local insertValue = TableUtil._GetSortNum(item, keyStr);

    while insertIndex <= #source do
        local curItem = source[insertIndex];
        local curValue = TableUtil._GetSortNum(curItem, keyStr);
        if little2big and insertValue < curValue then -- 从小到大排序,而且插入值小于当前值,则获得当前索引
            break;
        elseif not little2big and insertValue > curValue then -- 从大到小排序,而且插入值大于当前值,则获得当前索引
            break;
        end
        insertIndex = insertIndex + 1;
    end
    return insertIndex;
end

function TableUtil._GetSortNum(item, keyStr)
    if keyStr then
        if type(item[keyStr]) == "number" then
            return item[keyStr];
        elseif type(item[keyStr]) == "function" then
            return item[keyStr](item);
        else
            if error then error("TableUtil._GetSortNum(...) falure, value is not 'function' or 'number'!") end;
            return item;
        end
    else
        return item;
    end
end

function TableUtil.VecPos2ProtocolPos(vecPos, protolPos, withoutY)
    protolPos.x = vecPos.x;
    if not withoutY then
        protolPos.y = vecPos.y;
    end
    protolPos.z = vecPos.z;
end


function TableUtil.TableToString(tb)
    if type(tb) ~= "table" then
        return tostring(tb);
    end
    --记录一个GetTableContent方法的最大执行次数 超过这个次数直接return当前结果 防止要打印的东西太多导致卡死
    local maxCount = 0;
    local function GetTableContent (tb, indent)
        local result="";
        if maxCount > 100 then return result; end
        maxCount = maxCount + 1;
        for k, v in pairs(tb) do
            if type(k) == "string" then
                k = string.format("%q", k)
            end
            local szSuffix = ""
            if type(v) == "table" then
                szSuffix = "{"
            end
            local szPrefix = string.rep("    ", indent)
            formatting = szPrefix.."["..tostring(k).."]".." = "..szSuffix
            if type(v) == "table" then
                result=result.."\n"..formatting
                if indent >=10 then --防止死循环
                    result=result.."over ten layer...";
                elseif k==string.format("%q", "__index") then
                    result=result.."__index ...";
                else
                    result=result..GetTableContent(v, indent + 1)
                end
                result=result.."\n"..szPrefix.."},"
            else
                local szValue = ""
                if type(v) == "string" then
                    szValue = string.format("%q", v)
                else
                    szValue = tostring(v)
                end
                result=result.."\n"..formatting..szValue..","
            end
        end
        return result;
    end
    return GetTableContent(tb,0);
end


function TableUtil.TableToList(tb)
    local li = {};
    for i,v in pairs(tb) do
        table.insert(li,v);
    end
    return li;
end

-- @sortKey 排序字段
-- @increase 是否是递增排序（默认是递减排序）
function TableUtil.GetSortTabel(tb, sortKey, increase)
    local tbList = tb:GetDisorderAllID();
    table.sort(tbList, function(a, b)
        local cfgA = tb:GetRecorder(a);
        local cfgB = tb:GetRecorder(b);

        if not cfgA[sortKey] or not cfgB[sortKey] then return false end;
        local numberA = tonumber(cfgA[sortKey]);
        local numberB = tonumber(cfgB[sortKey]);
        if numberA == numberB then
            return false;
        end
        return increase and (numberA > numberB) or (numberA < numberB);
    end)
    return tbList;
end

function TableUtil.RemoveElementByKey(tbl,key)
    --新建一个临时的table
    local tmp ={}

    --把每个key做一个下标，保存到临时的table中，转换成{1=a,2=c,3=b}
    --组成一个有顺序的table，才能在while循环准备时使用#table
    for i in pairs(tbl) do
        table.insert(tmp,i)
    end

    local newTbl = {}
    --使用while循环剔除不需要的元素
    local i = 1
    while i <= #tmp do
        local val = tmp [i]
        if val == key then
            --如果是需要剔除则remove
            table.remove(tmp,i)
        else
            --如果不是剔除，放入新的tabl中
            newTbl[val] = tbl[val]
            i = i + 1
        end
    end
    return newTbl
end

---删除第一个满足条件的元素
function TableUtil.RemoveElementByPredicate(tab, predicate)
    if not tab or not predicate then
        return;
    end
    if type(tab) ~= "table" or type(predicate) ~= "function" then
        return;
    end

    local index = 0;
    for k,v in pairs(tab) do
        index = index + 1;
        if predicate(k, v) == true then
            table.remove(tab, index);
            return;
        end
    end
end

function TableUtil.Contains(T, value)
    for k,v in pairs(T) do
        if v == value then
            return true;
        end
    end
    return false;
end