--[[Author: 西索酱
	Date: 22.06.2020.
	按目标最大生命值造成百分比伤害]]
function HeartstopperAura( keys )
	local caster  = keys.caster
	local ability = keys.ability or caster:GetItemInSlot(2)
	local target  = keys.target
	local target_max_hp = target:GetMaxHealth() / 100

	local aura_damage   = ability:GetLevelSpecialValueFor("aura_damage", (ability:GetCurrentCharges() - 1))
	if caster:GetUnitName() == SET_FORCE_HERO then return end
	-- Shows the debuff on the target's modifier bar only if Necrophos is visible
	local visibility_modifier = keys.visibility_modifier
	if  target:CanEntityBeSeenByMyTeam(caster) then
		ability:ApplyDataDrivenModifier(caster, target, visibility_modifier, {})
	else
		target:RemoveModifierByName(visibility_modifier)
	end

	local damage_table = {}

	damage_table.attacker = caster
	damage_table.victim   = target
	damage_table.ability  = ability
	damage_table.damage   = target_max_hp * aura_damage 
	damage_table.damage_type  = DAMAGE_TYPE_PURE
	damage_table.damage_flags = DOTA_DAMAGE_FLAG_HPLOSS

	ApplyDamage(damage_table)
end