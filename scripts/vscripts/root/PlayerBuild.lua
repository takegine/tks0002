skill_player_queue = skill_player_queue or {}
--------------------------------------------------------------------------------

function skill_player_queue:OnSpellStart(  )
    local caster = self:GetCaster()
    local queue  = caster:GetItemInSlot(5)
    local level  = Clamp( self:GetLevel() + 1, 1, 10)
    local cost   = self:GetSpecialValueFor("basecost")
    local player = caster:GetPlayerOwnerID()

    if self:GetLevel() >= level then 
        return
    elseif caster:GetGold() < cost then 
        return
    elseif not queue then 
        return
    else
        queue:lvlup(level)
        self:SetLevel(level)
        caster:SpendGold( cost, DOTA_ModifyGold_PurchaseConsumable)
        CustomNetTables:OverData( "player_info", player, "quelvl" , level )
    end
end



skill_player_onback = skill_player_onback or {}
--------------------------------------------------------------------------------

function skill_player_onback:CastFilterResultTarget(  hTarget ) return ChecktTarget( { hTarget = hTarget, team = self:GetCaster():GetTeamNumber()} ) end
function skill_player_onback:GetCustomCastErrorTarget(hTarget ) return ErrorTarget( hTarget ) end
function skill_player_onback:OnSpellStart(  )
    print("PlayerBuild:OnBack")
    
    local target   = self:GetCursorTarget()
    local caster   = self:GetCaster()
   -- local onback   = false
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
        target:AddNewModifier(nil, nil, "modifier_phased", {duration=0.1})
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
end

    
skill_player_onsell = skill_player_onsell or {}
--------------------------------------------------------------------------------


function skill_player_onsell:CastFilterResultTarget(  hTarget ) return ChecktTarget( { hTarget = hTarget, team = self:GetCaster():GetTeamNumber()} ) end
function skill_player_onsell:GetCustomCastErrorTarget(hTarget ) return ErrorTarget( hTarget ) end
function skill_player_onsell:OnSpellStart()
    local target   = self:GetCursorTarget()
    local caster   = self:GetCaster()
    local plid     = caster:GetPlayerOwnerID()

    target:ForceKill(true)
    PlayerResource:Pay( plid, -100 ) 
    
end


skill_player_sell = skill_player_sell or {}
--------------------------------------------------------------------------------

function skill_player_sell:OnSpellStart()
    local target   = self:GetCursorTarget()
    local caster   = self:GetCaster()
    local plid     = caster:GetPlayerOwnerID()

    target:ForceKill(true)
    
end

skill_player_lvlup = skill_player_lvlup or {}
--------------------------------------------------------------------------------

function skill_player_lvlup:CastFilterResultTarget(  hTarget ) return ChecktTarget( { hTarget = hTarget, team = self:GetCaster():GetTeamNumber()} ) end
function skill_player_lvlup:GetCustomCastErrorTarget( hTarget ) return ErrorTarget( hTarget ) end
function skill_player_lvlup:OnSpellStart()
    local target   = self:GetCursorTarget()
    local caster   = self:GetCaster()
    local plid     = caster:GetPlayerOwnerID()
    local hero     = PlayerResource:GetSelectedHeroEntity(plid)
    local findcost = 100 --减钱

    print(PlayerResource:NumTeamPlayers())

    if not PlayerResource:Pay( plid, findcost ) then GetNewHero:UptoDJT(plid,"shopUp","poorguy") 
        else
            target:CheckLevel() end
    -- if  hero:GetGold() > findcost then
    --     hero:SetGold(hero:GetGold()-findcost,false)
        
    -- else
    --     print("poor guy")
    -- end
end


--------------------------------------------------------------------------------
function ChecktTarget(  data )
    hTarget = data.hTarget
    team    = data.team
    if hTarget:GetName()==SET_FORCE_HERO then return UF_FAIL_COURIER end
    if CustomNetTables:GetTableValue( "game_stat", "game_round_stat")["1"]~=0 then return UF_FAIL_CUSTOM end
    return UnitFilter( hTarget, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, team )
end

function ErrorTarget( hTarget )
    local stat = CustomNetTables:GetTableValue( "game_stat", "game_round_stat")["1"]

    --if self:GetCaster() == hTarget then return "#dota_hud_error_cant_cast_on_self" 
    if stat==1 then return "#OnGameRoundChange" end
    if stat==2 then return "#OnGameInProgress"  end
    -- if hTarget:IsAncient() then
    --     return "#dota_hud_error_cant_cast_on_ancient"
    -- end

    -- if hTarget:IsCreep() and ( not self:GetCaster():HasScepter() ) then
    --     return "#dota_hud_error_cant_cast_on_creep"
    --end
    return ""
end






