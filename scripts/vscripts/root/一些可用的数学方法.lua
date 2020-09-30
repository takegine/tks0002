
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

function Dynamic_Wrap ( mt, name )
    if Convars:GetBool( 'developer' ) then
        assert(mt ~= nil )
        local w = function (...)
                if not mt[name] then
                    error(string.format( "Attempt to call %s which is undefined", name))
                end
                return mt[name](...)
            end
        return w
    else
        return mt[name]
    end
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