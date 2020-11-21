
function LinkLuaS()
    local typetab = {"none","tree","fire","electrical","water","land","god"}
    local modload = "buff/BaseType.lua"
    for _,v in pairs(typetab) do
        print("modifier_attack_"..v)
        LinkLuaModifier( "modifier_attack_"..v, modload, 0 )
        LinkLuaModifier( "modifier_defend_"..v, modload, 0 )
    end
        LinkLuaModifier( "modifier_defend_big", modload, 0 )
        LinkLuaModifier( "modifier_custom_shield", modload, 0 )
        LinkLuaModifier( "modifier_abi_vam", "buff/ability_vampire", 0 )
end


function CCustomNetTableManager:OverData( ... )
    local name, id , key ,value =...
    local nettable = self:GetTableValue( name, tostring(id))
    nettable[key] = value
    self:SetTableValue( name, tostring(id), nettable)
end

function CDOTA_BaseNPC:CheckLevel(lvl)
    
    lvl = lvl or self:GetLevel()+1

    while( self:GetLevel() < lvl ) do
            if   self:IsHero() then
                 self:HeroLevelUp( false )
            else self:CreatureLevelUp( 1 )
            end
    end
    
    for i=0,15 do 
        if  self:GetAbilityByIndex(i) then 
            self:GetAbilityByIndex(i):SetLevel(lvl) 
        end 
    end
end

function CCustomNetTableManager:GetStage( ... )
    return "GAME_STAT_FINGHT"
end

function CDOTA_BaseNPC:XinShi()
    local team = self:GetTeamNumber()
    if Clamp(team,6,13) == team then
        local id   = PlayerResource:GetNthPlayerIDOnTeam(team,1)
        local hero = PlayerResource:GetSelectedHeroEntity(id)
        return hero
    else
        return {
            ship={},
            GetTeamNumber=function(self) return 3 end,
        }
    end
end

function createnewherotest( self,data )
    local owner   = PlayerResource:GetSelectedHeroEntity(data.PlayerID)
    local hteam   = PlayerResource:GetCustomTeamAssignment(data.PlayerID)
    local teamid  = data.good and hteam or 3
    local crePos  = Entities:FindByName(nil,"creep_birth_"..(hteam-5).."_"..(teamid-3)):GetAbsOrigin() 

    v = CreateUnitByName( data.way, crePos, true,nil,nil,teamid)
    v:Hold()
    v:SetIdleAcquire( false )
    v:SetAcquisitionRange( 0 )
    v:CheckLevel(1)
    v.battleinfo = {}
    -- v:AddNewModifier(nil, nil, "modifier_player_lock", nil)
    v:AddNewModifier(nil, nil, "modifier_phased", {duration=0.1})
    -- v:BattleThink()
    v:SetControllableByPlayer( owner:GetPlayerOwnerID(), true )

    if not data.good then
        v:SetInitialGoalEntity( 路线 )
        v.enemy=true
        -- table.insert(UNITS_LIST.enemy , v)
    else
        v:SetUnitCanRespawn(false)
        v:SetOwner(hero)
        -- table.insert(UNITS_LIST.defend , v)
        -- v:FindAbilityByName('skill_player_price'):CastAbility()
    end
end

function refreshlist()
    for k,v in pairs(LoadKeyValues('scripts/npc/npc_info_custom.txt'))
        do CustomNetTables:SetTableValue( "hero_info", k, v )
    end
end

function CDOTA_BaseNPC:IsOpposingSelf()
    return self:GetTeamNumber() == 3
end
