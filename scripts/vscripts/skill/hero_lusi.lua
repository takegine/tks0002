--[[
* @Description: 
* @Author: 白喵
* @Date: 2020-07-24 19:19:23
* @LastEditors: 白喵
* @LastEditTime: 2020-07-24 20:27:35
--]]
skill_hero_lusi = {}

function skill_hero_lusi:needwaveup()
    local caster = self:GetCaster()
    local owner = caster:GetOwner() or {ship={}}
    if owner.ship['siying'] then
        caster:AddNewModifier(caster, self, "modifier_skill_hero_lusi", nil)
    end
end


LinkLuaModifier("modifier_skill_hero_lusi", "skill/hero_lusi.lua", LUA_MODIFIER_MOTION_NONE)


modifier_skill_hero_lusi = {}

function modifier_skill_hero_lusi:DeclareFunctions()
    return {MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE}
end

function modifier_skill_hero_lusi:GetModifierHealthRegenPercentage()
    return 2
end

function modifier_skill_hero_lusi:IsAura()
    return true
end

function modifier_skill_hero_lusi:GetAuraRadius()
    return 600
end

function modifier_skill_hero_lusi:IsDebuff()
    return false
end

function modifier_skill_hero_lusi:GetModifierAura()
	return  "modifier_skill_hero_lusi"
end

function modifier_skill_hero_lusi:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end



function modifier_skill_hero_lusi:GetAuraSearchType()
	return DOTA_UNIT_TARGET_ALL
end