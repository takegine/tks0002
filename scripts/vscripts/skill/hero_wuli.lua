LinkLuaModifier('modifier_skill_hero_wuli', 'skill/hero_wuli.lua', 0)
LinkLuaModifier('modifier_skill_hero_wuli_stre', 'skill/hero_wuli.lua', 0)

skill_hero_wuli=class({})

function skill_hero_wuli:GetIntrinsicModifierName()
	return "modifier_skill_hero_wuli"
end

modifier_skill_hero_wuli=class({})

function modifier_skill_hero_wuli:DestroyOnExpire()	return false end
function modifier_skill_hero_wuli:IsHidden()			return self:GetStackCount() <= 0 end
function modifier_skill_hero_wuli:IsPurgable()			return false end
function modifier_skill_hero_wuli:RemoveOnDeath()		return false end


function modifier_skill_hero_wuli:OnCreated()
	local ability	= self:GetAbility()
	local caster		= self:GetCaster()
	local parent		= self:GetParent()
	local stacks = (caster:GetModifierStackCount("modifier_skill_hero_wuli_stre", nil)) 
	if not IsServer() then 
		return 
	end	
end

function modifier_skill_hero_wuli:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
end

function modifier_skill_hero_wuli:OnAttackLanded(keys)
    local target   = keys.unit
    local attacker = keys.attacker
	local parent   = self:GetParent()
	local ability =self:GetAbility() 

	if self:GetAbility():IsCooldownReady() and 
		not self:GetCaster():PassivesDisabled() 
		and ((keys.target == self:GetParent() 
		and not keys.attacker:IsOther() 
		and keys.attacker:GetTeamNumber() ~= keys.target:GetTeamNumber()) or (keys.attacker == self:GetCaster())) then
		local caster   = self:GetCaster()
		local duration = 15
		if ability.firetime
		and ability.firetime - GameRules:GetGameTime()> -0.5 then
			return false
		else
		ability.firetime = GameRules:GetGameTime()
			return 		caster:AddNewModifier(caster, ability, "modifier_skill_hero_wuli_stre", {duration = duration, stre = ability:GetSpecialValueFor("stre_gain")})
		end

	end
end

modifier_skill_hero_wuli_stre = class({})

function modifier_skill_hero_wuli_stre:IsDebuff()			return false end
function modifier_skill_hero_wuli_stre:IsHidden() 		return false end
function modifier_skill_hero_wuli_stre:IsPurgable() 		return false end
function modifier_skill_hero_wuli_stre:IsPurgeException()	return false end

function modifier_skill_hero_wuli_stre:DeclareFunctions() 
	return {MODIFIER_PROPERTY_STATS_STRENGTH_BONUS} 
end

function modifier_skill_hero_wuli_stre:OnCreated(keys)
	if IsServer() then
		self.stre_table = {}
		self:AddStack(keys.stre)
		self:StartIntervalThink(0.1)
	end
end

function modifier_skill_hero_wuli_stre:OnRefresh(keys)
	if IsServer() then
		self:AddStack(keys.stre)
	end
end

function modifier_skill_hero_wuli_stre:AddStack(iStack)
	if not self.stre_table[GameRules:GetGameTime()] then
		self.stre_table[GameRules:GetGameTime()] = iStack
	else
		self.stre_table[GameRules:GetGameTime() + RandomFloat(0.0000000001, 0.0001)] = iStack
	end
end

function modifier_skill_hero_wuli_stre:OnIntervalThink()
	local stacks = 0
	for k, v in pairs(self.stre_table) do
		if k + self:GetDuration() < GameRules:GetGameTime() then
			self.stre_table[k] = nil
		else
			stacks = stacks + v
		end
	end
	self:SetStackCount(stacks)
end

function modifier_skill_hero_wuli_stre:OnDestroy() self.stre_table = nil end

function modifier_skill_hero_wuli_stre:GetModifierBonusStats_Strength() 
	return self:GetParent():PassivesDisabled() and 0 or self:GetStackCount() 
end