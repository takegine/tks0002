item_queue_042 = item_queue_042 or class(item_class)
modifier_item_queue_042 = modifier_item_queue_042 or {
    GetTexture = function (self) return "items/"..self:GetAbility():GetAbilityTextureName() end,
    DeclareFunctions = function () return { MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE } end,
}
LinkLuaModifier( "modifier_item_queue_042_hero","items/5/042", 0 )
LinkLuaModifier( "modifier_item_queue_042_unit","items/5/042", 0 )
modifier_item_queue_042_hero = modifier_item_queue_042
modifier_item_queue_042_unit = modifier_item_queue_042
------------------------------------------------------------------

function modifier_item_queue_042:GetModifierDamageOutgoing_Percentage()
    return  self:GetAbilitySpecialValueFor('p1')
end