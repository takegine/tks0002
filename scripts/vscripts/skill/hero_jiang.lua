
LinkLuaModifier("modifier_skill_hero_jiang_juedou",'skill/hero_jiang.lua',0)
LinkLuaModifier("modifier_skill_hero_jiang_attack",'skill/hero_jiang.lua',0)


skill_hero_jiang=class({})

function skill_hero_jiang:GetIntrinsicModifierName()
	return "modifier_skill_hero_jiang_attack"
end

modifier_skill_hero_jiang_attack=class({})

function modifier_skill_hero_jiang_attack:DeclareFunctions()
    return {
    MODIFIER_EVENT_ON_ATTACK_LANDED
}
end

function modifier_skill_hero_jiang_attack:OnAttackLanded(keys)

    local ability=self:GetAbility()
    local parent=self:GetParent()
	local caster=self:GetCaster()
    local heal=keys.damage*ability:GetLevel()*3/100
    local modName = 'modifier_skill_hero_jiang_juedou'
    if  keys.attacker == parent  and keys.original_damage/parent:GetAverageTrueAttackDamage( keys.target )>1.05 
    then
    caster:AddNewModifier(caster, ability, modName,{})  
    caster:Heal(heal,caster)    
   end
end



modifier_skill_hero_jiang_juedou=class({})   --决斗加攻击

function modifier_skill_hero_jiang_juedou:IsHidden()
    return true 
end

function modifier_skill_hero_jiang_juedou:DeclareFunctions()
    return {        
        MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE
    }
end

function modifier_skill_hero_jiang_juedou:GetModifierDamageOutgoing_Percentage()
    local ability=self:GetAbility()
    return  ability:GetLevel()*3+15
end
