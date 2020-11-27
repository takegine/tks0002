item_queue_045 = item_queue_045 or class(item_class)
modifier_item_queue_045 = modifier_item_queue_045 or {
    IsHidden = on,
    IsAura = on,
    IsAuraActiveOnDeath = off,
    IsDebuff = off,
    GetAuraRadius = function () return 2000 end,
    GetModifierAura = function () return "modifier_item_queue_045_debuff" end,
    GetAuraSearchTeam = function () return DOTA_UNIT_TARGET_TEAM_ENEMY end,
    GetAuraSearchType = function ()	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end,
}
LinkLuaModifier( "modifier_item_queue_045_hero","items/5/045", 0 )
LinkLuaModifier( "modifier_item_queue_045_unit","items/5/045", 0 )
modifier_item_queue_045_hero = modifier_item_queue_045
modifier_item_queue_045_unit = modifier_item_queue_045
------------------------------------------------------------------

LinkLuaModifier( "modifier_item_queue_045_debuff","items/5/045", LUA_MODIFIER_MOTION_NONE )
modifier_item_queue_045_debuff = modifier_item_queue_045_debuff or {
    GetTexture = function (self) return "items/"..self:GetAbility():GetAbilityTextureName() end,
    DeclareFunctions = function () return { MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE, MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS } end,
}
-------------------------------------------------------------------------------

function modifier_item_queue_045_debuff:GetModifierDamageOutgoing_Percentage()
    return  -self:GetAbilitySpecialValueFor('p1')
end

function modifier_item_queue_045_debuff:GetModifierMagicalResistanceBonus()
    return  -self:GetAbilitySpecialValueFor('p2')
end