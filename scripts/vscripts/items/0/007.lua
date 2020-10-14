item_weapon_007 = item_weapon_007 or class(item_class)
------------------------------------------------------------------
LinkLuaModifier( "modifier_item_weapon_007_owner","items/0/007", 0 )
LinkLuaModifier( "modifier_item_weapon_007_hero","items/0/007", 0 )
LinkLuaModifier( "modifier_item_weapon_007_unit","items/0/007", 0 )
modifier_item_weapon_007_owner = modifier_item_weapon_007_owner or {}--给主公（信使）的效果
modifier_item_weapon_007_hero = modifier_item_weapon_007_hero or {}--给武将的效果
modifier_item_weapon_007_unit = class({modifier_item_weapon_007_hero})--给民兵的效果


function item_weapon_007:GetIntrinsicModifierName()
    return "modifier_item_weapon_007_hero"
end

function modifier_item_weapon_007_hero:DeclareFunctions()
    return  {  MODIFIER_EVENT_ON_ATTACK_LANDED
    }
end

function modifier_item_weapon_007_hero:OnAttackLanded(keys)
    if IsServer() then
        local owner = self:GetParent()
        local target = keys.target 
        local  attacker  = keys.attacker      
        local ability = self:GetAbility()
        local hp_pct  = ability:GetSpecialValueFor("p1") /100
        local caster = self:GetCaster()
    
        local damage_type  =ability:GetAbilityDamageType()
        local target_types =ability:GetAbilityTargetType()
        local target_flags =ability:GetAbilityTargetFlags()

		if owner ~= keys.attacker then
			return end

		if owner:IsIllusion() then 
            return end

        if target:HasItemInInventory("item_horses_013") or 
           target:HasItemInInventory("item_horses_014") or
           target:HasItemInInventory("item_horses_015") or
           target:HasItemInInventory("item_horses_016") or
           target:HasItemInInventory("item_horses_017") or
           target:HasItemInInventory("item_horses_018") or
           target:HasItemInInventory("item_horses_019")  then

            local dummy = CreateUnitByName( "npc_damage_dummy", Vector(0,0,0), false, owner, owner, owner:GetTeamNumber() )
            dummy.attack_type  = "tree"
            dummy:AddNewModifier(dummy, nil, 'modifier_kill', {duration = 0.1} )

            local  damage_table = {
                attacker     = dummy,
                victim       = target,
                damage_type  = damage_type,
                damage       = target:GetMaxHealth() * hp_pct, 
                damage_flags = DOTA_DAMAGE_FLAG_NONE
            }
            ApplyDamage(damage_table)
        end
	end
end

function modifier_item_weapon_007_hero:IsHidden()  return true end