item_horses_019 = item_horses_019 or class(item_class)
------------------------------------------------------------------
LinkLuaModifier( "modifier_item_horses_019_owner","items/3/019", 0 )
LinkLuaModifier( "modifier_item_horses_019_hero","items/3/019", 0 )
LinkLuaModifier( "modifier_silunche_yinsheng","items/3/019", 0 )
LinkLuaModifier( "modifier_item_horses_019_unit","items/3/019", 0 )
modifier_item_horses_019_owner = modifier_item_horses_019_owner or {}--给主公（信使）的效果
modifier_item_horses_019_hero = modifier_item_horses_019_hero or {}--给武将的效果
modifier_item_horses_019_unit = modifier_item_horses_019_unit or {}--给民兵的效果


function modifier_item_horses_019_hero:GetTexture()
    local ability = self:GetAbility()
    return "items/"..ability:GetAbilityTextureName()
end

function modifier_item_horses_019_hero:IsHidden()
  return  true
end

function modifier_item_horses_019_hero:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }
end

function modifier_item_horses_019_hero:OnAttackLanded(keys)

    local caster=self:GetCaster()
    local parent =self:GetParent()
    local ability=self:GetAbility()
    local cooldown=self:GetAbility():GetSpecialValueFor("p2")
    if not IsServer() then  return end
    if keys.target~=parent then  return end
    if ability:IsCooldownReady()  then
    parent:AddNewModifier(caster, ability, 'modifier_silunche_yinsheng', {})
    ability:StartCooldown(cooldown)
    end
end


modifier_silunche_yinsheng=class({})

function modifier_silunche_yinsheng:GetTexture()
    local ability = self:GetAbility()
    return "items/"..ability:GetAbilityTextureName()
end

function modifier_silunche_yinsheng:DeclareFunctions()
    return{
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_EVENT_ON_ABILITY_EXECUTED
    }
end

function modifier_silunche_yinsheng:GetModifierMoveSpeedBonus_Percentage()
    return self:GetAbility():GetSpecialValueFor("p1")
end

function modifier_silunche_yinsheng:GetEffectName()
    return
        'particles/generic_hero_status/status_invisibility_start.vpcf'  
end

function modifier_silunche_yinsheng:CheckState()
    local state = {
    [MODIFIER_STATE_INVISIBLE]=true,
    [MODIFIER_STATE_NO_UNIT_COLLISION]=true
}      return state
end

function modifier_silunche_yinsheng:OnAttackLanded(keys)
    local parent=self:GetParent()
    if not IsServer() then  return end
    if keys.attacker~=parent then  return end
    if parent:HasModifier('modifier_silunche_yinsheng') then
    parent:RemoveModifierByName('modifier_silunche_yinsheng')
end
end

function modifier_silunche_yinsheng:OnAbilityExecuted(keys)
    local caster=self:GetCaster()
    local parent=self:GetParent()
    if keys.unit~=parent then return end
    if parent:HasModifier('modifier_silunche_yinsheng') then
    parent:RemoveModifierByName("modifier_silunche_yinsheng")
end
end