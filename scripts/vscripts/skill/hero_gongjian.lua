--[[
* @Description: 
* @Author: 白喵
* @Date: 2020-09-17 20:08:02
* @LastEditors: 白喵
* @LastEditTime: 2020-09-17 20:20:21
--]]
skill_hero_gongjian = {}

function skill_hero_gongjian:needwaveup()
    local caster = self:GetCaster()
    caster:AddNewModifier(caster, self, "modifier_hero_gongjian", nil)
end

modifier_hero_gongjian = {}
LinkLuaModifier("modifier_hero_gongjian", "skill/hero_gongjian.lua", 0)
function modifier_hero_gongjian:IsHidden()
    return true
end

function modifier_hero_gongjian:IsAura()
    return true
end

function modifier_hero_gongjian:GetAuraRadius()
    local ability = self:GetAbility()
    return ability:GetSpecialValueFor("radius")
end

function modifier_hero_gongjian:GetModifierAura()
	return  "modifier_hero_gongjian2"
end


function modifier_hero_gongjian:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end


function modifier_hero_gongjian:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_hero_gongjian:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE
end

modifier_hero_gongjian2 = {}
LinkLuaModifier("modifier_hero_gongjian2", "skill/hero_gongjian.lua", 0)

function modifier_hero_gongjian2:DeclareFunctions()
    return {MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE}
end

function modifier_hero_gongjian2:GetModifierDamageOutgoing_Percentage()
    local ability = self:GetAbility()
    return ability:GetSpecialValueFor("attack")
end
