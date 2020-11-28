-- 这个文件主要放置通用工具，最好是通用于lua的脚本，或者是通用在任何项目下的脚本。
-- 参与贡献：
    -- Xavier
    -- 西索酱
    -- 白喵

function print_r(t)
    local print_r_cache = {}
    local function sub_print_r(t, indent)
        if (print_r_cache[tostring(t)]) then
            print(indent .. "*" .. tostring(t))
        else
            print_r_cache[tostring(t)] = true
            if (type(t) == "table") then
                for pos, val in pairs(t) do
                    if (type(val) == "table") then
                        print(indent .. "[" .. pos .. "] => " .. tostring(t) .. " {")
                        sub_print_r(val, indent .. string.rep(" ", string.len(pos) + 8))
                        print(indent .. string.rep(" ", string.len(pos) + 6) .. "}")
                    elseif (type(val) == "string") then
                        print(indent .. "[" .. pos .. '] => "' .. val .. '"')
                    else
                        print(indent .. "[" .. pos .. "] => " .. tostring(val))
                    end
                end
            else
                print(indent .. tostring(t))
            end
        end
    end
    if (type(t) == "table") then
        print(tostring(t) .. " {")
        sub_print_r(t, "  ")
        print("}")
    else
        sub_print_r(t, "  ")
    end
    print()
end

function Timer(delay,callback)
    if callback == nil then
        callback = delay
        delay = 0
    end

    local timerName = DoUniqueString("timer")

    GameRules.__vTimerNamerTable__ = GameRules.__vTimerNamerTable__ or {}
    GameRules.__vTimerNamerTable__[timerName] = true

    GameRules:GetGameModeEntity():SetContextThink(timerName,function()
    if GameRules:IsGamePaused() then
        return 0.1
    elseif GameRules.__vTimerNamerTable__[timerName] then
        return callback()
    else
        return nil
    end
    end,delay)
    return timerName
end

function RemoveTimer(timerName)
        GameRules.__vTimerNamerTable__[timerName] = nil
end

function msg_m(list)
    Msg( string.format( "Self: %s\n{\n", list ) )
	for k,v in pairs( list ) do
		Msg( string.format( "%s=>%s\n", k, v ) )
    end
    Msg( "}\n" )
end

--三个参数均为向量，返回 p 到 线段 v:w 的垂直距离
function DistancePointSegment( p, v, w )
    local l = w - v
    
	t = ( p - v ):Dot( l ) / l:Dot( l )
	if t < 0.0 then
		return ( v - p ):Length2D()
	elseif t > 1.0 then
		return ( w - p ):Length2D()
	else
		local proj = v + t * l
		return ( proj - p ):Length2D()
	end
end

--移除表中指定值
--迭代必须反向 否则remove会造成 k指向错误
function table.reduce(t,m)
    for i = #t, 1, -1 do
        if t[i] == m then
            table.remove(t, i)
        end
    end
end

--随机一个成员
function table.member( list )
    local tmpKeyT={}
    local n=1
	for k,_ in pairs( list ) do
        tmpKeyT[n]=k
        n=n+1
    end
    return list[tmpKeyT[math.random(1,n-1)]]
end

