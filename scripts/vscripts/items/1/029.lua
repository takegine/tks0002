item_defend_029 = item_defend_029 or class(item_class)
------------------------------------------------------------------
LinkLuaModifier( "modifier_item_defend_029_owner","items/1/029", 0 )
LinkLuaModifier( "modifier_item_defend_029_hero","items/1/029", 0 )
LinkLuaModifier( "modifier_item_defend_029_unit","items/1/029", 0 )
modifier_item_defend_029_owner = modifier_item_defend_029_owner or {}--给主公（信使）的效果
modifier_item_defend_029_hero = modifier_item_defend_029_hero or {}--给武将的效果
modifier_item_defend_029_unit = modifier_item_defend_029_unit or {}--给民兵的效果


function modifier_item_defend_029_hero:DeclareFunctions()
    return{
        MODIFIER_EVENT_ON_ATTACK_START
    }
end

function modifier_item_defend_029_hero:OnAttackStart(keys)
    local parent=self:GetParent()
    if  not IsServer()  then  return end
    if keys.attacker~=parent then  return  end

    if parent:HasModifier('modifier_fankui_jiansu') then
    parent:RemoveModifierByName('modifier_fankui_jiansu')
    end
end
    

function modifier_item_defend_029_unit:DeclareFunctions()
    return{
        MODIFIER_EVENT_ON_ATTACK_START
    }
end

function modifier_item_defend_029_unit:OnAttackStart(keys)
    local parent=self:GetParent()
    if  not IsServer()  then  return end
    if keys.attacker~=parent then  return  end

    if parent:HasModifier('modifier_fankui_jiansu') then
    parent:RemoveModifierByName('modifier_fankui_jiansu')
    end
end
    