-- 不用linkluamodifier 也不是多次执行脚本的技能，可以把脚本都放在这里
-- 这个文件是给 先生放置脚本的

function weixing(keys)
    local ability = keys.ability    --技能魏星
    local caster  = keys.caster     --施法者，这里是魏延
    local target  = keys.target     --目标，这里应该是空值
    
    --给这个技能后置生效，这个needwaveup会在游戏中，所有羁绊添加完成，所有物品添加完成后执行。
    ability.needwaveup = function ( ability)
        local caster   = ability:GetCaster()
        local owner   = caster:GetOwner() or {ship={}}--魏延的持有者，即 玩家操作的信使

        --判断是否拥有对应的羁绊
        if owner.ship['feihuo'] then
            ability:ApplyDataDrivenModifier( caster, caster , "modifier_skill_hero_weixing", nil  )
        end

    end
end

--首先判断是不是拥有诸葛连弩 如果有，则添加modifier_skill_hero_guanxing_3修饰器
function guanxing(keys)
    local ability  = keys.ability     --技能观星
    local caster   = keys.caster     --目标，这里是自己本身
    
    --给这个技能后置生效，这个needwaveup会在游戏中，所有羁绊添加完成，所有物品添加完成后执行。
    ability.needwaveup = function ( ability)
        local caster   = ability:GetCaster()

        --判断物品：第一个格子（武器栏）是不是诸葛连弩
        if  caster:HasItemInInventory("item_weapon_002") then
               ability:ApplyDataDrivenModifier( caster, caster , "modifier_skill_hero_guanxing_3", nil )
        end
        
    end

end

--LinkLuaModifier("qunxingyunluo", "scripts/vscripts/skill/qunxingjiban.lua", LUA_MODIFIER_MOTION_NONE)
--if modifier_skill_hero_wusheng_armor == nil then modifier_skill_hero_wusheng_armor = class({}) end
--function qunxingyunluo:RemoveOnDeath()	return true end
function guanxingjiban(keys)
    local caster  = keys.caster    
    local ability = keys.ability
	ability.count = 1 + ( ability.count or 0)
	print(ability.count)
	
    if ability.count > 3 then 
        ability.count=0
        --hero:AddNewModifier( hero, self, "修饰器名字", {"补充参数，没有就空着"} )
		print("yes")
	end
end

--[[
	Author: Noya
	Date: 14.01.2015.
	Applies a Lifesteal modifier if the attacked target is not a building and not a mechanical unit
]]
function VampiricAuraApply( event )
	-- Variables
	local attacker = event.attacker
	local target = event.target
	local ability = event.ability

	if target.GetInvulnCount == nil  then
		ability:ApplyDataDrivenModifier(attacker, attacker, "modifier_skill_hero_xixue_3", {duration = 1})
	end
	if target.GetInvulnCount == nil  then
		ability:ApplyDataDrivenModifier(attacker, attacker, "skill_hero_chongzhen_baoji", {duration = 1})
	end

end

function yiqidangqian(data)
    local caster = data.caster

    if caster:GetUnitName() == "npc_hero_madai" then
        --如果是马岱
        caster:ApplyDataDrivenModifier( caster, caster, "modifier_skill_ship_yiqidangqian", nil )
        --就给马岱加上一个 修饰器，名字是Modifier_skill_ship_NAME_for_zhaoyun
    end

    if caster:GetUnitName() == "npc_hero_machao" then
        --如果是马超
        caster:ApplyDataDrivenModifier( caster, caster, "modifier_skill_ship_yiqidangqian", nil )
        --就给马岱加上一个 修饰器，名字是Modifier_skill_ship_NAME_for_zhaoyun
    end

end

--[[Author: Pizzalol
	Date: 25.03.2015.
	Creates the stasis trap unit and initializes all the required functions of the unit]]
