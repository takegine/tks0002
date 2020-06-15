LinkLuaModifier("bianyang", "scripts/vscripts/skill/bianyang.lua", LUA_MODIFIER_MOTION_NONE)

function panduanbianayang( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local target = keys.target

	local duration = ability:GetLevelSpecialValueFor("duration", ability_level)
		
	if target:IsIllusion() then
		target:ForceKill(true)
		--判断是否为分身，是就杀死分身
	else
		--不是分身就向此目标添加修饰符（把目标变羊）
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


