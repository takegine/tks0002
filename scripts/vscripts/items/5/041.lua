item_queue_041 = item_queue_041 or class(item_class)
modifier_item_queue_041 = modifier_item_queue_041 or {
    GetTexture = function (self) return "items/"..self:GetAbility():GetAbilityTextureName() end,
    DeclareFunctions = function () return { MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS_UNIQUE_ACTIVE, MODIFIER_EVENT_ON_ATTACKED } end,
}
LinkLuaModifier( "modifier_item_queue_041_hero","items/5/041", 0 )
LinkLuaModifier( "modifier_item_queue_041_unit","items/5/041", 0 )
modifier_item_queue_041_hero = modifier_item_queue_041
modifier_item_queue_041_unit = modifier_item_queue_041
------------------------------------------------------------------

function modifier_item_queue_041:GetModifierPhysicalArmorBonusUniqueActive()
    return  self:GetAbilitySpecialValueFor('p1')
end


function modifier_item_queue_041:OnAttacked(params)
    local parent = self:GetParent()
    local target = params.target
	if  target == parent then

        local ability= self:GetAbility()
        local change = ability:GetSpecialValueFor('p2')
        local heal   = Clamp( change, 0, params.damage *0.5)
        local owner  = parent:XinShi()

        parent:Heal(heal,parent)
        SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, parent, heal, nil)
    end
end