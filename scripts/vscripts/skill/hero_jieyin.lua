
LinkLuaModifier("modifier_hero_jieyin", "skill/hero_jieyin.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_hero_jieyin_heal", "skill/hero_jieyin.lua", LUA_MODIFIER_MOTION_NONE)

skill_hero_jieyin = skill_hero_jieyin or class({})

function skill_hero_jieyin:GetIntrinsicModifierName()
	return "modifier_hero_jieyin"
end


modifier_hero_jieyin = modifier_hero_jieyin or class({})
-------------------------------------------------------------------------------
function modifier_hero_jieyin:IsAura()
	return true
end

function modifier_hero_jieyin:IsAuraActiveOnDeath()
	return false
end

function modifier_hero_jieyin:IsDebuff()
    return false
end

function modifier_hero_jieyin:GetAuraRadius()
	local ability = self:GetAbility()
    return ability:GetSpecialValueFor("radius")
end

function modifier_hero_jieyin:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_hero_jieyin:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_hero_jieyin:GetModifierAura()
	return "modifier_hero_jieyin_heal"
end

function modifier_hero_jieyin:IsHidden()
	return true
end

modifier_hero_jieyin_heal = class({})
-------------------------------------------------------------------------------
function modifier_hero_jieyin_heal:DeclareFunctions()
	return 
	{
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE
	}
end

function modifier_hero_jieyin_heal:GetModifierHealthRegenPercentage()
	local  ability=self:GetAbility()
	local  heal = ability:GetSpecialValueFor('heal')
	return heal
end