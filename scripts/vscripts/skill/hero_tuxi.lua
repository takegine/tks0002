LinkLuaModifier('modifier_tuxi_stun', 'skill/hero_tuxi.lua', 0)

skill_hero_tuxi = class({})

function skill_hero_tuxi:GetCastRange(location, target)

	if IsServer() then
        return self.BaseClass.GetCastRange(self, location, target)
    end
end

function skill_hero_tuxi:OnSpellStart()

	if self:GetCursorPosition() == self:GetCaster():GetAbsOrigin() then
		self:GetCaster():SetCursorPosition(self:GetCursorPosition() + self:GetCaster():GetForwardVector())
	end

	local caster = self:GetCaster()
	local ability = self
	local target_point = self:GetCursorPosition()        
	local sound_cast = "Hero_NyxAssassin.Impale" 
    local owner = caster:GetOwner() or {ship={}}  
    local spawn_distance = ability:GetSpecialValueFor("spawn_distance")
	local main_spike_dummy = CreateModifierThinker(self:GetCaster(), self, nil, {}, self:GetCaster():GetAbsOrigin(), self:GetCaster():GetTeamNumber(), false)
	main_spike_dummy.hit_units = 0
	
    EmitSoundOn(sound_cast, caster)

    local direction = (target_point - caster:GetAbsOrigin()):Normalized()
      
    local spawn_point = caster:GetAbsOrigin() + direction * spawn_distance
	local width  = ability:GetSpecialValueFor("width")
    local length = ability:GetSpecialValueFor("length")
	local speed  = ability:GetSpecialValueFor("speed")
	local particle_projectile = "particles/econ/items/nyx_assassin/nyx_assassin_ti6/nyx_assassin_impale_ti6.vpcf"

	local spikes_projectile = { Ability = ability,
								EffectName = particle_projectile,
								vSpawnOrigin = caster:GetAbsOrigin(),
								fDistance = length,
								fStartRadius = width,
								fEndRadius = width,
								Source = caster,
								bHasFrontalCone = false,
								bReplaceExisting = false,
								iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,                          
								iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
								iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,                           
								bDeleteOnHit = false,
								vVelocity = direction * speed * Vector(1, 1, 0),
								bProvidesVision = false,
								ExtraData = {main_spike = true,main_spike_dummy	= main_spike_dummy:entindex()}
							}
	CreateTuXi( spikes_projectile, direction, speed * Vector(1, 1, 0), true)			

	
	if owner.ship['wuzi'] then
        local left_QAngle = QAngle(0, 30, 0)
        local right_QAngle = QAngle(0, -30, 0)

        local left_spawn_point = RotatePosition(caster:GetAbsOrigin(), left_QAngle, spawn_point)
        local left_direction = (left_spawn_point - caster:GetAbsOrigin()):Normalized()

        local right_spawn_point = RotatePosition(caster:GetAbsOrigin(), right_QAngle, spawn_point)
        local right_direction = (right_spawn_point - caster:GetAbsOrigin()):Normalized()
		CreateTuXi( spikes_projectile, left_direction, speed * Vector(1, 1, 0), false)	
		CreateTuXi( spikes_projectile, right_direction, speed * Vector(1, 1, 0), false)	
    end
end

function CreateTuXi(...)
	local  pfxTable , direction, speed,ismain = ...
	pfxTable.vVelocity = direction * speed
	pfxTable.ExtraData.IsMain = ismain
	ProjectileManager:CreateLinearProjectile(pfxTable)
end

function skill_hero_tuxi:OnProjectileHit_ExtraData(target, location, ExtraData)
	
	if not target then
		return nil
	end

	local caster = self:GetCaster()
    local ability = self
    local owner = caster:GetOwner() or {ship={}}  
	local sound_impact = "Hero_NyxAssassin.Impale.Target"
	local sound_land = "Hero_NyxAssassin.Impale.TargetLand"
	local particle_impact = "particles/units/heroes/hero_nyx_assassin/nyx_assassin_impale_hit.vpcf"
	local modifier_stun = "modifier_tuxi_stun"
	local main_spike = 0

    local dummy = CreateUnitByName( "npc_damage_dummy",OUT_SIDE_VECTOR, false, caster, caster, caster:GetTeamNumber() )  
    dummy.attack_type  = "electrical"
    dummy:AddNewModifier(dummy, nil, 'modifier_kill', {duration = 0.1} )

	if IsServer() then
		main_spike = ExtraData.main_spike
	end

	if ExtraData.IsMain == 1 then	
		EntIndexToHScript(ExtraData.main_spike_dummy).hit_units = 1
	else
        EntIndexToHScript(ExtraData.main_spike_dummy).hit_units = 0
	end

	if owner.ship['weizhen'] then	
		local backheal =(caster:GetMaxHealth() * self:GetSpecialValueFor("regen"))  * EntIndexToHScript(ExtraData.main_spike_dummy).hit_units * 0.01
		caster:Heal(backheal, self)
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, caster, backheal, nil)
	end

	local stun_duration = ability:GetSpecialValueFor("stun_duration")
	local air_time = ability:GetSpecialValueFor("air_time")
	local air_height = ability:GetSpecialValueFor("air_height")
    local damage = ability:GetSpecialValueFor("damage")
    local damage_type  = ability:GetAbilityDamageType()
	local target_team  = ability:GetAbilityTargetTeam()
	local target_types = ability:GetAbilityTargetType()
    local target_flags = ability:GetAbilityTargetFlags()

	EmitSoundOn(sound_impact, target)

	local particle_impact_fx = ParticleManager:CreateParticle(particle_impact, PATTACH_ABSORIGIN, target)
	ParticleManager:SetParticleControl(particle_impact_fx, 0, target:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(particle_impact_fx)

	target:AddNewModifier(caster, ability, modifier_stun, {duration = stun_duration})
	

    local damageTable = {victim = target,
                        attacker = dummy,
                        damage = damage,
                        damage_type = damage_type,
                        ability = ability,
                        damage_flags = DOTA_DAMAGE_FLAG_NONE
                        }
	ApplyDamage(damageTable)

end

modifier_tuxi_stun = class({})


function modifier_tuxi_stun:IsHidden ()
    return true
end

function modifier_tuxi_stun:IsDebuff()
	return  true
end

function modifier_tuxi_stun:IsStunDebuff()
	return  true
end

function modifier_tuxi_stun:CheckState()
    local state = {
    [MODIFIER_STATE_STUNNED]=true,
}      return state
end
