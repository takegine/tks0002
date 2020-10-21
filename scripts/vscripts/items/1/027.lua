item_defend_027 = item_defend_027 or class(item_class)
------------------------------------------------------------------
LinkLuaModifier( "modifier_item_defend_027_owner","items/1/027", 0 )
LinkLuaModifier( "modifier_item_defend_027_hero","items/1/027", 0 )
LinkLuaModifier( "modifier_defend_big","items/1/027", 0 )
LinkLuaModifier( "modifier_item_defend_027_unit","items/1/027", 0 )
modifier_item_defend_027_owner = modifier_item_defend_027_owner or {}--给主公（信使）的效果
modifier_item_defend_027_hero = modifier_item_defend_027_hero or {}--给武将的效果
modifier_item_defend_027_unit = modifier_item_defend_027_unit or {}--给民兵的效果


function modifier_item_defend_027_hero:DeclareFunctions()
    return{
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }
end

function modifier_item_defend_027_hero:OnAttackLanded(keys)

    local parent=self:GetParent()
    local ability=self:GetAbility()
    local percent=ability:GetSpecialValueFor("p1")
    if not IsServer() then return  end
    if keys.target~=parent then return end

    local hModiferTable = {
        tree     = 50,
        duration = 7
    }
    parent:AddNewModifier( parent, ability , "modifier_defend_big", hModiferTable )

end





--[[ 
举例一个持续7秒的减免`火`系伤害`40%` 和 `地`系伤害`10%` 的写法。
```lua
    local hModiferTable = {
        fire     = 40,
        land     = 10，
        duration = 7
    }
    hCaster:AddNewModifier( hCaster, hAbility , "modifier_defend_big", hModiferTable ) ]]