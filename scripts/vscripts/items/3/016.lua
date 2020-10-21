item_horses_016 = item_horses_016 or class(item_class)
------------------------------------------------------------------
LinkLuaModifier( "modifier_item_horses_016_owner","items/3/016", 0 )
LinkLuaModifier( "modifier_item_horses_016_hero","items/3/016", 0 )
LinkLuaModifier( "modifier_item_horses_016_unit","items/3/016", 0 )
modifier_item_horses_016_owner = modifier_item_horses_016_owner or {}--给主公（信使）的效果
modifier_item_horses_016_hero = modifier_item_horses_016_hero or {}--给武将的效果
modifier_item_horses_016_unit = modifier_item_horses_016_unit or {}--给民兵的效果

function modifier_item_horses_016_hero:DeclareFunctions()
    return{
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
    }
end

function modifier_item_horses_016_hero:GetModifierMoveSpeedBonus_Percentage()
    return self:GetAbility():GetSpecialValueFor("p1")
end

function modifier_item_horses_016_hero:OnAttackLanded(keys)

   local parent=self:GetParent()
   local chance=self:GetAbility():GetSpecialValueFor("p2")
   if not IsServer() then  return  end
   if keys.attacker~=parent     then return  end
   if RollPercentage(chance)  then
  parent:PerformAttack(keys.target, true, false, false, false, true, false, true)
  end 

end


--[[ void PerformAttack( handle hTarget, bool bUseCastAttackOrb, bool bProcessProcs, bool bSkipCooldown,
 bool bIgnoreInvis, bool bUseProjectile, bool bFakeAttack, bool bNeverMiss )
Performs an attack on a target. ]]