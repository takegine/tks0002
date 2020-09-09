-- 不用linkluamodifier 也不是多次执行脚本的技能，可以把脚本都放在这里
-- 这个文件是给 白喵 放置脚本的

--[[
* @Description: 
* @Author: 白喵
* @Date: 2020-07-21 22:49:01
* @LastEditors: 白喵
* @LastEditTime: 2020-09-09 15:42:34
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
    for _,unit in ipairs(target_list) do
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

function add_quhu(keys)
    local unit = keys.target
    local ability = keys.ability
    if unit:IsHero() then
        ability:ApplyDataDrivenModifier(keys.caster, unit, "modifier_hero_quhu", {duration = ability:GetSpecialValueFor("duration")})
    else
        ability:ApplyDataDrivenModifier(keys.caster, unit, "modifier_hero_quhu", nil)
    end
end

function quhu(keys)
    local owner = keys.caster:GetOwner() or {ship={}}
    if not owner.ship['quhu'] then
        return
    end
    local unitlist = keys.target_entities
    local ability = keys.ability
    local dummy = CreateUnitByName( "npc_damage_dummy", Vector(0,0,0), false, keys.caster, keys.caster, keys.caster:GetTeamNumber() )
    dummy.attack_type  = "water"
    for _,unit in ipairs(unitlist) do
        local info ={
            attacker     = dummy,
            victim       = unit,
            damage_type  = DAMAGE_TYPE_MAGICAL,
            damage       = ability:GetSpecialValueFor("damage")
        }
        ApplyDamage(info)
    end
    dummy:AddNewModifier(dummy, nil, 'modifier_kill', {duration = 0.1} )
end