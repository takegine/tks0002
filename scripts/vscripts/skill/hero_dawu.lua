--[[
* @Description: 
* @Author: 白喵
* @Date: 2020-11-15 22:46:38
* @LastEditors: 白喵
* @LastEditTime: 2020-11-15 23:52:17
--]]
skill_hero_dawu = {}
function skill_hero_dawu:OnSpellStart()
    local caster = self:GetCaster()
    local loc = caster:GetAbsOrigin()
    local duration = self:GetSpecialValueFor("duration")
    local qixing = caster:FindModifierByName("modifier_hero_qixing")
    if qixing then
        if qixing:GetStackCount() >= 2 then
            qixing:DecrementStackCount()
            qixing:DecrementStackCount()
            duration = duration*1.5
        end
    end
    caster:AddNewModifier(caster, self, "modifier_dawu_aura", {duration = duration})
    local unitlist = FindUnitsInRadius(
        caster:GetTeam(),
        loc, 
        nil, 
        1200, 
        DOTA_UNIT_TARGET_TEAM_FRIENDLY, 
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
        DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE, 
        FIND_CLOSEST, 
        false
    )
    local max = #unitlist > 7 and 7 or #unitlist
    for i = 1,max do
        local unit = unitlist[i]
        unit:AddNewModifier(caster, self, "modifier_dawu", {duration = duration})
    end
end
LinkLuaModifier("modifier_dawu", "skill/hero_dawu.lua", 0)
modifier_dawu = {}

function modifier_dawu:DeclareFunctions()
    return {MODIFIER_PROPERTY_PERSISTENT_INVISIBILITY}
end


function modifier_dawu:GetModifierPersistentInvisibility()
    return 1
end

function modifier_dawu:CheckState()
	local state = {
		[MODIFIER_STATE_INVISIBLE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true
	}
	return state
end
LinkLuaModifier("modifier_dawu_aura", "skill/hero_dawu.lua", 0)
modifier_dawu_aura = {}

function modifier_dawu_aura:IsAura()
	return true
end

function modifier_dawu_aura:IsHidden()
    return true
end


function modifier_dawu_aura:IsAuraActiveOnDeath()
	return false
end

function modifier_dawu_aura:IsDebuff()
    return true
end

function modifier_dawu_aura:GetAuraRadius()
    return self:GetAbility():GetSpecialValueFor("radius")
end

function modifier_dawu_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_dawu_aura:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE
end

function modifier_dawu_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_dawu_aura:GetModifierAura()
	return "modifier_dawu_debuff"
end

LinkLuaModifier("modifier_dawu_debuff", "skill/hero_dawu.lua", 0)
modifier_dawu_debuff = {}

function modifier_dawu_debuff:DeclareFunctions()
    return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE}
end

function modifier_dawu_debuff:GetModifierMoveSpeedBonus_Percentage()
    return -self:GetAbility():GetSpecialValueFor("speed")
end

