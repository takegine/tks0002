item_weapon_005 = item_weapon_005 or class(item_class)
------------------------------------------------------------------
LinkLuaModifier( "modifier_item_weapon_005_owner","items/0/005", 0 )
LinkLuaModifier( "modifier_item_weapon_005_hero","items/0/005", 0 )
LinkLuaModifier( "modifier_item_weapon_005_unit","items/0/005", 0 )
modifier_item_weapon_005_owner = modifier_item_weapon_005_owner or {}--给主公（信使）的效果
modifier_item_weapon_005_hero = modifier_item_weapon_005_hero or {}--给武将的效果
modifier_item_weapon_005_unit = modifier_item_weapon_005_unit or {}--给民兵的效果
