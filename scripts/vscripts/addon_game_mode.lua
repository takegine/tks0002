-- Generated from template
SET_FORCE_HERO = "npc_dota_hero_phoenix"

if CAddonTemplateGameMode == nil then
	CAddonTemplateGameMode = class({})
end

require('root/ToolsFromX')

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
    LinkLuaS()
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
    GameRules:GetGameModeEntity():SetItemAddedToInventoryFilter( Dynamic_Wrap( self, "InvFilt" ), self )
    ListenToGameEvent("entity_hurt",Dynamic_Wrap(self, "entity_hurt"), self)
    ListenToGameEvent("npc_spawned",Dynamic_Wrap(self, "npc_spawned"), self)
    ListenToGameEvent("player_chat",Dynamic_Wrap(self, "player_chat"), self)
    ListenToGameEvent("entity_killed",Dynamic_Wrap(self,"OnEntityKilled"), self)
    -- ListenToGameEvent("dota_item_purchased",Dynamic_Wrap(self, "dota_item_purchased"), self)

    CustomGameEventManager:RegisterListener( "createnewherotest", Dynamic_Wrap(self,"createnewherotest") )
    CustomGameEventManager:RegisterListener("refreshlist",Dynamic_Wrap(self, 'refreshlist'))

    self.DamageKV = LoadKeyValues("scripts/damage_table.kv")
    self.shiplist = LoadKeyValues("scripts/羁绊名汉化.kv")
    self.namelist = LoadKeyValues("resource/addon_schinese.txt")["Tokens"]
    self.tkUnitList = {}
    local insetlist = function (list)
            table.foreach( list, function(k,v)
            if type(v)=="table" then
                self.tkUnitList[k]=v
            end
        end)
    end
    insetlist(LoadKeyValues('scripts/npc/npc_heroes_custom.txt'))
    insetlist(LoadKeyValues('scripts/npc/npc_units_custom.txt'))

end

-- Evaluate the state of the game
function CAddonTemplateGameMode:OnThink() return 1 end

function CAddonTemplateGameMode:createnewherotest( data )
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
                    h:AddAbility(abi)
                if  h:HasAbility(abi) then 
                    h:FindAbilityByName(abi):SetLevel(1)
                end
            end
        end
    end )
end

function CAddonTemplateGameMode:refreshlist()

    local ablelist = LoadKeyValues('scripts/npc/npc_skill_custom.txt')
    local herolist = LoadKeyValues('scripts/npc/npc_heroes_custom.txt')
    local unitlist = LoadKeyValues('scripts/npc/npc_Units_custom.txt')
    local hero_info = {}
    local unit_info = {}
    local function messageT(...)
        local mes, list, sendlist = ...
        local nocreate = {"npc_dota_fort","npc_dota_building", }
        for name,info in pairs(list)do
            if info == 1 
            or name == SET_FORCE_HERO
            or ( info.BaseClass and info.BaseClass ~= "npc_dota_creature" )
            then goto continue
            end
            local relist = {
                name = info.override_hero or name,
                --hero = info.override_hero,
                side = info.UnitLabel,
                popu = info.TksPopUse,
                price = info.TksPayedGold,
                able = ablelist[info.override_hero],
                }
            sendlist[name] = relist
            :: continue ::
        end
        CustomNetTables:SetTableValue( "hero_info", mes, sendlist )
    end
    messageT("hero", herolist, hero_info)
    messageT("unit", unitlist, unit_info) 


end

function CAddonTemplateGameMode:entity_hurt(keys)
    local killedUnit = EntIndexToHScript( keys.entindex_killed   )
    local killerUnit = EntIndexToHScript( keys.entindex_attacker )
    --damagebits
end

