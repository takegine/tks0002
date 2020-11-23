

LinkLuaModifier("modifier_fankui_jiansu",'skill/hero_fankui.lua',0)
LinkLuaModifier("modifier_fankui_buff",'skill/hero_fankui.lua',0)
LinkLuaModifier("modifier_fankui_aura",'skill/hero_fankui.lua',0)

skill_hero_fankui=class({})

function skill_hero_fankui:needwaveup()  
    local caster=self:GetCaster()
    caster:AddNewModifier(caster, self, "modifier_fankui_aura", {})
end


modifier_fankui_buff=class({})

function modifier_fankui_buff:DeclareFunctions()
    return{
        MODIFIER_EVENT_ON_ATTACK  
    }
end

function modifier_fankui_buff:OnAttack(keys)
    local ability=self:GetAbility()
    local parent=self:GetParent()
    local target=keys.attacker
    local caster=self:GetCaster()
    local owner =caster:XinShi()
    local  chance=ability:GetSpecialValueFor('percent')
 
    if keys.target~=parent then return end
    if RollPercentage(chance)  then
    local mod= target:AddNewModifier(caster, ability, "modifier_fankui_jiansu", {duration=3})   
    mod:SetStackCount(owner.ship['liaodi'] and -2 or -1)
end
end


modifier_fankui_jiansu=class({})
function modifier_fankui_jiansu:IsHidden()
    return true
end

function modifier_fankui_jiansu:DeclareFunctions()
    return{
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
    }
end

function modifier_fankui_jiansu:GetModifierAttackSpeedBonus_Constant()
    local  speed = { -25, -35 }
    return speed[-self:GetStackCount()]
end

function modifier_fankui_jiansu:GetModifierDamageOutgoing_Percentage()
    local attack={0,-15}  
    return attack[-self:GetStackCount()]
end

function modifier_fankui_jiansu:GetModifierMoveSpeedBonus_Percentage()
    local movespeed={-25,-35}
    return movespeed[-self:GetStackCount()]
end

modifier_fankui_aura=class({})

function modifier_fankui_aura:IsAura()
    return true
end 

function modifier_fankui_aura:IsAuraActiveOnDeath()
    return false 
end 

function modifier_fankui_aura:IsDebuff()
    return false
end

function modifier_fankui_aura:GetAuraRadius()
    return 900
end

function modifier_fankui_aura:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_FRIENDLY 
end

function modifier_fankui_aura:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end 

function modifier_fankui_aura:GetModifierAura()
    return 'modifier_fankui_buff'
end

function modifier_fankui_aura:IsHidden()
    return true
end