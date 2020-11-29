
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

function CDOTA_BaseNPC:CustomDamage( target, ability, damage, type, Attributes, flags)
    local damage_table = {}

	damage_table.attacker     = self
    damage_table.victim       = target
	damage_table.ability      = ability
	damage_table.damage       = damage
	damage_table.damage_type  = type
	damage_table.damage_flags = flags or 0

    if Attributes ~= self.attack_type then
        local dummy = CreateUnitByName( "npc_damage_dummy", Vector(0,0,0), false, self, self, self:GetTeamNumber() )
        dummy:AddNewModifier(dummy, nil, 'modifier_kill', {duration = 0.1} )
        dummy.attack_type     = Attributes
	    damage_table.attacker = dummy
    end

    return ApplyDamage(damage_table)
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

function CDOTA_BaseNPC:IsOpposingSelf()
    return self:GetTeamNumber() == 3
end

function CDOTA_BaseNPC:Phase()
    self:AddNewModifier(nil, nil, "modifier_phased", {duration=0.1})
end

function CEntities:Pos(iTeam, iSide)
    return self:FindByName(nil,"creep_birth_"..iTeam.."_"..iSide):GetOrigin()
end

function CCustomNetTableManager:OverData( ... )
    local name, id , key ,value =...
    local nettable = self:GetTableValue( name, tostring(id)) or {}
    nettable[key] = value
    self:SetTableValue( name, tostring(id), nettable)
end

function CreateUnitInFight(...)
    local v
    local name, ori, team, lvl, site, bEnemy = ...
    local 路线 = Entities:FindByName(nil,"creep_birth_"..site.."_0")
    local oppo = bEnemy and site == team
    team = oppo and DOTA_TEAM_BADGUYS or team + 5
    local owner= Entities:GetPlayer(team)
    ori = ori or 路线:GetOrigin()+RandomVector(20)
    v = CreateUnitByName( name, ori, true,nil,nil,team)
    v:CheckLevel(lvl)
    v.battleinfo = {}
    v:AddNewModifier(nil, nil, "modifier_player_lock", nil)
    v:Phase()
    v:BattleThink()

    if not oppo then
        v:SetControllableByPlayer( owner:GetPlayerOwnerID(), true )
    end


    if bEnemy then
        v:SetInitialGoalEntity( 路线 )
        v.enemy=true
        table.insert(UNITS_LIST.enemy , v)
    else
        v:SetUnitCanRespawn(false)
        v:SetOwner(owner)
        table.insert(UNITS_LIST.defend , v)
        v:FindAbilityByName('skill_player_price'):CastAbility()
    end

    return v
end

function BroadcastMsg( sMsg )
	-- Display a message about the button action that took place
	local buttonEventMessage = sMsg
	--print( buttonEventMessage )
	local centerMessage = {
		message = buttonEventMessage,
		duration = 1.0,
		clearQueue = true -- this doesn't seem to work
	}
	FireGameEvent( "show_center_message", centerMessage )
end

function LinkLuaS()
    print("LinkLuaS")
    local typetab = {"none","tree","fire","electrical","water","land","god"}
    local modload = "buff/BaseType.lua"
    for _,v in pairs(typetab) do
        LinkLuaModifier( "modifier_attack_"..v, modload, 0 )
        LinkLuaModifier( "modifier_defend_"..v, modload, 0 )
    end
        LinkLuaModifier( "modifier_defend_big", modload, 0 )
        LinkLuaModifier( "modifier_player_lock", modload, 0 )
        LinkLuaModifier( "modifier_custom_shield", modload, 0 )
        LinkLuaModifier( "modifier_abi_vam", "buff/ability_vampire", 0 )
    -- for k,v in pairs(tkItemInfo) do
    --     LinkLuaModifier( "modifier_"..k.."_hero", v.ScriptFile, 0 )
    -- end
end

function pertenth ( num ) 
    if num <0 then
        return 100/(100+num)
    end
        return (100-num)/100
end