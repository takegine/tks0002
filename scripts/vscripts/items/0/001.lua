item_weapon_001 = item_weapon_001 or class(item_class)
------------------------------------------------------------------
LinkLuaModifier( "modifier_item_weapon_001_owner","items/0/001", 0 )
LinkLuaModifier( "modifier_item_weapon_001_hero","items/0/001", 0 )
LinkLuaModifier( "modifier_item_weapon_001_unit","items/0/001", 0 )
modifier_item_weapon_001_owner = modifier_item_weapon_001_owner or {}--给主公（信使）的效果
modifier_item_weapon_001_hero = modifier_item_weapon_001_hero or {}--给武将的效果
modifier_item_weapon_001_unit = modifier_item_weapon_001_unit or {}--给民兵的效果
