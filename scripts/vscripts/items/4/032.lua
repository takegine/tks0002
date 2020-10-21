--[[
* @Description: 
* @Author: 白喵
* @Date: 2020-10-16 14:21:36
* @LastEditors: 白喵
* @LastEditTime: 2020-10-21 21:42:16
--]]
item_format_032 = item_format_032 or class(item_class)
------------------------------------------------------------------
LinkLuaModifier( "modifier_item_format_032_owner","items/4/032", 0 )
LinkLuaModifier( "modifier_item_format_032_hero","items/4/032", 0 )
LinkLuaModifier( "modifier_item_format_032_unit","items/4/032", 0 )
modifier_item_format_032_owner = modifier_item_format_032_owner or {IsHidden = on}--给主公（信使）的效果
modifier_item_format_032_hero = modifier_item_format_032_hero or {IsHidden = on}--给武将的效果
modifier_item_format_032_unit = modifier_item_format_032_hero or {IsHidden = on}--给民兵的效果

function modifier_item_format_032_hero:DeclareFunctions()
    return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE}
end
function modifier_item_format_032_hero:GetModifierMoveSpeedBonus_Percentage()
    return self:GetAbility():GetSpecialValueFor("p1")
end