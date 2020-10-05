item_jewelry_026 = item_jewelry_026 or class(item_class)
------------------------------------------------------------------
LinkLuaModifier( "modifier_item_jewelry_026_owner","items/2/026", 0 )
LinkLuaModifier( "modifier_item_jewelry_026_hero","items/2/026", 0 )
LinkLuaModifier( "modifier_item_jewelry_026_unit","items/2/026", 0 )
modifier_item_jewelry_026_owner = modifier_item_jewelry_026_owner or {IsHidden = on}--给主公（信使）的效果
modifier_item_jewelry_026_hero = modifier_item_jewelry_026_hero or {IsHidden = on}--给武将的效果
modifier_item_jewelry_026_unit = modifier_item_jewelry_026_unit or {IsHidden = on}--给民兵的效果
