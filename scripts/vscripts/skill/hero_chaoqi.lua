


-- Author: 西索酱
-- Date: 17.07.2020
-- evasion and crit

function Oncreated(keys)
    local ability = keys.ability
    
    ability.needwaveup = function ( ability)        
        local caster  = ability:GetCaster()
        local owner   = caster:GetOwner() or {ship={}}
        local modName = "modifier_skill_hero_chaoqi_attack"
        if  owner.ship['yiji'] then
            ability:ApplyDataDrivenModifier( caster, caster , modName, nil )
        end
    end

end

function HitUnitDamage(keys)

	local caster  = keys.caster
	local target  = keys.target
	local ability = keys.ability
	local damage  = ability:GetSpecialValueFor( "damage" )
    local damage_type  = ability:GetAbilityDamageType()
    
	local dummy = CreateUnitByName( "npc_damage_dummy", Vector(0,0,0), false, caster, caster, caster:GetTeamNumber() )
	dummy.attack_type  = "electrical"
	dummy:AddNewModifier(dummy, nil, 'modifier_kill', {duration = 1} )

	local damage_table = {}
	damage_table.attacker     = dummy
    damage_table.victim       = target
	damage_table.damage_type  = damage_type
	damage_table.ability      = ability
	damage_table.damage       = damage
	damage_table.damage_flags = DOTA_DAMAGE_FLAG_NONE
	
	ApplyDamage(damage_table)

end