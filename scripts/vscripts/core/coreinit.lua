

item_class = {}

function item_class:lvlup()
    -- print( self:GetName())
    -- local parent = self:GetParent()
    local level  = Clamp(1 + self:GetCurrentCharges(), 0 ,10)
    -- print("lvlup", self:GetLevel())
    self:SetLevel( level )

end

function item_class:OnUpgrade()
    -- local parent = self:GetParent()
    local level  = self:GetLevel()
    
    self:SetCurrentCharges(level)

    -- print("OnUpgrade", self:GetLevel())
    -- if  string.find(self:GetAbilityName(), 'queue' ) then
    --         parent.lvl_queue = level
    -- end
end

function item_class:OnEquip()
    
    local parent = self:GetParent()
    local level  = self:GetLevel()
    
    print("OnEquip", self:GetLevel())
end


function item_class:GetBehavior()
    return DOTA_ABILITY_BEHAVIOR_PASSIVE
end


function item_class:GetIntrinsicModifierName()
	return "modifier_"..self:GetName()
end