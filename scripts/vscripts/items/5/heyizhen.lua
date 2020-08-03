item_queue_heyizhen = item_queue_heyizhen or class(item_class)

------------------------------------------------------------------
LinkLuaModifier( "modifier_item_queue_heyizhen","items/5/heyizhen", LUA_MODIFIER_MOTION_NONE )
modifier_item_queue_heyizhen = modifier_item_queue_heyizhen or {}


function modifier_item_queue_heyizhen:IsHidden ()
    return true
end

function modifier_item_queue_heyizhen:IsAura()
	return true
end

function modifier_item_queue_heyizhen:IsAuraActiveOnDeath()
	return false
end

function modifier_item_queue_heyizhen:IsDebuff()
    return false
end

function modifier_item_queue_heyizhen:GetAuraRadius()
    return 2000
end

function modifier_item_queue_heyizhen:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_item_queue_heyizhen:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_item_queue_heyizhen:GetModifierAura()
	return "modifier_item_queue_heyizhen_debuff"
end

LinkLuaModifier( "modifier_item_queue_heyizhen_debuff","items/5/heyizhen", LUA_MODIFIER_MOTION_NONE )
modifier_item_queue_heyizhen_debuff = modifier_item_queue_heyizhen_debuff or {}
-------------------------------------------------------------------------------
function modifier_item_queue_heyizhen_debuff:GetTexture ()
    return "queue/鹤翼"
end

function modifier_item_queue_heyizhen_debuff:DeclareFunctions()
    return  
    {   
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE

    }
end

function modifier_item_queue_heyizhen_debuff:GetModifierPhysicalArmorBonus()
    local ability=self:GetAbility()
    local change = ability:GetSpecialValueFor('p1')
    return  -change
end

function modifier_item_queue_heyizhen_debuff:GetModifierHPRegenAmplify_Percentage()
    local ability=self:GetAbility()
    local change = ability:GetSpecialValueFor('p2')
    return  -change
end