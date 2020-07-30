item_queue_fengshizhen = item_queue_fengshizhen or class(item_class)

------------------------------------------------------------------
LinkLuaModifier( "modifier_item_queue_fengshizhen","items/5/fengshizhen", LUA_MODIFIER_MOTION_NONE )
modifier_item_queue_fengshizhen = modifier_item_queue_fengshizhen or {}


function modifier_item_queue_fengshizhen:GetTexture ()
    return "queue/锋矢"
end

function modifier_item_queue_fengshizhen:DeclareFunctions()
    return  
    {   
        MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE 
    }
end

function modifier_item_queue_fengshizhen:GetModifierDamageOutgoing_Percentage()
    local ability=self:GetAbility()
    local change = ability:GetSpecialValueFor('p1')
    return  change
end