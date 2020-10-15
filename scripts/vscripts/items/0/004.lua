item_weapon_004 = item_weapon_004 or class(item_class)
------------------------------------------------------------------
LinkLuaModifier( "modifier_item_weapon_004_owner","items/0/004", 0 )
LinkLuaModifier( "modifier_item_weapon_004_hero","items/0/004", 0 )
LinkLuaModifier( "modifier_item_weapon_004_unit","items/0/004", 0 )
LinkLuaModifier( "modifier_item_weapon_004_unstun","items/0/004", 0 )
modifier_item_weapon_004_owner = modifier_item_weapon_004_owner or {}--给主公（信使）的效果
modifier_item_weapon_004_hero = modifier_item_weapon_004_hero or {}--给武将的效果
modifier_item_weapon_004_unit = class(modifier_item_weapon_004_hero) or class({})--给民兵的效果
modifier_item_weapon_004_unstun = modifier_item_weapon_004_unstun or {}


function modifier_item_weapon_004_hero:DeclareFunctions()	
    return 
    { 
        MODIFIER_EVENT_ON_ATTACK_LANDED
    } 
end

function modifier_item_weapon_004_hero:CheckState()
    local ability  = self:GetAbility()
    local chance = ability:GetSpecialValueFor("p1")
    if RollPercentage(chance) then
        local states = {
            [MODIFIER_STATE_CANNOT_MISS] = true,
        }
        return states
    end
end

function modifier_item_weapon_004_hero:OnAttackLanded(keys)
    if IsServer() then
        local owner = self:GetParent()
        local ability = self:GetAbility()
		local attacker = keys.attacker
        local target = keys.target
        
		if owner ~= keys.attacker then
            return end
            
        if owner:IsIllusion() then 
            return end
            
			if RollPercentage(10) then

				target:AddNewModifier(owner, ability, "modifier_item_weapon_004_unstun", {duration = 1})

				-- if not target:HasModifier("modifier_item_weapon_004_unstun") then
				-- 	target:AddNewModifier(owner, ability, "modifier_item_weapon_004_unstun", {duration = 1})
				-- else
				-- 	target:RemoveModifierByName("modifier_item_weapon_004_unstun")
				-- 	target:AddNewModifier(owner, ability, modifier_skull_break, {duration = 1})
				-- end
			end
		
	end
end

function modifier_item_weapon_004_hero:IsDebuff()       return false end
function modifier_item_weapon_004_hero:IsHidden ()      return true end
function modifier_item_weapon_004_unstun:IsHidden ()    return true end
function modifier_item_weapon_004_unstun:IsDebuff()     return true end
function modifier_item_weapon_004_unstun:IsStunDebuff() return true end
function modifier_item_weapon_004_unstun:IsPurgable() 	return true end

function modifier_item_weapon_004_unstun:CheckState()
    local state = {
    [MODIFIER_STATE_STUNNED]=true,
}      return state
end