--表乱序
function table.reorder(old)
    local flag,new,getn = {},{},0
    local par,qar

    for id,v in pairs(old) do
        if v then
            table.insert(flag,id)
            table.insert(new,v)
        end
        getn = id> getn and id or getn
    end

    if getn == 1 then
        old[flag[1]] = flag[1]
        return
    end

    local arrayinset = function(key, value)
        par = new[key]
        qar = value or math.random(key+1, #new)
        new[key] = new[qar]
        new[qar] = par
    end
    for i=1, #new-1 do
        arrayinset(i)
    end
    for k,id in pairs(flag) do
        while new[k] == id do
            if id == getn then
                local err = k
                while new[err] == id or new[err] == old[id] do
                    err = math.random(1, #new-1)
                end
                arrayinset(k, err)
                old[flag[err]] = id
            else
                arrayinset(k)
            end
        end
        old[id] = new[k]
    end
end

function VectorRevolve(vector,angle)--向量平面逆时针旋转
    local x = vector.x*math.cos(math.rad(angle))-vector.y*math.sin(math.rad(angle))
    local y = vector.x*math.sin(math.rad(angle))+vector.y*math.cos(math.rad(angle))
    local z = vector.z
    return Vector(x,y,z)
end

--PRD算法的C值(war3/dota2伪随机算法)
function PRD(p)
    if p >= 1 and p <= 100 then
        local PRD = {
            [00] = 0.0001560,[01] = 0.0006201,[02] = 0.0013862,[03] = 0.0024486,[04] = 0.0038017,
            [05] = 0.0054401,[06] = 0.0073587,[07] = 0.0095524,[08] = 0.0120164,[09] = 0.0147458,
            [10] = 0.0177363,[11] = 0.0209832,[12] = 0.0244824,[13] = 0.0282297,[14] = 0.0322209,
            [15] = 0.0364523,[16] = 0.0409199,[17] = 0.0456201,[18] = 0.0505493,[19] = 0.0557040,
            [20] = 0.0610808,[21] = 0.0666764,[22] = 0.0724875,[23] = 0.0785111,[24] = 0.0847441,
            [25] = 0.0911835,[26] = 0.0978264,[27] = 0.1046702,[28] = 0.1117118,[29] = 0.1189492,
            [30] = 0.1263793,[31] = 0.1340009,[32] = 0.1418052,[33] = 0.1498101,[34] = 0.1579831,
            [35] = 0.1663288,[36] = 0.1749092,[37] = 0.1836247,[38] = 0.1924860,[39] = 0.2015474,
            [40] = 0.2109200,[41] = 0.2203646,[42] = 0.2298987,[43] = 0.2395402,[44] = 0.2493070,
            [45] = 0.2598724,[46] = 0.2704529,[47] = 0.2810076,[48] = 0.2915523,[49] = 0.3021030,
            [50] = 0.3126766,[51] = 0.3232905,[52] = 0.3341200,[53] = 0.3473700,[54] = 0.3603979,
            [55] = 0.3732168,[56] = 0.3858396,[57] = 0.3982783,[58] = 0.4105446,[59] = 0.4226497,
            [60] = 0.4346044,[61] = 0.4464193,[62] = 0.4581044,[63] = 0.4696699,[64] = 0.4811255,
            [65] = 0.4924808,[66] = 0.5074627,[67] = 0.5294118,[68] = 0.5507246,[69] = 0.5714286,
            [70] = 0.5915493,[71] = 0.6111111,[72] = 0.6301370,[73] = 0.6486486,[74] = 0.6666667,
            [75] = 0.6842105,[76] = 0.7012987,[77] = 0.7179487,[78] = 0.7341772,[79] = 0.7500000,
            [80] = 0.7654321,[81] = 0.7804878,[82] = 0.7951807,[83] = 0.8095238,[84] = 0.8235294,
            [85] = 0.8372093,[86] = 0.8505747,[87] = 0.8636364,[88] = 0.8764045,[89] = 0.8888889,
            [90] = 0.9010989,[91] = 0.9130435,[92] = 0.9247312,[93] = 0.9361702,[94] = 0.9473684,
            [95] = 0.9583333,[96] = 0.9690722,[97] = 0.9795918,[98] = 0.9898990,[99] = 1.0000000
            }
        return PRD[p-1]
    else
        return 0
    end
end

function prdRandom(chance)
    -- if type(chance) ~= "table" then
    --     error("param is not a table")
    -- end
    if not chance.c then
        chance.c = PRD(chance.p)
        chance.cur = chance.c
    end
    local rand = RandomFloat(0,1)
    if chance.cur >= rand then
        chance.cur = chance.c
        return true
    else
        chance.cur = chance.cur + chance.c
        return false
    end
end

function test()
    for i = 20,80 do
        cir = 0
        cur = 0
        srt = 0
        for _ = 1,10000 do
            cir = cir + (RollPercentage(i-1) and 1 or 0)
            cur = cur + (math.random()*100<i and 1 or 0)
            srt = srt + (RandomInt(1,100)<=i and 1 or 0)

        end
        print(i,cir,cur,srt)  --测试结果符合预期值
    end
end

--prd end

function damage_fix(attacker,target,damage)
    local armor = target:GetPhysicalArmorValue(false)
    local newkang = 1-armor/(100+math.abs(armor))
    local damage_f
    if not target:IsRangedAttacker() then
        damage_f = damage-16--近战自带16减伤
        damage_f = damage_f *newkang
    else
        damage_f = damage *newkang
    end
    if not GameRules.AddonTemplate.DamageKV
    or not attacker.attack_type
    then return false 
    end
    local damage_multiplier = GameRules.AddonTemplate.DamageKV[attacker.attack_type][target.defend_type] or 1
    damage_f = damage_f * damage_multiplier
    damage_f = damage_f > 0 and damage_f or 0
    return damage_f
end

function Isbitband(a,b)
    if type(a)=="userdata" then
        return a:BitwiseAnd(b) == b
    end
    return bit.band(a, b) == b
end