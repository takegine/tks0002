Game_Event = Game_Event or class({})

function Game_Event:init()
    ListenToGameEvent("player_connect_full",     Dynamic_Wrap(self, "ConnectFull"), self)
    ListenToGameEvent('dota_player_gained_level',Dynamic_Wrap(self, 'HeroLevelUp'), self)
    ListenToGameEvent("game_rules_state_change", Dynamic_Wrap(self, "StateChange"), self)
    ListenToGameEvent("entity_killed",           Dynamic_Wrap(self, "EntityKilled"), self)
    ListenToGameEvent("npc_spawned",             Dynamic_Wrap(self, "OnNPCSpawned"), self)

    -- Change random seed
    local timeTxt = string.gsub(string.gsub(GetSystemTime(), ":", ""), "0", "")
    math.randomseed(tonumber(timeTxt))

    self.mode = GameRules:GetGameModeEntity()
    self.mode:SetDamageFilter(Dynamic_Wrap(self, "DamageFilter"), self)
    self.mode:SetItemAddedToInventoryFilter( Dynamic_Wrap( self, "InventoryFilter" ), self )
    self.mode:SetModifyExperienceFilter( Dynamic_Wrap(self, "ExperienceFilter"), self )
end

-- This function is called once when the player fully connects and becomes "Ready" during Loading
function Game_Event:ConnectFull(keys)
    -- Set GameMode parametersself.mode:SetCustomHeroMaxLevel(MAX_LEVEL)
    self.mode:SetCustomGameForceHero(SET_FORCE_HERO)

    --游戏性
    self.mode:SetBuybackEnabled(false)
    self.mode:SetLoseGoldOnDeath(false)
    self.mode:SetTopBarTeamValuesVisible( true )
    self.mode:SetDaynightCycleDisabled(false)
    -- self.mode:SetStashPurchasingDisabled( true ) 禁用储藏室，不限购物地点
    self.mode:SetStickyItemDisabled(true)
    self.mode:SetFogOfWarDisabled( FOG_OF_WAR_DISABLE )
    
    -- self.mode:SetAlwaysShowPlayerInventory( true )
    --self.mode:SetUseCustomHeroLevels(true)
    --self.mode:SetCustomXPRequiredToReachNextLevel(Custom_XP_Required)

    --self.mode:SetCameraDistanceOverride( 1500 )
    --显示
    self.mode:SetCameraDistanceOverride( 1000)--设置镜头
    self.mode:SetHUDVisible(18,false)
    self.mode:SetCustomAttributeDerivedStatValue( DOTA_ATTRIBUTE_STRENGTH_DAMAGE, 5 )
    self.mode:SetCustomAttributeDerivedStatValue( DOTA_ATTRIBUTE_STRENGTH_HP, 100 )
    self.mode:SetCustomAttributeDerivedStatValue( DOTA_ATTRIBUTE_STRENGTH_HP_REGEN, 0 )--0.03
    self.mode:SetCustomAttributeDerivedStatValue( DOTA_ATTRIBUTE_AGILITY_DAMAGE, 5 )
    self.mode:SetCustomAttributeDerivedStatValue( DOTA_ATTRIBUTE_AGILITY_ARMOR, 0.25 )
    self.mode:SetCustomAttributeDerivedStatValue( DOTA_ATTRIBUTE_AGILITY_ATTACK_SPEED, 1 )
    self.mode:SetCustomAttributeDerivedStatValue( DOTA_ATTRIBUTE_INTELLIGENCE_DAMAGE, 5 )
    self.mode:SetCustomAttributeDerivedStatValue( DOTA_ATTRIBUTE_INTELLIGENCE_MANA, 0.2 )--0.25
    self.mode:SetCustomAttributeDerivedStatValue( DOTA_ATTRIBUTE_INTELLIGENCE_MANA_REGEN, 0.01 )--失效
    -- self.mode:SetHudCombatEventsDisabled( true )
    self.mode:SetHudCombatEventsDisabled( true )
end

function Game_Event:HeroLevelUp( keys )
    EntIndexToHScript(keys.hero_entindex):SetAbilityPoints(0)
end

function Game_Event:StateChange( keys )
    if   GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
        Timer(function()
            if PlayerResource:GetPlayerCount() <1 then
                return 0.01
            end
            for i=1,8 do
                PLAYER_LIST[i] = PlayerResource:GetPlayerCountForTeam( i +5 ) == 1 and i or nil
            end
            Game_Think:NewRound()
        end)
        
        for k,v in pairs(tkUnitInfo)
            do CustomNetTables:SetTableValue( "hero_info", k, v )
        end

        table.foreach( LoadKeyValues('scripts/npc/npc_ships_custom.txt'), function(s,n)
            tkShipList[s]={}
            table.foreach(n,function(_,u) table.insert(tkShipList[s], u) end)
        end)
    end
