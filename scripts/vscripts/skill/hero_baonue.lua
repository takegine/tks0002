
LinkLuaModifier("modifier_skill_hero_baonue",'skill/hero_baonue.lua',0)

--LinkLuaModifier("modifier_skill_hero_baonue_kill",'skill/hero_baonue.lua',0)

skill_hero_baonue=class({})

function skill_hero_baonue:needwaveup()

	local caster  = self:GetCaster()
    local owner   = caster:GetOwner() or {ship={}}
    
	local target_team  = self:GetAbilityTargetTeam()
	local target_types = self:GetAbilityTargetType()
    local target_flags = self:GetAbilityTargetFlags()

    local friend = FindUnitsInRadius(caster:GetTeamNumber(), 
    caster:GetOrigin(), 
    nil, 
    2000,
    DOTA_UNIT_TARGET_TEAM_FRIENDLY, 
    target_types, 
    target_flags, 
    0, 
    true)

    local count = 0
    local namelist = {}
    for k,v in pairs(friend) do
        if v:GetUnitLabel()=="qunxiong" or v:GetUnitLabel()=="xiliang"
        and not namelist[v:GetUnitName()]  then
            namelist[v:GetUnitName()]=true
            count = count + 1
        end
  
    end
    self.count = count
    for k,v in pairs(friend) do 
    if  not v:IsRangedAttacker()  then
    local mod=v:AddNewModifier(caster, self, 'modifier_skill_hero_baonue', {})
    mod:SetStackCount(count) 
 --   v:AddNewModifier(caster, self, 'modifier_skill_hero_baonue_kill', {})
    end
end

end

modifier_skill_hero_baonue=class({})

function modifier_skill_hero_baonue:DeclareFunctions()
    return{
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }
end

function modifier_skill_hero_baonue:OnAttackLanded(keys)

	if IsServer() then
		local parent = self:GetParent()
		local target = keys.target
        local caster=self:GetCaster()
        if parent ~= keys.attacker  
        or target:IsBuilding() 
        or target:IsIllusion() 
        or target:GetTeam() == parent:GetTeam()
        then return 
        end
        if  parent:IsRangedAttacker() then return end

        local ability = self:GetAbility()
        local damage  = keys.damage
        local count   = self:GetStackCount()*5/100
        local healre  = damage*count
 
        parent:Heal(healre, parent)
     --   caster:Heal(healre*2, parent)
     SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, parent, healre, nil)
     
		local lifesteal_particle = "particles/generic_gameplay/generic_lifesteal.vpcf"
		local lifesteal_pfx = ParticleManager:CreateParticle(lifesteal_particle, PATTACH_ABSORIGIN_FOLLOW, parent)
		ParticleManager:SetParticleControl(lifesteal_pfx, 0, parent:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(lifesteal_pfx)
	end
end

--[[ modifier_skill_hero_baonue_kill=class({})

function modifier_skill_hero_baonue_kill:DeclareFunctions()
    return{
        MODIFIER_EVENT_ON_TAKEDAMAGE
    }
end

function modifier_skill_hero_baonue_kill:OnTakeDamage(keys)
    local attacker=keys.attacker
    local victim=keys.unit
    local parent = self:GetParent()
    if not IsServer() then return  end
   if attacker~=parent  then  return end
    print(keys.damage)
    if attacker.damage>=victim:GetHealth() then
    attacker:Heal(victim:GetMaxHealth()*15/100, attacker)
    SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, attacker, victim:GetMaxHealth()*15/100, nil) ]]
end
end ]]