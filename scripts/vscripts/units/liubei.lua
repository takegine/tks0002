function Spawn( entityKeyValues )
	if not IsServer()
	or thisEntity == nil 
	then
		return 
	end
	local thisname = thisEntity:GetUnitName()
	local thisinfo = thisEntity:IsHero() and tkUnitInfo.hero[thisname] or tkUnitInfo.unit[thisname]
	
	skill01 = thisEntity:FindAbilityByName( thisinfo.able[1] )
	skill02 = thisEntity:FindAbilityByName( thisinfo.able[2] )
	skill03 = thisEntity:FindAbilityByName( thisinfo.able[3] )
	skill04 = thisEntity:FindAbilityByName( thisinfo.able[4] )

	thisEntity:SetContextThink( "PhoenixThink", PhoenixThink, 1 )--开始一个计时器

end

function PhoenixThink()
	if ( not thisEntity:IsAlive() ) then	 return -1 end

	local stage =CustomNetTables:GetStage( "stage" )
	if stage ~= "GAME_STAT_FINGHT" 
	or GameRules:IsGamePaused()
	then
		return 1
	end

    --if thisEntity:GetAcquisitionRange() < 2000 then	return 0.5	end
    
	local tEnemy  = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 999, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
	local tFriend = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 999, DOTA_UNIT_TARGET_TEAM_FRIENDLY,DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_FARTHEST, false )
	
	if  skill01 
	and skill01:IsFullyCastable()
	and tFriend[1]
	then 

		local tTar = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, skill01:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_FRIENDLY,DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_FARTHEST, false )
		for k,v in pairs(tTar) do
			if  v:GetUnitName() ~= SET_FORCE_HERO
			and v ~= thisEntity
			and v:GetMaxHealth() - v:GetHealth() > 0
			then
				thisEntity:CastAbilityOnPosition(v:GetAbsOrigin(), skill01, thisEntity:GetPlayerOwnerID())
				return 0.5
			end
		end
	end

	return 0.5
end


-----------------------------------------下面没用到-------------------------------------------------------------

function abi1(target)

	ExecuteOrderFromTable({
		UnitIndex    = thisEntity:entindex(),
		OrderType    = DOTA_UNIT_ORDER_CAST_POSITION,
		AbilityIndex = skill01:entindex(),
		IndexPosition = target,
		Queue = false,
	})
	
	return 0.5
end

function abi2( enemy )

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

function abi3(enemy)
	
    ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		AbilityIndex = ship01:entindex(),
		Position = enemy:GetOrigin(),
		Queue = false,
	})
	
	return 1
end