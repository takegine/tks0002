item_horses_013 = item_horses_013 or class(item_class)
------------------------------------------------------------------
LinkLuaModifier( "modifier_item_horses_013_owner","items/3/013", 0 )
LinkLuaModifier( "modifier_attackspeed","items/3/013", 0 )
LinkLuaModifier( "modifier_item_horses_013_hero","items/3/013", 0 )
LinkLuaModifier( "modifier_item_horses_013_unit","items/3/013", 0 )
modifier_item_horses_013_owner = modifier_item_horses_013_owner or {}--给主公（信使）的效果
modifier_item_horses_013_hero = modifier_item_horses_013_hero or {}--给武将的效果
modifier_item_horses_013_unit = modifier_item_horses_013_unit or {}--给民兵的效果


function modifier_item_horses_013_hero:IsAura()
    return true
end 

function modifier_item_horses_013_hero:IsAuraActiveOnDeath()
    return false 
end 

function modifier_item_horses_013_hero:IsDebuff()
    return true
end

function modifier_item_horses_013_hero:GetAuraRadius()
    return self:GetAbility():GetSpecialValueFor("p1")
end

function modifier_item_horses_013_hero:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_item_horses_013_hero:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end 

function modifier_item_horses_013_hero:GetModifierAura()
    return 'modifier_attackspeed'
end

function modifier_item_horses_013_hero:IsHidden()
    return false
end

function modifier_item_horses_013_hero:GetTexture()
    local ability = self:GetAbility()
    return "items/"..ability:GetAbilityTextureName()
end  

modifier_attackspeed=class({})

function modifier_attackspeed:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
    }
end

function modifier_attackspeed:GetModifierAttackSpeedBonus_Constant()
    return   -self:GetAbility():GetSpecialValueFor("p2")
end

