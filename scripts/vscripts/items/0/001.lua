item_weapon_001 = item_weapon_001 or class(item_class)
------------------------------------------------------------------
LinkLuaModifier( "modifier_item_weapon_001_owner","items/0/001", 0 )
LinkLuaModifier( "modifier_item_weapon_001_hero","items/0/001", 0 )
LinkLuaModifier( "modifier_item_weapon_001_unit","items/0/001", 0 )
LinkLuaModifier( "modifier_item_weapon_001_hero_debuff","items/0/001", 0 )
modifier_item_weapon_001_owner = modifier_item_weapon_001_owner or {}--给主公（信使）的效果
modifier_item_weapon_001_hero = modifier_item_weapon_001_hero or {}--给武将的效果
modifier_item_weapon_001_unit = class({modifier_item_weapon_001_hero})--给民兵的效果
modifier_item_weapon_001_hero_debuff = modifier_item_weapon_001_hero_debuff or {}

function item_weapon_001:GetIntrinsicModifierName()
    return "modifier_item_weapon_001_hero"
end

function modifier_item_weapon_001_hero:DeclareFunctions()
    return  {  MODIFIER_EVENT_ON_ATTACK_LANDED
    }
end

function modifier_item_weapon_001_hero:OnAttackLanded(keys)
    if IsServer() then
		local owner = self:GetParent()

		if owner ~= keys.attacker then
			return end
		local target = keys.target
		if owner:IsIllusion() then 
			return end

		if target:HasModifier("modifier_item_weapon_001_hero_debuff") then
			return end

        local ability = self:GetAbility()
        target:AddNewModifier(owner, ability, "modifier_item_weapon_001_hero_debuff", {duration = 3})
	end
end

function modifier_item_weapon_001_hero_debuff:DeclareFunctions()
    return  {  MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS       
}
end

function modifier_item_weapon_001_hero_debuff:GetModifierPhysicalArmorBonus()
    local ability=self:GetAbility()
    local armor = ability:GetSpecialValueFor('p1')
    return  -armor 
end

function modifier_item_weapon_001_hero:IsDebuff()			        return false end
function modifier_item_weapon_001_hero:IsHidden() 		            return true end
function modifier_item_weapon_001_hero:IsPurgable() 		        return false end
function modifier_item_weapon_001_hero_debuff:IsDebuff()			return true end
function modifier_item_weapon_001_hero_debuff:IsHidden() 		    return false end
function modifier_item_weapon_001_hero_debuff:IsPurgable() 		    return true end