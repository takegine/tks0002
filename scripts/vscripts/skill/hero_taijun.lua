LinkLuaModifier("modifier_skill_hero_taijun",'skill/hero_taijun.lua',0)

skill_hero_taijun=class({})

function skill_hero_taijun:needwaveup()

    local ability=self
	local caster=self:GetCaster()
    local owner =caster:XinShi()

    caster:AddNewModifier(caster,ability,'modifier_skill_hero_taijun', {})
end


modifier_skill_hero_taijun=class({})   --减免伤害

function modifier_skill_hero_taijun:DeclareFunctions()
    return 
    {
    MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK
}
end 

function modifier_skill_hero_taijun:GetModifierPhysical_ConstantBlock()
    local ability=self:GetAbility()
    return  ability:GetLevel()*130
end
