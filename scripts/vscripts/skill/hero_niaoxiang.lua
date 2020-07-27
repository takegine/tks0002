--[[
* @Description: 蒋钦:鸟翔
* @Author: 白喵
* @Date: 2020-07-26 17:55:35
* @LastEditors: 白喵
* @LastEditTime: 2020-07-27 23:11:28
--]]
skill_hero_niaoxiang = {}

function skill_hero_niaoxiang:needwaveup()
    local caster = self:GetCaster()
    self.number = 0
    caster:AddNewModifier(caster, self, "modifier_hero_niaoxiang2", nil)--添加鸟翔buff
end

LinkLuaModifier("modifier_hero_niaoxiang", "skill/hero_niaoxiang.lua", LUA_MODIFIER_MOTION_NONE)


modifier_hero_niaoxiang = {}


function modifier_hero_niaoxiang:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE
    }
end

function modifier_hero_niaoxiang:OnAttackLanded(keys)
    local damage = keys.damage
    local attacker = keys.attacker
    if attacker ~= self:GetParent() then
        return
    end
    local ability = self:GetAbility()
    local owner = attacker:GetOwner() or {ship={}}
    local level = ability:GetLevel()
    local duration = ability:GetLevelSpecialValueFor("duration", level-1)
    local max = 3
    local target = keys.target
    if owner.ship["moni"] then
        duration = duration *1.6--持续时间增加百分之60
        max = 5
    end
    if attacker:HasModifier("modifier_hero_niaoxiang") then
        if ability.number < max then
            local zhanying = CreateUnitByName( "npc_unit_nanmanzhanying", target:GetAbsOrigin(), false, attacker, attacker, attacker:GetTeamNumber())
            zhanying:CreatureLevelUp(ability:GetLevel()-1)
            ability.number = ability.number+1
            zhanying:AddNewModifier(attacker, ability, 'modifier_summoned_death',nil)
            zhanying:AddNewModifier(zhanying, nil, 'modifier_kill', {duration = duration})
        end
        attacker:RemoveModifierByName("modifier_hero_niaoxiang")
    end
end


function modifier_hero_niaoxiang:GetModifierPreAttack_CriticalStrike()
    return 200
end


function modifier_hero_niaoxiang:IsHidden()
    return true
end



LinkLuaModifier("modifier_hero_niaoxiang2", "skill/hero_niaoxiang.lua", LUA_MODIFIER_MOTION_NONE)

modifier_hero_niaoxiang2 = {}
function modifier_hero_niaoxiang2:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ATTACK_START
    }
end


function modifier_hero_niaoxiang2:OnAttackStart(keys)
    local attacker = keys.attacker
    if attacker ~= self:GetParent() then
        return
    end
    local ability = self:GetAbility()
    local chance = ability:GetSpecialValueFor("chance")
    local ramdom = RandomInt(1,100)
    attacker:RemoveModifierByName("modifier_hero_niaoxiang")
    if chance >= ramdom then
        attacker:AddNewModifier(attacker, ability, "modifier_hero_niaoxiang", nil)
    end
end


function modifier_hero_niaoxiang2:IsHidden()
    return false
end

LinkLuaModifier("modifier_summoned_death", "skill/hero_niaoxiang.lua", LUA_MODIFIER_MOTION_NONE)
modifier_summoned_death={}
function modifier_summoned_death:DeclareFunctions()
return {
    MODIFIER_EVENT_ON_DEATH
}
end
function modifier_summoned_death:OnDeath(keys)
    local ability = self:GetAbility()
    if keys.unit:GetOwner() ~= ability:GetCaster() or self:GetParent() ~= keys.unit then
        return
    end
    ability.number = ability.number-1
end
