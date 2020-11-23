
LinkLuaModifier("modifier_fangzhu_aura",'skill/hero_fangzhu.lua',0)
LinkLuaModifier("modifier_fangzhu_buff",'skill/hero_fangzhu.lua',0)

skill_hero_fangzhu=class({})

function skill_hero_fangzhu:needwaveup()  
   local caster=self:GetCaster()
   caster:AddNewModifier(caster, self, "modifier_fangzhu_aura", {})
end

modifier_fangzhu_aura=class({})


function modifier_fangzhu_aura:IsAura()
    return true
end 

function modifier_fangzhu_aura:IsAuraActiveOnDeath()
    return false 
end 

function modifier_fangzhu_aura:IsDebuff()
    return false
end

function modifier_fangzhu_aura:GetAuraRadius()
    local caster=self:GetCaster()
    return 300+caster:GetLevel()*30
end

function modifier_fangzhu_aura:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_fangzhu_aura:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end 

function modifier_fangzhu_aura:GetModifierAura()
    return 'modifier_fangzhu_buff'
end

function modifier_fangzhu_aura:IsHidden()
    return false
end

modifier_fangzhu_buff=class({})

function modifier_fangzhu_buff:IsHidden()
    return true
end 

function modifier_fangzhu_buff:DeclareFunctions()
    return{
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT
    }
end

function modifier_fangzhu_buff:GetModifierConstantManaRegen()
    local caster=self:GetCaster()
    return -caster:GetLevel()
end