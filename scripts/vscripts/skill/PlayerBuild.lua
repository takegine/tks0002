function OnBack( data )
    print("PlayerBuild:OnBack")
    
    local target   = data.target
    local caster   = data.caster

    if target == caster then return end
    if not YOUR_IN_TEST and CustomNetTables:GetTableValue( "game_stat", "game_round_stat")["1"]~=0 then return UF_FAIL_CUSTOM end

    local onback   = false
    local iTeam    = target:GetTeamNumber()-5
    local abiName  = "skill_player_bench"
    local tPop     = CustomNetTables:GetTableValue( "Hero_Population", tostring(target:GetPlayerOwnerID())) 
    --item:SetPurchaseTime(0)
    --item:SetPurchaser( caster )

    if  target:HasAbility(abiName) then
        target.bench = nil
        target:RemoveAbility(abiName)
        target:RemoveModifierByName("modifier_"..abiName)
        target:SetOrigin(Entities:FindByName(nil,"creep_birth_"..iTeam.."_2"):GetAbsOrigin()+ Vector (RandomFloat(-300, 300),RandomFloat(-100, 200),0) )
        tPop.popNow = tPop.popNow + target.popuse  
        CustomNetTables:SetTableValue( "Hero_Population", tostring(target:GetPlayerOwnerID()),tPop) 
        
        return
    end

    --[[
    --在记录表中删掉这个单位
    if _G.buildpostab[iTeam] then
        table.foreach(_G.buildpostab[iTeam],function(k,v) 
            if v.unit==target:GetUnitName() and v.origin==target:GetOrigin() then v=nil end 
        end)
    end
    ]]
        
    local x = caster.Ticket and 6 or 5
    for i = 1 , x do
        local posempty   = true
        local itemPos    = Entities:FindByName( nil, "dianjiangtai_"..iTeam.."_"..i):GetAbsOrigin()
        local isemptytab = Entities:FindAllInSphere(itemPos,50)
        
        for _,v in pairs(isemptytab) do
            if v:IsAlive() then posempty=false break end
        end
        if  posempty==true then
            target.bench = true
            target:AddNewModifier(nil, nil, "modifier_phased", {duration=0.1})
            target:AddAbility(abiName)
            target:FindAbilityByName(abiName):SetLevel(1)
            target:SetOrigin(itemPos)
            tPop.popNow = tPop.popNow - target.popuse  
            CustomNetTables:SetTableValue( "Hero_Population", tostring(target:GetPlayerOwnerID()),tPop) 
            return
        end
    end

    OnSell( data )
end

function OnSell( data )
    local target   = data.target
    local caster   = data.caster
    if target == caster then return end
    if not YOUR_IN_TEST and CustomNetTables:GetTableValue( "game_stat", "game_round_stat")["1"]~=0 then return UF_FAIL_CUSTOM end

    local onsell   = false
    local heroName = target:GetUnitName()
    local itemName = string.gsub(heroName,"npc","item")
    
end

function LevelUp( data )
    local target   = data.target
    local caster   = data.caster
    if target == caster then print("is wrong") return end
    if not YOUR_IN_TEST and CustomNetTables:GetTableValue( "game_stat", "game_round_stat")["1"]~=0 then return UF_FAIL_CUSTOM end


    local plid     = caster:GetPlayerOwnerID()
    local hero     = PlayerResource:GetSelectedHeroEntity(plid)
    local findcost = 100 --减钱

    print(PlayerResource:NumTeamPlayers())

    if  hero:GetGold() > findcost then
        hero:SetGold(hero:GetGold()-findcost,false)
        if   target:IsHero() then
             target:HeroLevelUp(false)
        else target:CreatureLevelUp(1)
        end
        for i=0,10 do 
            if  target:GetAbilityByIndex(i) then 
                target:GetAbilityByIndex(i):SetLevel(target:GetLevel()) 
            end 
        end 
    else
        print("poor guy")
    end
end