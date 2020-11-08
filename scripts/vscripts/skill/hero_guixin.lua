


LinkLuaModifier('skill_guixin_huanxiang', 'skill/hero_guixin.lua', 0)
LinkLuaModifier('skill_guixin_huanxiang_buff', 'skill/hero_guixin.lua', 0)
LinkLuaModifier('modifier_aura_guixin_huanxiang', 'skill/hero_guixin.lua', 0)

skill_hero_guixin=class({})

function skill_hero_guixin:needwaveup()

local caster=self:GetCaster()

caster:AddNewModifier(caster, self, "modifier_aura_guixin_huanxiang", {})  

end

modifier_aura_guixin_huanxiang=class({})  

function modifier_aura_guixin_huanxiang:IsAura()
    return true
end 

function modifier_aura_guixin_huanxiang:IsAuraActiveOnDeath()
    return false 
end 

function modifier_aura_guixin_huanxiang:IsDebuff()
    return true
end

function modifier_aura_guixin_huanxiang:GetAuraRadius()
    return 2000
end

function modifier_aura_guixin_huanxiang:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_aura_guixin_huanxiang:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end 

function modifier_aura_guixin_huanxiang:GetModifierAura()
    return 'skill_guixin_huanxiang'
end

function modifier_aura_guixin_huanxiang:IsHidden()
    return true
end
 

skill_guixin_huanxiang=class({})

function skill_guixin_huanxiang:IsHidden()
    return true
end

function skill_guixin_huanxiang:DeclareFunctions()
return{
    MODIFIER_EVENT_ON_DEATH
}
end

function skill_guixin_huanxiang:OnDeath(keys)

if  not  IsServer() then  return  end
local caster=self:GetCaster()
local parent=self:GetParent()
local ability=self:GetAbility()
local duration=ability:GetSpecialValueFor('duration')
if keys.unit ~= parent then  return  end
local illusions = CreateIllusions(caster, parent, {duration=duration ,100 ,0 }, 1, 50, true, true )
illusions[1]:SetOwner(caster)
illusions[1]:AddNewModifier(caster, ability, "skill_guixin_huanxiang_buff", {}) 

end

skill_guixin_huanxiang_buff=class({})

function skill_guixin_huanxiang_buff:IsHidden()
    return true
end

function skill_guixin_huanxiang_buff:DeclareFunctions()
    return{
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
    }
end 

function skill_guixin_huanxiang_buff:GetModifierAttackSpeedBonus_Constant()
    return self:GetAbility():GetSpecialValueFor('attackspeed')
end

function skill_guixin_huanxiang_buff:CheckState()
    local state = {
    [MODIFIER_STATE_NO_HEALTH_BAR]=true,
    [MODIFIER_STATE_NO_UNIT_COLLISION]=true,
    [MODIFIER_STATE_INVULNERABLE]=true 
}      return state
end
