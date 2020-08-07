item_queue_042 = item_queue_042 or class(item_class)

------------------------------------------------------------------
LinkLuaModifier( "modifier_item_queue_042","items/5/042", LUA_MODIFIER_MOTION_NONE )
modifier_item_queue_042 = modifier_item_queue_042 or {}


function modifier_item_queue_042:GetTexture ()
    local ability = self:GetAbility()
    return "items/"..ability:GetAbilityTextureName()
end

function modifier_item_queue_042:DeclareFunctions()
    return  
    {   
        MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE 
    }
end

function modifier_item_queue_042:GetModifierDamageOutgoing_Percentage()
    local ability=self:GetAbility()
    local change = ability:GetSpecialValueFor('p1')
    return  change
end