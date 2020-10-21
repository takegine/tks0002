--[[
* @Description: ,: 
* @Author: ,: 白喵
* @Date: ,: 2020-07-26 19:50:40
* @LastEditors: 白喵
* @LastEditTime: 2020-10-21 22:35:31
--]]



skill_hero_xiaoji = {}

function skill_hero_xiaoji:needwaveup()
    local caster = self:GetCaster()
    local owner = caster:GetOwner() or {ship={}}
    caster:AddNewModifier(caster, self, "modifier_hero_xiaoji", nil)
end

LinkLuaModifier("modifier_hero_xiaoji", "skill/hero_xiaoji.lua", LUA_MODIFIER_MOTION_NONE)


modifier_hero_xiaoji = {}



function modifier_hero_xiaoji:IsHidden()
    return true
end

function modifier_hero_xiaoji:IsAura()
    return true
end

function modifier_hero_xiaoji:GetAuraRadius()
    local ability = self:GetAbility()
    return ability:GetSpecialValueFor("radius")
end

function modifier_hero_xiaoji:IsDebuff()
    return false
end

function modifier_hero_xiaoji:GetModifierAura()
	return  "modifier_hero_xiaoji2"
end


function modifier_hero_xiaoji:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end


function modifier_hero_xiaoji:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_hero_xiaoji:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_RANGED_ONLY + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE
end

LinkLuaModifier("modifier_hero_xiaoji2", "skill/hero_xiaoji.lua", LUA_MODIFIER_MOTION_NONE)

modifier_hero_xiaoji2 = {}

function modifier_hero_xiaoji2:DeclareFunctions()
    return {MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE}
end

function modifier_hero_xiaoji2:GetModifierDamageOutgoing_Percentage()
    local ability = self:GetAbility()
    return ability:GetSpecialValueFor("attack")
end



function modifier_hero_xiaoji2:IsHidden()
    return false
end

function modifier_hero_xiaoji2:GetTexture()
    return "wuguo/ability_xiaoji"
end