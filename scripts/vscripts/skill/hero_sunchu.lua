

LinkLuaModifier("skill_hero_sunchu_takedamage",'skill/hero_sunchu.lua',0)


skill_hero_sunchu=class({})

    function skill_hero_sunchu:GetIntrinsicModifierName()
        return "skill_hero_sunchu_takedamage"
    end
    

skill_hero_sunchu_takedamage=class({})

function skill_hero_sunchu_takedamage:DeclareFunctions()
    return
    {
        MODIFIER_EVENT_ON_TAKEDAMAGE
    }
end

function skill_hero_sunchu_takedamage:OnTakeDamage(keys)

    local ability=self:GetAbility()
    local caster = self:GetCaster()
    local parent=self:GetParent()
    local zhoutailist = {}
    local target_team  = ability:GetAbilityTargetTeam()
	local target_types = ability:GetAbilityTargetType()
    local target_flags = ability:GetAbilityTargetFlags()

    local owner  = caster:GetOwner() or {ship={}}  

    if keys.unit~=parent then return end

    local friend = FindUnitsInRadius(caster:GetTeamNumber(), 
    caster:GetOrigin(), 
    nil, 
    650,
    DOTA_UNIT_TARGET_TEAM_FRIENDLY, 
    DOTA_UNIT_TARGET_HERO, 
    target_flags, 
    0, 
    true)

    for key,unit in pairs(friend) do
    if unit:GetUnitName()=='npc_dota_hero_slardar'  then
    table.insert( zhoutailist , unit)
    end
    end

    --print(#zhoutailist)

    if #zhoutailist>=1  then  


    parent:Heal(keys.damage*1.4, caster)

    for key,unit in pairs(zhoutailist) do

    local  damage_table = { 
        attacker     = keys.attacker,
        victim       = unit,
        damage_type  = keys.damage_type,
        damage       = keys.damage/#zhoutailist
    }
    ApplyDamage(damage_table)
    
    end
else  

end

end

    

