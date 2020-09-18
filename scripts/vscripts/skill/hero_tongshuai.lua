LinkLuaModifier('modifier_skill_hero_tongshuai', 'skill/hero_tongshuai.lua', 0)
LinkLuaModifier('modifier_skill_hero_tongshuai_agi', 'skill/hero_tongshuai.lua', 0)

skill_hero_tongshuai=class({})

function skill_hero_tongshuai:GetIntrinsicModifierName()
	return "modifier_skill_hero_tongshuai"
end

modifier_skill_hero_tongshuai=class({})

function modifier_skill_hero_tongshuai:DestroyOnExpire()	return false end
function modifier_skill_hero_tongshuai:IsHidden()			return self:GetStackCount() <= 0 end
function modifier_skill_hero_tongshuai:IsPurgable()			return false end
function modifier_skill_hero_tongshuai:RemoveOnDeath()		return false end


function modifier_skill_hero_tongshuai:OnCreated()
	local ability	= self:GetAbility()
	local caster		= self:GetCaster()
	local parent		= self:GetParent()
	local stacks = (caster:GetModifierStackCount("modifier_skill_hero_tongshuai_agi", nil)) 
	if not IsServer() then 
		return 
	end
end

function modifier_skill_hero_tongshuai:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
end

function modifier_skill_hero_tongshuai:OnAttackLanded(keys)
	if self:GetAbility():IsTrained() and 
	keys.attacker == self:GetParent() and 
	not self:GetParent():PassivesDisabled() and 
	not self:GetParent():IsIllusion() and 
	(keys.target:IsRealHero() or keys.target:IsClone()) and
	 not keys.target:IsTempestDouble() then
		local caster   = self:GetCaster()
		local ability = self:GetAbility()
		local duration = 15
		local ability = self:GetAbility()
		caster:AddNewModifier(caster, ability, "modifier_skill_hero_tongshuai_agi", {duration = duration, agi = ability:GetSpecialValueFor("agi_gain")})
	end
end

modifier_skill_hero_tongshuai_agi = class({})

function modifier_skill_hero_tongshuai_agi:IsDebuff()			return false end
function modifier_skill_hero_tongshuai_agi:IsHidden() 		return false end
function modifier_skill_hero_tongshuai_agi:IsPurgable() 		return false end
function modifier_skill_hero_tongshuai_agi:IsPurgeException()	return false end

function modifier_skill_hero_tongshuai_agi:DeclareFunctions() 
	return {MODIFIER_PROPERTY_STATS_AGILITY_BONUS} 
end

function modifier_skill_hero_tongshuai_agi:OnCreated(keys)
	if IsServer() then
		self.agi_table = {}
		self:AddStack(keys.agi)
		self:StartIntervalThink(0.1)
	end
end

function modifier_skill_hero_tongshuai_agi:OnRefresh(keys)
	if IsServer() then
		self:AddStack(keys.agi)
	end
end

function modifier_skill_hero_tongshuai_agi:AddStack(iStack)
	if not self.agi_table[GameRules:GetGameTime()] then
		self.agi_table[GameRules:GetGameTime()] = iStack
	else
		self.agi_table[GameRules:GetGameTime() + RandomFloat(0.0000000001, 0.0001)] = iStack
	end
end

function modifier_skill_hero_tongshuai_agi:OnIntervalThink()
	local stacks = 0
	for k, v in pairs(self.agi_table) do
		if k + self:GetDuration() < GameRules:GetGameTime() then
			self.agi_table[k] = nil
		else
			stacks = stacks + v
		end
	end
	self:SetStackCount(stacks)
end

function modifier_skill_hero_tongshuai_agi:OnDestroy() self.agi_table = nil end

function modifier_skill_hero_tongshuai_agi:GetModifierBonusStats_Agility() 
	return self:GetParent():PassivesDisabled() and 0 or self:GetStackCount() 
end