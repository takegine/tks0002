item_weapon_006 = item_weapon_006 or class(item_class)
------------------------------------------------------------------
LinkLuaModifier( "modifier_item_weapon_006_owner","items/0/006", 0 )
LinkLuaModifier( "modifier_item_weapon_006_hero","items/0/006", 0 )
LinkLuaModifier( "modifier_item_weapon_006_unit","items/0/006", 0 )
LinkLuaModifier("modifier_item_weapon_006_hero_debuff", "items/0/006", 0)
modifier_item_weapon_006_owner = modifier_item_weapon_006_owner or {}--给主公（信使）的效果
modifier_item_weapon_006_hero = modifier_item_weapon_006_hero or {}--给武将的效果
modifier_item_weapon_006_unit = class({modifier_item_weapon_006_hero})--给民兵的效果
modifier_item_weapon_006_hero_debuff = modifier_item_weapon_006_hero_debuff or {}

function item_weapon_006:GetIntrinsicModifierName()
    return "modifier_item_weapon_006_hero"
end

function modifier_item_weapon_006_hero:IsHidden()
    return true
end

function modifier_item_weapon_006_hero:IsAura()
    return true
end

function modifier_item_weapon_006_hero:GetAuraRadius()
    local radius = 1600
    return radius
end

function modifier_item_weapon_006_hero:IsDebuff()
    return true
end

function modifier_item_weapon_006_hero:GetModifierAura()
	return  "modifier_item_weapon_006_hero_debuff"
end

function modifier_item_weapon_006_hero:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_item_weapon_006_hero:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_item_weapon_006_hero:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_RANGED_ONLY + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE
end

function modifier_item_weapon_006_hero_debuff:DeclareFunctions()
    return {MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE}
end

function modifier_item_weapon_006_hero_debuff:GetModifierDamageOutgoing_Percentage()
    local ability = self:GetAbility()
    return -ability:GetSpecialValueFor("p1")
end

function modifier_item_weapon_006_hero_debuff:IsHidden()                return false end
function modifier_item_weapon_006_hero_debuff:IsDebuff()			    return true end         
function modifier_item_weapon_006_hero_debuff:IsPurgable() 		        return false end