--[[
* @Description: 
* @Author: 白喵
* @Date: 2020-10-05 08:49:38
* @LastEditors: 白喵
* @LastEditTime: 2020-10-05 16:33:24
--]]
item_format_033 = item_format_033 or class(item_class)
------------------------------------------------------------------
LinkLuaModifier( "modifier_item_format_033_owner","items/4/033", 0 )
LinkLuaModifier( "modifier_item_format_033_hero","items/4/033", 0 )
LinkLuaModifier( "modifier_item_format_033_unit","items/4/033", 0 )
modifier_item_format_033_owner = modifier_item_format_033_owner or {IsHidden = on}--给主公（信使）的效果
modifier_item_format_033_hero = modifier_item_format_033_hero or {IsHidden = on}--给武将的效果
modifier_item_format_033_unit = modifier_item_format_033_hero or {IsHidden = on}--给民兵的效果
