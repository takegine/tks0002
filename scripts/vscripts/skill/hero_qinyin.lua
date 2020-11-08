

LinkLuaModifier('modifier_qinyin_aura', 'skill/hero_qinyin.lua', 0)
LinkLuaModifier('modifier_qinyin', 'skill/hero_qinyin.lua', 0)

skill_hero_qinyin=class({})

function skill_hero_qinyin:needwaveup()

    local caster=self:GetCaster()

    caster:AddNewModifier(caster, self, "modifier_qinyin_aura", {})  

end

modifier_qinyin_aura=class({})

function modifier_qinyin_aura:IsAura()
    return true
end 

function modifier_qinyin_aura:IsAuraActiveOnDeath()
    return false 
end 

function modifier_qinyin_aura:IsDebuff()
    return true
end

function modifier_qinyin_aura:GetAuraRadius()
    return self:GetAbility():GetSpecialValueFor('radius')
end

function modifier_qinyin_aura:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_qinyin_aura:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end 

function modifier_qinyin_aura:GetModifierAura()
    return 'modifier_qinyin'
end

function modifier_qinyin_aura:IsHidden()
    return false
end
 
modifier_qinyin=class({})

function modifier_qinyin:IsHidden()
    return false
end

function modifier_qinyin:DeclareFunctions()
    return{
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
    }
end

function modifier_qinyin:GetModifierMoveSpeedBonus_Percentage()
    return  -self:GetAbility():GetSpecialValueFor('movespeed')
end

function modifier_qinyin:OnCreated()
    if not IsServer() then
        return
    end
    self:StartIntervalThink(1)
end


function modifier_qinyin:OnIntervalThink()
    local parent = self:GetParent()
    local percent = parent:GetMaxHealth()/100*2
    local curheal = parent:GetHealth()

    if parent:GetHealthPercent()>33  then parent:SetHealth(curheal-percent)
    else if  parent:GetHealthPercent()<=33 and curheal>percent*2 then  parent:SetHealth(curheal-percent*2)
    else if  curheal<=percent*2  then parent:SetHealth(1)
    end 
end
end

end