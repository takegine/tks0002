item_queue_046 = item_queue_046 or class(item_class)

------------------------------------------------------------------
LinkLuaModifier( "modifier_item_queue_046_hero","items/5/046", LUA_MODIFIER_MOTION_NONE )
modifier_item_queue_046_hero = modifier_item_queue_046_hero or {}


function modifier_item_queue_046_hero:GetTexture ()
    local ability = self:GetAbility()
    return "items/"..ability:GetAbilityTextureName()
end

function modifier_item_queue_046_hero:DeclareFunctions()
    return  
    {   
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE ,
        MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE
    }
end

function modifier_item_queue_046_hero:GetModifierMoveSpeedBonus_Percentage()
    local ability= self:GetAbility()
    local change = ability:GetSpecialValueFor('p1')
    return  change
end


function modifier_item_queue_046_hero:GetModifierHealthRegenPercentage()
    local ability= self:GetAbility()
    local change = ability:GetSpecialValueFor('p2')
    return  change
end