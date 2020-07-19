
skill_hero_tiaoxin = class({})

function skill_hero_tiaoxin:OnSpellStart()

    local caster = self:GetCaster()
    local target = self:GetCursorTarget()
    local count  = self:GetLevelSpecialValueFor("damage", self:GetLevel()-1)
    local radius = self:GetLevelSpecialValueFor("radius", self:GetLevel()-1)
    local owner  = caster:GetOwner() or {ship={}}

    local damage_type  = self:GetAbilityDamageType()
	local target_team  = self:GetAbilityTargetTeam()
	local target_types = self:GetAbilityTargetType()
    local target_flags = self:GetAbilityTargetFlags()

    if  owner.ship['qunxing'] then
        
        local enemy = FindUnitsInRadius(caster:GetTeamNumber(), 
                                    target:GetOrigin(), 
                                    nil, 
                                    500,
                                    target_team, 
                                    target_types, 
                                    target_flags, 
                                    0, 
                                    true)

        for key,unit in pairs(enemy) do
            unit:AddNewModifier(caster, self, "modifier_tiaoxin", {})
           -- unit:SetModifierStackCount( "modifier_tiaoxin", self ,count)
        end


        -- local wu = ParticleManager:CreateParticle("particles/units/heroes/hero_riki/riki_smokebomb_b.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
        -- ParticleManager:SetParticleControl(wu, 0, target:GetAbsOrigin())
        -- ParticleManager:ReleaseParticleIndex(wu)
        -- self:ApplyDataDrivenModifier(caster, target, 'modifier_smoke_screen', nil)
        
       -- target:AddNewModifier(caster, self, 'modifier_smoke_screen', nil)
       -- target:SetModifierStackCount( "modifier_smoke_screen", self ,radius)
    else
        target:AddNewModifier(caster, self, "modifier_tiaoxin", {})  --如果没写duration,会一直有，不死就一直存在这个buff
      --  target:SetModifierStackCount( "modifier_tiaoxin", self ,count)
    end

end

LinkLuaModifier('modifier_tiaoxin', 'skill/hero_tiaoxin.lua', 0)
modifier_tiaoxin=class({})

function modifier_tiaoxin:OnCreated()
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    -- local ability = self:GetAbility()
    -- print(ability)
    -- self.damage = self:GetStackCount()
self:StartIntervalThink(1)
end

function modifier_tiaoxin:OnIntervalThink(keys)
    if not IsServer() then return end
    local ability=self:GetAbility()
    local damage  =ability:GetLevelSpecialValueFor("damage",ability:GetLevel()-1)
    local parent = self:GetParent()
    local dummy = CreateUnitByName( "npc_damage_dummy", Vector(0,0,0), false, parent, parent, parent:GetTeamNumber() )
    dummy.attack_type  = "electrical"
    dummy:AddNewModifier(dummy, nil, 'modifier_kill', {duration = 0.1} )

    local  damage_table = {

    attacker     = dummy,
    victim       = self.parent,
    damage_type  = DAMAGE_TYPE_PHYSICAL,
    damage       = damage,
    damage_flags = DOTA_DAMAGE_FLAG_NONE
}
    ApplyDamage(damage_table)
    SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, damage_table.victim, damage_table.damage, nil)

end

-- function modifier_tiaoxin:IsDeff()
--     return  true
-- end
function modifier_tiaoxin:DeclareFunctions()   
    return { 
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_EVENT_ON_HERO_KILLED,
        MODIFIER_EVENT_ON_TAKEDAMAGE_KILLCREDIT
    } 
end

function modifier_tiaoxin:GetModifierAttackSpeedBonus_Constant()  
    return -50
end

function modifier_tiaoxin:OnTakeDamageKillCredit( params)

    if  params.attacker ~= self:GetParent() then 
        return 
    end
    
    local parent   = self:GetParent()
    local ability  = self:GetAbility()
    local owner    = parent:GetOwner() or {ship={}}
    local attacker = params.attacker
    local target   = params.target
    local damage   = params.damage
    
    if not target:IsHero() 
    and damage > target:GetHealth() then
        parent:RemoveModifierByName("modifier_tiaoxin")
    end
end

function modifier_tiaoxin:OnHeroKilled( params)
    
    local parent   = self:GetParent()
    local ability  = self:GetAbility()
    local radius   = ability:GetSpecialValueFor("radius")
    local heallvl  = ability:GetLevelSpecialValueFor("heallvl", ability:GetLevel()-1) /100
    local owner    = parent:GetOwner() or {ship={}}
    local unit     = params.unit
    local attacker = params.attacker
    local target   = params.target

    if unit == parent then
       
        parent:RemoveModifierByName("modifier_tiaoxin")
    end
end


modifier_smoke_screen = {}

function modifier_smoke_screen:OnCreated(keys)
    
    if not IsServer() then return end
        local wu = ParticleManager:CreateParticle("particles/units/heroes/hero_riki/riki_smokebomb_b.vpcf",
         PATTACH_ABSORIGIN_FOLLOW, target)
        ParticleManager:SetParticleControl(wu, 0, target:GetAbsOrigin())
        ParticleManager:SetParticleControl(wu, 1, Vector(self:GetStackCount(),self:GetStackCount(),self:GetStackCount()))
        ParticleManager:ReleaseParticleIndex(wu)
end