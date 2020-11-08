LinkLuaModifier('modifier_skill_hero_wensi', 'skill/hero_wensi.lua', 0)

skill_hero_wensi = class({})

function skill_hero_wensi:needwaveup()  
    local caster=self:GetCaster()

    local owner = caster:XinShi() 

    if owner.ship['sitingzhu'] then
      caster:AddNewModifier(caster, self ,'modifier_skill_hero_wensi', {})
    end
end

function skill_hero_wensi:GetCastRange(location, target)

	if IsServer() then
        return self.BaseClass.GetCastRange(self, location, target)
    end
end

modifier_skill_hero_wensi=class({})

function modifier_skill_hero_wensi:DeclareFunctions()
    return{
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }
end

function modifier_skill_hero_wensi:OnAttackLanded(keys)
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	local target_point = keys.attacker:GetAbsOrigin()
    local spawn_distance = ability:GetSpecialValueFor("spawn_distance")
    local direction = caster:GetForwardVector()

    local spawn_point = caster:GetAbsOrigin() + direction * spawn_distance
	local width  = ability:GetSpecialValueFor("width")
    local length = ability:GetSpecialValueFor("length")
	local speed  = ability:GetSpecialValueFor("speed")
    local particle_projectile = "particles/econ/items/queen_of_pain/qop_arcana/qop_arcana_sonic_wave_v2.vpcf"
    
    local left_QAngle = QAngle(0, 30, 0)
    local right_QAngle = QAngle(0, -30, 0)

    local left_spawn_point = RotatePosition(caster:GetAbsOrigin(), left_QAngle, spawn_point)
    local left_direction = (left_spawn_point - caster:GetAbsOrigin()):Normalized()

    local right_spawn_point = RotatePosition(caster:GetAbsOrigin(), right_QAngle, spawn_point)
    local right_direction = (right_spawn_point - caster:GetAbsOrigin()):Normalized()

    if ability:IsTrained() and 
	not caster:PassivesDisabled() 
		and ((keys.target == caster 
		and not keys.attacker:IsOther() 
		and keys.attacker:GetTeamNumber() ~= keys.target:GetTeamNumber()) or (keys.attacker == self:GetParent())) then
        if RollPercentage(15) then
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
                                    bDeleteOnHit = false,
                                    vVelocity = direction * speed * Vector(1, 1, 0),
                                    bProvidesVision = false,
                                    ExtraData = {damage = damage}
                                }
            CreateHeLiang( spikes_projectile, direction, speed * Vector(1, 1, 0), true)			
            CreateHeLiang( spikes_projectile, left_direction, speed * Vector(1, 1, 0), true)	
            CreateHeLiang( spikes_projectile, right_direction, speed * Vector(1, 1, 0), true)
        end
    end
end

function CreateHeLiang(...)
	local  pfxTable , direction, speed = ...
	pfxTable.vVelocity = direction * speed
    ProjectileManager:CreateLinearProjectile(pfxTable)
end

function skill_hero_wensi:OnProjectileHit_ExtraData(target, location,ExtraData)
	
	if not target then
		return nil
    end
    
    if target:IsMagicImmune() then 
        return nil 
    end

	local caster = self:GetCaster()
    local ability = self


    local dummy = CreateUnitByName( "npc_damage_dummy",OUT_SIDE_VECTOR, false, caster, caster, caster:GetTeamNumber() )  
    dummy.attack_type  = "electrical"
    dummy:AddNewModifier(dummy, nil, 'modifier_kill', {duration = 0.1} )


    local damage = ability:GetSpecialValueFor("damage")
    local damage_type  = ability:GetAbilityDamageType()
	local target_team  = ability:GetAbilityTargetTeam()
	local target_types = ability:GetAbilityTargetType()
    local target_flags = ability:GetAbilityTargetFlags()

	local particle_impact_fx = ParticleManager:CreateParticle(particle_impact, PATTACH_ABSORIGIN, target)
	ParticleManager:SetParticleControl(particle_impact_fx, 0, target:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(particle_impact_fx)

    local damageTable = {victim = target,
                        attacker = dummy,
                        damage = damage,
                        damage_type = damage_type,
                        ability = ability,
                        damage_flags = DOTA_DAMAGE_FLAG_NONE
                        }
	ApplyDamage(damageTable)

end

function modifier_skill_hero_wensi:IsHidden()
    return true
end