end

function Game_Event:EntityKilled( keys )
    local killedUnit = EntIndexToHScript( keys.entindex_killed   )
    local killerUnit = EntIndexToHScript( keys.entindex_attacker )

    if not killedUnit or not killerUnit then
        return
    end

    if killedUnit.reSpawn then
        killedUnit.reSpawn = nil
        return
    end

    if not killedUnit:IsHero() and not killerUnit:IsOpposingSelf() then
        local owner = killerUnit:XinShi()
        local gold = killedUnit:GetGoldBounty()
        if owner and gold then
            SendOverheadEventMessage(nil, OVERHEAD_ALERT_GOLD, owner, gold, nil)
            owner:ModifyGold( killedUnit:GetGoldBounty(), true, DOTA_ModifyGold_CreepKill )
        end
    end

    if  killedUnit.enemy then
        Timer(1,function() UTIL_Remove( killedUnit ) end)
        table.reduce( UNITS_LIST.enemy,killedUnit )
    end
end

function Game_Event:OnNPCSpawned( keys )
    local  npc  = EntIndexToHScript(keys.entindex)
    local NameX = npc:GetName()
    if NameX == "npc_dota_fort"
    or NameX == "npc_dota_building"
    or npc.bFirstSpawned then
        return
    end

    npc.bFirstSpawned = true
    npc.battleinfo = {}

    if NameX==SET_FORCE_HERO then
        local id = npc:GetPlayerID() --GetPlayerOwnerID()
        local team = npc:GetTeam()--npc:GetTeamNumber()
        npc.ship={}
        npc:CheckLevel(1)
        npc.Ticket = PlayerResource:HasCustomGameTicketForPlayerID(id)
        npc:SetCustomHealthLabel( PlayerResource:GetPlayerName(id), COLOER_PLAYER[team-5], COLOER_PLAYER[team-4], COLOER_PLAYER[team-3] )
        CreateUnitByName("tower_zhugong",Entities:Pos(team-5,3),false,nil,nil,team):SetOwner(npc)
        CustomNetTables:SetTableValue( "Hero_Population", tostring(id),{popMax=LOCAL_POPLATION,popNow=0} )
        CustomNetTables:SetTableValue( "player_info", tostring(id),{ ships={ Hold={},Lost={} } } )
        if GetMapName=="map0" then CustomGameEventManager:Send_ServerToTeam(team, "CameraRotateHorizontal", {angle=id*360/8}) end
    else
        NameX = npc:GetUnitName()
        local thisinfo = npc:IsHero() and  tkUnitInfo.hero[NameX] or tkUnitInfo.unit[NameX] or tkUnitInfo.other[NameX] or tkUnitInfo.enemy[NameX]

        if thisinfo then
            npc.attack_type = thisinfo.atk
            npc.defend_type = thisinfo.def
            npc.popuse      = thisinfo.pop
            
            table.foreach(thisinfo.able,function(_,a)
                npc:AddAbility(a)
            end)
            -- print(nameX, npc.attack_type, npc.defend_type)
            
            npc:AddNewModifier(npc, nil, "modifier_attack_" .. npc.attack_type, {})
            npc:AddNewModifier(npc, nil, "modifier_defend_" .. npc.defend_type, {})
        else
            if not (NameX == "npc_damage_dummy" or NameX ==  "npc_dota_thinker") then
                print(NameX,"error create without info")
            end
            return
        end

        -- if not npc:GetPlayerOwner()
        -- then return 
        -- end
    end

    print("                        [BAREBONES] NPC Spawned",NameX)

end


