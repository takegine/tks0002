item_defend_027 = item_defend_027 or class(item_class)
------------------------------------------------------------------
LinkLuaModifier( "modifier_item_defend_027_owner","items/1/027", 0 )
LinkLuaModifier( "modifier_item_defend_027_hero","items/1/027", 0 )
LinkLuaModifier( "modifier_item_defend_027_unit","items/1/027", 0 )
modifier_item_defend_027_owner = modifier_item_defend_027_owner or {}--给主公（信使）的效果
modifier_item_defend_027_hero = modifier_item_defend_027_hero or {}--给武将的效果
modifier_item_defend_027_unit = modifier_item_defend_027_unit or {}--给民兵的效果


function modifier_item_defend_027_hero:needwaveup()

    local parent=self:GetParent()
    local ability=self:GetAbility()
    local percent=ability:GetSpecialValueFor("p1")

    local hModiferTable = {
        tree     = percent,
        duration = 50
    }
    parent:AddNewModifier( parent, ability , "modifier_defend_big", hModiferTable )

end




