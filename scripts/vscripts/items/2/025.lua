item_jewelry_025 = item_jewelry_025 or class(item_class)
------------------------------------------------------------------
LinkLuaModifier( "modifier_item_jewelry_025_owner","items/2/025", 0 )
LinkLuaModifier( "modifier_item_jewelry_025_hero","items/2/025", 0 )
LinkLuaModifier( "modifier_item_jewelry_025_unit","items/2/025", 0 )
modifier_item_jewelry_025_owner = modifier_item_jewelry_025_owner or {IsHidden = on}--给主公（信使）的效果
modifier_item_jewelry_025_hero = modifier_item_jewelry_025_hero or {IsHidden = on}--给武将的效果
modifier_item_jewelry_025_unit = modifier_item_jewelry_025_hero or {IsHidden = on}--给民兵的效果
