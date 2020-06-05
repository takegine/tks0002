function Spawn( entityKeyValues )
	if not IsServer()    then return end
	if thisEntity == nil then return end
	--thisEntity:GetAbilityCount()

	skill01 = thisEntity:FindAbilityByName( "skill_hero_fangquan" )--thisEntity:GetAbilityByIndex(0)
	thisEntity:SetContextThink( "PhoenixThink", PhoenixThink, 1 )
end

function PhoenixThink()
	if ( not thisEntity:IsAlive() ) then	 return -1 end
	
	if GameRules:IsGamePaused() == true then return  1 end
	
	if skill01 ~= nil and skill01:IsFullyCastable() then 
		thisEntity:CastAbilityNoTarget( skill01, thisEntity:GetPlayerOwnerID() )
		return 0.5
	end

	return 0.5
end