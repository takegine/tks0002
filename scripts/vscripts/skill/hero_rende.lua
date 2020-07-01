-- 西索
-- 2020.07.01
-- 友军回血，敌军扣血

function rende(keys)

	local caster  = keys.caster
    -- local point   = keys.target_points[1]
    local target  = keys.target
    local ability = keys.ability
    local attacker= keys.attacker
    local partfri = keys.partfri
    local owner   = caster:GetOwner() or {ship={}}

    local HPRegen = ability:GetLevelSpecialValueFor("hp_re", (ability:GetLevel()-1) )
    local damage  = ability:GetLevelSpecialValueFor("damage", (ability:GetLevel()-1) )/ 100
    local radius  = ability:GetLevelSpecialValueFor("radius", (ability:GetLevel()-1) )
    local damage_type  = ability:GetAbilityDamageType()
	local target_team  = ability:GetAbilityTargetTeam()
	local target_types = ability:GetAbilityTargetType()
    local target_flags = ability:GetAbilityTargetFlags()


    if target:GetUnitName() == "npc_dota_hero_phoenix" then
        return
    elseif not target:IsOpposingTeam(caster:GetTeamNumber()) then

        target:Heal(HPRegen, ability)
        SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, target, HPRegen, nil)

        local inPart = ParticleManager:CreateParticle( partfri, PATTACH_ABSORIGIN_FOLLOW, target)
        ParticleManager:SetParticleControl(inPart, 0, target:GetAbsOrigin())
        ParticleManager:SetParticleControl(inPart, 1, Vector(20,20,20))
        ParticleManager:SetParticleControl(inPart, 3, caster:GetAbsOrigin())
        ParticleManager:ReleaseParticleIndex(inPart)

    elseif owner.ship['quhu'] then

        local damage_table = {
            attacker     = caster,
            victim       = target,
            damage_type  = damage_type,
            ability      = ability,
            damage       = damage * HPRegen
        }

        ApplyDamage(damage_table)
        SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, target, damage_table.damage, nil)
    end
end