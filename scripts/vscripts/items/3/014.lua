item_horses_014 = item_horses_014 or class(item_class)
------------------------------------------------------------------
LinkLuaModifier( "modifier_item_horses_014_owner","items/3/014", 0 )
LinkLuaModifier( "modifier_item_horses_014_hero","items/3/014", 0 )
LinkLuaModifier( "modifier_item_horses_014_unit","items/3/014", 0 )
LinkLuaModifier( "modifier_dilu_attackspeed","items/3/014", 0 )
modifier_item_horses_014_owner = modifier_item_horses_014_owner or {}--给主公（信使）的效果
modifier_item_horses_014_hero = modifier_item_horses_014_hero or {}--给武将的效果
modifier_item_horses_014_unit = modifier_item_horses_014_unit or {}--给民兵的效果

function modifier_item_horses_014_hero:GetTexture()
    local ability = self:GetAbility()
    return "items/"..ability:GetAbilityTextureName()
end

function modifier_item_horses_014_hero:IsAura()
    return true
end 

function modifier_item_horses_014_hero:IsAuraActiveOnDeath()
    return false 
end 

function modifier_item_horses_014_hero:IsDebuff()
    return false
end

function modifier_item_horses_014_hero:GetAuraRadius()
    return self:GetAbility():GetSpecialValueFor("p1")
end

function modifier_item_horses_014_hero:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_item_horses_014_hero:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end 

function modifier_item_horses_014_hero:GetModifierAura()
    return 'modifier_dilu_attackspeed'
end

function modifier_item_horses_014_hero:IsHidden()
    return false
end 

modifier_dilu_attackspeed=class({})

function modifier_dilu_attackspeed:GetTexture()
    local ability = self:GetAbility()
    return "items/"..ability:GetAbilityTextureName()  
end

function modifier_dilu_attackspeed:IsDebuff()
    return true
end

function modifier_dilu_attackspeed:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
    }
end

function modifier_dilu_attackspeed:GetModifierAttackSpeedBonus_Constant()
    return -self:GetAbility():GetSpecialValueFor("p2")
end

function modifier_dilu_attackspeed:GetModifierMoveSpeedBonus_Percentage()
    return -self:GetAbility():GetSpecialValueFor("p2")
end

