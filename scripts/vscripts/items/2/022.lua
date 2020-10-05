item_jewelry_022 = item_jewelry_022 or class(item_class)
------------------------------------------------------------------
LinkLuaModifier( "modifier_item_jewelry_022_owner","items/2/022", 0 )
LinkLuaModifier( "modifier_item_jewelry_022_hero","items/2/022", 0 )
LinkLuaModifier( "modifier_item_jewelry_022_unit","items/2/022", 0 )
modifier_item_jewelry_022_owner = modifier_item_jewelry_022_owner or {IsHidden = on}--给主公（信使）的效果
modifier_item_jewelry_022_hero = modifier_item_jewelry_022_hero or {IsHidden = on}--给武将的效果
modifier_item_jewelry_022_unit = modifier_item_jewelry_022_unit or {IsHidden = on}--给民兵的效果
