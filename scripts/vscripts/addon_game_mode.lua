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
    GameRules:EnableCustomGameSetupAutoLaunch(true)
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
    ListenToGameEvent("game_rules_state_change",Dynamic_Wrap(CAddonTemplateGameMode,"OnGameRulesStateChange"), self)
    
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
                
                --ShuaGuai("npc_dota_creature_gnoll_assassin",1)--测试刷怪
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

function ShuaGuai( CreateName,number)
        for i=1,number do
                --获取ShuaGuai_1这个实体
                local ShuaGuai_entity = Entities:FindByName(nil,"creep_birth_0")
                --创建单位
                local ShuaGuai = CreateUnitByName(CreateName,ShuaGuai_entity:GetOrigin(),false,nil,nil,DOTA_TEAM_NEUTRALS)
                --添加相位移动的modifier，持续时间0.1秒
                --当相位移动的modifier消失，系统会自动计算碰撞，这样就避免了卡位
                ShuaGuai:AddNewModifier(nil, nil, "modifier_phased", {duration=0.1})        
        end
end

function CAddonTemplateGameMode:createnewherotest( data ) 
    local hero   = PlayerResource:GetSelectedHeroEntity(data.PlayerID)
    local teamid = 3
    if data.good then teamid = PlayerResource:GetCustomTeamAssignment(data.PlayerID) end 
    CreateUnitByNameAsync( data.way, Entities:FindByName(nil,"creep_birth_"..(teamid-3)):GetAbsOrigin(), true, nil, nil, teamid,  function( v ) v:SetControllableByPlayer( data.PlayerID, false ) v:Hold() v:SetIdleAcquire( false ) v:SetAcquisitionRange( 0 ) end )  
end

function CAddonTemplateGameMode:refreshlist()
        for name,info in pairs(LoadKeyValues('scripts/npc/npc_heroes_custom.txt'))do 
                if info ~= 1 and name ~= SET_FORCE_HERO then 
                        CustomGameEventManager:Send_ServerToAllClients('hero_info', {name=name,hero=info.override_hero}) 
                end
        end
end