function CAddonTemplateGameMode:DamageFilter(filterTable)
    local damage_new = filterTable.damage
    local damtype    = filterTable.damagetype_const
    local killedUnit = EntIndexToHScript( filterTable.entindex_victim_const   )
    local killerUnit = EntIndexToHScript( filterTable.entindex_attacker_const )
    local killerReal = killerUnit:GetName()=="npc_dota_thinker" and killerUnit:GetOwner() or killerUnit
    local defend_big = killedUnit:FindAllModifiersByName( "modifier_defend_big" )

    if damtype == DAMAGE_TYPE_PHYSICAL then

        local armor    =  killedUnit:GetPhysicalArmorValue(false)
        local oldkang  = 1-6*armor/(100+6*armor)--1-52/48*armor/(18.75+armor)
        local newkang  = 1-armor/(100+armor)

        damage_new = damage_new /oldkang *newkang
    end

    if not self.DamageKV
    or not killerUnit.attack_type
    then return true 
    end

    killedUnit.defend_type  = killedUnit.defend_type or "none"
    local damage_multiplier = self.DamageKV[killerUnit.attack_type][killedUnit.defend_type] or 1

    damage_new = damage_new * damage_multiplier
    
    if defend_big then
        local damage_re = 0
        local pertenth  = function( num ) return (100-num)/10 end 
        for _,mod in pairs(defend_big) do
            damage_re = 100 - pertenth(mod[killerUnit.attack_type]) * pertenth( damage_re )
        end
        damage_new = damage_new * Clamp( pertenth( damage_re ) /10, 0, 1)
    end

    filterTable.damage = damage_new
    killerReal.damage_deal = damage_new
    -- killerReal:GetOwner().damage_deal= damage_new + killerReal:GetOwner().damage_deal or 0
    killedUnit.damage_take = damage_new
    -- killedUnit:GetOwner().damage_take= damage_new + killedUnit:GetOwner().damage_take or 0

    -- 演示实际伤害模块
        local type_list  = {
            none    =  "普通",
            god     =  "神",
            tree    =  "木",
            fire    =  "火",
            water   =  "水",
            land    =  "地",
            electrical="电"
        }
        local mes_sta = "<font color='#FF1493'>"..type_list[killerUnit.attack_type].."</font> 系"
        local mes_att = "<font color='#32CD32'>"..(self.namelist[killerReal:GetUnitName()] or "未知").."</font>"
        local mes_vim = "<font color='#DC143C'>"..(self.namelist[killedUnit:GetUnitName()] or "未知").."</font>"
        local mes_typ = "<font color='#4682B4'>"..(damtype == DAMAGE_TYPE_PHYSICAL and "物理" or damtype == DAMAGE_TYPE_MAGICAL and "魔法" or "其他").."</font>"
        local mes_dam = "<font color='#40E0D0'>"..string.format("%.2f", damage_new).."</font>"
        local mes_tot = mes_att.." 对 "..mes_vim.." 造成 "..mes_sta..mes_typ.." 的 "..mes_dam.." 点伤害"
        GameRules:SendCustomMessage( mes_tot, killerUnit:GetTeamNumber(), 1)

    return true

end

function CAddonTemplateGameMode:OnEntityKilled(keys)
    local killedUnit = EntIndexToHScript( keys.entindex_killed   )
    if killedUnit.reSpawn then
        killedUnit.reSpawn = nil
        return
    end
    Timer(0.1,function()
        if not killedUnit:IsNull() then
        killedUnit:Destroy() 
        end
    end)
end

function CAddonTemplateGameMode:npc_spawned(keys )
    local npc   = EntIndexToHScript(keys.entindex)
    local nameX = npc:GetName()
    if    nameX== "npc_dota_building"
    or    npc.bFirstSpawned 
    then  return
    end

    npc.bFirstSpawned = true

    if nameX==SET_FORCE_HERO then
        npc.ship={}
        -- 伤害傀儡无法使用伤害过滤器
        -- local elementlist =  { "none", "god", "tree", "fire", "electrical", "water", "land" }
        -- local colorlist = {
        --     255, 255, 255,--原色
        --       0,   0,   0,--黑色
        --       0, 255,   0,--绿色
        --     255,   0,   0,--红色
        --     255,   0, 255,--紫色
        --       0,   0, 255,--蓝色
        --     237, 189, 101,--黄色
        --       0, 255, 255,--青色
        -- }
        -- for i=1,7 do
        --     local rotationAngle =  360/8 * (1-i)
        --     local relPos = RotatePosition( Vector(0,0,0), QAngle( 0, rotationAngle, 0 ), Vector( 0, 400 , 0) )
        --     local absPos = GetGroundPosition( relPos , npc )
        --     local Pos = npc:GetAbsOrigin() + npc:GetForwardVector() * i * 300
        --     local targetdummy = CreateUnitByName( "npc_dota_hero_target_dummy", absPos, true, nil, nil, 7 )
        --     targetdummy:SetBaseMagicalResistanceValue( 0 )
        --     targetdummy:SetRenderColor( colorlist[i*3-2], colorlist[i*3-1], colorlist[i*3] )
        --     targetdummy.defend_type = elementlist[i]
        -- end
        LinkLuaModifier("print_evasion" , "root/print_evasion" ,0)
        local targetdummy = CreateUnitByName( "npc_dota_hero_target_dummy", Vector(0,0,0), true, nil, nil, 7 )
        targetdummy:SetBaseMagicalResistanceValue( 0 )
        targetdummy:AddNewModifier(npc, nil, "print_evasion", nil).namelist = self.namelist

        
        CustomNetTables:SetTableValue( "player_info", tostring(npc:GetPlayerID()),{ ships={ Hold={},Lost={} } } )
    elseif self.tkUnitList[nameX] then
        npc.attack_type = self.tkUnitList[nameX]["TksAttackType"]
        npc.defend_type = self.tkUnitList[nameX]["TksDefendType"]
        print(nameX, npc.attack_type, npc.defend_type)
        
        npc:AddNewModifier(npc, nil, "modifier_attack_" .. npc.attack_type, {})
        npc:AddNewModifier(npc, nil, "modifier_defend_" .. npc.defend_type, {})
    end
    
    if npc:IsHero() then
        for i=0,15 do 
            if   npc:GetAbilityByIndex(i) 
            then npc:GetAbilityByIndex(i):SetLevel(1) 
            end 
        end
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
    elseif list[1]=="side" and list[2] then
        hero.side = list[2]
        CustomNetTables:OverData( "player_info", keys.playerid, "side" , list[2] )
    elseif list[1]=="ship" and list[2] then
        hero.ship[list[2]]= list[3]=="true" or nil
        local shipname = self.shiplist["skill_ship_"..list[2]] or list[2]
        GameRules:SendCustomMessage( "羁绊名："..shipname.." ，已设置:"..(list[3]=="true" and "生" or "失").."效", hero:GetTeamNumber(), 1)
        herochange("waveup")
        
        -- local encreate = function(k,v) 
        --     if v then
        --         table.insert(my_ships.ships.Hold, k)
        --     else
        --         table.insert(my_ships.ships.Lost, k)
        --     end
        -- end
        
        -- my_ships.ships ={}
        -- table.foreach(hero.ship, encreate)
        local shipsList = { Hold={},Lost={} }
        for k,v in pairs(hero.ship) do
            if v then
                table.insert( shipsList.Hold, k)
            else
                table.insert( shipsList.Lost, k)
            end
        end
        CustomNetTables:OverData( "player_info", keys.playerid, "ships" , shipsList )

    elseif list[1]=="hero" and list[2] then
        herochange(list[2])
    end
