LinkLuaModifier("modifier_skill_hero_sunjun",'skill/hero_sunjun.lua',0)

skill_hero_sunjun=class({})

function skill_hero_sunjun:needwaveup()

    local ability=self
	local caster=self:GetCaster()
    local owner =caster:GetOwner() or {ship={}}
    if owner.ship['junzi'] then
    caster:AddNewModifier(caster,ability,'modifier_skill_hero_sunjun', {})
    end
end


modifier_skill_hero_sunjun=class({})   --减免伤害

function modifier_skill_hero_sunjun:DeclareFunctions()
    return 
    {
    MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK_SPECIAL
}
end 


function modifier_skill_hero_sunjun:GetModifierPhysical_ConstantBlockSpecial()
    local ability=self:GetAbility()
    return  ability:GetLevel()*130
end

function modifier_skill_hero_sunjun:IsHidden()
    return true
end