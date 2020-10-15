item_weapon_005 = item_weapon_005 or class(item_class)
------------------------------------------------------------------
LinkLuaModifier( "modifier_item_weapon_005_owner","items/0/005", 0 )
LinkLuaModifier( "modifier_item_weapon_005_hero","items/0/005", 0 )
LinkLuaModifier( "modifier_item_weapon_005_unit","items/0/005", 0 )
LinkLuaModifier( "modifier_item_weapon_005_hero_buff","items/0/005", 0 )
modifier_item_weapon_005_owner = modifier_item_weapon_005_owner or {}--给主公（信使）的效果
modifier_item_weapon_005_hero = modifier_item_weapon_005_hero or {}--给武将的效果
modifier_item_weapon_005_unit = class(modifier_item_weapon_005_hero) or class({})--给民兵的效果
modifier_item_weapon_005_hero_buff = modifier_item_weapon_005_hero_buff or {}


function modifier_item_weapon_005_hero:DeclareFunctions()	
    return 
    { 
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_EVENT_ON_ATTACK_LANDED
    } 
end

function modifier_item_weapon_005_hero:GetModifierAttackSpeedBonus_Constant()	
    local ability = self:GetAbility()
    local attack_speed  = ability:GetSpecialValueFor("p1")
        return attack_speed        
end

function modifier_item_weapon_005_hero:OnAttackLanded(keys)
    if IsServer() then
		local owner = self:GetParent()
        local target = keys.target
        local ability = self:GetAbility()
        local chance = ability:GetSpecialValueFor("p2")
		if owner ~= keys.attacker then
			return end
		
		if owner:IsIllusion() then 
			return end

            if RollPercentage(chance) then
            owner:AddNewModifier(owner, ability, "modifier_item_weapon_005_hero_buff", {duration = 1.5})
        end
    end
end

function modifier_item_weapon_005_hero_buff:DeclareFunctions()	
    return 
    { 
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
    } 
end

function modifier_item_weapon_005_hero_buff:GetModifierAttackSpeedBonus_Constant()	
    local ability = self:GetAbility()
    local atk_speed  = ability:GetSpecialValueFor("p3")
        return atk_speed        
end

function modifier_item_weapon_005_hero:IsDebuff()			        return false end
function modifier_item_weapon_005_hero:IsHidden() 		            return true end
function modifier_item_weapon_005_hero:IsPurgable() 		        return false end
function modifier_item_weapon_005_hero_buff:IsDebuff()			    return false end
function modifier_item_weapon_005_hero_buff:IsHidden() 		        return false end
function modifier_item_weapon_005_hero_buff:IsPurgable() 		    return true end