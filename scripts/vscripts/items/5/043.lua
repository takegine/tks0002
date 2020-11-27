item_queue_043 = item_queue_043 or class(item_class)
modifier_item_queue_043 = modifier_item_queue_043 or {
    GetTexture = function (self) return "items/"..self:GetAbility():GetAbilityTextureName() end,
    DeclareFunctions = function () return { MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT, MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE } end,
}
LinkLuaModifier( "modifier_item_queue_043_hero","items/5/043", 0 )
LinkLuaModifier( "modifier_item_queue_043_unit","items/5/043", 0 )
modifier_item_queue_043_hero = modifier_item_queue_043
modifier_item_queue_043_unit = modifier_item_queue_043
------------------------------------------------------------------

function modifier_item_queue_043:GetModifierAttackSpeedBonus_Constant(params)
    return  self:GetAbilitySpecialValueFor('p1')
end

function modifier_item_queue_043:GetModifierPreAttack_CriticalStrike()
    local chance = self:GetAbilitySpecialValueFor('p2')
	return RollPercentage(chance) and 200 or 0
end