item_queue_039 = item_queue_039 or class(item_class)
modifier_item_queue_039 = modifier_item_queue_039 or {
    IsHidden = on,
    IsAura = on,
    IsAuraActiveOnDeath = off,
    IsDebuff = off,
    GetAuraRadius = function () return 2000 end,
    GetModifierAura = function () return "modifier_item_queue_039_debuff" end,
    GetAuraSearchTeam = function () return DOTA_UNIT_TARGET_TEAM_ENEMY end,
    GetAuraSearchType = function ()	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end,
}

LinkLuaModifier( "modifier_item_queue_039_hero","items/5/039", 0 )
LinkLuaModifier( "modifier_item_queue_039_unit","items/5/039", 0 )
modifier_item_queue_039_hero = modifier_item_queue_039
modifier_item_queue_039_unit = modifier_item_queue_039
------------------------------------------------------------------


LinkLuaModifier( "modifier_item_queue_039_debuff","items/5/039", LUA_MODIFIER_MOTION_NONE )
modifier_item_queue_039_debuff = modifier_item_queue_039_debuff or {
    GetTexture = function (self) return "items/"..self:GetAbility():GetAbilityTextureName() end,
    DeclareFunctions = function () return { MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS, MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE } end,
}
-------------------------------------------------------------------------------

function modifier_item_queue_039_debuff:GetModifierPhysicalArmorBonus()
    return  -self:GetAbilitySpecialValueFor('p1')
end

function modifier_item_queue_039_debuff:GetModifierHPRegenAmplify_Percentage()
    return  -self:GetAbilitySpecialValueFor('p2')
end