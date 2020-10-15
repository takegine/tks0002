item_weapon_010 = item_weapon_010 or class(item_class)
------------------------------------------------------------------
LinkLuaModifier( "modifier_item_weapon_010_owner","items/0/010", 0 )
LinkLuaModifier( "modifier_item_weapon_010_hero","items/0/010", 0 )
LinkLuaModifier( "modifier_item_weapon_010_unit","items/0/010", 0 )
modifier_item_weapon_010_owner = modifier_item_weapon_010_owner or {}--给主公（信使）的效果
modifier_item_weapon_010_hero = modifier_item_weapon_010_hero or {}--给武将的效果
modifier_item_weapon_010_unit = class(modifier_item_weapon_010_hero) or class({})--给民兵的效果


function modifier_item_weapon_010_hero:DeclareFunctions()
    return  { MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE              
    }
end

function modifier_item_weapon_010_hero:GetModifierSpellAmplify_Percentage()
    local ability = self:GetAbility()
    local amp = ability:GetSpecialValueFor("p1")
    return amp  
end