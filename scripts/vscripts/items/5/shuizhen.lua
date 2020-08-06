item_queue_shuizhen = item_queue_shuizhen or class(item_class)

------------------------------------------------------------------
LinkLuaModifier( "modifier_item_queue_shuizhen","items/5/shuizhen", LUA_MODIFIER_MOTION_NONE )
modifier_item_queue_shuizhen = modifier_item_queue_shuizhen or {}


function modifier_item_queue_shuizhen:GetTexture ()
    return "queue/水阵"
end

function modifier_item_queue_shuizhen:DeclareFunctions()
    return  
    {   
        MODIFIER_EVENT_ON_DEATH,
        MODIFIER_PROPERTY_TOOLTIP
    }
end

function modifier_item_queue_shuizhen:OnDeath(params)

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

function modifier_item_queue_shuizhen:OnTooltip()
    local parent = self:GetParent()
    local ability= self:GetAbility()
    local change = ability:GetSpecialValueFor('p2')
    local health = parent:GetMaxHealth()
    return  health *change /100
end

function modifier_item_queue_shuizhen:IsAura()
	return true
end

function modifier_item_queue_shuizhen:IsAuraActiveOnDeath()
	return false
end

function modifier_item_queue_shuizhen:IsDebuff()
    return false
end

function modifier_item_queue_shuizhen:GetAuraRadius()
    return 2000
end

function modifier_item_queue_shuizhen:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_item_queue_shuizhen:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_item_queue_shuizhen:GetModifierAura()
	return "modifier_item_queue_shuizhen_debuff"
end

LinkLuaModifier( "modifier_item_queue_shuizhen_debuff","items/5/shuizhen", LUA_MODIFIER_MOTION_NONE )
modifier_item_queue_shuizhen_debuff = modifier_item_queue_shuizhen_debuff or {}
-------------------------------------------------------------------------------
function modifier_item_queue_shuizhen_debuff:GetTexture ()
    return "queue/水阵"
end

function modifier_item_queue_shuizhen_debuff:DeclareFunctions()
    return  
    {   
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
    }
end

function modifier_item_queue_shuizhen_debuff:GetModifierMoveSpeedBonus_Percentage()
    local ability=self:GetAbility()
    local change = ability:GetSpecialValueFor('p1')
    return  -change
end