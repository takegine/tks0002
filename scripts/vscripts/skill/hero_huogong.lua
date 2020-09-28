--[[
    Author: 西索
    Data: 08/07/2020
    创建投射物和特效
]]
function Fire_thefire( event )
    local caster       = event.caster
    local ability      = event.ability
    local startPos     = event.target_points[1]
    local pathRadius   = event.path_radius
    local damage       = event.damage
    local duration	   = event.duration 
    local dummyMod     = event.dummyMod
    local owner        = caster:GetOwner() or {ship={}}
    local damage_type  = ability:GetAbilityDamageType()
    local target_team  = ability:GetAbilityTargetTeam()
    local target_types = ability:GetAbilityTargetType()
    local target_flags = ability:GetAbilityTargetFlags()
    ability.startPos   = startPos
    ability.expireTime = GameRules:GetGameTime() + duration

    if  caster:HasItemInInventory("item_weapon_010") then
        damage     = 1.25 * damage
        pathRadius = 1.25 * pathRadius
    end

    if  owner.ship['bihe'] then
        pathRadius = 1.25 * pathRadius
    end

    local particleName  = "particles/units/heroes/hero_jakiro/jakiro_macropyre.vpcf"
    local pfx = ParticleManager:CreateParticle( particleName, PATTACH_ABSORIGIN, caster )
    ParticleManager:SetParticleControl( pfx, 0, startPos )
    ParticleManager:SetParticleControl( pfx, 1, startPos )
    ParticleManager:SetParticleControl( pfx, 2, Vector( duration, 0, 0 ) )
    ParticleManager:SetParticleControl( pfx, 3, startPos )

    ProjectileManager:CreateLinearProjectile( {
        Ability				= ability,
        vSpawnOrigin		= startPos,
        fDistance			= 64,
        fStartRadius		= pathRadius,
        fEndRadius			= pathRadius,	
        Source				= caster,
        bHasFrontalCone		= false,
        bReplaceExisting	= false,
        iUnitTargetTeam		= target_team,
        iUnitTargetFlags	= target_flags,
        iUnitTargetType		= target_types,
        fExpireTime			= ability.expireTime,
        bDeleteOnHit		= false,
        vVelocity			= Vector( 0, 0, 0 ),
        bProvidesVision		= false,
    } )

    local dummy = CreateUnitByName( "npc_damage_dummy", startPos, false, caster, caster, caster:GetTeamNumber() )
    dummy.attack_type   = "electrical"
    ability:ApplyDataDrivenModifier( caster, dummy, dummyMod, {} )
    ability.path_radius = pathRadius
    ability.damage      = damage
    ability.dummy       = dummy
end

--[[
    Author: 西索
    Data: 08/07/2020
    投射物撞到了就添加个修改器
]]
function ApplyDummyModifier( event )
    local caster  = event.caster
    local target  = event.target
    local ability = event.ability
    local modifierName = event.modifier_name

    local duration = ability.expireTime - GameRules:GetGameTime()
    ability:ApplyDataDrivenModifier( target, target, modifierName, { duration = duration } )
end

--[[
    Author: 西索
    Data: 08/07/2020
    在特效范围内则造成伤害
]]
function deal_damage( event )
    local caster 	= event.caster
    local target	= event.target
    local ability	= event.ability
    if not ability
    then return
    end

    local dummy      = ability.dummy
    local pathRadius = ability.path_radius
    local damage	 = ability.damage 
    local targetPos  = target:GetAbsOrigin()
    targetPos.z = 0
    
    if ability and ( targetPos - ability.startPos ):Length2D() < pathRadius then
        ApplyDamage( {
            ability  = ability,
            attacker = dummy,
            victim   = target,
            damage   = damage ,
            damage_type = ability:GetAbilityDamageType(),
        } )
    end
end