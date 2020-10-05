item_queue_038 = item_queue_038 or class(item_class)

------------------------------------------------------------------
LinkLuaModifier( "modifier_item_queue_038_hero","items/5/038", LUA_MODIFIER_MOTION_NONE )
modifier_item_queue_038_hero = modifier_item_queue_038_hero or {}


function modifier_item_queue_038_hero:GetTexture ()
    local ability = self:GetAbility()
    return "items/"..ability:GetAbilityTextureName()
end

function modifier_item_queue_038_hero:DeclareFunctions()
    return  
    {   
        MODIFIER_EVENT_ON_DEATH,
        MODIFIER_PROPERTY_TOOLTIP
    }
end

function modifier_item_queue_038_hero:OnDeath(params)

    local parent = self:GetParent()
    local ability= self:GetAbility()
    local target_team  = ability:GetAbilityTargetTeam()
    local target_flags = ability:GetAbilityTargetFlags()
    local target_types = self:GetAuraSearchType()

    local friend = FindUnitsInRadius(parent:GetTeamNumber(),
                                    parent:GetOrigin(),
                                    nil,
                                    200,
                                    DOTA_UNIT_TARGET_TEAM_FRIENDLY,
                                    target_types,
                                    target_flags,
                                    0,
                                    true)

    for _,unit in pairs(friend) do
        unit:Heal(self:OnTooltip(), parent)
    end
end

function modifier_item_queue_038_hero:OnTooltip()
    local parent = self:GetParent()
    local ability= self:GetAbility()
    local change = ability:GetSpecialValueFor('p2')
    local health = parent:GetMaxHealth()
    return  health *change /100
end

function modifier_item_queue_038_hero:IsAura()
	return true
end

function modifier_item_queue_038_hero:IsAuraActiveOnDeath()
	return false
end

function modifier_item_queue_038_hero:IsDebuff()
    return false
end

function modifier_item_queue_038_hero:GetAuraRadius()
    return 2000
end

function modifier_item_queue_038_hero:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_item_queue_038_hero:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_item_queue_038_hero:GetModifierAura()
	return "modifier_item_queue_038_hero_debuff"
end

LinkLuaModifier( "modifier_item_queue_038_hero_debuff","items/5/038", LUA_MODIFIER_MOTION_NONE )
modifier_item_queue_038_hero_debuff = modifier_item_queue_038_hero_debuff or {}
-------------------------------------------------------------------------------
function modifier_item_queue_038_hero_debuff:GetTexture ()
    local ability = self:GetAbility()
    return "items/"..ability:GetAbilityTextureName()
end

function modifier_item_queue_038_hero_debuff:DeclareFunctions()
    return  
    {   
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
    }
end

function modifier_item_queue_038_hero_debuff:GetModifierMoveSpeedBonus_Percentage()
    local ability=self:GetAbility()
    local change = ability:GetSpecialValueFor('p1')
    return  -change
end