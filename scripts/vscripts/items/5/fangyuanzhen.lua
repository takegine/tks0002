item_queue_fangyuanzhen = item_queue_fangyuanzhen or class(item_class)

------------------------------------------------------------------
LinkLuaModifier( "modifier_item_queue_fangyuanzhen","items/5/fangyuanzhen", LUA_MODIFIER_MOTION_NONE )
modifier_item_queue_fangyuanzhen = modifier_item_queue_fangyuanzhen or {}

function modifier_item_queue_fangyuanzhen:GetTexture ()
    return "queue/方圆"
end

function modifier_item_queue_fangyuanzhen:DeclareFunctions()
    return  
    {   
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT 
    }
end

function modifier_item_queue_fangyuanzhen:GetModifierConstantManaRegen()
    local ability=self:GetAbility()
    local change = ability:GetSpecialValueFor('p2')
    return  change
end

function modifier_item_queue_fangyuanzhen:IsAura()
	return true
end

function modifier_item_queue_fangyuanzhen:IsAuraActiveOnDeath()
	return false
end

function modifier_item_queue_fangyuanzhen:IsDebuff()
    return false
end

function modifier_item_queue_fangyuanzhen:GetAuraRadius()
    return 2000
end

function modifier_item_queue_fangyuanzhen:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_item_queue_fangyuanzhen:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_item_queue_fangyuanzhen:GetModifierAura()
	return "modifier_item_queue_fangyuanzhen_debuff"
end

LinkLuaModifier( "modifier_item_queue_fangyuanzhen_debuff","items/5/fangyuanzhen", LUA_MODIFIER_MOTION_NONE )
modifier_item_queue_fangyuanzhen_debuff = modifier_item_queue_fangyuanzhen_debuff or {}
-------------------------------------------------------------------------------
function modifier_item_queue_fangyuanzhen_debuff:GetTexture ()
    return "queue/方圆"
end

function modifier_item_queue_fangyuanzhen_debuff:DeclareFunctions()
    return  
    {   
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
    }
end

function modifier_item_queue_fangyuanzhen_debuff:GetModifierAttackSpeedBonus_Constant()
    local ability=self:GetAbility()
    local change = ability:GetSpecialValueFor('p1')
    return  -change
end