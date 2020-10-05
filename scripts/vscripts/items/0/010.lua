item_weapon_010 = item_weapon_010 or class(item_class)
------------------------------------------------------------------
LinkLuaModifier( "modifier_item_weapon_010_owner","items/0/010", 0 )
LinkLuaModifier( "modifier_item_weapon_010_hero","items/0/010", 0 )
LinkLuaModifier( "modifier_item_weapon_010_unit","items/0/010", 0 )
modifier_item_weapon_010_owner = modifier_item_weapon_0010_owner or {}--给主公（信使）的效果
modifier_item_weapon_010_hero = modifier_item_weapon_0010_hero or {}--给武将的效果
modifier_item_weapon_010_unit = modifier_item_weapon_0010_unit or {}--给民兵的效果
