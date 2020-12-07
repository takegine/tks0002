Game_Think = Game_Think or class({})

-- This function initializes the game mode and is called before anyone loads into the game
-- It can be used to pre-initialize any values/tables that will be needed later
function Game_Think:init()
    SET_PREGAME_TIME = 1
    SET_STARTING_GOLD = 9999
    GameRules:SetUseUniversalShopMode(true)
	GameRules:SetPreGameTime(1)
    GameRules:SetStartingGold(9999)
    GameRules:LockCustomGameSetupTeamAssignment(true)

    GameRules:GetGameModeEntity():SetHUDVisible(1,true)
    GameRules:GetGameModeEntity():SetHUDVisible(2,true)
    GameRules:GetGameModeEntity():SetHUDVisible(3,true)
    GameRules:GetGameModeEntity():SetHUDVisible(4,true) 
    GameRules:GetGameModeEntity():SetHUDVisible(5,true)
    GameRules:SetCustomGameTeamMaxPlayers( 6, 1 )

    ListenToGameEvent("dota_item_purchased",Dynamic_Wrap(self, "dota_item_purchased"), self)
    ListenToGameEvent("player_chat",        Dynamic_Wrap(self, "player_chat"), self)
    ListenToGameEvent("entity_hurt",        Dynamic_Wrap(self, "entity_hurt"), self)

    CustomGameEventManager:RegisterListener( "testOptionChange", testOptionChange )
    CustomGameEventManager:RegisterListener( "createnewherotest", createnewherotest )
    CustomGameEventManager:RegisterListener("refreshlist",refreshlist)
	CustomGameEventManager:RegisterListener( "testOption_01", self.testOption_01 )
	CustomGameEventManager:RegisterListener( "testOption_02", self.testOption_02 )
	CustomGameEventManager:RegisterListener( "testOption_03", self.testOption_03 )
	CustomGameEventManager:RegisterListener( "testOption_04", self.testOption_04 )
	CustomGameEventManager:RegisterListener( "testOption_05", self.testOption_05 )
	CustomGameEventManager:RegisterListener( "testOption_06", self.testOption_06 )
	CustomGameEventManager:RegisterListener( "testOption_07", self.testOption_07 )
	CustomGameEventManager:RegisterListener( "testOption_08", self.testOption_08 )
	CustomGameEventManager:RegisterListener( "testOption_09", self.testOption_09 )
	CustomGameEventManager:RegisterListener( "testOption_15", self.testOption_15 )
	CustomGameEventManager:RegisterListener( "testOption_16", self.testOption_16 )


    
    SendToServerConsole( "dota_ability_debug 0" )

    self.shiplist = LoadKeyValues("scripts/羁绊名汉化.kv")
    self.namelist = LoadKeyValues("resource/addon_schinese.txt")["Tokens"]
    self.slotlist = { 'weapon', 'defend', 'jewelry', 'horses', 'format', 'queue' }
    -- local ship = {}
    --     table.foreach(self.shiplist,function(s)
    --         ship[string.sub(s,12)]=true
    --     end)
    --     print_r(ship)
end

function Game_Think:NewRound()
    
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
    LinkLuaModifier("print_evasion" , "test/print_evasion" ,0)
    local targetdummy = CreateUnitByName( "npc_dota_hero_target_dummy", Entities:Pos(1,1), true, nil, nil, 7 )
    targetdummy:SetBaseMagicalResistanceValue( 0 )
    targetdummy:AddNewModifier(nil, nil, "print_evasion", nil).namelist = self.namelist
    CustomUI:DynamicHud_Create( -1,"","file://{resources}/layout/custom_game/test/option.xml",nil)
end

