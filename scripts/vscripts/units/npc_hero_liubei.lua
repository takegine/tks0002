function Spawn( entityKeyValues )
	if not IsServer()    then return end--如果不是服务器发出的指令，就结束
	if thisEntity == nil then return end--如果这个单位被删除了，就结束
	--thisEntity:GetAbilityCount()

	skill01 = thisEntity:FindAbilityByName( "skill_hero_rende" )--thisEntity:GetAbilityByIndex(0)  --找到刘备的名为 仁德 的技能
	thisEntity:SetContextThink( "PhoenixThink", PhoenixThink, 1 )--开始一个计时器
end

i = 1

function PhoenixThink()
	if ( not thisEntity:IsAlive() ) then	 return -1 end
	
	if GameRules:IsGamePaused() == true then return  1 end--如果游戏被暂停，就只循环，不运行后面的
    
    --if thisEntity:GetAcquisitionRange() < 2000 then	return 0.5	end
    
	local tEnemy  = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 999, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
	local tFriend = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 999, DOTA_UNIT_TARGET_TEAM_FRIENDLY,DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_FARTHEST, false )
	
	--如果刘备有仁德，仁德不在冷却中，附近友方单位不为空
	if skill01 ~= nil and skill01:IsFullyCastable() and tFriend[1] ~= nil then 

		--获取施法范围内的友军
		local tTar = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, skill01:GetLevelSpecialValueFor("radius",0), DOTA_UNIT_TARGET_TEAM_FRIENDLY,DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_FARTHEST, false )
		for k,v in pairs(tTar) do--从远到近检查
			--print("rende_liubei",k,v)
			--如果不是主公，不是刘备自己，生命值小于最大生命值
			if  v:GetUnitName() ~= SET_FORCE_HERO and v ~= thisEntity and v:GetMaxHealth() - v:GetHealth() > 0 then--
				--print(v:GetMaxHealth(),v:GetHealth(),v:GetAbsOrigin())
				--print(k,v,v:GetUnitName())
				return spirits(v:GetAbsOrigin())--给他丢个仁德
			end
		end
	end
	return 0.5
end



function spirits( target )
	thisEntity:CastAbilityOnPosition(target, skill01, thisEntity:GetPlayerOwnerID())
	return 0.5
end
-----------------------------------------下面没用到-------------------------------------------------------------

function spirits2(target)

	ExecuteOrderFromTable({
		UnitIndex    = thisEntity:entindex(),
		OrderType    = DOTA_UNIT_ORDER_CAST_POSITION,
		AbilityIndex = skill01:entindex(),
		IndexPosition = target,
		Queue = false,
	})
	
	return 0.5
end

function launch( enemy )

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		AbilityIndex = skill02:entindex(),
		TargetIndex  = enemy:entindex(),
		Queue = false,
	})
    
    if i == 1 then
        skill02:StartCooldown(3)
    end
    
    return 0.1
end

function ray(enemy)
	
    ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		AbilityIndex = ship01:entindex(),
		Position = enemy:GetOrigin(),
		Queue = false,
	})
	
	return 1
end