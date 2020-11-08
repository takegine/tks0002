
LinkLuaModifier("modifier_skill_hero_longdan",'skill/hero_longdan.lua',0)
LinkLuaModifier("modifier_skill_hero_longdan_unstun",'skill/hero_longdan.lua',0)
LinkLuaModifier("modifier_skill_hero_longdan_addspeed",'skill/hero_longdan.lua',0)

skill_hero_longdan = class({})  --声明技能


function skill_hero_longdan:GetIntrinsicModifierName()  --声明技能实践  技能释放
	 return "modifier_skill_hero_longdan"
end


modifier_skill_hero_longdan_unstun=class({})  ---眩晕buff

function modifier_skill_hero_longdan_unstun:IsHidden()
	return true
end

function modifier_skill_hero_longdan_unstun:IsDebuff()
	return  true
end

function modifier_skill_hero_longdan_unstun:IsStunDebuff()
	return  true
end
function modifier_skill_hero_longdan_unstun:CheckState()
    local state = {
    [MODIFIER_STATE_STUNNED]=true,
}      return state
end

modifier_skill_hero_longdan_addspeed=class({}) 

function modifier_skill_hero_longdan_addspeed:IsHidden()
	return true
end

function modifier_skill_hero_longdan_addspeed:DeclareFunctions()
	return{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end

function modifier_skill_hero_longdan_addspeed:GetModifierMoveSpeedBonus_Percentage()
	return 100
end


modifier_skill_hero_longdan=class({})  

function modifier_skill_hero_longdan:IsHidden()
    return true
end

function modifier_skill_hero_longdan:DeclareFunctions()
	return{
	MODIFIER_EVENT_ON_ATTACK_FAIL,
    MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
	MODIFIER_PROPERTY_EVASION_CONSTANT
}
end

function modifier_skill_hero_longdan:GetModifierPreAttack_CriticalStrike()
	local ability=self:GetAbility()
	local chance =ability:GetSpecialValueFor('chance')
	return RollPercentage(chance) and 200 or 0
end

function modifier_skill_hero_longdan:GetModifierEvasion_Constant()
	local ability=self:GetAbility()
    local chance=ability:GetLevelSpecialValueFor('chance',ability:GetLevel()-1)
    return chance		
end	

function modifier_skill_hero_longdan:OnAttackFail(keys)

	local caster=self:GetCaster()
	local attacker=keys.attacker
	local ability=self:GetAbility()
    local chance=ability:GetLevelSpecialValueFor('chance',ability:GetLevel()-1)
	local heal=ability:GetSpecialValueFor('heal')*keys.damage/100
	local owner  = caster:XinShi()
	
	if keys.target~=caster then return end

	if owner.ship['longyue'] then
	attacker:AddNewModifier(attacker,ability,"modifier_skill_hero_longdan_unstun",{Duration=1})
	end

	if owner.ship['qijin']  then
	caster:AddNewModifier(caster,ability,"modifier_skill_hero_longdan_addspeed",{Duration=3})
	caster:Heal(heal,caster)
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, caster, heal, nil)
	end

end



modifier_skill_hero_longdan_baoji=class({}) --暴击伤害

function modifier_skill_hero_longdan_baoji:IsHidden()
	return true
end

function modifier_skill_hero_longdan_baoji:DeclareFunctions()
	return{
	MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
	MODIFIER_EVENT_ON_ATTACK_FINISHED
}
end

function modifier_skill_hero_longdan_baoji:GetModifierPreAttack_CriticalStrike()
	return 200
end

function modifier_skill_hero_longdan_baoji:OnAttackFinished() 
	local caster=self:GetCaster()
	caster:RemoveModifierByName("modifier_skill_hero_longdan_baoji")
end

