item_defend_028 = item_defend_028 or class(item_class)
------------------------------------------------------------------
LinkLuaModifier( "modifier_item_defend_028_owner","items/1/028", 0 )
LinkLuaModifier( "modifier_item_defend_028_hero","items/1/028", 0 )
LinkLuaModifier( "modifier_item_defend_028_unit","items/1/028", 0 )
modifier_item_defend_028_owner = modifier_item_defend_028_owner or {}--给主公（信使）的效果
modifier_item_defend_028_hero = modifier_item_defend_028_hero or {}--给武将的效果
modifier_item_defend_028_unit = modifier_item_defend_028_unit or {}--给民兵的效果


function modifier_item_defend_028_hero:GetTexture()
    local ability = self:GetAbility()
    return "items/"..ability:GetAbilityTextureName()
end


function  modifier_item_defend_028_hero:DeclareFunctions()
return {
    MODIFIER_PROPERTY_EVASION_CONSTANT
}
end

function modifier_item_defend_028_hero:GetModifierEvasion_Constant()
    return  self:GetAbility():GetSpecialValueFor("p1")
end
