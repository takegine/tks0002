

LinkLuaModifier('modifier_diaogui_aura', 'skill/hero_diaogui.lua', 0)
LinkLuaModifier('modifier_diaogui', 'skill/hero_diaogui.lua', 0)


skill_hero_diaogui=class({})

function  skill_hero_diaogui:needwaveup()

local  caster=self:GetCaster()
local  owner =caster:XinShi()

if not  IsServer() then  return end
if  owner.ship['guishen'] then

caster:AddNewModifier(caster, self, 'modifier_diaogui_aura', {duration=60})
end

end

modifier_diaogui_aura=class({})

function modifier_diaogui_aura:IsAura()
    return true
end 

function modifier_diaogui_aura:IsAuraActiveOnDeath()
    return false 
end 

function modifier_diaogui_aura:IsDebuff()
    return true
end

function modifier_diaogui_aura:GetAuraRadius()
    return 1000
end

function modifier_diaogui_aura:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_diaogui_aura:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end 

function modifier_diaogui_aura:GetModifierAura()
    return 'modifier_diaogui'
end

function modifier_diaogui_aura:IsHidden()
    return true
end

modifier_diaogui=class({})
function modifier_diaogui:IsHidden()
    return true
end

function modifier_diaogui:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
    }
end

function modifier_diaogui:GetModifierAttackSpeedBonus_Constant()
    return -30
end