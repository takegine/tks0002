item_weapon_002 = item_weapon_002 or class(item_class)
------------------------------------------------------------------
LinkLuaModifier( "modifier_item_weapon_002_owner","items/0/002", 0 )
LinkLuaModifier( "modifier_item_weapon_002_hero","items/0/002", 0 )
LinkLuaModifier( "modifier_item_weapon_002_unit","items/0/002", 0 )
modifier_item_weapon_002_owner = modifier_item_weapon_002_owner or {}--给主公（信使）的效果
modifier_item_weapon_002_hero = modifier_item_weapon_002_hero or {}--给武将的效果
modifier_item_weapon_002_unit = modifier_item_weapon_002_unit or {}--给民兵的效果
