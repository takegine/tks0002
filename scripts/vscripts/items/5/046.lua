item_queue_046 = item_queue_046 or class(item_class)

------------------------------------------------------------------
LinkLuaModifier( "modifier_item_queue_046","items/5/046", LUA_MODIFIER_MOTION_NONE )
modifier_item_queue_046 = modifier_item_queue_046 or {}


function modifier_item_queue_046:GetTexture ()
    local ability = self:GetAbility()
    return "items/"..ability:GetAbilityTextureName()
end

function modifier_item_queue_046:DeclareFunctions()
    return  
    {   
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE ,
        MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE
    }
end

function modifier_item_queue_046:GetModifierMoveSpeedBonus_Percentage()
    local ability= self:GetAbility()
    local change = ability:GetSpecialValueFor('p1')
    return  change
end


function modifier_item_queue_046:GetModifierHealthRegenPercentage()
    local ability= self:GetAbility()
    local change = ability:GetSpecialValueFor('p2')
    return  change
end