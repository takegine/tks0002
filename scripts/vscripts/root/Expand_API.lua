
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


function createnewherotest( self,data )
    local hero    = PlayerResource:GetSelectedHeroEntity(data.PlayerID)
    local ablelist= LoadKeyValues('scripts/npc/npc_skill_custom.txt')
    local hteam   = PlayerResource:GetCustomTeamAssignment(data.PlayerID)
    local teamid  = data.good and hteam or 3
    local crePos  = Entities:FindByName(nil,"creep_birth_"..(hteam-5).."_"..(teamid-3)):GetAbsOrigin() 

    CreateUnitByNameAsync( data.way, crePos, true, hero, hero, teamid,  function( h )
        h:SetControllableByPlayer( data.PlayerID, false )
        h:Hold()
        h:SetOwner(hero)
        h:SetIdleAcquire( false )
        h:SetAcquisitionRange( 0 )
        if ablelist[data.way] then
            for c,abi in pairs( ablelist[data.way]) do
                if  h:HasAbility(abi) then 
                    h:FindAbilityByName(abi):SetLevel(1)
                end
            end
        end
    end )
end

function refreshlist()
    for k,v in pairs(LoadKeyValues('scripts/npc/npc_info_custom.txt'))
        do CustomNetTables:SetTableValue( "hero_info", k, v )
    end
end
