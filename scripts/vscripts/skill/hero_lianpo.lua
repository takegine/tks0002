LinkLuaModifier('modifier_lianpo_thinker_jiansu', 'skill/hero_lianpo.lua', 0)
LinkLuaModifier('modifier_lianpo_jiansu', 'skill/hero_lianpo.lua', 0)

skill_hero_lianpo=class({})

function skill_hero_lianpo:GetAOERadius()
	return 960
end

function skill_hero_lianpo:OnSpellStart()
    local caster = self:GetCaster()
    local ability = self 
    local duration = ability:GetSpecialValueFor("duration")
    local point = self:GetCursorPosition()
    -- local parent = self:GetParent()  
	CreateModifierThinker(caster, self, "modifier_lianpo_thinker_jiansu", {duration = duration}, self:GetCursorPosition(), caster:GetTeamNumber(), false)
end

modifier_lianpo_thinker_jiansu = modifier_lianpo_thinker_jiansu or {
    IsHidden = on,
    IsAura = on,
    IsAuraActiveOnDeath = off,
    IsDebuff = off,
    GetAuraDuration = function () return 0.1 end,
    GetAuraRadius = function (self ) return self.radius end,
    GetModifierAura = function () return "modifier_lianpo_jiansu" end,
    GetAuraSearchTeam = function () return DOTA_UNIT_TARGET_TEAM_ENEMY end,
    GetAuraSearchType = function ()	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end,
    GetAuraSearchFlags = function () return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES end,
    OnCreated = function (self , data)
        if not IsServer() then return end
        local ability = self:GetAbility() 
        self.radius = ability:GetSpecialValueFor("radius")
        if not ability then self:Destroy() return end
        
        local movespeed	= ability:GetSpecialValueFor("movespeed")
        
            
        self.magnetic_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_arc_warden/arc_warden_magnetic.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
        ParticleManager:SetParticleControl(self.magnetic_particle, 1, Vector(self.radius, 1, 1))
        self:AddParticle(self.magnetic_particle, false, false, 1, false, false)
    end,
    OnDestroy = function (self , data)
        if not IsServer() then return end
    end,
}


modifier_lianpo_jiansu = modifier_lianpo_jiansu or {
    IsDebuff = on,
    IsHidden = off,
    IsPurgable = off,
    IsBuff = off,
    RemoveOnDeath = on,
}
function modifier_lianpo_jiansu:OnCreated()
    local ability = self:GetAbility()

    self.flux_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_arc_warden/arc_warden_flux_tgt.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
    ParticleManager:SetParticleControlEnt(self.flux_particle, 2, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetAbsOrigin(), true)
    self:AddParticle(self.flux_particle, false, false, -1, false, false)

	if ability then
		local move_speed_bonus	= ability:GetSpecialValueFor("move_speed_bonus")
	elseif self:GetAuraOwner() and self:GetAuraOwner():HasModifier("modifier_lianpo_thinker_jiansu") then
		local move_speed_bonus	= self:GetAuraOwner():FindModifierByName("modifier_lianpo_thinker_jiansu").move_speed_bonus
	else
		self:Destroy()
    end
end

function modifier_lianpo_jiansu:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_EVENT_ON_TAKEDAMAGE
    }
end

function modifier_lianpo_jiansu:GetModifierMoveSpeedBonus_Percentage()
	return -60
end

function modifier_lianpo_jiansu:OnTakeDamage(keys)
    local target = keys.unit
    local parent = self:GetParent()
    if target == parent
    and not Isbitband(keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS)
    and self:GetAuraOwner():HasModifier("modifier_lianpo_thinker_jiansu") 
    and self:GetAuraOwner():FindModifierByName("modifier_lianpo_thinker_jiansu").radius
    then
        local caster = self:GetCaster()
        local ability = self:GetAbility()
        local original_damage = target.battleinfo.damage_take
        local damage = original_damage * 0.45
        -- target:SetHealth(target:GetHealth()-damage)
        if damage < target:GetHealth() then 
        target:ModifyHealth((target:GetHealth()-damage), ability, false, DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_NO_DIRECTOR_EVENT)
        else 
            return 
        print(target:GetHealth(),original_damage,damage)
        end
    end
end
