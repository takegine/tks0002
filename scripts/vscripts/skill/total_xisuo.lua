-- 作者：西索
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

-- Author: 西索酱
-- Date: 03.07.2020
-- 小于50%的血增加护甲30+lvl*3

function yinghan( keys )
	local caster  = keys.caster  
  --local target  = keys.target
	local ability = keys.ability
    local owner   = caster:GetOwner() or {ship={}}
	local armor   = ability:GetLevelSpecialValueFor("armor",(ability:GetLevel()-1))
	local modifierName = "modifier_skill_hero_yinghan_2"

	local percentage = owner.ship['taoyuan'] and 0.9 or 0.5

	if  not caster:HasModifier(modifierName) 
	and caster:GetHealth() / caster:GetMaxHealth() < percentage then
		ability:ApplyDataDrivenModifier( caster, caster, modifierName, nil )
		caster:SetModelScale(caster:GetModelScale()+0.2)
	end
end

-- 西索
-- 2020/06/30
-- 刘备 桃园结义，带羁绊加强

function liutao( keys )

    local ability = keys.ability

	ability.needwaveup = function ( ability)
		local caster   = ability:GetCaster()
        local owner    = caster:GetOwner() or {ship={}}
        local modname  = "modifier_skill_hero_liutao"
        local duration = ability:GetSpecialValueFor("duration")
        if not owner.ship['taoyuan'] then
            return
        end

        duration = owner.ship['yemeng'] and duration + 2 or duration

        ability:ApplyDataDrivenModifier(caster, caster, modname , {duration = duration})
    end

end

-- Author: 西索酱
-- Date: 30.05.2020
-- 转移30%的属性给随机队友

function fangquan_created(keys)
    
    self = keys.ability
    local caster   = self:GetCaster()
    local range	   = self:GetLevelSpecialValueFor("range",(self:GetLevel()-1))
    local tFriend  = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetOrigin(), nil, range, DOTA_UNIT_TARGET_TEAM_FRIENDLY,DOTA_UNIT_TARGET_HERO, 0, 0, false )

    for k,v in pairs(tFriend)do 
        if v==caster or v:GetName()==SET_FORCE_HERO then
            table.remove(tFriend, k)
        end
    end
    if #tFriend == 0 then return UF_FAIL_DEAD end

    local duration = self:GetLevelSpecialValueFor("duration",(self:GetLevel()-1))
    local change = self:GetLevelSpecialValueFor("change",(self:GetLevel()-1))
    self.Str     = math.ceil(caster:GetStrength()*change)
    self.Agi     = math.ceil(caster:GetAgility()*change)
    self.Int     = math.ceil(caster:GetIntellect()*change)
    local sBuff  = "modifier_skill_hero_fangquan_buff_"
    local sDebuff= "modifier_skill_hero_fangquan_debuff_"

    local target = tFriend[RandomInt(1, #tFriend)]        

    for _,v in pairs({"Str","Agi","Int"}) do
        self:ApplyDataDrivenModifier(caster, target, sBuff..v, {duration=duration})
        target:SetModifierStackCount(sBuff..v, caster, self[v])

        self:ApplyDataDrivenModifier(target, caster, sDebuff..v, nil)
        caster:SetModifierStackCount(sDebuff..v, target,self[v])
    end
    
end

function fangquan_destroy(keys)
    local target = keys.target
    local caster = keys.caster
    local sDebuff= "modifier_skill_hero_fangquan_debuff_"

    for _,v in pairs({"Str","Agi","Int"}) do
        if target:IsAlive() and caster:HasModifier(sDebuff..v) then
            caster:RemoveModifierByNameAndCaster(sDebuff..v, target)
        end
    end
end

-- 西索酱
-- 05/13/2020 
-- 马超 铁骑 修改自Tinker的机器人进军

function tieji( keys )
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

function tieji_HitUnitDamage(keys)
	
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

-- 西索
-- 2020/07/5
-- 张飞 咆哮

function paoxiao(keys)

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

-- 西索
-- 2020/07/5
-- 关银屏 武姬

function wuji(keys)
  
	local caster  = keys.caster
    local target  = keys.target
    local ability = keys.ability
    local attacker= keys.attacker
    local owner   = caster:GetOwner() or {ship={}}
    
    local chance  = ability:GetLevelSpecialValueFor("chance", (ability:GetLevel()-1) )
    local damage  = ability:GetLevelSpecialValueFor("damage", (ability:GetLevel()-1) )
    local radius  = ability:GetLevelSpecialValueFor("radius", (ability:GetLevel()-1) )
    local damage_type  = ability:GetAbilityDamageType()
	local target_team  = ability:GetAbilityTargetTeam()
	local target_types = ability:GetAbilityTargetType()
    local target_flags = ability:GetAbilityTargetFlags()
    
    if   caster:GetItemInSlot(0) 
    and  caster:GetItemInSlot(0):GetName()=='item_weapon_qinglongyanyuedao' 
    then chance = chance * 2
    end

    if not owner.ship['hufu'] 
    or not RollPercentage( chance ) 
    then return 
    end
    
    local pfxName = "particles/econ/items/axe/axe_cinder/axe_cinder_battle_hunger_start.vpcf"
    local zhuan = ParticleManager:CreateParticle( pfxName, PATTACH_ABSORIGIN_FOLLOW, caster)
    ParticleManager:SetParticleControl(zhuan, 0, keys.attacker:GetAbsOrigin())
    ParticleManager:ReleaseParticleIndex(zhuan)

    
	local damage_table = {}

	damage_table.attacker     = caster
    damage_table.victim       = attacker
	damage_table.damage_type  = damage_type
	damage_table.ability      = ability
	damage_table.damage       = damage
	damage_table.damage_flags = DOTA_DAMAGE_FLAG_NONE

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
        damage_table.victim = v
        ApplyDamage(damage_table)
    end

end

-- Author: 西索酱
-- Date: 17.07.2020
-- 马超 一骑当千

function chaooji(keys)
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

function chaooji_HitUnitDamage(keys)

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