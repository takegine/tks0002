--[[
* @Description: 
* @Author: 白喵
* @Date: 2020-07-26 22:45:01
* @LastEditors: 白喵
* @LastEditTime: 2020-07-27 23:10:37
--]]
skill_hero_sunwu = {}

function skill_hero_sunwu:needwaveup()
    local caster = self:GetCaster()
    local owner = caster:GetOwner() or {ship={}}
    if owner.ship["dongwu"] then
        self.number = 0
        caster:AddNewModifier(caster, self, "modifier_hero_sunwu2", nil)--添加东吴之志buff
    end
end

LinkLuaModifier("modifier_hero_sunwu", "skill/hero_sunwu.lua", LUA_MODIFIER_MOTION_NONE)


modifier_hero_sunwu = {}


function modifier_hero_sunwu:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE
    }
end

function modifier_hero_sunwu:OnAttackLanded(keys)
    local damage = keys.damage
    local attacker = keys.attacker
    if attacker ~= self:GetParent() then
        return
    end
    local ability = self:GetAbility()
    local owner = attacker:GetOwner() or {ship={}}
    local level = ability:GetLevel()
    local duration = ability:GetLevelSpecialValueFor("duration", level-1)--持续时间
    local max = 8--最大存在数量
    if attacker:HasModifier("modifier_hero_sunwu") then
        if ability.number < max then
            local bulianshi = CreateUnitByName( "npc_unit_bulianshi", attacker:GetAbsOrigin(), false, attacker, attacker, attacker:GetTeamNumber())
            FindClearSpaceForUnit(bulianshi,attacker:GetAbsOrigin(),false)
            bulianshi:CreatureLevelUp(ability:GetLevel()-1)
            ability.number = ability.number+1
            bulianshi:AddNewModifier(attacker, ability, 'modifier_summoned_death',nil)
            bulianshi:AddNewModifier(bulianshi, nil, 'modifier_kill', {duration = duration})
        end
        attacker:RemoveModifierByName("modifier_hero_sunwu")
    end
end


function modifier_hero_sunwu:GetModifierPreAttack_CriticalStrike()
    return 200
end


function modifier_hero_sunwu:IsHidden()
    return true
end



LinkLuaModifier("modifier_hero_sunwu2", "skill/hero_sunwu.lua", LUA_MODIFIER_MOTION_NONE)

modifier_hero_sunwu2 = {}
function modifier_hero_sunwu2:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ATTACK_START
    }
end


function modifier_hero_sunwu2:OnAttackStart(keys)
    local attacker = keys.attacker
    if attacker ~= self:GetParent() then
        return
    end
    local ability = self:GetAbility()
    local chance = ability:GetSpecialValueFor("chance")
    local ramdom = RandomInt(1,100)
    attacker:RemoveModifierByName("modifier_hero_sunwu")
    if chance >= ramdom then
        attacker:AddNewModifier(attacker, ability, "modifier_hero_sunwu", nil)
    end
end


function modifier_hero_sunwu2:IsHidden()
    return false
end

LinkLuaModifier("modifier_summoned_death", "skill/hero_sunwu.lua", LUA_MODIFIER_MOTION_NONE)
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
