
LinkLuaModifier("modifier_skill_hero_chongzhen_onattacked",'skill/hero_chongzhen.lua',0)
LinkLuaModifier("modifier_skill_hero_chongzhen_baoji",'skill/hero_chongzhen.lua',0)
LinkLuaModifier("modifier_skill_hero_chongzhen_unstun",'skill/hero_chongzhen.lua',0)
LinkLuaModifier("modifier_skill_hero_chongzhen_addspeed",'skill/hero_chongzhen.lua',0)

skill_hero_chongzhen = class({})  --声明技能


 function skill_hero_chongzhen:GetIntrinsicModifierName()  --声明技能实践  技能释放
	 return "modifier_skill_hero_chongzhen_onattacked"
 end



modifier_skill_hero_chongzhen_unstun=class({})  ---眩晕buff

function modifier_skill_hero_chongzhen_unstun:IsDebuff()
	return  true
end

function modifier_skill_hero_chongzhen_unstun:IsStunDebuff()
	return  true
end
function modifier_skill_hero_chongzhen_unstun:CheckState()
    local state = {
    [MODIFIER_STATE_STUNNED]=true,
}      return state
end

modifier_skill_hero_chongzhen_addspeed=class({})  --闪避加移速

function modifier_skill_hero_chongzhen_addspeed:DeclareFunctions()
	return{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
}
end

function modifier_skill_hero_chongzhen_addspeed:GetModifierMoveSpeedBonus_Constant()
	return 100
end


modifier_skill_hero_chongzhen_onattacked=class({})  --被攻击触发事件

function modifier_skill_hero_chongzhen_onattacked:DeclareFunctions()
	return{
	MODIFIER_EVENT_ON_ATTACK_FAIL,
	MODIFIER_EVENT_ON_ATTACK_START,
	MODIFIER_PROPERTY_EVASION_CONSTANT
}
end

function modifier_skill_hero_chongzhen_onattacked:OnAttackStart(keys)
	local ability=self:GetAbility()
	local caster=self:GetCaster()
    local chance=ability:GetLevelSpecialValueFor('chance',ability:GetLevel()-1)
	if RollPercentage(chance) then

		if keys.attacker ~= caster then  --判断攻击者是否为赵云
			return
		end
		caster:AddNewModifier(caster,ability,"modifier_skill_hero_chongzhen_baoji",{})      
	end
end


function modifier_skill_hero_chongzhen_onattacked:GetModifierEvasion_Constant()
	local ability=self:GetAbility()
    local chance=ability:GetLevelSpecialValueFor('chance',ability:GetLevel()-1)
    return chance		
end	


function modifier_skill_hero_chongzhen_onattacked:OnAttackFail(keys)
	local caster=self:GetCaster()
	local attacker=keys.attacker
	local ability=self:GetAbility()
    local chance=ability:GetLevelSpecialValueFor('chance',ability:GetLevel()-1)
	local heal=ability:GetSpecialValueFor('heal')
	local owner  = caster:GetOwner() or {ship={}}
	
	if keys.target~=caster 
	then return
	end

	if owner.ship['longyue'] then
	attacker:AddNewModifier(attacker,ability,"modifier_skill_hero_chongzhen_unstun",{Duration=1})
	end

	if  owner.ship['qijin']  then
	caster:AddNewModifier(caster,ability,"modifier_skill_hero_chongzhen_addspeed",{Duration=3})
	caster:Heal(keys.damage*heal/100,caster)
	end


end



modifier_skill_hero_chongzhen_baoji=class({}) --暴击伤害

function modifier_skill_hero_chongzhen_baoji:DeclareFunctions()
	return{
	MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
	MODIFIER_EVENT_ON_ATTACK_LANDED
}
end

function modifier_skill_hero_chongzhen_baoji:GetModifierPreAttack_CriticalStrike()
	return 200
end
function modifier_skill_hero_chongzhen_baoji:OnAttackLanded() --攻击命中  移除修饰器

	local caster=self:GetCaster()
	local parent=self:GetParent()
	local owner =caster:GetOwner() or {ship{}}
	
	caster:RemoveModifierByName("modifier_skill_hero_chongzhen_baoji")

end

