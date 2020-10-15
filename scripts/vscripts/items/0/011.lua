item_weapon_011 = item_weapon_011 or class(item_class)
------------------------------------------------------------------
LinkLuaModifier( "modifier_item_weapon_011_owner","items/0/011", 0 )
LinkLuaModifier( "modifier_item_weapon_011_hero","items/0/011", 0 )
LinkLuaModifier( "modifier_item_weapon_011_unit","items/0/011", 0 )
modifier_item_weapon_011_owner = modifier_item_weapon_0011_owner or {}--给主公（信使）的效果
modifier_item_weapon_011_hero = modifier_item_weapon_0011_hero or {}--给武将的效果
modifier_item_weapon_011_unit = class(modifier_item_weapon_011_hero)or class({})--给民兵的效果


function modifier_item_weapon_011_hero:DeclareFunctions()
    return  { MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE              
    }
end

function modifier_item_weapon_011_hero:GetModifierPreAttack_CriticalStrike()
    local ability = self:GetAbility()
    local chance = ability:GetSpecialValueFor("p1")
    return RollPercentage(chance) and 200 or 0  
end