LinkLuaModifier('modifier_skill_hero_tiandu', 'skill/hero_tiandu.lua', 0)
LinkLuaModifier('modifier_skill_hero_tiandu_buff', 'skill/hero_tiandu.lua', 0)
LinkLuaModifier('modifier_skill_hero_tiandu_debuff', 'skill/hero_tiandu.lua', 0)
LinkLuaModifier('modifier_skill_hero_tiandu_auto_cast', 'skill/hero_tiandu.lua', 0)
LinkLuaModifier('modifier_skill_hero_tiandu_unstun', 'skill/hero_tiandu.lua', 0)

skill_hero_tiandu=class({})

modifier_skill_hero_tiandu = class({})
modifier_skill_hero_tiandu_buff = class({})
modifier_skill_hero_tiandu_debuff = class({})
modifier_skill_hero_tiandu_auto_cast = class({})

function skill_hero_tiandu:OnSpellStart()

    local caster = self:GetCaster()
	local ability = self
    local target = self:GetCursorTarget()
    local radius = self:GetLevelSpecialValueFor("radius", self:GetLevel()-1)
    local owner   = caster:GetOwner() or {ship={}}
	local modifier_armor = "modifier_skill_hero_tiandu_buff"
    local armor_duration = ability:GetSpecialValueFor("armor_duration")
    local target_team  = self:GetAbilityTargetTeam()
	local target_types = self:GetAbilityTargetType()
    local target_flags = self:GetAbilityTargetFlags()

    target:AddNewModifier(caster, ability, modifier_armor, {duration = armor_duration})

    if owner.ship['weishi'] then
    -- local parent = self:GetParent()
    local units = FindUnitsInRadius(target:GetTeamNumber(),
                                    target:GetOrigin(),
                                    nil,
                                    200,
                                    DOTA_UNIT_TARGET_TEAM_ENEMY,
                                    target_types,
                                    target_flags,
                                    0,
                                    true)
                        
        for key,target in pairs(units) do
            target:AddNewModifier(caster,ability,"modifier_skill_hero_tiandu_unstun",{Duration=2.5})

            -- if target:IsMagicImmune() then
			--    return 
            -- end
        end 
    end 
end 

modifier_skill_hero_tiandu_unstun=class({})  ---眩晕buff

function modifier_skill_hero_tiandu_unstun:GetEffectName()
    return "particles/econ/items/winter_wyvern/winter_wyvern_ti7/wyvern_cold_embrace_ti7buff.vpcf"
end

function modifier_skill_hero_tiandu_unstun:IsHidden ()
    return true
end

function modifier_skill_hero_tiandu_unstun:IsDebuff()
	return  true
end

function modifier_skill_hero_tiandu_unstun:IsStunDebuff()
	return  true
end

function modifier_skill_hero_tiandu_unstun:CheckState()
    local state = {
    [MODIFIER_STATE_STUNNED]=true,
}      return state
end

function modifier_skill_hero_tiandu_buff:OnCreated()
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.modifier_armor_debuff = "modifier_skill_hero_tiandu_debuff"

	local armor_bonus = self.ability:GetSpecialValueFor("armor_bonus")
    local frost_duration = self.ability:GetSpecialValueFor("frost_duration")

end

function modifier_skill_hero_tiandu_buff:IsHidden() return false end
function modifier_skill_hero_tiandu_buff:IsDebuff() return false end

function modifier_skill_hero_tiandu_buff:GetEffectName()
    return "particles/econ/items/lanaya/ta_ti9_immortal_shoulders/ta_ti9_refraction.vpcf"
end

function modifier_skill_hero_tiandu_buff:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_EVENT_ON_ATTACK_LANDED}

	return decFuncs
end

function modifier_skill_hero_tiandu_buff:GetModifierPhysicalArmorBonus()
    local ability=self:GetAbility()
    local armor_bonus = ability:GetSpecialValueFor('armor_bonus')
    -- self.armor_bonus = self.ability:GetSpecialValueFor("armor_bonus")
	-- self.frost_duration = self.ability:GetSpecialValueFor("frost_duration")
    return  armor_bonus
