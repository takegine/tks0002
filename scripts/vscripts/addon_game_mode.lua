-- Generated from template
SET_FORCE_HERO = "npc_dota_hero_phoenix"

if CAddonTemplateGameMode == nil then
	CAddonTemplateGameMode = class({})
end

function Precache( context )
	--[[
		Precache things we know we'll use.  Possible file types include (but not limited to):
			PrecacheResource( "model", "*.vmdl", context )
			PrecacheResource( "soundfile", "*.vsndevts", context )
			PrecacheResource( "particle", "*.vpcf", context )
			PrecacheResource( "particle_folder", "particles/folder", context )
	]]
end

-- Create the game mode when we activate
function Activate()
	GameRules.AddonTemplate = CAddonTemplateGameMode()
	GameRules.AddonTemplate:InitGameMode()
end

function CAddonTemplateGameMode:InitGameMode()
	print( "Template addon is loaded." )
	--GameRules:GetGameModeEntity():SetThink( "OnThink", self, "GlobalThink", 2 )
	GameRules:SetPreGameTime(1)
    GameRules:SetStartingGold(9999)
    GameRules:SetStrategyTime( 0 )
    GameRules:SetHeroSelectionTime(0.0)
    GameRules:SetHeroSelectPenaltyTime(0)
    GameRules:SetUseUniversalShopMode(true)
    GameRules:SetHeroRespawnEnabled( false )
    GameRules:SetCustomGameSetupAutoLaunchDelay(0)
    --GameRules:EnableCustomGameSetupAutoLaunch(true)
    GameRules:LockCustomGameSetupTeamAssignment(true)
    GameRules:GetGameModeEntity():SetLoseGoldOnDeath(false)--死亡后自己不扣钱
    GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_GOODGUYS, 0 )
    GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_BADGUYS, 0 )
    GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_CUSTOM_1, 1 )
    GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_CUSTOM_2, 1 )
    GameRules:GetGameModeEntity():SetTopBarTeamValuesVisible( true )
    GameRules:GetGameModeEntity():SetFogOfWarDisabled( true )
    GameRules:GetGameModeEntity():SetCustomGameForceHero(SET_FORCE_HERO)
    --GameRules:GetGameModeEntity():SetCameraDistanceOverride( 1500 )
    GameRules:GetGameModeEntity():SetHUDVisible(1,true)   --设置HUD元素，1元素可见
    GameRules:GetGameModeEntity():SetHUDVisible(2,true)  --设置HUD元素，4元素不可见
    GameRules:GetGameModeEntity():SetHUDVisible(3,true)  --设置HUD元素，9元素可见
    GameRules:GetGameModeEntity():SetHUDVisible(4,true)   --设置HUD元素，1元素可见
    GameRules:GetGameModeEntity():SetHUDVisible(5,true)   --设置HUD元素，1元素可见
    GameRules:GetGameModeEntity():SetCustomAttributeDerivedStatValue( DOTA_ATTRIBUTE_STRENGTH_DAMAGE, 5 )
    GameRules:GetGameModeEntity():SetCustomAttributeDerivedStatValue( DOTA_ATTRIBUTE_STRENGTH_HP, 100 )
    GameRules:GetGameModeEntity():SetCustomAttributeDerivedStatValue( DOTA_ATTRIBUTE_STRENGTH_HP_REGEN, 0.03 )
    GameRules:GetGameModeEntity():SetCustomAttributeDerivedStatValue( DOTA_ATTRIBUTE_AGILITY_DAMAGE, 5 )
    GameRules:GetGameModeEntity():SetCustomAttributeDerivedStatValue( DOTA_ATTRIBUTE_AGILITY_ARMOR, 0.25 )
    GameRules:GetGameModeEntity():SetCustomAttributeDerivedStatValue( DOTA_ATTRIBUTE_AGILITY_ATTACK_SPEED, 0.01 )
    GameRules:GetGameModeEntity():SetCustomAttributeDerivedStatValue( DOTA_ATTRIBUTE_INTELLIGENCE_DAMAGE, 5 )
    GameRules:GetGameModeEntity():SetCustomAttributeDerivedStatValue( DOTA_ATTRIBUTE_INTELLIGENCE_MANA, 0.25 )
    GameRules:GetGameModeEntity():SetCustomAttributeDerivedStatValue( DOTA_ATTRIBUTE_INTELLIGENCE_MANA_REGEN, 0.01 )
    GameRules:GetGameModeEntity():SetDamageFilter( Dynamic_Wrap( self, "DamageFilter" ), self )
    ListenToGameEvent("entity_hurt",Dynamic_Wrap(self, "entity_hurt"), self)
    ListenToGameEvent("npc_spawned",Dynamic_Wrap(self, "npc_spawned"), self)
    ListenToGameEvent("player_chat",Dynamic_Wrap(self, "player_chat"), self)

    CustomGameEventManager:RegisterListener( "createnewherotest", Dynamic_Wrap(self,"createnewherotest") )
    CustomGameEventManager:RegisterListener("refreshlist",Dynamic_Wrap(self, 'refreshlist'))
end

-- Evaluate the state of the game
function CAddonTemplateGameMode:OnThink() return 1 end

