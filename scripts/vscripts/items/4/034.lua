--[[
* @Description: 
* @Author: 白喵
* @Date: 2020-10-16 14:21:36
* @LastEditors: 白喵
* @LastEditTime: 2020-10-21 21:53:53
--]]
item_format_034 = item_format_034 or class(item_class)
------------------------------------------------------------------
LinkLuaModifier( "modifier_item_format_034_owner","items/4/034", 0 )
LinkLuaModifier( "modifier_item_format_034_hero","items/4/034", 0 )
LinkLuaModifier( "modifier_item_format_034_unit","items/4/034", 0 )
modifier_item_format_034_owner = modifier_item_format_034_owner or {IsHidden = on}--给主公（信使）的效果
modifier_item_format_034_hero = modifier_item_format_034_hero or {IsHidden = on}--给武将的效果
modifier_item_format_034_unit = modifier_item_format_034_hero or {IsHidden = on}--给民兵的效果
function modifier_item_format_034_hero:DeclareFunctions()
    return {MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE}
end

function modifier_item_format_034_hero:GetModifierPercentageCooldown()
    return self:GetAbility():GetSpecialValueFor("p1")
end