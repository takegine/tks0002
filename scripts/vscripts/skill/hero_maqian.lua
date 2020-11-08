
LinkLuaModifier("modifier_madai_yiji",'skill/hero_maqian.lua',0)

skill_hero_maqian=class({})

function skill_hero_maqian:needwaveup()
    local caster=self:GetCaster()

    local owner =caster:XinShi()

if  owner.ship['yiji']  then   --如果存在一骑当千的羁绊 增加攻速
    caster:AddNewModifier(caster, self, "modifier_madai_yiji", {})
end
end


modifier_madai_yiji=class({})

function modifier_madai_yiji:IsHidden()
    return true 
end

function modifier_madai_yiji:DeclareFunctions()
    return{
    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
end

function modifier_madai_yiji:GetModifierAttackSpeedBonus_Constant() 
	local ability = self:GetAbility()
    return  ability:GetLevel()*5
end