function CAddonTemplateGameMode:createnewherotest( data )
    local hero    = PlayerResource:GetSelectedHeroEntity(data.PlayerID)
    local ablelist= LoadKeyValues('scripts/npc/npc_skill_custom.txt')
    local teamid  = 3
    if data.good then teamid = PlayerResource:GetCustomTeamAssignment(data.PlayerID) end

    CreateUnitByNameAsync( data.way, Entities:FindByName(nil,"creep_birth_"..(teamid-3)):GetAbsOrigin(), true, hero, hero, teamid,  function( h )
        h:SetControllableByPlayer( data.PlayerID, false )
        h:Hold()
        h:SetOwner(hero)
        h:SetIdleAcquire( false )
        h:SetAcquisitionRange( 0 )
        if ablelist[data.way] then
            for c,abi in pairs(ablelist[data.way]) do
                h:AddAbility(abi)
                if h:HasAbility(abi) then h:FindAbilityByName(abi):SetLevel(1) end
            end
        end
    end )
end

function CAddonTemplateGameMode:refreshlist()
    local relist = {}
    local herolist= LoadKeyValues('scripts/npc/npc_heroes_custom.txt')
    local ablelist= LoadKeyValues('scripts/npc/npc_skill_custom.txt')
    for name,info in pairs(herolist)do
        if info ~= 1 and name ~= SET_FORCE_HERO then
            relist['name']=name
            relist['hero']=info.override_hero

            if ablelist[info.override_hero] then
                relist['able']={}
                for k,v in pairs(ablelist[info.override_hero]) do
                    relist['able'][k]=v
                end
            end

        CustomGameEventManager:Send_ServerToAllClients('hero_info', relist)
        end
    end
end

function CAddonTemplateGameMode:entity_hurt(keys)
    local killedUnit = EntIndexToHScript( keys.entindex_killed   )
    local killerUnit = EntIndexToHScript( keys.entindex_attacker )
    --damagebits
end

function CAddonTemplateGameMode:DamageFilter(filterTable)
    local damage=filterTable.damage
    local killedUnit = EntIndexToHScript( filterTable.entindex_victim_const   )
    local killerUnit = EntIndexToHScript( filterTable.entindex_attacker_const )
    local armor = killedUnit:GetPhysicalArmorValue(false)
    local oldkang  = 1-52/48*armor/(18.75+armor)
    local newkang  = 1-armor/(100+armor)
    filterTable.damage=filterTable.damage/oldkang*newkang
    return true
end

function CAddonTemplateGameMode:npc_spawned(keys )
    local  npc = EntIndexToHScript(keys.entindex)
    if npc:GetName()== "npc_dota_fort"
    or npc:GetName()== "npc_dota_building"
    or npc.bFirstSpawned then
        return
    end

    npc.bFirstSpawned = true

    if npc:GetName()==SET_FORCE_HERO then
        npc.ship={}
        CreateUnitByName( "npc_dota_hero_target_dummy", RandomVector(20), true, nil, nil, 7 )
    end
    if npc:IsHero() then
        for i=0,15 do if npc:GetAbilityByIndex(i) then npc:GetAbilityByIndex(i):SetLevel(1) end end
    end
end

function CAddonTemplateGameMode:player_chat(keys )
    -- playerid	0
    -- game_event_listener	184549379
    -- game_event_name	player_chat
    -- text	ç¾ç»
    -- teamonly	1
    -- userid	1
    -- splitscreenplayer	-1
    local hero = PlayerResource:GetSelectedHeroEntity(keys.playerid)
    local list = {}
    local count = 1
    for k in string.gmatch(keys.text, "%a+") do
        list[count]=k
        count=count+1
    end

    if list[1]=="myid" then
        print(
            "your SteamID x64:",
            PlayerResource:GetSteamID(0),
            "\n",
            "your SteamID x32:",
            PlayerResource:GetSteamAccountID(0)
        )
    elseif list[1]=="ship" and list[2] then
        hero.ship[list[2]]= list[3]=="true" or nil
        GameRules:SendCustomMessage( "羁绊名："..list[2].." ，已设置为"..(list[3]=="true" and "有" or "失").."效", hero:GetTeamNumber(), 1)
    elseif list[1]=="hero" and list[2] then
        
        local reList = Entities:FindAllInSphere(Vector(0,0,0),9999)
        
        for k = #reList, 1, -1 do  
            local u= reList[k] 

            if not u.bFirstSpawned
            or not u:IsAlive()
            or u:GetName() == SET_FORCE_HERO 
            or u:GetName() == "npc_dota_courier" 
            then table.remove( reList , k )            
            end
        end

        if list[2]=="refresh" then
            table.foreach(reList,function(_,u)
                for i=0,10 do
                    local abi =u:GetAbilityByIndex(i)
                    if abi and abi.needwaveup then
                        abi:needwaveup()
                    end
                end
            end)
        elseif list[2]=="lvlup" then
            table.foreach(reList,function(_,u)
                local lvl = u:GetLevel()+1

                while( u:GetLevel() < lvl ) do
                    if   u:IsHero() then
                            u:HeroLevelUp( false )
                    else u:CreatureLevelUp( 1 )
                    end
                end
                for i=0,15 do
                    if  u:GetAbilityByIndex(i) then 
                        u:GetAbilityByIndex(i):SetLevel(lvl) 
                    end
                end
            end)
        end
    end
end