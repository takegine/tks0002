

LinkLuaModifier("skill_hero_guicai_arua",'skill/hero_guicai.lua',0)
LinkLuaModifier("modifier_guicai_armor",'skill/hero_guicai.lua',0)

skill_hero_guicai=class({})

function skill_hero_guicai:needwaveup()
    local  caster=self:GetCaster()
    caster:AddNewModifier(caster, self, "skill_hero_guicai_arua", {})
end

skill_hero_guicai_arua=class({})

function skill_hero_guicai_arua:IsAura()
    return true
end 

function skill_hero_guicai_arua:IsAuraActiveOnDeath()
    return false 
end 

function skill_hero_guicai_arua:IsDebuff()
    return false
end

function skill_hero_guicai_arua:GetAuraRadius()
    return 1200
end

function skill_hero_guicai_arua:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_FRIENDLY 
end

function skill_hero_guicai_arua:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end 

function skill_hero_guicai_arua:GetModifierAura()
    return 'modifier_guicai_armor'
end

function skill_hero_guicai_arua:IsHidden()
    return true
end

modifier_guicai_armor=class({})

function modifier_guicai_armor:DeclareFunctions()
    return{
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
    }
end

function modifier_guicai_armor:GetModifierPhysicalArmorBonus()
    return self:GetAbility():GetSpecialValueFor('armor')
end