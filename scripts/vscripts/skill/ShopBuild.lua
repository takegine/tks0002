function PopulationUp( data )
	print("ShopBuild:PopulationUp")
	local caster   = data.caster
	local ability  = data.ability
	local plid = caster:GetPlayerID()
	local tPop = CustomNetTables:GetTableValue( "Hero_Population", tostring(plid))
	
    tPop['popMax'] = tPop['popMax'] + 1

	CustomNetTables:SetTableValue( "Hero_Population", tostring(plid),tPop)

	print(caster:GetName(),ability:GetAbilityName(),caster:HasItemInInventory( ability:GetAbilityName()))
	local item = caster:FindItemInInventory(ability:GetAbilityName())
	caster:RemoveItem(item)
end