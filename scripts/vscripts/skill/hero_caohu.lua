skill_hero_caohu = {}


function skill_hero_caohu:needwaveup()
    local caster = self:GetCaster()
    local owner = caster:XinShi()
    if owner.ship['huben'] then
        caster:AddNewModifier(caster, self, "modifier_hero_caohu", nil)
    end
end




LinkLuaModifier("modifier_hero_caohu", "skill/hero_caohu.lua", 0)
modifier_hero_caohu= {}
function modifier_hero_caohu:DeclareFunctions()
    return {MODIFIER_PROPERTY_EVASION_CONSTANT}
end

function modifier_hero_caohu:GetModifierEvasion_Constant()
    return self:GetAbility():GetSpecialValueFor("chance")
end