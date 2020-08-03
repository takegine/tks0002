item_queue_yanxingzhen = item_queue_yanxingzhen or class(item_class)

------------------------------------------------------------------
LinkLuaModifier( "modifier_item_queue_yanxingzhen","items/5/yanxingzhen", LUA_MODIFIER_MOTION_NONE )
modifier_item_queue_yanxingzhen = modifier_item_queue_yanxingzhen or {}


function modifier_item_queue_yanxingzhen:GetTexture ()
    return "queue/雁行"
end

function modifier_item_queue_yanxingzhen:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS_UNIQUE_ACTIVE,
        MODIFIER_EVENT_ON_ATTACKED

    }
end

function modifier_item_queue_yanxingzhen:GetModifierPhysicalArmorBonusUniqueActive()
    local ability=self:GetAbility()
    local change = ability:GetSpecialValueFor('p1')
    return  change
end


function modifier_item_queue_yanxingzhen:OnAttacked(params)
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