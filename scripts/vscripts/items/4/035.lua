item_format_035 = item_format_035 or class(item_class)
------------------------------------------------------------------
LinkLuaModifier( "modifier_item_format_035_owner","items/4/035", 0 )
LinkLuaModifier( "modifier_item_format_035_hero","items/4/035", 0 )
LinkLuaModifier( "modifier_item_format_035_unit","items/4/035", 0 )
modifier_item_format_035_owner = modifier_item_format_035_owner or {IsHidden = on}--给主公（信使）的效果
modifier_item_format_035_hero = modifier_item_format_035_hero or {IsHidden = on}--给武将的效果
modifier_item_format_035_unit = modifier_item_format_035_hero or {IsHidden = on}--给民兵的效果
