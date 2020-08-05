--[[
* @Description: 
* @Author: 白喵
* @Date: 2020-07-26 19:50:40
* @LastEditors: 白喵
* @LastEditTime: 2020-08-05 17:02:52
--]]

skill_hero_lusi = {}

function skill_hero_lusi:needwaveup()
    local caster = self:GetCaster()
    local owner = caster:GetOwner() or {ship={}}
    if owner.ship['siying'] then
        caster:AddNewModifier(caster, self, "modifier_hero_lusi", nil)
    end
end


LinkLuaModifier("modifier_hero_lusi", "skill/hero_lusi.lua", LUA_MODIFIER_MOTION_NONE)


modifier_hero_lusi = {}





function modifier_hero_lusi:IsAura()
    return true
end

function modifier_hero_lusi:GetAuraRadius()
    local ability=self:GetAbility()
    return ability:GetSpecialValueFor("radius")
end

function modifier_hero_lusi:IsDebuff()
    return false
end
function modifier_hero_lusi:IsHidden()
    return true
end
function modifier_hero_lusi:GetModifierAura()
	return  "modifier_hero_lusi2"
end

function modifier_hero_lusi:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end
function modifier_hero_lusi:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE
end


function modifier_hero_lusi:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end


LinkLuaModifier("modifier_hero_lusi2", "skill/hero_lusi.lua", LUA_MODIFIER_MOTION_NONE)


modifier_hero_lusi2 = {}


function modifier_hero_lusi2:DeclareFunctions()
    return {MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE}
end


function modifier_hero_lusi2:GetModifierHealthRegenPercentage()
    local ability=self:GetAbility()
    return ability:GetSpecialValueFor("percent")
end

function modifier_hero_lusi2:IsHidden()
    return false
end

-- function modifier_hero_lusi2:GetTexture()
--     return "wuguo/ability_dimeng"
-- end
