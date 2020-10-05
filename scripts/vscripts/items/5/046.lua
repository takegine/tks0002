item_queue_046 = item_queue_046 or class(item_class)
modifier_item_queue_046 = modifier_item_queue_046 or {
    GetTexture = function (self) return "items/"..self:GetAbility():GetAbilityTextureName() end,
    DeclareFunctions = function () return { MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE, MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE } end,
}
LinkLuaModifier( "modifier_item_queue_046_hero","items/5/046", 0 )
LinkLuaModifier( "modifier_item_queue_046_unit","items/5/046", 0 )
modifier_item_queue_046_hero = modifier_item_queue_046
modifier_item_queue_046_unit = modifier_item_queue_046
------------------------------------------------------------------

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