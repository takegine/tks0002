
LinkLuaModifier("modifier_hero_wansha", "skill/hero_wansha.lua", 0)
LinkLuaModifier("modifier_hero_wansha_debuff", "skill/hero_wansha.lua", 0)

skill_hero_wansha = skill_hero_wansha or class({})

function skill_hero_wansha:GetIntrinsicModifierName()
	return "modifier_hero_wansha"
end


modifier_hero_wansha = modifier_hero_wansha or class({})

function modifier_hero_wansha:IsAura()
	return true
end

function modifier_hero_wansha:IsAuraActiveOnDeath()
	return false
end

function modifier_hero_wansha:IsDebuff()
    return true
end

function modifier_hero_wansha:GetAuraRadius()
	local ability = self:GetAbility()
    return ability:GetSpecialValueFor("radius")
end

function modifier_hero_wansha:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_hero_wansha:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO 
end

function modifier_hero_wansha:GetModifierAura()
	return "modifier_hero_wansha_debuff"
end

function modifier_hero_wansha:IsHidden()
	return true
end

modifier_hero_wansha_debuff = class({})

function modifier_hero_wansha_debuff:DeclareFunctions()
	return 
	{
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_DISABLE_HEALING
	}
end

function modifier_hero_wansha_debuff:GetModifierAttackSpeedBonus_Constant()
    local  ability=self:GetAbility()
	local  as_slow = ability:GetSpecialValueFor('as_slow')
    return -as_slow
end

function modifier_hero_wansha_debuff:GetDisableHealing()
    local unit=self:GetParent()
    local  max_hp_pct = 35/100 
    if (unit:GetHealth()/unit:GetMaxHealth() <= max_hp_pct ) then
    	return 1
    end
end