
LinkLuaModifier("modifier_jiuchi",'skill/hero_jiuchi.lua',0)  
LinkLuaModifier("modifier_skill_hero_jiuchi",'skill/hero_jiuchi.lua',0)
LinkLuaModifier("modifier_quanqing_damage",'skill/hero_jiuchi.lua',0)

skill_hero_jiuchi=class({})



function skill_hero_jiuchi:GetIntrinsicModifierName()  
    return "modifier_skill_hero_jiuchi"
end 


modifier_skill_hero_jiuchi=class({})


function modifier_skill_hero_jiuchi:IsHidden()
    return true
end

function modifier_skill_hero_jiuchi:DeclareFunctions()
    return{
        MODIFIER_EVENT_ON_ATTACK_START
    }
end

function modifier_skill_hero_jiuchi:OnAttackStart(keys)
    local ability=self:GetAbility()
    local caster=self:GetCaster()
    local owner  = caster:GetOwner() or {ship={}}

    if not IsServer() then  return end
    if keys.attacker~=caster then return end  

    if owner.ship['quanqing'] then
    caster:AddNewModifier(caster, ability, 'modifier_jiuchi', {})  
    caster:AddNewModifier(caster, ability, 'modifier_quanqing_damage', {})  
    else
  
    if ability:IsCooldownReady() then
    caster:AddNewModifier(caster, ability, 'modifier_jiuchi', {})
    ability:StartCooldown(6)
    end

    end 

end 


modifier_jiuchi=class({})

function modifier_skill_hero_jiuchi:IsHidden()
    return true
end

function modifier_jiuchi:DeclareFunctions()
    return{
        MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }
end

function modifier_jiuchi:GetModifierDamageOutgoing_Percentage()
    local ability=self:GetAbility()
    return  ability:GetLevel()*20+200
end

function modifier_jiuchi:OnAttackLanded(keys)
    local caster=self:GetCaster()
    local ability=self:GetAbility()
    if not IsServer() then  return end
    if keys.attacker~=caster then return end
    caster:RemoveModifierByName('modifier_jiuchi')
end
  

modifier_quanqing_damage=class({})

function modifier_quanqing_damage:IsHidden()
    return true
end 

function modifier_quanqing_damage:OnCreated()
self:StartIntervalThink(1)
end

function modifier_quanqing_damage:OnIntervalThink(keys)
    if not IsServer() then return end

    local caster=self:GetCaster()
    local ability=self:GetAbility()
    local parent = self:GetParent()
    local target_team  = ability:GetAbilityTargetTeam()
	local target_types = ability:GetAbilityTargetType()
    local target_flags = ability:GetAbilityTargetFlags()

   local dummy = CreateUnitByName( "npc_damage_dummy",OUT_SIDE_VECTOR, false, parent, parent, parent:GetTeamNumber() )
    dummy.attack_type  = "fire"
    dummy:AddNewModifier(dummy, nil, 'modifier_kill', {duration = 0.1} )

    local enemy = FindUnitsInRadius(caster:GetTeamNumber(), 
    parent:GetOrigin(), 
    nil, 
    500,
    target_team, 
    target_types, 
    target_flags, 
    0, 
    true)

    for key,unit in pairs(enemy) do
        local  damage_table = {
        attacker     = dummy,
        ability      = ability,
        victim       = unit,
        damage_type  = DAMAGE_TYPE_PHYSICAL,
        damage       = parent:GetMaxHealth()*6/100
    }

    ApplyDamage(damage_table)
    local heal=caster.damage_deal*(10+caster:GetLevel()+4)/100
    caster:Heal(heal,caster)
    SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, self:GetParent(),heal, nil) 
end
    
end 


