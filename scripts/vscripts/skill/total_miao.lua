-- 不用linkluamodifier 也不是多次执行脚本的技能，可以把脚本都放在这里
-- 这个文件是给 白喵 放置脚本的

--[[
* @Description: 
* @Author: 白喵
* @Date: 2020-07-21 22:49:01
* @LastEditors: 白喵
* @LastEditTime: 2020-08-28 17:50:00
--]]

--[[
* @description: 缔盟
* @return: 
* @param {type} 
* @author: chriscp_cat
--]]
function Dimeng(keys)
    local ability = keys.ability
    local level = ability:GetLevel()
    local target = keys.target
    if ability:IsCooldownReady() then
        local GiveMana = ability:GetSpecialValueFor("reduce")
        --local pfxname = "particles/units/heroes/hero_nyx_assassin/nyx_assassin_mana_burn.vpcf"
        --local pfx = ParticleManager:CreateParticle( pfxname, PATTACH_ABSORIGIN_FOLLOW, target)
        --ParticleManager:SetParticleControl(pfx, 0, Vector(0, 0, 0))
        --ParticleManager:ReleaseParticleIndex(pfx)
        target:ReduceMana(GiveMana)--减少目标蓝量
        ability:StartCooldown(5.0)--使技能进入冷却
    end
end


function fenwei(keys)
    local target_list = keys.target_entities
    for _,unit in pairs(target_list) do
        --unit:Purge(true, false, false, false, true)
        print(unit:GetUnitName())
        if unit:IsSummoned() then
            unit:Kill(keys.ability,keys.caster)
        end
        if unit:IsIllusion() then
            unit:Kill(keys.ability,keys.caster)
        end
    end
end


function p_kv(keys)
    for k,v in pairs(keys) do
        print(k,v)
    end
end