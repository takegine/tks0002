item_defend_030 = item_defend_030 or class(item_class)
------------------------------------------------------------------
LinkLuaModifier( "modifier_item_defend_030_owner","items/1/030", 0 )
LinkLuaModifier( "modifier_item_defend_030_hero","items/1/030", 0 )
LinkLuaModifier( "modifier_item_defend_030_unit","items/1/030", 0 )
modifier_item_defend_030_owner = modifier_item_defend_030_owner or {}--给主公（信使）的效果
modifier_item_defend_030_hero = modifier_item_defend_030_hero or {}--给武将的效果
modifier_item_defend_030_unit = modifier_item_defend_030_unit or {}--给民兵的效果

function modifier_item_defend_030_hero:GetTexture()
    local ability = self:GetAbility()
    return "items/"..ability:GetAbilityTextureName()
end


function  modifier_item_defend_030_hero:DeclareFunctions()
    return{
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_PROPERTY_INCOMING_PHYSICAL_DAMAGE_PERCENTAGE
    }
end

function modifier_item_defend_030_hero:GetModifierIncomingPhysicalDamage_Percentage()
    return -self:GetAbility():GetSpecialValueFor("p1")
end

function modifier_item_defend_030_hero:OnAttackLanded(keys)

  local  ability=self:GetAbility()
  local  parent=self:GetParent()
  local  percent=ability:GetSpecialValueFor('p1')

  if  not  IsServer() then  return  end
  if  keys.target~=parent  then  return  end
  if  keys.attacker:IsRangedAttacker() then return end

  parent:AddNewModifier(parent, ability, 'modifier_item_defend_030_hero', {})

end


