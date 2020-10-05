item_queue_038 = item_queue_038 or class(item_class)
modifier_item_queue_038 = modifier_item_queue_038 or {
    IsAura = on,
    IsAuraActiveOnDeath = off,
    IsDebuff = off,
    GetTexture = function (self) return "items/"..self:GetAbility():GetAbilityTextureName() end,
    DeclareFunctions = function () return  { MODIFIER_EVENT_ON_DEATH, MODIFIER_PROPERTY_TOOLTIP } end,
    GetAuraRadius = function () return 2000 end,
    GetAuraSearchTeam = function ()	return DOTA_UNIT_TARGET_TEAM_ENEMY end,
    GetAuraSearchType = function ()	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end,
    GetModifierAura = function () return "modifier_item_queue_038_debuff" end,
}
LinkLuaModifier( "modifier_item_queue_038_hero","items/5/038", 0 )
LinkLuaModifier( "modifier_item_queue_038_unit","items/5/038", 0 )
modifier_item_queue_038_hero = modifier_item_queue_038
modifier_item_queue_038_unit = modifier_item_queue_038
------------------------------------------------------------------

function modifier_item_queue_038:OnDeath(params)

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

function modifier_item_queue_038:OnTooltip()
    local parent = self:GetParent()
    local ability= self:GetAbility()
    local change = ability:GetSpecialValueFor('p2')
    local health = parent:GetMaxHealth()
    return  health *change /100
end


LinkLuaModifier( "modifier_item_queue_038_debuff","items/5/038", LUA_MODIFIER_MOTION_NONE )
modifier_item_queue_038_debuff = modifier_item_queue_038_debuff or {
    GetTexture = function (self) return "items/"..self:GetAbility():GetAbilityTextureName() end,
    DeclareFunctions = function () return { MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE } end,
}
-------------------------------------------------------------------------------

function modifier_item_queue_038_debuff:GetModifierMoveSpeedBonus_Percentage()
    local ability=self:GetAbility()
    local change = ability:GetSpecialValueFor('p1')
    return  -change
end