function StasisTrapPlant( keys )
	local caster = keys.caster
	local target_point = keys.target_points[1]
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	-- Modifiers
	local modifier_tracker = keys.modifier_tracker
	local modifier_stasis_trap_invisibility = keys.modifier_stasis_trap_invisibility
	local modifier_stasis_trap = keys.modifier_stasis_trap

	-- Ability variables
	local activation_time = ability:GetLevelSpecialValueFor("activation_time", ability_level) 
	local fade_time = ability:GetLevelSpecialValueFor("fade_time", ability_level) 
	local duration = ability:GetLevelSpecialValueFor("duration", ability_level) 

	-- Create the stasis trap and apply the stasis trap modifier and duration
	local stasis_trap = CreateUnitByName("npc_dota_techies_stasis_trap", target_point, false, nil, nil, caster:GetTeamNumber())
	stasis_trap:AddNewModifier(caster, ability, "modifier_kill", {Duration = duration})
	ability:ApplyDataDrivenModifier(caster, stasis_trap, modifier_stasis_trap, {})

	-- Apply the unit tracker after the activation time
	Timers:CreateTimer(activation_time, function()
		ability:ApplyDataDrivenModifier(caster, stasis_trap, modifier_tracker, {})
	end)

	-- Apply the invisibility after the fade time
	Timers:CreateTimer(fade_time, function()
		ability:ApplyDataDrivenModifier(caster, stasis_trap, modifier_stasis_trap_invisibility, {})
	end)
end

--[[Author: Pizzalol
	Date: 25.03.2015.
	Tracks if there are any enemy units within the trigger radius]]
function StasisTrapTracker( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	-- Ability variables
	local activation_radius = ability:GetLevelSpecialValueFor("activation_radius", ability_level) 
	local explode_delay = ability:GetLevelSpecialValueFor("explode_delay", ability_level)
	local vision_radius = ability:GetLevelSpecialValueFor("vision_radius", ability_level) 
	local vision_duration = ability:GetLevelSpecialValueFor("vision_duration", ability_level)
	local modifier_trigger = keys.modifier_trigger

	-- Target variables
	local target_team = DOTA_UNIT_TARGET_TEAM_ENEMY
	local target_types = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
	local target_flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES

	-- Find the valid units in the trigger radius
	local units = FindUnitsInRadius(target:GetTeamNumber(), target:GetAbsOrigin(), nil, activation_radius, target_team, target_types, target_flags, FIND_CLOSEST, false) 

	-- If there is a valid unit in range then explode the mine
	if #units > 0 then
		Timers:CreateTimer(explode_delay, function()
			if target:IsAlive() then
				ability:ApplyDataDrivenModifier(caster, target, modifier_trigger, {})

				-- Create vision upon exploding
				ability:CreateVisibilityNode(target:GetAbsOrigin(), vision_radius, vision_duration)
			end
		end)
	end
end

--[[Author: Pizzalol
	Date: 25.03.2015.
	Upon a Stasis Trap activation, remove all traps within the activation radius]]
function StasisTrapRemove( keys )
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	-- Ability variables
	local activation_radius = ability:GetLevelSpecialValueFor("activation_radius", ability_level)
	local unit_name = target:GetUnitName()

	-- Target variables
	local target_team = DOTA_UNIT_TARGET_TEAM_FRIENDLY
	local target_types = DOTA_UNIT_TARGET_ALL
	local target_flags = DOTA_UNIT_TARGET_FLAG_NONE

	local units = FindUnitsInRadius(target:GetTeamNumber(), target:GetAbsOrigin(), nil, activation_radius, target_team, target_types, target_flags, FIND_CLOSEST, false)

	for _,unit in ipairs(units) do
		if unit:GetUnitName() == unit_name then
			unit:ForceKill(true) 
		end
	end
end

function fashudidang(keys)
    local ability = keys.ability    --技能谦逊
    local caster  = keys.caster     --施法者，这里是陆逊
	local modName = "modifier_item_sphere_target"
	if not caster:HasModifier( modName ) then  --如果没有这个修饰器，则添加一个修饰器
		
		caster:AddNewModifier( caster, ability , modName, nil  )
	end
	
end