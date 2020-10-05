item_queue_045 = item_queue_045 or class(item_class)

------------------------------------------------------------------
LinkLuaModifier( "modifier_item_queue_045_hero","items/5/045", LUA_MODIFIER_MOTION_NONE )
modifier_item_queue_045_hero = modifier_item_queue_045_hero or {}
function modifier_item_queue_045_hero:IsAura()
	return true
end

function modifier_item_queue_045_hero:IsAuraActiveOnDeath()
	return false
end

function modifier_item_queue_045_hero:IsDebuff()
    return false
end

function modifier_item_queue_045_hero:GetAuraRadius()
    return 2000
end

function modifier_item_queue_045_hero:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_item_queue_045_hero:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_item_queue_045_hero:GetModifierAura()
	return "modifier_item_queue_045_hero_debuff"
end

function modifier_item_queue_045_hero:IsHidden()
	return true
end

LinkLuaModifier( "modifier_item_queue_045_hero_debuff","items/5/045", LUA_MODIFIER_MOTION_NONE )
modifier_item_queue_045_hero_debuff = modifier_item_queue_045_hero_debuff or {}
-------------------------------------------------------------------------------

function modifier_item_queue_045_hero_debuff:GetTexture ()
    local ability = self:GetAbility()
    return "items/"..ability:GetAbilityTextureName()
end

function modifier_item_queue_045_hero_debuff:DeclareFunctions()
    return  
    {   
        MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS

    }
end

function modifier_item_queue_045_hero_debuff:GetModifierDamageOutgoing_Percentage()
    local ability=self:GetAbility()
    local change = ability:GetSpecialValueFor('p1')
    return  -change
end

function modifier_item_queue_045_hero_debuff:GetModifierMagicalResistanceBonus()
    local ability=self:GetAbility()
    local change = ability:GetSpecialValueFor('p2')
    return  -change
end