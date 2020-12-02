item_horses_015 = item_horses_015 or class(item_class)
------------------------------------------------------------------
LinkLuaModifier( "modifier_item_horses_015_owner","items/3/015", 0 )
LinkLuaModifier( "modifier_item_horses_015_hero","items/3/015", 0 )
LinkLuaModifier( "modifier_item_horses_015_unit","items/3/015", 0 )
modifier_item_horses_015_owner = modifier_item_horses_015_owner or {}--给主公（信使）的效果
modifier_item_horses_015_hero = modifier_item_horses_015_hero or {}--给武将的效果
modifier_item_horses_015_unit = modifier_item_horses_015_unit or {}--给民兵的效果

function modifier_item_horses_015_hero:GetTexture()
    local ability = self:GetAbility()
    return "items/"..ability:GetAbilityTextureName()
end

function modifier_item_horses_015_hero:DeclareFunctions()
    return{
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }
end

function modifier_item_horses_015_hero:GetModifierMoveSpeedBonus_Percentage()
    return  self:GetAbility():GetSpecialValueFor("p1")
end

function modifier_item_horses_015_hero:OnAttackLanded(keys)
    
    local parent =self:GetParent()
    local percent=self:GetAbility():GetSpecialValueFor("p2") 
    local movespeed=keys.attacker:GetMoveSpeedModifier(keys.attacker:GetBaseMoveSpeed(),true)

    if not IsServer() then  return end
    if keys.attacker~=parent then  return end
    if movespeed>=520 then  movespeed=520 end
    local dummy = CreateUnitByName( "npc_damage_dummy", Vector(0,0,0), false, parent, parent, parent:GetTeamNumber() )
    dummy.attack_type  = "land"
    dummy:AddNewModifier(dummy, nil, 'modifier_kill', {duration = 0.1} )
    local  damage_table = {
        attacker     = dummy,
        victim       = keys.target,
        damage_type  = DAMAGE_TYPE_PHYSICAL,
        damage       = movespeed*percent/100,
        damage_flags = DOTA_DAMAGE_FLAG_NONE
    }
        ApplyDamage(damage_table)

end