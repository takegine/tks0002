

LinkLuaModifier('modifier_kurou', 'skill/hero_kurou.lua', 0)

LinkLuaModifier('modifier_kurou_damage', 'skill/hero_kurou.lua', 0)

skill_hero_kurou=class({})

function skill_hero_kurou:OnSpellStart()

    local caster = self:GetCaster()
    local target = self:GetCursorTarget()
    local target_team  = self:GetAbilityTargetTeam()
	local target_types = self:GetAbilityTargetType()
    local target_flags = self:GetAbilityTargetFlags()
    local owner  = caster:GetOwner() or {ship={}}  


caster:AddNewModifier(caster, self, "modifier_kurou", {duration=12})
caster:AddNewModifier(caster, self, "modifier_kurou_damage", {duration=12})

if owner.ship['kurou']  then

    local dummy = CreateUnitByName( "npc_damage_dummy", Vector(0,0,0), false, caster, caster, caster:GetTeamNumber() )
    dummy.attack_type  = "fire"
    dummy:AddNewModifier(dummy, nil, 'modifier_kill', {duration = 0.1} )

    local enemy = FindUnitsInRadius(caster:GetTeamNumber(), 
    caster:GetOrigin(), 
    nil, 
    500,
    DOTA_UNIT_TARGET_TEAM_ENEMY, 
    target_types, 
    target_flags, 
    0, 
    true)

    for key,unit in pairs(enemy) do

        local  damage_table = {
    
        attacker     = dummy,
        ability      =ability,
        victim       = unit,
        damage_type  = DAMAGE_TYPE_PURE,
        damage       = unit:GetHealth()*15/100
    }
        ApplyDamage(damage_table)

end

end

end


modifier_kurou=class({})

function modifier_kurou:DeclareFunctions()   
    return { 
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
    } 
end

function modifier_kurou:GetModifierAttackSpeedBonus_Constant()
    local ability=self:GetAbility()
    local speed=ability:GetSpecialValueFor('speed')
    return speed
end

function modifier_kurou:GetModifierMoveSpeedBonus_Constant()  
    local ability=self:GetAbility()
    local speed=ability:GetSpecialValueFor('speed')
    return speed
end


modifier_kurou_damage=class({})

function modifier_kurou_damage:OnCreated()
self:StartIntervalThink(1)
end


function modifier_kurou_damage:OnIntervalThink(keys)

    local ability=self:GetAbility()
    local target_team  = ability:GetAbilityTargetTeam()
	local target_types = ability:GetAbilityTargetType()
    local target_flags = ability:GetAbilityTargetFlags()

    if not IsServer() then return end

    local ability=self:GetAbility()
    local damage  =ability:GetLevelSpecialValueFor("damage",ability:GetLevel()-1)
    local parent = self:GetParent()
    local dummy = CreateUnitByName( "npc_damage_dummy", Vector(0,0,0), false, parent, parent, parent:GetTeamNumber() )
    dummy.attack_type  = "fire"
    dummy:AddNewModifier(dummy, nil, 'modifier_kill', {duration = 0.1} )

    local enemy = FindUnitsInRadius(parent:GetTeamNumber(), 
    parent:GetOrigin(), 
    nil, 
    500,
    DOTA_UNIT_TARGET_TEAM_ENEMY, 
    target_types, 
    target_flags, 
    0, 
    true)

    for key,unit in pairs(enemy) do

        local  damage_table = {
    
        attacker     = dummy,
        ability      =ability,
        victim       = unit,
        damage_type  = DAMAGE_TYPE_PHYSICAL,
        damage       = parent:GetMaxHealth()*3/100
    }
        ApplyDamage(damage_table)
end
        local  damage_table = {
    
            attacker     = dummy,
            ability      =ability,
            victim       = parent,
            damage_type  = DAMAGE_TYPE_PHYSICAL,
            damage       = parent:GetMaxHealth()*3/100
        }
            ApplyDamage(damage_table)
   

    if parent:GetHealth()<parent:GetMaxHealth()*30/100
    then  parent:RemoveModifierByName('modifier_kurou_damage')
    end

end