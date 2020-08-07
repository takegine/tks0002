item_queue_041 = item_queue_041 or class(item_class)

------------------------------------------------------------------
LinkLuaModifier( "modifier_item_queue_041","items/5/041", LUA_MODIFIER_MOTION_NONE )
modifier_item_queue_041 = modifier_item_queue_041 or {}


function modifier_item_queue_041:GetTexture ()
    local ability = self:GetAbility()
    return "items/"..ability:GetAbilityTextureName()
end

function modifier_item_queue_041:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS_UNIQUE_ACTIVE,
        MODIFIER_EVENT_ON_ATTACKED

    }
end

function modifier_item_queue_041:GetModifierPhysicalArmorBonusUniqueActive()
    local ability=self:GetAbility()
    local change = ability:GetSpecialValueFor('p1')
    return  change
end


function modifier_item_queue_041:OnAttacked(params)
    local parent = self:GetParent()
    local target = params.target
	if  target == parent then

        local ability= self:GetAbility()
        local change = ability:GetSpecialValueFor('p2')
        local heal   = Clamp( change, 0, params.damage *0.5)
        local owner  = parent:GetOwner() or {ship={}}

        parent:Heal(heal,parent)
        SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, parent, heal, nil)
    end

end