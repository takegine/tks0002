--[[
	西索酱
	05/13/2020 - 修改自Tinker的机器人进军
]]

--[[
	CHANGELIST:
	10.01.2015 - Delete unnecessary parameter to avoid confusion
]]

--[[
	Author: kritth
	Date: 10.01.2015
	Find necessary vectors, and spawn spawning until units cap is reached
]]
function march_of_the_machines_spawn( keys )
	-- Variables
	local caster 	= keys.caster
	local ability 	= keys.ability
	local casterLoc = caster:GetAbsOrigin()
	local targetLoc = keys.target_points[1]
	local duration 	= ability:GetLevelSpecialValueFor( "duration", ability:GetLevel() - 1 )
	local distance 	= ability:GetLevelSpecialValueFor( "distance", ability:GetLevel() - 1 )
	local radius 	= ability:GetLevelSpecialValueFor( "radius", ability:GetLevel() - 1 )
	local collision_radius 	= ability:GetLevelSpecialValueFor( "collision_radius", ability:GetLevel() - 1 )
	local projectile_speed 	= ability:GetLevelSpecialValueFor( "speed", ability:GetLevel() - 1 )
	local machines_per_sec 	= ability:GetLevelSpecialValueFor ( "machines_per_sec", ability:GetLevel() - 1 )
	local dummyModifierName = "modifier_march_of_the_machines_dummy_datadriven"
	local projectile_name 	= keys.projectile_name
	
	-- Find forward vector
	local 	forwardVec = targetLoc - casterLoc
			forwardVec = forwardVec:Normalized()
	local  velocityVec = Vector( forwardVec.x, forwardVec.y, 0 )

	-- Find backward vector
	local 	backwardVec = casterLoc - targetLoc
			backwardVec = backwardVec:Normalized()
	
	-- Find middle point of the spawning line
	--local middlePoint = casterLoc + ( radius * backwardVec )
	
	-- Find perpendicular vector
	local v = radius * backwardVec
	local 	perpendicularVec = Vector( -v.y, v.x, v.z )
			perpendicularVec = perpendicularVec:Normalized()
	
	-- Create dummy to store data in case of multiple instances are called
	local horse_num = 0
	
	-- Create timer to spawn projectile
	Timer( function()
			-- Get random location for projectile
			local spawn_location = casterLoc +v + perpendicularVec * RandomInt( -radius, radius )
			
			-- Spawn projectiles 用来判断的粒子
			local projectileTable = {
				Ability			= ability,
				EffectName		= "particles/units/heroes/hero_magnataur/magnataur_shockwave.vpcf",
				vSpawnOrigin	= spawn_location,
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
			ProjectileManager:CreateLinearProjectile( projectileTable )
			--[[
			-- Spawn projectiles 用来观看的粒子
			local iParticleID =	ParticleManager:CreateParticle(projectile_name, PATTACH_CUSTOMORIGIN , nil )
				--0是光圈起始位置 2是半径吧 3是马 8跟 10控制蓄力
								ParticleManager:SetParticleControl( iParticleID, 0, spawn_location)--self.vStart )起始点
								ParticleManager:SetParticleControlForward( iParticleID, 0, velocityVec)--self.vDirection )朝向
								ParticleManager:SetParticleControl( iParticleID, 1, projectile_speed * velocityVec)--self.vDirection*speed )速度
								ParticleManager:SetParticleControl( iParticleID, 2, Vector(collision_radius,0,0))--Vector(fRadius,0,0) )
								ParticleManager:SetParticleControl( iParticleID, 3, spawn_location)--self.vStart )
								ParticleManager:SetParticleControlForward( iParticleID, 3, velocityVec)--self.vDirection )
								ParticleManager:SetParticleFoWProperties( iParticleID, 3,-1,collision_radius)--fRadius )
								--ParticleManager:SetParticleControl( iParticleID, 8, Vector(self.fContinueTime,0,0) )
								--ParticleManager:SetParticleControl( iParticleID, 10,Vector(self.fContinueTime,0,0) )
			ParticleManager:ReleaseParticleIndex( iParticleID )]]
			
			-- Increment the counter
			horse_num = horse_num + 1
			
			-- Check if the number of machines have been reached
			if horse_num == machines_per_sec * duration then return nil
			else return 1 / machines_per_sec
			end
		end
	)
end
