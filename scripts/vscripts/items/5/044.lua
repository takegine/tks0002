item_queue_044 = item_queue_044 or class(item_class)
modifier_item_queue_044 = modifier_item_queue_044 or {
    IsAura = on,
    IsAuraActiveOnDeath = off,
    IsDebuff = off,
    GetAuraRadius = function () return 2000 end,
    GetModifierAura = function () return "modifier_item_queue_044_debuff" end,
    GetAuraSearchTeam = function () return DOTA_UNIT_TARGET_TEAM_ENEMY end,
    GetAuraSearchType = function ()	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end,
    GetTexture = function (self) return "items/"..self:GetAbility():GetAbilityTextureName() end,
    DeclareFunctions = function () return { MODIFIER_PROPERTY_MANA_REGEN_CONSTANT } end,
}
LinkLuaModifier( "modifier_item_queue_044_hero","items/5/044", 0 )
LinkLuaModifier( "modifier_item_queue_044_unit","items/5/044", 0 )
modifier_item_queue_044_hero = modifier_item_queue_044
modifier_item_queue_044_unit = modifier_item_queue_044
------------------------------------------------------------------

function modifier_item_queue_044:GetModifierConstantManaRegen()
    return  self:GetAbilitySpecialValueFor('p2')
end

LinkLuaModifier( "modifier_item_queue_044_debuff","items/5/044", LUA_MODIFIER_MOTION_NONE )
modifier_item_queue_044_debuff = modifier_item_queue_044_debuff or {
    GetTexture = function (self) return "items/"..self:GetAbility():GetAbilityTextureName() end,
    DeclareFunctions = function () return { MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT } end,
}
-------------------------------------------------------------------------------

function modifier_item_queue_044_debuff:GetModifierAttackSpeedBonus_Constant()
    return  -self:GetAbilitySpecialValueFor('p1')
end