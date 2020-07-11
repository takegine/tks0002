skill_hero_kuanggu = skill_hero_kuanggu or {}
    
function skill_hero_kuanggu:GetBehavior()
    return DOTA_ABILITY_BEHAVIOR_PASSIVE
end

function skill_hero_kuanggu:GetIntrinsicModifierName()
	return "modifier_skill_hero_kuanggu"
end

function skill_hero_kuanggu:GetAbilityDamageType()
	return DAMAGE_TYPE_PHYSICAL
end

function skill_hero_kuanggu:GetAbilityTargetTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function skill_hero_kuanggu:GetAbilityTargetType()
	return DOTA_UNIT_TARGET_ALL
end

function skill_hero_kuanggu:needwaveup()

    local caster  = self:GetCaster()
    local owner   = caster:GetOwner() or {ship={}}
    local count   = 0

    if  owner.ship['shawo'] then
        count = 10
    end
    
    caster:SetModifierStackCount( self:GetIntrinsicModifierName(), caster , count) 
end

LinkLuaModifier( "modifier_skill_hero_kuanggu","skill/hero_kuanggu", LUA_MODIFIER_MOTION_NONE )
modifier_skill_hero_kuanggu = modifier_skill_hero_kuanggu or {}

function modifier_skill_hero_kuanggu:DeclareFunctions()	
    return 
    { 
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,--百分比增长攻速
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_EVENT_ON_TAKEDAMAGE_KILLCREDIT,
        MODIFIER_EVENT_ON_HERO_KILLED,
        MODIFIER_EVENT_ON_HEAL_RECEIVED
        --MODIFIER_EVENT_ON_HEALTH_GAINED
    } 
end
function modifier_skill_hero_kuanggu:GetModifierAttackSpeedBonus_Constant(params)	
    return 15*self:GetStackCount() 
end

function modifier_skill_hero_kuanggu:OnAttackLanded( params)

    local parent = self:GetParent()

    if params.attacker ~= parent 
    then return
    end

    if  self:GetStackCount() < 10 then
        self:IncrementStackCount()
    end
    -- self:SetStackCount( Clamp(self:GetStackCount()+1, 0 ,10) )--功能相同
end



function modifier_skill_hero_kuanggu:OnTakeDamageKillCredit( params)

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
        if  not owner.ship['shawo'] then
            self:SetStackCount(0)
        end

        local heallvl  = ability:GetLevelSpecialValueFor("heallvl", ability:GetLevel()-1) /100
        local backheal = heallvl *target:GetMaxHealth()
        parent:Heal( backheal, parent)
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, parent, backheal, nil)
    end
end

function modifier_skill_hero_kuanggu:OnHeroKilled( params)
    
    local parent   = self:GetParent()
    local ability  = self:GetAbility()
    local radius   = ability:GetSpecialValueFor("radius")
    local heallvl  = ability:GetLevelSpecialValueFor("heallvl", ability:GetLevel()-1) /100
    local owner    = parent:GetOwner() or {ship={}}
    local unit     = params.unit
    local attacker = params.attacker
    local target   = params.target

    if unit == parent then
        if not owner.ship['shawo'] then
            self:SetStackCount(0)
        end

        local backheal = heallvl *target:GetMaxHealth() 
        parent:Heal( backheal, parent)
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, parent, backheal, nil)

    elseif owner.ship['shawo'] and (target:GetOrigin()-parent:GetOrigin()):Length2D() <= 300 then

        local backheal = heallvl *target:GetMaxHealth()  *4 *ability:GetLevel() /100
        parent:Heal( backheal, parent)
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, parent, backheal, nil)
    end
end

function modifier_skill_hero_kuanggu:OnHealReceived( params)
    
    
    local parent   = self:GetParent()
    local owner    = parent:GetOwner() or {ship={}}
    local unit     = params.unit
    local heal     = params.gain
    
    if not owner.ship['shawo'] 
    or not IsServer()
    or unit ~= parent
    or heal <= parent:GetHealthRegen()
    then return
    end
    
    local damage   = heal *0.45
    local ability  = self:GetAbility()
    local damage_type  = ability:GetAbilityDamageType()
    local target_team  = ability:GetAbilityTargetTeam()
    local target_types = ability:GetAbilityTargetType()
    local target_flags = ability:GetAbilityTargetFlags()
    local radius = ability:GetSpecialValueFor("radius_ship")
    local pfxname= "particles/econ/items/brewmaster/brewmaster_offhand_elixir/brewmaster_thunder_clap_elixir.vpcf"
    local clap_particle = ParticleManager:CreateParticle( pfxname, PATTACH_ABSORIGIN_FOLLOW, parent)
	ParticleManager:SetParticleControl(clap_particle, 1, Vector(radius, radius, radius))
	ParticleManager:ReleaseParticleIndex(clap_particle)

    local damage_table ={}
    damage_table.attacker     = parent
    damage_table.damage_type  = damage_type
    damage_table.ability      = ability
    damage_table.damage       = damage
    damage_table.damage_flags = DOTA_DAMAGE_FLAG_NONE
    
    local enemy = FindUnitsInRadius(parent:GetTeamNumber(), 
                                    parent:GetOrigin(), 
                                    nil, 
                                    radius,
                                    target_team,
                                    target_types, 
                                    target_flags, 
                                    0, 
                                    true)

    for k,v in pairs(enemy) do
        damage_table.victim = v
        ApplyDamage(damage_table)
    end
end

function modifier_skill_hero_kuanggu:OnHealthGained( params)
    
    local parent   = self:GetParent()
    local owner    = parent:GetOwner() or {ship={}}
    local unit     = params.unit

    -- if not owner.ship['shawo'] 
    -- or not IsServer()
    if unit ~= parent 
    then return
    end
    
    self.paramstable = self.paramstable or {}
    table.foreach(params, function(k,v)
        if  self.paramstable[k] ~= v then
            print("OnHealReceived",k,v, IsServer())
            self.paramstable[k] = v
        end
    end)

end