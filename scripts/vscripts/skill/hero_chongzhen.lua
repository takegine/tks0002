

LinkLuaModifier("modifier_skill_hero_chongzhen_unstun",'skill/hero_chongzhen.lua',0)
LinkLuaModifier("modifier_skill_hero_chongzhen_heal",'skill/hero_chongzhen.lua',0)

skill_hero_chongzhen=class({})


function skill_hero_chongzhen:GetIntrinsicModifierName()
	return "modifier_skill_hero_chongzhen_heal"
end


modifier_skill_hero_chongzhen_heal=class({})

function  modifier_skill_hero_chongzhen_heal:DeclareFunctions()
	return{
		MODIFIER_EVENT_ON_ATTACK_LANDED
}
end

function modifier_skill_hero_chongzhen_heal:OnAttackLanded(keys)
    local parent = self:GetParent()
	local caster=self:GetCaster()
	local ability=self:GetAbility()
	local heal=ability:GetSpecialValueFor('heal')*keys.damage/100
 	local owner  = caster:GetOwner() or {ship={}}  
 	local target=keys.target 

	if keys.attacker == parent
	and keys.original_damage/parent:GetAverageTrueAttackDamage( keys.target )>1.05 then

	if caster:GetItemInSlot(3) and caster:GetItemInSlot(3):GetName()=='item_horses_bailong' then

		heal=heal*1.5
	end
	caster:Heal(heal,caster)

	SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, parent, heal, nil)

	if owner.ship['wuhu']  then

	target:AddNewModifier(target,ability,"modifier_skill_hero_chongzhen_unstun",{Duration=1})
		
	end
    end
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
