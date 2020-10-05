item_queue_039 = item_queue_039 or class(item_class)

------------------------------------------------------------------
LinkLuaModifier( "modifier_item_queue_039_hero","items/5/039", LUA_MODIFIER_MOTION_NONE )
modifier_item_queue_039_hero = modifier_item_queue_039_hero or {}


function modifier_item_queue_039_hero:IsHidden ()
    return true
end

function modifier_item_queue_039_hero:IsAura()
	return true
end

function modifier_item_queue_039_hero:IsAuraActiveOnDeath()
	return false
end

function modifier_item_queue_039_hero:IsDebuff()
    return false
end

function modifier_item_queue_039_hero:GetAuraRadius()
    return 2000
end

function modifier_item_queue_039_hero:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_item_queue_039_hero:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_item_queue_039_hero:GetModifierAura()
	return "modifier_item_queue_039_hero_debuff"
end

LinkLuaModifier( "modifier_item_queue_039_hero_debuff","items/5/039", LUA_MODIFIER_MOTION_NONE )
modifier_item_queue_039_hero_debuff = modifier_item_queue_039_hero_debuff or {}
-------------------------------------------------------------------------------
function modifier_item_queue_039_hero_debuff:GetTexture ()
    local ability = self:GetAbility()
    return "items/"..ability:GetAbilityTextureName()
end

function modifier_item_queue_039_hero_debuff:DeclareFunctions()
    return  
    {   
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE

    }
end

function modifier_item_queue_039_hero_debuff:GetModifierPhysicalArmorBonus()
    local ability=self:GetAbility()
    local change = ability:GetSpecialValueFor('p1')
    return  -change
end

function modifier_item_queue_039_hero_debuff:GetModifierHPRegenAmplify_Percentage()
    local ability=self:GetAbility()
    local change = ability:GetSpecialValueFor('p2')
    return  -change
end