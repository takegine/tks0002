
skill_hero_yeyan = class({})

function skill_hero_yeyan:OnSpellStart()

    local caster = self:GetCaster()
    local target = self:GetCursorTarget()
    local owner  = caster:GetOwner() or {ship={}}

    target:AddNewModifier(caster, self, "modifier_yeyan", {})  

end

LinkLuaModifier('modifier_yeyan', 'skill/hero_yeyan.lua', 0)

modifier_yeyan=class({})

function modifier_yeyan:IsHidden()
    return false
end

function modifier_yeyan:CheckState()
    local state = {
    [MODIFIER_STATE_SILENCED]=true,
}      return state
end

function modifier_yeyan:OnCreated()
    self:StartIntervalThink(1)
end

function modifier_yeyan:OnIntervalThink()
    if not IsServer() then return end

    local ability=self:GetAbility()
    local parent = self:GetParent()
    local caster=self:GetCaster()
    local damage=ability:GetSpecialValueFor('damage')
    local dummy = CreateUnitByName( "npc_damage_dummy",OUT_SIDE_VECTOR, false, parent, parent, parent:GetTeamNumber() )
    dummy.attack_type  = "electrical"
    dummy:AddNewModifier(dummy, nil, 'modifier_kill', {duration = 0.1} )

    local  damage_table = {
    attacker     = dummy,
    victim       = parent,
    damage_type  = DAMAGE_TYPE_MAGICAL,
    damage       = damage,
    damage_flags = DOTA_DAMAGE_FLAG_NONE
}
    ApplyDamage(damage_table)
    SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, damage_table.victim, damage_table.damage, nil)

end

function modifier_yeyan:GetEffectName()
    return
    'particles/units/heroes/hero_doom_bringer/doom_bringer_ambient.vpcf'  
end

function modifier_yeyan:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_yeyan:IsHidden()
    return true
end

function modifier_yeyan:OnDestroy()

    if  not  IsServer()  then  return  end


    local parent=self:GetParent()
    local caster=self:GetCaster()
    local ability=self:GetAbility()

    local pfxname = "particles/battlepass/healing_campfire_ward.vpcf"
    local pfx = ParticleManager:CreateParticle( pfxname, PATTACH_ABSORIGIN_FOLLOW, parent)
    ParticleManager:SetParticleControl(pfx, 1, Vector(50, 50, 50))
    ParticleManager:ReleaseParticleIndex(pfx)
    
	local target_team  = ability:GetAbilityTargetTeam()
	local target_types = ability:GetAbilityTargetType()
    local target_flags = ability:GetAbilityTargetFlags() 
   
    local enemy = FindUnitsInRadius(caster:GetTeamNumber(), 
    parent:GetOrigin(), 
    nil, 
    1600,
    target_team, 
    target_types, 
    target_flags, 
    0, 
    true)

    if enemy and #enemy ~= 0 then       
    local rollenemyint = RandomInt(1, #enemy)  
    local rollenmey = enemy[rollenemyint]

    rollenmey:AddNewModifier(caster, ability, "modifier_yeyan", {})
    end
end