end

function herochange(keys)
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

    if keys=="waveup" then
        table.foreach(reList,function(_,u)
            for i=0,10 do
                local abi =u:GetAbilityByIndex(i)
                if abi and abi.needwaveup then
                    abi:needwaveup()
                end
                local item = u:GetItemInSlot(i)
                if item and item.needwaveup then
                    item:needwaveup()
                end
            end
        end)
    elseif keys=="lvlup" then
        table.foreach(reList,function(_,u)
            local lvl = u:GetLevel()+1

            while( u:GetLevel() < lvl ) do
                if u:IsCreature() then u:CreatureLevelUp( 1 )
                elseif u:IsHero() then u:HeroLevelUp( false )
                else print(u:GetUnitName(),"cant level up") break
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


function CAddonTemplateGameMode:InvFilt( filterTable )
    local hItem   = EntIndexToHScript( filterTable.item_entindex_const )
    local hItemPar= EntIndexToHScript( filterTable.item_parent_entindex_const )
    local hInvPar = EntIndexToHScript( filterTable.inventory_parent_entindex_const )
    local slot    = filterTable.suggested_slot

    if hItem == nil 
    or hInvPar == nil 
    then return true 
    end

    local slotlist={ 'level', 'weapon', 'defend', 'jewelry', 'horses', 'format', 'queue' }
    for k,v in pairs(slotlist) do
        if  string.find(hItem:GetAbilityName(),v) then
            if k==1 then
                hItem:CastAbility()
                return true
            else
                slot = k-2
            end
            break
        end
    end

    local curitem = hInvPar:GetItemInSlot(slot)
    if curitem then 
        if curitem:GetName() == hItem:GetName() then
            hItem:SetLevel( curitem:GetLevel()  )
            hItem:SetCurrentCharges( curitem:GetCurrentCharges()  )
        end
        hInvPar:RemoveItem(curitem) 
    end

    filterTable.suggested_slot = slot

    return true
end



function LinkLuaS()
    local typetab = {"none","tree","fire","electrical","water","land","god"}
    local modload = "buff/BaseType.lua"
    for _,v in pairs(typetab) do
        print("modifier_attack_"..v)
        LinkLuaModifier( "modifier_attack_"..v, modload, 0 )
        LinkLuaModifier( "modifier_defend_"..v, modload, 0 )
    end
        LinkLuaModifier( "modifier_defend_big", modload, 0 )
end

function CAddonTemplateGameMode:dota_item_purchased( data )
    -- [game_event_name] => "dota_item_purchased"
    -- [itemname] => "item_queue_038"
    -- [game_event_listener] => 1753219076
    -- [PlayerID] => 0
    -- [itemcost] => 0
    -- [splitscreenplayer] => -1
    local id = tostring(data.PlayerID)
    local my_ships = CustomNetTables:GetTableValue( "ship_show", id)
    
    local slotlist = { 'weapon', 'defend', 'jewelry', 'horses', 'format', 'queue' }
    for k,v in pairs(slotlist) do
        if  string.find(data.itemname,v) then
            my_ships.items[k] = data.itemname
            CustomNetTables:SetTableValue( "ship_show", id, my_ships)
            break
        end
    end
end
