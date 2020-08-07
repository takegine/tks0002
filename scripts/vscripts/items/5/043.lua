item_queue_043 = item_queue_043 or class(item_class)

------------------------------------------------------------------
LinkLuaModifier( "modifier_item_queue_043","items/5/043", LUA_MODIFIER_MOTION_NONE )
modifier_item_queue_043 = modifier_item_queue_043 or {}


function modifier_item_queue_043:GetTexture ()
    local ability = self:GetAbility()
    return "items/"..ability:GetAbilityTextureName()
end

function modifier_item_queue_043:DeclareFunctions()
    return  
    {   
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE
    }
end

function modifier_item_queue_043:GetModifierAttackSpeedBonus_Constant(params)
    local ability=self:GetAbility()
    local change = ability:GetSpecialValueFor('p1')
    return  change
end

function modifier_item_queue_043:GetModifierPreAttack_CriticalStrike()
    local ability=self:GetAbility()
    local chance = ability:GetSpecialValueFor('p2')
	return RollPercentage(chance) and 200 or 0
end