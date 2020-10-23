--[[
* @Description: 
* @Author: 白喵
* @Date: 2020-10-16 14:21:36
* @LastEditors: 白喵
* @LastEditTime: 2020-10-23 23:21:39
--]]
item_format_036 = item_format_036 or class(item_class)
------------------------------------------------------------------
LinkLuaModifier( "modifier_item_format_036_owner","items/4/036", 0 )
LinkLuaModifier( "modifier_item_format_036_hero","items/4/036", 0 )
LinkLuaModifier( "modifier_item_format_036_unit","items/4/036", 0 )
modifier_item_format_036_owner = modifier_item_format_036_owner or {IsHidden = on}--给主公（信使）的效果
modifier_item_format_036_hero = modifier_item_format_036_hero or {IsHidden = on}--给武将的效果
modifier_item_format_036_unit = modifier_item_format_036_hero or {IsHidden = on}--给民兵的效果


function modifier_item_format_036_hero:DeclareFunctions()
    return {MODIFIER_EVENT_ON_ATTACK_LANDED,MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK_UNAVOIDABLE_PRE_ARMOR}
end

function modifier_item_format_036_hero:OnAttackLanded(keys)
    local parent = self:GetParent()
    if parent ~= keys.attacker then
        return 
    end
    local ability = self:GetAbility()
    local p1 = ability:GetSpecialValueFor("p1")
    keys.target:ReduceMana(p1)
    parent:GiveMana(p1)
end


function modifier_item_format_036_hero:GetEffectName()
	return "particles/units/heroes/hero_medusa/medusa_mana_shield.vpcf"
end
function modifier_item_format_036_hero:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_item_format_036_hero:GetModifierPhysical_ConstantBlockUnavoidablePreArmor(keys)
    local caster = self:GetParent()
    if caster~=keys.target then
        return 
    end
    if keys.damage == 0 then
        return 0
    end
    local damage = damage_fix(keys.attacker,keys.target,keys.damage)
    local mana = caster:GetMana()
    local ability = self:GetAbility()
    local p2 = ability:GetSpecialValueFor("p2")
    local cost_mana = math.floor(damage / p2 )
    cost_mana = cost_mana > mana and mana or cost_mana
    caster:SpendMana(cost_mana,ability)
    local  damage_f = keys.damage
    if not caster:IsRangedAttacker() then
        damage_f = damage_f - 16--修正近战自带减伤
    end
    local damage_block = cost_mana*p2/damage*damage_f
    return damage_block
end