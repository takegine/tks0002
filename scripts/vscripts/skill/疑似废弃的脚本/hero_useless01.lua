
--[[Author: Pizzalol,Noya
	Date: February 24, 2016
	Initializes the Illuminate and swaps the abilities]]
function IlluminateStart( keys )--开始施法时更换技能，换成打断技能
	local caster = keys.caster
	local ability = keys.ability
	ability.illuminate_position = caster:GetAbsOrigin()
	ability.illuminate_vision_position = ability.illuminate_position
	ability.illuminate_direction = caster:GetForwardVector()
	ability.illuminate_start_time = GameRules:GetGameTime()

	-- Swap sub_ability
	local sub_ability_name = keys.sub_ability_name
	local main_ability_name = ability:GetAbilityName()

	caster:SwapAbilities(main_ability_name, sub_ability_name, false, true)
end

--[[Author: Pizzalol
	Date: February 24, 2016
	Creates vision fields every tick interval on the set positions]]
function IlluminateVisionFields( keys )--施法时 获取视野，已取消
	local caster = keys.caster
	local ability = keys.ability

	-- Vision variables
	local channel_vision_radius = ability:GetLevelSpecialValueFor("channel_vision_radius", (ability:GetLevel() - 1))
	local channel_vision_duration = ability:GetLevelSpecialValueFor("channel_vision_duration", (ability:GetLevel() - 1))
	local channel_vision_step = ability:GetLevelSpecialValueFor("channel_vision_step", (ability:GetLevel() - 1))

	-- Calculating the position
	ability.illuminate_vision_position = ability.illuminate_vision_position + ability.illuminate_direction * channel_vision_step

	AddFOWViewer(caster:GetTeamNumber(),ability.illuminate_vision_position,channel_vision_radius, channel_vision_duration,false)
end

--[[Author: Pizzalol
	Date: February 24, 2016
	Calculates the channel time according to the starting time and current time
	Calculates the damage according to the channel time
	Creates a projectile based on the casters starting channeling position]]
function IlluminateEnd( keys )
	local caster = keys.caster
	local ability = keys.ability

	-- Ability variables	
	ability.illuminate_damage = 0
	local damage_per_second = ability:GetLevelSpecialValueFor("damage_per_second", (ability:GetLevel() - 1))

	-- Projectile variables
	local projectile_name = keys.projectile_name
	local projectile_speed = ability:GetLevelSpecialValueFor("speed", (ability:GetLevel() - 1))
	local projectile_distance = ability:GetLevelSpecialValueFor("range", (ability:GetLevel() - 1))
	local projectile_radius = ability:GetLevelSpecialValueFor("radius", (ability:GetLevel() - 1))


	-- Calculating the Illuminate channel time and damage
	--ability.illuminate_channel_time = GameRules:GetGameTime() - ability.illuminate_start_time
	ability.illuminate_damage = 500--ability.illuminate_channel_time * damage_per_second


	-- Create projectile
	local projectileTable =
	{
		EffectName 		= projectile_name,
		Ability 		= ability,
		vSpawnOrigin 	= caster:GetAbsOrigin(),--ability.illuminate_position,
		vVelocity 		= projectile_speed * caster:GetForwardVector(),--ability.illuminate_direction
		fDistance 		= projectile_distance,
		fStartRadius 	= projectile_radius,
		fEndRadius 		= projectile_radius,
		Source 			= caster,
		bHasFrontalCone = false,
		bReplaceExisting= true,
		iUnitTargetTeam = ability:GetAbilityTargetTeam(),
		iUnitTargetFlags= DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType = ability:GetAbilityTargetType()
	}
	ability.illuminate_projectileID = ProjectileManager:CreateLinearProjectile( projectileTable )
end

--[[Author: Pizzalol
	Date: February 24, 2016
	Deals damage according to the channel time]]
