--[[
* @Description: 
* @Author: 白喵
* @Date: 2020-10-05 08:49:38
* @LastEditors: 白喵
* @LastEditTime: 2020-10-21 21:47:15
--]]
item_format_033 = item_format_033 or class(item_class)
------------------------------------------------------------------
LinkLuaModifier( "modifier_item_format_033_owner","items/4/033", 0 )
LinkLuaModifier( "modifier_item_format_033_hero","items/4/033", 0 )
LinkLuaModifier( "modifier_item_format_033_unit","items/4/033", 0 )
modifier_item_format_033_owner = modifier_item_format_033_owner or {IsHidden = on}--给主公（信使）的效果
modifier_item_format_033_hero = modifier_item_format_033_hero or {IsHidden = on}--给武将的效果
modifier_item_format_033_unit = modifier_item_format_033_hero or {IsHidden = on}--给民兵的效果
function modifier_item_format_033_hero:DeclareFunctions()
    return {MODIFIER_PROPERTY_STATS_AGILITY_BONUS,MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,MODIFIER_PROPERTY_STATS_STRENGTH_BONUS}
end

--力量
function modifier_item_format_033_hero:GetModifierBonusStats_Strength()
    return self:GetAbility():GetSpecialValueFor("p1")
end

--敏捷
function modifier_item_format_033_hero:GetModifierBonusStats_Agility()
    return self:GetAbility():GetSpecialValueFor("p1")
end

--智力
function modifier_item_format_033_hero:GetModifierBonusStats_Intellect()
    return self:GetAbility():GetSpecialValueFor("p1")
end