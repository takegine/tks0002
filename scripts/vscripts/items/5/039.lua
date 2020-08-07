item_queue_039 = item_queue_039 or class(item_class)

------------------------------------------------------------------
LinkLuaModifier( "modifier_item_queue_039","items/5/039", LUA_MODIFIER_MOTION_NONE )
modifier_item_queue_039 = modifier_item_queue_039 or {}


function modifier_item_queue_039:IsHidden ()
    return true
end

function modifier_item_queue_039:IsAura()
	return true
end

function modifier_item_queue_039:IsAuraActiveOnDeath()
	return false
end

function modifier_item_queue_039:IsDebuff()
    return false
end

function modifier_item_queue_039:GetAuraRadius()
    return 2000
end

function modifier_item_queue_039:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_item_queue_039:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_item_queue_039:GetModifierAura()
	return "modifier_item_queue_039_debuff"
end

LinkLuaModifier( "modifier_item_queue_039_debuff","items/5/039", LUA_MODIFIER_MOTION_NONE )
modifier_item_queue_039_debuff = modifier_item_queue_039_debuff or {}
-------------------------------------------------------------------------------
function modifier_item_queue_039_debuff:GetTexture ()
    local ability = self:GetAbility()
    return "items/"..ability:GetAbilityTextureName()
end

function modifier_item_queue_039_debuff:DeclareFunctions()
    return  
    {   
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE

    }
end

function modifier_item_queue_039_debuff:GetModifierPhysicalArmorBonus()
    local ability=self:GetAbility()
    local change = ability:GetSpecialValueFor('p1')
    return  -change
end

function modifier_item_queue_039_debuff:GetModifierHPRegenAmplify_Percentage()
    local ability=self:GetAbility()
    local change = ability:GetSpecialValueFor('p2')
    return  -change
end