function Game_Event:DamageFilter( filterTable )
    if not filterTable.entindex_victim_const
    or  not filterTable.entindex_attacker_const
    then
        return
    end
    local damage_new = filterTable.damage
    local damtype    = filterTable.damagetype_const
    local killedUnit = EntIndexToHScript( filterTable.entindex_victim_const   )
    local killerUnit = EntIndexToHScript( filterTable.entindex_attacker_const )
    local killerReal = killerUnit:GetName()=="npc_dota_thinker" and killerUnit:GetOwner() or killerUnit
    local defend_big = killedUnit:FindAllModifiersByName( "modifier_defend_big" )
    local shield = killedUnit:FindAllModifiersByName( "modifier_custom_shield" )

    if damtype == DAMAGE_TYPE_PHYSICAL then

        local armor    =  killedUnit:GetPhysicalArmorValue(false)
        local oldkang  = 1-6*armor/(100+6*math.abs(armor))--1-52/48*armor/(18.75+armor)
        ---------------war3计算方式--------------------        
        --local newkang = 0
        -- if armor >= 0 then
        --     newkang  = 1-armor/(100+math.abs(armor))
        -- else
        --     newkang  = 2-math.pow(1-0.01,-armor)
        -- end
        ---------------dota2计算方式--------------------        
        local newkang = 1-armor/(100+math.abs(armor))
        -----------------------------------------------

        damage_new = damage_new /oldkang *newkang
    end

    if not DamageKV
    or not killerUnit.attack_type
    then return true 
    end

    killedUnit.defend_type  = killedUnit.defend_type or "none"
    local damage_multiplier = DamageKV[killerUnit.attack_type][killedUnit.defend_type] or 1

    damage_new = damage_new * damage_multiplier
    
    
    local shield_damage = 0
    if shield and damage_new ~= 0 then
        for _,mod in pairs(shield) do
            --if (mod.shield_type ~= damtype) or (not mod[killerUnit.attack_type]) then
            if not mod[killerUnit.attack_type] then
                goto continue
            end
            if mod.shield_value > damage_new then
                mod.shield_value = mod.shield_value - damage_new
                shield_damage = shield_damage + damage_new
                damage_new = 0
                break
            else
                damage_new = damage_new - mod.shield_value
                shield_damage = shield_damage + mod.shield_value
                mod.shield_value = 0
                mod:Destroy()
                goto continue
            end
            ::continue::
        end
    end
    
    if defend_big and damage_new ~= 0 then
        local damage_re = 1
        for _,mod in pairs(defend_big) do
            damage_re = pertenth(mod[killerUnit.attack_type]) *damage_re
        end
        damage_new = damage_new * damage_re
    end

    filterTable.damage = damage_new
    if not killerReal.battleinfo then
        print("not killerReal.battleinfo",killerReal:GetUnitName(),killerUnit:GetUnitName())
    else
        killerReal.battleinfo.damage_deal = damage_new + shield_damage
    -- killerReal:GetOwner().battleinfo.damage_deal= damage_new + killerReal:GetOwner().battleinfo.damage_deal or 0
    end
    if not killedUnit.battleinfo then
        print("not killedUnit.battleinfo",killedUnit:GetUnitName())
    else
        killedUnit.battleinfo.damage_take = damage_new + shield_damage
    end
    -- killedUnit:GetOwner().battleinfo.damage_take= damage_new + killedUnit:GetOwner().battleinfo.damage_take or 0

    return true
end

function Game_Event:InventoryFilter( filterTable )
    local hItem   = EntIndexToHScript( filterTable.item_entindex_const )--获得的物品
    local hItemPar= EntIndexToHScript( filterTable.item_parent_entindex_const )
    local hInvPar = EntIndexToHScript( filterTable.inventory_parent_entindex_const )--InventoryParent--库存拥有者
    local slot    = filterTable.suggested_slot

    --if hItem:GetName()=='item_tpscroll' then return true end

    if not hItem
    or not hInvPar
    or  hItem:GetName()=='item_tpscroll'
    then return true
    end

    local slotlist={ 'weapon', 'defend', 'jewelry', 'horses', 'format', 'queue' }
    for k,v in pairs(slotlist) do
        if  string.find(hItem:GetAbilityName(),v) then
            slot = k-1
            break
        end
    end

    local curitem = hInvPar:GetItemInSlot(slot)
    if curitem then 
        if curitem:GetName() == hItem:GetName() 
        or string.find(hItem:GetAbilityName(),'queue') then
            hItem:SetLevel(curitem:GetLevel() )
            -- hItem:SetCurrentCharges( curitem:GetCurrentCharges()  )
        end
        hInvPar:SellItem(curitem)--RemoveItem
    end

    filterTable.suggested_slot = slot

    -- if hInvPar:GetName() == SET_FORCE_HERO then
    --     local arms={}
    --     table.foreach(HeroList:GetAllHeroes(),function(_,v)
    --         if not v:IsOpposingTeam( hInvPar:GetTeamNumber() ) and v~=hInvPar  then
    --             table.insert(arms,v)
    --         end
    --     end)
    --     for i in ipairs(arms) do arms[i]:AddItemByName(hItem:GetName()):SetSellable(false) end
    -- end

    return true
end

function Game_Event:ExperienceFilter( filterTable ) end
