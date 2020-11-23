
LinkLuaModifier("modifier_songwei_aura",'skill/hero_songwei.lua',0)
LinkLuaModifier("modifier_songwei",'skill/hero_songwei.lua',0)

skill_hero_songwei=class({})

function skill_hero_songwei:needwaveup()

    local caster=self:GetCaster()
    local target_types = self:GetAbilityTargetType()
    local target_flags = self:GetAbilityTargetFlags()
    
    local friend = FindUnitsInRadius(caster:GetTeamNumber(), 
    caster:GetOrigin(), 
    nil, 
    2000,
    DOTA_UNIT_TARGET_TEAM_FRIENDLY, 
    target_types, 
    target_flags, 
    0, 
    true)

    local count = 0
    local namelist = {}
    for k,v in pairs(friend) do
        if v:GetUnitLabel()=="weiguo" 
        and not namelist[v:GetUnitName()] then
            namelist[v:GetUnitName()]=true
            count = count + 1
        end
    end

   local mod= caster:AddNewModifier(caster, self, 'modifier_songwei_aura', {})
   mod:SetStackCount(count)

 end


 modifier_songwei=class({})

 function modifier_songwei:DeclareFunctions()
     return{
         MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
     }
 end
 
 function modifier_songwei:GetModifierMoveSpeedBonus_Percentage()
    local caster=self:GetCaster()
    local ability=self:GetAbility()
    local modifierName = "modifier_songwei_aura"
    local current_stack=caster:GetModifierStackCount(modifierName, caster)
    return -current_stack*3
 end
 

modifier_songwei_aura=class({})

function modifier_songwei_aura:IsAura()
    return true
end 

function modifier_songwei_aura:IsAuraActiveOnDeath()
    return false 
end 

function modifier_songwei_aura:IsDebuff()
    return true
end

function modifier_songwei_aura:GetAuraRadius()
    return 2000
end

function modifier_songwei_aura:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_songwei_aura:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end 

function modifier_songwei_aura:GetModifierAura()
    return 'modifier_songwei'
end

function modifier_songwei_aura:IsHidden()
    return true
end