function createnewherotest( eventSourceIndex, data )
    -- local owner   = PlayerResource:GetSelectedHeroEntity(data.PlayerID)
    -- local hteam   = PlayerResource:GetCustomTeamAssignment(data.PlayerID)
    local teamid  = data.good and 6 or 3
    local point   = data.good and 2 or 0
    local crePos  = Entities:Pos(1,point)
    v = CreateUnitByName( data.way, crePos, true,nil,nil,teamid)
    v:Hold()
    v:SetIdleAcquire( false )
    v:SetAcquisitionRange( 0 )
    v:CheckLevel(1)
    v.battleinfo = {}
    -- v:AddNewModifier(nil, nil, "modifier_player_lock", nil)
    v:AddNewModifier(nil, nil, "modifier_phased", {duration=0.1})
    -- v:BattleThink()
    v:SetControllableByPlayer( data.PlayerID, true )

    if not data.good then
        -- v:SetInitialGoalEntity( 路线 )
        v.enemy=true
        -- table.insert(UNITS_LIST.enemy , v)
    else
        v:SetUnitCanRespawn(false)
        v:SetOwner(id2play(data.PlayerID))
        -- table.insert(UNITS_LIST.defend , v)
        -- v:FindAbilityByName('skill_player_price'):CastAbility()
    end
end

function refreshlist()
    for k,v in pairs(LoadKeyValues('scripts/npc/npc_info_custom.txt'))
        do CustomNetTables:SetTableValue( "hero_info", k, v )
    end
end

function Game_Think:dota_item_purchased( data )
    -- [game_event_name] => "dota_item_purchased"
    -- [itemname] => "item_queue_038"
    -- [game_event_listener] => 1753219076
    -- [PlayerID] => 0
    -- [itemcost] => 0
    -- [splitscreenplayer] => -1
    local id = tostring(data.PlayerID)
    -- local my_ships = CustomNetTables:GetTableValue( "ship_show", id)
    
    local itemtype
    for k,v in pairs(self.slotlist) do
        if  string.find(data.itemname,v) then
            -- my_ships.items[k] = data.itemname
            -- CustomNetTables:SetTableValue( "ship_show", id, my_ships)
            itemtype = v
            break
        end
    end

    local item = PlayerResource:GetSelectedHeroEntity(data.PlayerID):FindItemInInventory(data.itemname)
    local modname
    for k,v in pairs(FindUnitsInRadius(6,Vector(0,0,0),nil,9999,1,55,0,0,false)) do
        if v:GetUnitName()~= SET_FORCE_HERO then
            for q = 1,v:GetModifierCount() do
                modname = v:GetModifierNameByIndex( q )
                if  string.find( modname ,itemtype) then
                    v:RemoveModifierByName( modname )
                end
            end

            v:AddNewModifier(v, item, "modifier_"..data.itemname.."_hero", nil)
        end
    end
end

function Game_Think:player_chat(keys )
    -- playerid	0
    -- game_event_listener	184549379
    -- game_event_name	player_chat
    -- text	ç¾ç»
    -- teamonly	1
    -- userid	1
    -- splitscreenplayer	-1
    local hero = id2play(keys.playerid)
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
    elseif list[1]=="stage" then
        self.testOption_05( eventSourceIndex, {msg = list[2]} )

    elseif list[1]=="side" and list[2] then

    elseif list[1]=="ship" and list[2] then
        hero.ship[list[2]]= list[3]=="true" or nil
        local shipname = self.shiplist["skill_ship_"..list[2]] or list[2]
        self:BroadcastMsg( "羁绊名："..shipname.." ，已设置:"..(list[3]=="true" and "生" or "失").."效" )
        self.testOption_04()
        
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
        if list[2]=="waveup" then
            self.testOption_04()
        elseif list[2]=="lvlup" then
            herochange("lvlup")
        end
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

-- An entity somewhere has been hurt.  This event fires very often with many units so don't do too many expensive
-- operations here
function Game_Think:entity_hurt(keys)
    local killedUnit = EntIndexToHScript( keys.entindex_killed   )
    local killerUnit = EntIndexToHScript( keys.entindex_attacker )
    local killerReal = killerUnit:GetName()=="npc_dota_thinker" and killerUnit:GetOwner() or killerUnit
    local damage_new = 0

    if killedUnit.battleinfo
    and killedUnit.battleinfo.damage_take
    then
        damage_new = killedUnit.battleinfo.damage_take
    elseif killerReal.battleinfo
    and killerReal.battleinfo.damage_deal
    then
        damage_new = killerReal.battleinfo.damage_deal
    end
    
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
        local mes_dam = "<font color='#40E0D0'>"..string.format("%.2f", damage_new ).."</font>"
        local mes_tot = mes_att.." 对 "..mes_vim.." 造成 "..mes_sta..mes_typ.." 的 "..mes_dam.." 点伤害"
        GameRules:SendCustomMessage( mes_tot, killerUnit:GetTeamNumber(), 1)
    --damagebits
