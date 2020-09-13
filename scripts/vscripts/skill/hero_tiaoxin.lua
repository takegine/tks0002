
skill_hero_tiaoxin = class({})

function skill_hero_tiaoxin:OnSpellStart()

    local caster = self:GetCaster()
    local target = self:GetCursorTarget()
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
        if unit:HasModifier("modifier_item_sphere_target") or unit:IsMagicImmune()  then return end
        unit:AddNewModifier(caster, self, "modifier_tiaoxin", {duration=10})
        end
        else
        if target:HasModifier("modifier_item_sphere_target") or unit:IsMagicImmune()  then  return end
        target:AddNewModifier(caster, self, "modifier_tiaoxin", {duration=10})  
        end
end

LinkLuaModifier('modifier_tiaoxin', 'skill/hero_tiaoxin.lua', 0)

modifier_tiaoxin=class({})

function modifier_tiaoxin:IsHidden()
    return true
end

function modifier_tiaoxin:OnCreated()
self:StartIntervalThink(1)
end

function modifier_tiaoxin:OnIntervalThink(keys)
    if not IsServer() then return end
    local ability=self:GetAbility()
    local parent = self:GetParent()
    local caster=self:GetCaster()
    local dummy = CreateUnitByName( "npc_damage_dummy", Vector(0,0,0), false, parent, parent, parent:GetTeamNumber() )
    dummy.attack_type  = "electrical"
    dummy:AddNewModifier(dummy, nil, 'modifier_kill', {duration = 0.1} )

    local  damage_table = {
    attacker     = dummy,
    victim       = parent,
    damage_type  = DAMAGE_TYPE_MAGICAL,
    damage       = ability:GetLevel()*130,
    damage_flags = DOTA_DAMAGE_FLAG_NONE
}
    ApplyDamage(damage_table)
    SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, damage_table.victim, damage_table.damage, nil)
end

function modifier_tiaoxin:GetEffectName()
    return
    'particles/units/heroes/hero_slardar/slardar_amp_damage.vpcf'     
end

function modifier_tiaoxin:GetEffectAttachType()
    return PATTACH_OVERHEAD_FOLLOW
end

function modifier_tiaoxin:IsHidden()
    return true
end

