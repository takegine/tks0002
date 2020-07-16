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

--============ Copyright (c) Valve Corporation, All rights reserved. ==========
--
--
--=============================================================================

function Deg2Rad(deg) 
    return deg * (math.pi / 180.0)
end


function Rad2Deg(rad) 
    return rad * (180.0 / math.pi)
end


function Clamp(val, min, max) 
    if val > max then 
        val = max
    elseif val < min then
        val = min
    end
    
    return val
end


function Lerp(t, a, b) 
    return a + t * (b - a)
end


function VectorDistanceSq(v1, v2) 
    return (v1.x - v2.x) * (v1.x - v2.x) + (v1.y - v2.y) * (v1.y - v2.y) + (v1.z - v2.z) * (v1.z - v2.z)
end


function VectorDistance(v1, v2) 
    return math.sqrt(VectorDistanceSq(v1, v2))
end


function VectorLerp(t, a, b) 
    return Vector(Lerp(t, a.x, b.x), Lerp(t, a.y, b.y), Lerp(t, a.z, b.z))
end


function VectorIsZero(v) 
    return (v.x == 0.0) and (v.y == 0.0) and (v.z == 0.0)
end


-- Remap a value in the range [a,b] to [c,d].
function RemapVal(v, a, b, c, d) 
    if a == b then 
        return (v >= b) and d or c
    end
    
    return c + (d - c) * (v - a) / (b - a)
end


-- Remap a value in the range [a,b] to [c,d].
function RemapValClamped(v, a, b, c, d) 
    if a == b then 
        return (v >= b) and d or c
    end
    
    local t = (v - a) / (b - a)
    t = Clamp(t, 0.0, 1.0)
    return c + (d - c) * t
end


function min(x, y) 
    if x < y then 
        return x
    end
    return y
end


function max(x, y) 
    if x > y then 
        return x
    end
    return y
end


function abs(val) 
    return val > 0 and val or -val
end


function Merge(table1, table2) 
    local result = vlua.clone(table2)
    for key, val in pairs(table1) do
        result[key] = val
    end
    return result
end