end

function Game_Think:BroadcastMsg( sMsg )
	-- Display a message about the button action that took place
	--print( sMsg )
	-- local centerMessage = {
	-- 	message = sMsg,
	-- 	duration = 1.0,
	-- 	clearQueue = true -- this doesn't seem to work
	-- }
    -- FireGameEvent( "show_center_message", centerMessage )
    
    
    GameRules:SendCustomMessage( sMsg, -1, 1)
end

function Game_Think.testOption_01( eventSourceIndex )
	SendToServerConsole( "dota_dev hero_refresh" )
	EmitGlobalSound( "UI.Button.Pressed" )
end

function Game_Think.testOption_02( eventSourceIndex )
    self = Game_Think
    self.m_bFreeSpellsEnabled = not self.m_bFreeSpellsEnabled
    self:BroadcastMsg( "无限技能："..(self.m_bFreeSpellsEnabled and "开启" or "关闭") )
    SendToServerConsole( "toggle dota_ability_debug" )
    EmitGlobalSound( "UI.Button.Pressed" )

	if  self.m_bFreeSpellsEnabled then
        self.testOption_01( eventSourceIndex )
    end
end

function Game_Think.testOption_03( eventSourceIndex, data )
    testOption.ship  = not testOption.ship
    Game_Think:BroadcastMsg( "叛军羁绊："..(testOption.ship and "开启" or "关闭") )
	EmitGlobalSound( "UI.Button.Pressed" )
end

function Game_Think.testOption_04( eventSourceIndex, data )
    local reList = Entities:FindAllInSphere(Vector(0,0,0),9999)
    local u,abi
    for k = #reList, 1, -1 do  
        u= reList[k] 

        if not u.bFirstSpawned
        or not u:IsAlive()
        or u:GetName() == SET_FORCE_HERO 
        or u:GetName() == "npc_dota_courier" 
        then else
            for i=0,10 do
                abi =u:GetAbilityByIndex(i)
                if abi and abi.needwaveup then
                    abi:needwaveup()
                end
            end
        end
    end
	EmitGlobalSound( "UI.Button.Pressed" )
end

function Game_Think.testOption_05( eventSourceIndex, data )
    local stagelist = {"f","p" ,"r" ,"GAME_STAT_FINGHT","GAME_STAT_PLAN","GAME_STAT_READY","对战回合","准备回合","即将开战"}
    local curstage = data.msg or _G.StageTable.stage
    local curcount = 1
    for i in ipairs(stagelist) do
        if stagelist[i]==curstage then
            curcount= (i+1)%3
            break
        end
    end
    _G.StageTable.stage = stagelist[curcount+3]
    Game_Think:BroadcastMsg( stagelist[curcount+6] )
	EmitGlobalSound( "UI.Button.Pressed" )
end

function Game_Think.testOption_06( eventSourceIndex, data )
    testOption.enemy  = not testOption.enemy
	EmitGlobalSound( "UI.Button.Pressed" )
end

function Game_Think.testOption_07( eventSourceIndex, data )
    data.way  = DOTAGameManager:GetHeroUnitNameByID( tonumber(data.str) )
    data.good = not testOption.enemy
    createnewherotest( eventSourceIndex, data )
end

function Game_Think.testOption_08( eventSourceIndex, data )
    local hero = id2play(data.PlayerID)
    hero.side = data.str
    CustomNetTables:OverData( "player_info", data.PlayerID, "side" , data.str )
	EmitGlobalSound( "UI.Button.Pressed" )
end

function Game_Think.testOption_09( eventSourceIndex, data )
	EmitGlobalSound( "UI.Button.Pressed" )
end


function Game_Think.testOption_15( eventSourceIndex )
    SendToServerConsole( "restart 0" )
	EmitGlobalSound( "UI.Button.Pressed" )
end

function Game_Think.testOption_16( eventSourceIndex )
    SendToServerConsole( "disconnect" )
	EmitGlobalSound( "UI.Button.Pressed" )
end