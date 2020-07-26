--[[
* @Description: 
* @Author: 白喵
* @Date: 2020-07-24 20:43:01
* @LastEditors: 白喵
* @LastEditTime: 2020-07-24 21:44:28
--]]


skill_hero_xiaoji = {}

function skill_hero_xiaoji:needwaveup()
    local caster = self:GetCaster()
    local owner = caster:GetOwner() or {ship={}}
    caster:AddNewModifier(caster, self, "modifier_hero_xiaoji", {})
end



LinkLuaModifier("modifier_hero_xiaoji", "skill/hero_xiaoji.lua", LUA_MODIFIER_MOTION_NONE)
modifier_hero_xiaoji = {}


function modifier_hero_xiaoji:DeclareFunctions()
    return {MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE}
end

function modifier_hero_xiaoji:GetModifierDamageOutgoing_Percentage()
    local level = self:GetAbility():GetLevel()
    return 6*level
end

function modifier_hero_xiaoji:IsAura()
    return true
end

function modifier_hero_xiaoji:GetAuraRadius()
    return 900
end

function modifier_hero_xiaoji:IsDebuff()
    return false
end

function modifier_hero_xiaoji:GetModifierAura()
	return  "modifier_hero_xiaoji"
end

function modifier_hero_xiaoji:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end



function modifier_hero_xiaoji:GetAuraSearchType()
	return DOTA_UNIT_TARGET_ALL
end

function modifier_hero_xiaoji:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_RANGED_ONLY
end