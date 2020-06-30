-- 西索
-- 2020/06/30
-- 刘备的刘桃，带羁绊加强

function liutao(keys)

	local caster  = keys.caster
    local ability = keys.ability
    local owner   = caster:GetOwner() or {ship={}}
    local modname = "modifier_skill_hero_liutao"
    local duration= ability:GetSpecialValueFor("duration")
    local radius  = ability:GetSpecialValueFor("radius")
	local target_team  = ability:GetAbilityTargetTeam()
	local target_types = ability:GetAbilityTargetType()
    local target_flags = ability:GetAbilityTargetFlags()

    if not owner.ship['taoyuan'] then
        return
    end

    duration = owner.ship['yemeng'] and duration + 2 or duration

    local teammate = FindUnitsInRadius( caster:GetTeamNumber(),
                                        caster:GetOrigin(),
                                        nil,
                                        radius,
                                        target_team,
                                        target_types,
                                        target_flags,
                                        0,
                                        true)

    for k,v in pairs(teammate) do
        ability:ApplyDataDrivenModifier(caster, v, modname.."_2", {duration = duration})
    end

    if caster:HasModifier(modname.."_2")
    and caster:HasModifier(modname) then
    caster:RemoveModifierByName(modname)
    end
end