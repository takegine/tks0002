item_queue_changshezhen = item_queue_changshezhen or class(item_class)

------------------------------------------------------------------
LinkLuaModifier( "modifier_item_queue_changshezhen","items/5/changshezhen", LUA_MODIFIER_MOTION_NONE )
modifier_item_queue_changshezhen = modifier_item_queue_changshezhen or {}


function modifier_item_queue_changshezhen:GetTexture ()
    return "queue/长蛇"
end

function modifier_item_queue_changshezhen:DeclareFunctions()
    return  
    {   
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE ,
        MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE
    }
end

function modifier_item_queue_changshezhen:GetModifierMoveSpeedBonus_Percentage()
    local ability= self:GetAbility()
    local change = ability:GetSpecialValueFor('p1')
    return  change
end


function modifier_item_queue_changshezhen:GetModifierHealthRegenPercentage()
    local ability= self:GetAbility()
    local change = ability:GetSpecialValueFor('p2')
    return  change
end