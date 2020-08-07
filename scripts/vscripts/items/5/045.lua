item_queue_045 = item_queue_045 or class(item_class)

------------------------------------------------------------------
LinkLuaModifier( "modifier_item_queue_045","items/5/045", LUA_MODIFIER_MOTION_NONE )
modifier_item_queue_045 = modifier_item_queue_045 or {}
function modifier_item_queue_045:IsAura()
	return true
end

function modifier_item_queue_045:IsAuraActiveOnDeath()
	return false
end

function modifier_item_queue_045:IsDebuff()
    return false
end

function modifier_item_queue_045:GetAuraRadius()
    return 2000
end

function modifier_item_queue_045:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_item_queue_045:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_item_queue_045:GetModifierAura()
	return "modifier_item_queue_045_debuff"
end

function modifier_item_queue_045:IsHidden()
	return true
end

LinkLuaModifier( "modifier_item_queue_045_debuff","items/5/045", LUA_MODIFIER_MOTION_NONE )
modifier_item_queue_045_debuff = modifier_item_queue_045_debuff or {}
-------------------------------------------------------------------------------

function modifier_item_queue_045_debuff:GetTexture ()
    local ability = self:GetAbility()
    return "items/"..ability:GetAbilityTextureName()
end

function modifier_item_queue_045_debuff:DeclareFunctions()
    return  
    {   
        MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS

    }
end

function modifier_item_queue_045_debuff:GetModifierDamageOutgoing_Percentage()
    local ability=self:GetAbility()
    local change = ability:GetSpecialValueFor('p1')
    return  -change
end

function modifier_item_queue_045_debuff:GetModifierMagicalResistanceBonus()
    local ability=self:GetAbility()
    local change = ability:GetSpecialValueFor('p2')
    return  -change
end