--[[
	西索酱
	05/13/2020 - 修改自Tinker的机器人进军
]]

function march_of_the_machines_spawn( keys )
	-- Variables
	local caster 	= keys.caster
	local ability 	= keys.ability
	local casterLoc = caster:GetAbsOrigin()
	local targetLoc = keys.target_points[1]
	local duration 	= ability:GetSpecialValueFor( "duration" )
	local distance 	= ability:GetSpecialValueFor( "distance" )
	local radius 	= ability:GetSpecialValueFor( "radius" )
	local wave 		= ability:GetSpecialValueFor( "wave" )
	local collision_radius 	= ability:GetSpecialValueFor( "collision_radius" )
	local projectile_speed 	= ability:GetSpecialValueFor( "speed" )
	local projectile_name 	= keys.projectile_name

	-- 朝向
	local 	forwardVec = targetLoc - casterLoc
			forwardVec = forwardVec:Normalized()
	local  velocityVec = Vector( forwardVec.x, forwardVec.y, 0 )

	-- 背向
	local 	backwardVec = casterLoc - targetLoc
			backwardVec = backwardVec:Normalized()
		
	-- 纵向
	local v = radius * backwardVec
	local 	perpendicularVec = Vector( -v.y, v.x, v.z )
			perpendicularVec = perpendicularVec:Normalized()
	
	-- 计数
	local pfx_count = 0
	
	-- 投射物主体信息
	local projectileTable = {
		Ability			= ability,
		EffectName		= projectile_name,
		vSpawnOrigin	= nil,
		fDistance		= distance,
		fStartRadius	= collision_radius,
		fEndRadius 		= collision_radius,
		Source 			= caster,
		bHasFrontalCone = false,
		bReplaceExisting= false,
		bProvidesVision = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		vVelocity 		= velocityVec * projectile_speed
		}

	-- 错峰生成波
	Timer( function()
			projectileTable.vSpawnOrigin = casterLoc +v + perpendicularVec * RandomInt( -radius, radius )
			ProjectileManager:CreateLinearProjectile( projectileTable )
			
			pfx_count = pfx_count + 1

			if pfx_count == wave
			then return nil
			else return duration / wave
			end
		end
	)

	-- -- Spawn projectiles 用来观看的粒子
	
	-- local projectile_name 	= "particles/units/heroes/hero_keeper_of_the_light/keeper_of_the_light_illuminate.vpcf"
	-- local iParticleID =	ParticleManager:CreateParticle(projectile_name, PATTACH_CUSTOMORIGIN , nil )
	-- 	--0是光圈起始位置 2是半径吧 3是马 8跟 10控制蓄力
	-- 					ParticleManager:SetParticleControl( iParticleID, 0, spawn_location)--self.vStart )起始点
	-- 					ParticleManager:SetParticleControlForward( iParticleID, 0, velocityVec)--self.vDirection )朝向
	-- 					ParticleManager:SetParticleControl( iParticleID, 1, projectile_speed * velocityVec)--self.vDirection*speed )速度
	-- 					ParticleManager:SetParticleControl( iParticleID, 2, Vector(collision_radius,0,0))--Vector(fRadius,0,0) )
	-- 					ParticleManager:SetParticleControl( iParticleID, 3, spawn_location)--self.vStart )
	-- 					ParticleManager:SetParticleControlForward( iParticleID, 3, velocityVec)--self.vDirection )
	-- 					ParticleManager:SetParticleFoWProperties( iParticleID, 3,-1,collision_radius)--fRadius )
	-- 					--ParticleManager:SetParticleControl( iParticleID, 8, Vector(self.fContinueTime,0,0) )
	-- 					--ParticleManager:SetParticleControl( iParticleID, 10,Vector(self.fContinueTime,0,0) )
	-- ParticleManager:ReleaseParticleIndex( iParticleID )
end

function HitUnitDamage(keys)
	
	local caster  = keys.caster
	local target  = keys.target
	local ability = keys.ability
	local owner   = caster:GetOwner() or {ship={}}
	local damage  = ability:GetSpecialValueFor( "damage" )
    local damage_type  = ability:GetAbilityDamageType()

	local dummy = CreateUnitByName( "npc_damage_dummy", Vector(0,0,0), false, caster, caster, caster:GetTeamNumber() )
	dummy.attack_type  = "electrical"
	dummy:AddNewModifier(dummy, nil, 'modifier_kill', {duration = 0.1} )

	local damage_table = {}
	damage_table.attacker     = dummy
    damage_table.victim       = target
	damage_table.damage_type  = damage_type
	damage_table.ability      = ability
	damage_table.damage       = damage
	damage_table.damage_flags = DOTA_DAMAGE_FLAG_NONE
	
	ApplyDamage(damage_table)

	
	if owner.ship['wuhu'] then

		damage_table.attacker     = caster
		damage_table.damage       = target:GetHealth()*0.04
		damage_table.damage_type  = DAMAGE_TYPE_PHYSICAL
		damage_table.damage_flags = DOTA_DAMAGE_FLAG_IGNORES_PHYSICAL_ARMOR
	
		ApplyDamage(damage_table)
	end
end