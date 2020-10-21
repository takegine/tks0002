--[[
* @Description: 
* @Author: 白喵
* @Date: 2020-10-16 14:21:36
* @LastEditors: 白喵
* @LastEditTime: 2020-10-21 21:31:00
--]]
item_format_031 = item_format_031 or class(item_class)
------------------------------------------------------------------
LinkLuaModifier( "modifier_item_format_031_owner","items/4/031", 0 )
LinkLuaModifier( "modifier_item_format_031_hero","items/4/031", 0 )
LinkLuaModifier( "modifier_item_format_031_unit","items/4/031", 0 )
modifier_item_format_031_owner = modifier_item_format_031_owner or {IsHidden = on}--给主公（信使）的效果
modifier_item_format_031_hero = modifier_item_format_031_hero or {IsHidden = on}--给武将的效果
modifier_item_format_031_unit = modifier_item_format_031_hero or {IsHidden = on}--给民兵的效果


function modifier_item_format_031_hero:DeclareFunctions()
    return {MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT}
end


function modifier_item_format_031_hero:GetModifierConstantHealthRegen()
    return self:GetAbility():GetSpecialValueFor("p1")
end