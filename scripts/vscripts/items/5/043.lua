item_queue_043 = item_queue_043 or class(item_class)

------------------------------------------------------------------
LinkLuaModifier( "modifier_item_queue_043_hero","items/5/043", LUA_MODIFIER_MOTION_NONE )
modifier_item_queue_043_hero = modifier_item_queue_043_hero or {}


function modifier_item_queue_043_hero:GetTexture ()
    local ability = self:GetAbility()
    return "items/"..ability:GetAbilityTextureName()
end

function modifier_item_queue_043_hero:DeclareFunctions()
    return  
    {   
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE
    }
end

function modifier_item_queue_043_hero:GetModifierAttackSpeedBonus_Constant(params)
    local ability=self:GetAbility()
    local change = ability:GetSpecialValueFor('p1')
    return  change
end

function modifier_item_queue_043_hero:GetModifierPreAttack_CriticalStrike()
    local ability=self:GetAbility()
    local chance = ability:GetSpecialValueFor('p2')
	return RollPercentage(chance) and 200 or 0
end