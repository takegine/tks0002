item_defend_027 = item_defend_027 or class(item_class)
------------------------------------------------------------------
LinkLuaModifier( "modifier_item_defend_027_owner","items/1/027", 0 )
LinkLuaModifier( "modifier_item_defend_027_hero","items/1/027", 0 )
LinkLuaModifier( "modifier_item_defend_027_unit","items/1/027", 0 )
modifier_item_defend_027_owner = modifier_item_defend_027_owner or {}--给主公（信使）的效果
modifier_item_defend_027_hero = modifier_item_defend_027_hero or {}--给武将的效果
modifier_item_defend_027_unit = modifier_item_defend_027_unit or {}--给民兵的效果


function modifier_item_defend_027_hero:OnCreated()
    if IsServer() then return end

    local parent = self:GetParent()
    local ability= self:GetAbility()
    local percent= ability:GetSpecialValueFor("p1")

    self.modname = "modifier_defend_big"
    self.parent  = parent
    self.tree    = percent
    local hModiferTable = {
        tree     = self.tree,
        duration = TIME_BATTER_MAX
    }
    parent:AddNewModifier( self.parent, ability , self.name, hModiferTable )

end

function modifier_item_defend_027_hero:OnDestroy()
    if IsServer() then return end
    if IsNull(self.parent) then return end
    -- self.parent:RemoveModifierByNameAndCaster( self.name, self.parent )
    local hModiferTable = {
        tree     = -self.tree,
        duration = TIME_BATTER_MAX
    }
    self.parent:AddNewModifier( self.parent, ability , self.name, hModiferTable )
end