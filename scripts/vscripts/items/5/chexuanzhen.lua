item_queue_chexuanzhen = item_queue_chexuanzhen or class(item_class)

------------------------------------------------------------------
LinkLuaModifier( "modifier_item_queue_chexuanzhen","items/5/chexuanzhen", LUA_MODIFIER_MOTION_NONE )
modifier_item_queue_chexuanzhen = modifier_item_queue_chexuanzhen or {}


function modifier_item_queue_chexuanzhen:GetTexture ()
    return "queue/车悬"
end

function modifier_item_queue_chexuanzhen:DeclareFunctions()
    return  
    {   
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE
    }
end

function modifier_item_queue_chexuanzhen:GetModifierAttackSpeedBonus_Constant(params)
    local ability=self:GetAbility()
    local change = ability:GetSpecialValueFor('p1')
    return  change
end

function modifier_item_queue_chexuanzhen:GetModifierPreAttack_CriticalStrike()
    local ability=self:GetAbility()
    local chance = ability:GetSpecialValueFor('p2')
	return RollPercentage(chance) and 200 or 0
end