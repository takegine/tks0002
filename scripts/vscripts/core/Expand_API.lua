
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

function CDOTA_BaseNPC:CustomDamage( target, ability, damage, type, Attributes, flags)--没有使用
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

function team2id( this ) return PlayerResource:GetNthPlayerIDOnTeam(this+5,1) end
function id2play(  id  ) return PlayerResource:GetSelectedHeroEntity(id) end
function id2team(  id  ) return PlayerResource:GetTeam( id )-5 end
function team2pl( this ) return id2play(team2id(this)) end
-- pl2team == npc:GetTeamNumber()
-- play2id == npc:GetPlayerID() --GetPlayerOwnerID()

function CDOTA_BaseNPC:XinShi()
    local team = self:GetTeamNumber()
    if Clamp(team,6,13) == team then
        return team2pl( team -5 )
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

function damage_fix(attacker,target,damage)
    local armor = target:GetPhysicalArmorValue(false)
    local newkang = 1-armor/(100+math.abs(armor))
    local damage_f
    if not target:IsRangedAttacker() then
        damage_f = damage-16--近战自带16减伤
        damage_f = damage_f *newkang
    else
        damage_f = damage *newkang
    end
    if not DamageKV
    or not attacker.attack_type
    then return false 
    end
    local damage_multiplier = DamageKV[attacker.attack_type][target.defend_type] or 1
    damage_f = damage_f * damage_multiplier
    damage_f = damage_f > 0 and damage_f or 0
    return damage_f
end

function pertenth ( num ) 
    if num <0 then
        return 100/(100+num)
    end
        return (100-num)/100
end