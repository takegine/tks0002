LinkLuaModifier("modifier_skill_hero_dianfan", "skill/hero_dianfan.lua", 0)

skill_hero_dianfan = class({})


modifier_skill_hero_dianfan = class({})

-- function modifier_skill_hero_dianfan:GetStatusEffectName()
-- 	return "particles/status_fx/status_effect_life_stealer_rage.vpcf"
-- end

function skill_hero_dianfan:OnSpellStart()
    if IsServer() then
    local caster=self:GetCaster()
    local ability = self
    local duration = ability:GetSpecialValueFor("duration")
	self:GetCaster():Purge(false, true, false, false, false)
    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_skill_hero_dianfan", {duration = duration})
    end

    -- local dianfan_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_life_stealer/life_stealer_rage.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
	-- ParticleManager:SetParticleControlEnt(dianfan_particle, 2, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)
	-- self:AddParticle(dianfan_particle, false, false, 0, true, false)
end


function modifier_skill_hero_dianfan:OnRefresh()
    local caster=self:GetCaster()
    local ability = self
	self:OnCreated()
end

function modifier_skill_hero_dianfan:CheckState()
	return {
		[MODIFIER_STATE_MAGIC_IMMUNE] = true
	}
end


function modifier_skill_hero_dianfan:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	}
end

function modifier_skill_hero_dianfan:GetModifierBaseDamageOutgoing_Percentage()
    local ability=self:GetAbility()
    local atk_pct = ability:GetSpecialValueFor('atk_pct')
    return  atk_pct   
end

function modifier_skill_hero_dianfan:GetModifierExtraHealthPercentage()
    local ability=self:GetAbility()
    local hp_pct = ability:GetSpecialValueFor('hp_pct')
    return  hp_pct   
end

function modifier_skill_hero_dianfan:GetModifierPhysicalArmorBonus()
    local ability=self:GetAbility()
    local addarmor = ability:GetSpecialValueFor('addarmor')
    return  addarmor   
end

function modifier_skill_hero_dianfan:IsDebuff()
    return false
end