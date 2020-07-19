LinkLuaModifier("bianyang", "scripts/vscripts/skill/modifier_voodoo_lua.lua", LUA_MODIFIER_MOTION_NONE)

function voodoo_start( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local target = keys.target

	local duration = ability:GetLevelSpecialValueFor("duration", ability_level)
	
	if target:IsIllusion() then
		target:ForceKill(true)
	else
		target:AddNewModifier(caster, ability, "bianyang", {duration = duration})
	end
end

bianyang = class({})

function bianyang:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MODEL_CHANGE
	}
	return funcs
end

function bianyang:GetModifierModelChange(data)
	return "models/courier/defense3_sheep/defense3_sheep.vmdl"
end


