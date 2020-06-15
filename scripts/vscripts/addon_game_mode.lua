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
    GameRules:GetGameModeEntity():SetDamageFilter( Dynamic_Wrap( CAddonTemplateGameMode, "DamageFilter" ), self )
    ListenToGameEvent("game_rules_state_change",Dynamic_Wrap(CAddonTemplateGameMode,"OnGameRulesStateChange"), self)
    ListenToGameEvent("entity_hurt",            Dynamic_Wrap(CAddonTemplateGameMode, "entity_hurt"), self)
    
    CustomGameEventManager:RegisterListener( "createnewherotest", Dynamic_Wrap(self,"createnewherotest") )
    CustomGameEventManager:RegisterListener("refreshlist",Dynamic_Wrap(self, 'refreshlist'))
end

function CAddonTemplateGameMode:OnGameRulesStateChange( keys )
        print ("print  OnGameRulesStateChange is running.")
               DeepPrintTable(keys)    --详细打印传递进来的表
        local newState = GameRules:State_Get() --获取当前游戏阶段

        if newState == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
                print("Player begin select team") --玩家处于选择队伍
                
        elseif newState == DOTA_GAMERULES_STATE_HERO_SELECTION then    
        		print("Player begin select hero")  --玩家处于选择英雄界面


        elseif newState == DOTA_GAMERULES_STATE_PRE_GAME then
                print("Player in befor game")  --进游戏直到倒数结束
                --CustomUI:DynamicHud_Create(-1,"psd","file://{resources}/layout/custom_game/uiscreen.xml",nil)--创建选择难度面板

                --CreateHeroForPlayer(string unitName, handle player)

                --CreateUnitByName(npc_creature_0,Entities:FindByName(nil,"playerlocal_1"):GetOrigin(),false,nil,nil,DOTA_TEAM_CUSTOM_1)

        elseif newState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
                print("Player game begin")  --玩家开始游戏

                print("Player---- OnGameInProgress endding")  --玩家开始游戏

                CAddonTemplateGameMode:refreshlist()

        elseif newState == DOTA_GAMERULES_STATE_STRATEGY_TIME then
        	for i=0, PlayerResource:GetPlayerCount()-1 do
                    if  PlayerResource:HasSelectedHero(i) == false then
                    	
                        PlayerResource:GetPlayer(i):MakeRandomHeroSelection()
                    end
            end

        elseif newState == DOTA_GAMERULES_STATE_POST_GAME then
                print("Player are show case")  --游戏结束
        end
end



-- Evaluate the state of the game
function CAddonTemplateGameMode:OnThink() return 1 end

function CAddonTemplateGameMode:createnewherotest( data ) 
    local hero   = PlayerResource:GetSelectedHeroEntity(data.PlayerID)
    local teamid = 3
    if data.good then teamid = PlayerResource:GetCustomTeamAssignment(data.PlayerID) end 
    CreateUnitByNameAsync( data.way, Entities:FindByName(nil,"creep_birth_"..(teamid-3)):GetAbsOrigin(), true, nil, nil, teamid,  function( v ) v:SetControllableByPlayer( data.PlayerID, false ) v:Hold() v:SetIdleAcquire( false ) v:SetAcquisitionRange( 0 ) end )  
end

function CAddonTemplateGameMode:refreshlist()
        local relist = {}
        local herolist= LoadKeyValues('scripts/npc/npc_heroes_custom.txt')
        local ablelist= LoadKeyValues('scripts/npc/npc_skill_custom.txt')
        for name,info in pairs(herolist)do 
                if info ~= 1 and name ~= SET_FORCE_HERO then 
                        relist['name']=name
                        relist['hero']=info.override_hero

                        if ablelist[name] then
                                relist['able']={}
                                for k,v in pairs(ablelist[name]) do
                                        relist['able'][k]=v
                                end
                        end
                end
        end

        
        CustomGameEventManager:Send_ServerToAllClients('hero_info', relist) 
end

function CAddonTemplateGameMode:entity_hurt(keys)
        
        print("entity_hurt")
        DeepPrintTable(keys)

        local killedUnit = EntIndexToHScript( keys.entindex_killed   ) 
        local killerUnit = EntIndexToHScript( keys.entindex_attacker ) 
        --damagebits
end

function CAddonTemplateGameMode:DamageFilter(filterTable)
        print("DamageFilter")
        DeepPrintTable(filterTable)
        local damage=filterTable.damage
        local killedUnit = EntIndexToHScript( filterTable.entindex_victim_const   ) 
        local killerUnit = EntIndexToHScript( filterTable.entindex_attacker_const ) 
        local armor = killedUnit:GetPhysicalArmorValue(false)
        local oldkang  = 1-52/48*armor/(18.75+armor)
        local newkang  = 1-armor/(100+armor)
        print(damage,oldkang)
        
        filterTable.damage=filterTable.damage/oldkang*newkang
        print(filterTable.damage,newkang)

        return true
end