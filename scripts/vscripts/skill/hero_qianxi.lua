
LinkLuaModifier("modifier_attack", "skill/hero_qianxi.lua",LUA_MODIFIER_MOTION_NONE)

skill_hero_qianxi = class({})  --声明技能

function skill_hero_qianxi:GetIntrinsicModifierName()  --声明技能实践  技能释放
return "modifier_attack"
end


modifier_attack=class({})

function modifier_attack:DeclareFunctions()
	return {
	MODIFIER_EVENT_ON_ATTACK_LANDED
}
end

function modifier_attack:OnAttackLanded(keys)   

	local  parent=self:GetParent()  --获取技能释放者
	local  target=keys.target  --获取鼠标选择的技能目标
    local  owner =parent:GetOwner() or {ship={}}

if keys.attacker ~= parent then
	return
end

--  kv里面的概率
	local ability      =self:GetAbility()
    local chance       =ability:GetLevelSpecialValueFor("chance", (ability:GetLevel()-1) )
    local damage_type  =ability:GetAbilityDamageType()
    local target_types =ability:GetAbilityTargetType()
    local target_flags =ability:GetAbilityTargetFlags()  --标识 



 if  owner.ship['shuigan'] and target:GetHealthPercent()>75 then

     chance = 100
 end    


 if RollPercentage(chance) then
		    local  damagetable={     --伤害表
		    victim=target,    --技能目标
		    attacker=parent,  --释放者
		    damage=target:GetHealth()*0.17,    --伤害
		    damage_type=damage_type   --伤害类型  物理
		}
 
		ApplyDamage(damagetable)  	
	 end
	
end


modifier_yiji=class({})   --声明修饰器

function modifier_yiji:IsDebuff()  --判断是否为debuff
	return  false
end

function modifier_yiji:DeclareFunction()
	return {
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}	
end

--function modifier_yiji:GetModifierAttackSpeedBonus_Constant() 
	--local ability = self:GetAbility()
	--return ability:GetLevel()*5
--end




