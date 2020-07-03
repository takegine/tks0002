function OnAttack(keys)

	local caster  = keys.caster
    local ability = keys.ability
    local owner   = caster:GetOwner() or {ship={}}
    local chance  = ability:GetLevelSpecialValueFor("chance", (ability:GetLevel()-1) )
    local damage  = ability:GetLevelSpecialValueFor("damage", (ability:GetLevel()-1) )
    local radius  = ability:GetSpecialValueFor("radius")
    
    local attspeedmod  = keys.attspeedmod
    local debuffname   = keys.debuffname
    local debuff_dur   = ability:GetSpecialValueFor("debuff_dur")
    local speed_dur    = ability:GetSpecialValueFor("speed_dur")
    local damage_type  = ability:GetAbilityDamageType()
	local target_team  = ability:GetAbilityTargetTeam()
	local target_types = ability:GetAbilityTargetType()
    local target_flags = ability:GetAbilityTargetFlags()

    if  caster:GetItemInSlot(0) and caster:GetItemInSlot(0):GetName()=='item_weapon_zhangbashemao' then
        chance = 100
    end

    if RollPercentage(chance) then
        ability:ApplyDataDrivenModifier( caster, caster, attspeedmod, { duration=speed_dur })

        if owner.ship['wuhu'] then

            local enemy = FindUnitsInRadius(caster:GetTeamNumber(),
                caster:GetOrigin(),
                nil,
                radius,
                target_team,
                target_types,
                target_flags,
                0,
                true)

            for k,v in pairs(enemy) do
                print(k,v:GetUnitName(),v:GetUnitLabel())

                ability:ApplyDataDrivenModifier( caster, v, debuffname, { duration=debuff_dur })
                
            end
        end
    end
end