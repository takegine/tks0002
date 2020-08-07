item_queue_047 = item_queue_047 or class(item_class)

------------------------------------------------------------------
LinkLuaModifier( "modifier_item_queue_047","items/5/047", LUA_MODIFIER_MOTION_NONE )
modifier_item_queue_047 = modifier_item_queue_047 or {}


function modifier_item_queue_047:GetTexture ()
    local ability = self:GetAbility()
    return "items/"..ability:GetAbilityTextureName()
end

function modifier_item_queue_047:GetModifierLifesteal()
    local ability= self:GetAbility()
    local p1  = ability:GetSpecialValueFor('p1')
    local p2  = ability:GetSpecialValueFor('p2')
    local parent = self:GetParent()
    local chance = parent:IsRangedAttacker() and p2 or p1
    return  change
end