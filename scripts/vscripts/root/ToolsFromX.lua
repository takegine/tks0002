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
    if GameRules.__vTimerNamerTable__[timerName] then
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

function CCustomNetTableManager:OverData( ... )
    local name, id , key ,value =...
    local nettable = self:GetTableValue( name, tostring(id))
    nettable[key] = value
    self:SetTableValue( name, tostring(id), nettable)
end


-- function table.reduce(t,m)
--     for k, v in ipairs(t) do
--         if v == m then
--             table.remove(t,k)
--         end
--     end
-- end
--迭代必须反向 否则remove会造成 k指向错误
function table.reduce(t,m)
    for i = #t, 1, -1 do
        if t[i] == m then
            table.remove(t, i)
        end
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
        local PRD = {0.000156,0.000620,0.001386,0.002449,0.003802,0.005440,0.007359,0.009552,0.012016,0.014746,0.017736,0.020983,0.024482,0.028230,0.032221,0.036452,0.040920,0.045620,0.050549,0.055704,0.061081,0.066676,0.072488,0.078511,0.084744,0.091183,0.097826,0.104670,0.111712,0.118949,0.126379,0.134001,0.141805,0.149810,0.157983,0.166329,0.174909,0.183625,0.192486,0.201547,0.210920,0.220365,0.229899,0.239540,0.249307,0.259872,0.270453,0.281008,0.291552,0.302103,0.312677,0.323291,0.334120,0.347370,0.360398,0.373217,0.385840,0.398278,0.410545,0.422650,0.434604,0.446419,0.458104,0.469670,0.481125,0.492481,0.507463,0.529412,0.550725,0.571429,0.591549,0.611111,0.630137,0.648649,0.666667,0.684211,0.701299,0.717949,0.734177,0.750000,0.765432,0.780488,0.795181,0.809524,0.823529,0.837209,0.850575,0.863636,0.876404,0.888889,0.901099,0.913043,0.924731,0.936170,0.947368,0.958333,0.969072,0.979592,0.989899,1.000000}
        return PRD[p]
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

-- function test()
--     chance = {p=15}
--     cirtcount = 0
--     for _ = 1,10000 do
--         if prdRandom(chance) then
--             cirtcount = cirtcount + 1
--         end
--     end
--     print(cirtcount)  测试结果符合预期值
-- end

--prd end