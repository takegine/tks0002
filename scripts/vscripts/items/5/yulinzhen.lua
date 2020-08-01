item_queue_yulinzhen = item_queue_yulinzhen or class(item_class)

------------------------------------------------------------------
LinkLuaModifier( "modifier_item_queue_yulinzhen","items/5/yulinzhen", LUA_MODIFIER_MOTION_NONE )
modifier_item_queue_yulinzhen = modifier_item_queue_yulinzhen or {}
function modifier_item_queue_yulinzhen:IsAura()
	return true
end

function modifier_item_queue_yulinzhen:IsAuraActiveOnDeath()
	return false
end

function modifier_item_queue_yulinzhen:IsDebuff()
    return false
end

function modifier_item_queue_yulinzhen:GetAuraRadius()
    return 2000
end

function modifier_item_queue_yulinzhen:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_item_queue_yulinzhen:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_item_queue_yulinzhen:GetModifierAura()
	return "modifier_item_queue_yulinzhen_debuff"
end

function modifier_item_queue_yulinzhen:IsHidden()
	return true
end

LinkLuaModifier( "modifier_item_queue_yulinzhen_debuff","items/5/yulinzhen", LUA_MODIFIER_MOTION_NONE )
modifier_item_queue_yulinzhen_debuff = modifier_item_queue_yulinzhen_debuff or {}
-------------------------------------------------------------------------------

function modifier_item_queue_yulinzhen_debuff:GetTexture ()
    return "queue/鱼鳞"
end

function modifier_item_queue_yulinzhen_debuff:DeclareFunctions()
    return  
    {   
        MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS

    }
end

function modifier_item_queue_yulinzhen_debuff:GetModifierDamageOutgoing_Percentage()
    local ability=self:GetAbility()
    local change = ability:GetSpecialValueFor('p1')
    return  -change
end

function modifier_item_queue_yulinzhen_debuff:GetModifierMagicalResistanceBonus()
    local ability=self:GetAbility()
    local change = ability:GetSpecialValueFor('p2')
    return  -change
end