end

function modifier_skill_hero_tiandu_buff:OnAttackLanded(keys)
	local attacker = keys.attacker
    local target = keys.target
    
    if target == self.parent and target:GetTeamNumber() ~= attacker:GetTeamNumber() then
        if attacker:IsRangedAttacker()then 
            return  
        end

		if attacker:IsMagicImmune() then
			return 
        end

        local modifier_debuff_handler

		if not attacker:HasModifier(self.modifier_armor_debuff) then
			modifier_debuff_handler = attacker:AddNewModifier(self.caster, self.ability, self.modifier_armor_debuff, {duration = 5})
        end
    end
end

function modifier_skill_hero_tiandu_debuff:OnCreated()

	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.ms_slow_pct = self.ability:GetSpecialValueFor("ms_slow_pct")
	self.as_slow = self.ability:GetSpecialValueFor("as_slow")
end

function modifier_skill_hero_tiandu_debuff:IsHidden() return false end
function modifier_skill_hero_tiandu_debuff:IsPurgable() return true end
function modifier_skill_hero_tiandu_debuff:IsDebuff() return true end

function modifier_skill_hero_tiandu_debuff:GetStatusEffectName()
	return "particles/status_fx/status_effect_frost.vpcf"
end

function modifier_skill_hero_tiandu_debuff:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT}

	return decFuncs
end

function modifier_skill_hero_tiandu_debuff:GetModifierMoveSpeedBonus_Percentage()
	return self.ms_slow_pct * (-1)
end

function modifier_skill_hero_tiandu_debuff:GetModifierAttackSpeedBonus_Constant()
	return self.as_slow * (-1)
end


-- function modifier_skill_hero_tiandu_auto_cast:OnCreated()
-- 	self.caster = self:GetCaster()
-- 	self.ability = self:GetAbility()
-- 	self.modifier_frost_armor = "modifier_skill_hero_tiandu_buff"
-- 	self.autocast_radius = self.ability:GetSpecialValueFor("autocast_radius")
-- end

-- function modifier_skill_hero_tiandu_auto_cast:DeclareFunctions()
-- 	local decFuncs = {MODIFIER_EVENT_ON_ATTACK,
-- 		MODIFIER_EVENT_ON_RESPAWN}
-- 	return decFuncs
-- end

-- -- function modifier_skill_hero_tiandu_auto_cast:OnRespawn(keys)
-- -- 	-- 只适用于施法者本身的单位
-- -- 	if keys.unit == self.caster then
-- -- 		self.caster:AddNewModifier(self.caster, self.ability, self.modifier_frost_armor, {})
-- -- 	end
-- -- end

-- function modifier_skill_hero_tiandu_auto_cast:OnAttack(keys)
-- 	local target = keys.target

-- 	if not self.ability:GetAutoCastState() then
-- 		return 
-- 	end


-- 	if self.caster:GetTeamNumber() ~= target:GetTeamNumber() then
-- 		return 
-- 	end

-- 	-- if self.caster:IsChanneling() then
-- 	-- 	return 
-- 	-- end

-- 	local distance = (self.caster:GetAbsOrigin() - target:GetAbsOrigin()):Length2D()
-- 	if distance > self.autocast_radius then
-- 		return 
-- 	end

-- 	if target:HasModifier(self.modifier_frost_armor) then
-- 		return 
-- 	end

-- 	if not self.ability:IsCooldownReady() then
-- 		return 
-- 	end

-- 	self.caster:CastAbilityOnTarget(target, self.ability, self.caster:GetPlayerID())
-- end

-- function modifier_skill_hero_tiandu_auto_cast:IsHidden() return true end
-- function modifier_skill_hero_tiandu_auto_cast:IsPurgable() return false end
-- function modifier_skill_hero_tiandu_auto_cast:RemoveOnDeath() return false end