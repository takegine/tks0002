item_queue_044 = item_queue_044 or class(item_class)

------------------------------------------------------------------
LinkLuaModifier( "modifier_item_queue_044_hero","items/5/044", LUA_MODIFIER_MOTION_NONE )
modifier_item_queue_044_hero = modifier_item_queue_044_hero or {}

function modifier_item_queue_044_hero:GetTexture ()
    local ability = self:GetAbility()
    return "items/"..ability:GetAbilityTextureName()
end

function modifier_item_queue_044_hero:DeclareFunctions()
    return  
    {   
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT 
    }
end

function modifier_item_queue_044_hero:GetModifierConstantManaRegen()
    local ability=self:GetAbility()
    local change = ability:GetSpecialValueFor('p2')
    return  change
end

function modifier_item_queue_044_hero:IsAura()
	return true
end

function modifier_item_queue_044_hero:IsAuraActiveOnDeath()
	return false
end

function modifier_item_queue_044_hero:IsDebuff()
    return false
end

function modifier_item_queue_044_hero:GetAuraRadius()
    return 2000
end

function modifier_item_queue_044_hero:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_item_queue_044_hero:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_item_queue_044_hero:GetModifierAura()
	return "modifier_item_queue_044_hero_debuff"
end

LinkLuaModifier( "modifier_item_queue_044_hero_debuff","items/5/044", LUA_MODIFIER_MOTION_NONE )
modifier_item_queue_044_hero_debuff = modifier_item_queue_044_hero_debuff or {}
-------------------------------------------------------------------------------
function modifier_item_queue_044_hero_debuff:GetTexture ()
    local ability = self:GetAbility()
    return "items/"..ability:GetAbilityTextureName()
end

function modifier_item_queue_044_hero_debuff:DeclareFunctions()
    return  
    {   
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
    }
end

function modifier_item_queue_044_hero_debuff:GetModifierAttackSpeedBonus_Constant()
    local ability=self:GetAbility()
    local change = ability:GetSpecialValueFor('p1')
    return  -change
end