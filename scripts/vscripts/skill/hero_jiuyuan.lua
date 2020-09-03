
LinkLuaModifier("modifier_skill_hero_jiuyuan",'skill/hero_jiuyuan.lua',0)

skill_hero_jiuyuan=class({})

function skill_hero_jiuyuan:needwaveup()

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
        if v:GetUnitLabel()=="wuguo" 
        and not namelist[v:GetUnitName()] then
            namelist[v:GetUnitName()]=true
            count = count + 1
        end
        v:AddNewModifier(caster, self, 'modifier_skill_hero_jiuyuan', {duration=50})
    end
    self.count = count
print(count)

end

modifier_skill_hero_jiuyuan=class({})

function modifier_skill_hero_jiuyuan:DeclareFunctions()
    return{
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }
end

function modifier_skill_hero_jiuyuan:OnAttackLanded(keys)


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

        local ability = self:GetAbility()
        local damage  = keys.damage
        local count   = ability.count
		--local target_armor = 0.06 *target:GetPhysicalArmorValue(false)
        local healre  = damage*2*count/100 --* (1 - target_armor/(1+math.abs( target_armor)))
        

        parent:Heal(healre, parent)
     --   caster:Heal(healre*2, parent)

		local lifesteal_particle = "particles/generic_gameplay/generic_lifesteal.vpcf"
		local lifesteal_pfx = ParticleManager:CreateParticle(lifesteal_particle, PATTACH_ABSORIGIN_FOLLOW, parent)
		ParticleManager:SetParticleControl(lifesteal_pfx, 0, parent:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(lifesteal_pfx)
	end
end


