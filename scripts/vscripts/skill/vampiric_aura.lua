--[[
	Author: Noya
	Date: 14.01.2015.
	Applies a Lifesteal modifier if the attacked target is not a building and not a mechanical unit
]]
function VampiricAuraApply( event )
	-- Variables
	local attacker = event.attacker
	local target = event.target
	local ability = event.ability

	if target.GetInvulnCount == nil  then
		ability:ApplyDataDrivenModifier(attacker, attacker, "modifier_skill_hero_xixue_3", {duration = 1})
	end
	if target.GetInvulnCount == nil  then
		ability:ApplyDataDrivenModifier(attacker, attacker, "skill_hero_chongzhen_baoji", {duration = 1})
	end

end
function yiqidangqian(data)
local caster = data.caster

  if caster:GetUnitName() == "npc_hero_madai" then
     --如果是马岱
     caster:ApplyDataDrivenModifier( caster, caster, "modifier_skill_ship_yiqidangqian", nil )
     --就给马岱加上一个 修饰器，名字是Modifier_skill_ship_NAME_for_zhaoyun
  end

  if caster:GetUnitName() == "npc_hero_machao" then
     --如果是马超
     caster:ApplyDataDrivenModifier( caster, caster, "modifier_skill_ship_yiqidangqian", nil )
     --就给马岱加上一个 修饰器，名字是Modifier_skill_ship_NAME_for_zhaoyun
  end

end
