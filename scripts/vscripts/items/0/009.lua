item_weapon_009 = item_weapon_009 or class(item_class)
------------------------------------------------------------------
LinkLuaModifier( "modifier_item_weapon_009_owner","items/0/009", 0 )
LinkLuaModifier( "modifier_item_weapon_009_hero","items/0/009", 0 )
LinkLuaModifier( "modifier_item_weapon_009_unit","items/0/009", 0 )
modifier_item_weapon_009_owner = modifier_item_weapon_009_owner or {}--给主公（信使）的效果
modifier_item_weapon_009_hero = modifier_item_weapon_009_hero or {}--给武将的效果
modifier_item_weapon_009_unit = class({modifier_item_weapon_009_hero})--给民兵的效果

function item_weapon_009:GetIntrinsicModifierName()
    return "modifier_item_weapon_009_hero"
end

function modifier_item_weapon_009_hero:DeclareFunctions()    
    return 
    {
    MODIFIER_EVENT_ON_ATTACK_LANDED
}
end 

function modifier_item_weapon_009_hero:OnAttackLanded(keys)
    
    if IsServer() then 
        local owner  = self:GetParent()
        local ability = self:GetAbility()

        local attacker = keys.attacker
        local target   = keys.target

        local lifesteal_pct = ability:GetSpecialValueFor("p1") / 100
        if owner == attacker then
        
            local damage = keys.damage
            owner:Heal( lifesteal_pct * damage, owner)
            
            SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, self:GetParent(), lifesteal_pct * damage, nil)
        end
    end
end

function modifier_item_weapon_009_hero:IsHidden()
    return true
end