function IlluminateProjectileHit( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target

	local damage_table = {}

	damage_table.attacker = caster
	damage_table.victim = target
	damage_table.ability = ability
	damage_table.damage_type = DAMAGE_TYPE_PHYSICAL--ability:GetAbilityDamageType()
	damage_table.damage = 500

	ApplyDamage(damage_table)
end

--[[Author: Noya
	Used by: Pizzalol
	Date: 24.01.2015.
	Swaps the abilities back]]
function IlluminateSwapEnd( keys )--施法结束，交换技能位置
	local caster = keys.caster
	local main_ability = keys.ability

	-- Swap the sub_ability back to normal
	local main_ability_name = main_ability:GetAbilityName()
	local sub_ability_name = keys.sub_ability_name

	caster:SwapAbilities(main_ability_name, sub_ability_name, true, false)
end

--[[Author: Pizzalol
	Date: 24.01.2015.
	Stops the ability channel]]
function IlluminateStop( keys )
	local caster = keys.caster

	caster:Stop()
end

--[[
	Author: Noya
	Used by: Pizzalol
	Date: 24.01.2015.
	Levels up the ability_name to the same level of the ability that runs this
]]
function LevelUpAbility( event )--技能升级，已取消
	local caster = event.caster
	local this_ability = event.ability		
	local this_abilityName = this_ability:GetAbilityName()
	local this_abilityLevel = this_ability:GetLevel()

	-- The ability to level up
	local ability_name = event.ability_name
	local ability_handle = caster:FindAbilityByName(ability_name)	
	local ability_level = ability_handle:GetLevel()

	-- Check to not enter a level up loop
	if ability_level ~= this_abilityLevel then
		ability_handle:SetLevel(this_abilityLevel)
	end
end



function tiejicreate(keys)
	local caster = keys.caster
	local ability = keys.ability
	local faceto =caster:GetForwardVector()
	local popp =ability:GetCaster()
	-- Projectile variables
	local projectile_name = keys.projectile_name

	local projectile_speed = ability:GetLevelSpecialValueFor("speed", (ability:GetLevel() - 1))
	local projectile_range = ability:GetLevelSpecialValueFor("range", (ability:GetLevel() - 1))
	local projectile_radius= ability:GetLevelSpecialValueFor("radius", (ability:GetLevel() - 1))

	-- Create projectile
	
	--ParticleManager:GetParticleReplacement(projectile_name, hCaster)
	local iParticleID=ParticleManager:CreateParticle(projectile_name, PATTACH_CUSTOMORIGIN , nil )
	--0是光圈起始位置 2是半径吧 3是马 8跟 10控制蓄力
	ParticleManager:SetParticleControl( iParticleID, 0, popp:GetAbsOrigin())--self.vStart )起始点
	ParticleManager:SetParticleControlForward( iParticleID, 0, faceto)--self.vDirection )朝向
	ParticleManager:SetParticleControl( iParticleID, 1, projectile_speed * faceto)--self.vDirection*speed )速度
	ParticleManager:SetParticleControl( iParticleID, 2, Vector(500,0,0))--Vector(fRadius,0,0) )
	ParticleManager:SetParticleControl( iParticleID, 3, popp:GetAbsOrigin())--self.vStart )
	ParticleManager:SetParticleControlForward( iParticleID, 3, faceto)--self.vDirection )
	ParticleManager:SetParticleFoWProperties( iParticleID, 3,-1,500)--fRadius )
	--ParticleManager:SetParticleControl( iParticleID, 8, Vector(self.fContinueTime,0,0) )
	--ParticleManager:SetParticleControl( iParticleID, 10,Vector(self.fContinueTime,0,0) )
	ParticleManager:ReleaseParticleIndex( iParticleID )
	--[[local projectileTable =
		{
		EffectName 		= projectile_name,"particles/econ/items/lina/lina_head_headflame/lina_spell_dragon_slave_headflame.vpcf"
		Ability 		= ability,
		vSpawnOrigin 	= popp:GetAbsOrigin(),--始发地点
		Target			= target,
		vVelocity 		= projectile_speed * faceto,--速度，带施法时脸的朝向
		fDistance 		= projectile_range,--距离
		fStartRadius 	= projectile_radius,--起始半径
		fEndRadius 		= projectile_radius+1500,--结束半径
		Source 			= caster,			--创建者
		bHasFrontalCone = false,			--有椎体
		bReplaceExisting= true,				--替代现有(投射器?)
		iUnitTargetTeam = ability:GetAbilityTargetTeam(),	--目标队伍
		iUnitTargetFlags= DOTA_UNIT_TARGET_FLAG_NONE,		--目标标记
		iUnitTargetType = ability:GetAbilityTargetType(),	--目标类型
		}
	ProjectileManager:CreateLinearProjectile( projectileTable )]]	
								
	--[[projectileTable2{
		EffectName?: string
		Ability?: CDOTABaseAbility
		Source?: CDOTA_BaseNPC
		vSourceLoc?: Vector
		Target?: CDOTA_BaseNPC
		iMoveSpeed?: int
		flExpireTime?: float
		bDodgeable?: bool
		bIsAttack?: bool
		bReplaceExisting?: bool
		iSourceAttachment?: DOTAProjectileAttachment_t
		bDrawsOnMinimap?: bool
		bVisibleToEnemies?: bool
		bProvidesVision?: bool
		iVisionRadius?: uint
		iVisionTeamNumber?: DOTATeam_t
		ExtraData?: Record<string, string | number | boolean>
		}
	ProjectileManager:CreateTrackingProjectile(projectileTable2)]]
end

--[[if caster:GetModifierCount() then
	for i = 0,caster:GetModifierCount() do
	--print("modifier_",caster:GetUnitName(),i,caster:GetModifierNameByIndex(i):GetName() )
	end
end
SetOrigin(-1 * enetity:GetForwardVector())]]