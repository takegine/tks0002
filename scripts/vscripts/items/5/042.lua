item_queue_042 = item_queue_042 or class(item_class)

------------------------------------------------------------------
LinkLuaModifier( "modifier_item_queue_042_hero","items/5/042", LUA_MODIFIER_MOTION_NONE )
modifier_item_queue_042_hero = modifier_item_queue_042_hero or {}


function modifier_item_queue_042_hero:GetTexture ()
    local ability = self:GetAbility()
    return "items/"..ability:GetAbilityTextureName()
end

function modifier_item_queue_042_hero:DeclareFunctions()
    return  
    {   
        MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE 
    }
end

function modifier_item_queue_042_hero:GetModifierDamageOutgoing_Percentage()
    local ability=self:GetAbility()
    local change = ability:GetSpecialValueFor('p1')
    return  change
end