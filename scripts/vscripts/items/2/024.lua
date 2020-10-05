--[[
* @Description: 
* @Author: 白喵
* @Date: 2020-10-05 08:49:38
* @LastEditors: 白喵
* @LastEditTime: 2020-10-05 16:22:26
--]]
item_jewelry_024 = item_jewelry_024 or class(item_class)
------------------------------------------------------------------
LinkLuaModifier( "modifier_item_jewelry_024_owner","items/2/024", 0 )
LinkLuaModifier( "modifier_item_jewelry_024_hero","items/2/024", 0 )
LinkLuaModifier( "modifier_item_jewelry_024_unit","items/2/024", 0 )
modifier_item_jewelry_024_owner = modifier_item_jewelry_024_owner or {IsHidden = on}--给主公（信使）的效果
modifier_item_jewelry_024_hero = modifier_item_jewelry_024_hero or {IsHidden = on}--给武将的效果
modifier_item_jewelry_024_unit = modifier_item_jewelry_024_hero or {IsHidden = on}--给民兵的效果

